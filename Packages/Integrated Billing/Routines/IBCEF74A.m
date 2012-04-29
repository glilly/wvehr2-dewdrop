IBCEF74A        ;ALB/ESG - Provider ID maint ?ID continuation ;7 Mar 2006
        ;;2.0;INTEGRATED BILLING;**320,343,349,395**;21-MAR-94;Build 3
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
EN(IBIFN,IBQUIT)        ; Display billing provider and service provider IDs as part
        ; of the ?ID display/help in the billing screens.
        ; Called from DISPID^IBCEF74.
        NEW IBID,IBX,Z,ZI,ZN,SEQ,PSIN,DATA,QUALNM,IDNUM,FACNAME,IBZ,IBXIEN,IBSSFI,ORGNPI
        ;
        D ALLIDS^IBCEF75(IBIFN,.IBID)
        ;
        ; Re-sort array by insurance sequence (P/S/T)
        K IBX
        F Z="BILLING PRV","LAB/FAC" F ZI="C","O" S ZN=0 F  S ZN=$O(IBID(Z,IBIFN,ZI,ZN)) Q:'ZN  D
        . S SEQ=$P($G(IBID(Z,IBIFN,ZI,ZN)),U,1) Q:SEQ=""
        . S IBX(Z,SEQ,ZI,ZN)=""
        . Q
        ;
        ; Display billing provider secondary ID's (current ins only)
        I ($Y+5)>IOSL S IBQUIT=$$NOMORE^IBCEF74() I IBQUIT G EX
        S Z="BILLING PRV"
        ; PRXM/KJH - Removed "I $D(IBX(Z))" from next line. Caused header to not display even though there would be a "None Found' message.
        W !!,"Billing Provider Secondary IDs (VistA Record CI1A):"
        D SECID(Z,.IBQUIT)
        I IBQUIT G EX
        ;
        ; Now display the lab or facility primary and secondary IDs
        ; This is the service facility information
        ;
        ; Facility name, same code as found in SUB-2
        I ($Y+5)>IOSL S IBQUIT=$$NOMORE^IBCEF74() I IBQUIT G EX
        W !!,"Service Facility Name and ID Information"
        S IBXIEN=IBIFN
        D F^IBCEF("N-RENDERING INSTITUTION","IBZ",,IBIFN)
        I $$ISRX^IBCEF1(IBIFN) S Z=$$RXSITE^IBCEF73A(IBIFN) I Z S $P(IBZ,"^")=+Z
        S FACNAME=$$GETFAC^IBCEP8(+IBZ,+$P(IBZ,U,2),0,"SUB")
        S Z="LAB/FAC"
        ;
        ; determine if flag to suppress lab/fac data is set
        D VAMCFD^IBCEF75(IBIFN,.IBSSFI)
        I $D(IBSSFI),'$G(IBSSFI("C",1)) D  I IBQUIT G EX
        . I ($Y+5)>IOSL S IBQUIT=$$NOMORE^IBCEF74() Q:IBQUIT
        . W !!,"Note:  Service Facility Data not sent for Current Insurance"
        . W !,"       'Send VA Lab/Facility IDs or Facility Data for VAMC?' is set to NO",!
        . Q
        ;
        ; facility name
        I ($Y+5)>IOSL S IBQUIT=$$NOMORE^IBCEF74() I IBQUIT G EX
        I FACNAME="" S FACNAME="n/a"
        W !,"Facility:  ",FACNAME
        ;
        ; PRXM/KJH - Add NPI to display for patch 343.
        S ORGNPI=$$ORGNPI^IBCEF73A(IBIFN)
        S DATA=$S($$ISRX^IBCEF1(IBIFN):$P(ORGNPI,U,3),$P($G(IBZ),U,2)=1:$P(ORGNPI,U,2),$P($G(IBZ),U,2)=0:$P(ORGNPI,U,1),1:$P(ORGNPI,U,3))
        I ($Y+5)>IOSL S IBQUIT=$$NOMORE^IBCEF74() I IBQUIT G EX
        W !?5,"Lab or Facility NPI:"
        W !?12,$S(DATA'="":DATA,1:"***MISSING***")
        ; primary ID
        S DATA=$G(IBID(Z,IBIFN,"C",1,0))   ; lab/facility current ins primary
        S QUALNM=$$QUAL($P(DATA,U,1),$$FT^IBCEF(IBIFN))
        S IDNUM=$P(DATA,U,2)
        I ($Y+5)>IOSL S IBQUIT=$$NOMORE^IBCEF74() I IBQUIT G EX
        W !?5,"Lab or Facility Primary ID (VistA Record SUB):"
        I DATA'="" W !?8,"(",$P($G(IBID(Z,IBIFN,"C",1)),U,1),") ",QUALNM,?40,IDNUM
        I DATA="" W !?8,"(-) None Found"
        ;
        ; secondary IDs
        I ($Y+5)>IOSL S IBQUIT=$$NOMORE^IBCEF74() I IBQUIT G EX
        W !?5,"Lab or Facility Secondary IDs (VistA Records SUB1,SUB2,OP3,OP6,OP7):"
        D SECID(Z,.IBQUIT)
        I IBQUIT G EX
        ;
EX      ;
        Q
        ;
QUAL(Z,FORMTYPE)        ; turn the qualifier code into a qualifier description
        NEW QUAL,IEN
        S QUAL=""
        I $G(Z)="" G QUALX
        I Z="1C" D  G QUALX   ; qualifier for Medicare Part ?
        . I $G(FORMTYPE)=2 S QUAL="MEDICARE PART B"   ; 1500
        . I $G(FORMTYPE)=3 S QUAL="MEDICARE PART A"   ; ub
        . Q
        I Z=34 S Z="SY"       ; qualifier for SSN
        S IEN=+$O(^IBE(355.97,"C",Z,"")) I 'IEN G QUALX
        S QUAL=$P($G(^IBE(355.97,IEN,0)),U,1)
QUALX   ;
        Q QUAL
        ;
SECID(Z,IBQUIT) ; Display secondary ID and qualifier information
        ; Z is the type of IDs passed in; either BILLING PRV or LAB/FAC
        ; IBQUIT is returned if passed by reference
        NEW SEQ,ZI,ZN,PSIN,DATA,QUALNM,IDNUM,NODATA
        S IBQUIT=0,NODATA=1
        F SEQ="P","S","T" D  Q:IBQUIT
        . ;
        . ; current ins only for billing provider secondary IDs
        . I Z="BILLING PRV",SEQ'=$$COB^IBCEF(IBIFN) Q
        . S ZI=""
        . F  S ZI=$O(IBX(Z,SEQ,ZI)) Q:ZI=""  D  Q:IBQUIT
        .. S ZN=0
        .. F  S ZN=$O(IBX(Z,SEQ,ZI,ZN)) Q:'ZN  D  Q:IBQUIT
        ... S PSIN=0   ; start at 0 to skip primary IDs
        ... F  S PSIN=$O(IBID(Z,IBIFN,ZI,ZN,PSIN)) Q:PSIN=""  D  Q:IBQUIT
        .... S DATA=$G(IBID(Z,IBIFN,ZI,ZN,PSIN))
        .... S QUALNM=$$QUAL($P(DATA,U,1),$$FT^IBCEF(IBIFN))
        .... S IDNUM=$P(DATA,U,2)
        .... I ($Y+5)>IOSL S IBQUIT=$$NOMORE^IBCEF74() Q:IBQUIT
        .... S NODATA=0
        .... W !?8,"(",SEQ,") ",QUALNM,?40,IDNUM
        .... I Z="LAB/FAC",$D(^DGCR(399,IBIFN,"I2")),SEQ=$$COB^IBCEF(IBIFN) W ?54,"<<<Current Ins"
        .... I Z="BILLING PRV",PSIN=1 W ?54,"<<<System Generated ID"
        .... Q
        ... Q
        .. Q
        . Q
        I NODATA,'IBQUIT W !?8,"(-) None Found"
SECIDX  ;
        Q
        ;
