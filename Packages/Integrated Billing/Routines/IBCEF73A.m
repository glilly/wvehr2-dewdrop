IBCEF73A        ;ALB/KJH - FORMATTER AND EXTRACTOR SPECIFIC (NPI) BILL FUNCTIONS ;30 Aug 2006  10:38 AM
        ;;2.0;INTEGRATED BILLING;**343,374,395,391**;21-MAR-94;Build 39
        ;; Per VHA Directive 10-93-142, this routine should not be modified.
        ;
PROVNPI(IBIEN399,IBNONPI)       ;
        ;Retrieves NPIs from #200 or 355.93
        ; Input:
        ;       IBIEN399 - IEN of record in BILL/CLAIMS file 399
        ;       IBNONPI - variable to pass info on missing NPI to calling routine.  Pass by reference
        ; Output:
        ;       NPI codes for all providers
        ;       IBNONPI - U-delimited list of provider types with missing NPIs
        N IBRETVAL,IBPTR,IBFT
        S IBRETVAL="",IBNONPI=""
        F IBFT=1:1:9 D
        . S IBPTR=$$PROVPTR^IBCEF7(IBIEN399,IBFT)
        . I IBPTR S $P(IBRETVAL,"^",IBFT)=$$GETNPI(IBPTR)
        Q IBRETVAL
GETNPI(IBPTR)   ;look for NPI in #200 or #355.93
        ;Input: IBPTR from 399.0222, field .02
        ;Output: NPI
        ;if in file #200
        N NPI
        S NPI=""
        ;if in 200 then get it from 200
        I $P(IBPTR,";",2)="VA(200," S NPI=$P($$NPI^XUSNPI("Individual_ID",$P(IBPTR,";")),U) S:NPI<1 NPI=""
        ;if in 355.93 then use 355.93
        I $P(IBPTR,";",2)="IBA(355.93," S NPI=$$NPIGET^IBCEP81($P(IBPTR,";"))
        I NPI="",$D(IBNONPI) S IBNONPI=$S(IBNONPI="":IBFT,1:IBNONPI_U_IBFT)
        Q NPI
        ;
SPECTAX(IBIEN399,IBNOSPEC)      ;
        ;Retrieves Specialty Codes from Current Taxonomy entries for a claim from #399
        ; Input:
        ;       IBIEN399 - IEN of record in BILL/CLAIMS file 399
        ;       IBNOSPEC - variable to pass info on missing taxonomies to calling routine.  Pass by reference
        ; Output:
        ;       Taxonomy Specialty Codes for all providers
        ;       IBNOSPEC - U-delimited list of provider types with missing Taxonomy Specialty codes
        N IBRETVAL,IBN,IBFT,IBSPEC,SPEC
        S IBRETVAL="",IBNOSPEC=""
        I $G(IBIEN399)="" Q ""
        F IBFT=1:1:9 D
        . S IBN=$O(^DGCR(399,IBIEN399,"PRV","B",IBFT,0))
        . I +IBN=0 Q
        . S IBSPEC=$P($G(^DGCR(399,IBIEN399,"PRV",+IBN,0)),"^",15)
        . S SPEC=$$GET1^DIQ(8932.1,IBSPEC,"SPECIALTY CODE")
        . S $P(IBRETVAL,"^",IBFT)=SPEC
        . I SPEC="",$D(IBNOSPEC) S IBNOSPEC=$S(IBNOSPEC="":IBFT,1:IBNOSPEC_U_IBFT)
        Q IBRETVAL
        ;
PROVTAX(IBIEN399,IBNOTAX)       ;
        ;Retrieves Current Taxonomy entries for a claim from #399
        ; Input:
        ;       IBIEN399 - IEN of record in BILL/CLAIMS file 399
        ;       IBNOTAX - variable to pass info on missing taxonomies to calling routine.  Pass by reference
        ; Output:
        ;       Taxonomy X12 codes for all providers
        ;       IBNOTAX - U-delimited list of provider types with missing Taxonomy X12 codes
        N IBRETVAL,IBN,IBFT,IBTAX,TAX
        S IBRETVAL="",IBNOTAX=""
        I $G(IBIEN399)="" Q ""
        F IBFT=1:1:9 D
        . S IBN=$O(^DGCR(399,IBIEN399,"PRV","B",IBFT,0))
        . I +IBN=0 Q
        . S IBTAX=$P($G(^DGCR(399,IBIEN399,"PRV",+IBN,0)),"^",15)
        . S TAX=$$GET1^DIQ(8932.1,IBTAX,"X12 CODE")
        . S $P(IBRETVAL,"^",IBFT)=TAX
        . I TAX="",$D(IBNOTAX) S IBNOTAX=$S(IBNOTAX="":IBFT,1:IBNOTAX_U_IBFT)
        Q IBRETVAL
GETTAX(IBPTR)   ;look for Taxonomy in #200 or #355.93
        ;Input: IBPTR from 399.0222, field .02
        ;Output: Taxonomy X12 code_"^"_IEN
        N TAX
        S TAX="^"
        ;if in 200 then get it from 200
        I $P(IBPTR,";",2)="VA(200," S TAX=$$TAXIND^XUSTAX($P(IBPTR,";"))
        ;if in 355.93 then use 355.93
        I $P(IBPTR,";",2)="IBA(355.93," S TAX=$$TAXGET^IBCEP81($P(IBPTR,";"))
        Q TAX
        ;
ORGNPI(IBIEN399,IBNONPI)        ; Extract NPIs for organizations on this claim
        ; Input
        ;       IBIEN399 - Claim IEN in file 399
        ;       IBNONPI - Variable to pass info on missing NPI back to calling routine.  Pass by reference.
        ; Output - NPI codes for facilities
        ;        Piece 1) Division (Responsible Institution) NPI code
        ;        Piece 2) Non-VA Service Facility NPI code
        ;        Piece 3) Billing Provider NPI code (main VA division)
        N IBRETVAL,IBORG,IBEVDT,IBDIV,NPI
        S IBNONPI=""
        I $G(IBIEN399)="" Q ""
        S IBRETVAL=""
        S IBEVDT=$$GET1^DIQ(399,IBIEN399_",",.03,"I")
        I IBEVDT="" S IBEVDT=DT
        S IBDIV=$$GET1^DIQ(399,IBIEN399_",",.22,"I")
        I IBDIV="" S IBDIV=$$PRIM^VASITE(IBEVDT)
        S IBORG=$P($$SITE^VASITE(IBEVDT,IBDIV),U),NPI=""
        I IBORG S NPI=$P($$NPI^XUSNPI("Organization_ID",IBORG),U) S:NPI>0 $P(IBRETVAL,U)=NPI
        I NPI<1,$D(IBNONPI) S IBNONPI=1
        S IBORG=$$GET1^DIQ(399,IBIEN399_",",232,"I")
        I IBORG S NPI=$$NPIGET^IBCEP81(IBORG),$P(IBRETVAL,U,2)=NPI I 'NPI,$D(IBNONPI) S IBNONPI=$S(IBNONPI="":2,1:IBNONPI_U_2)
        S IBORG=$P($$SITE^VASITE,U),NPI=""
        I IBORG S NPI=$P($$NPI^XUSNPI("Organization_ID",IBORG),U) S:NPI>0 $P(IBRETVAL,U,3)=NPI
        I NPI<1,$D(IBNONPI) S IBNONPI=$S(IBNONPI="":3,1:IBNONPI_U_3)
        I $$ISRX^IBCEF1(IBIEN399) S IBORG=$$RXSITE(IBIEN399) I IBORG S NPI=$P($$NPI^XUSNPI("Organization_ID",IBORG),U) S:NPI>0 $P(IBRETVAL,U,3)=NPI
        Q IBRETVAL
        ;
ORGTAX(IBIEN399,IBNOTAX)        ; Extract Taxonomies for organizations on this claim
        ; Input
        ;       IBIEN399 - Claim IEN in file 399
        ;       IBNOTAX - Variable to pass info on missing taxonomies back to calling routine.  Pass by reference.
        ; Output - Taxonomy X12 codes for facilities
        ;        Piece 1) Division (Responsible Institution) Taxonomy X12 code
        ;        Piece 2) Non-VA Service Facility Taxonomy X12 code
        ;        Piece 3) Billing Provider Taxonomy X12 code (main VA division)
        N IBRETVAL,IBTAX,TAX
        S IBTAX=$$GET1^DIQ(399,IBIEN399_",",243,"I")
        S TAX=$$GET1^DIQ(8932.1,IBTAX,"X12 CODE")
        S $P(IBRETVAL,U)=TAX
        I '$L(TAX),$D(IBNOTAX) S IBNOTAX=1
        S IBTAX=$$GET1^DIQ(399,IBIEN399_",",244,"I")
        S TAX=$$GET1^DIQ(8932.1,IBTAX,"X12 CODE")
        S $P(IBRETVAL,U,2)=TAX
        I '$L(TAX),$$GET1^DIQ(399,IBIEN399_",",232,"I"),$D(IBNOTAX) S IBNOTAX=$S(IBNOTAX="":2,1:IBNOTAX_U_2)
        S IBORG=$P($$SITE^VASITE,U)
        S TAX=$P($$TAXORG^XUSTAX(IBORG),U)
        S $P(IBRETVAL,U,3)=TAX
        I '$L(TAX),$D(IBNOTAX) S IBNOTAX=$S(IBNOTAX="":3,1:IBNOTAX_U_3)
        Q IBRETVAL
        ;
RXSITE(IBIEN399,IBLIST) ; returns prescription organization (file 4) pointer
        ; for the given bill.  If IBLIST passed by reference, then a list of
        ; the possible organizations are returned for a bill, since a bill may
        ; have more than one prescription.  If more than one rx on the bill, the
        ; $$ return is the pointer of the last prescription found.
        ; IBLIST(rx ien,fill date)=ORGINATION (file 4 pointer)
        ;
        N IBX,IBDATA,IBORG,IBRX,IBDT,IBY,IBRXN,DFN
        K ^TMP($J,"IBCEF73A")
        S IBORG=0,DFN=$P($G(^DGCR(399,IBIEN399,0)),"^",2),IBLIST="IBCEF73A"
        S IBRXN=0 F  S IBRXN=$O(^IBA(362.4,"AIFN"_IBIEN399,IBRXN)) Q:'IBRXN  S IBX=0 F  S IBX=$O(^IBA(362.4,"AIFN"_IBIEN399,IBRXN,IBX)) Q:'IBX  D
        . S IBDATA=$G(^IBA(362.4,IBX,0))
        . S IBRX=$P(IBDATA,"^",5),IBDT=$P(IBDATA,"^",3) Q:'IBRX!('IBDT)
        . D RX^PSO52API(DFN,IBLIST,IBRX,,"0,2,R")
        . I IBDT=+$G(^TMP($J,"IBCEF73A",DFN,IBRX,22)) S (IBORG,IBLIST(IBRX,IBDT))=$$PSONPI(+$G(^TMP($J,"IBCEF73A",DFN,IBRX,20))) Q
        . S IBY=0 F  S IBY=$O(^TMP($J,"IBCEF73A",DFN,IBRX,"RF",IBY)) Q:'IBY  I IBDT=+$G(^TMP($J,"IBCEF73A",DFN,IBRX,"RF",IBY,.01)) S (IBORG,IBLIST(IBRX,IBDT))=$$PSONPI(+$G(^TMP($J,"IBCEF73A",DFN,IBRX,"RF",IBY,8))) Q
        K ^TMP($J,"IBCEF73A")
        Q IBORG
        ;
PSONPI(IB59IEN) ; returns institution ien for a file 59 ien
        N IB4IEN
        K ^TMP($J,"IBCEF59")
        D PSS^PSO59(IB59IEN,,"IBCEF59")
        S IB4IEN=+$G(^TMP($J,"IBCEF59",IB59IEN,101))
        K ^TMP($J,"IBCEF59")
        Q IB4IEN
