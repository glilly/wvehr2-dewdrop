RORX019 ;BPOIFO/ACS - MELD SCORE BY RANGE ;11/1/09
        ;;1.5;CLINICAL CASE REGISTRIES;**10**;Feb 17, 2006;Build 32
        ;
        ; This routine uses the following IAs:
        ;
        ; #2056  GETS^DIQ (supported)
        ; #10105 $$LN^XLFMTH (supported)
        ; #3556  GCPR^LA7QRY (supported)
        ;
        Q
        ;
        ;************************************************************************
        ;COMPILE THE "MELD SCORE BY RANGE" REPORT (EXTRINISIC FUNCTION)
        ;REPORT CODE: 019
        ;
        ;Called by entry "MELD Score by Range" in ROR REPORT PARAMETERS (#799.34)
        ;
        ;INPUT
        ;  RORTSK     Task number and task parameters
        ;
        ;
        ;  Below is a sample RORTSK input array for utilization in 2003, most recent
        ;  scores, MELD range from 10 to 30, MELD Na range from 20 to 50:
        ;  
        ;  RORTSK=nnn   (the task number)
        ;  RORTSK("EP")="$$MLDRANGE^RORX019"
        ;  RORTSK("PARAMS","DATE_RANGE_3","A","END")=3031231
        ;  RORTSK("PARAMS","DATE_RANGE_3","A","START")=3030101
        ;  RORTSK("PARAMS","ICD9FILT","A","FILTER")="ALL"
        ;  RORTSK("PARAMS","LRGRANGES","C",1)=""
        ;  RORTSK("PARAMS","LRGRANGES","C",1,"H")=30
        ;  RORTSK("PARAMS","LRGRANGES","C",1,"L")=10
        ;  RORTSK("PARAMS","LRGRANGES","C",2)=""
        ;  RORTSK("PARAMS","LRGRANGES","C",2,"H")=50
        ;  RORTSK("PARAMS","LRGRANGES","C",2,"L")=20
        ;  RORTSK("PARAMS","OPTIONS","A","COMPLETE")=1
        ;  RORTSK("PARAMS","OPTIONS","A","MOST_RECENT")=1
        ;  RORTSK("PARAMS","PATIENTS","A","DE_AFTER")=1
        ;  RORTSK("PARAMS","PATIENTS","A","DE_BEFORE")=1
        ;  RORTSK("PARAMS","PATIENTS","A","DE_DURING")=1
        ;  RORTSK("PARAMS","REGIEN")=1
        ;  
        ;  If the user selected an 'as of' date = 12/31/2005:
        ;  RORTSK("PARAMS","OPTIONS","A","MOST_RECENT")=1
        ;     is replaced with:  
        ;  RORTSK("PARAMS","OPTIONS","A","MAX_DATE")=3051231
        ;
        ;
        ;OUTPUT
        ;  <0  Error code
        ;   0  Ok
        ;************************************************************************
MLDRANGE(RORTSK)        ;
        N RORREG        ; Registry IEN
        N RORSDT        ; report start date
        N ROREDT        ; report end date
        N RORDATA       ; array to hold ROR data and summary totals
        N RORPTIEN      ; IEN of patient in the ROR registry
        N DFN           ; DFN of patient in the PATIENT file (#2)
        N RORLC         ; sub-file and array of LOINC codes to search Lab data
        ;
        N REPORT,RC,I,TMP,SFLAGS,PARAMS
        ;--- Establish the root XML Node of the report and put into output
        S REPORT=$$ADDVAL^RORTSK11(RORTSK,"REPORT")
        Q:REPORT<0 REPORT
        ;
        ;--- Get registry IEN
        S RORREG=$$PARAM^RORTSK01("REGIEN")  ; Registry IEN
        ;
        ;--- Set standard report parameters data into output:
        ;registry, comment, patients (before, during, after), options (summary vs.
        ;complete), other registries, and other diagnoses
        S PARAMS=$$PARAMS^RORXU002(.RORTSK,REPORT,.RORSDT,.ROREDT,.SFLAGS) Q:PARAMS<0 PARAMS
        ;
        ;--- Add range parameters to output
        S RC=$$PARAMS^RORX019A(PARAMS,.RORDATA,.RORTSK) Q:RC<0 RC
        ;
        ;--- Put report header data into output:
        ;report creation date, task number, last registry update date, and
        ;last data extraction date
        S RC=$$HEADER(REPORT) Q:RC<0 RC
        ;
        ;--- Get MELD ranges requested
        ;I=1 ==> report = MELD      I=2 ==> report = MELD Na
        S I=0 F  S I=$O(RORTSK("PARAMS","LRGRANGES","C",I)) Q:I=""  D
        . S RORDATA("L",I)=$G(RORTSK("PARAMS","LRGRANGES","C",I,"L")) ;low range
        . S RORDATA("H",I)=$G(RORTSK("PARAMS","LRGRANGES","C",I,"H")) ;high range
        ;
        ;--- Get Max Date for test results  OUTPUT: RORDATA("DATE")
        S RORDATA("DATE")=$$PARAM^RORTSK01("OPTIONS","MAX_DATE")
        I $G(RORDATA("DATE"))="" S RORDATA("DATE")=DT
        ;
        ;--- Create 'patients' table
        N RORBODY S RORBODY=$$ADDVAL^RORTSK11(RORTSK,"PATIENTS",,REPORT)
        D ADDATTR^RORTSK11(RORTSK,RORBODY,"TABLE","PATIENTS")
        ;
        ;--- Check utilization
        N CNT,ECNT,UTSDT,UTEDT,SKIPSDT,SKIPEDT
        S (CNT,ECNT,RC)=0,SKIPEDT=ROREDT,SKIPSDT=RORSDT
        ; Utilization date range is always sent
        S UTSDT=$$PARAM^RORTSK01("DATE_RANGE_3","START")\1
        S UTEDT=$$PARAM^RORTSK01("DATE_RANGE_3","END")\1
        ; Combined date range
        S SKIPSDT=$$DTMIN^RORUTL18(SKIPSDT,$G(UTSDT))
        S SKIPEDT=$$DTMAX^RORUTL18(SKIPEDT,$G(UTEDT))
        ;
        ;--- Number of patients in the registry - used for calculating the
        ;task progress percentage (shown on the GUI screen)
        N RORPTCNT S RORPTCNT=$$REGSIZE^RORUTL02(+RORREG) S:RORPTCNT<0 RORPTCNT=0
        ;
        ;--- LOINC codes
        ;create list for future comparison
        S RORDATA("CR_LOINC")=";15045-8;21232-4;2160-0;" ;Creatinine
        S RORDATA("BIL_LOINC")=";14631-6;1975-2;" ;Bilirubin
        S RORDATA("SOD_LOINC")=";2947-0;2951-2;32717-1;" ;Sodium
        S RORDATA("INR_LOINC")=";34714-6;6301-6;" ;INR
        ;set up array for future call to Lab API
        S RORLC="CH" ;chemistry sub-file to search in #63
        S RORLC(1)="15045-8^LN" ;Creatinine LOINC
        S RORLC(2)="21232-4^LN" ;Creatinine LOINC
        S RORLC(3)="2160-0^LN"  ;Creatinine LOINC
        S RORLC(4)="14631-6^LN" ;Bilirubin LOINC
        S RORLC(5)="1975-2^LN"  ;Bilirubin LOINC
        S RORLC(6)="2947-0^LN"  ;Sodium LOINC
        S RORLC(7)="2951-2^LN"  ;Sodium LOINC
        S RORLC(8)="32717-1^LN" ;Sodium LOINC
        S RORLC(9)="34714-6^LN" ;INR LOINC
        S RORLC(10)="6301-6^LN" ;INR LOINC
        ;
        ;--- Get registry records
        N RCC,FLAG,TMP,DFN,SKIP
        S (CNT,RORPTIEN,RC)=0
        S FLAG=$G(RORTSK("PARAMS","ICD9FILT","A","FILTER"))
        F  S RORPTIEN=$O(^RORDATA(798,"AC",RORREG,RORPTIEN))  Q:RORPTIEN'>0  D  Q:RC<0
        . ;--- Calculate 'progress' for the GUI display
        . S TMP=$S(RORPTCNT>0:CNT/RORPTCNT,1:"")
        . S RC=$$LOOP^RORTSK01(TMP)  Q:RC<0
        . S CNT=CNT+1
        . ;--- Check if the patient should be skipped
        . Q:$$SKIP^RORXU005(RORPTIEN,SFLAGS,SKIPSDT,SKIPEDT)
        . ;--- Get the patient DFN
        . S DFN=$$PTIEN^RORUTL01(RORPTIEN)  Q:DFN'>0
        . ;--- Check if patient has passed the ICD9 filter
        . S RCC=0
        . I FLAG'="ALL" D
        . . S RCC=$$ICD^RORXU010(DFN,RORREG)
        . I (FLAG="INCLUDE")&(RCC=0) Q
        . I (FLAG="EXCLUDE")&(RCC=1) Q
        . ;
        . ;--- Check for any utilization in the corresponding date range
        . S SKIP=0 I $G(UTSDT)>0 D
        .. N UTIL K TMP S TMP("ALL")=1
        .. S UTIL=+$$UTIL^RORXU003(UTSDT,UTEDT,DFN,.TMP)
        .. S:'UTIL SKIP=1
        . ;--- Skip the patient if they have no utilization in the range
        . I $G(SKIP) Q
        . ;
        . ;--- For each patient, process the registry record and create report
        . I $$PATIENT(DFN,RORBODY,.RORDATA,RORPTIEN,.RORLC)<0 S ECNT=ECNT+1 ;error count
        ;
        K ^TMP("RORX019",$J)
        Q $S(RC<0:RC,ECNT>0:-43,1:0)
        ;
        ;************************************************************************
        ;ADD PATIENT DATA TO THE REPORT (EXTRINISIC FUNCTION)
        ;
        ;INPUT
        ;  DFN      Patient DFN in PATIENT file (#2)
        ;  PTAG     Reference IEN to the 'body' parent XML tag
        ;  RORDATA  Array with ROR data
        ;  RORPTIEN Patient IEN in the ROR registry
        ;  RORLC    sub-file and LOINC codes to search for
        ;
        ;OUTPUT
        ;  1        ok
        ; <0        error
        ;************************************************************************
PATIENT(DFN,PTAG,RORDATA,RORPTIEN,RORLC)        ;
        I $$CALCMLD(DFN,PTAG,.RORDATA,RORPTIEN,.RORLC)<0 Q 1 ;quit if no MELD score can be calculated
        I '$$INRANGE(.RORDATA) Q 1  ;exclude patient if score is out of range
        ;--- Get patient data and put into the report
        N VADM,VA,RORDOD,MTAG,TTAG
        D VADEM^RORUTL05(DFN,1)
        ;--- The <PATIENT> tag
        S PTAG=$$ADDVAL^RORTSK11(RORTSK,"PATIENT",,PTAG,,DFN)
        I PTAG<0 Q PTAG
        ;--- Patient Name
        D ADDVAL^RORTSK11(RORTSK,"NAME",VADM(1),PTAG,1)
        ;--- Last 4 digits of the SSN
        D ADDVAL^RORTSK11(RORTSK,"LAST4",VA("BID"),PTAG,2)
        ;--- Date of death
        S RORDOD=$$DATE^RORXU002($P(VADM(6),U)\1)
        D ADDVAL^RORTSK11(RORTSK,"DOD",$G(RORDOD),PTAG,1)
        ;--- MELDDATA tag
        S MTAG=$$ADDVAL^RORTSK11(RORTSK,"MELDDATA",,PTAG)
        I MTAG<0 Q MTAG
        ;--- Test Result Values
        N TNAME,TNAMEMIX F TNAME="BILI","CR","INR","NA" D
        . ;--- TEST tag
        . S TTAG=$$ADDVAL^RORTSK11(RORTSK,"TEST",,MTAG)
        . I TTAG<0 Q
        . ;--- Mixed case test name for GUI application
        . I TNAME="BILI" S TNAMEMIX="Bili"
        . I TNAME="CR" S TNAMEMIX="Cr"
        . I TNAME="INR" S TNAMEMIX="INR"
        . I TNAME="NA" S TNAMEMIX="Na"
        . ;---  Test Name
        . D ADDVAL^RORTSK11(RORTSK,"TNAME",TNAMEMIX,TTAG)
        . ;---  Test Date
        . D ADDVAL^RORTSK11(RORTSK,"DATE",$P($G(RORDATA(TNAME)),U,2),TTAG)
        . ;---  Test Result Value
        . D ADDVAL^RORTSK11(RORTSK,"RESULT",$P($G(RORDATA(TNAME)),U,1),TTAG)
        ;---  MELD score
        I RORDATA("IDLST")[1 D ADDVAL^RORTSK11(RORTSK,"MELD",$G(RORDATA("SCORE",1)),MTAG,3)
        ;---  MELD-Na Score
        I RORDATA("IDLST")[2 D ADDVAL^RORTSK11(RORTSK,"MELDNA",$G(RORDATA("SCORE",2)),MTAG,3)
        Q ($S($G(TTAG)<0:TTAG,1:1))
        ;
        ;************************************************************************
        ;CALCULATE THE MELD SCORE(S)
        ;
        ;INPUT
        ;  DFN      Patient DFN in LAB DATA file (#63)
        ;  PTAG     Reference IEN to the 'body' parent XML tag
        ;  RORDATA  Array with ROR data
        ;           RORDATA("FIELDS") - Field list for retrieving the test results
        ;  RORPTIEN Patient IEN in the ROR registry
        ;  RORLC    sub-file and LOINC codes to search for
        ;           
        ;OUTPUT
        ;  RORDATA  Array with ROR data
        ;           RORDATA("BVAL",DATE)=VALUE    - Bilirubin results
        ;           RORDATA("CVAL",DATE)=VALUE    - Creatinine results
        ;           RORDATA("IVAL",DATE)=VALUE    - INR results
        ;           RORDATA("SVAL",DATE)=VALUE    - Sodium results
        ;           RORDATA("CINV",DATE)=VALUE      - 'invalid' Creatinine result
        ;           RORDATA("SINV",DATE)=VALUE      - 'invalid' Sodium result
        ;           RORDATA("SCORE",1) - MELD score
        ;           RORDATA("SCORE",2) - MELD-Na score
        ;    1      Patient should appear on report
        ;   -1      Patient should NOT appear on report
        ;   
        ;   NOTE: the 'invalid' results will be stored as 'backup' results, in
        ;   case no valid result is found for Creatinine or Sodium.  An invalid
        ;   creatinine result is >12.  An invalid Sodium result is <100 or >180.
        ;   These results will be displayed on the report if no MELD range was 
        ;   specifically requested by the user, but the score will not be calculated.
        ;   They will not be displayed on the report if the user requested a MELD
        ;   range.
        ;************************************************************************
CALCMLD(DFN,PTAG,RORDATA,RORPTIEN,RORLC)        ;
        N RORID,RORST,ROREND,RORLAB,RORMSG,RC
        S RORDATA("CALC")=0,RORDATA("CALCNA")=0 ;default: don't calculate scores
        K RORDATA("SCORE",1),RORDATA("SCORE",2) ;test scores
        K RORDATA("BVAL"),RORDATA("CVAL"),RORDATA("IVAL"),RORDATA("SVAL") ;test results
        K RORDATA("CINV"),RORDATA("SINV") ;test results
        ;get patient ICN or SSN
        S RORID=$$PTID^RORUTL02(DFN)
        Q:'$G(RORID) -1
        ;---SET UP LAB API INPUT/OUTPUT PARMS---
        S RORST="2000101^CD" ;start date 1/1/1900
        S ROREND=$G(RORDATA("DATE"))\1 ;end date
        ;add 1 to the end date so the Lab API INCLUDES the end date correctly
        N X1,X2,X3 S X1=ROREND,X2=1 D C^%DTC S ROREND=X K X,X1,X2
        S ROREND=ROREND_"^CD"
        S RORLAB=$NA(^TMP("ROROUT",$J)) ;lab API output global
        K RORMSG,@RORLAB ;initialize prior to call
        ;---CALL LAB API---
        S RC=$$GCPR^LA7QRY(RORID,RORST,ROREND,.RORLC,"*",.RORMSG,RORLAB)
        I RC="",$D(RORMSG)>1  D  ;quit if error returned
        . N ERR,I,LST,TMP
        . S (ERR,LST)=""
        . F I=1:1  S ERR=$O(RORMSG(ERR))  Q:ERR=""  D
        . . S LST=LST_","_ERR,TMP=RORMSG(ERR)
        . . K RORMSG(ERR)  S RORMSG(I)=TMP
        . S LST=$P(LST,",",2,999)  Q:(LST=3)!(LST=99)
        . S RC=$$ERROR^RORERR(-27,,.RORMSG,RORPTIEN)
        I RC<0 Q -1
        ;Note: the Lab API returns data in the form of HL7 segments
        N TMP,RORSPEC,RORVAL,RORNODE,RORSEG,SEGTYPE,RORLOINC,RORDONE,RORDATE,RORTEST
        N RORCR,RORBIL,RORSOD,RORINR,FS
        S FS="|" ;HL7 field separator for lab data
        S (RORCR,RORBIL,RORSOD,RORINR,RORDONE,RORNODE)=0
        F  S RORNODE=$O(^TMP("ROROUT",$J,RORNODE)) Q:((RORNODE="")!(RORDONE))  D
        . S RORSEG=$G(^TMP("ROROUT",$J,RORNODE)) ;get entire HL7 segment
        . S SEGTYPE=$P(RORSEG,FS,1) ;get segment type (PID,OBR,OBX,etc.)
        . Q:SEGTYPE'="OBX"  ;we want OBX segments only
        . S RORSPEC=$P($P(RORSEG,FS,4),U,2) ;specimen type string (urine, serum, etc.)
        . S RORSPEC=":"_RORSPEC_":" ;append ":" as prefix and suffix
        . I ((RORSPEC[":UA:")!(RORSPEC[":UR:")) Q  ;quit if specimen type is urine
        . S RORLOINC=$P($P(RORSEG,FS,4),U,1) ;get LOINC code for test
        . S RORVAL=$P(RORSEG,FS,6) ;test result value
        . S RORVAL=$TR(RORVAL,"""","") ;get rid of double quotes around values
        . Q:($G(RORVAL)'>0)  ;quit if no value
        . S RORDATE=$$HL7TFM^XLFDT($P(RORSEG,FS,15)) ;get date collected
        . S RORDATE=RORDATE\1
        . ;---check for Creatinine match on LOINC---
        . I 'RORCR,RORDATA("CR_LOINC")[(";"_RORLOINC_";") D  Q
        .. ;store 'valid' value (12 or less) if no 'valid' value has been stored yet
        .. I RORVAL'>12,$O(RORDATA("CVAL",0))="" S RORDATA("CVAL",RORDATE)=RORVAL,RORCR=1 Q
        .. ;store 'invalid' value (>12) if no other value has been stored
        .. I RORVAL>12,$O(RORDATA("CVAL",0))="",$O(RORDATA("CINV",0))="" D
        ... S RORDATA("CINV",RORDATE)=$G(RORVAL)_"*" ;mark as 'invalid' value
        . ;---check for Sodium match on LOINC---
        . I 'RORSOD,RORDATA("SOD_LOINC")[(";"_RORLOINC_";") D  Q
        .. ;store 'valid' value (100 to 180) if no other 'valid' value has been stored
        .. I RORVAL'<100,RORVAL'>180,$O(RORDATA("SVAL",0))="" D  Q
        ... S RORDATA("SVAL",RORDATE)=$G(RORVAL),RORSOD=1
        .. ;store 'invalid' value (<100 or >180) if no other value has been stored yet
        .. I ((RORVAL<100)!(RORVAL>180)),$O(RORDATA("SVAL",0))="",$O(RORDATA("SINV",0))="" D  Q
        ... S RORDATA("SINV",RORDATE)=RORVAL_"*" Q   ;mark as 'invalid' value
        . ;---check for Bilirubin match on LOINC---
        . I 'RORBIL,RORDATA("BIL_LOINC")[(";"_RORLOINC_";") D  Q
        .. ;store first Bilirubin value
        .. I $O(RORDATA("BVAL",0))="" S RORDATA("BVAL",RORDATE)=RORVAL,RORBIL=1
        . ;---check for INR match on LOINC---
        . I 'RORINR,RORDATA("INR_LOINC")[(";"_RORLOINC_";") D  Q
        .. ;store first INR value
        .. I $O(RORDATA("IVAL",0))="" S RORDATA("IVAL",RORDATE)=RORVAL,RORINR=1
        . I RORCR,RORBIL,RORINR S RORDATA("CALC")=1 D
        .. I RORSOD D
        ... S RORDATA("CALCNA")=1,RORDONE=1
        .. E  S RORDATA("CALCNA")=0
        ;
        ;--- put test date and result into array: RORDATA(<test>)=value^date
        N DATE
        ;Bilirubin:
        S DATE=$O(RORDATA("BVAL",0))
        S RORDATA("BILI")=$S($G(DATE)="":U,1:$G(RORDATA("BVAL",DATE))_U_$G(DATE))
        ;Creatinine:
        S DATE=$O(RORDATA("CVAL",0))
        I $G(DATE)="" D  ;if regular Creatinine value is null, take invalid value
        . S DATE=$O(RORDATA("CINV",0)) I $G(DATE)>0 S RORDATA("CVAL",DATE)=$G(RORDATA("CINV",DATE))
        S RORDATA("CR")=$S($G(DATE)="":U,1:$G(RORDATA("CVAL",DATE))_U_$G(DATE))
        ;INR:
        S DATE=$O(RORDATA("IVAL",0))
        S RORDATA("INR")=$S($G(DATE)="":U,1:$G(RORDATA("IVAL",DATE))_U_$G(DATE))
        ;Sodium:
        S DATE=$O(RORDATA("SVAL",0))
        I $G(DATE)="" D  ;if regular Sodium value is null, take invalid value
        . S DATE=$O(RORDATA("SINV",0)) I $G(DATE)>0 S RORDATA("SVAL",DATE)=$G(RORDATA("SINV",DATE))
        S RORDATA("NA")=$S($G(DATE)="":U,1:$G(RORDATA("SVAL",DATE))_U_$G(DATE))
        ;
        N TEST,BILI,CR,INR,NA
        ;set lower limits for Bili, Cr, and INR to 1 if there's a value in there
        F TEST="BILI","CR","INR" D
        . S @TEST=$P($G(RORDATA(TEST)),U,1) Q:$G(@TEST)["*"  I $G(@TEST),@TEST<1 S @TEST=1
        ;for valid creatinine, use max=4 for calculations
        I $G(CR)'["*" D
        . I $G(CR)>4 S CR=4
        S NA=$P($G(RORDATA("NA")),U,1)
        ;for valid sodium, use min=120, max=135 for calculations
        I $G(NA)'["*" D
        . I $G(NA)>135 S NA=135 Q
        . I $G(NA)'="" I NA<120 S NA=120
        ;
        N TMP1,TMP2
        ;RORDATA("SCORE",1) will hold the calculated MELD score
        ;RORDATA("SCORE",2) will hold the calculated MELD Na score
        S (RORDATA("SCORE",1),RORDATA("SCORE",2))="" ;init calculated scores to null
        D
        . Q:($G(CR)["*")  ;quit if no calculation should occur
        . I $G(BILI),$G(CR),$G(INR) D
        .. ;MELD forumula: (.957*lne(Cr) + .378*lne(Bili) + 1.120*lne(Inr) + .643) * 10
        .. S TMP1=(.957*($$LN^XLFMTH(CR))+(.378*($$LN^XLFMTH(BILI)))+(1.120*($$LN^XLFMTH(INR)))+.643)*10
        .. S RORDATA("SCORE",1)=$J($G(TMP1),0,0) ;round MELD to whole number
        .. Q:($G(NA)["*")  ;quit if no calculation should occur
        .. ;if meld NA requested, sodium test must have a valid value
        .. I $G(NA),RORDATA("SCORE",1),RORDATA("IDLST")[2 D
        ... ;MELD-Na forumula: MELD + (1.59 *(135-Na))
        ... S TMP2=$G(RORDATA("SCORE",1))+(1.59*(135-NA))
        ... S RORDATA("SCORE",2)=$J($G(TMP2),0,0)
        Q 1
        ;
        ;************************************************************************
        ;DETERMINE IF THE SCORES ARE WITHIN THE REQUESTED RANGES
        ;-- If both tests contain ranges: scores for BOTH tests must fall in the
        ;ranges...treated like an 'AND'
        ;-- If 1 test contains a range: only patients with scores in the requested range
        ;will be displayed, and the test without the range will also be displayed
        ;with the calculated score (if applicable)
        ;-- If neither test contains a range: all patients and their test results
        ;and scores (null if they can't be calculated) are returned
        ;
        ;INPUT
        ;  RORDATA  Array with ROR data
        ;OUTPUT
        ;  1        include on report
        ;  0        exclude from report
        ;************************************************************************
INRANGE(RORDATA)        ;
        ;include all data and quit if no range was sent in
        I ('$G(RORDATA("RANGE",1))&('$G(RORDATA("RANGE",2)))) Q 1
        ;
        N I,RETURN,SCORE S RETURN=1 ;default is set to 'within range'
        S I=0 F  S I=$O(RORDATA("RANGE",I)) Q:I=""  D
        . I $G(RORDATA("L",I))'="" D
        .. S SCORE=$G(RORDATA("SCORE",I))
        .. I $G(SCORE)="" S RETURN=0 Q
        .. I SCORE<RORDATA("L",I) S RETURN=0
        . I $G(RORDATA("H",I))'="" D
        .. S SCORE=$G(RORDATA("SCORE",I))
        .. I $G(SCORE)="" S RETURN=0 Q
        .. I SCORE>$G(RORDATA("H",I)) S RETURN=0
        ;
        Q RETURN
        ;
        ;************************************************************************
        ;ADD THE HEADERS TO THE REPORT (EXTRINISIC FUNCTION)
        ;
        ;INPUT
        ;  PARTAG  Reference IEN to the 'report' parent XML tag
        ;
        ;OUTPUT
        ;  <0      error
        ;  >0      'Header' XML tag number or error code
        ;************************************************************************
HEADER(PARTAG)  ;
        N HEADER,RC,COL,COLUMNS,TMP S RC=0
        ;call to $$HEADER^RORXU002 will populate the report created date, task number,
        ;last registry update, and last data extraction.
        S HEADER=$$HEADER^RORXU002(.RORTSK,PARTAG)
        Q:HEADER<0 HEADER
        ;manually build the table defintion(s) listed below
        ;PATIENTS(#,NAME,LAST4,DOD,TEST,DATE,RESULT,MELD,MELDNA)
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
        . D ADDATTR^RORTSK11(RORTSK,TMP,"NAME","MELD")
        I RORDATA("IDLST")[2 D
        . S TMP=$$ADDVAL^RORTSK11(RORTSK,"COLUMN",,COLUMNS)
        . D ADDATTR^RORTSK11(RORTSK,TMP,"NAME","MELDNA")
        ;---
        Q $S(RC<0:RC,1:HEADER)
        ;
