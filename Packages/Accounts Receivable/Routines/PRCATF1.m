PRCATF1 ; GENERATED FROM 'PRCA FMS STATUS' PRINT TEMPLATE (#442) ; 09/19/10 ; (FILE 347, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(442,"DXS")
 S I(0)="^RC(347,",J(0)=347
 W ?0 W:$D(IOF) @IOF K DIP K:DN Y
 S X="A/R Document Status Inquiry",X=$J("",$S($D(DIWR)+$D(DIWL)=2:DIWR-DIWL+1,$D(IOM):IOM,1:80)-$L(X)\2-$X)_X K DIP K:DN Y W X
 F Y=0:0 Q:$Y>1  W !
 D N:$X>0 Q:'DN  W ?0 W " "
 D N:$X>0 Q:'DN  W ?0 W "Bill Number: "
 S X=$G(^RC(347,D0,0)) S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^PRCA(430,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>29 Q:'DN  W ?29 W "Amount: "
 S I(100)="^PRCA(430,",J(100)=430 S I(0,0)=D0 S DIP(1)=$S($D(^RC(347,D0,0)):^(0),1:"") S X=$P(DIP(1),U,7),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 S X=$G(^PRCA(430,D0,0)) S Y=$P(X,U,3) W:Y]"" $J(Y,10,2)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D N:$X>49 Q:'DN  W ?49 W "Debtor: "
 S I(100)="^PRCA(430,",J(100)=430 S I(0,0)=D0 S DIP(1)=$S($D(^RC(347,D0,0)):^(0),1:"") S X=$P(DIP(1),U,7),X=X S D(0)=+X S D0=D(0) I D0>0 D B1
 G B1R
B1 ;
 S X=$G(^PRCA(430,D0,0)) S Y=$P(X,U,9) S C=$P(^DD(430,9,0),U,2) D Y^DIQ:Y S C="," W $E(Y,1,30)
 Q
B1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 F Y=0:0 Q:$Y>4  W !
 W ?0 W " "
 D N:$X>4 Q:'DN  W ?4 W "Last Update: "
 S X=$G(^RC(347,D0,0)) S Y=$P(X,U,5) D DT
 D N:$X>49 Q:'DN  W ?49 W "STATUS: "
 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W " " K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,?0,"W:$D(IOF)"
 W !,?0,"@IOF"
 W !,?0,"W"
 W !,"--------------------------------------------------------------------------------",!!
