DVBCIRPT ;ALB/GTS-AMIE C&P INSUFF EXAM TRACKING RPT ; 11/9/94  2:00 PM
 ;;2.7;AMIE;**13,19,27**;Apr 10, 1995
 ;
 ;** Version Changes
 ;   2.7 - New routine (Enhc 15)
 ;
MAIN ;**Select Dte Rng & Rpt Type; call report routine
 F  Q:$D(DVBAOUT)  DO
 .D HOME^%ZIS
 .S TVAR(1,0)="0,0,1,2:2,1^Insufficient 2507 Exam Report"
 .D WR^DVBAUTL4("TVAR")
 .K TVAR
 .S RPTTYPE=$$RPTTYPE^DVBCUTA1()
 .S:((RPTTYPE'="D")&(RPTTYPE'="S")) DVBAOUT=""
 .W:'$D(DVBAOUT) !!
 .D:'$D(DVBAOUT) DATE^DVBCUTL4(.BEGDT,.ENDDT)
 .I $D(ENDDT),(+ENDDT>0) DO
 ..S ENDDT=ENDDT_".2359"
 ..I RPTTYPE="S" DO
 ...D DEVSEL
 ...I POP D SUMKILL
 ...I 'POP DO
 ....I $D(IO("Q")) DO
 .....N DVBAI
 .....S ZTRTN="SUM^DVBCIRPT",ZTIO=ION
 .....S ZTDESC="Summary Insufficient Exam Report"
 .....F DVBAI="BEGDT","ENDDT" S ZTSAVE(DVBAI)=""
 .....D ^%ZTLOAD
 .....N TSK S TSK=$S($D(ZTSK)=0:"C",1:"Y")
 .....I TSK="Y" W !!,"Summary Report Queued. Task number: ",ZTSK
 .....K ZTSK D CONTMES^DVBCUTL4
 .....D SUMKILL
 ....I '$D(IO("Q")) D SUM
 ...D ^%ZISC
 ..I RPTTYPE="D" DO
 ...D DETSEL^DVBCIRP1 ;**Select the Reasons and Exams to report
 ...I '$D(DVBAQTSL) DO
 ....D DEVSEL
 ....I POP D KVARS^DVBCIRP1
 ....I 'POP DO
 .....I $D(IO("Q")) DO
 ......N DVBAI
 ......S ZTRTN="DETAIL^DVBCIRP1",ZTIO=ION
 ......S ZTDESC="Detailed Insufficient Exam Report"
 ......F DVBAI="BEGDT","ENDDT","DVBAARY(""REASON"",","^TMP($J,""XMTYPE""," S ZTSAVE(DVBAI)=""
 ......D ^%ZTLOAD
 ......N TSK S TSK=$S($D(ZTSK)=0:"C",1:"Y")
 ......I TSK="Y" W !!,"Detail Report Queued. Task number: ",ZTSK
 ......K ZTSK D CONTMES^DVBCUTL4
 ......D KVARS^DVBCIRP1
 .....I '$D(IO("Q")) W:IOST?1"C-".E @IOF D DETAIL^DVBCIRP1
 ....D ^%ZISC
 ...K DVBAQTSL
 ..D CLEANUP
 D KVARS
 Q
 ;
KVARS ;** Kill the variables used in report
 K DVBAOUT,ENDDT,BEGDT,DTOUT,DUOUT,RPTTYPE,DVBACAN,DVBASTAT
 D CLEANUP
 Q
 ;
CLEANUP ;** Kill the variables used by the device handler
 K %ZIS,POP,%IS,IOP
 K IOBS,IOHG,IOPAR,IOUPAR,IOXY,POP,%DT,%YY,%XX,ION,IOPAR
 Q
 ;
DEVSEL ;** Select the device to report to
 S %ZIS="AEQ"
 S %ZIS("A")="Output device: "
 D ^%ZIS
 Q
 ;
SUM ;** Set up reason counter array, count all 2507's received
 U IO
 S (DVBARQCT,DVBAINRQ,DVBAXMCT,DVBAINXM)=0
 S DVBACAN("REQ")=0,DVBACAN("EXM")=0
 S DVBAENDL=ENDDT
 ;
 ;** Initialize reason counter array
 F DVBARIFN=0:0 S DVBARIFN=$O(^DVB(396.94,DVBARIFN)) Q:+DVBARIFN'>0  DO
 .S DVBAINXM(DVBARIFN)=0
 S DVBAINXM("NO REASON")=0
 ;
 ;** Count the total and insufficient number of exams and 2507 requests
 S DVBADTLP=BEGDT-.0001
 F  S DVBADTLP=$O(^DVB(396.3,"ADP",DVBADTLP)) Q:(DVBADTLP=""!(DVBADTLP>ENDDT))  DO
 .S DVBAPRIO=""
 .F  S DVBAPRIO=$O(^DVB(396.3,"ADP",DVBADTLP,DVBAPRIO)) Q:DVBAPRIO=""  DO
 ..S DVBADALP=""
 ..F  S DVBADALP=$O(^DVB(396.3,"ADP",DVBADTLP,DVBAPRIO,DVBADALP)) Q:DVBADALP=""  DO
 ...S DVBARQCT=DVBARQCT+1
 ...K DVBAINSF
 ...I DVBAPRIO="E" DO
 ....S DVBAINRQ=DVBAINRQ+1
 ....I $P(^DVB(396.3,DVBADALP,0),U,18)="RX" S DVBACAN("REQ")=DVBACAN("REQ")+1
 ....S DVBAINSF=""
 ...S DVBAXMDA=""
 ...F  S DVBAXMDA=$O(^DVB(396.4,"C",DVBADALP,DVBAXMDA)) Q:DVBAXMDA=""  DO
 ....S DVBAXMCT=DVBAXMCT+1
 ....I $D(DVBAINSF) DO
 .....S DVBAINXM=DVBAINXM+1
 .....S DVBARIFN=$P(^DVB(396.4,DVBAXMDA,0),U,11),DVBASTAT=$P(^(0),U,4)
 .....S:DVBARIFN="" DVBARIFN="NO REASON"
 .....S DVBAINXM(DVBARIFN)=DVBAINXM(DVBARIFN)+1
 .....I DVBASTAT="RX" S DVBACAN("EXM")=DVBACAN("EXM")+1
 D SUMRPT^DVBCIRP1
 S:$D(ZTQUEUED) ZTREQ="@"
 D SUMKILL
 D ^%ZISC
 Q
 ;
SUMKILL ;** Kill the variables used in the summary report
 K DVBADTLP,DVBAENDL,DVBARQCT,DVBAINRQ,DVBAXMCT,DVBAINXM
 K DVBAPRIO,DVBADALP,DVBAXMDA,DVBAINSF,DVBARIFN
 Q
