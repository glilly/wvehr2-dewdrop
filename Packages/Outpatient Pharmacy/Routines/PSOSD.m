PSOSD   ;BHAM ISC/SAB - action or informational profile ;11/18/92 18:30
        ;;7.0;OUTPATIENT PHARMACY;**2,17,155,176,300**;DEC 1997;Build 4
        ;External reference to ^PS(55 supported by DBIA 2228
        ;External reference to ^PSDRUG( supported by DBIA 221
        ;
START   S X=$$SITE^VASITE,PSOINST=$P(X,"^",3) K X
        K IOP,DIR S DIR("A")="Action or Informational (A or I): ",DIR("?",1)="Enter 'A' for action profile",DIR("?",2)="      'I' for informational profile",DIR("?")="      'E' to EXIT process",DIR("B")="A",DIR(0)="SAM^1:Action;0:Informational;E:Exit"
        D ^DIR G:Y="E"!($D(DIRUT)) PAT1 S PSTYPE=Y
        S PSONUM=0 I 'PSTYPE!'$P($G(PSOSYS),"^",6) S PSOPOL=0 G ASK
        K DIR S DIR("A")="Do you want generate a Polypharmacy report?: ",DIR("?",1)="Enter 'Y' to generate report",DIR("?",2)="      'N' if you do not want the report",DIR("?")="      'E' to EXIT process",DIR("B")="NO",DIR(0)="SA^1:YES;0:NO;E:Exit"
        D ^DIR S PSOPOL=$S(Y:1,1:0) G:Y="E"!($D(DIRUT)) PAT1 G:'PSOPOL ASK
        K DIR S DIR("A")="Minimum Number of Active Prescriptions",DIR("B")=7,DIR(0)="N^1:100:0" D ^DIR S PSONUM=Y G:$D(DIRUT) PAT1
        ;
ASK     K DIR S DIR("A")="By Patient, Clinic or Clinic Group (P/C/G): ",DIR("?",1)="Enter 'P' to print by patient ",DIR("?",2)="      'C' for printing by clinic",DIR("?",3)="      'G' for printing by clinic group"
        S DIR("?")="      'E' to exit process",DIR("B")="P",DIR(0)="SAM^P:Patient;C:Clinic;G:Clinic Group;E:Exit"
        D ^DIR G:Y="E"!($D(DIRUT)) PAT1 S PSOUT=Y
        K DIR,DTOUT,DIRUT,DUOUT S DIR("A")="Do you want this Profile to print in 80 column or 132 column: ",DIR("B")="132",DIR(0)="SAM^1:132;8:80;E:Exit"
        D ^DIR G:Y="E"!($D(DIRUT)) PAT1 S PSORM=$S(Y=1:1,1:0) K DIR,X,Y
        G:PSOUT="P" ^PSOSD1 G:PSOUT="G" CLSG^PSOSDP
CLINIC  N RSLT K DIR,X,Y R !!,"FOR CLINIC (TYPE 'ALL' FOR ALL CLINICS): ",X:DTIME S:'$T X="^" G:"^"[X EXIT
        S DIC="^SC(",DIC(0)="QEM",FR="ALL",TO="" I X'="ALL" D ^DIC G CLINIC:Y<0 S (FR,TO)=+Y
        S %DT="AEFX",%DT("A")="FOR DATE: " D ^%DT G CLINIC:Y<0 S FR=FR_","_Y,TO=TO_","_Y_".2359",PSOT=Y
CLSG    D DAYS^PSOSD1 G:$D(DIRUT) EXIT S X1=DT,X2=-PSDAYS D C^%DTC S PSDATE=X S PSTYPE=$S($D(PSTYPE):PSTYPE,1:0),$P(LINE,"-",132)="-"
        N PSOBARS,PSOBAR0,PSOBAR1
        D DEV^PSOSDRAP Q:$D(DTOUT)!($D(DUOUT))
        S (IOP,APRT)=ION,PSOIOS=IOS D DEVBAR^PSOBMST
        K PSOION I $D(IO("Q")) S ZTDESC="Outpatient Pharmacy Action Profile",ZTRTN="QUE^PSOSD",ZTSAVE("ZTREQ")="@" D  D EXIT G START
        .F G="FR","TO","LINE","PSOT","APRT","PSOPOL","PSOSYS","PSOINST","PSOBAR0","PSOBAR1","PSOBAR2","PSOPAR","PSOPAR7","PRF","PSDAYS","PSDATE","PSTYPE","PSOSITE","PSDATE","PSDAY","PSONUM","PSORM" S:$D(@G) ZTSAVE(G)=""
        .S ZTSAVE("DOD*")="" D ^%ZTLOAD W:$D(ZTSK) !,"Report Queued to Print !!",! K:'$G(LM) ZTSK,IO("Q")
        ;S DISTOP="I $D(DIRUT)"
        I $P(FR,",",1)'="ALL" D CLINIC^PSOSDRAP
        I $P(FR,",",1)="ALL" D CLINALL^PSOSDRAP
        S (X,PSTY)=PSTYPE D EXIT S PSTYPE=PSTY Q:$G(CLSP)  G START
        ;
PAT     N K D:$P($G(^PS(55,DFN,0)),"^",6)'=2 EN^PSOHLUP(DFN)
        S PSDT=PSDATE-1 I '$O(^PS(55,DFN,"P","A",PSDT)) D HD^PSOSD2 Q:$D(DIRUT)  W !!?13,">>>> NO PRESCRIPTIONS ON FILE <<<<" G PAT1
        K ^TMP($J,DFN),^TMP($J,"PRF"),^TMP($J,"ACT")
        F Z1=0:0 S PSDT=$O(^PS(55,DFN,"P","A",PSDT)) Q:'PSDT  D RX
        I '$D(^TMP($J,"PRF")) D HD^PSOSD2 W !!?13,">>>>> NO CURRENT PRESCRIPTIONS DATA FOUND <<<<<" D PAT1 Q
        D ^PSOSDP:$G(PSOPOL)&('$D(CLINICX))
        D HD^PSOSD2:'$D(CLINICX)
        D ^PSOSD0,PAT1 Q:($D(DIRUT))
        Q
RX      F J=0:0 S J=$O(^PS(55,DFN,"P","A",PSDT,J)) Q:'J  D RX1
        Q
RX1     Q:'$D(^PSRX(J,0))  S RXNO=J
        S RX0=$G(^PSRX(J,0)),$P(RX0,"^",15)=+$G(^("STA")),RX2=$G(^(2)),RX3=$G(^(3)) I RX0]"" D
        .S DRUG="" S:$D(^PSDRUG(+$P(RX0,"^",6),0)) DRUG=$P(^(0),"^"),CLASS=$P(^(0),"^",2) S:CLASS="" CLASS="zz" I DRUG]"" D STAT^PSOFUNC,STORE
        .I $G(PSOPOL),$P($G(^PSDRUG(+$P(RX0,"^",6),0)),"^",3)'["S" S:'$D(^TMP($J,DFN)) ^TMP($J,DFN)=0 S:"05"[$E(+$P(RX0,"^",15)) ^TMP($J,DFN)=^TMP($J,DFN)+1,^TMP($J,DFN,DRUG,J)=""
        Q
PAT1    K DUPD,DIR,X,Y,CLASS,ZCLASS,DRUG,CLAPP,HDFL,RXN,PSDOB,ADDR,RX,ST,ST0,II,FA,FN,PRI,DIC,PSRENW,PSLC,PI,Z2,Z,P,Z0,Z1,Z3,Z4,Z5,FDATE,AL,RFL,DRG,ELN,FDT,FILLDATE,FN,LN,PSOIFSUP,PSOPRPAS,RX3,RXCNT,SG,SGC,PSOUT,PSOPOLP
        Q
        ;
STORE   I $P(^PSRX(J,"STA"),"^")=13!($P($G(^(3)),"^",7)="CANCELLED FROM SUSPENSE BEFORE FILLING")!($P($G(^(3)),"^",7)="DISCONTINUED FROM SUSPENSE BEFORE FILLING") Q
        I 'PSDAYS,ST]"","DE"[$E(ST) Q
        S FILLDATE=9999999-$P(^PSRX(J,3),"^") I "DE"[$E(ST) S FILLDATE=FILLDATE+10000
        I $E(ST)="D" S CNDT=0 F PSIIX=0:0 S PSIIX=$O(^PSRX(J,"A",PSIIX)) Q:'PSIIX  I $P($G(^(0)),"^",2)="C",+$P(^(0),"^")>CNDT S CNDT=+$P(^(0),"^")
        Q:"AHPSDE"'[$E(ST)  S ^TMP($J,"PRF",CLASS,DRUG,FILLDATE,J)=$P(RX0,"^",1,14)_"^"_ST_"^"_$S($D(CNDT):CNDT,1:"") S:"AHPS"[$E(ST) ^TMP($J,"ACT",CLASS,DRUG)=""
        K CNDT Q
        ;
EXIT    K ^TMP($J,"PRF"),^("ACT"),PSOT,%DT,ADDR,ADDRFL,BY,CLASS,PCLASS,CLDT
        K CLINICX,CNDT,DFN,DHD,DRUG,FLDS,FR,CLAPP,HDFL,I,II,J,L,LINE,P,POP,PSDATE
        K PSDAYS,PSDOB,PSIIX,PSNAME,PSSN,PSTYPE,RX,RX0,RX2,RX3,RXN,ST,ST0,TO,VAR,Z1
        K APRT,DIE,DR,X,Y,DIC,ZTSAVE,PSORM,PSOUT,PSOPOLP,G,LM,PSDT,ZTDESC,ZTRTN,ZTSK
        K PSOIOS,PSONUM,PSOPOL,RXNO,X1,X2,RSLT,DIR,DIRUT,DTOUT,DUOUT
        K CS,DOD,GMRVSTR,PAGE,PSOBAR2,PSOBAR3,PSOBAR4,VA,VADM,VAPA,VAIN
        D ^%ZISC
        Q
ACT     ;
        S PSTYPE=1 G START
INFO    ;
        S PSTYPE=0 G START
        ;
QUE     ;prints clinics when queued
        I $P(FR,",",1)'="ALL" D CLINIC^PSOSDRAP
        I $P(FR,",",1)="ALL" D CLINALL^PSOSDRAP
        D EXIT
        Q
