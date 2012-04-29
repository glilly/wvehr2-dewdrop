PSOBPSU2        ;BIRM/MFR - BPS (ECME) Utilities 2 ;10/15/04
        ;;7.0;OUTPATIENT PHARMACY;**260,287**;DEC 1997;Build 77
        ;Reference to File 200 - NEW PERSON supported by IA 10060
        ;
MWC(RX,RFL)     ; Returns wheter a prescription is (M)ail, (W)indow or (C)MOP
        ;Input: (r) RX   - Rx IEN (#52)
        ;       (o) RFL  - Refill #  (Default: most recent)
        ;Output: "M": MAIL / "W": WINDOW / "C": CMOP
        ;
        N MWC
        ;
        I '$D(RFL) S RFL=$$LSTRFL^PSOBPSU1(RX)
        ;
        ; - MAIL/WINDOW fields (Original and Refill)
        I RFL S MWC=$$GET1^DIQ(52.1,RFL_","_RX,2,"I")
        E  S MWC=$$GET1^DIQ(52,RX,11,"I")
        S:MWC="" MWC="W"
        ;
        ; - Checking the RX SUSPENSE file (#52.5)
        I $$GET1^DIQ(52,RX,100,"I")=5 D
        . N RXS S RXS=+$O(^PS(52.5,"B",RX,0)) Q:'RXS
        . I $$GET1^DIQ(52.5,RXS,3,"I")'="" S MWC="C" Q
        . S MWC="M"
        ;
        ; - Checking the CMOP EVENT sub-file (#52.01)
        I MWC'="C" D
        . N CMP S CMP=0
        . F  S CMP=$O(^PSRX(RX,4,CMP)) Q:'CMP  D  I MWC="C" Q
        . . I $$GET1^DIQ(52.01,CMP_","_RX,2,"I")=RFL S MWC="C"
        ;
        Q MWC
        ;
RXACT(RX,RFL,COMM,TYPE,USR)     ; - Add an Activity to the ECME Activity Log (PRESCRIPTION file)
        ;Input: (r) RX   - Rx IEN (#52)
        ;       (o) RFL  - Refill #  (Default: most recent)
        ;       (r) COMM - Comments (up to 75 characters)
        ;       (r) TYPE - Comments type: (M-ECME,E-Edit, etc...) See file #52 DD for all values
        ;       (o) USR  - User logging the comments (Default: DUZ)
        ;
        S:'$D(RFL) RFL=$$LSTRFL^PSOBPSU1(RX) S:'$D(USR) USR=DUZ
        S:'$D(^VA(200,+USR,0)) USR=DUZ S COMM=$E($G(COMM),1,75)
        ;
        I COMM="" Q
        I '$D(^PSRX(RX)) Q
        ;
        N PSOTRIC S PSOTRIC="",PSOTRIC=$$TRIC^PSOREJP1(RX,RFL,PSOTRIC)
        I $E(COMM,1,7)'="TRICARE",PSOTRIC S COMM=$E("TRICARE-"_COMM,1,75)
        N X,DIC,DA,DD,DO,DR,DINUM,Y,DLAYGO
        S DA(1)=RX,DIC="^PSRX("_RX_",""A"",",DLAYGO=52.3,DIC(0)="L"
        S DIC("DR")=".02///"_TYPE_";.03////"_USR_";.04///"_$S(TYPE'="M"&(RFL>5):RFL+1,1:RFL)_";.05///"_COMM
        S X=$$NOW^XLFDT() D FILE^DICN
        Q
        ;
ECMENUM(RX)     ; Returns the ECME number for a specific prescription
        N ECMENUM,STS,RF
        S ECMENUM=$E(10000000+RX,2,8)
        S STS=$$STATUS^PSOBPSUT(RX,0)
        I STS="" D
        . S RF=0 F  S RF=$O(^PSRX(RX,RF)) Q:'RF  D  I STS'="" Q
        . . S STS=$$STATUS^PSOBPSUT(RX,RF)
        I STS="" Q ""
        Q ECMENUM
        ;
RXNUM(ECME)     ; Returns the Rx number for a specific ECME number
        ;
        N RXNUM,FOUND,MAX,LFT,RAD,I,DIR,RX
        S MAX=$O(^PSRX(999999999999),-1),LFT=0 I $L(MAX)>7 S LFT=$E(MAX,1,$L(MAX)-7)
        S FOUND=0
        F RAD=LFT:-1:0 D
        . S RX=RAD*10000000+ECME I $D(^PSRX(RX,0)),$$ECMENUM(RX)=ECME S FOUND=FOUND+1,FOUND(FOUND)=RX
        ;
        I FOUND<2 D
        . I FOUND=0 S FOUND=-1 Q
        . S FOUND=FOUND(1)
        E  D
        . W ! F I=1:1:FOUND W !?5,I,". ",$$GET1^DIQ(52,FOUND(I),.01),?25,$$GET1^DIQ(52,FOUND(I),6)
        . W ! S DIR(0)="NA^1:"_FOUND,DIR("A")="Select one: ",DIR("B")=1
        . D ^DIR I $D(DIRUT) S FOUND=-1 Q
        . S FOUND=FOUND(Y)
        ;
        Q FOUND
        ;
ELIG(RX,RFL,PSOELIG)    ;Stores eligibility flag
        N DA,DIE,X,Y,PSOTRIC
        I RFL=0 S DA=RX,DIE="^PSRX(",DR="85///"_PSOELIG D ^DIE
        E  S DA=RFL,DA(1)=RX,DIE="^PSRX("_DA(1)_",1,",DR="85///"_PSOELIG D ^DIE
        Q
        ;
