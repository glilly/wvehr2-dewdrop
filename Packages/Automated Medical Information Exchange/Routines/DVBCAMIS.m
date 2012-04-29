DVBCAMIS ;ALB/GTS-557/THM-2507 AMIS REPORT ;21 MAY 89@0822 ; 5/23/91  1:30 PM
 ;;2.7;AMIE;**17**;Apr 10, 1995
 ;
 ;** NOTICE: This routine is part of an implementation of a Nationally
 ;**         Controlled Procedure.  Local modifications to this routine
 ;**         are prohibited per VHA Directive 10-93-142
 ;
SETUP S UPDATE="N",PREVMO=$P(^DVB(396.1,1,0),U,11),HD="AMIS 290 REPORT" I '$D(DT) S X="T" D ^%DT S DT=Y
 S DVBCDT(0)=$$FMTE^XLFDT(DT,"5DZ")
 D HOME^%ZIS S FF=IOF
 F JI="3DAYSCH","30DAYEX","PENDADJ","TRANSIN","TRNRETTO","TRNPNDTO","TRANSOUT","TRNRETFR","TRNPNDFR","INSUFF" S TOT(JI)=0
 F JI="RECEIVED","INCOMPLETE","DAYS","COMPLETED" S TOT(JI)=0
 F JI="P90","P121","P151","P181","P365","P366" S TOT(JI)=0
 ;
EN W @IOF,!?(IOM-$L(HD)\2),HD,!!!
 S %DT(0)=-DT,%DT="AE",%DT("A")="Enter STARTING DATE: " D ^%DT G:Y<0 EXIT S BDATE1=Y,BDATE=Y-.1
 S %DT="AE",%DT("A")="    and ENDING DATE: " D ^%DT G:Y<0 EN S EDATE1=Y,EDATE=Y+.5
 I EDATE1<BDATE1 W *7,!!,"Invalid date sequence - ending date is before starting date.",!! H 3 G EN
ASK0 W !!,"Please enter the total pending from the previous month: " R PREVMO:DTIME G:'$T!(PREVMO[U) EXIT I PREVMO["?" W !!,"Enter the totals for the month previous to the one you are processing." G ASK0
 I PREVMO'?1.4N!(PREVMO<0) W *7,!!,"Must be a number from 0 to 9999." G ASK0
 ;
ASK K %DT S SBULL="Y"
 W !!!,"Do you want to send a bulletin when processing is done"
 S %=1 D YN^DICN G:$D(DTOUT)!(%<0) EXIT
 I %=0 W !!,"Enter Y to send a bulletin to selected recipients or N not to send it at all.",!! G ASK
 I %'=1 S SBULL="N"
 I SBULL="Y" D BULL^DVBCAMI3
 W ! S %ZIS="AEQ",%ZIS("A")="Output device: " D ^%ZIS G:POP EXIT
 I $D(IO("Q")) S ZTRTN="GO^DVBCAMI2",ZTDESC="2507 Amis Report",ZTIO=ION F I="PREVMO","RO*","BDATE*","TOT*","EDATE*","SBULL","DUZ","DVBCDT(0)","XM*" S ZTSAVE(I)=""
 I $D(IO("Q")) D ^%ZTLOAD W:$D(ZTSK) !!,"Request queued",!! H 1 K ZTSK G EXIT
 G GO^DVBCAMI2
 ;
EXIT K PREVMO,UPDATE G KILL^DVBCUTIL
