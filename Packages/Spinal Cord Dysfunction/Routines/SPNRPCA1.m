SPNRPCA1        ;SD/WDE - Returns SPUTUM LAB results box;JUL 28, 2008
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ;
        ;   INTEGRATION REFERENCE INQUIRY #4245
        ;   INTEGRATION REFERENCE INQUIRY #4246
        ;
        ;     dfn is ien of the pt
        ;     root is the sorted data in latest date of test first
        ;---------------------------------------------------------------------
COL(ROOT,ICN,SPNSDT,SPNEDT)     ;
        ;
        K ^TMP($J)
        K SPNARRY
        S ROOT=$NA(^TMP($J))
        ;***************************
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:DFN=""
        ;****************************
        ;NEWT(ROOT,ICN,SDATE,EDATE)     ;
        D NOW^%DTC S SPNEDT=X
        S X=SPNSDT S %DT="T" D ^%DT S SPNSDT=Y
        K Y,Y
        ;ONLY THE BEGINNING DATE IS PASSED IN.  COLLECT DATA FROM THAT DATE UP TO THE CURRENT DATE.
        K ^TMP($J)
        K ^TMP("SPN",$J)
        K SPNITEM
        ;***************************
        S LRDFN=$$LRDFN^LRPXAPIU(DFN) Q:LRDFN'>0
        F  D  Q:'MORE
         . D RESULTS^LRPXAPI(.SPNITEM,DFN,"M",,.MORE,,SPNSDT,SPNEDT)
         . M ^TMP("SPN",$J)=SPNITEM
        K SPNITEM
        ;
        S SPNCNT=0
        S SPNXX=0 F A=1:1 S SPNXX=$O(^TMP("SPN",$J,SPNXX)) Q:SPNXX=""  D
        .S SPNDATA=$G(^TMP("SPN",$J,SPNXX))
        .S X=$P(SPNDATA,U,1)
        .S SPNARRY(X)=SPNDATA
        K SPNXX,SPNDATAM,SPNITEM
        ;AT THIS POINT ARRAY ONLY CONTAINS THE TOP LEVEL DATA FOR THE TESTS DONE
        S SPNTEST=0 F  S SPNTEST=$O(SPNARRY(SPNTEST)) Q:SPNTEST=""  D
        .S SPNDATA=$G(SPNARRY(SPNTEST))
        .S SPNCNT=0
        .S SPNRDTE=$P(SPNDATA,";",5)
        .S X=$P($$REFVAL^LRPXAPI("LRDFN;MI;SPNRDTE;1"),U,5)  ;sputum screen
        .Q:X=""
        .S SPNSPUT=$G(X) K X
        .S Y=$P($$REFVAL^LRPXAPI("LRDFN;MI;SPNRDTE;0"),U,1) D DD^%DT  ;record date
        .S SPNXDT=Y K X,Y  ;sputum screen date
        .;
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,"UTIL",SPNRDTE,"A",SPNCNT)="BOR999"_U_SPNXDT_U_SPNSPUT_"^EOL999"
KILL    ;
        K DFN,LRDFN,MORE,SPNSDT,SPNEDT,ICN,SPNITEM,SPNCNT,SPNXX,SPNARRY,SPNDATA,SPNTEST,SPNRDTE,X,Y,SPNSPUT,SPNXDT
        K %DT,A
        Q
