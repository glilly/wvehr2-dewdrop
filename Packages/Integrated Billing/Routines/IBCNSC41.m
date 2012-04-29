IBCNSC41 ;ALB/TMP - INSURANCE PLAN SCREEN UTILITIES (CONT) ; 15-AUG-95
 ;;Version 2.0 ; INTEGRATED BILLING ;**43**; 21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
HDR ; -- Plan detail screen header
 S VALMHDR(1)="Plan Information for: "_$E($P($G(^DIC(36,+$G(IBCPOLD),0)),"^"),1,20)_" Insurance Company",VALMHDR(2)=$J("",40)_"** Plan Currently "_$S($P(IBCPOLD,U,11):"Ina",1:"A")_"ctive **"
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K VALMBCK,^TMP("IBCNSCP",$J)
 D CLEAN^VALM10,CLEAR^VALM1
 Q
 ;
LIMBLD(START,OFFSET,IBLCNT) ; Build actual limit display
 N COV,COVD,COVFN,IBCNT,LEDT,LIM,LINE,X1,Z0
 S LIM=0,LINE=3
 D SET^IBCNSC4(START,OFFSET," Plan Coverage Limitations ",IORVON,IORVOFF)
 D SET^IBCNSC4(START+1,OFFSET,"  Coverage            Effective Date   Covered?       Limit Comments")
 D SET^IBCNSC4(START+2,OFFSET,"  --------            --------------   --------       --------------")
 ;
 F  S LIM=$O(^IBE(355.31,LIM)) Q:'LIM  S COV=$P($G(^(LIM,0)),U),IBCNT=0,LEDT="" F  S LEDT=$O(^IBA(355.32,"APCD",IBCPOL,LIM,LEDT)) Q:$S(LEDT="":IBCNT,1:0)  D  Q:LEDT=""
 .S COVFN=+$O(^IBA(355.32,"APCD",IBCPOL,LIM,+LEDT,"")),COVD=$G(^IBA(355.32,+COVFN,0))
 .I COVD="" D SET^IBCNSC4(START+LINE,OFFSET,"  "_$E(COV_$J("",18),1,18)_$J("",19)_"BY DEFAULT") S LINE=LINE+1 Q  ;No entry in file for this coverage
 .S IBCNT=IBCNT+1
 .S X1="  "_$E($S(IBCNT=1:COV,1:"")_$J("",18),1,18) ;Don't dup category
 .S X1=X1_"  "_$E($$DAT1^IBOUTL($P(LEDT,"-",2))_$J("",8),1,8)_$J("",9)_$S($P(COVD,U,4):$S($P(COVD,U,4)<2:"YES"_$J("",8),$P(COVD,U,4)=2:"CONDITIONAL",1:"UNKNOWN    "),1:"NO"_$J("",9))_$J("",5)
 .D SET^IBCNSC4(START+LINE,OFFSET,X1)
 .I '$O(^IBA(355.32,COVFN,2,0)) S LINE=LINE+1
 .S Z0=0 F  S Z0=$O(^IBA(355.32,COVFN,2,Z0)) Q:'Z0  D SET^IBCNSC4(START+LINE,OFFSET+54,$G(^IBA(355.32,COVFN,2,Z0,0))) S LINE=LINE+1
 ;
 S IBLCNT=LINE-3
 Q
 ;
