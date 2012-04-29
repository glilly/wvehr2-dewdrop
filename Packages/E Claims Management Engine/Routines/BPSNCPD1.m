BPSNCPD1        ;BHAM ISC/LJE - Pharmacy API part 2 ;4/16/08  17:07
        ;;1.0;E CLAIMS MGMT ENGINE;**1,3,5,6**;JUN 2004;Build 10
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; External reference to $$NCPDPQTY^PSSBPSUT supported by IA4992
        ;
        ; Due to space considerations, these comments were moved from BPSNPCPD
        ;   to this routine.
        ;
        ; ------------------ Beginning of BPSNCPDP comments ------------------
        ;Input
        ; BRXIEN = Prescription IEN
        ; BFILL = Fill Number
        ; BFILLDAT = Fill Date of current prescription and fill number
        ; BWHERE (RX Action)
        ;    ARES = Resubmit for an auto-reversed claim was released while waiting
        ;           for the payer response
        ;    AREV = Auto-Reversal
        ;    BB   = Back Billing
        ;    CRLB = CMOP Release & Rebill
        ;    CRLR = CMOP Release & Reverse (successful release)
        ;    CRLX = CMOP unsuccessful release & reverse
        ;    DC   = Discontinue - only reverse un-released PAYABLE DC's, release date check
        ;           should be in calling routine.
        ;    DDED = Delete in edit
        ;    DE   = Delete
        ;    ED   = Edit
        ;    ERES = Resubmit from ECME user screen
        ;    EREV = Reversal from ECME user screen
        ;    HLD  = Put prescription on Hold
        ;    OF   = Original Fill
        ;    PC   = Pull CMOPs
        ;    PE   = Pull early from suspense
        ;    PL   = Pull local from suspense
        ;    PP   = PP from Patient Prescription Processing option
        ;    RF   = Refill
        ;    RL   = Release Rx NDC check - Rebill if billed NDC doesn't match release NDC
        ;    RN   = Renew
        ;    RRL  = Original claim rejected, submit another claim, no reversal
        ;    RS   = Return-to-Stock
        ; BILLNDC = Valid NDC# with format 5-4-2
        ; REVREAS = Reversal Reason
        ; DURREC  = String of DUR info - Three "^" pieces
        ;                Professional Service Code
        ;                Reason for Service Code
        ;                Result of Service Code
        ; BPOVRIEN = Pointer to BPS NCPDP OVERIDE file.  This parameter will
        ;            only be passed if there are overrides entered by the
        ;            user via the Resubmit with Edits (RED) option in the
        ;            user screen.
        ; BPSCLARF = Clarification Code (0-9,99), entered by pharmacist and passed
        ;            by Outpatient Pharmacy to ECME to put into the claim
        ;
        ;Output (RESPONSE^MESSAGE)
        ; RESPONSE
        ;    0  Submitted through ECME
        ;    1  No submission through ECME
        ;    2  IB not billable
        ;    3  Claim was closed, not submitted (RTS/Deletes)
        ;    4  Unable to queue claim
        ;    5  Incorrect information supplied to ECME
        ;    6  Inactive ECME - Primarly used for Tricare to say ok to process rx
        ;    10 Reversal but no resubmit
        ; MESSAGE = Message associated with the response (error/submitted)
        ; ----------------- End of BPSNCPDP comments ----------------------
        ;
        ; Procedure STARRAY - Retrieve information for API call to IB and store in BPSARRY
        ; Incoming Parameters
        ;    BRXIEN - Prescription IEN
        ;    BFILL  - Fill Number
        ;    BWHERE - RX action
        ;    BPSARRY  - Array that is built (passed by reference)
        ;    BPSITE - OUTPATIENT SITE file #59 ien
STARRAY(BRXIEN,BFILL,BWHERE,BPSARRY,BPSITE)     ;
        N DRUGIEN,BPARR,BPSARR,QTY
        D RXAPI^BPSUTIL1(BRXIEN,"6;7;8;17;31","BPARR","I")
        I BFILL>0 D RXSUBF^BPSUTIL1(BRXIEN,52,52.1,BFILL,"1;1.1;1.2;17","BPARR","I")
        S BPSARRY("DFN")=DFN
        S BPSARRY("DAYS SUPPLY")=$S(BFILL=0:$G(BPARR(52,BRXIEN,8,"I")),1:$G(BPARR(52.1,BFILL,1.1,"I")))
        S BPSARRY("IEN")=BRXIEN
        S BPSARRY("FILL NUMBER")=BFILL
        S BPSARRY("NDC")=BILLNDC
        S (BPSARRY("DRUG"),DRUGIEN)=BPARR(52,BRXIEN,6,"I")
        S BPSARRY("DEA")=$$DRUGDIE^BPSUTIL1(DRUGIEN,3)
        S BPSARRY("COST")=$S(BFILL=0:$G(BPARR(52,BRXIEN,17,"I")),1:$G(BPARR(52.1,BFILL,1.2,"I")))
        S QTY=$S(BFILL=0:$G(BPARR(52,BRXIEN,7,"I")),1:$G(BPARR(52.1,BFILL,1,"I")))
        S QTY=$$NCPDPQTY^PSSBPSUT(DRUGIEN,QTY)
        S BPSARRY("QTY")=$P(QTY,U,1)
        S BPSARRY("UNITS")=$P(QTY,U,2)
        S BPSARRY("FILL DATE")=BFILLDAT
        S BPSARRY("RELEASE DATE")=$P($S(BFILL=0:$G(BPARR(52,BRXIEN,31,"I")),1:$G(BPARR(52.1,BFILL,17,"I"))),".")
        S BPSARRY("SC/EI OVR")=0
        ;determine BPS PHARMACY
        I $G(BPSITE)>0 S BPSARRY("EPHARM")=$$GETPHARM^BPSUTIL(BPSITE)
        ;
        ; Add user so that it is stored correctly in the IB Event Log
        ;  Note: Auto-Reversals (AREV) and CMOP/OPAI (CR*/PC/RL) use postmaster (.5)
        I ",AREV,CRLB,CRLX,CRLR,PC,RL,"[(","_BWHERE_",") S BPSARRY("USER")=.5
        E  S BPSARRY("USER")=DUZ
        Q
        ;
        ; Called by BPSNCPDP to display progress of claim
STATUS(BRXIEN,BFILL,REBILL,REVONLY,BPSTART,BWHERE)      ;
        ; Initialization
        N TRANSIEN,CERTUSER,BPSTO,END,IBSEQ,BPQ
        N CLMSTAT,OCLMSTAT,RESUB,RESFL
        S (CLMSTAT,OCLMSTAT)=0
        ;
        ; Set CERTUSER to true if this user is the certifier
        S CERTUSER=^BPS(9002313.99,1,"CERTIFIER")=DUZ
        ;
        ; Build Transaction IEN
        S TRANSIEN=BRXIEN_"."_$E($TR($J("",4-$L(BFILL))," ","0")_BFILL,1,4)_1
        ;
        ; Write Rebill and Status Messages
        W !!,"Claim Status: "
        I REBILL,$G(MOREDATA("REVERSE THEN RESUBMIT"))'=2 W !,"Reversing and Rebilling a previously submitted claim...",!,"Reversing..."
        ;
        ; Get the ECME Timeout and set the display timeout
        S BPSTO=$$GET1^DIQ(9002313.99,"1,",3.01),END=$S(CERTUSER:50,$G(BPSTO)]"":BPSTO,1:5)
        ;
        ; For remaining time, loop through and display status
        S (BPQ,RESFL)=0
        F IBSEQ=1:1:END D  Q:BPQ=1
        . H 1
        . ;
        . ; Get status of resubmit, last update, and claim status
        . S CLMSTAT=$$STATUS^BPSOSRX(BRXIEN,BFILL,1)
        . S RESUB=$$GET1^DIQ(9002313.59,TRANSIEN_",",1.12,"I")
        . ;
        . ; Format status message
        . S CLMSTAT=$P(CLMSTAT,"^",1)_$S($P(CLMSTAT,"^",1)["IN PROGRESS":"-"_$P(CLMSTAT,"^",3),1:"")
        . ;
        . ; If we are starting the resubmit, display message
        . I REBILL,RESFL=0,RESUB=1,CLMSTAT["Resubmitting" W !,"Resubmitting..." S RESFL=1 Q
        . I REBILL,RESFL=0,RESUB=2,CLMSTAT["IN PROGRESS" W !,"Resubmitting..." S RESFL=1
        . ;
        . ; If the status has changed, display the new message
        . I OCLMSTAT'=CLMSTAT W !,CLMSTAT S OCLMSTAT=CLMSTAT I CLMSTAT="E REJECTED",MOREDATA("ELIG")'="V" D
        .. N BPSRTEXT,BPSRESP,BPSPOS,X
        .. S BPSRESP=$P($G(^BPST(IEN59,0)),"^",5) Q:'BPSRESP
        .. S BPSPOS=+$O(^BPSR(BPSRESP,1000,":"),-1) Q:'BPSPOS
        .. D REJTEXT^BPSOS03(BPSRESP,BPSPOS,.BPSRTEXT)
        .. S X=0 F  S X=$O(BPSRTEXT(X)) Q:'X  W !?4,$P(BPSRTEXT(X),":")," - ",$P(BPSRTEXT(X),":",2)
        . ;
        . ; If the status is not IN PROGRESS, then we are done
        . I CLMSTAT'["IN PROGRESS" S BPQ=1
        W !
        Q
        ;
        ; Bulletin to the OPECC
        ; BPST=Tricare flag 1 is Tricare Related
BULL(RXI,RXR,SITE,DFN,PATNAME,BPST)     ;
        N BTXT,XMSUB,XMY,XMTEXT,XMDUZ
        N SSN,X,SITENM
        I $G(SITE) D
        . K ^TMP($J,"BPSARR")
        . D PSS^PSO59(SITE,,"BPSARR")
        . S SITENM=$G(^TMP($J,"BPSARR",SITE,.01))
        I $G(DFN) D
        . S X=$P($G(^DPT(DFN,0)),U,9)
        . S SSN=$E(X,$L(X)-3,$L(X))
        ;
        ; Need to do in the background
        ;   Mailman calls CMOP which calls EN^BPSNCPDP.
        ;   If BPSNCPDP* (same process) then calls mailman, it gets confused.
        N ZTIO,ZTRTN,ZTDTH,ZTSAVE,ZTDESC
        N %,%H,%I,X
        D NOW^%DTC
        S ZTIO="",ZTDTH=%,ZTDESC="IN PROGRESS BULLETIN"
        S (ZTSAVE("RXR"),ZTSAVE("RXI"))=""
        S (ZTSAVE("SITENM"),ZTSAVE("PATNAME"),ZTSAVE("SSN"),ZTSAVE("BPST"))=""
        S ZTRTN="BULL1^BPSNCPD1"
        D ^%ZTLOAD
        Q
        ;
BULL1   ;
        N BPSRX,BPSL,XMDUZ,XMY,BPSX,XMZ,XMSUB
        S BPSL=0,BPSRX=$$RXAPI1^BPSUTIL1(RXI,.01,"E")
        S XMSUB=$S($G(BPST):"TRICARE ",1:"")_"RX not processed for site "_$G(SITENM)
        I $G(BPST) D
        . S BPSL=BPSL+1,BPSX(BPSL)="Prescription "_BPSRX_" for fill number "_(+RXR)_" could not be filled because of a"
        . S BPSL=BPSL+1,BPSX(BPSL)="delay in processing the third party claim. The Rx was placed on suspense"
        . S BPSL=BPSL+1,BPSX(BPSL)="because TRICARE Rx's may not be filled unless they have a payable third"
        . S BPSL=BPSL+1,BPSX(BPSL)="party claim."
        . S BPSL=BPSL+1,BPSX(BPSL)=" "
        . S BPSL=BPSL+1,BPSX(BPSL)="Please monitor the progress of the claim.  If the claim is eventually"
        . S BPSL=BPSL+1,BPSX(BPSL)="returned as payable, the Rx label will be printed when Print from Suspense"
        . S BPSL=BPSL+1,BPSX(BPSL)="occurs or it may be Pulled Early from Suspense.  If a reject occurs, the"
        . S BPSL=BPSL+1,BPSX(BPSL)="Rx will be placed in the REFILL TOO SOON/DUR REJECTS (Third Party) section"
        . S BPSL=BPSL+1,BPSX(BPSL)="of the medication profile and placed on the Pharmacy Reject Worklist."
        ;
        E  D
        . S BPSL=BPSL+1,BPSX(BPSL)="Prescription "_BPSRX_" for fill number "_(+RXR)_" could not be processed because the"
        . S BPSL=BPSL+1,BPSX(BPSL)="previous request was in progress.  There may have been a delay in"
        . S BPSL=BPSL+1,BPSX(BPSL)="processing of the previous claim or the previous claim may be stranded."
        ;
        S BPSL=BPSL+1,BPSX(BPSL)=" "
        S BPSL=BPSL+1,BPSX(BPSL)="For more information on this prescription's activity, please view the ECME"
        S BPSL=BPSL+1,BPSX(BPSL)="log within the View Prescription (VP) option on the Further Research (FR)"
        S BPSL=BPSL+1,BPSX(BPSL)="menu of the ECME user screen."
        S BPSL=BPSL+1,BPSX(BPSL)=" "
        S BPSL=BPSL+1,BPSX(BPSL)=$S($G(BPST):"TRICARE ",1:"")_"Patient Name: "_$G(PATNAME)_" ("_$G(SSN)_")"
        S BPSL=BPSL+1,BPSX(BPSL)="Prescription: "_BPSRX_"  Fill: "_(+RXR)
        S BPSL=BPSL+1,BPSX(BPSL)="Drug Name:  "_$$RXAPI1^BPSUTIL1(RXI,6,"E")
        ;
        S XMDUZ="BPS PACKAGE",XMTEXT="BPSX("
        S XMY("G.BPS OPECC")=""
        I $G(DUZ)'<1 S XMY(DUZ)=""
        D ^XMD
        I $G(BPST) D PRIORITY^XMXEDIT(XMZ)
        Q
