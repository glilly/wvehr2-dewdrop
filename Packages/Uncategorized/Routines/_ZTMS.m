%ZTMS ;SEA/RDS-TaskMan: Submanager, (Entry & Trap) ;11/3/03  13:46
 ;;8.0;KERNEL;**2,18,24,36,67,94,118,127,136,162,275**;Jul 10, 1995
 ;
START ;Bottom level of submanager
 S $ETRAP="D ERROR^%ZTMS HALT"
 D NOW^%DTC S ZTQUEUED=0,U="^",DT=X
 D KMPR("$STRT ZTMS$")
 D PARAMS G:$D(ZTOUT) QUIT
 I ZTPFLG("XUSCNT") D COUNT^XUSCNT(1)
 D SETNM^%ZOSV("Sub "_$J)
 S ^%ZTSCH("SUB",ZTPFLG("HOME"),0)=0
 I $D(^%ZTSCH("STOP","SUB",ZTPAIR)) G QUIT
 I ZTPFLG("XUSCNT") D SETLOCK^XUSCNT($NA(^%ZTSCH("SUBLK",ZTPFLG("HOME"),$J)))
 G SUBMGR^%ZTMS1
 ;
KMPR(TAG) ;Call KMPR to log data
 N Y
 I +$G(^%ZTSCH("LOGRSRC")) S Y="" X $G(^%ZOSF("UCI")) I Y[^%ZOSF("PROD") D LOGRSRC^%ZOSV(TAG)
 Q
QUIT D KMPR("$STOP ZTMS$")
 I ZTPFLG("XUSCNT") D COUNT^XUSCNT(-1)
 Q
PARAMS ;
 ;START--lookup parameters
 X ^%ZOSF("PRIINQ") S %ZTMS("PRIO")=Y ;Get starting priority
 D GETENV^%ZOSV
 S ZTCPU=$P(Y,U,2),ZTNODE=$P(Y,U,3),ZTPAIR=$P(Y,U,4),ZTUCI=$P(Y,U)_$S(ZTCPU]"":","_ZTCPU,1:"") S:ZTPAIR[":" ZTNODE=$P(ZTPAIR,":",2)
 S ZTPFLG("RT")=0,ZTPFLG("MIN")=1,ZTYPE="",ZTPFLG("ZTREQ")=0
 S ZTPN=$O(^%ZIS(14.7,"B",ZTPAIR,0)),ZTPFLG("ZTPN")=ZTPN
 I ZTPN>0 S %=$G(^%ZIS(14.7,ZTPN,0)) D
 . S ZTPFLG("RT")=+$P(%,U,6),ZTYPE=$P(%,U,9) S:$P(%,U,12)>1 ZTPFLG("MIN")=$P(%,U,12)
 . S ZTPFLG("HOME")=$S($P(%,U,13):$P(^%ZIS(14.7,+$P(%,U,13),0),U),1:ZTPAIR)
 . S ZTPFLG("ZTREQ")=+$G(^%ZIS(14.7,ZTPN,3))
 . Q
 S ZTPFLG("XUSCNT")=0 I ^%ZOSF("OS")["GT.M" S ZTPFLG("XUSCNT")=$L($T(^XUSCNT))
 K ZTMLOG ;Set to log msg about locks
 I "FO"[ZTYPE S ZTOUT=1 Q  ;SM only run on C,P,G types
 Q
ERROR ;START--trap
 I $S(^%ZOSF("OS")["GT.M":$ZS["STACKO",1:$ZE["STKOVR"!($ZE["STACK")) S $ET="Q:$ST>"_($ST-8)_"  D ERR2^%ZTMS" Q
 ;set backup trap, prepare to handle error.
ERR2 S $ETRAP="D ERROR2^%ZTMS0 HALT"
 S %ZTERLGR=$$LGR^%ZOSV
 S %ZTME=$$EC^%ZOSV,ZTERROH=$H
 S %ZTMETSK=$S($D(%ZTTV)#2:$P(%ZTTV,"^",4),$G(ZTSK)>0:ZTSK,1:0)
 I %ZTMETSK L ^%ZTSK(%ZTMETSK) ;Unlock all other locks
 I $G(IO)]"" L +^%ZTSCH("DEV",IO) ;Keep other tasks from IO device.
 ;Check if to record error
 I '$$SCREEN^%ZTER(%ZTME) D
 . D ^%ZTER ;Kernel error file
 . ;log error and context in TaskMan Error file
 . L +^%ZTSCH("ER") H 1 S ZTERROH=$H
 . S ^%ZTSCH("ER",+ZTERROH,$P(ZTERROH,",",2))=%ZTME
 . D XREF^%ZTMS0
 . S ^%ZTSCH("ER",+ZTERROH,$P(ZTERROH,",",2),1)=ZTERROX1
 . L -^%ZTSCH("ER")
 . Q
 ;
 I $D(ZTDEVOK) S $P(^%ZTSCH("IO"),U,2)=ZTDEVOK ;Have others skip dev.
 ;Update Task file entry
 I $G(ZTQUEUED),%ZTMETSK,$D(^%ZTSK(%ZTMETSK)) D STATUS^%ZTMS0
 ;
 ;D KMPR("$ETRP ZTMS$")
 I ZTPFLG("XUSCNT") D COUNT^XUSCNT(-1)
 I ZTQUEUED>.9,%ZTMETSK>0,$G(DUZ)>.9,$D(^DD(8992,.01,0)) D
 . S XQA(DUZ)="",XQAMSG="Your task #"_%ZTMETSK_" stopped because of an error",XQADATA=%ZTMETSK,XQAROU="XQA^XUTMUTL"
 . D SETUP^XQALERT Q
 ;
CLEAN ;clean up global data related to this process
 I $G(ZTQUEUED)>.9,'$D(^%ZTSCH("TASK",ZTQUEUED,"P")) K ^%ZTSCH("TASK",ZTQUEUED)
 K ^TMP($J),^UTILITY($J),^XUTL("XQ",$J)
 I '$G(ZTQUEUED) D SUB^%ZTMS1(-1)
 I $D(ZTDEVN)#2,$D(%ZTIO)#2,%ZTIO]"" D DEVLK^%ZTMS1(-1,%ZTIO)
 I $D(ZTDEVOK)#2 D DEVBAD^%ZTMS0
 I $G(ZTSYNCFL)]"" S X=$$SYNCFLG^%ZTMS2("S",ZTSYNCFL,"","Stopped because of an error")
 ;
CLOSE ;close i/o device after error
 D ERCLOZ^%ZTMS0
 I $G(IO)]"" C IO H 5 ;In case of a port problem give it time to reset.
 ;
 D KMPR("$STOP ZTMS$")
 I ZTQUEUED=.5,%ZTMETSK>0,$P($G(^%ZTSK(%ZTMETSK,.12)),"^")<5 D  ;Only try 5 times
 . S $P(^(.12),"^")=^%ZTSK(%ZTMETSK,.12)+1
 . S ^%ZTSCH($$NEWH^%ZTMS2($H,600),%ZTMETSK)=""
 HALT  ;Start a new process to continue
 ;
GTM ;Special entry point for GT.M
 S $ZINTERRUPT="I $$JOBEXAM^ZU($ZPOSITION)"
 G START
