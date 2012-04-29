GMTSPXFP        ; SLC/SBW,KER - PCE Health Factors Component ; 2/22/07 1:52pm
        ;;2.7;Health Summary;**8,10,28,56,58,62,69,82**;Oct 20, 1995;Build 21
        ;
        ; External References
        ;   DBIA   1243  HF^PXRHS07
        ;   DBIA   4295  $$GET1^DIQ  (file #9999999.64, .01)
        ;   DBIA   4295  $$GET1^DIQ  (file #9999999.64, .03)
        ;   DBIA   4295  $$GET1^DIQ  (file #9999999.64, .08)
        ;   DBIA   4295  $$GET1^DIQ  (file #9999999.64), .1)
        ;   DBIA   4295  ^AUTTHF("AC")
        ;   DBIA  10011  ^DIWP
        ;
HFSEL   ; Health Factors Selected
        N HFSEG,GMTSFC,GMW,GMTSHFO Q:$O(GMTSEG(GMTSEGN,9999999.64,0))'>0
        S GMTSFC=0,GMW=0 K ^TMP("PXF",$J),^TMP("GMTSPXO",$J)
        F  S GMTSFC=$O(GMTSEG(GMTSEGN,9999999.64,GMTSFC)) Q:'GMTSFC  D
        . S HFSEG(GMTSEG(GMTSEGN,9999999.64,GMTSFC))=""
        K ^TMP("PXF",$J) D HF^PXRHS07(DFN,GMTSEND,GMTSBEG,GMTSNDM,.HFSEG)
        Q:'$D(^TMP("PXF",$J))  D REORD D CKP^GMTSUP Q:$D(GMTSQIT)  D SELECT
        Q
REORD   ; Re-Order Selected Health Factors
        N GMTSI,GMTSHFI,GMTSCAT,GMTSHFT,GMTSMCAT,GMTSHF,GMTSHFC K GMTSHFO
        S GMTSI=0 F  S GMTSI=$O(GMTSEG(GMTSEGN,9999999.64,GMTSI)) Q:+GMTSI=0  D
        . S GMTSHFI=$G(GMTSEG(GMTSEGN,9999999.64,GMTSI))
        . S GMTSCAT=$$GET1^DIQ(9999999.64,(GMTSHFI_","),.03)
        . S GMTSHFT=$$GET1^DIQ(9999999.64,(GMTSHFI_","),.1,"I") Q:'$L(GMTSHFT)
        . I GMTSHFT="C" D  Q
        . . N GMTSCAT,GMTSMCAT S GMTSMCAT=GMTSHFI N GMTSHFI
        . . S GMTSCAT=$$GET1^DIQ(9999999.64,(GMTSMCAT_","),.01) Q:'$L(GMTSCAT)
        . . S GMTSHFI=0 F  S GMTSHFI=$O(^AUTTHF("AC",+GMTSMCAT,GMTSHFI)) Q:+GMTSHFI=0  D
        . . . S GMTSHF=$$GET1^DIQ(9999999.64,(GMTSHFI_","),.01) Q:'$L(GMTSHF)
        . . . S GMTSHFC=+($O(^TMP("GMTSPXO",$J," "),-1))+1,^TMP("GMTSPXO",$J,GMTSHFC,GMTSCAT,GMTSHF)=""
        . Q:'$L(GMTSCAT)  S GMTSHF=$$GET1^DIQ(9999999.64,(GMTSHFI_","),.01) Q:'$L(GMTSHF)
        . S GMTSHFC=+($O(^TMP("GMTSPXO",$J," "),-1))+1,^TMP("GMTSPXO",$J,GMTSHFC,GMTSCAT,GMTSHF)=""
        Q
HFACT   ; Control Health Factor retrieval and display
        K ^TMP("PXF",$J) D HF^PXRHS07(DFN,GMTSEND,GMTSBEG,GMTSNDM) Q:'$D(^TMP("PXF",$J))
        D CKP^GMTSUP Q:$D(GMTSQIT)  D HFMAIN
        Q
HFMAIN  ; Display Health Factors
        N GMHFC,GMHF,GMDT,GMIFN,GMN0,GMW,X,GMTSDAT,HF,LEVEL,PHFC,COMMENT,GMICL,GMTAB,GMTSLN,GMTSFRST S GMHFC="",GMW=0,GMTSFRST=0
        F  S GMHFC=$O(^TMP("PXF",$J,GMHFC)) Q:GMHFC=""  D  Q:$D(GMTSQIT)
        . S GMHF="" F  S GMHF=$O(^TMP("PXF",$J,GMHFC,GMHF)) Q:GMHF=""  D  Q:$D(GMTSQIT)
        . . D BYDT
        K ^TMP("PXF",$J),^TMP("GMTSPXO",$J) W:GMTSFRST=0 " No data available",!
        Q
SELECT  ; Display Selected Health Factors
        N GMO,GMHFC,GMHF,GMDT,GMIFN,GMN0,GMW,X,GMTSDAT,HF,LEVEL,PHFC,COMMENT,GMICL,GMTAB,GMTSLN,GMTSFRST S GMHFC="",GMW=0,PHFC="",GMTSFRST=0
        S GMO=0 F  S GMO=$O(^TMP("GMTSPXO",$J,GMO)) Q:+GMO=0  D  Q:$D(GMTSQIT)
        . S GMHFC="" F  S GMHFC=$O(^TMP("GMTSPXO",$J,GMO,GMHFC)) Q:'$L(GMHFC)  D  Q:$D(GMTSQIT)
        . . S GMHF="" F  S GMHF=$O(^TMP("GMTSPXO",$J,GMO,GMHFC,GMHF)) Q:'$L(GMHF)  D  Q:$D(GMTSQIT)
        . . . D BYDT
        K ^TMP("PXF",$J),^TMP("GMTSPXO",$J) W:GMTSFRST=0 " No Data Available",!
        Q
BYDT    ; Display Health Factors by Date
        N GMDT,GMIFN S GMDT=0 F  S GMDT=$O(^TMP("PXF",$J,GMHFC,GMHF,GMDT)) Q:GMDT'>0  D  Q:$D(GMTSQIT)
        . S GMIFN=0 F  S GMIFN=$O(^TMP("PXF",$J,GMHFC,GMHF,GMDT,GMIFN)) Q:GMIFN'>0  D  Q:$D(GMTSQIT)
        . . D HFDSP Q:$D(GMTSQIT)
        Q
HDR     ; Display Header
        N GMTSRN Q:$D(GMTSOBJ)  Q:$D(GMTSQIT)
        D CKP^GMTSUP Q:$D(GMTSQIT)  W "Category",!
        D CKP^GMTSUP Q:$D(GMTSQIT)  W "  Health Factor ",?50,"Visit Date",! W:GMTSFRST=1 !
        Q
HFDSP   ; Display Data
        N GMTSRN,GMTSIEN
        ;VMP/RJT -- HD67936 -- HEALTH FACTORS 'DISPLAY ON HEALTH SUMMARY' PARAMETER CHECK
        S GMTSIEN=$$FIND1^DIC(9999999.64,"","X",GMHF,"B",""),GMTSRN=$$GET1^DIQ(9999999.64,GMTSIEN,.08,"I")
        Q:GMTSRN'="Y"
        I GMTSFRST=0 D HDR S GMTSFRST=1
        S GMN0=$G(^TMP("PXF",$J,GMHFC,GMHF,GMDT,GMIFN,0))
        Q:GMN0']""
        S X=$P(GMN0,U,2) D REGDT4^GMTSU S GMTSDAT=X
        S HF=$P(GMN0,U),LEVEL=$P(GMN0,U,4)
        D CKP^GMTSUP Q:$D(GMTSQIT)  D:GMTSNPG HDR D
        . I GMHFC'=$G(PHFC)!GMTSNPG D
        . . I '$D(GMTSOBJ),$G(PHFC)="",'GMTSNPG W ! D CKP^GMTSUP Q:$D(GMTSQIT)
        . . W GMHFC,! S PHFC=GMHFC
        . S GMW=1
        D CKP^GMTSUP Q:$D(GMTSQIT)
        W ?2,HF
        W:LEVEL]"" " (",LEVEL,")"
        W ?50,GMTSDAT,!
        S COMMENT="",COMMENT=$P(^TMP("PXF",$J,GMHFC,GMHF,GMDT,GMIFN,"COM"),U)
        I COMMENT]"" S GMICL=13,GMTAB=2 D FORMAT I $D(^UTILITY($J,"W")) D CKP^GMTSUP Q:$D(GMTSQIT)  D
        . F GMTSLN=1:1:^UTILITY($J,"W",DIWL) D LINE Q:$D(GMTSQIT)
        Q
FORMAT  ; Format Line
        N DIWR,DIWF,X
        S DIWL=3,DIWR=80-(GMICL+GMTAB)
        K ^UTILITY($J,"W")
        S X=COMMENT D ^DIWP
        Q
LINE    ; Write Line
        D CKP^GMTSUP Q:$D(GMTSQIT)  W ?13,^UTILITY($J,"W",DIWL,GMTSLN,0),!
        Q
