MCAROC2 ; GENERATED FROM 'MCARCATH2' PRINT TEMPLATE (#973) ; 09/19/10 ; (FILE 691.1, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(973,"DXS")
 S I(0)="^MCAR(691.1,",J(0)=691.1
 D T Q:'DN  D N D N:$X>34 Q:'DN  W ?34 X DXS(1,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "PREMEDICATIONS:"
 S I(1)=10,J(1)=691.2 F D1=0:0 Q:$O(^MCAR(691.1,D0,10,D1))'>0  X:$D(DSC(691.2)) DSC(691.2) S D1=$O(^(D1)) Q:D1'>0  D:$X>21 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^MCAR(691.1,D0,10,D1,0)) W ?21 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 Q
A1R ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "VASCULAR ACCESS:"
 S I(1)=11,J(1)=691.21 F D1=0:0 Q:$O(^MCAR(691.1,D0,11,D1))'>0  X:$D(DSC(691.21)) DSC(691.21) S D1=$O(^(D1)) Q:D1'>0  D:$X>22 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^MCAR(691.1,D0,11,D1,0)) W ?22 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 Q
B1R ;
 D N:$X>22 Q:'DN  W ?22 X DXS(2,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "CATHETERS:"
 D N:$X>29 Q:'DN  W ?29 W "TYPE AND SIZE"
 D N:$X>57 Q:'DN  W ?57 W "ENGAGEMENT"
 D N:$X>7 Q:'DN  W ?7 W "RIGHT HEART"
 S X=$G(^MCAR(691.1,D0,12)) D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>7 Q:'DN  W ?7 W "LEFT HEART"
 S I(1)=13,J(1)=691.22 F D1=0:0 Q:$O(^MCAR(691.1,D0,13,D1))'>0  X:$D(DSC(691.22)) DSC(691.22) S D1=$O(^(D1)) Q:D1'>0  D:$X>19 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^MCAR(691.1,D0,13,D1,0)) D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(695.6,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>58 Q:'DN  W ?58 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 Q
C1R ;
 D N:$X>7 Q:'DN  W ?7 W "RIGHT CORONARY"
 S I(1)=14,J(1)=691.23 F D1=0:0 Q:$O(^MCAR(691.1,D0,14,D1))'>0  X:$D(DSC(691.23)) DSC(691.23) S D1=$O(^(D1)) Q:D1'>0  D:$X>23 T Q:'DN  D D1
 G D1R
D1 ;
 S X=$G(^MCAR(691.1,D0,14,D1,0)) D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(695.6,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>58 Q:'DN  W ?58 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 Q
D1R ;
 D N:$X>7 Q:'DN  W ?7 W "LEFT CORONARY"
 S I(1)=15,J(1)=691.24 F D1=0:0 Q:$O(^MCAR(691.1,D0,15,D1))'>0  X:$D(DSC(691.24)) DSC(691.24) S D1=$O(^(D1)) Q:D1'>0  D:$X>22 T Q:'DN  D E1
 G E1R
E1 ;
 S X=$G(^MCAR(691.1,D0,15,D1,0)) D N:$X>27 Q:'DN  W ?27 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(695.6,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>58 Q:'DN  W ?58 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 Q
E1R ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "FLOURO TIME:"
 S X=$G(^MCAR(691.1,D0,12)) W ?18 S Y=$P(X,U,1) W:Y]"" $J(Y,3,0)
 W " MINUTES"
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "OTHER PROCEDURE AND COMMENT:"
 S I(1)=17,J(1)=691.25 F D1=0:0 Q:$O(^MCAR(691.1,D0,17,D1))'>0  S D1=$O(^(D1)) D:$X>34 T Q:'DN  D F1
 G F1R
F1 ;
 S X=$G(^MCAR(691.1,D0,17,D1,0)) S DIWL=27,DIWR=78 D ^DIWP
 Q
F1R ;
 D 0^DIWW
 D ^DIWW
 D N:$X>6 Q:'DN  W ?6 W "TECH COMMENTS:"
 S I(1)=2,J(1)=691.12 F D1=0:0 Q:$O(^MCAR(691.1,D0,2,D1))'>0  S D1=$O(^(D1)) D:$X>22 T Q:'DN  D G1
 G G1R
G1 ;
 S X=$G(^MCAR(691.1,D0,2,D1,0)) S DIWL=23,DIWR=77 D ^DIWP
 Q
G1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N:$X>29 Q:'DN  W ?29 X DXS(3,9) K DIP K:DN Y W X
 S I(1)=19,J(1)=691.26 F D1=0:0 Q:$O(^MCAR(691.1,D0,19,D1))'>0  X:$D(DSC(691.26)) DSC(691.26) S D1=$O(^(D1)) Q:D1'>0  D:$X>29 T Q:'DN  D H1
 G H1R
H1 ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "INTERVENTION:"
 S X=$G(^MCAR(691.1,D0,19,D1,0)) W ?19 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 D N:$X>6 Q:'DN  W ?6 W "PRESSURES:"
 D N:$X>7 Q:'DN  W ?7 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="RA A: "_$P(DIP(1),U,2) K DIP K:DN Y W X
 D N:$X>27 Q:'DN  W ?27 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="PCW A: "_$P(DIP(1),U,13) K DIP K:DN Y W X
 D N:$X>51 Q:'DN  W ?51 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X="AO S: "_$P(DIP(1),U,1) K DIP K:DN Y W X
 D N:$X>10 Q:'DN  W ?10 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="V: "_$P(DIP(1),U,3) K DIP K:DN Y W X
 D N:$X>31 Q:'DN  W ?31 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="V: "_$P(DIP(1),U,14) K DIP K:DN Y W X
 D N:$X>54 Q:'DN  W ?54 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X="D: "_$P(DIP(1),U,2) K DIP K:DN Y W X
 D N:$X>10 Q:'DN  W ?10 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="M: "_$P(DIP(1),U,4) K DIP K:DN Y W X
 D N:$X>31 Q:'DN  W ?31 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="M: "_$P(DIP(1),U,15) K DIP K:DN Y W X
 D N:$X>54 Q:'DN  W ?54 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X="M: "_$P(DIP(1),U,3) K DIP K:DN Y W X
 D N:$X>7 Q:'DN  W ?7 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="RV S: "_$P(DIP(1),U,6) K DIP K:DN Y W X
 D N:$X>28 Q:'DN  W ?28 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="LA A: "_$P(DIP(1),U,16) K DIP K:DN Y W X
 D N:$X>51 Q:'DN  W ?51 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="LV S: "_$P(DIP(1),U,22) K DIP K:DN Y W X
 D N:$X>10 Q:'DN  W ?10 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="D: "_$P(DIP(1),U,7) K DIP K:DN Y W X
 D N:$X>31 Q:'DN  W ?31 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="V: "_$P(DIP(1),U,17) K DIP K:DN Y W X
 D N:$X>50 Q:'DN  W ?50 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="PRE A: "_$P(DIP(1),U,20) K DIP K:DN Y W X
 D N:$X>31 Q:'DN  W ?31 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="M: "_$P(DIP(1),U,18) K DIP K:DN Y W X
 D N:$X>54 Q:'DN  W ?54 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="Z: "_$P(DIP(1),U,21) K DIP K:DN Y W X
 D N:$X>7 Q:'DN  W ?7 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="PA S: "_$P(DIP(1),U,9) K DIP K:DN Y W X
 D N:$X>51 Q:'DN  W ?51 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="LV S: "_$P(DIP(1),U,24) K DIP K:DN Y W X
 W ?62 W "(POST DYE)"
 D N:$X>10 Q:'DN  W ?10 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="D: "_$P(DIP(1),U,10) K DIP K:DN Y W X
 D N:$X>50 Q:'DN  W ?50 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="PRE A: "_$P(DIP(1),U,25) K DIP K:DN Y W X
 D N:$X>10 Q:'DN  W ?10 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="M: "_$P(DIP(1),U,11) K DIP K:DN Y W X
 D N:$X>54 Q:'DN  W ?54 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="Z: "_$P(DIP(1),U,26) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>6 Q:'DN  W ?6 W "SATURATIONS: "
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="RA: "_$P(DIP(1),U,5) K DIP K:DN Y W X
 D N:$X>30 Q:'DN  W ?30 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="PA: "_$P(DIP(1),U,12) K DIP K:DN Y W X
 D N:$X>46 Q:'DN  W ?46 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="LV: "_$P(DIP(1),U,23) K DIP K:DN Y W X
 D N:$X>63 Q:'DN  W ?63 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X="IVC: "_$P(DIP(1),U,8) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="RV: "_$P(DIP(1),U,8) K DIP K:DN Y W X
 D N:$X>30 Q:'DN  W ?30 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,0)):^(0),1:"") S X="LA: "_$P(DIP(1),U,19) K DIP K:DN Y W X
 D N:$X>46 Q:'DN  W ?46 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X="AO: "_$P(DIP(1),U,4) K DIP K:DN Y W X
 D N:$X>63 Q:'DN  W ?63 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X="SVC: "_$P(DIP(1),U,6) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>6 Q:'DN  W ?6 W "OUTPUT AND INDEX"
 D N:$X>29 Q:'DN  W ?29 W "(L/MIN)"
 D N:$X>54 Q:'DN  W ?54 W "(L/MIN/M2)"
 D N:$X>9 Q:'DN  W ?9 W "ASSUMED FICK"
 S X=$G(^MCAR(691.1,D0,19,D1,1)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,9) W:Y]"" $J(Y,6,2)
 D N:$X>55 Q:'DN  W ?55
 S Y(691.26,36,2)=$S($D(^MCAR(691.1,D0,0)):^(0),1:""),Y(691.26,36,1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X=$P(Y(691.26,36,1),U,9),X=$S($P(Y(691.26,36,2),U,9):X/$P(Y(691.26,36,2),U,9),1:"*******") S X=$J(X,0,2) W:X'?."*" $J(X,7,2)
 D N:$X>9 Q:'DN  W ?9 W "INDOGREEN"
 S X=$G(^MCAR(691.1,D0,19,D1,1)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,12) W:Y]"" $J(Y,6,2)
 D N:$X>55 Q:'DN  W ?55
 S Y(691.26,39,2)=$S($D(^MCAR(691.1,D0,0)):^(0),1:""),Y(691.26,39,1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X=$P(Y(691.26,39,1),U,12),X=$S($P(Y(691.26,39,2),U,9):X/$P(Y(691.26,39,2),U,9),1:"*******") S X=$J(X,0,2) W:X'?."*" $J(X,7,2)
 D N:$X>9 Q:'DN  W ?9 W "THERMODILUTION"
 S X=$G(^MCAR(691.1,D0,19,D1,1)) D N:$X>29 Q:'DN  W ?29 S Y=$P(X,U,14) W:Y]"" $J(Y,6,2)
 D N:$X>55 Q:'DN  W ?55
 S Y(691.26,41,2)=$S($D(^MCAR(691.1,D0,0)):^(0),1:""),Y(691.26,41,1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X=$P(Y(691.26,41,1),U,14),X=$S($P(Y(691.26,41,2),U,9):X/$P(Y(691.26,41,2),U,9),1:"*******") S X=$J(X,0,2) W:X'?."*" $J(X,7,2)
 D T Q:'DN  D N D N:$X>6 Q:'DN  W ?6 S DIP(1)=$S($D(^MCAR(691.1,D0,19,D1,1)):^(1),1:"") S X="A V AREA (CM SQ): "_$P(DIP(1),U,19) K DIP K:DN Y W X
 Q
H1R ;
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
