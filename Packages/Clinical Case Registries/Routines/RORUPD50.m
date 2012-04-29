RORUPD50 ;HCIOFO/SG - UPDATE THE PATIENT IN THE REGISTRIES  ; 8/2/05 9:14am
 ;;1.5;CLINICAL CASE REGISTRIES;;Feb 17, 2006
 ;
 Q
 ;
 ;***** ADDS THE PATIENT TO THE REGISTRY
 ;
 ; PATIEN        Patient IEN
 ; REGIEN        Registry IEN
 ;
 ; [ROR8RULS]    Closed root of a local array containing list of
 ;               triggered selection rules:
 ;                 @ROR8RULS@(RuleIEN)=Date
 ;               If this parameter is not defined or equals to
 ;               an empty string, selection rules are loaded from
 ;               corresponding sub-node of the ^TMP("RORUPD",$J,"U").
 ;
 ; [[.]DOD]      Date of death. If this parameter is undefined,
 ;               its value will be taken from the ROR PATIENT file.
 ;               If you are going to call this function several times
 ;               for the same patient (for different registries),
 ;               pass a reference to undefined local variable (the
 ;               DOD will be read from the file only once).
 ;
 ; Return values:
 ;       <0  Error code
 ;        0  Ok
 ;        1  Patient has already existed in the registry
 ;
ADD(PATIEN,REGIEN,ROR8RULS,DOD) ;
 N I,IENS,IENS01,RC,RORFDA,RORIEN,RORMSG,RULEIEN,TMP
 ;--- Quit if the patient is already in the registry
 Q:$$PRRIEN^RORUTL01(PATIEN,REGIEN)>0 1
 ;
 ;--- Prepare registry data
 K RORFDA  S IENS="+1,"
 S RORFDA(798,IENS,.01)=PATIEN           ; Patient Name
 S RORFDA(798,IENS,.02)=REGIEN           ; Registry
 S RORFDA(798,IENS,3)=4                  ; Pending
 S RORFDA(798,IENS,4)=1                  ; Update Demographics
 S RORFDA(798,IENS,5)=1                  ; Update Local Data
 S RORFDA(798,IENS,11)=1                 ; Don't Send
 ;--- Get the date of death
 S:'($D(DOD)#10) DOD=$$GET1^DIQ(798.4,PATIEN_",",.351,"I",,"RORMSG")
 ;--- Load list of triggered rules
 S:$G(ROR8RULS)="" ROR8RULS=$NA(@RORUPDPI@("U",PATIEN,2,REGIEN))
 S RULEIEN=""
 F I=1:1  S RULEIEN=$O(@ROR8RULS@(RULEIEN))  Q:RULEIEN=""  D
 . S IENS01="+"_(1000+I)_","_IENS
 . S RORFDA(798.01,IENS01,.01)=RULEIEN  ; SELECTION RULE
 . S TMP=$P(@ROR8RULS@(RULEIEN),U)\1
 . S:TMP>0 RORFDA(798.01,IENS01,1)=TMP  ; DATE
 . S TMP=+$P(@ROR8RULS@(RULEIEN),U,2)
 . S:TMP>0 RORFDA(798.01,IENS01,2)=TMP  ; LOCATION
 ;
 ;--- Registry update transaction
 S RC=0  D
 . ;--- Call "before update" entry point
 . S ENTRY=$G(RORUPD("UPD",REGIEN,1))
 . I ENTRY'=""  X "S RC="_ENTRY_"(.RORFDA,PATIEN,REGIEN)"  Q:RC<0
 . ;--- Make sure that the DON'T SEND flag is set for 'test' patient
 . S:$$TESTPAT^RORUTL01(PATIEN) RORFDA(798,IENS,11)=1
 . ;--- Update the registry
 . D UPDATE^DIE(,"RORFDA","RORIEN","RORMSG")
 . I $G(DIERR)  S RC=$$DBS^RORERR("RORMSG",-9)  Q
 . ;--- Call "after update" entry point
 . S ENTRY=$G(RORUPD("UPD",REGIEN,2))
 . I ENTRY'=""  X "S RC="_ENTRY_"(RORIEN(1),PATIEN,REGIEN)"  Q:RC<0
 Q:RC'<0 0
 ;
 ;--- Rollback the update in case of error(s)
 N DA,DIK
 S DIK=$$ROOT^DILFD(798),DA=$G(RORIEN(1))
 D:DA>0 ^DIK
 Q RC
 ;
 ;***** ADDS PATIENT DATA TO THE 'ROR PATIENT' FILE
 ;
 ; PATIEN        Patient IEN
 ;
 ; Return values:
 ;       <0  Error code
 ;        0  Ok
 ;        1  Patient data have already existed
 ;
ADDPDATA(PATIEN) ;
 N IENS,RC,RORBUF,RORPAT,RORIEN,RORMSG
 ;--- Try to find patient data
 D FIND^DIC(798.4,,"@","QUX",PATIEN,1,"B",,,"RORBUF","RORMSG")
 Q:$G(DIERR) $$DBS^RORERR("RORMSG",-9,,,798.4)
 ;--- Patient data already exists in the file
 Q:$G(RORBUF("DILIST",0)) 1
 ;--- Check if the patient record in the file #2 is valid
 S RC=$$CHKPTR^RORUTL05(PATIEN)  Q:RC<0 RC
 ;--- Prepare patient data
 S IENS="+1,"
 S RC=$$PATDATA^RORUPD52(PATIEN_",",.RORPAT,IENS)  Q:RC<0 RC
 S RORIEN(1)=PATIEN                      ; IEN of the new record
 S RORPAT(798.4,IENS,.01)=PATIEN         ; Patient Name
 ;--- Add the patient record to the file
 D UPDATE^DIE(,"RORPAT","RORIEN","RORMSG")
 I $G(DIERR)  D  Q:RC
 . S RC=$$DBS^RORERR("RORMSG",-9,,PATIEN,798.4)
 Q 0
 ;
 ;***** ADDS THE PATIENT TO MARKED REGISTRIES
 ;
 ; PATIEN        Patient IEN
 ;
 ; Return values:
 ;       <0  Error code
 ;        0  Patient should not be added to the registry
 ;       >0  Patient has been added to the registry
 ;
UPDREG(PATIEN) ;
 N DOD,ENTRY,INCTVDT,RC,REGIEN
 ;--- Check if patient should be added to any registry
 Q:$D(@RORUPDPI@("U",PATIEN,2))<10 0
 ;--- Add patient data
 S RC=$$ADDPDATA(PATIEN)  Q:RC<0 RC
 ;--- Update all marked registries
 S REGIEN="",RC=0
 F  D  Q:REGIEN=""  S RC=$$ADD(PATIEN,REGIEN,,.DOD)  Q:RC<0
 . S REGIEN=$O(@RORUPDPI@("U",PATIEN,2,REGIEN))
 Q $S(RC<0:RC,1:1)
