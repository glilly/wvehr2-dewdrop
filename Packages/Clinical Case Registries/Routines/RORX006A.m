RORX006A ;HCIOFO/BH,SG - LAB UTILIZATION (QUERY & SORT) ; 11/8/05 8:35am
 ;;1.5;CLINICAL CASE REGISTRIES;;Feb 17, 2006
 ;
 Q
 ;
 ;***** LOADS AND PROCESSES THE LAB DATA
 ;
 ; DFN           Patient IEN (in file #2)
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Number of non-fatal errors
 ;
LABDATA(DFN) ;
 N DST,ENDT,NR,PTNO,PTNR,PRNT,RC,TSTIEN
 S DST=$NA(^TMP("RORX006",$J))
 ;
 ;--- Get the data
 S DST("RORCB")="$$LTSCB^RORX006A",DST("RORIDT")=""
 S RC=$$LTSEARCH^RORUTL10(DFN,RORLTST,.DST,,RORSDT,ROREDT1)
 Q:RC<0 RC  Q:$D(@DST@("PAT",DFN))<10 0
 ;
 ;--- Calculate intermediate totals of the tests
 S TSTIEN=0,(PTNR,PTNT)=0
 F  S TSTIEN=$O(@DST@("PAT",DFN,"R",TSTIEN))  Q:TSTIEN'>0  D
 . S NR=+$G(@DST@("PAT",DFN,"R",TSTIEN))
 . S PTNR=PTNR+NR  ; Number of patient's results
 . S PTNT=PTNT+1   ; Number of different tests
 . ;---
 . S @DST@("RES",TSTIEN,"P")=$G(@DST@("RES",TSTIEN,"P"))+1
 . S @DST@("RES",TSTIEN,"R")=$G(@DST@("RES",TSTIEN,"R"))+NR
 . ;---
 . S TMP=$G(@DST@("RES",TSTIEN,"M"))
 . D:NR'<TMP
 . . I NR>TMP  S @DST@("RES",TSTIEN,"M")=NR_U_1  Q
 . . S $P(@DST@("RES",TSTIEN,"M"),U,2)=$P(TMP,U,2)+1
 ;
 ;--- Orders
 S @DST@("ORD")=$G(@DST@("ORD"))+$G(@DST@("PAT",DFN,"O"))
 ;
 ;--- Results
 S @DST@("RES1",PTNR)=$G(@DST@("RES1",PTNR))+1
 S @DST@("RES1",PTNR,RORPNAME,DFN)=""
 ;
 ;--- Other totals
 S @DST@("PAT",DFN)=RORLAST4_U_RORDOD
 S @DST@("PAT",DFN,"R")=PTNR_U_PTNT
 S @DST@("PAT")=$G(@DST@("PAT"))+1
 S @DST@("RES")=$G(@DST@("RES"))+PTNR
 Q 0
 ;
 ;***** LAB SEARCH CALLBACK
 ;
 ; .ROR8DST      Reference to the ROR8DST parameter.
 ;
 ; INVDT         IEN of the Lab test (inverted date)
 ;
 ; .RESULT       Reference to a local variable, which contains
 ;               the result (see the $$LTSEARCH^RORUTL10).
 ;
 ; Return Values:
 ;       <0  Error code (the search will be aborted)
 ;        0  Ok
 ;        1  Skip this result
 ;        2  Skip this and all remaining results
 ;
LTSCB(ROR8DST,INVDT,RESULT) ;
 N DFN,TMP,TSTIEN
 S DFN=+ROR8DST("RORDFN"),TSTIEN=+RESULT(2)
 ;--- Number of orders
 I INVDT'=ROR8DST("RORIDT")  D  S ROR8DST("RORIDT")=INVDT
 . S @ROR8DST@("PAT",DFN,"O")=$G(@ROR8DST@("PAT",DFN,"O"))+1
 ;--- Number of results
 S TMP=$G(@ROR8DST@("PAT",DFN,"R",TSTIEN))
 S @ROR8DST@("PAT",DFN,"R",TSTIEN)=TMP+1
 Q 0
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
 N RORDOD        ; Date of death of the current patient
 N RORLAST4      ; Last 4 digits of the current patient's SSN
 N RORPNAME      ; Name of the current patient
 N RORPTN        ; Number of patients in the registry
 ;
 N CNT,ECNT,IEN,IENS,PATIEN,RC,TMP,VA,VADM,XREFNODE
 S XREFNODE=$NA(^RORDATA(798,"AC",+RORREG))
 S RORPTN=$$REGSIZE^RORUTL02(+RORREG)  S:RORPTN<0 RORPTN=0
 S (CNT,ECNT,RC)=0
 ;
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
 . ;--- Get the patient's data
 . D VADEM^RORUTL05(PATIEN,1)
 . S RORPNAME=VADM(1),RORLAST4=VA("BID")
 . S RORDOD=$$DATE^RORXU002($P(VADM(6),U)\1)
 . ;
 . ;--- Get the Lab data
 . S RC=$$LABDATA(PATIEN)
 . I RC  Q:RC<0  S ECNT=ECNT+RC
 ;---
 Q $S(RC<0:RC,1:ECNT)
 ;
 ;***** SORTS THE RESULTS AND COMPILES THE TOTALS
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Number of non-fatal errors
 ;
SORT() ;
 N ECNT,IEN,NAME,NDLT,NODE,RC,RORMSG,TMP
 S NODE=$NA(^TMP("RORX006",$J)),(ECNT,RC)=0
 ;---
 S RC=$$LOOP^RORTSK01(0)  Q:RC<0 RC
 Q:$D(@NODE)<10 0
 ;---
 S IEN=0,NDLT=0
 F  S IEN=$O(@NODE@("RES",IEN))  Q:IEN'>0  D
 . S NDLT=NDLT+1
 . S NAME=$$GET1^DIQ(60,IEN,.01,,,"RORMSG")
 . D:$G(DIERR) DBS^RORERR("RORMSG",-9,,,60,IEN)
 . S:NAME?." " NAME="Unknown ("_IEN_")"
 . S TMP=+$G(@NODE@("RES",IEN,"R"))
 . S @NODE@("RES","B",TMP,NAME,IEN)=""
 ;--- Total numbers of Lab tests
 S $P(@NODE@("RES"),U,2)=NDLT
 ;---
 Q $S(RC<0:RC,1:ECNT)
