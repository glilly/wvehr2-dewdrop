XPDCOM ;SFISC/RSD - Compare Transport Global ;09/22/2005  574322.260552
 ;;8.0;KERNEL;**21,58,108,124,393**;Jul 10, 1995;Build 12
EN1 ;compare to current system
 N DIC,DIR,DIRUT,POP,XPD,XPDA,XPDC,XPDNM,XPDT,XPDST,Y,Z,%ZIS
 ;S DIC="^XPD(9.7,",DIC(0)="AEQMZ",DIC("S")="I '$P(^(0),U,9),$D(^XTMP(""XPDI"",Y))"
 ;D ^DIC Q:Y<0  S XPDA=+Y,XPDNM=Y(0,0)
 S XPDST=$$LOOK^XPDI1("I '$P(^(0),U,9),$D(^XTMP(""XPDI"",Y))",1) Q:XPDST'>0
 S DIR(0)="S^1:Full Comparison;2:Second line of Routines only;3:Routines only;4:Columnar Routine compare",DIR("A")="Type of Compare",DIR("?")="Enter the type of comparison." ;rwf
 D ^DIR Q:$D(DTOUT)!$D(DUOUT)
 S XPDC=Y,Y="JOB^XPDCOM",Z="Transport Global Compare",XPD("XPDNM")="",XPD("XPDC")="",XPD("XPDT(")=""
 D EN^XUTMDEVQ(Y,Z,.XPD)
 Q
JOB ;Loop thru XPDT
 N XPDIT
 F XPDIT=0:0 S XPDIT=$O(XPDT(XPDIT)) Q:XPDIT'>0  D COM(+XPDT(XPDIT))
 Q
 ;
COM(XPDA) ;XPDA=ien of package in ^XTMP("XPDI"
 Q:'$D(^XTMP("XPDI",$G(XPDA)))
 S:$D(XPDT("DA",XPDA)) XPDNM=$P(XPDT(+XPDT("DA",XPDA)),U,2)
 D HDR,COMR(5):XPDC<4,XPDDO^XTRCMP(XPDA):XPDC=4,EN^XPDCOMG:XPDC=1 ;rwf
 Q
 ;compare routines
COMR(NL) ;NL=number of lines to check ahead
 N DL,XL,XPDI,X,XL,Y,YL
 S:'$G(NL) NL=5 S XPDI=""
 F  S XPDI=$O(^XTMP("XPDI",XPDA,"RTN",XPDI)) Q:XPDI=""  S X=$G(^(XPDI)) D
 .I X W:X=1 !!,"DELETE Routine: ",XPDI,! Q
 .S X=XPDI X ^%ZOSF("TEST") E  W !!,"ADD Routine: ",XPDI,! Q
 .W !!," Routine: ",XPDI
 .;check 2nd line only
 .I XPDC=2 D  Q
 ..S X=$G(^XTMP("XPDI",XPDA,"RTN",XPDI,2,0)),Y=$T(+2^@XPDI)
 ..W !,"<TG> ",X,!,"<SYS>",Y Q:X=Y!(X'["**")
 ..;check patch string
 ..S X=$P(X,"**",2),XL=$L(X,","),Y=$P(Y,"**",2),YL=$L(Y,",")
 ..Q:X=Y
 ..;incoming has more patches than system, check for missing patches
 ..I XL>YL W:$P(X,",",1,(XL-1))'=Y !,"*** WARNING, you are missing one or more Patches ***" Q
 ..I YL>XL W !,"*** WARNING, your routine has more patches than the incoming routine ***" Q
 .F %=1:1 Q:'$D(^XTMP("XPDI",XPDA,"RTN",XPDI,%))
 .;XL=lines in routine in XTMP, DL=line in routine on disk
 .S XL=%-1,DL=$$LD(XPDI)
 .D COMP K ^TMP($J,XPDI)
 Q
COMP ;taken from XMPC routine
 N D1,DI,I,J,K,X1,XI,Y1
 S (XI,DI)=0
 ;check each line in the incoming routine,X1, against the routine on disk,D1
 F  S XI=XI+1,DI=DI+1 Q:XI>XL!(DI>DL)  D:^XTMP("XPDI",XPDA,"RTN",XPDI,XI,0)'=^TMP($J,XPDI,DI,0)
 .S X1=^XTMP("XPDI",XPDA,"RTN",XPDI,XI,0),Y1=0
 .;if lines are not the same, look ahead five lines in D1
 .F I=DI:1:$S(DI+NL<DL:DI+NL,1:DL) S D1=^TMP($J,XPDI,I,0) D  Q:Y1
 ..F K=1:5:26 Q:$L($E(D1,K,K+10))<7  I $F(X1,$E(D1,K,K+10))  D  Q
 ...;print the lines upto the line that are the same
 ...F J=DI:1:I-1 D WP(^TMP($J,XPDI,J,0),2)
 ...;quit if the lines are equal
 ...S DI=I,Y1=1 Q:D1=X1
 ...;if lines are equal, print old and new
 ...D WP(D1,3),WP(X1,4)
 .Q:Y1  D WP(X1,1) S DI=DI-1
 ;check remaining lines in routines
 I XI>XL&(DI<(DL+1)) F I=DI:1:DL D WP(^TMP($J,XPDI,I,0),2)
 I DI>DL&(XI<(XL+1)) F I=XI:1:XL D WP(^XTMP("XPDI",XPDA,"RTN",XPDI,I,0),1)
 Q
WP(X,Y) W !,"* "_$P("ADD^DEL^OLD^NEW",U,Y)_" *  ",X
 Q
 ;load system routine into TMP global
LD(X) N %N,DIF,XCNP
 K ^TMP($J,X)
 S DIF="^TMP($J,X,",XCNP=0
 X ^%ZOSF("LOAD")
 Q XCNP-1
 ;
HDR S $P(XPDUL,"-",80)=""
 W @IOF,"Compare ",XPDNM," to current site",!
 I XPDC>1 W:XPDC=2 "2nd Line of " W "Routines Only",!
 W XPDUL,!
 Q
