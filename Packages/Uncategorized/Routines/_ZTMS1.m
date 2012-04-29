%ZTMS1 ;SEA/RDS-TaskMan: Submanager, (Loop & Get Task) ;11/03/2003  13:31
 ;;8.0;KERNEL;**36,49,104,118,127,136,275**;JUL 10, 1995;
 ;
SUBMGR ;START--outer submanager loop
 D GETTASK G:ZTSK'>0 QUIT^%ZTMS ;task locked
 I $L($P($G(^%ZTSK(ZTSK,.1)),U,10)) D  G SUBMGR
 . D TSKSTAT("D","Stopped by User") S (ZTSK,ZTQUEUED)=0
 . Q
 D PROCESS^%ZTMS2 G:$D(ZTQUIT) QUIT^%ZTMS
 G SUBMGR
 ;
GETTASK ;SUBMGR--retain the partition; check Waiting Lists every 1 seconds
 D SUB(1) S ZTSK=0
 ;
 F ZRT=0:0 D  Q:$$EXIT  S %=$S($O(^%ZTSCH("JOB",0))>0:1,1:$R(1+$$SUB(0))+1),ZRT=ZRT+% H % ;Space out the SM loop
 . I $D(^%ZTSCH("WAIT","SUB")) H 5 Q  ;Wait
 . S %ZTIME=$$H3($H),ZTSK=0 I $D(^%ZTSCH("STOP","SUB",ZTPAIR)) Q
 . D C Q:ZTSK!(ZTYPE="C")  ;Do directed work before check for balance
 . I $$BALANCE S ZRT=ZRT-.4 Q  ;Wait for balance, Slow ZRT rise.
 . D JOB,IOQ:'ZTSK ;Look at last 2 lists
 . Q
 Q
 ;
EXIT() ;GETTASK--decide whether to exit retention loop
 I ZTSK,$D(^%ZTSCH("NO-OPTION")),$P(^%ZTSK(ZTSK,0),"^",1,2)="ZTSK^XQ1" D
 . D SCHTM^%ZTMS2(ZTDTH+60) S ZTSK=0
 . Q
 I ZTSK G YES
 I $D(^%ZTSCH("STOP","SUB",ZTPAIR)) G YES
 I ZTPFLG("RT")>ZRT G NO ;Retention time check
 I $$SUB(0)>ZTPFLG("MIN") G YES ;Let extras go
NO ;EXIT--Don't exit
 S ^%ZTSCH("SUB",ZTPFLG("HOME"),$J)=$H ;Keep our node current
 I ZTPFLG("XUSCNT") D SETLOCK^XUSCNT($NA(^%ZTSCH("SUBLK",ZTPFLG("HOME"),$J)))
 L ^%ZTSCH("SUBLK",ZTPFLG("HOME"),$J) Q 0
 ;
YES ;EXIT--adjust counter and set flags
 D SUB(-1)
 Q 1
 ;
C ;GETTASK--On C type volume sets, get tasks from Cross-Volume Job List
 I $O(^%ZTSCH("C",ZTPAIR,0))="" Q
 L +^%ZTSCH("C",ZTPAIR):1 I '$T D:$D(ZTMLOG) LOG^%ZTMS7("No Lock C")
 S ZTDTH="",^%ZTSCH("C",ZTPAIR)=0
 F  S ZTDTH=$O(^%ZTSCH("C",ZTPAIR,ZTDTH)),ZTSK=0 Q:ZTDTH=""  D  Q:ZTSK
 . F  S ZTSK=$O(^%ZTSCH("C",ZTPAIR,ZTDTH,ZTSK)),ZX=0 Q:ZTSK=""  D  Q:ZX
 .. I $D(^%ZTSK(ZTSK,0))[0!'ZTSK D  Q
 ... I ZTSK'=0,$D(^%ZTSK(ZTSK)) D TSKSTAT("I")
 ... K ^%ZTSCH("C",ZTPAIR,ZTDTH,ZTSK) S ZTSK=0
 ... Q
 .. L +^%ZTSK(ZTSK):0 Q:'$T
 .. S %ZTIO=^%ZTSCH("C",ZTPAIR,ZTDTH,ZTSK),ZTQUEUED=.5
 .. I %ZTIO]"" S ZTDEVN=1
 .. K ^%ZTSCH("C",ZTPAIR,ZTDTH,ZTSK)
 .. S ZX=1
 .. Q
 . Q
 ;I $D(^%ZTSCH("C",ZTPAIR))=1 K ^%ZTSCH("C",ZTPAIR)
 L -^%ZTSCH("C",ZTPAIR)
 Q
 ;
BALANCE() ;GETTASK--check load balance, and wait while Manager waits
 Q:ZTPAIR="" 0
 I $G(^%ZTSCH("LOADA",ZTPAIR)) Q 1
 Q 0
 ;
JOB ;GETTASK--search Partition Waiting List
 S ZTSK=0,ZTDTH=0,ZTQUEUED=0
 L +^%ZTSCH("JOBQ"):1 I '$T D:$D(ZTMLOG) LOG^%ZTMS7("No Lock JOBQ") Q
J2 S ZTDTH=$O(^%ZTSCH("JOB",ZTDTH)),ZTSK=0 I ZTDTH="" L -^%ZTSCH("JOBQ") Q
J3 S ZTSK=$O(^%ZTSCH("JOB",ZTDTH,ZTSK)),ZTQUEUED=0 I ZTSK'>0 G J2
 L +^%ZTSK(ZTSK):0 G J3:'$T
 I $D(^%ZTSCH("JOB",ZTDTH,ZTSK))[0 L -^%ZTSK(ZTSK) G J3
 I $D(^%ZTSK(ZTSK,0))[0 D BADTASK L -^%ZTSK(ZTSK) G J3
 S %ZTIO=^%ZTSCH("JOB",ZTDTH,ZTSK),ZTQUEUED=.5
 K ^%ZTSCH("JOB",ZTDTH,ZTSK) L -^%ZTSCH("JOBQ") ;Now can release JOBQ
 ;try and only pick up work for this node.
 S ZTREC=$G(^%ZTSK(ZTSK,0)),%=$P(ZTREC,U,14) I %[":",%'[ZTNODE D  G J3
 . S ^%ZTSCH("C",%,ZTDTH,ZTSK)=%ZTIO
 . Q
 I %ZTIO]"" S ZTDEVN=1
 Q
 ;
BADTASK ;JOB--unschedule tasks with bad numbers or incomplete records
 S %ZTIO=^%ZTSCH("JOB",ZTDTH,ZTSK) I %ZTIO]"" S ZTDEVN=1
 I ZTSK'=0,$D(^%ZTSK(ZTSK)) D TSKSTAT("I",3)
 K ^%ZTSCH("JOB",ZTDTH,ZTSK)
 S ZTQUEUED=0
 I %ZTIO]"" D DEVLK(-1,%ZTIO)
 Q
 ;
IOQ ;GETTASK--search Device Waiting List, Lock IO then DEV.
 S ZTSK=0 I '$D(^%ZTSCH("IO")) Q
 ;Lock to just to get last scan
 L +^%ZTSCH("IO"):0 I '$T D:$D(ZTMLOG) LOG^%ZTMS7("No Lock IO")
 S ZTI=$G(^%ZTSCH("IO")),ZTH=%ZTIME
 ;Keep 5 sec apart
 I $TR($$DIFF(%ZTIME,+ZTI,1),"-")'>5 L -^%ZTSCH("IO") D:$D(ZTMLOG) LOG^%ZTMS7("IO TIME") Q
 S $P(^%ZTSCH("IO"),"^")=%ZTIME,%ZTIO=$P(ZTI,"^",2)
 L -^%ZTSCH("IO")
I2 S %ZTIO=$O(^%ZTSCH("IO",%ZTIO)),ZTDTH="" I %ZTIO="" G IOX
 I $D(^%ZTSCH("IO",%ZTIO))<9 G I2
 S IOT=^%ZTSCH("IO",%ZTIO)
 I IOT'["RES" G I2:'$$DEVLK(1,%ZTIO) ;lock device if not RES.
 I '$D(^%ZTSCH("DEVTRY",%ZTIO)) S ^%ZTSCH("DEVTRY",%ZTIO)=%ZTIME ;Set problem device check
 S X=%ZTIO,X1=IOT,ZTDEVOK=X D DEVOK^%ZOSV I Y D DEVLK(-1,%ZTIO) G I2
I3 S ZTDTH=$O(^%ZTSCH("IO",%ZTIO,ZTDTH)),ZTSK=0 I ZTDTH="" D DEVLK(-1,%ZTIO) G I2
I5 S ZTSK=$O(^%ZTSCH("IO",%ZTIO,ZTDTH,ZTSK)) I ZTSK'>0 G I3
 L +^%ZTSK(ZTSK):0 G I5:('$T)
 S ZTQUEUED=.5 D DQ^%ZTM4 I $G(^%ZTSK(ZTSK,0))="" L -^%ZTSK(ZTSK) G I5
 S ZTH=%ZTIME-20 ;Leave ^%ZTSCH("DEV",io) locked, Released in %ZTMS2
IOX L +^%ZTSCH("IO"):0 S ^%ZTSCH("IO")=ZTH_"^"_%ZTIO L -^%ZTSCH("IO") ;Update anyway
 K ZTDEVOK,%ZISCHK
 Q
 ;
DEVLK(X,ZIO,TO) ;1=Lock/-1=unlock the ^%ZTSCH("DEV",ZIO) node.
 I X<0 L -^%ZTSCH("DEV",ZIO) Q
 L +^%ZTSCH("DEV",ZIO):(+$G(TO)) I '$T Q 0
 Q 1
 ;
SUB(X) ;Inc/Dec SUB or return SUB count
 N % L +^%ZTSCH("SUB",ZTPFLG("HOME")):5
 S %=+$G(^%ZTSCH("SUB",ZTPFLG("HOME"))) S:%<1 %=0
 I X>0 S ^%ZTSCH("SUB",ZTPFLG("HOME"))=%+1,^%ZTSCH("SUB",ZTPFLG("HOME"),$J)=$H
 I X<0 S ^%ZTSCH("SUB",ZTPFLG("HOME"))=$S(%>0:%-1,1:0) K ^%ZTSCH("SUB",ZTPFLG("HOME"),$J)
 L -^%ZTSCH("SUB",ZTPFLG("HOME"))
 Q:X=0 % Q
 ;
DIFF(N,O,T) ;Diff in sec.
 Q:$G(T) N-O ;For new seconds times
 Q N-O*86400-$P(O,",",2)+$P(N,",",2)
 ;
TSKSTAT(CODE,MSG) ;Update task's status
 S $P(^%ZTSK(ZTSK,.1),U,1,3)=$G(CODE)_U_$H_U_$G(MSG)
 Q
 ;
H3(%) ;Convert $H to seconds.
 Q 86400*%+$P(%,",",2)
H0(%) ;Covert from seconds to $H
 Q (%\86400)_","_(%#86400)
 ;
