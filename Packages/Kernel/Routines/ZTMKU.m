ZTMKU ;SEA/RDS-Taskman: Option, ZTMWAIT/RUN/STOP ;11/04/99  15:05
 ;;8.0;KERNEL;**118,127,275,355**;Jul 10, 1995;Build 9
 ;
 Q
SSUB(NODE) ;Stop sub-managers
 D SS(1,"SUB",NODE) Q
SMAN(NODE) ;stop managers
 D SS(1,"MGR",NODE) Q
 ;
SS(MD,GR,NODE) ;Set/clear STOP nodes.
 S GR=$G(GR,"MGR") S:"MGR_SUB_"'[GR GR="MGR"
 I MD=1 S ^%ZTSCH("STOP",GR,NODE)=$H D WS(0,GR)
 I MD=0 K ^%ZTSCH("STOP",GR,NODE)
 Q
 ;
WS(MD,GR) ;Set/Clear Wait state
 S GR=$G(GR,"MGR") S:"MGR_SUB_"'[GR GR="MGR"
 I MD=1 S ^%ZTSCH("WAIT",GR)=$H ;set wait state
 I MD=0 K ^%ZTSCH("WAIT",GR) ;Clear wait
 Q
 ;
GROUP(CALL) ;Do CALL for each node, use NODE as the parameter
 N J,ND,NODE
 ;Get the Managers
 F J=0:0 S J=$O(^%ZTSCH("STATUS",J)) Q:J=""  S ND=$G(^(J)),NODE=$P(ND,"^",3) D @CALL
 ;Get any remote Sub-Managers
 S NODE="" F  S NODE=$O(^%ZTSCH("SUB",NODE)) Q:NODE=""  D @CALL
 Q
 ;
OPT(MD) ;Disable/Enable option prosessing
 I MD=1 S ^%ZTSCH("NO-OPTION")=""
 I MD=0 K ^%ZTSCH("NO-OPTION")
 Q
 ;
RUN ;Remove Task Managers From WAIT State
 D WS(0,"MGR"),WS(0,"SUB") K ^%ZTSCH("STOP") W !,"Done!",!
 Q
 ;
UPDATE ;Have Managers Do an parameter Update
 K ^%ZTSCH("UPDATE") W !,"Done!",!
 Q
 ;
WAIT ;Put Task Managers In WAIT State
 D WS(1,"MGR") W !,"TaskMan now in 'WAIT STATE'",$C(7)
 D QSUB
 Q
 ;
STOP ;Shut Down Task Managers
 N ZTX,ND,J
 F  R !!,"Are you sure you want to stop TaskMan? NO// ",ZTX:$S($D(DTIME)#2:DTIME,1:60) Q:'$T!("^YESyesNOno"[ZTX)  W:ZTX'["?" $C(7) W !,"Answer YES to shut down all Task Managers on current the volume set."
 I "^NOno"[ZTX W !,"TaskMan NOT shut down." Q
 W !,"Shutting down TaskMan." D GROUP("SMAN(NODE)")
 ;. F J=0:0 S J=$O(^%ZTSCH("STATUS",J)) Q:J=""  S ND=$G(^(J)) D SMAN($P(ND,U,3))
 ;. Q
 D QSUB
 Q
 ;
QSUB N ZTX,ND
 F  R !!,"Should active submanagers shut down after finishing their current tasks? NO// ",ZTX:$S($D(DTIME)#2:DTIME,1:60) Q:'$T!("^"[ZTX)!("YESyesNOno"[ZTX)  W:ZTX'["?" $C(7) W !,"Please answer YES or NO."
 D:"YESyes"[ZTX&(ZTX]"") GROUP("SSUB(NODE)") W !,"Okay!",!
 Q
 ;
QUERY ;Query Status Of A Task Manager
 Q:$D(%ZTX)[0  Q:%ZTX=""  S %ZTY=0
 I $D(^%ZTSCH("STATUS",%ZTX))#2 S %ZTY=^%ZTSCH("STATUS",%ZTX)
 K %ZTX Q
 ;
NODES ;Return Task Manager Status Nodes
 S %ZTX="" F %ZTY=0:0 S %ZTX=$O(^%ZTSCH("STATUS",%ZTX)) Q:%ZTX=""  S %ZTY=%ZTY+1,%ZTY(%ZTY)=%ZTX
 K %ZTX Q
 ;
LIVE ;Return Whether A Task Manager Is Live
 Q:$D(%ZTX)[0  Q:%ZTX=""  S %ZTY=0,U="^",%ZTX1=$H,%ZTX2=$P(%ZTX,U)
 S %ZTX3=%ZTX1-%ZTX2*86400+$P(%ZTX1,",",2)-$P(%ZTX2,",",2)
 I %ZTX3'<0 S %ZTY=$S($D(^%ZTSCH("RUN"))[0&(%ZTX'["WAIT"):0,%ZTX3<30:1,%ZTX3<120&(%ZTX["PAUSE"):1,1:0)
 K %ZTX,%ZTX1,%ZTX2,%ZTX3 Q
 ;
TABLE ;Display Task Manager Table
 W !,"NUMBER",?15,"STATUS",?25,"DESCRIPTION",?55,"LAST UPDATED",?75,"LIVE"
 W !,"------",?15,"------",?25,"-----------",?55,"------------",?75,"----"
 D NODES S %ZTZ=%ZTY,%ZTZ1=0,U="^",%H=$H D YMD^%DTC S DT=X
 F %ZTI=1:1:%ZTZ S %ZTX=%ZTY(%ZTI) D QUERY I %ZTY'=0 W !,%ZTY(%ZTI),?15,$P(%ZTY,U,2),?25,$P(%ZTY,U,3),?55 S %ZTT=$P(%ZTY,U) D T S %ZTX=%ZTY D LIVE W ?75,$S(%ZTY:"YES",1:"NO") I %ZTY S %ZTZ1=%ZTZ1+1
 W !?6,"Total:",$J(%ZTZ,3),!?6,"Live :",$J(%ZTZ1,3)
 K %ZTI,%ZTT,%ZTY,%ZTZ Q
 ;
CLEAN ;Cleanup Status Node
 K ^%ZTSCH("STATUS") W !,"Done!",! Q
PURGE ;Purge the TASK list of running tasks.
 N TSK S TSK=0
 F  S TSK=$O(^%ZTSCH("TASK",TSK)) Q:TSK'>0  I '$D(^%ZTSCH("TASK",TSK,"P")) K ^%ZTSCH("TASK",TSK)
 W !,"Done!",! Q
 ;
ZTM ;Return Number Of Live Task Managers
 D NODES S %ZTZ=%ZTY,%ZTZ1=0 F %ZTI=1:1:%ZTZ S %ZTX=%ZTY(%ZTI) D QUERY I %ZTY'=0 S %ZTX=%ZTY D LIVE I %ZTY S %ZTZ1=%ZTZ1+1
 S %ZTY=%ZTZ1 K %ZTI,%ZTZ,%ZTZ1 Q
 ;
T ;Print Informal-format Conversion Of $H-format Date ; Input: %ZTT, DT.
 S %H=%ZTT D 7^%DTC W $S(DT=X:"TODAY",DT+1=X:"TOMORROW",1:$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3))_" AT " S X=$P(%ZTT,",",2)\60,%H=X\60 W $E(%H+100,2,3)_":"_$E(X#60+100,2,3)
 K %,%D,%H,%M,%Y,X Q  ; Output: %ZTT, DT.
 ;
