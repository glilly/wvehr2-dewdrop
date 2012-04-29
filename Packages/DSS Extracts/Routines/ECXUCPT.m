ECXUCPT ;ALB/TJL-CPT INQUIRY FOR MYSTERY FEEDER KEYS ; 10/15/03 2:12pm
 ;;3.0;DSS EXTRACTS;**49**;July 1, 2003
 ;
EN ; entry point
 N X,Y,DATE,ECRUN,QFLG
 S QFLG=0
 ; get today's date
 D NOW^%DTC S DATE=X,Y=$E(%,1,12) D DD^%DT S ECRUN=$P(Y,"@") K %DT
 D BEGIN
 F  D SELECT W @IOF Q:QFLG
 Q
 ;
BEGIN ; display report description
 W @IOF
 W !,"This inquiry allows the user to select a CPT code, then displays"
 W !,"the Short Name, Category, and Description for the selected code."
 W !!
 Q
 ;
SELECT ; user inputs for CPT Code
 N OUT,DIC,X,Y,DIR,ECXARR,ECXERR,ECXIEN
 S DIC="^ICPT(",DIC(0)="AZEMQ" D ^DIC
 I Y<0 S QFLG=1 Q
 S ECXIEN=+Y
 D GETS^DIQ(81,ECXIEN,".01;2;3;50*","E","ECXARR","ECXERR")
 I $D(ECXERR) W !,"CPT Code Error." S QFLG=1 Q
 D PRINT
 S DIR(0)="E" W ! D ^DIR K DIR I 'Y S QFLG=1
 Q
 ;
PRINT ; display results of inquiry
 N LN,DA,DESCDA
 S $P(LN,"-",80)=""
 W !!,"CPT Inquiry",?54,"Date: ",ECRUN,!,LN,!
 S DA=ECXIEN S DA=DA_","
 W !,"CPT Code: ",ECXARR(81,DA,.01,"E")
 W ?30,"Short Name: ",ECXARR(81,DA,2,"E")
 W !!,"Category: ",ECXARR(81,DA,3,"E")
 W !!,"Description: "
 F LN=1:1 S DESCDA=LN_","_DA  Q:'$D(ECXARR(81.01,DESCDA,.01,"E"))  D
 .W ECXARR(81.01,DESCDA,.01,"E"),!
 W !!!
 Q
 ;
