GMRAFDA3        ;HIRMFO/WAA-DISPLAY FDA REPORT OVER DT RANGE ;12/1/95  11:34
        ;;4.0;Adverse Reaction Tracking;**33**;Mar 29, 1996;Build 5
EN1     ; Entry for PRINT ALL FDA EVENTS WITHIN D/T RANGE option
        S GMRAOUT=0 K DIR
        S DIR(0)="DO^:NOW:EXT",DIR("A")="Select Start Date/Time"
        D ^DIR K DIR
        I $D(DIRUT) G EXIT
        S GMRABGDT=Y K Y
        S DIR(0)="DO^"_GMRABGDT_":NOW:EXT",DIR("A")="Select End Date/Time",DIR("B")="T"
        D ^DIR K DIR
        I $D(DIRUT) G EXIT
        S GMRAENDT=Y K Y
EN2     ;
        S GMRABGDT=GMRABGDT-.0000001
        S GMRAENDT=$S($P(GMRAENDT,".",2)="":GMRAENDT_".24",1:(GMRAENDT+.000001))
YN      F  S %=1 W !,"Do you want an Abbreviated report" D YN^DICN S:%=-1 %=2,GMRAOUT=1 Q:%  W !,"ENTER ""Y"" FOR YES OR ""N"" FOR NO",$C(7)
        G:GMRAOUT EXIT
        S GMRAYN=%
PRINTER ;Select printer
        S GMRAOUT=0,GMRAPG=0
        W ! K GMRAZIS S:GMRAYN=2 GMRAZIS="QM132S60" D DEV^GMRAUTL I POP W !,"PLEASE TRY LATER" G EXIT
        I $D(IO("Q")) D  G EXIT
        .S ZTRTN="PRINT^GMRAFDA3",ZTSAVE("GMRAPG")="",ZTSAVE("GMRAOUT")="",ZTSAVE("GMRABGDT")="",ZTSAVE("GMRAENDT")="",ZTSAVE("GMRAYN")=""
        .S ZTDESC="Print FDA Report by Date/Time" D ^%ZTLOAD
        .W !!,$S($D(ZTSK):"Request queued...",1:"Request NOT queued please try later...")
        .Q
        U IO D PRINT U IO(0)
        D CLOSE^GMRAUTL
        G EXIT
        Q
PRINT   ;Central Print
        N GMRACNT S GMRACNT=0
        S GMRAFLG=0,GMRANOW=$$NOW^XLFDT,GMRANOW=$$FMTE^XLFDT(GMRANOW,"1")
        I IOST?1"C".E W @IOF
        I GMRAYN=1 D HDR1
        F  S GMRABGDT=$O(^GMR(120.85,"B",GMRABGDT)) Q:GMRABGDT<1!(GMRABGDT>GMRAENDT)!(GMRAOUT)  S GMRAPA1=0 F  S GMRAPA1=$O(^GMR(120.85,"B",GMRABGDT,GMRAPA1)) Q:GMRAPA1<1  D  Q:GMRAOUT
        .I +$P($G(^GMR(120.8,+$P($G(^GMR(120.85,+GMRAPA1,0)),U,15),"ER")),U,1)=1 Q
        .I GMRAYN=2 D PRT^GMRAFDA1 Q
        .I $Y>(IOSL-3) D HEAD Q:GMRAOUT
        .S GMRAPA1(0)=$G(^GMR(120.85,GMRAPA1,0)) Q:GMRAPA1(0)=""
        .S GMRAPA(0)=$G(^GMR(120.8,$P(GMRAPA1(0),U,15),0)) Q:GMRAPA(0)=""
        .S DFN=$P(GMRAPA(0),U) D PID^VADPT6
        .Q:'$$PRDTST^GMRAUTL1(DFN)  ;GMRA*4*33  Exclude test patient from report if production or legacy environment.
        .S GMRACNT=GMRACNT+1
        .W !,$E($P(^DPT(DFN,0),U),1,23)," (",VA("PID"),")" K VA,DFN
        .W ?32,$E($P(GMRAPA(0),U,2),1,28)
        .W ?62 S Y=$P(GMRAPA1(0),U),Y=$$DATE^GMRAUTL1(Y) W $P(Y,":",1,2) K Y
        .I $P($G(^GMR(120.85,GMRAPA1,"PTC1")),U,5) D
        ..W !,?5,"(SENT TO FDA: " S Y=$P(^GMR(120.85,GMRAPA1,"PTC1"),U,5),Y=$$DATE^GMRAUTL1(Y) W $P(Y,":",1,2),")" K Y
        .Q
        .K GMRAPA1(0),GMRAPA(0)
        .Q
        I 'GMRACNT W !,?30,"NO DATA FOR THIS REPORT"
        Q
HEAD    ;Header Print
HDR     ;
        I IOST?1"C".E K DIR S DIR(0)="E" D ^DIR K DIR I Y'>0 S GMRAOUT=1 Q
        W @IOF
HDR1    S GMRAPG=GMRAPG+1
        W GMRANOW,?70,"Page: ",GMRAPG
        W !,?30,"FDA ABBREVIATED REPORT"
        W !,"PATIENT",?32,"SUSPECTED AGENT",?62,"D/T OF EVENT"
        W !,$$REPEAT^XLFSTR("-",79),!
        Q
EXIT    ;EXIT
        K ^TMP($J,"GMRAEF")
        D KILL^XUSCLEAN
        Q
