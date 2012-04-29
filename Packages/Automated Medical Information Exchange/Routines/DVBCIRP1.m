DVBCIRP1 ;ALB/GTS-AMIE INSUFFICIENT 2507 RPT -CONT 1 ; 11/10/94  1:30 PM
 ;;2.7;AMIE;**13,19,27**;Apr 10, 1995
 ;
 ;** Version Changes
 ;   2.7 - New routine (Enhc 15)
 ;
SUMRPT ;**Output the summary report
 W:IOST?1"C-".E @IOF
 D SUMHD
 ;print request data
 W !?3,"Total 2507 requests received for date range:",?71,$J(DVBARQCT,5)
 W !?3,"Total insufficient 2507 requests received for date range:",?71,$J(DVBAINRQ,5)
 W !?3,"Total insufficient 2507 requests cancelled by RO for date range:",?71,$J(DVBACAN("REQ"),5)
 I DVBARQCT>0 D
 .S PERCENT=(DVBAINRQ/DVBARQCT)*100
 .W !?3,"% of insufficient requests per total requests received:",?71,$J(PERCENT,5,1)_"%"
 .S PERCENT=((DVBAINRQ-DVBACAN("REQ"))/DVBARQCT)*100
 .W !?3,"% of uncancelled insufficient requests per total requests received:",?71,$J(PERCENT,5,1)_"%"
 I DVBARQCT'>0 D
 .S PERCENT=0
 .W !?3,"% of insufficient requests per total requests received:",?71,$J(PERCENT,5,1)_"%"
 .W !?3,"% of uncancelled insufficient requests per total requests received:",?71,$J(PERCENT,5,1)_"%"
 ;print exam data
 W !!?3,"Total 2507 exams received for date range:",?71,$J(DVBAXMCT,5)
 W !?3,"Total insufficient 2507 exams received for date range:",?71,$J(DVBAINXM,5)
 W !?3,"Total insufficient 2507 exams cancelled by RO for date range:",?71,$J(DVBACAN("EXM"),5)
 I DVBAXMCT>0 D
 .S PERCENT=(DVBAINXM/DVBAXMCT)*100
 .W !?3,"% of insufficient exams per total exams received:",?71,$J(PERCENT,5,1)_"%"
 .S PERCENT=((DVBAINXM-DVBACAN("EXM"))/DVBAXMCT)*100
 .W !?3,"% of uncancelled insufficient exams per total exams received:",?71,$J(PERCENT,5,1)_"%"
 I DVBAXMCT'>0 D
 .S PERCENT=0
 .W !?3,"% of insufficient exams per total exams received:",?71,$J(PERCENT,5,1)_"%"
 .W !?3,"% of uncancelled insufficient exams per total exams received:",?71,$J(PERCENT,5,1)_"%"
 ;print insufficient reason data
 I IOST?1"C-".E DO
 .K DTOUT,DUOUT
 .W !!
 .D PAUSE^DVBCUTL4
 .I '$D(DTOUT),('$D(DUOUT)) DO
 ..W @IOF
 ..D SUMHD
 I '$D(DTOUT),('$D(DUOUT)) DO
 .W:IOST'?1"C-".E !!
 .W !?15,"Summary of insufficient exams per Reason",!
 .W !?3,"Reason",?53,"Num",?59,"Percent"
 .N DVBARSLP S DVBARSLP=""
 .F  S DVBARSLP=$O(DVBAINXM(DVBARSLP)) Q:DVBARSLP=""  DO  ;**Reason tot's
 ..W:+DVBARSLP>0 !?3,$P(^DVB(396.94,DVBARSLP,0),U,3),?53,DVBAINXM(DVBARSLP)
 ..I +DVBARSLP'>0,(+DVBAINXM(DVBARSLP)>0) W !?3,"Exams without insufficient reason indicated",?53,DVBAINXM(DVBARSLP)
 ..W:(+DVBAINXM(DVBARSLP)>0&(DVBAINXM>0)) ?59,($P(((DVBAINXM(DVBARSLP)/DVBAINXM)*100),".",1))_$S($E($P(((DVBAINXM(DVBARSLP)/DVBAINXM)*100),".",2),1,1)'="":"."_$E($P(((DVBAINXM(DVBARSLP)/DVBAINXM)*100),".",2),1,1),1:"")_" %"
 .I IOST?1"C-".E DO
 ..D CONTMES^DVBCUTL4
 Q
 ;
SUMHD ;** Output Summary Report heading
 N STRTDT,LSTDT
 W !?15,"Summary Insufficient Exam Report for ",$$SITE^DVBCUTL4(),!
 S Y=$P(BEGDT,".",1) X ^DD("DD") S STRTDT=Y K Y
 S Y=$P(ENDDT,".",1) X ^DD("DD") S LSTDT=Y K Y
 W !?16,"For Date Range: "_STRTDT_" to "_LSTDT,!
 Q
 ;
DETAIL ;** Output reason, exam type and exam info
 N STRTDT,LSTDT
 S Y=$P(BEGDT,".",1) X ^DD("DD") S STRTDT=Y K Y
 S Y=$P(ENDDT,".",1) X ^DD("DD") S LSTDT=Y K Y
 U IO
 S DVBADTLP=BEGDT
 S DVBAENDL=ENDDT
 D DETHD^DVBCIUTL
 S RSDA=""
 S DVBAPG1=""
 F  S RSDA=$O(DVBAARY("REASON",RSDA)) Q:(RSDA=""!($D(GETOUT)))  DO
 .K DVBARSPT
 .S TPDA=""
 .F  S TPDA=$O(^TMP($J,"XMTYPE",TPDA)) Q:(TPDA=""!($D(GETOUT)))  DO
 ..K DVBAXMPT
 ..S XMDA=""
 ..F  S XMDA=$O(^DVB(396.4,"AIT",RSDA,TPDA,XMDA)) Q:(XMDA=""!($D(GETOUT)))  DO
 ...I $P(^DVB(396.3,$P(^DVB(396.4,XMDA,0),U,2),0),U,5)>DVBADTLP,($P(^DVB(396.3,$P(^DVB(396.4,XMDA,0),U,2),0),U,5)<DVBAENDL) D EXMOUT^DVBCIUTL
 I '$D(GETOUT),(IOST?1"C-".E) D CONTMES^DVBCUTL4
 D ^%ZISC
 D KVARS ;**KILL the variables used by DETAIL
 Q
 ;
KVARS ;** Final Kill for Detail report
 S:$D(ZTQUEUED) ZTREQ="@"
 K ^TMP($J),DVBAARY,DVBANAME,DVBASSN,DVBACNUM,RSDA,TPDA,XMDA,DVBADTLP
 K DVBAENDL,DVBARSPT,DVBAXMPT,REQDA,DFN,DVBAORXM,DVBAXMTP,DVBACMND
 K DVBAORPV,DVBAORP1,DVBADTWK,DVBADTE,DVBAORDT,DVBANAM1,GETOUT
 K DVBAARY,DVBAPG1,DVBARQDT,DVBAXDT,DVBAXRS
 Q
 ;
DETSEL ;** Select the details to report
 D RSEL^DVBCIUTL
 I '$D(DVBAARY("REASON")) S DVBAQTSL=""
 I $D(DVBAQTSL) DO
 .S DIR("A",1)="You have not selected Insufficient reasons to report."
 .S DIR("A",2)="This is required to print the Detailed report."
 .S DIR("A",3)=" "
 .S DIR(0)="FAO^1:1",DIR("A")="Hit Return to continue." D ^DIR K DIR,X,Y
 I '$D(DVBAQTSL) DO
 .D XMSEL^DVBCIUTL
 .I '$D(^TMP($J,"XMTYPE")) S DVBAQTSL=""
 .I $D(DVBAQTSL) DO
 ..S DIR("A",1)="You have not selected Exams to report."
 ..S DIR("A",2)="This is required to print the Detailed report."
 ..S DIR("A",3)=" "
 ..S DIR(0)="FAO^1:1",DIR("A")="Hit Return to continue." D ^DIR K DIR,X,Y
 ..K DVBAARY("REASON")
 Q
 ;
