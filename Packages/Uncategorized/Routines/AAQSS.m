AAQSS ;JHS/FGO;10/14/97; REVISED SYSTEM STATUS [12/3/03 7:03pm]
 ;;1.7;LOCAL;; For Kernel V8.0 and Intersystems Cache
 ;;Revised version of %ZAUG from at/jas; birmingham ocio/albany ocio
 K ZTSK,ZTQUEUED D GETENV S %ZIS="MQ" D ^%ZIS
 I $D(IO("Q")) K IO("Q") S ZTCPU=AAQVOL_":"_AAQSYS,ZTDESC="Revised System Status",ZTRTN="EN^AAQSS",ZTSAVE("^UTILITY($J,")="" D ^%ZTLOAD K ZIS
 I $D(ZTSK) W !!,"Request queued.",!! G EXIT
EN D GETENV I IOST["P-" U IO
 E  D HOME^%ZIS
 D ^XQDATE S $P(LINE,"-",IOM)="",PG=0,QUIT=0 D HDR
 K JOB S NJOB=0,NSYS=0,USER=""
 S SW10=$V(0,-2,$ZU(40,0,1))\1024#2
 S BASE=$V($ZU(40,2,47),-2,"S")
 S MAXPID=$V($ZU(40,2,118),-2,4)
 F I=1:1:MAXPID-1 S PID=$V($V($ZU(40,2,47)+((I\32)*$ZU(40,0,25)),-2,$ZU(40,0,25))+((I#32)*4),-2,4) S:PID JOB(I\1000,PID)=PID
 S JJ="" F  S JJ=$O(JOB(JJ)) Q:JJ=""  S KK="" F  S KK=$O(JOB(JJ,KK)) Q:KK=""  D  G:QUIT EXIT
 .S PID=JOB(JJ,KK),NJOB=NJOB+1
 .I ($ZU(67,0,PID)'=2) W !,?2,PID,?9,"************************",?51,"Ghost?, Check %SS" Q
 .S XX=$V(-1,PID),DEV=$P(XX,"^",3),PROG=$P(XX,"^",6),SPROG=$P(XX,"^",10),UCI=$P(XX,"^",14) D PORTS I $E(DEV,1,6)="|TRM|:" S DEV=$E(DEV,1,6)_"System Console",PROG="SystemJob"
 .I UCI'=AAQUCI,PROG="" S PROG=SPROG
 .S:'$D(^XUTL("XQ",PID,"DUZ")) USER="Unknown"
 .S:'$D(^XUTL("XQ",PID,0)) USER="System"
 .S:PROG["%ZTMS" USER="Task Submanager"
 .S:PROG="%ZTM" USER="Taskman Manager"
 .S:PROG="%mvbTCP" USER="Cache Thin Client"
 .I $D(^XUTL("XQ",PID,"DUZ")) S SVDUZ=^XUTL("XQ",PID,"DUZ") S:SVDUZ=0 SVDUZ=".5" S USER=$P(^VA(200,SVDUZ,0),"^",1)
 .I PROG="%ZISTCPS" D LIST
 .S:PROG="XWBTCPL" USER="RPC Broker Listener"
 .S:PROG="HLCSLM" USER="HL7 Link Manager"
 .S:PROG="XMKPLQ" USER="MailMan Background Mover"
 .S:PROG="XMTDT" USER="MailMan Background Tickler"
 .I USER="System" S NSYS=NSYS+1
 .W !,?2,PID,?9,PROG,?19,DEV,?51,USER
 .D:$Y>(IOSL-6) HDR
 W !!,?2,"Number of Processes: "
 ; NOTE: The number of user and system jobs will be different
 ; for %SS (system job) and AAQSS (user job).
 S NGLO=0 ; From Cache routine %SS
 F M=0:1:5 S NGLO=NGLO+($V($ZU(40,2,135)+(M*$ZU(40,0,1)),-2,$ZU(40,0,1))*(2**(11+M))/(1024*1024))
 S NGLO=$FN(NGLO,"",0)
 S NROU=$V($ZU(40,2,26),-2,$ZU(40,0,1))*32767/(1024*1024)
 S NROU=$FN(NROU,"",0)
 S NUSR=NJOB-NSYS ;number of user processes
 W NUSR_" user, "_NSYS_" system, "
 W NGLO_" mb global/"_NROU_" mb routine cache"
 I IOST?1"C-".E,'QUIT S X=$$RD(0)
EXIT K %Y,%ZIS,AAQLP,AAQPORT,AAQSERV,AAQSYS,AAQUCI,AAQUS,AAQVOL,AAQY4,BASE,DEV,DEV1,DEV2,I,JJ,JOB,KK,LINE,M,MAXPID,NGLO,NJOB,NROU,NSYS,NUSR
 K PG,PID,PROG,QUIT,SPROG,SVDUZ,SW10,UCI,USER,X,XX,Y,ZTCPU,ZTDESC,ZTRTN,ZTSAVE,ZTSK
 D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" Q
KEEP ; ZTQUEUED, ZTREQ are used to delete task and are not killed.
GETENV S U="^" D GETENV^%ZOSV S AAQUCI=$P(Y,"^",1),AAQVOL=$P(Y,"^",2),AAQY4=$P(Y,"^",4),AAQSYS=$P(AAQY4,":",2)
 I AAQSYS["MIR" S AAQSYS=$P(AAQSYS,"MIR")
 S AAQUS=AAQUCI_" on "_AAQSYS Q
LIST S AAQLP=$P(DEV,"|TCP|",2)
 I $E(AAQLP,1,2)=25 S USER="TCP/IP Mail Listener"
 E  S USER="HL7 Multi-Listener"
 Q
RD(X) W !!,"Press RETURN to "_$S(X:"Continue or '^' to Exit: ",1:"End: ")
 R X:15
 Q ($E(X)="^")
HDR I IOST?1"C-".E,PG'=0,'$D(ZTQUEUED),$$RD(1) S QUIT=1 Q
 S PG=PG+1 W @IOF,!?2,%Y,"   Revised System Status    ",AAQUS,?(IOM-12),"Page ",PG,!!
 W "  PID",?9,"Program",?19,"Device Used",?51,"Process Holder"
 W !,"  ===",?9,"=======",?19,"=============================",?51,"======================="
 Q
PORTS ;;Following code reformats port information to more readable format
 I $E(DEV,1,5)="|TNT|" S DEV1=$P(DEV,".",1),DEV2=$P(DEV,":",2),DEV=DEV1_":"_DEV2 Q
 S DEV1=$P($G(DEV),",",1),DEV2=$P($G(DEV),",",2)
 I DEV2="",$E(DEV1,1,6)="|LAT|M" S AAQSERV=$E(DEV,10,11),AAQPORT=$E(DEV,18,19),DEV="PORT "_AAQSERV_"/"_AAQPORT Q  ;EQN
 I $E(DEV1,1,6)="|LAT|M" S AAQSERV=$E(DEV1,10,11),AAQPORT=$E(DEV1,18,22),DEV="PORT "_AAQSERV_"/"_AAQPORT_","_DEV2 Q  ;EQN,null
 I $E(DEV2,1,6)="|LAT|M" S AAQSERV=$E(DEV2,10,11),AAQPORT=$E(DEV2,18,22),DEV=DEV1_","_"PORT "_AAQSERV_"/"_AAQPORT Q  ;null,EQN
 I $E(DEV,1,8)="|LAT|PCL" S DEV="WFW PC "_$E(DEV,10,21) Q  ;WFW311
 I $E(DEV,1,5)="|LAT|" S DEV1=$P(DEV,":",1),DEV="NT PC "_$E(DEV1,6,99) Q  ;SUPERLAT
 Q
