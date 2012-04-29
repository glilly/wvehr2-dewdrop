AAQPRKIL ;FGO/PJP - Stop running Print jobs ;09/22/97 [8/28/01 10:38am]
 ;;1.0;Local;;
 ;
 ; This routine will kill a process and remove an associated task
 ; from the task list, %ZTSCH("TASK",). You will be prompted for a
 ; print device and the routine will search all running jobs and
 ; display the job tied to that Device.
 S FOUND=0 W ! S DIC="^%ZIS(1,",DIC(0)="AEMQZ",DIC("A")="Enter Printer Name: "  D ^DIC
 I Y=-1 G EXIT
 S PRINTER=$P(Y(0),"^",2)
 W !!,"If a print job is actively printing, answer the LOGOUT",!,"question with YES to continue with the kill process."
 W !!,"A print job stopped due to an Equinox port in XOFF state",!,"may resume printing after using LOGOUT to make the port available."
ASKLO S %=1 W !!,"Have you checked the port status to see if a LOGOUT is needed" D YN^DICN S AAQLO=% I %=0 W !!,"Answer 'Y' to continue with killing the job.",!,"Answer 'N' to check the port status first." G ASKLO
 I AAQLO=2 W !!,"Check the port, LOGOUT if needed, check port status for Accessed/Activity",!,"or us Examine Job to see if the job has resumed." R !!,"Press RETURN to continue:",DANS:15 W ! G EXIT
 ;; Taken from %ZAUG ;at/jas; birmingham ocio/albany ocio ;PROGRAM TO LIST JOBS AND PIDS
 S SW10=$V(0,-2,$ZU(40,0,1))\1024#2
 S BASE=$V($ZU(40,2,47),-2,"S")
 S MAXPID=$V($ZU(40,2,47)-(2*$ZU(40,0,4)),-2,4)
 F I=1:1:MAXPID S PID=$V(I*4+BASE,-3,4) S:PID JOB(PID)=PID
 S JJ="" F  S JJ=$O(JOB(JJ)) Q:(FOUND=1)!(JJ="")  D:$ZU(67,0,JJ)=2
 .S PID=JOB(JJ)
 .S XX=$V(-1,PID),PROG=$P(XX,"^",6),DEV=$P(XX,"^",3) S:PROG="" PROG="SystemJob"
 .I $G(^XUTL("XQ",PID,"DUZ")) S ZDUZ=^XUTL("XQ",PID,"DUZ") S:ZDUZ=0 ZDUZ=".5" S USER=$P(^VA(200,ZDUZ,0),"^",1)
 .; Do not allow the killing of a System Job or a % job.
 .I (DEV[PRINTER)&(PROG'["%")&(PROG'="SystemJob") D
 ..S FOUND=1
 ..S ^TMP($J,"DEV",PID)=XX
 ..S PADPID=PID_$E("      ",$L(PID)+1,6) ;pad pid for display
 ..S PADRTN=$P(XX,"^",6)_$E("           ",$L($P(XX,"^",6))+1,10) ;pad routine for display
 ..W !,!,"PID   ","ROUTINE   ","USER        ","       DEVICE "
 ..W !,"---   ","-------   ","----        ","       ------ "
 ..W !,PADPID,PADRTN,USER,"     ",$P(XX,"^",3),!
 ..D KILLIT
 I FOUND=0 W !,!,"...No job found using ",PRINTER,!
EXIT K %,AAQLO,BASE,DANS,DEV,DIC,FOUND,I,JJ,JOB,KILLED,MAXPID
 K PADPID,PADRTN,PID,PRINTER,PROG,RECORD,SW10,USER,TSK,TSKDEV,TSKPID,Y,XX,ZDUZ,ZTSK,^TMP($J,"DEV")
 Q
KILLIT K DIR
 S DIR(0)="Y"
 S DIR("A")="Are you sure you want to stop this process"
 S DIR("B")="NO"
 S DIR("?")="     Answer YES to kill the process."
 D ^DIR
 I 'Y W !,!,?5,"Tasks NOT stopped!",!
 I $D(DTOUT) W $C(7) G END
 K DIR,DIRUT,DTOUT,DUOUT
 I 'Y G END
 S KILLED=$$INT^ZZRESJOB(PID)
 I KILLED=0 W !,!,"...PROCESS DEAD OR NOT RESPONDING",!
 I KILLED=1 W !,!,"...PID# ",PID," has been stopped.",!
 S TSK=0 F I=0:0 S TSK=$O(^%ZTSCH("TASK",TSK)) Q:TSK=""  D
 .S RECORD=^%ZTSCH("TASK",TSK),TSKDEV=$P(RECORD,"^",6),TSKPID=$P(RECORD,"^",10)
 .I TSKPID=PID  D
 ..W !,"...PID# ",PID," was a tasked job.  Removing Task# ",TSK," from the task list.",! S ZTSK=TSK H 2
 ..L +^%ZTSCH("TASK",ZTSK)
 ..K ^%ZTSCH("TASK",ZTSK)
 ..W !?5,"...",ZTSK," removed."
 ..L -^%ZTSCH("TASK",ZTSK)
 ..W !?5,"...finished!",!
 ..R !,"...Press RETURN to continue:",DANS:15 W !
 Q
END S JJ=10000 ;Dirty exit should not have a process number higher
 Q
