DVBHCE5 ; ;09/20/12
 D DE G BEGIN
DE S DIE="^DPT(",DIC=DIE,DP=2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DPT(DA,""))=""
 I $D(^(.11)) S %Z=^(.11) S %=$P(%Z,U,1) S:%]"" DE(46)=%
 I $D(^(.3)) S %Z=^(.3) S %=$P(%Z,U,1) S:%]"" DE(30)=% S %=$P(%Z,U,6) S:%]"" DE(23)=% S %=$P(%Z,U,11) S:%]"" DE(40)=%
 I $D(^(.32)) S %Z=^(.32) S %=$P(%Z,U,3) S:%]"" DE(9)=% S %=$P(%Z,U,14) S:%]"" DE(3)=% S %=$P(%Z,U,15) S:%]"" DE(2)=% S %=$P(%Z,U,17) S:%]"" DE(1)=% S %=$P(%Z,U,18) S:%]"" DE(4)=%
 I $D(^(.36)) S %Z=^(.36) S %=$P(%Z,U,1) S:%]"" DE(33)=%
 I $D(^(.361)) S %Z=^(.361) S %=$P(%Z,U,1) S:%]"" DE(18)=% S %=$P(%Z,U,2) S:%]"" DE(20)=% S %=$P(%Z,U,5) S:%]"" DE(21)=%
 I $D(^(.362)) S %Z=^(.362) S %=$P(%Z,U,12) S:%]"" DE(37)=% S %=$P(%Z,U,13) S:%]"" DE(38)=% S %=$P(%Z,U,14) S:%]"" DE(39)=% S %=$P(%Z,U,20) S:%]"" DE(41)=%
 I $D(^("TYPE")) S %Z=^("TYPE") S %=$P(%Z,U,1) S:%]"" DE(28)=%
 I $D(^("VET")) S %Z=^("VET") S %=$P(%Z,U,1) S:%]"" DE(29)=%
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
BEGIN S DNM="DVBHCE5",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW=".32;17",DV="RDX",DU="",DLB="NNTL-RAD",DIFLD=.3298
 S DE(DW)="C1^DVBHCE5",DE(DW,"INDEX")=1
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 D EVENT^IVMPLOG(DA)
C1S S X="" G:DG(DQ)=X C1F1 K DB
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C1F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=663 S DIEZRXR(2,DIXR)=""
 Q
X1 S %DT="E",%DT(0)=-DT D ^%DT K %DT S X=Y K:Y<1 X I $D(X) S DFN=DA D SER2^DGLOCK I $D(X) K:'$$VALMSE^DGRPMS(DFN,X,1,"MSNNTL") X I $D(X),$D(^DG(43,1)) S SD1=3 D PS^DGINP
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW=".32;15",DV="P23'X",DU="",DLB="NNTL-Bran. Ser.",DIFLD=.3296
 S DE(DW)="C2^DVBHCE5",DE(DW,"INDEX")=1
 S DU="DIC(23,"
 G RE
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 I $P($G(^DPT(DA,.321)),U,14)]"" D FVP^DGRPMS
 S X=DE(2),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(2),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.3291)):^(.3291),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" S DIH=$G(^DPT(DIV(0),.3291)),DIV=X S $P(^(.3291),U,3)=DIV,DIH=2,DIG=.32913 D ^DICR
 S X=DE(2),DIC=DIE
 X "S DGXRF=.3296 D ^DGDDC Q"
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.3291)):^(.3291),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" S DIH=$G(^DPT(DIV(0),.3291)),DIV=X S $P(^(.3291),U,3)=DIV,DIH=2,DIG=.32913 D ^DICR
 S X=DG(DQ),DIC=DIE
 ;
C2F1 N X,X1,X2 S DIXR=410 D C2X1(U) K X2 M X2=X D C2X1("O") K X1 M X1=X
 D
 . N DIEXARR M DIEXARR=X S DIEZCOND=1
 . S X=X2(1)=""
 . S DIEZCOND=$G(X) K X M X=DIEXARR Q:'DIEZCOND
 . D DELMSE^DGRPMS(DA,3)
 G C2F2
C2X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.3296,DION),$P($G(^DPT(DA,.32)),U,15))
 S X=$G(X(1))
 Q
C2F2 Q
X2 S DFN=DA K:X=$O(^DIC(23,"B","B.E.C.","")) X I $D(X) D SER2^DGLOCK S DGCOMBR=$G(Y) Q
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW=".32;14",DV="RP25'X",DU="",DLB="NNTL-Char. Ser.",DIFLD=.3295
 S DE(DW)="C3^DVBHCE5"
 S DU="DIC(25,"
 G RE
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 D EVENT^IVMPLOG(DA)
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C3F1 Q
X3 S DFN=DA D SER2^DGLOCK
 Q
 ;
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW=".32;18",DV="FX",DU="",DLB="NNTL-Ser. Num.",DIFLD=.3299
 S DE(DW)="C4^DVBHCE5"
 G RE
C4 G C4S:$D(DE(4))[0 K DB
 S X=DE(4),DIC=DIE
 D EVENT^IVMPLOG(DA)
C4S S X="" G:DG(DQ)=X C4F1 K DB
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C4F1 Q
X4 S DFN=DA D SER2^DGLOCK I $D(X) S:X?1"SS".E L=$S($D(^DPT(DA,0)):$P(^(0),U,9),1:X) W:X?1"SS".E "  ",L S:X?1"SS".E X=L K:$L(X)>15!($L(X)<1)!'(X?.N) X
 I $D(X),X'?.ANP K X
 Q
 ;
5 S DQ=6 ;@33
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 I Z2'[4 S Y="@3"
 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 S DVBSCR=1 D ^DVBHS4
 Q
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 S DVBJC2=$S($D(^DPT(D0,.32)):$P(^(.32),U,3),1:"")
 Q
9 D:$D(DG)>9 F^DIE17,DE S DQ=9,DW=".32;3",DV="*P21'Xa",DU="",DLB="PERIOD OF SERVICE",DIFLD=.323
 S DE(DW)="C9^DVBHCE5"
 S DU="DIC(21,"
 G RE
C9 G C9S:$D(DE(9))[0 K DB
 S X=DE(9),DIC=DIE
 K ^DPT("APOS",$E(X,1,30),DA)
 S X=DE(9),DIC=DIE
 ;
 S X=DE(9),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".323;" D AVAFC^VAFCDD01(DA)
 S X=DE(9),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(9),DIIX=2_U_DIFLD D AUDIT^DIET
C9S S X="" G:DG(DQ)=X C9F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^DPT("APOS",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.323,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,"ODS")):^("ODS"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y X ^DD(2,.323,1,2,1.1) X ^DD(2,.323,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".323;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 I $D(DE(9))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C9F1 Q
X9 S DFN=DA D POS^DGLOCK1
 Q
 ;
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 I X'=DVBJC2 S DVBJ2=1
 Q
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 K DVBJC2
 Q
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 S Y="@3"
 Q
13 S DQ=14 ;@104
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 D ^DVBHS5 S Y="@5" K DXS
 Q
15 S DQ=16 ;@204
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 I Z2'[1 S Y="@205"
 Q
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 S DVBSCR=1 D ^DVBHS5 S DVBJ2=1
 Q
18 D:$D(DG)>9 F^DIE17,DE S DQ=18,DW=".361;1",DV="SX",DU="",DLB="ELIGIBILITY STATUS",DIFLD=.3611
 S DE(DW)="C18^DVBHCE5"
 S DU="P:PENDING VERIFICATION;R:PENDING RE-VERIFICATION;V:VERIFIED;"
 G RE
C18 G C18S:$D(DE(18))[0 K DB
 S X=DE(18),DIC=DIE
 ;
 S X=DE(18),DIC=DIE
 ;
 S X=DE(18),DIC=DIE
 D EVENT^IVMPLOG(DA)
C18S S X="" G:DG(DQ)=X C18F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.361)):^(.361),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y X ^DD(2,.3611,1,1,1.1) X ^DD(2,.3611,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.361)):^(.361),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV N %I,%H,% D NOW^%DTC X ^DD(2,.3611,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C18F1 Q
X18 D EK^DGLOCK Q:'$D(X)
 Q
 ;
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 G A
20 D:$D(DG)>9 F^DIE17,DE S DQ=20,DW=".361;2",DV="DX",DU="",DLB="ELIGIBILITY STATUS DATE",DIFLD=.3612
 S DE(DW)="C20^DVBHCE5"
 S X="TODAY"
 S Y=X
 G Y
C20 G C20S:$D(DE(20))[0 K DB
 S X=DE(20),DIC=DIE
 ;
 S X=DE(20),DIC=DIE
 D EVENT^IVMPLOG(DA)
C20S S X="" G:DG(DQ)=X C20F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.361)):^(.361),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X=$S(($D(DUZ)#2):DUZ,1:"") X ^DD(2,.3612,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C20F1 Q
X20 S %DT="E",%DT(0)=-DT D ^%DT K %DT S X=Y K:Y<1 X I $D(X) D EK^DGLOCK
 Q
 ;
21 D:$D(DG)>9 F^DIE17,DE S DQ=21,DW=".361;5",DV="FX",DU="",DLB="ELIGIBILITY VERIF. METHOD",DIFLD=.3615
 S DE(DW)="C21^DVBHCE5"
 S X="HINQ"
 S Y=X
 G Y
C21 G C21S:$D(DE(21))[0 K DB
 S X=DE(21),DIC=DIE
 D EVENT^IVMPLOG(DA)
C21S S X="" G:DG(DQ)=X C21F1 K DB
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C21F1 Q
X21 K:$L(X)>50!($L(X)<2) X I $D(X) D EK^DGLOCK
 I $D(X),X'?.ANP K X
 Q
 ;
22 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=22 G A
23 D:$D(DG)>9 F^DIE17,DE S DQ=23,DW=".3;6",DV="DX",DU="",DLB="MONETARY BEN. VERIFY DATE",DIFLD=.306
 S X="TODAY"
 S Y=X
 G Y
X23 S %DT="E",%DT(0)=-DT D ^%DT K %DT S X=Y K:Y<1 X I $D(X) D EK^DGLOCK
 Q
 ;
24 S D=0 K DE(1) ;361
 S DIFLD=361,DGO="^DVBHCE6",DC="3^2.0361IP^E^",DV="2.0361M*P8'X",DW="0;1",DOW="ELIGIBILITY",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="DIC(8,"
 G RE:D I $D(DSC(2.0361))#2,$P(DSC(2.0361),"I $D(^UTILITY(",1)="" X DSC(2.0361) S D=$O(^(0)) S:D="" D=-1 G M24
 S D=$S($D(^DPT(DA,"E",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M24 I D>0 S DC=DC_D I $D(^DPT(DA,"E",+D,0)) S DE(24)=$P(^(0),U,1)
 G RE
R24 D DE
 S D=$S($D(^DPT(DA,"E",0)):$P(^(0),U,3,4),1:1) G 24+1
 ;
25 S DQ=26 ;@205
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 I Z2'[2 S Y="@206"
 Q
27 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=27 D X27 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X27 S DVBSCR=1 D ^DVBHS5 S DVBJ2=1
 Q
28 S DW="TYPE;1",DV="P391'a",DU="",DLB="TYPE",DIFLD=391
 S DE(DW)="C28^DVBHCE5",DE(DW,"INDEX")=1
 S DU="DG(391,"
 G RE
C28 G C28S:$D(DE(28))[0 K DB
 S X=DE(28),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF="391;" D AVAFC^VAFCDD01(DA)
 S X=DE(28),DIIX=2_U_DIFLD D AUDIT^DIET
C28S S X="" G:DG(DQ)=X C28F1 K DB
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF="391;" D AVAFC^VAFCDD01(DA)
 I $D(DE(28))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C28F1 N X,X1,X2 S DIXR=664 D C28X1(U) K X2 M X2=X D C28X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DPT("APTYPE",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DPT("APTYPE",X,DA)=""
 G C28F2
C28X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,391,DION),$P($G(^DPT(DA,"TYPE")),U,1))
 S X=$G(X(1))
 Q
C28F2 Q
X28 Q
29 D:$D(DG)>9 F^DIE17,DE S DQ=29,DW="VET;1",DV="SXa",DU="",DLB="VETERAN (Y/N)?",DIFLD=1901
 S DE(DW)="C29^DVBHCE5"
 S DU="Y:YES;N:NO;"
 G RE
C29 G C29S:$D(DE(29))[0 K DB
 S X=DE(29),DIC=DIE
 S DFN=DA D EN^DGMTCOR K DGMTCOR
 S X=DE(29),DIC=DIE
 S DFN=DA D EN^DGRP7CC
 S X=DE(29),DIC=DIE
 ;
 S X=DE(29),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DE(29),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF="1901;" D AVAFC^VAFCDD01(DA)
 S X=DE(29),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(29),DIIX=2_U_DIFLD D AUDIT^DIET
C29S S X="" G:DG(DQ)=X C29F1 K DB
 S X=DG(DQ),DIC=DIE
 S DFN=DA D EN^DGMTCOR K DGMTCOR
 S X=DG(DQ),DIC=DIE
 S DFN=DA D EN^DGRP7CC
 S X=DG(DQ),DIC=DIE
 X ^DD(2,1901,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.3)):^(.3),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X=DIV S X="N" X ^DD(2,1901,1,3,1.4)
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF="1901;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(29))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C29F1 Q
X29 I $D(X) S:'$D(DPTX) DFN=DA D:'$D(^XUSEC("DG ELIGIBILITY",DUZ)) VAGE^DGLOCK:X="Y" I $D(X) D:$D(DFN) EV^DGLOCK
 Q
 ;
30 D:$D(DG)>9 F^DIE17,DE S DQ=30,DW=".3;1",DV="SXa",DU="",DLB="SERVICE CONNECTED?",DIFLD=.301
 S DE(DW)="C30^DVBHCE5"
 S DU="Y:YES;N:NO;"
 G RE
C30 G C30S:$D(DE(30))[0 K DB
 S X=DE(30),DIC=DIE
 ;
 S X=DE(30),DIC=DIE
 ;
 S X=DE(30),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DE(30),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".301;" D AVAFC^VAFCDD01(DA)
 S X=DE(30),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(30),DIIX=2_U_DIFLD D AUDIT^DIET
C30S S X="" G:DG(DQ)=X C30F1 K DB
 D ^DVBHCE7
C30F1 Q
X30 S DFN=DA D EV^DGLOCK I $D(X),X="Y" D VET^DGLOCK
 Q
 ;
31 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=31 D X31 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X31 I X="N" S Y="@2063"
 Q
32 S DQ=33 ;@2063
33 D:$D(DG)>9 F^DIE17,DE S DQ=33,DW=".36;1",DV="*P8'Xa",DU="",DLB="PRIMARY ELIGIBILITY CODE",DIFLD=.361
 S DE(DW)="C33^DVBHCE5",DE(DW,"INDEX")=1
 S DU="DIC(8,"
 G RE
C33 G C33S:$D(DE(33))[0 K DB
 D ^DVBHCE8
C33S S X="" G:DG(DQ)=X C33F1 K DB
 D ^DVBHCE9
C33F1 N X,X1,X2 S DIXR=743 D C33X1(U) K X2 M X2=X D C33X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.361,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.361,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C33F2
C33X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.361,DION),$P($G(^DPT(DA,.36)),U,1))
 S X=$G(X(1))
 Q
C33F2 Q
X33 S DFN=DA D EV^DGLOCK I $D(X) D ECD^DGLOCK1
 Q
 ;
34 S DQ=35 ;@206
35 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=35 D X35 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X35 I Z2'[3 S Y="@104"
 Q
36 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=36 D X36 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X36 S DVBSCR=1 D ^DVBHS5 S DVBJ2=1
 Q
37 D:$D(DG)>9 F^DIE17,DE S DQ=37,DW=".362;12",DV="SX",DU="",DLB="RECEIVING A&A BENEFITS?",DIFLD=.36205
 S DE(DW)="C37^DVBHCE5"
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C37 G C37S:$D(DE(37))[0 K DB
 D ^DVBHCE10
C37S S X="" G:DG(DQ)=X C37F1 K DB
 D ^DVBHCE11
C37F1 Q
X37 S DFN=DA D MV^DGLOCK I $D(X) S DFN=DA D EV^DGLOCK
 Q
 ;
38 D:$D(DG)>9 F^DIE17,DE S DQ=38,DW=".362;13",DV="SX",DU="",DLB="RECEIVING HOUSEBOUND BENEFITS?",DIFLD=.36215
 S DE(DW)="C38^DVBHCE5"
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C38 G C38S:$D(DE(38))[0 K DB
 D ^DVBHCE12
C38S S X="" G:DG(DQ)=X C38F1 K DB
 D ^DVBHCE13
C38F1 Q
X38 S DFN=DA D MV^DGLOCK I $D(X) S DFN=DA D EV^DGLOCK
 Q
 ;
39 D:$D(DG)>9 F^DIE17,DE S DQ=39,DW=".362;14",DV="SX",DU="",DLB="RECEIVING A VA PENSION?",DIFLD=.36235
 S DE(DW)="C39^DVBHCE5"
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C39 G C39S:$D(DE(39))[0 K DB
 D ^DVBHCE14
C39S S X="" G:DG(DQ)=X C39F1 K DB
 D ^DVBHCE15
C39F1 Q
X39 S DFN=DA D MV^DGLOCK
 Q
 ;
40 D:$D(DG)>9 F^DIE17,DE S DQ=40,DW=".3;11",DV="SX",DU="",DLB="RECEIVING VA DISABILITY?",DIFLD=.3025
 S DE(DW)="C40^DVBHCE5"
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C40 G C40S:$D(DE(40))[0 K DB
 D ^DVBHCE16
C40S S X="" G:DG(DQ)=X C40F1 K DB
 D ^DVBHCE17
C40F1 Q
X40 S DFN=DA D MV^DGLOCK I $D(X),X="Y" D EC^DGLOCK1
 Q
 ;
41 D:$D(DG)>9 F^DIE17,DE S DQ=41,DW=".362;20",DV="NJ8,2X",DU="",DLB="TOTAL ANNUAL VA CHECK AMOUNT",DIFLD=.36295
 S DE(DW)="C41^DVBHCE5"
 G RE
C41 G C41S:$D(DE(41))[0 K DB
 S X=DE(41),DIC=DIE
 X "S DFN=DA D EN^DGMTR K DGREQF"
 S X=DE(41),DIC=DIE
 D AUTOUPD^DGENA2(DA)
C41S S X="" G:DG(DQ)=X C41F1 K DB
 D ^DVBHCE18
C41F1 Q
X41 D DOL^DGLOCK2 K:+X'=X&(X'?.N1"."2N)!(X>99999)!(X<0) X I $D(X) S DFN=DA D MV^DGLOCK I $D(X),('$$TOTCHK^DGLOCK2(DFN)) D TOTCKMSG^DGLOCK2 K X
 Q
 ;
42 S DQ=43 ;@2062
43 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=43 D X43 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X43 S Y="@104"
 Q
44 S DQ=45 ;@11
45 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=45 D X45 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X45 S DVBJ2=1
 Q
46 D:$D(DG)>9 F^DIE17,DE S DQ=46,DW=".11;1",DV="Fa",DU="",DLB="STREET ADDRESS [LINE 1]",DIFLD=.111
 S DE(DW)="C46^DVBHCE5",DE(DW,"INDEX")=1
 G RE
C46 G C46S:$D(DE(46))[0 K DB
 D ^DVBHCE19
C46S S X="" G:DG(DQ)=X C46F1 K DB
 D ^DVBHCE20
C46F1 N X,X1,X2 S DIXR=230 D C46X1(U) K X2 M X2=X D C46X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.111,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.111,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C46F2
C46X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.111,DION),$P($G(^DPT(DA,.11)),U,1))
 S X=$G(X(1))
 Q
C46F2 Q
X46 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>35!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
47 D:$D(DG)>9 F^DIE17 G ^DVBHCE21
