IBECEA3 ;ALB/CPM - Cancel/Edit/Add... Add a Charge ;30-MAR-93
        ;;2.0;INTEGRATED BILLING;**7,57,52,132,150,153,166,156,167,176,198,188,183,202,240,312,402**;21-MAR-94;Build 17
        ;;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
ADD     ; Add a Charge protocol
        N IBSWINFO S IBSWINFO=$$SWSTAT^IBBAPI()                     ;IB*2.0*312
        N IBGMT,IBGMTR
        S (IBGMT,IBGMTR)=0
        S IBCOMMIT=0,IBEXSTAT=$$RXST^IBARXEU(DFN,DT),IBCATC=$$BILST^DGMTUB(DFN),IBCVAEL=$$CVA^IBAUTL5(DFN),IBLTCST=$$LTCST^IBAECU(DFN,DT,1)
        ;I 'IBCVAEL,'IBCATC,'$G(IBRX),+IBEXSTAT<1 W !!,"This patient has never been Means Test billable." S VALMBCK="" D PAUSE^VALM1 G ADDQ1
        ;
        ; - clear screen and begin
        D CLOCK^IBAUTL3 I 'IBCLDA S (IBMED,IBCLDAY,IBCLDOL,IBCLDT)=0
        D HDR^IBECEAU("A D D")
        I IBY<0 D NODED^IBECEAU3 G ADDQ
        ;
        ; - ask for the charge type
        D CHTYP^IBECEA33 G:IBY<0 ADDQ
        N IBAFEE S:$P($G(^IBE(350.1,+$G(IBATYP),0)),"^",8)="FEE SERVICE/OUTPATIENT" IBAFEE=IBATYP
        ;
        ; - process CHAMPVA charges
        I IBXA=6 D CHMPVA^IBECEA32 G ADDQ
        ;
        ; - process TRICARE charges
        I IBXA=7 D CUS^IBECEA35 G ADDQ
        ;
        ; - display MT billing clock data
        I IBXA=2,$P($G(^IBE(350.1,+IBATYP,0)),"^",8)'["NHCU",IBCLDAY>90 S IBMED=IBMED/2
        I IBXA=1,IBCLDAY>90 D MED^IBECEA34 G:IBY<0 ADDQ
        I "^1^2^3^"[("^"_IBXA_"^"),IBCLDA W !!,"  ** Active Billing Clock **   # Inpt Days: ",IBCLDAY,"    ",$$INPT^IBECEAU(IBCLDAY)," 90 days: $",+IBCLDOL,!
        ;
        ; - display LTC billing clock data
        I IBXA>7,IBXA<10 D  G:IBCLDA<1 ADDQ
        . N IBCLZ
        . S IBCLDA=$O(^IBA(351.81,"AE",DFN,9999999),-1)
        . S:IBCLDA IBCLDA=$O(^IBA(351.81,"AE",DFN,IBCLDA,0))
        . I 'IBCLDA W !!,"  ** Patient has no LTC billing clock **" Q
        . S IBCLZ=^IBA(351.81,IBCLDA,0)
        . W !!,"  **Last LTC Billing Clock    Start Date: ",$$FMTE^XLFDT($P(IBCLZ,"^",3)),"  Free Days Remaining: ",+$P(IBCLZ,"^",6)
        . I $P(IBCLZ,"^",6) W !,"The patient must use his free days first." S IBCLDA=0
        ;
        ; - ask units for rx copay charge
        I IBXA=5 D UNIT^IBECEAU2(0) G ADDQ:IBY<0 D  G ADDQ:IBY<0 G PROC
        . ;
        . ; has patient been previously tracked for cap info
        . D TRACK^IBARXMN(DFN)
        . ;
        . D CTBB^IBECEAU3
        . ;
        . ; check if above cap
        . I IBY'<0 D
        .. N IBB,IBN,DIR,DIRUT,DUOUT,DTOUT,X,Y
        .. D NEW^IBARXMC(1,IBCHG,DT,.IBB,.IBN) Q:'IBN
        .. ;
        .. ; display message ask to proceed
        .. W !!,"This charge will put the patient > $",$J(IBN,0,2)," above their cap amount."
        .. S DIR(0)="Y",DIR("A")="Okay to proceed" D ^DIR S:'Y IBY=-1
        .. ;
        S IBLIM=$S(IBXA=4!(IBXA=3):DT,1:$$FMADD^XLFDT(DT,-1))
        ;
FR      ; - ask 'bill from' date
        D FR^IBECEAU2(0) G:IBY<0 ADDQ
        ; Do NOT PROCESS on VistA if IBFR>=Switch Eff Date          ;CCR-930
        I +IBSWINFO,(IBFR+1)>$P(IBSWINFO,"^",2) D  G FR             ;IB*2.0*312
          .W !!,"The 'Bill From' date cannot be on or AFTER the PFSS Effective Date"
          .W ": ",$$FMTE^XLFDT($P(IBSWINFO,"^",2))
        ;
        S IBGMT=$$ISGMTPT^IBAGMT(DFN,IBFR),IBGMTR=0 ;GMT Copayment Status
        I IBGMT>0,IBXA>0,IBXA<4 W !,"The patient has GMT Copayment Status."
        ; - check the MT billing clock
        I IBXA'=8,IBXA'=9 D CLMSG^IBECEA33 G:IBY<0 ADDQ
        ;Adjust Deductible for GMT patient
        I IBGMT>0,IBXA>0,IBXA<4,$G(IBMED) S IBMED=$$REDUCE^IBAGMT(IBMED) W !,"Medicare Deductible reduced due to GMT Copayment Status ($",$J(IBMED,"",2),")."
        ;
        ; - check the LTC billing clock
        I IBXA>7,IBXA<10 D  I IBY<0 W !!,"The patient has no LTC clock active for the date.",! G ADDQ
        . N IBCLZ S IBCLZ=^IBA(351.81,IBCLDA,0)
        . ;
        . ; is this the clock and within the date range
        . I IBFR'<$P(IBCLZ,"^",3),$$YR^IBAECU($P(IBCLZ,"^",3),IBFR) S IBY=-1 Q
        . ;
        . ; look for another clock that might fit the date
        . I IBFR<$P(IBCLZ,"^",3) S IBCLDA=$O(^IBA(351.81,"AE",DFN,IBFR+1),-1) I 'IBCLDA!($$YR^IBAECU($P($G(^IBA(351.81,+IBCLDA,0)),"^",3),IBFR)) S IBY=-1
        ;
        ; - calculate the MT inpt copay charge
        I IBXA=2 S IBDT=IBFR D COPAY^IBAUTL2 G ADDQ:IBY<0 S:IBGMT>0 IBGMTR=1,IBCHG=$$REDUCE^IBAGMT(IBCHG) I IBCHG+IBCLDOL<IBMED W *7,"   ($",IBCHG,"/day)" W:IBGMTR " GMT Rate"
        ;
        ; - find the correct clock from the 'bill from' date (ignore LTC)
        I IBXA'=8,IBXA'=9,('IBCLDA!(IBCLDA&(IBFR<IBCLDT))) D NOCL^IBECEA33 G:IBY<0 ADDQ
        ;
        ; - perform outpatient edits
        N IBSTOPDA
        I IBXA=4 D  G ADDQ:IBY<0,PROC
        .   ;  for visits prior to 12/6/01 or FEE
        .   I IBFR<3011206!($G(IBAFEE)) D OPT^IBECEA33 Q
        .   ;  for visits on or after 12/5/01
        .   D OPT^IBEMTSCU
        ;
        ; - if LTC outpatient calculate the charge
        I IBXA=8 D  G:IBY<0 ADDQ S (IBDT,IBTO,IBEVDT)=IBFR,IBDESC=$P(^IBE(350.1,IBATYP,0),"^",8),IBUNIT=1,IBEVDA="*" D COST^IBAUTL2,CALC^IBAECO,CTBB^IBECEAU3 G @$S(IBCHG:"PROC",1:"ADDQ")
        . ;
        . ; is this day already a free day
        . I $D(^IBA(351.81,IBCLDA,1,"AC",IBFR)) W !!,"This day is already marked as a Free Day." S IBY=-1
        . ;
        . ; have we already billed for this day
        . I $$BFO^IBECEAU(DFN,IBFR) W !!,"This patient has already been billed for this date." S IBY=-1
        ;
        ; - find per diem charge and description
        I IBXA=3 D  I 'IBCHG W !!,"Unable to determine the per diem rate.  Please check your rate table." G ADDQ
        .N IBDT S IBDT=IBFR,IBGMTR=0 D COST^IBAUTL2
        .I IBGMT>0 S IBGMTR=1,IBCHG=$$REDUCE^IBAGMT(IBCHG)
        .S IBDESC="" X:$D(^IBE(350.1,IBATYP,20)) ^(20)
        ;
        ; - calculate charge for the inpatient copay
        I IBXA=2,IBCHG+IBCLDOL'<IBMED S IBCHG=IBMED-IBCLDOL,IBUNIT=1,IBTO=IBFR D CTBB^IBECEAU3 G EV
        ;
TO      ; - ask 'bill to' date
        D TO^IBECEAU2(0) G:IBY<0 ADDQ
        ; Do NOT PROCESS on VistA if IBTO>=Switch Eff Date         ;CCR-930
        I +IBSWINFO,(IBTO+1)>$P(IBSWINFO,"^",2) D  G TO            ;IB*2.0*312
         .W !!,"The 'Bill To' date cannot be on or AFTER the PFSS Effective Date"
         .W ": ",$$FMTE^XLFDT($P(IBSWINFO,"^",2))
        ;
        I IBXA>0,IBXA<4,IBGMT'=$$ISGMTPT^IBAGMT(DFN,IBTO) W !!,"The patient's GMT Copayment status changed within the specified period!",! G ADDQ
        ;
        ; - calculate unit charge for LTC inpatient in IBCHG
        I IBXA=9 S IBDT=IBFR,IBEVDA=$$EVF^IBECEA31(DFN,IBFR,IBTO,IBNH),IBEVDT=$E(IBFR,1,5)_"01" D:IBEVDA<1  G ADDQ:IBY<0 D COST^IBAUTL2 I $E(IBFR,1,5)'=$E(IBTO,1,5) W !!,"  LTC Copayment charges cannot go from one month to another." G ADDQ
        . D NOEV^IBECEA31 I '$G(IBDG)!(IBY<0) S IBY=-1 Q
        . ; - build the event record
        . N IBNHLTC S IBNHLTC=1 D ADEV^IBECEA31
        ;
        ;
        ; - calculate units and total charge
        S IBUNIT=$$FMDIFF^XLFDT(IBTO,IBFR) S:IBXA'=3!(IBFR=IBTO) IBUNIT=IBUNIT+1
        I IBXA=1 D:IBGMT>0  D FEPR^IBECEA32 G ADDQ:IBY<0,EV
        . S IBGMTR=1
        . W !,"The patient has GMT Copayment Status! GMT rate must be applied.",!
        S IBCHG=IBCHG*IBUNIT S:IBXA=2 IBCHG=$S(IBCLDOL+IBCHG>IBMED:IBMED-IBCLDOL,1:IBCHG)
        ;
        ; adjust the LTC charge based on the calculated copay cap
        I IBXA=9 D CALC^IBAECI G:IBY<1!('IBCHG) ADDQ S IBDESC="LTC INPATIENT COPAY"
        ;
        D CTBB^IBECEAU3 W:IBXA=3!(IBXA=9) "  (for ",IBUNIT," day",$E("s",IBUNIT>1),")" W:IBGMTR " GMT Rate"
        ;
EV      ; - find event record, or select admission for linkage
        I IBXA'=9 S IBEVDA=$$EVF^IBECEA31(DFN,IBFR,IBTO,IBNH)
        I IBEVDA'>0 D NOEV^IBECEA31 G ADDQ:IBY<0,PROC
        S IBSL=$P($G(^IB(+IBEVDA,0)),"^",4)
        W !!,"Linked charge to ",$$TYP(),"admission on ",$$DAT1^IBOUTL($P(IBEVDA,"^",2)),"  ("
        W $S($P(IBEVDA,"^",3)=9999999:"Still admitted)",1:"Discharged on "_$$DAT1^IBOUTL($P(IBEVDA,"^",3))_$S($P(IBEVDA,"^",3)>DT:" [pseudo])",1:")"))," ..."
        S IBEVDA=+IBEVDA
        I '$G(IBSIBC) D SPEC^IBECEA32(0,$O(^IBE(351.2,"AD",IBEVDA,0)))
        ;
        ;
PROC    ; - okay to proceed?
        D PROC^IBECEAU4("add") G:IBY<0 ADDQ
        ;
        ; - build the event record first if necessary
        I $G(IBDG),IBXA'=9 D @("ADEV^IBECEA3"_$S($G(IBFEEV):4,1:1)) G:IBY<0 ADDQ
        ;
        ; - disposition the special inpatient billing case, if necessary
        I $G(IBSIBC) D CEA^IBAMTI1(IBSIBC,IBEVDA)
        ;
        ; - generate entry in file #354.71 and #350
        I IBXA=5 W !!,"Building the new transaction...  " S IBAM=$$ADD^IBARXMN(DFN,"^^"_DT_"^^P^^"_IBUNIT_"^"_IBCHG_"^"_IBDESC_"^^"_IBCHG_"^0^"_IBSITE) G:IBAM<0 ADDQ
        D ADD^IBECEAU3 G:IBY<0 ADDQ W "done."
        ;
        ; - pass the charge off to AR on-line
        W !,"Passing the charge directly to Accounts Receivable... "
        D PASSCH^IBECEA22 W:IBY>0 "done." G:IBY<0 ADDQ
        ;
        ; - review the special inpatient billing case
        I $G(IBSIBC1) D CHK^IBAMTI1(IBSIBC1,IBEVDA)
        ;
        ; - handle updating of clock
        I IBXA'=8,IBXA'=9 D CLUPD^IBECEA32
        ;
ADDQ    ; - display error, rebuild list, and quit
        D ERR^IBECEAU4:IBY<0,PAUSE^IBECEAU S VALMBCK="R"
        I IBCOMMIT S IBBG=VALMBG W !,"Rebuilding list of charges..." D ARRAY^IBECEA0 S VALMBG=IBBG
        K IBMED,IBCLDA,IBCLDT,IBCLDOL,IBCLDAY,IBATYP,IBDG,IBSEQNO,IBXA,IBNH,IBBS,IBLIM,IBFR,IBTO,IBRTED,IBSIBC,IBSIBC1,IBBG,IBFEEV,IBAM
        K IBX,IBCHG,IBUNIT,IBDESC,IBDT,IBEVDT,IBEVDA,IBSL,IBNOS,IBN,IBTOTL,IBARTYP,IBIL,IBTRAN,IBAFY,IBCVA,IBCLSF,IBDD,IBND,VADM,VA,VAERR,IBADJMED
ADDQ1   K IBEXSTAT,IBCOMMIT,IBCATC,IBCVAEL,IBLTCST
        Q
        ;
        ;
TYP()   ; Return descriptive admission type.
        N X S X=""
        I IBNH'=2 G TYPQ
        I $G(IBADJMED) S X=$S(IBADJMED=1:"C",1:"H")
        E  S X=$S($P($G(^IBE(350.1,+IBATYP,0)),"^")["NHCU":"C",1:"H")
        S X=$S(X="C":"CNH ",1:"Contract Hospital ")
TYPQ    Q X
