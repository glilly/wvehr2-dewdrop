BPSOSIZ ;BHAM ISC/FCS/DRS/DLF - Filing BPS Transaction ;06/01/2004
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 Q
 ;
 ; EN - Create and/or update BPS Transaction
 ; Input
 ;   IEN59    - BPS Transaction number
 ;   MOREDATA - Array of data created by BPSNCPD*
EN(IEN59,MOREDATA) ;EP - BPSOSRB
 ;
 ; Initialize variables
 N RX,RXR,EXISTS,ERROR,X
 S ERROR=0,RX=$P(IEN59,"."),RXR=+$E($P(IEN59,".",2),1,4)
 ;
 ;
 D LOG^BPSOSL(IEN59,$T(+0)_"-Building Transaction")
 ;
 ; Lock the transaction
 I '$$LOCK59(IEN59) D ERROR(IEN59,"Could not lock the transaction") Q
 ;
 ; Check for claims that should not be resubmitted
 S X=$$RXPAID^BPSOSIY(IEN59)
 I X D ERROR(IEN59,"RXPAID^BPSOSIY returned "_X) Q
 ;
 ; Make sure that the record is not already IN PROGRESS
 S X=+$$STATUS59^BPSOSRX(IEN59)
 I X'=0,X'=99 D ERROR(IEN59,"STATUS is "_X) Q
 ;
 ; Check if the BPS Transaction exists
 S EXISTS=$$EXIST59(IEN59)
 ;
 ; If the record exists, delete all but the essential fields
 I EXISTS D CLEAR59(IEN59)
 ;
 ; If the record does not exist, create new record and validate the IEN
 I 'EXISTS S X=$$NEW59(IEN59) I X'=IEN59 D ERROR(IEN59,"NEW59 returned "_X) Q
 ;
 ; Update the fields.  If error is returned, log to the BPS Transaction, which
 ;   we know exists at this point
 S ERROR=$$INIT^BPSOSIY(IEN59)
 I ERROR D ERROR^BPSOSU($T(+0),IEN59,ERROR,"BPS Transaction not updated"),UNLOCK59(IEN59) Q
 ;
 ; Validate the transaction
 D ONE59^BPSOSQA(IEN59)
 ;
 ; Unlock the transaction
 D UNLOCK59(IEN59)
 Q
 ;
 ; LOCK59 - Lock Transaction
LOCK59(IEN59) ;
 L +^BPST(IEN59):5
 Q $T
 ;
 ; UNLOCK59 - Unlock record
UNLOCK59(IEN59) ;
 L -^BPST(IEN59)
 Q
 ;
 ; EXISTS - See if the BPS Transaction already exists
EXIST59(IEN59) ;
 N X
 S X=$$FIND1^DIC(9002313.59,,"QX","`"_IEN59)
 Q $S(X>0:X,X=0:0)
 ;
 ; NEW59 - Create a new BPS Transaction record
NEW59(IEN59) ;
 ; Initialize variables
 N FDA,IEN,MSG,FN
 ;
 ; The .01 node and IEN should be the transaction number
 S FN=9002313.59
 S (IEN(1),FDA(FN,"+1,",.01))=IEN59
 ;
 ; Create the new BPS Transaction record
 D UPDATE^DIE("","FDA","IEN","MSG")
 I $D(MSG) Q 0
 Q IEN(1)
 ;
 ; CLEAR59 - If it exists, clear out the old values
CLEAR59(IEN59) ;
 ; Deletes all values except for fields:
 ;   Entry # (.01)
 ;   Resubmit after reversal (1.12)
 ;   Result Text (202)
 ;   Comments (111 multiple)
 ; If reverse/resubmit, then also do not clear fields:
 ;   Status (1)
 ;   Submit Date/Time (6)
 ;   Last Update (7)
 ;   Start Date (15)
 ;
 ; Initialize variables
 N FN,FDA,MSG,FIELD,SKIP,ENTRY
 S FN=9002313.59
 ;
 ; Set up fields that we do not want to delete
 S SKIP(1.12)="",SKIP(202)=""
 I $G(MOREDATA("REVERSE THEN RESUBMIT"))=1 S SKIP(1)="",SKIP(6)="",SKIP(7)="",SKIP(15)=""
 ;
 ; Start with field .01 so it will not be deleted
 ; Place 'non-skip' fields in FDA to be deleted
 S FIELD=.01
 F  S FIELD=$O(^DD(FN,FIELD)) Q:'FIELD  I '$D(SKIP(FIELD)) S FDA(FN,IEN59_",",FIELD)=""
 ;
 ; Delete Insurance multiple
 S FN=9002313.59902,ENTRY=0
 F  S ENTRY=$O(^BPST(IEN59,10,ENTRY)) Q:ENTRY="B"!(ENTRY="")  D
 . S FDA(FN,ENTRY_","_IEN59_",",.01)=""
 ;
 ; Delete DUR multiple
 S FN=9002313.5913,ENTRY=0
 F  S ENTRY=$O(^BPST(IEN59,13,ENTRY)) Q:+ENTRY=0  D
 . S FDA(FN,ENTRY_","_IEN59_",",.01)=""
 ;
 ; Fileman call to do the delete
 D FILE^DIE("","FDA","MSG")
 ;
 ; Update Result Text File with 'PREVIOUSLY['
 D PREVISLY(IEN59) ; for result text field 202
 Q
 ;
 ; PREVISLY - Add semicolon in between the result text
PREVISLY(IEN59) ;EP - BPSOSRB, BPSOSU
 N X
 S X=$$GET1^DIQ(9002313.59,IEN59,202)
 I X="" Q
 S X=$E(";"_X,1,200)
 N FN,FDA,MSG
 S FDA(9002313.59,IEN59_",",202)=X
 D FILE^DIE("","FDA","MSG")
 Q
 ;
 ; ERROR - Log an error to the log
ERROR(IEN59,MSG) ;
 N RX,RXR
 S RX=$P(IEN59,"."),RXR=+$E($P(IEN59,".",2),1,4)
 D LOG^BPSOSL(IEN59,$T(+0)_"-Skipping: "_$G(MSG))
 K ^XTMP("BPSOSRX",RX,RXR)
 D UNLOCK59(IEN59)
 Q
