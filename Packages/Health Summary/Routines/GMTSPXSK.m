GMTSPXSK        ; SLC/SBW,KER - PCE Skin Test comp ; 05/04/2009
        ;;2.7;Health Summary;**8,10,28,56,89**;Oct 20, 1995;Build 61
        ;
        ; External References
        ;   DBIA  1240  SKIN^PXRHS04
        ;   DBIA 10011  ^DIWP
        ;
SKIN    ; Main Entry Point
        K ^TMP("PXS",$J) D SKIN^PXRHS04(DFN) Q:'$D(^TMP("PXS",$J))
        D CKP^GMTSUP Q:$D(GMTSQIT)  D HDR
        N GMSK,GMDT,GMIFN,GMW,GMSITE,GMSKIN,GMN0,GMN1,GMRDG,X,GMTSDAT,GMRES
        N COMMENT,GMICL,GMRDT,GMTSLN,GMTAB S GMSK=""
        F  S GMSK=$O(^TMP("PXS",$J,GMSK)) Q:GMSK=""  D  Q:$D(GMTSQIT)
        . S (GMDT,GMW)=0
        . F  S GMDT=$O(^TMP("PXS",$J,GMSK,GMDT)) Q:GMDT'>0  D  Q:$D(GMTSQIT)
        . . S GMIFN=0
        . . F  S GMIFN=$O(^TMP("PXS",$J,GMSK,GMDT,GMIFN)) Q:GMIFN'>0  D SKINDSP Q:$D(GMTSQIT)
        K ^TMP("PXS",$J)
        Q
HDR     ; Display Header
        W ?36," -  Date  - ",!
        W "Skin Test",?12,"Reading",?21,"Results",?33,"Admin.",?45,"Reading",?57,"Facility",!!
        Q
SKINDSP ; Display Skin Test Data
        S GMN0=$G(^TMP("PXS",$J,GMSK,GMDT,GMIFN,0)) Q:GMN0']""
        S GMN1=$G(^TMP("PXS",$J,GMSK,GMDT,GMIFN,1))
        S GMSITE=$S($P(GMN1,U,3)]"":$P(GMN1,U,3),$P(GMN1,U,4)]"":$P(GMN1,U,4),1:"No Site")
        ;S GMSITE=$S($P(GMN1,U,3)]"":$E($P(GMN1,U,3),1,10),$P(GMN1,U,4)]"":$E($P(GMN1,U,4),1,10),1:"No Site")
        S X=$P(GMN0,U,2) D REGDT4^GMTSU S GMTSDAT=X
        S GMSKIN=$P(GMN0,U),GMRDG=$P(GMN0,U,5)
        S X=$P(GMN0,U,6) D REGDT4^GMTSU S GMRDT=X
        I GMRDG]"" S GMRDG=$J(GMRDG,2)_" mm"
        S GMRES=$P(GMN0,U,4)
        I GMRDG']"",GMRES']"" S GMRES="UNREPORTED"
        ;D CKP^GMTSUP Q:$D(GMTSQIT)  D:GMTSNPG HDR W:GMW'>0!GMTSNPG GMSKIN W ?15,GMRDG,?24,GMRES,?35,GMTSDAT,?47,GMRDT,?62,$E(GMSITE,1,17),!
        D CKP^GMTSUP Q:$D(GMTSQIT)  D:GMTSNPG HDR
        W:GMW'>0!GMTSNPG GMSKIN
        W ?12,GMRDG,?21,GMRES,?33,GMTSDAT,?45,GMRDT,?57,$S($L(GMSITE)>16:$E(GMSITE,1,16)_"*",1:GMSITE),!
        S COMMENT=$P($G(^TMP("PXS",$J,GMSK,GMDT,GMIFN,"COM")),U)
        I COMMENT]"" S GMICL=5,GMTAB=2 D FORMAT I $D(^UTILITY($J,"W")) D
        . F GMTSLN=1:1:^UTILITY($J,"W",DIWL) D LINE Q:$D(GMTSQIT)
        S GMW=1
        Q
FORMAT  ; Format Line
        N DIWR,DIWF,X S DIWL=3,DIWR=80-(GMICL+GMTAB) K ^UTILITY($J,"W")
        S X="Comments: "_COMMENT D ^DIWP
        Q
LINE    ; Write Line
        D CKP^GMTSUP Q:$D(GMTSQIT)  W ?5,^UTILITY($J,"W",DIWL,GMTSLN,0),!
        Q
