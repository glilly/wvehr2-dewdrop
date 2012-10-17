ONCOPMA ;Hines OIFO/GWB [MA Print QA/Multiple Abstracts] ;12/13/99
        ;;2.11;ONCOLOGY;**6,25,44,46,47,49**;Mar 07, 1995;Build 38
        ;
EN      ;Select Report Type
        K DIR S DIR("A")=" Select Report"
        S DIR(0)="SO^1:QA Abstract;2:Extended Abstract (80c);3:Complete Abstract (132c);4:Incidence Report;5:Print PCE Data"
        D ^DIR
        G EX:Y[U,EX:Y=""
        I Y'=5 S PRINT="PRT"_Y_"^ONCOPMP"
        K DIR
        ;
OP      ;Select option
        I Y=5 D PCEPRT2^ONCOGEN Q
        S DIR(0)="SO^1:All abstracts, One PATIENT;2:All abstracts, One SITE/GP;3:All abstracts, One or more ACCESSION YEAR(s), One SITE/GP;4:All abstracts, One ACCESSION YEAR;5:Complete Abstracts by DATE DX;6:QA - 10% Complete abstracts"
        S DIR("A")="     Select Option"
        W ! D ^DIR G EX:Y[U,EX:Y=""
        G @Y:Y<4,Y^ONCOPMB
        ;
1       ;[MA Print QA/Multiple Abstracts - 1 All abstracts, One PATIENT]
        W ! S DIC("A")=" Select PATIENT: "
        S DIC="^ONCO(160,",DIC(0)="AEMQ" D ^DIC G EX:Y<0 S ONCOXD1=+Y
        I PRINT["PRT3" D ESPD^ONCOGEN I ESPD[U K ESPD Q
        S %ZIS="Q" W ! D ^%ZIS I POP S ONCOUT="" G EX
        S ONCOION=ION,ONCIOST=IOST
        I '$D(IO("Q")) D TK1^ONCOPMA G EX
        S ZTRTN="TK1^ONCOPMA"
        S ZTSAVE("ONCOION")=""
        S ZTSAVE("ONCIOST")=""
        S ZTSAVE("ONCOXD1")=""
        S ZTSAVE("PRINT")=""
        S ZTSAVE("ESPD")=""
        S ZTDESC="All abstracts, One PATIENT"
        D ^%ZTLOAD
        G EX
        ;
TK1     S ONCOXD0=0
        F  S ONCOXD0=$O(^ONCO(165.5,"C",ONCOXD1,ONCOXD0)) Q:ONCOXD0'>0  I $$DIV^ONCFUNC(ONCOXD0)=DUZ(2) D  I ONCIOST?1"C".E W ! K DIR S DIR(0)="E",DIR("A")="Enter RETURN to go to next abstract or '^' to exit" D ^DIR Q:'Y
        .S (NUMBER,ONCODA)=ONCOXD0
        .S IOP=ONCOION
        .W @IOF
        .D @PRINT
        .I PRINT["PRT1" D
        ..S IOP=ONCOION
        ..D 8^ONCOPMP
        G EX
        ;
2       ;[MA Print QA/Multiple Abstracts - 2 All Abstracts, One SITE/GP]
        W ! S DIC("A")=" Select SITE/GP: "
        S DIC="^ONCO(164.2,",DIC(0)="AEQM" D ^DIC G EX:Y<0 S ONCOXD1=+Y
        I PRINT["PRT3" D ESPD^ONCOGEN I ESPD[U K ESPD Q
        S %ZIS="Q" W ! D ^%ZIS I POP S ONCOOUT="" G EX
        S ONCOION=ION,ONCIOST=IOST
        I '$D(IO("Q")) D TK2^ONCOPMA G EX
        S ZTRTN="TK2^ONCOPMA"
        S ZTSAVE("ONCOXD1")=""
        S ZTSAVE("ONCOION")=""
        S ZTSAVE("ONCIOST")=""
        S ZTSAVE("PRINT")=""
        S ZTSAVE("ESPD")=""
        S ZTDESC="All Abstracts, One SITE/GP"
        D ^%ZTLOAD G EX
        ;
TK2     S ONCOXD0=0
        F  S ONCOXD0=$O(^ONCO(165.5,"B",ONCOXD1,ONCOXD0)) Q:ONCOXD0'>0  I $$DIV^ONCFUNC(ONCOXD0)=DUZ(2) D  I ONCIOST?1"C".E W ! K DIR S DIR(0)="E",DIR("A")="Enter RETURN to go to next abstract or '^' to exit" D ^DIR Q:'Y  W @IOF
        .S (NUMBER,ONCODA)=ONCOXD0
        .S IOP=ONCOION
        .D @PRINT
        .I PRINT["PRT1" D
        ..S IOP=ONCOION
        ..D 8^ONCOPMP
        G EX
        ;
3       ;[MA Print QA/Multiple Abstracts - 3 All abstracts, ACCESSION YEAR(s), One SITE/GP]
        S Y=3 D TF^ONCOST G EX:Y[U
        S DIC("A")="     Select SITE/GP: "
        S DIC(0)="AEQZ",DIC="^ONCO(164.2," D ^DIC G EX:Y<0,EX:Y=U S ONCOXD1=+Y
        I PRINT["PRT3" D ESPD^ONCOGEN I ESPD[U K ESPD Q
        S %ZIS="Q" W ! D ^%ZIS I POP S ONCOUT="" G EX
        S ONCOION=ION,ONCIOST=IOST
        I '$D(IO("Q")) D TK3^ONCOPMA G EX
        S ZTRTN="TK3^ONCOPMA"
        S ZTSAVE("ONCOXD1")=""
        S ZTSAVE("ONCOION")=""
        S ZTSAVE("ONCIOST")=""
        S ZTSAVE("PRINT")=""
        S ZTSAVE("ONCOS*")=""
        S ZTSAVE("ESPD")=""
        S ZTDESC="All abstracts, One or more ACCESSION YEAR(s), One SITE/GP"
        D ^%ZTLOAD G EX
        ;
TK3     N ONCOXD0,SY,EY
        S ONCOXD0=0
        S SY=$S(ONCOS("YR")="ALL":0,1:$P(ONCOS("YR"),U,1)-1)
        S EY=$S(ONCOS("YR")="ALL":9999,1:$P(ONCOS("YR"),U,2))
        F  S SY=$O(^ONCO(165.5,"AY",SY)) Q:(SY'>0)!(SY>EY)!($G(Y)=0)  F  S ONCOXD0=$O(^ONCO(165.5,"AY",SY,ONCOXD0)) Q:ONCOXD0'>0  I $$DIV^ONCFUNC(ONCOXD0)=DUZ(2),$P(^ONCO(165.5,ONCOXD0,0),U,1)=ONCOXD1 D  I ONCIOST?1"C".E W ! D ^DIR Q:'Y  W @IOF
        .S (NUMBER,ONCODA)=ONCOXD0
        .S IOP=ONCOION
        .D @PRINT
        .I ONCIOST?1"C".E K DIR S DIR(0)="E",DIR("A")="Enter RETURN to go to next abstract or '^' to exit"
        .I PRINT["PRT1" D
        ..S IOP=ONCOION
        ..D 8^ONCOPMP
        G EX
        ;
EX      ;KILL variables
        K ^TMP("ONCO",$J)
        K %ZIS,DIC,DIR,IOP,NUMBER,ONCIOST,ONCODA,ONCOION,ONCOOUT,ONCOS,ONCOUT
        K ONCOXD0,ONCOXD1,POP,PRINT,ZTDESC,ZTRTN,ZTSAVE
        D ^%ZISC
        Q
