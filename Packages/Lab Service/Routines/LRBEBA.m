LRBEBA  ;DALOI/JAH/FHS - SCI, EI, AND LRBEDGX QUESTIONS ;8/10/04
        ;;5.2;LAB SERVICE;**291,352,315**;Sep 27, 1994;Build 25
        ;
        ; This routine contains the questions to be asked for 
        ; Service Connected Indicator, Environmental Indicator,
        ; and Diagnosis.
        ;
        ; Reference to EN^DDIOL supported by IA #10142
        ; Reference to ^DIC supported by IA #10006
        ; Reference to $$GET1^DIQ supported by IA #2056
        ; Reference to ^DIR supported by IA #10026
        ; Reference to ^ICD9 supported by IA #10082
        ; Reference to ^DIC(9.4 supported by IA #10048
        ;
QUES(LRBEDFN,LRBESMP,LRBESPC,TST,DT,LRBEAR,LRBEDP)      ; Start asking questions
        N DIC,DIR,DTOUT,DUOUT,DIRUT,LRBEFMSG,LRBEST,LRBEQT,LRTMP,X,Y
        S:$G(LRBEALO)="" LRBEALO=0 S (LRBEST,LRBEQT)=0
        F  D  Q:LRBEQT
        .;ensure it's active on the date of encounter
        .;S DIC("S")="I $$STATCHK^ICDAPIU(Y,DT)" 
        .S LRBEFMSG=" ICD-9 CODE: "
        .S DIC("A")="Select "_$S(LRBEALO=0:"Primary",1:"Secondary")_LRBEFMSG
        .S DIC="^ICD9(",DIC(0)="AMEQZ" D ^DIC
        .I $D(DTOUT)!($D(DUOUT)) S (LRBEST,LRBEQT)=1 K DIC,LRBEAR Q:LRBEQT
        .I +Y<1 K DIC S LRBEQT=1 Q:LRBEQT
        .S LRBEDGX=+Y,LRTMP=$P(Y(0),U,1,2)_U
        .S LRTMP=LRTMP_$P($$ICDDX^ICDCODE(+LRTMP,,,1),U,4)
        .S LRBEAR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,TST,LRBEDGX)=LRTMP
        .S:'LRBEALO $P(LRBEAR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,TST,LRBEDGX),U,12)=1
        .S LRBEALO=1 D SCI(LRBEDFN,DT,.LRBEQT) Q:LRBEQT
        K LRBEALO
        Q LRBEST
        ;
SCI(LRBEDFN,LRBECDT,LRBEQT)     ; Ask the Indicator Questions
        N DIR,DTOUT,DUOUT,DIRUT,I,LRBEA,LRBEB,LRBEBL,LRBESEG,LRBECLY,Y
        I $D(LRBEDP(LRBEDGX)) D  Q
        .S LRBEBL=$L($G(LRBEDP(LRBEDGX)),U)
        .S LRBEB=$P(LRBEDP(LRBEDGX),U,4,LRBEBL)
        .S $P(LRBEAR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,TST,LRBEDGX),U,4,LRBEBL)=LRBEB
        D CL^SDCO21(LRBEDFN,LRBECDT_".2359","",.LRBECLY)
        S LRBESEG="3,7,1,2,4,8,5,6"
        F I=1:1:$L(LRBESEG,",") S LRBEA=+$P(LRBESEG,",",I) D  Q:LRBEQT
        .I $D(LRBECLY(LRBEA)) D  Q:LRBEQT
        ..S DIR("A")="  "_$$GETI(LRBEA)
        ..S DIR(0)="YO" D ^DIR
        ..I $D(DTOUT)!($D(DUOUT)) S (LRBEST,LRBEQT)=1 K DIC,LRBEAR Q:LRBEQT
        ..I +Y=-1 S LRBEQT=1 Q:LRBEQT
        ..S $P(LRBEAR(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,TST,LRBEDGX),U,LRBEA+3)=Y
        ..S $P(LRBEDP(LRBEDGX),U,LRBEA+3)=Y
        Q
        ;
GETI(LRBEA)     ; Get type of Indicator
        N LRBEX,LRBEQUES,LRBEQUS1
        S LRBEQUES="Was treatment related to ",LRBEQUS1="Was treatment for a "
        S:LRBEA=1 LRBEX=LRBEQUES_"Agent Orange exposure"
        S:LRBEA=2 LRBEX=LRBEQUES_"Ionizing Radiation exposure"
        S:LRBEA=3 LRBEX=LRBEQUS1_"Service Connected condition"
        S:LRBEA=4 LRBEX=LRBEQUES_"service in SW Asia"
        S:LRBEA=5 LRBEX=LRBEQUES_"Military Sexual Trauma"
        S:LRBEA=6 LRBEX=LRBEQUES_"Head and Neck Cancer"
        S:LRBEA=7 LRBEX=LRBEQUES_"Combat Vet"
        S:LRBEA=8 LRBEX=LRBEQUES_"Shipboard Hazard And Defense"
        Q LRBEX
        ;
ERRMSG(MT)      ; Display Error Message
        N LRBEAST,LRBEFMT,LRBELIN,LRBEMS
        S:MT=-1 LRBEMS="An error occurred. Data may or may not have been processed."
        S:MT<-1 LRBEMS="No data was processed."
        S LRBEMS="* "_LRBEMS_" *",LRBEAST="",$P(LRBEAST,"*",80)="",LRBEFMT="!?"_((80-$L(LRBEMS))/2)
        S LRBELIN=$E(LRBEAST,1,$L(LRBEMS)+1)
        D EN^DDIOL(LRBELIN,"",LRBEFMT),EN^DDIOL(LRBEMS,"",LRBEFMT),EN^DDIOL(LRBELIN,"",LRBEFMT)
        Q
        ;
SDG1(LRODT,LRSN,LRTN,LRSAMP,LRSPEC,LRTSTS,LRBEAR)       ; Set the diagnois 
        ;                             and indicators file #69
        N LRBEFIL,LRBEIEN,LRBEDFN,LRFDA,LRFDAIEN,LRERR,LRBEPDGX,LRBETNUM
        N LRDA,LRBEP,DIK,DA
        S DIK="^LRO(69,"_LRODT_",1,"_LRSN_",2,"_LRTN_",2,"
        S LRDA=0 F  S LRDA=$O(^LRO(69,LRODT,1,LRSN,2,LRTN,2,LRDA)) Q:LRDA<1  D
        . S DA=LRDA D ^DIK
        K DA,DIK
        S LRBEP=0
        I '$D(DFN) S LRBEDFN=$$GET1^DIQ(63,LRDFN,.03,"I")
        S:$D(DFN) LRBEDFN=DFN
        S LRBEFIL=69.05,LRBETNUM=$O(^LRO(69,LRODT,1,LRSN,2,LRTN,2,""),-1)+1,LRBEPDGX=""
        F  S LRBEPDGX=$O(LRBEAR(LRBEDFN,"LRBEDGX",LRSAMP,LRSPEC,LRTSTS,LRBEPDGX)) Q:LRBEPDGX=""  D
        .S LRBEPTDT=$G(LRBEAR(LRBEDFN,"LRBEDGX",LRSAMP,LRSPEC,LRTSTS,LRBEPDGX))
        .I 'LRBEP,'$P(LRBEPTDT,U,12) Q
        .S LRBEP=1
        .S LRBEIEN="+"_LRBETNUM_","_LRTN_","_LRSN_","_LRODT_","
        .S LRFDAIEN(LRBETNUM)=LRBETNUM
        .S LRFDA(99,LRBEFIL,LRBEIEN,.01)=LRBEPDGX
        .S:$P(LRBEPTDT,U,6)'="" LRFDA(99,LRBEFIL,LRBEIEN,1)=$P(LRBEPTDT,U,6)
        .S:$P(LRBEPTDT,U,10)'="" LRFDA(99,LRBEFIL,LRBEIEN,2)=$P(LRBEPTDT,U,10)
        .S:$P(LRBEPTDT,U,4)'="" LRFDA(99,LRBEFIL,LRBEIEN,3)=$P(LRBEPTDT,U,4)
        .S:$P(LRBEPTDT,U,5)'="" LRFDA(99,LRBEFIL,LRBEIEN,4)=$P(LRBEPTDT,U,5)
        .S:$P(LRBEPTDT,U,7)'="" LRFDA(99,LRBEFIL,LRBEIEN,5)=$P(LRBEPTDT,U,7)
        .S:$P(LRBEPTDT,U,8)'="" LRFDA(99,LRBEFIL,LRBEIEN,6)=$P(LRBEPTDT,U,8)
        .S:$P(LRBEPTDT,U,9)'="" LRFDA(99,LRBEFIL,LRBEIEN,7)=$P(LRBEPTDT,U,9)
        .S:$P(LRBEPTDT,U,11)'="" LRFDA(99,LRBEFIL,LRBEIEN,9)=$P(LRBEPTDT,U,11)
        .S:$P(LRBEPTDT,U,12)=1 LRFDA(99,LRBEFIL,LRBEIEN,8)=1         ;Is Primary?
        .S LRBETNUM=LRBETNUM+1
        .I $P(LRBEPTDT,U,12) K LRBEAR(LRBEDFN,"LRBEDGX",LRSAMP,LRSPEC,LRTSTS,LRBEPDGX) S LRBEPDGX=""
        D UPDATE^DIE("","LRFDA(99)","LRFDAIEN","LRERR")
        Q
        ;
SDOS(LRODT,LRSN,LRTN,LRBECDT)   ; Set DOS for CIDC
        N LRBEIEN,LRFDA,LRERR
        S LRBEIEN=LRTN_","_LRSN_","_LRODT_",",LRFDA(99,69.03,LRBEIEN,22)=LRBECDT
        D UPDATE^DIE("","LRFDA(99)","","LRERR")
        Q
        ;
CCPT(LRBECPT,LRBECDT,LRBEAR)    ; Check the status of the CPT (CSV)
        ;
        ; Input:
        ;  LRBECPT  -  CPT
        ;  LRBECDT   -  Date To Be Checked ; Collection date/time
        ;  LRBEAR   -  An array passed by reference to hold IEN and Status
        ;
        ; Output:
        ;  ST       -  Status of CPT (Active (1),Inactive (0), or Invalid (-1))
        ;  LRBEAR   -  An array passed by reference to hold IEN and Status
        ;   LRBEAR(CPT)=IEN^NAME^EFFECTIVE DAT^STATUS 
        ;
        N LRBEST,LRBEPTDT
        S LRBEST=""
        S LRBEPTDT=$$CPT^ICPTCOD(LRBECPT,LRBECDT)
        S LRBEST=$P(LRBEPTDT,U,7) I 'LRBEST S LRBEST=-1 Q LRBEST
        S LRBEAR(LRBECPT)=$P(LRBEPTDT,U,1)_U_$P(LRBEPTDT,U,3)_U_$P(LRBEPTDT,U,6)_U_LRBEST
        Q LRBEST
        ;
EMSGCPT(LRBEAR) ; Print out Inactive CPTs
        N CNAM,LRBEASK,LRBEFMT,LRBELIN,LRBECPT,LRBEMS,LRBEMS2,LRBEMS3,LRBEMSG,LRBESP
        S LRBEMSG="Please contact HISYS to correct the Inactive CPTs: "
        S LRBEMS="*  "_LRBEMSG_"  *",LRBEAST="",$P(LRBEAST,"*",80)="",LRBEFMT="!?"_((80-$L(LRBEMS))/2)
        S LRBESP="",$P(LRBESP," ",80)="",LRBELIN=$E(LRBEAST,1,$L(LRBEMS))
        S LRBEMS2="*  "_$E(LRBESP,1,$L(LRBEMSG))_"  *"
        D EN^DDIOL(LRBELIN,"","!"_LRBEFMT),EN^DDIOL(LRBEMS,"",LRBEFMT),EN^DDIOL(LRBEMS2,"",LRBEFMT)
        S LRBECPT="" F  S LRBECPT=$O(LRBEAR(LRBECPT)) Q:LRBECPT=""  D
        .Q:$P(LRBEAR(LRBECPT),U,4)'=0
        .S CNAM=$P(LRBEAR(LRBECPT),U,2)
        .S LRBEMS3="*     "_LRBECPT_$E(LRBESP,1,15-$L(LRBECPT))_$E(CNAM,1,30)
        .S LRBEMS3=LRBEMS3_$E(LRBESP,1,($L(LRBEMS)-$L(LRBEMS3))-1)_"*"
        .D EN^DDIOL(LRBEMS3,"",LRBEFMT)
        D EN^DDIOL(LRBEMS2,"",LRBEFMT),EN^DDIOL(LRBELIN,"",LRBEFMT)
        Q
        ;
BAWRK(LRODT,LRSN,LRI,LRBEY,LRTEST,LRBEDEL,LRBEVST,LRBEROLL,ORIEN)       ; Send the Billing Information to PCE
        ;input LRBEROLL = 1, if processing from routine LRBEBA5 for roll-up to PCE
        ;input ORIEN = OERR Order #; only passed from WORK^LRBEBA4
        Q:$G(LRCHG)=1
        K ^TMP("LRPXAPI",$J),LRBEAR,LRBEAR1,LRBECPT
        N D0,DA,DIC,DIE,DIR,I,T,X1,X2,X3,X9,Z,Z1,Z2,CNT,VADM,VAIN
        N LRBETEST,LRTN,LRBESB,LRBETST,LRBEPAN,LRBEMSG,LRDBEDGX,LRBESEQ,LRNOP,LRX
        N PXBREQ,LRVN,PXKDONE
        I '$G(LRPKG) D
        . S LRPKG=$$FIND1^DIC(9.4,,"B","LAB SERVICE","B","","ERR")
        I LRPKG<1 D  Q
        . D EN^DDIOL("PCE Error Condition -  Lab Service package not installed","","!")
        N LRBEAR,LRBEDFN,LRBECDT,LRBEU,LRBEX,LRBEZ,LRBETYP,LRBECDT
        N LRBENO,LRBEMOD,LROOS,LRPCECNT,LRI,X,Y,USR
        M LRBETEST=LRTEST
        M LRBESB=LRSB
        S LROOS=$$GET1^DIQ(68,LRAA,.8,"I") I 'LROOS S LROOS=$$GET1^DIQ(69.9,1,.8,"I")
        S LRBEMOD=$$GMOD^LRBEBA2(LRAA)
        S LRBEDEL=$G(LRBEDEL)
        I $G(LRDFN) S:'$G(DFN) DFN=$$GET1^DIQ(63,LRDFN_",",.03,"I")
        S LRBEDFN=DFN
        S:'$G(LRBEVST) LRBEVST=$P($G(^LRO(69,LRODT,1,LRSN,"PCE")),";")
        S (LRBECDT,LRBEDT)=$J($$GET1^DIQ(69.01,LRSN_","_LRODT_",",10,"I"),7,4)
        S I=0 F  S I=$O(LRBETEST(I)) Q:I<1  D
        . S LRBETST=$P(LRBETEST(I),U,1)
        . S LRTN=$O(^LRO(69,LRODT,1,LRSN,2,"B",LRBETST,0))
        . I LRTN D SDOS(LRODT,LRSN,LRTN,LRBECDT)
        G:$G(LRBENO) KILL
        D BLDAR^LRBEBA3(LRBEDFN,LRODT,LRSN,.LRBEAR,.LRBEY,.LRBETEST,.LRBEPAN,LRBEDEL) G:$G(LRBENO) KILL
        D STDN^LRBEBA2(LRODT,LRSN,.LRBETEST,.LRBEY) G:$G(LRBENO) KILL
        D SOP^LRBEBA2(LRBEDFN,.LRBESB,.LRBEY,.LRBEPAN,$G(LRBEROLL)) G:$G(LRBENO) KILL
        I $D(LRBECPT)>1 D
        .D OPORD^LRBEBAO Q:$G(LRBENO)
        .D OPRES^LRBEBAO(.LRBEAR,.LRBEAR1,LRODT,LRSN,LRBEVST)
KILL    ;
        K ^TMP("LRPXAPI",$J)
        K LRPKG,LRBEDIA,LRBEVSIT,LRBEAR,LRBEAR1,LRBEDEL,LRBEDT,LRBEPOS
        K LRBEIEN,LRBEMOD,LRBEPTDT,LRBETM,LRBEDN,LRBESMP,LRBESPC,LRBEDGX,LRBEVST,LROOS,LRBERES
        K ERRDIS,INROOT,SRC,SUB1,SUB2,SUB3,USR
        I '$G(LRBEROLL) K LRBECPT,LRBEY
        Q
        ;
GEDT(LRODT,LRSN,LRBETST)        ; Get the Date of Service
        N X,Y,LRBEIEN,DIC,LRBEEDT
        S LRBEEDT=""
        S X=$$GET1^DIQ(60,LRBETST_",",.01)
        S DIC="^LRO(69,"_LRODT_",1,"_LRSN_",2,"
        S DIC(0)="Z" D ^DIC I +Y<0 K DIC Q 0
        S LRBEIEN=+Y_","_LRSN_","_LRODT_","
        S LRBEEDT=$$GET1^DIQ(69.03,LRBEIEN,22,"I")
        Q LRBEEDT
        ;
GCDT(LRODT,LRSN)        ; Get the collection date/time
        N LRBECDT,LRBEIEN
        S LRBECDT=""
        S LRBEIEN=LRSN_","_LRODT_","
        S LRBECDT=$$GET1^DIQ(69.01,LRBEIEN,10,"I")
        Q LRBECDT
