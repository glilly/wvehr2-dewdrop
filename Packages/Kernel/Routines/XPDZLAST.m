XPDZLAST ;FGO/JHS;Last Patch Installed for Package ; 12/2/05 9:15pm
 ;;8.0;KERNEL;**L33**;Jul 10, 1995
 D UCI^%ZOSV S AAQU=$P(Y,",",1)
 S RV1="$C(27,91,55,109)",RV0="$C(27,91,109)" ;Reverse Video VT100
 ;;G:AAQU="VAH" HDR
 G:AAQU="EHR" HDR
 W !!,$C(7),"This routine cannot be run on the Test (TST) system.",!,"It uses the PACKAGE file (#9.4) and the PATCH RECORD file (#437016)."
 W !,"The accurate updating of those files is only done on",!,"the Production (EHR) system.",! G EXIT
HDR W !!,"Simple Patch - Most Recently Installed -  "_AAQU_"  -  " S X=$$NOW^XLFDT S AAQDT=$$FMTE^XLFDT(X) W AAQDT,!
 D RV1NOTE W ?6,"This will display information for the Latest Version only",!,?6,"of a package, even if you select a prior version.",!
 W !,?6,"This will display National Patches only.  Local patches cannot",!,?6,"be uniquely identified in the PACKAGE file Patch History.",!
 W !,?6,"This will not display a patch that has been installed in TST only.",!
 S U="^",DIC="^DIZ(437016,",DIC(0)="AEQM",DIC("A")="Enter a package prefix or namespace: "
 D ^DIC G:Y=-1 EXIT W ! S AAQJDA=+Y,AAQJPV=$P(Y,U,2),AAQJPKG=$P(AAQJPV,"*",1),AAQOVER=$P(AAQJPV,"*",2)
 I '$D(^DIC(9.4,"C",AAQJPKG)) D RV1NOTE W "Sorry.  Package couldn't be found with "_AAQJPKG_" Prefix." G EXIT
 S X=AAQJPKG,AAQX=X S AAQNVER=$$VERSION^XPDUTL(X) D VERSION^XPDZPRE1
 I AAQOVER'=AAQNVER D RV1NOTE W "Changing to Version ",AAQNVER,! S AAQJPV=AAQJPKG_"*"_AAQNVER D REPKG
 S X=AAQJPKG,I=$O(^DIC(9.4,"C",X,0)) S:I'>0 I=$O(^DIC(9.4,"B",X,0))
 S AAQPKG=$P(^DIC(9.4,I,0),U) W !,AAQPKG," Version "_AAQNVER_" was installed "_$$FMTE^XLFDT(DATE),".",!
LAST S PKG=AAQPKG,PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VER=AAQNVER,VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)'<LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 W !,"The Most Recent Patch in the PACKAGE file Patch History is:"
 W !!,AAQJPKG_"*"_AAQNVER_"*"_PATCH_" which was installed in EHR on ",$$FMTE^XLFDT(LATEST)_".",!
INQ W !,"The option 'Inquire for Patch/Install' will run now."
 W !,"For DEVICE: Enter a printer name or press Enter for screen display.",!
 S (AAQINS,AAQDONE,AAQTST,AAQTSW)=0 S AAQPKG=AAQJPV,AAQJPKG=AAQPKG,AAQPDA=+PATCH
 I '$D(^DIZ(437016,AAQJDA,1,"B",AAQPDA)) D MANINQ G PINQX
 S X=AAQPKG,DIC="^DIZ(437016,",DIC(0)="XM" D ^DIC I +Y>0 S AAQJDA=+Y
 S AAQPDA=$P(PATCH," ") S AAQDA=0 S DA=$O(^DIZ(437016,AAQJDA,1,"B",AAQPDA,AAQDA))
 S AAQJPAT=$P(^DIZ(437016,AAQJDA,1,DA,0),"^")
 S AAQPAT=AAQJPAT D INIT^XMVVITAE D MRP^AAQJPINQ
PINQX D:$D(AAQDA) EXITA^AAQJPINQ
 G EXIT
REPKG S AAQX=0 S AAQJDA=$O(^DIZ(437016,"B",AAQJPV,AAQX))
 Q
RV1NOTE W !,@RV1,"NOTE:",@RV0,$C(7)," " Q
MANINQ W $C(7),!,"Patch ",AAQPDA," cannot be uniquely identified in the Patch Record."
 W !,"There may be one or more National TEST Patches installed."
 W !,"You need to run a Patch Inquire if more information is desired."
 W !,"Press Enter at the next prompt if you do not want a Patch Inquire.",!
 D ^AAQJPINQ
 Q
EXIT K AAQDA,AAQDONE,AAQDT,AAQINS,AAQJDA,AAQJPAT,AAQJPKG,AAQJPV,AAQOVER,AAQPAT,AAQPDA,AAQPKG,AAQNVER,AAQTST,AAQTSW,AAQU,AAQX,DA,DATE,DIC,I,LATEST,PATCH,PKG,PKGIEN,RV0,RV1,SUBIEN,VER,VERIEN,X,Y
 K D0,DN,IFN,VERSION,XCF,XCN,XMZ ;Set by called routines
 Q
