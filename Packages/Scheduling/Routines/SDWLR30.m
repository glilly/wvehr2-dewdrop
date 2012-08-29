SDWLR30 ;BPOI/TEH - WAIT LIST REPORT 30/120 (PCMM);06/12/2002
        ;;5.3;scheduling;**524**;AUG 13 1993;Build 29
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        Q
EN      ;ENTRY POINT
        N ZCODE,ZTDESC,ZTDTH,ZTIO,ZTQUEDED,ZTREQ,ZTRTN,ZTSAVE,ZTSK
        N SDTEAM,SDHIST,SDACTIVE
        D HD
1       S SDWLINST="",SDWLERR=0,SDWLE=0 K ^TMP("SDWLR30",$J),DIC,DIR,DR,DIE
        D INS G END:SDWLERR
2       D OPEN G 1:SDWLERR
        S ^TMP("SDWLR30",$J,"DATE")=""
3       D DATE G 2:SDWLERR
        D QUE
        Q
INS     ;Get Institution
        S (DIC("B"),DIR("B"))="ALL",SDWLERR=0
IN1     W ! S DIR("A")="Institution",DIR(0)="F^1:30" D ^DIR
        I Y="All"!(Y="")!(Y="all")!(Y="ALL") S ^TMP("SDWLR30",$J,"INS")=Y Q
        I Y["^" S SDWLERR=1 Q
        S DIC("S")="I $$GET1^DIQ(4,+Y_"","",11,""I"")=""N"",$$TF^XUAF4(+Y)"
        S X=Y,DIC(0)="EMNZQ",DIC=4 D ^DIC G IN1:Y<0 S SDWLINS=Y
        I X="^",'$G(SDWLINST) S SDWLERR=1 Q
        I Y<0,'$G(SDWLINST) S SDWLERR=1
        Q:SDWLINS=""  S SDWLINST=SDWLINST_SDWLINS_";",SDWLINST(SDWLINS)=""
        S ^TMP("SDWLR30",$J,"INS")=SDWLINST,^TMP("SDWLR30",$J,"INS",SDWLINS)=""
        G IN1:Y<0,END:$D(DUOUT)
        S DIR("B")="NO",DIR("A")="Select Another Institution",DIR(0)="Y" D ^DIR
        I Y K DIR("B") G IN1
IN3     K DIR,DIC,SDWLINST,SDWLINS,X,Y
        Q
OPEN    ;OPEN Wait List Entries  
        S %=1,SDWLERR=0 W !!,"Do you want only 'OPEN' Wait List Entries " D YN^DICN
        I '% W *7,"Must Enter 'YES' or 'NO'." G OPEN
        I %=-1 S SDWLERR=1
        S ^TMP("SDWLR30",$J,"OPEN")=$S(%=1:"O",1:"OC")
        Q
DATE    ;Date range selection
        S %=1 W !!,"Print Report for ALL dates? " D YN^DICN
        I %=1 S ^TMP("SDWLR30",$J,"DATE")="ALL" G E1
        Q:%=0
        I %=-1 S SDWLERR=1 Q
        S SDWLERR=0 W ! S %DT="AE",%DT("A")="Start with Date Entered: " D ^%DT
        I Y<1 S SDWLERR=1 Q
        S SDWLBDT=Y
        S %DT(0)=SDWLBDT,%DT("A")="End with Date Entered: " D ^%DT
        I X["^" S SDWLERR=1 Q
        G E1:Y<1 S SDWLEDT=Y K %DT(0),%DT("A")
        I SDWLEDT<SDWLBDT W !,"Beginning Date must be greater than Ending Date." G DATE
        S ^TMP("SDWLR30",$J,"DATE")=SDWLBDT_"^"_SDWLEDT Q
E1      Q
QUE     ;Queue Report
        N ZTQUEUED,POP S ^TMP("SDWLR30","JOB")=$J
        K %ZIS,IOP,IOC,ZTIO,SDWLSPT S %ZIS="MQ" D ^%ZIS I POP W " NOT QUEUED" G END
        S ZTRTN="EN^SDWLR31",ZTDTH=$H,ZTDESC="WAIT LIST 30/120 REPORT"
        S SDWLTASK="" F  S SDWLTASK=$O(^TMP("SDWLR30",$J,SDWLTASK)) Q:SDWLTASK=""  D
        .S SDWLTK=$G(^TMP("SDWLR30",$J,SDWLTASK))
        .S ZTSAVE(SDWLTASK)=SDWLTK
        I $D(IO("Q")) K IO("Q") D ^%ZTLOAD W !,"REQUEST QUEUED" G END
QUE1    S:$E(IOST,1,2)="C-" SDWLSPT=1 I $D(ZTRTN) U IO D @ZTRTN K SDWLSPT
        ;
END     K SDWLTASK,SDWLY,SDWLED,WDWLBD,SDWLOPEN,SDWLDATE,SDWLFORM,SDWLPRI
        K DIR,DIC,DR,DIE,SDWLSPT,I
        D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
        K DUOUT,SDWLBDT,SDWLE,SDWLEDT,SDWLERR,SDWLTK
        Q
HD      W:$D(IOF) @IOF W !,?80-$L("EWL Under 30/Over 30/120 Day Wait List Report")\2,"EWL Under 30/Over 30/120 Day Wait List Report"
