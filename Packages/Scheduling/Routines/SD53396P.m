SD53396P ;VMP/RB - POST INIT FOR PATCH SD*5.3*396 ;09/30/04
 ;;5.3;Scheduling;**396**;AUG 13,1993
 ;
 ;Post init routine to locate ^SCE encounters that have a app't
 ;status of pending action (14), BUT a status of 'I' in
 ;the associated ^DPT(DFN,"S") node.  The app't status will be
 ;modified to '8' if condition found.
TASK ;
 ; Task the initial bad data determination as background process
 ;
 D NOW^%DTC
 ;Task process
 S ZTDTH=%H
 S ZTIO=""
 S ZTRTN="INIT^SD53396P",ZTDESC="^SCE O/P encounter status check for inpatients"
 D ^%ZTLOAD K ZTDTH,ZTRTN,ZTIO,ZTDESC
 I $D(ZTSK)&('$D(ZTQUEUED)) D BMES^XPDUTL("Task Queued!")
 Q
INIT ;
 ; Drives through ^SCE and finds all invalid entries.
 ; If entries are found to be invalid the entry is corrected
 ; and stored in temp print file
 ;
 N IEN,DFN,DATA,ESTS,SDAT,U,PDATE,SCHD,SSTS
 D NOW^%DTC
 S PDATE=+%H+60,U="^"
 S PDATE=$$HTFM^XLFDT(PDATE)
 L +^XTMP("SD53396P",0):1 I '$T Q
 K ^XTMP("SD53396P")
 S ^XTMP("SD53396P",0)=PDATE_"^"_X_"^"_"SCE encounter Clean Utility"
 L -^XTMP("SD53396P",0)
 S IEN=0
 F  S IEN=$O(^SCE(IEN)) Q:IEN=""!'IEN  D
 .S DATA=$G(^SCE(IEN,0)),SDAT=+$E($P(DATA,U),1,12),DFN=$P(DATA,U,2),ESTS=$P(DATA,U,12)
 .Q:ESTS'=14!'DFN
 .S SCHD=$G(^DPT(DFN,"S",SDAT,0)),SSTS=$P(SCHD,U,2)
 .Q:SSTS'="I"
 .S ^XTMP("SD53396P",IEN,0)=DFN_"^"_SDAT_"^"_ESTS_"^"_SSTS,^XTMP("SD53396P",IEN,1)=DATA,^XTMP("SD53396P",IEN,2)=SCHD
 .S $P(^SCE(IEN,0),U,12)=8
 .W !,IEN,?15,DFN,?30,SDAT,?50,ESTS,"/",SSTS
 S ZTREQ="@",^XTMP("SD53396P")="@"
 Q
REPORT ;
 ; Reports the entries that are have been cleaned up by the cleaning process
 ;
 I '$D(^XTMP("SD53396P")) W !!,"COMPILE AUDIT NOT RUN" Q
 I $G(^XTMP("SD53396P"))'="@" W !!,"COMPILE NOT COMPLETED" Q
 N POP,REC,DATA
 D ^%ZIS
 Q:POP
 I '$O(^XTMP("SD53396P",0)) W !!,"** NO ERRORS DETECTED **" Q
 W !!,"List of entries that SD*5.3*396 has determined to be incorrect AND FIXED",!!
 W "IEN",?10,"DFN",?20,"SCHED DT",?34,"STS",!
 S REC=0
 F  S REC=$O(^XTMP("SD53396P",REC)) Q:REC=""  D
 .S DATA=^XTMP("SD53396P",REC,0)
 .W !,REC,?10,$P(DATA,U),?20,$P(DATA,U,2),?34,$P(DATA,U,3),"/",$P(DATA,U,4),?40,$P(^DPT($P(DATA,U),0),U)
 . W !,?3,"SCE: ",$E(^XTMP("SD53396P",REC,1),1,70)
 . W !,?3,"DPT: ",$E(^XTMP("SD53396P",REC,2),1,70)
 Q
