DVB83RPT ;ALB/RLC;REPORT TO IDENTIFY BAD RECORDS IN FILE 396.3; 01/24/05 1:05 PM
 ;;2.7;AMIE;**83**;Apr 10, 1995
 ;
 ;report to identify records that may possibly have to be corrected
 ;
 K ^TMP("396.3")
 D QUE
 Q
 ;
 ;Identify possible corrupt records
ID S DVBIEN=0
 F  S DVBIEN=$O(^DVB(396.3,DVBIEN)) Q:'DVBIEN  D
 .Q:'$D(^DVB(396.3,DVBIEN,0))
 .Q:$P(^DVB(396.3,DVBIEN,0),U,13)'=-1!($P(^DVB(396.3,DVBIEN,0),U,14)'=-1)
 .S ^TMP("396.3",DVBIEN)=""
 ;
RPT ;Report of records identified
 S DVPG=0
 D HEAD,HD1
 S DVBIEN=0
 F  S DVBIEN=$O(^TMP("396.3",DVBIEN)) Q:'DVBIEN  D
 .W !?5,DVBIEN
 .I $D(SCREEN),$Y>IOSL S DIR(0)="E" D ^DIR D HEAD,HD1 Q
 .I $Y>IOSL D HEAD,HD1
 D FOOT
 Q
 ;
HEAD ;Report header
 W:$D(IOF) @IOF
 S $Y=0
 W !,"LIST OF RECORDS FROM FILE 396.3 THAT MAY BE CORRUPT"
 S DVPG=DVPG+1 W ?72,"Page: ",DVPG,!!
 Q
 ;
HD1 ;Column heading
 W "Internal Record #",!,"================="
 Q
 ;
FOOT ;End of report
 W !!!,"*** END OF REPORT ***",!
 K DVBIEN,^TMP("396.3")
 Q
 ;
QUE ;Queue Report
 W:$D(IOF) @IOF
 W !,"LIST OF RECORDS FROM FILE 396.3 THAT MAY BE CORRUPT",!!
 N ZTQUEUED,POP
 K %ZIS,IOP,IOC,ZTIO S %ZIS="MQ" D ^%ZIS G:POP QUE1
 S ZTRTN="ID^DVB83RPT"
 I $D(IO("Q")) K IO("Q") D ^%ZTLOAD W !,"REQUEST QUEUED" Q
QUE1 S SCREEN="" I $D(ZTRTN) D @ZTRTN
 Q
