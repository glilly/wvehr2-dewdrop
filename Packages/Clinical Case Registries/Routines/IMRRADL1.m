IMRRADL1 ;HCIOFO/NCA/FAI - Print Radiology Utility Report (Cont.) ;09/27/00  22:34
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**11**;Feb 09, 1998
PRNT ; Print Radiology Data
 S IMRD="FOR THE PERIOD "_$E(IMRSD,4,5)_"/"_$E(IMRSD,6,7)_"/"_$E(IMRSD,2,3)_" TO "_$E(IMRED,4,5)_"/"_$E(IMRED,6,7)_"/"_$E(IMRED,2,3)
 S (IMRTOT,IMRUT)=0
 I IMR2C F IMR0C=0:1:4 S IMR1C="C"_IMR0C,IMRLBL=$S(IMR0C=0:"NO CATEGORY DEFINED",IMR0C=1:"HIV+",IMR0C=2:"HIV+ (CD4<500)",IMR0C=3:"AIDS-3",1:"AIDS") D PRN1
 Q:IMRUT
 I IMR2C Q:'$D(^TMP($J,"IMRPR","CT"))  S IMR1C="CT" D C3^IMRRADL K ^TMP($J,"IMRPR","CT")
 S IMRTOT=1,IMR0C=5,IMR1C="CT",IMRLBL="TOTAL HIV+ (ALL CATEGORIES) POPULATION" D PRN1
 K IMRLBL
 Q
PRN1 Q:'$D(^TMP($J,"IMRPRN",IMR1C))
 Q:IMRUT
 S IMRTIT="RADIOLOGY UTILIZATION REPORT" D HDR Q:IMRUT
 W !,"Totals:  " W +$P(IMRCPR,"^",IMR0C+1)," procedures reported for ",+$P(IMRTTP,"^",IMR0C+1)," patients ( ",+$P(IMRPAT,"^",IMR0C+1)," individual patients )"
 W !?20,"There were ",+$P(IMRDPR,"^",IMR0C+1)," different procedures performed",!
 I IMR2C D
 .S $P(IMRCPR,"^",6)=$P(IMRCPR,"^",6)+$P(IMRCPR,"^",IMR0C+1)
 .S $P(IMRPAT,"^",6)=$P(IMRPAT,"^",6)+$P(IMRPAT,"^",IMR0C+1)
 .S $P(IMRTTP,"^",6)=$P(IMRTTP,"^",6)+$P(IMRTTP,"^",IMR0C+1)
 .Q
 D HDR1 S (IMRI,IMRTP)="",IMRCP=0,IMRX="A"
 F  S IMRX=$O(^TMP($J,"IMRPRN",IMR1C,IMRX),-1) Q:IMRX<1!(IMRUT)  S IMRPN="" F  S IMRPN=$O(^TMP($J,"IMRPRN",IMR1C,IMRX,IMRPN)) Q:IMRPN=""!(IMRUT)  S IMRY=$G(^(IMRPN)) D
 .I ($Y>(IOSL-4)) D HDR Q:IMRUT  D HDR1
 .I +IMRY<IMRCP D TOT
 .W !?8,$J(+IMRY,7)," ",$P(IMRPN,"~",1),?48,$J($P(IMRY,"^",2),8)
 .S $P(IMRTP,"^",1)=$P(IMRTP,"^",1)+$P(IMRY,"^",1),$P(IMRTP,"^",2)=$P(IMRTP,"^",2)+$P(IMRY,"^",2),IMRCP=+IMRY
 .I 'IMRTOT D
 ..I '$D(^TMP($J,"IMRPR","CT",IMRPN)) S ^(IMRPN)="" S $P(IMRDPR,"^",6)=$P(IMRDPR,"^",6)+1
 ..S IMRI=$G(^TMP($J,"IMRPR","CT",IMRPN)),$P(IMRI,"^",1)=$P(IMRI,"^",1)+$P(IMRY,"^",1),$P(IMRI,"^",2)=$P(IMRI,"^",2)+$P(IMRY,"^",2)
 ..S ^TMP($J,"IMRPR","CT",IMRPN)=IMRI
 ..Q
 .Q
 Q:IMRUT  I IMRTP'="" D TOT
 D HDR Q:IMRUT
 D HDR2
 S IMRX="A" F  S IMRX=$O(^TMP($J,"IMRPRN",IMR1C,IMRX),-1) Q:IMRX<1!(IMRUT)!(IMRX<IMRN1)  S IMRPN="" F  S IMRPN=$O(^TMP($J,"IMRPRN",IMR1C,IMRX,IMRPN)) Q:IMRPN=""!(IMRUT)  S IMRY=$G(^(IMRPN)) D
 .I ($Y>(IOSL-4)) D HDR Q:IMRUT  D HDR2
 .W !,$P(IMRPN,"~",1),?33,$P(IMRPN,"~",2),?48,$J($P(IMRY,"^",1),10),$J($P(IMRY,"^",2),14)
 .Q
 K ^TMP($J,"IMRPRN",IMR1C) Q:IMRUT
 Q:'IMRRMAX  D HDR Q:IMRUT
 S IMRN=0 S X1="HIGHEST UTILIZATION PATIENTS BASED ON NUMBER OF PROCEDURES" D HDR3
 S IMRX="A" F  S IMRX=$O(^TMP($J,"IMRPAT",IMR1C,IMRX),-1) Q:IMRX<1!(IMRN'<IMRRMAX)  Q:IMRUT  F IMRDFN=0:0 S IMRDFN=$O(^TMP($J,"IMRPAT",IMR1C,IMRX,IMRDFN)) Q:IMRDFN<1  Q:IMRUT  S IMRX1=^(IMRDFN) D PAT D:'IMRUT ALLPAT
 K ^TMP($J,"IMRPAT",IMR1C)
 Q
PAT ; Identify Patients
 I ($Y>(IOSL-4)) D HDR Q:IMRUT
 S DFN=IMRDFN,IMRN=IMRN+1 D NS^IMRCALL W !,IMRNAM,?32,IMRSSN,?45,$J($P(IMRX1,U),6),$J($P(IMRX1,U,2),10)
 Q
TOT ; Tabulate a total procedure and patients
 W !!?8,$J(+$P(IMRTP,"^",1),7)," ","procedure",$S($P(IMRTP,"^",1)>1:"s",1:"")," reported for",?48,$J(+$P(IMRTP,"^",2),8)," patient",$S($P(IMRTP,"^",2)>1:"s",1:""),!
 S IMRTP=""
 Q
ALLPAT ; Set ^TMP for all Patients
 Q:IMRTOT
 I '$D(^TMP($J,"IMRPAT","CT",IMRX,IMRDFN)) S ^(IMRDFN)=IMRX1
 Q
EOP ; Check End of Page
 S IMRUT=0 I $E(IOST,1,2)="C-",IMRPG'<1 W ! S DIR(0)="E" D ^DIR K DIR I 'Y S IMRUT=1 Q
 Q
HDR ; Print Header of the Report
 Q:IMRUT  D EOP Q:IMRUT
 W:'($E(IOST,1,2)'="C-"&'IMRPG) @IOF S IMRPG=IMRPG+1
 W:IOST'["C-" !!! W !,IMRDTE,?(IOM-$L(IMRTIT)\2),IMRTIT,?(IOM-8),"Page ",IMRPG,!?(IOM-$L(IMRD)\2),IMRD,!?(IOM-$L(IMRLBL)\2),IMRLBL,!
 Q
HDR1 ; Heading For Radiology Procedures Reported
 Q:IMRUT  W !?8,"  Total ","Procedure Reported",?48,"Patients",!
 Q
HDR2 ; Heading For Listing the Minimum  # of Highest Procedures
 Q:IMRUT  W !,"For ",IMRN1," or more procedures",!
 W !?30,"CPT code-Modifier ",?54,"Procs",?67,"Patients",!
 Q
HDR3 ; Heading For Highest Utility Patients
 W !,X1,!!,?47,"TOTAL",?55,"DIFFERENT",!,"PATIENT NAME",?35,"SSN",?47,"PROCS",?55,"PROCEDURES",!
 Q
