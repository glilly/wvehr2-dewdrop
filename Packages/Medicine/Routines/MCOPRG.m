MCOPRG ; GENERATED FROM 'MCBUILDGENERIC' INPUT TEMPLATE(#1424), FILE 697.2;09/19/10
 D DE G BEGIN
DE S DIE="^MCAR(697.2,",DIC=DIE,DP=697.2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^MCAR(697.2,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(13)=% S %=$P(%Z,U,2) S:%]"" DE(1)=% S %=$P(%Z,U,3) S:%]"" DE(3)=% S %=$P(%Z,U,4) S:%]"" DE(5)=% S %=$P(%Z,U,5) S:%]"" DE(6)=% S %=$P(%Z,U,6) S:%]"" DE(7)=% S %=$P(%Z,U,7) S:%]"" DE(8)=%
 I  S %=$P(%Z,U,8) S:%]"" DE(14)=% S %=$P(%Z,U,9) S:%]"" DE(9)=% S %=$P(%Z,U,10) S:%]"" DE(10)=% S %=$P(%Z,U,11) S:%]"" DE(11)=% S %=$P(%Z,U,12) S:%]"" DE(2)=% S %=$P(%Z,U,13) S:%]"" DE(4)=% S %=$P(%Z,U,19) S:%]"" DE(12)=%
 I $D(^(1)) S %Z=^(1) S %=$P(%Z,U,1) S:%]"" DE(15)=%
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
BEGIN S DNM="MCOPRG",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(1424,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=1424,U="^"
1 S DW="0;2",DV="RFX",DU="",DLB="GLOBAL LOCATION",DIFLD=1
 S DE(DW)="C1^MCOPRG"
 S Y="MCAR(699.5"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 K ^MCAR(697.2,"C",$E(X,1,30),DA)
C1S S X="" G:DG(DQ)=X C1F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^MCAR(697.2,"C",$E(X,1,30),DA)=""
C1F1 Q
X1 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>10!($L(X)<5)!'(X'?1P.E)!(X'?.ANP) X
 I $D(X),X'?.ANP K X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="0;12",DV="F",DU="",DLB="MEDICAL PATIENT FIELD NUMBER",DIFLD=1.1
 S Y=".02"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X2 K:$L(X)>7!($L(X)<1)!'(X?.3N.1".".3N) X
 I $D(X),X'?.ANP K X
 Q
 ;
3 S DW="0;3",DV="F",DU="",DLB="SCREEN ONE",DIFLD=2
 S Y="MCFSGEN"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X3 K:$L(X)>16!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
4 S DW="0;13",DV="F",DU="",DLB="BRIEF SCREEN ONE",DIFLD=2.1
 S Y="MCBSGEN"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X4 K:$L(X)>16!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
5 S DW="0;4",DV="RS",DU="",DLB="TYPE OF PROCEDURE",DIFLD=3
 S DE(DW)="C5^MCOPRG"
 S DU="C:CARDIOLOGY;G:GI;H:HEMATOLOGY;P:PULMONARY ENDOSCOPY;Z:CONSULT;PF:PULMONARY FUNCTION TEST;R:RHEUMATOLOGY;GEN:GENERIC;I:INTERNAL;HI:INTERNAL HEMATOLOGY;N:NEUROLOGY;"
 S Y="GEN"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C5 G C5S:$D(DE(5))[0 K DB
 S X=DE(5),DIC=DIE
 K ^MCAR(697.2,"D",$E(X,1,30),DA)
C5S S X="" G:DG(DQ)=X C5F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^MCAR(697.2,"D",$E(X,1,30),DA)=""
C5F1 Q
X5 Q
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="0;5",DV="F",DU="",DLB="ENTRY POINT OF PRINT ROUTINE",DIFLD=4
 S Y="GENERIC"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X6 K:$L(X)>8!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
7 S DW="0;6",DV="F",DU="",DLB="PRINT ROUTINE",DIFLD=5
 S Y="MCARPAC"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X7 K:$L(X)>8!($L(X)<5) X
 I $D(X),X'?.ANP K X
 Q
 ;
8 S DW="0;7",DV="F",DU="",DLB="PRINT LINE",DIFLD=6
 S Y="GENERIC"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X8 K:$L(X)>8!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
9 S DW="0;9",DV="S",DU="",DLB="USED WITH GENERIC MODULE?",DIFLD=8
 S DU="1:YES;"
 S Y="1"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X9 Q
10 S DW="0;10",DV="FX",DU="",DLB="INPUT TEMPLATE",DIFLD=9
 S Y="MCFLGEN"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X10 K:$L(X)>30!($L(X)<3)!'$D(^DIE("B",X)) X
 I $D(X),X'?.ANP K X
 Q
 ;
11 S DW="0;11",DV="FX",DU="",DLB="BRIEF INPUT TEMPLATE",DIFLD=10
 S Y="MCBLGEN"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X11 K:$L(X)>30!($L(X)<3)!'$D(^DIE("B",X)) X
 I $D(X),X'?.ANP K X
 Q
 ;
12 S DW="0;19",DV="S",DU="",DLB="LOCALLY DEFINED",DIFLD=16
 S DU="1:YES;"
 S Y="1"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X12 Q
13 S DW="0;1",DV="RFX",DU="",DLB="NAME",DIFLD=.01
 S DE(DW)="C13^MCOPRG"
 G RE
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIC=DIE
 K ^MCAR(697.2,"B",$E(X,1,30),DA)
C13S S X="" G:DG(DQ)=X C13F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^MCAR(697.2,"B",$E(X,1,30),DA)=""
C13F1 Q
X13 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>20!($L(X)<2) X
 I $D(X),X'?.ANP K X
 Q
 ;
14 D:$D(DG)>9 F^DIE17,DE S DQ=14,DW="0;8",DV="RFX",DU="",DLB="PRINT NAME",DIFLD=7
 S DE(DW)="C14^MCOPRG"
 G RE
C14 G C14S:$D(DE(14))[0 K DB
 S X=DE(14),DIC=DIE
 K ^MCAR(697.2,"BA",$E(X,1,30),DA)
C14S S X="" G:DG(DQ)=X C14F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^MCAR(697.2,"BA",$E(X,1,30),DA)=""
C14F1 Q
X14 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<1)!($O(^MCAR(697.2,"BA",X,0))) X
 I $D(X),X'?.ANP K X
 Q
 ;
15 D:$D(DG)>9 F^DIE17,DE S DQ=15,DW="1;1",DV="RS",DU="",DLB="PROCEDURE/SUBSPECIALTY",DIFLD=1001
 S DU="P:PROCEDURE;S:SUBSPECIALTY;"
 G RE
X15 Q
16 S D=0 K DE(1) ;1000
 S DIFLD=1000,DGO="^MCOPRG1",DC="1^697.21PA^CPT^",DV="697.21MP81'",DW="0;1",DOW="CPT",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="ICPT("
 G RE:D I $D(DSC(697.21))#2,$P(DSC(697.21),"I $D(^UTILITY(",1)="" X DSC(697.21) S D=$O(^(0)) S:D="" D=-1 G M16
 S D=$S($D(^MCAR(697.2,DA,"CPT",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M16 I D>0 S DC=DC_D I $D(^MCAR(697.2,DA,"CPT",+D,0)) S DE(16)=$P(^(0),U,1)
 G RE
R16 D DE
 S D=$S($D(^MCAR(697.2,DA,"CPT",0)):$P(^(0),U,3,4),1:1) G 16+1
 ;
17 G 0^DIE17
