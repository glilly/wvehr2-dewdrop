FBCTV ; GENERATED FROM 'FB VENDOR UPDATE' INPUT TEMPLATE(#1055), FILE 161.2;09/19/10
 D DE G BEGIN
DE S DIE="^FBAAV(",DIC=DIE,DP=161.2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^FBAAV(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(2)=% S %=$P(%Z,U,2) S:%]"" DE(3)=% S %=$P(%Z,U,3) S:%]"" DE(4)=% S %=$P(%Z,U,4) S:%]"" DE(5)=% S %=$P(%Z,U,5) S:%]"" DE(6)=% S %=$P(%Z,U,6) S:%]"" DE(7)=% S %=$P(%Z,U,7) S:%]"" DE(8)=%
 I  S %=$P(%Z,U,8) S:%]"" DE(9)=% S %=$P(%Z,U,9) S:%]"" DE(10)=% S %=$P(%Z,U,10) S:%]"" DE(11)=% S %=$P(%Z,U,13) S:%]"" DE(12)=% S %=$P(%Z,U,14) S:%]"" DE(13)=%,DE(14)=% S %=$P(%Z,U,17) S:%]"" DE(17)=% S %=$P(%Z,U,18) S:%]"" DE(18)=%
 I $D(^(1)) S %Z=^(1) S %=$P(%Z,U,1) S:%]"" DE(21)=% S %=$P(%Z,U,10) S:%]"" DE(22)=%,DE(23)=%
 I $D(^(3)) S %Z=^(3) S %=$P(%Z,U,2) S:%]"" DE(15)=%
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
BEGIN S DNM="FBCTV",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(1055,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=1055,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 S:'$D(Z1) Y="@10"
 Q
2 S DW="0;1",DV="RFX",DU="",DLB="NAME",DIFLD=.01
 S DE(DW)="C2^FBCTV"
 S X=$P(Z1,U)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 K ^FBAAV("B",$E(X,1,46),DA)
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^FBAAV("B",$E(X,1,46),DA)=""
C2F1 Q
X2 Q
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="0;2",DV="RFOX",DU="",DLB="ID NUMBER",DIFLD=1
 S DQ(3,2)="S Y(0)=Y S Y=$E(Y,1,3)_""-""_$E(Y,4,5)_""-""_$E(Y,6,99)"
 S DE(DW)="C3^FBCTV"
 S X=$P(Z1,U,2)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 K ^FBAAV("C",$E(X,1,30),DA)
 S X=DE(3),DIC=DIE
 K ^FBAAV("BS",$E(X,6,9),DA)
 S X=DE(3),DIC=DIE
 K:$P(^FBAAV(DA,0),U,10) ^FBAAV("AD",X_$E("0000",$L($P(^(0),U,10))+1,4)_$P(^(0),U,10),DA)
 S X=DE(3),DIC=DIE
 K ^FBAAV("E",$E(X,1,9),DA)
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^FBAAV("C",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^FBAAV("BS",$E(X,6,9),DA)=""
 S X=DG(DQ),DIC=DIE
 S:$P(^FBAAV(DA,0),U,10) ^FBAAV("AD",X_$E("0000",$L($P(^(0),U,10))+1,4)_$P(^(0),U,10),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^FBAAV("E",$E(X,1,9),DA)=""
C3F1 Q
X3 Q
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW="0;3",DV="F",DU="",DLB="STREET ADDRESS",DIFLD=2
 S X=$P(Z1,U,3)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X4 Q
5 S DW="0;4",DV="RF",DU="",DLB="CITY",DIFLD=3
 S X=$P(Z1,U,4)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X5 Q
6 S DW="0;5",DV="RP5'",DU="",DLB="STATE",DIFLD=4
 S DE(DW)="C6^FBCTV"
 S DU="DIC(5,"
 S X=$P(Z1,U,5)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C6 G C6S:$D(DE(6))[0 K DB
 S X=DE(6),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^FBAAV(D0,0)):^(0),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X="" S DIH=$S($D(^FBAAV(DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,13)=DIV,DIH=161.2,DIG=5.5 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
C6S S X="" G:DG(DQ)=X C6F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
C6F1 Q
X6 Q
7 D:$D(DG)>9 F^DIE17,DE S DQ=7,DW="0;6",DV="RFX",DU="",DLB="ZIP CODE",DIFLD=5
 S X=$P(Z1,U,6)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X7 Q
8 S DW="0;7",DV="RS",DU="",DLB="TYPE OF VENDOR",DIFLD=6
 S DU="1:PUBLIC HOSPITAL;2:PHYSICIAN;3:PHARMACY;4:PROSTHETICS;5:TRAVEL;6:RADIOLOGY;7:LABORATORY;8:OTHER;9:PRIVATE HOSPITAL;10:FEDERAL HOSPITAL;"
 S X=$P(Z1,U,7)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X8 Q
9 S DW="0;8",DV="P161.6'",DU="",DLB="SPECIALTY CODE",DIFLD=.05
 S DU="FBAA(161.6,"
 S X=$P(Z1,U,8)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X9 Q
10 S DW="0;9",DV="RP161.81'",DU="",DLB="PART CODE",DIFLD=7
 S DU="FBAA(161.81,"
 S X=$P(Z1,U,9)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X10 Q
11 S DW="0;10",DV="FX",DU="",DLB="CHAIN",DIFLD=8
 S DE(DW)="C11^FBCTV"
 S X=$P(Z1,U,10)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C11 G C11S:$D(DE(11))[0 K DB
 S X=DE(11),DIC=DIE
 K:$P(^FBAAV(DA,0),U,2) ^FBAAV("AD",$P(^(0),U,2)_$E("0000",$L(X)+1,4)_X,DA)
C11S S X="" G:DG(DQ)=X C11F1 K DB
 S X=DG(DQ),DIC=DIE
 S:$P(^FBAAV(DA,0),U,2) ^FBAAV("AD",$P(^(0),U,2)_$E("0000",$L(X)+1,4)_X,DA)=""
C11F1 Q
X11 Q
12 D:$D(DG)>9 F^DIE17,DE S DQ=12,DW="0;13",DV="RNJ4,0XO",DU="",DLB="COUNTY",DIFLD=5.5
 S DQ(12,2)="S Y(0)=Y S Y(0)=Y Q:Y']""""  S Z0=$S($D(^FBAAV(D0,0)):+$P(^(0),""^"",5),1:"""") Q:'Z0  S Y=$P($S($D(^DIC(5,Z0,1,Y,0)):^(0),1:""""),""^"",1)"
 S X=$P(Z1,U,13)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X12 Q
13 S DW="0;14",DV="F",DU="",DLB="STREET ADDRESS 2",DIFLD=2.5
 S Y="@"
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X13 Q
14 S DW="0;14",DV="F",DU="",DLB="STREET ADDRESS 2",DIFLD=2.5
 S X=$P(Z1,U,14)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X14 Q
15 S DW="3;2",DV="FX",DU="",DLB="NPI",DIFLD=41.01
 S DE(DW)="C15^FBCTV"
 S X=Z6
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C15 G C15S:$D(DE(15))[0 K DB
 S X=DE(15),DIC=DIE
 K ^FBAAV("NPI",$E(X,1,30),DA)
 S X=DE(15),DIC=DIE
 K ^FBAAV("NPIHISTORY",$E(X,1,30),DA)
C15S S X="" G:DG(DQ)=X C15F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^FBAAV("NPI",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^FBAAV("NPIHISTORY",$E(X,1,30),DA)=""
C15F1 Q
X15 Q
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 G A
17 D:$D(DG)>9 F^DIE17,DE S DQ=17,DW="0;17",DV="F",DU="",DLB="MEDICARE ID NUMBER",DIFLD=22
 S X=$P(Z1,U,17)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X17 Q
18 S DW="0;18",DV="F",DU="",DLB="MAIL ROUTE CODE",DIFLD=5.18
 S X=$P(Z1,U,18)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X18 Q
19 S DQ=20 ;@10
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 S:'$D(Z3) Y="@20"
 Q
21 S DW="1;1",DV="F",DU="",DLB="PHONE NUMBER",DIFLD=14
 S X=$P(Z3,U,1)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X21 Q
22 S DW="1;10",DV="S",DU="",DLB="BUSINESS TYPE (FPDS)",DIFLD=24
 S DU="1:SMALL BUSINESS;2:LARGE BUSINESS;3:OUTSIDE U.S.;4:OTHER ENTITIES;"
 S Y="@"
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X22 Q
23 S DW="1;10",DV="S",DU="",DLB="BUSINESS TYPE (FPDS)",DIFLD=24
 S DU="1:SMALL BUSINESS;2:LARGE BUSINESS;3:OUTSIDE U.S.;4:OTHER ENTITIES;"
 S X=$P(Z3,U,10)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X23 Q
24 S DQ=25 ;@20
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 S:'$D(Z4) Y=""
 Q
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 S:$G(FBTMPCK) Y="@30"
 Q
27 D:$D(DG)>9 F^DIE17 G ^FBCTV1
