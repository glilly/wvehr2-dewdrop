RORX001 ;HCIOFO/SG - LIST OF REGISTRY PATIENTS ; 9/15/05 2:13pm
 ;;1.5;CLINICAL CASE REGISTRIES;;Feb 17, 2006
 ;
 ; This routine uses the following IAs:
 ;
 ; #10061        DEM^VADPT (supported)
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
 N COL,COLUMNS,HEADER,TMP
 S HEADER=$$HEADER^RORXU002(.RORTSK,PARTAG)
 S COLUMNS=$$ADDVAL^RORTSK11(RORTSK,"TBLDEF",,HEADER)
 D ADDATTR^RORTSK11(RORTSK,COLUMNS,"NAME","PATIENTS")
 D ADDATTR^RORTSK11(RORTSK,COLUMNS,"HEADER","1")
 D ADDATTR^RORTSK11(RORTSK,COLUMNS,"FOOTER","1")
 S RORFLDS=".01"
 ;--- Required columns
 F COL="#","NAME"  D
 . S TMP=$$ADDVAL^RORTSK11(RORTSK,"COLUMN",,COLUMNS)
 . D ADDATTR^RORTSK11(RORTSK,TMP,"NAME",COL)
 ;--- Additional columns
 F COL="DOD","CSSN","LAST4","SELRULES","SELDT","CONFDT"  D
 . Q:'$$OPTCOL^RORXU006(COL)
 . S TMP=$$ADDVAL^RORTSK11(RORTSK,"COLUMN",,COLUMNS)
 . D ADDATTR^RORTSK11(RORTSK,TMP,"NAME",COL)
 ;---
 S:$$OPTCOL^RORXU006("CONFDT") RORFLDS=RORFLDS_";2"
 S:$$OPTCOL^RORXU006("SELDT") RORFLDS=RORFLDS_";3.2"
 Q 0
 ;
 ;***** ADDS THE PATIENT DATA TO THE REPORT
 ;
 ; IENS          IENS of the patient's record in the registry
 ; PARTAG        Reference (IEN) to the parent tag
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
PATIENT(IENS,PARTAG) ;
 N DFN,IATIME,NAME,RC,RORBUF,RORMSG,TMP,VA,VADM,VAHOW,VAROOT
 D GETS^DIQ(798,IENS,RORFLDS,"I","RORBUF","RORMSG")
 Q:$G(DIERR) $$DBS^RORERR("RORMSG",-9,,,798,IENS)
 S DFN=$G(RORBUF(798,IENS,.01,"I"))
 ;--- Load the demographic data
 D DEM^VADPT
 ;--- The <PATIENT> tag
 S PTAG=$$ADDVAL^RORTSK11(RORTSK,"PATIENT",,PARTAG,,DFN)
 ;--- Patient Name
 D ADDVAL^RORTSK11(RORTSK,"NAME",VADM(1),PTAG,1)
 ;--- Date of Death
 D:$$OPTCOL^RORXU006("DOD")
 . S TMP=$$DATE^RORXU002(VADM(6)\1)
 . D ADDVAL^RORTSK11(RORTSK,"DOD",TMP,PTAG,1)
 ;--- Coded SSN
 D:$$OPTCOL^RORXU006("CSSN")
 . S TMP=$$XOR^RORUTL03($P(VADM(2),U))
 . D ADDVAL^RORTSK11(RORTSK,"CSSN",TMP,PTAG,1)
 ;--- Last 4 digits of the SSN
 D:$$OPTCOL^RORXU006("LAST4")
 . D ADDVAL^RORTSK11(RORTSK,"LAST4",VA("BID"),PTAG,2)
 ;--- Selection Rules
 I $$OPTCOL^RORXU006("SELRULES")  D  Q:RC<0 RC
 . S RC=$$SELRULES(IENS,PTAG)
 ;--- Date Selected for the Registry
 D:$$OPTCOL^RORXU006("SELDT")
 . S TMP=$$DATE^RORXU002($G(RORBUF(798,IENS,3.2,"I"))\1)
 . D ADDVAL^RORTSK11(RORTSK,"SELDT",TMP,PTAG,1)
 ;--- Date Confirmed in the Registry
 D:$$OPTCOL^RORXU006("CONFDT")
 . S TMP=$$DATE^RORXU002($G(RORBUF(798,IENS,2,"I"))\1)
 . D ADDVAL^RORTSK11(RORTSK,"CONFDT",TMP,PTAG,1)
 ;--- Patient IEN (DFN)
 ;S:$$OPTCOL^RORXU006("DFN") TMP=$$ADDVAL^RORTSK11(RORTSK,"DFN",DFN,PTAG)
 ;--- Integration Control Number
 ;D:$$OPTCOL^RORXU006("ICN")
 ;. S TMP=$$ICN^RORUTL02(DFN)
 ;. D ADDVAL^RORTSK11(RORTSK,"ICN",$P(TMP,"V"),PTAG,1)
 Q 0
 ;
 ;***** COMPILES A LIST OF REGISTRY PATIENTS
 ; REPORT CODE: 001
 ;
 ; .RORTSK       Task number and task parameters
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
REGPTLST(RORTSK) ;
 N RORFLDS       ; Fields to load from the file #798
 N RORPTN        ; Number of patients in the registry
 N RORREG        ; Registry IEN
 ;
 N BODY,CNT,ECNT,IEN,IENS,MODE,PTNAME,RC,REPORT,SFLAGS,TMP,XREFNODE
 ;--- Root node of the report
 S REPORT=$$ADDVAL^RORTSK11(RORTSK,"REPORT")
 Q:REPORT<0 REPORT
 ;
 ;--- Get and prepare the report parameters
 S RORREG=$$PARAM^RORTSK01("REGIEN")
 S RC=$$PARAMS^RORXU002(.RORTSK,REPORT,,,.SFLAGS)  Q:RC<0 RC
 S SFLAGS=$TR(SFLAGS,"DG")
 S:'$$PARAM^RORTSK01("PATIENTS","CONFIRMED") SFLAGS=SFLAGS_"C"
 S:'$$PARAM^RORTSK01("PATIENTS","PENDING") SFLAGS=SFLAGS_"G"
 D ADDVAL^RORTSK11(RORTSK,"TYPE",SFLAGS,REPORT)
 ;
 ;--- Initialize constants and variables
 S RORPTN=$$REGSIZE^RORUTL02(+RORREG)  S:RORPTN<0 RORPTN=0
 S ECNT=0,XREFNODE=$NA(^RORDATA(798,"ARP",RORREG_"#"))
 ;
 ;--- The report header and list of patients
 S RC=$$HEADER(REPORT)  Q:RC<0 RC
 S BODY=$$ADDVAL^RORTSK11(RORTSK,"PATIENTS",,REPORT)
 D ADDATTR^RORTSK11(RORTSK,BODY,"TABLE","PATIENTS")
 Q:BODY<0 BODY
 ;
 ;--- Browse through the registry records
 S PTNAME="",(CNT,RC)=0
 F  S PTNAME=$O(@XREFNODE@(PTNAME))  Q:PTNAME=""  D  Q:RC<0
 . S IEN=0
 . F  S IEN=$O(@XREFNODE@(PTNAME,IEN))  Q:IEN'>0  D  Q:RC<0
 . . S TMP=$S(RORPTN>0:CNT/RORPTN,1:"")
 . . S RC=$$LOOP^RORTSK01(TMP)  Q:RC<0
 . . S IENS=IEN_",",CNT=CNT+1
 . . ;--- Check if the patient should be skipped
 . . Q:$$SKIP^RORXU005(IEN,SFLAGS)
 . . ;--- Process the registry record
 . . I $$PATIENT(IENS,BODY)<0  S ECNT=ECNT+1  Q
 ;---
 Q $S(RC<0:RC,ECNT>0:-43,1:0)
 ;
 ;***** ADDS THE SELECTION RULES TO THE REPORT
 ;
 ; IENS          IENS of the patient's record in the registry
 ; PARTAG        Reference (IEN) to the parent tag
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
SELRULES(IENS,PARTAG) ;
 N CNT,I,RORBUF,RORMSG,RT,SRLTAG,TMP
 ;--- Load the list of selection rules
 D LIST^DIC(798.01,","_IENS,"@;.01I;1I",,,,,"B",,,"RORBUF","RORMSG")
 Q:$G(DIERR) $$DBS^RORERR("RORMSG",-9,,,798.01,IENS)
 ;--- The <SELRULES> ... </SELRULES> tags
 S SRLTAG=$$ADDVAL^RORTSK11(RORTSK,"SELRULES",,PARTAG)
 ;--- Add the selection rules to the report
 S I="",CNT=0
 F  S I=$O(RORBUF("DILIST","ID",I))  Q:I=""  D
 . S RT=$$ADDVAL^RORTSK11(RORTSK,"RULE",,SRLTAG),CNT=CNT+1
 . S TMP=$G(RORBUF("DILIST","ID",I,.01))
 . S TMP=$$GET1^DIQ(798.2,TMP_",",4,,,"RORMSG")
 . Q:$G(DIERR)!(TMP="")
 . D ADDATTR^RORTSK11(RORTSK,RT,"DESCR",TMP)
 . S TMP=$$DATE^RORXU002($G(RORBUF("DILIST","ID",I,1))\1)
 . D:TMP'="" ADDATTR^RORTSK11(RORTSK,RT,"DATE",TMP)
 ;--- Add the default item if no selection rules have been found
 D:CNT'>0
 . S RT=$$ADDVAL^RORTSK11(RORTSK,"RULE",,SRLTAG)
 . D ADDATTR^RORTSK11(RORTSK,RT,"DESCR","Manual Entry")
 Q 0
