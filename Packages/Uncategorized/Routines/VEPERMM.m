VEPERMM ;DAOU/KFK; HL7 ERROR REPORT MAIL MESSAGE GENERATION; ; 6/3/05 4:16pm
 ;;1.0;;;;Build 1
 ; This routine will determine if there is a mailgroup that is to
 ; receive the HL7 Error Report for Patient Lookup.
 ;
 ; Need to enter routine at a TAG.
 Q
 ;
MMEN ; Tag to be called by TaskMan to generate report with default values
 ; and send as MailMan message
 ;
 ; Initialize variables
 N BDT,EDT,HL7ERTN,HL7ESPC,TM
 ;
 ; Default report parameters
 ; Start Date/Time - End Date/Time range
 ; Determine start time based on site parameter
 ;
 S TM=$$GET1^DIQ(350.9,"1,",51.03,"E")
 I TM=""!(TM=0) S TM="2400"
 S EDT=$$DT^XLFDT
 S BDT=$$FMADD^XLFDT(EDT,-1)
 S HL7ESPC("BEGDTM")=+(BDT_"."_TM)
 S HL7ESPC("ENDDTM")=+(EDT_"."_TM)
 ; Sort by Patient
 S HL7ESPC("SORT")=2
 ; Set MailMan flag to site parameter email address
 S HL7ESPC("MM")=$$MGRP^IBCNEUT5
 ; If there is no email address to send message - do not continue
 I HL7ESPC("MM")="" Q
 ; If the send email message parameter is turned off, stop the process
 I '$P($G(^IBE(350.9,1,51)),U,2) Q
 ;
 ; Set routine parameter
 S HL7ERTN="VEPERIER"
 ;
 ; Initialize scratch global
 K ^TMP($J,HL7ERTN)
 ;
 ; Compile the report data
 I '$G(ZSTOP) D EN^VEPERIER(HL7ERTN,HL7ESPC)
 ;
 ; Kill scratch global
 K ^TMP($J,HL7ERTN)
 ;
 ; Purge the task record
 I $D(ZTQUEUED) S ZTREQ="@"
 ;
 ; MAILMSG exit
 Q
