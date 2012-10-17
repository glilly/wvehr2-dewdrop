HLOT    ;IRMFO-ALB/CJM - Services provided by the transport layer;03/24/2004  14:43 ;10/03/2008
        ;;1.6;HEALTH LEVEL SEVEN;**126,131,139**;Oct 13, 1995;Build 11
        ;
        ;**NOTE:  tags of the format ZB* are used by the client-trace debugging tool and should not be removed
        ;
READHDR(HLCSTATE,HDR)   ;
ZB10    N SUCCESS,SEG
        N MCODE
        S HLCSTATE("MESSAGE ENDED")=0
        ;**START P139 CJM
        S HLCSTATE("MESSAGE STARTED")=0
        ;**END P139
        S MCODE="S SUCCESS=$$"_HLCSTATE("READ HEADER")_"(.HLCSTATE,.HDR)"
        X MCODE
        ;**START P139 CJM
        I SUCCESS S HLCSTATE("MESSAGE STARTED")=1
        ;**END P139
ZB11    Q SUCCESS
        ;
READSEG(HLCSTATE,SEG)   ;
ZB12    N RETURN
        N MCODE
        S MCODE="S RETURN=$$"_HLCSTATE("READ SEGMENT")_"(.HLCSTATE,.SEG)"
        X MCODE
ZB13    Q RETURN
        ;
OPEN(HLCSTATE)  ;
        N MCODE
        I '$L(HLCSTATE("OPEN")) S HLCSTATE("CONNECTED")=0 Q
        S MCODE="D "_HLCSTATE("OPEN")_"(.HLCSTATE)"
        X MCODE
        Q
        ;
CLOSE(HLCSTATE) ;
        N MCODE
        S MCODE="D "_HLCSTATE("CLOSE")_"(.HLCSTATE)"
        X MCODE
        S HLCSTATE("CONNECTED")=0
        Q
        ;
WRITESEG(HLCSTATE,SEG)  ;
ZB14    N RETURN
        N MCODE
        S MCODE="S RETURN=$$"_HLCSTATE("WRITE SEGMENT")_"(.HLCSTATE,.SEG)"
        X MCODE
ZB15    Q RETURN
        ;
WRITEHDR(HLCSTATE,HDR)  ;
ZB16    N SUCCESS
        N MCODE
        S MCODE="S SUCCESS=$$"_HLCSTATE("WRITE HEADER")_"(.HLCSTATE,.HDR)"
        X MCODE
ZB17    Q SUCCESS
        ;
ENDMSG(HLCSTATE)        ;
ZB18    N RETURN
        N MCODE
        S MCODE="S RETURN=$$"_HLCSTATE("END MESSAGE")_"(.HLCSTATE)"
        X MCODE
ZB19    Q RETURN
