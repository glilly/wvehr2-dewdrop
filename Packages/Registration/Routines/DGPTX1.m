DGPTX1 ; GENERATED FROM 'DG101' INPUT TEMPLATE(#426), FILE 45;08/30/12
 D DE G BEGIN
DE S DIE="^DGPT(",DIC=DIE,DP=45,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DGPT(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,3) S:%]"" DE(4)=% S %=$P(%Z,U,5) S:%]"" DE(5)=%
 I $D(^(70)) S %Z=^(70) S %=$P(%Z,U,4) S:%]"" DE(26)=% S %=$P(%Z,U,5) S:%]"" DE(27)=% S %=$P(%Z,U,6) S:%]"" DE(22)=% S %=$P(%Z,U,8) S:%]"" DE(34)=% S %=$P(%Z,U,9) S:%]"" DE(33)=% S %=$P(%Z,U,12) S:%]"" DE(31)=% S %=$P(%Z,U,13) S:%]"" DE(32)=%
 I $D(^(101)) S %Z=^(101) S %=$P(%Z,U,1) S:%]"" DE(6)=% S %=$P(%Z,U,3) S:%]"" DE(7)=% S %=$P(%Z,U,4) S:%]"" DE(12)=% S %=$P(%Z,U,5) S:%]"" DE(8)=% S %=$P(%Z,U,6) S:%]"" DE(9)=% S %=$P(%Z,U,8) S:%]"" DE(10)=%
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
BEGIN S DNM="DGPTX1",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(426,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=426,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 S:+DGJUMP'=1 Y="@99"
 Q
2 S DQ=3 ;@1
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 S DGJUMP=$P(DGJUMP,"1,",2)
 Q
4 S DW="0;3",DV="RNJ3,0X",DU="",DLB="FACILITY",DIFLD=3
 S X=$P($$SITE^VASITE,U,3)
 S Y=X
 G Y
X4 S DIC="^DIC(4,",DIC(0)="M" D ^DIC S X=$S($D(^DIC(4,+Y,99)):+^(99),1:"") K:Y'>0 X
 Q
 ;
5 S DW="0;5",DV="FX",DU="",DLB="SUFFIX",DIFLD=5
 S DE(DW)="C5^DGPTX1"
 G RE
C5 G C5S:$D(DE(5))[0 K DB
 S X=DE(5),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGPT(D0,101)):^(101),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X="" S DIH=$S($D(^DGPT(DIV(0),101)):^(101),1:""),DIV=X S $P(^(101),U,1)=DIV,DIH=45,DIG=20 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
C5S S X="" G:DG(DQ)=X C5F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
C5F1 Q
X5 D UP^DGHELP S DIC="^DIC(45.81,",DIC(0)="EFC",D="D1" D IX^DIC S DIC=$S($D(DIE):DIE,1:DIC) I Y'>0!(X=" ")!('$$ACTIVE^DGPTDD($G(X),+Y,+$G(PTF))) K X
 I $D(X),X'?.ANP K X
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="101;1",DV="*P45.1'R",DU="",DLB="SOURCE OF ADMISSION",DIFLD=20
 S DU="DIC(45.1,"
 G RE
X6 S DIC("S")="S DGER=0 D SA^DGPTFJ K DGSU0,DGSU1 I 'DGER" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
7 S DW="101;3",DV="S",DU="",DLB="SOURCE OF PAYMENT",DIFLD=22
 S DU="1:CONTRACT-PUBLIC&PRIV;2:SHARING;3:CONTRACT-MILT&FED AGENCY;4:PAID UNAUTH;"
 G RE
X7 Q
8 S DW="101;5",DV="NJ3,0X",DU="",DLB="TRANSFERRING FACILITY",DIFLD=21.1
 G RE
X8 S DIC="^DIC(4,",DIC(0)="ME" D ^DIC S X=$S($D(^DIC(4,+Y,99)):$E(^(99),1,3),1:"") K:Y'>0 X
 Q
 ;
9 S DW="101;6",DV="FX",DU="",DLB="TRANSFERRING SUFFIX",DIFLD=21.2
 G RE
X9 D UP^DGHELP S DIC(0)="ECF",DIC="^DIC(45.81,",D="D1" D IX^DIC S DIC=$S($D(DIE):DIE,1:DIC) I +Y'>0!(X=" ") K X
 I $D(X),X'?.ANP K X
 Q
 ;
10 S DW="101;8",DV="P8'",DU="",DLB="ADMITTING ELIGIBILITY",DIFLD=20.1
 S DU="DIC(8,"
 S X=$$ELIG^DGUTL3(DFN,1,$P($G(^DGPT(DA,101)),U,8))
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X10 Q
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 I DGPTFMT>1 S Y="@10"
 Q
12 S DW="101;4",DV="P45.82'X",DU="",DLB="CATEGORY OF BENEFICIARY",DIFLD=23
 S DE(DW)="C12^DGPTX1"
 S DU="DIC(45.82,"
 G RE
C12 G C12S:$D(DE(12))[0 K DB
 S X=DE(12),DIC=DIE
 S %=+^DGPT(DA,0) I $D(^DPT(%,.3)) S %C=$P(^(.3),U,10) I %C S ^(.3)=$P(^(.3),U,1,9)_U_U_$P(^(.3),U,11,99) K ^DPT("ACB",%C,%),%,%C
C12S S X="" G:DG(DQ)=X C12F1 K DB
 S X=DG(DQ),DIC=DIE
 S %=+^DGPT(DA,0) I %>0 S %C=$S($D(^DPT(%,.3)):^(.3),1:"")_"^^^^^^^^^^",^(.3)=$P(%C,U,1,9)_U_X_U_$P(%C,U,11,99),^DPT("ACB",X,%)="" K ^DPT("ACB",+$P(%C,U,10),%),%,%C
C12F1 Q
X12 D CAT1^DGINP
 Q
 ;
13 S DQ=14 ;@10
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S:+DGJUMP'=2 Y="@99"
 Q
15 S DQ=16 ;@2
16 S DQ=17 ;@3
17 S DQ=18 ;@4
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 S I(0,0)=D0 S Y(1)=$S($D(^DGPT(D0,0)):^(0),1:"") S X=$P(Y(1),U,1),X=X S D(0)=+X S X=$S(D(0)>0:D(0),1:"")
 S DGO="^DGPTX11",DC="^2^DPT(" G DIEZ^DIE0
R18 D DE G A
 ;
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 S:+DGJUMP'=5 Y="@99"
 Q
20 S DQ=21 ;@5
21 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=21 D X21 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X21 S DGJUMP=$P(DGJUMP,"5,",2)
 Q
22 D:$D(DG)>9 F^DIE17,DE S DQ=22,DW="70;6",DV="P45.6'",DU="",DLB="PLACE OF DISPOSITION",DIFLD=75
 S DU="DIC(45.6,"
 G RE
X22 Q
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 D X23 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X23 S:+DGJUMP'=6 Y="@99"
 Q
24 S DQ=25 ;@6
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 S DGJUMP=$P(DGJUMP,"6,",2)
 Q
26 S DW="70;4",DV="S",DU="",DLB="OUTPATIENT TREATMENT",DIFLD=73
 S DU="1:YES;3:NO;"
 G RE
X26 Q
27 S DW="70;5",DV="S",DU="",DLB="VA AUSPICES",DIFLD=74
 S DU="1:YES;2:NO;"
 G RE
X27 Q
28 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=28 D X28 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X28 S:DGJUMP'=7 Y="@99"
 Q
29 S DQ=30 ;@7
30 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=30 D X30 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X30 S DGJUMP=$P(DGJUMP,"7,",2)
 Q
31 S DW="70;12",DV="NJ3,0X",DU="",DLB="RECEIVING FACILITY",DIFLD=76.1
 G RE
X31 S DIC="^DIC(4,",DIC(0)="ME" D ^DIC S DIC=$S($D(DIE):DIE,1:DIC) S X=$S($D(^DIC(4,+Y,99)):$E(^(99),1,3),1:"") K:Y'>0 X
 Q
 ;
32 S DW="70;13",DV="FX",DU="",DLB="RECEIVING SUFFIX",DIFLD=76.2
 G RE
X32 D UP^DGHELP S DIC(0)="EFC",DIC="^DIC(45.81,",D="D1" D IX^DIC S DIC=DIE I +Y'>0!(X=" ") K X
 I $D(X),X'?.ANP K X
 Q
 ;
33 S DW="70;9",DV="S",DU="",DLB="C&P STATUS",DIFLD=78
 S DU="1:COMP/SC COND >10%;2:NON-COMP/SC COND<10%;3:COMP/SC (+10%) NO MED CARE;4:NON-COMP(-10%) SC NO MED CARE-VA PENSION;5:VA PENSION-NO SC COND;6:NON-COMP(-10%) SC NO MED CARE NO PENSION;7:NO PENSION-NO SC;8:NON-VET;"
 G RE
X33 Q
34 S DW="70;8",DV="NJ6,0",DU="",DLB="ASIH DAYS",DIFLD=77
 G RE
X34 K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
35 S DQ=36 ;@99
36 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=36 D X36 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X36 S:+DGJUMP Y="@"_+DGJUMP
 Q
37 G 0^DIE17
