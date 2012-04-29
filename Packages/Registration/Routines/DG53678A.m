DG53678A ;ALB/MRY - Pre/Post-Install ; 9/26/05 3:33pm
 ;;5.3;Registration;**678**;Aug 13, 1993
 ;
POST ;Set up TaskMan to re-queue PTF records in the background
 N ZTDESC,ZTDTH,ZTIO,ZTQUEUED,ZTREQ,ZTRTN,ZTSAVE,ZTSK
 S ZTRTN="SCAN^DG53678A"
 S ZTDESC="Re-queue PTF records for DG*5.3*678"
 ;Queue Task to start in 60 seconds
 S ZTDTH=$$SCH^XLFDT("60S",$$NOW^XLFDT)
 S ZTIO=""
 D ^%ZTLOAD
 D BMES^XPDUTL("*****")
 D
 . I $D(ZTSK)[0 D  Q
 . .D MES^XPDUTL("TaskMan run to requeue PTF records for DG*5.3*678 was not started.")
 . .D MES^XPDUTL("Re-run Post Install routine POST^DG53678A.")
 . D MES^XPDUTL("Task "_ZTSK_" started to requeue PTF records.")
 . I $D(ZTSK("D")) D
 . . D MES^XPDUTL("Task will start at "_$$HTE^XLFDT(ZTSK("D")))
 D MES^XPDUTL("*****")
 Q
 ;
SCAN ;Search the PTF records for any messages that would have been
 ;transmitted to the NPCD after the Katrina ERI date and re-queue
 ;those messages.
 ;
 N DGSTART   ;Job start date/time
 N DGTOTCNT  ;count of verified transmitted patients
 N DGPTFCNT  ;count of re-queued PTF records
 N DGMSG     ;free text message/line count passed to NOTIFY
 N DGIEN     ;IEN for PTF RELEASE file
 N DGDTRAN   ;Date Transmitted
 N DGDTREL   ;Date Released
 N DGQUIT    ;job control flag
 N DGERIDT   ;Hurricane Katrine date
 ;
 K ^TMP("DG53678A",$J),^TMP("DG53678",$J)
 S DGERIDT=3050826 ;Hurricane Katrina ERI cutoff date
 S DGSTART=$$NOW^XLFDT
 S (DGMSG,DGQUIT,DGTOTCNT)=0
 S DGPTFCNT="0^0"
 S ZTREQ="@"  ;delete task when finished
 L +^DGP(45.83):3 I '$T D  Q
 . S DGMSG=2
 . S DGMSG(1)="PTF Transmission Currently Running - Patch Re-queue Job Stopping"
 . S DGMSG(2)="Re-run Post Install routine POST^DG53678A."
 . D NOTIFY(DGSTART,DGTOTCNT,DGPTFCNT,.DGMSG)
 S DGDTRAN=DGERIDT-.00001 ;PTF transmitted date
 ;Scan thru transmitted PTFs
 F  S DGDTRAN=$O(^DGP(45.83,"AP",DGDTRAN)) Q:'DGDTRAN  D  Q:DGQUIT
 . S DGDTREL=0 ;PTF released date
 . F  S DGDTREL=$O(^DGP(45.83,"AP",DGDTRAN,DGDTREL)) Q:'DGDTREL  D  Q:DGQUIT
 . . S DGIEN=0 ;PTF ien
 . . F  S DGIEN=$O(^DGP(45.83,"AP",DGDTRAN,DGDTREL,DGIEN)) Q:'DGIEN  D  Q:DGQUIT
 . . . ;check PTF record (admit>8/25) that were xmit'ed and re-queue them
 . . . K DGPTFARR ;one PTF entry in array at atime
 . . . I ($$GET1^DIQ(45,DGIEN,2,"I")>(DGERIDT-.00001)),$$GETPTF(DGIEN,DGDTREL,.DGPTFARR) D REQPTF(.DGPTFARR,.DGPTFCNT)
 . . . I $$S^%ZTLOAD D  Q
 . . . . S DGMSG=2
 . . . . S DGMSG(1)="Patch DG*5.3*678 PTF Re-queue Task Stopped by User"
 . . . . S DGMSG(2)="Re-run Post Install routine POST^DG53678A."
 . . . . S (ZTSTOP,DGQUIT)=1
 L -^DGP(45.83)
 D NOTIFY(DGSTART,DGPTFCNT,.DGMSG)
 Q
 ;
GETPTF(DGPTF,DGQDT,DGPT) ;Find PTF records transmitted after the verification
 ; date.  Build array subscripted by record numbers set equal to the
 ; PTF record type.
 ;
 ;  Input
 ;    DGPTF   - IEN to PTF file (#45)
 ;    DGQDT    - Date queued (Released)
 ;    DGPT    - array node passed by reference
 ;
 ;  Output
 ;    DGPT - array of PTF record types and queue dates (1:PTF,2:CENSUS)
 ;           subscripted by PTF record # (ex. DGPT(1402)=2^3011212)
 ;    function result - 0 : no records found
 ;                      1 : records found
 ;
 N DFN    ;IEN to PATIENT file (#2)
 N DGRTY  ;Record type
 N DGPT0  ;zero node of patient's PTF record
 ;
 ;borrowed from DIC("S") in DREL^DGPTFDEL
 I $D(^DGPT(DGPTF,0)),$D(^DGPT(DGPTF,70)),+^DGPT(DGPTF,70)>2901000,$D(^DGP(45.83,"C",DGPTF)) D
 . S DGPT0=^DGPT(DGPTF,0)
 . S DFN=$P(DGPT0,U)
 . S DGRTY=$P(DGPT0,U,11)
 . I ($$EMGRES^DGUTL(DFN)="K"),(DGRTY=1) D  ;PTF records only
 . . S DGPT(DGPTF)=DGRTY_U_DGQDT
 . . D DEM^VADPT
 . . S DGNAM=$S($D(VADM(1)):VADM(1),1:" ")
 . . S DGSSN=$S($D(VADM(2)):$P($P(VADM(2),"^",2),"-",3),1:" ")
 . . S ^TMP("DG53678",$J,DGNAM,DGSSN,DGPTF)=""
 Q ($D(DGPT)>0)
 ;
REQPTF(DGPTFT,DGPTFC) ;Re-queue the PTF record for transmission
 ;  Input
 ;    DGPTFT - array of PTF record #'s to resend for a patient
 ;    DGPTFC - count of re-queued PTF records
 ;
 ;  Output
 ;    DGPTFC - count of re-queued PTF records PTF^CENSUS
 ;             (ex.  DGPTFC=4^1)
 ;
 N DGPTF  ;PTF record number
 N DGRTY  ;PTF record type (1:PTF, 2:CENSUS)
 N DGDAT  ;Date of queuing for previous transmission
 ;
 S DGPTF=0
 F  S DGPTF=$O(DGPTFT(DGPTF)) Q:'DGPTF  D
 . S DGRTY=+DGPTFT(DGPTF),DGDAT=$P(DGPTFT(DGPTF),U,2)
 . I $$UNREL(DGPTF,DGDAT) D RELEASE(DGPTF) D
 . . S:'$D(^TMP("DG53678",$J,0,DGPTF)) $P(DGPTFC,U,DGRTY)=$P(DGPTFC,U,DGRTY)+1
 . . S ^TMP("DG53678",$J,0,DGPTF)=""
 Q
 ;
UNREL(DGPTF,DGDT) ;Unrelease the PTF record - borrowed from OK^DGPTFDEL
 ;
 ;  Input:
 ;    DGPTF - PTF record number
 ;    DGDT  - Date of Previously Queued Transmission
 ;
 ;  Output:
 ;    function result 1:success, 0:failure
 ;
 N DA,DIK  ;FileMan variables
 ;
 S DA(1)=DGDT
 I 'DA(1) Q 0
 S DIK="^DGP(45.83,"_DA(1)_",""P"",",DA=DGPTF D ^DIK
 Q 1
 ;
RELEASE(DGPTF) ;Re-release the PTF record - borrowed from REL^DGPTFREL
 ;
 ;  Input:
 ;    DGPTF - PTF record number
 ;
 ;  Output:
 ;    none
 ;
 N DA,DIC,DIE,DINUM,DR,X  ;FileMan variables
 ;
 ;if date entry doesn't exist then create new entry and "P" node
 I '$D(^DGP(45.83,DT,0)) D
 . S (DINUM,X)=DT,DIC="^DGP(45.83,",DIC(0)="L"
 . K DD,DO
 . D FILE^DICN
 . K DINUM,DIC
 I '($D(^DGP(45.83,DT,"P",0))#2) S ^DGP(45.83,DT,"P",0)="^45.831PA^0^0"
 ;if transmission date exists then clear it to allow re-transmission
 I $P(^DGP(45.83,DT,0),U,2) D
 . S DA=DT,DIE="^DGP(45.83,",DR="1///@"
 . D ^DIE
 . K DA,DIE,DR
 ;add the PTF record to the queue
 S (DINUM,X)=DGPTF,DIC(0)="L",DA(1)=DT,DIC="^DGP(45.83,"_DT_",""P"","
 D FILE^DICN
 K DA,DIC,DINUM
 ;update RELEASE DATE and RELEASED BY fields in PTF CLOSE OUT file.
 S DA=DGPTF,DIE="^DGP(45.84,",DR="4////"_DT_";5////"_DUZ
 D ^DIE
 K DA,DIE,DR
 Q
 ;
NOTIFY(DGSTIME,DGPTFNUM,DGMESS) ;send job msg
 ;
 ;  Input
 ;    DGSTIME - job start date/time
 ;    DGPTFNUM - count of PTF messages re-queued
 ;    DGMESS - free text message array for task stop or errors passed
 ;             by reference
 ;
 ;  Output
 ;    none
 ;
 N DIFROM,XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 N DGSITE,DGETIME,DGTEXT,DGI,DGNAM,DGSSN,DGPTF,LINECT
 S DGSITE=$$SITE^VASITE
 S DGETIME=$$NOW^XLFDT
 S XMDUZ="PTF Re-queue"
 S XMSUB="Patch DG*5.3*678 Emergency Response - Hurricane Katrina (PTF)"
 S XMTEXT="^TMP(""DG53678A"",$J,"
 S XMY(DUZ)=""
 S XMY("AACVHANPCDERInotification@mail.va.gov")=""
 S XMY("G.PTT")=""
 S XMY("YORTY,M ROBERT@FORUM.VA.GOV")=""
 S ^TMP("DG53678A",$J,1)=""
 S ^TMP("DG53678A",$J,2)="          Facility Name:  "_$P(DGSITE,U,2)
 S ^TMP("DG53678A",$J,3)="         Station Number:  "_$P(DGSITE,U,3)
 S ^TMP("DG53678A",$J,4)=""
 S ^TMP("DG53678A",$J,5)="  Date/Time job started:  "_$$FMTE^XLFDT(DGSTIME)
 S ^TMP("DG53678A",$J,6)="  Date/Time job stopped:  "_$$FMTE^XLFDT(DGETIME)
 S ^TMP("DG53678A",$J,7)=""
 I $G(DGMESS) D
 . F DGI=1:1:DGMESS D
 . . S ^TMP("DG53678A",$J,7+DGI)="*** "_$E($G(DGMESS(DGI)),1,65)
 I '$G(DGMESS) D
 . S ^TMP("DG53678A",$J,8)="PTF Message Re-queue Complete"
 . ;S ^TMP("DG53678A",$J,9)="Total Hurricane Katrina patients in file (#45.83): "_DGTOT
 . S ^TMP("DG53678A",$J,10)="Total Hurricane Katrina PTF records re-queued: "_$P(DGPTFNUM,U,1)
 . S ^TMP("DG53678A",$J,11)=""
 . S ^TMP("DG53678A",$J,12)="  If your site has PTF records that were re-queued, please follow the steps"
 . S ^TMP("DG53678A",$J,13)="  listed below to retransmit them: Please refer to the PIMS V5.3 ADT"
 . S ^TMP("DG53678A",$J,14)="  Module User Manual - PTF Menu, for additional information."
 . S ^TMP("DG53678A",$J,15)=""
 . S ^TMP("DG53678A",$J,16)="     *   Go to the PTF Menu, then PTF Transmission"
 . S ^TMP("DG53678A",$J,17)="     *      At the Start Date prompt, type ?. "
 . S ^TMP("DG53678A",$J,18)="     You should see a list of dates available for re-transmission."
 . S ^TMP("DG53678A",$J,19)="     *   Enter the first available start date, then enter a through date"
 . S ^TMP("DG53678A",$J,20)="         for the date ranges available."
 . S ^TMP("DG53678A",$J,21)="     *      It is recommended that you retransmit these records"
 . S ^TMP("DG53678A",$J,22)="            within 15 days of the patch installation."
 . I +DGPTFCNT D
 . . Q  ;don't list names
 . . S ^TMP("DG53678A",$J,23)=""
 . . S ^TMP("DG53678A",$J,24)="List of Transmitted PTF records re-queued with a 'Katrina' indicator."
 . . S ^TMP("DG53678A",$J,25)="SSN(L4)   PTF#        Patient"
 . . S ^TMP("DG53678A",$J,26)="-------------------------------------------"
 . . S LINECT=26
 . . S DGNAM=0 F  S DGNAM=$O(^TMP("DG53678",$J,DGNAM)) Q:DGNAM=""  D
 . . . S DGSSN="" F  S DGSSN=$O(^TMP("DG53678",$J,DGNAM,DGSSN)) Q:DGSSN=""  D
 . . . . S DGPTF="" F  S DGPTF=$O(^TMP("DG53678",$J,DGNAM,DGSSN,DGPTF)) Q:DGPTF=""  D
 . . . . . S ^TMP("DG53678A",$J,LINECT+1)=DGSSN_"      "_DGPTF_"     "_DGNAM
 . . . . . S LINECT=LINECT+1
 D ^XMD
 K ^TMP("DG53678A",$J),^TMP("DG53678",$J),XMY,VADM Q
