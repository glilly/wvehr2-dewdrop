ECXLBBC ;ALB/MRY - LBB Extract Audit Comparative Report ; 6/15/09 3:19pm
        ;;3.0;DSS EXTRACTS;**120**;Dec 22, 1997;Build 43
        ;
EN      ;entry point for LBB extract audit comparative report
        N ECSD,ECED,ECSDN,ECEDN
        D SETUP^ECXLBB I ECFILE="" Q
        N %X,%Y,%DT,X,Y,DIC,DA,DR,DIQ,DIR,DIRUT,DTOUT,DUOUT,SCRNARR,REPORT
        N SCRNARR,ECXERR,ECXHEAD,ECXAUD,ECXARRAY,STATUS,FLAG,ECXALL,TMP
        N ZTQUEUED,ZTSTOP
        S SCRNARR="^TMP(""ECX"",$J,""SCRNARR"")"
        K @SCRNARR@("DIVISION")
        S (ECXERR,FLAG)=0
        ;ecxaud=0 for 'extract' audit
        S ECXHEAD="LBB",ECXAUD=0
        W !!,"Setup for ",ECXHEAD," Extract Comparative Report --",!!
        ;select extract
        D AUDIT^ECXUTLA(ECXHEAD,.ECXERR,.ECXARRAY,ECXAUD)
        Q:ECXERR
        W !!
        ;select divisions/sites; all divisions if ecxall=1
        ;**not in ECXPLBB report, so leaving multi-divisions out.
        ;S ECXERR=$$NUT^ECXDVSN()
        ;I ECXERR=1 D  Q
        ;.W !!,?5,"Try again later... exiting.",!
        ;.K @SCRNARR@("DIVISION")
        ;.D AUDIT^ECXKILL
        S:'$D(ECINST) ECINST=+$P(^ECX(728,1,0),U)
        S ECXINST=ECINST
        K ECXDIC S DA=ECINST,DIC="^DIC(4,",DIQ(0)="I",DIQ="ECXDIC",DR=".01;99"
        D EN^DIQ1 S ECINST=$G(ECXDIC(4,DA,99,"I")) K DIC,DIQ,DA,DR,ECXDIC
        ;sort by COMP
        S DIR(0)="Y",DIR("A")="Do you want the "_ECXHEAD_" extract comparative report to sort by COMP"
        S DIR("B")="NO" D ^DIR K DIR
        I $G(DIRUT) S ECXERR=1 Q
        ;if y=0 i.e., 'no', then ecxcomp=0 i.e., 'selected'
        S ECXCFLG=Y
        I ECXERR=1 D  Q
        .W !!,?5,"Try again later... exiting.",!
        .D AUDIT^ECXKILL
        W !
        Q:(ECXARRAY("END")']"")&(ECXARRAY("START")']"")
        N ECXPOP S ECXPOP=0 D QUE Q:ECXPOP=1
        ;
START   ; entry point from tasked job
        ; get LAB DATA and build temporary global ^TMP("ECXLBB",$J)
        N ECXLOGIC,ECXRPT,ECXCRPT,ECXJOB
        S ECXJOB=$J
        K ^TMP("ECXLBBC",ECXJOB)
        U IO
        I $E(IOST,1,2)="C-" W !,"Retrieving records... "
        S (ECXRPT,ECXCRPT)=1 D AUDRPT^ECXLBB ;build source tmp
        D EXTRACT ;build extract tmp
        ;
OUTPUT  ; entry point called by EN tag
        N ECDATE,ECXTOT,ECXSTOT,ECXSTRX,ECXSTRS,ECRDT,ECQUIT,ECPG,ECLINE,ECLINE1,ECXCLAST
        I '$D(^TMP("ECXLBBC",ECXJOB)) W !,"There were no records that met the date range criteria" Q
        S (ECPG,ECDATE,ECQUIT,ECXCOMP,ECXTOT,ECXSTOT)=0
        S ECXCOMP("TOTAL","S")=0,ECXCOMP("TOTAL","X")=0,ECXCLAST=0
        S ECLINE="",$P(ECLINE,"=",132)="=",ECLINE1="",$P(ECLINE1,"-",132)="-"
        S ECSDN=$$FMTE^XLFDT(ECSD,9),ECEDN=$$FMTE^XLFDT(ECED,9),ECRDT=$$FMTE^XLFDT(DT,9)
        W:$E(IOST,1,2)="C-" @IOF D HED
        S ECXCOMP=0 F  S ECXCOMP=$O(^TMP("ECXLBBC",ECXJOB,ECXCOMP)) D  Q:ECXCOMP=""  Q:ECQUIT
        . I ECXCFLG,ECXCLAST'=0,ECXCOMP="" S ECXSTOT=1 D TOTAL S ECXSTOT=0 Q
        . Q:ECXCOMP=""
        . I ECXCFLG,ECXCLAST'=0,ECXCLAST'=ECXCOMP S ECXSTOT=1 D TOTAL S ECXSTOT=0
        . S ECXCLAST=ECXCOMP
        . S ECXCOMP(ECXCOMP,"S")=0,ECXCOMP(ECXCOMP,"X")=0
        . S ECXDFN=0 F  S ECXDFN=$O(^TMP("ECXLBBC",ECXJOB,ECXCOMP,ECXDFN)) Q:'ECXDFN  D  Q:ECQUIT
        .. S ECDATE=0 F  S ECDATE=$O(^TMP("ECXLBBC",ECXJOB,ECXCOMP,ECXDFN,ECDATE))  Q:'ECDATE  D  Q:ECQUIT
        ... S ECXSTRS=$G(^TMP("ECXLBBC",ECXJOB,ECXCOMP,ECXDFN,ECDATE,"S"))
        ... S ECXSTRX=$G(^TMP("ECXLBBC",ECXJOB,ECXCOMP,ECXDFN,ECDATE,"X"))
        ... I ECXSTRS'="" D
        .... S ECXCOMP(ECXCOMP,"S")=ECXCOMP(ECXCOMP,"S")+(+$P(ECXSTRS,"^",12))
        .... S ECXCOMP("TOTAL","S")=ECXCOMP("TOTAL","S")+(+$P(ECXSTRS,"^",12))
        ... I ECXSTRX'="" D
        .... S ECXCOMP(ECXCOMP,"X")=ECXCOMP(ECXCOMP,"X")+(+$P(ECXSTRX,"^",12))
        .... S ECXCOMP("TOTAL","X")=ECXCOMP("TOTAL","X")+(+$P(ECXSTRX,"^",12))
        ... D PRINT
        S ECXTOT=1 D TOTAL S ECXTOT=0
        D ^ECXKILL
        Q
        ;
PRINT   ;
        I $Y+5>IOSL D  Q:ECQUIT
        . I $E(IOST,1,2)["C-" S DIR(0)="E" D ^DIR K DIR I 'Y S ECQUIT=1 Q
        . W @IOF D HED
        I ECXSTRS="" W !?3,"***************N*O***D*A*T*A*****************"
        I ECXSTRS'="" D
        . W !,$P(ECXSTRS,"^",5),?11,$P(ECXSTRS,"^",4),?26,$P(ECXSTRS,"^",16)
        . W ?37,$$FMTE^XLFDT($$HL7TFM^XLFDT($P(ECXSTRS,"^",8)),2)
        . W ?49,$P(ECXSTRS,"^",11),?60,$J(+$P(ECXSTRS,"^",12),2)
        I ECXSTRX="" W ?83,"*******N*O***D*A*T*A*********"
        I ECXSTRX'="" D
        . W ?80,$P(ECXSTRX,"^",4)
        . W ?92,$$FMTE^XLFDT($$HL7TFM^XLFDT($P(ECXSTRX,"^",8)),2)
        . W ?102,$P(ECXSTRX,"^",11),?113,$J(+$P(ECXSTRX,"^",12),2)
        Q
TOTAL   ;
        ;I $Y+3>IOSL D  Q:ECQUIT
        ;. I $E(IOST,1,2)["C-" S DIR(0)="E" D ^DIR K DIR I 'Y S ECQUIT=1 Q
        ;. W @IOF D HED
        W !,ECLINE1
        I $G(ECXSTOT) W !,?47,$J(ECXCLAST_" TOTAL",12),?60,$J(+$G(ECXCOMP(ECXCLAST,"S")),4),?100,$J(ECXCLAST_" TOTAL",12),?113,$J(+$G(ECXCOMP(ECXCLAST,"X")),4)
        I $G(ECXTOT) W !,"TOTAL",?60,$J(+$G(ECXCOMP("TOTAL","S")),4),?113,$J(+$G(ECXCOMP("TOTAL","X")),4)
        Q
        ;
HED     ;
        S ECPG=ECPG+1
        W !,"LBB Extract Comparative Report",?124,"Page",$J(ECPG,3)
        W !,ECSDN," - ",ECEDN,?111,"Run Date:",$J(ECRDT,12)
        W !!,"------------------ LOCAL BLOOD BANK SOURCE ----------------------"
        W ?80,"------------- LBB EXTRACT (#"_ECXARRAY("EXTRACT")_") ---------------"
        W !,?37,"Transf",?57,"Number",?92,"Transf",?113,"Number"
        W !,"Name",?14,"SSN",?25,"FDR LOC",?37,"Date",?49,"COMP",?57,"of Units",?80,"SSN",?92,"Date",?102,"COMP",?113,"of Units"
        W !,ECLINE
        Q
        ;
QUE     ;
        ;determine output device and queue if requested
        N %,X,%DT
        S X=ECXARRAY("START") D ^%DT S ECSD=Y S X=ECXARRAY("END") D ^%DT S ECED=Y
        S ECSDN=$$FMTE^XLFDT(ECSD),ECEDN=$$FMTE^XLFDT(ECED),ECSD1=ECSD-.1
        F X="ECINST","ECED","ECSD","ECSD1","ECEDN","ECSDN" S ECXSAVE(X)=""
        F X="ECPACK","ECPIECE","ECRTN","ECGRP","ECNODE" S ECXSAVE(X)=""
        F X="ECFILE","ECHEAD","ECVER","ECINST","ECXINST","ECXCFLG" S ECXSAVE(X)=""
        ;S ECXSAVE("ECXDIV(")=""
        S ECXSAVE("ECXARRAY(")="",ECXSAVE("SCRNARR")="",TMP=$$OREF^DILF(SCRNARR),ECXSAVE(TMP)=""
        S ECXPGM="START^ECXLBBC",ECXDESC="LBB Extract Audit Comparative Report"
        W !!,"This report requires a print width of 132 characters.",!!
        D DEVICE^ECXUTLA(ECXPGM,ECXDESC,.ECXSAVE)
        I ECXSAVE("POP")=1 D  S ECXPOP=1 Q
        .W !!,?5,"Try again later... exiting.",!
        .K @SCRNARR@("DIVISION")
        .D AUDIT^ECXKILL
        I ECXSAVE("ZTSK")=0 D
        .K ECXSAVE,ECXPGM,ECXDESC
        .D START^ECXLBBC
        I IO'=IO(0) D ^%ZISC
        D HOME^%ZIS S ECXPOP=1
        D AUDIT^ECXKILL
        Q
EXTRACT ;build extract tmp
        N ECXEXT,IEN,NODE0,ECXDFN,ECXTDT,ECXTTM,ECXCOMP
        S ECXEXT=ECXARRAY("EXTRACT")
        S IEN=0 F  S IEN=$O(^ECX(727.829,"AC",ECXEXT,IEN)) Q:IEN=""  D
        . S NODE0=$G(^ECX(727.829,IEN,0)),ECXDFN=$P(NODE0,"^",5)
        . S ECXTDT=$P(NODE0,"^",10)
        . I ($E(ECXTDT,1)+1_$E(ECXTDT,3,8))>ECED Q
        . I ($E(ECXTDT,1)+1_$E(ECXTDT,3,8))<ECSD Q
        . S ECXTTM=$P(NODE0,"^",11),ECXCOMP=$P(NODE0,"^",13)
        . N ECCOUNT S ECCOUNT=0
        . F  S ECCOUNT=ECCOUNT+1 Q:'$D(^TMP("ECXLBBC",$J,$S($G(ECXCFLG)=1:ECXCOMP,1:"ZZNOZZ"),ECXDFN,ECXTDT_"."_ECXTTM_"."_ECCOUNT,"X"))
        . S ^TMP("ECXLBBC",$J,$S($G(ECXCFLG)=1:ECXCOMP,1:"ZZNOZZ"),ECXDFN,ECXTDT_"."_ECXTTM_"."_ECCOUNT,"X")="^"_$P(NODE0,"^",4,99)
        Q
