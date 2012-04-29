PSSWRNC ;DAL/RJS-NEW WARNING SOURCE CUSTOM WARNING LIST BUILDER CONT;
 ;;1.0;PHARMACY DATA MANAGEMENT;**98**;10/12/05
 ;
 ;IA: 3735 ^PSNDF(50.68
 ;IA: 4445 ^PS(50.625
 ;IA: 4446 ^PS(50.626
 ;IA: 4448 ^PS(50.627
SEL1 ;
 S DR=0 F  S DR=$O(^PSDRUG(DR)) Q:'DR  D
 .I '$D(^PSDRUG(DR,0)) Q
 .S WARN54=$P(^PSDRUG(DR,0),"^",8) I WARN54="" Q
 .I SKIP,$P($G(^PSDRUG(DR,"WARN")),"^")'="" Q
 .D ACTIVE^PSSWRNB I 'ACTIVE Q
 .D DRUG^PSSWRNB I PSSWRN="" S ^TMP("PSSWRNB",$J,$P(^PSDRUG(DR,0),"^"))=WARN54_"^"_NDF
 Q
SEL2 ;
 S DR=0 F  S DR=$O(^PSDRUG(DR)) Q:'DR  D
 .I '$D(^PSDRUG(DR,0)) Q
 .S WARN54=$P(^PSDRUG(DR,0),"^",8) I WARN54="" Q
 .I SKIP,$P($G(^PSDRUG(DR,"WARN")),"^")'="" Q
 .D ACTIVE^PSSWRNB I 'ACTIVE Q
 .F I=1:1:$L(WARN54,",") S WARN=$P(WARN54,",",I) I WARN>20 D
 ..I '$D(^PS(54,WARN)) Q
 ..S ^TMP("PSSWRNB",$J,$P(^PSDRUG(DR,0),"^"))=WARN54
 Q
SEL3 ;
 W ! K DIR S DIR(0)="FO^1:30",DIR("A")="Enter starting drug name" D ^DIR K DIR I Y["^"!(Y="") S QUIT=1 Q
 S X=$$ENLU^PSSGMI(Y)
 S DRUG=X
 W ! K DIR S DIR(0)="FO^1:30",DIR("A")="Enter ending drug name" D ^DIR K DIR I Y["^"!(Y="") S QUIT=1 Q
 S EDRUG=Y
 W !!,"WARNINGS FOR DRUGS FROM "_DRUG_" TO "_EDRUG
 W ! K DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSSOUT=1,QUIT=1 Q
 I $D(^PSDRUG("B",DRUG)) S I=$L(DRUG),DRUG=$E(DRUG,1,I-1)
 F  S DRUG=$O(^PSDRUG("B",DRUG)) Q:DRUG=""  Q:DRUG]EDRUG  D
 .S DR=$O(^PSDRUG("B",DRUG,0)) I DR="" Q
 .I SKIP,$P($G(^PSDRUG(DR,"WARN")),"^")'="" Q
 .D ACTIVE^PSSWRNB I 'ACTIVE Q
 .S ^TMP("PSSWRNB",$J,DRUG)=""
 Q
SEL4 ;
 S DR=0 F  S DR=$O(^PSDRUG(DR)) Q:'DR  D
 .I SKIP,$P($G(^PSDRUG(DR,"WARN")),"^")'="" Q
 .D ACTIVE^PSSWRNB I 'ACTIVE Q
 .D DRUG^PSSWRNB I PSSWRN="" Q
 .N XX S XX=DR D CHECK20^PSSWRNA
 .I $L(PSSWRN,",")>5 S ^TMP("PSSWRNB",$J,$P(^PSDRUG(DR,0),"^"))=PSSWRN
 Q
SEL59 ;
 S DIC=54,DIC(0)="AEQM",DIC("A")="Select drugs containing RX Consult number:" D ^DIC K DIC I Y<0 Q
 S RXNUM=$P(Y,"^")
 I '$D(^PS(54,RXNUM)) W !,RXNUM_" is not in the RX Consult file.",! K DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSSOUT=1 Q
 I SEL=9,'$G(^PS(54,RXNUM,2)) W !,RXNUM," is not mapped to a new data source warning",! K DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSSOUT=1 Q
 I SEL=9 S PSO9=$G(^PS(54,RXNUM,2))_"N" W "  ",RXNUM," is mapped to ",PSO9 H 1
 S DR=0 F  S DR=$O(^PSDRUG(DR)) Q:'DR  D
 .I '$D(^PSDRUG(DR,0)) Q
 .S WARN54=$P(^PSDRUG(DR,0),"^",8) I WARN54="" Q
 .I SKIP,$P($G(^PSDRUG(DR,"WARN")),"^")'="" Q
 .D ACTIVE^PSSWRNB I 'ACTIVE Q
 .I ","_WARN54_","[(","_RXNUM_",") D
 ..I SEL=9 D DRUG^PSSWRNB I PSSWRN="" Q
 ..I SEL=9,","_PSSWRN_","[(","_PSO9_",") Q
 ..S ^TMP("PSSWRNB",$J,$P(^PSDRUG(DR,0),"^"))=WARN54
 Q
SEL6 ;
 S DR=0 F  S DR=$O(^PSDRUG(DR)) Q:'DR  D
 .I '$D(^PSDRUG(DR,0)) Q
 .S WARN54=$P(^PSDRUG(DR,0),"^",8) I WARN54="" Q
 .I SKIP,$P($G(^PSDRUG(DR,"WARN")),"^")'="" Q
 .D ACTIVE^PSSWRNB I 'ACTIVE Q
 .F I=1:1:$L(WARN54,",") S WARN=$P(WARN54,",",I) I WARN,$D(^PS(54,WARN,1)),$G(^PS(54,WARN,2))="" D
 ..S ^TMP("PSSWRNB",$J,$P(^PSDRUG(DR,0),"^"))=WARN54
 Q
SEL7 ;
 W !! K DIR S DIR("A")="Select drugs containing New warning number"
 S DIR("?",1)="Answer using format # or #N"
 S DIR("?")="Example: 15 or 15N"
 S DIR(0)="FO"
 D ^DIR S RXNUM=Y
 I Y="N"!(Y="n")!(Y="Y")!(Y="y") W !,$C(7),?5,RXNUM_" is not a valid entry" H 2 S QUIT=1 Q
 I RXNUM["N"!(RXNUM["n") S RXNUM=$TR(RXNUM,"Nn","")
 I RXNUM="^"!(RXNUM="")!(RXNUM=" ") S QUIT=1 Q
 I '$D(^PS(50.625,RXNUM)) W !,$C(7),RXNUM_" is not in the New warning file" H 1 S QUIT=1 Q
 W @IOF
 W "Searching for drugs that contain new warning number "_RXNUM
 S PSOWARN=RXNUM_"N",STAR="" D NEWWARN^PSSWRNE
 K DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSSOUT=1 Q
 S DR=0 F  S DR=$O(^PSDRUG(DR)) Q:'DR  D
 .I SKIP,$P($G(^PSDRUG(DR,"WARN")),"^")'="" Q
 .D ACTIVE^PSSWRNB I 'ACTIVE Q
 .D DRUG^PSSWRNB I PSSWRN="" Q
 .I ","_PSSWRN_","[(","_RXNUM_"N,") S ^TMP("PSSWRNB",$J,$P(^PSDRUG(DR,0),"^"))=PSSWRN
 Q
SEL8 ;
 N WARN,GEND
 S WARN=0 F  S WARN=$O(^PS(50.625,WARN)) Q:'WARN  I $G(^PS(50.625,WARN,2))'="" S GEND(WARN_"N")=""
 I $O(GEND(""))="" Q
 S DR=0 F  S DR=$O(^PSDRUG(DR)) Q:'DR  D
 .I SKIP,$P($G(^PSDRUG(DR,"WARN")),"^")'="" Q
 .D ACTIVE^PSSWRNB I 'ACTIVE Q
 .D DRUG^PSSWRNB I PSSWRN="" Q
 .S WARN=0 F  S WARN=$O(GEND(WARN)) Q:'WARN  I ","_PSSWRN_","[(","_WARN_",") D
 ..S ^TMP("PSSWRNB",$J,$P(^PSDRUG(DR,0),"^"))=PSSWRN
 Q
