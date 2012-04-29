IBCRHBS8        ;ALB/ARH - RATES: UPLOAD (RC 2+) CALCULATIONS CHARGE ; 10-OCT-03
        ;;2.0;INTEGRATED BILLING;**245,382**;21-MAR-94;Build 2
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
ISA(SITE,ITLINE)        ; Return Inpatient DRG Standard Ancillary Charge
        N IBCHG,IBZIP,IBAA,IBCTI,IBCTIAAP S IBCHG=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        I $P(ITLINE,U,2)'="DRG" G ISAQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G ISAQ
        S IBCTI=$P($G(ITLINE),U,4),IBCTIAAP=$S(IBCTI="S":3,IBCTI="N":5,1:0) I 'IBCTIAAP G ISAQ
        ;
        S IBCHG=$P(ITLINE,U,6)*$P(IBAA,U,IBCTIAAP) S IBCHG=$J(IBCHG,0,2)
        ;
ISAQ    Q IBCHG
        ;
ISR(SITE,ITLINE)        ; Return Inpatient DRG Standard Room & Board Charge
        N IBCHG,IBZIP,IBAA,IBCTI,IBCTIAAP S IBCHG=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        I $P(ITLINE,U,2)'="DRG" G ISRQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G ISRQ
        S IBCTI=$P($G(ITLINE),U,4),IBCTIAAP=$S(IBCTI="S":2,IBCTI="N":4,1:0) I 'IBCTIAAP G ISRQ
        ;
        S IBCHG=$P(ITLINE,U,5)*$P(IBAA,U,IBCTIAAP) S IBCHG=$J(IBCHG,0,2)
        ;
ISRQ    Q IBCHG
        ;
IIA(SITE,ITLINE)        ; Return Inpatient DRG ICU Ancillary Charge
        N IBCHG,IBZIP,IBAA,IBCTI,IBCTIAAP S IBCHG=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        I $P(ITLINE,U,2)'="DRG" G IIAQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G IIAQ
        S IBCTI=$P($G(ITLINE),U,4),IBCTIAAP=$S(IBCTI="S":3,IBCTI="N":5,1:0) I 'IBCTIAAP G IIAQ
        ;
        S IBCHG=$P(ITLINE,U,8)*$P(IBAA,U,IBCTIAAP) S IBCHG=$J(IBCHG,0,2)
        ;
IIAQ    Q IBCHG
        ;
IIR(SITE,ITLINE)        ; Return Inpatient DRG ICU Room & Board Charge
        N IBCHG,IBZIP,IBAA,IBCTI,IBCTIAAP S IBCHG=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        I $P(ITLINE,U,2)'="DRG" G IIRQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G IIRQ
        S IBCTI=$P($G(ITLINE),U,4),IBCTIAAP=$S(IBCTI="S":2,IBCTI="N":4,1:0) I 'IBCTIAAP G IIRQ
        ;
        S IBCHG=$P(ITLINE,U,7)*$P(IBAA,U,IBCTIAAP) S IBCHG=$J(IBCHG,0,2)
        ;
IIRQ    Q IBCHG
        ;
ISNF(SITE,ITLINE)       ; Return Inpatient Skilled Nursing Facility Per Diem
        N IBCHG,IBZIP,IBAA S IBCHG=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        I $P(ITLINE,U,2)'="SNF" G ISNFQ
        I $P(ITLINE,U,1)'="999",$P(ITLINE,U,1)'="000" G ISNFQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G ISNFQ
        ;
        S IBCHG=$P(ITLINE,U,5)*$P(IBAA,U,6) S IBCHG=$J(IBCHG,0,2)
        ;
ISNFQ   Q IBCHG
        ;
        ;
FAC(SITE,ITLINE)        ; Return Facility Charge (Table B) for All Charge and Unit Types
        ; each line record contains 1 charge that may be calculated in multiple ways
        N IBCHG,IBUT S IBCHG=0,SITE=$G(SITE),ITLINE=$G(ITLINE)
        ;
        S IBUT=$P(ITLINE,U,10)
        ;
        I IBUT=1 S IBCHG=$$FSTD(SITE,ITLINE) G FACQ
        I IBUT=4 S IBCHG=$$FSTD(SITE,ITLINE) G FACQ
        I IBUT=2 S IBCHG=$$FHRS(SITE,ITLINE) G FACQ
        ;
FACQ    Q IBCHG
        ;
FSTD(SITE,ITLINE)       ; Return Facility Charge of Unit Type = 1 or 4 (Standard and Miles)
        N IBCHG,IBZIP,IBUT,IBAA,IBSCC,IBSCCAAP S IBCHG=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        S IBUT=$P(ITLINE,U,10) I IBUT'=1,IBUT'=4 G FSTDQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G FSTDQ
        S IBSCC=$$GETSCC($P(ITLINE,U,5)),IBSCCAAP=$P(IBSCC,U,4) I 'IBSCCAAP G FSTDQ
        ;
        S IBCHG=$P(ITLINE,U,8)*$P(IBAA,U,IBSCCAAP) S IBCHG=$J(IBCHG,0,2)
        ;
FSTDQ   Q IBCHG
        ;
FHRS(SITE,ITLINE)       ; Return Facility Charge of Unit Type = 2 (Hours)
        N IBCHG,IBCHGB,IBZIP,IBUT,IBAA,IBSCC,IBSCCAAP S (IBCHG,IBCHGB)=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        S IBUT=$P(ITLINE,U,10) I IBUT'=2 G FHRSQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G FHRSQ
        S IBSCC=$$GETSCC($P(ITLINE,U,5)),IBSCCAAP=$P(IBSCC,U,4) I 'IBSCCAAP G FHRSQ
        ;
        S IBCHG=$P(ITLINE,U,8)*$P(IBAA,U,IBSCCAAP) S IBCHG=$J(IBCHG,0,2)
        S IBCHGB=$P(ITLINE,U,9)*$P(IBAA,U,IBSCCAAP) S IBCHGB=$J(IBCHGB,0,2)
        ;
FHRSQ   Q IBCHG_U_IBCHGB
        ;
        ;
PROF(SITE,ITLINE)       ; Return Professional Charge (Table C) for All Charge and Unit Types
        ; each line record contains 1 charge that may be calculated in multiple ways
        N IBCHG,IBCT,IBUT S IBCHG=0,SITE=$G(SITE),ITLINE=$G(ITLINE)
        ;
        S IBCT=$P(ITLINE,U,8)
        S IBUT=$P(ITLINE,U,16)
        ;
        I IBUT=1,IBCT="RBRVS" S IBCHG=$$PRBRVS(SITE,ITLINE) G PROFQ
        I IBUT=1,IBCT="TotalUnits" S IBCHG=$$PTRVU(SITE,ITLINE) G PROFQ
        I IBUT=1,IBCT="NW" S IBCHG=$$PNW(SITE,ITLINE) G PROFQ
        I IBUT=3,IBCT="Anesth" S IBCHG=$$PANES(SITE,ITLINE) G PROFQ
        ;
PROFQ   Q IBCHG
        ;
PRBRVS(SITE,ITLINE)     ; Return Professional RBRVS Based Charge
        N IBCHG,IBZIP,IBCTI,IBUT,IBAA,IBSCC,IBSCCAAP,IBPEP,IBWE,IBPE,IBCF S IBCHG=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        S IBCTI=$P(ITLINE,U,8) I IBCTI'="RBRVS" G PRBRVSQ
        S IBUT=$P(ITLINE,U,16) I IBUT'=1 G PRBRVSQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G PRBRVSQ
        S IBSCC=$$GETSCC($P(ITLINE,U,6)) S IBSCCAAP=$P(IBSCC,U,4) I 'IBSCCAAP G PRBRVSQ
        ;
        S IBPEP=$S($P(SITE,U,5)=3:11,1:10) ; provider/non-provider site
        ;
        S IBWE=$P(ITLINE,U,9)*$P(IBAA,U,7)
        S IBPE=$P(ITLINE,U,IBPEP)*$P(IBAA,U,8)
        S IBCF=$P(IBSCC,U,3)*$P(IBAA,U,IBSCCAAP)
        ;
        S IBCHG=(IBWE+IBPE)*IBCF S IBCHG=$J(IBCHG,0,2)
        ;
PRBRVSQ Q IBCHG
        ;
        ;
PTRVU(SITE,ITLINE)      ; Return Professional Total RVU Charge
        N IBCHG,IBZIP,IBCTI,IBUT,IBAA,IBSCC,IBSCCAAP,IBUN,IBCF S IBCHG=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        S IBCTI=$P(ITLINE,U,8) I IBCTI'="TotalUnits" G PTRVUQ
        S IBUT=$P(ITLINE,U,16) I IBUT'=1 G PTRVUQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G PTRVUQ
        S IBSCC=$$GETSCC($P(ITLINE,U,6)) S IBSCCAAP=$P(IBSCC,U,4) I 'IBSCCAAP G PTRVUQ
        ;
        S IBUN=$P(ITLINE,U,12)*$P(IBAA,U,9)
        S IBCF=$P(IBSCC,U,3)*$P(IBAA,U,IBSCCAAP)
        ;
        S IBCHG=IBUN*IBCF S IBCHG=$J(IBCHG,0,2)
        ;
PTRVUQ  Q IBCHG
        ;
PNW(SITE,ITLINE)        ; Return Professional Nationwide Charge
        N IBCHG,IBZIP,IBCTI,IBUT,IBAA,IBSCC,IBSCCAAP S IBCHG=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        S IBCTI=$P(ITLINE,U,8) I IBCTI'="NW" G PNWQ
        S IBUT=$P(ITLINE,U,16) I IBUT'=1 G PNWQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G PNWQ
        S IBSCC=$$GETSCC($P(ITLINE,U,6)) S IBSCCAAP=$P(IBSCC,U,4) I 'IBSCCAAP G PNWQ
        ;
        S IBCHG=$P(ITLINE,U,14)*$P(IBAA,U,IBSCCAAP) S IBCHG=$J(IBCHG,0,2)
        ;
PNWQ    Q IBCHG
        ;
PANES(SITE,ITLINE)      ; Return Professional Anesthesia Charge
        N IBCHG,IBCHGB,IBZIP,IBCTI,IBUT,IBAA,IBSCC,IBSCCAAP,IBCF S (IBCHG,IBCHGB)=0,ITLINE=$G(ITLINE),IBZIP=$P($G(SITE),U,4)
        S IBCTI=$P(ITLINE,U,8) I IBCTI'="Anesth" G PANESQ
        S IBUT=$P(ITLINE,U,16) I IBUT'=3 G PANESQ
        ;
        S IBAA=$$GETAA(IBZIP) I $P(IBAA,U,1)'=IBZIP G PANESQ
        S IBSCC=$$GETSCC($P(ITLINE,U,6)) S IBSCCAAP=$P(IBSCC,U,4) I 'IBSCCAAP G PANESQ
        ;
        S IBCF=$P(IBSCC,U,3)*$P(IBAA,U,IBSCCAAP)
        ;
        S IBCHG=$P(ITLINE,U,14)*IBCF S IBCHG=$J(IBCHG,0,2)
        S IBCHGB=$P(ITLINE,U,13)*IBCF S IBCHGB=$J(IBCHGB,0,2)
        ;
PANESQ  Q IBCHG_U_IBCHGB
        ;
        ;
        ;
        ;
GETAA(ZIP)      ; return Area Factor entry for Zip from Table E
        N IBTMPAA,IBAALN,IBDIV,IBDIVLN S IBAALN="",IBTMPAA="IBCR RC E",IBDIV=""
        ;
        I $G(ZIP)?3N S IBDIV=$O(^XTMP(IBTMPAA,"A",ZIP,0))
        I +IBDIV S IBDIVLN=$G(^XTMP(IBTMPAA,IBDIV)) I $P(IBDIVLN,U,1)=ZIP S IBAALN=IBDIVLN
        ;
        Q IBAALN
        ;
GETSCC(SCC)     ; return Service Category Code entry from Table D
        N IBTMPSCC,IBSCC,IBSCCLN,IBLN S IBSCCLN="",IBTMPSCC="IBCR RC D",IBSCC=""
        ;
        I +$G(SCC) S IBSCC=$O(^XTMP(IBTMPSCC,"A",SCC,0))
        I +IBSCC S IBLN=$G(^XTMP(IBTMPSCC,IBSCC)) I $P(IBLN,U,1)=SCC S IBSCCLN=IBLN
        ;
        Q IBSCCLN
