XUZKEYS ; GENERATED FROM 'KEY/NEW PERSON LIST' PRINT TEMPLATE (#1422) ; 09/19/10 ; (FILE 19.1, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1422,"DXS")
 S I(0)="^DIC(19.1,",J(0)=19.1
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.3) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(200)) X DSC(200) E  Q
 W:$X>0 ! S I(100)="^VA(200,",J(100)=200
 F Y=0:0 Q:$Y>4  W !
 S X=$G(^VA(200,D0,0)) W ?0,$E($P(X,U,1),1,20)
 S X=$G(^VA(200,D0,201)) W ?22 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^DIC(19,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,25)
 S X=$G(^VA(200,D0,0)) W ?49,$E($P(X,U,4),1,9)
 S X=$G(^VA(200,D0,5)) W ?60,$E($P(X,U,2),1,5)
 W ?67 S DIP(101)=$S($D(^VA(200,D0,0)):^(0),1:"") S X=$P(DIP(101),U,11) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,?49,"FILE"
 W !,?49,"MANAGER"
 W !,?49,"ACCESS",?60,"MAIL"
 W !,?0,"NAME",?22,"PRIMARY MENU OPTION",?49,"CODE",?60,"CODE",?67,"TERMINATED"
 W !,"--------------------------------------------------------------------------------",!!
