XDRDPRGE ;SF-IRMFO/IHS/OHPRD/JCM - PURGE DUPLICATE RECORD FILE;   [ 08/13/92  09:50 AM ] ;08/24/99  09:59
 ;;7.3;TOOLKIT;**23,42**;Apr 25, 1995
 ;;
START ;
 D INIT G:XDRQFLG END
 D ASK G:XDRQFLG END
DQ ; Entry point for Tasked job
 I XDRDPRGE("CHOICE")="BOTH" D BOTH I 1
 E  D XREF
END D EOJ
 Q
 ;
INIT ;
 S XDRQFLG=0
 D FILE
 G:XDRQFLG INITX
 S XDRGL=^DIC(XDRFL,0,"GL")
INITX Q
 ;
FILE ;
 ;S DIC("S")=
 S DIC(0)="QEAZ"
 S DIC("A")="Select File to Be Checked to purge: "
 S DIC="^VA(15.1," D ^DIC K DIC,X
 I Y=-1 S XDRQFLG=1 G FILEX
 S XDRFL=$P(Y(0),U) K Y
FILEX Q
 ;
ASK ;
 S DIR(0)="S^1:POTENTIAL DUPLICATES PURGE;2:VERIFIED NOT DUPLICATES PURGE;3:ALL RECORDS EXCEPT VERIFIED DUPLICATES PURGE"
 S DIR("A")="Choice "
 S DIR("?",1)="Enter a 1 if you wish to purge only the potential non-verified duplicates"
 S DIR("?",2)="Enter a 2 if you wish to purge only Verified Non-Duplicates"
 S DIR("?",3)="Enter a 3 if you wish to purge everything except verifed duplicates"
 D ^DIR K DIR
 I $D(DIRUT) S XDRQFLG=1 G ASKX
 S (XDRDPRGE("XREF"),XDRDPRGE("CHOICE"))=$S(Y=1:"APOT",Y=2:"ANOT",1:"BOTH") K Y
 S DIR(0)="Y"
 S DIR("A")="Do you wish to Queue this purging (Y/N)"
 D ^DIR K DIR
 I $D(DIRUT) S XDRQFLG=1 G ASKX
 I Y D QUEUE
ASKX K Y
 Q
 ;
QUEUE ;
 S ZTRTN="DQ^XDRDPRGE",ZTIO="",ZTDESC="Duplicate Record Purge"
 F %="XDRFL","XDRGL","XDRDPRGE(" S ZTSAVE(%)=""
 D ^%ZTLOAD K ZTSK
 S XDRQFLG=1
 Q
 ;
BOTH ;
 S XDRDPRGE("XREF")="APOT" D XREF
 S XDRDPRGE("XREF")="ANOT" D XREF
 Q
 ;
XREF ;
 G:'$D(^VA(15,XDRDPRGE("XREF"))) XREFX
 S XDRDPRGE("GL")="^VA(15,"_""""_XDRDPRGE("XREF")_""""_","_""""_$P(XDRGL,U,2)_""""_","
 S XDRDPRGE("RCDS")=0,DIK="^VA(15," F XDRDI1=0:0 S XDRDPRGE("RCDS")=$O(@(XDRDPRGE("GL")_"XDRDPRGE(""RCDS""))")) Q:XDRDPRGE("RCDS")=""  S DA=$O(@(XDRDPRGE("GL")_"XDRDPRGE(""RCDS""),0)")) D ^DIK
XREFX K XDRDI1,DIK,DA,XDRDPRGE("GL")
 Q
 ;
EOJ ;
 K XDRFL,XDRGL,XDRDPRGE
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
