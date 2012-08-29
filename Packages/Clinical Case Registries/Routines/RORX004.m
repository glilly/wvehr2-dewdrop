RORX004 ;HOIFO/BH,SG - CLINIC FOLLOW UP ; 11/15/05 8:50am
 ;;1.5;CLINICAL CASE REGISTRIES;;Feb 17, 2006
 ;
 ; This routine uses the following IAs:
 ;
 ; #10040        Access to the HOSPITAL LOCATION file (supported)
 ; #10061        2^VADPT (supported)
 ;
 Q
 ;
 ;***** COMPILES THE "CLINIC FOLLOW UP" REPORT
 ; REPORT CODE: 004
 ;
 ; .RORTSK       Task number and task parameters
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
CLNFLWUP(RORTSK) ;
 N ROREDT        ; End date
 N RORREG        ; Registry IEN
 N RORSDT        ; Start date
 ;
 N CNT,ECNT,IEN,IENS,PATIENTS,RC,REPORT,RORPTN,SFLAGS,TMP,XREFNODE
 ;--- Root node of the report
 S REPORT=$$ADDVAL^RORTSK11(RORTSK,"REPORT")
 Q:REPORT<0 REPORT
 ;
 ;--- Get and prepare the report parameters
 S RORREG=$$PARAM^RORTSK01("REGIEN")
 S RC=$$PARAMS(REPORT,.RORSDT,.ROREDT,.SFLAGS)
 Q:RC<0 RC
 ;
 ;--- Initialize constants and variables
 S RORPTN=$$REGSIZE^RORUTL02(+RORREG)  S:RORPTN<0 RORPTN=0
 S ECNT=0,XREFNODE=$NA(^RORDATA(798,"AC",RORREG))
 ;
 D
 . ;--- Report header
 . S RC=$$HEADER(REPORT)  Q:RC<0
 . S PATIENTS=$$ADDVAL^RORTSK11(RORTSK,"PATIENTS",,REPORT)
 . I PATIENTS<0  S RC=+PATIENTS  Q
 . D ADDATTR^RORTSK11(RORTSK,PATIENTS,"TABLE","PATIENTS")
 . ;
 . ;--- Browse through the registry records
 . D TPPSETUP^RORTSK01(100)
 . S (CNT,IEN,RC)=0
 . F  S IEN=$O(@XREFNODE@(IEN))  Q:IEN'>0  D  Q:RC<0
 . . S TMP=$S(RORPTN>0:CNT/RORPTN,1:"")
 . . S RC=$$LOOP^RORTSK01(TMP)  Q:RC<0
 . . S IENS=IEN_",",CNT=CNT+1
 . . ;--- Check if the patient should be skipped
 . . Q:$$SKIP^RORXU005(IEN,SFLAGS,RORSDT,ROREDT)
 . . ;--- Process the registry record
 . . S TMP=$$PATIENT(IENS,PATIENTS)
 . . I TMP<0  S ECNT=ECNT+1  Q
 . Q:RC<0
 ;
 ;--- Cleanup
 Q $S(RC<0:RC,ECNT>0:-43,1:0)
 ;
 ;***** OUTPUTS THE REPORT HEADER
 ;
 ; PARTAG        Reference (IEN) to the parent tag
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
HEADER(PARTAG) ;
 ;;PATIENTS(#,NAME,LAST4,DOD,SEEN,LSNDT)
 ;
 N HEADER,RC
 S HEADER=$$HEADER^RORXU002(.RORTSK,PARTAG)
 Q:HEADER<0 HEADER
 S RC=$$TBLDEF^RORXU002("HEADER^RORX004",HEADER)
 Q $S(RC<0:RC,1:HEADER)
 ;
 ;***** OUTPUTS THE PARAMETERS TO THE REPORT
 ;
 ; PARTAG        Reference (IEN) to the parent tag
 ;
 ; [.STDT]       Start and end dates of the report
 ; [.ENDT]       are returned via these parameters
 ;
 ; [.FLAGS]      Flags for the $$SKIP^RORXU005 are
 ;               returned via this parameter
 ;
 ; Return Values:
 ;       <0  Error code
 ;       >0  IEN of the PARAMETERS element
 ;
PARAMS(PARTAG,STDT,ENDT,FLAGS) ;
 N PARAMS,TMP
 S PARAMS=$$PARAMS^RORXU002(.RORTSK,PARTAG,.STDT,.ENDT,.FLAGS)
 Q:PARAMS<0 PARAMS
 ;--- Process the list of clinics
 S TMP=$$CLINLST^RORXU006(.RORTSK,PARAMS)
 Q:TMP<0 TMP
 ;---
 Q PARAMS
 ;
 ;***** ADDS THE PATIENT DATA TO THE REPORT
 ;
 ; IENS          IENS of the patient's record in the registry
 ; PARTAG        Reference (IEN) to the parent tag
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Skip the patient
 ;
PATIENT(IENS,PARTAG) ;
 N CHK,CLINAIDS,DFN,IEN,RC,RORBUF,RORMSG,SEEN,TMP,VA,VADM,VAHOW,VAROOT
 S RC=0
 S DFN=$$PTIEN^RORUTL01(+IENS)
 ; 
 ;--- Only include patients that received utilization if care is true
 I $$PARAM^RORTSK01("PATIENTS","CAREONLY")  D  Q:'TMP 1
 . S CHK("ALL")=""
 . S TMP=$$UTIL^RORXU003(RORSDT,ROREDT,DFN,.CHK)
 ;
 ;--- Select Seen/NotSeen patients
 S SEEN=$$SEEN^RORXU001(RORSDT,ROREDT,DFN)
 Q:'$$PARAM^RORTSK01("PATIENTS",$S(SEEN:"SEEN",1:"NOTSEEN")) 1
 ;
 ;--- Load the demographic data
 D 2^VADPT
 ;
 ;--- The <PATIENT> tag
 S PTAG=$$ADDVAL^RORTSK11(RORTSK,"PATIENT",,PARTAG,,DFN)
 Q:PTAG<0 PTAG
 ;
 ;--- Patient Name
 D ADDVAL^RORTSK11(RORTSK,"NAME",VADM(1),PTAG,1)
 ;--- Last 4 digits of the SSN
 D ADDVAL^RORTSK11(RORTSK,"LAST4",VA("BID"),PTAG,2)
 ;--- Date of Death
 S TMP=$$DATE^RORXU002($P(VADM(6),U)\1)
 D ADDVAL^RORTSK11(RORTSK,"DOD",TMP,PTAG,1)
 ;--- Seen/Not Seen
 D ADDVAL^RORTSK11(RORTSK,"SEEN",SEEN,PTAG,1)
 ;--- The latest date the patient was seen at any one of
 ;--- the given clinics
 S TMP=$$LASTVSIT^RORXU001(DFN)\1
 D ADDVAL^RORTSK11(RORTSK,"LSNDT",$$DATE^RORXU002(TMP),PTAG,1)
 Q 0
