SPNRPCD ;SD/WDE - Returns URINALYSIS Lab test results;JUL 01, 2008
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ;      DBIA 4245 RESULTS^LRPXAPI
        ;
        ;
        ;     dfn is ien of the pt
        ;     cutdate is the date to start collection data from
        ;     root is the sorted data in latest date of test first
        ;
COL(ROOT,ICN,CUTDATE)   ;
        ;S X=CUTDATE S %DT="T" D ^%DT S CUTDATE=9999999.9999-Y
        S X=CUTDATE D ^%DT S CUTDATE=Y
        K ^TMP($J)
        S ROOT=$NA(^TMP($J))
        ;*************************
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:$G(DFN)=""
        D NEWT
        Q
        K SPNA,SPNB,SPNC,SPND,ITEMS,MORE,DATA,SPNCNT,SPNA,DATA,SPNREV,SPNTST,TESTS,Y,SPNDT
        K UPPER,LOWERM,UNIT,HILOW,VALUE,SPNZZZ,SPNX,ZZZ,Z,Y,TESTS,SPN,DFN,COL,SPNJ
        Q
NEWT    ;
        K ^TMP($J),ITMES,TESTS
        K TESTS
        ;S DFN=141471   ;HAS TEST GROUPS 70,72 ONLY DAYT42 ACCOUNT
        ;S DFN=142920  ;HAS TEST GROUPS 70, 72 AND 73
        ; THIS WORKS D RESULTS^LRPXAPI(.ZZZ,DFN,"C",10,,"S=72") BUT I DONT HAVE THE NAME OF THE TEST
        ;get the test that the patient has received
        ;^LAB(61,70,0)=BLOOD^0X000^^^B^20
        ;^LAB(61,71,0)=URINE^7X100^^^U^15
        ;^LAB(61,72,0)=SERUM^0X500^^^S^4
        ;^LAB(61,73,0)=PLASMA^0X400^^^P^6
        ;^LAB(61,74,0)=CEREBROSPINAL FLUID^X1000^^  NOT INCLUDED IN THIS REPORT
        ;D TESTS^LRPXAPI(.TESTS,DFN)
        K SPNA,SPNB,SPNC,SPND
        D TESTS^LRPXAPI(.SPNA,DFN,,,,"S=71")
        S SPNJ=0 F  S SPNJ=$O(SPNA(SPNJ)) Q:SPNJ=""  S TESTS(SPNJ)=$G(SPNA(SPNJ))
        K SPNA
        D TESTS^LRPXAPI(.SPNA,DFN,,,,"S=70")
        S SPNJ=0 F  S SPNJ=$O(SPNA(SPNJ)) Q:SPNJ=""  S TESTS(SPNJ)=$G(SPNA(SPNJ))
        K SPNA,SPNB,SPNC
        F  D  Q:'MORE
         . D RESULTS^LRPXAPI(.ITEMS,DFN,"C",100,.MORE)
         . M ^TMP("SPN",$J)=ITEMS
         ;NOW RESORT THE DATA AND BUILD THE STRING WE WANT
         ;            "-3050303 5270")=3050303^5270^1^61.1^^82400.0000!!!3216!!!5270^2936^72!60!!!^^^^55
         K ITEMS
         S SPNCNT=0,DATA=""
         S SPNA=0 F  S SPNA=$O(^TMP("SPN",$J,SPNA)) Q:SPNA=""  D
        .S DATA=$G(^TMP("SPN",$J,SPNA))
        .S SPNCNT=SPNCNT+1
        .Q:DATA=""
        .S SPNREV="-"_$P(DATA,U,1)  ;MINUS DATE THING
        .I $P(DATA,U,1)<CUTDATE Q
        .S Y=$P(DATA,U,1) D DD^%DT S SPNDT=Y
        .S SPNTST=$P(DATA,U,2)
        .Q:SPNTST=""  ;NO TEST NUMBER IN THE DATA STREAM
        .S SPNTENA=$P($G(TESTS(SPNTST)),U,2)
        .Q:SPNTENA=""  ;TEST NOT IS THE LIST GENERATED IN TESTS^LRPXAPI
        .;SCREEN FOR TEST WE WANT
        .S COL=0
        .I SPNTENA["CRYSTA" S COL=1
        .I SPNTENA["TURBID" S COL=1
        .I SPNTENA["COLOR" S COL=1
        .I SPNTENA["SPECIF" S COL=1
        .I SPNTENA["UROBIL" S COL=1
        .I SPNTENA["UR BLOOD" S COL=1
        .I SPNTENA["URINE BLOOD" S COL=1
        .I SPNTENA["UR BILIR" S COL=1
        .I SPNTENA["KETO" S COL=1
        .I SPNTENA["UR GLU" S COL=1
        .I SPNTENA["URINE GLUCOSE" S COL=1
        .I SPNTENA["UR PROTEIN" S COL=1
        .I SPNTENA["URINE PROTEIN" S COL=1
        .I SPNTENA["UR PH" S COL=1
        .I SPNTENA["URINE PH" S COL=1
        .I SPNTENA["WBC/" S COL=1
        .I SPNTENA["RBC/" S COL=1
        .I SPNTENA["EPITHE" S COL=1
        .I SPNTENA["BACT" S COL=1
        .I SPNTENA["MUCUS" S COL=1
        .I SPNTENA["URINE CA" S COL=1
        .I SPNTENA["HYAL" S COL=1
        .I SPNTENA["WAXY" S COL=1
        .I SPNTENA["SQUAM" S COL=1
        .I SPNTENA["NITRI" S COL=1
        .I SPNTENA["LEUKOC" S COL=1
        .Q:COL=0  ;TEST DOES NOT MAKE IT
        .S LOWER=$P(DATA,"!",5)  ;lower range
        .S UPPER=$P(DATA,"!",6)  ;upper range
        .S SPNZZZ=$P(DATA,U,8) S UNIT=$P(SPNZZZ,"!",7) K SPNZZZ
        .S ZZ="" F Z=1:1:$L(UNIT) I $E(UNIT,Z)'=" " S ZZ=ZZ_$E(UNIT,Z)  ;Strip off the blanks
        .S UNIT=ZZ K ZZ,X
        .S HILOW=$P(DATA,U,5)
        .S VALUE=$P(DATA,U,4)
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,"BEFORE",SPNREV,SPNCNT)=SPNDT_U_SPNTENA_U_VALUE_U_HILOW_U_UNIT_U_LOWER_U_UPPER_U_"EOL999"
        .K SPNTENA,LOWER,UPPER,UNIT,SPNTENA,HILOW,VALUE,DATA
REDO    ;RESORT THE TEMP GLOBAL
        S SPNCNT=0
        S SPNREV="" F  S SPNREV=$O(^TMP($J,"BEFORE",SPNREV)) Q:SPNREV=""  S SPNX=0 F  S SPNX=$O(^TMP($J,"BEFORE",SPNREV,SPNX)) Q:SPNX=""  D
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,SPNCNT)=$G(^TMP($J,"BEFORE",SPNREV,SPNX))
        K ^TMP($J,"BEFORE")
        K ^TMP("SPN",$J)
        Q
DOIT    ;
        K TESTS
        K ^TMP($J,"BEFORE")
        K ^TMP("SPN",$J)
        K ^TMP($J)
        ;D COL(,1002619533,"JAN 1 1990")
        D COL(,1002619533,"DEC 1 2004")
        ;D ^%G
        Q
