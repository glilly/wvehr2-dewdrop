DVBHCE1 ; ;09/19/10
 S X=DG(DQ),DIC=DIE
 X "I X'=""Y"" S DGXRF=.3285 D ^DGDDC Q"
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.3285,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.32)):^(.32),1:"") S X=$P(Y(1),U,20),X=X S DIU=X K Y S X=DIV S X="N" X ^DD(2,.3285,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$C(59)_$P($G(^DD(2,.3285,0)),U,3) S X=$P($P(Y(1),$C(59)_Y(0)_":",2),$C(59))'="YES" I X S X=DIV S Y(1)=$S($D(^DPT(D0,.32)):^(.32),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X="" X ^DD(2,.3285,1,3,1.4)
