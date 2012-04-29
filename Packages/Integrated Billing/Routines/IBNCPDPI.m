IBNCPDPI        ;DALOI/SS - for ECME SCREEN INSURANCE VIEW AND UTILITIES ;3/27/08  13:05
        ;;2.0;INTEGRATED BILLING;**276,383**;21-MAR-94;Build 11
        ;;Per VHA Directive 10-93-142, this routine should not be modified.
        ; -- main entry point
        Q
EN      ;
        Q
EN1(DFN)        ;
        I $G(DFN)'>0 Q
        Q:$$PFSSON()  ;quit if PFSS is ON
        N J,POP,START,X,VA,ALMBG,DIC,DT,C,CTRLCOL,DILN
        ;
        ;if the user does have IB keys to edit insurances
        I $D(^XUSEC("IB INSURANCE SUPERVISOR",DUZ))!($D(^XUSEC("IB INSURANCE COMPANY ADD",DUZ))) D  Q
        . N D1,DA,DDER,DDH,DIE,DR,I
        . N IBCH,IBCNS,IBCNSEH,IBCNT,IBCPOL,IBDT,IBDUZ,IBFILE,IBLCNT,IBN,IBNEW,IBPPOL
        . N IBTYP,IBYE,IBCDFN,IBCDFND1,IBCGN
        . D EN^VALM("IBNCPDP INSURANCE MANAGEMENT")
        ;if the user doesn't have insurance IB keys
        D
        . N D0,IBCAB,IBCDFN,IBCDFND1,IBCNS,IBCNT,IBCPOL,IBDT,IBEXP1
        . N IBEXP2,IBFILE,IBLCNT,IBN,IBPPOL
        . D EN1^IBNCPDPV(DFN)
        Q
        ;
INIT    ; -- set up initial variables
        ;DFN should be defined
        I '$D(DFN) Q
        S U="^",VALMCNT=0,VALMBG=1
        K ^TMP("IBNSM",$J),^TMP("IBNSMDX",$J)
        S IBTYP="P"
        D BLD^IBCNSM
        Q
        ;
HDR     ; -- screen header for initial screen
        D HDR^IBCNSM
        Q
        ;
HELP    ; -- help code
        Q
        ;
EXIT    ; -- exit code
        Q
        ;
EXPND   ; -- expand code
        Q
        ;
        ;check if PFSS On?
        ;returns:
        ; 1 - PFSS is ON
        ; 0 - PFSS is OFF or not installed
PFSSON()        ;
        N BPST
        S BPST=0
        I $L($T(SWSTAT^IBBAPI))>0 S BPST=+$$SWSTAT^IBBAPI()
        I BPST=1 D  Q 1
        . W !,"This functionality is not supported on PFSS sites." D PAUSE^VALM1
        Q 0
        ;**
        ;API for ECME (DBIA #4721)
        ;Insurance Company lookup API
        ;NOTE: PFSS needs to modify this code to return back values
        ;  from the appropriate PFSS file instead of ALL ("0")
        ;input:
        ; PRMTMSG - prompt message
        ; DFLTVAL - INSURANCE NAME as a default value for the prompt (optional)
        ;output:
        ; IEN^INSURANCE_NAME^PFSS_STATUS
        ;   0^^PFSS_STATUS  means ALL selected (temporary solution for PFSS sites)
        ;  -1^^PFSS_STATUS  nothing was selected, timeout expired or uparrow entered
        ; where: IEN is record number in file #36.
        ; PFSS_STATUS - the value returned by the PFSS switch: 0 - OFF, 1- ON
SELINSUR(PRMTMSG,DFLTVAL)       ;*/
        N Y,DUOUT,DTOUT,IBQUIT,DIROUT,IBPFSS
        S IBPFSS=$$PFSSON()
        ;PFSS needs to modify this code to return back
        ;selection in new PFSS file instead of ALL ("0")
        I IBPFSS=1 Q "0^^"_IBPFSS
        S IBQUIT=0
        N DIC
        S DIC="^DIC(36,"
        S DIC(0)="AEMNQ"
        S:$L($G(DFLTVAL))>0 DIC("B")=DFLTVAL
        S DIC("A")=PRMTMSG_": "
        D ^DIC
        I (Y=-1)!$D(DUOUT)!$D(DTOUT) S IBQUIT=1
        I IBQUIT=1 Q "-1^^"_IBPFSS
        Q Y_U_IBPFSS
        ;
        ;API for ECME (DBIA #4729)
        ;Determine Bill# and Account Receivable information about the bill
        ;input:
        ; IBRX - pointer to file #52 (internal prescription number)
        ; IBREF - re-fill number
        ;output:
        ;Returns a string of information about the bill requested:
        ; piece #1:  Bill number (field(#.01) of file (#399))
        ; piece #2:  Original Amount of bill
        ; piece #3:  Current Status (pointer to file #430.3)
        ; piece #4:  Current Balance
        ; piece #5:  Total Collected
        ; piece #6:  % Collected Returns null if no data or bill found.
        ; piece #7:  PFSS switch status: 0-OFF, 1-ON
        ;On PFSS site the API will always return "^^^^^^1"
        ;
BILLINFO(IBRX,IBREF)    ;
        N IBIEN,IBBNUM,RCRET
        N IBPFSS,IBRETV
        S RCRET="",IBRETV=""
        S IBPFSS=$$PFSSON()
        I IBPFSS=1 S $P(IBRETV,U,7)=IBPFSS Q IBRETV
        S IBBNUM=$$BILL^IBNCPDPU(IBRX,IBREF)
        I IBBNUM]"" D
        .S IBIEN=$O(^DGCR(399,"B",IBBNUM,"")) Q:IBIEN=""
        .S RCRET=$$BILL^RCJIBFN2(IBIEN)
        S IBRETV=IBBNUM_U_RCRET
        S $P(IBRETV,U,7)=IBPFSS
        Q IBRETV
        ;
        ;entry point for TPJI option of the ECME User Screen
TPJI(DFN)       ;
        Q:$$PFSSON()  ;quit if PFSS is ON
        I DFN>0 D EN^IBJTLA
        Q
        ;
EPHON() ; API to return if ePhamracy is on within IB
        ;   1 FOR Active
        ;   0 FOR Not Active
        ;
        Q +$G(^IBE(350.9,1,11))
        ;
