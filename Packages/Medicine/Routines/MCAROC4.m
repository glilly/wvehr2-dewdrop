MCAROC4 ; GENERATED FROM 'MCARCATH4' PRINT TEMPLATE (#971) ; 09/19/10 ; (FILE 691.1, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(971,"DXS")
 S I(0)="^MCAR(691.1,",J(0)=691.1
 S I(1)=37,J(1)=691.36 F D1=0:0 Q:$O(^MCAR(691.1,D0,37,D1))'>0  X:$D(DSC(691.36)) DSC(691.36) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 D T Q:'DN  D N D N D N:$X>32 Q:'DN  W ?32 X DXS(1,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>23 Q:'DN  W ?23 W "STARTING"
 D N:$X>38 Q:'DN  W ?38 W "RESULTING"
 D N:$X>53 Q:'DN  W ?53 W "STARTING"
 D N:$X>65 Q:'DN  W ?65 W "RESULTING"
 D N:$X>6 Q:'DN  W ?6 W "SEGMENT"
 D N:$X>21 Q:'DN  W ?21 W "% OBSTRUCTION"
 D N:$X>36 Q:'DN  W ?36 W "% OBSTRUCTION"
 D N:$X>53 Q:'DN  W ?53 W "GRADIENT"
 D N:$X>65 Q:'DN  W ?65 W "GRADIENT"
 S X=$G(^MCAR(691.1,D0,37,D1,0)) D N:$X>7 Q:'DN  W ?7 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(696,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>23 Q:'DN  W ?23 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^MCAR(696.1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 S X=$G(^MCAR(691.1,D0,37,D1,3)) D N:$X>23 Q:'DN  W ?23 S Y=$P(X,U,1) W:Y]"" $J(Y,7,2)
 S X=$G(^MCAR(691.1,D0,37,D1,0)) D N:$X>40 Q:'DN  W ?40 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^MCAR(696.1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 S X=$G(^MCAR(691.1,D0,37,D1,3)) D N:$X>40 Q:'DN  W ?40 S Y=$P(X,U,2) W:Y]"" $J(Y,7,2)
 S X=$G(^MCAR(691.1,D0,37,D1,0)) D N:$X>55 Q:'DN  W ?55 S Y=$P(X,U,4) W:Y]"" $J(Y,4,0)
 D N:$X>67 Q:'DN  W ?67 S Y=$P(X,U,5) W:Y]"" $J(Y,4,0)
 Q
A1R ;
 D T Q:'DN  D N D N D N:$X>29 Q:'DN  W ?29 X DXS(2,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 X DXS(3,9) K DIP K:DN Y W X
 D N:$X>7 Q:'DN  W ?7 X DXS(4,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W X
 D N:$X>7 Q:'DN  W ?7 X DXS(5,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W X
 D N:$X>7 Q:'DN  W ?7 X DXS(6,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W X
 D N:$X>7 Q:'DN  W ?7 W "WALL MOTION:"
 S I(1)=39,J(1)=691.39 F D1=0:0 Q:$O(^MCAR(691.1,D0,39,D1))'>0  X:$D(DSC(691.39)) DSC(691.39) S D1=$O(^(D1)) Q:D1'>0  D:$X>21 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^MCAR(691.1,D0,39,D1,0)) D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(696.5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 W ", "
 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 Q
B1R ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 S DIP(1)=$S($D(^MCAR(691.1,D0,40)):^(40),1:"") S X="EJECTION FRACTION: "_$P(DIP(1),U,3) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 X DXS(7,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 S DIP(1)=$S($D(^MCAR(691.1,D0,40)):^(40),1:"") S X="MITRAL REGURGITATION: "_$S('$D(^MCAR(696.7,+$P(DIP(1),U,1),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 X DXS(8,9) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 X DXS(9,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "COMPLICATIONS: "
 S DICMX="D L^DIWP" D N:$X>20 Q:'DN  S DIWL=21,DIWR=78 X DXS(10,9) K DIP K:DN Y
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 S DIP(1)=$S($D(^MCAR(691.1,D0,42)):^(42),1:"") S X="IMPRESSION: "_$S('$D(^MCAR(693.2,+$P(DIP(1),U,1),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "CONCLUSION:"
 S I(1)=43,J(1)=691.41 F D1=0:0 Q:$O(^MCAR(691.1,D0,43,D1))'>0  S D1=$O(^(D1)) D:$X>17 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^MCAR(691.1,D0,43,D1,0)) S DIWL=18,DIWR=77 D ^DIWP
 Q
C1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "PLAN:"
 S I(1)=44,J(1)=691.42 F D1=0:0 Q:$O(^MCAR(691.1,D0,44,D1))'>0  S D1=$O(^(D1)) D:$X>11 T Q:'DN  D D1
 G D1R
D1 ;
 S X=$G(^MCAR(691.1,D0,44,D1,0)) S DIWL=12,DIWR=76 D ^DIWP
 Q
D1R ;
 D 0^DIWW
 D ^DIWW
 D N:$X>24 Q:'DN  W ?24 W "------------------------------"
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "CARDIOLOGY FELLOW: "
 S X=$G(^MCAR(691.1,D0,45)) W ?25 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>4 Q:'DN  W ?4 W "CARDIOLOGY FELLOW (2nd): "
 S X=$G(^MCAR(691.1,D0,5)) W ?4 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "CARDIOLOGY STAFF: "
 S X=$G(^MCAR(691.1,D0,45)) W ?24 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>4 Q:'DN  W ?4 W "CARDIOLOGY STAFF (2nd): "
 S X=$G(^MCAR(691.1,D0,5)) W ?4 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 W ?41 S MCFILE=691.1 D DISP^MCMAG K DIP K:DN Y
 W ?52 K MCFILE K DIP K:DN Y
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
