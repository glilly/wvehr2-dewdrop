RORUPD04 ;HCIOFO/SG - PROCESSING OF THE LAB DATA  ; 12/8/05 8:20am
 ;;1.5;CLINICAL CASE REGISTRIES;;Feb 17, 2006
 ;
 Q
 ;
 ;***** CHECKS AN INDICATOR CONDITION
 ;
 ; LSI           Indicator (internal value)
 ; VAL           Indicated value
 ; .RESULT(      Result value
 ;   "RH")       Reference high
 ;   "RL")       Reference low
 ;
 ; Return Values:
 ;        0  False
 ;       >0  True
 ;
CHKIND(LSI,VAL,RESULT) ;
 S RESULT=$$UP^XLFSTR(RESULT)
 ;--- Reference Range
 I LSI=1  D  Q LSI
 . I $G(RESULT("RL"))'=""  Q:RESULT<RESULT("RL")
 . I $G(RESULT("RH"))'=""  Q:RESULT>RESULT("RH")
 . S LSI=0
 ;--- Positive Result
 I LSI=6  S VAL=0  D  Q VAL
 . I (RESULT="P")!(RESULT="R")  S VAL=1  Q
 . I RESULT'["POS",RESULT'["REA",RESULT'["DETEC"  Q
 . I RESULT'["NEG",RESULT'["NO",RESULT'["IND"  S VAL=1
 ;--- Compare to the value
 Q:VAL="" 0
 I LSI=3  Q (RESULT>VAL)
 I LSI=4  Q (RESULT<VAL)
 S VAL=$$UP^XLFSTR(VAL)
 I LSI=2  Q (RESULT[VAL)
 I LSI=5  Q (RESULT=VAL)
 Q 0
 ;
 ;***** PROCESSING OF THE 'LAB DATA' FILE
 ;
 ; UPDSTART      Date of the earliest update (DO NOT pass by
 ;               reference)
 ; PATIEN        Patient IEN
 ;
 ; Return values:
 ;       <0  Error code
 ;        0  Continue processing of the current patient
 ;        1  Stop processing
 ;
LAB(UPDSTART,PATIEN) ;
 N RORFILE       ; File number
 ;
 N DM,DSEND,LABIENS,RC,RORLAB,TMP
 S RORFILE=63,DSEND=RORUPD("DSEND")
 K RORVALS("LS")
 ;--- If the start date is more than 60 days in the past, results
 ;    should be loaded using collection dates. Otherwise, dates of
 ;--- the results are used).
 S DM=$S($$FMDIFF^XLFDT(DT,UPDSTART)>60:"^CD",1:"^RAD")
 ;--- Check the event references if the events are enabled
 I $G(RORUPD("FLAGS"))["E"  D  Q:RC'>0 RC
 . S RC=$$GET^RORUPP02(PATIEN,1,.UPDSTART,.DSEND)
 . ;--- If dates have been modified according to the event references,
 . ;--- they are the collection dates/times.
 . S:RC>1 UPDSTART=UPDSTART\1,DSEND=$$FMADD^XLFDT(DSEND\1,1),DM="^CD"
 ;---
 S TMP=$$LABREF^RORUTL18(PATIEN)  Q:TMP'>0 TMP
 S LABIENS=TMP_",",RC=0
 ;
 S RORLAB=$$ALLOC^RORTMP()  D  D FREE^RORTMP(RORLAB)
 . ;--- Load the Lab results
 . S RC=$$LABRSLTS^RORUTL02(PATIEN,UPDSTART_DM,DSEND_DM,RORLAB)
 . I RC<0  D INCEC^RORUPDUT(.RC)  Q
 . ;--- Process the results
 . Q:$$RESULTS(PATIEN,RORLAB)<0
 . ;--- Load necessary data elements
 . I $D(RORUPD("SR",RORFILE,"F"))>1  D  I TMP<0  D INCEC^RORUPDUT()  Q
 . . S TMP=$$LOAD(LABIENS)
 . ;--- Apply "before" rules
 . S RC=$$APLRULES^RORUPDUT(RORFILE,LABIENS,"B")
 . I RC  D INCEC^RORUPDUT(.RC)  Q
 . ;--- Apply "after" rules
 . S RC=$$APLRULES^RORUPDUT(RORFILE,LABIENS,"A")
 . I RC  D INCEC^RORUPDUT(.RC)  Q
 ;
 D CLRDES^RORUPDUT(RORFILE)
 Q RC
 ;
 ;***** LOAD DATA ELEMENTS
 ;
 ; IENS          IENS of the current record
 ;
 ; Return values:
 ;       <0  Error code
 ;        0  Ok
 ;
LOAD(IENS) ;
 N RC  S RC=0
 ;--- API #1
 I $D(RORUPD("SR",RORFILE,"F",1))  D  Q:RC<0 RC
 . S RC=$$LOADFLDS^RORUPDUT(RORFILE,IENS)
 ;--- API #2
 Q 0
 ;
 ;***** EXTRACTS PROPER RESULT CODE FROM THE OBSERVATION ID
 ;
 ; OID           Observation ID in HL7 format
 ; CS            HL7 component separator
 ;
 ; Return values:
 ;           Lab result code (see the LA7SC parameter of
 ;           the GCPR^LA7QRY entry point)
 ;             ^1: Result code
 ;             ^2: Coding system ("LN" or "NLT")
 ;           Or an empty string if coding system is unknown or there
 ;           are no active search indicators exist for this code.
 ;
RESCODE(OID,CS) ;
 N CODE,I,RESCODE,TYPE
 S RESCODE=""
 F I=1,4  D  Q:RESCODE'=""
 . S CODE=$P(OID,CS,I),TYPE=$P(OID,CS,I+2)             Q:CODE=""
 . S TYPE=$S(TYPE="LN":"LN",TYPE="99VA64":"NLT",1:"")  Q:TYPE=""
 . ;--- Check if the search indicators exist for this code
 . S RESCODE=CODE_U_TYPE
 . S:$D(@RORUPDPI@("LS",RESCODE))<10 RESCODE=""
 Q RESCODE
 ;
 ;***** LOADS AND PROCESSES RESULTS OF THE TESTS
 ;
 ; PATIEN        Patient IEN
 ; ROR8LAB       Closed root of the HL7 message created by GCPR^LA7QRY
 ;
 ; Return values:
 ;       <0  Error code
 ;        0  Ok
 ;
RESULTS(PATIEN,ROR8LAB) ;
 N CS,DATE,FS,I,ISEG,LOCATION,LSIEN,LSNODE,RC,RESCODE,RESVAL,RORHL,SEG,SEGTYPE,TMP
 S ISEG="",RC=0
 F  S ISEG=$O(@ROR8LAB@(ISEG))  Q:ISEG=""  D  Q:RC<0
 . S SEG=$G(@ROR8LAB@(ISEG))
 . ;--- Extract separators from the MSH segment
 . I $E(SEG,1,3)="MSH"  D  Q
 . . S (RORHL("FS"),FS)=$E(SEG,4),TMP=$P(SEG,FS,2)
 . . S CS=$E(TMP,1)
 . ;--- Skip all segments except OBX
 . S SEGTYPE=$P(SEG,FS)
 . Q:SEGTYPE'="OBX"
 . ;--- Get lab result code
 . S RESCODE=$$RESCODE($P(SEG,FS,4),CS)  Q:RESCODE=""
 . ;--- Load the full segment
 . D LOADSEG^RORHL7A(.SEG,$NA(@ROR8LAB@(ISEG)))
 . ;--- Get the result data
 . S RESVAL=$G(SEG(5)),TMP=$G(SEG(7))
 . S RESVAL("RL")=$P(TMP,"-",1) ; Reference Low
 . S RESVAL("RH")=$P(TMP,"-",2) ; Reference High
 . S DATE=$$HL7TFM^XLFDT($G(SEG(14)),"L")\1
 . ;--- Analyze the result
 . K LOCATION
 . S LSNODE=$NA(@RORUPDPI@("LS",RESCODE))
 . S LSIEN=""
 . F  S LSIEN=$O(@LSNODE@(LSIEN))  Q:LSIEN=""  D  Q:RC<0
 . . S I="",RC=0
 . . F  S I=$O(@LSNODE@(LSIEN,I))  Q:I=""  D  Q:RC
 . . . S TMP=$G(@LSNODE@(LSIEN,I))
 . . . S RC=$$CHKIND(+TMP,$P(TMP,U,2),.RESVAL)
 . . Q:RC'>0
 . . S TMP=+$G(RORVALS("LS",LSIEN))
 . . I TMP  Q:(DATE'>0)!(DATE'<TMP)
 . . S:'$D(LOCATION) LOCATION=$$IEN^XUAF4($P($G(SEG(15)),CS))
 . . S RORVALS("LS",LSIEN)=DATE_U_LOCATION
 ;---
 Q $S(RC<0:RC,1:0)
 ;
 ;***** IMPLEMENTATION OF THE SELECTION RULE
 ;
 ; LSIEN         Lab Search IEN
 ;
 ; Return values:
 ;        0  Skip the patient
 ;        1  Add the patient
 ;
RULE(LSIEN) ;
 Q:'$D(RORVALS("LS",LSIEN)) 0
 N DATE,LOC,SRDT
 S DATE=+$G(RORVALS("LS",LSIEN))
 D:DATE>0
 . S LOC=$P($G(RORVALS("LS",LSIEN)),U,2)
 . S SRDT=$$GETVAL^RORUPDUT("ROR SRDT")
 . I (DATE<SRDT)!(SRDT'>0)  D  Q
 . . S RORVALS("SV","ROR SRDT")=DATE
 . . S RORVALS("SV","ROR SRLOC")=LOC
 . I DATE=SRDT  D:$$GETVAL^RORUPDUT("ROR SRLOC")=""  Q
 . . S RORVALS("SV","ROR SRLOC")=LOC
 Q 1
