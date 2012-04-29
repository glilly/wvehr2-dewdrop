XOBVTCPL ;; mjk/alb - VistALink TCP/IP Listener (Cache NT) ; 07/27/2002  13:00
 ;;1.5;VistALink;;Sep 09, 2005
 ;;Foundations Toolbox Release v1.5 [Build: 1.5.0.026]
 ;
 QUIT
 ;
 ; -- Important: Should always be JOBed using START^XOBVTCP
LISTENER(XOBPORT,XOBCFG) ; -- Start Listener
 ;
 ; -- quit if not Cache for NT
 IF $$GETOS^XOBVTCP()'="OpenM-NT" QUIT
 ;
 NEW $ETRAP,$ESTACK SET $ETRAP="D ^%ZTER HALT"
 ;
 NEW X,POP,XOBDA,U,DTIME,DT,XOBIO
 SET U="^",DTIME=900,DT=$$DT^XLFDT()
 IF $GET(DUZ)="" NEW DUZ SET DUZ=.5,DUZ(0)="@"
 ;
 ; -- only start if not already started
 IF $$LOCK^XOBVTCP(XOBPORT) DO
 . IF $$OPENM(.XOBIO,XOBPORT) DO
 . . ; -- listener started and now stopping
 . . SET IO=XOBIO
 . . DO CLOSE^%ZISTCP
 . . ; -- update status to 'stopped'
 . . DO UPDATE^XOBVTCP(XOBPORT,4,$GET(XOBCFG))
 . ELSE  DO
 . . ; -- listener failed to start
 . . ; -- update status to 'failed'
 . . DO UPDATE^XOBVTCP(XOBPORT,5,$GET(XOBCFG))
 . ;
 . DO UNLOCK^XOBVTCP(XOBPORT)
 QUIT
 ;
 ; -- open/start listener port
OPENM(XOBIO,XOBPORT) ;
 NEW XOBBOX,%ZA
 SET XOBBOX=+$$GETBOX^XOBVTCP()
 SET XOBIO="|TCP|"_XOBPORT
 OPEN XOBIO:(:XOBPORT:"AT"):30
 ;
 ; -- if listener port could not be openned then gracefully quit
 ;    (other namespace using port maybe?)
 IF '$TEST QUIT 0
 ;
 ; -- indicate listener is 'running'
 DO UPDATE^XOBVTCP(XOBPORT,2,$GET(XOBCFG))
 ; -- read & spawn loop
 FOR  DO  QUIT:$$EXIT(XOBBOX,XOBPORT)
 . USE XOBIO
 . READ *X:60 IF '$TEST QUIT
 . JOB CHILDNT^XOBVTCPL():(:4:XOBIO:XOBIO):10 SET %ZA=$ZA
 . IF %ZA\8196#2=1 WRITE *-2 ;Job failed to clear bit
 QUIT 1
 ;
CHILDNT() ;Child process for OpenM
 NEW XOBEC
 SET $ETRAP="D ^%ZTER L  HALT"
 SET IO=$PRINCIPAL ;Reset IO to be $P
 USE IO:(::"-M") ;Packet mode like DSM
 ; -- do quit to save a stack level
 SET XOBEC=$$NEWOK()
 IF XOBEC DO LOGINERR(XOBEC,IO)
 IF 'XOBEC DO VAR,SPAWN^XOBVLL
 QUIT
 ;
VAR ;Setup IO variables
 SET IO(0)=IO,IO(1,IO)="",POP=0
 SET IOT="TCP",IOF="#",IOST="P-TCP",IOST(0)=0
 QUIT
 ;
NEWOK() ;Is it OK to start a new process
 NEW XQVOL,XUVOL,X,XOBCODE,Y
 SET U="^"
 DO GETENV^%ZOSV SET XQVOL=$PIECE(Y,U,2)
 SET X=$$FIND1^DIC(8989.304,",1,","BX",XQVOL,"","",""),XUVOL=$SELECT(X>0:^XTV(8989.3,1,4,X,0),1:XQVOL_"^y^1")
 SET XOBCODE=$$INHIBIT^XUSRB()
 IF XOBCODE=1 QUIT 181004
 IF XOBCODE=2 QUIT 181003
 QUIT 0
 ;
 ; -- process error
LOGINERR(XOBEC,XOBPORT) ;
 DO ERROR^XOBVLL(XOBEC,$$EZBLD^DIALOG(XOBEC),XOBPORT)
 ;
 ; -- give client time to process stream
 HANG 2
 QUIT
 ;
EXIT(XOBBOX,XOBPORT) ;
 ; -- is status 'stopping'
 QUIT ($PIECE($GET(^XOB(18.04,+$$GETLOGID(XOBBOX,XOBPORT),0)),U,3)=3)
 ;
GETLOGID(XOBBOX,XOBPORT) ;
 QUIT +$ORDER(^XOB(18.04,"C",XOBBOX,XOBPORT,""))
 ;
