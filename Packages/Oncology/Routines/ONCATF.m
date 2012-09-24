ONCATF  ;Hines OIFO/GWB - Treatment @FAC (at this facility) stuffing ;06/23/10
        ;;2.11;ONCOLOGY;**19,25,27,36,40,42,46,51**;Mar 07, 1995;Build 65
        ;
NCDS    ;SURG DX/STAGING PROC @FAC (165.5,58.4) 
        N COC D CHKCOC I (COC="00")!(COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=34)!(COC=35) D
        .S $P(^ONCO(165.5,D0,3.1),U,5)=$P($G(^ONCO(165.5,D0,3)),U,27)
        Q
        ;
NCDSDT  ;SURG DX/STAGING PROC @FAC DATE (165.5,58.5)
        N COC D CHKCOC I (COC="00")!(COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=34)!(COC=35) D
        .S $P(^ONCO(165.5,D0,3.1),U,6)=$P($G(^ONCO(165.5,D0,3)),U,31)
        Q
        ;
DSPNCDS ;Display SURG DX/STAGING PROC @FAC (165.5,58.4)
        N COC D CHKCOC I (COC=20)!(COC=21)!(COC=22)!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=36)!(COC=37) D  K TXNO,TXUNK,TXNUL S Y="@36" Q
        .S NTX=1 W ! D NCDSATF^ONCNTX1 K NTX
        .I $G(DNCATF)=1 K DNCATF,TXNUL Q
        I $G(DNCATF)=1 K DNCATF,TXNUL S Y="@36" Q
        I (COC="00")!(COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=34)!(COC=35) G DIQ1
        I $G(TXNO)=1 S NTX=1 W ! D NCDSATF^ONCNTX1 K NTX,TXNO S Y="@36" Q
        I $G(TXUNK)=1 S NTX=1 W ! D NCDSATF^ONCUTX1 K NTX,TXUNK S Y="@36" Q
        I $G(TXNUL)=1 K TXNUL S Y="@36"
        Q
        ;
DIQ1    N DI,DIC,DA,DR,DIQ,ONC
        S DA=D0,DIC="^ONCO(165.5,",DIQ="ONC(",DIQ(0)="E",DR="58.4;58.5"
        D EN^DIQ1
        W !!,$P(^DD(165.5,58.4,0),U,1),".....: "_$E(ONC(165.5,DA,58.4,"E"),1,47)
        W !,$P(^DD(165.5,58.5,0),U,1),": "_ONC(165.5,DA,58.5,"E")
        K TXNO,TXUNK,TXNUL S Y="@36"
        Q
        ;
SPSR    ;SURGERY OF PRIMARY @FAC (R) (165.5,50.2)
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,7)=$P($G(^ONCO(165.5,D0,3)),U,38)
        Q
        ;
DSPSPSR ;Display SURGERY OF PRIMARY @FAC (R) (165.5,50.2)
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@427" Q
        .S NTX=1 W ! D SURATFR^ONCNTX1 K NTX
        .I $G(DSATF)=1 K DSATF,TXNUL Q
        I $G(DSATF)=1 K DSATF,TXNUL S Y="@427" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D SURATFR^ONCNTX1 K NTX,TXNO S Y="@427" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D SURATFR^ONCUTX1 K NTX,TXUNK S Y="@427" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@427" Q
        N DI,DIC,DA,DR,DIQ,ONC
        S DA=D0,DIC="^ONCO(165.5,",DIQ="ONC(",DIQ(0)="E"
        S DR=50.2
        D EN^DIQ1
        I $G(DSATF)'=1 D
        .W !!,$P(^DD(165.5,50.2,0),U,1),"....: "_$E(ONC(165.5,DA,50.2,"E"),1,48)
        K DSATF,TXNO,TXUNK,TXNUL S Y="@427"
        Q
        ;
SPS     ;SURGERY OF PRIMARY @FAC (F) (165.5,58.7)
        N SUUP
        S SUUP=1 D RFNS^ONCATF1
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,30)=$P($G(^ONCO(165.5,D0,3.1)),U,29)
        Q
        ;
SPSDT   ;MOST DEFINITIVE SURG @FAC DATE (165.5,50.3)
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,8)=$P($G(^ONCO(165.5,D0,3)),U,1)
        Q
        ;
DSPSPS  ;Display SURGERY OF PRIMARY @FAC (F) (165.5,58.7)
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@43" Q
        .S NTX=1 W ! D SURATF^ONCNTX1 K NTX
        .I $G(DSATF)=1 K DSATF,TXNUL Q
        I $G(DSATF)=1 K DSATF,TXNUL S Y="@43" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D SURATF^ONCNTX1 K NTX,TXNO S Y="@43" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D SURATF^ONCUTX1 K NTX,TXUNK S Y="@43" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@43" Q
        N DI,DIC,DA,DR,DIQ,ONC
        S DA=D0,DIC="^ONCO(165.5,",DIQ="ONC(",DIQ(0)="E"
        S DR="58.7;50.3"
        D EN^DIQ1
        I $G(DSATF)'=1 D
        .W !!,"SURGERY OF PRIMARY @FAC.....(F): "_$E(ONC(165.5,DA,58.7,"E"),1,48)
        .W !,"MOST DEFINITIVE SURG @FAC DATE.: "_ONC(165.5,DA,50.3,"E") Q
        K DSATF,TXNO,TXUNK,TXNUL S Y="@43"
        Q
        ;
SCPR    ;SCOPE OF LN SURGERY @FAC (R) (165.5,138.1)
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,9)=$P($G(^ONCO(165.5,D0,3)),U,40)
        Q
        ;
SCP     ;SCOPE OF LN SURGERY @FAC (F) (165.5,138.5)
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,32)=$P($G(^ONCO(165.5,D0,3.1)),U,31)
        Q
        ;
SCPDT   ;SCOPE OF LN SURGERY @FAC DATE (165.5,138.3)
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,23)=$P($G(^ONCO(165.5,D0,3.1)),U,22)
        Q
        ;
NUMND   ;NUMBER OF LN REMOVED @FAC (R) (165.5,140.1)
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,11)=$P($G(^ONCO(165.5,D0,3)),U,42)
        Q
        ;
DSPSCPR ;Display SCOPE OF LN SURGERY @FAC (R) (165.5,138.1)
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@139" Q
        .S NTX=1 W ! D NODATFR^ONCNTX1 K NTX
        .I $G(DSCATF)=1 K DSCATF,TXNUL Q
        I $G(DSCATF)=1 K DSCATF,TXNUL S Y="@139" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D NODATFR^ONCNTX1 K NTX,TXNO S Y="@139" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D NODATFR^ONCUTX1 K NTX,TXUNK S Y="@139" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@139" Q
        N DI,DIC,DA,DR,DIQ,ONC
        S DA=D0,DIC="^ONCO(165.5,",DIQ="ONC(",DIQ(0)="E"
        S DR="138.1;140.1"
        D EN^DIQ1
        I $G(DSCATF)'=1 D
        .W !!,$P(^DD(165.5,138.1,0),U,1),"...: "_$E(ONC(165.5,DA,138.1,"E"),1,48)
        .W !,$P(^DD(165.5,140.1,0),U,1),"..: "_ONC(165.5,DA,140.1,"E")
        K DSCATF,TXNO,TXUNK,TXNUL S Y="@139" Q
        ;
DSPSCP  ;Display SCOPE OF LN SURGERY @FAC (F) (165.5,138.5)
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@46" Q
        .S NTX=1 W ! D NODEATF^ONCNTX1 K NTX
        .I $G(DSCATF)=1 K DSCATF,TXNUL Q
        I $G(DSCATF)=1 K DSCATF,TXNUL S Y="@46" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D NODEATF^ONCNTX1 K NTX,TXNO S Y="@46" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D NODEATF^ONCUTX1 K NTX,TXUNK S Y="@46" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@46" Q
        N DI,DIC,DA,DR,DIQ,ONC
        S DA=D0,DIC="^ONCO(165.5,",DIQ="ONC(",DIQ(0)="E"
        S DR="138.5;138.3"
        D EN^DIQ1
        I $G(DSCATF)'=1 D
        .W !!,$P(^DD(165.5,138.5,0),U,1),"....: "_$E(ONC(165.5,DA,138.5,"E"),1,48)
        .W !,$P(^DD(165.5,138.3,0),U,1),".: "_ONC(165.5,DA,138.3,"E")
        K DSCATF,TXNO,TXUNK,TXNUL S Y="@46" Q
        ;
SOSNR   ;SURG PROC/OTHER SITE @FAC (R) (165.5,139)
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,10)=$P($G(^ONCO(165.5,D0,3)),U,41)
        Q
        ;
SOSN    ;SURG PROC/OTHER SITE @FAC (F) (165.5,139.5)
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,34)=$P($G(^ONCO(165.5,D0,3.1)),U,33)
        Q
        ;
SOSNDT  ;SURG PROC/OTHER SITE @FAC DATE (165.5,139.3)
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,25)=$P($G(^ONCO(165.5,D0,3.1)),U,24)
        Q
        ;
DSPSOSR ;Display SURG PPROC/OTHER SITE @FAC (R) (165.5,139.1)
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@428" Q
        .S NTX=1 W ! D SOSATFR^ONCNTX1 K NTX
        .I $G(DSOATF)=1 K DSOATF,TXNUL Q
        I $G(DSOATF)=1 K DSOATF,TXNUL S Y="@428" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D SOSATFR^ONCNTX1 K NTX,TXNO S Y="@428" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D SOSATFR^ONCUTX1 K NTX,TXUNK S Y="@428" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@428" Q
        N DI,DIC,DA,DR,DIQ,ONC
        S DA=D0,DIC="^ONCO(165.5,",DIQ="ONC(",DIQ(0)="E"
        S DR=139.1
        D EN^DIQ1
        I $G(DSOATF)'=1 D
        .W !,$P(^DD(165.5,139.1,0),U,1),": "_ONC(165.5,DA,139.1,"E") Q
        K DSOATF,TXNO,TXUNK,TXNUL S Y="@428" Q
        ;
DSPSOSN ;Display SURG PPROC/OTHER SITE @FAC (F) (165.5,139.5)
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@48" Q
        .S NTX=1 W ! D SOSNATF^ONCNTX1 K NTX
        .I $G(DSOATF)=1 K DSOATF,TXNUL Q
        I $G(DSOATF)=1 K DSOATF,TXNUL S Y="@48" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D SOSNATF^ONCNTX1 K NTX,TXNO S Y="@48" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D SOSNATF^ONCUTX1 K NTX,TXUNK S Y="@48" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@48" Q
        N DI,DIC,DA,DR,DIQ,ONC
        S DA=D0,DIC="^ONCO(165.5,",DIQ="ONC(",DIQ(0)="E"
        S DR="139.5;139.3"
        D EN^DIQ1
        I $G(DSOATF)'=1 D
        .W !!,$P(^DD(165.5,139.5,0),U,1),": "_$E(ONC(165.5,DA,139.5,"E"),1,48)
        .W !,$P(^DD(165.5,139.3,0),U,1),": "_ONC(165.5,DA,139.3,"E") Q
        K DSOATF,TXNO,TXUNK,TXNUL S Y="@48" Q
        ;
CHKCOC  ;CLASS OF CASE
        S COC=$E($$GET1^DIQ(165.5,DA,.04),1,2)
        Q
        ;
CLEANUP ;Cleanup
        K D0,Y
