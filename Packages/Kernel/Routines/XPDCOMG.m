XPDCOMG ;SFISC/RSD - compare globals ;08/14/2008
        ;;8.0;KERNEL;**304,506**;Jul 10, 1995;Build 11
        ;Per VHA Directive 2004-038, this routine should not be modified.
EN      D IX,FIA:'$D(DIRUT),KRN:'$D(DIRUT)
        Q
        ;
IX      ;FileMan new style cross-references
        N XPDF,XPDF2,XPDFN
        F XPDF=0:0 S XPDF=$O(^XTMP("XPDI",XPDA,"IX",XPDF)) Q:'XPDF  F XPDF2=0:0 S XPDF2=$O(^XTMP("XPDI",XPDA,"IX",XPDF,XPDF2)) Q:'XPDF2  D
        .S XPDFN="" F  S XPDFN=$O(^XTMP("XPDI",XPDA,"IX",XPDF,XPDF2,XPDFN)) Q:XPDFN=""!$D(DIRUT)  D
        ..K ^TMP($J) M ^TMP($J,1)=^XTMP("XPDI",XPDA,"IX",XPDF,XPDF2,XPDFN)
        ..D DASHES,EN^XPDCOMF($NA(^TMP($J)),$NA(^DD("IX")),.11,"1L",.DITCPT)
        ..Q
        Q
        ;
FIA     ;FileMan DD and Data
        N DIC,OLDA,XPDFIL,XPDFILO,XPDFILS,XPDS,XPDS0,XPDX,XPDX0,XPDY,XPDY1,XPDZ,XPDZ1,X,Y
        S XPDFIL=0
        F  S XPDFIL=$O(^XTMP("XPDI",XPDA,"FIA",XPDFIL)) Q:'XPDFIL!$D(DIRUT)  S XPDZ1=^(XPDFIL,0),XPDFILO=^(0,1) D
        .I '$D(^DIC(XPDFIL)) W !!," File # ",XPDFIL," is NEW",! Q
        .S XPDZ="^XTMP(""XPDI"","_XPDA,XPDY=XPDZ_",""^DIC"","_XPDFIL_","_XPDFIL_",0",XPDX=XPDY_")"
        .S XPDY=XPDY_",",XPDY1="^DIC("_XPDFIL_",0",XPDS=XPDY1_")",XPDY1=XPDY1_","
        .I $P(XPDFILO,U)="y" D
        ..;W !!,XPDUL," File # ",XPDFIL," Data Dictionary "
        ..S XPDFILS=0 F  S XPDFILS=$O(^XTMP("XPDI",XPDA,"^DD",XPDFIL,XPDFILS)) Q:'XPDFILS  D
        ...S XPDY=XPDZ_",""^DD"","_XPDFIL_","_XPDFILS,XPDX=XPDY_")",XPDY=XPDY_",",XPDY1="^DD("_XPDFILS,XPDS=XPDY1_")",XPDY1=XPDY1_","
        ...D DASHES,EN^XPDCOMF(XPDX,XPDS,0,"1L",.DITCPT)
        ...Q
        ..Q
        .;check Data in file
        .Q:'$D(^XTMP("XPDI",XPDA,"DATA",XPDFIL))
        .D DASHES,EN^XPDCOMF($NA(^(XPDFIL)),$$CREF^DIQGU(^DIC(XPDFIL,0,"GL")),XPDFIL,"1L",.DITCPT)
        W ! Q
        ;
KRN     ;Kernel Components
        N DEL,DIC,OLDA,ORD,X,XPDFIL,XPDFILNM,XPDI,XPDS,XPDS0,XPDX,XPDX0,XPDY,XPDY1,XPDZ,XPDZ1,Y
        S ORD=0
        F  S ORD=$O(^XTMP("XPDI",XPDA,"ORD",ORD)) Q:'ORD!$D(DIRUT)  S XPDFIL=+$O(^(ORD,0)),XPDFILNM=$G(^(XPDFIL,0)) D:XPDFIL
        .I $P($G(^DIC(XPDFIL,0)),U)'=XPDFILNM W !!," File "_XPDFIL_" is not "_XPDFILNM_", nothing can be installed.",! Q
        .D DASHES,EN^XPDCOMF($NA(^XTMP("XPDI",XPDA,"KRN",XPDFIL)),$$CREF^DIQGU(^DIC(XPDFIL,0,"GL")),XPDFIL,"1L",.DITCPT)
        .Q
        Q
        ;
DASHES  K DITCPT S DITCPT(0)=XPDUL
        Q
        ;
