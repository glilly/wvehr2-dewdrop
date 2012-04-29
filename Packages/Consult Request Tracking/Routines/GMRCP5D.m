GMRCP5D ;SLC/DCM,RJS,JFR - Print Consult form 513 (Gather Data - Addendums, Headers, Service reports and Comments) ;8/19/03 15:31
        ;;3.0;CONSULT/REQUEST TRACKING;**4,12,15,22,29,35,38,61**;Dec 27, 1997;Build 2
        ;
FORMAT(GMRCIFN,GMRCRD,PAGEWID)  ;
        ;
        I $L($P(GMRCRD,U,15)) D
        .I $O(^TMP("GMRCR",$J,"MCAR",0)) D
        ..N GMRCSVC
        ..S GMRCSVC=$P($G(^GMR(123.5,+$P(GMRCRD,U,5),0)),U,1)
        ..S:$L(GMRCSVC) GMRCSVC=GMRCSVC_" "
        ..;
        ..; Medicine Results?
        ..S GMRCR0=0 F  S GMRCR0=$O(^TMP("GMRCR",$J,"MCAR",GMRCR0)) Q:'GMRCR0  D
        ...D SUB("H","SREP",GMRCR0,$$CENTER(GMRCSVC_"Service Report #"_GMRCR0_" continued."))
        ...D SUB("H","SREP",GMRCR0," ")
        ...D BLD("SREP",GMRCR0,1,0,$$CENTER("Medicine Package Report"))
        ...D BLD("SREP",GMRCR0,1,0,"")
        ...N LN
        ...S LN=0 F  S LN=$O(^TMP("GMRCR",$J,"MCAR",GMRCR0,LN)) Q:'LN  D
        ....D BLD("SREP",GMRCR0,1,0,$G(^TMP("GMRCR",$J,"MCAR",GMRCR0,LN,0)))
        ;
        ; Build Processing Activities
        S GMRCR0=0 F  S GMRCR0=$O(^GMR(123,GMRCIFN,40,GMRCR0)) Q:'GMRCR0  D
        .N GMRCR1,GMRC400,CMT,USER,GMRCDT,RPRV,GMRC402,GMRCISIT
        .S GMRCR1=+$O(^GMR(123,GMRCIFN,40,GMRCR0,0)) Q:GMRCR1'=1
        .S GMRC400=$G(^GMR(123,GMRCIFN,40,GMRCR0,0))
        .S GMRC402=$G(^GMR(123,GMRCIFN,40,GMRCR0,2))
        .S CMT=$$PRCMT^GMRCP5B(+$P(GMRC400,U,2)) Q:'$L(CMT)
        .S GMRCDT=$P(GMRC400,U,3) S:'GMRCDT GMRCDT=$P(GMRC400,U,1)
        .S GMRCDT=$$EXDT(GMRCDT)_" "_$P(GMRC402,U,3)
        .;Following lines modified in patch *38
        .;I $P(^GMR(123,GMRCIFN,0),U,23) D  ;commented out
        .;.S GMRCISIT=$$GET1^DIQ(4,$P(^GMR(123,GMRCIFN,0),U,23),.01)  ;commented out
        .;.S GMRCISIT="Entered at: "_GMRCISIT  ;commented out
        .I $L(GMRC402) D  ;ADDED
        ..S GMRCISIT=$$GET1^DIQ(123,GMRCIFN,.07)  ;ADDED
        .I '$D(GMRCISIT) D  ;ADDED
        ..S GMRCISIT=$$KSP^XUPARAM("INST")  ;ADDED
        ..I GMRCISIT'="" S GMRCISIT=$$GET1^DIQ(4,GMRCISIT,.01)  ;ADDED
        ..I GMRCISIT="" S GMRCISIT=$$GET1^DIQ(123,GMRCIFN,.05)  ;ADDED
        .S GMRCISIT="Entered at: "_GMRCISIT  ;ADDED
        .;End of modifications for patch *38
        .S RPRV=$$GET1^DIQ(200,+$P(GMRC400,U,4),.01)
        .I '$L(RPRV) S RPRV=$P(GMRC402,U,2)
        .S:($L(RPRV)) RPRV="Responsible Person: "_RPRV
        .S USER=$$GET1^DIQ(200,+$P(GMRC400,U,5),.01)
        .I '$L(USER) S USER=$P(GMRC402,U)
        .S USER="Entered by: "_USER_" - "_GMRCDT
        .D SUB("H","COM",GMRCR0,CMT_" Comment ("_USER_") continued.")
        .D SUB("H","COM",GMRCR0," ")
        .D BLD("COM",GMRCR0,1,0,"")
        .D BLD("COM",GMRCR0,1,0,$$CENTER("("_CMT_" Comment)"))
        .I $P(GMRC400,U,2)=17!($P(GMRC400,U,2)=25) D
        .. N FWDLN,FWDRS
        .. S FWDLN="Forwarded from: "
        .. S FWDRS=$P($G(^GMR(123,GMRCIFN,40,GMRCR0,3)),U)
        .. I $L(FWDRS) S FWDLN=FWDLN_FWDRS
        .. I '$L(FWDRS) S FWDLN=FWDLN_$$GET1^DIQ(123.5,+$P(GMRC400,U,6),.01)
        .. D BLD("COM",GMRCR0,1,5,FWDLN)
        .D BLD("COM",GMRCR0,1,5,USER)
        .D:($L(RPRV)) BLD("COM",GMRCR0,1,5,RPRV)
        .D:($L($G(GMRCISIT))) BLD("COM",GMRCR0,1,5,GMRCISIT)
        .;
        .N GMRCR2 S GMRCR2=0
        .F  S GMRCR2=$O(^GMR(123,GMRCIFN,40,GMRCR0,GMRCR1,GMRCR2)) Q:'GMRCR2  D
        ..D BLD("COM",GMRCR0,1,0,$G(^GMR(123,GMRCIFN,40,GMRCR0,GMRCR1,GMRCR2,0)))
        ;
        Q
        ;
ADDEND(GMRCIFN,GMRCR0,GMRCNDX,GMRCRD,PAGEWID)   ;
        ;
        N GMRCADD,GMRCNDX,GMRCR1,GMRCV,TEXT,GMRCX
        ;
        S GMRCADD=0 F  S GMRCADD=$O(^TMP("GMRCR",$J,"RES",GMRCR0,"ADD",GMRCADD)) Q:'GMRCADD  D
        .N GMRCSGNM,GMRCNMDT,GMRCTIT,GMRCMODE,GMRCCSDT,GMRCCTIT,GMRCCSGM
        .;
        .F GMRCV="GMRCSGNM","GMRCNMDT","GMRCTIT","GMRCMODE" D
        ..S @GMRCV=$G(^TMP("GMRCR",$J,"RES",GMRCR0,"ADD",GMRCADD,GMRCV))
        .;
        . F GMRCV="GMRCCSDT","GMRCCTIT","GMRCCSGM","GMRCCSIG" D
        .. S @GMRCV=$G(^TMP("GMRCR",$J,"RES",GMRCR0,"ADD",GMRCADD,GMRCV))
        .S GMRCNDX=$O(^TMP("GMRC",$J,"OUTPUT","RES"," "),-1)+1
        .I $L($G(GMRCRPT)) D SUB("H","RES",GMRCNDX,"Addendum #"_GMRCADD_" To Consult Note #"_GMRCR0_" for "_GMRCRPT_" continued.")
        .I '$L($G(GMRCRPT)) D SUB("H","RES",GMRCNDX,"Addendum #"_GMRCADD_" To Consult Note #"_GMRCR0_" continued.")
        .D SUB("H","RES",GMRCNDX," ")
        .I $L($G(GMRCSGNM)) D
        ..D SUB("F","RES",GMRCNDX," ")
        ..I (GMRCMODE="electronic") S GMRCX=" Addendum Signature: "_GMRCSGNM_" /es/ "_$$EXDT($G(GMRCNMDT))
        ..I '(GMRCMODE="electronic") S GMRCX=" Addendum Author: "_GMRCSGNM S:$L($G(GMRCNMDT)) GMRCX=GMRCX_" Last edited: "_$$EXDT(GMRCNMDT)
        ..D SUB("F","RES",GMRCNDX,GMRCX)
        ..D:$L($G(GMRCTIT)) SUB("F","RES",GMRCNDX,"                     "_GMRCTIT)
        .I $L($G(GMRCCSDT)) D
        ..D SUB("F","RES",GMRCNDX," ")
        ..I (GMRCCSGM="electronic") S GMRCX=" Addendum CoSignature: "_GMRCCSIG_" /es/ "_$$EXDT(GMRCCSDT)
        ..I '(GMRCCSGM="electronic") S GMRCX=" Addendum CoSignature: "_GMRCCSIG_" /chart/ "_$$EXDT(GMRCCSDT)
        ..D SUB("F","RES",GMRCNDX,GMRCX)
        ..D:$L($G(GMRCCTIT)) SUB("F","RES",GMRCNDX,"                       "_GMRCCTIT)
        .D BLD("RES",GMRCNDX,1,0," ")
        .I $L($G(GMRCRPT)) D BLD("RES",GMRCNDX,1,0,$$CENTER("ADDENDUM #"_GMRCADD_" TO CONSULT NOTE #"_GMRCR0_" FOR "_GMRCRPT))
        .I '$L($G(GMRCRPT)) D BLD("RES",GMRCNDX,1,0,$$CENTER("ADDENDUM #"_GMRCADD_" TO CONSULT NOTE #"_GMRCR0))
        .D BLD("RES",GMRCNDX,1,0," ")
        .S GMRCR1=0 F  S GMRCR1=$O(^TMP("GMRCR",$J,"RES",GMRCR0,"ADD",GMRCADD,GMRCR1)) Q:'GMRCR1  D
        ..D BLD("RES",GMRCNDX,1,0,$G(^TMP("GMRCR",$J,"RES",GMRCR0,"ADD",GMRCADD,GMRCR1,0)))
        Q
        ;
HDR     ; Header code for form 513
        ;
        N PG,GMRCFROM
        ;
        F PG=0,1 D
        .D BLD("HDR",PG,1,0,GMRCDVL)
        .D BLD("HDR",PG,1,6,"MEDICAL RECORD")
        .D BLD("HDR",PG,0,29,"|")
        .D BLD("HDR",PG,0,36,"CONSULTATION SHEET")
        .I PG D BLD("HDR",PG,0,60,"Page ","GMRCPG,65") I 1
        .E  I '$G(GMRCGUI) D BLD("HDR",PG,0,60,"Page ","GMRCPG,65")
        .;
        .D BLD("HDR",PG,1,0,GMRCDVL)
        .D BLD("HDR",PG,1,0,"Consult Request: "_$$CONSRQ(GMRCIFN))
        .D BLD("HDR",PG,1,55,"|Consult No.: "_GMRCIFN)
        .;
        D BLD("HDR",1,1,0,GMRCEQL)
        D BLD("HDR",0,1,0,GMRCDVL)
        ;
        I $G(CMT) D BLD("HDR",0,1,27,"("_$$PRCMT^GMRCP5B(CMT)_")") Q
        ;
        S GMRCFROM=$P($G(^SC(+$P(GMRCRD,U,6),0)),U,1)
        ;
        I '$L(GMRCFROM) D
        .N VAIN
        .D INP^VADPT
        .S GMRCFROM=$P($G(VAIN(4)),U,2)
        .I $L($G(VAIN(5))) S GMRCFROM=GMRCFROM_" (Rm/Bd: "_$G(VAIN(5))_" )"
        ;No location, IFC - consulting site
        I '$L(GMRCFROM),$P(GMRCRD,U,23),$P($G(GMRCRD(12)),U,5)="F" D
        .I $P(GMRCRD,U,21) S GMRCFROM=$$GET1^DIQ(4,$P(GMRCRD,U,21),.01)
        .E  S GMRCFROM=$$GET1^DIQ(4,$P(GMRCRD,U,23),.01)
        ;
        D BLD("HDR",0,1,0,"To: "_$P($G(^GMR(123.5,+$P(GMRCRD,U,5),0)),U,1))
        D BLD("HDR",0,1,5,"From: "_GMRCFROM)
        D BLD("HDR",0,0,49,"|Requested: "_$$EXDT($P(GMRCRD,U,7)))
        ;
        D BLD("HDR",0,1,0,GMRCDVL)
        D BLD("HDR",0,1,0,"Requesting Facility: "_$E(GMRCFAC,1,22))
        I $P(GMRCRD,U,11) D BLD("HDR",0,0,45,"|ATTENTION: "_$E($P($G(^VA(200,+$P(GMRCRD,U,11),0)),U,1),1,21))
        I $P(GMRCRD,U,23) D
        . D BLD("HDR",0,1,0,"Remote Consult No.: "_GMRCINO)
        . D BLD("HDR",0,1,0,"Role: "_GMRCIRL)
        D BLD("HDR",0,1,0,GMRCEQL)
        ;
        Q
        ;
CENTER(X)       ;
        ;
        N TEXT,COL
        S COL=35-($L(X)\2) Q:(COL<1) X
        S $E(TEXT,COL)=X
        Q TEXT
        ;
BLD(SUB,NDX,LINE,TAB,TEXT,RUNTIME)      ;
        ;
        Q:'$L($G(SUB))
        N LINECNT
        ;
        F LINECNT=1:1:+LINE S ^TMP("GMRC",$J,"OUTPUT",SUB,NDX,$$LASTLN(SUB,NDX)+1,0)=""
        ;
        S $E(^TMP("GMRC",$J,"OUTPUT",SUB,NDX,$$LASTLN(SUB,NDX),0),TAB+1)=TEXT
        I $L($G(RUNTIME)) S ^TMP("GMRC",$J,"OUTPUT",SUB,NDX,$$LASTLN(SUB,NDX),1)=RUNTIME
        ;
        S GMRCLAST=SUB
        Q
        ;
SUB(ZONE,SUB,NDX,TEXT)  ;
        ;
        N NEXT
        S NEXT=$O(^TMP("GMRC",$J,"OUTPUT",SUB,NDX,ZONE," "),-1)+1
        S ^TMP("GMRC",$J,"OUTPUT",SUB,NDX,ZONE,NEXT,0)=TEXT
        Q
        ;
LASTLN(SUB,NDX) ;
        Q +$O(^TMP("GMRC",$J,"OUTPUT",SUB,NDX," "),-1)
        ;
CONSRQ(IFN)     ;
        ;
        N PTR,LINK,REF,GMRCRQ
        I +$P(^GMR(123,+IFN,0),U,8) D
        . S GMRCRQ=$P(^GMR(123,+IFN,0),U,8)
        . S GMRCRQ=$$GET1^DIQ(123.3,+GMRCRQ,.01)
        . I '$L(GMRCRQ) S GMRCRQ="Procedure"
        I $L($G(GMRCRQ)) Q GMRCRQ
        I $L($G(^GMR(123,IFN,1.11))) D
        . N SERV,TYPE
        . S SERV=$$UP^XLFSTR($$GET1^DIQ(123.5,$P(^GMR(123,IFN,0),U,5),.01))
        . S TYPE=$$UP^XLFSTR(^GMR(123,IFN,1.11)) I TYPE'=SERV D
        . I TYPE'=SERV S GMRCRQ=$E(^GMR(123,IFN,1.11),1,36)
        Q:$L($G(GMRCRQ)) GMRCRQ Q "Consult"
        ;
EXDT(X) ;EXTERNAL DATE FORMAT
        ;
        N DATE,TIME,HR,MN,PD,Y,%DT
        Q:'$L(X) ""
        I '(X?7N.1".".6N) S %DT="PTS" D ^%DT S X=Y
        Q $$FMTE^XLFDT(X,"5PMZ")
        ;
