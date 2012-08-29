RAPM3 ;HOIFO/SM-Radiology Performance Monitors/Indicator ;1/5/04  11:11
 ;;5.0;Radiology/Nuclear Medicine;**37,44,63,67**;Mar 16, 1998
 ;; IA #11090 allows Fileman read of Entire file 4
 Q
EN1 ;entry/edit OUTLOOK mail groups
 N RA1,RA2
 S RA1=$O(^RA(79,0)) Q:'RA1
 I $O(^RA(79,RA1,1,0)) D
 . W !?5,"OUTLOOK mail groups previously entered:",!?56,"OQP Perf. Mgmt?",!?56,"--------------"
 . S RA2=0
 . F  S RA2=$O(^RA(79,RA1,1,RA2)) Q:'RA2  W !?8,$P(^(RA2,0),U),?63,$P(^(0),U,2)
 . Q
 W !!?5,"You may add another mail group."
 W !,?5,"To edit or replace a mail group, you must delete the old one first.",!
 L +^RA(79,RA1,1):1 I '$T W !,$C(7),"Can't lock ^RA,",RA1,",1) now, try again later." Q
 S DIE="^RA(79,",DA=RA1,DR="175"
 D ^DIE
 L -^RA(79,RA1,1)
 Q
TASKLM ; task off last month's Perf. Indic. Summary Report [RA PERFORMIN TASKLM]
 ; define report type as summary
 N RA1,RA2,RA3,RABDATE,RAEDATE,RADAYS,RAENDDT,RABEGDT,RAUTOM,RALASTM
 N M1,M2,X1,X2,Y1,Y2
 ; RALASTM flags this option RA PERFORMIN TASKLM, queued or interactive
 S RALASTM=1
 ; if tasked here, set RAUTOM to flag automatic queued mid-month report
 I $D(ZTQUEUED) S RAUTOM=1
 ; if interactive, display Outlook mail groups and ask if continue
 I '$D(ZTQUEUED) D  I 'RA3 W !!?5,"** Nothing Done **" Q
 . W !!?5,"The Summary Report of Last Month's data will be sent to the"
 . W !?5,"Outlook mail group(s) in File 79's PERF INDC SMPT E-MAIL ADDRESS"
 . W !?5,"with ""N"" defined for OQP Performance Management."
 . S RA1=$O(^RA(79,0))
 . I '$O(^RA(79,RA1,1,0)) S RA3=0 W !?5,"** There is no Outlook mail group defined in File 79's",!?8,"PERF INDC SMTP E-MAIL ADDRESS. **",! Q
 . S RA2=0
 . W !?56,"OQP Perf. Mgmt?",!?56,"---------------"
 . F  S RA2=$O(^RA(79,RA1,1,RA2)) Q:'RA2  W !?3,$P(^(RA2,0),U),?63,$P(^(0),U,2)
 . W !
 . D HQASK^RAPM4
 . S DIR(0)="Y"
 . S DIR("A",1)=""
 . S DIR("A")="  Do you want to continue"
 . D ^DIR S RA3=Y
 . Q:'RA3
 . ; ask Task Start Time
 . W !!?5,"The requested start time must be within day 10 through the last",!?5,"day of the current month.",!
 . ; find end day of current month
 . S Y1=$E(DT,1,3),M1=$E(DT,4,5)
 . S Y2=$S(M1="12":Y1+1,1:Y1),M2=$S(M1="12":"01",1:M1+1)
 . S:$L(M2)=1 M2="0"_M2
 . S RA1=Y1_M1_"10"
 . S RA2=Y2_M2_"01"
 . S X2=RA1,X1=RA2 D ^%DTC
 . S X2=X-1,X1=RA1 D C^%DTC S RA2=X
 . S DIR(0)="D^"_RA1_":"_RA2_":AE"
 . S DIR("A",1)="  Enter date to start this Task"
 . S DIR("A")="  (time will be the same hh:mm as now.)"
 . S DIR("?",1)="   The Task date must be at least 10 days from the"
 . S DIR("?")="   beginning of this month through the end of this month."
 . D ^DIR
 . S:$D(DIRUT) RA3=0
 . S ZTDTH=Y_"."_$P(($$NOW^XLFDT),".",2)
 . Q
 K ^TMP($J)
 S RARAD="" ; all radiologists
 S RARPT="S",RAANS=0,RAANS2=1 ; summary, no local mail, send Outlook mail
 ; define LAST MONTH'S begin and end dates
 S Y1=$E(DT,1,3),M1=$E(DT,4,5) ; current month
 S Y2=$S(M1="01":Y1-1,1:Y1),M2=$S(M1="01":12,1:M1-1) ; last month
 S:$L(M2)=1 M2="0"_M2
 S RA1=Y1_M1_"01" ; Current year and month, 1st day of month
 S RABDATE=Y2_M2_"01" ; Begin date for last month
 S X1=RA1,X2=RABDATE D ^%DTC S RADAYS=X ; No. days in last month
 S X2=(RADAYS-1),X1=RABDATE D C^%DTC S RAEDATE=X ; End date last month
 S RAENDDT=RAEDATE_.9999 ; convert for search loop
 S RABEGDT=(RABDATE-1)_.9999 ; convert for search loop
 ; define divisions that have at least 1 active img loc
 S RA1=0
 F  S RA1=$O(^RA(79,RA1)) Q:'RA1  D
 . S RA2=0
 . ;if div has at least 1 active img loc, then store div in ^tmp
 . F  S RA2=$O(^RA(79,RA1,"L",RA2)) Q:'RA2  I $D(^(RA2,0)),$P($G(^RA(79.1,+^(0),0)),U,19)="" S RA3=$$GET1^DIQ(4,RA1,.01),^TMP($J,"RA D-TYPE",RA3,RA1)="" Q
 ; define imaging types if not vascular lab but has file 79.1 BIMG xref
 S RA1=0
 F  S RA1=$O(^RA(79.2,RA1)) Q:'RA1  D
 . I $D(^RA(79.2,RA1,0)) S RA2=$P(^(0),U) I RA2'["VASCULAR LAB",$D(^RA(79.1,"BIMG",RA1)) S ^TMP($J,"RA I-TYPE",RA2,RA1)=""
 ; task job
 S ZTIO=""
 D TASK^RAPM
 S X1=ZTDESC,X2=ZTDTH ; save taskman vars
 D ^%ZTLOAD
 I +$G(ZTSK("D"))>0,$D(ZTSK) D
 . W !?5,*7,"Request queued: ",X1
 . W !?5,"to start on: ",$$FMTE^XLFDT(X2)
 . W !?5,"Task #: "_$G(ZTSK)
 K ^TMP($J)
 Q
RESCH ; reschedule option that is in file 19.2
 N RABY,RADT,RAERR,RAWHEN,RAFLAG
 N D1,M1,Y1,M2,Y2,X
 ; RAFLAG="" determines if allow LAYGO to file 19.2, if the option "RA 
 ; PERFORMIN TASKLM" was installed in file 19.2, RAFLAG = "",
 ; if not installed, then RAFLAG = "L"
 S RAFLAG=""
 ; get task status of option
 D OPTSTAT^XUTMOPT("RA PERFORMIN TASKLM",.RAR)
 I $P($G(RAR(1)),U) D EN^DDIOL("** Option RA PERFORMIN TASKLM is already scheduled, so nothing done. **",,"!!?5") D PRESS Q
 I '$D(RAR(1)) D
 . D EN^DDIOL("** Option RA PERFORMIN TASKLM has not been installed into file 19.2 **",,"!!?5")
 . D EN^DDIOL("** will install it into file 19.2 now. **",,"!!?5")
 . S RAFLAG="L"
 . Q
 ; task the option that seems to be lost from the task queue
 D SET15
 D EN^DDIOL("Now scheduling RA PERFORMIN TASKLM to run on: ",,"!!?5")
 D RESCH^XUTMOPT("RA PERFORMIN TASKLM",RAWHEN,,RABY,RAFLAG,.RAERR)
 D OPTSTAT^XUTMOPT("RA PERFORMIN TASKLM",.RAR)
 I $D(RAR(1))#2 D EN^DDIOL("Task number :   "_+RAR(1),,"!!?37")
 D PRESS
 Q
PRESS R !!?5,"Press RETURN to continue. ",X:DTIME
 Q
SET15 ; set some variables for scheduling task
 S Y1=$E(DT,1,3),M1=$E(DT,4,5),D1=$E(DT,6,7)
 S Y2=$S(M1="12":Y1+1,1:1),M2=$S(M1="12":"01",1:M1+1)
 S:$L(M2)=1 M2="0"_M2
 D:D1=15 TODAY D:D1<15 THISM D:D1>15 NEXTM
 S RAWHEN=$$FMADD^XLFDT(RADT,,,5) ; add 5 mins to scheduled date
 S RABY="1M(15)" ; every month on the 15th day
 Q
TODAY ; today is the 15th
 S RADT=$$NOW^XLFDT
 Q
THISM ; this month on the 15th
 S RADT=Y1_M1_"15."_$P(($$NOW^XLFDT),".",2)
 Q
NEXTM ; next month on the 15th
 S RADT=Y2_M2_"15."_$P(($$NOW^XLFDT),".",2)
 Q
SFOOT ; Footer for Summary Report
 G:'RAIO SFOOT2
 I ($Y+5)>IOSL,IO=IO(0) D
 . I $E(IOST,1,2)="C-" R !,"Press RETURN to continue.",X:DTIME
 . S RAPG=RAPG+1,RAHDR="Summary Verification Timeliness Report"
 . W @IOF,!?(RAIOM-$L(RAHDR)\2),RAHDR,?(RAIOM-10),"Page: ",$G(RAPG)
 W !!?5,"* Columns represent # of hours elapsed from exam date/time through",!?7,"date/time report entered or date/time report was verified."
 W !?7,"e.g. "">0-24 Hrs"" column represents those exams that had a report"
 W !?7,"transcribed and/or verified within 0-24 hours from the exam date/time."
 W !!?5,"* Columns following the initial elapsed time column "">0-24 Hrs"" begin"
 W !?7,"at .0001 after the starting hour (e.g. "">24-48 Hrs"" = starts at 24.001",!?7,"through the 48th hour.)",!
 W !?5,"* PENDING means there's no data for DATE REPORT ENTERED or VERIFIED DATE."
 W !?7,"So, if the expected report is missing one of these fields, or is missing"
 W !?7,"data for fields .01 through 17 from file #74, RAD/NUC MED REPORTS, or"
 W !?7,"is a Stub Report that was entered by the Imaging package when images"
 W !?7,"were captured before a report was entered, then the expected report"
 W !?7,"would be counted in the PENDING column."
 ;
SFOOT2 ; store in tmp
 S (^TMP($J,"RAPM",RAN),^TMP($J,"RAPM",RAN+1))="",RAN=RAN+1
 ;
 S ^TMP($J,"RAPM",RAN)="    * Columns represent # of hours elapsed from exam date/time through",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      date/time report entered or date/time report was verified.",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      e.g. "">0-24 Hrs"" column represents those exams that had a report",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      transcribed and/or verified within 0-24 hours from the exam date/time.",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="    * Columns following the initial elapsed time column (0-24 Hrs) begin",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      at .0001 after the starting hour (e.g. "">24-48 Hrs"" = starts at 24.001",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      through the 48th hour.)",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="    * PENDING means there's no data for DATE REPORT ENTERED or VERIFIED DATE.",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      So, if the expected report is missing one of these fields, or is missing",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      data for fields .01 through 17 from file #74, RAD/NUC MED REPORTS, or",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      is a Stub Report that was entered by the Imaging package when images",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      were captured before a report was entered, then the expected report",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      would be counted in the PENDING column."
 D BFOOT
 Q
BFOOT ;footer for both
 G:'RAIO BFOOT2
 W !!?5,"* A printset, i.e., a set of multiple exams that share the same report,",!?7,"will be expected to have 1 report."
 W !!?5,"* Cancelled and ""No Credit"" cases are excluded from this report."
BFOOT2 ; used in summary
 Q:'$G(RAN)
 S RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="    * A printset, i.e., a set of multiple exams that share the same report,",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="      will be expected to have 1 report.",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="",RAN=RAN+1
 S ^TMP($J,"RAPM",RAN)="    * Cancelled and ""No Credit"" cases are excluded from this report."
 Q
RADIOL ; select Radiologist for Summary Report
 W !
 S DIC("S")="I $D(^VA(200,""ARC"",""R"",Y))!($D(^VA(200,""ARC"",""S"",Y)))",DIC("A")="Select Primary Interpreting Staff Physician (Optional): ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC Q:Y<0  S RARAD=+Y
 Q
