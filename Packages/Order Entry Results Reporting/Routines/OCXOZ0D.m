OCXOZ0D ;SLC/RJS,CLA - Order Check Scan ;AUG 11,2009 at 08:45
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
CHK360  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK198+9^OCXOZ09.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK360 Variables
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(43) ---> Data Field: OI NATIONAL ID (FREE TEXT)
        ; OCXDF(74) ---> Data Field: VA DRUG CLASS (FREE TEXT)
        ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
        ; OCXDF(132) --> Data Field: CLOZAPINE MED (BOOLEAN)
        ;
        ;      Local Extrinsic Functions
        ;
        S OCXDF(131)=$P($P($G(OCXPSD),"|",3),"^",4) I $L(OCXDF(131)) S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) S OCXDF(132)=$P($$CLOZLABS^ORKLR(OCXDF(37),7,OCXDF(131)),"^",1) D CHK365
        S OCXDF(43)=$P($P($G(OCXPSD),"|",3),"^",1) I $L(OCXDF(43)) S OCXDF(74)=$P($$ENVAC^PSJORUT2(OCXDF(43)),"^",2) I $L(OCXDF(74)) D CHK497^OCXOZ0G
        Q
        ;
CHK365  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK360+14.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK365 Variables
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
        ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
        ; OCXDF(132) --> Data Field: CLOZAPINE MED (BOOLEAN)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,116, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE DRUG SELECTED)
        ;
        I $L(OCXDF(132)),(OCXDF(132)) S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXOERR=$$FILE(DFN,116,"130") Q:OCXOERR 
        Q
        ;
CHK371  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK347+16^OCXOZ0C.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK371 Variables
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
        ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,117, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE NO ANC W/IN 7 DAYS)
        ;
        S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXOERR=$$FILE(DFN,117,"130") Q:OCXOERR 
        Q
        ;
CHK375  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK347+17^OCXOZ0C.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK375 Variables
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
        ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,118, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE NO WBC W/IN 7 DAYS)
        ;
        S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXOERR=$$FILE(DFN,118,"130") Q:OCXOERR 
        Q
        ;
CHK378  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK347+18^OCXOZ0C.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK378 Variables
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
        ; OCXDF(139) --> Data Field: CLOZAPINE WBC W/IN 7 FLAG (BOOLEAN)
        ; OCXDF(140) --> Data Field: CLOZAPINE WBC W/IN 7 RESULT (NUMERIC)
        ;
        ;      Local Extrinsic Functions
        ;
        I (OCXDF(140)<"3.0") S OCXDF(139)=$P($P($$CLOZLABS^ORKLR(OCXDF(37),7,OCXDF(131)),"^",2),";",1) I $L(OCXDF(139)),(OCXDF(139)) D CHK382
        I (OCXDF(140)>2.999),(OCXDF(140)<3.5) S OCXDF(139)=$P($P($$CLOZLABS^ORKLR(OCXDF(37),7,OCXDF(131)),"^",2),";",1) I $L(OCXDF(139)),(OCXDF(139)) D CHK388
        I (OCXDF(140)>3.499) S OCXDF(139)=$P($P($$CLOZLABS^ORKLR(OCXDF(37),7,OCXDF(131)),"^",2),";",1) I $L(OCXDF(139)),(OCXDF(139)) D CHK393
        Q
        ;
CHK382  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK378+13.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK382 Variables
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
        ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,119, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE WBC < 3.0)
        ;
        S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXOERR=$$FILE(DFN,119,"130") Q:OCXOERR 
        Q
        ;
CHK388  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK378+14.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK388 Variables
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
        ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,120, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE WBC >= 3.0 & < 3.5)
        ;
        S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXOERR=$$FILE(DFN,120,"130") Q:OCXOERR 
        Q
        ;
CHK393  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK378+15.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK393 Variables
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
        ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; FILE(DFN,121, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE WBC >= 3.5)
        ;
        S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXOERR=$$FILE(DFN,121,"130") Q:OCXOERR 
        Q
        ;
CHK398  ; Look through the current environment for valid Event/Elements for this patient.
        ;  Called from CHK58+21^OCXOZ05.
        ;
        Q:$G(OCXOERR)
        ;
        ;    Local CHK398 Variables
        ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
        ; OCXDF(62) ---> Data Field: PATIENT AGE (NUMERIC)
        ; OCXDF(141) --> Data Field: AMITRIPTYLINE TEXT (FREE TEXT)
        ; OCXDF(143) --> Data Field: DANGEROUS MEDS FOR PT > 64 NAME (FREE TEXT)
        ;
        ;      Local Extrinsic Functions
        ; MSGTEXT( ---------> MESSAGE TEXT
        ;
        I (OCXDF(143)["AMITRIPTYLINE") S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) S OCXDF(62)=$$AGE^ORQPTQ4(OCXDF(37)),OCXDF(141)=$$MSGTEXT("AMITRIPTYLINE") D CHK403^OCXOZ0E
        I (OCXDF(143)["CHLORPROPAMIDE") S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) S OCXDF(62)=$$AGE^ORQPTQ4(OCXDF(37)),OCXDF(141)=$$MSGTEXT("AMITRIPTYLINE") D CHK410^OCXOZ0E
        I (OCXDF(143)["DIPYRIDAMOLE") S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) S OCXDF(62)=$$AGE^ORQPTQ4(OCXDF(37)),OCXDF(141)=$$MSGTEXT("AMITRIPTYLINE") D CHK417^OCXOZ0E
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
MSGTEXT(ID)        ;  Compiler Function: MESSAGE TEXT
        ;
        N MSG
        S MSG=""
        ;
        I ID="AMITRIPTYLINE" D
        .S MSG="Amitriptyline can cause cognitive impairment and loss of"
        .S MSG=MSG_" balance in older patients. Consider other antidepressant"
        .S MSG=MSG_" medications on formulary."
        ;
        I ID="CHLORPROPAMIDE" D
        .S MSG="Older patients may experience hypoglycemia with"
        .S MSG=MSG_" Chlorpropamide due to its long duration and variable"
        .S MSG=MSG_" renal secretion. They may also be at increased risk for"
        .S MSG=MSG_" Chlorpropamide-induced SIADH."
        ;
        I ID="DIPYRIDAMOLE" D
        .S MSG="Older patients can experience adverse reactions at high doses"
        .S MSG=MSG_" of Dipyridamole (e.g., headache, dizziness, syncope, GI"
        .S MSG=MSG_" intolerance.) There is also questionable efficacy at"
        .S MSG=MSG_" lower doses."
        ;
        I ID="CLOZWBC30_35" D
        .S MSG="WBC between 3.0 and 3.5 with no ANC - pharmacy cannot fill"
        .S MSG=MSG_" clozapine order. Please order CBC/Diff with WBC and ANC"
        .S MSG=MSG_" immediately."
        ;
        Q MSG
        ;
