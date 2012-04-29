MCARORF1 ; GENERATED FROM 'MCRHPHYS' PRINT TEMPLATE (#1015) ; 09/19/10 ; (continued)
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
 D N:$X>0 Q:'DN  W ?0 W "Chest Expansion"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,13) W:Y]"" $J(Y,8,0)
 D N:$X>40 Q:'DN  W ?40 W " cm"
 D N:$X>0 Q:'DN  W ?0 W "Occiput - Wall"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,14) W:Y]"" $J(Y,8,0)
 D N:$X>40 Q:'DN  W ?40 W " cm"
 D N:$X>0 Q:'DN  W ?0 W "Finger-to-Palm Crease - left"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,15) W:Y]"" $J(Y,8,1)
 D N:$X>40 Q:'DN  W ?40 W " cm"
 D N:$X>0 Q:'DN  W ?0 W "Finger-to-Palm Crease - Right"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,16) W:Y]"" $J(Y,8,1)
 D N:$X>40 Q:'DN  W ?40 W " cm"
 D N:$X>0 Q:'DN  W ?0 W "Interincisor Distance"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,17) W:Y]"" $J(Y,8,0)
 D N:$X>40 Q:'DN  W ?40 W " mm"
 D N:$X>0 Q:'DN  W ?0 W "Schirmer Test"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,18) W:Y]"" $J(Y,8,0)
 D N:$X>40 Q:'DN  W ?40 W " mm"
 D N:$X>0 Q:'DN  W ?0 W "Walk Time (50 feet)"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,19) W:Y]"" $J(Y,8,0)
 D N:$X>40 Q:'DN  W ?40 W " secs"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "M I S C E L L A N E O U S :"
 D N:$X>0 Q:'DN  W ?0 W "Functional Class (ARA)"
 D N:$X>63 Q:'DN  W ?63 S Y=$P(X,U,20) W:Y]"" $J($S($D(DXS(50,Y)):DXS(50,Y),1:Y),16)
 D N:$X>0 Q:'DN  W ?0 W "Disease Severity - Patient Estimate"
 D N:$X>63 Q:'DN  W ?63 S Y=$P(X,U,21) W:Y]"" $J($S($D(DXS(51,Y)):DXS(51,Y),1:Y),16)
 D N:$X>0 Q:'DN  W ?0 W "Disease Severity - Physician Estimate"
 D N:$X>63 Q:'DN  W ?63 S Y=$P(X,U,52) W:Y]"" $J($S($D(DXS(52,Y)):DXS(52,Y),1:Y),16)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "J O I N T   E X A M I N A T I O N:"
 D N:$X>0 Q:'DN  W ?0 W "LEFT"
 D N:$X>70 Q:'DN  W ?70 W "RIGHT"
 D N:$X>0 Q:'DN  W ?0 W "----"
 D N:$X>70 Q:'DN  W ?70 W "-----"
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(53,Y)):DXS(53,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "Fingers - DIPs"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,23) W:Y]"" $J($S($D(DXS(54,Y)):DXS(54,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,24) W:Y]"" $S($D(DXS(55,Y)):DXS(55,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "Fingers - PIPs"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,25) W:Y]"" $J($S($D(DXS(56,Y)):DXS(56,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,26) W:Y]"" $S($D(DXS(57,Y)):DXS(57,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "MCPs"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,27) W:Y]"" $J($S($D(DXS(58,Y)):DXS(58,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,28) W:Y]"" $S($D(DXS(59,Y)):DXS(59,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "First Carpomentacarpal"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,29) W:Y]"" $J($S($D(DXS(60,Y)):DXS(60,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,30) W:Y]"" $S($D(DXS(61,Y)):DXS(61,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "Wrist"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,31) W:Y]"" $J($S($D(DXS(62,Y)):DXS(62,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,32) W:Y]"" $S($D(DXS(63,Y)):DXS(63,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "Elbow"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,33) W:Y]"" $J($S($D(DXS(64,Y)):DXS(64,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,34) W:Y]"" $S($D(DXS(65,Y)):DXS(65,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "Shoulder"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,35) W:Y]"" $J($S($D(DXS(66,Y)):DXS(66,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,36) W:Y]"" $S($D(DXS(67,Y)):DXS(67,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "Sternoclavicular"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,37) W:Y]"" $J($S($D(DXS(68,Y)):DXS(68,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,38) W:Y]"" $S($D(DXS(69,Y)):DXS(69,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "TMJ"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,39) W:Y]"" $J($S($D(DXS(70,Y)):DXS(70,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,40) W:Y]"" $S($D(DXS(71,Y)):DXS(71,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "HIP"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,41) W:Y]"" $J($S($D(DXS(72,Y)):DXS(72,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,42) W:Y]"" $S($D(DXS(73,Y)):DXS(73,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "Knee"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,43) W:Y]"" $J($S($D(DXS(74,Y)):DXS(74,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,44) W:Y]"" $S($D(DXS(75,Y)):DXS(75,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "Ankle"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,45) W:Y]"" $J($S($D(DXS(76,Y)):DXS(76,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,46) W:Y]"" $S($D(DXS(77,Y)):DXS(77,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "MTP"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,47) W:Y]"" $J($S($D(DXS(78,Y)):DXS(78,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,48) W:Y]"" $S($D(DXS(79,Y)):DXS(79,Y),1:Y)
 D N:$X>30 Q:'DN  W ?30 W "Toes - PIP"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,49) W:Y]"" $J($S($D(DXS(80,Y)):DXS(80,Y),1:Y),8)
 D T Q:'DN  D N D N:$X>30 Q:'DN  W ?30 W "Cervical Spine"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,50) W:Y]"" $J($S($D(DXS(81,Y)):DXS(81,Y),1:Y),8)
 D N:$X>30 Q:'DN  W ?30 W "Lumber Spine"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,51) W:Y]"" $J($S($D(DXS(82,Y)):DXS(82,Y),1:Y),8)
 F Y=0:0 Q:$Y>(IOSL-3)  W !
 D N:$X>0 Q:'DN  W ?0 W " "
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
