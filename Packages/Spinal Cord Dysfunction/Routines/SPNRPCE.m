SPNRPCE ;SD/WDE - Returns MICROBIOLOGY URINE Lab test results;JUL 23, 2008
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ;   INTEGRATION REFERENCE INQUIRY #2210
        ;   INTEGRATION REFERENCE INQUIRY #10060  VA(200
        ;   INTEGRATION REFERENCE INQUIRY #4245
        ;   INTEGRATION REFERENCE INQUIRY #4246
        ;    
        ;
        ;     dfn is ien of the pt
        ;     cutdate is the date to start collection data from
        ;     root is the sorted data in latest date of test first
        ;
COL(ROOT,ICN,SDATE)     ;
        K ^TMP($J)
        K ARRAY
        S ROOT=$NA(^TMP($J))
        ;***************************
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:DFN=""
        ;****************************
        ;NEWT(ROOT,ICN,SDATE,EDATE)     ;
        D NOW^%DTC S EDATE=X
        S X=SDATE S %DT="T" D ^%DT S SDATE=Y
        ;ONLY THE BEGINNING DATE IS PASSED IN.  COLLECT DATA FROM THAT DATE UP TO THE CURRENT DATE.
        K ^TMP($J)
        K ^TMP("SPN",$J)
        K ITEMS
        ;***************************
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:DFN=""
        ;
        S LRDFN=$$LRDFN^LRPXAPIU(DFN)  ;
        F  D  Q:'MORE
         . D RESULTS^LRPXAPI(.ITEMS,DFN,"M",,.MORE,,SDATE,EDATE)
         . M ^TMP("SPN",$J)=ITEMS
        K ITEMS
        ;
        S SPNXX=0 F A=1:1 S SPNXX=$O(^TMP("SPN",$J,SPNXX)) Q:SPNXX=""  D
        .S TSTDATA=$G(^TMP("SPN",$J,SPNXX))
        .S X=$P(TSTDATA,U,1)
        .S ARRAY(X)=TSTDATA
        .;AT THIS POINT ARRAY ONLY CONTAINS THE TOP LEVEL DATA FOR THE TESTS DONE
        S SPNTEST=0 F  S SPNTEST=$O(ARRAY(SPNTEST)) Q:SPNTEST=""  D
        .S TSTDATA=$G(ARRAY(SPNTEST))
        .S SPNCNT=0
        .S RDATE=$P(TSTDATA,";",5)
        .K SITPC
        .S SITPC=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;0"),U,5)
        .S SITESPEC=$$SPECNM^LRPXAPIU(SITPC)
        .Q:SITESPEC'["URINE"
        .S ACCES=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;0"),U,6)
        .S Y=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;0"),U,10) D DD^%DT S DATTAKE=Y
        .;
        .;
        .S X=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;0"),U,11) S COLSAMP=$$GET1^DIQ(62,X_",",.01)
        .I COLSAMP="" S COLSAMP="ERROR ON COLSAMP"
        .S REPTYPE=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;1"),U,2)
        .S REPTYPE=$S(REPTYPE="P":"Preliminary",REPTYPE="F":"Final",1:"-----")
        .S Y=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;1"),U,1) D DD^%DT
        .S REPORDT=Y K X,Y
        .;
        .;
        .;
        .S X=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;0"),U,7)
        .S PROVIDER=$$GET1^DIQ(200,X_",",.01)
        .;
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,"UTIL",RDATE,"A",SPNCNT)="BOR999"_U_ACCES_U_DATTAKE_U_COLSAMP_U_REPTYPE_U_REPORDT_U_SITESPEC_U_PROVIDER_U_"LR("_LRDFN_","_RDATE_U_"EOL999"
        .;
        .;
        .D BACT  ;STILL NEED TO RESOLVE THE ISSUE THAT THERE IS NOT ANY DATA AT THIS LEVEL
        .D ORG
        .D BACTXT
        .;
KILL    ;
        K %DT,A,ACCE,B,COLSAMP,DATTAKE,DFN,EDATE,ICN,ITEMS,LINECT,ACCES,SITESPEC
        K LRDFN,MORE,ORGNAM,ORIEN,ORNUM,ORTEXT,ORTXIEN,ORTXLI,PROVIDER
        K RDATE,REPORDT,REPTYPE,SDATE,SITESPE,SITPC,SPNCNT,SPNTEST,SPNXX
        K SUBCNT,TEXT,TSTDATA,TXTCNT,VALUE
        Q
ORG     ;
        ;now build the organism tests for this record date
        S SUBCNT=0
        S ORNUM=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;3,0"),U,4)
        S ORIEN="" F A=1:1:ORNUM D  ;S ORIEN=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;3,A,0"),U,1) D:$G(ORIEN)
        .S X=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;3,A,0"),U,1,2)
        .Q:X=""
        .S Y=$P(X,U,1) S ORGNAM=$$BUGNM^LRPXAPIU(X)
        .S VALUE=$P($G(X),U,2)
        .S SUBCNT=SUBCNT+1 S ^TMP($J,"UTIL",RDATE,"C",SUBCNT)="ORGANISM999^"_ORGNAM_U_VALUE_U_"EOL999"
        .;build the organism text for this organism
        .S ORTXLI=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;3,A,1,0"),U,3)  ;number of lines for this organism
        .S TXTCNT=0
        .S ORTXIEN=0 F B=1:1:ORTXLI S ORTEXT=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;3,A,1,B,0"),U,1) D
        ..S TXTCNT=TXTCNT+1 S ^TMP($J,"UTIL",RDATE,"C",A,SUBCNT,TXTCNT)="TXT999^"_ORTEXT_U_"EOL999"
        Q
        ;
        ;
BACT    ;
        ;now build the BACT tests for this record date
        S SUBCNT=0
        S LINECT=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;26,0"),U,3)
        F A=1:1:LINECT D  ;S ORIEN=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;3,A,0"),U,1) D:$G(ORIEN)
        .S X=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;26,A,0"),U,1)
        .Q:X=""
        .;S Y=$P(X,U,1) S ORGNAM=$$BUGNM^LRPXAPIU(X)
        .;S VALUE=$P($G(X),U,2)
        .S SUBCNT=SUBCNT+1 S ^TMP($J,"UTIL",RDATE,"B",SUBCNT)="BACTTEST999^"_X_U_"EOL999"
        Q
BACTXT  ;----------   DONT THINK THAT THERE ANY REMAKS WITH EACH ONE WILL LOOK
        ;build the BAC TEST REMARKS
        S X=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;4,0"),U,3)  ;number of lines
        S TXTCNT=0
        F B=1:1:X D
        .S TEXT=$P($$REFVAL^LRPXAPI("LRDFN;MI;RDATE;4,B,0"),U,1) D
        ..Q:TEXT=""
        ..S TXTCNT=TXTCNT+1 S ^TMP($J,"UTIL",RDATE,"D",TXTCNT)="BACT_REMARKS999^"_TEXT_U_"EOL999"
        ..Q
        .Q
        Q
