RORX002 ;HCIOFO/SG - CURRENT INPATIENT LIST ; 10/20/06 4:09pm
 ;;1.5;CLINICAL CASE REGISTRIES;**1**;Feb 17, 2006;Build 24
 ;
 ; This routine uses the following IAs:
 ;
 ; #325          ADM^VADPT2 (controlled)
 ; #10061        51^VADPT (supported)
 ;
 Q
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
 ;;PATIENTS(#,NAME,LAST4,WARD,ROOM-BED)
 ;
 N HEADER,RC
 S HEADER=$$HEADER^RORXU002(.RORTSK,PARTAG)
 Q:HEADER<0 HEADER
 S RC=$$TBLDEF^RORXU002("HEADER^RORX002",HEADER)
 Q $S(RC<0:RC,1:HEADER)
 ;
 ;***** COMPILES THE "CURRENT INPATIENT LIST"
 ; REPORT CODE: 002
 ;
 ; .RORTSK       Task number and task parameters
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
INPTLST(RORTSK) ;
 N RORPTN        ; Number of patients in the registry
 N RORREG        ; Registry IEN
 N RORTMP        ; Closed root of the temporary buffer
 ;
 N BODY,ECNT,INPCNT,RC,REPORT,SFLAGS,TMP
 ;--- Root node of the report
 S REPORT=$$ADDVAL^RORTSK11(RORTSK,"REPORT")
 Q:REPORT<0 REPORT
 ;
 ;--- Get and prepare the report parameters
 S RORREG=$$PARAM^RORTSK01("REGIEN")
 S RC=$$PARAMS^RORXU002(.RORTSK,REPORT,,,.SFLAGS)  Q:RC<0 RC
 ;
 ;--- Initialize constants and variables
 S ECNT=0
 S RORPTN=$$REGSIZE^RORUTL02(+RORREG)  S:RORPTN<0 RORPTN=0
 ;
 ;--- Report header
 S RC=$$HEADER(REPORT)  Q:RC<0 RC
 S RORTMP=$$ALLOC^RORTMP()
 D
 . ;--- Query the registry
 . D TPPSETUP^RORTSK01(50)
 . S RC=$$QUERY(.INPCNT,SFLAGS)
 . I RC  Q:RC<0  S ECNT=ECNT+RC
 . ;--- Generate the list of patients
 . D TPPSETUP^RORTSK01(50)
 . S RC=$$PTLIST(REPORT,INPCNT)
 . I RC  Q:RC<0  S ECNT=ECNT+RC
 ;
 ;--- Cleanup
 D FREE^RORTMP(RORTMP)
 Q $S(RC<0:RC,ECNT>0:-43,1:0)
 ;
 ;***** ADDS THE PATIENT DATA TO THE REPORT
 ;
 ; NODE          Closed root of the patient's node in the buffer
 ; PARTAG        Reference (IEN) to the parent tag
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
PATIENT(NODE,PARTAG) ;
 N IEN,NAME,PATIEN,PTAG,PTBUF,RC,TMP
 S PTBUF=@NODE,PATIEN=$P(PTBUF,U,2)
 Q:PATIEN'>0 0
 ;--- The <PATIENT> tag
 S PTAG=$$ADDVAL^RORTSK11(RORTSK,"PATIENT",,PARTAG,,PATIEN)
 ;--- Patient data
 D ADDVAL^RORTSK11(RORTSK,"NAME",$QS(NODE,4),PTAG,1)
 D ADDVAL^RORTSK11(RORTSK,"LAST4",$QS(NODE,5),PTAG,2)
 S TMP=$$DATE^RORXU002($P(PTBUF,U,4)\1)
 ;D ADDVAL^RORTSK11(RORTSK,"DOD",TMP,PTAG,1)
 D ADDVAL^RORTSK11(RORTSK,"WARD",$QS(NODE,3),PTAG,1)
 D ADDVAL^RORTSK11(RORTSK,"ROOM-BED",$P(PTBUF,U,3),PTAG,1)
 Q 0
 ;
 ;***** GENERATES THE LIST OF PATIENTS
 ;
 ; REPORT        IEN of the <REPORT> node
 ; INPCNT        Number of inpatients
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Number of non-fatal errors
 ;
PTLIST(REPORT,INPCNT) ;
 N BODY,CNT,ECNT,FLT,FLTLEN,NODE,RC,TCNT,TMP
 S (CNT,ECNT,RC)=0
 S BODY=$$ADDVAL^RORTSK11(RORTSK,"PATIENTS",,REPORT)
 Q:BODY<0 BODY
 D ADDATTR^RORTSK11(RORTSK,BODY,"TABLE","PATIENTS")
 D:$D(@RORTMP)>1
 . S NODE=RORTMP
 . S FLTLEN=$L(NODE)-1,FLT=$E(NODE,1,FLTLEN)
 . F  S NODE=$Q(@NODE)  Q:$E(NODE,1,FLTLEN)'=FLT  D  Q:RC<0
 . . S TMP=$S(INPCNT>0:CNT/INPCNT,1:"")
 . . S RC=$$LOOP^RORTSK01(TMP)  Q:RC<0
 . . S CNT=CNT+1
 . . I $$PATIENT(NODE,BODY)<0  S ECNT=ECNT+1  Q
 Q $S(RC<0:RC,1:ECNT)
 ;
 ;***** QUERIES THE REGISTRY
 ;
 ; .INPCNT       Number of inpatients is returned in this parameter
 ; SFLAGS        Flags for $$SKIP^RORXU005
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Number of non-fatal errors
 ;
QUERY(INPCNT,SFLAGS) ;
 N CNT,DFN,ECNT,IEN,IENS,RC,TCNT,TMP,VA,VADM,VAHOW,VAIP,VAROOT,XREFNODE,WARD
 S XREFNODE=$NA(^RORDATA(798,"AC",+RORREG))
 S (CNT,ECNT,INPCNT,RC)=0
 ;--- Browse through the registry records
 S IEN=0
 F  S IEN=$O(@XREFNODE@(IEN))  Q:IEN'>0  D  Q:RC<0
 . S TMP=$S(RORPTN>0:CNT/RORPTN,1:"")
 . S RC=$$LOOP^RORTSK01(TMP)  Q:RC<0
 . S IENS=IEN_",",CNT=CNT+1
 . ;--- Skip a patient
 . Q:$$SKIP^RORXU005(IEN,SFLAGS)
 . ;--- Process the registry record
 . S DFN=$$PTIEN^RORUTL01(IEN)  Q:DFN'>0
 . K VA,VADM,VAIP  S VAIP("D")=DT\1  D 51^VADPT
 . S WARD=$P(VAIP(5),U,2)  Q:WARD=""
 . S TMP=$S($G(VA("BID"))'="":VA("BID"),1:"UNKN") ; Last 4 of SSN
 . S @RORTMP@(WARD,VADM(1),TMP)=IEN_U_DFN_U_$P(VAIP(6),U,2)_U_$P(VADM(6),U)
 . S INPCNT=INPCNT+1
 ;---
 Q $S(RC<0:RC,1:ECNT)
 ;
 ;***** CHECKS THE SUFFIX FOR VALIDITY
 ;
 ; SUFFIX        Suffix
 ;
 ; Return Values:
 ;        0  Ok
 ;        1  Invalid suffix
VSUFFIX(SUFFIX) ;
 Q '("9AA,9AB,9BB,A0,A4,A5,BU,BV,PA"[SUFFIX)
