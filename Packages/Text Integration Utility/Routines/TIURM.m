TIURM   ; SLC/JER - MIS Document Review ;9/24/03
        ;;1.0;TEXT INTEGRATION UTILITIES;**74,79,58,100,113,216,224**;Jun 20, 1997;Build 7
        ;12/7/00 split TIURM into TIURM & TIURM1
MAKELIST(TIUCLASS)      ; Get Search Criteria
        N DIRUT,DTOUT,DUOUT,TIUI,STATUS,TIUTYP,TIUSTAT,TIUEDFLT,TIUDCL
        N TIUDPRMT,STATWORD,STATIFN,NOWFLAG,TIUK
        K DIROUT
        D INITRR^TIULRR(0)
DIVISION        ; Select Division(s)
        D SELDIV^TIULA
        I SELDIV'>0 S VALMQUIT=1 Q
        I $D(TIUDI) D
        . S TIUK=0 F  S TIUK=$O(TIUDI(TIUK)) Q:'TIUK  D
        . . S TIUDI("ENTRIES")=$G(TIUDI("ENTRIES"))_TIUK_";"
        E  S TIUDI("ENTRIES")="ALL DIVISIONS"
STATUS  S STATUS=$S($D(TIUQUIK):$$SELSTAT^TIULA(.TIUSTAT,"F","UNSIGNED,UNCOSIGNED"),1:$$SELSTAT^TIULA(.TIUSTAT,"A",$$DFLTSTAT(DUZ)))
        ;VMP/ELR changed status ck from <0 TO <1 to account for entering an *  p224
        I +STATUS<1 S VALMQUIT=1 Q
        S TIUI=0
        F  S TIUI=$O(TIUSTAT(TIUI)) Q:'TIUI  D
        . S STATIFN=$O(^TIU(8925.6,"B",$$UPPER^TIULS($P(TIUSTAT(TIUI),U,3)),0))
        . Q:'STATIFN
        . S STATUS("IFNS")=$G(STATUS("IFNS"))_STATIFN_";"
        S TIUI=1,STATWORD=$$UPPER^TIULS($P(TIUSTAT(1),U,3))
        I +$G(TIUSTAT(4))'>0 F  S TIUI=$O(TIUSTAT(TIUI)) Q:+TIUI'>0  D
        . S STATWORD=STATWORD_$S(TIUI=+TIUSTAT(1):" & ",1:", ")_$$UPPER^TIULS($P(TIUSTAT(TIUI),U,3))
        I +$G(TIUSTAT(4))>0 S STATWORD=$S($P(TIUSTAT(4),U,4)="ALL":"ALL",1:STATWORD_", OTHER")
        S STATUS("WORDS")=STATWORD
DOCTYPE ; Select Document Type(s)
        N TIUDCL
        ; -- Ask user for docmt types and set ^TMP("TIUTYP",$J):
        D SELTYP^TIULA(TIUCLASS,.TIUTYP,"A","LAST","DOC",0,.TIUDCL)
        I +$G(DIROUT) S VALMQUIT=1 Q
        I +$G(@TIUTYP)'>0,'$D(TIUQUIK) K @TIUTYP G STATUS
        D CHECKADD
ERLY    S TIUEDFLT=$S(TIUCLASS=3:"T-2",TIUCLASS=244:"T-30",1:"T-7")
        S TIUDPRMT="Entry"
        S TIUEDT=$S($D(TIUQUIK):1,1:$$EDATE^TIULA(TIUDPRMT,"",TIUEDFLT))
        I +$G(DIROUT) S VALMQUIT=1 Q
        I TIUEDT'>0 K @TIUTYP G DOCTYPE
LATE    S TIULDT=$S($D(TIUQUIK):9999999,1:$$LDATE^TIULA(TIUDPRMT))
        I +$G(DIROUT) S VALMQUIT=1 Q
        I TIULDT'>0 G ERLY
        I TIUEDT>TIULDT D SWAP(.TIUEDT,.TIULDT)
        I $L(TIULDT,".")=1 D EXPRANGE(.TIUEDT,.TIULDT) ; P74.  Add late date time whether or not late date is same as early date.
        ; -- Reset late date to NOW on rebuild:
        S NOWFLAG=$S(TIULDT-$$NOW^XLFDT<.0001:1,1:0)
        I '$G(TIURBLD) W !,"Searching for the documents."
        D BUILD(TIUCLASS,.STATUS,TIUEDT,TIULDT,NOWFLAG,.TIUDI)
        ; -- If attaching ID note & changed view,
        ;    update video for line to be attached: --
        I $G(TIUGLINK) D RESTOREG^TIULM(.TIUGLINK)
        K TIUDI,SELDIV
        Q
CHECKADD        ; Checks whether Addendum is included in the list of types
        N TIUI,HIT,NUMTYPS
        S (TIUI,HIT)=0
        F  S TIUI=$O(^TMP("TIUTYP",$J,TIUI)) Q:+TIUI'>0!+HIT  I $$UP^XLFSTR(^TMP("TIUTYP",$J,TIUI))["ADDENDUM" S HIT=1
        S NUMTYPS=^TMP("TIUTYP",$J)
        I +HIT'>0 S ^TMP("TIUTYP",$J,NUMTYPS+1)=+^TMP("TIUTYP",$J,NUMTYPS)+1_U_"81^Addendum^NOT PICKED",^TMP("TIUTYP",$J)=^TMP("TIUTYP",$J)+1
        Q
SWAP(TIUX,TIUY) ; Swap any two variables
        N TIUTMP S TIUTMP=TIUX,TIUX=TIUY,TIUY=TIUTMP
        Q
EXPRANGE(TIUX,TIUY)     ; Expand late date to include time
        ;P74 If user entered date/time = T, then numerical date time is FIRST ^ PIECE ONLY of TIUX & TIUY.
        I $P(TIUY,U)=DT S TIUY=$$NOW^XLFDT I 1
        E  S TIUY=$P(TIUY,U)_"."_235959 ;P74 Add seconds
        Q
BUILD(TIUCLASS,STATUS,EARLY,LATE,NOWFLAG,TIUDI) ; Build List
        N TIUPREF
        S TIUPREF=$$PERSPRF^TIULE(DUZ)
        K ^TMP("TIUR",$J),^TMP("TIURIDX",$J),^TMP("TIUI",$J)
        ; If user entered NOW at first build, update NOW for rebuild;
        ; Save data in ^TMP("TIURIDX",$J,0) for rebuild:
        I $G(TIURBLD),$G(NOWFLAG) S LATE=$$NOW^XLFDT
        S ^TMP("TIURIDX",$J,0)=+EARLY_U_+LATE_U_$G(STATUS("IFNS"))_U_NOWFLAG
        S ^TMP("TIUR",$J,"RTN")="TIURM"
        I '$D(TIUPRM0)!'$D(TIUPRM0) D SETPARM^TIULE
        S EARLY=+$G(EARLY,0),LATE=+$G(LATE,3333333)
        D GATHER^TIURM1(TIUPREF,TIUCLASS,STATUS("IFNS"),EARLY,LATE,.TIUDI)
        D PUTLIST^TIURM1(TIUPREF,TIUCLASS,.STATUS,.TIUDI)
        K ^TMP("TIUI",$J)
        Q
CLEAN   ; Clean up your mess!
        K ^TMP("TIUR",$J),^TMP("TIURIDX",$J) D CLEAN^VALM10,KILLRR^TIULRR
        K VALMY
        K ^TMP("TIUTYP",$J)
        Q
URGENCY(TIUDA)  ; What is the urgency of the current document
        N TIUY,TIUD0,TIUDSTAT,TIUDURG
        S TIUD0=$G(^TIU(8925,+TIUDA,0)),TIUDSTAT=$P(TIUD0,U,5)
        S TIUDURG=$P(TIUD0,U,9)
        S TIUY=$S(TIUDSTAT<7:$S(TIUDURG="P":1,1:2),1:3)
        Q TIUY
DFLTSTAT(USER)  ; Set default STATUS for current user
        N TIUMIS,TIUMD,TIUY,TIUDPRM D DOCPRM^TIULC1(244,.TIUDPRM)
        S TIUMIS=$$ISA^USRLM(DUZ,"MEDICAL INFORMATION SECTION")
        I +TIUMIS,+$P($G(TIUDPRM(0)),U,3) S TIUY="UNVERIFIED" G DFLTX
        I $$ISA^USRLM(DUZ,"PROVIDER") S TIUY="COMPLETED" G DFLTX
        S TIUY="COMPLETED"
DFLTX   Q TIUY
        ;
RBLD    ; Rebuild list after actions 11/30/00
        N TIUEXP,TIUR0,TIURIDX0,TIUEDT,TIULDT
        N TIURBLD,TIUI,TIUCLASS,TIUDI,TIUSCRN
        S TIURBLD=1
        D FIXLSTNW^TIULM ;restore video for elements added to end of list
        I +$O(^TMP("TIUR",$J,"EXPAND",0)) D
        . M TIUEXP=^TMP("TIUR",$J,"EXPAND")
        S TIUR0=^TMP("TIUR",$J,0),TIURIDX0=^TMP("TIURIDX",$J,0)
        S TIUCLASS=^TMP("TIUR",$J,"CLASS")
        S STATUS("WORDS")=$P(TIUR0,U,2)
        S STATUS("IFNS")=$P(TIURIDX0,U,3)
        S TIUEDT=$P(TIURIDX0,U),TIULDT=$P(TIURIDX0,U,2),NOWFLAG=+$P(TIURIDX0,U,4)
        M TIUDI=^TMP("TIUR",$J,"DIV")
        ;VMP/ELR ADDED THE FOLLOWING LINE IN PATCH 224
        S TIUSCRN="ALL"
        D BUILD(TIUCLASS,.STATUS,TIUEDT,TIULDT,NOWFLAG,.TIUDI)
        ; Reexpand previously expanded items:
        D RELOAD^TIUROR1(.TIUEXP)
        D BREATHE^TIUROR1(1)
        Q
