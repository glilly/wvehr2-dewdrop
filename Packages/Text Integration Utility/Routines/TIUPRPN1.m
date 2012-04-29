TIUPRPN1        ;SLC/JER - Print SF 509-Progress Notes ;11/23/07
        ;;1.0;TEXT INTEGRATION UTILITIES;**45,52,87,100,162,182,211,222,234,233**;Jun 20, 1997;Build 3
        ;
        ; EXTERNAL REFERENCE - DBIA 10040  ^SC(D0,0)
        ;
PRINT(TIUFLAG,TIUSPG)   ; Print Document
        ; ^TMP("TIUPR",$J) is array of records to be printed
        ; TIUFLAG=1 --> Chart Copy     TIUSPG=1 --> Contiguous
        ; TIUFLAG=0 --> Work Copy      TIUSPG=0 --> Fresh Page- each note
        ; TIUCONT=1 --> Continue printing
        ; TIUCONT1=1 --> Write "Continue to next/from previous-page" msgs
        ; TIUPFNBR ---> Print Form # like vice 509
        ; TIUMISC=TIUFLAG_U_TIUPFNBR_U_TIUDA
        N CONT,TIUASK,TIUI,TIUJ,TIUKID,TIUPAGE,TIUFOOT,TIUK,TIUDA,TIUCONT,TIUPGRP,TIUTYP
        N TIUPFHDR,TIUPFNBR,TIUMISC,TIUCONT1,TIUIDONE,TMP
        S TIUFLAG=+$G(TIUFLAG),TIUSPG=+$G(TIUSPG)
        S (CONT,TIUCONT)=1,(TIUASK,TIUCONT1)=0
        S TIUI=0 F  S TIUI=$O(^TMP("TIUPR",$J,TIUI)) Q:TIUI=""  D  Q:'TIUCONT
        . N DFN,TIU
        . ; -- P182 TIUI has form PGRP$PFHDR;DFN with PGRP possibly 0, and
        . ;    PFHDR possibly null (see TIURA):
        . S TIUPGRP=+$P(TIUI,"$"),TIUPFHDR=$P($P(TIUI,";"),"$",2)
        . I TIUPFHDR']"" S TIUPFHDR="Progress Notes"
        . S DFN=$P(TIUI,";",2)
        . I $G(TIUPGRP)>2 S TIUSPG=0
        . D PATPN^TIULV(.TIUFOOT,DFN)
        . I +$G(TIUSPG) D HEADER^TIUPRPN2(.TIUFOOT,TIUFLAG,.TIUPFHDR,TIUCONT1)
        . ; Use TIUJ="" (not TIUJ=0), to print "complete" notes w/o sigdt:
        . S TIUJ="" F  S TIUJ=$O(^TMP("TIUPR",$J,TIUI,TIUJ)) Q:TIUJ=""  D  Q:'TIUCONT
        . . S TIUK=0 F  S TIUK=$O(^TMP("TIUPR",$J,TIUI,TIUJ,TIUK)) Q:'TIUK  D  Q:'TIUCONT
        . . . S TIUCONT1=0 S TIUPFNBR=^TMP("TIUPR",$J,TIUI,TIUJ,TIUK)
        . . . ; Note: TIUPFNBR may be null
        . . . ;P182 Set TIUMISC BEFORE quitting if deleted
        . . . S TIUDA=TIUK,TIUMISC=TIUFLAG_U_TIUPFNBR_U_TIUDA
        . . . ; Quit docmt if deleted:
        . . . I '$D(^TIU(8925,+TIUDA,0)) D  Q
        . . . . S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . . . . W !!,"NOTE DATED:",!,"Document #",TIUDA," for ",$G(TIUFOOT("PNMP")),!,"no longer exists in the TIU DOCUMENT file.",!!!
        . . . . S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT))
        . . . N TIUROOT
        . . . I '+$G(TIUSPG) D HEADER^TIUPRPN2(.TIUFOOT,TIUFLAG,.TIUPFHDR,TIUCONT1)
        . . . K ^TMP("TIULQ",$J)
        . . . D EXTRACT^TIULQ(+TIUDA,"^TMP(""TIULQ"",$J)",.TIUERR,"","",1)
        . . . I +$G(TIUERR) W !,$P(TIUERR,U,2) Q
        . . . Q:'$D(^TMP("TIULQ",$J))
        . . . S TIUROOT="^TMP(""TIULQ"",$J,"_TIUDA_")"
        . . . D REPORT(TIUROOT,.TIUFOOT,TIUMISC,.TIUCONT) Q:'TIUCONT
        . . . D IDKIDS(TIUROOT,.TIUFOOT,TIUMISC,TIUCONT1,.TIUCONT) Q:'TIUCONT
        . . . I '+$G(TIUKID),'+$G(TIUSPG) S TIUCONT1=0 S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,1,$G(TIUROOT))
        . Q:'TIUCONT
        . I $E(IOST,1,2)="C-" S TIUCONT=$$STOP^TIUPRPN2() Q:'TIUCONT
        . I '+$G(TIUKID),+$G(TIUSPG),$E(IOST,1,2)'="C-" S TIUCONT1=0 S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,1,$G(TIUROOT))
        Q
        ;
REPORT(TIUROOT,TIUFOOT,TIUMISC,TIUCONT,TIUIDEND)        ; Report Text
        ; Requires array TIUFOOT, vars TIUMISC, TIUCONT
        ; Requires TIUROOT =
        ; ^TMP("TIULQ",$J,NOTEIFN) for parent/stand-alone note, or
        ; ^TMP("TIULQ",$J,NOTEIFN,"ZADD",ADDMIFN) for addendum, or
        ; ^TMP("TIULQ",$J,NOTEIFN,"ZZID",KIDSEQ#,IDKIDIFN) for ID kid, or
        ; ^TMP("TIULQ",$J,NOTEIFN,"ZZID",KIDSEQ#,IDKIDIFN,"ZADD",KIDADDMIFN)
        ;       for ID kid addm.
        N DIW,DIWF,DIWL,DIWR,DIWT,TIUERR,TIU,TIUI,X,Z,LOC
        N REFDT,TITLE,LOINCNM,ADT,HLOC,SUBJ
        N TIUDA,TIUCONT1,HASIDKID,HASIDDAD
        S TIUDA=$P(TIUMISC,U,3),TIUCONT1=0
        S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        S HASIDKID=$G(^TMP("TIULQ",$J,TIUDA,"ZZID",0)) ;how many ID kids
        S HASIDDAD=$S(TIUROOT["ZZID":1,1:0)
        I HASIDKID W "<< Interdisciplinary Note - Begin >>",!
        I HASIDDAD W "<< Interdisciplinary Note - Cont. >>",!
        W $S('HASIDKID&'HASIDDAD:"NOTE DATED: ",1:"ENTRY DATED: ")
        S REFDT=@TIUROOT@(1301,"I")
        W $$DATE^TIULS(REFDT,"MM/DD/CCYY HR:MIN")
        S TITLE=@TIUROOT@(.01,"E"),LOINCNM=@TIUROOT@(89261,"E")
        W !,"LOCAL TITLE: ",$$UP^XLFSTR(TITLE),!
        I $L(LOINCNM)>1 W "STANDARD TITLE: ",$$UP^XLFSTR(LOINCNM),!
        S LOC=$G(@TIUROOT@(1205,"I"))
        I +LOC D
        . W $S($P(^SC(LOC,0),U,3)="W":"ADMITTED: ",1:"VISIT: ")
        . S ADT=$G(@TIUROOT@(.07,"I"))
        . W $$DATE^TIULS(ADT,"MM/DD/CCYY HR:MIN")
        . S HLOC=$G(@TIUROOT@(1205,"E"))
        . W " ",HLOC
        S SUBJ=$G(@TIUROOT@(1701,"E"))
        I SUBJ]"" W !,"SUBJECT: ",^("E"),! ; @TIUROOT@(1701,"E")
        S TIUCONT1=1
        I $D(@TIUROOT@("PROBLEM")) D  Q:'TIUCONT
        . S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . W !,"ASSOCIATED PROBLEMS:"
        . N TIUI S TIUI=0
        . F  S TIUI=$O(@TIUROOT@("PROBLEM",TIUI)) Q:'TIUI  D  Q:'TIUCONT
        ..W !,^(TIUI,0) ; @TIUROOT@("PROBLEM",TIUI,0)
        ..S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        W !
        S TIUI=0,DIWF="WN",DIWL=1,DIWR=79 K ^UTILITY($J,"W")
        F  S TIUI=$O(@TIUROOT@("TEXT",TIUI)) Q:TIUI'>0  D  Q:'TIUCONT  ; D ^DIWW
        . S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . S X=@TIUROOT@("TEXT",TIUI,0) S:X="" X=" " D ^DIWP
        D ^DIWW K ^UTILITY($J,"W")
        Q:'TIUCONT
        D GETSIG(TIUROOT,.TIUSIG)
        S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        W !
        D SIGBLK^TIUPRPN8(.TIUFOOT,TIUMISC,TIUCONT1,.TIUCONT,.TIUSIG,TIUROOT)
        Q:'TIUCONT
ADDENDA ; Fall through and do Addenda of docmt TIUDA
        N DIW,DIWF,DIWL,DIWR,DIWT,X,Z,TIUI,TIUADD,ADDMRDT
        S TIUADD=0,DIWF="WN",DIWL=1,DIWR=79 K ^UTILITY($J,"W")
        ; VM/RJT - *233 - quit if addendum status is unreleased (=3)
        F  S TIUADD=$O(@TIUROOT@("ZADD",TIUADD)) Q:TIUADD'>0  Q:$P($G(^TIU(8925,TIUADD,0)),U,5)=3  D  Q:'TIUCONT
        . S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . S ADDMRDT=@TIUROOT@("ZADD",TIUADD,1301,"I")
        . W !!,$$DATE^TIULS(ADDMRDT,"MM/DD/CCYY HR:MIN"),?21,"ADDENDUM"
        . W ?39,"STATUS: ",@TIUROOT@("ZADD",TIUADD,.05,"E") ;P162
        . S TIUI=0
        . F  S TIUI=$O(@TIUROOT@("ZADD",TIUADD,"TEXT",TIUI)) Q:TIUI'>0  D  Q:'TIUCONT
        . . S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,0,$G(TIUROOT)) Q:'TIUCONT
        . . S X=@TIUROOT@("ZADD",TIUADD,"TEXT",TIUI,0) S:X="" X=" " D ^DIWP
        . D ^DIWW
        . Q:'TIUCONT
        . N TIUADRT
        . S TIUADRT=$P(TIUROOT,")")_",""ZADD"","_TIUADD_")"
        . D GETSIG(TIUADRT,.TIUSIG)
        . D SIGBLK^TIUPRPN8(.TIUFOOT,TIUMISC,TIUCONT1,.TIUCONT,.TIUSIG,TIUADRT)
        ; Need ! in front for amended notes:
        I $G(TIUIDEND) W !,"<< Interdisciplinary Note - End >>",!
        K ^UTILITY($J,"W")
        ; Write 2 linefeeds between records
        S:$E(IOST,1,2)="C-" TIUCONT=$$STOP^TIUFLP1,TIUASK=1
        W:TIUCONT !!
        Q
        ;
IDKIDS(TIUROOT,TIUFOOT,TIUMISC,TIUCONT1,TIUCONT)        ; Print ID kids
        ;of docmt TIUDA (each kid does its own addenda)
        N TIUL,KIDDA,TIUDA,TIUSORT,TIUIDRT,TIUIDEND
        S TIUDA=$P(TIUMISC,U,3),TIUIDEND=0
        S TIUL=0
        F  S TIUL=$O(^TMP("TIULQ",$J,TIUDA,"ZZID",TIUL)) Q:'TIUL  D  Q:'TIUCONT
        . S KIDDA=$O(^TMP("TIULQ",$J,TIUDA,"ZZID",TIUL,0))
        . I +$$MEMBEROF^TIUPR222(+$G(^TIU(8925,+KIDDA,0)),"FORM LETTERS") D  Q  ; hand off to TIUFLP1 (Form Letter Print)
        . . I '+$G(TIUKID),'+$G(TIUSPG) S TIUCONT1=0 S TIUCONT=$$SETCONT(.TIUFOOT,TIUMISC,TIUCONT1,1,$G(TIUROOT))
        . . I 'TIUCONT!'CONT Q
        . . I $E(IOST,1,2)="C-",'+TIUASK S CONT=$$STOP^TIUFLP1,TIUCONT=CONT Q:'+CONT
        . . S TIUASK=0,TIUKID=1 D IDKID^TIUFLP1(TIUDA,KIDDA)
        . S TIUMISC=TIUFLAG_U_TIUPFNBR_U_KIDDA
        . S TIUIDRT="^TMP(""TIULQ"",$J,"_TIUDA_",""ZZID"","_TIUL_","_KIDDA_")"
        . I '$O(^TMP("TIULQ",$J,TIUDA,"ZZID",TIUL)) S TIUIDEND=1
        . D REPORT(TIUIDRT,.TIUFOOT,TIUMISC,.TIUCONT,TIUIDEND)
        Q
        ;
GETSIG(TIUROOT,TIUSIG)  ; Get signature info from TIULQ global;
        ; Set info into TIUSIG array **100**
        ; Requires array name TIUROOT; passes back array TIUSIG
        ; TIUROOT = ^TMP("TIULQ",$J,NOTEIFN) for parent note, or
        ;           ^TMP("TIULQ",$J,NOTEIFN,"ZADD",ADDMIFN) for addendum, or
        ;           ^TMP("TIULQ",$J,NOTEIFN,"ZZID",IDKIDIFN) for ID kid.
        ; Signature should be on bottom of form, Addenda on Subsequent pages
        N TIULINE S $P(TIULINE,"-",81)=""
        S TIUSIG("AUTHOR")=$G(@TIUROOT@(1202,"I"))_";"_$G(^("E"))
        S TIUSIG("EXPSIGNR")=$G(@TIUROOT@(1204,"I"))_";"_$G(^("E"))
        S TIUSIG("EXPCOSNR")=$G(@TIUROOT@(1208,"I"))_";"_$G(^("E"))
        S TIUSIG("SIGNDATE")=$G(@TIUROOT@(1501,"I"))
        S TIUSIG("SIGNEDBY")=$G(@TIUROOT@(1502,"I"))_";"_$G(^("E"))
        S TIUSIG("SIGNNAME")=$G(@TIUROOT@(1503,"E"))
        S TIUSIG("SIGTITL")=$G(@TIUROOT@(1504,"E"))
        S TIUSIG("SIGNMODE")=$G(@TIUROOT@(1505,"I"))_";"_$G(^("E"))
        S TIUSIG("COSGDATE")=$G(@TIUROOT@(1507,"I"))
        S TIUSIG("COSGEDBY")=$G(@TIUROOT@(1508,"I"))_";"_$G(^("E"))
        S TIUSIG("COSGNAME")=$G(@TIUROOT@(1509,"E"))
        S TIUSIG("COSGTITL")=$G(@TIUROOT@(1510,"E"))
        S TIUSIG("COSGMODE")=$G(@TIUROOT@(1511,"I"))_";"_$G(^("E"))
        S TIUSIG("SIGCHRT")=$G(@TIUROOT@(1512,"I"))_";"_$G(^("E"))
        S TIUSIG("COSCHRT")=$G(@TIUROOT@(1513,"I"))_";"_$G(^("E"))
        ; -- P182 Set Admin Clos Date:
        S TIUSIG("ADMINCDT")=$G(@TIUROOT@(1606,"I"))_";"_$G(^("E"))
        Q
        ;
SETCONT(TIUFOOT,TIUMISC,TIUCONT1,TIUHEAD,TIUROOT)       ;Does footer
        ;and returns TIUCONT
        ; Requires array TIUFOOT, vars TIUMISC,TIUCONT1; optional TIUHEAD
        ; Optional TIUROOT
        Q $$FOOTER^TIUPRPN2(.TIUFOOT,TIUMISC,TIUCONT1,TIUHEAD,$G(TIUROOT))
