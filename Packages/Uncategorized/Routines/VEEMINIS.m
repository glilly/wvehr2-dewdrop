VEEMINIS ; ; 04-JAN-2004
 ;;12;VPE SHELL;;JAN 04, 2004
PAC(PKG,VER) ; called from package init (DIFROM7 created this routine)
 ; PKG = $T(IXF) of the INIT routine.
 ; VER is an array that is contained in DIFROM from the INIT routine
 ;
 N %,%I,%H,DATE,DIFROM,NOW,PACKAGE,RUN,SERVER,SITE,START,X,XMDUZ,XMSUB,XMTEXT,XMY,Y K ^TMP("VEEMINIS",$J)
 ;
 ; Site tracking updates only occur if run in a VA production primary domain
 ; account.
 I $G(^XMB("NETNAME"))'[".VA.GOV" Q
 Q:'$D(^%ZOSF("UCI"))  Q:'$D(^%ZOSF("PROD"))
 X ^%ZOSF("UCI") I Y'=^%ZOSF("PROD") Q
 ;
 S SERVER="S.A5CSTS@FORUM.VA.GOV"
 S PACKAGE=$P($P(PKG,";",3),U)
 S SITE=$G(^XMB("NETNAME"))
 S START=$P($G(^DIC(9.4,VER(0),"PRE")),U,2) I '$L(START) S START="Unknown"
 D  ; check if ok to use kernel functions
 .S X="XLFDT" X ^%ZOSF("TEST") I $T D  Q
 ..S NOW=$$HTFM^XLFDT($H)
 ..S RUN="Unknown" I START S RUN=$$FMDIFF^XLFDT(NOW,START,3)
 ..S START=$$FMTE^XLFDT(START)
 ..S DATE=NOW\1
 ..S NOW=$$FMTE^XLFDT(NOW)
 .D NOW^%DTC S NOW=%,DATE=X
 .S RUN="" ; don't bother to compute
 .S Y=START D DD^%DT S START=Y
 .S Y=NOW D DD^%DT S NOW=Y
 ;
 ; Message for server
 S ^TMP("VEEMINIS",$J,1,0)="PACKAGE INSTALL"
 S ^TMP("VEEMINIS",$J,2,0)="SITE: "_SITE
 S ^TMP("VEEMINIS",$J,3,0)="PACKAGE: "_PACKAGE
 S ^TMP("VEEMINIS",$J,4,0)="VERSION: "_VER
 S ^TMP("VEEMINIS",$J,5,0)="Start time: "_START
 S ^TMP("VEEMINIS",$J,6,0)="Completion time: "_NOW
 S ^TMP("VEEMINIS",$J,7,0)="Run time: "_RUN
 S ^TMP("VEEMINIS",$J,8,0)="DATE: "_DATE
 ;
 ; Data is sent to server on FORUM - S.A5CSTS
 S XMY(SERVER)="",XMDUZ=.5,XMTEXT="^TMP(""VEEMINIS"",$J,",XMSUB=PACKAGE_" VERSION "_VER_" INSTALLATION"
 D ^XMD
 K ^TMP("VEEMINIS",$J)
 Q
