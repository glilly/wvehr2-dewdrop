PRCATO4 ; GENERATED FROM 'PRCA DISP ADJ' PRINT TEMPLATE (#397) ; 09/19/10 ; (FILE 433, MARGIN=80)
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
 S I(0)="^PRCA(433,",J(0)=433
 D N:$X>0 Q:'DN  W ?0 S X="=",DIP(1)=X S X=75,X1=DIP(1) S %=X,X="" Q:X1=""  S $P(X,X1,%\$L(X1)+1)=X1,X=$E(X,1,%) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "BILL NO.: "
 S X=$G(^PRCA(433,D0,0)) D N:$X>12 Q:'DN  W ?12 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^PRCA(430,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>39 Q:'DN  W ?39 W "ADJUSTMENT AMOUNT: "
 S X=$G(^PRCA(433,D0,1)) D N:$X>61 Q:'DN  W ?61 S Y=$P(X,U,5) W:Y]"" $J(Y,10,2)
 D N:$X>0 Q:'DN  W ?0 W "ADJUSTMENT DATE: "
 D N:$X>21 Q:'DN  W ?21 S Y=$P(X,U,1) D DT
 D N:$X>39 Q:'DN  W ?39 W "ADJUSTMENT NO.: "
 D N:$X>59 Q:'DN  W ?59,$E($P(X,U,4),1,5)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "FISCAL YEAR"
 D N:$X>19 Q:'DN  W ?19 W "ADJ.AMOUNT"
 D N:$X>34 Q:'DN  W ?34 W "PRIN.BAL.(ADJUSTED)"
 S I(1)=4,J(1)=433.01 F D1=0:0 Q:$O(^PRCA(433,D0,4,D1))'>0  X:$D(DSC(433.01)) DSC(433.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>55 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^PRCA(433,D0,4,D1,0)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,1),1,30)
 D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,5) W:Y]"" $J(Y,10,2)
 D N:$X>34 Q:'DN  W ?34 S Y=$P(X,U,2) W:Y]"" $J(Y,11,2)
 Q
A1R ;
 D N:$X>0 Q:'DN  W ?0 W " "
 D N:$X>0 Q:'DN  W ?0 W "Brief Comment: "
 S X=$G(^PRCA(433,D0,5)) D N:$X>15 Q:'DN  W ?15,$E($P(X,U,2),1,30)
 D N:$X>49 Q:'DN  W ?49 W "Follow-up Date: "
 D N:$X>65 Q:'DN  W ?65 S DIP(1)=$S($D(^PRCA(433,D0,5)):^(5),1:"") S X=$P(DIP(1),U,3) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W " "
 D N:$X>0 Q:'DN  W ?0 W "Comments: "
 S I(1)=7,J(1)=433.041 F D1=0:0 Q:$O(^PRCA(433,D0,7,D1))'>0  S D1=$O(^(D1)) D:$X>12 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^PRCA(433,D0,7,D1,0)) S DIWL=1,DIWR=78 D ^DIWP
 Q
B1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S X="=",DIP(1)=X S X=75,X1=DIP(1) S %=X,X="" Q:X1=""  S $P(X,X1,%\$L(X1)+1)=X1,X=$E(X,1,%) K DIP K:DN Y W X
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
