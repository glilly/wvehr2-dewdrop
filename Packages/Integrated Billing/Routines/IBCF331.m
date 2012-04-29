IBCF331 ;ALB/ARH - UB92 HCFA-1450 (GATHER CODES CONT) ;25-AUG-1993
        ;;2.0;INTEGRATED BILLING;**52,210,309,389**; 21-MAR-94;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
DX      ;additional dx codes (ie more than 9 on bill)
        D SET^IBCSC4D(IBIFN,"",.IBARRAY) G:$P(IBARRAY,U,2)'>9 RX
        S IBX=+$P(IBARRAY,U,2)-9+2 D SPACE
        S IBZ="" D SET2
        S IBZ="ADDITIONAL DIAGNOSIS CODES:" D SET2
        S IBX=0 F IBI=1:1 S IBX=$O(IBARRAY(IBX)) Q:IBX=""  I IBI>9 D
        . S IBY=$$ICD9^IBACSV(+$G(IBARRAY(IBX)),$$BDATE^IBACSV(+IBIFN)) Q:IBY=""
        . S IBZ=$P(IBY,U)_$J(" ",(10-$L($P(IBY,U))))_$P(IBY,U,3) D SET2
        ;
RX      ;add rx refills
        D SET^IBCSC5A(IBIFN,.IBARRAY) G:'$P(IBARRAY,U,2) PD
        S IBX=+$P(IBARRAY,U,2)+2 D SPACE
        S IBZ="" D SET2
        S IBZ="PRESCRIPTION REFILLS:" D SET2
        S IBX=0 F  S IBX=$O(IBARRAY(IBX)) Q:IBX=""  S IBY=0 F  S IBY=$O(IBARRAY(IBX,IBY)) Q:'IBY  S IBLN=IBARRAY(IBX,IBY) D
        . D ZERO^IBRXUTL(+$P(IBLN,U,2))
        . S IBZ=IBX_$J(" ",(11-$L(IBX)))_" "_$J($S($P(IBLN,U,6):"$"_$FN($P(IBLN,U,6),",",2),1:""),10)_"  "_$J($$FMTE^XLFDT(IBY,2),8)_"  "_$G(^TMP($J,"IBDRUG",+$P(IBLN,U,2),.01)) D SET2
        . S IBZ="",IBZ=$S(+$P(IBLN,U,4):"QTY: "_$P(IBLN,U,4)_" ",1:"")_$S(+$P(IBLN,U,3):"for "_$P(IBLN,U,3)_" days supply ",1:"") I IBZ'="" S IBZ=$J(" ",35)_IBZ D SET2
        . S IBZ="",IBZ=$S($P(IBLN,U,5)'="":"NDC #: "_$P(IBLN,U,5),1:"") I IBZ'="" S IBZ=$J(" ",35)_IBZ D SET2
        . K ^TMP($J,"IBDRUG")
        . Q
        ;
PD      ;add prosthetic items
        D SET^IBCSC5B(IBIFN,.IBARRAY) G:'$P(IBARRAY,U,2) END
        S IBX=+$P(IBARRAY,U,2)+2 D SPACE
        S IBZ="" D SET2
        S IBZ="PROSTHETIC ITEMS:" D SET2
        S IBX=0 F  S IBX=$O(IBARRAY(IBX)) Q:IBX=""  S IBY=0 F  S IBY=$O(IBARRAY(IBX,IBY)) Q:'IBY  D
        . S IBZ=$$FMTE^XLFDT(IBX,2)_" "_$J($S($P(IBARRAY(IBX,IBY),U,2):"$"_$FN($P(IBARRAY(IBX,IBY),U,2),",",2),1:""),10)_"  "_$E($$PINB^IBCSC5B(+IBARRAY(IBX,IBY)),1,54) D SET2
        ;
END     Q
        ;
SET2    D SET2^IBCF33 Q
SPACE   D SPACE^IBCF33 Q
