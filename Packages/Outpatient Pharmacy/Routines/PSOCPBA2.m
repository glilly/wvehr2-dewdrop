PSOCPBA2        ;BIR/EJW-PHARMACY CO-PAY APPLICATION UTILITIES FOR IB ;03/29/03
        ;;7.0;OUTPATIENT PHARMACY;**137,303**;DEC 1997;Build 19
        ;
        ;External reference to ^PSDRUG supported by DBIA 221
        ;External reference to ^IBAM(354.7 supported by DBIA 3877
TALLY   ;
        ; IF NO IB NUMBER FOR THIS FILL, SET UP VARIABLES AND TALLY
        S PSODFN="" F  S PSODFN=$O(^XTMP("PSOCPBAK",$J,PSODFN)) Q:'PSODFN  D
        .I $G(^XTMP("PSOCPBAK",$J,PSODFN)) Q  ; EXEMPT OR SC QUESTION APPLIES
        .S (PSOCAP(302),PSOCAP(303))=0 ; INITIAL ANNUAL CAP FLAG FOR PATIENT FOR 2002 AND 2003
        .S RXP="" F  S RXP=$O(^XTMP("PSOCPBAK",$J,PSODFN,RXP)) Q:'RXP  S YY=""  F  S YY=$O(^XTMP("PSOCPBAK",$J,PSODFN,RXP,YY)) Q:YY=""  D
        ..S PSOREL=$G(^XTMP("PSOCPBAK",$J,PSODFN,RXP,YY))
        ..I PSOCAP($E(PSOREL,1,3)) Q  ; MET ANNUAL CAP FOR 2002 OR 2003
        ..I 'YY D  Q
        ...I $P($G(^PSRX(RXP,"IB")),"^",2)'="" Q  ; ALREADY BILLED
        ...D SITE
        ...D CP
        ..I $P($G(^PSRX(RXP,1,YY,"IB")),"^",1)="" D  ; REFILL LEVEL
        ...D SITE
        ...D CP
        Q
        ;
CP      ; Entry point to Check if COPAY  -   Requires RXP,PSOSITE7
        I '$D(PSOPAR) D ^PSOLSET G CP
        K PSOCP
        S PSOCPN=$P(^PSRX(RXP,0),"^",2) ; Set COPAY dfn PTR TO PATIENT
        S PSOCP=$P($G(^PSRX(RXP,"IB")),"^") ; IB action type
        S PSOSAVE=$S(PSOCP:1,1:"") ; save current copay status
        ;         Set x=service^dfn^actiontype^user duz
        I +$G(PSOSITE7)'>0 S PSOSITE7=$P(^PS(59,PSOSITE,"IB"),"^")
        S X=PSOSITE7_"^"_PSOCPN_"^"_PSOCP_"^"_$P(^PSRX(RXP,0),"^",16)
        ;
RX      ;         Determine Original or Refill for RX
        N PSOIB
        S PSOIB=0
        S PSOREF=0
        I $G(^PSRX(RXP,1,+$G(YY),0))]"" S PSOREF=YY
        ;         Check if bill # already exists for this RX or Refill
        I 'PSOREF,+$P($G(^PSRX(RXP,"IB")),"^",2)>0 D CHKIB^PSOCP1 I PSOIB G QUIT
        I 'PSOREF,+$P($G(^PSRX(RXP,"IB")),"^",4)>0 G QUIT ; 'POTENTIAL BILL' - ALREADY ATTEMPTED TO BILL, BUT EXCEEDED ANNUAL COPAY CAP
        I PSOREF,+$G(^PSRX(RXP,1,PSOREF,"IB")) D CHKIB^PSOCP1 I PSOIB G QUIT
        I PSOREF,+$P($G(^PSRX(RXP,1,PSOREF,"IB")),"^",2) G QUIT ; POTENTIAL BILL
        S PSOCHG=1 ; set temporary variable to copay and then look for exceptions
        D COPAYREL
        I 'PSOCHG G QUIT ; NOT BILLABLE
        I PSOCHG=2 I 'PSOCP G QUIT
        ;         Units for COPAY
        S PSOCPUN=$P(($P(^PSRX(RXP,0),"^",8)+29)/30,".",1) ; NUMBER OF 30-DAY UNITS ELIGIBLE TO BILL
        D ACCUM
QUIT    ;
        K Y,PSOCP1,PSOCP2,QQ,PSOCPN,X,PSOCPUN,PSOREF,PSOCHG,PSOSAVE,PREA,PSORSN
        Q
        ;
COPAYREL        ; Recheck copay status at release
        ;
        ; check Rx patient status
        I $P(^PSRX(RXP,0),"^",3)'="",$P($G(^PS(53,$P(^PSRX(RXP,0),"^",3),0)),"^",7)=1 S PSOCHG=0 Q
        ; see if drug is nutritional supplement, investigational or supply
        N DRG,DRGTYP
        S DRG=+$P(^PSRX(RXP,0),"^",6),DRGTYP=$P($G(^PSDRUG(DRG,0)),"^",3)
        I DRGTYP["I"!(DRGTYP["S")!(DRGTYP["N") S PSOCHG=0 Q
        K PSOTG,CHKXTYPE
        I +$G(^PSRX(RXP,"IBQ")) D XTYPE1^PSOCP1
        I $G(^PSRX(RXP,"IBQ"))["1" S PSOCHG=0 Q
        Q
        ;
ACCUM   ; ACCUMULATE TOTALS AND SEE IF PATIENT MET ANNUAL CAP
        S PSOYR=$E(PSOREL,1,3) I PSOYR="" Q
        S PSOYEAR=$S(PSOYR="302":"YR2002",PSOYR="303":"YR2003",1:"") I PSOYEAR="" Q
        S PSOTOT=$G(^XTMP("PSOCPBAK",$J,PSODFN,PSOYEAR))
        I 'PSOTOT D
        .S PSOSQ="" F  S PSOSQ=$O(^IBAM(354.7,PSODFN,1,PSOSQ)) Q:'PSOSQ  S PSOLOG=$G(^IBAM(354.7,PSODFN,1,PSOSQ,0)) I $E(PSOLOG,1,3)=PSOYR D
        ..S PSOTOT=PSOTOT+$P(PSOLOG,"^",2)
        I PSOTOT+(7*PSOCPUN)>840 S PSOCAP(PSOYR)=1 Q  ; BILLING FOR THIS WOULD EXCEED ANNUAL CAP
        S ^XTMP("PSOCPBAK",$J,PSODFN,PSOYEAR)=PSOTOT+(PSOCPUN*7)
        S ^XTMP("PSOCPBAK",$J,PSODFN,PSOYEAR,PSOCPUN)=$G(^XTMP("PSOCPBAK",$J,PSODFN,PSOYEAR,PSOCPUN))+1
        Q
        ;
SITE    ; SET UP VARIABLES NEEDED BY BILLING
        S PSOSITE=$S(YY=0:$P(^PSRX(RXP,2),"^",9),1:$P($G(^PSRX(RXP,1,YY,0)),"^",9))
        I PSOSITE="" Q
        S PSOPAR=$G(^PS(59,PSOSITE,1))
        S PSOSITE7=$P($G(^PS(59,PSOSITE,"IB")),"^")
        Q
