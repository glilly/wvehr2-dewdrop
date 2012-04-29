MCAROPG ; GENERATED FROM 'MCARPG' PRINT TEMPLATE (#988) ; 09/19/10 ; (FILE 698, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(988,"DXS")
 S I(0)="^MCAR(698,",J(0)=698
 D N:$X>32 Q:'DN  W ?32 X DXS(1,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 S DIP(1)=$S($D(^MCAR(698,D0,0)):^(0),1:"") S X="HOSPITAL WHERE IMPLANTED: "_$S('$D(^DIC(4,+$P(DIP(1),U,8),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "GENERATOR"
 D N:$X>5 Q:'DN  W ?5 S DIP(1)=$S($D(^MCAR(698,D0,0)):^(0),1:"") S X="MODEL: "_$S('$D(^MCAR(698.4,+$P(DIP(1),U,3),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 S DIP(1)=$S($D(^MCAR(698,D0,0)):^(0),1:"") S X="MANUFACTURER: "_$S('$D(^MCAR(698.6,+$P(DIP(1),U,4),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D N:$X>5 Q:'DN  W ?5 S DIP(1)=$S($D(^MCAR(698,D0,0)):^(0),1:"") S X="SERIAL NUMBER: "_$P(DIP(1),U,5) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 X DXS(2,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "TRANSMITTER"
 D N:$X>5 Q:'DN  W ?5 S DIP(1)=$S($D(^MCAR(698,D0,1)):^(1),1:"") S X="MODEL: "_$S('$D(^MCAR(698.4,+$P(DIP(1),U,3),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 S DIP(1)=$S($D(^MCAR(698,D0,1)):^(1),1:"") S X="MANUFACTURER: "_$S('$D(^MCAR(698.6,+$P(DIP(1),U,4),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 X DXS(3,9) K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "ATTENDING PHYSICIAN: "
 S X=$G(^MCAR(698,D0,3)) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>2 Q:'DN  W ?2 W "FELLOW-1st: "
 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>2 Q:'DN  W ?2 W "FELLOW-2nd: "
 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>2 Q:'DN  W ?2 X DXS(4,9) K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "FIRST SCHEDULED FOLLOW-UP: "
 S X=$G(^MCAR(698,D0,0)) S Y=$P(X,U,12) D DT
 D T Q:'DN  D N D N D N:$X>34 Q:'DN  W ?34 X DXS(5,9) K DIP K:DN Y W X
 D N:$X>54 Q:'DN  W ?54 X DXS(6,9) K DIP K:DN Y W X
 D N:$X>4 Q:'DN  W ?4 W "NON-MAG RATE"
 S X=$G(^MCAR(698,D0,4)) D N:$X>35 Q:'DN  W ?35 S Y=$P(X,U,1) W:Y]"" $J(Y,6,1)
 D N:$X>54 Q:'DN  W ?54 S Y=$P(X,U,5) W:Y]"" $J(Y,6,1)
 D N:$X>4 Q:'DN  W ?4 W "MAGNET RATE"
 D N:$X>35 Q:'DN  W ?35 S Y=$P(X,U,2) W:Y]"" $J(Y,6,1)
 D N:$X>54 Q:'DN  W ?54 S Y=$P(X,U,6) W:Y]"" $J(Y,6,1)
 D N:$X>4 Q:'DN  W ?4 W "NON-MAG PULSE WIDTH"
 D N:$X>37 Q:'DN  W ?37 S Y=$P(X,U,3) W:Y]"" $J(Y,5,2)
 D N:$X>56 Q:'DN  W ?56 S Y=$P(X,U,7) W:Y]"" $J(Y,5,2)
 D N:$X>4 Q:'DN  W ?4 W "MAGNET PULSE WIDTH"
 D N:$X>37 Q:'DN  W ?37 S Y=$P(X,U,4) W:Y]"" $J(Y,5,2)
 D N:$X>56 Q:'DN  W ?56 S Y=$P(X,U,8) W:Y]"" $J(Y,5,2)
 D N:$X>4 Q:'DN  W ?4 W "OTHER INDICATOR"
 D N:$X>36 Q:'DN  W ?36,$E($P(X,U,9),1,25)
 D N:$X>56 Q:'DN  S DIWL=57,DIWR=76 S Y=$P(X,U,10) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 S DIP(1)=$S($D(^MCAR(698,D0,0)):^(0),1:"") S X="NUMBER OF PULSE GENERATORS: "_$P(DIP(1),U,13) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "LAST PREVIOUS IMPLANT: "
 S X=$G(^MCAR(698,D0,0)) S Y=$P(X,U,14) D DT
 D N:$X>2 Q:'DN  W ?2 W "INCIPIENT MALFUNCTION: "
 S X=$G(^MCAR(698,D0,1)) S Y=$P(X,U,6) D DT
 D N:$X>2 Q:'DN  W ?2 W "PACING FAILURE: "
 S I(1)=2,J(1)=698.093 F D1=0:0 Q:$O(^MCAR(698,D0,2,D1))'>0  X:$D(DSC(698.093)) DSC(698.093) S D1=$O(^(D1)) Q:D1'>0  D:$X>20 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^MCAR(698,D0,2,D1,0)) W ?20 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(13,Y)):DXS(13,Y),1:Y)
 W ", "
 W ?37 S Y=$P(X,U,2) D DT
 Q
A1R ;
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "GENERATOR EXPLANT DATE: "
 S X=$G(^MCAR(698,D0,1)) S Y=$P(X,U,1) D DT
 D N:$X>2 Q:'DN  W ?2 S DIP(1)=$S($D(^MCAR(698,D0,1)):^(1),1:"") S X="REASON FOR CHANGE: "_$S('$D(^MCAR(695.8,+$P(DIP(1),U,2),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "COMMENTS: "
 S I(1)=10,J(1)=698.01 F D1=0:0 Q:$O(^MCAR(698,D0,10,D1))'>0  S D1=$O(^(D1)) D:$X>14 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^MCAR(698,D0,10,D1,0)) S DIWL=14,DIWR=78 D ^DIWP
 Q
B1R ;
 D 0^DIWW
 D ^DIWW
 S I(100)="^MCAR(690,",J(100)=690 S I(0,0)=D0 S DIP(1)=$S($D(^MCAR(698,D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X S D0=D(0) I D0>0 D C1
 G C1R
C1 ;
 D T Q:'DN  D N D N D N:$X>31 Q:'DN  W ?31 X DXS(7,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "PACING INDICATION:"
 S I(101)="""P""",J(101)=690.07 F D1=0:0 Q:$O(^MCAR(690,D0,"P",D1))'>0  X:$D(DSC(690.07)) DSC(690.07) S D1=$O(^(D1)) Q:D1'>0  D:$X>22 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^MCAR(690,D0,"P",D1,0)) D T Q:'DN  W ?0 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(694.1,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,100)
 Q
A2R ;
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "RISK FACTORS: "
 S I(101)="""P1""",J(101)=690.08 F D1=0:0 Q:$O(^MCAR(690,D0,"P1",D1))'>0  X:$D(DSC(690.08)) DSC(690.08) S D1=$O(^(D1)) Q:D1'>0  D:$X>18 T Q:'DN  D B2
 G B2R
B2 ;
 S X=$G(^MCAR(690,D0,"P1",D1,0)) D N:$X>17 Q:'DN  W ?17 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(695.4,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,40)
 W ", "
 S Y=$P(X,U,2) D DT
 Q
B2R ;
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "PSC STATUS: "
 S X=$G(^MCAR(690,D0,"P2")) W ?16 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(14,Y)):DXS(14,Y),1:Y)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 X DXS(8,9.3) S X=X_$P($P(DIP(106),$C(59)_$P(DIP(101),U,1)_":",2),$C(59),1),X=$S(DIP(103):DIP(104),DIP(105):X) K DIP K:DN Y W X
 D N:$X>5 Q:'DN  W ?5 X DXS(9,9.3) S X=$S(DIP(103):DIP(104),DIP(105):X) K DIP K:DN Y W X
 D N:$X>5 Q:'DN  W ?5 X DXS(10,9.2) S DIP(103)=X S X="",DIP(104)=X S X=1,DIP(105)=X S X="SUDDENESS: ",X=$S(DIP(103):DIP(104),DIP(105):X) K DIP K:DN Y W X
 S X=$G(^MCAR(690,D0,"P3")) S Y=$P(X,U,3) W:Y]"" $S($D(DXS(15,Y)):DXS(15,Y),1:Y)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 X DXS(11,9.2) S X=$S(DIP(102):DIP(103),DIP(104):X) K DIP K:DN Y W X
 S X=$G(^MCAR(690,D0,"P3")) S Y=$P(X,U,4) D DT
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 X DXS(12,9.2) S X=$S(DIP(102):DIP(103),DIP(104):X) K DIP K:DN Y W X
 S X=$G(^MCAR(690,D0,"P3")) W ?0,$E($P(X,U,5),1,25)
 Q
C1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
