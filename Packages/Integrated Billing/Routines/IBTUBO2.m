IBTUBO2 ;ALB/AAS - UNBILLED AMOUNTS - GENERATE UNBILLED REPORTS ;03 Aug 2004  8:21 AM
 ;;2.0;INTEGRATED BILLING;**19,31,32,91,123,159,192,155,309,347**;21-MAR-94;Build 24
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
INPT(DGPM) ; - Check if inpatient episode has bills or final bill; if not,
 ;   ^TMP($J,"IBTUB-INPT",NAME@@DFN,DATE,IBX)=bill status
 ;   ^TMP($J,"IBTUB-INPT_MRA",NAME@@DFN,DATE,IBX)=1 if MRA request
 ;   *Pre-set variables: DFN=patient IEN, DGPM=pointer to file #405,
 ;                       IBDT=event date, IBRT=bill rate,
 ;                       IBEDT=reporting period date
 I '$G(DFN)!('$G(DGPM))!('$G(IBDT))!('$G(IBRT)) G INPTQ
 N IBIP,IBDATA,IBNAME,IBNCF,IBXX,X,Y,IBMRA
 S IBNAME=$P($G(^DPT(DFN,0)),U)
 I $D(^TMP($J,"IBTUB-INPT",IBNAME_"@@"_DFN,IBDT)) G INPTQ
 I $P($G(^DGPM(DGPM,0)),U,11) G INPTQ ;      Admitted for SC condition.
 I $$SC^IBTUBOU($P($G(^DGPM(DGPM,0)),U,16)) G INPTQ ; Check PTF for SC.
 S (IBIP(1),IBIP(2))=0 ; Set claim flags.
 ;
 ; - Check patient's claims.
 S (IBNCF,X)=0
 F  S X=$O(^DGCR(399,"C",DFN,X)) Q:'X  D  Q:IBIP(1)&(IBIP(2))
 . S IBDATA=$$CKBIL^IBTUBOU(X,1) Q:IBDATA=""
 . ;
 . ; The admission date on the bill is different from the Event date.
 . I $P(IBDATA,U,5)'=$P(IBDT,".") Q
 . S IBNCF=IBNCF+1 ; Increment the number of bills on file for episode
 . ;
 . ; If Compile/Store & Not authorized before reporting period - Quit.
 . I $G(IBCOMP),$S($P(IBDATA,U,2)'=2:$P(IBDATA,U,3),1:$P(IBDATA,U,6))>IBEDT Q
 . ;
 . S IBIP($P(IBDATA,U,4))=$S($P(IBDATA,U,2)'=2:1,1:2) ;   Episode billed for inst/prof bill type
 ;
 I IBIP(1)=1 G:IBIP(2)=1!(IBDT<2990901) INPTQ ; Episode is billed.
 ;
 ; - Add to episodes missing inst./prof. bills.
 S (IBXX,IBMRA)=""
 ;
 I IBIP(1)'=1 D
 . I 'IBIP(1) S IBUNB("EPISM-I")=IBUNB("EPISM-I")+1 S:IBDET IBXX="I"
 . I $G(IBXTRACT) S IB(1)=IB(1)+1 ; For DM extract.
 . I IBIP(1)=2 S IBUNB("EPISM-I-MRA")=IBUNB("EPISM-I-MRA")+1 S:IBDET IBMRA="I"
 ;
 I IBIP(2)'=1,IBDT'<2990901 D
 . I 'IBIP(2) S IBUNB("EPISM-P")=IBUNB("EPISM-P")+1 S:IBDET IBXX=$S(IBXX="I":"I,P",1:"P")
 . I $G(IBXTRACT) S IB(3)=IB(3)+1 ; For DM extract.
 . I IBIP(2)=2 S IBUNB("EPISM-P-MRA")=IBUNB("EPISM-P-MRA")+1 S:IBDET IBMRA=$S(IBMRA="I":"I,P",1:"P")
 ;
 I $S('IBIP(1):1,'IBIP(2):1,1:0) S IBUNB("EPISM-A")=IBUNB("EPISM-A")+1  ; Number of Admissions missing claims
 S:IBIP(1)=2!(IBIP(2)=2) IBUNB("EPISM-A-MRA")=IBUNB("EPISM-A-MRA")+1
 I $G(IBXTRACT) S IB(5)=IB(5)+1 ; For DM extract.
 ;
 I '$G(IBINMRA),IBIP(1)=2 G:IBIP(2)=1 INPTQ
 I '$G(IBINMRA),IBIP(2)=2 G:IBIP(1)=1 INPTQ
 ;
 ; - Set global for report.
 I $S($G(IBINMRA):1,1:IBXX'="") S ^TMP($J,"IBTUB-INPT",IBNAME_"@@"_DFN,IBDT,IBX)=IBNCF_U_IBXX_U_U_U_$$HOSP^IBTUBOU(DGPM)
 I IBMRA'="",$G(IBINMRA) S ^TMP($J,"IBTUB-INPT_MRA",IBNAME_"@@"_DFN,IBDT,IBX)=1_U_IBMRA
 ;
INPTQ Q
 ;
RX(IBRX) ; - Check if prescription has been billed; if not,
 ;   ^TMP($J,"IBTUB-RX",NAME@@DFN,DATE@RX#,IBX)=bill status^drug name^
 ;                                            original fill date
 ;   ^TMP($J,"IBTUB-RX_MRA",NAME@@DFN,DATE@RX#,IBX)=1 if req MRA
 ;
 ;   *Pre-set variables: DFN=patient IEN, IBDT=refill date,
 ;                       IBRT=bill rate, IBRX=pointer to file #52,
 ;                       IBEDT=reporting period date
 I '$G(DFN)!('$G(IBDT))!('$G(IBRT))!('$G(IBRX)) G RXQ
 N IBDATA,IBDAY,IBDRX,IBFL,IBFLG,IBOFD,IBNAME,IBND,IBNO,IBNCF,RX,X,RXDT,IBMRA,IBCO
 ;
 ; - Be sure prescription has an RX#.
 S IBND=$$RXZERO^IBRXUTL(DFN,IBRX),IBNO=$P(IBND,U) G:IBNO="" RXQ
 ;
 ; - Retrieve the Prescription Original Fill Date
 S IBOFD=$$FILE^IBRXUTL(IBRX,22)\1
 ;
 S IBDAY=$E(IBDT,1,7),IBDRX=IBDAY_"@@"_IBNO,IBNAME=$P($G(^DPT(DFN,0)),U)
 ;
 ; - Be sure that this fill was not already marked as unbilled.
 I $D(^TMP($J,"IBTUB-RX",IBNAME_"@@"_DFN,IBDRX,IBX)) G RXQ
 ;
 ; - Look at all fills of the prescription that are on a claim.
 S (IBFL,X)="",(IBFLG,IBNCF,IBNCF(0),IBMRA)=0
 F  S X=$O(^IBA(362.4,"B",IBNO,X)) Q:'X  D  Q:IBFL
 . S RX=$G(^IBA(362.4,X,0)),RXDT=$P(RX,U,3)\1
 . I RXDT=IBOFD S IBFLG=1  ; Original Fill Date Billed?
 . I RXDT'=IBDAY Q  ; RX refill and claim refill dates not the same.
 . ;
 . ; - Skip bill if not authorized (and not meeting other criteria).
 . S IBDATA=$$CKBIL^IBTUBOU($P(RX,U,2)) Q:IBDATA=""
 . S IBNCF=IBNCF+1 ; Increment the number of bills on file for the episode
 . ; If Compile/Store & Not authorized before reporting period - Quit.
 . I $G(IBCOMP),$S($P(IBDATA,U,2)'=2:$P(IBDATA,U,3),1:$P(IBDATA,U,6))>IBEDT S IBNONMRA=0 Q
 . S:$P(IBDATA,U,2)'=2 IBFL=1,IBMRA=0 ; at least 1 non-MRA bill exists
 . S:$P(IBDATA,U,2)=2 IBMRA=1 ; at least 1 MRA bill exists
 . ;
 ;
 I IBFL G RXQ ; Refill has been billed.
 ;
RX1 ; - Calculate unbilled amounts.
 S:'IBMRA IBUNB("PRESCRP")=IBUNB("PRESCRP")+1
 I IBMRA S IBUNB("PRESCRP-MRA")=IBUNB("PRESCRP-MRA")+1
 S IBCO=$$BICOST^IBCRCI(IBRT,3,IBDAY,"PRESCRIPTION FILL")
 S:'IBMRA IBUNB("UNBILRX")=IBUNB("UNBILRX")+IBCO
 I IBMRA S IBUNB("UNBILRX-MRA")=IBUNB("UNBILRX-MRA")+IBCO
 I $G(IBXTRACT) D  ; For DM extract.
 . S IB(17)=IB(17)+1
 . S IB(18)=IB(18)+IBCO
 ;
 ; - Set global for report.
 D ZERO^IBRXUTL(+$P(IBND,U,6))
 I $S($G(IBINMRA):1,1:'IBMRA) S ^TMP($J,"IBTUB-RX",IBNAME_"@@"_DFN,IBDRX,IBX)=IBNCF_U_$P($G(^VA(200,+$P(IBND,U,4),0)),U)_U_$$FILE^IBRXUTL(IBRX,22)_U_U_IBFLG_U_$G(^TMP($J,"IBDRUG",+$P(IBND,U,6),.01))
 I IBMRA,$G(IBINMRA) S ^TMP($J,"IBTUB-RX_MRA",IBNAME_"@@"_DFN,IBDRX,IBX)=1
 K ^TMP($J,"IBDRUG")
 ;
RXQ Q
