LRBEBA4 ;DALOI/JAH/FHS - ORDERING AND RESULTING OUTPATIENT ;8/10/04
        ;;5.2;LAB SERVICE;**291,359,352**;Sep 27, 1994;Build 1
        ;
GPRO(LRBEDN,LRBECDT,LRBESPC,LRBETST)    ; Get the Procedure (CPT)
        ; A qualified coder will setup the CPTs in #60. The routine look for
        ; CPTs by specimen, then HCPCS, and lasty, by a default.
        ;
        S X="CH;"_LRBEDN_";1",Y=$O(^LAB(60,"C",X,0))
        Q:+Y<0
        S LRBETST=+Y
PANEL   ;Entry point for panel cpt
        N X,Y,DIC,LRBEIEN,LRBENLT,LRN
        S:$G(LRSPEC)="" LRSPEC=$G(LRBESPC)
        S (LRI,LRBECPT)=""
        ; #60 Specimen CPT
SP60    D GCPT(LRBETST,LRBECDT,LRSPEC) Q:$O(LRBECPT(LRBETST,0))
        ;HCPCS CODE
HCPCS   D
        . S LRBECPT=$$GET1^DIQ(60,LRBETST_",","HCPCS CODE","I")
        . I LRBECPT D
        . . S LRBECPT=$$CPT^ICPTCOD(LRBECPT,LRBECDT)
        . . I '$P(LRBECPT,U,7) S LRBECPT="" Q
        . . S LRBECPT(LRBETST,$G(LRI)+1,$P(LRBECPT,U))="HCPCS CODE",LRI=$G(LRI)+1
        ;Try file #64
NLT     Q:$O(LRBECPT(LRBETST,0))  D
        . N I,LRBENLT,LRX,LRN,LRNM,SUFX
        . S LRBENLT=$$GET1^DIQ(60,LRBETST_",",64,"I")
        . Q:'LRBENLT
        . S LRNM=$P($G(^LAM(LRBENLT,0)),U,2)
        . S LRNM(1)=LRNM
        . S SUFX=$P(LRNM,".",2)
        . I $G(LRCDEF),SUFX'=LRCDEF S LRNM(2)=$P(LRNM,".",1)_"."_LRCDEF
        . I SUFX S LRNM(3)=$P(LRNM,".",1)_"."_"0000"
        . S I=0 F  S I=$O(LRNM(I)) Q:'I  Q:$O(LRBECPT(LRBETST,0))  D
        . . S LRBENLT=$O(^LAM("C",LRNM(I)_" ",0)) Q:'LRBENLT
        . . S LRN=0 F  S LRN=$O(^LAM(LRBENLT,4,"AC","CPT",LRN)) Q:LRN<1  D
        . . . S LRX=$G(^LAM(LRBENLT,4,LRN,0)) Q:'LRX  D
        . . . . Q:'$P(LRX,U,3)!($P(LRX,U,3)>LRBECDT)!($P(LRX,U,4)&($P(LRX,U,4)<LRBECDT))
        . . . . S LRBECPT=+LRX
        . . . . I '$P($$CPT^ICPTCOD(LRBECPT,LRBECDT),U,7) Q
        . . . . S LRBECPT(LRBETST,($G(LRI)+1),LRBECPT)="WKLD CODE-"_LRNM(I),LRI=$G(LRI)+1
        . . . . I LRI>1,LRBECPT(LRBETST,LRI,LRBECPT)=$G(LRBECPT(LRBETST,($G(LRI)-1),LRBECPT)) D
        . . . . . S LRBECPT(LRBETST,($G(LRI)-1),LRBECPT,"COUNT")=+$G(LRBECPT(LRBETST,($G(LRI)-1),LRBECPT,"COUNT"))+1
        . . . . . K LRBECPT(LRBETST,LRI,LRBECPT) S LRI=$G(LRI)-1
        ;Default Site/Spec CPT
SPCPT   Q:$O(LRBECPT(LRBETST,0))  D
        . S LRBECPT=$$GET1^DIQ(60,LRBETST_",","DEFAULT SITE/SPECIMEN CPT","E")
        . I LRBECPT D
        . . I '$P($$CPT^ICPTCOD(LRBECPT,LRBECDT),U,7) S LRBECPT="" Q
        . . S LRBECPT(LRBETST,$G(LRI)+1,LRBECPT)="DEFAULT SITE/SPECIMEN CPT",LRI=$G(LRI)+1
        Q
        ;
SCPT(CPT,TDAT)  ; Get the CPT/HCPCS Code
        Q $$CPT^ICPTCOD(CPT,TDAT)
        ;
GCPT(LRBETST,LRBECDT,LRSPEC)    ; Get the CPT
        N A,ARR,LRBEAX,LRBEIEN,LRBEAR60,X,XX
        S LRBEIEN=LRSPEC_","_LRBETST_",",(LRI,LRBECPT)=""
        D GETS^DIQ(60.01,LRBEIEN,"96*","I","LRBEAR60")
        S A="" F  S A=$O(LRBEAR60(60.196,A)) Q:A=""  D
        . Q:$G(LRBEAR60(60.196,A,1,"I"))=""
        . S ARR($G(LRBEAR60(60.196,A,1,"I")))=$G(LRBEAR60(60.196,A,.01,"I"))
        S XX=$P(LRBECDT,".",1)_"."_9999
        S X=$O(ARR(XX),-1) I X D
        .S LRBEAX=ARR(X)
        .S LRBEAX=$$CPT^ICPTCOD(LRBEAX,LRBECDT)
        .Q:'$P(LRBEAX,U,7)
        .S LRBECPT(LRBETST,($G(LRI)+1),$P(LRBEAX,U))="SPECIMEN CPT",LRI=$G(LRI)+1
        Q
        ;
UPDOR(DFN,ORITEM,ORIEN,ORDX,ORSCEI)     ; Update CIDC information from OERR
        I $G(^XTMP("LRPCELOG",0)) D
        . N LRLNOW,LRI
        . F  S LRLNOW=$$NOW^XLFDT Q:'$D(^XTMP("LRPCELOG",3,LRLNOW))
        . S ^XTMP("LRPCELOG",3,LRLNOW)=DFN_U_ORITEM_U_ORIEN_U_"["_ORSCEI_"]"
        . S LRI=0 F  S LRI=$O(ORDX(LRI)) Q:LRI=""  D
        . . S ^XTMP("LRPCELOG",3,LRLNOW,"ORDX",LRI)=ORDX(LRI)
        I $S('$O(ORDX(0)):1,ORSCEI="^^^^^":1,1:0) Q "O^No Diagnosis Entered"
        N LRBEAR,LRBEDFN,LRDFN,LRBEIEN,LRODT,LRORD,LRSN,LRBERMS,LRBETN,LRBETYP
        N LRBEVST,LRAA,LRLLOC,LRSAMP,LRSPEC,LRSB,LRBEY
        S LRBERMS=1,LRORD=$P(ORITEM,";",1),LRODT=$P(ORITEM,";",2)
        S LRSN=$P(ORITEM,";",3),LRBEIEN=LRSN_","_LRODT_","
        S (LRBEDFN,LRDFN)=$$GET1^DIQ(69.01,LRBEIEN,.01,"I")
        S LRSAMP=$$GET1^DIQ(69.01,LRBEIEN,3,"I")
        S LRLLOC=$$GET1^DIQ(69.01,LRBEIEN,8,"I")
        S LRSPEC=$$GET1^DIQ(69.02,"1,"_LRBEIEN,.01,"I") S:LRSPEC="" LRSPEC=72
        I LRORD'=$$GET1^DIQ(69.01,LRBEIEN,9.5,"I") D  Q LRBERMS
        .S LRBERMS="0^"_$$EMSG(1)
        I DFN'=$$GET1^DIQ(63,LRBEDFN_",",.03,"I") D  Q LRBERMS
        .S LRBERMS="0^"_$$EMSG(2)
        S LRBEVST=$P($G(^LRO(69,LRODT,1,LRSN,"PCE")),";",1) D WORK
        Q LRBERMS
        ;
WORK    ; Enter the updated information into file
        N LRBEFND,LRBETNM,LRBETST,LRBEZ,LRBERES
        S (LRBETN,LRBEFND)=0
        F  S LRBETN=$O(^LRO(69,LRODT,1,LRSN,2,LRBETN)) Q:LRBETN=""!('LRBETN)  D
        .Q:ORIEN'=$$GET1^DIQ(69.03,LRBETN_","_LRBEIEN,6,"I")
        .S:'LRBEFND LRBEFND=1 S LRAA=""
        .S LRBETST=$$GET1^DIQ(69.03,LRBETN_","_LRBEIEN,.01,"I")
        .S LRBETNM=$$GET1^DIQ(60,LRBETST_",",.01,"I")
        .S LRBEZ(LRBETN)=LRBETST_"^"_LRBETNM K LRBEAR
        .D BLRSB(.LRSB,LRBETN_","_LRBEIEN,LRBETST,.LRBEY)
        .D KILL(LRODT,LRSN,LRBETN),SET(DFN,.ORDX,ORSCEI)
        .D SDG1(LRODT,LRSN,LRBETN,DFN,.LRBEAR)
        I 'LRBEFND S LRBERMS="0^"_$$EMSG(3) Q
        I LRBEVST'="",LRAA'="" S LRBERES=1 D BAWRK^LRBEBA(LRODT,LRSN,1,.LRBEY,.LRBEZ,"",LRBEVST,"",ORIEN)
        Q
        ;
KILL(LRBEODT,LRBESN,LRBETN)     ; Kill the existing DGX and SC/EI
        N DA,DIK
        S DA(1)=LRBETN,DA(2)=LRSN,DA(3)=LRODT
        S DA="" F  S DA=$O(^LRO(69,DA(3),1,DA(2),2,DA(1),2,DA)) Q:DA=""  D
        .S DIK="^LRO(69,"_DA(3)_","_1_","_DA(2)_","_2_","_DA(1)_","_2_","
        .D ^DIK
        Q
        ;
SET(DFN,ORDX,ORSCEI)    ; Set #69 with new DGX and SC/EI
        N LRBEA
        S LRBEA="" F  S LRBEA=$O(ORDX(LRBEA)) Q:LRBEA=""  D
        .S LRBEAR(DFN,"LRBEDGX",LRBEA,$G(ORDX(LRBEA)))="^^^"_ORSCEI
        .S:LRBEA=1 $P(LRBEAR(DFN,"LRBEDGX",LRBEA,$G(ORDX(LRBEA))),U,12)=1
        Q
        ;
SDG1(LRODT,LRSN,LRBETN,DFN,LRBEAR)      ; Set the diagnois
        ;                             and indicators file #69
        N LRBEA,LRBEFIL,LRBEIEN,LRFDA,LRFDAIEN,LRERR,LRBEPDGX,LRBETNUM
        S LRBEFIL=69.05,LRBETNUM=$O(^LRO(69,LRODT,1,LRSN,2,LRBETN,2,""),-1)+1
        S LRBEA="" F  S LRBEA=$O(LRBEAR(DFN,"LRBEDGX",LRBEA)) Q:LRBEA=""  D
        .S LRBEPDGX=""
        .F  S LRBEPDGX=$O(LRBEAR(DFN,"LRBEDGX",LRBEA,LRBEPDGX)) Q:LRBEPDGX=""  D
        ..S LRBEPTDT=$G(LRBEAR(DFN,"LRBEDGX",LRBEA,LRBEPDGX))
        ..S LRBEIEN="+"_LRBETNUM_","_LRBETN_","_LRSN_","_LRODT_","
        ..S LRFDAIEN(LRBETNUM)=LRBETNUM,LRFDA(99,LRBEFIL,LRBEIEN,.01)=LRBEPDGX
        ..S:$P(LRBEPTDT,U,6)'="" LRFDA(99,LRBEFIL,LRBEIEN,1)=$P(LRBEPTDT,U,6)
        ..S:$P(LRBEPTDT,U,10)'="" LRFDA(99,LRBEFIL,LRBEIEN,2)=$P(LRBEPTDT,U,10)
        ..S:$P(LRBEPTDT,U,4)'="" LRFDA(99,LRBEFIL,LRBEIEN,3)=$P(LRBEPTDT,U,4)
        ..S:$P(LRBEPTDT,U,5)'="" LRFDA(99,LRBEFIL,LRBEIEN,4)=$P(LRBEPTDT,U,5)
        ..S:$P(LRBEPTDT,U,7)'="" LRFDA(99,LRBEFIL,LRBEIEN,5)=$P(LRBEPTDT,U,7)
        ..S:$P(LRBEPTDT,U,8)'="" LRFDA(99,LRBEFIL,LRBEIEN,6)=$P(LRBEPTDT,U,8)
        ..S:$P(LRBEPTDT,U,9)'="" LRFDA(99,LRBEFIL,LRBEIEN,7)=$P(LRBEPTDT,U,9)
        ..S:$P(LRBEPTDT,U,11)'="" LRFDA(99,LRBEFIL,LRBEIEN,9)=$P(LRBEPTDT,U,11)
        ..S:$P(LRBEPTDT,U,12)=1 LRFDA(99,LRBEFIL,LRBEIEN,8)=1         ;Is Primary?
        ..S LRBETNUM=LRBETNUM+1
        D UPDATE^DIE("","LRFDA(99)","LRFDAIEN","LRERR")
        Q
        ;
EMSG(LRBETYP)   ; Return Error Message
        N LRBEEMS,LRBETYPN
        S:LRBETYP=1 LRBETYPN="Order Number" S:LRBETYP=2 LRBETYPN="DFN"
        S:LRBETYP=3 LRBETYPN="Orderable Item"
        S LRBEEMS="Possible reasons for failure is the "_LRBETYPN_" did not match."
        Q LRBEEMS
        ;
BLRSB(LRSB,LRBEIENT,LRBETST,LRBEY)      ; Build the LRSB global
        N LRBESS,LRBEIDT,LRBESB,LRBEAA,LRBEAD,LRBEAN,LRBEIEN2,LRBET,NX,XX
        S (LRAD,LRBEAD)=$$GET1^DIQ(69.03,LRBEIENT,2,"I")
        S (LRAA,LRBEAA)=$$GET1^DIQ(69.03,LRBEIENT,3,"I") Q:LRAA=""
        S (LRAN,LRBEAN)=$$GET1^DIQ(69.03,LRBEIENT,4,"I")
        S LRBEIEN2=LRBEAN_","_LRBEAD_","_LRBEAA_","
        S (LRSS,LRBESS)=$$GET1^DIQ(68,LRBEAA_",",.02,"I")
        S (LRIDT,LRBEIDT)=$$GET1^DIQ(68.02,LRBEIEN2,13.5,"I")
        S XX=$P($P(^LAB(60,LRBETST,0),U,5),";",2) I XX D
        .S LRSB(XX)=$G(^LR(LRDFN,LRSS,LRIDT,XX))
        .I LRSB(XX)="" K LRSB(XX) Q
        .I "pending^canc"[$P(LRSB(XX),U,1) K LRSB(XX) Q
        .S LRBEY(LRBETST,XX)=""
        S NX=0 F  S NX=$O(^LAB(60,LRBETST,2,NX)) Q:'NX  D
        .S LRBET=+^LAB(60,LRBETST,2,NX,0)
        .S XX=$P($P(^LAB(60,LRBET,0),U,5),";",2) I XX D
        ..S LRSB(XX)=$G(^LR(LRDFN,LRSS,LRIDT,XX))
        ..I LRSB(XX)="" K LRSB(XX) Q
        ..I "pending^canc"[$P(LRSB(XX),U,1) K LRSB(XX) Q
        ..S LRBEY(LRBETST,XX)=""
        Q
        ;
CHKINP(LRDFN,LRBEDAT)   ; Check for Inpatient Status)
        N VAIN,VAINDT
        I '$G(DFN) D
        . S DFN=$$GET1^DIQ(63,LRDFN_",",.03,"I")
        . S LRDPF=$$GET1^DIQ(63,LRDFN_",",.02,"I")
        I $G(LRDPF)'=2 Q 0
        S VAINDT=LRBEDAT D INP^VADPT
        Q $G(VAIN(1))
        ;
RFLX()  ; Ask the Reflex Question
        N DIR,DUOUT,DTOUT,DIRUT,Y
        S DIR("A")="Is this a Reflex Test? (Y/N): "
        S DIR(0)="YA" D ^DIR
        I $D(DIRUT)!($D(DUOUT)!$D(DTOUT)) Q -1
        Q +Y
        ;
DEFAULT ;Set Default diagnosis
        N LRD,LRI,LRX,LRY,LRD
        S (LRBEDMSG,LRDBEDGX)=""
        S LRI=$O(^LRO(69,LRODT,1,LRSN,2,1,2,0)) Q:LRI<1
        S LRD=$G(^LRO(69,LRODT,1,LRSN,2,1,2,LRI,0))
        Q:'LRD
        S LRDBEDGX=+LRD
        S LRBEDMSG=+LRD_"^^^"_$P(LRD,U,4)_U_$P(LRD,U,5)_U_$P(LRD,U,2)
        S LRBEDMSG=LRBEDMSG_U_$P(LRD,U,6)_U_$P(LRD,U,7)_U_$P(LRD,U,8)
        S LRBEDMSG=LRBEDMSG_U_$P(LRD,U,3)_U_$P(LRD,U,10)_U_$P(LRD,U,9)
        W:$G(LRDBUG) !,LRBEDMSG
        Q
        ;
GEPRO(LRBEAA)   ; Provider - Responsible Official
        N X,LRBEPRO
        S LRBEPRO=$$GET1^DIQ(68,LRBEAA_",",.1,"I")
        I $$GET^XUA4A72(LRBEPRO,DT)<0 S LRBEPRO=$$GET1^DIQ(69.9,1,617,"I")
        Q LRBEPRO
        ;
GOPRO(LRODT,LRSN)       ; Get the Ordering Provider
        N X,Y,DIC,LRBEPRO
        S LRBEPRO=$$GET1^DIQ(69.01,LRSN_","_LRODT_",",7,"I")
        I $$GET^XUA4A72(LRBEPRO,DT)<0 S LRBEPRO=0 D
        .S X=$$GET1^DIQ(69.9,1,617,"I")
        .I $$GET^XUA4A72(X,DT)>0 S LRBEPRO=X
        Q LRBEPRO
