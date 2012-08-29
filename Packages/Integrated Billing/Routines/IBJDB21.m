IBJDB21 ;ALB/RB - REASONS NOT BILLABLE REPORT (COMPILE) ;19-JUN-00
 ;;2.0;INTEGRATED BILLING;**123,159,185**;21-MAR-94
 ;
EN ; - Entry point from IBJDB2.
 K ^TMP("IBJDB2",$J),IB,IBE
 I '$G(IBXTRACT) D
 . F X=1:1:4 I IBSEL[X S IBE(X)=IBEPS(X) ; Set episodes for report.
 ;
 ; - Print the header line for the Excel spreadsheet
 I $G(IBEXCEL) D PHDL
 ;
 ; - Compile reason not billable (RNB) data for episode.
 S IBRNB=0 F  S IBRNB=$S(IBSRNB'="A":$O(IBSRNB(IBRNB)),1:$O(^IBE(356.8,IBRNB))) Q:'IBRNB  D
 .S IB0=0 F  S IB0=$O(^IBT(356,"AR",IBRNB,IB0)) Q:'IB0  D
 ..S IBN0=$G(^IBT(356,IB0,0)),IBN1=$G(^IBT(356,IB0,1)) Q:'IBN0!('IBN1)
 ..S IBEP=+$P(IBN0,U,18) I IBSEL'[IBEP Q  ; Get episode.
 ..S (IBRNB1,IBSORT1)=$P($G(^IBE(356.8,IBRNB,0)),U)
 ..;
 ..; - Get valid date entered/episode date and amount for report.
 ..S IBEPD=+$P(IBN0,U,6)\1,IBDEN=+IBN1\1
 ..S IBDT=$S($E(IBD)="D":IBDEN,1:IBEPD)
 ..Q:IBDT<IBBDT!(IBDT>IBEDT)
 ..S IBAMT=$$AMOUNT(IBEP,IB0)
 ..;
 ..; - Get division, if necessary.
 ..I IBSD D  Q:'VAUTD&('$D(VAUTD(IBDIV)))
 ...S IBDIV=$$DIV^IBJD1(IB0)
 ..E  S IBDIV=$S($G(IBEXCEL):+$$PRIM^VASITE(),1:0)
 ..;
 ..; - Provider & Specialty
 ..S (IBPRV,IBSPC)="",IBQT=0
 ..I IBEP=1!(IBEP=2) D  I IBQT Q
 ...S IBPRSP=$$PRVSPC(IBEP,IB0)
 ...I IBSPRV'="A",'$D(IBSPRV(+IBPRSP)) S IBQT=1 Q
 ...I IBEP=1,IBSISP'="A",'$D(IBSISP(+$P(IBPRSP,U,3))) S IBQT=1 Q
 ...I IBEP=2,IBSOSP'="A",'$D(IBSOSP(+$P(IBPRSP,U,3))) S IBQT=1 Q
 ...S IBPRV=$S($P(IBPRSP,U,2)'="":$P(IBPRSP,U,2),1:"** UNKNOWN **")
 ...S IBSPC=$S($P(IBPRSP,U,4)'="":$P(IBPRSP,U,4),1:"** UNKNOWN **")
 ..;
 ..; - Get remaining data for detailed report.
 ..S DFN=+$P(IBN0,U,2)
 ..D DEM^VADPT S IBPT=$E(VADM(1),1,25),IBSSN=$P(VADM(2),U)
 ..S DIC="^VA(200,",DA=+$P(IBN1,U,4),DR=".01",DIQ="IBCLK" D EN^DIQ1
 ..S IBCLK=$E($G(IBCLK(200,DA,.01)),1,20)
 ..;
 ..; - Get totals for summary.
 ..I '$D(IB(IBDIV,IBEP,IBRNB)) S IB(IBDIV,IBEP,IBRNB)="0^0"
 ..S $P(IB(IBDIV,IBEP,IBRNB),U)=$P(IB(IBDIV,IBEP,IBRNB),U)+1
 ..S $P(IB(IBDIV,IBEP,IBRNB),U,2)=$P(IB(IBDIV,IBEP,IBRNB),U,2)+IBAMT
 ..I IBRPT="S" Q
 ..;
 ..S IBSORT1=$S(IBSORT="P":IBPRV,IBSORT="S":IBSPC,1:IBSORT1)
 ..S:IBSORT1="" IBSORT1=" "
 ..;
 ..I $G(IBEXCEL) D  Q
 ...W !,$E($P($G(^DG(40.8,IBDIV,0)),U),1,25),U
 ...W $S(IBEP<4:$E(IBE(IBEP)),1:"H"),U,IBPT,U,IBSSN,U
 ...W $$DT^IBJD(IBEPD,1),U,$$DT^IBJD(IBDEN,1),U
 ...W $$DT^IBJD($P(IBN1,U,3),1),U,IBCLK,U,$E(IBRNB1,1,25),U
 ...W $E(IBPRV,1,25),U,$E(IBSPC,1,25),U,IBAMT,U,$P(IBN1,U,8)
 ..;
 ..S X=IBEPD_U_IBDEN_U_$P(IBN1,U,3)_U_IBCLK_U_IBRNB1
 ..S X=X_U_IBPRV_U_IBSPC_U_IBAMT_U_$E($P(IBN1,U,8),1,70)
 ..S ^TMP("IBJDB2",$J,IBDIV,IBEP,IBSORT1,IBPT_"@@"_$E(IBSSN,6,10))=$$INS^IBJD1(+$P(IBN0,U,2),IBEPD)
 ..S ^TMP("IBJDB2",$J,IBDIV,IBEP,IBSORT1,IBPT_"@@"_$E(IBSSN,6,10),+IBN0)=X
 ;
 I '$G(IBEXCEL) D EN^IBJDB22 ; Print report(s).
 ;
ENQ K ^TMP("IBJDB2")
 K DA,DIC,DIQ,DR,IB,IB0,IBAMT,IBCLK,IBDEN,IBDIV,IBDT,IBE,IBEP,IBEPD,IBI
 K IBN0,IBN1,IBN2,IBPRSP,IBPRV,IBPT,IBQT,IBRNB,IBRNB1,IBSORT1,IBSPC
 K IBSSN,VADM,X1,X2
 Q
 ;
AMOUNT(EPS,CLM) ; Return the Amount not billed 
 ; Input: EPS - Episode(1=Inpatient,2=Outpatient,3=Prosthet.,4=Prescr.)
 ;        CLM - Pointer to Claim Tracking File (#356)
 ;Output: AMOUNT not billed
 ;
 N ADM,ADMDT,AMOUNT,BLBS,BLDT,CPT,CPTLST,DA,DR,DCHD,DFN,DIC,DIQ,DIV,DRG
 N ENC,ENCDT,EPDT,PFT,PRST,PTF,RIMB,VCPT,TTCST,X
 ;
 S AMOUNT=0,X=$G(^IBT(356,CLM,0))
 S ENC=+$P(X,U,4)     ; Encounter    (Pointer to #409.68)
 S ADM=+$P(X,U,5)     ; Admission    (Pointer to #405)
 S PRST=+$P(X,U,9)    ; Prothetics   (Pointer to #660)
 S EPDT=$P(X,U,6)     ; Episode Date (FM format)
 ;
 ; - Assumes REIMBURSABLE INS. as the RATE TYPE
 S RIMB=$O(^DGCR(399.3,"B","REIMBURSABLE INS.",0)) I 'RIMB S RIMB=8
 ;
 G @("AMT"_EPS)
 ;
AMT1 ; - Inpatient Charges
 I 'ADM G QAMT
 S X=$G(^DGPM(ADM,0)) G QAMT:X="" S PTF=$P(X,U,16) G QAMT:'PTF
 S ADMDT=$P(X,U)\1,DFN=+$P(X,U,3)
 I $P(X,U,17) S DCHD=$P($G(^DGPM(+$P(X,U,17),0)),U)\1
 I '$G(DCHD) S DCHD=$$DT^XLFDT()
 ;
 K ^TMP($J,"IBCRC-PTF"),^TMP($J,"IBCRC-DIV"),^TMP($J,"IBCRC-INDT")
 D PTF^IBCRBG(PTF) G QAMT:'$D(^TMP($J,"IBCRC-PTF"))
 D PTFDV^IBCRBG(PTF) G QAMT:'$D(^TMP($J,"IBCRC-DIV"))
 D BSLOS^IBCRBG(ADMDT,DCHD,1,ADM,0) G QAMT:'$D(^TMP($J,"IBCRC-INDT"))
 ;
 S BLDT=""
 F  S BLDT=$O(^TMP($J,"IBCRC-INDT",BLDT)) Q:BLDT=""  D
 .S X=^TMP($J,"IBCRC-INDT",BLDT)
 .S BLBS=$P(X,U,2),DRG=$P(X,U,4),DIV=$P(X,U,5)
 .;
 .; - Tort Liable Charge (prior to 09/01/99)
 .I BLDT<2990901 D  Q
 ..S AMOUNT=AMOUNT+$$BICOST^IBCRCI(RIMB,1,BLDT,"INPATIENT BEDSECTION STAY",BLBS)
 .;
 .; - Reasonable Charges (on 09/01/99 or later)
 .S AMOUNT=AMOUNT+$$BICOST^IBCRCI(RIMB,1,BLDT,"INPATIENT DRG",DRG,"",DIV,"",1)
 ;
 ; - Add the Professional Average Amount per Episode (Reason.Chg only)
 I EPDT'<2990901 S AMOUNT=AMOUNT+$$AVG(EPDT)
 ;
 ; - Subtract the amount billed for this Episode
 S AMOUNT=AMOUNT-$$CLAMT(DFN,EPDT,1)
 ;
 K ^TMP($J,"IBCRC-PTF"),^TMP($J,"IBCRC-DIV"),^TMP($J,"IBCRC-INDT")
 ;
 G QAMT
 ;
AMT2 ; - Outpatient Charges
 S X=$$GETOE^SDOE(ENC),ENCDT=+$P(X,U),DFN=+$P(X,U,2),DIV=$P(X,U,11)
 ;
 ; - Tort Liable Charge (prior to 09/01/99)
 I ENCDT<2990901 D  G QAMT
 . S AMOUNT=+$$BICOST^IBCRCI(RIMB,3,ENCDT,"OUTPATIENT VISIT DATE")
 ;
 D GETCPT^SDOE(ENC,"CPTLST") S VCPT=0
 F  S VCPT=$O(CPTLST(VCPT)) Q:VCPT=""  D
 .S CPT=+CPTLST(VCPT)
 .S AMOUNT=AMOUNT+$$BICOST^IBCRCI(RIMB,3,ENCDT,"PROCEDURE",CPT,"",DIV,"")
 ;
 ; - Subtract the amount billed for this Episode
 S AMOUNT=AMOUNT-$$CLAMT(DFN,EPDT,0)
 G QAMT
 ;
AMT3 ; Prosthetic Charges
 S DIC="^RMPR(660,",DA=PRST,DR="14",DIQ="TTCST" D EN^DIQ1
 S AMOUNT=+$G(TTCST(660,DA,14))
 G QAMT
 ;
AMT4 ; - Prescription Charges 
 ; - Tort Liable Charge & Reasonable Charge (same source)
 S AMOUNT=+$$BICOST^IBCRCI(RIMB,3,EPDT,"PRESCRIPTION FILL")
 ;
QAMT I AMOUNT<0 S AMOUNT=0
 Q AMOUNT
 ;
CLAMT(DFN,EPDT,PT) ; Returns the Total Amount of Claims for Patient/Episode
 ;
 ; Input:  DFN - Pointer to the Patient File #2
 ;        EPDT - Episode Date
 ;          PT - 0=Outpatient, 1=Inpatient
 ;
 N CLAMT,CLM,DAY,IBD,X
 S CLAMT=0,DAY=EPDT-1,CLM=""
 F  S CLM=$O(^DGCR(399,"C",DFN,CLM)) Q:'CLM  D
 .S X=$G(^DGCR(399,CLM,0))
 .I $P($P(X,U,3),".")=$P(EPDT,".") D
 ..S IBD=$$CKBIL^IBTUBOU(CLM,PT) Q:IBD=""
 ..I '$P(IBD,U,3) Q  ; Not authorized
 ..S CLAMT=CLAMT+$G(^DGCR(399,CLM,"U1"))
 ;
QCLAMT Q CLAMT
 ;
AVG(EPDT) ; Returns the Average Amount of Inpatient Professional per
 ;         Number of Episodes for the previous 12 months
 N AVG,M,Z
 S AVG=0,M=EPDT\100*100
 I '$D(^IBE(356.19,M,1)) S M=$O(^IBE(356.19,M),-1) I 'M G QAVG
 S Z=$G(^IBE(356.19,M,1)) I $P(Z,U,12) S AVG=$P(Z,U,11)/$P(Z,U,12)
QAVG Q $J(AVG,0,2)
 ;
PRVSPC(EPS,CLM) ; Return the Provider and the Specialty
 ;  Input: EPS - Episode(1 = Inpatient OR 2 = Outpatient)
 ;         CLM - Pointer to Claim Tracking File (#356)
 ; Output: Provider Code (Pointer to #200) ^ Provider Name ^
 ;         Specialty Code (Pointer to #40.7 or #45.7) ^ Specialty Name
 ;
 N ADM,DFN,ENC,PRI,PRS,PRV,PRVLST,SPC,STP,X,VAIN,VAINDT
 ;
 S X=$G(^IBT(356,CLM,0))
 S DFN=$P(X,U,2),ENC=$P(X,U,4),ADM=$P(X,U,5),PRS=$P(X,U,8)
 ;
 S (PRV,SPC)="^"
 I EPS=1,ADM D  G QPS  ; Inpatient
 .S X=$G(^DGPM(ADM,0)),VAINDT=$P(X,U)\1 I 'VAINDT Q
 .D INP^VADPT S PRV=$G(VAIN(11)),SPC=$G(VAIN(3))
 .S:PRV="" PRV="^" S:SPC="" SPC="^"
 ;
 I EPS=2,ENC D  G QPS  ; Outpatient
 .D GETPRV^SDOE(ENC,"PRVLST")
 .S (X,PRI)=""
 .F  S X=$O(PRVLST(X),-1) Q:X=""!PRI  D
 ..N IBX S PRV=+PRVLST(X)
 ..I $P(PRVLST(X),U,4)="P" S PRI=1 ; Primary provider
 ..I PRV S PRV=PRV_U_$P($G(^VA(200,+PRV,0)),U)
 ..S IBX=$$GETOE^SDOE(ENC),STP=$P(IBX,U,3)
 ..I STP'="" S SPC=STP_U_$P($G(^DIC(40.7,STP,0)),U)
 ;
QPS Q (PRV_U_SPC)
 ;
PHDL ; - Print the header line for the Excel spreadsheet
 N X
 S X="Division^Svc^Patient^SSN^Episode Dt^Dt Entered^Dt Lst Edit^"
 S X=X_"Lst Edited By^RNB Cat^Provider^Specialty^Entry Amt^Comments"
 W !,X
 Q
