IBCSC61 ;ALB/MJB - MCCR SCREEN UTILITY ;20 JUN 88 10:58
        ;;2.0;INTEGRATED BILLING;**52,80,106,51,210,230,309,389**;21-MAR-94;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;MAP TO IBCSC61
        ;
REV     I I>1 W !?4,"Rev. Code",?16,": "
        N IBNAME S IBNAME=$E($$NAME($P(IBREVC(I),U,10),$P(IBREVC(I),U,11)),1,17)
        S DGRCD=$S($D(^DGCR(399.2,+IBREVC(I),0)):^(0),1:""),DGRCD=$P(DGRCD,"^",1)_"-"_$S(IBNAME'="":IBNAME,1:$E($P(DGRCD,"^",2),1,17))
        I $P(IBREVC(I),"^",6) S DGRCD=DGRCD_$J("",21-$L(DGRCD))_"  "_$P($$CPT^ICPTCOD(+$P(IBREVC(I),"^",6)),U,2)
        I '$P(IBREVC(I),U,6),$P(IBREVC,U,11) S DGRCD=DGRCD_$J("",21-$L(DGRCD))_" *"_$P($$CPT^ICPTCOD(+$P(IBREVC(I),"^",11)),U,2)
        S DGRCD=DGRCD_$J("",28-$L(DGRCD))
        I (+$P(IBREVC(I),"^",3)>1)!($P(IBREVC(I),U,10)'=4) S DGRCD=DGRCD_$J($P(IBREVC(I),"^",3),3)
        S X=$S($P(IBREVC(I),"^",4)]"":$P(IBREVC(I),"^",4),1:IBU) I X'=IBU S X2="2$" D COMMA^%DTC
        W DGRCD,$J("",32-$L(DGRCD)),X
        I $P(IBREVC(I),"^",5)]"",$D(^DGCR(399.1,$P(IBREVC(I),"^",5),0)) W ?60," ",$E($P(^DGCR(399.1,$P(IBREVC(I),"^",5),0),"^"),1,16)
        I IBREVC<10,$P(IBREVC(I),U,9)'="",$$FT^IBCEF(IBIFN)=3 S X=$P(IBREVC(I),U,9),X2="2$" D COMMA^%DTC W !,?50,X S IBREVC=IBREVC+1 W ?64,"(Non-Covered)"
        Q
        ;
CHARGE  S (IBCH,IBUCH)=0 F I=1:1 Q:'$D(IBREVC(I))  S IBCH=IBCH+($P(IBREVC(I),U,4)),IBUCH=IBUCH+$P(IBREVC(I),U,9)
        I IB("U1")]"" S X=$P(IB("U1"),"^",1),X1=$P(IB("U1"),"^",2),IBCH=X
        Q
        ;
OFFSET  S IBOFFC="" W !?4,"OFFSET",?16,": " S X=$S(IB("U1")']"":0,1:+$P(IB("U1"),U,2)),X2="2$" S:X IBOFFC=$P(IB("U1"),U,3) D COMMA^%DTC
        W X,"  [",$S($L(IBOFFC):IBOFFC,'$P(X,"$",2):"NO OFFSET RECORDED",1:"OFFSET DESCRIPTION UNSPECIFIED"),"]"
        D CHARGE W !?4,"BILL TOTAL",?16,": " S X=$S('$D(IBCH):0,1:+IBCH),X2="2$" D COMMA^%DTC W X
        K IBOFFC
        Q
        ;
NAME(TYPE,ITEM) ; if rx or pros or DRG or unassociated return name of the item
        N IBNAME S IBNAME=""
        I $G(TYPE)=3,+$G(ITEM) D
        .D ZERO^IBRXUTL($P($G(^IBA(362.4,+ITEM,0)),U,4))
        .S IBNAME=$G(^TMP($J,"IBDRUG",+$P($G(^IBA(362.4,+ITEM,0)),U,4),.01))
        .K ^TMP($J,"IBDRUG")
        .Q
        I $G(TYPE)=5,+$G(ITEM) S IBNAME=$P($G(^IBA(362.5,+ITEM,0)),U,5)
        I $G(TYPE)=6,+$G(ITEM) S IBNAME=$P($$DRG^IBACSV(+ITEM),U,1)
        I $G(TYPE)=9,+$G(ITEM) S IBNAME=$P($G(^IBA(363.21,+ITEM,0)),U,1)
        Q IBNAME
        ;IBCSC61
