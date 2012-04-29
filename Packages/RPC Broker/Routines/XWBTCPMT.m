XWBTCPMT ;ISF/RWF - Routine to test a connection ;11/28/2005
 ;;1.1;RPC BROKER;**43**;Mar 28, 1997
CALL ;Interactive
 N IP,PORT,STAT
 D HOME^%ZIS
 S U="^",DTIME=$$DTIME^XUP
 W !,"Interactive Broker Test"
 R !,"IP ADDRESS: ",IP:DTIME
 I IP["^" Q
 R !,"PORT: ",PORT:DTIME
 I PORT["^" Q
 S STAT=$$TEST(IP,PORT,1)
 U $P
 W !,$S(STAT>0:"Success, response: "_$P(STAT,U,2),1:"Failed: "_$P(STAT,U,2,9))
 Q
 ;
TEST(IP,PORT,TALK) ;
 I IP'?1.3N1P1.3N1P1.3N1P1.3N S IP=$$ADDRESS^XLFNSLK(IP)
 I IP'?1.3N1P1.3N1P1.3N1P1.3N Q "-1^BAD IP"
 D CALL^%ZISTCP(IP,PORT)
 I POP Q "-1^Failed to Connect"
 U IO
 N $ET S $ET="G ERR^XWBTCPMT"
 ;TCPConnect
 W "[XWB]10304"_$C(10)_"TCPConnect5001010.6.17.95f00010f0024ISF-FORTW.vha.med.va.govf"_$C(4),@IOF
 R RES:10 I '$T S RES="-1^TIMEOUT" G EXIT
 W "[XWB]10304"_$C(5)_"#BYE#"_$C(4),@IOF
 R RES2:10 I '$T S RES="-1^TIMEOUT after accept"
 S RES="1^"_RES
EXIT ;Close and Exit
 D CLOSE^%ZISTCP
 Q RES
 ;
ERR ;
 D CLOSE^%ZISTCP
 U $P
 Q "-1^"_$$EC^%ZOSV
 ;
CHECK ;Check server setup
 N XPARSYS,XWBDEBUG,XWBOS,XWBT,XWNRBUF,XWBTIME,NEWJOB
 W !,"This will check for some of the errors that can prevent the Broker"
 W !,"from getting started.",!
 D HOME^%ZIS
 D INIT^XWBTCPM
 W !,"Debuging is set to ",$S(XWBDEBUG=1:"On",XWBDEBUG=2:"Verbose",XWBDEBUG=3:"Very Verbose",1:"Off")
 D SETTIME^XWBTCPM(0)
 W !,"Broker activity timeout is set to ",XWBTIME
 S %ZIS="MN",IOP="NULL" D ^%ZIS
 I POP W !,"The NULL device is not setup correctly."
 I 'POP D ^%ZISC W !,"The NULL device is OK."
 I $T(SHARELIC^%ZOSV)="" W !,"The routine %ZOSV is missing the entry point 'SHARELIC'."
 I $T(GETPEER^%ZOSV)="" W !,"The routine %ZOSV is missing the entry point 'GETPEER'."
 I $G(XWBT("PCNT")),$T(COUNT^XUSCNT)="" W !,"The routine XUSCNT is missing on a GT.M system."
 W !,"Checking if new JOB's can start."
 S ^TMP("XWB",$J)=1 J HOLD^XWBTCPMT($J) H 1
 I $G(^TMP("XWB",$J))=1 W !,"Doesn't look like a new JOB could start!",!
 S NEWJOB=$$NEWJOB^XWBTCPM()
 W !,"New jobs are "_$S('NEWJOB:"not ",1:"")_"allowed."
 W !,"Done with the checks.",!
 K ^TMP("XWB",$J)
 Q
 ;
HOLD(MJ) ;Show that a new job is allowed.
 S ^TMP("XWB",MJ)=5
 HANG 5
 Q
