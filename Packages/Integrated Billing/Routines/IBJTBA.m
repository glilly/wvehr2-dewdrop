IBJTBA  ;ALB/ARH - TPI BILL CHARGE INFO SCREEN ;01-MAR-1995
        ;;2.0;INTEGRATED BILLING;**39,80,51,137,135,309,349,389**;21-MAR-94;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
EN      ; -- main entry point for IBJ TP BILL CHARGES
        D EN^VALM("IBJT BILL CHARGES")
        Q
        ;
HDR     ; -- header code
        D HDR^IBJTU1(+IBIFN,+DFN,12)
        Q
        ;
INIT    ; -- init variables and list array
        N IBOK,IBEOBDET
        K ^TMP("IBJTBA",$J) N IBFT
        I '$G(DFN)!'$G(IBIFN) S VALMQUIT="" G INITQ
        S IBFT=+$P($G(^DGCR(399,+IBIFN,0)),U,19),IBOK=1
        I $D(^IBM(361.1,"B",IBIFN))!$D(^IBM(361.1,"C",IBIFN)) D  G:'IBOK INITQ
        . S DIR("A")="DO YOU WANT ALL EEOB DETAILS?: ",DIR("B")="NO",DIR(0)="YA"
        . D FULL^VALM1 W ! D ^DIR K DIR
        . I $D(DTOUT)!$D(DUOUT) S IBOK=0 Q
        . S IBEOBDET=+Y
        D BLD
INITQ   Q
        ;
MRA     ; -- mra/eob
        N IBI,Z,IBSTR,IBSHEOB,IBCT
        S IBCT=0
        S IBI=0 F  S IBI=$O(^IBM(361.1,"B",IBIFN,IBI)) Q:'IBI  S Z=+$O(^IBM(361.1,IBI,8,0)) I '$O(^(Z)) S IBCT=IBCT+1,IBSHEOB(IBI)=0  ; Entire EOB belongs to the bill
        S IBI=0 F  S IBI=$O(^IBM(361.1,"C",IBIFN,IBI)) Q:'IBI  S IBCT=IBCT+1,IBSHEOB(IBI)=1 ; EOB has been reapportioned at the site
        I 'IBCT D
        . S IBSTR=$$SETLN("No EEOB/MRA Information","",1,79)
        . S IBLN=$$SET(IBSTR,IBLN)
        I IBCT D
        . S Z=0
        . S IBI=0 F  S IBI=$O(IBSHEOB(IBI)) Q:'IBI  S Z=Z+1 D SHEOB^IBJTBA1(IBI,+IBSHEOB(IBI),Z,IBCT)
        ;
        Q
        ;
HELP    ; -- help code
        S X="?" D DISP^XQORM1 W !!
        Q
        ;
EXIT    ; -- exit code
        K ^TMP("IBJTBA",$J)
        D CLEAR^VALM1
        Q
        ;
BLD     ; charges, as they would display on the bill
        N IBXDATA,IBXSAVE
        I $P($G(^DGCR(399,+IBIFN,0)),U,19)=2 D H1500 Q
        D UB04
        K ^TMP("IBXSAVE",$J)
        Q
        ;
H1500   ; block 24
        N X,IBI,IBJ,IBLN,IBX,IBSTR,IBLKLN,IBPFORM,IBLIN
        K ^TMP("IBXSAVE",$J)
        S IBLIN=$$BOX24D^IBCEF11("",1),IBLKLN=0,IBLN=1
        Q:'$G(IBIFN)  K ^TMP("IBXDISP",$J)
        S IBPFORM=$S($P($G(^IBE(353,2,2)),U,8):$P(^(2),U,8),1:2),IBLN=1
        S IBX=$$BILLN^IBCEFG0(1,"1^99",IBLIN,+IBIFN,IBPFORM)
        S IBI=$O(^TMP("IBXDISP",$J,""),-1)
        S IBJ="" F  S IBJ=$O(^TMP("IBXDISP",$J,IBI,IBJ),-1) Q:$S('IBJ:1,1:$TR($G(^(IBJ))," ")'="")  K ^TMP("IBXDISP",$J,IBI,IBJ)
        I '$O(^TMP("IBXDISP",$J,IBI,0)) S VALMSG="No charges or procedures defined.",VALMQUIT="" G H1500Q
        S IBI="" F  S IBI=$O(^TMP("IBXDISP",$J,IBI)) Q:'IBI  S IBJ=0 F  S IBJ=$O(^TMP("IBXDISP",$J,IBI,IBJ)) Q:'IBJ  D
        . S IBX=$G(^TMP("IBXDISP",$J,IBI,IBJ)),IBLN=$$SET(IBX,IBLN)
        K ^TMP("IBXDISP",$J)
        D COB,MRA
        I $$ISRX^IBCEF1(IBIFN) D RX
        I $$ISPROS^IBCEF1(IBIFN) D PROS
        S VALMCNT=IBLN-1
H1500Q  Q
        ;
UB04    ;form locator 42-49,   IBIFN required
        N X,Y,DIR,IBI,IBJ,IBX,IBLN,IBLC,IBLIN,IBPFORM,IBSTATE,IBCBILL,IBINPAT,IBQ,Z,Z0
        K ^TMP("IBXSAVE",$J)
        S IBLIN=$$RCBOX^IBCEF11()
        S IBQ=0,IBLC=9 Q:'$G(IBIFN)  K ^TMP("IBXDISP",$J)
        S IBPFORM=$S($P($G(^IBE(353,3,2)),U,8):$P(^(2),U,8),1:3)
        S IBX=$$BILLN^IBCEFG0(1,"1^99",IBLIN,+IBIFN,IBPFORM)
        I '$O(^TMP("IBXDISP",$J,0)) S VALMSG="No charges defined.",VALMQUIT="" G UB04Q
        S Z="" F  S Z=$O(^TMP("IBXDISP",$J,1,Z),-1) Q:Z=""  S Z0=$G(^(Z)) Q:$TR(Z0," ")'=""  K ^(Z)
        S:Z ^TMP("IBXDISP",$J,1,Z+1)=" "
        S IBINPAT=$$INPAT^IBCEF(IBIFN,1)
        S IBSTATE=$G(^DGCR(399,IBIFN,"U")),IBCBILL=$G(^DGCR(399,IBIFN,0))
        ;
        S (VALMCNT,IBLN)=1,IBLKLN=0
        I +IBINPAT D  S IBLN=$$SET(IBSTR,IBLN)
        . S IBX=$P(IBSTATE,U,15),IBSTR=+IBX_" DAY"_$S(IBX'=1:"S",1:"")_" INPATIENT CARE"
        . S IBX=$$LOS^IBCU64(+IBSTATE,+$P(IBSTATE,U,2),+$P(IBCBILL,U,6)),IBX=IBX-$$LOS1^IBCU64(IBIFN) I IBX>0 S IBSTR=IBSTR_$J("Pass Days: "_IBX,55)
        ;
        S IBI="" F  S IBI=$O(^TMP("IBXDISP",$J,IBI)) Q:'IBI  S IBJ=0 F  S IBJ=$O(^TMP("IBXDISP",$J,IBI,IBJ)) Q:'IBJ  D
        . S IBX=$G(^TMP("IBXDISP",$J,IBI,IBJ)),IBLN=$$SET(IBX,IBLN)
        . I $E(IBX,1,3)="001" D COB
        ;
        K ^TMP("IBXDISP",$J)
        ;
        D MRA
        S VALMCNT=IBLN-1
UB04Q   Q
        ;
SETLN(STR,IBX,COL,WD)   ;
        S IBX=$$SETSTR^VALM1(STR,IBX,COL,WD)
        Q IBX
        ;
SET(STR,LN)     ; set up TMP array with screen data (allows 2 blank lines, if not at end of array)
        N IBX,IBI I STR?80" " S IBLKLN=IBLKLN+1 G SETQ
        F IBI=1:1:IBLKLN D SET^VALM10(LN," ") S LN=LN+1 Q:IBI>1
        D SET^VALM10(LN,STR)
        S LN=LN+1,IBLKLN=0
SETQ    Q LN
        ;
COB     ; if there is an offset or a secondary/tertiary payer add it to the display, with ins co, and prior bill #
        ; IBIFN and IBLN must exist upon entry, IBLN is updated with new line count
        N IBM,IBM1,IBI,IBJ,IBD,IBSTR,IBCU2,IBCU1 Q:'$G(IBIFN)
        S IBM=$G(^DGCR(399,IBIFN,"M")),IBM1=$G(^DGCR(399,IBIFN,"M1"))
        S IBCU2=$G(^DGCR(399,IBIFN,"U2")),IBCU1=$G(^DGCR(399,IBIFN,"U1"))
        S IBJ=$P($G(^DGCR(399,IBIFN,0)),U,21),IBJ=$S(IBJ="P":3,IBJ="S":3,IBJ="T":3,1:0),IBSTR=""
        I +$P(IBM,U,2)!(+$P(IBM,U,3)) F IBI=1:1:IBJ I +$P(IBM,U,IBI) D  S IBLN=$$SET(IBSTR,IBLN)
        . I IBSTR="" S IBLN=$$SET("",IBLN)
        . S IBD=$S(IBI=1:"Primary",IBI=2:"Secondary",1:"Tertiary")_": " S IBSTR=$$SETLN(IBD,"",5,11)
        . S IBD=$P($G(^DIC(36,+$P(IBM,U,IBI),0)),U,1) S IBSTR=$$SETLN(IBD,IBSTR,17,25)
        . I $P(IBCU2,U,(IBI+3))'="" S IBD=$J(+$P(IBCU2,U,(IBI+3)),9,2) S IBSTR=$$SETLN(IBD,IBSTR,44,11)
        . I $P(IBM1,U,(IBI+4))'="" S IBD=$$BN1^PRCAFN(+$P(IBM1,U,(IBI+4))) S IBSTR=$$SETLN(IBD,IBSTR,60,11)
        I +$P(IBCU1,U,2) D  S IBLN=$$SET(IBSTR,IBLN)
        . I IBSTR="" S IBLN=$$SET("",IBLN)
        . S IBD="Offset: " S IBSTR=$$SETLN(IBD,"",5,11)
        . S IBD=$P(IBCU1,U,3) S IBSTR=$$SETLN(IBD,IBSTR,17,25)
        . S IBD=$J($P(IBCU1,U,2),9,2) S IBSTR=$$SETLN(IBD,IBSTR,44,11)
        . S IBD=$P(IBCU1,U,1)-$P(IBCU1,U,2),IBD="Billed: "_$J(IBD,0,2) S IBSTR=$$SETLN(IBD,IBSTR,60,17)
        Q
        ;
RX      ;RX refill info for CMS-1500 TPJI display
        N Z,Z0,Z1,IBSPC,IBD,IBI,IBSTR,IBARRAY,IBRXX
        S IBLN=IBLN+1
        S IBSPC=$J("",5)
        D SET^IBCSC5A(IBIFN,.IBARRAY)
        I $D(IBARRAY) D
        . S (Z,Z0)=0 F  S Z0=$O(IBARRAY(Z0)) Q:Z0=""  S Z1=0 F  S Z1=$O(IBARRAY(Z0,Z1)) Q:'Z1  S Z=Z+1 S IBXDATA(Z)=$$DAT1^IBOUTL(Z1)_U_$G(IBARRAY(Z0,Z1))
        S IBD=$$SET("",IBLN)
        S IBD="PRESCRIPTION REFILLS: (For TPJI display only)"
        S IBSTR=$$SETLN(IBD,"",1,79),IBLN=$$SET(IBSTR,IBLN)
        S IBI=0 F  S IBI=$O(IBXDATA(IBI)) Q:IBI=""  D
        . S IBRXX=$G(IBXDATA(IBI))
        . D ZERO^IBRXUTL($P(IBRXX,U,3))
        . S IBD=$J($P(IBRXX,U,7),9,2)_IBSPC_$P(IBRXX,U)_IBSPC_$G(^TMP($J,"IBDRUG",+$P(IBRXX,U,3),.01))
        . K ^TMP($J,"IBDRUG")
        . S IBSTR=$$SETLN(IBD,"",1,79),IBLN=$$SET(IBSTR,IBLN)
        . S IBD="QTY: "_$P(IBRXX,U,5)_" for "_$P(IBRXX,U,4)_" days supply "_"NDC# "_$P(IBRXX,U,6)
        . S IBSTR=$$SETLN(IBD,"",23,79),IBLN=$$SET(IBSTR,IBLN)
        Q
        ;
PROS    ;prosthetic info for CMS-1500 TPJI display
        N Z,Z0,Z1,IBARRAY,IBSPC,IBD,IBI,IBSTR
        S IBSPC=$J("",10),IBLN=IBLN+1
        D SET^IBCSC5B(IBIFN,.IBARRAY)
        I $D(IBARRAY) D
        . S (Z,Z0)=0 F  S Z0=$O(IBARRAY(Z0)) Q:Z0=""  S Z1=0 F  S Z1=$O(IBARRAY(Z0,Z1)) Q:'Z1  S Z=Z+1,IBXDATA(Z)=$$DAT1^IBOUTL(Z0)_U_$E($$PINB^IBCSC5B(+IBARRAY(Z0,Z1)),1,39)
        S IBD=$$SET("",IBLN)
        S IBD="PROSTHETIC REFILLS: (For TPJI display only)"
        S IBSTR=$$SETLN(IBD,"",1,79),IBLN=$$SET(IBSTR,IBLN)
        S IBI=0 F  S IBI=$O(IBXDATA(IBI)) Q:IBI=""  D
        . S IBD=$P(IBXDATA(IBI),U)_IBSPC_$P(IBXDATA(IBI),U,2)
        . S IBSTR=$$SETLN(IBD,"",1,79),IBLN=$$SET(IBSTR,IBLN)
        Q
        ;
