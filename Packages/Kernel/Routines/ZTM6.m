%ZTM6 ;SEA/RDS-TaskMan: Manager, Part 8 (Load Balancing) ;07/28/2005  16:14
 ;;8.0;KERNEL;**23,118,127,136,355**;JUL 10, 1995;Build 9
 ;
BALANCE ;CHECK^%ZTM--determine whether cpu should wait for balance
 ;Return ZTOVERLD =1 if need to wait, 0 to run
 ;The TM with the largest value sets ^%ZTSCH("LOAD",value)=who^when
 ;If your value is greater or equal then you run.
 ;If your value is less you wait unless you set LOAD then you run.
 L +^%ZTSCH("LOAD"):5 N X,ZTIME,ZTLEFT,ZTPREV
 N $ES,$ET S $ET="Q:$ES>0  D ER^%ZTM6"
 S ZTOVERLD=0,ZTPREV=+$O(^%ZTSCH("LOAD",0)),@("ZTLEFT="_%ZTPFLG("BAL"))
 S ZTIME=$$H3($H),ZTOVERLD=$$COMPARE(%ZTPAIR,ZTLEFT,ZTPREV)
 ;If we are RUNNING have other submanagers wait
 I 'ZTOVERLD D
 . S X="" F  S X=$O(^%ZTSCH("LOADA",X)) Q:X=""  S $P(^(X),"^")=1
 . K ^%ZTSCH("LOAD") S ^("LOAD",ZTLEFT)=%ZTPAIR_"^"_ZTIME
 ;Now set a value that is used by our %ZTMS to run/wait also
 S ^%ZTSCH("LOADA",%ZTPAIR)=ZTOVERLD_"^"_ZTLEFT_"^"_ZTIME_"^"_$J
 L -^%ZTSCH("LOAD")
 Q
 ;
STOPWT() ;See if we should stop Balance wait
 L +^%ZTSCH("LOAD"):0 Q:'$T 0 ;Keep waiting if can't get lock
 N I,J S I="",J=1
 F  S I=$O(^%ZTSCH("LOADA",I)) Q:I=""  I '^(I) S J=0
 L -^%ZTSCH("LOAD")
 Q J ;Return: stop waiting 1, keep waiting 0.
 ;
CHECK ;Called when job limit reached.
 ;If not doing balancing, remove node and quit
 N I,J I %ZTPFLG("BAL")="" K ^%ZTSCH("LOADA",%ZTPAIR) Q
 L +^%ZTSCH("LOAD"):0 Q:'$T  ;Get it next time
 S I=$O(^%ZTSCH("LOAD",0)),J=$G(^%ZTSCH("LOADA",%ZTPAIR))
 S I=$P(J,"^",2)<I,$P(^%ZTSCH("LOADA",%ZTPAIR),"^",1)=I
 L -^%ZTSCH("LOAD")
 Q
 ;
COMPARE(ID,ZTLEFT,ZTPREV) ;
 ;BALANCE--compare our cpu capacity left to that of previous checker
 ;input:  cpu name, cpu capacity left, cpu capacity of previous checker
 ;output: whether current cpu should wait, 0=run, 1=wait
 N X
 I ZTLEFT'<ZTPREV Q 0
 S X=^%ZTSCH("LOAD",ZTPREV)
 I $P(X,"^",2)+150<ZTIME Q 0
 Q $P(X,"^")'[ID
 ;
ER ;Clean up if error
 S $EC="",%ZTPFLG("BAL")="",ZTOVERLD=0 L -^%ZTSCH("LOAD")
 Q
 ;
H3(%) ;Convert $H to seconds
 Q 86400*%+$P(%,",",2)
 ;
VXD(BIAS) ;--algorithm for VAX DSM
 ;Capacity Left=Available Jobs - Active Jobs - (4 * Compute Queue Length)
 ;output: cpu capacity left+bias
 N ZTJ,ZTL S ZTJ=$$VXDJOBS
 S ZTL=$P(ZTJ,",")-$P(ZTJ,",",2)-(4*$P(ZTJ,",",3)) I ZTL<1 S ZTL=1
 Q ZTL+$G(BIAS)
 ;
VXDJOBS() ;
 ;VXD--gather job table information
 ;output: sysgen max # jobs, current # jobs, current # computable jobs
 N
 D INIT^%VOLDEF I '%SMSTART Q ""
 S ZTJOBSIZ=%JOBSIZ,ZTJOBTAB=%JOBTAB
 S ZTMAX=%MAXPROC,(ZTCOMP,ZTCOUNT)=0
 F ZTJOB=1:1:ZTMAX D
 .S ZTADDR=ZTJOB*ZTJOBSIZ+ZTJOBTAB,ZTPID=$V(ZTADDR+20) D VXDJ1:ZTPID Q
 Q ZTMAX_","_ZTCOUNT_","_ZTCOMP
 ;
VXDJ1 ;VXDJOBS--adjust # active and # computable based on current entry
 S X="VXDJE",@^%ZOSF("TRAP")
 S ZTNAME=$ZC(%GETJPI,ZTPID,"PRCNAM") Q:ZTNAME["Sub"
 S ZTSTATE=$ZC(%GETJPI,ZTPID,"STATE")
 S ZTCOUNT=ZTCOUNT+1
 I ZTSTATE["COM"!(ZTSTATE["CUR") S ZTCOMP=ZTCOMP+1
VXDJE S X="",@^%ZOSF("TRAP") Q
 ;
MSM4() ;Use MSMv4 LAT calcuation
 N MAXJOB,CURJOB
 S MAXJOB=$V($V(3,-5),-3,0),CURJOB=$V(168,-4,2)
 Q MAXJOB-CURJOB*255\MAXJOB
 ;
CACHE1(%) ;Use available jobs
 N CUR,MAX
 Q $$AVJ^%ZOSV()+$G(%)
 ;
CACHE2(%COM,%LOG) ;Cache, Pull metric data
 N TMP,$ET
 S $ETRAP="S $ECODE="""" Q ZTPREV"
 S %LOG=$G(%LOG,"VISTA$METRIC")
 I $L($G(%COM)) S TMP=$ZF(-1,%COM)
 Q $ZF("TRNLNM",%LOG)
 ;
RNDRBN() ;Round Robin
 L +^%ZTSCH("RNDRBN"):1
 N R S R=$G(^%ZTSCH("RNDRBN"))+2,^%ZTSCH("RNDRBN")=(R#512)
 L -^%ZTSCH("RNDRBN")
 Q
