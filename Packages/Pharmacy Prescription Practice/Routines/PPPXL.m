PPPXL ; GENERATED FROM 'PPP LOGP' PRINT TEMPLATE (#508) ; 09/19/10 ; (FILE 1020.4, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 I $D(DXS)<9 M DXS=^DIPT(508,"DXS")
 S I(0)="^PPP(1020.4,",J(0)=1020.4
 D T Q:'DN  D N W ?0 W "DATE/TIME:"
 D N:$X>11 Q:'DN  W ?11 S DIP(1)=$S($D(^PPP(1020.4,D0,0)):^(0),1:"") S X=$P(DIP(1),U,3) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 D N:$X>20 Q:'DN  W ?20 X DXS(1,9.2) S X=$E(DIP(4),DIP(5),X)_":" K DIP K:DN Y W $E(X,1,2)
 W ":"
 X DXS(2,9.2) S X=$E(DIP(4),DIP(5),X) K DIP K:DN Y W $E(X,1,2)
 W ":"
 X DXS(3,9.2) S X=$E(DIP(4),DIP(5),X) K DIP K:DN Y W $E(X,1,2)
 D N:$X>34 Q:'DN  W ?34 W "USER:"
 S X=$G(^PPP(1020.4,D0,0)) D N:$X>40 Q:'DN  W ?40 S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>0 Q:'DN  W ?0 W "ROUTINE  :"
 S X=$G(^PPP(1020.4,D0,1)) D N:$X>11 Q:'DN  W ?11,$E($P(X,U,1),1,20)
 S I(100)="^PPP(1020.6,",J(100)=1020.6 S I(0,0)=D0 S DIP(1)=$S($D(^PPP(1020.4,D0,0)):^(0),1:"") S X=$P(DIP(1),U,1),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 S X=$G(^PPP(1020.6,D0,0)) D T Q:'DN  W ?0,$E($P(X,U,2),1,80)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 S X=$G(^PPP(1020.4,D0,2)) D T Q:'DN  W ?0,$E($P(X,U,1),1,245)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
