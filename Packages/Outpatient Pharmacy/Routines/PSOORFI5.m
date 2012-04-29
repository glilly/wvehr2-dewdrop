PSOORFI5        ;BIR/SJA-finish cprs orders ;2:35 PM  11 Aug 2009
        ;;7.0;OUTPATIENT PHARMACY;**225,315**;DEC 1997;Build 54;WorldVistA 30-June-08
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
        ;External references UL^PSSLOCK supported by DBIA 2789
        ;External reference to ^DPT supported by DBIA 10035
        ;
FLG     W ! K MEDP,MEDA,POERR("DFLG"),DIR D KQ S PSOSORT="FLAGGED^FLAGGED"
        S LG=0,PATA=0 F  S LG=$O(^PS(52.41,"AD",LG)) Q:'LG!($G(POERR("QFLG")))  F PSOD=0:0 S PSOD=$O(^PS(52.41,"AD",LG,PSOPINST,PSOD)) Q:'PSOD!($G(POERR("QFLG")))  D
        .Q:'$D(^PS(52.41,PSOD,0))!('$P($G(^PS(52.41,PSOD,0)),"^",23))
        .Q:$G(PAT($P(^PS(52.41,PSOD,0),"^",2)))=$P(^PS(52.41,PSOD,0),"^",2)  S PAT=$P(^PS(52.41,PSOD,0),"^",2)
        .I PAT'=PATA,$O(PSORX("PSOL",0))!($D(RXRS)) D LBL^PSOORFIN
        .D LK I $G(POERR("QFLG")) K POERR("QFLG") S PSOLK=1,PAT(PAT)=PAT Q
        .I $$CHK^PSODPT(PAT_"^"_$P($G(^DPT(PAT,0)),"^"),1,1)<0 S PSOLK=1,PAT(PAT)=PAT S X=PAT D ULP K PSOQFLG,PSOQQ Q
        .S (PSODFN,Y)=PAT_"^"_$P($G(^DPT(PAT,0)),"^"),PATA=PAT
        .D:'$G(MEDA) PROFILE^PSOORFI2 S Y=PSODFN I $G(MEDP) D SPL D OERR^PSORX1 S PSOFIN=1 D QU S X=PSOPTLOK D KLLP,ULP,KLL Q
        .D SDFN D POST^PSOORFI1 I $G(PSOQFLG)!($G(PSOQUIT)) S:$G(PSOQUIT) POERR("QFLG")=1 S:$G(PSOQFLG) PAT(PAT)=PAT S X=PAT D ULP K PSOQFLG Q
        .S PAT(PAT)=PAT
        .F ORD=0:0 S ORD=$O(^PS(52.41,"AOR",PAT,PSOPINST,ORD)) Q:'ORD!($G(POERR("QFLG")))!($G(PSOQQ))  D
        ..I $P($G(^PS(52.41,ORD,0)),"^",23) D PP,LK1,ORD^PSOORFIN
        .S X=PAT D ULP K PSOQQ
        I $O(PSORX("PSOL",0))!($D(RXRS)) D LBL^PSOORFIN
        I $G(PSOQUIT) K PSOQUIT D EX G ^PSOORFIN
        G EX
        ;
PRI     ; Called from PSOORFIN due to it's routine size.
        K DIR S PSOSORT="PRIORITY"
        S DIR("A")="Select Priority",DIR(0)="SBM^S:STAT;E:EMERGENCY;R:ROUTINE",DIR("B")="ROUTINE"
        D ^DIR G:$D(DIRUT) EX S PSOSORT=PSOSORT_"^"_Y,PSRT=Y
        S LG=0,PATA=0 F  S LG=$O(^PS(52.41,"AD",LG)) Q:'LG!($G(POERR("QFLG")))  F PSOD=0:0 S PSOD=$O(^PS(52.41,"AD",LG,PSOPINST,PSOD)) Q:'PSOD!($G(POERR("QFLG")))  D
        .Q:$P($G(^PS(52.41,PSOD,0)),"^",23)
        .Q:$G(PAT($P(^PS(52.41,PSOD,0),"^",2)))=$P(^PS(52.41,PSOD,0),"^",2)  S PAT=$P(^PS(52.41,PSOD,0),"^",2)
        .I PAT'=PATA,$O(PSORX("PSOL",0))!($D(RXRS)) D LBL^PSOORFIN
        .I '$O(^PS(52.41,"AP",PAT,PSRT,0)) S PSOLK=1,PAT(PAT)=PAT Q
        .D PRI^PSOORFI2 I $G(PSZFIN) S PSOLK=1,PAT(PAT)=PAT Q
        .D LK I $G(POERR("QFLG")) K POERR("QFLG") S PSOLK=1,PAT(PAT)=PAT Q
        .I $$CHK^PSODPT(PAT_"^"_$P($G(^DPT(PAT,0)),"^"),1,1)<0 S PSOLK=1,PAT(PAT)=PAT S X=PAT D ULP Q
        .S (PSODFN,Y)=PAT_"^"_$P($G(^DPT(PAT,0)),"^"),PATA=PAT
        .D:'$G(MEDA) PROFILE^PSOORFI2 S Y=PSODFN I $G(MEDP) D SPL D OERR^PSORX1 S PSOFIN=1 D QU S X=PSOPTLOK D KLLP,ULP,KLL Q
        .D SDFN D POST^PSOORFI1 I $G(PSOQFLG)!($G(PSOQUIT)) S:$G(PSOQUIT) POERR("QFLG")=1 S:$G(PSOQFLG) PAT(PAT)=PAT S X=PAT D ULP K PSOQFLG Q
        .D PP S ORD=0 D @PSRT S PAT(PAT)=PAT
        .S X=PAT D ULP
        I $O(PSORX("PSOL",0))!($D(RXRS)) D LBL^PSOORFIN
        I $G(PSOQUIT) K PSOQUIT D EX G ^PSOORFIN
EX      D EX^PSOORFI1
        Q
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
KLL     K PSOPTLOK
        Q
KLLP    K PSONOLCK
        Q
SPL     D SPL^PSOORFI4
        Q
SDFN    S PSODFN=+$G(PSODFN)
        Q
PP      D PP^PSOORFI4
        Q
KQ      K PSOQUIT,POERR("QFLG")
        Q
S       D S^PSOORFI2 ; Process STAT priority
        Q
        ;
E       D E^PSOORFI2 ; Process EMERGENCY priority
        Q
        ;
R       D R^PSOORFI2 ; Process ROUTINE priority
        Q
        ;
LMDISP(ORD)     ; Backdoor ListManager Display of Flag/Unflag Informaiton
        N FLAG
        K FLAGLINE S ORD=+$G(ORD) I 'ORD Q
        ;
        I '$G(^PS(52.41,ORD,"FLG")) Q
        ; S X=IORVON_"Flagged"_IORVOFF
        D GETS^DIQ(52.41,ORD,"33;34;35;36;37;38","IE","FLAG")
        S L1="Flagged by "_$E(FLAG(52.41,ORD_",",34,"E"),1,30)_" on "_$$FMTE^XLFDT(FLAG(52.41,ORD_",",33,"I"),2)_": "
        S LEN=80-$L(L1),L1=L1_$E(FLAG(52.41,ORD_",",35,"E"),1,LEN),L2=$E(FLAG(52.41,ORD_",",35,"E"),LEN+1,999)
        S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=L1,FLAGLINE(IEN)=7
        I L2'="" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=L2
        I FLAG(52.41,ORD_",",36,"I")'="" D
        . S L1="Unflagged by "_$E(FLAG(52.41,ORD_",",37,"E"),1,30)_" on "_$$FMTE^XLFDT(FLAG(52.41,ORD_",",36,"I"),2)_": "
        . S LEN=80-$L(L1),L1=L1_$E(FLAG(52.41,ORD_",",38,"E"),1,LEN),L2=$E(FLAG(52.41,ORD_",",38,"E"),LEN+1,999)
        . S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=L1,FLAGLINE(IEN)=9
        . I L2'="" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=L2
        S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" "
        Q
        ;Begin WorldVistA change; PSO*7*208; 08/11/2008
SUCC    ;
        D UL1^PSOORFI3,FULL^VALM1
        D:$P($G(^PS(52.41,+$G(ORD),0)),"^",3)'="NW"&($P($G(^(0)),"^",3)'="RNW")&($P($G(^(0)),"^",3)'="HD")&($P($G(^(0)),"^",3)'="RF")
        .K PSOSD("PENDING",$S('$G(OID):$P(^PS(50.7,$P(OR0,"^",8),0),"^")_" "_$P(^PS(50.606,$P(^PS(50.7,$P(OR0,"^",8),0),"^",2),0),"^"),1:$P(^PSDRUG($P(OR0,"^",9),0),"^")))
        S:$G(POERR("DFLG")) POERR("QFLG")=1 K POERR("DFLG"),PSONEW,ACP,OR0,DRET,SIG,OID,OI,PSORX("SC"),PSORX("CLINIC"),PSODRUG
        Q
LBL     ;Begin DAOU
        S PSOFROM="NEW" D ^PSORXL
        K PSORX("PSOL"),PPL,RXRS
        ;End  5/4/2005
        Q
CHK     ;
        D:'$D(PSOPAR) ^PSOLSET I '$D(PSOPAR) W !,$C(7),"Outpatient Division MUST be selected!",! G EX^PSOORFIN
        D INST1^PSOORFI2
        S PSZCNT=0 F PSZZI=0:0 S PSZZI=$O(^PS(59,PSZZI)) Q:'PSZZI  S PSZCNT=PSZCNT+1
        S TC=0 F TO=0:0 S TO=$O(^PS(52.41,"AOR",TO)) Q:'TO  F TZ=0:0 S TZ=$O(^PS(52.41,"AOR",TO,TZ)) Q:'TZ  F PSTZ=0:0 S PSTZ=$O(^PS(52.41,"AOR",TO,TZ,PSTZ)) Q:'PSTZ  S TC=TC+1
        W !!?10,$C(7),"Orders to be completed"_$S(PSZCNT=1:": ",1:" for all divisions: ")_TC,! Q:'TC
        D SUMM^PSOORNE1 K PSZZI,PSZCNT,PSTZ
        Q
        ;End WorldVistA change
