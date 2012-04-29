RORX007A ;HCIOFO/BH,SG - RADIOLOGY UTILIZATION (OVERFLOW) ; 11/14/06 8:51am
 ;;1.5;CLINICAL CASE REGISTRIES;**1**;Feb 17, 2006;Build 24
 ;
 ; This routine uses the following IAs:
 ;
 ; #2043         EN1^RAO7PC1 (supported)
 ;
 Q
 ;
 ;***** APPENDS MODIFIERS TO THE CPT CODE
 ;
 ; CPT           CPT code
 ;
 ; NODE          Closed root of the exam data node returned
 ;               by the EN1^RAO7PC1
 ;
CPTMOD(CPT,NODE) ;
 N CPM,RORIM
 S RORIM=""
 F  S RORIM=$O(@NODE@("CMOD",RORIM))  Q:RORIM=""  D
 . S CPM=$P($G(@NODE@("CMOD",RORIM)),U)
 . S:CPM'="" CPT=CPT_"-"_CPM
 Q CPT
 ;
 ;***** LOADS AND PROCESSES THE RADILOGY DATA
 ;
 ; DFN           Patient IEN (in file #2)
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
GETDATA(DFN) ;
 N CPT,EXAMID,NODE,PRNAME,RORBUF
 ;--- Get the data
 D EN1^RAO7PC1(DFN,RORSDT,ROREDT,999999)
 Q:'$D(^TMP($J,"RAE1",PATIEN)) 0
 ;
 ;--- Process the data
 S EXAMID=""
 F  S EXAMID=$O(^TMP($J,"RAE1",DFN,EXAMID))  Q:EXAMID=""  D
 . S NODE=$NA(^TMP($J,"RAE1",DFN,EXAMID))
 . S RORBUF=$G(@NODE),CPT=$$CPTMOD($P(RORBUF,U,10),NODE)
 . ;--- Get Procedure Name
 . S PRNAME=$E($P(RORBUF,U),1,30)  Q:PRNAME=""
 . S PRNAME=PRNAME_U_$S(CPT'="":CPT,1:" ")
 . ;--- Increment the counters
 . S ^(DFN)=$G(^TMP("RORX007",$J,"PROC",PRNAME,DFN))+1
 . S ^(PRNAME)=$G(^TMP("RORX007",$J,"PAT",DFN,PRNAME))+1
 ;
 ;--- Cleanup
 K ^TMP($J,"RAE1")
 Q 0
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
 ;;PATIENTS(#,NAME,LAST4,DOD,TOTAL,UNIQUE)
 ;;PROCEDURES(#,NAME,CPT,PATIENTS,TOTAL)
 ;
 N HEADER,RC
 S HEADER=$$HEADER^RORXU002(.RORTSK,PARTAG)
 Q:HEADER<0 HEADER
 S RC=$$TBLDEF^RORXU002("HEADER^RORX007A",HEADER)
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
 N NAME,PARAMS,TMP
 S PARAMS=$$PARAMS^RORXU002(.RORTSK,PARTAG,.STDT,.ENDT,.FLAGS)
 Q:PARAMS<0 PARAMS
 ;--- Additional parameters
 F NAME="MAXUTNUM","MINRPNUM"  D
 . S TMP=$$PARAM^RORTSK01(NAME)
 . D:TMP'="" ADDVAL^RORTSK11(RORTSK,NAME,TMP,PARAMS)
 ;---
 Q PARAMS
 ;
 ;***** QUERIES THE REGISTRY
 ;
 ; FLAGS         Flags for the $$SKIP^RORXU005
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Number of non-fatal errors
 ;
QUERY(FLAGS) ;
 N CNT,ECNT,IEN,IENS,PATIEN,RC,RORMSG,TMP,XREFNODE
 S XREFNODE=$NA(^RORDATA(798,"AC",+RORREG))
 S (CNT,ECNT,RC)=0
 ;--- Browse through the registry records
 S IEN=0
 F  S IEN=$O(@XREFNODE@(IEN))  Q:IEN'>0  D  Q:RC<0
 . S TMP=$S(RORPTN>0:CNT/RORPTN,1:"")
 . S RC=$$LOOP^RORTSK01(TMP)  Q:RC<0
 . S IENS=IEN_",",CNT=CNT+1
 . ;--- Check if the patient should be skipped
 . Q:$$SKIP^RORXU005(IEN,FLAGS,RORSDT,ROREDT)
 . ;
 . ;--- Get the patient IEN (DFN)
 . S PATIEN=$$PTIEN^RORUTL01(IEN)  Q:PATIEN'>0
 . ;
 . ;--- Get the radiology data
 . S RC=$$GETDATA(PATIEN)
 . I RC  S ECNT=ECNT+1  Q:RC<0
 ;---
 Q $S(RC<0:RC,1:ECNT)
 ;
 ;***** PLURAL/SINGULAR
SRPL(QNTY,WORD,SQ) ;
 Q $S('$G(SQ):QNTY_" ",1:"")_$P(WORD,U,$S(QNTY=1:1,1:2))
