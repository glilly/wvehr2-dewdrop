IBNCPDP1        ;OAK/ELZ - PROCESSING FOR NEW RX REQUESTS ;3/27/08  17:36
        ;;2.0;INTEGRATED BILLING;**223,276,339,363,383,405**;21-MAR-94;Build 4
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
RX(DFN,IBD)     ; pharmacy package call, passing in IBD by ref
        ; this is called by PSO for all prescriptions issued, return is
        ; a response to bill ECME or not with array for billing data elements
        ;warning: back-billing flag:
        ;if passed IBSCRES(IBRXN,IBFIL)=1
        ; - the the SC Determination is just done by the IB clerk (billable)
        ;
        ;clean up the list of non-answered SC/Env.indicators questions and INS
        K IBD("SC/EI NO ANSW"),IBD("INS")
        ;
        N IBTRKR,IBARR,IBADT,IBRXN,IBFIL,IBTRKRN,IBRMARK,IBANY,IBX,IBT,IBINS,IBSAVE
        N IBFEE,IBEABD,IBBI,IBIT,IBPRICE,IBRS,IBRT,IBTRN,IBCHG,IBERMSG,IBRES,IBNEEDS
        ;
        I '$G(DFN) S IBRES="0^No DFN" G RXQ
        S IBRXN=+$G(IBD("IEN")) I 'IBRXN S IBRES="0^No Rx IEN" G RXQ
        S IBFIL=+$G(IBD("FILL NUMBER"),-1) I IBFIL<0 S IBRES="0^No fill number" G RXQ
        S IBD("QTY")=+$G(IBD("QTY")) I 'IBD("QTY") S IBRES="0^No Quantity" G RXQ
        ;
        S IBRES="0^Error"
        S (IBEABD,IBADT)=+$G(IBD("FILL DATE"),DT)
        ;
        ; -- look up insurance for patient
        D ALL^IBCNS1(DFN,"IBINS",1,IBADT,1)
        ;
        ; -- determine rate type
        S IBRT=$$RT^IBNCPDPU(DFN,.IBINS)
        ;
        ; -- claims tracking info
        S IBTRKR=$G(^IBE(350.9,1,6))
        ; date can't be before parameters
        S $P(IBTRKR,U)=$S('$P(IBTRKR,U,4):0,+IBTRKR&(IBADT<+IBTRKR):0,1:IBADT)
        ; already in claims tracking
        S IBTRKRN=+$O(^IBT(356,"ARXFL",IBRXN,IBFIL,0))
        I IBTRKRN,$$PAPERBIL(IBTRKRN) S IBRES="0^Existing IB Bill in CT",IBD("NO ECME INSURANCE")=1 G RXQ
        ; already billed as Tricare
        I $D(^IBA(351.5,"B",IBRXN_";"_IBFIL)) S IBRES="0^Already billed under prior Tricare process",IBD("NO ECME INSURANCE")=1 G RXQ
        ;
        ; -- no pharmacy coverage, update ct if applicable, quit
        I '$$PTCOV^IBCNSU3(DFN,IBADT,"PHARMACY",.IBANY) S IBRMARK=$S($G(IBANY):"SERVICE NOT COVERED",1:"NOT INSURED") D:$P(IBTRKR,U,4)=2 CT S IBRES="0^"_IBRMARK,IBD("NO ECME INSURANCE")=1 G RXQ
        ;
        ;  -- check for compound,  NOT BILLABLE
        I $G(IBD("DEA"))="" D CT S IBRES="0^Null DEA Special Handling field" G RXQ
        I IBD("DEA")["M"!(IBD("DEA")["0") S IBRMARK="DRUG NOT BILLABLE" D CT S IBRES="0^COMPOUND DRUG" G RXQ
        ; -- check drug (not investigational, supply, over the counter, or nutritional supplement drug
        ;  "E" means always ecme billable
        I (IBD("DEA")["I"!(IBD("DEA")["S")!(IBD("DEA")["9"))!(IBD("DEA")["N"),IBD("DEA")'["E" S IBRMARK="DRUG NOT BILLABLE" D CT S IBRES="0^"_IBRMARK G RXQ
        ;
        ;retrieve indicators from file #52 and overwrite the indicators in IBD array
        D GETINDIC^IBNCPUT2(+IBD("IEN"),.IBD)
        ; -- process patient exemptions if any (if not already resolved)
        I $G(IBD("SC/EI OVR"))'=1 D CL^SDCO21(DFN,IBADT,"",.IBARR)
        ; check out exemptions
        S IBNEEDS=0 ;flag will be set to 1 if at least one of the questions wasn't answered
        I $G(IBD("SC/EI OVR"))'=1 I $D(IBARR)>9 F IBX=2:1 S IBT=$P($T(EXEMPT+IBX),";;",2) Q:IBT=""  D:$D(IBARR(+IBT))
        . I $G(IBD($P(IBT,U,2)))=0 Q
        . I $G(IBD($P(IBT,U,2))) S IBRMARK=$P(IBT,U,3) Q
        . I '$G(IBSCRES(IBRXN,IBFIL)) S IBNEEDS=1 D
        . . S IBD("SC/EI NO ANSW")=$S($G(IBD("SC/EI NO ANSW"))="":$P(IBT,U,2),1:$G(IBD("SC/EI NO ANSW"))_","_$P(IBT,U,2))
        I '$D(IBRMARK),IBNEEDS=1 S IBRMARK="NEEDS SC DETERMINATION"
        I $D(IBRMARK) D CT S IBRES="0^"_IBRMARK G RXQ
        ; Clean-up the NEEDS SC DETERMINATION record if resolved
        ; And check if it is non-billable in CT
        I IBTRKRN D
        . N IBNBR,IBNBRT
        . S IBNBR=$P($G(^IBT(356,+IBTRKRN,0)),U,19) Q:'IBNBR
        . S IBNBRT=$P($G(^IBE(356.8,IBNBR,0)),U) Q:IBNBRT=""
        . ; if refill was deleted (not RX) and now the refill is re-entered
        . ;use $$RXSTATUS^IBNCPRR instead of $G(^PSRX(IBRXN,"STA"))
        . I IBNBRT="PRESCRIPTION DELETED",$$RXSTATUS^IBNCPRR(DFN,IBRXN)'=13 D  Q
        . . N DIE,DA,DR
        . . ; clean up REASON NOT BILLABLE and ADDITIONAL COMMENT
        . . S DIE="^IBT(356,",DA=+IBTRKRN,DR=".19////@;1.08////@" D ^DIE
        . ; Clean up NBR if released
        . I IBNBRT="PRESCRIPTION NOT RELEASED" D:$G(IBD("RELEASE DATE"))  Q
        . . N DIE,DA,DR
        . . S DIE="^IBT(356,",DA=+IBTRKRN,DR=".19////@" D ^DIE
        . ; Clean up 'Needs SC determ'
        . I IBNBRT="NEEDS SC DETERMINATION" D  Q
        . . N DIE,DA,DR
        . . S DIE="^IBT(356,",DA=+IBTRKRN,DR=".19////@" D ^DIE
        . S IBRMARK=IBNBRT
        I $D(IBRMARK) S IBRES="0^Non-Billable in CT: "_IBRMARK G RXQ
        ;
        ; -- setup insurance data for patient
        S IBERMSG="" ; Error message
        S IBX=0 F  S IBX=$O(IBINS("S",IBX)) Q:'IBX  D
        . S IBT=0 F  S IBT=$O(IBINS("S",IBX,IBT)) Q:'IBT  D
        .. N IBDAT,IBPL,IBINSN,IBPIEN,IBY,IBZ
        .. S IBZ=$G(IBINS(IBT,0)) Q:IBZ=""
        .. S IBPL=$P(IBZ,U,18) ; plan
        .. Q:'IBPL
        .. Q:'$$PLCOV^IBCNSU3(IBPL,IBADT,3)  ; not covered
        .. I '$D(IBD("INS")),$P(IBRT,"^",3)="V",($P($G(^IBE(355.1,+$P($G(^IBA(355.3,+IBPL,0)),"^",9),0)),"^")["TRICARE"!($P($G(^(0)),"^")="CHAMPVA")) K IBINS Q  ;Tricare/ChampVa coverage for a Vet
        .. S IBINSN=$P($G(^DIC(36,+$G(^IBA(355.3,+IBPL,0)),0)),U) ; ins name
        .. S IBPIEN=+$G(^IBA(355.3,+IBPL,6))
        .. I 'IBPIEN S IBERMSG="Plan not linked to the Payer" Q  ; Not linked
        .. D STCHK^IBCNRU1(IBPIEN,.IBY)
        .. I $E($G(IBY(1)))'="A" S IBERMSG=$$ERMSG($P($G(IBY(6)),",")) Q  ; not active
        .. S IBDAT=IBPL ; Plan IEN
        .. S $P(IBDAT,U,2)=$G(IBY(2)) ; BIN
        .. S $P(IBDAT,U,3)=$G(IBY(3)) ; PCN
        .. S $P(IBDAT,U,4)=$P($G(^BPSF(9002313.92,+$P($G(IBY(5)),",",1),0)),U) ; Payer Sheet B1
        .. S $P(IBDAT,U,5)=$P($G(IBINS(IBT,355.3)),U,4) ; Group ID
        .. S $P(IBDAT,U,6)=$P(IBZ,U,2) ; Cardholder ID
        .. S $P(IBDAT,U,7)=$P(IBZ,U,16) ; Patient Relationship Code
        .. S $P(IBDAT,U,8)=$P($P($P(IBZ,U,17),",",2)," ") ; Cardholder First Name
        .. S $P(IBDAT,U,9)=$P($P(IBZ,U,17),",") ; Cardholder Last Name
        .. S $P(IBDAT,U,10)=$P($G(^DIC(36,+IBZ,.11)),U,5) ; State
        .. S $P(IBDAT,U,11)=$P($G(^BPSF(9002313.92,+$P($G(IBY(5)),",",2),0)),U) ; Payer Sheet B2
        .. S $P(IBDAT,U,12)=$P($G(^BPSF(9002313.92,+$P($G(IBY(5)),",",3),0)),U) ; Payer Sheet B3
        .. S $P(IBDAT,U,13)=$G(IBY(4)) ; Software/Vendor Cert ID
        .. S $P(IBDAT,U,14)=IBINSN ; Ins Name
        .. S IBD("INS",IBX,1)=IBDAT
        .. S IBDAT=$P($G(IBINS(IBT,355.3)),"^",3) ;group name
        .. S $P(IBDAT,U,2)=$$PHONE(+IBZ) ;ins co ph 3
        .. S $P(IBDAT,U,3)=$$GET1^DIQ(366.03,IBPIEN_",",.01) ;plan ID
        .. S $P(IBDAT,U,4)=$S($P($G(^IBE(355.1,+$P($G(IBINS(IBT,355.3)),"^",9),0)),"^")="TRICARE":"T",1:"V") ; plan type
        .. S $P(IBDAT,U,5)=+$G(^IBA(355.3,+IBPL,0)) ; insurance co ien
        .. S IBD("INS",IBX,3)=IBDAT
        I '$D(IBD("INS")),IBERMSG'="" S IBRES="0^Not ECME billable: "_IBERMSG,IBD("NO ECME INSURANCE")=1 G RXQ
        I '$D(IBD("INS")) S IBRES="0^No Insurance ECME billable",IBD("NO ECME INSURANCE")=1 G RXQ
        ;
        ; determine rates/prices to use
        I 'IBRT D CT S IBRES="0^Cannot determine Rate type" G RXQ
        S IBBI=$$EVNTITM^IBCRU3(+IBRT,3,"PRESCRIPTION FILL",IBADT,.IBRS)
        I 'IBBI,$P(IBBI,";")'="VA COST" D CT S IBRES="0^Cannot find Billable Item" G RXQ
        ;1;BEDSECTION;1^
        ;IBRS(1,18,5)=
        S IBRS=+$O(IBRS($P(IBBI,";"),0))
        S IBIT=$$ITPTR^IBCRU2($P(IBBI,";"),$S($P(IBRT,U,2)="A":$$NDC^IBNCPDPU($G(IBD("NDC"))),1:"PRESCRIPTION"))
        I 'IBIT,$P(IBRT,U,2)'="C" D CT S IBRES="0^Cannot find Item Pointer" G RXQ
        ;8
        S IBPRICE=+$$BICOST^IBCRCI(+IBRT,3,IBADT,"PRESCRIPTION FILL",+IBIT,,,$S($P(IBRT,U,2)="A":IBD("QTY"),1:1))
        ;36^2991001
        ;
        ; get fees if any, ignore return, don't care about price, just need fees
        S IBCHG=$$RATECHG^IBCRCC(+IBRS,$S($P(IBRT,U,2)'="C":1,1:IBD("QTY")*IBD("COST")),IBADT,.IBFEE)
        I $P(IBRT,U,2)="C" S IBPRICE=+IBCHG
        ;
        I 'IBPRICE D CT S IBRES="0^Cannot find price for Item" G RXQ
        ;
        S IBPRICE=(+$G(IBFEE))_U_$S($P(IBRT,U,2)="A":"01",$P(IBRT,U,2)="C":"05",1:"07")_U_$S($P(IBRT,U,2)="C":IBD("QTY")*IBD("COST")+$G(IBFEE),$P(IBRT,U,2)="A":IBPRICE-$G(IBFEE)-$P($G(IBFEE),U,2),1:IBPRICE)_U_IBPRICE_U_(+$P($G(IBFEE),U,2))
        S IBX=0 F  S IBX=$O(IBD("INS",IBX)) Q:IBX<1  S IBD("INS",IBX,2)=IBPRICE ;_U_$P(IBPAYER,U,6)
        ;
        S IBRES=$S($D(IBRMARK):"0^"_IBRMARK,1:1)
        I IBRES,'$G(IBD("RELEASE DATE")) S IBRMARK="PRESCRIPTION NOT RELEASED"
        D CT
        ;
RXQ     S $P(IBRES,"^",3)=$S($L($P($G(IBRT),"^",3)):$P(IBRT,"^",3),1:"V")
        I IBRES D START^IBNCPDP6(IBRXN_";"_IBFIL,$P(IBRES,"^",3),+IBRT)
        D LOG^IBNCPDP2("BILLABLE STATUS CHECK",IBRES)
        Q IBRES
        ;
        ;
CT      ; files in claims tracking
        I IBTRKR D CT^IBNCPDPU(DFN,IBRXN,IBFIL,IBADT,$G(IBRMARK))
        Q
        ;
EXEMPT  ; exemption reasons
        ; variable from SD call ^ variable from PSO ^ reason not billable
        ;;1^AO^AGENT ORANGE
        ;;2^IR^IONIZING RADIATION
        ;;3^SC^SC TREATMENT
        ;;4^SWA^SOUTHWEST ASIA
        ;;5^MST^MILITARY SEXUAL TRAUMA
        ;;6^HNC^HEAD/NECK CANCER
        ;;7^CV^COMBAT VETERAN
        ;;8^SHAD^PROJECT 112/SHAD
        ;;
        ;
ERMSG(IBSTL)    ; Inactive status reason
        N IBSTA,IBI,IBARR,IBTXT
        D STATAR^IBCNRU1(.IBARR)
        F IBI=1:1:$L(IBSTL,",")+1 S IBSTA=+$P(IBSTL,",",IBI) Q:"^100^200^300^400^"'[(U_IBSTA_U)
        S IBTXT=$G(IBARR(+IBSTA),"Plan is not active.")
        Q IBTXT
        ;
NEEDSC(IBTXT)   ; is the CT NBR one of 'needs sc determination'?
        I IBTXT="NEEDS SC DETERMINATION" Q 1
        N I,RES,IBT
        S RES=0
        F I=2:1 S IBT=$P($P($T(EXEMPT+I),";;",2),U,3) Q:IBT=""  I IBT=IBTXT S RES=1 Q
        Q RES
        ;
PAPERBIL(IBTRKRN)       ; 'paper' bill in CT?
        N IBZ,IBIFN
        S IBZ=$G(^IBT(356,IBTRKRN,0)) I IBZ="" Q 0
        S IBIFN=+$P(IBZ,U,11) I 'IBIFN Q 0
        I $P($G(^DGCR(399,IBIFN,0)),U,13)=7 Q 0  ; cancelled
        I $P($G(^DGCR(399,IBIFN,"M1")),U,8)'="" Q 0  ; ecme bill
        Q 1
        ;
        ;gets the insurance phone
        ;input:
        ; IB36 - ptr to INSURANCE COMPANY File (#36)
        ;output:
        ; the phone number
PHONE(IB36)     ;
        N IB1
        ;check first CLAIMS (RX) PHONE NUMBER if empty
        S IB1=$$GET1^DIQ(36,+IB36,.1311,"E")
        Q:$L(IB1)>0 IB1
        ;check BILLING PHONE NUMBER if empty - return nothing
        S IB1=$$GET1^DIQ(36,+IB36,.132,"E")
        Q IB1
        ;
        ;IBNCPDP1
