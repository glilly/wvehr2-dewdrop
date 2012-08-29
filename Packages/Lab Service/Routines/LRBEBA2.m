LRBEBA2 ;DALOI/JAH/FHS - ORDERING AND RESULTING OUTPATIENT ;8/10/04
        ;;5.2;LAB SERVICE;**291,359,352**;Sep 27, 1994;Build 1
        ;
DG1(LRBESTG)    ; Set the DG1 segment into the ^TMP
        N LRBEDGX,LRBETNUM
        S LRBETNUM=$O(^TMP("OR",$J,"LROT",STARTDT,TYPE,SAMP,SPEC,LRSX,"LRBEDGX",""),-1)
        S LRBETNUM=$G(LRBETNUM)+1
        S LRBEDGX=$P($P(LRBESTG,"|",4),"^",1)
        S ^TMP("OR",$J,"LROT",STARTDT,TYPE,SAMP,SPEC,LRSX,"LRBEDGX",LRBETNUM)=LRBEDGX
        Q
ZCL(LRBESTG)    ; Set the ZCL segment into the ^TMP
        N LRBEX,LRBETNUM,LRBEIND
        S LRBETNUM=$O(^TMP("OR",$J,"LROT",STARTDT,TYPE,SAMP,SPEC,LRSX,"LRBEDGX",""),-1)
        S LRBEX=$P(LRBESTG,"|",3),LRBEIND=$P(LRBESTG,"|",4)
        S $P(^TMP("OR",$J,"LROT",STARTDT,TYPE,SAMP,SPEC,LRSX,"LRBEDGX",LRBETNUM),U,LRBEX+1)=LRBEIND
        Q
        ;
SDGX69(J,LRBEIEN)       ; Set the diagnosis into #69
        N LRBEDGX,LRBEFIL,LRFDA,LRFDAIEN,LRBESEQ,LRBEPTDT,LRBEIEN2
        S LRBESEQ="",LRBEFIL=69.05
        F  S LRBESEQ=$O(^TMP("OR",$J,"LROT",LRSDT,LRXZ,LRSAMP,LRSPEC,J,"LRBEDGX",LRBESEQ)) Q:LRBESEQ=""  D
        .S LRBEPTDT=$G(^TMP("OR",$J,"LROT",LRSDT,LRXZ,LRSAMP,LRSPEC,J,"LRBEDGX",LRBESEQ))
        .S LRBEIEN2=LRBESEQ_","_LRBEIEN
        .I '$D(^LRO(69,LRODT,1,LRSN,2,$P(LRBEIEN,",",1),2,"B",$P(LRBEPTDT,U,1))) S LRBEIEN2="+"_LRBEIEN2
        .S LRFDA(99,LRBEFIL,LRBEIEN2,.01)=$P(LRBEPTDT,U,1),LRFDAIEN(LRBESEQ)=LRBESEQ
        .S LRFDA(99,LRBEFIL,LRBEIEN2,1)=$P(LRBEPTDT,U,4)   ;SC
        .S LRFDA(99,LRBEFIL,LRBEIEN2,2)=$P(LRBEPTDT,U,8)   ;CV
        .S LRFDA(99,LRBEFIL,LRBEIEN2,3)=$P(LRBEPTDT,U,2)   ;AO
        .S LRFDA(99,LRBEFIL,LRBEIEN2,4)=$P(LRBEPTDT,U,3)   ;IR
        .S LRFDA(99,LRBEFIL,LRBEIEN2,5)=$P(LRBEPTDT,U,5)   ;SWAC
        .S LRFDA(99,LRBEFIL,LRBEIEN2,6)=$P(LRBEPTDT,U,6)   ;MST
        .S LRFDA(99,LRBEFIL,LRBEIEN2,7)=$P(LRBEPTDT,U,7)   ;HNC
        .S LRFDA(99,LRBEFIL,LRBEIEN2,9)=$P(LRBEPTDT,U,9)   ;SHAD
        .S:LRBESEQ=1 LRFDA(99,LRBEFIL,LRBEIEN2,8)=1         ;Is Primary?
        D UPDATE^DIE("","LRFDA(99)","LRFDAIEN","LRERR")
        Q
        ;
GDG1(LRODT,SN,IFN)      ; diagnosis and indicators back to CPRS
        N LRBECNT,LRBEDGX,LRBESEQ,LRBEPTDT
        S LRBECNT=2
        S LRBESEQ=0 F  S LRBESEQ=$O(^LRO(69,LRODT,1,SN,2,IFN,2,LRBESEQ)) Q:LRBESEQ<1  D
        .S LRBEPTDT=$G(^LRO(69,LRODT,1,SN,2,IFN,2,LRBESEQ,0))
        .Q:'$G(LRBEPTDT)
        .S:$P(LRBEPTDT,"^",9)=1 ^TMP("LRX",$J,69,IFN,"LRBEDGX",1)=LRBEPTDT
        .S:$P(LRBEPTDT,"^",9)'=1 ^TMP("LRX",$J,69,IFN,"LRBEDGX",LRBECNT)=LRBEPTDT,LRBECNT=LRBECNT+1
        Q
        ;
SDG1(IFN,CTR,LRBEMSG)   ; Setup the DG1 segment For CPRS
        N LRBEX,LRBEDGX,LRBEIEN,LRBESEQ,LRBEPTDT,LRBEXMSG
        S LRBESEQ="" F  S LRBESEQ=$O(^TMP("LRX",$J,69,IFN,"LRBEDGX",LRBESEQ)) Q:LRBESEQ=""  D
        .S LRBEPTDT=$G(^TMP("LRX",$J,69,IFN,"LRBEDGX",LRBESEQ))
        .S LRBEDGX=$$GET1^DIQ(80,$P(LRBEPTDT,U,1)_",",.01,"I")
        .S LRBEXMSG=$$GET1^DIQ(80,$P(LRBEPTDT,U,1)_",",3,"I")
        .S LRBEX=$P(LRBEPTDT,U,1)_"^"_LRBEXMSG_"^80^"_LRBEDGX_"^"_LRBEXMSG_"^ICD9"
        .S CTR=CTR+1,@LRBEMSG@(CTR)="DG1|"_LRBESEQ_"||"_LRBEX_"|||||||||||||"
        .S CTR=CTR+1,@LRBEMSG@(CTR)="ZCL|"_LRBESEQ_"|1|"_$P(LRBEPTDT,U,4)
        .S CTR=CTR+1,@LRBEMSG@(CTR)="ZCL|"_LRBESEQ_"|2|"_$P(LRBEPTDT,U,5)
        .S CTR=CTR+1,@LRBEMSG@(CTR)="ZCL|"_LRBESEQ_"|3|"_$P(LRBEPTDT,U,2)
        .S CTR=CTR+1,@LRBEMSG@(CTR)="ZCL|"_LRBESEQ_"|4|"_$P(LRBEPTDT,U,6)
        .S CTR=CTR+1,@LRBEMSG@(CTR)="ZCL|"_LRBESEQ_"|5|"_$P(LRBEPTDT,U,7)
        .S CTR=CTR+1,@LRBEMSG@(CTR)="ZCL|"_LRBESEQ_"|6|"_$P(LRBEPTDT,U,8)
        .S CTR=CTR+1,@LRBEMSG@(CTR)="ZCL|"_LRBESEQ_"|7|"_$P(LRBEPTDT,U,3)
        .S CTR=CTR+1,@LRBEMSG@(CTR)="ZCL|"_LRBESEQ_"|8|"_$P(LRBEPTDT,U,10)
        Q
        ;
GMOD(LRBEAA,LRBECPT)    ; Get external service modifier
        ;input LRBECPT - ien to #81, not required
        N LRBEMOD
        S LRBECPT=$G(LRBECPT)
        S LRBEMOD=$$GMOD^LRBEBA21(LRBEAA,LRBECPT)
        Q LRBEMOD
        ;
SACC(LRODT,LRSN,LRTN,LRSAMP,LRSPEC,LRTSTS,LRBEX)        ; Set Accession 
        N LRBEZ
        D CARR(.LRBEX,.LRBEZ,LRSAMP,LRSPEC,LRTSTS)
        D SDG1^LRBEBA(LRODT,LRSN,LRTN,LRSAMP,LRSPEC,LRTSTS,.LRBEZ)
        Q
        ;
CARR(LRBEAR,LRBEARR,LRBESAMP,LRBESPEC,LRTSTS)   ; Change the array to only
        ; the specimen that needs to go
        N LRBEDFN,LRBETS,LRBESMP,LRBESPC
        M LRBEARR=LRBEAR
        I '$D(DFN) S LRBEDFN=$$GET1^DIQ(63,LRDFN,.03,"I")
        S:$D(DFN) LRBEDFN=DFN
        S LRBESMP=""
        F  S LRBESMP=$O(LRBEARR(LRBEDFN,"LRBEDGX",LRBESMP)) Q:LRBESMP=""  D
        .I LRBESAMP'=LRBESMP D  Q
        ..K LRBEARR(LRBEDFN,"LRBEDGX",LRBESMP)
         .S LRBESPC=""
        .F  S LRBESPC=$O(LRBEARR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC)) Q:LRBESPC=""  D
        ..I LRBESPEC'=LRBESPC D  Q
        ...K LRBEARR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC)
        ..S LRBETS=""
        ..F  S LRBETS=$O(LRBEARR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,LRBETS)) Q:LRBETS=""  D
        ...I LRBETS'=LRTSTS K LRBEARR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,LRBETS)
        Q
        ;
BLDAR(LRBEDFN,LRODT,LRSN,LRTN,LRBESMP,LRBESPC,LRBETST,LRBEAR)   ; Build array
        ;                                     with diagnosis and indicator info
        K LRBEMSG,LRBESEQ,LRBEPTDT,LRBEODT,LRBEDMSG,LRDBEDGX,LRD
        S LRBEODT=$P(LRODT,"."),LRBEPTDT=""
        S LRTN=$O(^LRO(69,LRODT,1,LRSN,2,"B",LRBETST,0))
        Q:'$G(LRTN)
        S LRBESEQ=0 F  S LRBESEQ=$O(^LRO(69,LRODT,1,LRSN,2,LRTN,2,LRBESEQ)) Q:LRBESEQ<1  D
        . I LRBESEQ,$D(^LRO(69,LRODT,1,LRSN,2,LRTN,2,LRBESEQ,0)) S LRD=^(0) D
        . . S LRBEMSG=+LRD_"^^^"_$P(LRD,U,4)_U_$P(LRD,U,5)_U_$P(LRD,U,2)
        . . S LRBEMSG=LRBEMSG_U_$P(LRD,U,6)_U_$P(LRD,U,7)_U_$P(LRD,U,8)
        . . S LRBEMSG=LRBEMSG_U_$P(LRD,U,3)_U_$P(LRD,U,10)_U_$P(LRD,U,9)
        . . S LRBEDGX=+LRD
        . S LRBEAR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,LRBETST,LRBEDGX)=LRBEMSG
        ;if test has no dx, sc/ei, then find default dx, sc/ei
        S LRBESEQ=$O(^LRO(69,LRODT,1,LRSN,2,LRTN,2,0)) I 'LRBESEQ D
        . D DEFAULT^LRBEBA4 Q:$G(LRBENO)
        . Q:'$G(LRDBEDGX)
        . S LRBEAR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,LRBETST,LRDBEDGX)=LRBEDMSG
        N LRTNX,LRI,LRTNXID
        D BLDAR2(LRBETST,LRBETST,LRBESMP,LRBESPC)
        S LRI=0 F  S LRI=$O(^LAB(60,LRBETST,2,LRI)) Q:LRI<1  D
        . S LRTNX=+$G(^LAB(60,LRBETST,2,LRI,0)) Q:'LRTNX
        . S LRTNXID=$P($P(^LAB(60,LRTNX,0),U,5),";",2)
        . I LRTNXID="" D BLDAR2(LRBETST,LRTNX,LRBESMP,LRBESPC)
        Q
        ;
BLDAR2(LRBETST,XTEST,LRBESMP,LRBESPC)   ;
        N LRTNX,LRI,DGX,LRX
        S LRI=0
        F  S LRI=$O(^LAB(60,XTEST,2,LRI)) Q:LRI<1  D
        . S LRTNX=+$G(^LAB(60,XTEST,2,LRI,0)) Q:'LRTNX  D
        . . S DGX=0 F  S DGX=$O(LRBEAR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,LRBETST,DGX)) Q:DGX<1  D
        . . . S LRX=$G(LRBEAR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,LRBETST,DGX))
        . . . Q:'LRX
        . . . S LRBEAR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,LRTNX,DGX)=LRX
        Q
        ;
STDN(LRODT,LRBESN,LRBETEST,LRBEAR1)     ;  Test and Data Number
        N LRBEA,LRBEB,LRBEC,LRBED,LRBEDX,LRBEPTDT,X,Y
        S LRBEA="" F  S LRBEA=$O(LRBETEST(LRBEA)) Q:LRBEA=""  D
        .S DIC="^LRO(69,"_LRODT_","_1_","_LRBESN_","_"2,",DIC(0)="MZ"
        .S X=$P(LRBETEST(LRBEA),U,2) D ^DIC K DIC I +Y<1 Q
        .S LRBEB=0 F  S LRBEB=$O(^LRO(69,LRODT,1,LRBESN,2,+Y,2,"B",LRBEB)) Q:LRBEB<1  D
        ..S LRBEC=0 F  S LRBEC=$O(^LRO(69,LRODT,1,LRBESN,2,+Y,2,"B",LRBEB,LRBEC)) Q:'LRBEC  D
        ...S LRBED="" F  S LRBED=$O(LRBEAR1($P(LRBETEST(LRBEA),U,1),LRBED)) Q:LRBED=""  D
        ....S LRBEAR1($P(LRBETEST(LRBEA),U,1),LRBED,LRBEC)=LRBEB
        Q
        ;
SOP(LRBEDFN,LRBESB,LRBEAR1,LRBEPAN,LRBEROLL)    ;Outpatient Resulting 
        ; Information in CIDC Array
        N DIC,LRBEDN,LRBESTG,LRBEDGX,LRBEEDT,LRBEEPRO,LRBEOPRO,LRBEQTY,LRBETST
        N LRBEPOS,LRORREFN,LRBE21
        ;LRBERES=Resend PCE date flag
        K LRBECPT S (LRBECPT,LRBEEDT,LRBEEPRO,LRBEOPRO,LRBEQTY,LRORREFN)=""
        S LRBEEPRO=$$GEPRO^LRBEBA4(LRAA),LRBEOPRO=$$GOPRO^LRBEBA4(LRODT,LRSN)
        S LRBETST=0 F  S LRBETST=$O(LRBEAR1(LRBETST)) Q:'LRBETST  D
        . S LRBE21=0
        . ;process AMA/billable panel CPT codes
        . I $D(LRBEPAN(LRBETST)) D EN^LRBEBA21(.LRBE21)
        . ;otherwise process atomic test(s) CPT codes
        . I 'LRBE21 D
        . . S LRY=$O(^LRO(69,LRODT,1,LRSN,2,"B",LRBETST,0))
        . . Q:'LRY
        . . S LRY=LRY_","_LRSN_","_LRODT_","
        . . Q:$$GET1^DIQ(69.03,LRY,10,"I")
        . . I $G(ORIEN),$$GET1^DIQ(69.03,LRY,6,"I")'=ORIEN Q
        . . S LRBECDT=$$GET1^DIQ(69.03,LRY,22,"I")
        . . Q:'LRBECDT
        . . S LRBEDN="" F  S LRBEDN=$O(LRBEAR1(LRBETST,LRBEDN)) Q:LRBEDN=""  D SOP2
        . . I $D(LRBECPT)=11 S LRFDA(1,69.03,LRY,11)=1 D FILE^DIE("KS","LRFDA(1)","ERR")
        Q
        ;
SOP2    ;Process atomic test CPT code
        N OUT,LRBETSTX
        I $G(LRBESB(LRBEDN))'="" D
        . I $P(LRBESB(LRBEDN),U)="pending" Q
        . I $P(LRBESB(LRBEDN),U)="canc" Q
        . I '$G(LRBERES) Q:$P($G(LRBESB(LRBEDN)),U,13)
        . S LRBEQTY=1
        . D GPRO^LRBEBA4(LRBEDN,LRBECDT,LRSPEC,.LRBETSTX) I $G(LRBETSTX),$O(LRBECPT(LRBETSTX,0)) D
        . . D GOREF^LRBEBA21(LRODT,LRSN,LRBEDN,.LRBEAR1,.LRORREFN)
        . . S OUT=0 I $G(LRDFN),$G(LRIDT),$D(^LR(LRDFN,LRSS,LRIDT,$G(LRBEDN))) D
        . . . ;test already sent to PCE
        . . . I '$G(LRBERES) S OUT=$P(^LR(LRDFN,LRSS,LRIDT,$G(LRBEDN)),U,13) Q:OUT
        . . . ;otherwise, mark it as sent to PCE
        . . . S $P(^LR(LRDFN,LRSS,LRIDT,$G(LRBEDN)),U,13)=1
        . . ;don't continue if test already sent to PCE and not re-sending from WORK^LRBEBA4
        . . Q:OUT
        . . S LRI=0 F  S LRI=$O(LRBECPT(LRBETSTX,LRI)) Q:LRI<1  D
        . . . S LRBECPT=$O(LRBECPT(LRBETSTX,LRI,0))
        . . . S LRBEMOD=$$GMOD^LRBEBA2(LRAA,LRBECPT)
        . . . S LRBEPOS=$$GPOS(.LRBESB,LRBEDN)
        . . . D GDGX^LRBEBA21(LRBETST,LRBEDN,.LRBEAR,.LRBEAR1,.LRBEDGX)
        . . . S LRBESTG=LRBECPT_U_LRBEMOD_U_$G(LRBEDGX(LRBETST,1))_U_$G(LRBEDGX(LRBETST,2))_U_$G(LRBEDGX(LRBETST,3))
        . . . S LRBESTG=LRBESTG_U_$G(LRBEDGX(LRBETST,4))_U_LRBECDT_U_LRBEEPRO_U_LRBEOPRO_U_LRBEQTY_U_LRBEPOS
        . . . S LRBESTG=LRBESTG_U_$G(LRBEDGX(LRBETST,5))_U_$G(LRBEDGX(LRBETST,6))_U_$G(LRBEDGX(LRBETST,7))
        . . . S LRBESTG=LRBESTG_U_$G(LRBEDGX(LRBETST,8))_U_LRORREFN
        . . . I $G(LRBECPT(LRBETSTX,LRI,LRBECPT,"COUNT")) S $P(LRBESTG,U,20)=LRBECPT(LRBETSTX,LRI,LRBECPT,"COUNT")+1
        . . . S LRBEAR(LRBEDFN,"LRBEDGX",LRI,LRBEDN)=LRBESTG
        Q
        ;
GPOS(LRBESB,LRBEDN)     ; Get the Place of Service
        Q $P($G(LRBESB(LRBEDN)),U,9)
        ;
SLROT(LRXST,LRTEST,LRBEOT)      ;
        D SLROT^LRBEBA3(.LRXST,.LRTEST,.LRBEOT)
        Q
