SPNRPCL ;SD/WDE - Returns Lab test results for the complete blood count;JUL 01, 2008
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ;   INTEGRATION REFERENCE INQUIRY #4245
        ;   INTEGRATION REFERENCE INQUIRY #4246
        ;
        ;Note that this routine does not list all of the drugs that
        ; spnrpce does.  This one is a shorter list.
        ;     dfn is ien of the pt
        ;     cutdate is the date to start collection data from
        ;     root is the sorted data in latest date of test first
        ;
COL(ROOT,ICN,CUTDATE)   ;
        S X=CUTDATE D ^%DT S CUTDATE=Y
        K ^TMP($J)
        S ROOT=$NA(^TMP($J))
        ;********************************
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:$G(DFN)=""
        ;********************************
        S LRDFN=$$LRDFN^LRPXAPIU(DFN) Q:LRDFN'>0
        D NEWT
        K SPNA,SPNB,SPNC,SPND,ITEMS,MORE,DATA,SPNCNT,SPNA,DATA,SPNREV,SPNTST,TESTS,Y,SPNDT
        K UPPER,LOWERM,UNIT,HILOW,VALUE,SPNZZZ,SPNX,ZZZ,Z,Y,TESTS,SPN,DFN,COL
        K LRDFN  ;WDE
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
        S SPNCNT=0
        D TESTS^LRPXAPI(.SPNA,DFN,,,,"S=70")
        S SPN=0 F  S SPN=$O(SPNA(SPN)) Q:(SPN="")!('+SPN)  S SPNCNT=SPNCNT+1 S TESTS(SPN)=$G(SPNA(SPN))
        D TESTS^LRPXAPI(.SPNB,DFN,,,,"S=72")
        S SPN=0 F  S SPN=$O(SPNB(SPN)) Q:(SPN="")!('+SPN)  S SPNCNT=SPNCNT+1 S TESTS(SPN)=$G(SPNB(SPN))
        D TESTS^LRPXAPI(.SPNC,DFN,,,,"S=73")
        S SPN=0 F  S SPN=$O(SPNC(SPN)) Q:(SPN="")!('+SPN)  S SPNCNT=SPNCNT+1 S TESTS(SPN)=$G(SPNC(SPN))
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
        .Q:DATA=""
        .S SPNREV="-"_$P(DATA,U,1)  ;MINUS DATE THING
        .I $P(DATA,U,1)<CUTDATE Q
        .S Y=$P(DATA,U,1) D DD^%DT S SPNDT=Y
        .S SPNTST=$P(DATA,U,2)
        .Q:$G(TESTS(SPNTST))=""  ;IS NOT A TEST THAT WE WANT
        .S SPNTENA=$P($G(TESTS(SPNTST)),U,2)
        .;SCREEN FOR TEST WE WANT
        .S COL=0
        .I COL=0 I SPNTENA["WBC" S COL=1
        .I COL=0 I SPNTENA["HGB" S COL=1
        .I COL=0 I SPNTENA["HCT" S COL=1
        .I COL=0 I SPNTENA["PROTEIN" S COL=1
        .I COL=0 I SPNTENA["WINTROB" S COL=1
        .I COL=0 I SPNTENA["WESTERGR" S COL=1
        .I COL=0 I SPNTENA["ESR" S COL=1
        .I COL=0 I SPNTENA["C-REACTIVE" S COL=1
        .I COL=0 I SPNTENA["CRP" S COL=1
        .I COL=0 I SPNTENA["ZINC" S COL=1
        .I COL=0 I SPNTENA["VITAMIN A" S COL=1
        .I COL=0 I SPNTENA["VITAMIN C" S COL=1
        .I COL=0 I SPNTENA["VITAMIN E" S COL=1
        .I COL=0 I SPNTENA["LYMPHS" S COL=1
        .I COL=0 I SPNTENA["TRANSTHYRE" S COL=1
        .I COL=0 I SPNTENA["ALBUMI" S COL=1
        .I COL=0 I SPNTENA["TRANSFERRIN" S COL=1
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
