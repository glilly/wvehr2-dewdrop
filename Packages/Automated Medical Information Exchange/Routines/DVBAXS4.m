DVBAXS4 ; ;08/19/96
 D DE G BEGIN
DE S DIE="^DVB(396,",DIC=DIE,DP=396,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DVB(396,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,23) S:%]"" DE(5)=%
 I $D(^(1)) S %Z=^(1) S %=$P(%Z,U,5) S:%]"" DE(1)=% S %=$P(%Z,U,6) S:%]"" DE(8)=%,DE(12)=% S %=$P(%Z,U,7) S:%]"" DE(16)=%
 I $D(^(2)) S %Z=^(2) S %=$P(%Z,U,2) S:%]"" DE(11)=%
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
N I X="" G A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) I DV'["*" D ^DIC S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
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
SET I X'?.ANP S DDER=1 Q 
 N DIR S DIR(0)="SMV^"_DU,DIR("V")=1
 I $D(DB(DQ)),'$D(DIQUIET) N DIQUIET S DIQUIET=1
 D ^DIR I 'DDER S %=Y(0),X=Y
 Q
BEGIN S DNM="DVBAXS4",DQ=1
1 S DW="1;5",DV="D",DU="",DLB="FORM 21-2680 COMPLETION DATE",DIFLD=14.5
 G RE
X1 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 I X=""&(DVBASTAT="C") W *7,!!,"Completed status must have date.",!! S Y="@13"
 Q
3 S DQ=4 ;@14
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 S CODE=$P(^DVB(396,D0,0),U,23) S:CODE="" Y="@16" S:DVBACORR="N"&(CODE'="P") Y="@16"
 Q
5 S DW="0;23",DV="S",DU="",DLB="STATUS OF ASSET INFORMATION",DIFLD=16
 S DU="P:PENDING;C:COMPLETED;"
 G RE
X5 Q
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S DVBASTAT=X S:X="C" Y="@15"
 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 S DVBADT=$S($D(^DVB(396,D0,1)):$P(^(1),U,6),1:"") S:X="P"&(DVBADT="") Y="@16"
 Q
8 S DW="1;6",DV="D",DU="",DLB="ASSET INFO COMPLETION DATE",DIFLD=16.5
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X8 S %DT="X" D ^%DT S X=Y K:Y<1 X
 Q
 ;
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 S Y="@16"
 Q
10 S DQ=11 ;@15
11 S DW="2;2",DV="F",DU="",DLB="EDIT16",DIFLD=16.7
 S X=OPER
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G Z
X11 Q
12 S DW="1;6",DV="D",DU="",DLB="ASSET INFO COMPLETION DATE",DIFLD=16.5
 G RE
X12 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 I X=""&(DVBASTAT="C") W *7,!!,"Completed status must have date.",!! S Y="@15"
 Q
14 S DQ=15 ;@16
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 S CODE=$S($D(^DVB(396,D0,1)):$P(^(1),U,7),1:"") S:CODE="" Y="@18" S:DVBACORR="N"&(CODE'="P") Y="@18"
 Q
16 S DW="1;7",DV="S",DU="",DLB="ADMISSION REPORT STATUS",DIFLD=17.4
 S DU="P:PENDING;C:COMPLETED;"
 G RE
X16 Q
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 S DVBASTAT=X S:X="C" Y="@17"
 Q
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 S DVBADT=$S($D(^DVB(396,D0,1)):$P(^(1),U,8),1:"") S:X="P"&(DVBADT="") Y="@18"
 Q
19 D:$D(DG)>9 F^DIE17 G ^DVBAXS5
