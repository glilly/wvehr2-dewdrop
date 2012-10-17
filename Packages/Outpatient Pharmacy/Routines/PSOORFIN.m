PSOORFIN        ;BIR/SAB-finish cprs orders ;10:52 AM  2 Aug 2011
        ;;7.0;OUTPATIENT PHARMACY;**7,15,27,32,44,46,84,106,111,117,131,146,139,195,225,315,266,208**;DEC 1997;Build 59;WorldVistA 30-June-08
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        ;PSSLOCK-2789,PSDRUG-221,50.7-2223,55-2228,50.606-2174
        ;PSO*7*266 Change order of calling ^PSOBING1 and ^PSORXL
        ;
        ;Begin WorldVistA change; PSO*7*208
        ;D:'$D(PSOPAR) ^PSOLSET I '$D(PSOPAR) D MSG^PSODPT G EX
        I $G(PSOAFYN)'="Y" D:'$D(PSOPAR) ^PSOLSET I '$D(PSOPAR) D MSG^PSODPT G EX
        I $G(PSOAFYN)="Y" D:'$D(PSOPAR) ^PSOAFSET I '$D(PSOPAR) D MSG^PSODPT G EX  ;vfah
        ;End WorldVistA change
        D INST^PSOORFI2 I $G(PSOIQUIT) K PSOIQUIT G EX
        I $P($G(PSOPAR),"^",2),'$D(^XUSEC("PSORPH",DUZ)) S PSORX("VERIFY")=1
        ;Begin WorldVistA change; PSO*7*208
        ;S (PSOFIN,POERR)=1
        I $G(PSOAFYN)'="Y" S (PSOFIN,POERR)=1
        ;End WorldVistA change
        K PSOBCK,MEDA,MEDP,SRT,DIR D KQ
        S DIR("?")="^D ST^PSOORFI1",DIR("A")="Select By",DIR("B")="PATIENT",DIR(0)="SMB^PA:PATIENT;RT:ROUTE;PR:PRIORITY;CL:CLINIC;FL:FLAG;E:EXIT"
        ;Begin WorldVistA change; PSO*7*208
        ;D ^DIR I $D(DIRUT)!(Y="E") G EX
        I $G(PSOAFYN)'="Y" D ^DIR I $D(DIRUT)!(Y="E") G EX
        I $G(PSOAFYN)="Y" S Y="PA" ;vfah
        ;End WorldVistA change
        G:Y="PA" PAT G:Y="PR" PRI^PSOORFI5 G:Y="CL" ^PSOORFI3 G:Y="FL" FLG^PSOORFI5
        K DIR S PSOSORT="ROUTE"
        S DIR("?")="^D RT^PSOORFI1",DIR("A")="Route",DIR(0)="SBM^W:WINDOW;M:MAIL;C:CLINIC;E:EXIT",DIR("B")="WINDOW"
        D ^DIR G:$D(DIRUT)!(Y="E") EX S PSOSORT=PSOSORT_"^"_Y,PSRT=Y
        S LG=0,PATA=0 F  S LG=$O(^PS(52.41,"AD",LG)) Q:'LG!($G(POERR("QFLG")))  F PSOD=0:0 S PSOD=$O(^PS(52.41,"AD",LG,PSOPINST,PSOD)) Q:'PSOD!($G(POERR("QFLG")))  D
        .Q:$P($G(^PS(52.41,PSOD,0)),"^",23)
        .Q:$G(PAT($P(^PS(52.41,PSOD,0),"^",2)))=$P(^PS(52.41,PSOD,0),"^",2)  S PAT=$P(^PS(52.41,PSOD,0),"^",2)
        .;PSO*7*266
        .I PAT'=PATA D LBL
        .I '$O(^PS(52.41,"AC",PAT,PSRT,0)) S PSOLK=1,PAT(PAT)=PAT Q
        .D RTE^PSOORFI2 I $G(PSZFIN) S PSOLK=1,PAT(PAT)=PAT Q
        .D LK I $G(POERR("QFLG")) K POERR("QFLG") S PSOLK=1,PAT(PAT)=PAT Q
        .I $$CHK^PSODPT(PAT_"^"_$P($G(^DPT(PAT,0)),"^"),1,1)<0 S PSOLK=1,PAT(PAT)=PAT S X=PAT D ULP Q
        .S (PSODFN,Y)=PAT_"^"_$P($G(^DPT(PAT,0)),"^"),PATA=PAT
        .D:'$G(MEDA) PROFILE^PSOORFI2 S Y=PSODFN I $G(MEDP) D SPL D OERR^PSORX1 S PSOFIN=1 D QU S X=PSOPTLOK D KLLP,ULP,KLL Q
        .D SDFN D POST^PSOORFI1 I $G(PSOQFLG)!($G(PSOQUIT)) S:$G(PSOQUIT) POERR("QFLG")=1 S:$G(PSOQFLG) PAT(PAT)=PAT S X=PAT D ULP K PSOQFLG Q
        .D PP S ORD=0 D @PSRT S PAT(PAT)=PAT
        .S X=PAT D ULP
        ;PSO*7*266
        K POERR("QFLG"),PSOQFLG,PSOPTPST,MAIL,WIN,CLI D LBL
        I $G(PSOQUIT) K PSOQUIT D EX G PSOORFIN
EX      D EX^PSOORFI1
        Q
W       D KQ F  S ORD=$O(^PS(52.41,"AC",PAT,"W",ORD)) Q:'ORD!($G(POERR("QFLG")))  I $P(^PS(52.41,ORD,0),"^",3)'="DC",$P(^(0),"^",3)'="DE" D LK1,ORD S MAIL=1
        Q:$G(POERR("QFLG"))  I $G(MAIL) S ORD=0 D
        .D KQ F  S ORD=$O(^PS(52.41,"AC",PAT,"M",ORD)) Q:'ORD!($G(POERR("QFLG")))  D:$P(^PS(52.41,ORD,0),"^",3)'="DC"&($P(^(0),"^",3)'="DE") LK1,ORD
        .Q:$G(POERR("QFLG"))
        .D KQ F  S ORD=$O(^PS(52.41,"AC",PAT,"C",ORD)) Q:'ORD!($G(POERR("QFLG")))  D:$P(^PS(52.41,ORD,0),"^",3)'="DC"&($P(^(0),"^",3)'="DE") LK1,ORD
        Q
M       D KQ F  S ORD=$O(^PS(52.41,"AC",PAT,"M",ORD)) Q:'ORD!($G(POERR("QFLG")))  I $P(^PS(52.41,ORD,0),"^",3)'="DC",$P(^(0),"^",3)'="DE" D LK1,ORD S WIN=1
        Q:$G(POERR("QFLG"))  I $G(WIN) S ORD=0 D
        .D KQ F  S ORD=$O(^PS(52.41,"AC",PAT,"W",ORD)) Q:'ORD!($G(POERR("QFLG")))  I $P(^PS(52.41,ORD,0),"^",3)'="DC",$P(^(0),"^",3)'="DE" D LK1,ORD
        .Q:$G(POERR("QFLG"))
        .D KQ F  S ORD=$O(^PS(52.41,"AC",PAT,"C",ORD)) Q:'ORD!($G(POERR("QFLG")))  D:$P(^PS(52.41,ORD,0),"^",3)'="DC"&($P(^(0),"^",3)'="DE") LK1,ORD
        Q
C       D KQ F  S ORD=$O(^PS(52.41,"AC",PAT,"C",ORD)) Q:'ORD!($G(POERR("QFLG")))  I $P(^PS(52.41,ORD,0),"^",3)'="DC",$P(^(0),"^",3)'="DE" D LK1,ORD S CLI=1
        Q:$G(POERR("QFLG"))  I $G(CLI) S ORD=0 D
        .D KQ F  S ORD=$O(^PS(52.41,"AC",PAT,"M",ORD)) Q:'ORD!($G(POERR("QFLG")))  I $P(^PS(52.41,ORD,0),"^",3)'="DC",$P(^(0),"^",3)'="DE" D LK1,ORD
        .Q:$G(POERR("QFLG"))
        .D KQ F  S ORD=$O(^PS(52.41,"AC",PAT,"W",ORD)) Q:'ORD!($G(POERR("QFLG")))  D:$P(^PS(52.41,ORD,0),"^",3)'="DC"&($P(^(0),"^",3)'="DE") LK1,ORD
        Q
PAT     ;Begin WorldVistA change; PSO*7*208
        ;W ! K MEDP,MEDA,POERR("DFLG"),DIR D KQ S PSOSORT="PATIENT"
        ;S DIR("?")="^D PT^PSOORFI1",DIR("A")="All Patients or Single Patient",DIR(0)="SBM^A:ALL;S:SINGLE;E:EXIT",DIR("B")="SINGLE"
        ;D ^DIR K DIR G:$D(DIRUT)!(Y="E") EX I Y="S" S PSOSORT=PSOSORT_"^"_"SINGLE" G SPAT
        I $G(PSOAFYN)'="Y" W ! K MEDP,MEDA,POERR("DFLG"),DIR D KQ S PSOSORT="PATIENT"
        I $G(PSOAFYN)="Y" K MEDP,MEDA,POERR("DFLG"),DIR D KQ S PSOSORT="PATIENT"
        I $G(PSOAFYN)'="Y" S DIR("?")="^D PT^PSOORFI1",DIR("A")="All Patients or Single Patient",DIR(0)="SBM^A:ALL;S:SINGLE;E:EXIT",DIR("B")="SINGLE"
        I $G(PSOAFYN)'="Y" D ^DIR K DIR G:$D(DIRUT)!(Y="E") EX I Y="S" S PSOSORT=PSOSORT_"^"_"SINGLE" G SPAT
        I $G(PSOAFYN)="Y" S PSOSORT=PSOSORT_"^"_"SINGLE" G SPAT
        ;End WorldVistA change
        S PSOSORT=PSOSORT_"^ALL"
        S LG=0,PATA=0 F  S LG=$O(^PS(52.41,"AD",LG)) Q:'LG!($G(POERR("QFLG")))  F PSOD=0:0 S PSOD=$O(^PS(52.41,"AD",LG,PSOPINST,PSOD)) Q:'PSOD!($G(POERR("QFLG")))  D
        .Q:'$D(^PS(52.41,PSOD,0))!($P($G(^PS(52.41,PSOD,0)),"^",23))
        .Q:$G(PAT($P(^PS(52.41,PSOD,0),"^",2)))=$P(^PS(52.41,PSOD,0),"^",2)  S PAT=$P(^PS(52.41,PSOD,0),"^",2)
        .;PSO*7*266
        .I PAT'=PATA D LBL
        .D LK I $G(POERR("QFLG")) K POERR("QFLG") S PSOLK=1,PAT(PAT)=PAT Q
        .I $$CHK^PSODPT(PAT_"^"_$P($G(^DPT(PAT,0)),"^"),1,1)<0 S PSOLK=1,PAT(PAT)=PAT S X=PAT D ULP K PSOQFLG,PSOQQ Q
        .S (PSODFN,Y)=PAT_"^"_$P($G(^DPT(PAT,0)),"^"),PATA=PAT
        .D:'$G(MEDA) PROFILE^PSOORFI2 S Y=PSODFN I $G(MEDP) D SPL D OERR^PSORX1 S PSOFIN=1 D QU S X=PSOPTLOK D KLLP,ULP,KLL Q
        .D SDFN D POST^PSOORFI1 I $G(PSOQFLG)!($G(PSOQUIT)) S:$G(PSOQUIT) POERR("QFLG")=1 S:$G(PSOQFLG) PAT(PAT)=PAT S X=PAT D ULP K PSOQFLG Q
        .S PAT(PAT)=PAT
        .F ORD=0:0 S ORD=$O(^PS(52.41,"AOR",PAT,PSOPINST,ORD)) Q:'ORD!($G(POERR("QFLG")))!($G(PSOQQ))  D
        ..I '$P($G(^PS(52.41,ORD,0)),"^",23) D PP,LK1,ORD
        .S X=PAT D ULP K PSOQQ
        I $O(PSORX("PSOL",0))!($D(RXRS)) D LBL
        I $G(PSOQUIT) K PSOQUIT D EX G PSOORFIN
        G EX
        ;PSO*7*266 kill BINGCRT,BINGRTE when selecting pat.
SPAT    K MEDA,MEDP,PSOQFLG,PSORX("FN"),BINGCRT,BINGRTE D KQ,KV^PSOVER1
        ;Begin WorldVistA change; PSO*7*208
        ;S DIR(0)="FO^2:30",DIR("A")="Select Patient",DIR("?")="^D HELP^PSOORFI2" D ^DIR I $E(X)="?" G SPAT
        ;G:$D(DIRUT) EX D KV^PSOVER1
        ;S DIC(0)="EQM",DIC=2,DIC("S")="I $D(^PS(52.41,""AOR"",+Y,PSOPINST))"
        ;D ^DIC K DIC G:"^"[X EX G:Y=-1 SPAT S (PSODFN,PAT)=+Y,PSOFINY=Y
        I $G(PSOAFDON)=1 G EX
        I $G(PSOAFYN)'="Y" S DIR(0)="FO^2:30",DIR("A")="Select Patient",DIR("?")="^D HELP^PSOORFI2" D ^DIR I $E(X)="?" G SPAT
        I $G(PSOAFYN)'="Y" G:$D(DIRUT) EX D KV^PSOVER1
        I $G(PSOAFYN)'="Y" S DIC(0)="EQM",DIC=2,DIC("S")="I $D(^PS(52.41,""AOR"",+Y,PSOPINST))"
        I $G(PSOAFYN)'="Y" D ^DIC K DIC G:"^"[X EX G:Y=-1 SPAT S (PSODFN,PAT)=+Y,PSOFINY=Y
        ;End WorldVistA change
        D LK I $G(POERR("QFLG")) G SPAT
        N SNGLPAT S SNGLPAT=1
        ;PSO*7*266
        D:'$G(MEDA) PROFILE^PSOORFI2 S Y=PSOFINY I $G(MEDP) D SPL D OERR^PSORX1 D LBL S PSOFIN=1,X=PSOPTLOK D KLLP,ULP,KLL G SPAT
        D PP,SDFN,POST^PSOORFI1 D:$G(PSOQFLG)  G:$G(PSOQFLG) EX I $G(PSOQUIT) S:$G(PSOQUIT) POERR("QFLG")=1 S X=PAT D ULP G SPAT
        .S X=PAT D ULP
        ;Begin WorldVistA change; PSO*7*208
        I PSOAFYN'="Y" S ORD=0 F  S ORD=$O(^PS(52.41,"P",PAT,ORD)) Q:'ORD!($G(POERR("QFLG")))  D:'$P($G(^PS(52.41,ORD,0)),"^",23)
        .;End WorldVistA change
        .D:$P(^PS(52.41,ORD,0),"^",3)'="DC"&($P(^(0),"^",3)'="DE")&($P(^(0),"^",3)'="HD") LK1,ORD
        ;PSO*7*266
        ;Begin WorldVistA change; PSO*7*208
        ;D LBL
        I PSOAFYN="Y" S ORD=0,ORD=$O(^PS(52.41,"B",+ORDERID,ORD)) D:$P(^PS(52.41,ORD,0),"^",3)'="DC"&($P(^(0),"^",3)'="DE")&($P(^(0),"^",3)'="HD") LK1,ORD
        I $O(PSORX("PSOL",0))!($D(RXRS)) D LBL
        I $G(PSOAFYN)="Y" S PSOAFDON=1 ;vfah
        ;End WorldVistA change
        S PSOFIN=1,X=PAT D ULP G SPAT
ORD     I $G(PSOBCK) N LST,ORN
        E  S PSOLOUD=1 D:$P($G(^PS(55,PAT,0)),"^",6)'=2 EN^PSOHLUP(PAT) K PSOLOUD
        K DRET,SIG,^TMP("PSORXDC",$J) Q:'$D(^PS(52.41,ORD,0))
        I $G(PSOFIN),$P($G(^PS(52.41,ORD,"INI")),"^")'=$G(PSOPINST) Q
        D L1^PSOORFI3 I '$G(PSOMSG) K PSOMSG Q
        I '$D(^PS(52.41,ORD,0)) K PSOMSG Q
        K DRET,SIG,PSOPRC,PHI,PRC,PSOSIGFL,OBX,PSOMSG S PSOFDR=1,OR0=^PS(52.41,ORD,0),OI=$P(OR0,"^",8),PSORX("SC")=$P(OR0,"^",16)
        I $O(^PS(52.41,ORD,2,0)) S PHI=^PS(52.41,ORD,2,0),T=0 F  S T=$O(^PS(52.41,ORD,2,T)) Q:'T  S PHI(T)=^PS(52.41,ORD,2,T,0)
        I $P($G(^PS(52.41,ORD,"EXT")),"^")'="" K PHI I $O(^PS(52.41,ORD,"SIG",0)) S PHI=$G(^PS(52.41,ORD,"SIG",0)),T=0 F  S T=$O(^PS(52.41,ORD,"SIG",T)) Q:'T  S PHI(T)=$G(^PS(52.41,ORD,"SIG",T,0))
        I $O(^PS(52.41,ORD,3,0)) S PRC=^PS(52.41,ORD,3,0),T=0 F  S T=$O(^PS(52.41,ORD,3,T)) Q:'T  S PRC(T)=^PS(52.41,ORD,3,T,0)
        I $P(OR0,"^",24),($P(OR0,"^",3)="RNW"!($P(OR0,"^",3)="NW")) N PKI,PKI1,PKIR,PKIE S PKI=0 D CER^PSOPKIV1 Q:PKI<1
        I $P(OR0,"^",3)="RNW",$D(^PSRX(+$P(OR0,"^",21),0)) D  G SUCC ;process renews
        .K PSOREEDT S (PSOORRNW,PSOFDR)=1,PSORENW("OIRXN")=$P(OR0,"^",21),PSOOPT=3,(PSORENW("DFLG"),PSORENW("QFLG"))=0 D ^PSOORRNW,SQR
        I $P(OR0,"^",3)="RF",$D(^PSRX(+$P(OR0,"^",19),0)) D RF^PSOORFI2 G SUCC
        N PSODRUG,PSONEW S PSOFROM="PENDING" D:'$G(PSOTPBFG) DSPL^PSOTPCAN(ORD) D DSPL^PSOORFI1,SQN^PSOORFI3
SUCC    ;
        D UL1^PSOORFI3,FULL^VALM1
        D:$P($G(^PS(52.41,+$G(ORD),0)),"^",3)'="NW"&($P($G(^(0)),"^",3)'="RNW")&($P($G(^(0)),"^",3)'="HD")&($P($G(^(0)),"^",3)'="RF")
        .K PSOSD("PENDING",$S('$G(OID):$P(^PS(50.7,$P(OR0,"^",8),0),"^")_" "_$P(^PS(50.606,$P(^PS(50.7,$P(OR0,"^",8),0),"^",2),0),"^"),1:$P(^PSDRUG($P(OR0,"^",9),0),"^")))
        S:$G(POERR("DFLG")) POERR("QFLG")=1 K POERR("DFLG"),PSONEW,ACP,OR0,DRET,SIG,OID,OI,PSORX("SC"),PSORX("CLINIC"),PSODRUG
        Q
        ;PSO*7*266 change order of bingo checks.
LBL     I $O(PSORX("PSOL",0))!($D(RXRS)) S PSOFROM="NEW" D ^PSORXL K PSORX("PSOL"),PPL,RXRS
        D:$D(BINGCRT)&($D(BINGRTE)&($D(DISGROUP))) ^PSOBING1 K BINGCRT,BINGRTE,PSONEW,BBFLG,BBRX
        Q
CHK     ;
        D:'$D(PSOPAR) ^PSOLSET I '$D(PSOPAR) W !,$C(7),"Outpatient Division MUST be selected!",! G EX
        D INST1^PSOORFI2
        S PSZCNT=0 F PSZZI=0:0 S PSZZI=$O(^PS(59,PSZZI)) Q:'PSZZI  S PSZCNT=PSZCNT+1
        S TC=0 F TO=0:0 S TO=$O(^PS(52.41,"AOR",TO)) Q:'TO  F TZ=0:0 S TZ=$O(^PS(52.41,"AOR",TO,TZ)) Q:'TZ  F PSTZ=0:0 S PSTZ=$O(^PS(52.41,"AOR",TO,TZ,PSTZ)) Q:'PSTZ  S TC=TC+1
        W !!?10,$C(7),"Orders to be completed"_$S(PSZCNT=1:": ",1:" for all divisions: ")_TC,! Q:'TC
        D SUMM^PSOORNE1 K PSZZI,PSZCNT,PSTZ
        Q
        ;
LK      D LOCK^PSOORFI1
        Q
LK1     D LOCK1^PSOORFI1 Q
QU      I $G(PSOQUIT) S POERR("QFLG")=1 K PSOQUIT
        S:$G(PSOQFLG) PAT(PAT)=PAT
        Q
ULP     K PSORX("MAIL/WINDOW"),PSORX("METHOD OF PICK-UP")
        D CLEAN^PSOVER1
        I '$G(X) Q
        D UL^PSSLOCK(X) Q
KLL     K PSOPTLOK Q
KLLP    K PSONOLCK Q
SPL     D SPL^PSOORFI4 Q
SDFN    S PSODFN=+$G(PSODFN) Q
PP      D PP^PSOORFI4 Q
KQ      K PSOQUIT,POERR("QFLG") Q
SQR     ;
        K PSOORRNW,PSOOPT,PSOREEDT,PSOQUIT S POERR("DFLG")=0
        Q
