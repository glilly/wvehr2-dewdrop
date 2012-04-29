ECXFELOC        ;BIR/DMA,CML-Print Feeder Locations; [ 05/07/96  8:41 AM ] ; 6/12/07 6:29am
        ;;3.0;DSS EXTRACTS;**1,8,105**;Dec 22, 1997;Build 70
EN      ;entry point from option
        W !!,"Print list of feeder locations.",! S QFLG=1
        K %ZIS S %ZIS="Q" D ^%ZIS Q:POP
        I $D(IO("Q")) S ZTDESC="Feeder Location List (DSS)",ZTRTN="START^ECXFELOC" D ^%ZTLOAD D ^%ZISC G OUT
        U IO
START   ;queued entry point
        I '$D(DT) S DT=$$HTFM^XLFDT(+$H)
        K ^TMP($J) S (QFLG,PG)=0,$P(LN,"-",81)=""
LAB     S EC=0 F  S EC=$O(^LRO(68,EC)) Q:'EC  I $D(^(EC,0)) S EC1=^(0),^TMP($J,"LAB",$P(EC1,U,11),EC)=$P(EC1,U)
ECS     S EC=0 I $P($G(^EC(720.1,1,0)),U,2) D  G IV
        .F  S EC=$O(^ECJ(EC)) Q:'EC  I $D(^(EC,0)) S EC1=$P(^(0),"-",1,2),EC2=$P($G(^ECD(+$P(EC1,"-",2),0)),U),^TMP($J,"ECS",EC1,EC1)=EC2
        F  S EC=$O(^ECK(EC)) Q:'EC  I $D(^(EC,0)) S EC1=$P(^(0),"-",1,2),EC2=$P($G(^ECD(+$P(EC1,"-",2),0)),U),^TMP($J,"ECS",EC1,EC1)=EC2
IV      S EC=0 F  S EC=$O(^DG(40.8,EC)) Q:'EC  I $D(^DG(40.8,EC,0)) S EC1=$E($P(^(0),U),1,30),^TMP($J,"IVP","IVP"_EC,EC)="IV Pharmacy-"_EC1
CLI     S EC=0 F  S EC=$O(^SC(EC)) Q:'EC  I $D(^(EC,0)) S EC1=^(0),ECS=$P(EC1,U,15),ECSC=$P($G(^DIC(40.7,+$P(EC1,U,7),0)),U,2),ECD=$P(EC1,U) S:'ECS ECS=1 D
        .I $P(EC1,U,17)'="Y",$P(EC1,U,3)="C" S DAT=$G(^SC(EC,"I")),ID=+DAT,RD=$P(DAT,U,2) I 'ID!(ID>DT)!(RD&(RD<DT)) S ^TMP($J,"CLI",ECS_ECSC,EC)=ECD
PRE     N ARRAY S ARRAY="^TMP($J,""ECXDSS"")" K @ARRAY D PSS^PSO59(,"??","ECXDSS") I @ARRAY@(0)>0 G V6
        ;dbia (#4689)
        S EC=0 F  S EC=$O(^DIC(59,EC)) Q:'EC  I $D(^(EC,0)) S EC1=$E($P(^(0),U),1,30),^TMP($J,"PRE","PRE"_EC,EC)="Prescriptions-"_EC1
        G RAD
V6      S EC=0 F  S EC=$O(@ARRAY@(EC)) Q:'EC  I $D(^(EC)) S EC1=$E(@ARRAY@(EC,.01),1,30),^TMP($J,"PRE","PRE"_EC,EC)="Prescriptions-"_EC1
        K @ARRAY
RAD     S EC=0 F  S EC=$O(^RA(79,EC)),EC1=0 Q:'EC  I $D(^(EC,0)) S ECD=$P(^(0),U) F  S EC1=$O(^RA(79.2,EC1)) Q:'EC1  I $D(^(EC1,0)) S ECD1=$P(^(0),U),^TMP($J,"RAD",EC_"-"_EC1,EC_"-"_EC1)=ECD_"-"_ECD1
NUR     S EC=0 F  S EC=$O(^NURSF(211.4,EC)) Q:'EC  I $D(^(EC,0)) S EC1=$P(^(0),U),EC1=$P($G(^SC(+EC1,0)),U),^TMP($J,"NUR",EC,EC)=EC1
SUR     F EC=1:1:14 S EC2=$P($T(@EC),";",3) F EC1="I","A","D","M","P","C","S" S EC3=$P($T(@EC1),";",3),^TMP($J,"SUR",$P(EC2,U)_EC1,EC)=$P(EC2,U,2)_"-"_EC3
1       ;;ORGE^GENERAL PURPOSE OPERATING ROOM
2       ;;OROR^ORTHOPEDIC OPERATING ROOM
3       ;;ORCA^CARDIAC OPERATING ROOM
4       ;;ORNE^NEUROSURGERY OPERATING ROOM
5       ;;ORCN^CARDIAC/NEURO OPERATING ROOM
6       ;;ORAM^AMBULATORY OPERATING ROOM
7       ;;ORIN^INTENSIVE CARE UNIT
8       ;;OREN^ENDOSCOPY ROOM
9       ;;ORCY^CYSTOSCOPY ROOM
10      ;;ORWA^WARD
11      ;;ORCL^CLINIC
12      ;;ORDE^DEDICATED ROOM
13      ;;OROT^OTHER LOCATION
14      ;;ORNO^UNKNOWN
I       ;;IMPLANTS
A       ;;ANESTHESIA TIME
D       ;;SURGERY TIME (DENTAL)
M       ;;SURGERY TIME (MEDICINE)
P       ;;SURGERY TIME (PSYCH)
C       ;;SURGERY TIME (SPINAL CORD)
S       ;;SURGERY TIME (SURGERY)
UDP     S EC=0 F  S EC=$O(^DG(40.8,EC)) Q:'EC  I $D(^DG(40.8,EC,0)) S EC1=$E($P(^(0),U),1,30),^TMP($J,"UDP","UDP"_EC,EC)="Unit Dose Medications-"_EC1
DEN     S EC=0 F  S EC=$O(^DENT(225,EC)) Q:'EC  I $D(^(EC,0)) S EC1=$P(^(0),U),^TMP($J,"DEN",EC1,EC)="Dental "_EC1
        ;
PRINT   ;
        S EC="" F  S EC=$O(^TMP($J,EC)),EC1="" Q:EC=""  Q:QFLG  D HEAD Q:QFLG  F  S EC1=$O(^TMP($J,EC,EC1)),EC2=""  Q:EC1=""  Q:QFLG  F  S EC2=$O(^TMP($J,EC,EC1,EC2)) Q:EC2=""  Q:QFLG  D
        .W !,?5,EC1,?23,^(EC2) I $Y+3>IOSL D HEAD Q:QFLG
OUT     I $E(IOST)="C"&('QFLG) S DIR(0)="E" D  D ^DIR K DIR
        .S SS=22-$Y F JJ=1:1:SS W !
        K ^TMP($J),DAT,EC,EC1,EC2,EC3,ECD,ECD1,ECS,ECSC,ID,JJ,LN,PG,POP,QFLG,RD,SS,X,Y
        W:$E(IOST)'="C" @IOF D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" Q
HEAD    ;
        I $E(IOST)="C" S SS=22-$Y F JJ=1:1:SS W !
        I $E(IOST)="C",PG>0 S DIR(0)="E" W ! D ^DIR K DIR I 'Y S QFLG=1 Q
        S PG=PG+1 W:$Y!($E(IOST)="C") @IOF W !,?15,"Feeder Location List For Feeder System ",EC,?72,"Page: ",PG,!!,?5,"FEEDER LOCATION",?23,"DESCRIPTION",!,LN
        Q
