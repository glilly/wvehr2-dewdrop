IBNCPDPI        ;DALOI/SS - ECME SCREEN INSURANCE VIEW AND UTILITIES ;3/6/08  16:21
        ;;2.0;INTEGRATED BILLING;**276,383,384**;21-MAR-94;Build 74
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
EN1(DFN)        ;
        I $G(DFN)'>0 Q
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
SELINSUR(PRMTMSG,DFLTVAL)       ;
        ;API for ECME (DBIA #4721)
        ;Insurance Company lookup API
        ;input:
        ; PRMTMSG - prompt message
        ; DFLTVAL - INSURANCE NAME as a default value for the prompt (optional)
        ;output:
        ; IEN^INSURANCE_NAME
        ;   0^  means ALL selected
        ;  -1^  nothing was selected, timeout expired or uparrow entered
        ; where: IEN is record number in file #36.
        ;
        N Y,DUOUT,DTOUT,IBQUIT,DIROUT
        S IBQUIT=0
        N DIC
        S DIC="^DIC(36,"
        S DIC(0)="AEMNQ"
        S:$L($G(DFLTVAL))>0 DIC("B")=DFLTVAL
        S DIC("A")=PRMTMSG_": "
        D ^DIC
        I (Y=-1)!$D(DUOUT)!$D(DTOUT) S IBQUIT=1
        I IBQUIT=1 Q "-1^"
        Q Y
        ;
        ;
BILLINFO(IBRX,IBREF)    ;
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
        ;
        N IBIEN,IBBNUM,RCRET,IBRETV
        S RCRET="",IBRETV=""
        S IBBNUM=$$BILL^IBNCPDPU(IBRX,IBREF)
        I IBBNUM]"" D
        .S IBIEN=$O(^DGCR(399,"B",IBBNUM,"")) Q:IBIEN=""
        .S RCRET=$$BILL^RCJIBFN2(IBIEN)
        S IBRETV=IBBNUM_U_RCRET
        Q IBRETV
        ;
        ;
TPJI(DFN)       ; entry point for TPJI option of the ECME User Screen
        I DFN>0 D EN^IBJTLA
        Q
        ;
INSNM(IBINSIEN) ; api to return insurance company name
        Q $P($G(^DIC(36,+$G(IBINSIEN),0)),"^")
        ;
ACPHONE()       ; API to return the agent cashier's phone number
        Q $P($G(^IBE(350.9,1,2)),"^",6)
        ;
INSPL(IBPL)     ; api to return the insurance company IEN from the plan
        ; passed in.
        Q $P($G(^IBA(355.3,+$G(IBPL),0)),"^")
        ;
MXTRNS(IBPLID)  ; api to return MAXIMUM NCPDP TRANSACTIONS for a plan
        ; Input: IBPLID = ID from the PLAN file.
        ; Returns: Numeric value from field 10.1 of Plan file
        ;          Default's to 1 if undefined.
        Q:IBPLID="" 1
        Q:$O(^IBCNR(366.03,"B",$G(IBPLID),0))']"" 1
        Q $P($G(^IBCNR(366.03,$O(^IBCNR(366.03,"B",$G(IBPLID),0)),10)),"^",10)
        ;
EPHON() ; API to return if ePhamracy is on within IB
        ;   1 FOR Active
        ;   0 FOR Not Active
        ;
        Q +$G(^IBE(350.9,1,11))
        ;
