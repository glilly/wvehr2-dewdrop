DGRPX76 ; ;08/31/12
 D DE G BEGIN
DE S DIE="^DPT(",DIC=DIE,DP=2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DPT(DA,""))=""
 I $D(^(.3)) S %Z=^(.3) S %=$P(%Z,U,9) S:%]"" DE(3)=%
 I $D(^(.32)) S %Z=^(.32) S %=$P(%Z,U,3) S:%]"" DE(5)=%
 I $D(^(.36)) S %Z=^(.36) S %=$P(%Z,U,1) S:%]"" DE(1)=%
 I $D(^("ODS")) S %Z=^("ODS") S %=$P(%Z,U,2) S:%]"" DE(7)=% S %=$P(%Z,U,3) S:%]"" DE(8)=%
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
BEGIN S DNM="DGRPX76",DQ=1
1 S DW=".36;1",DV="*P8'Xa",DU="",DLB="PRIMARY ELIGIBILITY CODE",DIFLD=.361
 S DE(DW)="C1^DGRPX76",DE(DW,"INDEX")=1
 S DU="DIC(8,"
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 ;
 S X=DE(1),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 X ^DD(2,.361,1,2,2.2) I DIV(1)>0 S DIK(0)=DA,DIK="^DPT(DIV(0),""E"",",DA(1)=DIV(0),DA=DIV(1) D ^DIK S DA=DIK(0) K DIK
 S X=DE(1),DIC=DIE
 X "I $S('$D(^DIC(8,+X,0)):0,$P(^(0),""^"",1)[""DOM"":0,'$D(^DPT(DA,.36)):1,'$D(^DIC(8,+^(.36),0)):1,$P(^(0),""^"",1)'[""DOM"":1,1:0) S DGXRF=.361 D ^DGDDC Q"
 S X=DE(1),DIC=DIE
 K ^DPT("AEL",DA,+X)
 S X=DE(1),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DE(1),DIIX=2_U_DIFLD D AUDIT^DIET
C1S S X="" G:DG(DQ)=X C1F1 K DB
 S X=DG(DQ),DIC=DIE
 X "S DFN=DA D EN^DGMTR K DGREQF"
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 X ^DD(2,.361,1,2,89.4) S Y(102)=$S($D(^DPT(D0,"E",D1,0)):^(0),1:"") S X=$S('$D(^DIC(8,+$P(Y(102),U,1),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) S D1=I(1,0) S DIU=X K Y S X=DIV S X=DIV,X=X X ^DD(2,.361,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 S ^DPT("AEL",DA,+X)=""
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 I $D(DE(1))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C1F1 N X,X1,X2 S DIXR=743 D C1X1(U) K X2 M X2=X D C1X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.361,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.361,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C1F2
C1X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.361,DION),$P($G(^DPT(DA,.36)),U,1))
 S X=$G(X(1))
 Q
C1F2 Q
X1 S DFN=DA D EV^DGLOCK I $D(X) D ECD^DGLOCK1
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 D AAC1^DGLOCK2 S:DGAAC(1)']"" Y=361
 Q
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW=".3;9",DV="*P35'X",DU="",DLB="AGENCY/ALLIED COUNTRY",DIFLD=.309
 S DU="DIC(35,"
 G RE
X3 S DFN=DA D AAC^DGLOCK2
 Q
 ;
4 S D=0 K DE(1) ;361
 S DIFLD=361,DGO="^DGRPX77",DC="3^2.0361IP^E^",DV="2.0361M*P8'X",DW="0;1",DOW="ELIGIBILITY",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="DIC(8,"
 G RE:D I $D(DSC(2.0361))#2,$P(DSC(2.0361),"I $D(^UTILITY(",1)="" X DSC(2.0361) S D=$O(^(0)) S:D="" D=-1 G M4
 S D=$S($D(^DPT(DA,"E",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M4 I D>0 S DC=DC_D I $D(^DPT(DA,"E",+D,0)) S DE(4)=$P(^(0),U,1)
 G RE
R4 D DE
 S D=$S($D(^DPT(DA,"E",0)):$P(^(0),U,3,4),1:1) G 4+1
 ;
5 S DW=".32;3",DV="*P21'Xa",DU="",DLB="PERIOD OF SERVICE",DIFLD=.323
 S DE(DW)="C5^DGRPX76"
 S DU="DIC(21,"
 G RE
C5 G C5S:$D(DE(5))[0 K DB
 S X=DE(5),DIC=DIE
 K ^DPT("APOS",$E(X,1,30),DA)
 S X=DE(5),DIC=DIE
 ;
 S X=DE(5),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".323;" D AVAFC^VAFCDD01(DA)
 S X=DE(5),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(5),DIIX=2_U_DIFLD D AUDIT^DIET
C5S S X="" G:DG(DQ)=X C5F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^DPT("APOS",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.323,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,"ODS")):^("ODS"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y X ^DD(2,.323,1,2,1.1) X ^DD(2,.323,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".323;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 I $D(DE(5))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C5F1 Q
X5 S DFN=DA D POS^DGLOCK1
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 D ^DGYZODS S:'DGODS Y="@704"
 Q
7 D:$D(DG)>9 F^DIE17,DE S DQ=7,DW="ODS;2",DV="S",DU="",DLB="RECALLED TO ACTIVE DUTY",DIFLD=11500.02
 S DE(DW)="C7^DGRPX76"
 S DU="0:NO;1:NATIONAL GUARD;2:RESERVES;"
 G RE
C7 G C7S:$D(DE(7))[0 K DB
 S X=DE(7),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
C7S S X="" G:DG(DQ)=X C7F1 K DB
 S X=DG(DQ),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
C7F1 Q
X7 Q
8 D:$D(DG)>9 F^DIE17,DE S DQ=8,DW="ODS;3",DV="*P25002.1'",DU="",DLB="RANK",DIFLD=11500.03
 S DE(DW)="C8^DGRPX76"
 S DU="DIC(25002.1,"
 G RE
C8 G C8S:$D(DE(8))[0 K DB
 S X=DE(8),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
C8S S X="" G:DG(DQ)=X C8F1 K DB
 S X=DG(DQ),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
C8F1 Q
X8 S DIC("S")="I '$P(^(0),""^"",4),(""^e^c^""[(""^""_$P(^(0),""^"",2)_""^""))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
9 S DQ=10 ;@704
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S:DGDR'["704" Y="@99"
 Q
11 D:$D(DG)>9 F^DIE17,DE S DQ=11,D=0 K DE(1) ;.3731
 S DIFLD=.3731,DGO="^DGRPX78",DC="2^2.05A^.373^",DV="2.05MFX",DW="0;1",DOW="SERVICE CONNECTED CONDITIONS",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 G RE:D I $D(DSC(2.05))#2,$P(DSC(2.05),"I $D(^UTILITY(",1)="" X DSC(2.05) S D=$O(^(0)) S:D="" D=-1 G M11
 S D=$S($D(^DPT(DA,.373,0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M11 I D>0 S DC=DC_D I $D(^DPT(DA,.373,+D,0)) S DE(11)=$P(^(0),U,1)
 G RE
R11 D DE
 S D=$S($D(^DPT(DA,.373,0)):$P(^(0),U,3,4),1:1) G 11+1
 ;
12 S DQ=13 ;@99
13 G 0^DIE17
