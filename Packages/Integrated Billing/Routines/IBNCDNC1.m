IBNCDNC1        ;ALB/SS - DRUGS NON COVERED ;11/13/07
        ;;2.0;INTEGRATED BILLING;**384**;21-MAR-94;Build 74
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
        ;in how many days we need to recheck NON-COVERED NDC+PLAN combination ?
RECHCKIN()      ;
        Q +$P($G(^IBE(350.9,1,11)),U,2)
        ;
        ;is this reject code valid for the NON-COVERED DRUGS functionality?
        ;IBREJ - ien of #9002313.93
VALIDREJ(IBREJ) ;
        Q ($O(^IBE(350.9,1,12,"B",+$G(IBREJ),0)))>0
        ;
        ;update or create a new record in #366.16
        ;IBRJCODE - ien of #9002313.93
UPDREC(IBNDC,IBPLAN,IBRJCODE,IBDRUG)    ;
        N IBIEN,IBEXIST
        I (+$G(IBPLAN)=0)!($G(IBNDC)="")!($G(IBRJCODE)="") Q
        S IBEXIST=$O(^IBCNR(366.16,"AD",IBNDC,IBRJCODE,+$G(IBPLAN),0))
        ;if already exists then update
        I IBEXIST>0 D FILLFLDS^IBNCPUT1(366.16,.04,IBEXIST,(DT\1)) Q
        ;otherwise - create a new record
        S IBEXIST=$$INSITEM^IBNCPUT1(366.16,"",IBNDC,"")
        I IBEXIST>0 D
        . D FILLFLDS^IBNCPUT1(366.16,.02,IBEXIST,IBPLAN)
        . D FILLFLDS^IBNCPUT1(366.16,.03,IBEXIST,IBRJCODE)
        . D FILLFLDS^IBNCPUT1(366.16,.04,IBEXIST,(DT\1))
        . D FILLFLDS^IBNCPUT1(366.16,.05,IBEXIST,IBDRUG)
        Q
        ;
SETVARS ;
        ;newed in IBNCDNC
        S (IBPLAN,IBRJCODE)=0
        D MODE Q:IBQ
        D DEVICE^IBNCDNC1 Q:IBQ
        Q
        ;
DEVICE  ;
        N DIR,DIRUT,POP,ZTRTN,ZTIO,ZTSAVE,ZTDESC,%ZIS,ZTSK
        S %ZIS="QM"
        W ! D ^%ZIS
        I POP S IBQ=1 Q
        S IBSCR=$S($E($G(IOST),1,2)="C-":1,1:0)
        ;
        I $D(IO("Q")) D  S IBQ=1
        . S ZTRTN="START^IBNCDNC"
        . S ZTIO=ION
        . S ZTSAVE("IB*")=""
        . S ZTDESC="IB NON-BILLABLE DRUG REPORT"
        . D ^%ZTLOAD
        . W !,$S($D(ZTSK):"REQUEST QUEUED TASK="_ZTSK,1:"REQUEST CANCELLED")
        . D HOME^%ZIS
        U IO
        Q
        ;
MODE    ;
        N DIR,DIC,DIRUT,DUOUT
        N IBM1,IBM2
        S (IBM1,IBM2)="A"
        S DIR(0)="S^G:GROUP PLAN;A:ALL"
        S DIR("A")="Display Specific (G)roup plan or (A)LL"
        S DIR("B")="ALL"
        D ^DIR K DIR I $D(DIRUT) S IBQ=1 Q
        S IBM1=Y
        I IBM1="G" S DIC="^IBA(355.3,",DIC(0)="AEQMN",DIC("A")="Select Group Plan: " D ^DIC Q:$D(DUOUT)  S IBPLAN=$S(Y>0:+Y,1:0)
        I 'IBPLAN W "   ALL" S IBPLAN="ALL"
        ;
        S DIR(0)="S^R:REJECT CODE;A:ALL"
        S DIR("A")="Display Specific (R)eject Code or (A)LL"
        S DIR("B")="ALL"
        D ^DIR K DIR I $D(DIRUT) S IBQ=1 Q
        S IBM2=Y
        I IBM2="R" S DIC="^BPSF(9002313.93,",DIC(0)="AEQMN",DIC("A")="Select Reject Code: " D ^DIC Q:$D(DUOUT)  S IBRJCODE=$S(Y>0:+Y,1:0)
        I 'IBRJCODE W "   ALL" S IBRJCODE="ALL"
        Q
        ;
PRNLINE(IB36616,IBDAYS) ;
        ;00779-0588-30 IMIPRAMINE 25MG T 70     AETNA         12345767  11/03/07  YES    
        N IBZ,IBPLAN,IBINS,IBGRNUM,X1,X2,IBACTFLG
        S IBZ=$G(^IBCNR(366.16,+$G(IB36616),0))
        S IBACTFLG=0
        I IBZ="" Q
        W !
        W ?0,$E($P(IBZ,U,1),1,13) ;ndc
        W ?14,$E($P(IBZ,U,5),1,17) ;drug name
        W ?32,$E($P($G(^BPSF(9002313.93,+$P(IBZ,U,3),0)),U),1,2) ;reject code
        S IBPLAN=$P(IBZ,U,2)
        S IBINS=$P($G(^DIC(36,+$G(^IBA(355.3,IBPLAN,0)),0)),U)
        W ?39,$E(IBINS,1,13) ;insurance name
        S IBGRNUM=$P($G(^IBA(355.3,IBPLAN,0)),U,4)
        W ?53,$E(IBGRNUM,1,9) ;group number
        S X1=(+$P(IBZ,U,4))\1
        I X1>0 D
        . W ?63,$E($$DAT^IBNCPEV(X1),1,8) ;last date rejected
        . I IBDAYS>0 S X2=IBDAYS D C^%DTC I +X'<DT S IBACTFLG=1 Q
        . I IBDAYS'>0 S IBACTFLG=-1 ;the functionality was turned off
        W ?73,$S(IBACTFLG=1:"Yes",IBACTFLG=0:"No",1:"") ;active?
        Q
        ;
HDR     ;
        N IBSLCTD,IBLEN,IBPOS,IBPLN
        S IBPLN=IBPLAN
        I IBPLAN'="ALL" S IBPLN=$E($P($G(^DIC(36,+$G(^IBA(355.3,IBPLAN,0)),0)),U),1,13)
        W @IOF S IBPAGE=+$G(IBPAGE)+1
        W !,?70,"PAGE: ",IBPAGE
        W !,?26,"DRUGS NOT COVERED BY PLANS"
        I +$G(IBDAYS)>0 W !,?14,"TIMEFRAME TO RECHECK THE NOT COVERED STATUS = ",+$G(IBDAYS)," DAYS"
        I +$G(IBDAYS)'>0 W !,?20,"THE FUNCTIONALITY HAS BEEN TURNED OFF"
        S IBSLCTD="REJECTED CODE: "_IBRJCODE_"  GROUP PLAN: "_IBPLN
        S IBLEN=$L(IBSLCTD),IBLEN=40-((IBLEN/2)\1)
        S $P(IBPOS," ",IBLEN)=""
        W !,IBPOS,IBSLCTD
        W !,"NDC#          DRUG NAME         REJECT INSURANCE     GROUP     LAST DATE ACTIVE?"
        W !,?32,"CODE                 NUMBER    REJECTED"
        W !,"================================================================================"
        Q
        ;
CHKP    ;Check for EOP
        N Y
        I $Y>(IOSL-4) D:IBSCR PAUSE Q:IBQ  D HDR
        Q
        ;
PAUSE   ;
        N X U IO(0) W !,"Press RETURN to continue, '^' to exit:" R X:DTIME S:'$T X="^" S:X["^" IBQ=1
        U IO
        Q
        ;
