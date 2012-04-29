RORXU002 ;HCIOFO/SG - REPORT BUILDER UTILITIES ; 5/18/06 11:13am
 ;;1.5;CLINICAL CASE REGISTRIES;**1**;Feb 17, 2006;Build 24
 ;
 Q
 ;
 ;***** SCANS THE TABLE DEFINITION (RORSRC) FOR COLUMN NAMES
 ;
 ; .TERM         Reference to a local variable where
 ;               is terminator is returned
 ;
 ; Return Values:
 ;       ""  End of definition
 ;      ...  Name of the column
 ;
COLSCAN(TERM) ;
 N CH,I,TOKEN
 F I=1:1  S TERM=$E(RORSRC,I)  Q:"(,)"[TERM
 S TOKEN=$E(RORSRC,1,I-1)
 F I=I+1:1  S CH=$E(RORSRC,I)  Q:(CH="")!("(,)"'[CH)
 S $E(RORSRC,1,I-1)=""
 Q TOKEN
 ;
 ;***** CHECKS THE FILEMAN DATE/TIME VALUE
DATE(DT) ;
 Q $S(DT>0:+DT,1:"")
 ;
 ;***** OUTPUTS THE BASIC HEADER TO THE REPORT
 ;
 ; .RORTSK       Task number and task parameters
 ;
 ; PARTAG        Reference (IEN) to the parent tag
 ;
 ; Return Values:
 ;       <0  Error code
 ;       >0  IEN of the HEADER element
 ;
HEADER(RORTSK,PARTAG) ;
 N HEADER,IENS,REGIEN,RORBUF,RORMSG,TMP
 S HEADER=$$ADDVAL^RORTSK11(RORTSK,"HEADER",,PARTAG)
 Q:HEADER<0 HEADER
 D ADDVAL^RORTSK11(RORTSK,"DATE",$$DATE($$NOW^XLFDT),HEADER)
 D ADDVAL^RORTSK11(RORTSK,"TASK_NUMBER",RORTSK,HEADER)
 S REGIEN=+$$PARAM^RORTSK01("REGIEN")
 ;---
 S IENS=REGIEN_","
 D GETS^DIQ(798.1,IENS,"1;2","I","RORBUF","RORMSG")
 Q:$G(DIERR) $$DBS^RORERR("RORMSG",-9,,,798.1,IENS)
 S TMP=$G(RORBUF(798.1,IENS,1,"I"))
 D ADDVAL^RORTSK11(RORTSK,"UPDATED_UNTIL",$$DATE(TMP),HEADER)
 S TMP=$G(RORBUF(798.1,IENS,2,"I"))
 D ADDVAL^RORTSK11(RORTSK,"EXTRACTED_UNTIL",$$DATE(TMP),HEADER)
 Q HEADER
 ;
 ;***** PARSES THE COMMA-SEPARATED LIST
 ;
 ; .LIST         Reference to a local variable that contains a list.
 ;               Items of the list are returned as the subscripts of
 ;               this variable.
 ;
LIST(LIST) ;
 N I,TMP,VAL
 F I=1:1  S VAL=$P(LIST,",",I)  Q:VAL=""  D
 . S TMP=$$TRIM^XLFSTR(VAL)
 . S:TMP'="" LIST(TMP)=""
 Q
 ;
 ;***** COMPILES A TEXT DESCRIPTION FOR THE REPORT OPTIONS
 ;
 ; .OPTIONS      Reference to a local variable containing
 ;               the options as subscripts
 ;
 ; [DLGNUM]      Number of the dialog that contains the template
 ;               (7980000.018, by default).
 ;
 ; Return Values:
 ;      ...  Text description of the options
 ;
OPTXT(OPTIONS,DLGNUM) ;
 N I,J,NS,RORBUF,TEXT,TMP
 S:$G(DLGNUM)'>0 DLGNUM=7980000.018
 D BLD^DIALOG(DLGNUM,,,"RORBUF")
 S TEXT="",I=0
 F  S I=$O(RORBUF(I))  Q:I=""  D:$E(RORBUF(I),1)'=" "
 . S NS=0
 . F J=1:1  S TMP=$TR($P(RORBUF(I),",",J)," ")  Q:TMP=""  D
 . . S:$D(OPTIONS(TMP)) NS=2**(J-1)+NS
 . Q:'NS
 . S TMP=$$TRIM^XLFSTR($G(RORBUF(I+NS)))
 . S:TMP'="" TEXT=TEXT_", "_TMP
 Q $P(TEXT,", ",2,999)
 ;
 ;***** OUTPUTS THE PARAMETERS TO THE REPORT
 ;
 ; .RORTSK       Task number and task parameters
 ;
 ; PARTAG        Reference (IEN) to the parent tag
 ;
 ; .STDT         Start and end dates of the report
 ; .ENDT         are returned via these parameters
 ;
 ; [.FLAGS]      Flags for the $$SKIP^RORXU005 are returned via this
 ;               parameter. The "D" (skip deceased patients) and "G"
 ;               (skip pending patients) flags are always added.
 ;
 ; Return Values:
 ;       <0  Error code
 ;       >0  IEN of the PARAMETERS element
 ;
PARAMS(RORTSK,PARTAG,STDT,ENDT,FLAGS) ;
 N BUF,ELEMENT,I,LTAG,MODE,NAME,PARAMS,RC,REGIEN,RORMSG,TMP
 S PARAMS=$$ADDVAL^RORTSK11(RORTSK,"PARAMETERS",,PARTAG)
 S RC=0,(ENDT,STDT)="",FLAGS=""
 ;
 ;=== Registry name
 S REGIEN=+$$PARAM^RORTSK01("REGIEN")
 I REGIEN>0  D  Q:RC<0 RC
 . S TMP=$P($$REGNAME^RORUTL01(REGIEN),U)
 . I TMP=""  S RC=-1  Q
 . S RC=$$ADDVAL^RORTSK11(RORTSK,"REGNAME",TMP,PARAMS)
 ;
 ;=== Alternate date ranges
 F I=2:1:3  D  Q:RC<0
 . S STDT=$$PARAM^RORTSK01("DATE_RANGE_"_I,"START")\1  Q:STDT'>0
 . S ENDT=$$PARAM^RORTSK01("DATE_RANGE_"_I,"END")\1    Q:ENDT'>0
 . S ELEMENT=$$ADDVAL^RORTSK11(RORTSK,"DATE_RANGE_"_I,,PARAMS)
 . I ELEMENT<0  S RC=+ELEMENT  Q
 . S RC=$$ADDATTR^RORTSK11(RORTSK,ELEMENT,"START",STDT)  Q:RC<0
 . S RC=$$ADDATTR^RORTSK11(RORTSK,ELEMENT,"END",ENDT)
 Q:RC<0 RC
 ;
 ;=== Main date range
 S STDT=$$PARAM^RORTSK01("DATE_RANGE","START")\1
 S ENDT=$$PARAM^RORTSK01("DATE_RANGE","END")\1
 I STDT>0,ENDT>0  D  Q:RC<0 RC
 . S ELEMENT=$$ADDVAL^RORTSK11(RORTSK,"DATE_RANGE",,PARAMS)
 . I ELEMENT<0  S RC=+ELEMENT  Q
 . S RC=$$ADDATTR^RORTSK11(RORTSK,ELEMENT,"START",STDT)  Q:RC<0
 . S RC=$$ADDATTR^RORTSK11(RORTSK,ELEMENT,"END",ENDT)
 E  S (ENDT,STDT)=""
 ;
 ;=== Task comment
 S TMP=$$PARAM^RORTSK01("TASK_COMMENT")
 D:TMP'="" ADDVAL^RORTSK11(RORTSK,"TASK_COMMENT",TMP,PARAMS)
 ;
 ;=== Patient selection and Options
 F NAME="PATIENTS","OPTIONS"  D  Q:RC<0
 . K BUF  M BUF=RORTSK("PARAMS",NAME,"A")  Q:$D(BUF)<10
 . ;--- Generate the XML tags
 . S ELEMENT=$$ADDVAL^RORTSK11(RORTSK,NAME,$$OPTXT(.BUF),PARAMS)
 . I ELEMENT'>0  S RC=ELEMENT  Q
 . S TMP=""
 . F  S TMP=$O(BUF(TMP))  Q:TMP=""  D  Q:RC<0
 . . S RC=$$ADDATTR^RORTSK11(RORTSK,ELEMENT,TMP,"1")
 . ;--- Compile the flags
 . D:NAME="PATIENTS"
 . . S:'$D(BUF("DE_BEFORE")) FLAGS=FLAGS_"P"
 . . S:'$D(BUF("DE_DURING")) FLAGS=FLAGS_"N"
 . . S:'$D(BUF("DE_AFTER")) FLAGS=FLAGS_"F"
 Q:RC<0 RC
 ;
 ;=== Other Registries
 I $D(RORTSK("PARAMS","OTHER_REGISTRIES","C"))>1  D  Q:RC<0 RC
 . N NODE,REGIEN
 . S LTAG=$$ADDVAL^RORTSK11(RORTSK,"OTHER_REGISTRIES",,PARAMS)
 . I LTAG<0  S RC=+LTAG  Q
 . S NODE=$NA(RORTSK("PARAMS","OTHER_REGISTRIES","C"))
 . S REGIEN=0
 . F  S REGIEN=$O(@NODE@(REGIEN))  Q:REGIEN'>0  D  Q:RC<0
 . . S TMP=$P($$REGNAME^RORUTL01(REGIEN),U,2)
 . . S MODE=+$G(@NODE@(REGIEN))
 . . I 'MODE!(TMP="")  K @NODE@(REGIEN)  Q
 . . S TMP=TMP_" ("_$S(MODE<0:"Exclude",1:"Include")_")"
 . . S RC=$$ADDVAL^RORTSK11(RORTSK,"REGNAME",TMP,LTAG)
 . S FLAGS=FLAGS_"R"
 ;
 ;=== Local Fields
 I $D(RORTSK("PARAMS","LOCAL_FIELDS","C"))>1  D  Q:RC<0 RC
 . N NODE,IEN,IENS
 . S LTAG=$$ADDVAL^RORTSK11(RORTSK,"LOCAL_FIELDS",,PARAMS)
 . I LTAG<0  S RC=+LTAG  Q
 . S NODE=$NA(RORTSK("PARAMS","LOCAL_FIELDS","C"))
 . S IEN=0
 . F  S IEN=$O(@NODE@(IEN))  Q:IEN'>0  D  Q:RC<0
 . . S TMP=$$GET1^DIQ(799.53,IEN_",",.01,,,"RORMSG")
 . . D:$G(DIERR) DBS^RORERR("RORMSG",-9,,,799.53,IEN_",")
 . . S MODE=+$G(@NODE@(IEN))
 . . I 'MODE!(TMP="")  K @NODE@(IEN)  Q
 . . S TMP=TMP_" ("_$S(MODE<0:"Exclude",1:"Include")_")"
 . . S RC=$$ADDVAL^RORTSK11(RORTSK,"FIELD",TMP,LTAG)
 . S FLAGS=FLAGS_"O"
 ;
 ;=== Lab test ranges
 I $D(RORTSK("PARAMS","LRGRANGES","C"))>1  D  Q:RC<0 RC
 . N GRC,NODE
 . S NODE=$NA(RORTSK("PARAMS","LRGRANGES","C"))
 . S GRC=0
 . F  S GRC=$O(@NODE@(GRC))  Q:GRC'>0  D  Q:RC<0
 . . S RC=$$ITEMIEN^RORUTL09(3,REGIEN,GRC,.TMP)
 . . S:RC'<0 @NODE@(GRC)=TMP
 ;
 ;=== Defaults
 S TMP=$TR(FLAGS,"FNP")  S:$L(FLAGS)-$L(TMP)=3 FLAGS=TMP
 S FLAGS=FLAGS_"DG"
 ;
 ;=== Success
 Q PARAMS
 ;
 ;***** GENERATES TABLE DEFINITION
 ;
 ; TBLREF        Reference to the definition table in the source
 ;               code (TAG^ROUTINE). See the HEADER^RORX013 for
 ;               examples of table definitions.
 ;
 ; HEADER        IEN of the HEADER element
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
TBLDEF(TBLREF,HEADER) ;
 N COND,IT,NAME,RC,RORSRC,TBLDEF,TERM,TGET
 S TGET="S RORSRC=$T("_$P(TBLREF,"^")_"+IT^"_$P(TBLREF,"^",2)_")"
 S RC=0
 F IT=1:1  X TGET  S RORSRC=$P(RORSRC,";;",2)  Q:RORSRC=""  D  Q:RC<0
 . S COND=$$TRIM^XLFSTR($P(RORSRC,U,2,999))
 . I COND'=""  X COND  E  Q
 . S RORSRC=$$TRIM^XLFSTR($P(RORSRC,U))
 . S NAME=$$COLSCAN(.TERM)  Q:(NAME="")!(TERM'="(")
 . S TBLDEF=$$ADDVAL^RORTSK11(RORTSK,"TBLDEF",,HEADER)
 . I TBLDEF<0  S RC=TBLDEF  Q
 . D ADDATTR^RORTSK11(RORTSK,TBLDEF,"NAME",NAME)
 . D ADDATTR^RORTSK11(RORTSK,TBLDEF,"HEADER","1")
 . D ADDATTR^RORTSK11(RORTSK,TBLDEF,"FOOTER","1")
 . D TBLDEF1(TBLDEF)
 Q $S(RC<0:RC,1:0)
 ;
 ;***** GENERATES <COLUMN> ELEMENTS FROM TABLE DEFINITION (RORSRC)
 ;
 ; PTAG          IEN of the parent element
 ;
TBLDEF1(PTAG) ;
 N COLUMN,NAME,TERM
 F  S NAME=$$COLSCAN(.TERM)  Q:NAME=""  D  Q:")"[TERM
 . S COLUMN=$$ADDVAL^RORTSK11(RORTSK,"COLUMN",,PTAG)
 . D ADDATTR^RORTSK11(RORTSK,COLUMN,"NAME",NAME)
 . D:TERM="(" TBLDEF1(COLUMN)
 Q
