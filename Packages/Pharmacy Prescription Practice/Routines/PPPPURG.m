PPPPURG ;ALB/GGP,DAD - ppp logfile purge routine ;03/13/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**2,5,21**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; purge any log entrys which are earlier than (today-days retained)
 ; days  =days retained
 ; pdate =purge date in fileman format (purge before this day)
 ; date  =date of current record
LOG ;
 N PURGE,BOGUS,DAYS,PDATE,DATE,X,Y,DIR,Y
 ;
 S DIR(0)="YA",DIR("A")="Purge entries in PPP LOG file: ",DIR("B")="NO"
 S DIR("?")="Enter yes to purge out entries in file." D ^DIR
 I Y D  Q
 .D LOG1 W !!,"RETAINED LAST "_$G(DAYS)_" DAYS, PURGED "_$G(PURGE)_" RECORDS.",!!,"PPP LOG file unchanged"
 Q
 ;
LOG1 ; -- purges entries from log file
 S PURGE=0
 S BOGUS=$$LOGEVNT^PPPMSC1(1019,"LOG1_PPPPURG")
 ; write log 'purge started'
 ;
 S DAYS=$P($G(^PPP(1020.1,1,0)),"^",11),X1=DT,X2=-DAYS+1 D C^%DTC S PDATE=X
 ;W !,PDATE
LOOP ;
 ;loop through date in 'c'->date index
 S DATE="" FOR X=0:0 D  Q:DATE=""
 .S DATE=$O(^PPP(1020.4,"C",DATE))  Q:DATE=""
 .S DA=""
 .;
 .; loop thru rec with same date, check date/delete
 .;
 .F Y=0:0 D  Q:DA=""
 ..S DA=$O(^PPP(1020.4,"C",DATE,DA))  Q:DA=""
 ..I (DATE<PDATE) D
 ...S DIK="^PPP(1020.4,"
 ...;W !,"PURGING= ",DA
 ...D ^DIK S PURGE=PURGE+1
EXIT ;
 ;write # of days retained, and # of records purged from logfile
 ;
 S BOGUS=$$LOGEVNT^PPPMSC1(1020,"_PPPPURG","RETAINED LAST "_$G(DAYS)_" DAYS, PURGED "_$G(PURGE)_" RECORDS.")
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
 ;
XREF ;
 ; purge any xref entrys which are earlier than (today-days retained)
 ; days  =days retained
 ; pdate =purge date in fileman format (purge before this day)
 ; date  =date of current record
 ;
 N PURGE,BOGUS,DAYS,PDATE,DATE,X,Y,DIR,Y
 ;
 S DIR(0)="YA",DIR("A")="Purge entries in PPP FOREIGN FACILITY XREF file: ",DIR("B")="NO"
 S DIR("?")="Enter yes to purge out entries in file." D ^DIR
 I Y D  Q
 .D XREF1
 .W !!,"RETAINED LAST "_$G(DAYS)_" DAYS, PURGED "_$G(PURGE)_" RECORDS."
 W !!,"PPP FOREIGN FACILITY XREF file unchanged"
 Q
 ;
XREF1 ; -- purges other facility Xref
 S PURGE=0
 S BOGUS=$$LOGEVNT^PPPMSC1(1021,"XREF1_PPPPURG")
 ; WRITE LOG 'XREF PURGE STARTED'
 ;
 S DAYS=$P($G(^PPP(1020.1,1,0)),"^",12)
 ; CALCULATE PURGE DATE
 S X1=DT,X2=-DAYS+1
 D C^%DTC S PDATE=X
 ;W !,PDATE
 ;
XREFLOOP ;
 ;DAVE B (PPP*1*21)
 ;Loop through "D" xref
 K DATE,PURGE
1 S DATE=$S('$D(DATE):$O(^PPP(1020.2,"D",0)),1:$O(^PPP(1020.2,"D",DATE))) G KLLQ:DATE'>0 S IFN=0
 I DATE>PDATE G 1
 ;
2 S IFN=$O(^PPP(1020.2,"D",DATE,IFN)) G 1:IFN'>0
 S DATA=$G(^PPP(1020.2,IFN,0))
 S DATA1=$G(^PPP(1020.2,IFN,1))
 S PATDFN=$S($P($G(DATA),"^")="":0,1:$P($G(DATA),"^"))
 S POV=$S($P($G(DATA),"^",2)="":0,1:$P($G(DATA),"^",2))
 K ^PPP(1020.2,"ARPOV",POV,PATDFN,IFN)
 K ^PPP(1020.2,"APOV",PATDFN,POV,IFN)
 S DA=IFN,DIK="^PPP(1020.2," D ^DIK S PURGE=$G(PURGE)+1 G 2
 ;
KLLQ K DATE,DATA,DATA1,PATDFN,POV,IFN Q
 ;
XREFEXIT ;
 ;write # of days retained, and # of records purged from xref
 ;
 S BOGUS=$$LOGEVNT^PPPMSC1(1022,"_PPPPURG","RETAINED LAST "_$G(DAYS)_" DAYS, PURGED "_$G(PURGE)_" RECORDS.")
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
SETUP1 ;queues background job to purge logfile data
 D NOW^%DTC S %DT="RAEX",%DT(0)=%,%DT("B")="NOW",%DT("A")="QUEUE JOBS TO RUN AT WHAT TIME: " D ^%DT S PSOQTIME=Y I $D(DTOUT)!(Y=-1) W !,"Try again later",! G OUT
 S ZTIO="",ZTRTN="LOG1^PPPPURG",ZTDTH=PSOQTIME,ZTDESC="PPP PURGE LOGFILE DATA" D ^%ZTLOAD
OUT K Y,X,PSOQTIME,%DT
 Q
 ;
SETUP2 ;queues background job to purge xref data
 D NOW^%DTC S %DT="RAEX",%DT(0)=%,%DT("B")="NOW",%DT("A")="QUEUE JOBS TO RUN AT WHAT TIME: " D ^%DT S PSOQTIME=Y I $D(DTOUT)!(Y=-1) W !,"Try again later",! G OUT2
 S ZTIO="",ZTRTN="XREF1^PPPPURG",ZTDTH=PSOQTIME,ZTDESC="PPP PURGE FORIEGN FACILITY XREF" D ^%ZTLOAD
OUT2 K Y,X,PSOQTIME,%DT
 Q
