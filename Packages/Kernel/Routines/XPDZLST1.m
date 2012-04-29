XPDZLST1 ;FGO/JFW;Package File Last Patch Installed; 10-17-01 [2/18/04 12:51pm]
 ;;8.0;KERNEL;**L999**;Jul 10, 1995
 ; Copied then modified XPDZLAST(written by FGO/JHS) - 02-18-2004/JFW
 D UCI^%ZOSV S AAQU=$P(Y,",",1)
 ;S RV1="$C(27,91,55,109)",RV0="$C(27,91,109)" ;Reverse Video VT100
 G:AAQU="VAH" HDR
HDR W !!,"Package File Last Patch Installed -  "_AAQU_"  -  " S X=$$NOW^XLFDT S AAQDT=$$FMTE^XLFDT(X) W AAQDT,!
 W !!,?3,"This will display information from the PACKAGE file only.",!
HDR2 ;
 S U="^",DIC="^DIC(9.4,",DIC(0)="AEQM",DIC("A")="Enter a Package Namespace: "
 D ^DIC G:Y=-1 EXIT W ! S AAQJDA=+Y,AAQJPV=$P(Y,U,2),AAQJPKG=$P(AAQJPV,"*",1),AAQOVER=$P(AAQJPV,"*",2)
 S X=AAQJPKG,AAQX=X S AAQNVER=$$VERSION^XPDUTL(X) D VERSION^XPDZPRE1
 I AAQOVER'=AAQNVER W !,?3,"Changing to Version ",AAQNVER,! S AAQJPV=AAQJPKG_"*"_AAQNVER
 I AAQNVER<.1 W !!,"**",!,"** Invalid version found, not a valid Package entry. **",!,"**",! G HDR2
 S X=AAQJPKG,I=$O(^DIC(9.4,"C",X,0)) S:I'>0 I=$O(^DIC(9.4,"B",X,0))
 S AAQPKG=$P(^DIC(9.4,I,0),U) W !,?3,AAQPKG," Version "_AAQNVER_" was installed "_$$FMTE^XLFDT(DATE),".",!
 S AAQPREF=$P(^DIC(9.4,I,0),U,2)
 I $E(AAQJPKG,1,5)="LOCAL" W !!,?3,"Use this option for National Packages only.",! G HDR2
 I $E(AAQPREF,$L(AAQPREF))="Z" W !!,?3,"Namespace ends in Z, cannot use this option for this Namespace.",! G HDR2
LAST S PKG=AAQPKG,PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VER=AAQNVER,VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)'<LATEST S LATEST=$P(^(0),U,2),PATCH=$P($G(^(0)),U)
 ;
 I PATCH<.1 W !!,"**",!,"** No Patches for "_AAQJPKG_" were found in the Package file. **",!,"**",! G HDR2
 W !,?3,"--------------------------",!
 W !,?3,"The last patch installed for the package is:"
 W !!,?6,AAQPREF_"*"_AAQNVER_"*"_PATCH_" installed on ",$$FMTE^XLFDT(LATEST)_".",!
 W !,?3,"--------------------------",! G HDR2
 G EXIT
 Q
EXIT K AAQDA,AAQDONE,AAQDT,AAQINS,AAQJDA,AAQJPAT,AAQJPKG,AAQJPV,AAQOVER,AAQPAT,AAQPDA,AAQPKG,AAQNVER,AAQTST,AAQTSW,AAQU,AAQX,DA,DATE,DIC,I,LATEST,PATCH,PKG,PKGIEN,RV0,RV1,SUBIEN,VER,VERIEN,X,Y,AAQPREF
 K D0,DN,IFN,VERSION,XCF,XCN,XMZ ;Set by called routines
 Q
