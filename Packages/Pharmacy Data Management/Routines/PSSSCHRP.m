PSSSCHRP        ;BIR/RTR-Schedule Report ;07/03/07
        ;;1.0;PHARMACY DATA MANAGEMENT;**129**;9/30/07;Build 67
        ;Reference to DIC(42 supported by DBIA 10039
        ;
        ;
EN      ;Prompts for Administration File Schedule Report
        W !!,"This report displays entries from the ADMINISTRATION SCHEDULE (#51.1) File."
        W !,"It can be run for all Schedules, or only Schedules without a FREQUENCY"
        W !,"(IN MINUTES). Only schedules with a PSJ Package Prefix will be displayed, since"
        W !,"they are the only schedules the software will look at when deriving a FREQUENCY"
        W !,"(IN MINUTES) for the daily dosage checks. If a FREQUENCY (IN MINUTES) cannot",!,"be determined for an order, the daily dosage check cannot occur for that order."
        N DIR,PSSAFRP,PSSALONG,Y,X,DTOUT,DUOUT,DIRUT,DIROUT,IOP,%ZIS,POP,ZTRTN,ZTDESC,ZTSAVE,ZTSK
        K DIR,Y S DIR(0)="SO^A:All Schedules;O:Only Schedules with a missing frequency",DIR("A")="Print All Schedules, or Only Schedules without a frequency",DIR("B")="A"
        S DIR("?")=" ",DIR("?",1)=" ",DIR("?",2)="Enter 'A' to see all Administration Schedules, enter 'O' to see only",DIR("?",3)="those Administration Schedules without data in the FREQUENCY (IN MINUTES)"
        S DIR("?",4)="(#2) Field. A FREQUENCY (IN MINUTES) must be derived from a Schedule",DIR("?",5)="for the daily dosage check to occur for an order."
        W ! D ^DIR K DIR I $D(DUOUT)!($D(DTOUT)) D MESS K DIR,Y S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR Q
        I Y'="A",Y'="O" D MESS K DIR,Y S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR Q
        S PSSAFRP=Y
        K DIR,Y S DIR(0)="SO^80:80 Column;132:132 Column",DIR("A")="Print report in 80 or 132 column format",DIR("B")="80"
        S DIR("?")=" ",DIR("?",1)="Enter 80 to print the report in an 80 column format,",DIR("?",2)="Enter 132 to print the report in an 132 column format."
        W ! D ^DIR K DIR I $D(DUOUT)!($D(DTOUT)) D MESS K DIR,Y S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR Q
        I Y'="80",Y'="132" D MESS K DIR,Y S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR Q
        S PSSALONG=Y W !
        K IOP,%ZIS,POP S %ZIS="QM" D ^%ZIS I $G(POP)>0 D MESS K DIR,Y S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR,IOP,%ZIS,POP Q
        I $D(IO("Q")) S ZTRTN="START^PSSSCHRP",ZTDESC="Administration Schedule Report",ZTSAVE("PSSAFRP")="",ZTSAVE("PSSALONG")="" D ^%ZTLOAD K %ZIS W !!,"Report queued to print.",! K DIR,Y S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR Q
        ;
        ;
START   ;Print Administration Schedule File report
        U IO
        N PSSAFCT,PSSAFOUT,PSSAFDEV,PSSAFLIN,PSSAFQ,PSSAFQEN,PSSAFQS,PSSAFQL,PSSAFQQ,PSSAFQC,PSSAFAA,PSSAFAL,PSSWAS,PSSWASEN,PSSWASNM,PSSWASAD,PSSWASLL,PSSTPE
        N PSSAFRA,PSSAFRAA,PSSAFROP,PSSAFQL,PSSAFROO,PSSAFRFL,PSSWASX,PSSAFZZZ,PSSAFABC,PSSAFNOF
        S (PSSAFOUT,PSSAFNOF)=0,PSSAFDEV=$S($E(IOST,1,2)'="C-":"P",1:"C"),PSSAFCT=1
        K PSSAFLIN S:PSSALONG=132 $P(PSSAFLIN,"-",130)="" S:PSSALONG=80 $P(PSSAFLIN,"-",78)=""
        D HD
        S PSSAFQ="" F  S PSSAFQ=$O(^PS(51.1,"B",PSSAFQ)) Q:PSSAFQ=""!(PSSAFOUT)  D
        .F PSSAFQEN=0:0 S PSSAFQEN=$O(^PS(51.1,"B",PSSAFQ,PSSAFQEN)) Q:'PSSAFQEN!(PSSAFOUT)  D
        ..K PSSAFRA,PSSAFRAA,PSSAFROP,PSSAFQS,PSSAFROP,PSSAFROO,PSSAFQL,PSSWASX,PSSAFQC,PSSAFQQ
        ..S PSSAFRA=PSSAFQEN_","
        ..D GETS^DIQ(51.1,PSSAFRA,".01;1;2;4;8;8.1","E","PSSAFRAA")
        ..I $G(PSSAFRAA(51.1,PSSAFRA,4,"E"))'="PSJ" Q
        ..I PSSAFRP="O",$G(PSSAFRAA(51.1,PSSAFRA,2,"E")) Q
        ..S PSSAFNOF=1
        ..W !!,$G(PSSAFRAA(51.1,PSSAFRA,.01,"E"))
        ..I ($Y+5)>IOSL D HD Q:PSSAFOUT
        ..S PSSAFQS=$G(PSSAFRAA(51.1,PSSAFRA,1,"E"))
        ..W !?5,"STANDARD ADMINISTRATION TIMES: " D  K PSSAFAA Q:PSSAFOUT
        ...Q:PSSAFQS=""
        ...S PSSAFQL=$L(PSSAFQS)
        ...I PSSALONG=132 D  Q
        ....I PSSAFQL<96 D  Q
        .....W PSSAFQS
        .....I ($Y+5)>IOSL D HD Q:PSSAFOUT
        ....K PSSAFAA D FORMAT(PSSAFQS,96)
        ....S PSSAFRFL=0 F PSSAFAL=0:0 S PSSAFAL=$O(PSSAFAA(PSSAFAL)) Q:'PSSAFAL!(PSSAFOUT)  D
        .....W:'PSSAFRFL ?36,$G(PSSAFAA(PSSAFAL)) W:PSSAFRFL !?36,$G(PSSAFAA(PSSAFAL)) S PSSAFRFL=1
        .....I ($Y+5)>IOSL D HD Q:PSSAFOUT
        ...I PSSAFQL<44 D  Q
        ....W PSSAFQS
        ....I ($Y+5)>IOSL D HD Q:PSSAFOUT
        ...K PSSAFAA D FORMAT(PSSAFQS,44)
        ...S PSSAFRFL=0 F PSSAFAL=0:0 S PSSAFAL=$O(PSSAFAA(PSSAFAL)) Q:'PSSAFAL!(PSSAFOUT)  D
        ....W:'PSSAFRFL ?36,$G(PSSAFAA(PSSAFAL)) W:PSSAFRFL !?36,$G(PSSAFAA(PSSAFAL)) S PSSAFRFL=1
        ....I ($Y+5)>IOSL D HD Q:PSSAFOUT
        ..I ($Y+5)>IOSL D HD Q:PSSAFOUT
        ..W !?14,"OUTPATIENT EXPANSION: " D
        ...S PSSAFROP=$G(PSSAFRAA(51.1,PSSAFRA,8,"E"))
        ...I PSSALONG=132 D  Q
        ....I $L(PSSAFROP)<96 W PSSAFROP,! Q
        ....N X,DIWL,DIWR,DIWF S X=PSSAFROP,DIWL=37,DIWR=131,DIWF="W" K ^UTILITY($J,"W") D ^DIWP D ^DIWW K ^UTILITY($J,"W")
        ...I $L(PSSAFROP)<44 W PSSAFROP,! Q
        ...N X,DIWL,DIWR,DIWF S X=PSSAFROP,DIWL=37,DIWR=79,DIWF="W" K ^UTILITY($J,"W") D ^DIWP D ^DIWW K ^UTILITY($J,"W")
        ..I ($Y+5)>IOSL D HD Q:PSSAFOUT  W !
        ..W ?10,"OTHER LANGUAGE EXPANSION: " D
        ...S PSSAFROO=$G(PSSAFRAA(51.1,PSSAFRA,8.1,"E"))
        ...I PSSALONG=132 D  Q
        ....I $L(PSSAFROO)<96 W PSSAFROO,! Q
        ....N X,DIWL,DIWR,DIWF S X=PSSAFROO,DIWL=37,DIWR=131,DIWF="W" K ^UTILITY($J,"W") D ^DIWP D ^DIWW K ^UTILITY($J,"W")
        ...I $L(PSSAFROO)<44 W PSSAFROO,! Q
        ...N X,DIWL,DIWR,DIWF S X=PSSAFROO,DIWL=37,DIWR=79,DIWF="W" K ^UTILITY($J,"W") D ^DIWP D ^DIWW K ^UTILITY($J,"W")
        ..;Set PSSAFZZZ=0 if last write had a line feed, PSSAFZZZ=1 if last write did not have a line feed, to use for Schedule Type
        ..S PSSAFZZZ=0 I ($Y+5)>IOSL D HD S PSSAFZZZ=0 Q:PSSAFOUT
        ..S PSSAFRFL=0 F PSSWAS=0:0 S PSSWAS=$O(^PS(51.1,PSSAFQEN,1,PSSWAS)) Q:'PSSWAS!(PSSAFOUT)  D
        ...S PSSWASEN=$P($G(^PS(51.1,PSSAFQEN,1,PSSWAS,0)),"^") Q:'PSSWASEN
        ...S PSSWASX=PSSWAS_","_PSSAFQEN_"," S PSSWASNM=$$GET1^DIQ(51.11,PSSWASX,".01") Q:PSSWASNM=""
        ...;PSSARFRL=0 if last Write ended in Line Feed, =1 if Last Write dod not end in line feed, for writing Wards
        ...W:'PSSAFRFL ?30,"WARD: "_PSSWASNM W:PSSAFRFL !?30,"WARD: "_PSSWASNM S (PSSAFZZZ,PSSAFRFL)=1
        ...I ($Y+5)>IOSL D HD S (PSSAFZZZ,PSSAFRFL)=0 Q:PSSAFOUT
        ...W !?9,"WARD ADMINISTRATION TIMES: " S (PSSAFZZZ,PSSAFRFL)=1
        ...S PSSWASAD=$P($G(^PS(51.1,PSSAFQEN,1,PSSWAS,0)),"^",2)
        ...Q:PSSWASAD=""
        ...S (PSSWASLL,PSSAFQL)=$L(PSSWASAD)
        ...I PSSALONG=132 D  Q
        ....I PSSWASLL<96 D  Q
        .....W PSSWASAD S (PSSAFZZZ,PSSAFRFL)=1
        .....I ($Y+5)>IOSL D HD S (PSSAFZZZ,PSSAFRFL)=0 Q:PSSAFOUT
        ....K PSSAFAA D FORMAT(PSSWASAD,96)
        ....S PSSAFABC=0 F PSSAFAL=0:0 S PSSAFAL=$O(PSSAFAA(PSSAFAL)) Q:'PSSAFAL!(PSSAFOUT)  D
        .....W:'PSSAFABC ?36,$G(PSSAFAA(PSSAFAL)) W:PSSAFABC !?36,$G(PSSAFAA(PSSAFAL)) S PSSAFABC=1 S (PSSAFZZZ,PSSAFRFL)=1
        .....I ($Y+5)>IOSL D HD S (PSSAFZZZ,PSSAFRFL)=0 Q:PSSAFOUT
        ...I PSSWASLL<37 D  Q
        ....W PSSWASAD S (PSSAFZZZ,PSSAFRFL)=1
        ....I ($Y+5)>IOSL D HD S (PSSAFZZZ,PSSAFRFL)=0 Q:PSSAFOUT
        ...K PSSAFAA D FORMAT(PSSWASAD,44)
        ...S PSSAFABC=0 F PSSAFAL=0:0 S PSSAFAL=$O(PSSAFAA(PSSAFAL)) Q:'PSSAFAL!(PSSAFOUT)  D
        ....W:'PSSAFABC ?36,$G(PSSAFAA(PSSAFAL)) W:PSSAFABC !?36,$G(PSSAFAA(PSSAFAL)) S PSSAFABC=1 S (PSSAFZZZ,PSSAFRFL)=1
        ....I ($Y+5)>IOSL D HD S (PSSAFZZZ,PSSAFRFL)=0 Q:PSSAFOUT
        ..Q:PSSAFOUT
        ..K PSSAFAA
        ..I ($Y+5)>IOSL D HD S (PSSAFZZZ,PSSAFRFL)=0 Q:PSSAFOUT
        ..K PSSTPE S PSSTPE=$$GET1^DIQ(51.1,PSSAFQEN_",",5)
        ..W:'PSSAFZZZ ?21,"SCHEDULE TYPE: "_$G(PSSTPE) W:PSSAFZZZ !?21,"SCHEDULE TYPE: "_$G(PSSTPE)
        ..I ($Y+5)>IOSL D HD Q:PSSAFOUT
        ..W !?12,"FREQUENCY (IN MINUTES): "_$G(PSSAFRAA(51.1,PSSAFRA,2,"E"))
        ..I ($Y+5)>IOSL D HD Q:PSSAFOUT
        ;
END     ;
        I '$G(PSSAFOUT),PSSAFRP="O",'$G(PSSAFNOF) W !!,"No schedules found without frequencies.",!
        I $G(PSSAFDEV)="P"  W !!,"End of Report.",!
        I '$G(PSSAFOUT),$G(PSSAFDEV)="C" W !!,"End of Report." K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR
        I $G(PSSAFDEV)="C" W !
        E  W @IOF
        K PSSAFRP,PSSALONG
        D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
        Q
        ;
        ;
HD      ;Report Header
        I $G(PSSAFDEV)="C",$G(PSSAFCT)'=1 W ! K DIR,Y S DIR(0)="E",DIR("A")="Press Return to continue, '^' to exit" D ^DIR K DIR I 'Y S PSSAFOUT=1 Q
        W @IOF
        I PSSAFRP="A" W !,"ADMINISTRATION SCHEDULE FILE REPORT (All)"
        I PSSAFRP="O" W !,"ADMINISTRATION SCHEDULE WITHOUT FREQUENCY REPORT"
        W ?$S(PSSALONG=80:68,1:120),"PAGE: "_PSSAFCT,!,PSSAFLIN,! S PSSAFCT=PSSAFCT+1
        Q
        ;
        ;
MESS    ;
        W !!,"Nothing queued to print.",!
        Q
        ;
        ;
FORMAT(PSSAFQC,PSSAFQQ) ;Format print arrays, breaking on the "-" character
        ;PSSAFQC = Administration Times text
        ;PSSAFQQ = Character at which to break
        N PSSAFAC,PSSAFAB,PSSAFAZ,PSSAFAD,PSSAFAF,PSSAFAX
        S PSSAFAC=1,PSSAFAZ=0 K PSSAFAB
        F PSSAFAD=1:1:PSSAFQL I $E(PSSAFQC,PSSAFAD)="-" S PSSAFAB(PSSAFAC)=$P(PSSAFQC,"-",PSSAFAC)_"-" S PSSAFAC=PSSAFAC+1,PSSAFAZ=PSSAFAD+1
        I PSSAFAZ<PSSAFAD S:PSSAFAZ=0 PSSAFAZ=1 S PSSAFAB(PSSAFAC)=$E(PSSAFQC,PSSAFAZ,PSSAFQL) S PSSAFAC=PSSAFAC+1
        S PSSAFAF=1
        F PSSAFAX=1:1:PSSAFAC D
        .Q:'$D(PSSAFAB(PSSAFAX))
        .I '$D(PSSAFAA(PSSAFAF)) S PSSAFAA(PSSAFAF)=PSSAFAB(PSSAFAX) Q
        .I $L(PSSAFAA(PSSAFAF))+$L(PSSAFAB(PSSAFAX))<PSSAFQQ S PSSAFAA(PSSAFAF)=PSSAFAA(PSSAFAF)_PSSAFAB(PSSAFAX) Q
        .S PSSAFAF=PSSAFAF+1 S PSSAFAA(PSSAFAF)=PSSAFAB(PSSAFAX)
        Q
