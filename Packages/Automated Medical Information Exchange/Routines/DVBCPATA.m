DVBCPATA ;ALB/JLU,557/THM-ADD NEW VET TO FILE #2 ; 10/4/91  9:22 AM
 ;;2.7;AMIE;**1,23,40,42,55,77**;Apr 10, 1995
 ;
EN ;determine if new patient
 S OLDHD1=HD1,HD1="Additional Veteran Information"
 K DVBCNEW,OUT,EDIT
 S DIC="^DPT(",DIC(0)="AELMQ",DLAYGO=2
 D ^DIC
 K DLAYGO
 I Y<0 S OUT=1 D EXIT1 Q
 S DVBADA=+Y
 I $P(Y,U,3) S DVBCNEW=1 D MPI(,DVBADA)
 S DA=DVBADA
 ;
ADDR I '$D(DVBCNEW) S DTA=^DPT(DA,0),PNAM=$P(DTA,U,1),SSN=$P(DTA,U,9),DFN=DA,CNUM=$S($D(^DPT(DFN,.31)):$P(^(.31),U,3),1:"Unknown") S:CNUM="" CNUM="Unknown"
 ;
ASK K %Y I '$D(DVBCNEW) D ADDR^DVBCUTIL W !,"Is this the correct Veteran" S %=2 D YN^DICN I $D(DTOUT)!(%<0) S OUT=1 G EXIT
 I $D(%Y) I %Y["?" W !!,"Enter Y if it is the correct Veteran, N to reselect",! G ASK
 K %Y I '$D(DVBCNEW),$D(%),%'=1 D CLR G EN
 ;
ASKED1 I $D(EDIT) S DIE="^DPT(",DR="W @IOF,!,""Edit Veteran Data"",!!!;.02;.09;.313;.314;.361;.525;.323;1901;.111;.112:.115;.1112;.117;.131;.132;.326;.327" D ^DIE S EDIT=1
 ;
ASKED2 I $D(EDIT) W !!,"Want to edit it again" S %=1 D YN^DICN G:%=1 ASKED1 S:$D(DTOUT)!(%<0) OUT=1 I $D(OUT) G EXIT
 I $D(%Y),%Y["?" W !!,"Enter Y to edit the information again or N to skip.",!! H 3 G ASKED2
 W !! G EXIT1:'$D(DVBCNEW)
 S DIE("NO^")="BACKOUTOK",DIE="^DPT(",DR="[DVBA C ADD 2507 PAT]" D ^DIE K DIE("NO^") S EDIT=1
 I $D(DVBACPLT),DVBACPLT=0 DO
 .;Aborting C&P request due to incomplete Patient required information.
 .N VAR
 .S VAR(1,0)="1,5,0,2,0^...Error, required information missing!...."
 .S VAR(2,0)="0,7,0,1:2,0^...Unable to complete, Request aborted!....."
 .D WR^DVBAUTL4("VAR")
 .D CONTMES^DVBCUTL4
 .S OUT=""
 .K VAR
 I $D(DVBACPLT),DVBACPLT=0 D EXIT1 QUIT  ;**QUIT w/out D EXIT
 ;
EXIT S DTA=^DPT(DA,0),PNAM=$P(DTA,U,1),SSN=$P(DTA,U,9),DFN=DA,CNUM=$S($D(^DPT(DFN,.31)):$P(^(.31),U,3),1:"Unknown") S:CNUM="" CNUM="Unknown"
 I $D(DVBCNEW) S XMB="DVBA C NEW C&P VETERAN",XMB(1)=PNAM,XMB(2)=SSN,XMB(3)=$S($D(^VA(200,+DUZ,0)):$P(^(0),U),1:"Unknown user"),Y=DT X ^DD("DD") S XMB(4)=Y D ^XMB
EXIT1 S HD1=OLDHD1 K OLDHD1,DIC,DIE,DR,%,%Y,DTA,X,Y,DVBCNEW,DVBADA,DVBACPLT Q
 ;
CLR W @IOF,!?(IOM-$L(HD1)\2),HD1,!!
 Q
MPI(DVBBKMSG,DFN) ;MPI call to set ICN
 ;check to see if CIRN PD/MPI is installed
 I $D(DG20NAME) K DG20NAME
 N X S X="MPIFAPI" X ^%ZOSF("TEST") Q:'$T
 K MPIFRTN
 S MPIFS=1
 D MPIQ^MPIFAPI(DFN)
 K MPIFRTN
 Q
