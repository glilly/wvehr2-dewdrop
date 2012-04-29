MPIFSAQ ;SF/CMC-STAND ALONE QUERY ;JAN 12, 1998
 ;;1.0; MASTER PATIENT INDEX VISTA ;**1,3,8,13,17,21,23,28,35**;30 Apr 99
 ;
VTQ(MPIVAR) ;
 D VTQ^MPIFSA2(.MPIVAR)
 Q
 ;
INTACTV ;Interactive standalone query - Display Only patient doesn't have to be in Patient file
 S FLG=0 K DIR,X,Y S DIR(0)="Y",DIR("B")="YES",DIR("A")="Is Patient in the PATIENT file " D ^DIR
 G:(Y'=1)&(Y'=0) END
 I Y=1 S FLG=1 D PAT(.MPIVAR)
 I Y'=1,'$D(MPIVAR) D NOPAT(.MPIVAR)
 I '$D(MPIVAR("DFN"))&(FLG'=0) G END
 I +$G(MPIVAR("DOB"))'>0 W !,"DOB is missing - Required field" G END
 D VTQ^MPIFSA2(.MPIVAR) K DIR,X,Y,MPIVAR,FLG
 Q
END K DIR,X,Y,MPIVAR,DIRUT,DTOUT,DUOUT
 Q
CLEAN(NAM) ;NAM is the name to be cleaned up, Returned from this function is a clean name
 N YY,I
 I NAM?.E1L.E F I=1:1:$L(NAM) S:$E(NAM,I)?1L NAM=$E(NAM,0,I-1)_$C($A(NAM,I)-32)_$E(NAM,I+1,$L(NAM)) ; only uppercase
 F YY=", ","  " F  Q:'$F(NAM,YY)  S NAM=$E(NAM,1,($F(NAM,YY)-2))_$E(NAM,$F(NAM,YY),$L(NAM)) ; no space after comma and no double spaces
 F  Q:$E(NAM,$L(NAM))'=" "  S NAM=$E(NAM,1,$L(NAM)-1) ; no space at the end
 Q NAM
PAT(MPIVAR) ;patient is in local Patient file
PATA N DIC,X,Y,DIQ,DR,DA,MPIFAR,DFN,DTOUT,DUOUT
 S DIC="^DPT(",DIC(0)="AEQZM",DIC("A")="Patient Name: " D ^DIC
 G:$D(DTOUT)!($D(DUOUT))!(Y="^")!(X="") END
 I +Y=-1 W !,"Patient not found.  Try Again" G PATA
 S (DFN,MPIVAR("DFN"))=+Y,MPIVAR("NM")=$P(Y(0),"^"),DIQ="MPIFAR",DR=".09;.03;.02",DIC="^DPT(",DA=+Y,DIQ(0)="I" D EN^DIQ1 K DA
 S MPIVAR("DOB")=$G(MPIFAR(2,DFN,.03,"I")),MPIVAR("SSN")=$G(MPIFAR(2,DFN,.09,"I")) I MPIVAR("SSN")["P" S MPIVAR("SSN")=""
 S MPIVAR("SEX")=$G(MPIFAR(2,DFN,.02,"I"))
 Q
NOPAT(MPIVAR) ; patient is not in the local Patient file
NAME N DTOUT,DUOUT,DIR,X,Y,%
 S DIR(0)="FU^::",DIR("A")="PATIENT NAME (last,first middle)" D ^DIR
 G:$D(DTOUT)!($D(DUOUT))!(Y="^") END
 I (Y="")!($L(Y)>45)!($L(Y)<3) W !,"Name should be Last,first middle and at least 3 characters and no more than 30" G NAME
 I (Y?1P.E)!(Y'?1U.ANP)!(Y'[",")!(Y[":")!(Y[";") W !,"Name should be Last,first middle and at least 3 characters and no more than 30" G NAME
 I Y'?.UNP F %=1:1:$L(Y) I $E(Y,%)?1L S Y=$E(Y,0,%-1)_$C($A(Y,%)-32)_$E(Y,%+1,999)
 S MPIVAR("NM")=$$CLEAN(Y)
DOB K DIR,X,Y S DIR(0)="DU^::AE",DIR("A")="Date of Birth" D ^DIR
 G:$D(DTOUT)!($D(DUOUT)) END
 S MPIVAR("DOB")=Y
SSN ; ssn is optional
 K DIR,X,Y S DIR(0)="FUO^9:9:",DIR("A")="9 Digit SSN (No Dashes)" D ^DIR
 G:$D(DTOUT)!($D(DUOUT)) END
 I Y'="",Y'?9N W !,"SSN should be 9 numbers" G SSN
 S MPIVAR("SSN")=Y
 Q
SEG(SEGMENT,PIECE,CODE) ;Return segment from MPIDC array and kill node
 N MPINODE,MPIDATA,MPIDONE,MPIC,HOLD K MPIDONE
 I '$D(MPIC) S MPIC=$E(HL("ECH"))
 S MPINODE=0
 F  S MPINODE=$O(MPIDC(MPINODE)) Q:MPINODE=""!($D(MPIDONE))  D
 .S MPIDATA=MPIDC(MPINODE)
 .I ($P(MPIDATA,HL("FS"),1)=SEGMENT)&($P($P(MPIDATA,HL("FS"),PIECE),MPIC,1)=CODE) S MPIDONE=1 S HOLD(MPINODE)="" D
 ..I SEGMENT="RDT" F  S MPINODE=$O(MPIDC(MPINODE)) Q:MPINODE=""  Q:MPIDC(+MPINODE)=""  S MPIDATA=MPIDATA_MPIDC(MPINODE),HOLD(MPINODE)=""
 I $D(MPIDONE) S MPINODE=0 F  S MPINODE=$O(HOLD(MPINODE)) Q:MPINODE=""  K MPIDC(MPINODE)
 Q:$D(MPIDONE) $G(MPIDATA)
 Q ""
