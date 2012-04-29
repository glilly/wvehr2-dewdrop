PSOHLSN2        ;BIR/LE - Utilities for PSOHLSN1 ;02/27/04
        ;;7.0;OUTPATIENT PHARMACY;**143,226,239,225**;DEC 1997;Build 29
        ;
DG1     ;this section builds both DG1 segments
        Q:'$D(^PSRX(PSRXIEN,"ICD",1,0))
        N LP,DG,DXDESC,I
        S LIMIT=4,FIELD(0)="DG1",FIELD(4)=""
        ;I '$D(^PSRX(PSRXIEN,"ICD",1,0)) S FIELD(1)=1,FIELD(2)="",FIELD(3)="^^^^^" D SEG^PSOHLSN1 Q
        I $P(^PSRX(PSRXIEN,"ICD",1,0),"^",1)="" Q  ;S FIELD(1)=1,FIELD(2)="",FIELD(3)="^^^^^" D SEG^PSOHLSN1 Q
        F I=1:1:8 D
        . Q:'$D(^PSRX(PSRXIEN,"ICD",I,0))
        . S PSOICD="",PSOICD=^PSRX(PSRXIEN,"ICD",I,0) Q:$P(PSOICD,U,1)=""
        . S (DG,DXDESC)=""
        . I $P(PSOICD,U,1)'="" D
        .. S DXDESC=$$GET1^DIQ(80,$P(PSOICD,U,1)_",",10),FIELD(1)=I,FIELD(2)=""
        .. S FIELD(3)=$P(PSOICD,U,1)_U_DXDESC_U_"80"_U_$$GET1^DIQ(80,$P(PSOICD,U,1)_",",.01)_U_DXDESC_U_"ICD9"
        .. D SEG^PSOHLSN1
        K PSOICD("K")
        Q
ZCL     N STOP,IBQ,ICD,I,JJJ,EI
        S LIMIT=3,FIELD(0)="ZCL"
        I '$D(^PSRX(PSRXIEN,"ICD"))&($D(^PSRX(PSRXIEN,"IBQ"))) D    ;For edits; currently CPRS doesn't update SC/EI for edits, but just in case they start
        . S FIELD(1)=1,FIELD(2)=3
        . S EI="",EI=^PSRX(PSRXIEN,"IBQ")
        . S JJJ=0 F I=3,4,1,5,2,6,7,8 S JJJ=JJJ+1,FIELD(3)=$P(EI,U,I) S FIELD(1)=1,FIELD(2)=JJJ D SEG^PSOHLSN1
        E  F I=1:1:8 D
        . Q:'$D(^PSRX(PSRXIEN,"ICD",I,0))
        . S PSOICD=^PSRX(PSRXIEN,"ICD",I,0),ICD=$P(PSOICD,"^",1)
        . Q:ICD=""&(I>1)
        . F JJJ=2:1:9 S EI=$P(PSOICD,U,JJJ),FIELD(2)=JJJ-1 D
        .. S FIELD(1)=$S(ICD="":1,1:I)
        .. ;S FIELD(3)=$S(EI=1:EI,1:0)
        .. S FIELD(3)=$S(EI=1:EI,EI=0:EI,1:"")
        .. D SEG^PSOHLSN1
        K PSOICD
        Q
        ;CPRS doesn't look at the ZCL segment when their CIDC switch is off.  Always send both ZCL and ZSC for consistency
ZSC     S PSOCPS=$$DT^PSOMLLDT S LIMIT=$S($G(PSOCPS):8,1:1) X NULLFLDS
        S FIELD(0)="ZSC" N JJJ,PSOICD
        I '$D(^PSRX(PSRXIEN,"ICD",1,0)) D
        . I '$G(PSOCPS) S FIELD(1)=$S($P($G(^PSRX(PSRXIEN,"IB")),"^"):"NSC",1:"SC")
        . I $G(PSOCPS) D
        .. S FIELD(1)=$P($G(^PSRX(PSRXIEN,"IBQ")),"^")
        .. F JJJ=2:1:8 S FIELD(JJJ)=$P($G(^PSRX(PSRXIEN,"IBQ")),"^",JJJ)
        .D SEG^PSOHLSN1
        I $D(^PSRX(PSRXIEN,"ICD",1,0)) D
        . S PSOICD=$G(^PSRX(PSRXIEN,"ICD",1,0))
        . F JJJ=2:1:9 D
        .. I JJJ=2 S FIELD(3)=$P(PSOICD,"^",JJJ)  ;AO
        .. I JJJ=3 S FIELD(4)=$P(PSOICD,"^",JJJ)  ;IR
        .. I JJJ=4 S FIELD(1)=$P(PSOICD,"^",JJJ)  ;SC
        .. I JJJ=5 S FIELD(5)=$P(PSOICD,"^",JJJ)  ;EC
        .. I JJJ=6 S FIELD(2)=$P(PSOICD,"^",JJJ)  ;MST
        .. I JJJ=7 S FIELD(6)=$P(PSOICD,"^",JJJ)  ;HNC
        .. I JJJ=8 S FIELD(7)=$P(PSOICD,"^",JJJ)  ;CV
        .. I JJJ=9 S FIELD(8)=$P(PSOICD,"^",JJJ)  ;SHAD
        . D SEG^PSOHLSN1
        Q
