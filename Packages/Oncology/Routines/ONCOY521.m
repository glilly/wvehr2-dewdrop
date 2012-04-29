ONCOY521 ; GENERATED FROM 'ONCOY52' PRINT TEMPLATE (#862) ; 03/30/98 ; (continued)
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
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "Presentation at Cancer Conference:  "
 S X=$G(^ONCO(165.5,D0,0)) S Y=$P(X,U,26) W:Y]"" $S($D(DXS(17,Y)):DXS(17,Y),1:Y)
 D N:$X>10 Q:'DN  W ?10 W "Date of Cancer Conference:  "
 S Y=$P(X,U,27) S Y(0)=Y S X=Y D DATEOT^ONCOES W $E(Y,1,30)
 D N:$X>7 Q:'DN  W ?7 W "Referral to Support Services:  "
 S X=$G(^ONCO(165.5,D0,0)) S Y=$P(X,U,28) W:Y]"" $S($D(DXS(18,Y)):DXS(18,Y),1:Y)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
