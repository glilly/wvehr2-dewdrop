IBOA31 ;ALB/AAS - PRINT ALL BILLS FOR A PATIENT ; 04/18/90
 ;;2.0; INTEGRATED BILLING ;**95,199**; 21-MAR-94
 ;
 ;MAP TO DGCRA31
EN ;
 ;***
 ;I $D(XRT0) S:'$D(XRTN) XRTN="IBOA31" D T1^%ZOSV ;stop rt clock
 ;S XRTL=$ZU(0),XRTN="IBOA31-1" D T0^%ZOSV ;start rt clock
 N DPTNOFZY S DPTNOFZY=1  ;Suppress PATIENT file fuzzy lookups
 S DIC="^DPT(",DIC(0)="AEQMN" D ^DIC K DIC Q:Y<1  S DFN=+Y
 S DIR(0)="Y",DIR("A")="Include Pharmacy Co-Pay charges on this report",DIR("B")="NO"
 S DIR("?",1)="    Enter:  'Y'  -  To include Pharmacy Co-pay charges on this report"
 S DIR("?",2)="            'N'  -  To exclude Pharmacy Co-pay charges on this report"
 S DIR("?")="            '^'  -  To select a new patient"
 D ^DIR K DIR G:$D(DIRUT) END S IBIBRX=Y
 W !,"You will need a 132 column printer for this report."
 S %ZIS="QM" D ^%ZIS G:POP ENQ
 I $D(IO("Q")) K IO("Q") D  G ENQ
 .S ZTDESC="IB - PRINT ALL BILLS FOR A PATIENT",ZTRTN="DQ^IBOA31",ZTSAVE("DFN")="",ZTSAVE("IB*")=""
 .D ^%ZTLOAD K ZTSK D HOME^%ZIS
 ;
 ;***
 ;I $D(XRT0) S:'$D(XRTN) XRTN="IBOA31" D T1^%ZOSV ;stop rt clock
DQ ;
 ;***
 ;S XRTL=$ZU(0),XRTN="IBOA31-2" D T0^%ZOSV ;start rt clock
 U IO S IBPAG=0 D NOW^%DTC S Y=% X ^DD("DD") S IBNOW=Y,$P(IBLINE,"-",IOM+1)=""
 S IBQUIT=0,IBN=$$PT^IBEFUNC(DFN) D UTIL^IBCA3,UTIL^IBOA32
 I '$D(^UTILITY($J)) W !,"No Bills On File for ",$P(IBN,"^"),"  SSN: ",$P(IBN,"^",2),"." G ENQ
 D HDR1 S (IBDT,IBIFN)=""
 ; - loop through all bills
 F  S IBDT=$O(^UTILITY($J,IBDT)) Q:IBDT=""!(IBQUIT)  D
 . F  S IBIFN=$O(^UTILITY($J,IBDT,IBIFN)) Q:IBIFN=""!(IBQUIT)  D @($S($E(IBIFN,$L(IBIFN))="X":"^IBOA32",1:"ONE"))
 D:'IBQUIT PAUSE
ENQ W ! G END
 ;
ONE D GVAR^IBCBB
 D:($Y>(IOSL-5)) HDR Q:IBQUIT
 W !,IBBNO,?8,$$DAT1^IBOUTL($P(IBNDS,"^",12)),?18,$P($G(^DGCR(399.3,+IBAT,0)),"^")
 W ?37,$S(IBCL=1:"INPATIENT",IBCL=2:"HUMANIT. (INPT)",IBCL=3:"OUTPATIENT",IBCL=4:"HUMANIT. (OPT)",1:""),?54
 F I=$S(IBCL<3!('$O(^DGCR(399,IBIFN,"OP",0))):IBEVDT,1:$O(^DGCR(399,IBIFN,"OP",0))),IBFDT,IBTDT W $S(I]"":$$DAT1^IBOUTL(I)_"  ",1:"          ")
 S X=+$$TPR^PRCAFN(IBIFN) W $J($S(X<0:0,1:X),8,2)
 W ?94,$S(IBST=1:"ENTERED/NOT REV.",IBST=2:"REVIEWED",IBST=3:"AUTHORIZED",IBST=4:"PRINTED",IBST=7:"CANCELLED",1:"")
 W ?112,$P("NON-PAYMENT/ZERO^ADMIT - DISCHARGE^INTERIM - FIRST^INTERIM - CONTINUING^INTERIM - LAST^LATE CHARGE(S) ONLY^ADJUSTMENT OF PRIOR^REPLACEMENT OF PRIOR","^",(IBTF+1))
 ; - print remaining outpatient visit dates
 S IBOPD=$O(^DGCR(399,IBIFN,"OP",0)) Q:'IBOPD
 F  S IBOPD=$O(^DGCR(399,IBIFN,"OP",IBOPD)) Q:'IBOPD  D  Q:IBQUIT
 . D:($Y>(IOSL-5)) HDR Q:IBQUIT  W !?54,$$DAT1^IBOUTL(IBOPD)
 Q
 ;
HDR I $E(IOST,1,2)["C-" D PAUSE Q:IBQUIT
HDR1 S IBPAG=IBPAG+1 W:$E(IOST,1,2)["C-"!(IBPAG>1) @IOF
 W "List of all Bills for ",$P(IBN,"^"),"  SSN: ",$P(IBN,"^",2),"  ",?(IOM-31),IBNOW,"  PAGE ",IBPAG
 W !,"BILL",?10,"DATE",?54,"DATE OF",?63,"STATEMENT  STATEMENT  AMOUNT"
 W !,"NO.      PRINTED  ACTION/RATE TYPE   CLASSIFICATION    CARE    "
 W $S(IBIBRX=1:"FR/FL DT   TO/RL DT",1:"FROM DATE   TO DATE")
 W "  COLLECTED STATUS            TIMEFRAME OF BILL"
 W !,IBLINE
 W:IBIBRX !,?52,"'*' = outpt visit on same day as Rx fill date",!,IBLINE
 Q
 ;
PAUSE S IBX1="" R:$E(IOST,1,2)["C-" !!!,"Enter ""^"" to quit, or return to continue",IBX1:DTIME S IBQUIT=$S(IBX1["^":1,1:0) Q
 ;
END K ^UTILITY($J)
 ;***
 ;I $D(XRT0) S:'$D(XRTN) XRTN="IBOA31" D T1^%ZOSV ;stop rt clock
 I $D(ZTQUEUED) S ZTREQ="@" Q
 D END^IBCBB1
 K IBIFN1,IBQUIT,IBX1,IBDT,IBCNT,IBN,DFN,IBIFN,IBLINE,IBNOW,IBPAG,IBOPD,IBIBRX,DIRUT,DUOUT,DTOUT,X,Y
 K IBRDT,IBRF,IBRX
 D ^%ZISC G EN
