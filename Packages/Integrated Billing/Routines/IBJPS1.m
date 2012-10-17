IBJPS1  ;ALB/MAF,ARH - IBSP IB SITE PARAMETER BUILD ;22-DEC-1995
        ;;2.0;INTEGRATED BILLING;**39,52,70,115,153,137,161,384**;21-MAR-94;Build 74
        ;;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
BLD     ; - build screen array for IB parameters
        N IBTW,IBTC,IBSW,IBLN,IBGRPB,IBGRPE,IBX,IBT,IBI,IBLR,IBSEL,IBPD0,IBPD1,IBPD2,IBPD4,IBPD6,IBPD7,IBPD8,IBPD9,IBPD10
        N IBPD50,IBCISOCK,IBCIMFLG
        N IBPD11,IBPD12,IBZ
        ;
        ; IBTW = max width of data   IBTC = start column of data
        ; IBSW = total width of prompt field (including the ":")
        S IBTW(1)=21,IBTC(1)=5,IBSW(1)=19
        S IBTW(2)=21,IBTC(2)=47,IBSW(2)=13
        S IBTW(3)=21,IBTC(3)=5,IBSW(3)=53
        S IBTW(4)=27,IBTC(4)=5,IBSW(4)=47
        S IBTW(5)=17,IBTC(5)=5,IBSW(5)=19
        S IBTW(6)=19,IBTC(6)=41,IBSW(6)=17
        S IBTW(7)=35,IBTC(7)=5,IBSW(7)=46
        S IBTW(8)=32,IBTC(8)=5,IBSW(8)=46
        S IBTW(9)=31,IBTC(9)=5,IBSW(9)=43
        ;
        S IBPD0=$G(^IBE(350.9,1,0)),IBPD1=$G(^IBE(350.9,1,1)),IBPD2=$G(^IBE(350.9,1,2))
        S IBPD4=$G(^IBE(350.9,1,4)),IBPD6=$G(^IBE(350.9,1,6)),IBPD8=$G(^(8)),IBPD9=$G(^IBE(350.9,1,9))
        S IBPD7=$G(^IBE(350.9,1,7)),IBPD10=$G(^IBE(350.9,1,10)),IBPD50=$G(^IBE(350.9,1,50))
        S IBPD11=$G(^IBE(350.9,1,11))
        S IBZ=0 F  S IBZ=$O(^IBE(350.9,1,12,IBZ)) Q:+IBZ=0  S IBPD12(IBZ)=$G(^IBE(350.9,1,12,IBZ,0))
        ;
        S (VALMCNT,IBLN,IBGRPB,IBGRPE)=1,IBSEL=0
        ;
        D RIGHT(4,1,"") ; - copay stuff
        S IBLN=$$SET("Copay Background Error Mg",$$EXSET^IBJU1($P(IBPD0,U,9),350.9,.09),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Copay Exemption Mailgroup",$$EXSET^IBJU1($P(IBPD0,U,13),350.9,.13),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Use Alerts for Exemption",$$YN($P(IBPD0,U,14)),IBLN,IBLR,IBSEL)
        ;
        D RIGHT(4,1,1) ; - patient Billing
        S IBLN=$$SET("Hold MT Bills w/Ins",$$YN(+$P(IBPD1,U,20)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Suppress MT Ins Bulletin",$$YN(+$P(IBPD0,U,15)),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Means Test Mailgroup",$$EXSET^IBJU1($P(IBPD0,U,11),350.9,.11),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Per Diem Start Date",$$DATE^IBJU1(+$P(IBPD0,U,12)),IBLN,IBLR,IBSEL)
        ;
        D LEFT(2)
        S IBLN=$$SET("# of Days Charges Held",$$EXSET^IBJU1($P(IBPD7,U,4),350.9,7.04),IBLN,IBLR,IBSEL)
        ;
        D RIGHT(4,1,1) ; - third party stuff
        S IBLN=$$SET("Disapproval Mailgroup",$$EXSET^IBJU1($P(IBPD1,U,9),350.9,1.09),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Cancellation Mailgroup",$$EXSET^IBJU1($P(IBPD1,U,7),350.9,1.07),IBLN,IBLR,IBSEL)
        D FSTRNG^IBJU1($P(IBPD2,U,7),IBSW(IBLR),.IBX) D  K IBX
        . S IBI=$O(IBX(0)) S IBLN=$$SET("Cancellation Remark",$G(IBX(+IBI)),IBLN,IBLR,IBSEL)
        . F  S IBI=$O(IBX(IBI)) Q:'IBI  S IBLN=$$SET("",IBX(+IBI),IBLN,IBLR,IBSEL)
        ;
        D RIGHT(4,1,1)
        S IBLN=$$SET("New Insurance Mailgroup",$$EXSET^IBJU1($P(IBPD4,U,4),350.9,4.04),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Unbilled Mailgroup",$$EXSET^IBJU1($P(IBPD6,U,25),350.9,6.25),IBLN,IBLR,IBSEL)
        S IBLN=$$SET("Auto Print Unbilled List",$$YN(+$P(IBPD6,U,24)),IBLN,IBLR,IBSEL)
        ;
        D BLD2^IBJPS2
        ;
        S VALMCNT=$S(IBLN>IBGRPE:IBLN,1:IBGRPE)-1
        Q
        ;
SET(TTL,DATA,LN,LR,SEL) ;
        N IBY,IBX,IBC S IBC=": " I TTL="" S IBC="  "
        S IBY=TTL_$J("",(IBTW(LR)-$L(TTL)-2))_IBC_DATA,IBX=$G(^TMP("IBJPS",$J,LN,0))
        S IBX=$$SETSTR^VALM1(IBY,IBX,IBTC(LR),(IBTW(LR)+IBSW(LR)))
        D SET1(IBX,LN,SEL)
        S LN=LN+1
        Q LN
        ;
SET1(STR,LN,SEL,RV)     ; set up TMP array with screen data
        S ^TMP("IBJPS",$J,LN,0)=STR
        S ^TMP("IBJPS",$J,"IDX",LN,SEL)=""
        S ^TMP("IBJPSAX",$J,SEL)=SEL
        I $G(RV)'="" D CNTRL^VALM10(LN,1,4,IOINHI,IOINORM)
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
