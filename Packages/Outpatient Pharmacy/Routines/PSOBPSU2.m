PSOBPSU2        ;BIRM/MFR - BPS (ECME) Utilities 2 ;10/15/04
        ;;7.0;OUTPATIENT PHARMACY;**260,287,289**;DEC 1997;Build 107
        ;Reference to File 200 - NEW PERSON supported by IA 10060
        ;Reference to DUR1^BPSNCPD3 supported by IA 4560
        ;Reference to $$NCPDPQTY^PSSBPSUT supported by IA 4992
        ; 
MWC(RX,RFL)     ; Returns whether a prescription is (M)ail, (W)indow or (C)MOP
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
        ;Description: 
        ;Input: RX = Prescription file #52 IEN
        ; RFL = Refill number
        ;Returns: A value of 0 (zero) will be returned when reject codes M6, M8,
        ;NN, and 99 are present OR if on susp hold which means the prescription should not 
        ;be printed from suspense. Otherwise, a value of 1(one) will be returned.
DUR(RX,RFL)     ;
        N REJ,IDX,TXT,CODE,SHOLD,SHCODE,SHDT
        S SHOLD=1,IDX=""
        I '$D(RFL) S RFL=$$LSTRFL^PSOBPSU1(RX)
        S SHDT=$$SHDT(RX,RFL) ; Get suspense hold date for rx/refill
        ; Add one day to compare to prevent from running just after midnight problem.
        I SHDT>$$FMADD^XLFDT(DT,1) Q 0 ; Quit with 0 since still on hold
        D DUR1^BPSNCPD3(RX,RFL,.REJ) ; Get reject list from last submission
        F  S IDX=$O(REJ(IDX)) Q:IDX=""  D  Q:'SHOLD
        . S TXT=$G(REJ(IDX,"REJ CODE LST"))
        . F I=1:1:$L(TXT,",") S CODE=$P(TXT,",",I) D  Q:'SHOLD
        . . F SHCODE="M6","M8","NN",99 D  Q:'SHOLD
        . . . I CODE=SHCODE D
        . . . . I SHDT="" S SHOLD=0 D SHDTLOG(RX,RFL) Q  ; No previous Susp Hold Date or log entry - Create it.
        Q SHOLD
        ;
        ;Description: This subroutine sets the EPHARMACY SUSPENSE HOLD DATE field
        ;for the rx or refill to tomorrow and adds an entry to the SUSPENSE Activity Log.
        ;Input: RX = Prescription File IEN
        ; RFL = Refill
SHDTLOG(RX,RFL) ;
        N DA,DIE,DR,COMM,SHDT
        I '$D(RFL) S RFL=$$LSTRFL^PSOBPSU1(RX)
        S SHDT=$$FMADD^XLFDT(DT,1)
        S COMM="SUSPENSE HOLD until "_$$FMTE^XLFDT(SHDT,"2D")_" due to host reject error."
        I RFL=0 S DA=RX,DIE="^PSRX(",DR="86///"_SHDT D ^DIE
        E  S DA=RFL,DA(1)=RX,DIE="^PSRX("_DA(1)_",1,",DR="86///"_SHDT D ^DIE
        D RXACT(RX,RFL,COMM,"S",+$G(DUZ)) ; Create Activity Log entry
        Q
        ;
        ;Description: This function returns the EPHARMACY SUSPENSE HOLD DATE field
        ;for the rx or refill
        ;Input: RX = Prescription File IEN
        ; RFL = Refill
SHDT(RX,RFL)    ;
        N FILE,IENS
        I '$D(RFL) S RFL=$$LSTRFL^PSOBPSU1(RX)
        S FILE=$S(RFL=0:52,1:52.1),IENS=$S(RFL=0:RX_",",1:RFL_","_RX_",")
        Q $$GET1^DIQ(FILE,IENS,86,"I")
        ;
ELOG(RESP)      ; - due to size of PSOBPSU1 exceeding limit 
        ; -Logs an ECME Activity Log if Rx Qty is different than Billing Qty
        I '$G(RESP),$T(NCPDPQTY^PSSBPSUT)'="" D
        . N DRUG,RXQTY,BLQTY,BLDU,Z
        . S DRUG=$$GET1^DIQ(52,RX,6,"I")
        . S RXQTY=$S('RFL:$$GET1^DIQ(52,RX,7,"I"),1:$$GET1^DIQ(52.1,RFL_","_RX,1))/1
        . S Z=$$NCPDPQTY^PSSBPSUT(DRUG,RXQTY),BLQTY=Z/1,BLDU=$P(Z,"^",2)
        . I RXQTY'=BLQTY D
        . . D RXACT(RX,RFL,"BILLING QUANTITY submitted: "_$J(BLQTY,0,$L($P(BLQTY,".",2)))_" ("_BLDU_")","M",DUZ)
        Q
        ;
UPDFL(RXREC,SUB,INDT)   ;update fill date with release date when NDC changes at CMOP and OPAI auto-release
        ;Input: RXREC = Prescription File IEN
        ;         SUB = Refill
        ;        INDT = Release date
        N DA,DIE,DR,PSOX,SFN,DEAD,SUB,XOK,OLD,X,II,EXDAT,OFILLD,COM,CNT,RFCNT,RF
        S DEAD=0,SFN=""
        S EXDAT=INDT I EXDAT["." S EXDAT=$P(EXDAT,".")
        I '$D(SUB) S SUB=0 F II=0:0 S II=$O(^PSRX(RXREC,1,II)) Q:'II  S SUB=+II
        I 'SUB S OFILLD=$$GET1^DIQ(52,RXREC,22,"I") Q:OFILLD=EXDAT  D
        .S (X,OLD)=$P(^PSRX(RXREC,2),"^",2),DA=RXREC,DR="22///"_EXDAT_";101///"_EXDAT,DIE=52
        .D ^DIE K DIE,DA
        I SUB S (OLD,X)=+$P($G(^PSRX(RXREC,1,SUB,0)),"^"),DA(1)=RXREC,DA=SUB,OFILLD=$$GET1^DIQ(52.1,DA_","_RXREC,.01,"I") Q:OFILLD=EXDAT  D
        . S DIE="^PSRX("_DA(1)_",1,",DR=".01///"_EXDAT D ^DIE K DIE S $P(^PSRX(RXREC,3),"^")=EXDAT
        Q:$D(DTOUT)!($D(DUOUT))
        S DA=RXREC
        D AREC^PSOSUCH1
FIN     ;
        Q
