XPDZVER ;FGO/JHS;Revised Verify Checksums ; 11-09-98 [5/18/99 2:28pm]
 ;;8.0;KERNEL;**L33**;Jul 10, 1995
EN1 ;print from Transport Global
 N D0,DIC,X,XPD,Y,Z
 S DIC="^XPD(9.7,",DIC(0)="AEQMZ",DIC("S")="I $D(^XTMP(""XPDI"",Y))"
 D ^DIC Q:Y<0
 S D0=+Y,XPD("D0")="",X="XUTMDEVQ"
 ;during Virgin install, XUTMDEVQ might not exists
 X ^%ZOSF("TEST") E  D  Q
 .S IOSL=99999,IOM=80,IOF="#",IOST="",$Y=0 D PNT(9.7)
 S Y="PNT^XPDZVER(9.7)",Z="Checksum Print"
ENBAT S AAQFILE="Transport Global",AAQGLOB="^XTMP(""XPDI"")",AAQHDR=0 W ! D @Y
 G EXIT
PNT(XPDFIL) ;print
 N XPD0,XPDC,XPDDT,XPDE,XPDI,XPDJ,XPDPG,XPDQ,XPDUL,X
 Q:'$D(^XPD(XPDFIL,D0,0))  S XPD0=^(0),XPDPG=1,$P(XPDUL,"-",IOM)="",XPDDT=$$HTE^XLFDT($H,"1M")
 D HDR
 S XPDI="",(XPDQ,XPDE)=0
 ;XPDFIL=9.7  use transport global exists
 I XPDFIL=9.7 D
 .I '$D(^XTMP("XPDI",D0)) W !!," ** Transport Global doesn't exist **" S XPDQ=1 Q
 .;check for missing nodes in transport global
 .I '$D(^XTMP("XPDI",D0,"BLD"))="" W !!," **Transport Global corrupted, please reload **" S XPDQ=1 Q
 .F XPDC=0:1 S XPDI=$O(^XTMP("XPDI",D0,"RTN",XPDI)) Q:XPDI=""  S XPDJ=$G(^(XPDI)) D  Q:XPDQ
 ..I XPDJ="" W !," **Transport Global corrupted, please reload **" S XPDQ=1 Q
 ..;if deleting at site, there is no checksum
 ..I +XPDJ=1 S XPDC=XPDC-1 Q
 ..D SUM(XPDI,$NA(^XTMP("XPDI",D0,"RTN",XPDI)),$P(XPDJ,U,3))
 ..S XPDQ=$$CHK(4)
 Q:XPDQ
 W !!?3,XPDC," Routine checked, ",XPDE," failed.",!
 Q
SUM(XPDR,Z,XPD) ;check checksum
 N Y
 ;first char. is the sum tag used in XPDRSUM
 I XPD'?1U1.N W !,XPDR,?10,"ERROR in Checksum" S XPDE=XPDE+1 Q
 S @("Y=$$SUM"_$E(XPD)_"^XPDRSUM(Z)"),XPD=$E(XPD,2,255)
 I Y'=XPD W !,XPDR,?10,"Calculated "_$C(7)_Y_", should be "_XPD S XPDE=XPDE+1
 Q
CHK(Y) ;Y=excess lines, return 1 to exit
 Q:$Y<(IOSL-Y) 0
 I $E(IOST,1,2)="C-" D  Q:'Y 1
 .N DIR,I,J,K,X
 Q 0
HDR W !,"PACKAGE: ",$P(XPD0,U),"     ",AAQUCI_"  "_XPDDT,?69,"PAGE ",XPDPG,!,$E(XPDUL,1,75)
 Q
EXIT K %,AAQFILE,AAQGLOB,AAQHDR,AAQUCI,C
 Q
