MCARORF ; GENERATED FROM 'MCRHPHYS' PRINT TEMPLATE (#1015) ; 09/19/10 ; (FILE 701, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1015,"DXS")
 S I(0)="^MCAR(701,",J(0)=701
 F Y=0:0 Q:$Y>-1  W !
 D N:$X>0 Q:'DN  W ?0 W "PATIENT PHYSICAL EXAMINATION"
 S I(100)="^MCAR(690,",J(100)=690 S I(0,0)=D0 S DIP(1)=$S($D(^MCAR(701,D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Height"
 S X=$G(^MCAR(701,D0,2)) D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,1) W:Y]"" $J(Y,8,0)
 D N:$X>36 Q:'DN  W ?36 W " cm"
 D N:$X>0 Q:'DN  W ?0 W "Weight"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,2) W:Y]"" $J(Y,8,1)
 D N:$X>36 Q:'DN  W ?36 W " kg"
 D N:$X>0 Q:'DN  W ?0 W "Systolic pressure"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,3) W:Y]"" $J(Y,8,0)
 D N:$X>36 Q:'DN  W ?36 W " mmhg"
 D N:$X>0 Q:'DN  W ?0 W "Diastolic pressure"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,4) W:Y]"" $J(Y,8,0)
 D N:$X>36 Q:'DN  W ?36 W " mmhg"
 D N:$X>0 Q:'DN  W ?0 W "Pulse"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,5) W:Y]"" $J(Y,8,0)
 D N:$X>36 Q:'DN  W ?36 W " /min"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "G E N E R A L :"
 D N:$X>0 Q:'DN  W ?0 W "Uveitis"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,6) W:Y]"" $J($S($D(DXS(1,Y)):DXS(1,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Lymph Node Enlargement"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,16) W:Y]"" $J($S($D(DXS(2,Y)):DXS(2,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Cataract"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,7) W:Y]"" $J($S($D(DXS(3,Y)):DXS(3,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Muscle Tenderness"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,17) W:Y]"" $J($S($D(DXS(4,Y)):DXS(4,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Iritis"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,8) W:Y]"" $J($S($D(DXS(5,Y)):DXS(5,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Muscle Weakness - Dital"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,18) W:Y]"" $J($S($D(DXS(6,Y)):DXS(6,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Oral Ulcers"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,9) W:Y]"" $J($S($D(DXS(7,Y)):DXS(7,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Hepatomegaly"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,19) W:Y]"" $J($S($D(DXS(8,Y)):DXS(8,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Rales"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,10) W:Y]"" $J($S($D(DXS(9,Y)):DXS(9,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Splenomegoly"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,20) W:Y]"" $J($S($D(DXS(10,Y)):DXS(10,Y),1:Y),8)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Pleural Rub"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,11) W:Y]"" $J($S($D(DXS(11,Y)):DXS(11,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Muscle Weakness - Proximal"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,21) W:Y]"" $S($D(DXS(12,Y)):DXS(12,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "Pleural Effusion"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,12) W:Y]"" $J($S($D(DXS(13,Y)):DXS(13,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Muscle Atrophy"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,22) W:Y]"" $J($S($D(DXS(14,Y)):DXS(14,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Pericardial Rub"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,13) W:Y]"" $J($S($D(DXS(15,Y)):DXS(15,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Psychosis"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,23) W:Y]"" $J($S($D(DXS(16,Y)):DXS(16,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Systolic Murmur"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,14) W:Y]"" $J($S($D(DXS(17,Y)):DXS(17,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Organic Brain Syndrome"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,24) W:Y]"" $J($S($D(DXS(18,Y)):DXS(18,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Diastolic Murmur"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,15) W:Y]"" $J($S($D(DXS(19,Y)):DXS(19,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Motor Neurophathy"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,25) W:Y]"" $J($S($D(DXS(20,Y)):DXS(20,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Sensory Neurophathy"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,26) W:Y]"" $J($S($D(DXS(21,Y)):DXS(21,Y),1:Y),8)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "S K I N"
 D N:$X>0 Q:'DN  W ?0 W "Heliotrope Eyelids"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,27) W:Y]"" $J($S($D(DXS(22,Y)):DXS(22,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Telangiectasis"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,37) W:Y]"" $J($S($D(DXS(23,Y)):DXS(23,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Rash - Malar"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,28) W:Y]"" $J($S($D(DXS(24,Y)):DXS(24,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Cutaneous Vasculitis"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,38) W:Y]"" $J($S($D(DXS(25,Y)):DXS(25,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Psoriasis"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,29) W:Y]"" $J($S($D(DXS(26,Y)):DXS(26,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Periungal Erythema"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,39) W:Y]"" $J($S($D(DXS(27,Y)):DXS(27,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Rash - Discoid"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,30) W:Y]"" $J($S($D(DXS(28,Y)):DXS(28,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Keratodermia Blennorrhagica"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,40) W:Y]"" $J($S($D(DXS(29,Y)):DXS(29,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Rash - JRA"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,31) W:Y]"" $J($S($D(DXS(30,Y)):DXS(30,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Knuckle Erythema"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,41) W:Y]"" $J($S($D(DXS(31,Y)):DXS(31,Y),1:Y),8)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Palpable Purpura"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,32) W:Y]"" $J($S($D(DXS(32,Y)):DXS(32,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Digital Ulcers"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,42) W:Y]"" $J($S($D(DXS(33,Y)):DXS(33,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Sclerodactyly"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,33) W:Y]"" $J($S($D(DXS(34,Y)):DXS(34,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Nail Pitting"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,43) W:Y]"" $J($S($D(DXS(35,Y)):DXS(35,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Scleroderma - Extremity"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,34) W:Y]"" $J($S($D(DXS(36,Y)):DXS(36,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Skin Ulcers"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,44) W:Y]"" $J($S($D(DXS(37,Y)):DXS(37,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Scleroderma - Generalized"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,35) W:Y]"" $J($S($D(DXS(38,Y)):DXS(38,Y),1:Y),8)
 D N:$X>39 Q:'DN  W ?39 W "Erythema Nodosum"
 D N:$X>70 Q:'DN  W ?70 S Y=$P(X,U,45) W:Y]"" $J($S($D(DXS(39,Y)):DXS(39,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Morphea"
 D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,36) W:Y]"" $J($S($D(DXS(40,Y)):DXS(40,Y),1:Y),8)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "C U R R E N T   M E D I C A T I O N :"
 S X=$G(^MCAR(701,D0,3)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,1),1,200)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "P R E S R I B E D   M E D I C A T I O N S :"
 S I(1)=4,J(1)=701.0108 F D1=0:0 Q:$O(^MCAR(701,D0,4,D1))'>0  S D1=$O(^(D1)) D:$X>45 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^MCAR(701,D0,4,D1,0)) S DIWL=1,DIWR=78 D ^DIWP
 Q
B1R ;
 D 0^DIWW
 D ^DIWW
 F Y=0:0 Q:$Y>(IOSL-3)  W !
 W ?0 W " "
 F Y=0:0 Q:$Y>-1  W !
 D N:$X>0 Q:'DN  W ?0 W "PATIENT PHYSICAL EXAMINATION"
 S I(100)="^MCAR(690,",J(100)=690 S I(0,0)=D0 S DIP(1)=$S($D(^MCAR(701,D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X S D0=D(0) I D0>0 D C1
 G C1R
C1 ;
 Q
C1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "R H E U M A T I C :"
 D N:$X>0 Q:'DN  W ?0 W "Sysmmetrical Arthritis"
 S X=$G(^MCAR(701,D0,5)) D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,1) W:Y]"" $J($S($D(DXS(41,Y)):DXS(41,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Dactylitis"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,2) W:Y]"" $J($S($D(DXS(42,Y)):DXS(42,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Tophi"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,3) W:Y]"" $J($S($D(DXS(43,Y)):DXS(43,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Sub-Cutaneous Nodules"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,4) W:Y]"" $J($S($D(DXS(44,Y)):DXS(44,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Synovial (Baker's) Cyst"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,5) W:Y]"" $J($S($D(DXS(45,Y)):DXS(45,Y),1:Y),8)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Heel Pain"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,6) W:Y]"" $J($S($D(DXS(46,Y)):DXS(46,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Tenosynovitis (Tendon Rubs)"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,7) W:Y]"" $J($S($D(DXS(47,Y)):DXS(47,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Temporal Artery Tenderness"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,8) W:Y]"" $J($S($D(DXS(48,Y)):DXS(48,Y),1:Y),8)
 D N:$X>0 Q:'DN  W ?0 W "Costochondritis"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,9) W:Y]"" $J($S($D(DXS(49,Y)):DXS(49,Y),1:Y),8)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "F U N C T I O N A L   A S S E S S M E N T :"
 D N:$X>0 Q:'DN  W ?0 W "Grip Strength - left"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,10) W:Y]"" $J(Y,8,0)
 D N:$X>40 Q:'DN  W ?40 W " mmHg"
 D N:$X>0 Q:'DN  W ?0 W "Grip Strength - Right"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,11) W:Y]"" $J(Y,8,0)
 D N:$X>40 Q:'DN  W ?40 W " mmHg"
 D N:$X>0 Q:'DN  W ?0 W "Schober Test (10 cm Base)"
 D N:$X>32 Q:'DN  W ?32 S Y=$P(X,U,12) W:Y]"" $J(Y,8,0)
 D N:$X>40 Q:'DN  W ?40 W " cm"
 G ^MCARORF1
