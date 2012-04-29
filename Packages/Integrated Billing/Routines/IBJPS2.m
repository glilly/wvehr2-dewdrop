IBJPS2  ;ALB/MAF,ARH - IBSP IB SITE PARAMETER BUILD (cont) ;22-DEC-1995
        ;;2.0;INTEGRATED BILLING;**39,52,115,143,51,137,161,155,320,348,349,377**;21-MAR-94;Build 23
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
BLD2    ; - continue build screen array for IB parameters
        ;
        N Z,Z0
        D RIGHT(1,1,1) ; - facility/med center  (new line for each)
        S IBLN=$$SET("Medical Center",$$EXSET^IBJU1($P(IBPD0,U,2),350.9,.02),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("MAS Service",$$EXSET^IBJU1($P(IBPD1,U,14),350.9,1.14),IBLN,IBLR,IBSEL)
        ;
        D LEFT(2)
        S IBLN=$$SET("Default Division",$$EXSET^IBJU1($P(IBPD1,U,25),350.9,1.25),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Billing Supervisor",$$EXSET^IBJU1($P(IBPD1,U,8),350.9,1.08),IBLN,IBLR,IBSEL)
        ;
        D RIGHT(1,1,1)
        S IBLN=$$SET("Initiator Authorize",$$YN(+$P(IBPD1,U,23)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Ask HINQ in MCCR",$$YN(+$P(IBPD1,U,16)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Multiple Form Types",$$YN(+$P(IBPD1,U,22)),IBLN,IBLR,IBSEL)
        ;
        D LEFT(2)
        S IBLN=$$SET("Xfer Proc to Sched",$$YN(+$P(IBPD1,U,19)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Use Non-PTF Codes",$$YN(+$P(IBPD1,U,15)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Use OP CPT screen",$$YN(+$P(IBPD1,U,17)),IBLN,IBLR,IBSEL)
        ;
        ; IB patch 349 for UB-04 claim form and parameters
        D RIGHT(1,1,1)
        S IBLN=$$SET("UB-04 Print IDs",$$EXSET^IBJU1($P(IBPD1,U,33),350.9,1.33),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("CMS-1500 Print IDs",$$EXSET^IBJU1($P(IBPD1,U,32),350.9,1.32),IBLN,IBLR,IBSEL)
        ;
        D LEFT(2)
        S IBLN=$$SET("UB-04 Address Col",$P(IBPD1,U,31),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("CMS-1500 Addr Col",$P(IBPD1,U,27),IBLN,IBLR,IBSEL)
        ;
        D RIGHT(1,1,1)
        S IBLN=$$SET("Default RX DX Cd",$$EXSET^IBJU1($P(IBPD1,U,29),350.9,1.29),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Default RX CPT Cd",$$EXSET^IBJU1($P(IBPD1,U,30),350.9,1.30),IBLN,IBLR,IBSEL)
        ;
        D LEFT(2)
        S IBLN=$$SET("Default ASC Rev Cd",$$EXSET^IBJU1($P(IBPD1,U,18),350.9,1.18),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Default RX Rev Cd",$$EXSET^IBJU1($P(IBPD1,U,28),350.9,1.28),IBLN,IBLR,IBSEL)
        ;
        D RIGHT(1,1,1)
        S IBLN=$$SET("Bill Signer Name","<No longer used>",IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Bill Signer Title","<No longer used>",IBLN,IBLR,IBSEL)
        ;
        D LEFT(2)
        S IBLN=$$SET("Federal Tax #",$P(IBPD1,U,5),IBLN,IBLR,IBSEL)
        ;
        D RIGHT(3,1,1) ; - Remittance/Agent Cashier Address
        S IBLN=$$SET("Billing Facility is Another Facility",$$EXPAND^IBTRE(350.9,2.12,+$P(IBPD2,U,12)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Billing Facility Name",$P(IBPD2,U,10),IBLN,IBLR,IBSEL)
        D ADD^IBJPS(IBPD2,IBSW(3),.IBX) D  K IBX
        . S IBT="Remittance Address",IBX=0 F  S IBX=$O(IBX(IBX)) Q:'IBX  D
        .. S IBLN=$$SET(IBT,IBX(IBX),IBLN,IBLR,IBSEL),IBT=""
        S IBLN=$$SET("Phone",$P(IBPD2,U,6),IBLN,IBLR,IBSEL)
        ;
        D RIGHT(3,1,1)
        S IBLN=$$SET("Inpt Health Summary",$$EXSET^IBJU1($P(IBPD2,U,8),350.9,2.08),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Opt Health Summary",$$EXSET^IBJU1($P(IBPD2,U,9),350.9,2.09),IBLN,IBLR,IBSEL)
        ;
        D RIGHT(5,1,1)
        S IBLN=$$SET("Rx Billing Port",$P(IBPD9,U),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("AWP Update Port",$P(IBPD9,U,2),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("TCP/IP Address",$P(IBPD9,U,3),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Task UCI/VOL",$P(IBPD9,U,11),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("AWP Charge Set",$$EXSET^IBJU1($P(IBPD9,U,12),350.9,9.12),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Prescriber ID",$P(IBPD9,U,13),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("DEA vs Presc.ID",$$YN($P(IBPD9,U,14)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Calc comp code",$$YN($P(IBPD9,U,15)),IBLN,IBLR,IBSEL)
        ;
        D LEFT(6)
        S IBLN=$$SET("Prim Billing Task",$P(IBPD9,U,4),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Sec Billing Task",$P(IBPD9,U,5),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Prim AWP Upd Task",$P(IBPD9,U,6),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Sec AWP Upd Task",$P(IBPD9,U,7),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Task Started",$$DAT1^IBOUTL($P(IBPD9,U,8),1),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Task Last Ran",$$DAT1^IBOUTL($P(IBPD9,U,9),1),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Shutdown Tasks?",$$YN($P(IBPD9,U,10)),IBLN,IBLR,IBSEL)
        ;
        ; transfer pricing
        D RIGHT(1,1,1)
        S IBLN=$$SET("Inpatient TP Active ",$$YN(+$P(IBPD10,U,2)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Outpatient TP Active",$$YN(+$P(IBPD10,U,3)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Pharmacy TP Active  ",$$YN(+$P(IBPD10,U,4)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Prosthetic TP Active",$$YN(+$P(IBPD10,U,5)),IBLN,IBLR,IBSEL)
        ;
        ; EDI/MRA parameters
        D RIGHT(7,1,1)
        N IBZ S IBZ=$P(IBPD8,U,3)
        S IBLN=$$SET(" EDI/MRA Activated",$$EXSET^IBJU1(+$P(IBPD8,U,10),350.9,8.1),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" EDI Contact Phone",$P(IBPD2,U,11),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" EDI 837 Live Transmit Queue",$P(IBPD8,U),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" EDI 837 Test Transmit Queue",$P(IBPD8,U,9),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" Auto-Txmt Bill Frequency",$S(IBZ:"Every"_$S(IBZ>1:" "_$P(IBPD8,U,3),1:""),1:"")_$S(IBZ:" Day"_$S(IBZ=1:"",1:"s"),1:"Never Run"),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" Hours To Auto-Transmit",$P(IBPD8,U,6),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" Max # Bills Per Batch",$P(IBPD8,U,4),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" Only Allow 1 Ins Co/Claim Batch?",$$EXPAND^IBTRE(350.9,8.07,+$P(IBPD8,U,7)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" Last Auto-Txmt Run Date",$$DATE^IBJU1($P(IBPD8,U,5)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" Days To Wait To Purge Msgs",$P(IBPD8,U,2),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" Allow MRA Processing?",$$YN(+$P(IBPD8,U,12)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET(" Enable Automatic MRA Processing?",$$YN(+$P(IBPD8,U,11)),IBLN,IBLR,IBSEL)
        ;
        ; Ingenix ClaimsManager Information
        D RIGHT(9,1,1)
        S IBLN=$$SET("Are we using ClaimsManager?",$$YN(+$P(IBPD50,U,1)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Is ClaimsManager working OK?",$$YN(+$P(IBPD50,U,2)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("ClaimsManager TCP/IP Address",$P(IBPD50,U,5),IBLN,IBLR,IBSEL)
        S IBCISOCK=$O(^IBE(350.9,1,50.06,"B",""))
        S IBLN=$$SET("ClaimsManager TCP/IP Ports",IBCISOCK,IBLN,IBLR,IBSEL)
        F  S IBCISOCK=$O(^IBE(350.9,1,50.06,"B",IBCISOCK)) Q:IBCISOCK=""  D
        . S IBLN=$$SET("",IBCISOCK,IBLN,IBLR,IBSEL)
        . Q
        S IBLN=$$SET("General Error MailGroup",$$EXSET^IBJU1($P(IBPD50,U,3),350.9,50.03),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Communication Error MailGroup",$$EXSET^IBJU1($P(IBPD50,U,4),350.9,50.04),IBLN,IBLR,IBSEL)
        S IBCIMFLG=$$EXTERNAL^DILFD(350.9,50.07,"",$P(IBPD50,U,7))
        I IBCIMFLG="" S IBCIMFLG="PRIORITY"
        S IBLN=$$SET("MailMan Messages",IBCIMFLG,IBLN,IBLR,IBSEL)
        ;
        Q
        ;
SET(TTL,DATA,LN,LR,SEL,HDR)     ;
        N IBY,IBX,IBC S IBC=": " I TTL="" S IBC="  "
        S IBY=TTL_$J("",(IBTW(LR)-$L(TTL)-2))_$S('$G(HDR):IBC_DATA,1:""),IBX=$G(^TMP("IBJPS",$J,LN,0))
        S IBX=$$SETSTR^VALM1(IBY,IBX,IBTC(LR),(IBTW(LR)+IBSW(LR)))
        D SET1(IBX,LN,SEL)
        S LN=LN+1
        Q LN
        ;
SET1(STR,LN,SEL,HI)     ; set up TMP array with screen data
        S ^TMP("IBJPS",$J,LN,0)=STR
        S ^TMP("IBJPS",$J,"IDX",LN,SEL)=""
        S ^TMP("IBJPSAX",$J,SEL)=SEL
        I $G(HI)'="" D CNTRL^VALM10(LN,1,4,IOINHI,IOINORM)
        ;I $G(RV) D CNTRL^VALM10(LN,6,19,IOUON,IOUOFF)
        Q
        ;
YN(X)   Q $S(+X:"YES",1:"NO")
        ;
RIGHT(LR,SEL,BL)        ; - reset control variables for right side of screen
        S IBLN=$S(IBLN>IBGRPE:IBLN,1:IBGRPE) I $G(BL) S IBLN=$$SET("","",IBLN,IBLR,IBSEL)
        S IBLR=$G(LR),IBGRPB=IBLN I +$G(SEL) S IBSEL=IBSEL+1 D SET1("["_IBSEL_"]",IBLN,IBSEL,1)
        Q
        ;
LEFT(LR)        ; - reset control variables for left side of screen
        S IBLR=$G(LR),IBGRPE=IBLN,IBLN=IBGRPB
        Q
