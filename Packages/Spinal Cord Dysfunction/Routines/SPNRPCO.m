SPNRPCO ;SD/WDE - Returns Lab test results for MICROBIOLOGY;JUL 23, 2008
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ;   INTEGRATION REFERENCE INQUIRY #4245
        ;   INTEGRATION REFERENCE INQUIRY #4246 ;
        ;
        ;
        ;     dfn is ien of the pt
        ;     cutdate is the date to start collection data from
        ;     root is the sorted data in latest date of test first
        ;  loops through the lr file and looks at these specific subscripts
        ;              "MI"
        ;
COL(ROOT,ICN,SPNSDT)    ;
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
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:DFN=""
        S LRDFN=$$LRDFN^LRPXAPIU(DFN)
        F  D  Q:'MORE
         . D RESULTS^LRPXAPI(.SPNITEM,DFN,"M",,.MORE,,SPNSDT,SPNEDT)
         . M ^TMP("SPN",$J)=SPNITEM
        K SPNITEM
        ;
        S SPNXX=0 F A=1:1 S SPNXX=$O(^TMP("SPN",$J,SPNXX)) Q:SPNXX=""  D
        .S TSTDATA=$G(^TMP("SPN",$J,SPNXX))
        .S X=$P(TSTDATA,U,1)
        .S SPNARRY(X)=TSTDATA
        .;AT THIS POINT ARRAY ONLY CONTAINS THE TOP LEVEL DATA FOR THE TESTS DONE
        S SPNTEST=0 F  S SPNTEST=$O(SPNARRY(SPNTEST)) Q:SPNTEST=""  D
        .S SPNDATA=$G(SPNARRY(SPNTEST))
        .S SPNCNT=0
        .S RDATE=$P(SPNDATA,";",5)
        .K SITPC
        .S SITPC=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;0"),U,5)
        .S SITESPEC=$$SPECNM^LRPXAPIU(SITPC)
        .;Q:SITESPEC'["URINE"
        .S ACCES=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;0"),U,6)
        .S Y=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;0"),U,10) D DD^%DT S DATTAKE=Y
        .;
        .;
        .S X=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;0"),U,11) S COLSAMP=$$GET1^DIQ(62,X_",",.01)
        .I COLSAMP="" S COLSAMP="ERROR ON COLSAMP"
        .S REPTYPE=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;1"),U,2)
        .;S REPTYPE=$S(REPTYPE="P":"Preliminary",REPTYPE="F":"Final",1:"-----")
        .S Y=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;1"),U,1) D DD^%DT
        .S REPORDT=Y K X,Y
        .;
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,"UTIL",RDATE,"A",SPNCNT)="BOR999"_U_DATTAKE_U_ACCES_U_COLSAMP_U_SITESPEC_U_REPTYPE_U_REPORDT_U_"LR("_RDATE_U_"EOL999"
        .D BACTXT
        .D GRAM
KILL    ;
        K A,ICN,ACCES,B,COLSAMP,DATTAKE,DFN,LRDFN,MORE,RDATE
        K REPORDT,REPTYPE,SITESPEC,SPNCNT,SPNCT,SPNDATA,SPNEDT
        K SPNGRM,SPNTEST,SPNTXT,SPNX,SPNXX,TSTDATA,C,%DT
        Q
GRAM    ;
        ;now build the organism tests for this record date
        S SPNX=0
        S SPNGRM=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;2,0"),U,3)
        F A=1:1:SPNGRM D
        .S X=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;2,A,0"),U,1)
        .Q:X=""
        .S SPNX=SPNX+1 S ^TMP($J,"UTIL",RDATE,"CC",SPNX)="BOG999^"_X_U_"EOL999"
        Q
BACTXT  ;----------
        ;build the BAC TEST REMARKS
        S SPNX=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;4,0"),U,3)  ;number of lines
        S SPNCT=0
        S SPNCT=SPNCT+1 S ^TMP($J,"UTIL",RDATE,"AA",SPNCT)="BOB999^EOL999"
        F B=1:1:SPNX D 
        .S SPNTXT=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;4,B,0"),U,1) D
        ..Q:SPNTXT=""
        ..S SPNCT=SPNCT+1 S ^TMP($J,"UTIL",RDATE,"AA",SPNCT)=SPNTXT_U_"EOL999"
        Q
