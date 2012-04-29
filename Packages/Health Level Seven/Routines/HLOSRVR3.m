HLOSRVR3        ;IRMFO/OAK/PIJ - Reading messages, sending acks;03/24/2004  14:43 ;07/25/2008
        ;;1.6;HEALTH LEVEL SEVEN;**138**;Oct 13, 1995;Build 34
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;; Start HL*1.6*138 PIJ
ERROR   ;error trap
        ;
        S $ETRAP="Q:$QUIT """" Q"
        D END^HLOSRVR
        ;
        ;; Start HL*1.6*138 PIJ This code added by Jim
        ;multi-listener should stop execution, only a single server may continue
        I $P($G(HLCSTATE("LINK","SERVER")),"^",2)'="S" D  Q:$QUIT "" Q
        .;; End HL*1.6*138
        .;don't log these errors
        .I ($ECODE["READ")!($ECODE["NOTOPEN")!($ECODE["DEVNOTOPN")!($ECODE["WRITE")!($ECODE["OPENERR") D
        ..;
        .E  D
        ..D ^%ZTER
        ;
        ;; Start HL*1.6*138 cjm
        ;debugging?
        ;I $G(^HLTMP("LOG ALL ERRORS"))!($ECODE["EDITED") Q:$QUIT "" Q
        I $G(^HLTMP("LOG ALL ERRORS")) D  Q:$QUIT "" Q
        .D ^%ZTER
        ;editing?
        I ($ECODE["EDITED") Q:$QUIT "" Q
        ;; End HL*1.6*138 cjm
        ;
        ;possibly an endless loop?
        N HOUR
        S HOUR=$E($$NOW^XLFDT,1,10)
        I ($G(^TMP("HL7 ERRORS",$J,HOUR,$P($ECODE,",",2)))>30) Q:$QUIT "" Q
        ;
        ;resume execution for the single listener
        S ^TMP("HL7 ERRORS",$J,HOUR,$P($ECODE,",",2))=$G(^TMP("HL7 ERRORS",$J,HOUR,$P($ECODE,",",2)))+1
        D UNWIND^%ZTER
        Q
        ;; End HL*1.6*138 PIJ
