OCXOZ07 ;SLC/RJS,CLA - Order Check Scan ;AUG 11,2009 at 08:45
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,221,243**;Dec 17,1997;Build 242
        ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
        ;
        ; ***************************************************************
        ; ** Warning: This routine is automatically generated by the   **
        ; ** Rule Compiler (^OCXOCMP) and ANY changes to this routine  **
        ; ** will be lost the next time the rule compiler executes.    **
        ; ***************************************************************
        ;
        Q
        ;
CHK121  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK2+14^OCXOZ02.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK121 Variables
        ; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
        ; OCXDF(34) ---> Data Field: ORDER NUMBER (NUMERIC)
        ; OCXDF(96) ---> Data Field: ORDERABLE ITEM NAME (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,101, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: HL7 FINAL IMAGING RESULT)
        ; FILE(DFN,55, -----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CONSULT FINAL RESULTS)
        ; ORDITEM( ---------> GET ORDERABLE ITEM FROM ORDER NUMBER
        ;
        I (OCXDF(2)="GMRC"),$L(OCXDF(34)) S OCXDF(96)=$$ORDITEM(OCXDF(34)),OCXOERR=$$FILE(DFN,55,"96") Q:OCXOERR 
        I (OCXDF(2)="RA"),$L(OCXDF(34)) S OCXDF(96)=$$ORDITEM(OCXDF(34)),OCXOERR=$$FILE(DFN,101,"96") Q:OCXOERR 
        Q
        ;
CHK131  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK12+33^OCXOZ03.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK131 Variables
        ; OCXDF(34) ---> Data Field: ORDER NUMBER (NUMERIC)
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(54) ---> Data Field: SITE FLAGGED ORDER (BOOLEAN)
        ; OCXDF(96) ---> Data Field: ORDERABLE ITEM NAME (FREE TEXT)
        ; OCXDF(146) --> Data Field: INPT/OUTPT (FREE TEXT)
        ; OCXDF(147) --> Data Field: PATIENT LOCATION (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; ORDITEM( ---------> GET ORDERABLE ITEM FROM ORDER NUMBER
        ; PATLOC( ----------> PATIENT LOCATION
        ;
        S OCXDF(54)=$$SITEORD^ORB3F1(OCXDF(34),OCXDF(146)) I $L(OCXDF(54)),(OCXDF(54)) S OCXDF(96)=$$ORDITEM(OCXDF(34)),OCXDF(147)=$P($$PATLOC(OCXDF(37)),"^",2) D CHK136
        Q
        ;
CHK136  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK131+17.
        ;
        Q:$G(OCXOERR)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,58, -----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: NEW SITE FLAGGED ORDER)
        ;
        S OCXOERR=$$FILE(DFN,58,"9,96,147") Q:OCXOERR 
        Q
        ;
CHK144  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK47+20^OCXOZ05.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK144 Variables
        ; OCXDF(34) ---> Data Field: ORDER NUMBER (NUMERIC)
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(55) ---> Data Field: SITE FLAGGED RESULT (BOOLEAN)
        ; OCXDF(96) ---> Data Field: ORDERABLE ITEM NAME (FREE TEXT)
        ; OCXDF(146) --> Data Field: INPT/OUTPT (FREE TEXT)
        ; OCXDF(147) --> Data Field: PATIENT LOCATION (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; ORDITEM( ---------> GET ORDERABLE ITEM FROM ORDER NUMBER
        ; PATLOC( ----------> PATIENT LOCATION
        ;
        S OCXDF(55)=$$SITERES^ORB3F1(OCXDF(34),OCXDF(146)) I $L(OCXDF(55)),(OCXDF(55)) S OCXDF(96)=$$ORDITEM(OCXDF(34)),OCXDF(147)=$P($$PATLOC(OCXDF(37)),"^",2) D CHK149
        Q
        ;
CHK149  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK144+17.
        ;
        Q:$G(OCXOERR)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,59, -----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: SITE FLAGGED FINAL LAB RESULT)
        ;
        S OCXOERR=$$FILE(DFN,59,"9,96,147") Q:OCXOERR 
        Q
        ;
CHK151  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK1+31^OCXOZ02.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK151 Variables
        ; OCXDF(1) ----> Data Field: CONTROL CODE (FREE TEXT)
        ; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
        ; OCXDF(15) ---> Data Field: RESULT STATUS (OBX) (FREE TEXT)
        ; OCXDF(34) ---> Data Field: ORDER NUMBER (NUMERIC)
        ; OCXDF(96) ---> Data Field: ORDERABLE ITEM NAME (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,60, -----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: NEW OBR STAT ORDER)
        ; LIST( ------------> IN LIST OPERATOR
        ; ORDITEM( ---------> GET ORDERABLE ITEM FROM ORDER NUMBER
        ;
        I $L(OCXDF(1)),$$LIST(OCXDF(1),"NW,SN"),$L(OCXDF(34)) S OCXDF(96)=$$ORDITEM(OCXDF(34)),OCXOERR=$$FILE(DFN,60,"96") Q:OCXOERR 
        I $L(OCXDF(15)),(OCXDF(15)="F"),$L(OCXDF(1)),$$LIST(OCXDF(1),"RE"),$L(OCXDF(2)),($E(OCXDF(2),1,2)="LR"),$L(OCXDF(34)) S OCXDF(96)=$$ORDITEM(OCXDF(34)) D CHK264^OCXOZ0B
        Q
        ;
CHK157  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK1+32^OCXOZ02.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK157 Variables
        ; OCXDF(1) ----> Data Field: CONTROL CODE (FREE TEXT)
        ; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
        ; OCXDF(23) ---> Data Field: REQUEST STATUS (OBR) (FREE TEXT)
        ; OCXDF(34) ---> Data Field: ORDER NUMBER (NUMERIC)
        ; OCXDF(96) ---> Data Field: ORDERABLE ITEM NAME (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,61, -----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: NEW ORC STAT ORDER)
        ; LIST( ------------> IN LIST OPERATOR
        ; ORDITEM( ---------> GET ORDERABLE ITEM FROM ORDER NUMBER
        ;
        I $L(OCXDF(1)),$$LIST(OCXDF(1),"NW,SN"),$L(OCXDF(34)) S OCXDF(96)=$$ORDITEM(OCXDF(34)),OCXOERR=$$FILE(DFN,61,"96") Q:OCXOERR 
        I $L(OCXDF(23)),(OCXDF(23)="F"),$L(OCXDF(1)),$$LIST(OCXDF(1),"RE"),$L(OCXDF(2)) D CHK253^OCXOZ0B
        Q
        ;
CHK163  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK58+18^OCXOZ05.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK163 Variables
        ; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(40) ---> Data Field: ORDER MODE (FREE TEXT)
        ; OCXDF(43) ---> Data Field: OI NATIONAL ID (FREE TEXT)
        ;
        I (OCXDF(40)="ACCEPT") D CHK164^OCXOZ08
        I (OCXDF(40)="DISPLAY") S OCXDF(2)=$P($G(OCXPSD),"|",2) I $L(OCXDF(2)),($E(OCXDF(2),1,2)="PS") S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) D CHK182^OCXOZ08
        I (OCXDF(40)="SELECT") D CHK196^OCXOZ09
        I (OCXDF(40)="SESSION") S OCXDF(2)=$P($G(OCXPSD),"|",2) I $L(OCXDF(2)),($E(OCXDF(2),1,2)="PS") S OCXDF(43)=$P($P($G(OCXPSD),"|",3),"^",1) I $L(OCXDF(43)) D CHK227^OCXOZ0A
        Q
        ;
FILE(DFN,OCXELE,OCXDFL) ;     This Local Extrinsic Function logs a validated event/element.
        ;
        N OCXTIMN,OCXTIML,OCXTIMT1,OCXTIMT2,OCXDATA,OCXPC,OCXPC,OCXVAL,OCXSUB,OCXDFI
        S DFN=+$G(DFN),OCXELE=+$G(OCXELE)
        ;
        Q:'DFN 1 Q:'OCXELE 1 K OCXDATA
        ;
        S OCXDATA(DFN,OCXELE)=1
        F OCXPC=1:1:$L(OCXDFL,",") S OCXDFI=$P(OCXDFL,",",OCXPC) I OCXDFI D
        .S OCXVAL=$G(OCXDF(+OCXDFI)),OCXDATA(DFN,OCXELE,+OCXDFI)=OCXVAL
        ;
        M ^TMP("OCXCHK",$J,DFN)=OCXDATA(DFN)
        ;
        Q 0
        ;
LIST(DATA,LIST) ;   IS THE DATA FIELD IN THE LIST
        ;
        S:'($E(LIST,1)=",") LIST=","_LIST S:'($E(LIST,$L(LIST))=",") LIST=LIST_"," S DATA=","_DATA_","
        Q (LIST[DATA)
        ;
ORDITEM(OIEN)   ;  Compiler Function: GET ORDERABLE ITEM FROM ORDER NUMBER
        Q:'$G(OIEN) ""
        ;
        N OITXT,X S OITXT=$$OI^ORQOR2(OIEN) Q:'OITXT "No orderable item found."
        S X=$G(^ORD(101.43,+OITXT,0)) Q:'$L(X) "No orderable item found."
        Q $P(X,U,1)
        ;
PATLOC(DFN)     ;  Compiler Function: PATIENT LOCATION
        ;
        N OCXP1,OCXP2
        S OCXP1=$G(^TMP("OCXSWAP",$J,"OCXODATA","PV1",2))
        S OCXP2=$P($G(^TMP("OCXSWAP",$J,"OCXODATA","PV1",3)),"^",1)
        I OCXP2 D
        .S OCXP2=$P($G(^SC(+OCXP2,0)),"^",1,2)
        .I $L($P(OCXP2,"^",2)) S OCXP2=$P(OCXP2,"^",2)
        .E  S OCXP2=$P(OCXP2,"^",1)
        .S:'$L(OCXP2) OCXP2="NO LOC"
        I $L(OCXP1),$L(OCXP2) Q OCXP1_"^"_OCXP2
        ;
        S OCXP2=$G(^DPT(+$G(DFN),.1))
        I $L(OCXP2) Q "I^"_OCXP2
        Q "O^OUTPT"
        ;
