IMRSOPT ;ISC-SF/JLI,HCIOFO/FT-SET UP FOR QUEUEING OF DATA COLLECTION ;1/23/98  14:53
VER ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 ;[IMR QUE DATA COLLECT] - Queue Registry Data Collection
 S X="IMR REGISTRY DATA",DIC(0)="MX",DIC=19 D ^DIC I Y'>0 W:'$D(IMRPOSTI) !,$C(7),"Can't identify the 'IMR REGISTRY DATA' option in the option file",! Q
 S %H=$H D YMD^%DTC S IMRX="T"_$S($E(%_"000000",2,5)>1745:"+1",1:"")_"@1800"
 I '$D(^DIC(19.2,0)) D  G KILL
 .W !!,"Sorry, cannot schedule this option to run because the OPTION SCHEDULING",!,"file (19.2) doesn't exist.",!!
 .Q
 I $D(^DIC(19.2,0)) D
 . N DIC,DIE,DLAYGO,DR,DA
 . S DIC(0)="ML",DIC="^DIC(19.2,",X="IMR REGISTRY DATA",DLAYGO=19.2
 . D ^DIC Q:Y'>0
 . S DA=+Y S DIE="^DIC(19.2,",DR="2///"_IMRX_";6///1D;" D ^DIE
 W:'$D(IMRPOSTI) !!,"The National Registry Data Collection has been queued to run at ",IMRX,!,"and will be automatically requeued at 24 hour intervals",!!
KILL K DA,DR,DIE,DIC,IMRX,%,%H,Y,%DT,%I,%T,%X,%Y,D,D0,DI,DQ,I,X,DISYS,POP
 Q
 ;
CHEK ; called from [IMR MENU (MANAGEMENT)] entry action
 W:$D(IOF) @IOF W !,"ICR PACKAGE VERSION ",$P($T(VER),";",3)
 I '$D(^XUSEC("IMRMGR",DUZ)) S IMRLOC="CHEK^IMRSOPT" D ACESSERR^IMRERR,H^XUS K IMRLOC
 I '$D(^IMR(158.9,1,0)) W !?10,$C(7),"Site Parameter File needs to be initialized",! Q
 S X=^IMR(158.9,1,0),X1=$P(X,U,9),X2=$P(X,U,10) I X1=""&(X2="") W !!,"The data collection option has not been run yet",!! K X,X1,X2 Q
 I X2="",X1>0 W !,"The data collection option apparently started running for the first time ",! S X=X1 D PDATE W !! K X,X1,X2 Q
 I X2<X1 W !,"The data collection option last finished " S X=X2 D PDATE W !?3,"and started running again " S X=X1 D PDATE W !! K X1,X2,X Q
 I X2>X1 W !!?3,"The data collection option last was run between ",!!?5 S X=X1 D PDATE W "   and   " S X=X2 D PDATE W ! K X,X1,X2
 Q
 ;
PDATE S %=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)_" ",X=$E($P(X,".",2)_"000000",1,6),%=%_$E(X,1,2)_":"_$E(X,3,4)_":"_$E(X,5,6) W % K %
 Q
 ;
