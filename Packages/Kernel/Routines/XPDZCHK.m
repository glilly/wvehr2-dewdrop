XPDZCHK ;FGO/JHS;Transport/Build Checksums ; 11-07-98 [4/13/00 4:39pm]
 ;;8.0;KERNEL;**L33**;Jul 10, 1995
 D UCI^%ZOSV S AAQUCI=$P(Y,",",1) K Y S AAQDT=$$HTE^XLFDT($H,"1M") D HOME^%ZIS
ASKCHK R !!,"Do you want checksums for (T)ransport Global Pre-Install values,",!,?23,"or (B)uild File Post-Install values?: ",AAQCHK:60 G:AAQCHK="^" EXIT
 I AAQCHK?1L.E S AAQCHK=$$UP^XLFSTR(AAQCHK)
 I $E(AAQCHK,1)'="T",$E(AAQCHK,1)'="B" W $C(7),!!,"Enter uppercase T or B, `^' to quit." G ASKCHK
 G:AAQCHK="B" BLD
TRN ;print from Transport Global
 N D0,DIC,X,XPD,Y,Z W !
 I $D(AAQP) S DIC("B")=AAQP ;used only by XPDZPAT
 S DIC="^XPD(9.7,",DIC(0)="AEQMZ",DIC("S")="I $D(^XTMP(""XPDI"",Y))"
 D ^DIC Q:Y<0
 S D0=+Y,XPD("D0")="",X="XUTMDEVQ",AAQD0=D0,AAQPAT=$P(Y,U,2)
 ;during Virgin install, XUTMDEVQ might not exists
 X ^%ZOSF("TEST") E  D  Q
 .S IOSL=99999,IOM=80,IOF="#",IOST="",$Y=0 D PNT(9.7)
 S Y="PNT^XPDZCHK(9.7)",Z="Checksum Print"
ASKTRN W !!,"Default 'NO' will list checksums for routines on the system."
 S %=2 W !,"Do you want to also list Transport Global RSUM Values" D YN^DICN G:%=1 TPRT
 I %=0 W !!,"Enter 'Y' to list Transport Global information,",!,"Enter 'N' or Press Return to list Routine information only." G ASKTRN
 G:%=-1 EXIT G:%=2 PRE
TPRT S AAQFILE="Transport Global",AAQGLOB="^XTMP(""XPDI"")",AAQHDR=0 W ! D @Y
PRE S X=$$NOW^XLFDT,AAQDT=$$FMTE^XLFDT(X) W !!,"Pre-Install Values from Transport Global "_AAQUCI_" Routines   "_AAQDT,!!,"Routine",?10,"Checksum",?22,"2nd Line Patches",!
 S (XPDC,XPDI,XPDQ)=0
 F XPDC=0:1 S XPDI=$O(^XTMP("XPDI",AAQD0,"RTN",XPDI)) Q:XPDI=""  S XPDJ=$G(^(XPDI)) D  Q:XPDQ
 .I XPDJ="" W !," **Transport Global corrupted, please reload **" S XPDQ=1 Q
 .S ^UTILITY($J,XPDI)=""
 G EXIT:$O(^UTILITY($J,""))=""
 S RN="" F  S RN=$O(^UTILITY($J,RN)) G:RN="" EXIT D
 . S X=RN X ^%ZOSF("TEST") E  W !,RN," is not on the system." Q
 . S X=RN,XCNP=0,DIF="RTN(" K RTN X ^%ZOSF("LOAD") S LC=XCNP-1
 . D RSUM S Y=$O(^DIC(9.8,"B",RN,0)) Q:Y'>0
 . S X=RTN(2,0) W !,RN,?10,$J(RSUM,8),?22,$P(X,";",5)
 . Q
 Q
RSUM N Y,Y2,%,%1,%2,%3 S (Y,Y2)=0
 F %=1,3:1:LC S %1=RTN(%,0),%3=$F(%1," "),%3=$S($E(%1,%3)'=";":$L(%1),$E(%1,%3+1)=";":$L(%1),1:%3-2) F %2=1:1:%3 S Y=$A(%1,%2)*%2+Y,Y2=$A(%1,%2)*(%2+%)+Y2
 S RSUM=Y,RSUM2=Y2
 Q
BLD ;print from Build File
 N D0,DIC,X,XPD,Y,Z W !
 S DIC="^XPD(9.6,",DIC(0)="AEQMZ"
 D ^DIC Q:Y<0
 S D0=+Y
ENBLD D UCI^%ZOSV S AAQUCI=$P(Y,",",1),AAQDT=$$HTE^XLFDT($H,"1M") D HOME^%ZIS S AAQD0=D0
 S Y="PNT^XPDZCHK(9.6)",Z="Checksum Print",XPD("D0")="",XPDI=0
ASKBLD W !!,"Default 'NO' will list checksums for routines on the system."
 S %=2 W !,"Do you want to also list Build File RSUM Values" D YN^DICN G:%=1 BPRT
 I %=0 W !!,"Enter 'Y' to list Build File information,",!,"Enter 'N' or Press Return to list Routine information only." G ASKBLD
 G:%=2 POST G:%=-1 EXIT
BPRT S AAQFILE="Build File",AAQGLOB="^XPD(9.6)",AAQHDR=0 W ! D @Y
POST S BLDA=D0 D CALL^XTZRUTL
 G EXIT
PNT(XPDFIL) ;print
 N XPD0,XPDC,XPDE,XPDI,XPDJ,XPDQ,XPDUL,X
 Q:'$D(^XPD(XPDFIL,D0,0))  S XPD0=^(0),$P(XPDUL,"-",IOM-4)=""
 S X=$$NOW^XLFDT,AAQDT=$$FMTE^XLFDT(X) D HDR W !
 S XPDI="",(XPDQ,XPDE)=0
 I XPDFIL=9.7 S D0=0,D0=$O(^XPD(9.7,"B",AAQPAT,D0)) D
 .I '$D(^XTMP("XPDI",AAQD0)) W !!," ** Transport Global doesn't exist **" S XPDQ=1 Q
 .;check for missing nodes in transport global
 .I '$D(^XTMP("XPDI",AAQD0,"BLD"))="" W !!," **Transport Global corrupted, please reload **" S XPDQ=1 Q
 .F XPDC=0:1 S XPDI=$O(^XTMP("XPDI",AAQD0,"RTN",XPDI)) Q:XPDI=""  S XPDJ=$G(^(XPDI)) D  Q:XPDQ
 ..I XPDJ="" W !," **Transport Global corrupted, please reload **" S XPDQ=1 Q
 ..;if deleting at site, there is no checksum
 ..I +XPDJ=1 S XPDC=XPDC-1 Q
 ..;list Routine, RSUM, and second line from Transport Global
 ..W !,XPDI,?10,$P(XPDJ,U,3),?22,"**"_$P(^XTMP("XPDI",AAQD0,"RTN",XPDI,2,0),"**",2)_"**"
 ..S XPDQ=$$CHK(4)
 ;check build file
 E  D
 .F XPDC=0:1 S XPDI=$O(^XPD(9.6,AAQD0,"KRN",9.8,"NM","B",XPDI)) Q:XPDI=""  S XPDJ=$O(^(XPDI,0)) D  Q:XPDQ
 ..Q:'$D(^XPD(9.6,AAQD0,"KRN",9.8,"NM",+XPDJ,0))  S XPDJ=$P(^(0),U,4)
 ..;quit if no checksum, routine wasn't loaded
 ..I XPDJ="" S XPDC=XPDC-1 Q
 ..N DIF,XCNP,%N
 ..S X=XPDI,DIF="^TMP($J,""RTN"",XPDI,",XCNP=0
 ..X ^%ZOSF("TEST") E  W !,XPDI,?10,"Doesn't Exist" Q
 ..;list Routine and RSUM from Build File
 ..W !,XPDI,?10,XPDJ
 ..S XPDQ=$$CHK(4)
 Q
CHK(Y) ;Y=excess lines, return 1 to exit
 Q:$Y<(IOSL-Y) 0
 I $E(IOST,1,2)="C-" D  Q:'Y 1
 .N DIR,I,J,K,X
 Q 0
HDR W:AAQHDR=0 !,AAQFILE_" Checksums: ",$P(XPD0,U),?57,AAQDT,!,$E(XPDUL,1,75),! S AAQHDR=AAQHDR+1
 W !,AAQFILE,"  ",AAQGLOB,"  Entry #",D0
 W !!,"Routine",?10,"RSUM Values" W:AAQFILE["Transport" ?22,"2nd Line Patches"
 Q
EXIT K %N,%Y,AAQCHK,AAQFILE,AAQGLOB,AAQHDR,AAQLOC,AAQUCI,BLDA,C,DIF,LC,RN,RSUM,RSUM2,RTN,X,XCNP,XPDC,XPDI,XPDJ,XPDQ,Y,Z,^UTILITY($J) D ^%ZISC
 ;AAQD0, AAQP, and AAQPAT are used by XPDZPAT and killed at EXIT.
 ;When running this routine from [XPDZ CHECKSUMS/2ND LINE] option,
 ;these variables are killed in the menu option Exit Action.
 Q
