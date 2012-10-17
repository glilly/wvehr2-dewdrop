PSBOVT  ;BIRMINGHAM/BSR - CUMULATIVE VITALS REPORT ;5/28/10 1:49pm
        ;;3.0;BAR CODE MED ADMIN;**42**;Mar 2004;Build 23
        ; Reference/IA
        ; EN3^GMRVSC0/1444
        ;
EN      ; Print Cumulative Vitals Report
        ;
        N PSBGBL,DFN
        S PSBGBL="^TMP(""PSBO"",$J,""B"")"
        S PSBGBL=$Q(@PSBGBL) Q:PSBGBL=""  Q:$QS(PSBGBL,1)'="PSBO"!($QS(PSBGBL,2)'=$J)
        S DFN=$QS(PSBGBL,5)
        D PRNT(DFN,$P(PSBRPT(.1),U,6)_$P(PSBRPT(.1),U,7),$P(PSBRPT(.1),U,8)_$P(PSBRPT(.1),U,9))
        Q
        ;
PRNT(DFN,PSBVSDT,PSBVFDT)                   ; PATIENT CUMULATIVE VITALS REPORT
        ; INPUT VARIABLES:    DFN=PATIENT NUMBER
        ;
        S FLGD=""
        S PSBINS=$P(PSBVSDT,".")
        S PSBINSA=$P(PSBVFDT,".")
        D DATEADD
        I IOST="P-DUMMY"  D PSBIOCH
        ;
        ;IHS/MSC/PLS - Call Vitals lookup based on agency code
        ;  and PCC Vitals package usage flag "BEHOVM USE VMSR"=1
        I $G(DUZ("AG"))="I",$$GET^XPAR("ALL","BEHOVM USE VMSR") D
        .D CRPT^APCDMSR1(DFN,PSBINS,PSBINSA)
        E  D
        .D EN3^GMRVSC0(DFN,PSBINS,PSBINSA)
        Q
        ;
DATEADD ;
        S X=PSBINSA
        D H^%DTC
        S %H=%H+1
        D YMD^%DTC
        S PSBINSA=X
        Q
        ;
PSBIOCH ;
        S IOF="#"
        S IOSL="66"
        Q
        ;
        ;
