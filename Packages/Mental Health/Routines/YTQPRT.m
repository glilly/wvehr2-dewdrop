YTQPRT  ;ASF/ALB MHA3 PRINT TEST; 2/24/10 1:27pm
        ;;5.01;MENTAL HEALTH;**85,97**;DEC 30,1994;Build 42
        ;
        Q
FORM    ;print for clinicians
        N YSLIMIT,YSCODE,YSCODEN,YSNUMB,YSG,YSIEN,YSOPER,YSQG2,YSERR,YSCTYPE,YSCHT,YSCHOICE,YSLEG,YSQN,YSNN,YSLFT
        N DA,G,J,N,N1,Y,YS1,YSCDISP,YSCHTSEQ,YSCTEXT,YSI,YSIDENT,YSDISP,YSINTRO,YSQDISP,YSR,YSRTYPE,YSSCALE,YSSCIEN,YSZ,YSEQ,YSIDISP
        K DIC S DIC(0)="MAE",DIC="^YTT(601.71," D ^DIC Q:Y'>0
        S YSCODEN=+Y,YSCODE=$P(Y,U,2)
        ;S DA=YSCODEN D EN^DIQ
        D ^%ZIS Q:POP
FA      W @IOF,!?7,YSCODE
        W !,$$GET1^DIQ(601.71,YSCODEN_",","PRINT TITLE")
        S YSNUMB=0,YSLFT=""
        ;Loop thru test for all items
        S YSEQ=0 F  S YSEQ=$O(^YTT(601.76,"AD",YSCODEN,YSEQ)) Q:YSEQ'>0!(YSLFT)  S YSIEN=$O(^YTT(601.76,"AD",YSCODEN,YSEQ,0)) Q:YSIEN'>0!(YSLFT)  S YSNUMB=YSNUMB+1,YSR=0 D
        . D:(($Y+5)>IOSL) WAIT
        . S YSG=^YTT(601.76,YSIEN,0),YSQN=$P(YSG,U,4),YSQG2=$G(^YTT(601.72,YSQN,2)),YSRTYPE=$P(YSQG2,U,2)
        . S YSQDISP=$P(YSG,U,6),YSIDISP=$P(YSG,U,7),YSCDISP=$P(YSG,U,8)
        . D QOUT
        . W:YSRTYPE'=1 !,$$GET1^DIQ(601.74,YSRTYPE_",",1)_":__________"
        . S YSCTYPE=$P(YSQG2,U,3) Q:YSCTYPE=""  ;-->out
        . S YSIDENT=$O(^YTT(601.89,"B",YSCTYPE,0)) S:YSIDENT'="" YSIDENT=$P($G(^YTT(601.89,YSIDENT,0)),U,2)
        . S YSI=0 S YSCHTSEQ=0 F  S YSCHTSEQ=$O(^YTT(601.751,"AC",YSCTYPE,YSCHTSEQ)) Q:YSCHTSEQ'>0  S YSI=YSI+1 D
        .. S YSCHOICE=$O(^YTT(601.751,"AC",YSCTYPE,YSCHTSEQ,0)) Q:YSCHOICE'>0  D
        ... S YSCTEXT=$G(^YTT(601.75,YSCHOICE,1))
        ... W !,"_____ ",$S(YSIDENT=0:YSI-1_".",YSIDENT="N":"",1:YSI_".")," ",YSCTEXT
        K ^TMP($J,"YSG")
        D ^%ZISC
        Q
QOUT    ;pull text and intros
        W !! ;,YSEQ,">> Question#"_YSQN
        S YSINTRO=$P($G(^YTT(601.72,YSQN,2)),U)
        I YSINTRO?1N.N S N1=0 F  S N1=$O(^YTT(601.73,YSINTRO,1,N1)) Q:N1'>0  W !,^YTT(601.73,YSINTRO,1,N1,0)
        W !,YSNUMB,". " S N1=0 F  S N1=$O(^YTT(601.72,YSQN,1,N1)) Q:N1'>0  W:N1>1 ! W ^YTT(601.72,YSQN,1,N1,0)
        Q
PRTTEST ;print for developers
        K DIC S DIC(0)="MAE",DIC="^YTT(601.71," D ^DIC Q:Y'>0
        N YSLIMIT,YSCODE,YSCODEN,YSNUMB,YSG,YSIEN,YSOPER,YSQG2,YSERR,YSCTYPE,YSCHT,YSCHOICE,YSLEG,YSQN,YSNN
        N DA,G,J,N,N1,YS1,YSCDISP,YSCHTSEQ,YSCTEXT,YSI,YSIDENT,YSDISP,YSINTRO,YSQDISP,YSR,YSRTYPE,YSSCALE,YSSCIEN,YSZ,YSEQ,YSIDISP,YSLFT,YSRPT
EN1     ;
        K IOP S %ZIS="Q" D ^%ZIS Q:POP  ;-->out
        S YSCODEN=+Y,YSCODE=$P(^YTT(601.71,YSCODEN,0),U)
        W @IOF,!?10,"*** ",YSCODE," ***",!
        S DA=YSCODEN,DIC="^YTT(601.71," D EN^DIQ
        S YSNUMB=0,YSLFT=""
        D:(($Y+9)>IOSL) WAIT
        Q:YSLFT
        ;Loop thru test for all items
        S YSEQ=0 F  S YSEQ=$O(^YTT(601.76,"AD",YSCODEN,YSEQ)) Q:YSEQ'>0!(YSLFT)  S YSIEN=$O(^YTT(601.76,"AD",YSCODEN,YSEQ,0)) Q:YSIEN'>0!(YSLFT)  S YSNUMB=YSNUMB+1,YSR=0 D
        . D:(($Y+5)>IOSL) WAIT
        . S YSG=^YTT(601.76,YSIEN,0),YSQN=$P(YSG,U,4),YSQG2=$G(^YTT(601.72,YSQN,2))
        . S YSQDISP=$P(YSG,U,6),YSIDISP=$P(YSG,U,7),YSCDISP=$P(YSG,U,8)
        . D GETTEXT
        . S YSCTYPE=$P(YSQG2,U,3) Q:YSCTYPE=""  ;->out
        . W !,"Choicetype: ",YSCTYPE
        . W "  identifier: " I $D(^YTT(601.89,"B",YSCTYPE)) S YSIDENT=$O(^YTT(601.89,"B",YSCTYPE,0)) Q:YSIDENT=""  W $P($G(^YTT(601.89,YSIDENT,0)),U,2)
        . D IENCK(YSCTYPE)
        . S YSCHTSEQ=0 F  S YSCHTSEQ=$O(^YTT(601.751,"AC",YSCTYPE,YSCHTSEQ)) Q:YSCHTSEQ'>0  D
        .. S YSCHOICE=$O(^YTT(601.751,"AC",YSCTYPE,YSCHTSEQ,0)) Q:YSCHOICE'>0  D
        ... S YSCTEXT=$G(^YTT(601.75,YSCHOICE,1))
        ... S YSLEG=$P($G(^YTT(601.75,YSCHOICE,0)),U,2)
        ... W !,"# "_YSCHOICE_" Leg: "_YSLEG_"  "_YSCTEXT
        Q:YSLFT  ;-->out
        D SCALES
        Q:YSLFT  ;-->out
        D SKIP
        Q:YSLFT  ;-->out
        D RULESKIP
        Q:YSLFT  ;-->out
        D REPORT
        K ^TMP($J,"YSG")
        D ^%ZISC
        Q
GETTEXT ;pull text and intros
        W !!,"<<",YSEQ,">> Question#"_YSQN,"     Display Q: ",YSQDISP,"  I: ",YSIDISP,"  C: ",YSCDISP
        S YSINTRO=$P($G(^YTT(601.72,YSQN,2)),U)
        I YSINTRO?1N.N W !,"Intro #"_YSINTRO S N1=0 F  S N1=$O(^YTT(601.73,YSINTRO,1,N1)) Q:N1'>0  W !,^YTT(601.73,YSINTRO,1,N1,0)
        S N1=0 F  S N1=$O(^YTT(601.72,YSQN,1,N1)) Q:N1'>0  W !,^YTT(601.72,YSQN,1,N1,0)
        Q
SCALES  ;scales
        W !!!?5,"*** Scales ***",!
        S YS1("CODE")=YSCODE D SCALEG^YTQAPI3(.YSZ,.YS1)
        S N=1 F  S N=$O(^TMP($J,"YSG",N)) Q:N'>0!(YSLFT)  D
        . D:(($Y+9)>IOSL) WAIT
        . S G=^TMP($J,"YSG",N)
        . I G'?1"Scale".E W !,"scale group: ",+$P(G,"=",2),"  ",$P(G,U,3) Q
        . S YSSCALE=$P(G,U,4),YSSCIEN=$P($P(G,U,1),"=",2)
        . W !,YSSCIEN,?10,YSSCALE
        . Q:'$D(^YTT(601.91,"AC",YSSCIEN))
        . W !?5,"#      Question     target           ADD"
        . S J=0 F  S J=$O(^YTT(601.91,"AC",YSSCIEN,J)) Q:J'>0  S G=^YTT(601.91,J,0) W !?5,+G,?12,$P(G,U,3),"  ",$P(G,U,4),"   ",$P(G,U,5)
        K ^TMP($J,"YSG")
        Q
SKIP    ;skip questions
        W !!!?5,"*** Skips ***",!
        S N=0 F  S N=$O(^YTT(601.79,"AC",YSCODEN,N)) Q:N'>0!(YSLFT)  D
        . D:(($Y+9)>IOSL) WAIT
        .S G=^YTT(601.79,N,0)
        . W !,"SkipID: "+$P(G,U)_"  RuleId: "_$P(G,U,3)_"  QuestionID: "_$P(G,U,4)
        .S ^TMP($J,"YSG",$P(G,U,3))=""
        Q
RULESKIP        ;rules that skip questions
        S N=0 F  S N=$O(^TMP($J,"YSG",N)) Q:N'>1!(YSLFT)  D
        . D:(($Y+9)>IOSL) WAIT
        . W !
        . S DA=N,DIC="^YTT(601.82," D EN^DIQ
        Q
REPORT  ;display report setup
        S YSRPT=$O(^YTT(601.93,"C",YSCODEN,0))
        I YSRPT'>0 W !!,"REPORT: not defined",!! Q  ;-->out
        W !!
        S DA=YSRPT,DIC="^YTT(601.93," D EN^DIQ
        Q
IENCK(NN)       ;check ien< 100,000
        Q:YSCODEN>99999  ;-->out
        S J=0 F  S J=$O(^YTT(601.751,"B",NN,J)) Q:J'>0  I J>99999 W !,"###### not national ######## ",^YTT(601.751,J,0) S ^TMP($J,"YSNATERR",NN,YSCODE)=""
        Q
WAIT    ;
        F I0=1:1:IOSL-$Y-4 W !
        N DTOUT,DUOUT,DIRUT
        I IOST?1"C".E S DIR(0)="E" D ^DIR K DIR S YSLFT=$D(DIRUT)
        W @IOF Q
