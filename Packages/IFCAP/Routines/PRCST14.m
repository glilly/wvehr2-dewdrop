PRCST14 ; ;09/19/10
 D DE G BEGIN
DE S DIE="^PRCS(410,",DIC=DIE,DP=410,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^PRCS(410,DA,""))=""
 I $D(^(7)) S %Z=^(7) S %=$P(%Z,U,1) S:%]"" DE(4)=% S %=$P(%Z,U,3) S:%]"" DE(6)=% S %=$P(%Z,U,5) S:%]"" DE(8)=%
 I $D(^(9)) S %Z=^(9) S %=$P(%Z,U,1) S:%]"" DE(2)=%
 I $D(^(14)) S %Z=^(14) S %=$P(%Z,U,1) S:%]"" DE(9)=%
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
BEGIN S DNM="PRCST14",DQ=1
1 S D=0 K DE(1) ;16
 S DIFLD=16,DGO="^PRCST15",DC="3^410.04P^12^",DV="410.04M*P410.4X",DW="0;1",DOW="SUB-CONTROL POINT",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="PRCS(410.4,"
 G RE:D I $D(DSC(410.04))#2,$P(DSC(410.04),"I $D(^UTILITY(",1)="" X DSC(410.04) S D=$O(^(0)) S:D="" D=-1 G M1
 S D=$S($D(^PRCS(410,DA,12,0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M1 I D>0 S DC=DC_D I $D(^PRCS(410,DA,12,+D,0)) S DE(1)=$P(^(0),U,1)
 G RE
R1 D DE
 S D=$S($D(^PRCS(410,DA,12,0)):$P(^(0),U,3,4),1:1) G 1+1
 ;
2 S DW="9;1",DV="FX",DU="",DLB="DELIVER TO/LOCATION",DIFLD=46
 G RE
X2 K:$L(X)>30!($L(X)<3)!(X'?.ANP) X
 I $D(X),X'?.ANP K X
 Q
 ;
3 S D=0 K DE(1) ;45
 S Y="JUSTIFICATION^W^^0;1^Q",DG="8",DC="^410.06" D DIEN^DIWE K DE(1) G A
 ;
4 S DW="7;1",DV="P200'X",DU="",DLB="REQUESTOR",DIFLD=40
 S DE(DW)="C4^PRCST14"
 S DU="VA(200,"
 G RE
C4 G C4S:$D(DE(4))[0 K DB
 S X=DE(4),DIC=DIE
 S $P(^PRCS(410,DA,7),"^",2)=""
C4S S X="" G:DG(DQ)=X C4F1 K DB
 S X=DG(DQ),DIC=DIE
 I $D(^VA(200,X,20)),$P(^(20),"^",3)'="" S $P(^PRCS(410,DA,7),"^",2)=$P(^VA(200,X,20),"^",3)
C4F1 Q
X4 I $D(^PRC(411,PRC("SITE"),8,X)) K X Q
 Q
 ;
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 I $D(^PRC(420,PRC("SITE"),1,+PRC("CP"),0)),$P(^(0),"^",11)="Y" S Y=68
 Q
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="7;3",DV="P200'",DU="",DLB="APPROVING OFFICIAL",DIFLD=42
 S DE(DW)="C6^PRCST14"
 S DU="VA(200,"
 G RE
C6 G C6S:$D(DE(6))[0 K DB
 S X=DE(6),DIC=DIE
 S $P(^PRCS(410,DA,7),"^",4)=""
C6S S X="" G:DG(DQ)=X C6F1 K DB
 S X=DG(DQ),DIC=DIE
 I $D(^VA(200,X,20)),$P(^(20),"^",3)'="" S $P(^PRCS(410,DA,7),"^",4)=$P(^VA(200,X,20),"^",3)
C6F1 Q
X6 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 G A
8 D:$D(DG)>9 F^DIE17,DE S DQ=8,DW="7;5",DV="D",DU="",DLB="DATE SIGNED (APPROVED)",DIFLD=44
 S Y="TODAY"
 G Y
X8 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
9 S DW="14;1",DV="P200'",DU="",DLB="ORIGINATOR OF REQUEST",DIFLD=68
 S DU="VA(200,"
 G RE
X9 Q
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 K PRCSJP,PRCSTDT,PRCSSUB
 Q
11 S D=0 K DE(1) ;60
 S Y="COMMENTS^W^^0;1^Q",DG="CO",DC="^410.05" D DIEN^DIWE K DE(1) G A
 ;
12 G 0^DIE17
