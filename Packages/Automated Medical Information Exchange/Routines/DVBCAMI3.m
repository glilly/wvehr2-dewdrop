DVBCAMI3 ;ALB/GTS-557/THM-HOSPITAL AMIS 290 PRINTING, BULLETIN SEND ; 7/16/91  8:55 AM
 ;;2.7;AMIE;;Apr 10, 1995
 ;
 ;** NOTICE: This routine is part of an implementation of a Nationally
 ;**         Controlled Procedure.  Local modifications to this routine
 ;**         are prohibited per VHA Directive 10-93-142
 ;
EN U IO D HDR F JI=0:0 S JI=$O(^TMP($J,JI)) Q:JI=""  W ^(JI,0),! I IOST?1"C-".E,$Y>19 D PAUSE G:$D(OUT) EXIT D HDR
 I IOST?1"P-".E D ^%ZISC
 D PAUSE I $D(OUT)!(ANS=U) W:SBULL="Y" !!,*7,"Bulletin will NOT be sent!!",*7,! H 2 G EXIT
 D ^%ZISC
 S:'$D(XMY) SBULL="N" I SBULL="Y" D SEND
 ;
EXIT K TFIND,PG,OUT,PREVMO,UPDATE,DTTRET,DTTRIN,DTTROUT,TROUT,XI
 D:$D(ZTQUEUED) KILL^%ZTLOAD G KILL^DVBCUTIL
 ;
BULL W ! S XMDUZ=DUZ,XMMG=$S($D(^VA(200,DUZ,0)):$P(^(0),U,1),1:"") D DES^XMA21
 S XMSUB="AMIS 290 report for " S Y=BDATE1 X ^DD("DD") S XMSUB=XMSUB_Y S Y=EDATE1 X ^DD("DD") S XMSUB=XMSUB_" to "_Y,XMTEXT="^TMP($J,"
 Q
 ;
SEND I IOST'?1"P-",'$D(ZTQUEUED) W !!,"Loading AMIS 290 bulletin ..." H 1
 D ^XMD K XMY,XMTEXT,XMSUB K ^TMP($J),^TMP("DVBC",$J)
 I '$D(ZTQUEUED) W !!,*7,">> Mail message transmitted <<",!! H 2
 Q
 ;
HDR S PG=PG+1 W:(IOST?1"C-".E) @IOF
 W "AMIS 290 Report for "_$$SITE^DVBCUTL4,?(IOM-9),"Page: ",PG,!
 W "For date range: " S Y=BDATE1 X ^DD("DD") W Y W " to " S Y=EDATE1 X ^DD("DD") W Y,!
 F LINE=1:1:80 W "-"
 W !!
 Q
 ;
PAUSE K OUT S ANS="" I IOST?1"C-".E W *7,!!,"Press RETURN to continue or ""^"" to exit  " R ANS:DTIME I '$T!(ANS[U) S OUT=1
 Q
