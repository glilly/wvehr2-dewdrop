GMRACMR4        ;HIRMFO/WAA-PATIENT NOT ASKED ABOUT ALLERGIES ;10/1/92
        ;;4.0;Adverse Reaction Tracking;**33**;Mar 29, 1996;Build 5
EN1     ;This is the main entry point for this program
        D EN1^GMRACMR G:GMRAOUT EXIT
DEV     ; *** Select output device, force queuing
        S GMRAZIS=""
        S:GMRASEL'="1," GMRAZIS="Q"
        W !! D DEV^GMRAUTL I POP S GMRAOUT=1 G EXIT
        I $D(IO("Q")) D  G EXIT
        . K IO("Q")
        . S ZTRTN="ENTSK^GMRACMR4"
        . S ZTSAVE("GMRA*")="",ZTSAVE("^TMP($J,")=""
        . S ZTDESC="List of patients without ID band or Chart marked"
        . D ^%ZTLOAD
        . W !!,$S($D(ZTSK):"Request queued...",1:"Request NOT queued please try later...")
        . Q
        E  D ENTSK
        Q
ENTSK   U IO
        D EN1^GMRACMR2,EN1^GMRACMR3
        S GMRAPAGE=0,X="NOW" D ^%DT S GMRAPDT=$$DATE^GMRAUTL1(Y)
        D SITE^GMRAUTL S GMRASITE=$G(^GMRD(120.84,GMRASITE,0))
        D PRINT
        G EXIT
PRINT   ;PRINT THE DATE
        D PRE^GMRAPNA
        S GMRAHLOC="" F  S GMRAHLOC=$O(^TMP($J,"GMRAWC","C",GMRAHLOC)) Q:GMRAHLOC=""  S GMRAX=0 Q:GMRAOUT  F  S GMRAX=$O(^(GMRAHLOC,GMRAX)) Q:GMRAX<1  D  Q:GMRAOUT
        .S GMRA=^TMP($J,"GMRAWC",GMRAX)
        .D HEAD Q:GMRAOUT
        .W !!,?10,$S(GMRA="W":"WARD",GMRA="M":"MODULE",GMRA="C":"CLINIC",1:"UNKNOWN"),": ",$P(^SC(GMRAX,0),U)
        .S GMRACNT=0
        .S GMRADATE=0 F  S GMRADATE=$O(^TMP($J,"GMRAWC",GMRAX,GMRADATE))  Q:GMRADATE=""  S (GMRAFLG,GMRADFN)=0 F  S GMRADFN=$O(^TMP($J,"GMRAWC",GMRAX,GMRADATE,GMRADFN)) Q:GMRADFN<1  D  Q:GMRAOUT
        ..Q:'$$PRDTST^GMRAUTL1(GMRADFN)  ;GMRA*4*33 Exclude test patient from report if production or legacy environment.
        ..S GMRAI=0 F  S GMRAI=$O(^GMR(120.8,"B",GMRADFN,GMRAI)) Q:GMRAI<1  D  Q:GMRAOUT
        ...Q:'$D(^GMR(120.8,GMRAI,0))  Q:$P($G(^GMR(120.86,GMRADFN,0)),U,2)'=1
        ...Q:$D(^GMR(120.8,GMRAI,"ER"))
        ...Q:$P(^GMR(120.8,GMRAI,0),U,2)=""
        ...S (GMRA("C"),GMRA("I"),GMRA("M"))=1
        ...I '$O(^GMR(120.8,GMRAI,13,0)) S (GMRA("C"),GMRA("M"))=0
        ...I GMRA'="W",GMRA("M") Q
        ...I GMRA="W",$P(GMRASITE,U,5)'=0,'$$IDMARK^GMRACMR5(GMRADFN,GMRADATE,GMRAI) S (GMRA("I"),GMRA("M"))=0
        ...I GMRA("M") Q
        ...S GMRACNT=GMRACNT+1
        ...W ! I GMRAFLG'=GMRADFN W $E($P(^DPT(GMRADFN,0),U),1,30) S (DFN,GMRAFLG)=GMRADFN S GMRAPID="" D VAD^GMRAUTL1(GMRADFN,"","","","","","","",.GMRAPID) W ?30,GMRAPID K GMRAPID
        ...W ?45,$E($P(^GMR(120.8,GMRAI,0),U,2),1,20)
        ...I GMRA="W" W ?66,$S(('GMRA("C")&'GMRA("I")):"ID BAND/CHART",('GMRA("C")):"CHART",('GMRA("I")):"ID BAND",1:"ERROR")
        ...E  W ?66,$S('GMRA("C"):"CHART",1:"ERROR")
        ...I $Y>(IOSL-4) D HEAD Q:GMRAOUT
        ...Q
        ..Q
        .D NOPAT^GMRAPNA
        .Q
        D CLOSE^GMRAUTL
        Q
HEAD    ;HEADER PAGE FOR PRINTOUT
        S GMRAPAGE=GMRAPAGE+1,GMRATL="" I $E(IOST,1)="C",GMRAPAGE=1 W @IOF
        I $E(IOST,1)="C",GMRAPAGE'=1 D  Q:GMRAOUT
        .S DIR(0)="E" D ^DIR I 'Y S GMRAOUT=1
        .K Y
        .Q
        W:GMRAPAGE'=1 @IOF
        W !,GMRAPDT,?22,"PATIENTS WITH UNMARKED ID BAND/CHART",?70,"PAGE ",GMRAPAGE
        I GMRASEL["1" S GMRATL="CURRENT INPATIENTS"
        I GMRASEL["2" S GMRATL=$S(GMRATL="":"OUTPATIENTS",1:GMRATL_" / OUTPATIENTS")
        I GMRASEL["3" S GMRATL=$S(GMRATL="":"NEW ADMISSIONS",1:GMRATL_" / NEW ADMISSIONS")
        W !,?(40-($L(GMRATL)/2)),GMRATL
        I (GMRASEL["2"!(GMRASEL["3")) W !,?22,"FROM ",$$DATE^GMRAUTL1(GMRAST),?43,"TO ",$$DATE^GMRAUTL1(GMRAED)
        W !!,"PATIENT",?30,"SSN",?45,"ALLERGY",?66,"UNMARKED"
        W !,$$REPEAT^XLFSTR("-",79)
        I $D(ZTQUEUED) S:$$STPCK^GMRAUTL1 GMRAOUT=1 ; Check if stopped by user
        Q
EXIT    ;
        K ^TMP($J,"GMRAWC")
        D KILL^XUSCLEAN
        Q
