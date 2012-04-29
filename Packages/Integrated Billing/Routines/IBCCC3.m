IBCCC3  ;ALB/AAS - CANCEL AND CLONE A BILL - CONTINUED ;25-JAN-90
        ;;2.0;INTEGRATED BILLING;**363,381,389,405,403**;21-MAR-94;Build 24
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;copy entries from table files:
        ;passed in: IBIFN=new bill, IBIFN1=old bill
        ;
        I '$D(^DGCR(399,+$G(IBIFN),0))!'$D(^DGCR(399,+$G(IBIFN1),0)) Q
        N IBXR,X,Y,IBX
        ;
DX      ;copy diagnosis' (362.3)
        N IBDX,IBDIFN
        ;copy diagnosis from old bill
        I $D(^IBA(362.3,"AIFN"_IBIFN1)) S IBXR="AIFN"_IBIFN1 D
        . S IBDX=0 F  S IBDX=$O(^IBA(362.3,IBXR,IBDX)) Q:'IBDX  D
        .. S IBDIFN=0 F  S IBDIFN=$O(^IBA(362.3,IBXR,IBDX,IBDIFN)) Q:'IBDIFN  D
        ... S IBX=$G(^IBA(362.3,IBDIFN,0)) I 'IBX!($P(IBX,U,2)'=IBIFN1) Q
        ... S DIC="^IBA(362.3,",DIC(0)="L",X=+IBX K DA,DO D FILE^DICN
        ... S DIE=DIC,DA=+Y,DR=".02////"_IBIFN_";.03////"_$P(IBX,U,3)_";.04////"_$P(IBX,U,4) D ^DIE K DIC,DIE,DA,DO,DR
        K DIE,DIC,DA,DO,DR,X,Y
        ;
PRDX    ;repoint procedure's associated diagnosis (2,304,10-13 -> 362.3)
        N IBCPT,IBDIFN1,IBLN,IBI
        S IBCPT=0 F  S IBCPT=$O(^DGCR(399,+IBIFN,"CP",IBCPT)) Q:'IBCPT  D
        . S IBLN=$G(^DGCR(399,+IBIFN,"CP",IBCPT,0)) F IBI=11:1:14 S IBDIFN1=$P(IBLN,U,IBI) I +IBDIFN1 D
        .. S IBDX=+$G(^IBA(362.3,+IBDIFN1,0)) Q:'IBDX
        .. S IBDIFN=$O(^IBA(362.3,"AIFN"_IBIFN,IBDX,0)) Q:'IBDIFN
        .. S $P(^DGCR(399,+IBIFN,"CP",IBCPT,0),U,IBI)=IBDIFN
        ;
RX      ;copy rx refills (362.4)
        N IBRX,IBRIFN,IBRXDA,IBDATE,IBNDC,IBDFN,IB3624DA
        ;copy rx refills from old bill
        ; IB*2*363 - get NDC# from PRESCRIPTION file (#52) before creating new
        ; record entry in 362.4
        I $D(^IBA(362.4,"AIFN"_IBIFN1)) S IBXR="AIFN"_IBIFN1 D
        . S IBRX=0 F  S IBRX=$O(^IBA(362.4,IBXR,IBRX)) Q:IBRX=""  D
        .. S IBRIFN=0 F  S IBRIFN=$O(^IBA(362.4,IBXR,IBRX,IBRIFN)) Q:'IBRIFN  D
        ... S IBX=$G(^IBA(362.4,IBRIFN,0)) I IBX=""!($P(IBX,U,2)'=IBIFN1) Q
        ... S DIC="^IBA(362.4,",DIC(0)="L",X=$P(IBX,U,1) K DA,DO D FILE^DICN K DA,DO Q:Y'>0
        ... S IB3624DA=+Y,IBRXDA=$P(IBX,U,5),IBDATE=$P(IBX,U,3),IBDFN=$$GET1^DIQ(399,IBIFN1,.02,"I")
        ... S IBNDC=$S(IBRXDA:$$GETNDC^IBEFUNC3(IBDFN,IBRXDA,IBDATE),1:$P(IBX,U,8))
        ... S DR=".02////"_IBIFN_";.03////"_IBDATE_";.04////"_$P(IBX,U,4)_";.05////"_IBRXDA_";.06////"_$P(IBX,U,6)_";.07////"_$P(IBX,U,7)_";.08////"_IBNDC
        ... S:$L($P(IBX,U,10)) DR=DR_";.1////"_$P(IBX,U,10)
        ... S DIE=DIC,DA=IB3624DA D ^DIE K DIC,DIE,DA,DO,DR
        K DIE,DIC,DA,DO,DR,X,Y
        ;
PROS    ;copy prosthetics (362.5)
        N IBPR,IBPIFN
        ;copy rx refills from old bill
        I $D(^IBA(362.5,"AIFN"_IBIFN1)) S IBXR="AIFN"_IBIFN1 D
        . S IBPR=0 F  S IBPR=$O(^IBA(362.5,IBXR,IBPR)) Q:IBPR=""  D
        .. S IBPIFN=0 F  S IBPIFN=$O(^IBA(362.5,IBXR,IBPR,IBPIFN)) Q:'IBPIFN  D
        ... S IBX=$G(^IBA(362.5,IBPIFN,0)) I IBX=""!($P(IBX,U,2)'=IBIFN1) Q
        ... S DIC="^IBA(362.5,",DIC(0)="L",X=$P(IBX,U,1) K DA,DO D FILE^DICN K DA,DO Q:Y'>0
        ... S DR=".02////"_IBIFN_";.04////"_$P(IBX,U,4)_";.05////^S X=$P(IBX,U,5)"
        ... S DIE=DIC,DA=+Y D ^DIE K DIC,DIE,DA,DO,DR
        K DIE,DIC,DA,DO,DR,X,Y
        Q
        ;IBCCC3
