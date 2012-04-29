SDCO0   ;ALB/RMO - Build List Area - Check Out; 11 FEB 1993 10:00 am ; 6/22/05 12:56pm
        ;;5.3;Scheduling;**20,44,132,180,351,441**;Aug 13, 1993;Build 14
        ;
EN(SDARY,SDOE,SDSTART,SDTOT)    ;Entry point Called by Ck Out & Apt Mgr Exp Dis
        S SDTOT=0
        D CL(SDARY,SDOE,SDSTART,.SDTOT)
        D PR(SDARY,SDOE,SDSTART,.SDTOT)
        D DX(SDARY,SDOE,SDSTART,.SDTOT)
        I $P($G(^SCE(+SDOE,0)),"^",8)'=2 D SC(SDARY,SDOE,SDSTART,.SDTOT)
        Q
        ;
CL(SDARY,SDOE,SDSTART,SDTOT)    ;Build classification (Pg: 1  Row: SDSTART-SDSTART+7  Col: 1-80)
        N SDCLOEY,SDCNI,SDCNT,SDCTI,SDCTIS,SDCTS,SDEND,SDLINE,SDNA,SDVAL,X
        S SDLINE=SDSTART,SDEND=SDSTART+8
        D SET(SDARY,SDLINE," CLASSIFICATION ",5,IORVON,IORVOFF,"","","",.SDTOT)
        D CLASK^SDCO2(SDOE,.SDCLOEY)
        D SET(SDARY,SDLINE,"["_$S($D(SDCLOEY):"Required",1:"Not Required")_"]",24,"","","","","",.SDTOT)
        S SDCNT=0,SDCTIS=$$SEQ^SDCO21
        F SDCTS=1:1 S SDCTI=+$P(SDCTIS,",",SDCTS) Q:'SDCTI  D
        .S SDCNT=SDCNT+1,SDLINE=SDLINE+1
        .S:$D(SDCLOEY(SDCTI)) SDVAL=$$VAL^SDCODD(SDCTI,$P(SDCLOEY(SDCTI),"^",2)),SDNA=+$P(SDCLOEY(SDCTI),"^",3)
        .S X=$S('$D(SDCLOEY(SDCTI)):"Not Applicable",$$COMDT^SDCOU(SDOE)&(SDVAL=""):"Not Applicable",SDVAL="":"Unanswered",1:SDVAL)
        .D SET(SDARY,SDLINE,SDCNT_"  "_$J($P($G(^SD(409.41,SDCTI,0)),"^",6)_": ",32)_X,2,"","","CL",SDCNT,+$G(SDCLOEY(SDCTI))_"^"_SDCTI,.SDTOT)
        F SDLINE=SDLINE+1:1:SDEND D SET(SDARY,SDLINE,"",1,"","","","","",.SDTOT)
        Q
        ;
PR(SDARY,SDOE,SDSTART,SDTOT)    ;Build Provider (Pg: 1  Row: SDSTART+8-END  Col: 1-40)
        N SDCNT,SDLINE,SDPR,SDVPRV
        S SDLINE=SDSTART+9
        D SET(SDARY,SDLINE," PROVIDER ",5,IORVON,IORVOFF,"","","",.SDTOT)
        D SET(SDARY,SDLINE,"["_$S($$PRASK^SDCO3(SDOE)=1:"Required",1:"Not Required")_"]",18,"","","","","",.SDTOT)
        ;
        ; -- get provider data
        D GETPRV^SDOE(SDOE,"SDPR")
        S (SDCNT,SDVPRV)=0
        F  S SDVPRV=$O(SDPR(SDVPRV)) Q:'SDVPRV  D
        . S SDCNT=SDCNT+1
        . S SDLINE=SDLINE+1
        . D SET(SDARY,SDLINE,SDCNT_"  "_$$PR^SDCO31(+SDPR(SDVPRV)),2,"","","PR",SDCNT,SDVPRV_"^"_+SDPR(SDVPRV),.SDTOT)
        Q
        ;
DX(SDARY,SDOE,SDSTART,SDTOT)    ;Build Diagnosis (Pg: 1  Row: SDSTART+8-END  Col: 42-80)
        N SDCNT,SDDXS,SDDXD,SDVPOV,SDLINE,ICDVDT
        S SDLINE=SDSTART+9
        D SET(SDARY,SDLINE," DIAGNOSIS ",45,IORVON,IORVOFF,"","","",.SDTOT)
        D SET(SDARY,SDLINE,"["_$S($$DXASK^SDCO4(SDOE)=1:"Required",1:"Not Required")_"]",59,"","","","","",.SDTOT)
        ;
        ; -- get dxs data
        D GETDX^SDOE(SDOE,"SDDXS")
        S (SDCNT,SDVPOV)=0
        F  S SDVPOV=$O(SDDXS(SDVPOV)) Q:'SDVPOV  D
        . S SDCNT=SDCNT+1
        . S SDLINE=SDLINE+1
        . S ICDVDT=$S($P(SDDXS(SDVPOV),"^",3)'="":$$GET1^DIQ(9000010,$P(SDDXS(SDVPOV),"^",3),.01,"I"),1:"")
        . S SDDXD=$$DX^SDCO41(+SDDXS(SDVPOV),ICDVDT)
        . D SET(SDARY,SDLINE,SDCNT_"  "_$P(SDDXD,"^"),42,"","","","","",.SDTOT)
        . D SET(SDARY,SDLINE,$P(SDDXD,"^",2),55,"","","DX",SDCNT,SDVPOV_"^"_+SDDXS(SDVPOV),.SDTOT)
        Q
        ;
SC(SDARY,SDOEP,SDSTART,SDTOT)   ;Build Stop Codes (Pg: 2  Row: SDTOT+1  Col: 1-80)
        N SDLINE,SDONE
        F SDLINE=SDTOT+1:1:SDSTART+VALM("LINES")+1 D SET(SDARY,SDLINE,"",1,"","","","","",.SDTOT)
        D SET(SDARY,SDLINE," STOP CODES ",5,IORVON,IORVOFF,"","","",.SDTOT)
        D SET(SDARY,SDLINE,"[Stop Codes Not Required / Procedures Required]",28,"","","","","",.SDTOT)
        D AE(SDARY,SDOEP,.SDLINE,.SDTOT,.SDONE)
        S SDOE=0
        F  S SDOE=$O(^SCE("APAR",SDOEP,SDOE)) Q:'SDOE  D AE(SDARY,SDOE,.SDLINE,.SDTOT,.SDONE)
        Q
        ;
AE(SDARY,SDOE,SDLINE,SDTOT,SDONE)       ; -- add/edits
        N SDOE0,SDT,DFN,SDVIEN,CPTS,SDCNT,SDVCPT0,SDVCPT,SDSCD0,X
        S SDOE0=$G(^SCE(+SDOE,0))
        S SDT=+SDOE0
        S DFN=+$P(SDOE0,"^",2)
        S SDSC=+$P(SDOE0,U,3)
        S SDCL=+$P(SDOE0,U,4)
        S SDVIEN=+$P(SDOE0,U,5)
        ;
        ; -- quit if visit already processed
        G:$D(SDONE(SDVIEN)) AEQ
        ;
        S SDSCD0=$G(^DIC(40.7,SDSC,0))
        S SDLINE=SDLINE+1
        D SET(SDARY,SDLINE,$P(SDSCD0,"^",2)_"  "_$E($P(SDSCD0,"^"),1,30),5,"","","","","",.SDTOT)
        ;
        ; -- get cpts and loop
        D GETCPT^SDOE(SDOE,"CPTS")
        S (SDCNT,SDVCPT)=0
        N MODINFO,MODPTR,MODTEXT,PTR,MODCODE,CPTINFO,ICPTVDT
        F  S SDVCPT=+$O(CPTS(SDVCPT)) Q:'SDVCPT  D
        .; S SDVCPT0=$G(CPTS(SDVCPT))
        .; S SDCNT=SDCNT+1
        . S SDLINE=SDLINE+1
        . D SET(SDARY,SDLINE,"Procedure(s):",12,"","","","","",.SDTOT)
        .;
        .; IF $D(^ICPT(+SDVCPT0,0)) S X=^(0) D
        .; N CPTINFO
        . S ICPTVDT=$S($P(CPTS(SDVCPT),"^",3)'="":$$GET1^DIQ(9000010,$P(CPTS(SDVCPT),"^",3),.01,"I"),1:"")
        . S CPTINFO=$$CPT^ICPTCOD(+$G(CPTS(SDVCPT)),ICPTVDT,1)
        . S:CPTINFO>0 X=$P(CPTINFO,"^",2,99),X=$P(X,"^")_" x "_$P($G(CPTS(SDVCPT)),"^",16)_"  "_$P(X,"^",2)
        . S:CPTINFO'>0 X="Procedure not defined"
        . ;
        . D SET(SDARY,SDLINE,$E(X,1,40),27,"","","","","",.SDTOT)
        . ;
        . ;Retrieve Procedure (CPT) Codes and associated Modifiers
        . S PTR=0
        . F  S PTR=+$O(CPTS(SDVCPT,1,PTR)) Q:'PTR  D
        . . S MODPTR=$G(CPTS(SDVCPT,1,PTR,0))
        . . Q:'MODPTR
        . . S MODINFO=$$MOD^ICPTMOD(MODPTR,"I",ICPTVDT,1)
        . . Q:MODINFO'>0
        . . S MODCODE="-"_$P(MODINFO,"^",2)
        . . S MODTEXT=$P(MODINFO,"^",3)
        . . S SDLINE=SDLINE+1
        . . D SET(SDARY,SDLINE,MODCODE,29,"","","","","",.SDTOT)
        . . D SET(SDARY,SDLINE,MODTEXT,38,"","","","","",.SDTOT)
        . . Q
        ;
        ; -- set indicator that visit was processed
        S SDONE(SDVIEN)=""
AEQ     Q
        ;
SET(SDARY,LINE,TEXT,COL,ON,OFF,SDSUB,SDCNT,SDATA,SDTOT) ; -- set display array
        N X
        S:LINE>SDTOT SDTOT=LINE
        S X=$S($D(^TMP(SDARY,$J,LINE,0)):^(0),1:"")
        S ^TMP(SDARY,$J,LINE,0)=$$SETSTR^VALM1(TEXT,X,COL,$L(TEXT))
        D:$G(ON)]""!($G(OFF)]"") CNTRL^VALM10(LINE,COL,$L(TEXT),$G(ON),$G(OFF))
        S:$G(SDSUB)]"" ^TMP("SDCOIDX",$J,SDSUB,SDCNT,SDLINE)=SDATA,^TMP("SDCOIDX",$J,SDSUB,0)=SDCNT
        Q
