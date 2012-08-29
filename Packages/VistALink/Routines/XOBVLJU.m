XOBVLJU ;; mjk/alb - VistALink JUNIT Testers ; 07/27/2002  13:00
 ;;1.5;VistALink;;Sep 09, 2005
 ;;Foundations Toolbox Release v1.5 [Build: 1.5.0.026]
 ;
 QUIT
 ;
 ; ----------------------------------------------------------
 ;                 XOB Remote Procedure JUnit Testers
 ; ----------------------------------------------------------
 ; 
VERRP(XOBY) ; -- rpc: XOBV TEST JUNIT RPC VERSION
 SET XOBY=$GET(XWBAPVER,"XWBAPVER not defined")
 QUIT
 ;
 ; ----------- Switching RPC Format On-The-Fly Tests ---------
XA2GRP(XOBY,XOBARR) ; -- rpc: XOBV TEST JUNIT SWITCH ARR2GLB
 NEW X
 SET XOBY=$NAME(^TMP("XOB VL TEST",$JOB))
 KILL @XOBY
 MERGE @XOBY=XOBARR
 SET X=$$RTRNFMT^XWBLIB("GLOBAL ARRAY",1)
 QUIT
 ;
XG2ARP(XOBY,XOBARR) ; -- rpc: XOBV TEST JUNIT SWITCH GLB2ARR
 NEW X
 MERGE XOBY=XOBARR
 SET X=$$RTRNFMT^XWBLIB("ARRAY",1)
 QUIT
 ;
XA2SRP(XOBY,XOBARR) ; -- rpc: XOBV TEST JUNIT SWITCH ARR2SV
 NEW X,XOBRET,I
 SET XOBRET=""
 SET I=""
 FOR  SET I=$ORDER(XOBARR(I)) QUIT:I=""  SET XOBRET=XOBRET_XOBARR(I)_":"
 SET XOBY=XOBRET
 SET X=$$RTRNFMT^XWBLIB("SINGLE VALUE")
 QUIT
 ;
XS2ARP(XOBY,XOBARR) ; -- rpc: XOBV TEST JUNIT SWITCH SV2ARR
 NEW X
 MERGE XOBY=XOBARR
 SET X=$$RTRNFMT^XWBLIB("ARRAY",1)
 QUIT
 ;
XG2SRP(XOBY,XOBARR) ; -- rpc: XOBV TEST JUNIT SWITCH GLB2SV
 NEW X,Y,I
 SET Y=""
 SET I=""
 FOR  SET I=$ORDER(XOBARR(I)) QUIT:I=""  SET Y=Y_XOBARR(I)_"/"
 SET XOBY=Y
 SET X=$$RTRNFMT^XWBLIB("SINGLE VALUE")
 QUIT
 ;
XS2GRP(XOBY,XOBARR) ; -- rpc: XOBV TEST JUNIT SWITCH SV2GLB
 NEW X
 SET XOBY=$NAME(^TMP("XOB VL TEST",$JOB))
 KILL @XOBY
 MERGE @XOBY=XOBARR
 SET X=$$RTRNFMT^XWBLIB("GLOBAL ARRAY",1)
 QUIT
 ;
RPCTO(XOBY,XOBTTYP) ; -- rpc: graceful timeout : XOBV TEST JUNIT RPC TIMEOUT
 ; -- used to test graceful but not waiting
 IF XOBTTYP="NO TIMEOUT CHECK" SET XOBY=$$NOTOCHK() QUIT
 ; -- used to test timeout reset
 IF XOBTTYP="RESET TIMEOUT" DO RESET() SET XOBY=$$RESET() QUIT
 ; -- used to test force timeout
 IF XOBTTYP="FORCE TIMEOUT" DO FORCE() SET XOBY=$$FORCE() QUIT
 QUIT
 ;
NOTOCHK() ; -- no timeout check
 QUIT "No Timeout Check Return"
 ;
RESET() ; -- reset RPC timeout
 FOR  HANG 1 IF $$STOP^XOBVLIB() DO  QUIT
 . NEW TO,I,X
 . SET TO=$$GETTO^XOBVLIB()
 . FOR I=2:1 DO  QUIT:'X
 . . SET X=$$SETTO^XOBVLIB(TO*I)
 . . SET X=$$STOP^XOBVLIB()
 QUIT "Reset Timeout Return"
 ;
FORCE() ; -- force RPC timeout
 FOR  HANG 1 IF $$STOP^XOBVLIB() QUIT
 QUIT "Forced Timeout return"
 ;
