XPDZIB ;FGO/JHS;Revised KIDS Backup ; 11-09-98 [9/3/99 6:58am]
 ;;8.0;KERNEL;**L33**;Jul 10, 1995
 N XCNP,DIF,DIR,DIRUT,XMSUB,XMDUZ,XMDISPI,XMZ,XPD,XPDA,XPDNM,XPDQUIT,XPDST,XPDT,X,Y,%
 I $D(AAQPAT) S AAQP=AAQPAT G SET ;Used when called from AAQMENU
READ W !,"Enter Patch Name in the format Namespace*Version*Patch,"
 W !,"or Enter Package Name in the format Package{space}Version: " R AAQP:DTIME I '$T!(AAQP["^") W $C(7),!!,"Patch or Package Name was not entered.  No backup message was created." H 2 Q
 I AAQP="" W !!,"Enter Patch Name or '^' to Exit.",! G READ
 G:AAQP'["*" PKG
 G:$P(AAQP,"*",1)["Z" CKLOC
 I $P(AAQP,"*",1)'?2.4UN W $C(7),!!,"Namespace must be 2-4 Uppercase or Numeric with first character being Alpha." G READ
 G CKVER
CKLOC I $P(AAQP,"*",1)'?2.4UN1"Z" W $C(7),!!,"Namespace for a LOCAL Patch must be 2-4 Uppercase or Numeric",!,"characters with the first being Alpha and last character a 'Z'." G READ
CKVER I $P(AAQP,"*",2,3)?1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.6N G SET
 G VER
PKG I $P(AAQP," ",2)?1.2N1"."1.2N.1(1"V",1"T").2N G SET
VER W $C(7),!!,"Version number must include at least one whole number and decimal position.",! G READ
SET S %="I '$P(^(0),U,9),$D(^XPD(9.7,""ASP"",Y,1,Y)),$D(^XTMP(""XPDI"",Y))",XPDST=$$LOOK^XPDI1(%)
 Q:'XPDST!$D(XPDQUIT)
 D UCI^%ZOSV S AAQUCI=$P(Y,",",1),AAQPAT=$P(XPDT("1"),U,2)
 S XMSUB="BEFORE "_AAQPAT_" from "_AAQUCI,AAQSUB=XMSUB K AAQUCI,AAQPAT
 S XMDUZ="SIMPLE PATCH - "_$P(^VA(200,DUZ,0),U,1),XMY(DUZ)="",AAQXMY=$P(^VA(200,DUZ,0),U,1)
 D XMZ^XMA2 I XMZ<1 D QUIT^XPDI1(XPDST) Q
 S Y=$$NOW^XLFDT,%=$$DOW^XLFDT(Y),Y=$$FMTE^XLFDT(Y,2)
 S X="PACKMAN BACKUP Created on "_%_", "_$P(Y,"@")_" at "_$P(Y,"@",2)
 I $D(^VA(200,DUZ,0)) S X=X_" by "_$P(^(0),U)_" "
 S:$D(^XMB("NAME")) X=X_"at "_$P(^("NAME"),U)_" "
 S ^XMB(3.9,XMZ,2,0)="^3.92A^^^"_DT,^(1,0)="$TXT "_X,XCNP=1
 I $D(^VA(200,"B","PATCHES,ALL D")) S XMY("PATCHES,ALL D")="",AAQXMY=AAQXMY_" and PATCHES,ALL D"
 S XPDT=0,AAQROU=0
 F  S XPDT=$O(XPDT(XPDT)) Q:'XPDT  D
 .S XPDA=+XPDT(XPDT),XPDNM=$P(XPDT(XPDT),U,2),XPD=""
 .I '$D(^XTMP("XPDI",XPDA,"RTN")) W !,"No routines for ",XPDNM,! Q
 .W !,"Loading Routines for ",XPDNM
 .F  S XPD=$O(^XTMP("XPDI",XPDA,"RTN",XPD)) Q:XPD=""  D ROU(XPD) W "."
 G:AAQROU=0 NOXM
 S AAQBAK=XMZ D EN3^XMD,QUIT^XPDI1(XPDST) K XMY  ;AAQBAK killed by XPDZPAT
 W !,"Backup message #"_XMZ_" created",!,"with Subject '"_AAQSUB_"'",!,"and sent to "_AAQXMY,! K AAQSUB,AAQXMY
 Q  ;AAQBAK and AAQP killed in XPDZPAT or option Exit Action
NOXM W $C(7),!!,"There are no routines which need to be saved.",!,"No Backup Message will be created." S AAQBAK=0
 ;;D KILL^XMA3,QUIT^XPDI1(XPDST) K %H,%I,AAQROU,AAQSUB,AAQXMY,C,XMBASK,XMDISPI,XMDUN,XMDUZ,XMGAPI1,XMLOCK,XMY,XMZ Q
 D QUIT^XPDI1(XPDST) K %H,%I,AAQROU,AAQSUB,AAQXMY,C,XMBASK,XMDISPI,XMDUN,XMDUZ,XMGAPI1,XMLOCK,XMY,XMZ Q
ROU(X) N %N,DIF
 X ^%ZOSF("TEST") E  W !,"Routine ",X," is not on the disk." Q
 S XCNP=XCNP+1,^XMB(3.9,XMZ,2,XCNP,0)="$ROU "_X_" (PACKMAN_BACKUP)",DIF="^XMB(3.9,XMZ,2,"
 X ^%ZOSF("LOAD")
 S $P(^XMB(3.9,XMZ,2,0),U,3,4)=XCNP_U_XCNP,^(XCNP,0)="$END ROU "_X_" (PACKMAN-BACKUP)"
 S AAQROU=AAQROU+1
 Q
