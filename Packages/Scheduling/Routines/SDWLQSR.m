SDWLQSR ;BPOI/TEH - WAIT LIST STAT REPORT;06/12/02
        ;;5.3;scheduling;**263,425,448,524**;08/13/93;Build 29
        ;
        ;
        ;
        ;
        ;
EN      N ZCODE,ZTDESC,ZTDTH,ZTIO,ZTQUEDED,ZTREQ,ZTRTN,ZTSAVE,ZTSK,POP
        K ^TMP("SDWLQSR",$J)
        D HD
1       D INS G END:$D(DUOUT)
2       D DATE G END:$D(DUOUT)
3       D EXCL G END:$D(DUOUT)
        D QUE G END:$D(DUOUT)
        Q
INS     ;Get Institution
        S SDWLERR=0,SDWLPROM="Select Institution ALL // ",SDWLINST=""
IN      W ! S DIC(0)="QEMA",DIC("A")=SDWLPROM,DIC=4,DIC("S")="I $D(^SDWL(409.32,""C"",+Y))!$D(^SDWL(409.31,""E"",+Y))!$D(^SCTM(404.51,""AINST"",+Y))" D ^DIC I Y<0,'SDWLERR Q:$D(DUOUT)  S Y="ALL"
        G IN2:Y<0 Q:$D(DUOUT)
        I Y<0 S SDWLINST=$S(Y="ALL":"ALL",Y="":"ALL",Y="all":"ALL",Y="All":"ALL",Y["A":"ALL",Y["a":"ALL")
        I Y="All"!(Y="")!(Y="all")!(Y="ALL") S SDWLINST="ALL",^TMP("SDWLQSR",$J,"INS")="ALL" G IN3
        S SDWLINST=SDWLINST_Y_";",SDWLPROM="Another Institution: ",SDWLERR=1 G IN
IN2     S ^TMP("SDWLQSR",$J,"INS")=SDWLINST
IN3     Q
DATE    ;Date range selection
        K X,Y,%DT
        S SDWLERR=0 W ! S %DT="AE",%DT("A")="Start Date: " D ^%DT
        I X["^" S DUOUT=1 Q
        I Y<0 S DUOUT=1 Q
        S SDWLBDT=Y
        Q:$D(DUOUT)
        S %DT("A")="End Date: " D ^%DT G DATE:Y<1 S SDWLEDT=Y K %DT(0),%DT("A")
        G DATE:$D(DUOUT)
        I SDWLEDT<SDWLBDT W !,"Beginning Date must be greater than Ending Date." G DATE
        S ^TMP("SDWLQSR",$J,"DATE")=SDWLBDT_"^"_SDWLEDT K DIR,DIC,DIE,%DT Q
        Q
EXCL    ;EXCLUDE # REMAINING =0 - PATCH SD*5.3*524
        S SDWLEXCL=0,^TMP("SDWLQSR",$J,"EXCL")=0
        S DIR("A",1)="Do you wish to exclude any Teams, Specialities or Specific"
        S DIR("A")="Clinics where ALL values are zero"
        S DIR("B")="YES",DIR(0)="Y^A0" D ^DIR
        I X["^" S DUOUT=1 Q
        I Y<0 S DUOUT=1 Q
EXCL1   I Y S SDWLEXCL=1,^TMP("SDWLQSR",$J,"EXCL")=SDWLEXCL
        K DIR,X,Y,SDWLEXCL
        Q
QUE     ;Queue Report
        N ZTQUEUED,POP
        K %ZIS,IOP,IOC,ZTIO S %ZIS="MQ" D ^%ZIS G:POP QUE1
        S ZTRTN="EN^SDWLRSR",ZTDTH=$H,ZTDESC="WAIT LIST STAT REPORT"
        S SDWLTASK="" F  S SDWLTASK=$O(^TMP("SDWLQSR",$J,SDWLTASK)) Q:SDWLTASK=""  D
        .S SDWLTK=$G(^TMP("SDWLQSR",$J,SDWLTASK))
        .S ZTSAVE(SDWLTASK)=SDWLTK
        I $D(IO("Q")) K IO("Q") D ^%ZTLOAD W !,"REQUEST QUEUED" G QUE2
QUE1    S:$E(IOST,1,2)="C-" SDWLSPT=1 I $D(ZTRTN) U IO D @ZTRTN K SDWLSPT
        ;
        ;
QUE2    K SDWLTASK,SDWLY,SDWLED,WDWLBD,SDWLOPEN,SDWLDATE,SDWLFORM,SDWLPRI
        K DIR,DIC,DR,DIE
        D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
        Q
END     D EN^SDWLKIL
        K DUOUT,SDWLBDT,SDWLEDT,SDWLERR,SDWLIST,SDWLPROM,SDWLTK
        Q
HD      ;
        W:$D(IOF) @IOF W !,?80-$L("Wait List Stat Report")\2,"Wait List Stat Report",!
        Q
