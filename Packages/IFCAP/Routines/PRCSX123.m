PRCSX123        ;RB-SET TRANSACTION SEQUENCE FOR ALL 9999 ENTRIES
V       ;;5.1;IFCAP;**123**;MAR 25, 2009;Build 6
        ;Per VHA Directive 2004-038, this routine should not be modified
        Q  ;STOPS TOP DOWN ENTRY
EN      ;For patch RMPR*3.0*151 testing only and only on test system
        ;Sets PRCS(410,"B" nodes for all 9999 entries for station,FY,fiscal qtr and FCP
        I $$PROD^XUPROD() W !,"Can ONLY be run on test/mirror system" Q
        W #,"The following process will set all unused transaction numbers through 9999 for"
        W !,"selected station, FY, FQ and FCP used when entering a Prosthetics GUI PO",!!
        S TOT=0
1       R !!,"ENTER STATION: ",PRCSTA:60 Q:PRCSTA=""!(PRCSTA["^")
2       R !!,"ENTER FISCAL YEAR (EX. 09): ",PRCFY:60 G 1:PRCFY=""!(PRCFY["^")
        I $L(PRCFY)'=2 W ?30,"FISCAL YEAR MUST BE 2 DIGITS" G 2
3       R !!,"ENTER FISCAL QUARTER (1-4): ",PRCFQ:60 G 2:PRCFQ=""!(PRCFQ["^")
        I "1234"'[PRCFQ!($L(PRCFQ)>1) W ?40,"INVALID FISCAL QUARTER, MUST BE 1-4" G 3
4       R !!,"ENTER FUND CONTROL POINT (FOR PROSTHETICS ORDERS): ",PRCFCP:60 G 3:PRCFCP=""!(PRCFCP["^")
        I '$D(^PRC(420,PRCSTA,1,+PRCFCP)) W ?40,"INVALID FCP USED" G 4
        S CHK=PRCSTA_"-"_PRCFY_"-"_PRCFCP
        I '$D(^PRCS(410.1,"B",CHK)) W !!,CHK,"IS NOT A VALID SEQUENCE START BASE POINT FOR FILE ^PRCS(410.1,""B"")",!,"** You MUST enter accurate station, FY and FCP that you will using when doing Prosthetics GUI PO" G 1
        S PRCSIEN=$O(^PRCS(410.1,"B",CHK,0)),PRCRSQSV=$P($G(^PRCS(410.1,PRCSIEN,0)),"^",2)
        F I=1:1:9998 D
        . S PRCSQ=$E("000",1,4-$L(I))_I
        . S PRCRSQ=PRCSTA_"-"_PRCFY_"-"_PRCFQ_"-"_PRCFCP_"-"_PRCSQ
        . I $D(^PRCS(410,"B",PRCRSQ)) W !,"** ALREADY USED: ",PRCRSQ Q
        . S ^PRCS(410,"B",PRCRSQ,111)="##",TOT=TOT+1
        . W !,"SET ^PRCS(410,""B"",",PRCRSQ,",111)=##"
        S PRCSIEN=$O(^PRCS(410.1,"B",PRCSTA_"-"_PRCFY_"-"_PRCFCP,"")) I PRCSIEN S $P(^PRCS(410.1,PRCSIEN,0),"^",2)=9998,$P(^PRCS(410.1,PRCSIEN,0),"^",5)=PRCRSQSV
        W !!,"** ALL 9999 SLOTS HAVE BEEN SET FOR REQ #: ",$P(PRCRSQ,"-",1,4),"  TOTAL SET = ",TOT
        W !!,"PATCH RMPR*3.0*151 MAY BE TESTED AT THIS POINT"
        K PRCSTA,PRCFY,PRCFQ,PRCFCP,I,PRCSQ,PRCRSQ,XX,CHK,PRCSIEN,PRCRSQSV,TOT
        Q
DEL     ;DELETE DUMMY ^PRCS(410,"B" ENTRIES CREATED FOR RMPR*3.0*151 TESTING
        I $$PROD^XUPROD() W !,"Can ONLY be run on test/mirror system" Q
        S IEN=0,PRCRSQ=0,TOT=0
        F  S PRCRSQ=$O(^PRCS(410,"B",PRCRSQ)),IEN=0 Q:PRCRSQ=""  D
        . F  S IEN=$O(^PRCS(410,"B",PRCRSQ,IEN)) Q:IEN=""  D
        .. S PRCREC=^PRCS(410,"B",PRCRSQ,IEN) Q:PRCREC'="##"
        .. W !,"KILLING ^PRCS(410,""B"",",PRCRSQ,",",IEN S HPRCRSQ=PRCRSQ,TOT=TOT+1
        .. K ^PRCS(410,"B",PRCRSQ,IEN)
        I TOT=0 G DQ
        S PRCRSQ=$P(HPRCRSQ,"-")_"-"_$P(HPRCRSQ,"-",2)_"-"_$P(HPRCRSQ,"-",4)
        S PRCSIEN=$O(^PRCS(410.1,"B",PRCRSQ,"")) I PRCSIEN S $P(^PRCS(410.1,PRCSIEN,0),"^",2)=$P(^PRCS(410.1,PRCSIEN,0),"^",5),$P(^PRCS(410.1,PRCSIEN,0),"^",5)=""
        W !!,"ALL ADDED (",TOT,") TESTING ENTRIES FOR REQ SERIES ",$P(HPRCRSQ,"-",1,4)," HAVE BEEN DELETED",!
DQ      K IEN,PRCRSQ,PRCSIEN,HPRCRSQ,TOT,PRCREC
        Q
