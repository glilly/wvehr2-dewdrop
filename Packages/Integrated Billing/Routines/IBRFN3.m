IBRFN3  ;ALB/ARH - PASS BILL/CLAIM TO AR ;3/18/96
        ;;2.0;INTEGRATED BILLING;**61,133,210,309,389**;21-MAR-94;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;  Returns information on the bill passed in,  all data returned in external format, for AR's RC project
        ;
        ;  If the bill can not be found then returns ARRAY=0  (should be called with ARRAY passed by reference)
        ;  Otherwise ARRAY=1 and the following array elements may be defined
        ;  these array elements will only be defined is there is data to return
        ;  those elements that have multiple entries will be in the form ARRAY("SUB",X) where X=1:1:...
        ;
        ;  ARRAY("BN") = BILL NUMBER
        ;  ARRAY("SR") = SENSITIVE RECORD? (Y or N)
        ;  ARRAY("STF") = STATEMENT COVERS FROM DATE - first date covered by bill
        ;  ARRAY("STT") = STATEMENT COVERS TO DATE - last date covered by bill
        ;  ARRAY("TCG") = TOTAL CHARGES^OFFSET AMT (PRIOR PAYMENTS)^OFFSET DESC
        ;  ARRAY("TOC") = BILL TYPE (INPATIENT OR OUTPATIENT)
        ;  ARRAY("TCF") = BILL FORM TYPE
        ;  ARRAY("DFP") = DATE FIRST PRINTED
        ;  ARRAY("TAX") = FEDERAL TAX NUMBER - for facility, a site parameter
        ;
        ;  ARRAY("PIN") = DEBTOR INSURANCE NAME ^ HOSPITAL PROVIDER NUMBER ^ GROUP NAME ^ GROUP NUMBER ^
        ;                 NAME OF INSURED ^ SUBSCRIBER ID ^ RELATIONSHIP TO INSURED
        ;
        ;  ARRAY("PIN","MMA") = DEBTOR MAILING STREET ADDRESS [LINE 1] ^
        ;                       MAILING STREET ADDRESS [LINE 2] ^ MAILING STREET ADDRESS [LINE 3] ^ CITY ^
        ;                       STATE (ABBREVIATED) ^ ZIP ^ PHONE NUMBER
        ;
        ;  ARRAY("RVC") = NUMBER OF REVENUE CODES ON BILL
        ;  ARRAY("RVC",X) = REVENUE CODE ^ REVENUE CODE DESCRIPTION ^ CHARGE (PER UNIT) ^ UNITS ^
        ;                   TOTAL CHARGE FOR REV CODE
        ;
        ;  ARRAY("OPV") = NUMBER OF OUTPATIENT VISIT DATES ON BILL
        ;  ARRAY("OPV",X) = OUTPATIENT VISIT DATE
        ;
        ;  ARRAY("PRC") = NUMBER OF PROCEDURES ON BILL
        ;  ARRAY("PRC",X) = PROCEDURE CODE ^ PROCEDURE DESCRIPTION ^ PROCEDURE DATE ^
        ;                   PLACE OF SERVICE CODE ^ PLACE OF SERVICE ^ TYPE OF SERVICE CODE ^ TYPE OF SERVICE
        ;
        ;  ARRAY("DXS") = NUMBER OF DIAGNOSIS ON BILL
        ;  ARRAY("DXS,X) = DIAGNOSIS CODE ^ DIAGNOSIS
        ;
        ;  ARRAY("RXF") = NUMBER OF PRESCRIPTION REFILLS ON BILL
        ;  ARRAY("RXF",X) = PRESCRIPTION # ^ REFILL DATE ^ DRUG NAME ^ DAYS SUPPLY ^ QUANTITY ^ NDC #
        ;
        ;  ARRAY("PRD") = NUMBER OF PROSTHETIC ITEMS ON BILL
        ;  ARRAY("PRD",X) = PROSTHETIC DEVICE ^ DELIVERY DATE
        ;
        ;  IF CONDITION RELATED TO EMPLOYMENT:  ARRAY("CRE") = "EMPLOYMENT"
        ;  IF CONDITION RELATED TO AN AUTO ACCIDENT:  ARRAY("CRA") = "AUTO ACCIDENT" ^ STATE (ABBREVIATION)
        ;  IF CONDITION RELATED TO AN OTHER ACCIDENT:  ARRAY("CRO") = "OTHER ACCIDENT"
        ;
BILL(IBIFN,ARRAY)       ; returns array of information on a specific bill, based on RC requirements
        ;
        N IBI,IBJ,IBK,IBX,IBY,IBTMP,IBD0,IBDU,IBDU1,IBDI1,IBDS,IBDATE
        K ARRAY S ARRAY=1 I '$G(IBIFN)!($G(^DGCR(399,+$G(IBIFN),0))="") S ARRAY=0 Q
        F IBI=0,"U","U1","S" S @("IBD"_IBI)=$G(^DGCR(399,IBIFN,IBI))
        S IBX=$P(IBD0,U,21),IBX=$S(IBX="P":"I1",IBX="S":"I2",IBX="T":"I3",1:" ")
        S IBDI1=$G(^DGCR(399,IBIFN,IBX))
        ;
        S ARRAY("TCG")=$P(IBDU1,U,1,3)
        S ARRAY("BN")=$P(IBD0,U,1)
        S ARRAY("SR")=$S($P(IBDU,U,5)=1:"Y",1:"N")
        S ARRAY("STF")=$P(IBDU,U,1)
        S ARRAY("STT")=$P(IBDU,U,2)
        S ARRAY("TOC")=$S($P(IBD0,U,5)<3:"INPATIENT",1:"OUTPATIENT")
        S ARRAY("TCF")=$$FTN^IBCU3($$FT^IBCU3(IBIFN))
        S ARRAY("DFP")=$P(IBDS,U,12)
        S ARRAY("TAX")=$P($G(^IBE(350.9,1,1)),U,5)
        ;
INS     ; insurance information
        S IBX=$G(^DGCR(399,+IBIFN,"M"))
        S ARRAY("PIN")=$P(IBX,U,4)_U_$P($G(^DIC(36,+IBDI1,0)),U,11)_U_$P(IBDI1,U,15)_U_$P(IBDI1,U,3)_U_$P(IBDI1,U,17)_U_$P(IBDI1,U,2)_U_$$RTI($P(IBDI1,U,16))
        S ARRAY("PIN","MMA")=$P(IBX,U,5)_U_$P(IBX,U,6)_U_$P($G(^DGCR(399,+IBIFN,"M1")),U,1)_U_$P(IBX,U,7)_U_$$STATE($P(IBX,U,8))
        S ARRAY("PIN","MMA")=ARRAY("PIN","MMA")_U_$$ZIP($P(IBX,U,9))_U_$P($G(^DIC(36,+IBDI1,.13)),U,1)
        ;
RC      ; revenue codes
        S (IBI,IBJ)=0,ARRAY("RVC")=IBJ F  S IBI=$O(^DGCR(399,IBIFN,"RC",IBI)) Q:'IBI  D
        . S IBX=$G(^DGCR(399,IBIFN,"RC",IBI,0)) Q:IBX=""  S IBY=$G(^DGCR(399.2,+IBX,0))
        . S IBJ=IBJ+1,ARRAY("RVC")=IBJ
        . S ARRAY("RVC",IBJ)=$P(IBY,U,1)_U_$P(IBY,U,2)_U_$P(IBX,U,2)_U_$P(IBX,U,3)_U_$P(IBX,U,4)
        ;
OPV     ; outpatient visit dates
        S (IBI,IBJ)=0,ARRAY("OPV")=IBJ F  S IBI=$O(^DGCR(399,IBIFN,"OP",IBI)) Q:'IBI  D
        . S IBX=$G(^DGCR(399,IBIFN,"OP",IBI,0)) Q:'IBX
        . S IBJ=IBJ+1,ARRAY("OPV")=IBJ
        . S ARRAY("OPV",IBJ)=+IBX
        ;
PRC     ; procedure codes
        S (IBI,IBJ)=0,ARRAY("PRC")=IBJ F  S IBI=$O(^DGCR(399,IBIFN,"CP",IBI)) Q:'IBI  D
        . S IBX=$G(^DGCR(399,IBIFN,"CP",IBI,0)),IBY=""
        . S IBDATE=$P(IBX,U,2) I 'IBDATE S IBDATE=$$BDATE^IBACSV(IBIFN)
        . S IBY=$P($$PRCD^IBCEF1($P(IBX,U),1,IBDATE),U,2,3)
        . Q:$P(IBY,U)=""
        . S IBJ=IBJ+1,ARRAY("PRC")=IBJ
        . S ARRAY("PRC",IBJ)=IBY_U_$P(IBX,U,2)
        . S IBY=$G(^IBE(353.1,+$P(IBX,U,9),0)),ARRAY("PRC",IBJ)=ARRAY("PRC",IBJ)_U_$P(IBY,U)_U_$P(IBY,U,3)
        . S IBY=$G(^IBE(353.2,+$P(IBX,U,10),0)),ARRAY("PRC",IBJ)=ARRAY("PRC",IBJ)_U_$P(IBY,U)_U_$P(IBY,U,3)
        ;
DX      ; diagnosis codes
        K IBTMP D SET^IBCSC4D(IBIFN,"",.IBTMP)
        S IBDATE=$$BDATE^IBACSV(IBIFN)
        S (IBI,IBJ)=0,ARRAY("DXS")=IBJ F  S IBI=$O(IBTMP(IBI)) Q:'IBI  D
        . S IBX=IBTMP(IBI),IBY=$$ICD9^IBACSV(+IBX,IBDATE) Q:IBY=""
        . S IBJ=IBJ+1,ARRAY("DXS")=IBJ
        . S ARRAY("DXS",IBJ)=$P(IBY,U)_U_$P(IBY,U,3)
        ;
RX      ; prescription refills
        K IBTMP D SET^IBCSC5A(IBIFN,.IBTMP)
        S (IBI,IBJ)=0,ARRAY("RXF")=IBJ F  S IBI=$O(IBTMP(IBI)) Q:'IBI  D
        . S IBK=0 F  S IBK=$O(IBTMP(IBI,IBK)) Q:'IBK  D
        .. S IBX=IBTMP(IBI,IBK) D ZERO^IBRXUTL(+$P(IBX,U,2)) S IBY=$G(^TMP($J,"IBDRUG",+$P(IBX,U,2),.01))
        .. S IBJ=IBJ+1,ARRAY("RXF")=IBJ
        .. S ARRAY("RXF",IBJ)=IBI_U_IBK_U_IBY_U_$P(IBX,U,3)_U_$P(IBX,U,4)_U_$P(IBX,U,5)
        .. K ^TMP($J,"IBDRUG")
        .. Q
        ;
PD      ; prosthetic items
        K IBTMP D SET^IBCSC5B(IBIFN,.IBTMP)
        S (IBI,IBJ)=0,ARRAY("PRD")=IBJ F  S IBI=$O(IBTMP(IBI)) Q:'IBI  D
        . S IBK=0 F  S IBK=$O(IBTMP(IBI,IBK)) Q:'IBK  D
        .. S IBX=IBTMP(IBI,IBK)
        .. S IBJ=IBJ+1,ARRAY("PRD")=IBJ
        .. S ARRAY("PRD",IBJ)=$$PINB^IBCSC5B(+IBX)_U_IBI
        ;
CC      ; condition related to employment, auto accident (place), other accident
        S IBI=0 F  S IBI=$O(^DGCR(399,IBIFN,"CC",IBI)) Q:'IBI  I $G(^(IBI,0))="02" S ARRAY("CRE")="EMPLOYMENT"
        S IBI=0 F  S IBI=$O(^DGCR(399,IBIFN,"OC",IBI)) Q:'IBI  S IBX=$G(^(IBI,0)) I +IBX D
        . S IBY=$G(^DGCR(399.1,+IBX,0)) Q:IBY=""
        . I $P(IBY,U,9)=1 S ARRAY("CRE")="EMPLOYMENT"
        . I $P(IBY,U,9)=2 S ARRAY("CRA")="AUTO ACCIDENT"_U_$$STATE($P(IBX,U,3))
        . I $P(IBY,U,9)=3 S ARRAY("CRO")="OTHER ACCIDENT"
        Q
        ;
STATE(X)        ; returns 2 letter abbreviation for state
        Q $P($G(^DIC(5,+X,0)),U,2)
ZIP(X)  ; returns zip in external form
        S X=$E(X,1,5)_$S($E(X,6,9)]"":"-"_$E(X,6,9),1:"")
        Q X
RTI(X)  ; returns external form of relationship to insured
        I X'="" S X=$S(X="01":"PATIENT",X="02":"SPOUSE",X="03":"NATURAL CHILD",X="08":"EMPLOYEE",X="09":"UNKNOWN",X="11":"ORGAN DONOR",X="15":"INJURED PLANTIFF",X="18":"PARENT",1:"")
        Q X
        ;IBRFN3
