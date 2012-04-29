PPPBFFX ;BHM/DB-PPP/BUILD FOREIGN FACILITY XREF ;4MAR97
 ;;1.0;PHARMACY PRESCRIPTION PRACTICE;**11,26**;APR 7, 1995
 ;
 ;@references to variable names generally represent extended globals
 ;i.e., in this routine:
 ;@GBLCHK1 = ["PPS","VAH"]^VAM(394.94,"1","RUN")
 ;
 K ^TMP("PPP",$J),^TMP($J) D Q
 K CNT,CNTR,PPPSSN,^TMP("PPP",$J)
 ;
 W !!,"First let me check the status of the CD-ROM Server.",! H 2
 S SVRLOC=$O(^VAM(394.99,"A-UCIVOL",""))
 I SVRLOC="" W !,"Cannot find a location for the server." S ERR=1 G QNOBLD
 S GLBLOC=SVRLOC_"VAM("
 S GBLCHK1=GLBLOC_394.94_",1,"_"""RUN"""_")"
 S TMP=@GBLCHK1
 I TMP="" W !,"Could not get status of server." S ERR=1 G QNOBLD
 I +TMP'=1 W !,$P(TMP,"^",3) S ERR=1 G QNOBLD
 I +$P(TMP,"^",2) W !,"CD-ROM is in process of stopping." G QNOBLD
 ;
 ;Check for other jobs
 S GBLCHK1=GLBLOC_394.98_",1,"_"""POST"""_")"
 S PST=@GBLCHK1 I $P(PST,"^")'=0 W !,"Another request is already made.",! S ERR=1 G QNOBLD
 W !!,"Everything appears ok with the server, please proceed.",!
QCDTST K SVRLOC,GLBLOC,GBLCHK1,TMP,PST I $D(ERR) K ERR G QNOBLD
 ;First check for Last SSN processed
 S PPPSSN=$P($G(^PPP(1020.1,1,2)),"^",1) I PPPSSN="" S PPPSSN=0 G PPPBGN
 I $O(^DPT("SSN",PPPSSN))="" W !!,?10,"The last SSN processed (",PPPSSN,") is the last in the file.",!,?10,"therefore, we will start the extract from the beginning.",! S PPPSSN=0 G PPPBGN
 ;
ASK1 W !,"Do you want to start this extract at SSN : ",PPPSSN," ? NO// " R AN:DTIME I AN="" S AN="N"
 I "YyNn"'[AN W !!,?10,"Answer Y and the report will commence with the next SSN.",!,?10,"Answer 'N' and the process will start with the first SSN on file.",! K AN G ASK1
 I "Yy"[AN G PPPBGN
 I "Nn"[AN W !!,"OK, we'll start at the beginning." S PPPSSN=0
 ;
PPPBGN ;start this puppy rolling
 S PPP1=$G(^PPP(1020.1,1,1)),PPP0=$G(^PPP(1020.1,1,0))
 W !!,"First let me check a few things...."
 I $P(PPP1,"^")="" W !!,"No entry for the `LOCATION OF DPT GLOBAL'." G QNOBLD
 ;
 I $P(PPP1,"^",2)="" W !,"No entry for the `LOCATION OF TMP GLOBAL'." G QNOBLD
 I $P($G(^PPP(1020.1,1,0)),"^",9)="" W !!,"Station number not found in parameter file.",! G QNOBLD
DEVICE K DIR S DIR(0)="YA",DIR("A")="Create new Foreign Facility Cross Reference from CD: "
 S DIR("B")="NO",DIR("?")="Enter yes to create new FFX from CD."
 D ^DIR I Y G TSKMAN
 G QNOBLD
 ;
TSKMAN ;Call taskman
 W ! K DIR S DIR(0)="DA^NOW::ERSX",DIR("A")="When do you want to run this utility? ",DIR("B")="NOW",DIR("?")="Complete data and time must be stated." D ^DIR G Q:$D(DIRUT)
 S PPPRCVD=DUZ,ZTSAVE("PPPRCVD")="",ZTSAVE("PPPSSN")=""
 S ZTDTH=Y,ZTRTN="^PPPBFFX1",ZTDESC="FFX BUILD FROM CD ROM",ZTIO=""
 D ^%ZTLOAD
 I '$D(ZTSK) D HOME^%ZIS W !,"Task was not started properly.",! G QNOBLD
 W !!,"Task Queued - Task Number: ",ZTSK,!!
 Q
 G ^PPPBFFX1
QNOBLD W !!,"No build could be performed.",!
Q K AN,CNT,CNTR,DA,DIE,DMNNAME,DMNNEW,ERR,ERRTXT,EXCARR,FACADD,IFN,INUCI,LNUM,LSTVISIT,MPDARR,OUTUCI,PATADD,PATCHG,PATCHK,PPP0,PPP1,PPPRCVD,PPPSSN,STATUS,STRTTM,TMP2
 K PATDFN,PPP,PPP0,PPP1,PPPSSN,PPPSTANO,SITE,SITEADD,SITECNT,SSN,SSNARR,SSNCNT,STAT,STRTM,TODAY,X,XX,Y,MAILERR,CNTR1,CNTR2,PPPEND,MAILERR Q
