SDXACSE1 ; ;09/19/10
 D DE G BEGIN
DE S DIE="^SDV(D0,""CS"",",DIC=DIE,DP=409.51,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^SDV(D0,"CS",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(1)=% S %=$P(%Z,U,3) S:%]"" DE(2)=% S %=$P(%Z,U,4) S:%]"" DE(3)=% S %=$P(%Z,U,5) S:%]"" DE(4)=% S %=$P(%Z,U,6) S:%]"" DE(8)=%
 I $D(^(1)) S %Z=^(1) S %=$P(%Z,U,1) S:%]"" DE(6)=%
 I $D(^("PR")) S %Z=^("PR") S %=$P(%Z,U,1) S:%]"" DE(10)=% S %=$P(%Z,U,2) S:%]"" DE(12)=% S %=$P(%Z,U,3) S:%]"" DE(14)=% S %=$P(%Z,U,4) S:%]"" DE(16)=% S %=$P(%Z,U,5) S:%]"" DE(18)=%
 K %Z Q
 ;
W W !?DL+DL-2,DLB_": "
 Q
O D W W Y W:$X>45 !?9
 I $L(Y)>19,'DV,DV'["I",(DV["F"!(DV["K")) G RW^DIR2
 W:Y]"" "// " I 'DV,DV["I",$D(DE(DQ))#2 S X="" W "  (No Editing)" Q
TR R X:DTIME E  S (DTOUT,X)=U W $C(7)
 Q
A K DQ(DQ) S DQ=DQ+1
B G @DQ
RE G PR:$D(DE(DQ)) D W,TR
N I X="" G NKEY:$D(^DD("KEY","F",DP,DIFLD)),A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) I X?.ANP D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) G:DV["*" AST^DIED D NOSCR^DIED S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U D:$G(DE(DW,"INDEX")) SAVEVALS G:'$$KEYCHK UNIQFERR^DIE17 S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
X W:'$D(ZTQUEUED) $C(7),"??" I $D(DB(DQ)) G Z^DIE17
 S X="?BAD"
QS S DZ=X D D,QQ^DIEQ G B
D S D=DIFLD,DQ(DQ)=DLB_U_DV_U_DU_U_DW_U_$P($T(@("X"_DQ))," ",2,99) Q
Y I '$D(DE(DQ)) D O G RD:"@"'[X,A:DV'["R"&(X="@"),X:X="@" S X=Y G N
PR S DG=DV,Y=DE(DQ),X=DU I $D(DQ(DQ,2)) X DQ(DQ,2) G RP
R I DG["P",@("$D(^"_X_"0))") S X=+$P(^(0),U,2) G RP:'$D(^(Y,0)) S Y=$P(^(0),U),X=$P(^DD(X,.01,0),U,3),DG=$P(^(0),U,2) G R
 I DG["V",+Y,$P(Y,";",2)["(",$D(@(U_$P(Y,";",2)_"0)")) S X=+$P(^(0),U,2) G RP:'$D(^(+Y,0)) S Y=$P(^(0),U) I $D(^DD(+X,.01,0)) S DG=$P(^(0),U,2),X=$P(^(0),U,3) G R
 X:DG["D" ^DD("DD") I DG["S" S %=$P($P(";"_X,";"_Y_":",2),";") S:%]"" Y=%
RP D O I X="" S X=DE(DQ) G A:'DV,A:DC<2,N^DIE17
I I DV'["I",DV'["#" G RD
 D E^DIE0 G RD:$D(X),PR
 Q
SET N DIR S DIR(0)="SV"_$E("o",$D(DB(DQ)))_U_DU,DIR("V")=1
 I $D(DB(DQ)),'$D(DIQUIET) N DIQUIET S DIQUIET=1
 D ^DIR I 'DDER S %=Y(0),X=Y
 Q
SAVEVALS S @DIEZTMP@("V",DP,DIIENS,DIFLD,"O")=$G(DE(DQ)) S:$D(^("F"))[0 ^("F")=$G(DE(DQ))
 I $D(DE(DW,"4/")) S @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")=""
 E  K @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")
 Q
NKEY W:'$D(ZTQUEUED) "??  Required key field" S X="?BAD" G QS
KEYCHK() Q:$G(DE(DW,"KEY"))="" 1 Q @DE(DW,"KEY")
BEGIN S DNM="SDXACSE1",DQ=1
1 S DW="0;2",DV="P200'",DU="",DLB="EDITED LAST BY",DIFLD=2
 S DU="VA(200,"
 S X=$S($D(SDUZ):SDUZ,1:DUZ)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X1 Q
2 S DW="0;3",DV="*P44'",DU="",DLB="ASSOCIATED CLINIC",DIFLD=3
 S DU="SC("
 S X=$P(SDCPT(SDJ),U,2)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X2 Q
3 S DW="0;4",DV="*P8'",DU="",DLB="ELIGIBILITY FOR VISIT",DIFLD=4
 S DE(DW)="C3^SDXACSE1"
 S DU="DIC(8,"
 S X=$S($G(SDOEP):$P($G(^SCE(SDOEP,0)),U,13),1:"")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 ;
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA X ^DD(409.51,4,1,1,89.2) S Y(101)=$S($D(^SCE(D0,0)):^(0),1:"") S X=$S('$D(^DIC(8,+$P(Y(101),U,13),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) S D1=I(1,0) S DIU=X K Y S X=DIV S X=X X ^DD(409.51,4,1,1,1.4)
C3F1 Q
X3 Q
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW="0;5",DV="R*P409.1'",DU="",DLB="APPOINTMENT TYPE",DIFLD=5
 S DE(DW)="C4^SDXACSE1"
 S DU="SD(409.1,"
 S X=SDAPTYP
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C4 G C4S:$D(DE(4))[0 K DB
 S X=DE(4),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(0)=X S X="369"'[X I X S X=DIV S Y(1)=$S($D(^SDV(D0,"CS",D1,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(409.51,5,1,1,2.4)
 S X=DE(4),DIC=DIE
 X ^DD(409.51,5,1,2,2.3) I X S X=DIV S Y(1)=$S($D(^SDV(D0,"CS",D1,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(409.51,5,1,2,2.4)
 S X=DE(4),DIC=DIE
 K:X=10 ^SDV("ACG",DA(1),DA)
 S X=DE(4),DIC=DIE
 ;
C4S S X="" G:DG(DQ)=X C4F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(0)=X S X="369"'[X I X S X=DIV S Y(1)=$S($D(^SDV(D0,"CS",D1,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y X ^DD(409.51,5,1,1,1.1) X ^DD(409.51,5,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 X ^DD(409.51,5,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^SDV(D0,"CS",D1,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y X ^DD(409.51,5,1,2,1.1) X ^DD(409.51,5,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 S:X=10 ^SDV("ACG",DA(1),DA)=""
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA X ^DD(409.51,5,1,4,89.2) S Y(101)=$S($D(^SCE(D0,0)):^(0),1:"") S X=$S('$D(^SD(409.1,+$P(Y(101),U,10),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) S D1=I(1,0) S DIU=X K Y S X=DIV S X=X X ^DD(409.51,5,1,4,1.4)
C4F1 Q
X4 Q
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 I $D(SDNOTCG) S Y="@1"
 Q
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="1;1",DV="SI",DU="",DLB="COMPUTER GENERATED?",DIFLD=11
 S DE(DW)="C6^SDXACSE1"
 S DU="1:YES;"
 S X=1
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C6 G C6S:$D(DE(6))[0 K DB
 S X=DE(6),DIC=DIE
 K:X ^SDV("AG",DA(1),DA)
C6S S X="" G:DG(DQ)=X C6F1 K DB
 S X=DG(DQ),DIC=DIE
 S:X ^SDV("AG",DA(1),DA)=""
C6F1 Q
X6 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 I 'SDAPTYPR S Y="@1"
 Q
8 D:$D(DG)>9 F^DIE17,DE S DQ=8,DW="0;6",DV="S",DU="",DLB="UNRESOLVED APPT TYPE REASON",DIFLD=6
 S DU="1:DUAL ELIGIBILITY;2:POSSIBLE COMP & PEN;"
 S X=SDAPTYPR
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X8 Q
9 S DQ=10 ;@1
10 S DW="PR;1",DV="*P81'X",DU="",DLB="PROCEDURE 1",DIFLD=21
 S DU="ICPT("
 S X=$P(SDCPT(SDJ),U,3)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X10 Q
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 I $P(SDCPT(SDJ),U,4)']"" S Y="@99"
 Q
12 S DW="PR;2",DV="*P81'X",DU="",DLB="PROCEDURE 2",DIFLD=22
 S DU="ICPT("
 S X=$P(SDCPT(SDJ),U,4)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X12 Q
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 I $P(SDCPT(SDJ),U,5)']"" S Y="@99"
 Q
14 S DW="PR;3",DV="*P81'X",DU="",DLB="PROCEDURE 3",DIFLD=23
 S DU="ICPT("
 S X=$P(SDCPT(SDJ),U,5)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X14 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 I $P(SDCPT(SDJ),U,6)']"" S Y="@99"
 Q
16 S DW="PR;4",DV="*P81'X",DU="",DLB="PROCEDURE 4",DIFLD=24
 S DU="ICPT("
 S X=$P(SDCPT(SDJ),U,6)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X16 Q
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 I $P(SDCPT(SDJ),U,7)']"" S Y="@99"
 Q
18 S DW="PR;5",DV="*P81'X",DU="",DLB="PROCEDURE 5",DIFLD=25
 S DU="ICPT("
 S X=$P(SDCPT(SDJ),U,7)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X18 Q
19 S DQ=20 ;@99
20 G 1^DIE17
