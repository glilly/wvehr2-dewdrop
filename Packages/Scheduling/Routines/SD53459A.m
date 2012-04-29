SD53459A ;ALB/MRY - Pre/Post-Install; 9/29/05
 ;;5.3;Scheduling;**459**;Aug 13, 1993
 ;
 Q
 ;
POST ;Set up TaskMan to re-queue AmbCare records in the background
 N ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSK
 S ZTRTN="SCAN^SD53459A"
 S ZTDESC="Re-queue AmbCare records for SD*5.3*459"
 ;Queue Task to start in 60 seconds
 S ZTDTH=$$SCH^XLFDT("60S",$$NOW^XLFDT)
 S ZTIO=""
 D ^%ZTLOAD
 D BMES^XPDUTL("*****")
 D
 . I $D(ZTSK)[0 D  Q
 . . D MES^XPDUTL("TaskMan task to requeue AmbCare records for SD*5.3*459 did not start.")
 . . D MES^XPDUTL("Re-run post-install routine POST^SD53459A.")
 . D MES^XPDUTL("Task "_ZTSK_" started to re-queue AmbCare records.")
 . I $D(ZTSK("D")) D
 . . D MES^XPDUTL("Task will start at "_$$HTE^XLFDT(ZTSK("D")))
 D MES^XPDUTL("*****")
 Q
 ;
SCAN ;Scan the TRANSMITTED OUTPATIENT ENCOUNTER file (#409.73) for records
 ;transmitted after the Katrina hurricanne. Use $$FINDXMIT^SCDXFU01
 ;to find last corresponding entry in TRANSMITTED OUTPATIENT ENCOUNTER
 ;file (#409.73).
 ;
 N SDTIEN   ;Transmitted Outpatient Encounter file pointer
 N SDENCPTR ;Outpatient Encounter file pointer
 N SDREQUE  ;Count of messages re-queued
 N SDSTART  ;start date/time
 N SDXMITDT ;Xmit to NPCD counter
 N SDERIDT  ;Hurricane Katrina date
 N DFN      ;IEN to PATIENT file (#2)
 N SDNAM    ;Patient's name
 N SDSSN    ;Patient's ssn(last 4)
 ;
 K ^TMP("SD53459A",$J),^TMP("SD53459",$J)
 S SDERIDT=3050826
 S SDSTART=$$NOW^XLFDT
 S SDREQUE=0
 S SDXMITDT=SDERIDT-.00001
 F  S SDXMITDT=$O(^SD(409.73,"AACLST",SDXMITDT)) Q:'SDXMITDT  D
 . S SDTIEN=0
 . F  S SDTIEN=$O(^SD(409.73,"AACLST",SDXMITDT,SDTIEN)) Q:'SDTIEN  D
 . . S SDENCPTR=$P($G(^SD(409.73,SDTIEN,0)),U,2)
 . . Q:'SDENCPTR
 . . S DFN=$P($G(^SCE(SDENCPTR,0)),U,2)
 . . Q:($$EMGRES^DGUTL(DFN)'="K")
 . . S ^TMP("SD53459",$J,DFN)=SDTIEN ;build last transmitted ien
 . . D DEM^VADPT
 . . S SDNAM=$S($D(VADM(1)):VADM(1),1:" ")
 . . S SDSSN=$S($D(VADM(2)):$P($P(VADM(2),"^",2),"-",3),1:" ")
 . . S ^TMP("SD53459",$J,0,SDNAM,SDSSN,DFN)=$P($G(^SD(409.73,SDTIEN,0)),U)
 . . ;locate last transmitted message
 . . ;S SDTIEN=$$FINDXMIT^SCDXFU01(SDENCPTR)
 . . ;Q:'SDTIEN
 ;locate last transmitted message
 S DFN=0
 F  S DFN=$O(^TMP("SD53459",$J,DFN)) Q:'DFN  D
 . S SDTIEN=^TMP("SD53459",$J,DFN)
 . ;store event information
 . D STREEVNT^SCDXFU01(SDTIEN,0)
 . ;set transmission flag to 'YES'
 . D XMITFLAG^SCDXFU01(SDTIEN)
 . S SDREQUE=SDREQUE+1
 ;send completion MailMan message
 D NOTIFY(SDSTART,SDREQUE)
 ;delete the task entry
 S ZTREQ="@"
 Q
 ;
NOTIFY(SDSTIME,SDREQ) ;send job completion msg
 ;
 ;  Input
 ;    SDSTIME - job start date/time
 ;    SDREQ - count of AmbCare messages re-queued
 ;
 ;  Output
 ;    none
 ;
 N DIFROM,XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 N SDSITE,SDETIME,SDTEXT,LINECT
 S SDSITE=$$SITE^VASITE
 S SDETIME=$$NOW^XLFDT
 S XMDUZ="AmbCare Re-queue"
 S XMSUB="Patch SD*5.3*459 Hurricane Katrina ERI (ACRP)"
 S XMTEXT="^TMP(""SD53459A"",$J,"
 S XMY(DUZ)=""
 S XMY("AACVHANPCDERInotification@mail.va.gov")=""
 S XMY("YORTY,M ROBERT@FORUM.VA.GOV")=""
 S ^TMP("SD53459A",$J,1)=""
 S ^TMP("SD53459A",$J,2)="          Facility Name:  "_$P(SDSITE,U,2)
 S ^TMP("SD53459A",$J,3)="         Station Number:  "_$P(SDSITE,U,3)
 S ^TMP("SD53459A",$J,4)=""
 S ^TMP("SD53459A",$J,5)="  Date/Time job started:  "_$$FMTE^XLFDT(SDSTIME)
 S ^TMP("SD53459A",$J,6)="  Date/Time job stopped:  "_$$FMTE^XLFDT(SDETIME)
 S ^TMP("SD53459A",$J,7)=""
 S ^TMP("SD53459A",$J,9)="Total AmbCare records re-queued  : "_SDREQ
 S ^TMP("SD53459A",$J,10)="Please Note: There is no user intervention required with the re-transmission"
 S ^TMP("SD53459A",$J,11)="of the AmbCare records.  They will be retransmitted via the nightly"
 S ^TMP("SD53459A",$J,12)="background job that is scheduled at your site."
 S ^TMP("SD53459A",$J,13)=""
 S ^TMP("SD53459A",$J,14)="After the re-transmission is complete you may receive a  Late ACRP Related"
 S ^TMP("SD53459A",$J,15)="Activity  Mailman message,  if encounters occurred after the National"
 S ^TMP("SD53459A",$J,16)="Patient Care Database was closed for yearly workload credit.  Please"
 S ^TMP("SD53459A",$J,17)="ignore/delete these messages, the records will still be retransmitted to AAC."
 I SDREQ D
 . Q  ;don't list names
 . S ^TMP("SD53459A",$J,18)=""
 . S ^TMP("SD53459A",$J,19)="List of Transmitted Outpatient Encounters re-queued with a 'Katrina' indicator."
 . S ^TMP("SD53459A",$J,20)="          #409.73"
 . S ^TMP("SD53459A",$J,21)="SSN(L4)   Number          Patient"
 . S ^TMP("SD53459A",$J,22)="-----------------------------------"
 . S LINECT=23
 . S SDNAM="" F  S SDNAM=$O(^TMP("SD53459",$J,0,SDNAM)) Q:SDNAM=""  D
 . . S SDSSN="" F  S SDSSN=$O(^TMP("SD53459",$J,0,SDNAM,SDSSN)) Q:SDSSN=""  D
 . . . S DFN="" F  S DFN=$O(^TMP("SD53459",$J,0,SDNAM,SDSSN,DFN)) Q:DFN=""  D
 . . . . S SDTIEN=$G(^TMP("SD53459",$J,0,SDNAM,SDSSN,DFN))
 . . . . S ^TMP("SD53459A",$J,LINECT+1)=SDSSN_"      "_SDTIEN_"        "_SDNAM
 . . . . S LINECT=LINECT+1
 D ^XMD K ^TMP("SD53459A",$J),^TMP("SD53459",$J),XMY,VADM
 Q
