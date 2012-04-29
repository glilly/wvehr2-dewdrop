ONCOXDI ; GENERATED FROM 'ONCO XDEATH INFO' PRINT TEMPLATE (#788) ; 09/19/10 ; (FILE 160, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(788,"DXS")
 S I(0)="^ONCO(160,",J(0)=160
 D N:$X>19 Q:'DN  W ?19 W "***********DEATH INFORMATION**********"
 D N:$X>19 Q:'DN  W ?19 W " "
 D N:$X>4 Q:'DN  W ?4 W "Date:  "
 S X=$G(^ONCO(160,D0,1)) S Y=$P(X,U,8) S Y(0)=Y S X=Y D DATEOT^ONCOES W $E(Y,1,30)
 D N:$X>44 Q:'DN  W ?44 W "Place: "
 S X=$G(^ONCO(160,D0,1)) S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^ONCO(165.2,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,40)
 D N:$X>4 Q:'DN  W ?4 W "Cause of Death/Cancer: "
 S Y=$P(X,U,12) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>4 Q:'DN  W ?4 W "ICD Cause:  "
 S I(100)="^ICD9(",J(100)=80 S I(0,0)=D0 S DIP(1)=$S($D(^ONCO(160,D0,1)):^(1),1:"") S X=$P(DIP(1),U,3),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 S X=$G(^ICD9(D0,0)) W ?0,$E($P(X,U,3),1,30)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 W ?4 I $P($G(^ONCO(160,D0,1)),"^",3)="" D WRTSDC^ONCOAI K DIP K:DN Y
 D N:$X>4 Q:'DN  W ?4 W "Care Center: "
 S X=$G(^ONCO(160,D0,1)) S Y=$P(X,U,11) S Y(0)=Y S:Y'="" Y=$S($D(^ONCO(160.19,Y,0)):$P(^(0),U,2),1:Y) W $E(Y,1,30)
 D N:$X>44 Q:'DN  W ?44 W "ICD Revision: "
 S X=$G(^ONCO(160,D0,1)) S Y=$P(X,U,4) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>4 Q:'DN  W ?4 W "Autopsy: "
 S Y=$P(X,U,13) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 W " "
 S Y=$P(X,U,9) S Y(0)=Y S X=Y D DATEOT^ONCOES W $E(Y,1,30)
 D N:$X>42 Q:'DN  W ?42 W "  Autopsy #:  "
 S X=$G(^ONCO(160,D0,1)) W ?0,$E($P(X,U,10),1,15)
 W ?42 K ^UTILITY($J,"W") K DIP K:DN Y
 D N:$X>4 Q:'DN  W ?4 W "Path/Autopsy (Gross & Micro):"
 S:'$D(DIWF) DIWF="" S:DIWF'["N" DIWF=DIWF_"N" S X="" S I(1)=4,J(1)=160.031 F D1=0:0 Q:$O(^ONCO(160,D0,4,D1))'>0  S D1=$O(^(D1)) D:$X>4 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^ONCO(160,D0,4,D1,0)) S DIWL=7,DIWR=78 D ^DIWP
 Q
B1R ;
 D 0^DIWW
 D ^DIWW
 D N:$X>19 Q:'DN  W ?19 W " "
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
