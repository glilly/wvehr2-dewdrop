PSONEWG ;BIR/RTR - Copay copy and edit questions ;07/26/96
        ;;7.0;OUTPATIENT PHARMACY;**71,157,143,219,226,239,225**;DEC 1997;Build 29
        ;External reference ^PSDRUG( supported by DBIA 221
        ;External reference VADPT supported by DBIA 10061
START   ;
        N PSOPENIB,PSOMESOI
        S PSOPENIB="" I $G(PSORXED)!($G(PSOCOPY)) I $G(PSORXED("IRXN")) S PSOPENIB=$G(^PSRX(PSORXED("IRXN"),"IBQ"))
        S PSOMESOI=0 I $G(PSORXED) D
        .I $G(PSODRUG("OI")),$P($G(PSORXED("RX0")),"^",6) D
        ..I $G(PSODRUG("OI"))'=$P($G(^PSDRUG(+$P($G(PSORXED("RX0")),"^",6),2)),"^") S PSOMESOI=1
        S PSONEWFF=1,PSOFLAG=1
        ;Copay exemption checks
        D SCP^PSORN52D
        K PSOANSQ D SET S PSOCPZ("DFLG")=0,PSONEW("NEWCOPAY")=0
        I PSOSCP<50&($P($G(^PS(53,+$G(PSONEW("PATIENT STATUS")),0)),"^",7)'=1),$G(DUZ("AG"))="V" D  D COPAY^PSOCPB W !
        .;I $G(PSOANSQD("SC"))=0!($G(PSOANSQD("SC"))=1) Q
        .I $G(PSOANSQ("SC"))=0!($G(PSOANSQ("SC"))=1) S PSOANSQD("SC")=$G(PSOANSQ("SC"))
        I PSOSCA&(PSOSCP>49)!((PSOSCA!(PSOBILL=2))&($P($G(^PS(53,+$G(PSONEW("PATIENT STATUS")),0)),"^",7)=1))!(PSOSCP>49&(PSOBILL=2)) D SC^PSOMLLD2 I $G(PSOCPZ("DFLG")) K PSOANSQ,PSONEW("NEWCOPAY"),PSONEWFF,PSOMESOI Q
        I $G(PSOCPZ("DFLG")) K PSONEW("NEWCOPAY"),PSONEWFF,PSOMESOI Q
        ;IF MILL BILL, AND COPAY (*******TEST THE COPAY CHECK)
        I $$DT^PSOMLLDT D  I $G(PSOCPZ("DFLG")) K PSOANSQ,PSONEW("NEWCOPAY"),PSONEWFF,PSOMESOI Q
        .;New prompts Quit after first '^'
        .I $D(PSOIBQS(PSODFN,"CV")) D  D MESS D CV^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("CV"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("CV")),($P(PSOPENIB,"^",7)=0!($P(PSOPENIB,"^",7)=1)) S PSOANSQD("CV")=$P(PSOPENIB,"^",7)
        .I $D(PSOIBQS(PSODFN,"VEH")) D  D MESS D VEH^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("VEH"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("VEH")),($P(PSOPENIB,"^",3)=0!($P(PSOPENIB,"^",3)=1)) S PSOANSQD("VEH")=$P(PSOPENIB,"^",3)
        .I $D(PSOIBQS(PSODFN,"RAD")) D  D MESS D RAD^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("RAD"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("RAD")),($P(PSOPENIB,"^",4)=0!($P(PSOPENIB,"^",4)=1)) S PSOANSQD("RAD")=$P(PSOPENIB,"^",4)
        .I $D(PSOIBQS(PSODFN,"PGW")) D  D MESS D PGW^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("PGW"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("PGW")),($P(PSOPENIB,"^",5)=0!($P(PSOPENIB,"^",5)=1)) S PSOANSQD("PGW")=$P(PSOPENIB,"^",5)
        .I $D(PSOIBQS(PSODFN,"SHAD")) D  D MESS D SHAD^PSOMLLD2 I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("SHAD"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("SHAD")),($P(PSOPENIB,"^",8)=0!($P(PSOPENIB,"^",8)=1)) S PSOANSQD("SHAD")=$P(PSOPENIB,"^",8)
        .I $D(PSOIBQS(PSODFN,"MST")) D  D MESS D MST^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("MST"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("MST")),($P(PSOPENIB,"^",2)=0!($P(PSOPENIB,"^",2)=1)) S PSOANSQD("MST")=$P(PSOPENIB,"^",2)
        .I $D(PSOIBQS(PSODFN,"HNC")) D  D MESS D HNC^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("HNC"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("HNC")),($P(PSOPENIB,"^",6)=0!($P(PSOPENIB,"^",6)=1)) S PSOANSQD("HNC")=$P(PSOPENIB,"^",6)
        K PSONEWFF,PSOMESOI,PSOSCA
        Q
SET     ;Set original answers that were passed from CPRS
        Q:'$G(PSORXED("IRXN"))
        S PSOANSQ("SC")=$S($P($G(^PSRX(PSORXED("IRXN"),"IBQ")),"^")'="":$P($G(^("IBQ")),"^"),$P($G(^PSRX(PSORXED("IRXN"),"IB")),"^"):0,1:"")
        I $G(PSOANSQ("SC"))="" K PSOANSQ("SC")
        I $G(PSOPENIB)="" G SET2
        I '$$DT^PSOMLLDT Q
        I $P(PSOPENIB,"^",2)=0!($P(PSOPENIB,"^",2)=1) S PSOANSQ("MST")=$P(PSOPENIB,"^",2)
        I $P(PSOPENIB,"^",3)=0!($P(PSOPENIB,"^",3)=1) S PSOANSQ("VEH")=$P(PSOPENIB,"^",3)
        I $P(PSOPENIB,"^",4)=0!($P(PSOPENIB,"^",4)=1) S PSOANSQ("RAD")=$P(PSOPENIB,"^",4)
        I $P(PSOPENIB,"^",5)=0!($P(PSOPENIB,"^",5)=1) S PSOANSQ("PGW")=$P(PSOPENIB,"^",5)
        I $P(PSOPENIB,"^",6)=0!($P(PSOPENIB,"^",6)=1) S PSOANSQ("HNC")=$P(PSOPENIB,"^",6)
        I $P(PSOPENIB,"^",7)=0!($P(PSOPENIB,"^",7)=1) S PSOANSQ("CV")=$P(PSOPENIB,"^",7)
        I $P(PSOPENIB,"^",8)=0!($P(PSOPENIB,"^",8)=1) S PSOANSQ("SHAD")=$P(PSOPENIB,"^",8)
        ;
SET2    ;for when patient status is exempt, null IBQ node was set for exempts or SC>50 - data is in ICD node
        N PSOOICD,JJJ
        I $TR($G(^PSRX(PSODFN,"IBQ")),"^")="" S PSOOICD=$G(^PSRX(PSORXED("IRXN"),"ICD",1,0)) D SET3^PSONEWF:PSOOICD'=""
        ;
ICD     ;
        N JJ,ICD,II,FLD,RXN,TNEW,PSONOCHG S PSONOCHG=0
        S RXN=PSORXED("IRXN")
        I '$D(PSONEW("ICD"))&('$D(PSORXED("ICD"))) S PSONOCHG=1
        I $D(^PSRX(RXN,"ICD",0)) D
        . S II=0 F  S II=$O(^PSRX(RXN,"ICD",II)) Q:II=""!(II'?1N.N)!($G(PSOCOPY)&(II>1)&('PSONOCHG))  D
        .. S ICD=^PSRX(RXN,"ICD",II,0),FLD=$P(ICD,U) S:$G(PSONEW("IDFLG")) FLD="" D ICD^PSONEWF
        E  I $G(PSONEW("IDFLG")) K ^PSRX(RXN,"ICD","B") S $P(^PSRX(RXN,"ICD",1,0),"^",1)="",TNEW=2 D
        . F TNEW=TNEW:1:8 Q:'$D(^PSRX(RXN,"ICD",TNEW,0))  S DIK="^PSRX("_RXN_","_$C(34)_"ICD"_$C(34)_",",DA=TNEW,DA(1)=RXN D ^DIK K DA,DIK ;user deleted all
        K PSONEW("IDFLG"),PSORXED("IDFLG")
        Q
MESS    ;
        I $G(PSOMESOI)=1,$G(PSORXED) W !!,"The Pharmacy Orderable Item has changed for this order. Please review any",!,"existing SC or Environmental Indicator defaults carefully for appropriateness.",! S PSOMESOI=2
        Q
