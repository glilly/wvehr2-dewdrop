RORX016A        ;HOIFO/BH,SG,VAC - OUTPATIENT UTILIZATION (QUERY) ;4/7/09 2:10pm
        ;;1.5;CLINICAL CASE REGISTRIES;**8**;Feb 17, 2006;Build 8
        ;
        ; This routine uses the following IAs:
        ;
        ; #557          Read access to the file #40.7 (controlled)
        ; #2548         APIs in routine SDQ: ACRP Interface Toolkit (supported)
        ; #10103        FMADD^XLFDT (supported)
        ;
        ; This routine modified March 2009 for ICD9 Filter for Include or
        ;    Exclude
        Q
        ;
        ;***** LOADS AND PROCESSES THE OUTPATIENT DATA
        ;
        ; RORDFN        Patient IEN (in file #2)
        ;
        ; Return Values:
        ;       <0  Error code
        ;        0  Ok
        ;       >0  Number of non-fatal errors
        ;
OPDATA(RORDFN)  ;
        N QUERY,RORDST,RORECNT
        S RORDST=$NA(^TMP("RORX016",$J))
        D OPEN^SDQ(.QUERY)
        D INDEX^SDQ(.QUERY,"PATIENT/DATE","SET")
        D PAT^SDQ(.QUERY,RORDFN,"SET")
        D DATE^SDQ(.QUERY,RORSDT,ROREDT1,"SET")
        D SCANCB^SDQ(.QUERY,"D SCAN^RORX016A(Y,Y0)","SET")
        D ACTIVE^SDQ(.QUERY,"TRUE","SET")
        D SCAN^SDQ(.QUERY,"FORWARD")
        D CLOSE^SDQ(.QUERY)
        Q +$G(RORECNT)
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
QUERY(FLAGS)    ;
        N ROREDT1       ; Day after the end date
        N RORLAST4      ; Last 4 digits of the current patient's SSN
        N RORPNAME      ; Name of the current patient
        N RORPTN        ; Number of patients in the registry
        ;
        N CNT,ECNT,IEN,IENS,PATIEN,RC,TMP,VA,VADM,XREFNODE
        N RCC,FLAG
        S XREFNODE=$NA(^RORDATA(798,"AC",+RORREG))
        S RORPTN=$$REGSIZE^RORUTL02(+RORREG)  S:RORPTN<0 RORPTN=0
        S ROREDT1=$$FMADD^XLFDT(ROREDT,1)
        S (CNT,ECNT,RC)=0
        ;--- Browse through the registry records
        S IEN=0
        S FLAG=$G(RORTSK("PARAMS","ICD9FILT","A","FILTER"))
        F  S IEN=$O(@XREFNODE@(IEN))  Q:IEN'>0  D  Q:RC<0
        . S TMP=$S(RORPTN>0:CNT/RORPTN,1:"")
        . S RC=$$LOOP^RORTSK01(TMP)  Q:RC<0
        . S IENS=IEN_",",CNT=CNT+1
        . ;--- Check if the patient should be skipped
        . Q:$$SKIP^RORXU005(IEN,FLAGS,RORSDT,ROREDT)
        . ;
        . ;--- Get the patient IEN (DFN)
        . S PATIEN=$$PTIEN^RORUTL01(IEN)  Q:PATIEN'>0
        . ;--- Check the patient against the ICD9 Filter
        . S RCC=0
        . I FLAG'="ALL" D
        . . S RCC=$$ICD^RORXU010(PATIEN,RORREG)
        . I (FLAG="INCLUDE")&(RCC=0) Q
        . I (FLAG="EXCLUDE")&(RCC=1) Q
        . ;--- End of ICD9 Filter check
        . ;
        . ;--- Get the patient's data
        . D VADEM^RORUTL05(PATIEN,1)
        . S RORPNAME=VADM(1),RORLAST4=VA("BID")
        . ;
        . ;--- Get the outpatient data
        . S RC=$$OPDATA(PATIEN)
        . I RC  S ECNT=ECNT+1  Q:RC<0
        . ;
        . ;--- Calculate intermediate totals
        . S RC=$$TOTALS^RORX016B(PATIEN)
        . I RC  S ECNT=ECNT+1  Q:RC<0
        ;---
        Q $S(RC<0:RC,1:ECNT)
        ;
        ;***** CALLBACK ENTRY POINT FOR ACRP API
SCAN(Y,Y0)      ;
        N DTX,STOP,TMP
        ;--- Check the division
        S TMP=$$PARAM^RORTSK01("DIVISIONS","ALL")
        I 'TMP  Q:'$D(RORTSK("PARAMS","DIVISIONS","C",+$P(Y0,U,11)))
        ;--- Data comes from the OUTPATIENT ENCOUNTER file (409.68)
        S STOP=$P($G(^DIC(40.7,+$P(Y0,U,3),0)),U,2),DTX=Y0\1
        S:STOP="" STOP="NSC"
        S @RORDST@("OP",RORDFN,DTX)=$G(@RORDST@("OP",RORDFN,DTX))+1
        S @RORDST@("OP",RORDFN,DTX,STOP)=$G(@RORDST@("OP",RORDFN,DTX,STOP))+1
        Q
