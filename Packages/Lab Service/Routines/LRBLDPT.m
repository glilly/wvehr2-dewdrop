LRBLDPT ; GENERATED FROM 'LRBL DONOR TESTING REPORT' PRINT TEMPLATE (#108) ; 09/19/10 ; (FILE 65.5, MARGIN=132)
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
 I $D(DXS)<9 M DXS=^DIPT(108,"DXS")
 S I(0)="^LRE(",J(0)=65.5
 S I(1)=5,J(1)=65.54 F D1=0:0 Q:$O(^LRE(D0,5,D1))'>0  X:$D(DSC(65.54)) DSC(65.54) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^LRE(D0,5,D1,0)) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) D DT
 D N:$X>14 Q:'DN  W ?14,$E($P(X,U,4),1,10)
 Q
A1R ;
 D N:$X>26 Q:'DN  W ?26 S Y=D0 W:Y]"" $J(Y,5,0)
 S X=$G(^LRE(D0,0)) D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 S Y=$P(X,U,5) W:Y]"" $J($S($D(DXS(4,Y)):DXS(4,Y),1:Y),2)
 D N:$X>42 Q:'DN  W ?42 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 S I(1)=5,J(1)=65.54 F D1=0:0 Q:$O(^LRE(D0,5,D1))'>0  X:$D(DSC(65.54)) DSC(65.54) S D1=$O(^(D1)) Q:D1'>0  D:$X>47 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^LRE(D0,5,D1,10)) D N:$X>47 Q:'DN  W ?47 S Y=$P(X,U,1) W:Y]"" $J($S($D(DXS(6,Y)):DXS(6,Y),1:Y),3)
 S X=$G(^LRE(D0,5,D1,11)) D N:$X>51 Q:'DN  W ?51 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 S X=$G(^LRE(D0,5,D1,15)) D N:$X>55 Q:'DN  W ?55 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 S X=$G(^LRE(D0,5,D1,12)) D N:$X>59 Q:'DN  W ?59 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 S X=$G(^LRE(D0,5,D1,13)) D N:$X>63 Q:'DN  W ?63 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 S X=$G(^LRE(D0,5,D1,14)) D N:$X>67 Q:'DN  W ?67 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 S X=$G(^LRE(D0,5,D1,18)) D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 S X=$G(^LRE(D0,5,D1,0)) D N:$X>76 Q:'DN  W ?76 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(13,Y)):DXS(13,Y),1:Y)
 S I(2)=66,J(2)=65.66 F D2=0:0 Q:$O(^LRE(D0,5,D1,66,D2))'>0  X:$D(DSC(65.66)) DSC(65.66) S D2=$O(^(D2)) Q:D2'>0  D:$X>87 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^LRE(D0,5,D1,66,D2,0)) D N:$X>86 Q:'DN  W ?86 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^LAB(66,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,15)
 D N:$X>103 Q:'DN  W ?103 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(14,Y)):DXS(14,Y),1:Y)
 D N:$X>111 Q:'DN  W ?111 S Y=$P(X,U,4) D DT
 D N:$X>124 Q:'DN  W ?124 X DXS(1,9) K DIP K:DN Y W $E(X,1,3)
 D N:$X>128 Q:'DN  W ?128 X DXS(2,9) K DIP K:DN Y W $E(X,1,3)
 Q
A2R ;
 Q
B1R ;
 K Y
 Q
HEAD ;
 W !,?111,"EXPIRATION"
 W !,?0,"DONATION DATE",?14,"UNIT #",?26,"DONOR",?33,"PDef",?39,"PR",?42,"REC",?47,"ABO",?51,"Rh",?55,"AbS",?59,"RPR",?63,"Hep",?67,"HIV",?71,"HT1",?76,"COLL.DISP",?86,"COMPONENT",?103,"DISPO.",?111,"DATE",?124,"LTc",?128,"VTc"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!
