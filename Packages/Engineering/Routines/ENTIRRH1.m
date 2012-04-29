ENTIRRH1        ;WOIFO/LKG - Print hand receipt (Continued) ;3/4/08  15:02
        ;;7.0;ENGINEERING;**87**;Aug 17, 1993;Build 16
HDR1    ;Logic to print report heading
        G HDR1^ENTIRRH
        Q
        ;
ITST2   ;IT personnel entry point for printing signed hand receipts
        N ENDA,ENDATE
        N DIC,DTOUT,DUOUT S DIC=200,DIC(0)="AEMQ",DIC("S")="I $D(^ENG(6916.3,""C"",Y))"
        D ^DIC I Y<1!$D(DTOUT)!$D(DUOUT) Q
        S ENDA=+Y
        S ENDATE=$$DATES() I ENDATE="" Q
        S %ZIS="Q" D ^%ZIS I POP K POP Q
        I $D(IO("Q")) S ZTRTN="IN2^ENTIRRH1",ZTDESC="IT Equipment Hand Receipt Print",ZTSAVE("ENDA")="",ZTSAVE("ENDATE")="" D ^%ZTLOAD,HOME^%ZIS K ZTSK,IO("Q") Q
        G IN2
USER    ;User entry point for printing signed hand receipts
        I '$D(^ENG(6916.3,"C",DUZ)) W !,"You have no IT assignments, either active or ended." K DIR S DIR(0)="E" D ^DIR K DIR Q
        N ENDA,ENDATE S ENDA=DUZ
        S ENDATE=$$DATES() I ENDATE="" Q
        S %ZIS="Q" D ^%ZIS I POP K POP Q
        I $D(IO("Q")) S ZTRTN="IN2^ENTIRRH1",ZTDESC="IT Equipment Hand Receipt Print",ZTSAVE("ENDA")="",ZTSAVE("ENDATE")="" D ^%ZTLOAD,HOME^%ZIS K ZTSK,IO("Q") Q
        G IN2
IN2     ;
        N DIR,DIRUT,DIROUT,DTOUT,DUOUT,ENI,ENJ,ENL,ENNBR,ENV,ENVR,ENX
        S ENI=0
        F  S ENI=$O(^ENG(6916.3,"C",ENDA,ENI)) Q:+ENI'=ENI  D
        . S ENX=$G(^ENG(6916.3,ENI,0)) Q:ENX=""
        . S:$P($P(ENX,U,5),".")=ENDATE ENNBR=$P(ENX,U),ENV=$P(ENX,U,6),ENL(ENV)=$G(ENL(ENV))+1,^TMP($J,"ENITRRH","LIST","V"_ENV,ENNBR,ENI)=""
        . S ENJ=0
        . F  S ENJ=$O(^ENG(6916.3,ENI,3,ENJ)) Q:+ENJ'>0  D
        . . S ENX=$G(^ENG(6916.3,ENI,3,ENJ,0)) Q:ENX=""
        . . I $P($P(ENX,U),".")=ENDATE D
        . . . S ENNBR=$P(^ENG(6916.3,ENI,0),U),ENV=$P(ENX,U,2)
        . . . S:'$D(^TMP($J,"ENITRRH","LIST","V"_ENV,ENNBR,ENI)) ENL(ENV)=$G(ENL(ENV))+1,^TMP($J,"ENITRRH","LIST","V"_ENV,ENNBR,ENI)=ENJ
        S ENI=""
        F  S ENI=$O(^TMP($J,"ENITRRH","LIST",ENI)) Q:ENI=""  S ENVR=$P(ENI,"V",2) D PRT
        G EX2
PRT     U IO
        N END,ENDAC,ENERR,ENI,ENLNCNT,ENMFGN,ENMODEL,ENNOW,ENEQPT,ENPG,ENRDA,ENRDA1,ENX,ENNBR,ENSERNBR,ENSIG,ENSIGNDT,ENNAME,ENV,ENSTN,X,Y S ENPG=0,ENEQPT=1
        S ENNAME=$$GET1^DIQ(200,ENDA_",",.01),ENNOW=$$FMTE^XLFDT($$NOW^XLFDT(),"2M")
        S ENSTN=+$O(^DIC(6910,0)),ENSTN=$$GET1^DIQ(6910,ENSTN_",",1)
        D HDR1 Q:$D(DIRUT)
        I '$$CMP^XUSESIG1($P($G(^ENG(6916.2,ENVR,0)),U,3),$NAME(^ENG(6916.2,ENVR,1))) W !!!,"Hand receipt v",$P($G(^ENG(6916.2,ENVR,0)),U)," text is corrupted.",!?5," - Please contact EPS AEMS/MERS support"  Q
        S ENNBR=0,ENV="V"_ENVR
        F  S ENNBR=$O(^TMP($J,"ENITRRH","LIST",ENV,ENNBR)) Q:ENNBR=""  D  Q:$D(DIRUT)
        . S ENI=0
        . F  S ENI=$O(^TMP($J,"ENITRRH","LIST",ENV,ENNBR,ENI)) Q:ENI=""  D  Q:$D(DIRUT)
        . . N END,ENERR,ENERR1,ENERR2,ENERR3,ENERR4,X1,X2
        . . S ENDAC=ENNBR_"," D GETS^DIQ(6914,ENDAC,"3;4;5","E","END","ENERR")
        . . S ENMFGN=$G(END(6914,ENDAC,3,"E")),ENMODEL=$G(END(6914,ENDAC,4,"E")),ENSERNBR=$G(END(6914,ENDAC,5,"E"))
        . . I IOSL-1'>ENLNCNT D HDR1 Q:$D(DIRUT)
        . . W !,ENNBR,?11,$E(ENMFGN,1,20),?35,ENMODEL,?65,ENSERNBR S ENLNCNT=ENLNCNT+1
        . . S ENRDA=ENI,ENRDA1=$P(^TMP($J,"ENITRRH","LIST",ENV,ENNBR,ENI),U)
        . . K ENERR,ENSIG,ENSIGNDT
        . . S X=$S(ENRDA1>0:$G(^ENG(6916.3,ENRDA,3,ENRDA1,1)),1:$G(^ENG(6916.3,ENRDA,1)))
        . . I X'="" D
        . . . S X1=ENRDA,X2=1 D DE^XUSHSHP S ENSIG=$P(X,U),ENSIGNDT=$$FMTE^XLFDT($P(X,U,4))
        . . . S:$P(X,U,8)'=$P($G(^ENG(6916.2,ENVR,0)),U,3) ENERR1=1
        . . . S:$P(X,U,5)'=ENNBR ENERR2=1
        . . . S:$P(X,U,6)'=$P($G(^ENG(6916.3,ENRDA,0)),U,2) ENERR3=1
        . . . S:$P(X,U,4)'=$S(ENRDA1>0:$P($G(^ENG(6916.3,ENRDA,3,ENRDA1,0)),U),1:$P($G(^ENG(6916.3,ENRDA,0)),U,5)) ENERR4=1
        . . I $D(ENSIGNDT) D:IOSL-1'>ENLNCNT HDR1 Q:$D(DIRUT)  W !?4,"Signed: ",ENSIGNDT,?35,"Signature: /ES/",$G(ENSIG) S ENLNCNT=ENLNCNT+1
        . . I '$D(ENSIGNDT) D:IOSL-1'>ENLNCNT HDR1 Q:$D(DIRUT)  D
        . . . W !,?4,"Signed: "_$S(ENRDA1>0:$$GET1^DIQ(6916.31,ENRDA1_","_ENRDA_",",.01),1:$$GET1^DIQ(6916.3,ENRDA_",",4))
        . . . W ?35,"Certified by: "_$S(ENRDA1>0:$$GET1^DIQ(6916.31,ENRDA1_","_ENRDA_",",3),1:$$GET1^DIQ(6916.3,ENRDA_",",6))
         . . . S ENLNCNT=ENLNCNT+1
        . . I $G(ENERR1) D:IOSL-1'>ENLNCNT HDR1 Q:$D(DIRUT)  W !?19,"** Hand Receipt Text Altered **" S ENLNCNT=ENLNCNT+1
        . . I $G(ENERR2) D:IOSL-1'>ENLNCNT HDR1 Q:$D(DIRUT)  W !?19,"** Assigned Equipment Altered **" S ENLNCNT=ENLNCNT+1
        . . I $G(ENERR3) D:IOSL-1'>ENLNCNT HDR1 Q:$D(DIRUT)  W !?19,"** Assigned Person Altered **" S ENLNCNT=ENLNCNT+1
        . . I $G(ENERR4) D:IOSL-1'>ENLNCNT HDR1 Q:$D(DIRUT)  W !?19,"** Date Signed Altered **" S ENLNCNT=ENLNCNT+1
        . . D:IOSL-1'>ENLNCNT HDR1 Q:$D(DIRUT)  W !?4,"Current Status: ",$$GET1^DIQ(6916.3,ENI_",",20),?35,"Date: ",$$GET1^DIQ(6916.3,ENI_",",21) S ENLNCNT=ENLNCNT+1
        Q:$D(DIRUT)  S ENEQPT=0
        I IOSL-3'>ENLNCNT D HDR1 Q:$D(DIRUT)
        I ENLNCNT>3 W !! S ENLNCNT=ENLNCNT+2
        S ENI=0 F  S ENI=$O(^ENG(6916.2,ENVR,1,ENI)) Q:+ENI'=ENI  D  Q:$D(DIRUT)
        . I IOSL-1'>ENLNCNT D HDR1 Q:$D(DIRUT)
        . W !,$G(^ENG(6916.2,ENVR,1,ENI,0)) S ENLNCNT=ENLNCNT+1
        Q:$D(DIRUT)
        I $E(IOST,1,2)="C-" K DIR S DIR(0)="E" D ^DIR K DIR
        Q
EX2     S:$D(ZTQUEUED) ZTREQ="@" D ^%ZISC
        K ^TMP($J,"ENITRRH"),ENDA,ENDATE
        Q
DATES() ;Signature Dates for User
        K ^TMP($J,"ENITRRH","DATES") N ENCNT,ENDATE,ENI,ENJ,ENL,ENX,DIRUT,DIROUT,DTOUT,DUOUT,X,Y S ENDATE="" S:'$G(DT) DT=$$DT^XLFDT()
        S ENI=0
        F  S ENI=$O(^ENG(6916.3,"C",ENDA,ENI)) Q:+ENI'=ENI  D
        . S ENX=$P($P($G(^ENG(6916.3,ENI,0)),U,5),".") Q:ENX=""
        . S:'$D(^TMP($J,"ENITRRH","DATES",ENX)) ^TMP($J,"ENITRRH","DATES",ENX)=$$FMTE^XLFDT(ENX)
        . S ENJ=0
        . F  S ENJ=$O(^ENG(6916.3,ENI,3,ENJ)) Q:+ENJ'=ENJ  D
        . . S ENX=$P($P($G(^ENG(6916.3,ENI,3,ENJ,0)),U),".") Q:ENX=""
        . . S:'$D(^TMP($J,"ENITRRH","DATES",ENX)) ^TMP($J,"ENITRRH","DATES",ENX)=$$FMTE^XLFDT(ENX)
        W @IOF,?5,"Signature Dates" S ENL=1
        S ENI="",ENCNT=0
        F  S ENI=$O(^TMP($J,"ENITRRH","DATES",ENI),-1) Q:ENI=""  D  Q:$D(DIRUT)
        . I IOSL-2'>ENL K DIR S DIR(0)="E" D ^DIR K DIR S ENL=0 Q:$D(DIRUT)
        . W !?5,$P(^TMP($J,"ENITRRH","DATES",ENI),U) S ENL=ENL+1,ENCNT=ENCNT+1
        I 'ENCNT W !?3,"* No Signed Assignments *" K DIR S DIR(0)="E" D ^DIR K DIR Q ""
        K DIRUT,DIROUT,DTOUT,DUOUT W !
        K DIR S DIR(0)="DA^3061001:"_DT_"^I '$D(^TMP($J,""ENITRRH"",""DATES"",Y)) K X",DIR("A")="Date of Hand Receipt Signature: ",DIR("?")="Enter date from list."
        S:ENCNT=1 DIR("B")=$$FMTE^XLFDT($O(^TMP($J,"ENITRRH","DATES","")))
        D ^DIR K DIR I $D(DIRUT)!$D(DIROUT)!(Y'?7N) S Y=""
        S ENDATE=Y K ^TMP($J,"ENITRRH","DATES")
        Q ENDATE
        ;
        ;ENTIRRH1
