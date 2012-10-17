IBCSCE  ;ALB/MRL,MJB - MCCR SCREEN EDITS ;07 JUN 88 14:35
        ;;2.0;INTEGRATED BILLING;**52,80,91,106,51,137,236,245,287,349,371,400**;21-MAR-94;Build 52
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;MAP TO DGCRSCE
        ; always do procedures last because they are edited upon return to screen routine
        I IBDR20["54," S IBDR20=$P(IBDR20,"54,",1)_$P(IBDR20,"54,",2)_"54,"
        I IBDR20["44," S IBDR20=$P(IBDR20,"44,",1)_$P(IBDR20,"44,",2)_"44,"
LOOP    N IBDRLP,IBDRL S IBDRLP=IBDR20 F IBDRL=1:1 S IBDR20=$P(IBDRLP,",",IBDRL) Q:IBDR20=""  D EDIT
        Q
EDIT    N IBQUERY
        I (IBDR20["31") D MCCR^IBCNSP2 G ENQ
        I (IBDR20["43")!(IBDR20["52") D ^IBCSC4D G ENQ
        I (IBDR20["74")!(IBDR20["53") K DR N I D ^IBCOPV S (DA,Y)=IBIFN G TMPL
        I (IBDR20["54"),$P($G(^IBE(350.9,1,1)),"^",17) K DR N I D EN1^IBCCPT(.IBQUERY) D CLOSE^IBSDU(.IBQUERY) G TMPL ;
        I (IBDR20["55") D ^IBCSC5A G ENQ
        I (IBDR20["45")!(IBDR20["56") D ^IBCSC5B G ENQ
        I (IBDR20["66")!(IBDR20["76") D EDIT^IBCRBE(IBIFN) D ASKCMB^IBCU65(IBIFN) G ENQ
        I IBDR20["82",$$FT^IBCEF(IBIFN)=3 D EN^IBCSC8B G ENQ   ; UB-04 patient reason for visit (screen 8, section 2)
        I IBDR20["85",$$FT^IBCEF(IBIFN)=2 D ^IBCSC8A G ENQ     ; cms-1500 chiropractic data (screen 8, section 5)
        I IBDR20["87",$$FT^IBCEF(IBIFN)=3 D EN1^IBCEP6 G ENQ   ; UB-04 provider ID maintenance (screen 8, section 7)
        I IBDR20["89",$$FT^IBCEF(IBIFN)=2 D EN1^IBCEP6 G ENQ   ; cms-1500 provider ID maintenance (screen 8, section 9)
        ;
        F Q=1:1:9 I IBDR20[("9"_Q) D EDIT^IBCSC9 G ENQ
TMPL    N IBFLIAE S IBFLIAE=1 ;to invoke EN^DGREGAED from [IB SCREEN1]
        S DR="[IB SCREEN"_IBSR_IBSR1_"]",(DA,Y)=IBIFN,DIE="^DGCR(399,"
        D ^DIE K DIE,DR,DLAYGO
        I (IBDR20["61")!(IBDR20["71") I +$G(DGRVRCAL) D PROC^IBCU7A(IBIFN,1)
        ;
ENQ     ;
        K DIE,DR,IBDR1,IBDR20,DGDRD,DGDRS,DGDRS1,DA
        Q
        ;
        ;called by screen 3 (input template)
UPDT    F IBDD=0:0 S IBDD=$O(^DPT(DFN,.312,IBDD)) Q:IBDD'>0  S IBI1=^DPT(DFN,.312,IBDD,0) I $D(^DIC(36,+IBI1,0)),$P(^(0),"^",2)'="N" S IBDD(+IBI1)=IBI1
        F IBAIC=0:0 S IBAIC=$O(^DGCR(399,IBIFN,"AIC",IBAIC)) Q:IBAIC'>0  I $D(IBDD(IBAIC)) F IBI1="I1","I2","I3" I $D(^DGCR(399,IBIFN,IBI1)),+^(IBI1)=IBAIC,^(IBI1)'=IBDD(IBAIC) S ^DGCR(399,IBIFN,IBI1)=IBDD(IBAIC)
        K IBAIC,IBDD,IBI1 Q
        ;
        ;Edit patient's address using DGREGAED API
EDADDR(IBDFN)   ;
        I $G(IBFLIAE)'=1!(IBDFN=0) Q 0
        N IBFL S IBFL(1)=1
        N X,Y,DIE,DA,DR,DIDEL,DIW,DIEDA,DG,DICR
        D EN^DGREGAED(IBDFN,.IBFL)
        Q 1
        ;IBCSCE
