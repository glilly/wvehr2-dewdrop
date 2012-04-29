RORRP030 ;HCIOFO/SG - RPC: PATIENT DELETE ; 11/29/05 3:04pm
 ;;1.5;CLINICAL CASE REGISTRIES;;Feb 17, 2006
 ;
 Q
 ;
 ;***** MARKS THE PATIENT'S RECORD AS DELETED FROM THE REGISTRY
 ; RPC: [ROR PATIENT DELETE]
 ;
 ; .RESULTS      Reference to a local variable where the results
 ;               are returned to.
 ;
 ; REGIEN        Registry IEN
 ;
 ; RORDFN        IEN of the patient
 ;
 ; [FORCE]       Deprecated
 ;
 ; Return Values:
 ;
 ; A negative value of the first "^"-piece of the RESULTS(0)
 ; indicates an error (see the RPCSTK^RORERR procedure for more
 ; details).
 ;
 ; Otherwise, the following codes can be returned in the RESULTS(0):
 ;
 ;         0  The record cannot be deleted
 ;         9  The record has been marked as deleted
 ;
DELETE(RESULTS,REGIEN,RORDFN,FORCE) ;
 N IENS,RC,REGNAME,RORFDA,RORMSG,TMP
 D CLEAR^RORERR("DELETE^RORRP030",1)
 K RESULTS  S RESULTS(0)=0
 ;
 ;--- Get the registry description/name
 S TMP=$$REGNAME^RORUTL01(REGIEN)
 I TMP=""  D  D RPCSTK^RORERR(.RESULTS,RC)  Q
 . S RC=$$ERROR^RORERR(-1,,,RORDFN)
 S REGNAME=$S($P(TMP,U,2)'="":$P(TMP,U,2),1:$P(TMP,U))
 ;
 ;--- Get IENS of the registry record
 S IENS=$$PRRIEN^RORUTL01(RORDFN,REGIEN)_","
 I IENS'>0  D  D RPCSTK^RORERR(.RESULTS,RC)  Q
 . S RC=$$ERROR^RORERR(-97,,,RORDFN,REGNAME)
 ;
 I $$PENDING^RORUTL18(+IENS)  D
 . ;--- Delete the pending record immediately
 . N DA,DIK  S DIK=$$ROOT^DILFD(798),DA=+IENS  D ^DIK
 E  D
 . ;--- Mark the record as deleted
 . S RORFDA(798,IENS,3)=5
 . D FILE^DIE(,"RORFDA","RORMSG")
 . I $G(DIERR)  D  D RPCSTK^RORERR(.RESULTS,RC)
 . . S RC=$$DBS^RORERR("RORMSG",-9,,RORDFN,798,IENS)
 ;---
 S RESULTS(0)=9
 Q
