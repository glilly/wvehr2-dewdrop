BPSRPT9A        ;BHAM ISC/BNT - ECME REPORTS UTILITIES ;19-SEPT-08
        ;;1.0;E CLAIMS MGMT ENGINE;**8**;01-JUN-04;Build 29
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; Use of COLLECT^IBOSRX supported by IA 5361
        ; Use of $$INSUR^IBBAPI supported by IA 4419
        ; Use of $$RNB^IBNCPDPI supported by IA 4729
        ;
        Q
        ;
        ; Collect the Potential Secondary Rx Claims Report data
GETSEC(BPDT,BPARR)      ;
        N CNT,IBARR S CNT=0
        N BPSX,BPSY
        N BPS56 S BPS56=0
        I '$D(ZTQUEUED),$E(IOST,1,2)="C-" W !!,"Collecting Potential Secondary data ..."
        K ^TMP("BPSRPT9A",$J)
        D COLLECT^IBOSRX($P(BPDT,U),$P(BPDT,U,2))   ; get IB claim data (DBIA 5361)
        D GATHER($P(BPDT,U,1),$P(BPDT,U,2))         ; get ECME claim data - esg 7/6/10
        I '$D(^TMP("BPSRPT9A",$J)) Q
        F  S CNT=$O(^TMP("BPSRPT9A",$J,CNT)) Q:CNT=""  D
        . N DATA,RXI,RXN,RXF,DOS,BILL,DFN,PATNAME,BPDIV,INSC,X,COB,PINS,BP59S,BP59P,IBIFN,TOTCHG,BAL,BPSRESP,BPSPAID
        . S DATA=$G(^TMP("BPSRPT9A",$J,CNT))
        . S RXI=$P(DATA,U,1),RXN=$P(DATA,U,2),RXF=$P(DATA,U,3),BILL=$P(DATA,U,4),DFN=$P(DATA,U,5),DOS=$P(DATA,U,6),PINS=$P(DATA,U,7)
        . S IBIFN=$P(DATA,U,8),TOTCHG=$P(DATA,U,9)
        . Q:(RXI="")!(RXN="")!(RXF="")!(BILL="")!(DFN="")!(DOS="")!(PINS="")
        . S PATNAME=$$GET1^DIQ(2,DFN,.01)
        . ;
        . ; Drop the claim off this report if the Secondary claim is closed in ECME
        . ; esg - 7/6/10
        . S BP59S=+$$IEN59^BPSOSRX(RXI,RXF,2)  ; possible ien to file 9002313.59 for the secondary claim
        . I $$CLOSED02^BPSSCR03(+$P($G(^BPST(BP59S,0)),U,4)) Q
        . ;
        . ; Drop the claim off this report if the Secondary claim is Payable
        . ; bnt - 7/14/10
        . S BP59P=+$$IEN59^BPSOSRX(RXI,RXF,1)  ; possible ien to file 9002313.59 for the primary claim
        . I $$PAYBLSEC^BPSUTIL2(BP59P) Q
        . ;
        . ; Drop the claim off this report if the primary payer paid the full amount
        . ; esg - 8/3/10
        . I IBIFN,TOTCHG D  I BAL'>0 Q    ; check balance due on entries with payable primary claims
        .. S BPSRESP=+$P($G(^BPST(BP59P,0)),U,5)  ; response file ien
        .. S BPSPAID=0
        .. I BPSRESP S BPSPAID=$$DFF2EXT^BPSECFM($P($G(^BPSR(BPSRESP,1000,1,500)),U,9))   ; paid amt
        .. S BAL=TOTCHG-BPSPAID    ; balance due:  total charges - primary payer paid amt
        .. Q
        . ;
        . S BPDIV=$$GETDIV^BPSOSQC(RXI,RXF) Q:'BPDIV  ;Outpatient Site #59 ien
        . S BPS56=+$O(^BPS(9002313.56,"C",BPDIV,0)) Q:'BPS56  ;BPS PHARMACIES #9002313.56 ien
        . ;filter divisions
        . I BPPHARM=1,'$D(BPPHARM(BPS56)) Q
        . S BPDIV(BPDIV)=$$DIVNAME^BPSSCRDS(BPS56)
        . ;
        . S PSRT=$S($P($P(BPSORT,U,1),":")="N":PATNAME,$P($P(BPSORT,U,1),":")="P":PINS,$P($P(BPSORT,U,1),":")="S":$S('BPCRON:-DOS,1:DOS),1:BPDIV(BPDIV))
        . S SSRT=$S($P($P(BPSORT,U,2),":")="N":PATNAME,$P($P(BPSORT,U,2),":")="P":PINS,$P($P(BPSORT,U,2),":")="S":$S('BPCRON:-DOS,1:DOS),$P($P(BPSORT,U,2),":")="D":BPDIV(BPDIV),1:0)
        . S TSRT=$S($P($P(BPSORT,U,3),":")="N":PATNAME,$P($P(BPSORT,U,3),":")="P":PINS,$P($P(BPSORT,U,3),":")="S":$S('BPCRON:-DOS,1:DOS),$P($P(BPSORT,U,3),":")="D":BPDIV(BPDIV),1:0)
        . Q:((SSRT="")!(PSRT="")!(TSRT=""))
        . S BPARR(PSRT,SSRT,TSRT,CNT)=BPDIV(BPDIV)_U_BILL_U_RXN_U_RXF_U_$$FMTE^XLFDT(DOS,"2D")_U_PATNAME_U_"p"_U_PINS_U_$$SSN4^BPSRPT6(DFN)
        . S (X,INSC)=0
        . F  S X=$O(^TMP("BPSRPT9A",$J,CNT,X)) Q:X=""  D
        . . S BPSX=$G(^TMP("BPSRPT9A",$J,CNT,X,7))
        . . S COB=$S($P(BPSX,U)=1:"p",$P(BPSX,U)=2:"s",$P(BPSX,U)=3:"t",1:"-")
        . . S BPSY=$P($G(^TMP("BPSRPT9A",$J,CNT,X,1)),U,2)
        . . Q:BPSY[PINS
        . . S BPARR(PSRT,SSRT,TSRT,CNT,X)=COB_U_BPSY
        K ^TMP("BPSRPT9A",$J)
        Q
        ;
        ; Collect the Potential Tricare Rx Claims Report data
        ; Build array with report data
        ; BPARR(n)=DIVISION NAME^RX#^FILL^FILL DATE^PATIENT NAME
        ; BPARR(n,"INS",1)=PRIMARY INS NAME^PRIMARY INS ADDRESS
        ; BPARR(n,"INS",2)=SECONDARY INS NAME^SECONDARY INS ADDRESS
        ; BPARR(n,"ELIG")=ELIG 1^ELIG 2^...
GETTRI(BPDT,BPARR)      ;
        N RXI,RXN,RXF,RXFDT,LIST,RXLIST,BPQUIT,CNT,BPSFLDN
        S REF=$NA(^TMP($J,"BPSRPT9","AD"))
        S BPSFLDN=".01;2;6"
        K @REF
        S (RXFDT,BPDRUG,CNT)=0,LIST="BPSRPT9"
        I '$D(ZTQUEUED),$E(IOST,1,2)="C-" W !!,"Collecting TRICARE data ..."
        D REF^PSO52EX($P(BPDT,U),$P(BPDT,U,2),LIST)
        I '$D(@REF) Q
        F  S RXFDT=$O(@REF@(RXFDT)) Q:RXFDT=""  D
        . S RXI=0 F  S RXI=$O(@REF@(RXFDT,RXI)) Q:RXI=""  D
        . . S RXF=-1 F  S RXF=$O(@REF@(RXFDT,RXI,RXF)) Q:RXF=""  D
        . . . N BPELIG,VAEL,BPDRUG,BPDEA,BPIE,DFN,ARR,BPDIV,PSRT,SSRT,TSRT,BPS56
        . . . S (BPQUIT,BPDIV,BPS56)=0
        . . . ; Check Pharmacy Division against selected Divisions
        . . . S BPDIV=$$GETDIV^BPSOSQC(RXI,RXF) Q:'BPDIV  ;Outpatient Site #59 ien
        . . . S BPS56=+$O(^BPS(9002313.56,"C",BPDIV,0)) Q:'BPS56  ;BPS PHARMACIES #9002313.56 ien
        . . . ;filter divisions
        . . . I BPPHARM=1,'$D(BPPHARM(BPS56)) Q
        . . . D RXAPI^BPSUTIL1(RXI,BPSFLDN,"ARR","IE")
        . . . S DFN=ARR(52,RXI,2,"I") Q:'DFN
        . . . D ELIG^VADPT
        . . . ; Check for TRICARE or SHARING AGREEMENT
        . . . S BPELIG=$P(VAEL(1),U,2)
        . . . S BPQUIT=$S(BPELIG="TRICARE":0,BPELIG="SHARING AGREEMENT":0,1:1)
        . . . S BPELIG(1)=$E(BPELIG,1,4)
        . . . S X=-1 F  S X=$O(VAEL(1,X)) Q:X=""  D
        . . . . S BPELIG=$P(VAEL(1,X),U,2)
        . . . . S BPQUIT=$S(BPELIG="TRICARE":0,BPELIG="SHARING AGREEMENT":0,1:1)
        . . . . S BPELIG(1)=BPELIG(1)_U_$E(BPELIG,1,4)
        . . . Q:$S(BPELIG(1)["TRIC":0,BPELIG(1)["SHAR":0,1:1)
        . . . S BPDRUG=ARR(52,RXI,6,"I") Q:'BPDRUG
        . . . K ^TMP($J,"BPDRUG") D DATA^PSS50(BPDRUG,,,,,"BPDRUG")
        . . . S BPDEA=^TMP($J,"BPDRUG",BPDRUG,3)
        . . . ; Exclude drugs that are exempt from billing
        . . . I (BPDEA["I")!(BPDEA["S")!(BPDEA["N")&(BPDEA'["E") Q
        . . . ;
        . . . ; exclude Rx if it is non-billable - esg 8/4/10
        . . . I +$$RNB^IBNCPDPI(RXI,RXF) Q
        . . . ;
        . . . ; exclude Rx if it is not released - esg 8/5/10
        . . . I '$$RELDATE^BPSBCKJ(RXI,RXF) Q
        . . . ;
        . . . ; Make sure not already ECME billed
        . . . Q:$$STATUS^BPSOSRX(RXI,RXF)'=""
        . . . ; Check for TRICARE type insurance group
        . . . N BPIBA,X,BPOK,BPINS,I
        . . . I '$$INSUR^IBBAPI(DFN,RXFDT,"P",.BPIBA,"*") Q
        . . . S (X,BPOK)=0 F I=1:1 S X=$O(BPIBA("IBBAPI","INSUR",X)) Q:X=""  D
        . . . . I $P(BPIBA("IBBAPI","INSUR",X,21),U,2)="TRICARE" S BPOK=1
        . . . . N BPCOB S BPCOB=$P(BPIBA("IBBAPI","INSUR",X,7),U) S:BPCOB="" BPCOB=1
        . . . . S BPINS(DFN,BPCOB)=$P(BPIBA("IBBAPI","INSUR",X,1),U,2)_U_BPIBA("IBBAPI","INSUR",X,2)
        . . . Q:'BPOK
        . . . ; Build the return array since all filters have passed
        . . . S CNT=CNT+1,BPDIV(BPDIV)=$$DIVNAME^BPSSCRDS(BPS56)
        . . . S PSRT=$S($P($P(BPSORT,U),":")="N":$E(ARR(52,RXI,2,"E"),1,20),$P($P(BPSORT,U),":")="P":$P($G(BPINS(DFN,+$O(BPINS(DFN,0)))),U),$P($P(BPSORT,U),":")="S":$S('BPCRON:-RXFDT,1:RXFDT),1:BPDIV(BPDIV))
        . . . S SSRT=$S($P($P(BPSORT,U,2),":")="N":$E(ARR(52,RXI,2,"E"),1,20),$P($P(BPSORT,U,2),":")="P":$P($G(BPINS(DFN,+$O(BPINS(DFN,0)))),U),$P($P(BPSORT,U,2),":")="S":$S('BPCRON:-RXFDT,1:RXFDT),$P($P(BPSORT,U,2),":")="D":BPDIV(BPDIV),1:0)
        . . . S TSRT=$S($P($P(BPSORT,U,3),":")="N":$E(ARR(52,RXI,2,"E"),1,20),$P($P(BPSORT,U,3),":")="P":$P($G(BPINS(DFN,+$O(BPINS(DFN,0)))),U),$P($P(BPSORT,U,3),":")="S":$S('BPCRON:-RXFDT,1:RXFDT),$P($P(BPSORT,U,3),":")="D":BPDIV(BPDIV),1:0)
        . . . Q:((SSRT="")!(PSRT="")!(TSRT=""))
        . . . S BPARR(PSRT,SSRT,TSRT,CNT)=BPDIV(BPDIV)_U_ARR(52,RXI,.01,"E")_U_RXF_U_$$FMTE^XLFDT(RXFDT,"2D")_U_$E(ARR(52,RXI,2,"E"),1,20)_U_$$SSN4^BPSRPT6(DFN)
        . . . I $D(BPINS(DFN,1)) S BPARR(PSRT,SSRT,TSRT,CNT,"INS",1)=BPINS(DFN,1)
        . . . I $D(BPINS(DFN,2)) S BPARR(PSRT,SSRT,TSRT,CNT,"INS",2)=BPINS(DFN,2)
        . . . S BPARR(PSRT,SSRT,TSRT,CNT,"ELIG")=BPELIG(1)
        K @REF,REF
        I $D(BPARR) S BPARR(0)=CNT
        Q
        ;
GATHER(SDT,EDT) ; Gather cases where we have closed ECME primary claims and available secondary insurance
        ; Input: SDT - FileMan start date
        ;        EDT - FileMan end date
        ;
        N SDTYMD,EDTYMD,BPDOS,BP02,BP59,BPST0,BPST1,DFN,BPDTFD,RXIEN,RXFIL,IBINS,IBRET,BPRX,BPSPINS,CNT
        S SDTYMD=$$FM2YMD^BPSSCR04(SDT) I 'SDTYMD S SDTYMD=0          ; start date in YMD format
        S EDTYMD=$$FM2YMD^BPSSCR04(EDT) I 'EDTYMD S EDTYMD=99999999   ; end date in YMD format
        S BPDOS=$O(^BPSC("AF",SDTYMD),-1) F  S BPDOS=$O(^BPSC("AF",BPDOS)) Q:'BPDOS!(BPDOS>EDTYMD)  D
        . S BP02=0 F  S BP02=$O(^BPSC("AF",BPDOS,BP02)) Q:'BP02  D
        .. S BP59=+$O(^BPST("AE",BP02,0)) Q:'BP59
        .. S BPST0=$G(^BPST(BP59,0))
        .. S BPST1=$G(^BPST(BP59,1))
        .. I $P(BPST0,U,14)'=1 Q               ; looking for primary claims
        .. I '$$CLOSED02^BPSSCR03(BP02) Q      ; looking for closed claims
        .. S DFN=+$P(BPST0,U,6)
        .. S BPDTFD=$$YMD2FM^BPSSCR04(BPDOS)   ; FM date of service
        .. ;
        .. ; make sure the Rx is released
        .. S RXIEN=+$P(BPST1,U,11)
        .. S RXFIL=+$P(BPST1,U,1)
        .. I '$$RELDATE^BPSBCKJ(RXIEN,RXFIL) Q
        .. ;
        .. ; check insurances for this patient on this date
        .. K IBINS
        .. S IBRET=$$INSUR^IBBAPI(DFN,BPDTFD,"P",.IBINS,"1,2,7")
        .. I '$D(IBINS("IBBAPI","INSUR",2)) Q   ; do not have at least 2 Rx policies so get out
        .. ;
        .. ; save this entry in the scratch global
        .. S BPRX=$$RXAPI1^BPSUTIL1(RXIEN,.01,"I")    ; ext Rx#
        .. S BPSPINS=$$INSNAME^BPSSCRU6(BP59)         ; ins co name
        .. S CNT=$O(^TMP("BPSRPT9A",$J,""),-1)+1
        .. S ^TMP("BPSRPT9A",$J,CNT)=RXIEN_U_BPRX_U_RXFIL_U_"(P) Rej"_U_DFN_U_BPDTFD_U_BPSPINS_U_0_U_0
        .. M ^TMP("BPSRPT9A",$J,CNT)=IBINS("IBBAPI","INSUR")
        .. Q
        . Q
GATHERX ;
        Q
        ;
