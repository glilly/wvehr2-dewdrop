NURAPA ; GENERATED FROM 'NURA-I-A1106B' INPUT TEMPLATE(#988), FILE 213.2;09/19/10
 D DE G BEGIN
DE S DIE="^NURSA(213.2,",DIC=DIE,DP=213.2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^NURSA(213.2,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(1)=% S %=$P(%Z,U,3) S:%]"" DE(2)=% S %=$P(%Z,U,4) S:%]"" DE(3)=% S %=$P(%Z,U,5) S:%]"" DE(4)=% S %=$P(%Z,U,6) S:%]"" DE(5)=% S %=$P(%Z,U,7) S:%]"" DE(6)=% S %=$P(%Z,U,8) S:%]"" DE(7)=%
 I  S %=$P(%Z,U,9) S:%]"" DE(8)=% S %=$P(%Z,U,10) S:%]"" DE(9)=% S %=$P(%Z,U,11) S:%]"" DE(10)=% S %=$P(%Z,U,12) S:%]"" DE(11)=% S %=$P(%Z,U,13) S:%]"" DE(12)=% S %=$P(%Z,U,14) S:%]"" DE(13)=% S %=$P(%Z,U,15) S:%]"" DE(14)=%
 I  S %=$P(%Z,U,16) S:%]"" DE(15)=% S %=$P(%Z,U,17) S:%]"" DE(16)=%
 I $D(^(.5)) S %Z=^(.5) S %=$P(%Z,U,1) S:%]"" DE(17)=% S %=$P(%Z,U,2) S:%]"" DE(18)=% S %=$P(%Z,U,3) S:%]"" DE(19)=% S %=$P(%Z,U,4) S:%]"" DE(20)=%
 I $D(^(1)) S %Z=^(1) S %=$P(%Z,U,11) S:%]"" DE(21)=%
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
BEGIN S DNM="NURAPA",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(988,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=988,U="^"
1 S DW="0;2",DV="RNJ9,3",DU="",DLB="(01) BUDGETED RN",DIFLD=1
 S X=NURSFT(1)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X1 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
2 S DW="0;3",DV="RNJ9,3",DU="",DLB="(02) BUDGETED LPN",DIFLD=2
 S X=NURSFT(2)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X2 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
3 S DW="0;4",DV="RNJ9,3",DU="",DLB="(03) BUDGETED NA",DIFLD=3
 S X=NURSFT(3)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X3 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
4 S DW="0;5",DV="RNJ9,3",DU="",DLB="(04) BUDGETED CLERICAL",DIFLD=4
 S X=NURSFT(4)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X4 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
5 S DW="0;6",DV="RNJ9,3",DU="",DLB="(05) BUDGETED ADMIN OFFICER",DIFLD=5
 S X=NURSFT(5)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X5 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
6 S DW="0;7",DV="RNJ9,3",DU="",DLB="(06) BUDGETED CLIN SPECIALIST",DIFLD=6
 S X=NURSFT(6)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X6 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
7 S DW="0;8",DV="RNJ9,3",DU="",DLB="(07) BUDGETED RN PRACTITIONER",DIFLD=7
 S X=NURSFT(7)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X7 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
8 S DW="0;9",DV="RNJ9,3",DU="",DLB="(08) BUDGETED INFECT. CONTROL",DIFLD=8
 S X=NURSFT(8)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X8 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
9 S DW="0;10",DV="RNJ9,3",DU="",DLB="(09) BUDGETED PUBLIC HEALTH",DIFLD=9
 S X=NURSFT(9)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X9 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
10 S DW="0;11",DV="RNJ9,3",DU="",DLB="(10) BUDGETED STAFF NURSE",DIFLD=10
 S X=NURSFT(10)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X10 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
11 S DW="0;12",DV="RNJ9,3",DU="",DLB="(11) BUDGETED CHIEF NURSE",DIFLD=11
 S X=NURSFT(11)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X11 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
12 S DW="0;13",DV="RNJ9,3",DU="",DLB="(12) BUDGETED ASST CHIEF NURSE",DIFLD=12
 S X=NURSFT(12)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X12 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
13 S DW="0;14",DV="RNJ9,3",DU="",DLB="(13) BUDGETED ASSOC CHIEF N.S.",DIFLD=13
 S X=NURSFT(13)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X13 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
14 S DW="0;15",DV="RNJ9,3",DU="",DLB="(14) BUDGETED SUPERVISOR",DIFLD=14
 S X=NURSFT(14)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X14 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
15 S DW="0;16",DV="RNJ9,3",DU="",DLB="(15) BUDGETED HEAD NURSE",DIFLD=15
 S X=NURSFT(15)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X15 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
16 S DW="0;17",DV="RNJ9,3",DU="",DLB="(16) BUDGETED OTHER NURSE",DIFLD=16
 S X=NURSFT(16)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X16 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
17 S DW=".5;1",DV="RNJ9,3",DU="",DLB="(17) BUDGETED NURSE RESHR",DIFLD=17
 S X=NURSFT(17)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X17 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
18 S DW=".5;2",DV="RNJ9,3",DU="",DLB="(18) BUDGETED ASSOC CHIEF/RESH",DIFLD=18
 S X=NURSFT(18)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X18 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
19 S DW=".5;3",DV="RNJ9,3",DU="",DLB="(19) BUDGETED ASSOC CHIEF/EDU",DIFLD=19
 S X=NURSFT(19)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X19 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
20 S DW=".5;4",DV="RNJ9,3",DU="",DLB="(20) BUDGETED INSTR/EDU",DIFLD=20
 S X=NURSFT(20)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X20 K:+X'=X!(X>99999.999)!(X<0)!(X?.E1"."4N.N) X
 Q
 ;
21 S DW="1;11",DV="RD",DU="",DLB="DATE",DIFLD=43
 S X=NURSCRDT
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X21 S %DT="" D ^%DT S X=Y K:Y<1 X
 Q
 ;
22 G 0^DIE17
