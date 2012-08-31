IBNCPDPE        ;DALOI/AAT - NCPDP BILLING EVENTS REPORT ;3/6/08  16:18
        ;;2.0;INTEGRATED BILLING;**276,342,347,363,384**;21-MAR-94;Build 74
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
DATE    ;
        S (IBBDT,IBEDT)=DT
        S %DT="AEX"
        S %DT("A")="START WITH DATE: ",%DT("B")="TODAY"
        D ^%DT K %DT
        I Y<0 S IBQ=1 Q
        S IBBDT=+Y
        S %DT="AEX"
        S %DT("A")="GO TO DATE: ",%DT("B")="TODAY"
        D ^%DT K %DT
        I Y<0 S IBQ=1 Q
        S IBEDT=+Y
        Q
        ;
MODE    ;
        N DIR,DIC,DIRUT,DUOUT,PSOFILE
        S (IBM1,IBM2,IBM3)="A"
        S DIR(0)="S^P:SINGLE PATIENT;R:SINGLE RX;E:SINGLE ECME #;A:ALL ACTIVITY"
        S DIR("A")="SINGLE (P)ATIENT, SINGLE (R)X, SINGLE (E)CME #, (A)LL ACTIVITY"
        S DIR("B")="ALL"
        D ^DIR K DIR I $D(DIRUT) S IBQ=1 Q
        S IBM1=Y
        I IBM1="P" S DIC="^DPT(",DIC(0)="AEQMN" D ^DIC Q:$D(DUOUT)  S IBPAT=$S(Y>0:+Y,1:0) I 'IBPAT W "   ALL" S IBM1="A"
        I IBM1="R" S PSOFILE=52,DIC="^PSRX(",DIC(0)="AEQMN" D DIC^PSODI(PSOFILE,.DIC) Q:$D(DUOUT)  S IBRX=$S(Y>0:+Y,1:0) I 'IBRX W "   ALL" S IBM1="A"
        K PSODIY
        I IBM1="E" S DIR(0)="FO^7:7^I X'?1.7N W !!,""Cannot contain alpha characters"" K X",DIR("A")="Enter ECME #" D ^DIR Q:$D(DUOUT)  S IBECME=$S(+Y>0:Y,1:0) I 'IBECME W "   ALL" S IBM1="A"
        S IBM2="B"
        ; if "All"
        I IBM1="A" D  Q:$G(IBQ)
        .S DIR(0)="S^E:ECME BILLABLE;N:NON ECME BILLABLE;B:BOTH"
        .S DIR("A")="(E)CME BILLABLE;(N)ON ECME BILLABLE;(B)OTH"
        .S DIR("B")="BOTH"
        .D ^DIR K DIR I $D(DIRUT) S IBQ=1 Q
        .S IBM2=Y
        ;
        ;Mail/Window/CMOP?
        S DIR(0)="S^M:MAIL;W:WINDOW;C:CMOP;A:ALL"
        S DIR("A")="(M)AIL, (W)INDOW, (C)CMOP, (A)LL"
        S DIR("B")="ALL"
        D ^DIR K DIR I $D(DIRUT) S IBQ=1 Q
        S IBM3=Y
        ;
        S DIR(0)="S^S:SUMMARY REPORT;D:DETAILED REPORT"
        S DIR("A")="(S)UMMARY REPORT, (D)ETAILED REPORT"
        S DIR("B")="SUMMARY REPORT"
        D ^DIR K DIR I $D(DIRUT) S IBQ=1 Q
        S IBDTL=($E(Y)="D")
        Q
        ;
TESTDATA()      ;
        N Y
        S Y=$$HAVEDATA()
        I 'Y W !!,"No data found in the specified period.",!
        Q Y
        ;
HAVEDATA()      ;
        N Z
        I $D(^IBCNR(366.14,"B",IBBDT)) Q 1
        S Z=+$O(^IBCNR(366.14,"B",IBBDT))
        I Z=0 Q 0
        I Z>IBEDT Q 0
        Q 1
        ;
DEVICE  ;
        N DIR,DIRUT,POP,ZTRTN,ZTIO,ZTSAVE,ZTDESC,%ZIS,ZTSK
        S %ZIS="QM"
        W ! D ^%ZIS
        I POP S IBQ=1 Q
        S IBSCR=$S($E($G(IOST),1,2)="C-":1,1:0)
        ;
        I $D(IO("Q")) D  S IBQ=1
        . S ZTRTN="START^IBNCPEV"
        . S ZTIO=ION
        . S ZTSAVE("IB*")=""
        . S ZTDESC="IB ECME BILLING EVENTS REPORT"
        . D ^%ZTLOAD
        . W !,$S($D(ZTSK):"REQUEST QUEUED TASK="_ZTSK,1:"REQUEST CANCELLED")
        . D HOME^%ZIS
        U IO
        Q
        ;------ added for the User screen --------
        ;User Screen Entry point (to call from ECME User Screen)
        ;IBMODE:
        ; P-patient
        ; R-Rx
        ;IBVAL - patient DFN or RX ien (#52)
        ;
USRSCREN(IBMODE,IBVAL)  ;
        N IBPAT,IBRX,IBBDT,IBEDT,Y,IBM1,IBM2,IBM3,IBQ,IBSCR,IBPAGE,IBDTL,IBDIVS
        S (IBPAT,IBRX,IBQ,IBSCR,IBPAGE,IBDTL,IBDIVS)=0
        S IBM1=IBMODE
        I IBM1="P" S IBPAT=+IBVAL
        I IBM1="R" S IBRX=+IBVAL
        ;date
        F  D DATE Q:IBQ  Q:$$TESTDATA
        Q:IBQ
        N IBMLTDV S IBMLTDV=$$MULTPHRM^BPSUTIL()
        I +IBMLTDV=1 S IBDIVS=+$$MULTIDIV^IBNCPEV1(.IBDIVS) S:IBDIVS=0 IBDIVS(0)="0^ALL" I IBDIVS=-1 S IBQ=1 Q
        I +IBMLTDV=0 S IBDIVS=0,IBDIVS(0)="0^"_$P(IBMLTDV,U,2)
        D MODE2 Q:IBQ
        D DEVICE Q:IBQ
        D START^IBNCPEV
        D ^%ZISC
        I IBQ W !,"Cancelled"
        Q
        ;
MODE2   ;
        N DIR,DIC,DIRUT,DUOUT
        S (IBM1,IBM2,IBM3)="A"
        S IBM2="B"
        ;
        ;Mail/Window/CMOP?
        S DIR(0)="S^M:MAIL;W:WINDOW;C:CMOP;A:ALL"
        S DIR("A")="(M)AIL, (W)INDOW, (C)CMOP, (A)LL"
        S DIR("B")="ALL"
        D ^DIR K DIR I $D(DIRUT) S IBQ=1 Q
        S IBM3=Y
        ;
        S DIR(0)="S^S:SUMMARY REPORT;D:DETAILED REPORT"
        S DIR("A")="(S)UMMARY REPORT, (D)ETAILED REPORT"
        S DIR("B")="SUMMARY REPORT"
        D ^DIR K DIR I $D(DIRUT) S IBQ=1 Q
        S IBDTL=($E(Y)="D")
        Q
        ;IBNCPDPE
