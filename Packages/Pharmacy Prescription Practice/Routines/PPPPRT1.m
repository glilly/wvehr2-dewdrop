PPPPRT1 ;ALB/DMB - PRINT FOREIGN PROFILE ROUTINES ; 3/3/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
VFM(PATDFN,PHRMARRY) ; View/print foreign medication for 1 patient.
 ;
 N %ZIS,PPPARRY,PPPDOB,PPPNAME,PPPSSN,PPPTMP
 N DA,DIC,DIR,DOB,DR,ERR,LKUPERR,NAME,ND,NODE,NODELEN,OPENERR
 N OUT,PARMERR,POP,QUEERR,SSN,TMP,DIQ
 N ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN,ZTSAVE,ZTSK
 ;
 S PARMERR=-9001
 S LKUPERR=-9003
 S OPENERR=-9011
 S QUEERR=-9012
 S ERR=0
 ;
 S DIC=2,DA=PATDFN,DR=".01;.03;.09",DIQ="PPPTMP"
 D EN^DIQ1
 I '$D(PPPTMP) Q LKUPERR
 S NAME=PPPTMP(2,DA,.01)
 S DOB=PPPTMP(2,DA,.03)
 S SSN=PPPTMP(2,DA,.09)
 ;
PWHERE ; Ask where to send the listing
 ;
 S %ZIS="QM",%ZIS("A")="Print Profile On What Device? "
 D ^%ZIS
 I POP D  Q OPENERR
 .W !,*7,"Error Opening Print Device."
 .R !,"Press <RETURN> To Continue...",TMP:DTIME
QTSK I IO'=IO(0) D
 .I '$D(IO("Q")) S ZTDTH=$H
 .S ZTRTN="START^PPPPRT1"
 .S ZTIO=ION
 .S ZTDESC="FOREIGN MEDICATION PRINT"
 .S ZTSAVE("PPPNAME")=NAME
 .S ZTSAVE("PPPDOB")=DOB
 .S ZTSAVE("PPPSSN")=SSN
 .S ZTSAVE("PPPARRY")=PHRMARRY
 .D ^%ZTLOAD
QERR .I '$D(ZTSK) D  Q
 ..D HOME^%ZIS
 ..W !!,*7,"Error... Print task was not started successfully"
 ..R !,"Press <RETURN> To Continue...",TMP:DTIME
 ..S ERR=QUEERR
 .I $D(IO("Q")) W !!,"Request Queued On ",ION
 E  D
 .S PPPNAME=NAME
 .S PPPDOB=DOB
 .S PPPSSN=SSN
 .S PPPARRY=PHRMARRY
 .D START
 Q ERR
 ;
START ;
 ;
 N PAGE,OUT,BNR1,BNR2,DIR,I,X,Y
 ;
 S BNR1="Pharmacy Prscription Practices"
 S BNR2="Foreign Medication Profile"
 S PAGE=1
 S OUT=""
 ;
 D HEADING,QUERY
 W @IOF
 I $D(ZTQUEUED) S ZTREQ="@"
 D ^%ZISC
 K @PPPARRY,PPPNAME,PPPSSN,PPPDOB,PPPARRY
 Q
 ;
HEADING ; Write the page heading, Pause if a crt.
 ;
 I PAGE>1,$E(IOST,1,2)="C-" D  Q:OUT["^"
 .S DIR(0)="E" D ^DIR
 .I +Y=0 S OUT="^"
 W @IOF,!
 W ?((IOM-$L(BNR1))\2),BNR1,?(IOM-15),"Page ",PAGE,!
 W ?((IOM-$L(BNR2))\2),BNR2,!
 W !,"Patient: ",PPPNAME_" ("_PPPSSN_")",?60,"DOB: ",PPPDOB
 W !!,"RX #",?9,"DRUG",?41,"ST",?45,"QTY",?51,"ISSUED",?65,"LAST FILLED"
 W ! F I=1:1:IOM-1 W "-"
 S PAGE=PAGE+1
 Q
 ;
QUERY ; Query through the array and print the data
 ;
 S NODE=PPPARRY
 S NODELEN=$L(PPPARRY)
 F I=0:0 D  Q:($E(NODE,1,NODELEN-1)'=$E(PPPARRY,1,NODELEN-1))!(OUT["^")
 .S NODE=$Q(@NODE) Q:($E(NODE,1,NODELEN-1)'=$E(PPPARRY,1,NODELEN-1))
 .S ND=@NODE
 .I $Y+5>IOSL D HEADING Q:OUT["^"
 .W !!,$P(ND,"^"),?9,$E($P(ND,"^",2),1,30),?41,$E($P(ND,"^",3),1),?45,$P(ND,"^",4),?51,$$SLASHDT^PPPCNV1($P(ND,"^",5)),?65,$$SLASHDT^PPPCNV1($P(ND,"^",6))
 .W !,?9,"SIG: ",$E($P(ND,"^",7),1,25),?40,"ISSUED AT ",$P(ND,"^",8)," (",$P(ND,"^",9),")"
 I $E(IOST,1,2)="C-"&(OUT'["^") D
 .W !!,*7,"Listing Complete."
 .R !,"Press <RETURN> to continue...",OUT:DTIME
 Q
