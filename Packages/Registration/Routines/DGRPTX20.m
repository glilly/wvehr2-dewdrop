DGRPTX20 ; ;08/31/12
 D DE G BEGIN
DE S DIE="^DPT(",DIC=DIE,DP=2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DPT(DA,""))=""
 I $D(^(.3)) S %Z=^(.3) S %=$P(%Z,U,1) S:%]"" DE(19)=% S %=$P(%Z,U,2) S:%]"" DE(21)=%
 I $D(^(.321)) S %Z=^(.321) S %=$P(%Z,U,2) S:%]"" DE(15)=% S %=$P(%Z,U,3) S:%]"" DE(16)=%
 I $D(^(.322)) S %Z=^(.322) S %=$P(%Z,U,13) S:%]"" DE(17)=%
 I $D(^(.36)) S %Z=^(.36) S %=$P(%Z,U,2) S:%]"" DE(18)=%
 I $D(^(.52)) S %Z=^(.52) S %=$P(%Z,U,5) S:%]"" DE(1)=%
 I $D(^(.53)) S %Z=^(.53) S %=$P(%Z,U,1) S:%]"" DE(3)=% S %=$P(%Z,U,2) S:%]"" DE(8)=% S %=$P(%Z,U,3) S:%]"" DE(12)=% S %=$P(%Z,U,4) S:%]"" DE(9)=%,DE(13)=%
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
BEGIN S DNM="DGRPTX20",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW=".52;5",DV="RSX",DU="",DLB="POW STATUS INDICATED?",DIFLD=.525
 S DE(DW)="C1^DGRPTX20",DE(DW,"INDEX")=1
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 ;
 S X=DE(1),DIC=DIE
 ;
 S X=DE(1),DIC=DIE
 ;
 S X=DE(1),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DE(1),DIC=DIE
 X "S DFN=DA D EN^DGMTR K DGREQF"
 S X=DE(1),DIC=DIE
 D EVENT^IVMPLOG(DA)
C1S S X="" G:DG(DQ)=X C1F1 K DB
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.525,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.52)):^(.52),1:"") S X=$S('$D(^DIC(22,+$P(Y(1),U,6),0)):"",1:$P(^(0),U,1)) S DIU=X K Y S X=DIV S X="" X ^DD(2,.525,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.525,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.52)):^(.52),1:"") S X=$P(Y(1),U,7) S DIU=X K Y S X=DIV S X="" X ^DD(2,.525,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.525,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.52)):^(.52),1:"") S X=$P(Y(1),U,8) S DIU=X K Y S X=DIV S X="" X ^DD(2,.525,1,3,1.4)
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DG(DQ),DIC=DIE
 X "S DFN=DA D EN^DGMTR K DGREQF"
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C1F1 N X,X1,X2 S DIXR=646 D C1X1(U) K X2 M X2=X D C1X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.525,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.525,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C1F2
C1X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.525,DION),$P($G(^DPT(DA,.52)),U,5))
 S X=$G(X(1))
 Q
C1F2 Q
X1 S DFN=DA D POWV^DGLOCK I $D(X) D SV^DGLOCK
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 I $P($G(^DPT(DFN,.53)),U)]"" S Y="@53"
 Q
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW=".53;1",DV="SX",DU="",DLB="CURRENT PH INDICATOR",DIFLD=.531
 S DE(DW)="C3^DGRPTX20"
 S DU="Y:YES;N:NO;"
 G RE
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 K ^DPT("D",$E(X,1,30),DA)
 S X=DE(3),DIC=DIE
 D AUTOUPD^DGENA2(DA)
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^DPT("D",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
C3F1 Q
X3 S DFN=DA D VET^DGLOCK
 Q
 ;
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 I X="Y" S Y="@532",DGPHMULT=1
 Q
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 I X="N" S Y="@533",DGPHMULT=1
 Q
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S:X="" Y="@53"
 Q
7 S DQ=8 ;@532
8 D:$D(DG)>9 F^DIE17,DE S DQ=8,DW=".53;2",DV="S",DU="",DLB="CURRENT PURPLE HEART STATUS",DIFLD=.532
 S DE(DW)="C8^DGRPTX20"
 S DU="1:PENDING;2:IN PROCESS;3:CONFIRMED;"
 S X="PENDING"
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C8 G C8S:$D(DE(8))[0 K DB
 S X=DE(8),DIC=DIE
 K ^DPT("C",$E(X,1,30),DA)
 S X=DE(8),DIC=DIE
 D EVENT^IVMPLOG(DA)
C8S S X="" G:DG(DQ)=X C8F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^DPT("C",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C8F1 Q
X8 Q
9 D:$D(DG)>9 F^DIE17,DE S DQ=9,DW=".53;4",DV="P4'",DU="",DLB="PH DIVISION",DIFLD=.535
 S DU="DIC(4,"
 S X=$$DIV^DGRPLE()
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X9 Q
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S Y="@53"
 Q
11 S DQ=12 ;@533
12 S DW=".53;3",DV="S",DU="",DLB="CURRENT PURPLE HEART REMARKS",DIFLD=.533
 S DE(DW)="C12^DGRPTX20"
 S DU="1:UNACCEPTABLE DOCUMENTATION;2:NO DOCUMENTATION REC'D;3:ENTERED IN ERROR;4:UNSUPPORTED PURPLE HEART;5:VAMC;6:UNDELIVERABLE MAIL;"
 S X="VAMC"
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C12 G C12S:$D(DE(12))[0 K DB
 S X=DE(12),DIC=DIE
 D EVENT^IVMPLOG(DA)
C12S S X="" G:DG(DQ)=X C12F1 K DB
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C12F1 Q
X12 Q
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW=".53;4",DV="P4'",DU="",DLB="PH DIVISION",DIFLD=.535
 S DU="DIC(4,"
 S X=$$DIV^DGRPLE()
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X13 Q
14 S DQ=15 ;@53
15 S DW=".321;2",DV="RSX",DU="",DLB="AGENT ORANGE EXPOS. INDICATED?",DIFLD=.32102
 S DE(DW)="C15^DGRPTX20"
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C15 G C15S:$D(DE(15))[0 K DB
 S X=DE(15),DIC=DIE
 ;
 S X=DE(15),DIC=DIE
 ;
 S X=DE(15),DIC=DIE
 ;
 S X=DE(15),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DE(15),DIC=DIE
 ;
C15S S X="" G:DG(DQ)=X C15F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$C(59)_$P($G(^DD(2,.32102,0)),U,3) S X=$P($P(Y(1),$C(59)_Y(0)_":",2),$C(59))="NO" I X S X=DIV S Y(1)=$S($D(^DPT(D0,.321)):^(.321),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X="" X ^DD(2,.32102,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.32102,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.321)):^(.321),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X="" S DIH=$G(^DPT(DIV(0),.321)),DIV=X S $P(^(.321),U,10)=DIV,DIH=2,DIG=.3211 D ^DICR
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$C(59)_$P($G(^DD(2,.32102,0)),U,3) S X=$P($P(Y(1),$C(59)_Y(0)_":",2),$C(59))="NO" I X S X=DIV S Y(1)=$S($D(^DPT(D0,.321)):^(.321),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X="" X ^DD(2,.32102,1,3,1.4)
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.32102,1,5,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.321)):^(.321),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X="" S DIH=$G(^DPT(DIV(0),.321)),DIV=X S $P(^(.321),U,13)=DIV,DIH=2,DIG=.3213 D ^DICR
C15F1 Q
X15 S DFN=DA D SV^DGLOCK
 Q
 ;
16 D:$D(DG)>9 F^DIE17,DE S DQ=16,DW=".321;3",DV="RSX",DU="",DLB="RADIATION EXPOSURE INDICATED?",DIFLD=.32103
 S DE(DW)="C16^DGRPTX20"
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C16 G C16S:$D(DE(16))[0 K DB
 S X=DE(16),DIC=DIE
 ;
 S X=DE(16),DIC=DIE
 ;
 S X=DE(16),DIC=DIE
 D AUTOUPD^DGENA2(DA)
C16S S X="" G:DG(DQ)=X C16F1 K DB
 D ^DGRPTX21
C16F1 Q
X16 S DFN=DA D SV^DGLOCK
 Q
 ;
17 D:$D(DG)>9 F^DIE17,DE S DQ=17,DW=".322;13",DV="RSX",DU="",DLB="SOUTHWEST ASIA CONDITIONS?",DIFLD=.322013
 S DE(DW)="C17^DGRPTX20"
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C17 G C17S:$D(DE(17))[0 K DB
 D ^DGRPTX22
C17S S X="" G:DG(DQ)=X C17F1 K DB
 D ^DGRPTX23
C17F1 Q
X17 S DFN=DA D SV^DGLOCK
 Q
 ;
18 D:$D(DG)>9 F^DIE17,DE S DQ=18,DW=".36;2",DV="RSX",DU="",DLB="DISABILITY RET. FROM MILITARY?",DIFLD=.362
 S DE(DW)="C18^DGRPTX20"
 S DU="0:NO;1:YES, RECEIVING MILITARY RETIREMENT;2:YES, RECEIVING MILITARY RETIREMENT IN LIEU OF VA COMPENSATION;3:UNKNOWN;"
 G RE
C18 G C18S:$D(DE(18))[0 K DB
 S X=DE(18),DIC=DIE
 ;
 S X=DE(18),DIC=DIE
 D AUTOUPD^DGENA2(DA)
C18S S X="" G:DG(DQ)=X C18F1 K DB
 S X=DG(DQ),DIC=DIE
 X "S DFN=DA D EN^DGMTR K DGREQF"
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
C18F1 Q
X18 S DFN=DA D SV^DGLOCK
 Q
 ;
19 D:$D(DG)>9 F^DIE17,DE S DQ=19,DW=".3;1",DV="SXa",DU="",DLB="SERVICE CONNECTED?",DIFLD=.301
 S DE(DW)="C19^DGRPTX20"
 S DU="Y:YES;N:NO;"
 G RE
C19 G C19S:$D(DE(19))[0 K DB
 D ^DGRPTX24
C19S S X="" G:DG(DQ)=X C19F1 K DB
 D ^DGRPTX25
C19F1 Q
X19 S DFN=DA D EV^DGLOCK I $D(X),X="Y" D VET^DGLOCK
 Q
 ;
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 S:X'="Y" Y="@50"
 Q
21 D:$D(DG)>9 F^DIE17,DE S DQ=21,DW=".3;2",DV="NJ3,0Xa",DU="",DLB="SERVICE CONNECTED PERCENTAGE",DIFLD=.302
 S DE(DW)="C21^DGRPTX20"
 G RE
C21 G C21S:$D(DE(21))[0 K DB
 D ^DGRPTX26
C21S S X="" G:DG(DQ)=X C21F1 K DB
 D ^DGRPTX27
C21F1 Q
X21 S DFN=DA D EV^DGLOCK Q:'$D(X)  K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X I $D(X),$D(^DPT(DA,.3)),$P(^(.3),U,1)'="Y" W !?4,*7,"Only applies to service-connected applicants." K X
 Q
 ;
22 S DQ=23 ;@50
23 D:$D(DG)>9 F^DIE17 G ^DGRPTX28
