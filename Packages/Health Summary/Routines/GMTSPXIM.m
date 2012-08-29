GMTSPXIM        ; SLC/SBW,KER - PCE Immunization component ; 05/05/2009
        ;;2.7;Health Summary;**8,10,28,56,89**;Oct 20, 1995;Build 61
        ;
        ; External References
        ;   DBIA  1239  IMMUN^PXRHS03
        ;   DBIA 10011  ^DIWP
        ;                       
IMMUN   ; Main Entry Point
        K ^TMP("PXI",$J) D IMMUN^PXRHS03(DFN) Q:'$D(^TMP("PXI",$J))
        N GMIMM,GMDT,GMIFN,GMW,GMSITE,GMN0,GMN1,GMSIR,GMSIC,X,GMTSDAT,GML
        N GMTSX,GMCKP,GMTAB,COMMENT,GMTSLN,GMICL
        S GMIMM="" D CKP^GMTSUP Q:$D(GMTSQIT)  D HDR
        F  S GMIMM=$O(^TMP("PXI",$J,GMIMM)) Q:GMIMM=""  D  Q:$D(GMTSQIT)
        . S (GMDT,GMW)=0
        . F  S GMDT=$O(^TMP("PXI",$J,GMIMM,GMDT)) Q:GMDT'>0  D  Q:$D(GMTSQIT)
        . . S GMIFN=0
        . . F  S GMIFN=$O(^TMP("PXI",$J,GMIMM,GMDT,GMIFN)) Q:GMIFN'>0  D IMMDSP Q:$D(GMTSQIT)
        K ^TMP("PXI",$J)
        Q
IMMDSP  ; Display Immunization data
        S DIWL=0,CNT=0,COMMENT="",GMN0=$G(^TMP("PXI",$J,GMIMM,GMDT,GMIFN,0)) Q:GMN0']""
        S GMN1=$G(^TMP("PXI",$J,GMIMM,GMDT,GMIFN,1))
        S GMSITE=$S($P(GMN1,U,3)]"":$P(GMN1,U,3),$P(GMN1,U,4)]"":$P(GMN1,U,4),1:"No Site")
        ;S GMSITE=$S($P(GMN1,U,3)]"":$E($P(GMN1,U,3),1,10),$P(GMN1,U,4)]"":$E($P(GMN1,U,4),1,10),1:"No Site")
        S X=$P(GMN0,U,3) D REGDT4^GMTSU S GMTSDAT=X
        S GMSIR=$P(GMN0,U,6),GMSIC=$S(+$P(GMN0,U,7):"DO NOT REPEAT",1:"")
        I GMSIC]"",GMSIR]"" S GMSIR=GMSIR_"; "
        S GMSIR=GMSIR_GMSIC
        D CKP^GMTSUP Q:$D(GMTSQIT)  D:GMTSNPG HDR
        I GMW'>0!GMTSNPG D
        .I $L($P(GMN0,U,2))>14 D  S GML=$L($P(GMN0,U,2))+1 Q
        ..I $E($P(GMN0,U,2),14)=" " W $E($P(GMN0,U,2),1,13)_"*"  Q
        ..W $E($P(GMN0,U,2),1,14)_"*"
        .W $P(GMN0,U,2) S GML=$L($P(GMN0,U,2))+1
        W ?16,$P(GMN0,U,4),?23,GMTSDAT,?35,$S($L(GMSITE)>10:$E(GMSITE,1,10)_"*",1:GMSITE)
        I GMSIR']"" W ! G COM
        I GMSIR]"" S GMICL=48,GMTAB=2,CNT=1 D FORMAT I $D(^UTILITY($J,"W")) D
        . F GMTSLN=1:1:^UTILITY($J,"W",DIWL) D LINE Q:$D(GMTSQIT)
COM     ; Comments
        S COMMENT=$P(^TMP("PXI",$J,GMIMM,GMDT,GMIFN,"COM"),U)
        I COMMENT]"" S GMICL=33,GMTAB=2,CNT=2 D FORMAT I $D(^UTILITY($J,"W")) D CKP^GMTSUP Q:$D(GMTSQIT)  D
        . F GMTSLN=1:1:^UTILITY($J,"W",DIWL) D LINE Q:$D(GMTSQIT)
        S GMW=1
        Q
HDR     ; Header
        W "Immunization",?16,"Series",?23,"Date",?35,"Facility",?48,"Reaction",!!
        Q
FORMAT  ; Format Line
        N DIWR,DIWF,X S DIWL=3,DIWR=80-(GMICL+GMTAB) K ^UTILITY($J,"W")
        S X=$S(CNT=1:GMSIR,CNT=2:"Comments: "_COMMENT) D ^DIWP
        Q
LINE    ; Writes Line
        D CKP^GMTSUP Q:$D(GMTSQIT)
        W ?($S(CNT=1:48,CNT=2:5,1:0)),^UTILITY($J,"W",DIWL,GMTSLN,0),!
        Q
