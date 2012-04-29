ONCTNMC ;Hines OIFO/GWB [TNM Compute percentage of TNM forms completed];02/10/00
 ;;2.11;ONCOLOGY;**46**;Mar 07, 1995;Build 39
 ;
TNMCA ;[TNM Compute percentage of TNM forms completed]
 N SDT,EDT,IEN,TNMA,TNMC,TNMACNT,TNMCCNT,TNMP,RPTDATE,DIVISION
 W @IOF
 W !?3,"Compute percentage of TNM forms completed",!
 S %DT="AE",%DT("A")="   Start Date DX: "
 D ^%DT K %DT
 Q:Y<1  S START=Y,SDT=Y-1
 S %DT="AE",%DT("A")="   End Date DX..: ",%DT("B")="TODAY"
 D ^%DT K %DT
 Q:Y<1  S (END,EDT)=Y
 W !
 N %ZIS,IOP,POP
 S %ZIS="MQ"
 D ^%ZIS  Q:$G(POP)
 I $D(IO("Q")) D TASK G EXIT
 U IO D TNM D ^%ZISC K %ZIS,IOP G EXIT
 ;
TNM S (TNMACNT,TNMCCNT)=0
 F  S SDT=$O(^ONCO(165.5,"ADX",SDT)) Q:(SDT="")!(SDT>EDT)  S IEN=0 F  S IEN=$O(^ONCO(165.5,"ADX",SDT,IEN)) Q:IEN=""  I $$DIV^ONCFUNC(IEN)=DUZ(2) D
 .S TNMA=$P($G(^ONCO(165.5,IEN,7)),U,7)
 .S TNMC=$P($G(^ONCO(165.5,IEN,7)),U,14)
 .I (TNMA="")!(TNMA="0000000")!(TNMA=8888888)!(TNMA=9999999) Q
 .S TNMACNT=TNMACNT+1
 .I (TNMC="")!(TNMC="0000000")!(TNMC=8888888)!(TNMC=9999999) Q
 .S TNMCCNT=TNMCCNT+1
 I TNMACNT=0 D  W ! D PAUSE^ONCOPA2A G EXIT
 .W !,?3,"No TNM Forms have been assigned."
 S TNMP=TNMCCNT/TNMACNT
 S TNMP=$J(TNMP,3,2)*100_"%"
 S Y=DT D DD^%DT S RPTDATE=Y
 S DIVISION=$P(^DIC(4,DUZ(2),0),U,1)
 S Y=START D DD^%DT S START=Y
 S Y=END D DD^%DT S END=Y
 W !
 W !?3,"TNM FORMS ASSIGNED/COMPLETED REPORT",?60,RPTDATE
 W !
 W !?3,"Start Date DX................: ",START
 W !?3,"End Date DX..................: ",END
 W !?3,"Division.....................: ",DIVISION
 W !?3,"TNM Forms Assigned...........: ",TNMACNT
 W !?3,"TNM Forms Completed..........: ",TNMCCNT
 W !?3,"Percentage of Forms completed: ",TNMP
 D ^%ZISC
 W ! D PAUSE^ONCOPA2A
 Q
 ;
TASK ;Queue a task
 K IO("Q"),ZTUCI,ZTDTH,ZTIO,ZTSAVE
 S ZTRTN="TNM^ONCTNMC",ZTREQ="@",ZTSAVE("ZTREQ")=""
 S ZTDESC="Compute percentage of TNM forms completed"
 S ZTSAVE("SDT")="",ZTSAVE("EDT")="",ZTSAVE("START")="",ZTSAVE("END")=""
 D ^%ZTLOAD D ^%ZISC U IO W !,"Request Queued",!
 K ZTSK
 Q
 ;
EXIT Q
