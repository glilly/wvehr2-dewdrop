%ZTM ;SEA/RDS-TaskMan: Manager, Part 1 (Main Loop) ;1/9/2006
 ;;8.0;KERNEL;**24,36,64,67,118,127,136,275,355**;JUL 10, 1995;Build 9
 ;
 ;%ZTCHK is set to 1 @ top of SCHQ, set to 0 if send a task to SM
LOOP ;Taskman's Main Loop
 F %ZTLOOP=0:1 S %ZTLOOP=%ZTLOOP#16 D CHECK,SCHQ,IDLE:%ZTCHK
 S %ZTFALL="" G LOOP
 ;
CHECK ;LOOP--Check Status And Update Loop Data
 ;Do CHECK if sent a new job or %ZTLOOP=0.
 Q:%ZTLOOP&$G(%ZTCHK)
 I $D(^%ZTSCH("STOP","MGR",%ZTPAIR)) G HALT^%ZTM0
 S ^%ZTSCH("RUN")=$H,ZTPAIR="",%ZTIME=$$H3($H)
 I $D(^%ZTSCH("WAIT","MGR"))#2 D STATUS("WAIT","Taskman Waiting") H 5 G CHECK
 ;
 I $D(^%ZTSCH("UPDATE",$J))[0 D UPDATE^%ZTM5
 I %ZTVLI D STATUS("PAUSE","Logons Inhibited") H 60 G CHECK ;Set in %ZTM5
 I @%ZTNLG D INHIBIT^%ZTM5(1),STATUS("PAUSE","No Signons Allowed") H 60 G CHECK
 I $G(^%ZIS(14.5,"LOGON",%ZTVOL)) D INHIBIT^%ZTM5(0) ;Check field
 I $D(ZTREQUIR)#2 D STATUS("PAUSE","Required link to "_ZTREQUIR_" is down.") H 60 D REQUIR^%ZTM5 G CHECK
 ;
 I $D(^%ZTSCH("LINK"))#2,$$DIFF($H,^("LINK"))>900 D LINK^%ZTM3
 ;
 S %ZTRUN=%ZTVMJ>$$ACTJ^%ZOSV ;Check for job limit
 ;
 I %ZTPFLG("BAL")]"" D  I ZTOVERLD G CHECK
 . S ZTOVERLD=0
 . Q:%ZTPFLG("LBT")>%ZTIME  S %ZTPFLG("LBT")=%ZTIME+%ZTPFLG("BI")
 . D BALANCE^%ZTM6 Q:'ZTOVERLD
 . D STATUS("BALANCE","Waiting to balance the load.")
 . ;Start submanagers for C list work
 . I $D(^%ZTSCH("C",%ZTPAIR))>9,%ZTRUN D NEWJOB(%ZTUCI,%ZTVOL,"")
 . N T F T=1:1:%ZTPFLG("BI") H 1 Q:$$STOPWT^%ZTM6()
 . Q
 ;
 I %ZTRUN D STATUS("RUN","Main Loop")
 I '%ZTRUN D STATUS("RUN","Taskman Job Limit Reached"),CHECK^%ZTM6
 Q
 ;
STATUS(ST,MSG) ;Record TM status
 S ^%ZTSCH("STATUS",$J)=$H_"^"_ST_"^"_$G(%ZTPAIR)_"^"_MSG
 Q
 ;
TLOCK(M,T) ;Lock a time node
 I M>0 L +^%ZTSCH(ZTDTH):0 Q $T
 L -^%ZTSCH(ZTDTH) Q
 ;
SCHQ ;LOOP--Check Schedule List
 S %ZTIME=$$H3($H),ZTDTH=0,%ZTCHK=1,IO=""
S1 S ZTDTH=$O(^%ZTSCH(ZTDTH)),ZTSK=0 Q:(ZTDTH>%ZTIME)  Q:('ZTDTH)!(ZTDTH'?1.N)  I +ZTDTH<0 K ^%ZTSCH(ZTDTH) G S1
 I '$$TLOCK(1,ZTDTH) G S1
S2 S ZTSK=$O(^%ZTSCH(ZTDTH,ZTSK)) I ZTSK="" D TLOCK(-1,ZTDTH) G S1
 S ZTST=$G(^%ZTSCH(ZTDTH,ZTSK))
 ;Get task lock then release time lock
 L +^%ZTSK(ZTSK):0 G S2:'$T
 K ^%ZTSCH(ZTDTH,ZTSK) D TLOCK(-1,ZTDTH)
 ;Count tasks
 S %ZTMON(%ZTMON)=$G(%ZTMON(%ZTMON))+1
 I $D(^%ZTSK(ZTSK,0))[0 D TSKSTAT("I") L -^%ZTSK(ZTSK) G S2
 I $L($P($G(^%ZTSK(ZTSK,.1)),U,10)) D TSKSTAT("D","Stopped") L -^%ZTSK(ZTSK) G S2
 D ^%ZTM1
 I %ZTREJCT L -^%ZTSK(ZTSK) G S2
 ;
SEND ;Send Task To Submanager
 S %ZTCHK=0,ZTPAIR=""
 I ZTDVOL'=%ZTVOL D XLINK^%ZTM2 G:'ZTJOBIT SCHX
 ;Clear before job cmd
 I (ZTYPE'="C")&(%ZTNODE[ZTNODE) D
 . D TSKSTAT(3,"Placed on JOB List")
 . S ^%ZTSCH("JOB",ZTDTH,ZTSK)=IO ;No other lock on JOB
 E  D
 . D TSKSTAT("M","Placed on C List")
 . S ZTPAIR=ZTDVOL_$S($L(ZTNODE):":"_ZTNODE,1:"")
 . S ^%ZTSCH("C",ZTPAIR,ZTDTH,ZTSK)=IO
 ;
 L -^%ZTSK(ZTSK)
 ;
 ;I '$D(^%ZTSCH("STOP","SUB",%ZTPAIR)),'$$OOS(ZTPAIR) D NEWJOB(ZTUCI,ZTDVOL,ZTNODE,ZTYPE,ZTPAIR)
 ;I '$D(^%ZTSCH("STOP","SUB",%ZTPAIR)),(ZTYPE="C"!(%ZTRUN&$$NEWSUB)),'$$OOS(ZTPAIR) D
 ;. I 1 X %ZTJOB H %ZTSLO I '$T X %ZTJOB H %ZTSLO
 ;. Q
 I (ZTYPE="C"!(%ZTRUN&$$NEWSUB)),'$$OOS(ZTPAIR) D NEWJOB(ZTUCI,ZTDVOL,ZTNODE)
SCHX L  K ZTREP Q
 ;
IDLE ;LOOP--DEV Node Maintenance; Backup JOB Commands
 S (ZTREC,ZTCVOL)="" H 1 ;This is the main hang
 I %ZTMON("NEXT")'>%ZTIME D MON ;See if time to update %ZTMON
 Q:'%ZTRUN  ;Only do IDLE work if not at job limit
 I $D(^%ZTSCH("STOP","MGR",%ZTPAIR)) Q
 ;job off a new submanager if MIN count < # SUBs
 I $$NEWSUB D NEWJOB(%ZTUCI,%ZTVOL,"")
 L +^%ZTSCH("IDLE",%ZTPAIR):0 Q:'$T  D IDLE1 L -^%ZTSCH("IDLE",%ZTPAIR)
 Q
IDLE1 ;only proceed with idle work if 60 seconds since last check
 I $$DIFF(%ZTIME,^%ZTSCH("IDLE"),1)<60 Q
 I %ZTPFLG("XUSCNT") D TOUCH^XUSCNT
 D I1,I2,I5,I6
 S ^%ZTSCH("IDLE")=%ZTIME
 Q
 ;
I1 ;clear out old DEV nodes
 N X,%ZTIO S %ZTIO=""
 F  S %ZTIO=$O(^%ZTSCH("DEV",%ZTIO)) Q:%ZTIO=""  L ^%ZTSCH("DEV",%ZTIO):0 I $T D  L -^%ZTSCH("DEV",%ZTIO)
 . S X=$G(^%ZTSCH("DEV",%ZTIO)) Q:'$L(X)
 . I $$DIFF(%ZTIME,X,1)>120 K ^%ZTSCH("DEV",%ZTIO)
 . Q
 Q
 ;
I2 ;job new submanagers cross-volume for each unfinished C list
 I $D(^%ZTSCH("C")) D
 . N Y,ZTUCI,ZTVOL,ZTNODE,$ETRAP,$ESTACK S $ET="S $EC="""" D ERCL^%ZTM2"
 . S ZTVOL="" F  S ZTVOL=$O(^%ZTSCH("C",ZTVOL)) Q:ZTVOL=""  D
 .. I $O(^%ZTSCH("C",ZTVOL,0))="" Q
 .. S ZTNODE="",ZTDVOL=ZTVOL S:ZTDVOL[":" ZTNODE=$P(ZTDVOL,":",2),ZTDVOL=$P(ZTDVOL,":")
 .. S X=$G(^%ZTSCH("C",ZTVOL))
 .. I $D(^%ZTSCH("LINK",ZTDVOL))!(X>9)!$$OOS(ZTVOL) Q
 .. S ^%ZTSCH("C",ZTVOL)=X+1
 .. S ZTUCI=$O(^%ZIS(14.6,"AV",ZTDVOL,""))
 .. D NEWJOB(ZTUCI,ZTDVOL,ZTNODE)
 .. Q
 . Q
 Q
 ;
I4 ;job off a new submanager if the Job List still has tasks
 I $D(^%ZTSCH("JOB"))>9 D NEWJOB(%ZTUCI,%ZTVOL,"")
 Q
 ;
I5 ;Clean up %ZTSCH
 S ZTDTH="0,0" F  S ZTDTH=$O(^%ZTSCH(ZTDTH)) Q:ZTDTH'[","  D
 . N ZTSK,X L +^%ZTSCH(ZTDTH):0 Q:'$T
 . S ZTSK=$O(^%ZTSCH(ZTDTH,0)) I ZTSK>0 S X=^(ZTSK),^%ZTSCH($$H3(ZTDTH),ZTSK)=X K ^%ZTSCH(ZTDTH,ZTSK)
 . L -^%ZTSCH(ZTDTH)
 . Q
 Q
 ;
I6 ;Check on persistent jobs.
 S ZTSK=0 F  S ZTSK=$O(^%ZTSCH("TASK",ZTSK)) Q:ZTSK'>0  D:$D(^%ZTSCH("TASK",ZTSK,"P"))
 . L +^%ZTSCH("TASK",ZTSK):0 E  Q  ;Still running
 . L -^%ZTSCH("TASK",ZTSK)
 . D REQP^%ZTLOAD3(ZTSK) ;START NEW TASK.
 K %ZTVS Q
 ;
MON ;Set Next %ZTMON each Hour
 S %ZTMON=$P($H,",",2)\3600,%ZTMON(%ZTMON)=0
 S %ZTMON("NEXT")=($H*86400)+(%ZTMON+1*3600)
 D HOUR^%ZTM5
 I %ZTMON("DAY")<+$H D DAY^%ZTM5
 Q
 ;
NEWJOB(ZTUCI,ZTDVOL,ZTNODE) ;Start a new Job
 S ZTUCI=$G(ZTUCI),ZTDVOL=$G(ZTDVOL),ZTNODE=$G(ZTNODE)
 X %ZTJOB H %ZTSLO ;If job doesn't work, will catch next time.
 Q
 ;
DIFF(N,O,T) ;Diff in sec.
 Q:$G(T) N-O ;For new seconds times
 Q N-O*86400-$P(O,",",2)+$P(N,",",2)
 ;
OOS(BV) ;Check if Box-Volume is Out Of Service, Return 1 if OOS.
 Q:BV="" 0 N %
 S %=$O(^%ZIS(14.7,"B",BV,0)),%=$G(^%ZIS(14.7,+%,0))
 Q:%="" 1 Q $P(%,U,11)=1
 ;
H3(%) ;Convert $H to seconds.
 Q 86400*%+$P(%,",",2)
H0(%) ;Covert from seconds to $H
 Q (%\86400)_","_(%#86400)
SUBOK() ;Check if sub's are starting, return 1 if OK
 S ^%ZTSCH("SUB",%ZTPAIR,0)=($G(^%ZTSCH("SUB",%ZTPAIR,0))+1)_"^"_$H
 Q ^%ZTSCH("SUB",%ZTPAIR,0)<10
 ;
NEWSUB() ;See if we need a new submanager
 N SUBS
 L +^%ZTSCH("SUB",%ZTPAIR):0 S SUBS=^%ZTSCH("SUB",%ZTPAIR)
 L -^%ZTSCH("SUB",%ZTPAIR)
 I SUBS<%ZTPFLG("MINSUB") Q 1
 Q 0
 ;
TSKSTAT(CODE,MSG) ; Update task's status
 S $P(^%ZTSK(ZTSK,.1),U,1,3)=$G(CODE)_U_$H_U_$G(MSG)
 Q
