PSOSULB1 ;BHAM ISC/RTR,SAB-Print suspended labels  cont. ; 10/10/96
 ;;7.0;OUTPATIENT PHARMACY;**10,200,264**;DEC 1997;Build 19
DEV D:'$D(PSOPAR) ^PSOLSET G:'$D(PSOPAR) DEV S PSOION=ION
 N X S X="PSXRSUS" X ^%ZOSF("TEST") G:($T)&($G(PSXSYS))&($D(^XUSEC("PSXCMOPMGR",DUZ)))&($D(^XUSEC("PSX XMIT",DUZ))) ^PSXRSUS
DEV1 I '$P(PSOPAR,"^",8) G START
 N PSOPROP,PFIO W $C(7),!!,"PROFILES MUST BE SENT TO PRINTER !!",! K IOP,%ZIS,IO("Q"),POP S %ZIS="MNQ",%ZIS("A")="Select PROFILE Device: " D ^%ZIS K %ZIS("A") G:POP EXIT^PSOSULBL G:$E(IOST)["C"!(PSOION=ION) DEV S PSOPROP=ION D ^%ZISC
START I $G(PSOCUTDT)']"" S X1=DT,X2=-120 D C^%DTC S PSODTCUT=X,PSOPRPAS=$P(PSOPAR,"^",7)
ASK K ^TMP($J),PSOSU,PSOSUSPR S PFIOQ=0,PDUZ=DUZ W !
 S %DT="AEX",%DT("A")="Print labels through date: ",%DT("B")="TODAY" D ^%DT K %DT D:Y<0 MESS G:Y<0 EXIT^PSOSULBL S PRTDT=Y
 I '$O(^PS(52.5,"C",0))!($O(^(0))>PRTDT) W $C(7),!!,"NOTHING THRU DATE TO PRINT" G ASK
 W ! K DIR S DIR("A")="Sort by Patient Name, ID#, or DEA Special Handling",DIR(0)="SB^P:PATIENT NAME;I:IDENTIFICATION NUMBER;D:DEA SPECIAL HANDLING"
 S DIR("?")="Enter 'P' to sort the labels alphabetically by name, enter 'I' to sort by identification number, enter 'D' to sort by DEA Special Handling."
 S DIR("?",1)="Sorting by DEA Special Handling will print the labels in three groups. The",DIR("?",2)="first will contain labels with drugs marked with an A or C in the DEA Special"
 S DIR("?",3)="Handling field, indicating NARCOTICS AND ALCOHOLICS, and CONTROLLED SUBSTANCES-",DIR("?",4)="NON NARCOTIC. The second group will contain ones marked with an S, indicating"
 S DIR("?",5)="SUPPLY, and all others will print in the third group.",DIR("?",6)=""
 D ^DIR K DIR D:$D(DIRUT) MESS G:$D(DIRUT) EXIT^PSOSULBL S PSRT=$S(Y="D":"D",Y="P":1,1:0)
 I Y="D" W ! K DIR S DIR(0)="SB^P:PATIENT NAME;I:IDENTIFICATION NUMBER",DIR("A")="Within DEA Special Handling, sort by Patient Name or ID#" D ^DIR K DIR D:$D(DIRUT) MESS G:$D(DIRUT) EXIT^PSOSULBL S PSRTONE=Y
 S X1=PRTDT,X2=$P(PSOPAR,"^",27) D C^%DTC S XDATE=X K IOP,POP,IO("Q"),ZTSK
PRLBL W ! S %ZIS("A")="Printer 'LABEL' Device: ",%ZIS("B")="",%ZIS="MQN" D ^%ZIS S PSLION=ION I POP S IOP=PSOION D ^%ZIS D MESS G EXIT^PSOSULBL
 I $E(IOST)'["P" D MESSL G PRLBL
 N PSOIOS S PSOIOS=IOS D DEVBAR^PSOBMST
 S PSOBARS=PSOBAR1]""&(PSOBAR0]"")&$P(PSOPAR,"^",19)
 K PSOION D ^%ZISC I $D(IO("Q")) K IO("Q")
QUE K %DT,PSOTIME,PSOOUT D NOW^%DTC S %DT="REAX",%DT(0)=%,%DT("B")="NOW",%DT("A")="Queue to run at what time: " D ^%DT K %DT I $D(DTOUT)!(Y<0) D MESS G EXIT^PSOSULBL
 S (PSOSUSPR,PSODBQ)=1,PSOTIME=Y
 S ZTRTN="BEG^PSOSULBL",ZTDESC="PRINT LABELS FROM SUSPENSE",ZTIO=PSLION,ZTDTH=PSOTIME
 F G="PSOPAR","PSOSYS","PSOSUSPR","PSODBQ","PSRT","PSRTONE","PSOPROP","PSLION","PFIO","PSOBARS","PSODTCUT","PSOPRPAS","PRTDT","PDUZ","PSOBAR0","PSOBAR1","PSOSITE","XDATE","PSOTIME" S:$D(@G) ZTSAVE(G)=""
 D ^%ZTLOAD W !!,"PRINT FROM SUSPENSE JOB QUEUED!",! D ^%ZISC G EXIT^PSOSULBL
 ;G:PSRT'="D" BEG^PSOSULBL
MESS W $C(7),!!?3,"NOTHING QUEUED TO PRINT!",! Q
MESSL W $C(7),!?3,"LABELS MUST BE SENT TO A PRINTER!",! Q
BAIMAIL     ;Send mail message
 S:'$G(PDUZ) PDUZ=+$G(DUZ)
 K ^TMP("PSOM",$J)
 N SEQ,XMY,XMDUZ,XMSUB,XMTEXT,SEQ,NAME,PSSN,RX,FILL,FIRST
 S SEQ=1
 S XMY(PDUZ)=""
 S XMY("G.PSO EXTERNAL DISPENSE ALERTS")=""
 S XMDUZ="OUTPATIENT PHARMACY PACKAGE"
 S XMSUB="BAD ADDRESS SUSPENSE NOT PRINTED"
 I $G(PSOSITE) S XMSUB=$$GET1^DIQ(59,PSOSITE,.06)_" "_XMSUB
 S ^TMP("PSOM",$J,SEQ)="The following prescriptions with a routing of mail were not printed/sent to",SEQ=SEQ+1
 S ^TMP("PSOM",$J,SEQ)="external interface due to the BAD ADDRESS INDICATOR being set and no active",SEQ=SEQ+1
 S ^TMP("PSOM",$J,SEQ)="temporary address, or the patient has an active MAIL status of DO NOT MAIL, or",SEQ=SEQ+1
 S ^TMP("PSOM",$J,SEQ)="the patient has a foreign address:",SEQ=SEQ+1
 S NAME="" F  S NAME=$O(^TMP("PSOSM",$J,NAME)) Q:NAME=""  D
 .S PSSN="" F  S PSSN=$O(^TMP("PSOSM",$J,NAME,PSSN)) Q:PSSN=""  D
 ..S ^TMP("PSOM",$J,SEQ)="",SEQ=SEQ+1
 ..S ^TMP("PSOM",$J,SEQ)=NAME_"   "_PSSN,FIRST=1
 ..S RX=0 F  S RX=$O(^TMP("PSOSM",$J,NAME,PSSN,RX)) Q:'RX  S FILL="" F  S FILL=$O(^TMP("PSOSM",$J,NAME,PSSN,RX,FILL)) Q:FILL=""  D
 ...I FIRST D  S FIRST=0
 ....S ^TMP("PSOM",$J,SEQ)=^TMP("PSOM",$J,SEQ)_"   ("_$G(^TMP("PSOSM",$J,NAME,PSSN,RX,FILL))_")"
 ....S SEQ=SEQ+1
 ...S ^TMP("PSOM",$J,SEQ)="  "_$P(^PSRX(RX,0),"^")_" ("_FILL_")  "_$P($G(^PSDRUG($P(^PSRX(RX,0),"^",6),0)),"^"),SEQ=SEQ+1
 S ^TMP("PSOM",$J,SEQ+1)=""
 S XMTEXT="^TMP(""PSOM"",$J," N DIFROM D ^XMD K XMSUB,XMTEXT,XMY,XMDUZ
 Q
 ;
