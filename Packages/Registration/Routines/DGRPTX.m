DGRPTX ; GENERATED FROM 'DGRPT 10-10T REGISTRATION' INPUT TEMPLATE(#1476), FILE 2;09/20/12
 D DE G BEGIN
DE S DIE="^DPT(",DIC=DIE,DP=2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DPT(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(3)=%
 I $D(^(.11)) S %Z=^(.11) S %=$P(%Z,U,1) S:%]"" DE(7)=% S %=$P(%Z,U,2) S:%]"" DE(9)=% S %=$P(%Z,U,3) S:%]"" DE(11)=% S %=$P(%Z,U,4) S:%]"" DE(15)=% S %=$P(%Z,U,12) S:%]"" DE(14)=%
 I $D(^("TYPE")) S %Z=^("TYPE") S %=$P(%Z,U,1) S:%]"" DE(4)=%
 I $D(^("VET")) S %Z=^("VET") S %=$P(%Z,U,1) S:%]"" DE(5)=%
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
BEGIN S DNM="DGRPTX",DQ=1
 S DR(99,1,9.2)="S (D,D0)=$QS(DIMQ,$QL(DIMQ)) I D,$D(^DGNT(28.11,D,0)) S X=$P(^(0),U) S:$D(^DPT(+X,0)) X=$P(^(0),U) S DWLC=DWLC+1,^DPT(DA,DV,DWLC,0)=X"
 S DR(99,1,9.3)="N DIMQ,DIMSTRT,DIMSCNT S (DIMQ,DIMSTRT)=$NA(^DGNT(28.11,""B"",I(0,0))),DIMSCNT=$QL(DIMQ) F  S DIMQ=$Q(@DIMQ) Q:DIMQ=""""  Q:$NA(@DIMQ,DIMSCNT)'=DIMSTRT   X DR(99,1,9.2) Q:'$D(D)  S D=D0"
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(1476,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=1476,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 K DGFIN
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 I $G(DGNEWPF) S Y="@10"
 Q
3 S DW="0;2",DV="RSa",DU="",DLB="SEX",DIFLD=.02
 S DE(DW)="C3^DGRPTX",DE(DW,"INDEX")=1
 S DU="M:MALE;F:FEMALE;"
 G RE
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 K ^DPT("ASX",$E(X,1,30),DA)
 S X=DE(3),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(3),DIC=DIE
 S IVMX=X,IVMKILL=2,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX,IVMKILL
 S X=DE(3),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".02;" D AVAFC^VAFCDD01(DA)
 S X=DE(3),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(3),DIIX=2_U_DIFLD D AUDIT^DIET
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^DPT("ASX",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".02;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(3))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C3F1 N X,X1,X2 S DIXR=739 D C3X1(U) K X2 M X2=X D C3X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.02,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.02,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C3F2
C3X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.02,DION),$P($G(^DPT(DA,0)),U,2))
 S X=$G(X(1))
 Q
C3F2 Q
X3 Q
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW="TYPE;1",DV="P391'a",DU="",DLB="TYPE",DIFLD=391
 S DE(DW)="C4^DGRPTX",DE(DW,"INDEX")=1
 S DU="DG(391,"
 G RE
C4 G C4S:$D(DE(4))[0 K DB
 S X=DE(4),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF="391;" D AVAFC^VAFCDD01(DA)
 S X=DE(4),DIIX=2_U_DIFLD D AUDIT^DIET
C4S S X="" G:DG(DQ)=X C4F1 K DB
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF="391;" D AVAFC^VAFCDD01(DA)
 I $D(DE(4))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C4F1 N X,X1,X2 S DIXR=664 D C4X1(U) K X2 M X2=X D C4X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DPT("APTYPE",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DPT("APTYPE",X,DA)=""
 G C4F2
C4X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,391,DION),$P($G(^DPT(DA,"TYPE")),U,1))
 S X=$G(X(1))
 Q
C4F2 Q
X4 Q
5 D:$D(DG)>9 F^DIE17,DE S DQ=5,DW="VET;1",DV="SXa",DU="",DLB="VETERAN (Y/N)?",DIFLD=1901
 S DE(DW)="C5^DGRPTX"
 S DU="Y:YES;N:NO;"
 G RE
C5 G C5S:$D(DE(5))[0 K DB
 S X=DE(5),DIC=DIE
 S DFN=DA D EN^DGMTCOR K DGMTCOR
 S X=DE(5),DIC=DIE
 S DFN=DA D EN^DGRP7CC
 S X=DE(5),DIC=DIE
 ;
 S X=DE(5),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DE(5),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF="1901;" D AVAFC^VAFCDD01(DA)
 S X=DE(5),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(5),DIIX=2_U_DIFLD D AUDIT^DIET
C5S S X="" G:DG(DQ)=X C5F1 K DB
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
 I $D(DE(5))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C5F1 Q
X5 I $D(X) S:'$D(DPTX) DFN=DA D:'$D(^XUSEC("DG ELIGIBILITY",DUZ)) VAGE^DGLOCK:X="Y" I $D(X) D:$D(DFN) EV^DGLOCK
 Q
 ;
6 S DQ=7 ;@10
7 D:$D(DG)>9 F^DIE17,DE S DQ=7,DW=".11;1",DV="Fa",DU="",DLB="STREET ADDRESS [LINE 1]",DIFLD=.111
 S DE(DW)="C7^DGRPTX",DE(DW,"INDEX")=1
 G RE
C7 G C7S:$D(DE(7))[0 K DB
 S X=DE(7),DIC=DIE
 X "S DGXRF=.111 D ^DGDDC Q"
 S X=DE(7),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DE(7),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(7),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
 S X=DE(7),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(7),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".111;" D AVAFC^VAFCDD01(DA)
 S X=DE(7),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(7),DIIX=2_U_DIFLD D AUDIT^DIET
C7S S X="" G:DG(DQ)=X C7F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
 S X=DG(DQ),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".111;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(7))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C7F1 N X,X1,X2 S DIXR=230 D C7X1(U) K X2 M X2=X D C7X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.111,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.111,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C7F2
C7X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.111,DION),$P($G(^DPT(DA,.11)),U,1))
 S X=$G(X(1))
 Q
C7F2 Q
X7 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>35!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 S:X="" Y="@1112"
 Q
9 D:$D(DG)>9 F^DIE17,DE S DQ=9,DW=".11;2",DV="Fa",DU="",DLB="STREET ADDRESS [LINE 2]",DIFLD=.112
 S DE(DW)="C9^DGRPTX",DE(DW,"INDEX")=1
 G RE
C9 G C9S:$D(DE(9))[0 K DB
 S X=DE(9),DIC=DIE
 X "S DGXRF=.112 D ^DGDDC Q"
 S X=DE(9),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DE(9),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(9),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
 S X=DE(9),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(9),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".112;" D AVAFC^VAFCDD01(DA)
 S X=DE(9),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(9),DIIX=2_U_DIFLD D AUDIT^DIET
C9S S X="" G:DG(DQ)=X C9F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
 S X=DG(DQ),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".112;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(9))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C9F1 N X,X1,X2 S DIXR=232 D C9X1(U) K X2 M X2=X D C9X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.112,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.112,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C9F2
C9X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.112,DION),$P($G(^DPT(DA,.11)),U,2))
 S X=$G(X(1))
 Q
C9F2 Q
X9 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X D:$D(X) UP^DGHELP
 I $D(X),X'?.ANP K X
 Q
 ;
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S:X="" Y="@1112"
 Q
11 D:$D(DG)>9 F^DIE17,DE S DQ=11,DW=".11;3",DV="Fa",DU="",DLB="STREET ADDRESS [LINE 3]",DIFLD=.113
 S DE(DW)="C11^DGRPTX",DE(DW,"INDEX")=1
 G RE
C11 G C11S:$D(DE(11))[0 K DB
 S X=DE(11),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DE(11),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(11),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
 S X=DE(11),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(11),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".113;" D AVAFC^VAFCDD01(DA)
 S X=DE(11),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(11),DIIX=2_U_DIFLD D AUDIT^DIET
C11S S X="" G:DG(DQ)=X C11F1 K DB
 S X=DG(DQ),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
 S X=DG(DQ),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".113;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(11))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C11F1 N X,X1,X2 S DIXR=233 D C11X1(U) K X2 M X2=X D C11X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.113,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.113,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C11F2
C11X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.113,DION),$P($G(^DPT(DA,.11)),U,3))
 S X=$G(X(1))
 Q
C11F2 Q
X11 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
12 S DQ=13 ;@1112
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 S EASZIPLK=1
 Q
14 D:$D(DG)>9 F^DIE17,DE S DQ=14,DW=".11;12",DV="FXOa",DU="",DLB="ZIP+4",DIFLD=.1112
 S DQ(14,2)="S Y(0)=Y D ZIPOUT^VAFADDR"
 S DE(DW)="C14^DGRPTX",DE(DW,"INDEX")=1
 G RE
C14 G C14S:$D(DE(14))[0 K DB
 S X=DE(14),DIC=DIE
 D KILL^DGREGDD1(DA,.116,.11,6,$E(X,1,5))
 S X=DE(14),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(14),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
 S X=DE(14),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(14),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".1112;" D AVAFC^VAFCDD01(DA)
 S X=DE(14),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(14),DIIX=2_U_DIFLD D AUDIT^DIET
C14S S X="" G:DG(DQ)=X C14F1 K DB
 D ^DGRPTX1
C14F1 N X,X1,X2 S DIXR=185 D C14X1(U) K X2 M X2=X D C14X1("O") K X1 M X1=X
 D
 . N DIEXARR M DIEXARR=X S DIEZCOND=1
 . I X1(1)'=X2(1)
 . S DIEZCOND=$G(X) K X M X=DIEXARR Q:'DIEZCOND
 . K EASDO2
 G C14F2
C14X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.1112,DION),$P($G(^DPT(DA,.11)),U,12))
 S:('$G(EASDO2)&($D(EASZIPLK))) X=$$ZIP^DGREGDD1(DA,X(1))
 S:$D(X)#2 X(2)=X
 S X=$G(X(1))
 Q
C14F2 S DIXR=231 D C14X2(U) K X2 M X2=X D C14X2("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.1112,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.1112,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C14F3
C14X2(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.1112,DION),$P($G(^DPT(DA,.11)),U,12))
 S X=$G(X(1))
 Q
C14F3 Q
X14 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>20!($L(X)<5) X I $D(X) D ZIPIN^VAFADDR
 I $D(X),X'?.ANP K X
 Q
 ;
15 D:$D(DG)>9 F^DIE17,DE S DQ=15,DW=".11;4",DV="Fa",DU="",DLB="CITY",DIFLD=.114
 S DE(DW)="C15^DGRPTX",DE(DW,"INDEX")=1
 G RE
C15 G C15S:$D(DE(15))[0 K DB
 D ^DGRPTX2
C15S S X="" G:DG(DQ)=X C15F1 K DB
 D ^DGRPTX3
C15F1 N X,X1,X2 S DIXR=234 D C15X1(U) K X2 M X2=X D C15X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.114,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.114,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C15F2
C15X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.114,DION),$P($G(^DPT(DA,.11)),U,4))
 S X=$G(X(1))
 Q
C15F2 Q
X15 K:$L(X)>15!($L(X)<2) X
 I $D(X),X'?.ANP K X
 Q
 ;
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 S:'$$KEY^DGREGDD1(DUZ,DA) Y=.131
 Q
17 D:$D(DG)>9 F^DIE17 G ^DGRPTX4
