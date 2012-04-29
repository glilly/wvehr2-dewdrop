%ZTMS3 ;SEA/RDS-TaskMan: Submanager, Part 5 (Run Task) ;07/20/2005  13:54
 ;;8.0;KERNEL;**1,18,36,49,64,67,94,118,127,136,175,275,355**;Jul 10, 1995;Build 9
 ;
TASK ;SUBMGR--prepare and run task; cleanup after
 ;
BEFORE ;prepare task
 ;submanager's variables
 S ZTDEF=""
 S X=$O(^%ZIS(14.7,"B",ZTPAIR,""))
 I X]"",$D(^%ZIS(14.7,X,0))#2 S ZTDEF=^(0)
 S DUZ=+$P(ZTREC,U,3)
 S %ZTTV=ZTUCI_U_IOS_U_U_ZTSK_U_IO_U_IOT_U_ZTCPU_U_ZTNODE_U_DUZ_U_U_IOF_U_IOST_U_ZTPAIR_U_ZTYPE_U
 S %ZTTV(0)=ZTRTN_U_$P(ZTREC,U,8,9)_U_$P(ZTREC,U,6)_U_ION_U_ZTUCI_U_$P(ZTREC,U,5)_U_$S($L($P(ZTREC,U,10)):$P(ZTREC,U,10),1:$P(ZTREC,U,3))_U_$J_U_ZTSYNCFL_U_ZTPAIR_U
 ;
 I +$G(^%ZTSCH("LOGRSRC")) S %ZTTV(1)="!"_$S($P(ZTREC,U,9)="":$P(ZTREC,U,2),1:$P(ZTREC,U,9))
 ;
 ;external calls
 D NOW^%DTC S DT=% ;DT is Date.time at this point.
1 D SETNM^%ZOSV($E("BTask ",(ZTIO]"")+1,6)_(ZTSK#100000000))
 ;
 ;priority (Not done in the VA)
 ;S X=$P(ZTREC,U,15)
 ;S X=$S(+X'=X:0,X'<1&(X'>10):X\1,1:0)
 ;S Y=$S(IOS="":0,$D(^%ZIS(1,+IOS,0))[0:0,1:+$P(^(0),U,5))
 ;S Y=$S(Y'<1&(Y'>10):Y\1,1:0)
 ;S X=$S(Y:Y,X:X,$P(ZTDEF,U,4):$P(ZTDEF,U,4),1:10)
 ;X ^%ZOSF("PRIORITY")
 ;
2 ;restore saved variables
 S X=$O(^XTV(8989.3,1,4,"B",ZTCPU,0)) S:$P($G(^XTV(8989.3,1,4,+X,0)),U,6)="y" XRTL=ZTUCI
 K %,%H,%I,%ZTI,%ZTIO,IO("C"),IO("T"),X,Y,ZTCPU,ZTDEF,ZTIOST,ZTIOT,ZTNODE,ZTPAIR,ZTREC,ZTREC2,ZTREC21,ZTREC25,ZTUCI
 K ^TMP($J),^UTILITY($J),^XUTL("XQ",$J)
 S DUZ(0)="" D RESTORE^%ZTMS4
 ;
 ;force values, DTIME=1 so HFS reads work under Cache
 S DUZ=+DUZ,DTIME=1,ZTDESC=$G(^%ZTSK(ZTSK,.03)),ZTDTH=$H
 I DUZ(0)="" S DUZ(0)=$S($D(^VA(200,DUZ,0))#2:$P(^(0),U,4),1:"")
 I $D(DUZ(2))[0 S DUZ(2)=$S($D(^VA(200,DUZ,2,0)):$O(^(0)),1:0)
 S ^XUTL("XQ",$J,0)=DT,^("ZTSK")=ZTDESC,^("ZTSKNUM")=ZTSK
 S X="DUZ" F  S X=$Q(@X) Q:X=""  I $D(@X) S ^XUTL("XQ",$J,$TR(X,""""))=@X
 F X="DUZ","IO","IOBS","IOF","IOM","ION","IOS","IOSL","IOST","IOST(0)","IOT","IOXY","XQVOL" I $D(@X) S ^XUTL("XQ",$J,X)=@X
3 ;
 ;final checks & sets
 I '$D(^%ZTSK(ZTSK)) S ZTTASK=0 D AFTER Q
 I $L($P($G(^%ZTSK(ZTSK,.1)),U,10)) D  Q
 . D TSKSTAT("D","Stopped by User")
 . S ZTTASK=0
 . D AFTER
 D TSKSTAT(5,"Started Running",$J)
 S ZTQUEUED=ZTSK,ZTSTAT="1 General error"
 S ^%ZTSCH("TASK",ZTSK)=%ZTTV(0)_$H,^(ZTSK,2)=%ZTTV
 ;
4 ;run task
 I ^%ZOSF("OS")["MSM" D
 . I $P($ZV,"Version ",2)]]"4.3.0" D PURGELST^%MSMOPS Q
 . Q
 L
 I ZTPFLG("XUSCNT") D SETLOCK^XUSCNT($NA(^%ZTSCH("TASK",ZTSK)))
 L +^%ZTSCH("TASK",ZTSK) ;establish a lock on the task to be used to indicate that it is active
 ;Persistent task get set in ZTSK^XQ1
 I $P(^%ZIS(14.7,ZTPFLG("ZTPN"),0),U,3)="Y" S %ZTTV("LOG")=1 D LOGIN^%ZTMS4
 I $D(%ZTTV(1)) D:+$G(^%ZTSCH("LOGRSRC")) LOGRSRC^%ZOSV(%ZTTV(1))
 S DT=DT\1 S:ZTPFLG("ZTREQ") ZTREQ="@"
 M %ZTPFLG=ZTPFLG
 D RUN
 M ZTPFLG=%ZTPFLG K %ZTPFLG
 I $D(%ZTTV(1)) D:+$G(^%ZTSCH("LOGRSRC")) LOGRSRC^%ZOSV("$AFTR ZTMS$")
 I $G(%ZTTV("LOG")) D LOGOUT^%ZTMS4
 ;
AFTER ;cleanup after task; reset partition
 S U="^",ZTSK=$P(%ZTTV,U,4) D PCLEAR^%ZTLOAD(ZTSK) ;Clear persistent flag
 D TSKSTAT(6,"Finished")
 I ZTPFLG("XUSCNT") D SETLOCK^XUSCNT()
 L  ;Clear all user locks.
 L +^%ZTSK(ZTSK)
 I $D(ZTTASK)[0 K ^%ZTSCH("TASK",ZTSK) S ZTQUEUED=.6,ZTTASK=1
 ;S X=10 X ^%ZOSF("PRIORITY")
 D SETNM^%ZOSV("Sub "_$J) ;Change name back
 S ZTUCI=$P(%ZTTV,U),IOS=$P(%ZTTV,U,2),(IO,IO(0),%ZTIO)=$P(%ZTTV,U,5),IOT=$P(%ZTTV,U,6),ZTCPU=$P(%ZTTV,U,7),ZTNODE=$P(%ZTTV,U,8)
 S IOF=$P(%ZTTV,U,11),IOST=$P(%ZTTV,U,12),ZTPAIR=$P(%ZTTV,U,13),ZTYPE=$P(%ZTTV,U,14),ZTSYNCFL=$P(%ZTTV(0),U,11)
 I $G(ZTSYNCFL)]"" S X=$$SYNCFLG^%ZTMS2($S($G(ZTSTAT):"S",1:"D"),ZTSYNCFL,IO,$G(ZTSTAT)) D SCHSYNC^%ZTMS2(ZTSYNCFL,IO):'$G(ZTSTAT)
 D POST^%ZTMS4:ZTTASK,CLOSE
 K ^TMP($J),^UTILITY($J),^XUTL("XQ",$J) I $T(XUTL^XUSCLEAN)]"" D XUTL^XUSCLEAN
 K (%ZTIO,%ZTTV,DT,IO,IOF,ION,IOS,IOST,IOT,U,ZTCPU,ZTNODE,ZTNONEXT,ZTPAIR,ZTPFLG,ZTQUEUED,ZTREQ,ZTSTOP,ZTUCI,ZTYPE)
 K IO("C"),IO("T"),IO("ERROR"),IO("LASTERR"),IO("DOC"),IO("P"),IO("HFSIO")
 S DUZ=0,DUZ(0)="@",ZTQUEUED=0
 L  ;Clear all locks, -^%ZTSK(ZTSK)
 Q
 ;
RUN ;
 N %,%ZTTV,%ZTPFLG,XUALLOC
 F %=1:1:12 S $P(XUALLOC(%)," ",250)=""
 D @ZTRTN
 Q
 ;
CLOSE ;RUN--close &/or close execute
 I %ZTIO="" S ZTNONEXT=1 G CLX
 N ZTUCI,ZTCPU,ZTNODE,IOCPU,%IO
 I IOT="HFS"!(IOT="SPL") S ZTNONEXT=1
 K IO("C") S:IOT'="TRM" IO("C")=1
 S:$D(IO("CLOSE")) IO("T")=1
 I IOT="RES" K ZTNONEXT Q  ;For a Resource, don't close.
 ;Here is the Lock and hang to allow IDCU ports to reset. See %ZTMS2.
 I IOST["MINIOUT" S IO("C")=1,%IO=1 L +^%ZTSCH("NETMAIL",%ZTIO):8
 I $D(IO(1,IO))#2 D ^%ZISC
 I $G(%IO) H 6 ;Wait for terminal server to reset.
 ;Unlock of all locks is done in clean
 ;See that all devices are closed.
CLX S %IO="" F  S %IO=$O(IO(1,%IO)) Q:%IO=""  I %IO'=IO K IO(1,%IO) C %IO
 Q
 ;
TSKSTAT(CODE,MSG,JOB) ; Update task's status
 S $P(^%ZTSK(ZTSK,.1),U,1,3)=$G(CODE)_U_$H_U_$G(MSG)
 I $G(JOB)>0 S $P(^%ZTSK(ZTSK,.1),U,4)=JOB
 Q
 ;
