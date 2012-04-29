BPSOSRB ;BHAM ISC/FCS/DRS/FLS - Process claim on processing queue ;06/01/2004
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 Q
BACKGR ;
 I '$$LOCKNOW^BPSOSRX("BACKGROUND") Q
 N TYPE,RXI,RXR,IEN59
 I '$$LOCK^BPSOSRX("BACKGROUND",300) G FAIL
 F TYPE="CLAIM","UNCLAIM" D
 . S RXI="" F  S RXI=$O(^XTMP("BPS-PROC",TYPE,RXI)) Q:RXI=""  D
 .. S RXR="" F  S RXR=$O(^XTMP("BPS-PROC",TYPE,RXI,RXR)) Q:RXR=""  D
 ... N X S X=$$STATUS^BPSOSRX(RXI,RXR,0)
 ... S IEN59=$$IEN59^BPSOSRX(RXI,RXR)
 ... D LOG^BPSOSL(IEN59,$T(+0)_"-Dequeuing.  Type is "_TYPE)
 ... I $P(X,U)="IN PROGRESS" D  Q
 .... D LOG^BPSOSL(IEN59,$T(+0)_"-Status is 'IN PROGRESS'.  Will retry later.")
 ... N TIME,MOREDATA
 ... S TIME=^XTMP("BPS-PROC",TYPE,RXI,RXR) ; time requested
 ... I '$$LOCK^BPSOSRX("SUBMIT",10) D  Q
 .... D LOG^BPSOSL(IEN59,$T(+0)_"-Failed to $$LOCK^BPSOSRX(""SUBMIT"").  Will retry later.")
 ... I $D(^XTMP("BPS-PROC",TYPE,RXI,RXR,"MOREDATA")) M MOREDATA=^("MOREDATA")
 ... E  S MOREDATA=0
 ... K ^XTMP("BPS-PROC",TYPE,RXI,RXR)
 ... D BACKGR1(TYPE,RXI,RXR,TIME,.MOREDATA)
 ... D UNLOCK^BPSOSRX("SUBMIT")
FAIL D UNLOCK^BPSOSRX("BACKGROUND")
 Q
 ;
 ; BACKGR1 - Further processing of the claim
 ; Besides the parameter below, IEN59 also needs to be defined
BACKGR1(TYPE,RXI,RXR,TIME,MOREDATA) ;
 ; Resolve multiple requests
 N SKIP S SKIP=0 ; skip if you already got desired result
 N SKIPREAS
 N RESULT S RESULT=$$STATUS^BPSOSRX(RXI,RXR,0),RESULT=$P(RESULT,U)
 N STARTTIM S STARTTIM=$$STARTTIM(RXI,RXR)
 I TYPE="CLAIM" D
 . I $$RXDEL^BPSOS(RXI,RXR) D  Q
 .. S SKIP=1,SKIPREAS="Prescription is marked as DELETED or CANCELLED"
 . ; If it's never been through ECME before, good.
 . I RESULT="" Q
 . ; There's already a complete transaction for this RXI,RXR
 . ; (We screened out "IN PROGRESS" earlier)
 . ; The program to poll indexes would have set DO NOT RESUBMIT.
 . ; Calls from pharm pkg to ECME have '$D(MOREDATA("DO NOT RESUBMIT"))
 . I $D(MOREDATA("DO NOT RESUBMIT")) D
 .. S SKIP=1
 .. S SKIPREAS="MOREDATA(""DO NOT RESUBMIT"") is set"
 . E  I TIME<STARTTIM D  ; our request was made before trans. began
 .. ; submit claim but only if the prev result was successful reversal
 .. I RESULT="PAPER REVERSAL" Q
 .. I RESULT="E REVERSAL ACCEPTED" Q
 .. S SKIP=1
 .. S SKIPREAS="Prev result "_RESULT_"; claim started "_STARTTIM_">"_TIME_" submitted"
 . E  D  ; our request was made after it began
 .. ; So we will make a reversal if necessary,
 .. ; and then the claim will be resubmitted.
 .. I RESULT="E PAYABLE"!(RESULT="E DUPLICATE"),$G(MOREDATA("REVERSE THEN RESUBMIT"))'=2 D
 ... S MOREDATA("REVERSE THEN RESUBMIT")=1
 E  I TYPE="UNCLAIM" D
 . ; It must have gone through ECME with a payable result
 . I RESULT="E PAYABLE" Q
 . I RESULT="E DUPLICATE" Q
 . N RXACTION S RXACTION=$G(MOREDATA("RX ACTION"))
 . I RESULT="E REVERSAL REJECTED",(",DE,EREV,RS,"[(","_RXACTION_",")) Q
 . I RESULT="E REVERSAL STRANDED",RXACTION="EREV" Q
 . S SKIP=1
 . S SKIPREAS="Cannot reverse - previous result was "_RESULT
 E  D IMPOSS^BPSOSUE("P","TI","bad arg TYPE="_TYPE,,"BACKGR1",$T(+0))
 I SKIP D  Q
 . D LOG^BPSOSL(IEN59,$T(+0)_"-Skipping.  Reason: "_SKIPREAS)
 S MOREDATA("SUBMIT TIME")=TIME
 I TYPE="UNCLAIM"!$G(MOREDATA("REVERSE THEN RESUBMIT")) D REVERSE(IEN59,.MOREDATA)
 I TYPE="CLAIM",'$G(MOREDATA("REVERSE THEN RESUBMIT")) D CLAIM(IEN59,.MOREDATA)
 Q
 ;
 ; STARTTIM - Get START TIME field from BPS Transactions
STARTTIM(RXI,RXR) Q $P($G(^BPST($$IEN59^BPSOSRX(RXI,RXR),0)),U,11)
 ;
 ; Process claim request
 ; EP - Above and BPSOSU (for a resubmit after a reversal)
CLAIM(IEN59,MOREDATA) ;
 D LOG^BPSOSL(IEN59,$T(+0)_"-Initiating Claim")
 D EN^BPSOSIZ(IEN59,.MOREDATA)
 Q
 ;
 ; Process the reversal
REVERSE(IEN59,MOREDATA) ;
 N MSG,RETVAL,REV
 ;
 ; Log Reversal or Reversal/Resubmit message.
 ; Note that the reversal/resubmit message is needed
 ;   for Turn-Around Stats - Do NOT delete/alter!!
 S MSG=$T(+0)_"-Initiating Reversal"
 I $G(MOREDATA("REVERSE THEN RESUBMIT"))=1 D
 . S MSG=MSG_" and after that, claim will be resubmitted"
 . N X,X1,X2
 . S X1=DT,X2=30 D C^%DTC
 . S ^XTMP("BPSOSRB",0)=X_U_DT_U_"PASS VARIABLES FOR RESUBMITS"
 . K ^XTMP("BPSOSRB","MOREDATA",IEN59)
 . M ^XTMP("BPSOSRB","MOREDATA",IEN59,"RESUB")=MOREDATA
 D LOG^BPSOSL(IEN59,MSG)
 ;
 ; Change status to 0% (Waiting to Start), which will reset START TIME,
 ;   and then to 10% (Building transaction)
 D SETSTAT^BPSOSU(IEN59,0)
 D SETSTAT^BPSOSU(IEN59,10)
 ;
 ; Update User (#13), RX Action (#1201), and Reversal Reason (#404)
 ;   in BPS Transactions
 N DIE,DR,DA
 S DIE=9002313.59,DA=IEN59
 S DR="6////"_$G(MOREDATA("SUBMIT TIME"))_";13////"_$G(MOREDATA("USER"))
 S DR=DR_";404////"_$G(MOREDATA("REVERSAL REASON"))_";1201////"_$G(MOREDATA("RX ACTION"))
 ;
 ; Also update RESUBMIT AFTER REVERSAL field (#1.12) if needed
 I $G(MOREDATA("REVERSE THEN RESUBMIT"))=1 S DR=DR_";1.12////1"
 D ^DIE
 ;
 ; Log message for reverse without resubmit
 I $G(MOREDATA("REVERSE THEN RESUBMIT"))=2 D LOG^BPSOSL(IEN59,$P($G(MOREDATA("BILL")),U,2)_"-Claim cannot be resubmitted")
 ;
 ; Store contents of BPST in the Log
 D LOG^BPSOSL(IEN59,$T(+0)_"-Contents of ^BPST("_IEN59_") :")
 D LOG59^BPSOSQA(IEN59) ; Log contents of 9002313.59
 ;
 ; Add semi-colon to result text
 D PREVISLY^BPSOSIZ(IEN59)
 ;
 ; Contruct revesal claim
 ;   If no reversal claim is returned, log error and quit.
 S REV=$$REVERSE^BPSECA8(IEN59)
 I REV=0 D  Q
 . D LOG^BPSOSL(IEN59,$T(+0)_"-Reversal claim not created for "_IEN59)
 . D ERROR^BPSOSU($T(+0),IEN59,100,"Reversal Claim not created")
 ;
 ; Update Reversal Field in the transaction
 S DIE=9002313.59,DA=IEN59,DR="401////"_REV
 D ^DIE
 ;
 ; Update Log
 D LOG^BPSOSL(IEN59,$T(+0)_"-Reversal claim "_$P(^BPSC(REV,0),U)_" ("_REV_")")
 ;
 ; Update status to 30% (Building the claim)
 D SETSTAT^BPSOSU(IEN59,30)
 ;
 ; Fire off task to get this on the HL7 queue
 D TASK^BPSOSQA
 Q
