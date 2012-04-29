PPPXS ; GENERATED FROM 'PPPSTAP' PRINT TEMPLATE (#506) ; 09/19/10 ; (FILE 1020.3, MARGIN=80)
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
 S I(0)="^PPP(1020.3,",J(0)=1020.3
 D N:$X>0 Q:'DN  W ?0 W "Date Initialized...................... "
 S X=$G(^PPP(1020.3,D0,0)) D N:$X>39 Q:'DN  W ?39 S Y=$P(X,U,2) D DT
 D N:$X>0 Q:'DN  W ?0 W "Total PDX's Sent...................... "
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,3),1,10)
 D N:$X>0 Q:'DN  W ?0 W "Total Alerts Issued................... "
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,4),1,10)
 D N:$X>0 Q:'DN  W ?0 W "Total Alerts Ignored.................. "
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,5),1,10)
 D N:$X>0 Q:'DN  W ?0 W "Total Manual Entries Added............ "
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,6),1,10)
 D N:$X>0 Q:'DN  W ?0 W "Total Entries Deleted................. "
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,7),1,10)
 D N:$X>0 Q:'DN  W ?0 W "Total Entries Edited.................. "
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,8),1,10)
 D N:$X>0 Q:'DN  W ?0 W "Total New Patients Added.............. "
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,9),1,10)
 D N:$X>0 Q:'DN  W ?0 W "Total Profiles Viewed................. "
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,10),1,10)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
