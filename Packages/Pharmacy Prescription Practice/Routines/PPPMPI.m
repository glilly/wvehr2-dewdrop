PPPMPI ;BHM/DB - OBTAIN VISIT DATA FROM MPI ;21NOV01
 ;;1.0;PHARMACY PRESCRIPTION PRACTICE;**35,39,41**;APR 7, 1995
 ;
 ;Reference to ^DPT("SSN" are covered by IA# 350
 ;Reference to ^DIC(4) are covered by IA# 10090
 D DONE
 S (PPPCNT,PPPCNT1)=0
 ;This routine extracts patient data from the
 ;Treating Facility List file (#391.91)
 ;^DGCN(391.91,D0,0) =
 ;(#.01) PATIENT [1P] ^ (#.02) INSTITUTION [2P] ^
 ;(#.03) DATE LAST TREATED [3D]
 ;
 W @IOF,!!,?20,"Build Foreign Facility Cross Reference",!
 ;I '$D(^DGCN(391.91)) W !,"Sorry could not find the TREATING FACILITY LIST file (#391.91).",! G Q
DATE ;Check for last build date
 S PPPDUZ=DUZ
 I $P($G(^PPP(1020.1,1,0)),"^",4)'>0 W !,"Could not find last build date." G ASKDT
 S (PPPDT,Y)=$P($G(^PPP(1020.1,1,0)),"^",4) I +Y>0 X ^DD("DD") S PPPDT(1)=Y W !,"This option was last run on "_PPPDT(1)
ASKDT S %DT("A")="Start searching from what date? " I $G(PPPDT)'="" S %DT(0)=PPPDT,%DT("B")=PPPDT(1)
 S %DT="AE" D ^%DT G DONE:$G(DTOUT)=1 G DONE:+Y'>0  S PPPSTDT=+Y
PPPSSN ;CHECK SSN
 ;First check for Last SSN processed
 S PPPSSN=$P($G(^PPP(1020.1,1,2)),"^",1) I PPPSSN="" S PPPSSN=0 G TSKMAN
 I $O(^DPT("SSN",PPPSSN))="" W !!,?10,"The last SSN processed (",PPPSSN,") is the last in the file.",!,?10,"therefore, we will start the extract from the beginning.",! S PPPSSN=0 G TSKMAN
 ;
ASK1 W !,"Do you want to start this extract at SSN : ",PPPSSN," ? NO// " R AN:DTIME G DONE:AN["^" I AN="" S AN="N"
 I "YyNn"'[AN W !!,?10,"Answer Y and the report will commence with the next SSN.",!,?10,"Answer 'N' and the process will start with the first SSN on file.",! K AN G ASK1
 I "Yy"[AN G TSKMAN
 I "Nn"[AN W !!,"OK, we'll start at the beginning." S PPPSSN=0
TSKMAN ;Call taskman
 W ! K DIR S DIR(0)="DA^NOW::ERSX",DIR("A")="When do you want to run this utility? ",DIR("B")="NOW",DIR("?")="Complete data and time must be stated." D ^DIR G DONE:$D(DIRUT)
 F X="PPPSTDT","PPPRCVD","PPPDUZ","PPPSSN","PPPDT" S ZTSAVE(X)=""
 S ZTDTH=Y,ZTRTN="PPPBGN^PPPMPI",ZTDESC="FFX BUILD FROM CD ROM",ZTIO=""
 D ^%ZTLOAD
 I '$D(ZTSK) D HOME^%ZIS W !,"Task was not started properly.",! G DONE
 W !!,"Task Queued - Task Number: ",ZTSK,!!
 G DONE
 ;
PPPBGN ;Entry point for building FFX file
 N PPPDLUP
 D NOW^%DTC S Y=%,PPPDLUP=$P(Y,".") X ^DD("DD") S PPPSTRT=Y,(PPPCNTR,PPPVSTC,PPPEND,PPPCNT,PPPENDT)=0
 S PPPCNTR=0,PPPSSN1=PPPSSN F  S PPPSSN1=$O(^DPT("SSN",PPPSSN1)) Q:PPPSSN1=""  S PPPCNTR=$G(PPPCNTR)+1
 ;
 ;
PPPLOOP S PPPSSN=$O(^DPT("SSN",PPPSSN)) G Q:$G(PPPSSN)="" S PPPCNT=$G(PPPCNT)+1,PPPDFN=+$$GETDFN^PPPGET1(PPPSSN) I $G(PPPDFN)'>0 G PPPLOOP
 S ^PPP(1020.1,1,2)=PPPSSN,PPPEND=PPPSSN
 K PPPDATA D TFL^VAFCTFU1(.PPPDATA,PPPDFN) ;Supported IA #2990
 S PPPX1=0
1 S PPPX1=$O(PPPDATA(PPPX1)) G PPPLOOP:PPPX1'>0 S DATA=PPPDATA(PPPX1),PPPVSTC=$G(PPPVSTC)+1
 I $P(DATA,"^",5)'="VAMC" G 1
 S PPPSITE=$P(DATA,"^",1) I $D(^PPP(1020.5,"B",PPPSITE)) G 1
 I PPPSITE=$P($G(^PPP(1020.1,1,0)),"^",9) G 1
 ;get visit information & update 1020.2
 S PPPVST=$P($P(DATA,"^",3),".") I $G(PPPVST)<PPPSTDT G 1
 ;
MTCH ;Site data already exist for SSN
 ;VMP OIFO BAY PINES;VGF;PPP*1.0*39;STORE INSTITUTION FILE IEN INTO PLACE OF VISIT FIELD OF 1020.2
 K PPPIIEN
 S PPPIIEN=$O(^DIC(4,"D",PPPSITE,0))
 S PPPUPDT=0,PPPIEN1=$O(^PPP(1020.2,"APOV",PPPDFN,PPPIIEN,""))
 I $G(PPPIEN1)>0 S PPPOLDDT=$P($G(^PPP(1020.2,PPPIEN1,0)),"^",3) D
 .I $G(PPPOLDDT)'="",PPPVST>PPPOLDDT K DIE,DR S DIE="^PPP(1020.2,",DA=PPPIEN1,DR="2///"_PPPVST D ^DIE K DIE,DR,DA S PPPUPDT=1
 .;VMP OIFO BAY PINES;PPP*1*41
 .;ADDED NEXT LINE VISIT DATE CAN BE NULL IF ADDED BY PDX TRANSACTION IN PPPPDX3
 .I $G(PPPOLDDT)="",PPPVST>0 K DIE,DR S DIE="^PPP(1020.2,",DA=PPPIEN1,DR="2///"_PPPVST D ^DIE K DIE,DR,DA S PPPUPDT=1
 I $G(PPPUPDT)=1 G 1
 I $G(PPPIEN1)>0 G 1
 ;
 ;
 ;
NEWSSN ;Add patient to 1020.2
 S X=PPPDFN,DLAYGO="1020.2",DIC="^PPP(1020.2,",DIC(0)="",DIC("DR")="1////"_PPPIIEN_";2///"_PPPVST_";7///0" K DD,D0 D FILE^DICN
 G 1
Q ;
 ;VMP OIFO BAY PINES;PPP*1*41
 ;ADDED NEXT LINE TO UPDATE LAST PDX BATCH DATE IN PARAMETER FILE
 K DIE,DR S DIE="^PPP(1020.1,",DA=1,DR="3///"_PPPDLUP D ^DIE K DIE,DR,DA
 K DIC
 D NOW^%DTC S Y=% X ^DD("DD") S PPPENDT=Y
 S ^TMP($J,"PPP",1)=" "
 S ^TMP($J,"PPP",2)=" RESULTS FROM BUILD PROCESS"
 S ^TMP($J,"PPP",3)=" Build Started at   : "_$G(PPPSTRT)
 S ^TMP($J,"PPP",4)=" Build Finished at  : "_$G(PPPENDT)
 S ^TMP($J,"PPP",5)=" Last SSN processed : "_$G(PPPEND) I $O(^DPT("SSN",PPPEND))="" S ^TMP($J,"PPP",5)=^TMP($J,"PPP",5)_"   << Last SSN on file."
 S ^TMP($J,"PPP",6)=" Processed "_$G(PPPCNT)_" out of "_$G(PPPCNTR)_" SSNs."
 S ^TMP($J,"PPP",7)=" Examined "_$G(PPPVSTC)_" site visits"
 ;
 ;
SNDMAIL ;Send message to user
 S XMSUB="PHARMACY PRESCRIPTION PRACTICES",XMTEXT="^TMP("_$J_","_"""PPP"""_",",XMDUZ=.5,XMY(PPPDUZ)="" D ^XMD K XMDUZ
 K ^TMP($J)
DONE ;kill variables & exit
 K AN,DA,DATA,DD,DIC,DIE,DIR,DR,OLDDT,PPPCNT,PPPCNT1,PPPCNTR,PPPDATA,PPPDFN,PPPDT,PPPDUZ,PPPEND,PPPENDT,PPPIEN1,PPPSITE,PPPSSN,PPPSSN1,PPPSTDT,PPPSTRT,PPPUPDT,PPPVST,PPPVSTC,PPPX1
 K X,XMDUZ,XMY,Y Q
