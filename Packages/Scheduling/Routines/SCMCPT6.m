SCMCPT6 ; GENERATED FROM 'SCMC DIRECT PC FTEE 1 CLN' PRINT TEMPLATE (#1471) ; 09/19/10 ; (FILE 404.52, MARGIN=132)
 G BEGIN
CP G CP^DIO2
C S DQ(C)=Y
S S Q(C)=Y*Y+Q(C) S:L(C)>Y L(C)=Y S:H(C)<Y H(C)=Y
P S N(C)=N(C)+1
A S S(C)=S(C)+Y
 Q
D I Y=DITTO(C) S Y="" Q
 S DITTO(C)=Y
 Q
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
 I $D(DXS)<9 M DXS=^DIPT(1471,"DXS")
 S I(0)="^SCTM(404.52,",J(0)=404.52
 S X=$G(^SCTM(404.52,D0,0)) W ?0 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,15)
 S I(100)="^SCTM(404.57,",J(100)=404.57 S I(0,0)=D0 S DIP(1)=$S($D(^SCTM(404.52,D0,0)):^(0),1:"") S X=$P(DIP(1),U,1),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 S X=$G(^SCTM(404.57,D0,0)) W ?17 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^SCTM(404.51,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 W ?36,$E($P(X,U,1),1,17)
 W ?55 W $$PCP^SCMCTSK6(D0) K DIP K:DN Y
 D CLN^SCMCTSK6(D0) K DIP K:DN Y
 W ?60 X DXS(1,9.3) S X=$P($G(^SC(+$P(DIP(202),U,1),0)),U) S D0=I(100,0) S D1=I(101,0) K DIP K:DN Y W $E(X,1,15)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 S X=$G(^SCTM(404.52,D0,0)) W ?77 S Y=$P(X,U,9),C=1 D A:Y]"" W:Y]"" $J(Y,4,2)
 W ?85 X "N I,Y "_$P(^DD(404.52,.098,0),U,5,99) S DIP(1)=X S X=DIP(1) K DIP K:DN Y W $E(X,1,4) K Y(404.52,-1) S Y=X,C=2 D A:Y'?."*"
 W ?95 X ^DD(404.52,.097,9.2) S Y(404.52,.097,101)=$S($D(^SCTM(404.57,D0,0)):^(0),1:"") S X=$P(Y(404.52,.097,101),U,8) S D0=Y(404.52,.097,80) S X=$J(X,0,0) W $E(X,1,4) K Y(404.52,.097) S Y=X,C=3 D A:Y'?."*"
 W ?105 X DXS(2,9) K DIP K:DN Y W $E(X,1,5) K Y(404.52,-1) S Y=X,C=4 D A:Y'?."*"
 W ?116 X ^DD(404.52,.099,9.3) S Y(404.52,.099,5)=$G(X) S X=0,X=$J(Y(404.52,.099,4),Y(404.52,.099,5),X) S X=$J(X,0,0) W:X'?."*" $J(X,6,0) K Y(404.52,.099) S Y=X,C=5 D A:Y'?."*"
 S C=6 S X=$$PCPOSCNT^SCAPMCU1(+$G(^SCTM(404.52,D0,0)),DT,0) S Y=X D A
 K Y
 Q
HEAD ;
 W !,?85,"Patients",?95,"Patients"
 W !,?85,"for",?95,"for"
 W !,?55,"AP",?77,"Direct",?85,"Position",?95,"Position",?105,"Available",?116,"ADJUSTED"
 W !,?36,"Provider's Team",?55,"or",?60,"Associated",?81,"PC",?85,"Actual/",?95,"Allowed/",?105,"Patient",?119,"PANEL"
 W !,?0,"Provider's Name",?17,"PC Team",?36,"Position",?55,"PCP",?60,"Clinic",?79,"FTEE",?85,"Active",?95,"Maximum",?105,"Openings",?120,"SIZE"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!
