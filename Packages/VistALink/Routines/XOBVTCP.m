XOBVTCP ;; mjk/alb - VistALink TCP Utilities ; 07/27/2002  13:00
 ;;1.5;VistALink;;Sep 09, 2005
 ;;Foundations Toolbox Release v1.5 [Build: 1.5.0.026]
 ;
 QUIT
 ;
 ; -- called from protocol action at START^XOBUM1 
START(XOBPORT,XOBCFG) ;
 ; 
 ; -- set up environment
 NEW XOBOK
 SET XOBOK=0
 SET U="^" DO HOME^%ZIS
 ;
 ; -- if no port, set to default
 IF $GET(XOBPORT)="" NEW XOBPORT SET XOBPORT=8000
 ;
 IF $$LOCK(XOBPORT) DO
 . DO UNLOCK(XOBPORT)
 . ; -- JOB command same for CacheNT and DSM
 . JOB LISTENER^XOBVTCPL(XOBPORT,$GET(XOBCFG))::5
 . SET XOBOK=$TEST
 ELSE  DO
 . SET XOBOK=0
 QUIT XOBOK
 ;
UCX ; -- VMS TCPIP (UCX) multi-thread entry point
 ; -- Called from VistALink .com files
 ;
 NEW XOBEC
 DO ESET
 SET (IO,IO(0))="SYS$NET"
 ; **VMS specific code, need to share device**
 OPEN IO:(TCPDEV:BLOCKSIZE=512):60 ELSE  SET ^TMP("XOB DSM CONNECT FAILURE",$HOROLOG)="" QUIT
 USE IO
 SET XOBEC=$$NEWOK^XOBVTCPL()
 IF XOBEC DO LOGINERR^XOBVTCPL(XOBEC,IO)
 IF 'XOBEC DO SPAWN^XOBVLL
 QUIT
 ;
CACHEVMS ; -- VMS TCPIP (UCX) multi-thread entry point for Cache for VMS
 ; -- Called from VistALink .com files
 ;
 NEW XOBEC
 DO ESET
 SET (IO,IO(0))="SYS$NET"
 ;
 ; **Cache'/VMS specific code**
 OPEN IO::5
 USE IO:(::"-M") ;Packet mode like DSM
 ;
 SET XOBEC=$$NEWOK^XOBVTCPL()
 IF XOBEC DO LOGINERR^XOBVTCPL(XOBEC,IO)
 IF 'XOBEC DO SPAWN^XOBVLL
 QUIT
 ;
ESET ;Set inital error trap
 SET U="^",$ETRAP="D ^%ZTER H" ;Set up the error trap
 QUIT
 ;
STARTUP ; -- called by TaskMan startup option [Option: XOBV LISTENER STARTUP]
 ;           and could be called by VMS .com procedure
 ;
 ; -- quit if not Cache OS
 IF $$GETOS()'["OpenM" GOTO STARTUPQ
 ; -- clear log of non-active listeners
 DO CLEARLOG
 ; -- get config for BOX-VOL and start it!
 DO STARTCFG($$GETCFG())
STARTUPQ ;
 QUIT
 ;
CLEARLOG ; -- clear log of non-active listeners
 NEW DIK,DA,Y,XOBI,XOB0,XOBPORT
 ;
 SET XOBI=0
 FOR  SET XOBI=$ORDER(^XOB(18.04,XOBI)) QUIT:'XOBI  DO
 . SET XOB0=$GET(^XOB(18.04,XOBI,0))
 . SET XOBPORT=+$PIECE(XOB0,U,2)
 . ; -- make sure listener is not running
 . IF $$LOCK(XOBPORT) DO
 . . SET DIK="^XOB(18.04,",DA=XOBI DO ^DIK
 . . DO UNLOCK(XOBPORT)
 ;
 QUIT
 ;
STARTCFG(XOBCFG) ; -- start a configurations listeners
 NEW CFG0,LSTR,LSTR0,XOBPORT,STARTUP,XOBOK
 SET CFG0=$GET(^XOB(18.03,XOBCFG,0))
 ;
 ; -- quit if no configuration
 IF CFG0="" GOTO CFGQ
 ;
 ; -- quit if not Cache...for now!
 IF $$GETOS()'["OpenM" GOTO CFGQ
 ;
 SET LSTR=0
 FOR  SET LSTR=$ORDER(^XOB(18.03,XOBCFG,"PORTS",LSTR)) QUIT:'LSTR  DO
 . SET LSTR0=$GET(^XOB(18.03,XOBCFG,"PORTS",LSTR,0))
 . SET XOBPORT=+$PIECE(LSTR0,U,1)
 . SET STARTUP=$PIECE(LSTR0,U,2)
 . ;
 . ; -- if ok to start, port # defined and not already started
 . IF XOBPORT,STARTUP,$$LOCK^XOBVTCP(XOBPORT) DO
 . . DO UNLOCK(XOBPORT)
 . . DO UPDATE^XOBVTCP(XOBPORT,1,XOBCFG)
 . . SET XOBOK=$$START(XOBPORT,XOBCFG)
 . . IF 'XOBOK DO UPDATE(XOBPORT,5,XOBCFG)
 ;
CFGQ ;
 QUIT
 ;
LOCK(XOBPORT) ;-- Lock port
 ;
 ;  Used to prevent another process from attempting to start the Listener
 ;  when it is already running.
 ;
 ;    Input:
 ;      XOBPORT - Port #
 ;
 ;   Output:
 ;      Function Value - Returns 1 if lock was successful, 0 otherwise
 ;
 QUIT $$ACTION("LOCK",XOBPORT)
 ;
 ;
UNLOCK(XOBPORT) ;-- Unlock port
 ;
 ;  Used to release a lock created by $$LOCK.
 ;
 ;    Input:
 ;      XOBPORT - Port #
 ;
 ;   Output:
 ;      None
 ;
 NEW X
 SET X=$$ACTION("UNLOCK",XOBPORT)
 QUIT
 ;
ACTION(ACTION,XOBPORT) ; -- do lock action
 NEW ENV,VOL,UCI,BOX
 ;
 SET XOBPORT=+$GET(XOBPORT)
 ;
 SET ENV=$$GETENV()
 SET VOL=$PIECE(ENV,U,2)
 SET UCI=$PIECE(ENV,U)
 SET BOX=$PIECE(ENV,U,4)
 ;
 IF ACTION="LOCK",XOBPORT LOCK +^XOB(18.01,"VistALink Listener",VOL,UCI,BOX,XOBPORT):1 QUIT $TEST
 IF ACTION="UNLOCK",XOBPORT LOCK -^XOB(18.01,"VistALink Listener",VOL,UCI,BOX,XOBPORT) QUIT 1
 QUIT 0
 ;
 ;
UPDATE(XOBPORT,XOBSTAT,XOBCFG) ; -- update VISTALINK LISTENER STARTUP LOG for listener
 NEW DIC,Y,X,XOBBOX
 SET XOBBOX=$$GETBOXN()
 ;
 ; -- set up lookup call
 SET DIC="^XOB(18.04,"
 SET DIC(0)="MLX"
 SET DIC("DR")=".02////"_XOBPORT
 SET DIC("S")="IF $P(^(0),U,2)="_XOBPORT
 SET X=XOBBOX
 ;
 DO ^DIC
 ; -- quit if lookup failed
 IF +Y>0 DO UPDLOG(+Y,XOBPORT,XOBSTAT,$GET(XOBCFG))
 QUIT
 ;
UPDLOG(XOBDA,XOBPORT,XOBSTAT,XOBCFG) ; -- do edit
 NEW DA,DIE,DR,Y,X
 ;
 LOCK +^XOB(18.04,XOBDA,0)
 ; -- set basic fields
 SET DA=XOBDA
 SET DIE="^XOB(18.04,"
 SET DR=".02////"_XOBPORT_";.03////"_XOBSTAT_";.05////^S X=$$NOW^XLFDT"
 ; -- set config if defined, otherwise delete
 SET DR=DR_";.06////"_$SELECT($GET(XOBCFG)]"":XOBCFG,1:"@")
 ; -- set user if defined, otherwise delete
 SET DR=DR_";.04////"_$SELECT($GET(DUZ)]"":DUZ,1:"@")
 ;
 DO ^DIE
 LOCK -^XOB(18.04,XOBDA,0)
 ;
 QUIT
 ;
GETENV() ; -- get environment variable
 ;-- Get environment of current system i.e. Y=UCI^VOL/DIR^NODE^BOX LOOKUP
 NEW Y
 DO GETENV^%ZOSV
 QUIT Y
 ;
GETOS() ;-- Get operating system
 ;
 ;  This function will determine which operating system is being used.
 ;
 ;   Input:
 ;     None
 ;
 ;  Output:
 ;     Operating system value i.e. OpenM-NT for OpenM.
 ;
 ;-- Get operating system
 QUIT $PIECE($GET(^%ZOSF("OS")),"^")
 ;
 ;
GETBOX() ; -- get box ien
 ;
 QUIT $$FIND1^DIC(14.7,"","BX",$PIECE($$GETENV(),U,4),"","","")
 ;
GETBOXN() ; -- get box name
 ;
 QUIT $PIECE($$GETENV(),U,4)
 ;
GETCFG() ; -- get config ien for current BOX-VOL pair
 QUIT +$PIECE($GET(^XOB(18.01,1,"CONFIG",+$ORDER(^XOB(18.01,1,"CONFIG","B",+$$GETBOX(),"")),0)),U,2)
 ;
