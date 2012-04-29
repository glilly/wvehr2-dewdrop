PSOCP1  ;BHAM ISC/EJW-PHARMACY CO-PAY APPLICATION UTILITIES FOR IB (CONT'D) ;12/12/02
        ;;7.0;OUTPATIENT PHARMACY;**137,239,225**;DEC 1997;Build 29
        ;
        ;REF/IA
        ;IBARX/125
CHKIB   ; SEE IF BILL # IS A CHARGE OR CANCELLATION #
        N IBN,XX
        I PSOREF=0 S XX=$G(^PSRX(RXP,"IB")) I $P(XX,"^",4)'="" S PSOIB=1 Q  ;ALREADY BILLED
        I PSOREF=0 S IBN=$P(XX,"^",2)
        I PSOREF'=0 S XX=$G(^PSRX(RXP,1,PSOREF,"IB")) I $P(XX,"^",2)'="" S PSOIB=1 Q  ;ALREADY BILLED
        I PSOREF'=0 S IBN=$P(XX,"^",1)
        I IBN'="" D STATUS
        Q
        ;
STATUS  ;
        N XX
        S XX=$$STATUS^IBARX(IBN)
        I XX'=1,XX'=3 Q
        S PSOIB=1 ; ALREADY BILLED
        Q
        ;
XTYPE1  ;
        N PSOCIBQ,PSOSCMX,Y,I,J,X,SAVY
        S (X,PSOSCMX,SAVY)=""
        S PSOCIBQ=$G(^PSRX(RXP,"IBQ"))
        I $P(PSOCIBQ,"^",1)'=1 Q
        S J=0 F  S J=$O(^PS(59,J)) Q:'J  I +$G(^(J,"IB")) S X=+^("IB") Q
        I 'X Q
        S X=X_"^"_PSOCPN D XTYPE^IBARX
        I $G(Y)'=1 Q
        S J="" F  S J=$O(Y(J)) Q:'J  S I="" F  S SAVY=I,I=$O(Y(J,I)) Q:I=""  S:I>0 PSOSCMX=I
        I PSOSCMX="",SAVY=0 Q  ; INCOME EXEMPT OR SERVICE-CONNECTED
        I PSOSCMX=2 Q  ; NEED TO ASK SC QUESTION
        ; If get to here, service-connected question does not apply for this patient anymore.  Update "IBQ" and CPRS
        S $P(^PSRX(RXP,"IBQ"),"^",1)="",CHKXTYPE=1
        D EN^PSOHLSN1(RXP,"XX","","Order edited")
        Q
        ;
SETCOMM ;
        I EXMT="SC" S PSOCOMM="Service Connected" Q
        I EXMT="CV" S PSOCOMM="COMBAT VETERAN" Q
        I EXMT="AO" S PSOCOMM="AGENT ORANGE RELATED" Q
        I EXMT="IR" S PSOCOMM="IONIZING RAD RELATED" Q
        I EXMT="EC" S PSOCOMM="SW ASIA COND. RELATED" Q
        I EXMT="SHAD" S PSOCOMM="PROJ 112/SHAD" Q
        I EXMT="MST" S PSOCOMM="MILITARY SEXUAL TRAUMA" Q
        I EXMT="HNC" S PSOCOMM="Head and/or Neck Cancer" Q
        Q
        ;
ICD     ;
        S PSOCIBQ=$P(ZXX,U,4)_"^"_$P(ZXX,U,6)_"^"_$P(ZXX,U,2)_"^"_$P(ZXX,U,3)_"^"_$P(ZXX,U,5)_"^"_$P(ZXX,U,7)_"^"_$P(ZXX,U,8)_"^"_$P(ZXX,U,9)
        Q
        ;
