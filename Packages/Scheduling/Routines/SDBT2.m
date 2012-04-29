SDBT2 ; ;09/19/10
 D DE G BEGIN
DE S DIE="^SC(",DIC=DIE,DP=44,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^SC(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,11) S:%]"" DE(18)=% S %=$P(%Z,U,18) S:%]"" DE(12)=% S %=$P(%Z,U,30) S:%]"" DE(2)=%
 I $D(^("SDP")) S %Z=^("SDP") S %=$P(%Z,U,1) S:%]"" DE(3)=% S %=$P(%Z,U,2) S:%]"" DE(4)=% S %=$P(%Z,U,3) S:%]"" DE(9)=% S %=$P(%Z,U,4) S:%]"" DE(10)=%
 I $D(^("SDPROT")) S %Z=^("SDPROT") S %=$P(%Z,U,1) S:%]"" DE(13)=%
 I $D(^("SL")) S %Z=^("SL") S %=$P(%Z,U,1) S:%]"" DE(22)=% S %=$P(%Z,U,2) S:%]"" DE(25)=% S %=$P(%Z,U,3) S:%]"" DE(6)=% S %=$P(%Z,U,5) S:%]"" DE(19)=% S %=$P(%Z,U,6) S:%]"" DE(27)=% S %=$P(%Z,U,7) S:%]"" DE(20)=% S %=$P(%Z,U,8) S:%]"" DE(11)=%
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
BEGIN S DNM="SDBT2",DQ=1
1 S D=0 K DE(1) ;2700
 S DIFLD=2700,DGO="^SDBT3",DC="2^44.11P^DX^",DV="44.11M*P80'",DW="0;1",DOW="DIAGNOSIS",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="ICD9("
 G RE:D I $D(DSC(44.11))#2,$P(DSC(44.11),"I $D(^UTILITY(",1)="" X DSC(44.11) S D=$O(^(0)) S:D="" D=-1 G M1
 S D=$S($D(^SC(DA,"DX",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M1 I D>0 S DC=DC_D I $D(^SC(DA,"DX",+D,0)) S DE(1)=$P(^(0),U,1)
 G RE
R1 D DE
 S D=$S($D(^SC(DA,"DX",0)):$P(^(0),U,3,4),1:1) G 1+1
 ;
2 S DW="0;30",DV="S",DU="",DLB="WORKLOAD VALIDATION AT CHK OUT",DIFLD=30
 S DU="1:YES;0:NO;"
 G RE
X2 Q
3 S DW="SDP;1",DV="RNJ3,0",DU="",DLB="ALLOWABLE CONSECUTIVE NO-SHOWS",DIFLD=2001
 G RE
X3 K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
4 S DW="SDP;2",DV="RNJ3,0",DU="",DLB="MAX # DAYS FOR FUTURE BOOKING",DIFLD=2002
 G RE
X4 K:+X'=X!(X>999)!(X<11)!(X?.E1"."1N.N) X
 Q
 ;
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 S:+$O(^SC(DA,"ST",0))>0 Y="@25"
 Q
6 S DW="SL;3",DV="NJ2,0",DU="",DLB="HOUR CLINIC DISPLAY BEGINS",DIFLD=1914
 G RE
X6 K:+X'=X!(X>16)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 G A
8 S DQ=9 ;@25
9 S DW="SDP;3",DV="NJ2,0X",DU="",DLB="START TIME FOR AUTO REBOOK",DIFLD=2003
 G RE
X9 K:+X'=X!(X>16)!(X<0)!(X?.E1"."1N.N) X I $D(X),$D(^SC(DA,"SL")) I X<$S('$P(^("SL"),"^",3):8,1:$P(^("SL"),"^",3)) W !,*7,"MUST NOT BE EARLIER THAN CLINIC START TIME" K X
 Q
 ;
10 S DW="SDP;4",DV="RNJ3,0",DU="",DLB="MAX # DAYS FOR AUTO-REBOOK",DIFLD=2005
 G RE
X10 K:+X'=X!(X>365)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
11 S DW="SL;8",DV="S",DU="",DLB="SCHEDULE ON HOLIDAYS?",DIFLD=1918.5
 S DU="Y:YES;"
 G RE
X11 Q
12 S DW="0;18",DV="*P40.7'X",DU="",DLB="CREDIT STOP CODE",DIFLD=2503
 S DE(DW)="C12^SDBT2",DE(DW,"INDEX")=1
 S DU="DIC(40.7,"
 G RE
C12 G C12S:$D(DE(12))[0 K DB
C12S S X="" G:DG(DQ)=X C12F1 K DB
C12F1 N X,X1,X2 S DIXR=472 D C12X1(U) K X2 M X2=X D C12X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^SC("ACST",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^SC("ACST",X,DA)=""
 G C12F2
C12X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",44,DIIENS,2503,DION),$P($G(^SC(DA,0)),U,18))
 S X=$G(X(1))
 Q
C12F2 Q
X12 S DIC("S")="I $P(^(0),U,2)'=900&$S('$P(^(0),U,3):1,$P(^(0),U,3)>DT:1,1:0),""SE""[$P(^(0),U,6),$S('$P(^(0),U,7):1,$P(^(0),U,7)'>DT:1,1:0)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW="SDPROT;1",DV="S",DU="",DLB="PROHIBIT ACCESS TO CLINIC?",DIFLD=2500
 S DU="Y:YES;"
 G RE
X13 Q
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S:X'="Y" Y="@30"
 Q
15 S D=0 K DE(1) ;2501
 S DIFLD=2501,DGO="^SDBT4",DC="1^44.04PA^SDPRIV^",DV="44.04MP200'X",DW="0;1",DOW="PRIVILEGED USER",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="VA(200,"
 G RE:D I $D(DSC(44.04))#2,$P(DSC(44.04),"I $D(^UTILITY(",1)="" X DSC(44.04) S D=$O(^(0)) S:D="" D=-1 G M15
 S D=$S($D(^SC(DA,"SDPRIV",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M15 I D>0 S DC=DC_D I $D(^SC(DA,"SDPRIV",+D,0)) S DE(15)=$P(^(0),U,1)
 G RE
R15 D DE
 S D=$S($D(^SC(DA,"SDPRIV",0)):$P(^(0),U,3,4),1:1) G 15+1
 ;
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 G A
17 S DQ=18 ;@30
18 S DW="0;11",DV="F",DU="",DLB="PHYSICAL LOCATION",DIFLD=10
 G RE
X18 K:$L(X)>25!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
19 S DW="SL;5",DV="*P44'",DU="",DLB="PRINCIPAL CLINIC",DIFLD=1916
 S DU="SC("
 G RE
X19 S DIC("S")="I $P(^(0),""^"",3)=""C"",'$G(^(""OOS""))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
20 S DW="SL;7",DV="RNJ4,0",DU="",DLB="OVERBOOKS/DAY MAXIMUM",DIFLD=1918
 G RE
X20 K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
21 S D=0 K DE(1) ;1910
 S DIFLD=1910,DGO="^SDBT5",DC="1^44.03A^SI^",DV="44.03F",DW="0;1",DOW="SPECIAL INSTRUCTIONS",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 I $D(DSC(44.03))#2,$P(DSC(44.03),"I $D(^UTILITY(",1)="" X DSC(44.03) S D=$O(^(0)) S:D="" D=-1 G M21
 S D=$S($D(^SC(DA,"SI",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M21 I D>0 S DC=DC_D I $D(^SC(DA,"SI",+D,0)) S DE(21)=$P(^(0),U,1)
 G RE
R21 D DE
 G A
 ;
22 S DW="SL;1",DV="RNJ2,0X",DU="",DLB="LENGTH OF APP'T",DIFLD=1912
 G RE
X22 K:+X'=X!(X>240)!(X<10)!(X?.E1"."1N.N)!($S('(X#10):0,'(X#15):0,1:1)) X I $D(X) S SDLA=X I $D(^SC(DA,"SL")),+$P(^("SL"),U,6) S SDZ0=$P(^("SL"),U,6),SDZ1=60\SDZ0 I X#SDZ1 D LAPPT^SDUTL
 Q
 ;
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 G A
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 I '$D(SDLA) S SDLA=X
 Q
25 S DW="SL;2",DV="S",DU="",DLB="VARIABLE APP'NTMENT LENGTH",DIFLD=1913
 S DU="V:YES, VARIABLE LENGTH;"
 G RE
X25 Q
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 S:+$O(^SC(DA,"ST",0))>0 Y="@99"
 Q
27 S DW="SL;6",DV="RSX",DU="",DLB="DISPLAY INCREMENTS PER HOUR",DIFLD=1917
 S DU="1:60-MIN ;2:30-MIN ;4:15-MIN ;3:20-MIN ;6:10-MIN ;"
 S Y="4"
 G Y
X27 S ZSI=$S(X=1!(X=2)!(X=3)!(X=4)!(X=6):60/X,1:0),SDLA=$S('$D(^SC(DA,"SL")):0,1:+^("SL")) K:('SDLA)!('ZSI) SDLA,ZSI,X Q:'$D(X)  I SDLA#ZSI>0 X ^DD(44,1917,9.2) Q
 Q
 ;
28 S DQ=29 ;@99
29 G 0^DIE17
