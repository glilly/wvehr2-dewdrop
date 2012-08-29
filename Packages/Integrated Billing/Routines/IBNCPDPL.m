IBNCPDPL ;DALOI/SS - for ECME RESEARCH SCREEN ELIGIBILITY VIEW ;05-APR-05
 ;;2.0;INTEGRATED BILLING;**276**;21-MAR-94
 ;; Per VHA Directive 10-93-142, this routine should not be modified.
 ;
EN ;
 Q
 ;
 ; -- main entry point for IBNCPDP LSTMN ELIGIBILITY
 ;entry point for ECME "VE View Eligibility" menu option 
 ;of the main ECME User Screen
EN1(DFN) ;
 Q:$$PFSSON^IBNCPDPI()  ;quit if PFSS is ON
 I $G(DFN)>0 D EN^VALM("IBNCPDP LSTMN ELIGIBILITY")
 Q
 ;
HDR ; -- header code
 D HDR^IBJTEA
 Q
 ;
INIT ; -- init variables and list array
 ;D INIT^IBJTEA
 ;borrowed from INIT^IBJTEA with some changes
 K ^TMP("IBJTEA",$J)
 I '$G(DFN) S VALMQUIT="" Q
 D BLD^IBJTEA
 Q
 ;
HELP ; -- help code
 D HELP^IBJTEA
 Q
 ;
EXIT ; -- exit code
 D EXIT^IBJTEA
 Q
 ;
EXPND ; -- expand code
 Q
 ;
