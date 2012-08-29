RORXU001 ;HCIOFO/BH,SG - REPORT UTILITIES  ; 1/24/06 8:14am
 ;;1.5;CLINICAL CASE REGISTRIES;;Feb 17, 2006
 ;
 ; This routine uses the following IAs:
 ;
 ; #92           Read access to the file #45 (controlled)
 ;               fields 3 and 4.
 ; #1480         Read access to the file #405 (controlled)
 ; #1894         ENCEVENT^PXKENC (controlled)
 ;
 Q
 ;
 ;***** DOUBLE CHECKS THE ADMISSION
 ;
 ; DFN           Patient IEN
 ; VAINDT        Admission date
 ; .DISDT        Discharge date
 ;
 ; Return Values:
 ;        0  Ok
 ;        1  Invalid admission date
 ;
CHKADM(DFN,VAINDT,DISDT) ;
 N IEN,RORMSG,VADMVT,VAHOW,VAROOT
 D ADM^VADPT2  Q:'VADMVT 1
 S IEN=+$$GET1^DIQ(405,VADMVT,.17,"I",,"RORMSG")
 S:IEN>0 DISDT=$$GET1^DIQ(405,IEN_",",.01,"I",,"RORMSG")
 Q 0
 ;
 ;***** DATE OF THE MOST RECENT VISIT TO ANY OF THE SELECTED CLINICS
 ;
 ; PATIEN        Patient IEN (file #2)
 ;
 ; .RORCLIN      Reference to a local array of Clinics, the subscripts
 ;               are IEN's from file #44 or will be a single element
 ;               array with a subscript of "ALL", which will denote
 ;               all clinics (i.e. CLIN("ALL")="").
 ;
 ; Return Values:
 ;        0  The patient has never been seen at any of the given
 ;           clinics
 ;       >0  Date of the most recent visit to one of the selected
 ;           clinics
 ;
LASTVSIT(PATIEN,RORCLIN) ;
 N QUERY,RORDT,RORLAST
 S RORDT=$$FMADD^XLFDT($$DT^XLFDT,1),RORLAST=0
 ;---
 D OPEN^SDQ(.QUERY)
 D INDEX^SDQ(.QUERY,"PATIENT","SET")
 D PAT^SDQ(.QUERY,PATIEN,"SET")
 D SCANCB^SDQ(.QUERY,"D SDQSCAN2^RORXU001(Y,Y0)","SET")
 D ACTIVE^SDQ(.QUERY,"TRUE","SET")
 D SCAN^SDQ(.QUERY,"FORWARD")
 D CLOSE^SDQ(.QUERY)
 ;---
 Q RORLAST
 ;
 ;***** LOADS PTF DATA AND CHECKS IF THE RECORD SHOULD BE SKIPPED
 ;
 ; PTFIEN        IEN of the PTF record
 ;
 ; [FLAGS]       Flags to control processing
 ;                 F  Skip fee-basis records
 ;                 P  Skip non-PTF records
 ;
 ; [.ADMDT]      Admission date is returned via this parameter
 ; [.DISDT]      Discharge date is returned via this parameter
 ; [.SUFFIX]     Suffix is returned via this parameter
 ; [.STATUS]     Status is returned via this parameter
 ; [.FACILITY]   Facility number is returned via this parameter
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;        1  Skip this record
 ;
PTF(PTFIEN,FLAGS,ADMDT,DISDT,SUFFIX,STATUS,FACILITY) ;
 N FLDLST,IENS,RORBUF,RORMSG
 S FLAGS=$G(FLAGS),IENS=(+PTFIEN)_","
 S FLDLST="2;3;5;6;70"
 S:FLAGS["F" FLDLST=FLDLST_";4"        ; FEE BASIS
 S:FLAGS["P" FLDLST=FLDLST_";11"       ; TYPE OF RECORD
 ;--- Load the data
 D GETS^DIQ(45,IENS,FLDLST,"I","RORBUF","RORMSG")
 Q:$G(DIERR) $$DBS^RORERR("RORMSG",-9,,,45,IENS)
 ;---
 S ADMDT=$G(RORBUF(45,IENS,2,"I"))     ; ADMISSION DATE
 S FACILITY=$G(RORBUF(45,IENS,3,"I"))  ; FACILITY
 S SUFFIX=$G(RORBUF(45,IENS,5,"I"))    ; SUFFIX
 S STATUS=$G(RORBUF(45,IENS,6,"I"))    ; STATUS
 S DISDT=$G(RORBUF(45,IENS,70,"I"))    ; DISCHARGE DATE
 Q:ADMDT'>0 1
 ;--- Skip a non-PTF record
 I FLAGS["P"  Q:$G(RORBUF(45,IENS,11,"I"))'=1 1
 ;--- Skip a fee basis record
 I FLAGS["F"  Q:$G(RORBUF(45,IENS,4,"I")) 1
 ;--- Success
 Q 0
 ;
 ;**** CALL-BACK ENTRY POINTS FOR THE SDQ API
SDQSCAN1(Y,Y0) ;
 N TMP
 ;--- Check the clinic
 I '$$PARAM^RORTSK01("CLINICS","ALL")  D  Q:'TMP
 . S TMP=$D(RORTSK("PARAMS","CLINICS","C",+$P(Y0,U,4)))
 ;--- Count the encounters
 S RORENCNT=RORENCNT+1
 Q
 ;
SDQSCAN2(Y,Y0) ;
 N DTX,TMP
 ;--- Check the clinic
 I '$$PARAM^RORTSK01("CLINICS","ALL")  D  Q:'TMP
 . S TMP=$D(RORTSK("PARAMS","CLINICS","C",+$P(Y0,U,4)))
 ;--- Date of the visit
 S DTX=+$P(Y0,U)  S:(DTX>RORLAST)&(DTX<RORDT) RORLAST=DTX
 Q
 ;
 ;***** CHECKS IF THE PATIENT WAS SEEN AT SELECTED CLINICS
 ;
 ; RORSDT        Start Date for search (FileMan).
 ;               Time is ignored and the beginning of the day is
 ;               considered as the boundary (ST\1).
 ;
 ; ROREDT        End Date for search (FileMan).
 ;               Time is ignored and the end of the day is
 ;               considered as the boundary (ED\1+1).
 ;
 ; PATIEN        Patient IEN (file #2)
 ;
 ; Return Values:
 ;        0  The patient was not seen at any of the given clinics
 ;           during the provided time frame
 ;        1  The patient was seen
 ; 
SEEN(RORSDT,ROREDT,PATIEN) ;
 N QUERY,RORENCNT
 S RORENCNT=0
 ;---
 D OPEN^SDQ(.QUERY)
 D INDEX^SDQ(.QUERY,"PATIENT/DATE","SET")
 D PAT^SDQ(.QUERY,PATIEN,"SET")
 D DATE^SDQ(.QUERY,RORSDT\1,$$FMADD^XLFDT(ROREDT\1,1),"SET")
 D SCANCB^SDQ(.QUERY,"D SDQSCAN1^RORXU001(Y,Y0)","SET")
 D ACTIVE^SDQ(.QUERY,"TRUE","SET")
 D SCAN^SDQ(.QUERY,"FORWARD")
 D CLOSE^SDQ(.QUERY)
 ;---
 Q (RORENCNT>0)
