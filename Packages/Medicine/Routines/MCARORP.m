MCARORP ; GENERATED FROM 'MCRHPHYS1' PRINT TEMPLATE (#1008) ; 09/19/10 ; (FILE 701, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1008,"DXS")
 S I(0)="^MCAR(701,",J(0)=701
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Physical Examination"
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "General:"
 D N:$X>39 Q:'DN  W ?39 W "LYMPH NODE ENLARGEMENT:"
 S X=$G(^MCAR(701,D0,2)) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,16) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "UVEITIS/IRITIS:"
 S X=$G(^MCAR(701,D0,1)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "MUSCLE TENDERNESS:"
 S X=$G(^MCAR(701,D0,2)) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,17) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CONJUNCTIVITIS/EPISCLERITIS:"
 S X=$G(^MCAR(701,D0,1)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "MUSCLE WEAKNESS-DISTAL:"
 S X=$G(^MCAR(701,D0,2)) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,18) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "CATARACT:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "MUSCLE WEAKNESS-PROXIMAL:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,21) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "ORAL ULCERS:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "MUSCLE ATROPHY"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "RALES:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "PSYCHOSIS:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,23) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "PLEURAL RUB/"
 D N:$X>0 Q:'DN  W ?0 W "CLINICAL PLEURISY:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,11) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "ORGANIC BRAIN SYNDROME:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,24) W:Y]"" $S($D(DXS(13,Y)):DXS(13,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "PLEURAL EFFUSION:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,12) W:Y]"" $S($D(DXS(14,Y)):DXS(14,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "MOTOR NEUROPATHY:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,25) W:Y]"" $S($D(DXS(15,Y)):DXS(15,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "PERICARDIAL RUB/PERICARDITIS:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,13) W:Y]"" $S($D(DXS(16,Y)):DXS(16,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "SENSORY NEUROPATHY:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,26) W:Y]"" $S($D(DXS(17,Y)):DXS(17,Y),1:Y)
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "Skin:"
 D N:$X>39 Q:'DN  W ?39 W "CUTANEOUS VASCULTITIS:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,38) W:Y]"" $S($D(DXS(18,Y)):DXS(18,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "RASH-MALAR:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,28) W:Y]"" $S($D(DXS(19,Y)):DXS(19,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "PALPABLE PUPURA:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,32) W:Y]"" $S($D(DXS(20,Y)):DXS(20,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "RASH-DISCOID:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,30) W:Y]"" $S($D(DXS(21,Y)):DXS(21,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "SKIN ULCERS:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,44) W:Y]"" $S($D(DXS(22,Y)):DXS(22,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "RASH-JRA:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,31) W:Y]"" $S($D(DXS(23,Y)):DXS(23,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "ERYTHEMA NODOSUM:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,45) W:Y]"" $S($D(DXS(24,Y)):DXS(24,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "RASH-SLE,NON-MALAR:"
 S X=$G(^MCAR(701,D0,1)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(25,Y)):DXS(25,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "PERIUNGAL ERYTHEMA:"
 S X=$G(^MCAR(701,D0,2)) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,39) W:Y]"" $S($D(DXS(26,Y)):DXS(26,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "RASH-OTHER:"
 S X=$G(^MCAR(701,D0,1)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(27,Y)):DXS(27,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "HELIOTROPE EYELIDS:"
 S X=$G(^MCAR(701,D0,2)) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,27) W:Y]"" $S($D(DXS(28,Y)):DXS(28,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "KNUCKLE ERYTHEMA:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,41) W:Y]"" $S($D(DXS(29,Y)):DXS(29,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "TELANGIECTASIS:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,37) W:Y]"" $S($D(DXS(30,Y)):DXS(30,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "SUBCUTANEOUS CALCIFICATIONS:"
 S X=$G(^MCAR(701,D0,1)) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(31,Y)):DXS(31,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "SCLERODACTYLY:"
 S X=$G(^MCAR(701,D0,2)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,33) W:Y]"" $S($D(DXS(32,Y)):DXS(32,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "KERATODERMIA BLENNORRHAGICA:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,40) W:Y]"" $S($D(DXS(33,Y)):DXS(33,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "SCLERODERMA-EXTREMITY:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,34) W:Y]"" $S($D(DXS(34,Y)):DXS(34,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "DACTYLITIS:"
 S X=$G(^MCAR(701,D0,5)) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(35,Y)):DXS(35,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "SCLERODERMA-GENERALIZED:"
 S X=$G(^MCAR(701,D0,2)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,35) W:Y]"" $S($D(DXS(36,Y)):DXS(36,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "NAIL PITTING:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,43) W:Y]"" $S($D(DXS(37,Y)):DXS(37,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "MORPHEA:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,36) W:Y]"" $S($D(DXS(38,Y)):DXS(38,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "PSORIASIS:"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,29) W:Y]"" $S($D(DXS(39,Y)):DXS(39,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "DIGITAL ULCERS:"
 D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,42) W:Y]"" $S($D(DXS(40,Y)):DXS(40,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "HEEL PAIN:"
 S X=$G(^MCAR(701,D0,5)) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(41,Y)):DXS(41,Y),1:Y)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
