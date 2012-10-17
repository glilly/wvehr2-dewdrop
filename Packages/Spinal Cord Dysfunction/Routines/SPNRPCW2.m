SPNRPCW2        ;SD/WDE - Returns INFLUENZA Lab test results "CH" NODE;JUL 28, 2008
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ;   INTEGRATION REFERENCE INQUIRY #4245
        ;   INTEGRATION REFERENCE INQUIRY #4246
        ;    
        ;    
        ;     dfn is ien of the pt
        ;     root is the sorted data in latest date of test first
        ;
        ;this routine is called from spnrpcw
        ;and is not meant to run alone
COL(ICN,SDATE,EDATE)    ;
        ;dates are converted in spnrpcw
        ;****************************
        ;K ASSES,CNT,CNT2,COL,COM,COMMET,DATA,DATA2,DFN,DTREPTAK,DTSPETAK,EDATE,FIELD,FIELD2,FIELDNA,ICN,LASTCNT,LRDFN,RDATE
        ;K SDATE,SPECTYP,SUB,SUBCNT,TST,Y
NEWT    ;
        K TESTS,ITEMS,ZZZ
        D TESTS^LRPXAPI(.TESTS,DFN,"C",,,,SDATE,EDATE)
        ;NOW STRIP OUT ALL TEST BUT THE INFLUENZA TEST
        S T=0 F  S T=$O(TESTS(T)) Q:T=""  I $P(TESTS(T),U,2)'["INFLUEN" K TESTS(T)
        ;NOW STRIP OUT ALL TEST BUT THE PARA INFLUENZA TEST
        S T=0 F  S T=$O(TESTS(T)) Q:T=""  I $P(TESTS(T),U,2)["PARA" K TESTS(T)
        ;PUGET ERROR TRAP DEFECT 1058 (NEXT LINE) - 12/27/07
        Q:$D(TESTS)'=11
        F  D  Q:'MORE
         . D RESULTS^LRPXAPI(.ITEMS,DFN,"C",,.MORE,,SDATE,EDATE)
         . M ^TMP("SPN",$J)=ITEMS
        K ITEMS  ;just whats in the table
        ;at this point we have the test and all of the patients test given now strip out the results we don't want
        ;based on the values of the test number compared to the tests(#)
        S SPNTEST=0 F  S SPNTEST=$O(^TMP("SPN",$J,SPNTEST)) Q:SPNTEST=""  D
        .S WHATEST=$P($G(^TMP("SPN",$J,SPNTEST)),U,2)
        .I $G(TESTS(WHATEST))="" K ^TMP("SPN",$J,SPNTEST)
        ;NOW GROUP THE DATES
        ;                          -2870206 1202")=2870206^1202^1^NEG^
        ;                     "-2870206 1558")=2870206^1558^1^^
        ;                    "-2870206 1559")=2870206^1559^1^^
        ;                     "-2870206 881")=2870206^881^1^NEG^
        ;                     "-2870227 1202")=2870227^1202^1^NEG^
        ;                    "-2870227 1558")=2870227^1558^1^^
        ;                     "-2870227 1559")=2870227^1559^1^^
        ;                      "-2870227 881")=2870227^881^1^NEG^
GROUP   ;
        S SPNCNT=0
        S ^TMP($J,"UTILB")="Beginning of CHEM"_U_"EOL999"
        K ARRAY
        S SPNTEST=0 F A=1:1 S SPNTEST=$O(^TMP("SPN",$J,SPNTEST)) Q:SPNTEST=""  D
        .S X=$P(^TMP("SPN",$J,SPNTEST),U,1)
        .S ARRAY(X)=$G(^TMP("SPN",$J,SPNTEST))
        .S ARRAY(X,A)=$G(^TMP("SPN",$J,SPNTEST))
        ;NOW DATES ARE GROUPED
        S COLTIME=0 F  S COLTIME=$O(ARRAY(COLTIME)) Q:COLTIME=""  D
        .K ZZZ D SPEC^LRPXAPI(.ZZZ,DFN,COLTIME,"A")
        .S ACCES=$P($G(ZZZ("S")),U,6)
        .S RDATE=$P($G(ZZZ("S")),U,1)
        .S Y=RDATE D DD^%DT S SHOWDT=Y
        .S Y=$P($G(ZZZ("S")),U,3) D DD^%DT S REPDATE=Y
        .S X=$P($G(ZZZ("S")),U,5)
        .I $G(X) S SITSPEC=$$SPECNM^LRPXAPIU(X)
        .I $G(SITSPEC)="" S SITSPEC="--"
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,"UTILB",-RDATE,"A",SPNCNT)="BOR999"_U_SHOWDT_U_REPDATE_U_SITSPEC_U_ACCES_U_"EOL999"
        .;
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,"UTILB",-RDATE,"B",SPNCNT)="BOS_INFLUENZA_TESTS"_U_"EOL999"
        .S ^TMP($J,"UTILB",-RDATE,"B",999999)="EOS_INFLUENZA_TESTS"_U_"EOL999"
        .S TST=0 F  S TST=$O(ARRAY(COLTIME,TST)) Q:TST=""  D
        ..S TSTNUM=$P($G(ARRAY(COLTIME,TST)),U,2) S TSTNAM=$$TESTNM^LRPXAPIU(TSTNUM)
        ..S VALUE=$P($G(ARRAY(COLTIME,TST)),U,4)
        ..S SPNCNT=SPNCNT+1
        ..S ^TMP($J,"UTILB",-RDATE,"B",SPNCNT)=TSTNAM_U_VALUE_U_"EOL999"
        .;
        .;get order tests
        .S LRIDT=$$LRIDT^LRPXAPIU(RDATE)
        .S ^TMP($J,"UTILB",-RDATE,"C",0)="BOS_TEST_ORDERED"_U_"EOL999"
        .S ^TMP($J,"UTILB",-RDATE,"C",99999)="EOS_TEST_ORDERED"_U_"EOL999"
        .S VIRLINE=$P($$REFVAL^LRPXAPI("LRDFN;CH;LRIDT;""ORUT"",0"),U,4)
        .S LINE=0 F LINE=1:1:VIRLINE S DATA=$$REFVAL^LRPXAPI("LRDFN;CH;LRIDT;""ORUT"",LINE,0") D
        ..S ^TMP($J,"UTILB",-RDATE,"C",LINE)=DATA_U_"EOL999"
        .;
        .;get comments
        .S SPNCNT=1
        .S ^TMP($J,"UTILB",-RDATE,"D",SPNCNT)="BOS_CHEM_COMMENTS"_U_"EOL999"
        .S ^TMP($J,"UTILB",-RDATE,"D",99999)="EOS_CHEM_COMMENTS"_U_"EOL999"
        .S COM="" F  S COM=$O(ZZZ("C",COM)) Q:COM=""  S SPNCNT=SPNCNT+1 S ^TMP($J,"UTILB",-RDATE,"D",SPNCNT)=$G(ZZZ("C",COM))_U_"EOL999"
        .S ^TMP($J,"UTILB",-RDATE,"D",999999)="EOR999"_U_"EOL999"
        .K ZZZ,VIRLINE,COM
        .Q
KILL    ;
        K ASSES,CNT,CNT2,COL,COM,COMMET,DATA,DATA2,DFN,DTREPTAK,DTSPETAK,EDATE,FIELD,FIELD2,FIELDNA,ICN,LASTCNT,LRDFN,RDATE
        K SDATE,SPECTYP,SUB,SUBCNT,TST,Y,ARRAY,LINE,LRIDT,COM,SPNCNT,RDATE,LRDFN
        K SDATE,EDATE,SUC,CNT,RDATE,LRDFN,SPUTSCEN,ASSES,COLSAMP,REVDT,DATREC
        K REPORDT,REPOTYP,SITESPEC,SPUTSCEN,VIROLSTA,PROVIDER,VIRUS,VIRUSNA
        K VIROIEN,VIROTST,VIRRPIEN,VIRORPT,DATA,SUBCNT,DFN
        K ASSES,CNT,CNT2,COL,COM,COMMET,DATA
        K DATA2,DFN,DTREPTAK,DTSPETAK,EDATE
        K FIELD,FIELD2,FIELDNA,LRDFN,RDATE
        K SPECTYP,SUB,SUBCNT,TST,Y
        K X,VIRUSIEN,VIROLDT,LASTCNT,DATTAKE,%DT,ACCES,FMDATE,LINE,MORE
        K SPNCNT,SPNTEST,TSTDATA,VIRLINE,VIRX,X1,X2,ZZ,A,COLTIME
        K REPDATE,SHOWDT,SITSPEC,SPNTEST,T,TSTNAM,TSTNUM,VALUE,WHATEST,X1,X2
        Q
