ORWTIU  ; slc/REV - Functions for GUI PARAMETER ACTIONS ; 08 Feb 2001  09:02AM
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,85,109,132,195,243**;Dec 17, 1997;Build 242
        ;
GTTIUCTX(Y,ORUSER)      ; Returns current Notes view context for user
        N OCCLIM,SHOWSUB
        S Y=$$GET^XPAR("ALL","ORCH CONTEXT NOTES",1)
        I +$P(Y,";",5)=0 D
        . S OCCLIM=$P($$PERSPRF^TIULE(DUZ),U,10)
        . S:+OCCLIM>0 $P(Y,";",5)=OCCLIM
        S SHOWSUB=$P(Y,";",6)
        S $P(Y,";",6)=$S(SHOWSUB'="":SHOWSUB,1:0)
        Q
SVTIUCTX(Y,ORCTXT)      ; Save new Notes view preferences for user
        N TMP
        S TMP=$$GET^XPAR(DUZ_";VA(200,","ORCH CONTEXT NOTES",1)
        I TMP'="" D  Q
        . D CHG^XPAR(DUZ_";VA(200,","ORCH CONTEXT NOTES",1,ORCTXT)
        D ADD^XPAR(DUZ_";VA(200,","ORCH CONTEXT NOTES",1,ORCTXT)
        Q
        ;
GTDCCTX(Y,ORUSER)       ; Returns current DC Summary view context for user
        N OCCLIM,SHOWSUB
        S Y=$$GET^XPAR("ALL","ORCH CONTEXT SUMMRIES",1)
        I +$P(Y,";",5)=0 D
        . S OCCLIM=$P($$PERSPRF^TIULE(DUZ),U,10)
        . S:+OCCLIM>0 $P(Y,";",5)=OCCLIM
        S SHOWSUB=$P(Y,";",6)
        S $P(Y,";",6)=$S(SHOWSUB'="":SHOWSUB,1:0)
        Q
SVDCCTX(Y,ORCTXT)       ; Save new DC Summary view preferences for user
        N TMP
        S TMP=$$GET^XPAR(DUZ_";VA(200,","ORCH CONTEXT SUMMRIES",1)
        I TMP'="" D  Q
        . D CHG^XPAR(DUZ_";VA(200,","ORCH CONTEXT SUMMRIES",1,ORCTXT)
        D ADD^XPAR(DUZ_";VA(200,","ORCH CONTEXT SUMMRIES",1,ORCTXT)
        Q
        ;
PRINTW(ORY,ORDA,ORFLG)  ;TIU print to windows printer
        N ZTQUEUED,ORHFS,ORSUB,ORIO,ORSTATUS,ROOT,ORERR,ORWIN,ORHANDLE
        N IOM,IOSL,IOST,IOF,IOT,IOS
        S (ORSUB,ROOT)="ORDATA",ORIO="OR WINDOWS HFS",ORWIN=1,ORHANDLE="ORWTIU"
        S ORY=$NA(^TMP(ORSUB,$J,1))
        S ORHFS=$$HFS^ORWRP()
        D HFSOPEN^ORWRP(ORHANDLE,ORHFS,"W")
        I POP D  Q
        . I $D(ROOT) D SETITEM^ORWRP(.ROOT,"ERROR: Unable to open HFS file for TIU print")
        D IOVAR^ORWRP(.ORIO,,,"P-WINHFS80")
        N $ETRAP,$ESTACK
        S $ETRAP="D ERR^ORWRP Q"
        U IO
        D RPC^TIUPD(.ORERR,ORDA,ORIO,ORFLG,ORWIN)
        D HFSCLOSE^ORWRP(ORHANDLE,ORHFS)
        Q
GTLSTITM(ORY,ORTIUDA)   ; Return single listbox item for document
        Q:+$G(ORTIUDA)=0
        S ORY=ORTIUDA_U_$$RESOLVE^TIUSRVLO(ORTIUDA)
        Q
IDNOTES(ORY)       ; Is ID Notes installed?
        S ORY=$$PATCH^XPDUTL("TIU*1.0*100")
        Q
CANLINK(ORY,ORTITLE)       ;Can the title be an ID child?
        ; DBIA #2322
        S ORY=$$CANLINK^TIULP(ORTITLE)
        Q
GETCP(ORY,ORTIUDA)      ; Checks required CP fields before signature
        S ORY=""
        N ORTITLE,ORAUTH,ORCOS,ORPSUMCD,ORPROCDT,ORROOT,ORERR,ORREFDT
        S ORERR="",ORROOT=$NA(^TMP("ORTIU",$J))
        D EXTRACT^TIULQ(ORTIUDA,.ORROOT,.ORERR,".01;1202;1208;70201;70202;1301",,,"I")
        S ORTITLE=@ORROOT@(ORTIUDA,".01","I")
        S ORAUTH=@ORROOT@(ORTIUDA,"1202","I")
        S ORCOS=@ORROOT@(ORTIUDA,"1208","I")
        S ORPSUMCD=@ORROOT@(ORTIUDA,"70201","I")
        S ORPROCDT=@ORROOT@(ORTIUDA,"70202","I")
        S ORREFDT=@ORROOT@(ORTIUDA,"1301","I")
        S ORY=ORAUTH_U_ORCOS_U_ORPSUMCD_U_ORPROCDT_U_ORTITLE_U_ORREFDT
        K @ORROOT
        Q
CHKTXT(ORY,ORTIUDA)     ; Checks for presence of text before signature
        S ORY='$$EMPTYDOC^TIULF(ORTIUDA)  ;DBIA #4426
        Q
