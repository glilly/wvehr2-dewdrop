BPSOSQ2 ;BHAM ISC/FCS/DRS/DLF - form transmission packets ;06/01/2004
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ; Construct packets for transmission
 Q
 ;
PACKETS ; EP - Tasked by BPSOSQA
 ;
 ; Initialize
 N ERROR,RXILIST,STATUS
 ;
 ; First handle insurer alseep transactions
 D STATUS31^BPSOSQF
 ;
 ; Handle claims that need the packet to be built
 I $D(^BPST("AD",30)) D STATUS30
 ;
 ; If there are still any claims with status 30 (perhaps due to failed
 ;   LOCK59), queue up BPSOSQ2 to run again
 I $O(^BPST("AD",30,0)) H 60 D TASK^BPSOSQA
 Q
 ;
 ; Walk through claims at 30%, bundle, and create the claim
STATUS30 ;
 N IEN59
 S IEN59=""
 I '$$LOCK59(30) Q
 ;
 ; Loop though claims at 30%, bundle with other 30% claims, and process
 F  S IEN59=$$NEXT59(IEN59,30) Q:IEN59=""  D
 . ; Intialize the list
 . K RXILIST
 . S RXILIST(IEN59)=""
 . ;
 . ; Update the status to 40 (Building the packet)
 . D SETSTAT^BPSOSU(IEN59,40)
 . ;
 . ; If reversal, only one claim per packet
 . I $G(^BPST(IEN59,4)) G POINTX
 . ;
 . ; If prior auth are entered, only one claim per packet
 . G:$$CHKPA() POINTX
 . ;
 . ; Code below is for bundling claims.  The VA is not doing this
 . ; so we are skipping it.  However, the code is left here in
 . ; case we do bundling in the future.  If so, the code will need to be
 . ; rewritten to look at the corect fields.
 . G POINTX
 . ;
 . N RA0,RA1 S RA0=^BPST(IEN59,0),RA1=^(1)
 . N IEN59 S IEN59="" ; preserve the top-level index!
 . F  S IEN59=$$NEXT59(IEN59,30) Q:'IEN59  D
 .. N RB0,RB1 S RB0=^BPST(IEN59,0),RB1=^(1)
 .. ; Only bundle when you have the same:
 .. ; Patient, Visit, Division, Division Source, Insurer, Pharmacy
 .. I $P(RA0,U,6,7)'=$P(RB0,U,6,7) Q
 .. I $P(RA1,U,4,7)'=$P(RB1,U,4,7) Q
 .. I $P(RB0,U,2)'=30 Q  ; might have been canceled, or maybe 31'd
 .. D SETSTAT^BPSOSU(IEN59,40)
 .. S RXILIST(IEN59)=""
POINTX . ; Reversals and prior auth claims branch to here to bypass multi-claim packeting
 . ;
 . ; BPSOSQG will build the claim data, create the packet, and send to HL7
 . S ERROR=$$PACKET^BPSOSQG
 . ;
 . ; If an error is returned, log the error to each transaction
 . I ERROR S IEN59="" F  S IEN59=$O(RXILIST(IEN59)) Q:IEN59=""  D
 .. D ERROR^BPSOSU($T(+0),IEN59,$P(ERROR,U),$P(ERROR,U,2,$L(ERROR,U)))
 D UNLOCK59(30)
 Q
 ;
NEXT59(IEN59,STATUS) ;EP - BPSOSQF
 N INS,PAYSH,PAYSHNM,RETRY
N59A ;
 ; Get next transaction for the given status
 S IEN59=$O(^BPST("AD",STATUS,IEN59))
 I IEN59="" Q IEN59  ; end of list, return ""
 ;
 ; but if the insurer is asleep, don't take this one
 S INS=$P(^BPST(IEN59,9),U,1)
 ;
 ; Not sure when this would happen, but do not want to take it out
 I INS="" S INS=1,$P(^BPST(IEN59,9),U,1)=INS  ;LJE;8/25/03  ;current insurance
 ;
 ; Get the payer sheet, name, and retry time
 S PAYSH=$$PAYERSH^BPSOSQF(IEN59)
 S PAYSHNM=$$GET1^DIQ(9002313.92,PAYSH_",",.01,"E")
 S RETRY=$$GET1^DIQ(9002313.92,PAYSH_",",1.12,"I")    ;RETRY TIME
 ;
 ; If no retry time, insurer is not asleep and we can return the transaction
 I 'RETRY Q IEN59
 ;
 ; Insurer is asleep -
 ; If necessary, update the .59's record of when to retry
 I $P($G(^BPST(IEN59,8)),U)'=RETRY D  ;
 . S $P(^BPST(IEN59,8),U)=RETRY ; stamp with latest retry time
 . D SETSTAT^BPSOSU(IEN59,31) ; force screen update, too
 . D LOG^BPSOSL(IEN59,$T(+0)_"-Insurer still asleep - retry at "_RETRY_" for "_$G(PAYSHNM))
 ;
 ; If time to retry, return this transaction for processing
 I RETRY'>$$NOW Q IEN59
 ;
 ; If we are checking status 30, convert to insurer asleep
 I STATUS=30 D
 . D SETSTAT^BPSOSU(IEN59,31)
 . S $P(^BPST(IEN59,8),U)=$P($G(^BPSF(9002313.92,PAYSH,1)),"^",12)
 . S $P(^BPST(IEN59,8),U,3)=PAYSH
 ;
 ; Still asleep, go to next transaction
 G N59A
 ;
 ;
LOCK59(STATUS) ;EP - BPSOSQF
 L +^BPST("AD",STATUS):60
 Q $T
 ;
UNLOCK59(STATUS) ;EP - BPSOSQF
 L -^BPST("AD",STATUS)
 Q
 ;
CHKPA() ;
 N PATYP,PANUM,PACLM
 S PACLM=0
 ;
 S PATYP=$P($G(^BPST(IEN59,1)),U,15)    ;prior auth type code
 S PANUM=$P($G(^BPST(IEN59,1)),U,9)     ;prior auth number
 I ($G(PATYP)'="")!($G(PANUM)'="") S PACLM=1
 ;
 Q PACLM
 ;
NOW() N %,%H,%I,X D NOW^%DTC Q %
