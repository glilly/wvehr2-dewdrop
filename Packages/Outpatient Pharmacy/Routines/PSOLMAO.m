PSOLMAO ;BHAM ISC/LC - ACTIVE ORDERS ;03/14/1995
        ;;7.0;OUTPATIENT PHARMACY;**225**;DEC 1997;Build 29
EN      ; -- main entry point for PSO LM ACTION ORDER
        D EN^VALM("PSO LM ACTIVE ORDERS")
        Q
        ;
HDR     ; -- header code
        ;S VALMHDR(1)="This is a test header for PSO LM ACTION ORDER."
        ;S VALMHDR(2)="This is the second line"
        D HDR^PSOLMUTL
        Q
        ;
INIT    ; -- init variables and list array
        ;F LINE=1:1:30 D SET^VALM10(LINE,LINE_"     Line number "_LINE)
        S VALMCNT=PSOPF
        D RV^PSOORFL
        Q
        ;
HELP    ; -- help code
        S X="?" D DISP^XQORM1 W !!
        Q
        ;
EXIT    ; -- exit code
        S PSOQFLG=1 Q
        ;
EXPND   ; -- expand code
        Q
        ;
