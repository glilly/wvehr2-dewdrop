AAQXUTMQ ;FGO/JHS; TaskMan Waiting List ;08-07-97 [2/20/02 2:16am]
 ;;1.7;AAQ LOCAL;;Jun 3, 1998;For Kernel V8.0 and Cache/OpenM-NT
 ;;Revised version of XUTMQ
ENV ;Establish Routine Environment
 N %,%ZTF,%ZTI,%ZTJ,%ZTL,%ZTR,DDH,DIR,DIRUT,DTOUT,DUOUT,X,Y,ZT,ZT1,ZTENV,ZTKEY,ZTNAME,XUTMUCI S AAQX=""
 D ENV^XUTMUTL Q:'$D(ZTENV)
 D ^XQDATE X ^%ZOSF("UCI") S HDUV=Y
 I '+$O(^%ZTSK(0))&'$D(^%ZTSCH("TASK")) W !!,"The Task File is empty, and there are no tasks currently running." S DIR(0)="E" D ^DIR Q
SELECT ;Select listing (main loop)
 D FLAGS,IOQ
 I IOST["P-" W !!,"End of Report",@IOF
EXIT I $D(SVDTIME) S DTIME=SVDTIME
 K %X,%Y,%ZISOS,DIR,DIRUT,DTOUT,DUOUT,HDUV,IOT,POP,X,Y
 I $D(ZTQUEUED) K ZTDESC,ZTRTN,ZTSK D ^%ZISC,HOME^%ZIS S ZTREQ="@"
KEEP ; AAQX and SVDTIME are killed in AAQSOD or AAQMENU.
 Q   ; ZTQUEUED, ZTREQ are used to delete task and are not killed.
FLAGS ;Reset Taskman Files Status Flags
 S ZT1="",%ZTL=0 F  S ZT1=$O(^%ZTSCH("LINK",ZT1)) Q:ZT1=""  I $O(^%ZTSCH("LINK",ZT1,""))]"" S %ZTL=1 Q
 S ZT1="",%ZTJ=0 F  S ZT1=$O(^%ZTSCH("JOB",ZT1)) Q:ZT1=""  I $O(^%ZTSCH("JOB",ZT1,0))]"" S %ZTJ=1 Q
 S %ZTI=$D(^%ZTSCH("IO"))>9,%ZTF=+$O(^(""))!%ZTI!%ZTL!%ZTJ,%ZTR=$D(^%ZTSCH("TASK"))
 Q
IOQ ;Tasks waiting for devices.
 N DIR,DIRUT,DTOUT,DUOUT,X,ZT,ZT1,ZT2,ZT3,ZTC,ZTF,ZTH,ZTS S ZTC=0,ZTF=1,ZTH="Tasks waiting for devices"
 S ZT1="" F ZT=0:0 S ZT1=$O(^%ZTSCH("IO",ZT1)),ZT2="" Q:ZT1=""  F ZT=0:0 S ZT2=$O(^%ZTSCH("IO",ZT1,ZT2)),ZT3="" Q:'ZT2  F ZT=0:0 S ZT3=$O(^%ZTSCH("IO",ZT1,ZT2,ZT3)) Q:ZT3=""  D IOQ0 I (X=1)!(AAQX="^") G OUT
 I 'ZTC W !!,%Y,?30,"Tasks waiting for devices",?65,HDUV,!!,"There are no tasks waiting for devices on this volume set."
 Q:IOST["P-"  W ! S DIR(0)="E",DIR("A")=$S(ZTC:"End of listing.  ",1:"")_"Press RETURN to Continue" D ^DIR Q
IOQ0 ;IOQ--Extending Scope Of FOR Loop
 S ZTS=ZT3 D PRINT Q:X="^"
 Q
OUT ;Tag for breaking FOR scope to exit early
 Q
PRINT ;Subroutine--Print A Task
 N ZTSK W:'ZTC %Y,?30,ZTH,?65,HDUV,! W:'ZTF !,"-------------------------------------------------------------------------------"
 S X=0,ZTC=0,ZTF=0 D EN^XUTMTP(ZTS)
 I IOST["C-",$Y>18 S ZTF=1 R !!,"Press RETURN to Continue, '^' to Exit: ",AAQX:DTIME S X=AAQX Q:X="^"  W @IOF
 I IOST["P-",$Y+4>IOSL W @IOF,!,%Y,?30,"Tasks waiting for devices",?65,HDUV,!!
 S ZTC=ZTC+1 Q
DEV K %ZIS S %ZIS="MQ",%ZIS("B")="" D ^%ZIS I POP W !!,"No Device was Selected and no Report will be Printed." H 2 Q
 I '$D(IO("Q")),ION["P-MESSAGE" W $C(7),!,"If you select P-MESSAGE as the device, you must Queue the report." G DEV
 G:(IOT="VTRM") ENV
 I $D(IO("Q")) K IO("Q") S ZTDESC="Tasks waiting for devices",ZTRTN="ENV^AAQXUTMQ" D ^%ZTLOAD
 I $D(ZTQUEUED) W !!,"Request queued.",!! G EXIT
