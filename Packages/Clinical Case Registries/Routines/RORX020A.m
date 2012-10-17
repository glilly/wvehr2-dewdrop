RORX020A        ;BPOIFO/ACS - RENAL FUNCTION BY RANGE (CONT.) ;11/1/09
        ;;1.5;CLINICAL CASE REGISTRIES;**10**;Feb 17, 2006;Build 32
        ;
        Q
        ;
        ;************************************************************************
        ;ADD THE HEADERS TO THE REPORT (EXTRINSIC FUNCTION)
        ;
        ;INPUT
        ;  PARTAG  Reference IEN to the 'report' parent XML tag
        ;
        ;OUTPUT
        ;  <0      error
        ;  >0      'Header' XML tag number or error code
        ;************************************************************************
HEADER(PARTAG,RORTSK)   ;
        N HEADER,RC,COL,COLUMNS,TMP S RC=0
        ;call to $$HEADER^RORXU002 will populate the report created date, task number,
        ;last registry update, and last data extraction.
        S HEADER=$$HEADER^RORXU002(.RORTSK,PARTAG)
        Q:HEADER<0 HEADER
        ;manually build the table definition(s) listed below
        ;PATIENTS(#,NAME,LAST4,DOD,TEST,DATE,RESULT,CRCL,EGFR)
        S COLUMNS=$$ADDVAL^RORTSK11(RORTSK,"TBLDEF",,HEADER)
        D ADDATTR^RORTSK11(RORTSK,COLUMNS,"NAME","PATIENTS")
        D ADDATTR^RORTSK11(RORTSK,COLUMNS,"HEADER","1")
        D ADDATTR^RORTSK11(RORTSK,COLUMNS,"FOOTER","1")
        ;--- Required columns
        F COL="#","NAME","LAST4","DOD","TEST","DATE","RESULT"  D
        . S TMP=$$ADDVAL^RORTSK11(RORTSK,"COLUMN",,COLUMNS)
        . D ADDATTR^RORTSK11(RORTSK,TMP,"NAME",COL)
        ;--- Additional columns
        I RORDATA("IDLST")[1 D
        . S TMP=$$ADDVAL^RORTSK11(RORTSK,"COLUMN",,COLUMNS)
        . D ADDATTR^RORTSK11(RORTSK,TMP,"NAME","CRCL")
        I RORDATA("IDLST")[2 D
        . S TMP=$$ADDVAL^RORTSK11(RORTSK,"COLUMN",,COLUMNS)
        . D ADDATTR^RORTSK11(RORTSK,TMP,"NAME","EGFR")
        ;---
        Q $S(RC<0:RC,1:HEADER)
        ;
        ;*****************************************************************************
        ;INITIALIZE THE RANGE COUNTS TO 0
        ;
        ;INPUT
        ;  RORDATA  Array with ROR data
        ;           RORDATA("RCNT") Number of ranges/groupings to initialize
        ;*****************************************************************************
INIT(RORDATA)   ;
        I $G(RORDATA("RCNT"))="" Q
        N I
        F I=1:1:RORDATA("RCNT") D
        . S RORDATA("NP",I)=0
        Q
        ;
        ;*****************************************************************************
        ;OUTPUT REPORT 'RANGE' PARAMETERS, SET UP REPORT ID LIST (EXTRINISIC FUNCTION)
        ;
        ; PARTAG        Reference (IEN) to the parent tag
        ;
        ; Return Values:
        ;        RORDATA("IDLST") - list of IDs for tests requested
        ;        RORDATA("RANGE") - 1 if range passed in for either test, else 0
        ;       <0  Error code
        ;        0  Ok
        ;*****************************************************************************
PARAMS(PARTAG,RORDATA)  ;
        N PARAMS,DESC,TMP,RC,RANGE S RC=0
        S RORDATA("RANGE")=0 ;initialize to 'no range passed in'
        ;--- Lab test ranges
        I $D(RORTSK("PARAMS","LRGRANGES","C"))>1  D  Q:RC<0 RC
        . N GRC,ELEMENT,NODE,RTAG,RANGE
        . S NODE=$NA(RORTSK("PARAMS","LRGRANGES","C"))
        . S RTAG=$$ADDVAL^RORTSK11(RORTSK,"LRGRANGES",,PARTAG)
        . S (GRC,RC)=0
        . F  S GRC=$O(@NODE@(GRC))  Q:GRC'>0  D  Q:RC<0
        . . S RANGE=0,DESC=$$RTEXT(GRC,.RORDATA)
        . . S ELEMENT=$$ADDVAL^RORTSK11(RORTSK,"LRGRANGE",DESC,RTAG)
        . . I ELEMENT<0 S RC=ELEMENT Q
        . . D ADDATTR^RORTSK11(RORTSK,ELEMENT,"ID",GRC)
        . . ;add the user-requested test ID to the test ID 'list'
        . . S RORDATA("IDLST")=$G(RORDATA("IDLST"))_$S($G(RORDATA("IDLST"))'="":","_GRC,1:GRC)
        . . ;--- Process the range values
        . . S TMP=$G(@NODE@(GRC,"L"))
        . . I TMP'="" D  S RANGE=1
        . . . D ADDATTR^RORTSK11(RORTSK,ELEMENT,"LOW",TMP)
        . . S TMP=$G(@NODE@(GRC,"H"))
        . . I TMP'="" D  S RANGE=1
        . . . D ADDATTR^RORTSK11(RORTSK,ELEMENT,"HIGH",TMP)
        . . I RANGE D 
        . . . D ADDATTR^RORTSK11(RORTSK,ELEMENT,"RANGE",1)
        . . . S RORDATA("RANGE")=1
        ;--- Success
        ;if user didn't select any tests, default to both tests
        I $G(RORDATA("IDLST"))="" S RORDATA("IDLST")="1,2"
        Q RC
        ;
        ;*****************************************************************************
        ;RETURN RANGE TEXT AND ADD RANGE VALUES TO RORDATA (EXTRINISIC FUNCTION) 
        ;ID=1: MELD
        ;ID=2: MELD-Na
        ;
        ;INPUT:
        ;  GRC   Test ID number
        ;  RORDATA - Array with ROR data
        ;
        ;OUTPUT:
        ;  RORDATA("L",ID) - test ID low range
        ;  RORDATA("H",ID) - test ID high range
        ;  Description - <range>
        ;*****************************************************************************
RTEXT(GRC,RORDATA)      ;
        N RANGE,TMP
        S RANGE=""
        ;--- Range
        I $D(RORTSK("PARAMS","LRGRANGES","C",GRC))>1 D
        . ;--- Low
        . S TMP=$G(RORTSK("PARAMS","LRGRANGES","C",GRC,"L"))
        . S RORDATA("L",GRC)=$G(TMP)
        . S:TMP'="" RANGE=RANGE_" not less than "_TMP
        . ;--- High
        . S TMP=$G(RORTSK("PARAMS","LRGRANGES","C",GRC,"H"))
        . S RORDATA("H",GRC)=$G(TMP)
        . I TMP'=""  D:RANGE'=""  S RANGE=RANGE_" not greater than "_TMP
        . . S RANGE=RANGE_" and"
        ;--- Description
        S TMP=$G(RORTSK("PARAMS","LRGRANGES","C",GRC))
        S:TMP="" TMP="Unknown ("_GRC_")"
        Q TMP_" - "_$S(RANGE'="":"numeric results"_RANGE,1:"all results")
        ;
        ;************************************************************************
        ;DETERMINE IF THE SCORES ARE WITHIN THE REQUESTED RANGES (EXTRINSIC FUNCTION)
        ;If not in the range, exclude from report
        ;
        ;INPUT:
        ;  RORDATA  RORDATA("SCORE",I) contains computed test score for test ID 'I'
        ;
        ;OUTPUT:
        ;  1  include on report
        ;  0  exclude from report
        ;************************************************************************
INRANGE(RORDATA)        ;
        ;if range exists for either test, and any result is considered 'invalid',
        ;then skip the range check and exclude data from report
        ;I $G(RORDATA("RANGE")),'$G(RORDATA("CALC")) Q 0
        ;if range does not exist for either test, and any result is considered 'invalid',
        ;then skip the range check and include data in the report
        I '$G(RORDATA("RANGE")),'$G(RORDATA("CALC")) Q 1
        ;
        ;---Range Check
        N I,RETURN S RETURN=1 ;default is set to 'within range'
        S I=0 F  S I=$O(RORDATA("SCORE",I)) Q:I=""  D
        . I $G(RORDATA("L",I))'="" D
        .. ;if score is less than 'low' range, do not include on report 
        .. I $G(RORDATA("SCORE",I))<RORDATA("L",I) S RETURN=0
        . I $G(RORDATA("H",I))'="" D
        .. ;if score is higher than 'high' range, do not include on report 
        .. I $G(RORDATA("SCORE",I))>RORDATA("H",I) S RETURN=0
        ;
        Q RETURN
        ;
        ;************************************************************************
        ;ADD 1 TO APPROPRIATE eGFR CATEGORY
        ;
        ;INPUT
        ;  RORDATA  Array with ROR data
        ;************************************************************************
EGFRCAT(RORDATA)        ;
        I '$G(RORDATA("SCORE",2)) Q  ;quit if no score was calculated
        I $G(RORDATA("SCORE",2))>89 S RORDATA("NP",1)=$G(RORDATA("NP",1))+1 Q
        I $G(RORDATA("SCORE",2))>59 S RORDATA("NP",2)=$G(RORDATA("NP",2))+1 Q
        I $G(RORDATA("SCORE",2))>29 S RORDATA("NP",3)=$G(RORDATA("NP",3))+1 Q
        I $G(RORDATA("SCORE",2))>14 S RORDATA("NP",4)=$G(RORDATA("NP",4))+1 Q
        S RORDATA("NP",5)=$G(RORDATA("NP",5))+1 Q
        Q
        ;
        ;*****************************************************************************
        ;ADD SUMMARY DATA TO THE REPORT (EXTRINSIC FUNCTION)
        ;
        ;INPUT
        ;  RORTSK   Task number and task parameters
        ;  REPORT   'Report' XML tag number
        ;  RORDATA  Array with summary data:
        ;           RORDATA("NP",1) - total count of patients in 1st range
        ;           RORDATA("NP",2) - total count of patients in 2nd range
        ;           RORDATA("NP",3) - total count of patients in 3rd range
        ;           RORDATA("NP",4) - total count of patients in 4th range
        ;           RORDATA("NP",5) - total count of patients in 5th range
        ;
        ;OUTPUT
        ;  STAG     XML 'summary' tag number or error code
        ;*****************************************************************************
SUMMARY(RORTSK,REPORT,RORDATA)  ; Add the summary values to the report
        N SUMMARY,I,STAG,RORTAG,RORNAME,RORRANGE
        S SUMMARY=$$ADDVAL^RORTSK11(RORTSK,"SUMMARY",,REPORT)
        Q:SUMMARY<0 SUMMARY
        ;add data for the summary entries
        F I=1:1:RORDATA("RCNT")  D  Q:STAG<0
        . S STAG=$$ADDVAL^RORTSK11(RORTSK,"DATA",,SUMMARY)
        . Q:STAG<0
        . ;get each value
        . S RORTAG="S"_I S RORNAME=$P($T(@RORTAG),";;",2)
        . S RORRANGE=$P($T(@RORTAG),";;",3)
        . D ADDVAL^RORTSK11(RORTSK,"DESC",$G(RORNAME),STAG) ;severity
        . D ADDVAL^RORTSK11(RORTSK,"VALUES",$G(RORRANGE),STAG) ;range
        . D ADDVAL^RORTSK11(RORTSK,"NP",$G(RORDATA("NP",I)),STAG) ;count
        Q STAG
        ;************************************************************************
        ;eGFR by MDRD Categories and Values for the summary table.
        ;NOTE: the number of entries below must match the value of RORDATA("RCNT")
        ;************************************************************************
S1      ;;Normal or CKD1;;>=90 mL/min/1.73m
S2      ;;CKD2 (Mild);;60-89 mL/min/1.73m
S3      ;;CKD3 (Moderate);;30-59 mL/min/1.73m
S4      ;;CKD4 (Severe);;15-29 mL/min/1.73m
S5      ;;CKD5 (Kidney failure);;<15 mL/min/1.73m
