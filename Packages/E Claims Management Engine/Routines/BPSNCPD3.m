BPSNCPD3        ;BHAM ISC/LJE - Continuation of BPSNCPDP - DUR HANDLING ;06/16/2004
        ;;1.0;E CLAIMS MGMT ENGINE;**1,5,6,7**;JUN 2004;Build 46
        ;;Per VHA Directive 2004-038, this routine should not be modified.
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
        ; BPSAUTH = pre-authorization code (preauth. code^preauth number)
        ; BPSCLARF = Submission Clarification Code (ien of the #9002313.25), entered by pharmacist and passed
        ;            by Outpatient Pharmacy to ECME to put into the claim  
        ; BPCOBIND = (optional, default is Primary) for COB indicators - so when the API is called for the particular
        ;            COB claim the BPSNCPDP can handle it.
        ; BPJOBFLG = (optional, default is "F") B - if is called by unqueueing logic in background, F - by other (foreground) process, 
        ; BPREQIEN = (optional) ien of BPS REQUEST file record, that needs to be unqueued 
        ; BPSCLOSE = (optional) local array used with BWHERE="EREV" only, if the user had chosen to close the claim after reversal
        ;   if claim needs to be closed then
        ;   BPSCLOSE("CLOSE AFT REV")=1
        ;   BPSCLOSE("CLOSE AFT REV REASON")=<#356.8 ien>
        ;   BPSCLOSE("CLOSE AFT REV COMMENT")=<some text>
        ; 
        ;Output (RESPONSE^MESSAGE^ELIGIBILITY^CLAIMSTATUS)
        ; RESPONSE
        ;    0  Submitted through ECME
        ;    1  No submission through ECME
        ;    2  IB not billable
        ;    3  Claim was closed, not submitted (RTS/Deletes)
        ;    4  Unable to queue claim
        ;    5  Incorrect information supplied to ECME
        ;    6  Inactive ECME - Primarily used for Tricare to say ok to process rx
        ;    10 Reversal but no resubmit
        ; MESSAGE = Message associated with the response (error/submitted)
        ; ELIGIBILITY = V - VA, T - Tricare
        ; CLAIMSTATUS = claim status (null or IN PROGRESS/E PAYABLE/etc...)
        ; ----------------- End of BPSNCPDP comments ----------------------
        ;
        ; ----------------- DUR1 ------------------------------------------
        ; DUR1 is called by PSO to get the reject info so that should NOT be removed
        ;
        ;
        ; IA 4560
        ; Function call for DUR INFORMATION 
        ; Parameters: BRXIEN = Prescription IEN
        ;             BFILL = fill number
        ;             DUR = DUR info passed back
        ;             ERROR = error passed back
        ; Note:
        ;    DUR("BILLED")=0 if ecme off for pharmacy or no transaction in ECME
        ;    DUR(<Insurance counter>,"BILLED")=1 if billed through ecme
DUR1(BRXIEN,BFILL,DUR,ERROR)    ;
        N SITE,DFILL,TRANIEN,JJ,DUR1,DURIEN,I
        ;
        ; Get Site info and check is ECME is turned on
        ; If not, set DUR("BILLED")=0 and quit
        I '$G(BFILL) S SITE=$$RXAPI1^BPSUTIL1(BRXIEN,20,"I")
        I $G(BFILL) S SITE=$$RXSUBF1^BPSUTIL1(BRXIEN,52,52.1,BFILL,8,"I")
        I '$$ECMEON^BPSUTIL(SITE) S DUR("BILLED")=0 Q
        ;
        ; Set up the Transaction IEN
        S DFILL="",DFILL=$E($TR($J("",4-$L(BFILL))," ","0")_BFILL,1,4)_1
        S TRANIEN=BRXIEN_"."_DFILL
        ;
        ; If the transaction record does not exist, set DUR("BILLED")=0 and quit
        I '$D(^BPST(TRANIEN)) S DUR("BILLED")=0 Q
        ;
        ; Loop through the insurance multiple and set DUR array
        S JJ=0
        F  S JJ=$O(^BPST(TRANIEN,10,JJ)) Q:JJ=""!(JJ'?1N.N)  D
        . ;
        . ; We are good so set Billed
        . S DUR(JJ,"BILLED")=1
        . ;
        . S DUR(JJ,"ELIGBLT")=$P($G(^BPST(TRANIEN,9)),U,4)
        . ; Get Insurance Info and set into DUR array
        . D GETS^DIQ(9002313.59902,JJ_","_TRANIEN_",","902.05;902.06;902.24;902.25;902.26","E","DUR1","ERROR")
        . S DUR(JJ,"INSURANCE NAME")=$G(DUR1(9002313.59902,JJ_","_TRANIEN_",",902.24,"E"))  ; Insurance Company Name
        . S DUR(JJ,"GROUP NUMBER")=$G(DUR1(9002313.59902,JJ_","_TRANIEN_",",902.05,"E"))    ; Insurance Group Number
        . S DUR(JJ,"GROUP NAME")=$G(DUR1(9002313.59902,JJ_","_TRANIEN_",",902.25,"E"))      ; Insurance Group Name
        . S DUR(JJ,"PLAN CONTACT")=$G(DUR1(9002313.59902,JJ_","_TRANIEN_",",902.26,"E"))    ; Insurance Contact Number
        . S DUR(JJ,"CARDHOLDER ID")=$G(DUR1(9002313.59902,JJ_","_TRANIEN_",",902.06,"E"))   ; Cardholder ID
        . ;
        . ; Get Response IEN and Data
        . S DURIEN="",DURIEN=$P(^BPST(TRANIEN,0),"^",5)                             ;Note: in future will need to store/get DURIEN for each insurance
        . S DUR(JJ,"RESPONSE IEN")=DURIEN
        . D GETS^DIQ(9002313.0301,"1,"_DURIEN_",","501;567.01*;526","E","DUR1","ERROR")
        . S DUR(JJ,"PAYER MESSAGE")=$G(DUR1(9002313.0301,"1,"_DURIEN_",",526,"E"))           ;Additional free text message info from payer
        . S DUR(JJ,"STATUS")=$G(DUR1(9002313.0301,"1,"_DURIEN_",",501,"E"))                  ;Status of Response
        . S DUR(JJ,"REASON")=$G(DUR1(9002313.1101,"1,1,"_DURIEN_",",439,"E"))                ;Reason of Service Code
        . S DUR(JJ,"PREV FILL DATE")=$G(DUR1(9002313.1101,"1,1,"_DURIEN_",",530,"E"))        ;Previous Date of Fill
        . S DUR(JJ,"DUR FREE TEXT DESC")=$G(DUR1(9002313.1101,"1,1,"_DURIEN_",",544,"E"))    ;DUR Free Text Message from Payer
        . ;
        . ; Get DUR reject codes and description and store in DUR 
        . D GETS^DIQ(9002313.0301,"1,"_DURIEN_",","511*","I","DUR1","ERROR")                 ;get DUR codes and descriptions
        . S DUR(JJ,"REJ CODE LST")=""
        . F I=1:1 Q:'$D(DUR1(9002313.03511,I_",1,"_DURIEN_","))  D
        .. S DUR(JJ,"REJ CODES",I,DUR1(9002313.03511,I_",1,"_DURIEN_",",.01,"I"))=$$GET1^DIQ(9002313.93,DUR1(9002313.03511,I_",1,"_DURIEN_",",.01,"I"),".02")
        .. S DUR(JJ,"REJ CODE LST")=DUR(JJ,"REJ CODE LST")_","_DUR1(9002313.03511,I_",1,"_DURIEN_",",.01,"I")
        . S DUR(JJ,"REJ CODE LST")=$E(DUR(JJ,"REJ CODE LST"),2,9999)
        Q
