PPPPRT9 ;ALB/DMB - MEDICATION PROFILE PRINT ROUTINE ; 6/25/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**10,17**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
PLP(PATDFN) ; Print Label Profile
 ;
 N VISARRY,DI
 S VISARRY="^TMP(""PPP"",$J,""VISIT"")"
 ;
 Q:$$GETVIS^PPPGET7(PATDFN,VISARRY)<1
 D PRPROFIL(PATDFN,VISARRY)
 K @VISARRY
 Q
 ;
PRPROFIL(PATDFN,ARRAYNM,OBFLAG) ; Print the med profile
 ;
 N PPPDOB,PPPNAME,PPPSSN,PPPTMP,BNR1,BNR3,DA,DIC,DIQ,DIR,DR,DI,D0
 N DTOUT,DUOUT,I,NARRATIV,ND,OUT,PAGE,PARMERR,PHRMARRY,RVRSDT,RXIDX
 N STANAME,STAPTR,TMP,Y
 ;
 S PARMERR=-9001
 ;
 I '$D(ARRAYNM) Q PARMERR
 I '$D(OBFLAG) S OBFLAG="O"
 I OBFLAG="" S OBFLAG="O"
 S PHRMARRY="^TMP(""PPP"",$J,""PHR"")"
 S PAGE=1,OUT=""
 S BNR1="PPP - Medication Profile from other VAMC(s)"
 S BNR3="Date Printed: "_$$DTE^PPPUTL1(DT,0)
 ;
 ; Get the local name, SSN and DOB
 ;
 S DIC="^DPT(",DA=PATDFN,DR=".01;.03;.09",DIQ="PPPTMP" D EN^DIQ1
 S PPPNAME=PPPTMP(2,PATDFN,.01)
 S PPPDOB=PPPTMP(2,PATDFN,.03)
 S PPPSSN=PPPTMP(2,PATDFN,.09)
 K PPPTMP,DIC,DR,DA,DTOUT,DUOUT
 ;
 ; Get the prescription data
 ;
 I OBFLAG="B" S TMP=$$GLPHRM^PPPGET8(PATDFN,PHRMARRY)
 S TMP=$$GETPDX^PPPGET2(ARRAYNM,PHRMARRY)
 ;
 ; If there is anything to print... print it.
 ;
 I $D(@PHRMARRY) D
 .D HEADING1,NARRATIV
 K @PHRMARRY
 Q
 ;
HEADING1 ; Write the page heading, Pause if a crt.
 ;
 I PAGE>1,$E(IOST,1,2)="C-" D  Q:OUT["^"
 .S DIR(0)="E" D ^DIR
 .I +Y=0 S OUT="^"
 W @IOF,!
 W ?((IOM-$L(BNR1))\2),BNR1,?(IOM-15),"Page ",PAGE,!
 W ?((IOM-$L(BNR3))\2),BNR3,!!
 W !,"Patient: ",PPPNAME_" ("_PPPSSN_")",?60,"DOB: ",PPPDOB
 W ! F I=1:1:IOM W "="
 Q
 ;
HEADING2 ; Write the page heading, Pause if a crt.
 ;
 I PAGE>1,($E(IOST,1,2)="C-"),($D(NARRATIV)) D  Q:OUT["^"
 .S DIR(0)="E" D ^DIR
 .I +Y=0 S OUT="^"
 W !,"RX #",?9,"DRUG",?41,"ST",?45,"QTY",?51,"ISSUED",?65,"LAST FILLED"
 W ! F I=1:1:IOM W "="
 Q
 ;
NARRATIV ; Print the narratives.
 ; If PSTYPE is defined then this is part of the info/action profile
 ; and we don't want to print the narrative.
 ;
 S NARRATIV=1
 S STANAME=""
 I $D(@PHRMARRY@(0))&('$D(PSTYPE)) D
 .F  S STANAME=$O(@PHRMARRY@(0,STANAME)) Q:STANAME=""!(OUT["^")  D
 ..I $Y+5>IOSL S PAGE=PAGE+1 D HEADING1 Q:OUT["^"
 ..W !!,"NARRATIVE FROM ",STANAME
 ..W !,"  => ",@PHRMARRY@(0,STANAME)
 .W !
 K NARRATIV
 ;
DRUGS I $Y+8<IOSL D HEADING2
 S RVRSDT=0
 F  S RVRSDT=$O(@PHRMARRY@(RVRSDT)) Q:RVRSDT'>0!(OUT["^")  D
 .S STAPTR=""
 .F  S STAPTR=$O(@PHRMARRY@(RVRSDT,STAPTR)) Q:STAPTR=""!(OUT["^")  D
 ..S RXIDX=-1
 ..F  S RXIDX=$O(@PHRMARRY@(RVRSDT,STAPTR,RXIDX)) Q:RXIDX=""!(OUT["^")!(RXIDX="PID")  D
 ...I $Y+6>IOSL S PAGE=PAGE+1 D HEADING1 Q:OUT["^"  D HEADING2
 ...S ND=$G(@PHRMARRY@(RVRSDT,STAPTR,RXIDX)) Q:ND=""
 ...I $P(ND,"^",8)'="",$D(^TMP("PPP",$J,"VISIT",$P(ND,"^",8),1)),$P(^TMP("PPP",$J,"VISIT",$P(ND,"^",8),1),"^",1)'=PPPNAME W !,?9," ** WARNING ** Patient is identified as : ",$P(^TMP("PPP",$J,"VISIT",$P(ND,"^",8),1),"^",1)," not ",PPPNAME
 ...W !!,$P(ND,"^"),?9,$E($P(ND,"^",2),1,30),?41,$E($P(ND,"^",3),1),?45,$P(ND,"^",4),?51,$$SLASHDT^PPPCNV1($P(ND,"^",5)),?65,$$SLASHDT^PPPCNV1($P(ND,"^",6))
 ...W !,?9,"SIG: ",$E($P(ND,"^",7),1,25),?40,"ISSUED AT ",$P(ND,"^",8)," (",$P(ND,"^",9),")"
 ...W !,?9,"PROVIDER: ",$P(ND,"^",10)
 K @PHRMARRY
 Q
