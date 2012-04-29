TIUPRPN8        ;SLC/MAM - Print SF 509-Progress Notes, Cont ;11/10/04 [1/4/05 12:17pm]
        ;;1.0;TEXT INTEGRATION UTILITIES;**100,176,157,182,224**;Jun 20, 1997;Build 7
        ;
SIGBLK(TIUFOOT,TIUMISC,TIUCONT1,TIUCONT,TIUSIG,TIUROOT) ; Print signature block info
        ; Requires array TIUFOOT, requires TIUMISC
        ; Requires TIUCONT1
        ; Receives TIUCONT by ref (req'd)
        ; Receives array TIUSIG by ref, required.
        ; Requires TIUROOT
        N TIUDA,TIUFLAG
        S TIUCONT=1,TIUDA=$P(TIUMISC,U,3),TIUFLAG=$P(TIUMISC,U)
        ;S TIUGROOT=$NA(^TMP("TIULQ",$J,TIUDA))
        ; -- P182 Don't marked admin signed notes as draft:
        I '+TIUSIG("SIGNDATE"),'+TIUSIG("ADMINCDT") D  Q:'TIUCONT
        . W "**DRAFT COPY - DRAFT COPY -- ABOVE NOTE IS UNSIGNED--"
        . W " DRAFT COPY - DRAFT COPY**",!
        . S TIUCONT=$$SETCONT^TIUPRPN1(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT))
        ;I TIUSIG("SIGNEDBY")]"",(+TIUSIG("SIGNEDBY")'=+TIUSIG("AUTHOR"))  D
        ;. W ?21,"Author:      ",$P(TIUSIG("AUTHOR"),";",2),!
        I +TIUSIG("SIGNDATE") D  Q:'TIUCONT
        . S TIUCONT=$$SETCONT^TIUPRPN1(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . W ?18,"Signed by:",$S($P(TIUSIG("SIGNMODE"),";")="C":" /s/  ",1:" /es/ "),?34,$S(TIUSIG("SIGNNAME")]"":TIUSIG("SIGNNAME"),1:$P(TIUSIG("SIGNEDBY"),";",2))
        . I $L(TIUSIG("SIGTITL"))>45 D
        . . N TIUFT
        . . D WRAP^TIUFLD(TIUSIG("SIGTITL"),45)
        . . W !?34,$G(TIUFT(1))
        . . W !?39,$G(TIUFT(2))
        . I $L(TIUSIG("SIGTITL"))<46,TIUSIG("SIGTITL")]"" W !?34,TIUSIG("SIGTITL")
        . W !?34,$$DATE^TIULS(+TIUSIG("SIGNDATE"),"MM/DD/CCYY HR:MIN")
        . I '+$G(TIUFLAG)!($E(IOST)="C-") D
        . . I $P($$BEEP^TIULC1(+TIUSIG("SIGNEDBY")),U) W !?34,"Analog Pager: ",$P($$BEEP^TIULC1(+TIUSIG("SIGNEDBY")),U)
        . . I $P($$BEEP^TIULC1(+TIUSIG("SIGNEDBY")),U,2) W !?34,"Digital Pager: ",$P($$BEEP^TIULC1(+TIUSIG("SIGNEDBY")),U,2)
        I $P(TIUSIG("SIGNMODE"),";")="C" D  Q:'TIUCONT
        . S TIUCONT=$$SETCONT^TIUPRPN1(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . N TIUONCH
        . S TIUONCH=$P(TIUSIG("SIGCHRT"),";",2)
        . I TIUONCH']"" S TIUONCH=$P(TIUSIG("COSCHRT"),";",2)
        . W !?2,"Marked signed on chart by:",?34,$G(TIUONCH)
        ; -- If signer is not author, write "for the author":
        ;    P182 SIGNEDBY may =";" and follow null even when no signer:
        ;I TIUSIG("SIGNEDBY")]"",(+TIUSIG("SIGNEDBY")'=+TIUSIG("AUTHOR"))  D
        I TIUSIG("SIGNEDBY")]"",(TIUSIG("SIGNEDBY")'=";"),(+TIUSIG("SIGNEDBY")'=+TIUSIG("AUTHOR"))  D
        . N TIUSIGTL
        . W !?34,"for ",$P(TIUSIG("AUTHOR"),";",2)
        . S TIUSIGTL=$$GET1^DIQ(200,$P(TIUSIG("AUTHOR"),";",1),20.3)
        . I $D(TIUSIGTL) D
        . . N TIUFT
        . . D WRAP^TIUFLD(TIUSIGTL,45)
        . . W !?34,$G(TIUFT(1))
        . . W !?39,$G(TIUFT(2))
        I $G(@TIUROOT@(.05,"E"))="UNCOSIGNED" D
        . W !?34,"**REQUIRES COSIGNATURE**",!
        ;I +$G(TIUADD) S TIUGROOT=$NA(^TMP("TIULQ",$J,TIUDA,"ZADD",TIUADD))
        I +$D(@TIUROOT@("EXTRASGNR")) D  Q:'TIUCONT  ;**100** added the quit
        . N TIUI S TIUI=0
        . S TIUCONT=$$SETCONT^TIUPRPN1(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . F  S TIUI=$O(@TIUROOT@("EXTRASGNR",TIUI)) Q:'TIUI  D
        . . W !!?4,"Receipt Acknowledged By:"
        . . ;VMP/ELR P224 ADDED code to print awaiting signature and expected additional signer name
        . . I +$G(@TIUROOT@("EXTRASGNR",TIUI,"DATE"))'>0 D  Q
        . . . W !,?4,"* AWAITING SIGNATURE *",?30,$G(@TIUROOT@("EXTRASGNR",TIUI,"EXPNAME"))
        . . I TIUI>1 S TIUCONT=$$SETCONT^TIUPRPN1(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . . W !?29,"/es/ ",$G(@TIUROOT@("EXTRASGNR",TIUI,"NAME"))
        . . I $L($G(@TIUROOT@("EXTRASGNR",TIUI,"TITLE")))>45 D
        . . . N TIUFT
        . . . D WRAP^TIUFLD($G(@TIUROOT@("EXTRASGNR",TIUI,"TITLE")),45)
        . . . W !?34,$G(TIUFT(1))
        . . . W !?39,$G(TIUFT(2))
        . . I $L($G(@TIUROOT@("EXTRASGNR",TIUI,"TITLE")))<46 W !?34,$G(@TIUROOT@("EXTRASGNR",TIUI,"TITLE"))
        . . I $G(@TIUROOT@("EXTRASGNR",TIUI,"EXTRA")),$G(@TIUROOT@("EXTRASGNR",TIUI,"EXPIEN"))'=$G(@TIUROOT@("EXTRASGNR",TIUI,"EXTRA")) D
        . . . W !?30,"for ",$P($G(@TIUROOT@("EXTRASGNR",TIUI,"EXPNAME")),",",2)
        . . . W " ",$P($G(@TIUROOT@("EXTRASGNR",TIUI,"EXPNAME")),",")
        . . W !?34,$$DATE^TIULS($G(@TIUROOT@("EXTRASGNR",TIUI,"DATE")),"MM/DD/CCYY HR:MIN")
        . . I '+$G(TIUFLAG)!($E(IOST)="C-") D
        . . . N BEEP
        . . . S BEEP=$$BEEP^TIULC1(+$G(@TIUROOT@("EXTRASGNR",TIUI,"EXTRA")))
        . . . I +BEEP W !?34,"Analog Pager:  ",$P(BEEP,U)
        . . . I +$P(BEEP,U,2) W !?34,"Digital Pager: ",$P(BEEP,U,2)
        . ;K @TIUROOT@("EXTRASGNR") ;**100** commented out
        ;I +TIUSIG("COSGDATE"),(+TIUSIG("COSGEDBY")'=+TIUSIG("SIGNEDBY")) D  Q:'TIUCONT
        I +TIUSIG("COSGDATE") D  Q:'TIUCONT
        . S TIUCONT=$$SETCONT^TIUPRPN1(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . W !!?16,"Cosigned by:",$S($P(TIUSIG("COSGMODE"),";")="C":" /s/  ",1:" /es/ "),?34,$S(TIUSIG("COSGNAME")]"":TIUSIG("COSGNAME"),1:$P(TIUSIG("COSGEDBY"),";",2))
        . I $L(TIUSIG("COSGTITL"))>45 D
        . . N TIUFT
        . . D WRAP^TIUFLD(TIUSIG("COSGTITL"),45)
        . . W !?34,$G(TIUFT(1))
        . . W !?39,$G(TIUFT(2))
        . I $L(TIUSIG("COSGTITL"))<46 W !?34,TIUSIG("COSGTITL")
        . W !?34,$$DATE^TIULS(+TIUSIG("COSGDATE"),"MM/DD/CCYY HR:MIN")
        . I '+$G(TIUFLAG)!($E(IOST)="C-") D
        . . I $P($$BEEP^TIULC1(+TIUSIG("COSGEDBY")),U) W !?34,"Analog Pager: ",$P($$BEEP^TIULC1(+TIUSIG("COSGEDBY")),U)
        . . I $P($$BEEP^TIULC1(+TIUSIG("COSGEDBY")),U,2) W !?34,"Digital Pager: ",$P($$BEEP^TIULC1(+TIUSIG("COSGEDBY")),U,2)
        ;I +TIUSIG("COSCHRT"),$P(TIUSIG("COSGMODE"),";")="C" D  Q:'TIUCONT
        I $P(TIUSIG("COSGMODE"),";")="C" D  Q:'TIUCONT
        . S TIUCONT=$$SETCONT^TIUPRPN1(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . W !,"Marked cosigned on chart by:",?34,$P(TIUSIG("COSCHRT"),";",2)
        W !
        ;K TIUCONT1 ; kills the cont on next page msgs since no longer in middle
        ;of a note.  **100** moved down to amend code
AMEND   ; signature blocks of amender
        ;N TIUY S TIUY=4 ;I don't think we need TIUY anymore **100**
        I '$G(@TIUROOT@(1601,"I")) K TIUCONT1 Q
        S TIUCONT=$$SETCONT^TIUPRPN1(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT))
        K TIUCONT1 Q:'TIUCONT
        I +$G(@TIUROOT@(1601,"I")) D
        . W !!?12,"Amendment Filed:",?34,$$DATE^TIULS(@TIUROOT@(1601,"I"),"MM/DD/CCYY HR:MIN")
        . I $G(@TIUROOT@(1603,"E"))']"" D
        . . W !!?29 F TIUI=1:1:40 W "_"
        . . W !?29,$$SIGNAME^TIULS(@TIUROOT@(1602,"I"))
        . . W !?29,$$SIGTITL^TIULS(@TIUROOT@(1602,"I"))
        . I $G(@TIUROOT@(1604,"E"))]"" D
        . . W !?29,"/es/",?34,@TIUROOT@(1604,"E")
        . . W !?34,@TIUROOT@(1605,"E")
        Q
        ;
