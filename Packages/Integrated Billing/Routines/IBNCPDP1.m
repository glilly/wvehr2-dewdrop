IBNCPDP1        ;OAK/ELZ - PROCESSING FOR NEW RX REQUESTS ;5/22/08  15:24
        ;;2.0;INTEGRATED BILLING;**223,276,339,363,383,405,384,411**;21-MAR-94;Build 29
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
RX(DFN,IBD)     ; pharmacy package call, passing in IBD by ref
        ; this is called by PSO for all prescriptions issued, return is
        ; a response to bill ECME or not with array for billing data elements
        ;warning: back-billing flag:
        ;if passed IBSCRES(IBRXN,IBFIL)=1
        ; - then the SC Determination is just done by the IB clerk (billable)
        ; IBD("PLAN") - is specified only if RX API is called for billing determination for 2ndary claim.
        ;
        ;clean up the list of non-answered SC/Env.indicators questions and INS
        K IBD("SC/EI NO ANSW"),IBD("INS")
        ;
        N IBTRKR,IBARR,IBADT,IBRXN,IBFIL,IBTRKRN,IBRMARK,IBANY,IBX,IBT,IBINS,IBSAVE
        N IBFEE,IBEABD,IBBI,IBIT,IBPRICE,IBRS,IBRT,IBTRN,IBCHG,IBERMSG,IBRXPOL,IBCNT,IBRES,IBNEEDS
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
        D
        . I $G(IBD("RTYPE")),$G(IBD("PLAN")) S IBRT=+IBD("RTYPE") D  Q  ;Rate type was selected by the user for secondary or primary claims entered manually
        . . S IBRT=IBRT_U_$$COSTTYP^IBNCPUT3(+IBD("RTYPE"),IBADT)
        . S IBRT=$$RT^IBNCPDPU(DFN,.IBINS)
        ;
        ;for secondary billing - skip claim tracking functionality
        G:$G(IBD("RXCOB"))>1 SETINSUR
        ;
        ; -- claims tracking info
        S IBTRKR=$G(^IBE(350.9,1,6))
        ; date can't be before parameters
        S $P(IBTRKR,U)=$S('$P(IBTRKR,U,4):0,+IBTRKR&(IBADT<+IBTRKR):0,1:IBADT)
        ; already in claims tracking
        S IBTRKRN=+$O(^IBT(356,"ARXFL",IBRXN,IBFIL,0))
        I IBTRKRN,$$PAPERBIL^IBNCPNB(IBTRKRN) S IBRES="0^Existing IB Bill in CT",IBD("NO ECME INSURANCE")=1 G RXQ
        ; already billed as Tricare
        I $D(^IBA(351.5,"B",IBRXN_";"_IBFIL)) S IBRES="0^Already billed under prior Tricare process",IBD("NO ECME INSURANCE")=1 G RXQ
        ;
        ; -- no pharmacy coverage, update ct if applicable, quit
        I '$$PTCOV^IBCNSU3(DFN,IBADT,"PHARMACY",.IBANY) S IBRMARK=$S($G(IBANY):"SERVICE NOT COVERED",1:"NOT INSURED") D:$P(IBTRKR,U,4)=2 CT S IBRES="0^"_IBRMARK,IBD("NO ECME INSURANCE")=1 G RXQ
        ;
        ;  -- check for DEA SPECIAL HDLG
        S IBDEA=$$DEA^IBNCPDP($G(IBD("DEA")),.IBRMARK) I 'IBDEA S IBRES=IBDEA D CT G RXQ
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
SETINSUR        ; -- setup insurance data for patient
        ; Note: if more than one insurance with the same COB then the latest insurance occurance overrides the first one(s)
        ; Exmp:
        ; IBINS("S",1,1)=""
        ; IBINS("S",1,3)="" <<--- this will be primary
        ;
        K IBERMSG    ; Error message
        K IBRXPOL    ; Array of Rx policies found
        S IBX=0 F  S IBX=$O(IBINS("S",IBX)) Q:'IBX  D
        . S IBT=0 F  S IBT=$O(IBINS("S",IBX,IBT)) Q:'IBT  D
        .. N IBDAT,IBPL,IBINSN,IBPIEN,IBY,IBZ
        .. S IBZ=$G(IBINS(IBT,0)) Q:IBZ=""
        .. S IBPL=$P(IBZ,U,18) ; plan
        .. Q:'IBPL
        .. Q:'$$PLCOV^IBCNSU3(IBPL,IBADT,3)  ; not a pharmacy plan
        .. ;
        .. I $G(IBD("PLAN")) Q:IBPL'=$G(IBD("PLAN"))  ;skip other plans if we call RX API for a specific plan (IBD("PLAN"))
        .. ;
        .. I '$G(IBD("PLAN")) I '$D(IBD("INS")),$P(IBRT,"^",3)="V",($P($G(^IBE(355.1,+$P($G(^IBA(355.3,+IBPL,0)),"^",9),0)),"^")["TRICARE"!($P($G(^(0)),"^")="CHAMPVA")) K IBINS Q  ;Tricare/ChampVa coverage for a Vet
        .. ;
        .. ; at this point we have found an Rx policy.  We'll count these up later by IBX.
        .. S IBRXPOL(IBX,IBT)=""
        .. ;
        .. S IBINSN=$P($G(^DIC(36,+$G(^IBA(355.3,+IBPL,0)),0)),U) ; ins name
        .. S IBPIEN=+$G(^IBA(355.3,+IBPL,6))
        .. I 'IBPIEN S IBERMSG(IBX)="Plan not linked to the Payer" Q  ; Not linked
        .. D STCHK^IBCNRU1(IBPIEN,.IBY)
        .. I $E($G(IBY(1)))'="A" S IBERMSG(IBX)=$$ERMSG^IBNCPNB($P($G(IBY(6)),",")) Q  ; not active
        .. ;
        .. ; at this point we have a valid policy for this IBX
        .. S IBERMSG(IBX)=""          ; no error message
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
        .. ;
        .. S IBDAT=$P($G(IBINS(IBT,355.3)),"^",3) ;group name
        .. S $P(IBDAT,U,2)=$$PHONE^IBNCPDP6(+IBZ) ;ins co ph 3
        .. S $P(IBDAT,U,3)=$$GET1^DIQ(366.03,IBPIEN_",",.01) ;plan ID
        .. S $P(IBDAT,U,4)=$S($P($G(^IBE(355.1,+$P($G(IBINS(IBT,355.3)),"^",9),0)),"^")="TRICARE":"T",1:"V") ; plan type
        .. S $P(IBDAT,U,5)=+$G(^IBA(355.3,+IBPL,0)) ; insurance co ien
        .. S $P(IBDAT,U,6)=$P(IBZ,U,20) ;(#.2) COB field of the (#.3121) insurance Type multiple of the Patient file (#2)
        .. S IBD("INS",IBX,3)=IBDAT
        .. Q
        . Q
        ;
        ; Count the number of pharmacy insurance policies by IBX found up above
        S IBX=0 F IBCNT=0:1 S IBX=$O(IBRXPOL(IBX)) Q:'IBX
        ;
        ; Determine the value of the IBX variable here.  This is basically the COB sequence# to be used.
        ; If there is only 1 pharmacy policy or no pharmacy policies, then set IBX in this manner
        I IBCNT'>1 D
        . I $D(IBD("INS")) S IBX=+$O(IBD("INS",0))     ; use the only one in this array
        . I '$D(IBD("INS")) S IBX=+$O(IBERMSG(0))      ; the only one here (or 0)
        . Q
        ;
        ; If there are multiple pharmacy policies on file, then the COB field in the pt. policy must be used correctly
        ;   and primary insurance must be at #1
        I IBCNT>1 S IBX=1
        ;
        ; In all cases, if this variable is set, then use it
        I $G(IBD("RXCOB"))>1 S IBX=$G(IBD("RXCOB"))
        ;
        ; Check insurance at IBX
        I '$D(IBD("INS",IBX)),$G(IBERMSG(IBX))'="" S IBRES="0^Not ECME billable: "_IBERMSG(IBX),IBD("NO ECME INSURANCE")=1 G RXQ
        I '$D(IBD("INS",IBX)) S IBRES="0^No Insurance ECME billable",IBD("NO ECME INSURANCE")=1 G RXQ
        ;
        ;for secondary billing - skip ROI functionality
        G:$G(IBD("RXCOB"))>1 RATEPRIC
        ; -- check drug for sensitive dx special handling code and ROI on file
        I IBD("DEA")["U",$D(IBD("INS",1,3)) D  G:$D(IBRMARK) RXQ
        . I '$$ROI^IBNCPDR4(DFN,$G(IBD("DRUG")),+$P($G(IBD("INS",1,3)),U,5),$G(IBD("FILL DATE"))) D  Q
        .. S IBRMARK="REFUSES TO SIGN RELEASE (ROI)"
        .. D CT
        .. S IBRES="0^NOT BILLABLE, NO ROI - NO ACTIVE ROI ON FILE"
        . D ROICLN^IBNCPDR4(IBTRKRN,IBRXN,IBFIL) K:$G(IBRMARK)="REFUSES TO SIGN RELEASE (ROI)" IBRMARK
        ;
RATEPRIC        ;
        ; determine rates/prices to use
        I 'IBRT D CT S IBRES="0^Cannot determine Rate type" G RXQ
        S IBBI=$$EVNTITM^IBCRU3(+IBRT,3,"PRESCRIPTION FILL",IBADT,.IBRS)
        I 'IBBI,$P(IBBI,";")'="VA COST" D CT S IBRES="0^Cannot find Billable Item" G RXQ
        ;1;BEDSECTION;1^
        ;IBRS(1,18,5)=
        S IBRS=+$O(IBRS($P(IBBI,";"),0))
        S IBIT=$$ITPTR^IBCRU2($P(IBBI,";"),$S($P(IBRT,U,2)="A":$$NDC^IBNCPNB($G(IBD("NDC"))),1:"PRESCRIPTION"))
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
        S IBX=0 F  S IBX=$O(IBD("INS",IBX)) Q:IBX<1  S IBD("INS",IBX,2)=IBPRICE
        ;
        ;Check for non-covered drugs
        S IBRES=$$CHCK^IBNCDNC(.IBD) I IBRES]"" S IBRMARK=$P(IBRES,U,2) D CT G RXQ
        ;
        S IBRES=$S($D(IBRMARK):"0^"_IBRMARK,1:1)
        I IBRES,'$G(IBD("RELEASE DATE")) S IBRMARK="PRESCRIPTION NOT RELEASED"
        ;
        D CT
        ;
RXQ     S $P(IBRES,"^",3)=$S($L($P($G(IBRT),"^",3)):$P(IBRT,"^",3),1:"V")
        I IBRES D START^IBNCPDP6(IBRXN_";"_IBFIL,$P(IBRES,"^",3),+IBRT)
        D LOG^IBNCPDP2("BILLABLE STATUS CHECK",IBRES)
        Q IBRES
        ;
        ;
CT      ; files in claims tracking
        Q:$G(IBD("RXCOB"))>1  ;Claim Tracking is updated only for the primary payer (payer sequence =1)
        ;If null then the payer sequence = Primary is assumed
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
