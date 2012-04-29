MCARORH ; GENERATED FROM 'MCRHHIST' PRINT TEMPLATE (#1000) ; 09/19/10 ; (FILE 701, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1000,"DXS")
 S I(0)="^MCAR(701,",J(0)=701
 F Y=0:0 Q:$Y>-1  W !
 D N:$X>0 Q:'DN  W ?0 W "Patient History"
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Head,Eyes,Ears,Nose,Mouth:"
 D N:$X>0 Q:'DN  W ?0 W "BLURRED VISION:"
 S X=$G(^MCAR(701,D0,0)) D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "DRY EYES:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "Musculosketal:"
 D N:$X>0 Q:'DN  W ?0 W "RINGING IN EARS:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,15) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "STIFF IN THE MORNING HOW LONG:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,36) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "HEARING DIFFICULTIES:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "JOINT PAIN:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,37) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "MOUTH SORES:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,13) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "JOINT SWELLING:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,38) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "DRY MOUTH:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "LOW BACK PAIN:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,39) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "LOSS,CHANGE IN TASTE:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,11) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "MUSCLE PAIN:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,40) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "HEADACHE:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "NECK PAIN:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,41) W:Y]"" $S($D(DXS(13,Y)):DXS(13,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "DIZZINESS:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(14,Y)):DXS(14,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "NUMBNESS OR TINGLING:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,43) W:Y]"" $S($D(DXS(15,Y)):DXS(15,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "FEVER:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(16,Y)):DXS(16,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "SWELLING OF LEGS:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,44) W:Y]"" $S($D(DXS(17,Y)):DXS(17,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "NIGHT SWEATS:"
 S X=$G(^MCAR(701,D0,1)) D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(18,Y)):DXS(18,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "WEAKNESS OF MUSCLES:"
 S X=$G(^MCAR(701,D0,0)) D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,45) W:Y]"" $S($D(DXS(19,Y)):DXS(19,Y),1:Y)
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Chest, Lung, and Heart:"
 D N:$X>39 Q:'DN  W ?39 W "Neurologic and Psychologic:"
 D N:$X>0 Q:'DN  W ?0 W "CHEST PAIN/TAKING DEEP BREATH:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,17) W:Y]"" $S($D(DXS(20,Y)):DXS(20,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "DEPRESSION:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,46) W:Y]"" $S($D(DXS(21,Y)):DXS(21,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "SHORTNESS OF BREATH:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,18) W:Y]"" $S($D(DXS(22,Y)):DXS(22,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "INSOMNIA:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,47) W:Y]"" $S($D(DXS(23,Y)):DXS(23,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "WHEEZING(ASTHMA):"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,19) W:Y]"" $S($D(DXS(24,Y)):DXS(24,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "NERVOUSNESS:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,48) W:Y]"" $S($D(DXS(25,Y)):DXS(25,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "SEIZURES OR CONVULSION:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,49) W:Y]"" $S($D(DXS(26,Y)):DXS(26,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "TIREDNESS:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,50) W:Y]"" $S($D(DXS(27,Y)):DXS(27,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "TROUBLE REMEMBERING/THINKING:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,51) W:Y]"" $S($D(DXS(28,Y)):DXS(28,Y),1:Y)
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Gastrointestinal Tract:"
 D N:$X>39 Q:'DN  W ?39 W "Skin:"
 D N:$X>0 Q:'DN  W ?0 W "LOSS OF APPETITE:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,28) W:Y]"" $S($D(DXS(29,Y)):DXS(29,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "EASY BRUISING:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,52) W:Y]"" $S($D(DXS(30,Y)):DXS(30,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "DIFFICULTY SWALLOWING:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,23) W:Y]"" $S($D(DXS(31,Y)):DXS(31,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "FACIAL SKIN TIGHTENING:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,53) W:Y]"" $S($D(DXS(32,Y)):DXS(32,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "NAUSEA:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,71) W:Y]"" $S($D(DXS(33,Y)):DXS(33,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "HIVES OR WELTS:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,54) W:Y]"" $S($D(DXS(34,Y)):DXS(34,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "HEARTBURN,INDIGESTION,BELCHING:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,25) W:Y]"" $S($D(DXS(35,Y)):DXS(35,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "LOSS OF HAIR:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,12) W:Y]"" $S($D(DXS(36,Y)):DXS(36,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "VOMITING:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,31) W:Y]"" $S($D(DXS(37,Y)):DXS(37,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "ITCHING:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,55) W:Y]"" $S($D(DXS(38,Y)):DXS(38,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "PAIN/DISCOMFORT UPPER ABDOMEN:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,30) W:Y]"" $S($D(DXS(39,Y)):DXS(39,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "RASH:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,56) W:Y]"" $S($D(DXS(40,Y)):DXS(40,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "JAUNDICE:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,26) W:Y]"" $S($D(DXS(41,Y)):DXS(41,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "RASH OVER CHEEKS:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,57) W:Y]"" $S($D(DXS(42,Y)):DXS(42,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "LIVER:"
 S X=$G(^MCAR(701,D0,1)) W ?0,$J($P(X,U,2),29)
 D N:$X>39 Q:'DN  W ?39 W "SKIN COLOR CHANGE IN FINGERS:"
 S X=$G(^MCAR(701,D0,0)) D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,58) W:Y]"" $S($D(DXS(43,Y)):DXS(43,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "PAIN/CRAMPS LOWER ABDOMEN:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,29) W:Y]"" $S($D(DXS(44,Y)):DXS(44,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "SUN SENSITIVITY:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,59) W:Y]"" $S($D(DXS(45,Y)):DXS(45,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "DIARRHEA(FREQUENT,WATERY):"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(46,Y)):DXS(46,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CONSTIPATION:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,21) W:Y]"" $S($D(DXS(47,Y)):DXS(47,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "BLK/TARRY STOOL(NOT FROM IRON:"
 D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,20) W:Y]"" $S($D(DXS(48,Y)):DXS(48,Y),1:Y)
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Genitourinary:"
 D N:$X>39 Q:'DN  W ?39 W "Blood:"
 D N:$X>0 Q:'DN  W ?0 W "URINE PROTEIN:"
 S X=$G(^MCAR(701,D0,1)) D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(49,Y)):DXS(49,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "LOW WHITE BLOOD COUNT:"
 S X=$G(^MCAR(701,D0,10)) D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(50,Y)):DXS(50,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "BLOOD IN URINE:"
 S X=$G(^MCAR(701,D0,0)) D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,32) W:Y]"" $S($D(DXS(51,Y)):DXS(51,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "LOW PLATELETS:"
 S X=$G(^MCAR(701,D0,10)) D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(52,Y)):DXS(52,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "BURNING ON URINATION:"
 S X=$G(^MCAR(701,D0,0)) D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,33) W:Y]"" $S($D(DXS(53,Y)):DXS(53,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "LOW RED BLOOD COUNT:"
 S X=$G(^MCAR(701,D0,10)) D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(54,Y)):DXS(54,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "KIDNEY PROBLEMS:"
 S X=$G(^MCAR(701,D0,1)) W ?0,$J($P(X,U,4),19)
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Females Only:"
 D N:$X>0 Q:'DN  W ?0 W "PREGNANT:"
 S X=$G(^MCAR(701,D0,0)) D N:$X>33 Q:'DN  W ?33 S Y=$P(X,U,34) W:Y]"" $S($D(DXS(55,Y)):DXS(55,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "Males Only:"
 D N:$X>39 Q:'DN  W ?39 W "DISCHARGE FROM PENIS:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,60) W:Y]"" $S($D(DXS(56,Y)):DXS(56,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "Other:"
 D N:$X>39 Q:'DN  W ?39 W "IMPOTENCE:"
 D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,61) W:Y]"" $S($D(DXS(57,Y)):DXS(57,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "OTHER:"
 S X=$G(^MCAR(701,D0,1)) W ?0,$J($P(X,U,10),30)
 D N:$X>39 Q:'DN  W ?39 W "RASH/ULCERS ON PENIS:"
 S X=$G(^MCAR(701,D0,0)) D N:$X>71 Q:'DN  W ?71 S Y=$P(X,U,62) W:Y]"" $S($D(DXS(58,Y)):DXS(58,Y),1:Y)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
