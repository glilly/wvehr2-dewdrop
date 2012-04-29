BPSNCPD3        ;BHAM ISC/LJE - Continuation of BPSNCPDP - DUR HANDLING ;06/16/2004
        ;;1.0;E CLAIMS MGMT ENGINE;**1,5,6**;JUN 2004;Build 10
        ;;Per VHA Directive 2004-038, this routine should not be modified.
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
