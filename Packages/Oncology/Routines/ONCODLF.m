ONCODLF ;Hines OIFO/GWB - DISPLAY FOLLOW-UP DATA, ALL/LATEST ;03/08/00
 ;;2.11;ONCOLOGY;**16,25,44,45**;Mar 07, 1995
 ;
LFS ;LAST FOLLOW-UP STATUS (from D0 #165.59 - computed primary
 S XD0=$P(^ONCO(165.5,D0,0),U,2) G LF
 ;
LST ;Display last FOLLOW-UP (160,400) data
 S (XD0,OD0)=D0
LF S XD1=$O(^ONCO(160,XD0,"F","AA",0)) G:XD1'>0 EX S XD1=$O(^(XD1,0)),XXD0=$S($D(^ONCO(160,XD0,"F",XD1)):^(XD1,0),1:""),NL=$S($D(^ONCO(160,XD0,"F",XD1,1,0)):$P(^(0),U,4),1:"") D:XD1 WD G EX
 ;
FHC ;HISTORY-FOLLOWUP (COMPLETE) #46;D0=#160
 S (OD0,XD0)=D0,LST=9999999,HIS=1
F N XXD1,OJ S (XXD1,OJ)=0
 F  S XXD1=$O(^ONCO(160,XD0,"F","AA",XXD1)) S OJ=OJ+1 G END:XXD1'>0,END:XXD1>LST S XD1=$O(^(XXD1,0)),XXD0=$G(^ONCO(160,XD0,"F",XD1,0)),FDAT=$P(XXD0,U) K NL D C:XXD0'="",HD S D0=XD0,D1=XD1 D MTS^ONCOCOFA,WD
END ;End follow-up
 G EX:'$D(XD1) D HD:OJ>1,C S VS=$S($D(^ONCO(160,XD0,1)):$P(^(1),U),1:"") G DEAD:VS=0,EX
 ;
DEAD ;DEATH INFORMATION
 S D0=XD0 K DXS,DIOT D ^ONCOXDI G EX
 ;
FHP ;FOLLOW-UP HISTORY #150 (for particular primary):D0=#165.5
 N FDAT,OJ
 S (XD0,OD0)=D0
P S XD0=$G(^ONCO(165.5,XD0,0)) G EX:XD0="" D DAT S LST=9999999-XLC,XD0=$P(XD0,U,2)
 S (XXD1,OJ)=0
 ;F  S XXD1=$O(^ONCO(160,XD0,"F","AA",XXD1)) S OJ=OJ+1 G FIN:XXD1'>0,FIN:XXD1>LST S XD1=$O(^(XXD1,0)),XXD0=$G(^ONCO(160,XD0,"F",XD1,0)),FDAT=$P(XXD0,U) K NL D C:XXD0'="",HD I XXD0'="" S D0=XD0,D1=XD1 D MTS^ONCOCOFA,WD
 F  S XXD1=$O(^ONCO(160,XD0,"F","AA",XXD1)) S OJ=OJ+1 G FIN:XXD1'>0,FIN:XXD1>LST S XD1=$O(^(XXD1,0)),XXD0=$G(^ONCO(160,XD0,"F",XD1,0)),FDAT=$P(XXD0,U) K NL D HD I XXD0'="" S D0=XD0,D1=XD1 D MTS^ONCOCOFA,WD
FIN G EX
 ;D:OJ>1 HD G EX
 ;
DAT ;Get Reference date
 S XLC=$P(XD0,U,16) Q:XLC'=""  S XLC=$P(XD0,U,9) Q:XLC'=""  S XLC=$P(XD0,U,8) Q
 ;
 S YR=$P(XD0,U,7) I XDD'="" Q:($E(XDD,1,3)+1700)'<YR
 S XDD=2_$E(YR,3,4)_"0000"
 Q
HD ;header for Follow-up History
 W "--------------------------------------------------------------------------------"
 Q
 ;
WD F I=1:1:5 S X(I-1)=$P(XXD0,U,I)
 S X(6)=$P(XXD0,U,6)
 S X(11)=$P(XXD0,U,10)
 S X(12)=$P(XXD0,U,11)
 S X=X(0) D DATEOT^ONCOES S X(0)=X
1 S X=X(1),X(1)=$S(X=0:"Dead",X=1:"Alive",1:"")
3 S X=X(3),X(3)=$S(X=0:"Reported Hospitalization",X=1:"Readmission",X=2:"Physician",X=3:"Patient",X=4:"Department of Motor Vehicles",X=5:"Medicare/Medicaid file",X=7:"Death certificate",X=8:"Other",1:"Unknown")
4 S X=X(4),X(4)=$S(X=0:"Normal",X=1:"Symptomatic & Ambulatory",X=2:"More than 50% Ambulatory",X=3:"Less than 50% Ambulatory",X=4:"Bedridden",X=8:"Not applicable, dead",1:"Unknown or unspecified")
6 S X=X(6),X(6)=$S(X=0:"Chart requisition",X=1:"Physician letter",X=2:"Contact letter",X=3:"Phone call",X=4:"Other hospital contact",X=5:"Other, NOS",X=8:"Foreign residents (not followed)",1:"Not followed")
11 S X=X(11),X(11)=$P($G(^VA(200,+X,0)),U,1)
12 S X=X(12) D DATEOT^ONCOES S X(12)=X
 ;W !?1,"Last Contact: ",?15,X(0),?30,"F-U Method: ",?47,X(3)
 ;W !?1,"Vital Status: ",?15,X(1),?30,"Quality of Surv: ",?47,X(4)
 ;W !?1,"Date entered: ",?15,X(12),?30,"Next F-U Method: ",?47,X(6)
 ;W !?1,"Registrar: ",?15,X(11)
 W !?2,"Date of Last Contact or Death.:",?34,X(0)
 I $G(FUQA)="QA" W ! Q
 W !?2,"Vital Status..................:",?34,X(1)
 W !?2,"Follow-up Source..............:",?34,X(3)
 W !?2,"Next Follow-up Source.........:",?34,X(6)
 W !?2,"Quality of Survival...........:",?34,X(4)
 W !?2,"Registrar.....................:",?34,X(11)
 W !?2,"Date entered..................:",?34,X(12)
 ;Q:NL=""  W !!," Comments:"
 W !?2,"Comments:"
PC S X=0 F I=0:0 S X=$O(^ONCO(160,XD0,"F",XD1,1,X)) Q:X'>0  W !?2,^(X,0)
 W !
 ;
C Q:$D(NL)  S NL=$S($D(^ONCO(160,XD0,"F",+XD1,1,0)):($P(^(0),U,4)+1),1:""),TL=6+NL Q:TL<(IOSL-($Y))  D HD W # I $D(^UTILITY($J,1)) X ^(1) Q
 W ?10,"*************** FOLLOWUP HISTORY ***************",!!
 Q
DT I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 Q
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E X ^(1)
 Q
EX ;Kill and Exit
 S D0=OD0 ;RESET wherever came from
 K OD0,HIS,NL,XD1,XD0,I,X1,X2,XXD0,XX,VS S X=""
 Q
