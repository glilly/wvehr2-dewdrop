YTQTUSE ;ASF/ALB- PSYCHOLOGICAL TEST USEAGE REPORTING ; 7/30/09 10:44am
        ;;5.01;MENTAL HEALTH;**87,97**;Dec 30, 1994;Build 42
        ;called as a server option from YTQTUSE
1       N YSB,YSY,DFN,YSTST,YSCOMP,N,N1,A,YSCPLETE,YSGIVEN,YSCODEN,YSAD,Y
        N XMA,XMDUZ,XMY,XMSUB,XMRG,XQSUB,XMTEXT
        K ^TMP($J,"YSTAT")
        S ^TMP($J,"YSTAT",1)=$$SITE^VASITE
        S XMA=1 X XMREC
        I XMRG="" S ^TMP($J,"YSTAT",12)="Dates can not be resolved" D SENDER Q  ;-->out
        S YSB=$P(XMRG,U),YSY=$P(XMRG,U,2)
        S ^TMP($J,"YSTAT",2)="From: "_YSB_" To: "_YSY
        S ^TMP($J,"YSTAT",3)=" "
TT      ;test ck
        S N=20
        D STATS ;useage rollup
        S YSTST=0 F  S YSTST=$O(A(YSTST)) Q:YSTST'>0  D
        . S N=N+1
        . S ^TMP($J,"YSTAT",N)=+A(YSTST)_U_$P($G(^YTT(601.71,YSTST,0)),U)_U_YSTST_U_$$SITE^VASITE_U_A(YSTST)
SENDER  ;
        S XMSUB="MHA3 Automated Usage Report"
        S XMY(XMFROM)=""
        S XMTEXT="^TMP($J,""YSTAT"","
        S XMDUZ="MH3 automated testing REPLY"
        N XMFROM,XMZ,XMREC,XMCHAN D ^XMD
        Q
STATS   ;test count
        N YSHLSTAT,YSHLP K A
        S YSCODEN=0 F  S YSCODEN=$O(^YTT(601.84,"AC",YSCODEN)) Q:YSCODEN'>0  D
        . S YSGIVEN=YSB-.01
        . F  S YSGIVEN=$O(^YTT(601.84,"AC",YSCODEN,YSGIVEN)) Q:YSGIVEN'>0!(YSGIVEN>YSY)  D
        .. S YSAD=0
        .. F  S YSAD=$O(^YTT(601.84,"AC",YSCODEN,YSGIVEN,YSAD)) Q:YSAD'>0  D
        ... S YSCPLETE=$P(^YTT(601.84,YSAD,0),U,9)
        ... Q:YSCPLETE'="Y"  ;-->out
        ... S YSHLSTAT=$P($G(^YTT(601.84,YSAD,2)),U)
        ... S YSHLP=$S(YSHLSTAT="S":2,YSHLSTAT="E":3,YSHLSTAT="T":4,1:5)
        ... S $P(A(YSCODEN),U)=$P($G(A(YSCODEN)),U)+1
        ... S $P(A(YSCODEN),U,YSHLP)=$P(A(YSCODEN),U,YSHLP)+1
        Q
EN1     ;interactive login
        ;
        N DIR,YSB,YSY,YSCPLETE,A,B,YSINS,YSLFT
        S N=0,YSLFT=0
        K DIR S DIR(0)="DA^2961001:NOW:TX",DIR("A")="Begin date/time: ",DIR("B")="T-1M" D ^DIR
        Q:$D(DIRUT)
        S YSB=Y
        K DIR S DIR(0)="DA^2961001:NOW:TX",DIR("A")="End date/time: ",DIR("B")="NOW" D ^DIR
        Q:$D(DIRUT)
        S YSY=Y
        D STATS
        S YSTST=0 F  S YSTST=$O(A(YSTST)) Q:YSTST'>0  D
        . S N=N+1
        . S B($P($G(^YTT(601.71,YSTST,0)),U))=A(YSTST)
        . K A(YSTST)
        D ^%ZIS Q:POP  U IO
        W @IOF,!,"MHA3 Test Count from: "
        S Y=YSB D DD^%DT W Y
        S Y=YSY D DD^%DT W " to: ",Y
        W !,?5,"Count",?12,"Instrument",?60,"S E T ?"
        S YSINS=0
        F  S YSINS=$O(B(YSINS)) Q:YSINS=""!(YSLFT)  D
        . D:(($Y+5)>IOSL) WAIT
        . W !?5,$P(B(YSINS),U),?12,YSINS,?60,$P(B(YSINS),U,2,9)
        D ^%ZISC
        Q
WAIT    ;
        F I0=1:1:IOSL-$Y-4 W !
        N DIR,DTOUT,DUOUT,DIRUT
        I IOST?1"C".E S DIR(0)="E" D ^DIR K DIR S YSLFT=$D(DIRUT)
        W @IOF Q
