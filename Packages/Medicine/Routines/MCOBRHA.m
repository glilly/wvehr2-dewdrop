MCOBRHA ; GENERATED FROM 'MCRHBRPR1' PRINT TEMPLATE (#1037) ; 09/19/10 ; (FILE 701, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1037,"DXS")
 S I(0)="^MCAR(701,",J(0)=701
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Miscellaneous:"
 D N:$X>0 Q:'DN  W ?0 W "FUNCTIONAL CLASS (ACR):"
 S X=$G(^MCAR(701,D0,5)) D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,20) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "DISEASE SEVERITY-PAT. ESTIMATE:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,21) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "DISEASE SEVERITY-PHY. ESTIMATE:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,52) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Joint Examination:"
 D N:$X>29 Q:'DN  W ?29 W "Left"
 D N:$X>69 Q:'DN  W ?69 W "Right"
 D N:$X>29 Q:'DN  W ?29 W "----"
 D N:$X>69 Q:'DN  W ?69 W "-----"
 D N:$X>0 Q:'DN  W ?0 W "FINGERS-DIP"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,23) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "MCPS:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,26) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,27) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "1st CARPOMETACARPAL:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,28) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,29) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "WRIST:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,30) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,31) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "ELBOW:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,32) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,33) W:Y]"" $S($D(DXS(13,Y)):DXS(13,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "SHOULDER:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,34) W:Y]"" $S($D(DXS(14,Y)):DXS(14,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,35) W:Y]"" $S($D(DXS(15,Y)):DXS(15,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "TMJ:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,38) W:Y]"" $S($D(DXS(16,Y)):DXS(16,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,39) W:Y]"" $S($D(DXS(17,Y)):DXS(17,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "COSTOCHONDRAL:"
 S X=$G(^MCAR(701,D0,1)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,11) W:Y]"" $S($D(DXS(18,Y)):DXS(18,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,12) W:Y]"" $S($D(DXS(19,Y)):DXS(19,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "SACROILIAC:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,13) W:Y]"" $S($D(DXS(20,Y)):DXS(20,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,14) W:Y]"" $S($D(DXS(21,Y)):DXS(21,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "HIP:"
 S X=$G(^MCAR(701,D0,5)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,40) W:Y]"" $S($D(DXS(22,Y)):DXS(22,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,41) W:Y]"" $S($D(DXS(23,Y)):DXS(23,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "KNEE:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,42) W:Y]"" $S($D(DXS(24,Y)):DXS(24,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,43) W:Y]"" $S($D(DXS(25,Y)):DXS(25,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "ANKLE:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,44) W:Y]"" $S($D(DXS(26,Y)):DXS(26,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,45) W:Y]"" $S($D(DXS(27,Y)):DXS(27,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "MTP:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,46) W:Y]"" $S($D(DXS(28,Y)):DXS(28,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,47) W:Y]"" $S($D(DXS(29,Y)):DXS(29,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "TOES-PIP:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,48) W:Y]"" $S($D(DXS(30,Y)):DXS(30,Y),1:Y)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,49) W:Y]"" $S($D(DXS(31,Y)):DXS(31,Y),1:Y)
 D N:$X>24 Q:'DN  W ?24 W "CERVICAL SPINE:"
 D N:$X>44 Q:'DN  W ?44 S Y=$P(X,U,50) W:Y]"" $S($D(DXS(32,Y)):DXS(32,Y),1:Y)
 D N:$X>24 Q:'DN  W ?24 W "LUMBAR SPINE:"
 D N:$X>44 Q:'DN  W ?44 S Y=$P(X,U,51) W:Y]"" $S($D(DXS(33,Y)):DXS(33,Y),1:Y)
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "MEDICATION: "
 S I(1)=6,J(1)=701.0201 F D1=0:0 Q:$O(^MCAR(701,D0,6,D1))'>0  X:$D(DSC(701.0201)) DSC(701.0201) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^MCAR(701,D0,6,D1,0)) D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(695,Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^PSDRUG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4,$E($P(X,U,2),1,10)
 D N:$X>4 Q:'DN  W ?4,$E($P(X,U,3),1,10)
 Q
A1R ;
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "DIAGNOSIS: "
 S I(1)=13,J(1)=701.0615 F D1=0:0 Q:$O(^MCAR(701,D0,13,D1))'>0  X:$D(DSC(701.0615)) DSC(701.0615) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^MCAR(701,D0,13,D1,0)) D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(697.5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,50)
 D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,2) D DT
 Q
B1R ;
 S I(1)="""ICD""",J(1)=701.01 F D1=0:0 Q:$O(^MCAR(701,D0,"ICD",D1))'>0  X:$D(DSC(701.01)) DSC(701.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>17 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^MCAR(701,D0,"ICD",D1,0)) D N:$X>9 Q:'DN  S DIWL=10,DIWR=69 S Y=$P(X,U,2) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 Q
C1R ;
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "PROCEDURE SUMMARY: "
 S X=$G(^MCAR(701,D0,.2)) D N:$X>9 Q:'DN  S DIWL=10,DIWR=69 S Y=$P(X,U,2) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "SUMMARY: "
 S X=$G(^MCAR(701,D0,.2)) S Y=$P(X,U,1) W:Y]"" $S($D(DXS(34,Y)):DXS(34,Y),1:Y)
 W ?0 S MCFILE=701 D DISP^MCMAG K DIP K:DN Y
 W ?11 K MCFILE K DIP K:DN Y
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
