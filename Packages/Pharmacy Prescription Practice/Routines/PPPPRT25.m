PPPPRT25 ;ALB/DMB/JFP - FFX PRINT ROUTINES ; 3/16/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
FFXPRMNU ; FFX Print Menu
 ;
 N %ZIS,PPPMENU,PPPRNGE,ACTION,BANNER,I,POP,RANGE,STOP,TERM,TMP
 N ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK,PROMPT,X
 ;
 S PPPMENU("TEXT",1)="Print Cross-reference By Patient Name"
 S PPPMENU("TEXT",2)="Print Cross-reference By Station Name"
 S PPPMENU("TEXT",3)="Print Station Histogram"
 S PPPMENU("TEXT",4)="Print Visit Histogram"
 S PPPMENU("TEXT",5)="Print Data Summary"
 ;
 S BANNER="FOREIGN FACILITY CROSS-REFERENCE PRINT UTILITIES"
 ;
 I '$D(^PPP(1020.2,"B")) D
 .W !!,*7,"There is no data in the Foreign Facility Cross-reference File"
 .W !!
 ;
 S TMP=$$BANNER^PPPDSP1(BANNER)
 W !!!!
 S STOP=0
 F I=1:1:5 W !,?18,I," - ",PPPMENU("TEXT",I)
 F I=0:0 D  Q:STOP
 .W !!,?18
 .S PROMPT="Select Range Of Items Or 'A' For All: "
 .S RANGE=$$GETRANGE^PPPGET5(1,5,PROMPT)
 .I RANGE<0 D
 ..I RANGE<-2 D
 ...W !!,*7,?18,"Input Error -> ",$S(RANGE=-3:"Improper Format",RANGE=-4:"Value Out Of Range",1:""),"."
 ...W !,?18,"Please Re-enter."
 ..E  D
 ...S STOP=1
 .E  S STOP=1
 Q:RANGE<0
 ;
 S PPPRNGE=RANGE
 D PRFFX
 Q
 ;
PRFFX ;
 S PPPMENU("ROUT",1)="PRTBYNM^PPPPRT20"
 S PPPMENU("ROUT",2)="PRTBYSTA^PPPPRT21"
 S PPPMENU("ROUT",3)="STAHISTP^PPPPRT22"
 S PPPMENU("ROUT",4)="VISHISTP^PPPPRT23"
 S PPPMENU("ROUT",5)="DATASUM^PPPPRT24"
 ;
 N INC
 S TERM=0
 I $E(IOST,1,2)="C-" S TERM=1
 F INC=1:1:$L(PPPRNGE,",") D
 .S ACTION=$P(PPPRNGE,",",INC)
 .I TERM W !!,"Please wait..building display for '"_PPPMENU("TEXT",ACTION)_"'"
 .D @PPPMENU("ROUT",ACTION)
 .D ^PPPPRT29
 W @IOF
 I $D(ZTQUQUED) S ZTREQ="@"
 D ^%ZISC
 ;
 Q
