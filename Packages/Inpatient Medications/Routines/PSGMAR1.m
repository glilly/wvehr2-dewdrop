PSGMAR1 ;BIR/CML3-SORT ORDERS FOR 24 HOUR MAR ; 7/21/08 9:24am
        ;;5.0; INPATIENT MEDICATIONS ;**8,111,145,196**;16 DEC 97;Build 13
        ;
        ;
SP      ; start print
        U IO S (LN1,LN2,PSGOP,PN,RB,WDN,TM)="",PSGLSTOP=1,$P(LN1,"-",133)="",$P(LN2,"-",126)=""
        K BLN S BLN(1)=$E(LN1,1,20),BLN(2)=" Indicate RIGHT (R)",BLN(3)=" or LEFT (L)",BLN(4)=" 1. DELTOID",BLN(5)=" 2. ABDOMEN",BLN(6)=" 3. ILIAC CREST",BLN(7)=" 4. GLUTEAL",BLN(8)=" 5. THIGH",BLN(9)="PRN: E=Effective",BLN(10)="     N=Not Effective"
        I PSGSS="P"!(PSGSS="C")!(PSGSS="L") F  S PN=$O(^TMP($J,PN)) Q:PN=""  D P
        Q:(PSGSS="P")!(PSGSS="C")!(PSGSS="L") 
        F  S (PTM,TM)=$O(^TMP($J,TM)) Q:TM=""  F  S (PWDN,WDN)=$O(^TMP($J,TM,WDN)) Q:WDN=""  D
        . I PSGRBPPN="R" F  S (PRB,RB)=$O(^TMP($J,TM,WDN,RB)) Q:RB=""  F  S PN=$O(^TMP($J,TM,WDN,RB,PN)) Q:PN=""  S PPN=^(PN) D PI,^PSGMAR2
        ;
        ;DAM 5-01-07 - rewrite above lines to utilize the ^XTMP global set up in PSGMAR0 for printing by WARD/PATIENT or WARD GROUP
        I PSGRBPPN="P" F  S (PTM,TM)=$O(^XTMP(PSGREP,TM)) Q:TM=""  F  S PN=$O(^XTMP(PSGREP,TM,PN)) Q:PN=""  D
        . F  S (PWDN,WDN)=$O(^XTMP(PSGREP,TM,PN,WDN)) Q:WDN=""  D
        . . F  S (PRB,RB)=$O(^XTMP(PSGREP,TM,PN,WDN,RB)) Q:RB=""  S PPN=^(RB) D PI,^PSGMAR2
        Q
        ;
P       ;
        ;
        N TMPPWDN
        I PSGMARB=1 S PPN=^TMP($J,PN),PWDN=$S(PSGSS="C":$G(PSGAPWDN),1:$P(PPN,U,19)),PRB=$S(PSGSS="C":"",1:$P(PPN,U,20)),PTM="zz" D PI,^PSGMAR2 Q
        S TMPPWDN=$P(^TMP($J,PN),U,19)
        S:TMPPWDN="" TMPPWDN="zz"
        S PWDN=""
        F  S PWDN=$O(^TMP($J,PN,PWDN)) Q:PWDN=""  S TMPPWDN=PWDN S PPN=^TMP($J,PN),PRB=$P(PPN,U,20),PTM="zz" D PI,^PSGMAR2 S PWDN=TMPPWDN
        Q
        ;
PI      ; Parses patient information.  Does not contain medication info.
        K PSGMPG,PSGMPGN
        S:PTM="zz" PTM="NOT FOUND" S:PWDN="zz" PWDN="NOT FOUND" S:PRB="zz" PRB="NOT FOUND"
        S (PSGOP,PSGP)=+$P(PN,U,2),PSGP(0)=$P(PN,U),BD=$P(PPN,U,2),PSSN=$P(PPN,U,3),DX=$P(PPN,U,4),WT=$P(PPN,U,5)_" "_$P(PPN,U,6)
        ;GMZ:PSJ*5*196;Set diet info for each patient.
        S HT=$P(PPN,U,7)_" "_$P(PPN,U,8),AD=$P(PPN,U,9),TD=$P(PPN,U,10),PSEX=$P(PPN,U,11),PSGLWD=$P(PPN,U,12),PSJDIET=$P($G(PPN),U,21)
        S PSGPLS=$P(PPN,U,13),PSGPLF=$P(PPN,U,14),PSGMARSD=$P(PPN,U,15),PSGMARFD=$P(PPN,U,16),PSGMARSP=$P(PPN,U,17),PSGMARFP=$P(PPN,U,18)
        S PPN=$P(PPN,U),PAGE=$P(BD,";",2),BD=$P(BD,";"),DFN=PSGP
        D ATS^PSJMUTL(115,117,1)
        Q
