MCAROGI ; GENERATED FROM 'MCARGICON' PRINT TEMPLATE (#982) ; 09/19/10 ; (FILE 699, MARGIN=80)
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
 S I(0)="^MCAR(699,",J(0)=699
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Consulting Doctor:  "
 S X=$G(^MCAR(699,D0,0)) W ?22 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Consultation Type:  "
 S X=$G(^MCAR(699,D0,15)) W ?22 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^MCAR(699.82,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Subjective:"
 S I(1)=20,J(1)=699.66 F D1=0:0 Q:$O(^MCAR(699,D0,20,D1))'>0  S D1=$O(^(D1)) D:$X>13 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^MCAR(699,D0,20,D1,0)) S DIWL=14,DIWR=73 D ^DIWP
 Q
A1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Objective:"
 S I(1)=21,J(1)=699.67 F D1=0:0 Q:$O(^MCAR(699,D0,21,D1))'>0  S D1=$O(^(D1)) D:$X>12 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^MCAR(699,D0,21,D1,0)) S DIWL=14,DIWR=73 D ^DIWP
 Q
B1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Assessment:"
 S I(1)=22,J(1)=699.68 F D1=0:0 Q:$O(^MCAR(699,D0,22,D1))'>0  S D1=$O(^(D1)) D:$X>13 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^MCAR(699,D0,22,D1,0)) S DIWL=14,DIWR=73 D ^DIWP
 Q
C1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Planned:"
 S I(1)=23,J(1)=699.69 F D1=0:0 Q:$O(^MCAR(699,D0,23,D1))'>0  S D1=$O(^(D1)) D:$X>10 T Q:'DN  D D1
 G D1R
D1 ;
 S X=$G(^MCAR(699,D0,23,D1,0)) S DIWL=14,DIWR=73 D ^DIWP
 Q
D1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Indication Comment:  "
 S X=$G(^MCAR(699,D0,0)) D T Q:'DN  S DIWL=25,DIWR=80 S Y=$P(X,U,6) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  W ?2 D DISP^MCMAG K DIP K:DN Y
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
