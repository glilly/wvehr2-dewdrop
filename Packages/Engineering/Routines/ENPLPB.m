ENPLPB ; GENERATED FROM 'ENPLP006' PRINT TEMPLATE (#158) ; 09/19/10 ; (FILE 6925, MARGIN=132)
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
 I $D(DXS)<9 M DXS=^DIPT(158,"DXS")
 S I(0)="^ENG(""PROJ"",",J(0)=6925
 F Y=0:0 Q:$Y>-1  W !
 D N:$X>0 Q:'DN  W ?0 W "VHA"
 D N:$X>53 Q:'DN  W ?53 W "PROJECT APPLICATION"
 D N:$X>54 Q:'DN  W ?54 W "EXECUTIVE SUMMARY"
 D T Q:'DN  D N D N:$X>44 Q:'DN  W ?44 W "***********  GENERAL DATA  ***********"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "1. PROJECT PROGRAM: "
 S X=$G(^ENG("PROJ",D0,0)) S Y=$P(X,U,6) W:Y]"" $S($D(DXS(15,Y)):DXS(15,Y),1:Y)
 D N:$X>59 Q:'DN  W ?59 W "2. REGION: "
 X DXS(1,9.2) S X=$P(DIP(101),U,7) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>89 Q:'DN  W ?89 W "3. FACILITY PRIORITY: "
 S X=$G(^ENG("PROJ",D0,15)) S Y=$P(X,U,9) W:Y]"" $J(Y,3,0)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "4. FACILITY: "
 X DXS(2,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>79 Q:'DN  W ?79 W "DIVISION: "
 S X=$G(^ENG("PROJ",D0,15)) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ENG(6910.3,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,10)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "5. PROJECT TITLE: "
 S X=$G(^ENG("PROJ",D0,0)) W ?0,$E($P(X,U,3),1,50)
 D N:$X>89 Q:'DN  W ?89 W "6. PROJECT NUMBER: "
 W ?0,$E($P(X,U,1),1,11)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "7. EMERGENCY  : "
 X DXS(3,9.3) S X=$S(DIP(4):DIP(6),DIP(7):X) K DIP K:DN Y W X
 D N:$X>29 Q:'DN  W ?29 W "8. EQUIPMENT OVER   : "
 X DXS(4,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W X
 D N:$X>59 Q:'DN  W ?59 W "9. BUILDING : "
 X DXS(5,9) K DIP K:DN Y W $E(X,1,50)
 D N:$X>3 Q:'DN  W ?3 W "APPLICATION"
 D N:$X>32 Q:'DN  W ?32 W "$250K APPLICATION"
 D N:$X>62 Q:'DN  W ?62 W "NUMBER(S)"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "10. BUILDING OCCUPANCY: "
 S X=$G(^ENG("PROJ",D0,15)) S Y=$P(X,U,4) W:Y]"" $S($D(DXS(16,Y)):DXS(16,Y),1:Y)
 D N:$X>55 Q:'DN  W ?55 W "11a. PROJECT CATEGORY: "
 S X=$G(^ENG("PROJ",D0,52)) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^OFM(7336.8,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,40)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "11b. BONUS CATEGORY: "
 W ?23 X DXS(6,9.3) S DIP(6)=X S X="N/A",X=$S(DIP(3):DIP(5),DIP(6):X) K DIP K:DN Y W X
 D N:$X>55 Q:'DN  W ?55 W "11c. SIR RATING: "
 S X=$G(^ENG("PROJ",D0,15)) S Y=$P(X,U,11) W:Y]"" $J(Y,6,2)
 D N:$X>81 Q:'DN  W ?81 W "11d. % ENERGY TARGET ACHIEVED: (Region enters)"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "12a. BUDGET CATEGORY: "
 S X=$G(^ENG("PROJ",D0,52)) S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^OFM(7336.9,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,40)
 D N:$X>55 Q:'DN  W ?55 W "12b. EPA CATEGORY: "
 W ?76 X DXS(7,9.3) S DIP(6)=X S X="N/A",X=$S(DIP(3):DIP(5),DIP(6):X) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "13. NET BED CHANGE: "
 S X=$G(^ENG("PROJ",D0,15)) W ?0,$E($P(X,U,2),1,4)
 D N:$X>39 Q:'DN  W ?39 W "14. LISTED ON 5 YR FACILITY PLAN: "
 X DXS(8,9) K DIP K:DN Y W $E(X,1,4)
 D N:$X>89 Q:'DN  W ?89 W "15. 5-YR FACILITY PLAN FY: "
 S X=$G(^ENG("PROJ",D0,15)) W ?0,$E($P(X,U,6),1,4)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "16. NET PARKING CHANGE: "
 W ?0,$E($P(X,U,3),1,5)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "17. PROJECT DESCRIPTION:"
 S I(1)=17,J(1)=6925.0192 F D1=0:0 Q:$O(^ENG("PROJ",D0,17,D1))'>0  S D1=$O(^(D1)) D:$X>26 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ENG("PROJ",D0,17,D1,0)) S DIWL=27,DIWR=130 D ^DIWP
 Q
A1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "18. PROJECT JUSTIFICATION:"
 S I(1)=26,J(1)=6925.05 F D1=0:0 Q:$O(^ENG("PROJ",D0,26,D1))'>0  S D1=$O(^(D1)) D:$X>28 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^ENG("PROJ",D0,26,D1,0)) S DIWL=29,DIWR=130 D ^DIWP
 Q
B1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "19. WORKLOAD:"
 S I(1)=27,J(1)=6925.06 F D1=0:0 Q:$O(^ENG("PROJ",D0,27,D1))'>0  S D1=$O(^(D1)) D:$X>15 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^ENG("PROJ",D0,27,D1,0)) S DIWL=16,DIWR=130 D ^DIWP
 Q
C1R ;
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "20. FDP UPDATE COMPLETED: "
 W "* Reserved for Future Use *"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "21. DEPARTMENT/SERVICE OR TECHNICAL"
 D N:$X>74 Q:'DN  W ?74 W "22. FDP CRITICAL"
 D N:$X>99 Q:'DN  W ?99 W "23. FDP CORRECTIVE"
 D N:$X>4 Q:'DN  W ?4 W "DEFICIENCIES TO BE ADDRESSED"
 D N:$X>78 Q:'DN  W ?78 W "RATING"
 D N:$X>103 Q:'DN  W ?103 W "ACTION #"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W ""
 D N:$X>29 Q:'DN  W ?29 W "* Reserved for Future Use *"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "24. PROJECT SCOPE: "
 D N:$X>4 Q:'DN  W ?4 W "25. CODE"
 D N:$X>19 Q:'DN  W ?19 W "26. DEPARTMENT/SERVICE"
 D N:$X>69 Q:'DN  W ?69 W "27.       NEW"
 D N:$X>107 Q:'DN  W ?107 W "28. RENOVATED"
 D N:$X>72 Q:'DN  W ?72 W "NSF           GSF"
 D N:$X>105 Q:'DN  W ?105 W "NSF           GSF"
 S I(1)=22,J(1)=6925.03 F D1=0:0 Q:$O(^ENG("PROJ",D0,22,D1))'>0  X:$D(DSC(6925.03)) DSC(6925.03) S D1=$O(^(D1)) Q:D1'>0  D:$X>124 T Q:'DN  D D1
 G D1R
D1 ;
 D N:$X>8 Q:'DN  W ?8 X DXS(9,9.2) S DIP(101)=$S($D(^OFM(7336.6,D0,0)):^(0),1:"") S X=$P(DIP(101),U,2) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 D N:$X>23 Q:'DN  W ?23 X DXS(10,9.2) S DIP(101)=$S($D(^OFM(7336.6,D0,0)):^(0),1:"") S X=$P(DIP(101),U,1) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 S X=$G(^ENG("PROJ",D0,22,D1,0)) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,2) W:Y]"" $J(Y,9,0)
 D N:$X>83 Q:'DN  W ?83 S Y=$P(X,U,3) W:Y]"" $J(Y,9,0)
 D N:$X>102 Q:'DN  W ?102 S Y=$P(X,U,4) W:Y]"" $J(Y,9,0)
 D N:$X>116 Q:'DN  W ?116 S Y=$P(X,U,5) W:Y]"" $J(Y,9,0)
 Q
D1R ;
 D T Q:'DN  D N D N:$X>39 Q:'DN  W ?39 W "29.-30. NSF & GSF TOTALS: "
 D N:$X>69 Q:'DN  W ?69 X DXS(11,9) K DIP K:DN Y W $J(X,9)
 D N:$X>83 Q:'DN  W ?83 X DXS(12,9) K DIP K:DN Y W $J(X,9)
 D N:$X>102 Q:'DN  W ?102 X DXS(13,9) K DIP K:DN Y W $J(X,9)
 D N:$X>116 Q:'DN  W ?116 X DXS(14,9) K DIP K:DN Y W $J(X,9)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "31.-39. (ISSUES) SITE: "
 S X=$G(^ENG("PROJ",D0,29)) W ?0,$E($P(X,U,1),1,90)
 D N:$X>0 Q:'DN  W ?0 W ?11 W "HISTORICAL: "
 W ?0,$E($P(X,U,2),1,90)
 D N:$X>0 Q:'DN  W ?0 W ?8 W "ENVIRONMENTAL: "
 S X=$G(^ENG("PROJ",D0,32)) W ?0,$E($P(X,U,2),1,90)
 D N:$X>0 Q:'DN  W ?0 W ?14 W "SEISMIC: "
 S X=$G(^ENG("PROJ",D0,30)) W ?0,$E($P(X,U,1),1,90)
 D N:$X>0 Q:'DN  W ?0 W ?5 W "HAZARDOUS MAT'LS: "
 W ?0,$E($P(X,U,2),1,90)
 D N:$X>0 Q:'DN  W ?0 W ?12 W "TRANSPORT: "
 S X=$G(^ENG("PROJ",D0,31)) W ?0,$E($P(X,U,1),1,90)
 D N:$X>0 Q:'DN  W ?0 W ?14 W "PARKING: "
 W ?0,$E($P(X,U,2),1,90)
 D N:$X>0 Q:'DN  W ?0 W ?15 W "IMPACT: "
 W ?25 W "Information (if any) moved to Impact Justification on page 3."
 F Y=0:0 Q:$Y>(IOSL-6)  W !
 D N:$X>0 Q:'DN  W ?0 W "VAF 10-1193 REVISED 5/95 p.1"
 K Y K DIWF
 Q
HEAD ;
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!
