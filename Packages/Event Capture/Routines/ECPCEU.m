ECPCEU  ;BIR/JPW - ECS to PCE Utilities ;23 Jul 2008
        ;;2.0; EVENT CAPTURE ;**4,5,7,10,17,18,23,42,54,73,72,95**;8 May 96;Build 26
CLIN    ;check for active inactive clinic
        N ECCLDT
        I $L($G(ECDT))>6,+ECDT=ECDT S ECCLDT=ECDT
        I '$G(ECCLDT) S ECCLDT=DT
        K ECPCL
        I '$D(EC4) S ECPCL=0 Q
        I 'EC4 S ECPCL=0 Q
        I '$D(^SC(+EC4,"I")) S ECPCL=1 Q
        S ECPCID=+$P(^SC(+EC4,"I"),"^"),ECPCRD=+$P(^("I"),"^",2)
        I ECPCID,ECPCID'>ECCLDT I 'ECPCRD!(ECPCRD>ECCLDT) S ECPCL=0 Q
        I ECPCID,ECPCRD,ECPCRD'>ECCLDT S ECPCL=1 Q
        I ECPCID,ECPCID>ECCLDT S ECPCL=1 Q
        S ECPCL=1
        K ECPCID,ECPCRD
        Q
NITE    ;start nightly job
        K ^TMP("ECPXAPI",$J)
        D NOW^%DTC S ECCKDT=+$E(%,1,12)
        S ECPKG=$O(^DIC(9.4,"B","EVENT CAPTURE",0)),ECS="EVENT CAPTURE DATA"
        S ECJJ=0 F  S ECJJ=$O(^ECH("AD",ECJJ)) Q:'ECJJ  S ECJJ1=0 F  S ECJJ1=$O(^ECH("AD",ECJJ,ECJJ1)) Q:'ECJJ1  I $D(^ECH(ECJJ1,"PCE")) D SET
        K DA,DIE,DR,EC4,EC725,ECAO,ECCPT,ECDT,ECDX,ECHL,ECID,ECIR,ECJJ,ECJJ1,ECL,ECNODE,ECPKG,ECPS,ECS,ECSC,ECV,ECVST,ECVV,ECZEC,ECMST,ECHNC,ECCV,ECDFAPT,CNT,ECPRVARY,ECPRV,ECUSR
        K %,%H,%I,ECCKDT
        K ^TMP("ECPXAPI",$J)
        Q
SET     ;set variables
        S ECNODE=^ECH(ECJJ1,"PCE"),ECDT=$P(ECNODE,"~"),ECPS=$P(ECNODE,"~",2),ECHL=$P(ECNODE,"~",3),ECL=$P(ECNODE,"~",4),ECID=$P(ECNODE,"~",5),ECV=$P(ECNODE,"~",9),ECUSR=$P($G(^ECH(ECJJ1,0)),U,13)
        S ECCPT=$P(ECNODE,"~",10),ECDX=$P(ECNODE,"~",11),ECAO=$P(ECNODE,"~",12),ECIR=$P(ECNODE,"~",13),ECZEC=$P(ECNODE,"~",14),ECSC=$P(ECNODE,"~",15),EC725=$P(ECNODE,"~",16),ECELIG=$P(ECNODE,"~",17),ECMST=$P(ECNODE,"~",18)
        S ECHNC=$P(ECNODE,"~",19),ECCV=$P(ECNODE,"~",20)
        ; EC*2.0*73 next line added to get default appt type if defined
        S ECDFAPT="" S:$D(^SC(ECHL,"AT")) ECDFAPT=+$G(^SC(ECHL,"AT"))
TMP     ;set ^TMP for PCE call
ENC     S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"ENC D/T")=ECDT
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"PATIENT")=ECPS
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"HOS LOC")=ECHL
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"INSTITUTION")=ECL
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"APPT")=ECDFAPT  ; added EC*2.0*73
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"SC")=ECSC
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"AO")=ECAO
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"IR")=ECIR
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"EC")=ECZEC
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"MST")=ECMST
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"HNC")=ECHNC
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"CV")=ECCV
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"SERVICE CATEGORY")="X"
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"ENCOUNTER TYPE")="A"
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"DSS ID")=ECID
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"CHECKOUT D/T")=ECCKDT
        S ^TMP("ECPXAPI",$J,"ENCOUNTER",1,"ELIGIBILITY")=ECELIG
PROV    ;Set providers in ^TMP("ECPXAPI",$J,"PROVIDER",n,"NAME")=provider
        K ECPRVARY S ECPRV=$$GETPRV^ECPRVMUT(ECJJ1,.ECPRVARY),ECI=0
        ;set primary provider in ^TMP global
        F  S ECI=$O(ECPRVARY(ECI)) Q:'ECI  I $P(ECPRVARY(ECI),U,3)="P" D  Q
        .S ^TMP("ECPXAPI",$J,"PROVIDER",1,"NAME")=$P(ECPRVARY(ECI),U)
        .S ^TMP("ECPXAPI",$J,"PROVIDER",1,"PRIMARY")=1
        .S ^TMP("ECPXAPI",$J,"PROCEDURE",1,"ENC PROVIDER")=$P(ECPRVARY(ECI),U)
        .K ECPRVARY(ECI)
        ;set secondary providers in ^TMP global
        S ECI=0,CNT=2 F  S ECI=$O(ECPRVARY(ECI)) Q:'ECI  D
        .S ^TMP("ECPXAPI",$J,"PROVIDER",CNT,"NAME")=$P(ECPRVARY(ECI),U),CNT=CNT+1
        I $O(^ECH(ECJJ1,"MOD",0))'="" S ECMODF=$$MOD^ECUTL(ECJJ1,"E",.ECMOD) D
        . I ECMODF S MOD="" F  S MOD=$O(ECMOD(MOD)) Q:MOD=""  D
        . . S ^TMP("ECPXAPI",$J,"PROCEDURE",1,"MODIFIERS",MOD)=""
DX      S ^TMP("ECPXAPI",$J,"DX/PL",1,"DIAGNOSIS")=ECDX
        S ^TMP("ECPXAPI",$J,"DX/PL",1,"PRIMARY")=1
        ;Set secondary diagnosis codes in ^TMP("ECPXAPI",$J,"DX/PL",1,"DIAGNOSIS",diagnosis
        S DXS=0 F ECI=2:1 S DXS=$O(^ECH(ECJJ1,"DX",DXS)) Q:DXS=""  D
        . S DXSIEN=$G(^ECH(ECJJ1,"DX",DXS,0)) I DXSIEN="" Q
        . S ^TMP("ECPXAPI",$J,"DX/PL",ECI,"DIAGNOSIS")=DXSIEN
PROC    S ^TMP("ECPXAPI",$J,"PROCEDURE",1,"EVENT D/T")=ECDT
        S ^TMP("ECPXAPI",$J,"PROCEDURE",1,"PROCEDURE")=ECCPT
        S ^TMP("ECPXAPI",$J,"PROCEDURE",1,"QTY")=ECV
        S:EC725]"" ^TMP("ECPXAPI",$J,"PROCEDURE",1,"NARRATIVE")=EC725
MOD     ;Set modifiers in ^TMP("ECPXAPI",$J,"PROCEDURE",1,"MODIFIERS",modifier
        I $O(^ECH(ECJJ1,"MOD",0))'="" S ECMODF=$$MOD^ECUTL(ECJJ1,"E",.ECMOD) D
        . I ECMODF S MOD="" F  S MOD=$O(ECMOD(MOD)) Q:MOD=""  D
        . . S ^TMP("ECPXAPI",$J,"PROCEDURE",1,"MODIFIERS",MOD)=""
D2PCE   S VALQUIET=1,ECVV=$$DATA2PCE^PXAPI("^TMP(""ECPXAPI"",$J)",ECPKG,ECS,.ECVST,ECUSR)
        I ECVST K DA,DIE,DR S DA=ECJJ1,DIE=721,DR="25////1;31///@;28////"_ECVST_";32////"_ECCKDT D ^DIE K DA,DIE,DR
        K ^TMP("ECPXAPI",$J),ECVST,VALQUIET,MOD,ECMODF,ECMOD,ECI,DXSIEN,DXS
        K DA,D0,DIE,DR,EC725,ECAO,ECCPT,ECDT,ECDX,ECHL,ECID,ECIR,ECNODE,ECPS,ECSC,ECV,ECVV,ECZEC,ECELIG,ECMST,ECHNC,ECCV,CNT,ECPRVARY,ECPRV
        Q
        ;
PCETASK(ECPCE)  ;Set up task for transfer to PCE
        ;
        ;  Input:
        ;    ECPCE - [pass by reference] array subscripted by FM date/time
        ;            and pointer to EVENT CAPTURE PATIENT (#721) file
        ;            [ex: ECPCE(3080101.140425,611)]
        ;
        ;  Output:
        ;   Function value - Task ID on success; 0 on failure
        ;
        N ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTUCI,ZTCPU,ZTPRI,ZTSAVE,ZTKIL,ZTSYNC,ZTSK
        S ZTIO=""
        S ZTRTN="XFER2PCE^ECPCEU"
        S ZTDESC="ECS2PCE TRANSFER"
        S ZTDTH=$$NOW^XLFDT()
        S ZTSAVE("ECPCE(")=""
        D ^%ZTLOAD
        Q $S($D(ZTSK):ZTSK,1:0)
        ;
XFER2PCE        ;Task entry point for single ECS record xfer to PCE
        ;Input from Task: ECPCE -array subscripted by date and pointer
        ;                 to EVENT CAPTURE PATIENT (#721) file
        ;                 [Ex: ECPCE(3080101,611)]
        ;
        N ECPKG  ;package name
        N ECS    ;source
        N ECCKDT  ;check-out date/time
        N ECJJ   ;date iterator
        N ECJJ1  ;file #721 IEN iterator
        K ^TMP("ECPXAPI",$J)
        D NOW^%DTC S ECCKDT=+$E(%,1,12)
        S ECPKG=$O(^DIC(9.4,"B","EVENT CAPTURE",0)),ECS="EVENT CAPTURE DATA"
        S ECJJ=0 F  S ECJJ=$O(ECPCE(ECJJ)) Q:'ECJJ  D
        . S ECJJ1=0
        . F  S ECJJ1=$O(ECPCE(ECJJ,ECJJ1)) Q:'ECJJ1  D
        . . I $D(^ECH(ECJJ1,"PCE")) D SET
        K DA,DIE,DR,EC4,EC725,ECAO,ECCPT,ECDT,ECDX,ECHL,ECID,ECIR,ECJJ,ECJJ1,ECL,ECNODE,ECPKG,ECPS,ECS,ECSC,ECV,ECVST,ECVV,ECZEC,ECMST,ECHNC,ECCV,ECDFAPT,CNT,ECPRVARY,ECPRV,ECUSR
        K %,%H,%I,ECCKDT
        K ^TMP("ECPXAPI",$J)
        S ZTREQ="@"
        Q
