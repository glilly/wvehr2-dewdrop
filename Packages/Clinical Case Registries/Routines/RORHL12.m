RORHL12 ;HOIFO/BH,SG - HL7 MICROBIOLOGY DATA: OBR ; 3/13/06 9:24am
 ;;1.5;CLINICAL CASE REGISTRIES;**1**;Feb 17, 2006;Build 24
 ;
 ; This routine uses the following IAs:
 ;
 ; #4335         $$GETDATA^LA7UTL1A (controlled)
 ;
 Q
 ;
 ;***** SEARCHES FOR MICROBIOLOGY DATA
 ;
 ; RORDFN        IEN of the patient in the PATIENT file (#2)
 ;
 ; .DXDTS        Reference to a local variable where the
 ;               data extraction time frames are stored.
 ;
 ; [CDSMODE]     Search the data by:
 ;                 0  completion/result date (default)
 ;                 1  specimen collection date
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Non-fatal error(s)
 ;
EN1(RORDFN,DXDTS,CDSMODE) ;
 N ERRCNT,IDX,LRDFN,RC,RCL,RORENDT,RORMIIEN,RORREF,RORSTDT,RORTMP,TMP
 S (ERRCNT,RC)=0
 ;--- Check the parameters
 S CDSMODE=$S($G(CDSMODE):"CD",1:"RAD")
 ;
 S LRDFN=+$$LABREF^RORUTL18(RORDFN)  Q:LRDFN'>0 0
 S RORTMP=$$ALLOC^RORTMP()
 ;
 S IDX=0
 F  S IDX=$O(DXDTS(11,IDX))  Q:IDX'>0  D  Q:RC<0
 . S RORSTDT=$P(DXDTS(11,IDX),U),RORENDT=$P(DXDTS(11,IDX),U,2)
 . K @RORTMP
 . ;--- Get microbiology data
 . S RCL=$$GETDATA^LA7UTL1A(LRDFN,RORSTDT,RORENDT,CDSMODE,RORTMP)
 . I RCL<0  D  Q
 . . S TMP="$$GETDATA^LA7UTL1A"
 . . S RC=$$ERROR^RORERR(-56,,$P(RCL,U,2),RORDFN,+RCL,TMP)
 . ;--- Process the data
 . S RORMIIEN=""
 . F  S RORMIIEN=$O(@RORTMP@(LRDFN,RORMIIEN))  Q:RORMIIEN=""  D
 . . S RORREF=$NA(@RORTMP@(LRDFN,RORMIIEN))
 . . ;---
 . . S TMP=$$OBR(RORREF)
 . . I TMP  Q:TMP<0  S ERRCNT=ERRCNT+TMP
 . . ;---
 . . S TMP=$$OBX^RORHL121(RORREF)
 . . I TMP  Q:TMP<0  S ERRCNT=ERRCNT+TMP
 ;
 D FREE^RORTMP(RORTMP)
 Q $S(RC<0:RC,1:ERRCNT)
 ;
 ;***** MICROBIOLOGY OBR SEGMENT BUILDER
 ;
 ; RORREF        Global reference for MI entry
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Non-fatal error(s)
 ;
OBR(RORREF) ;
 N CS,ERRCNT,RC,RORSEG
 S (ERRCNT,RC)=0
 D ECH^RORHL7(.CS)
 ;
 ;--- Initialize the segment
 S RORSEG(0)="OBR"
 ;
 ;--- OBR-3 - Accession Number
 S TMP=$G(@RORREF@(0,.06,"I"))
 I TMP=""  D  Q RC
 . S RC=$$ERROR^RORERR(-100,,,,"No accession #","$$GETDATA^LA7UTL1A")
 S RORSEG(3)=TMP
 ;
 ;--- OBR-4 - Universal Service ID
 S RORSEG(4)="87999"_CS_"MICROBIOLOGY"_CS_"C4"
 ;
 ;--- OBR-7 - Accession Date
 S TMP=$$FMTHL7^XLFDT($G(@RORREF@(0,.01,"I")))
 I TMP'>0  D  Q RC
 . S RC=$$ERROR^RORERR(-100,,,,"No accession date","$$GETDATA^LA7UTL1A")
 S RORSEG(7)=TMP
 ;
 ;--- OBR-11 - Urine Screen
 S RORSEG(11)=$G(@RORREF@(0,11.57,"I"))
 ;
 ;--- OBR-13 - Site/Specimen
 S RORSEG(13)=$$ESCAPE^RORHL7($G(@RORREF@(0,.05,"E")))
 ;
 ;--- OBR-20 - Collection Sample
 S RORSEG(20)=$$ESCAPE^RORHL7($G(@RORREF@(0,.055,"E")))
 ;
 ;--- OBR-21 - Sputum Screen
 S RORSEG(21)=$$ESCAPE^RORHL7($G(@RORREF@(0,11.58,"E")))
 ;
 ;--- OBR-24 - Diagnostic Service ID
 S RORSEG(24)="MB"
 ;
 ;--- OBR-25 - Sterility Control
 S TMP=$G(@RORREF@(0,11.51,"I"))
 S RORSEG(25)=$S(TMP="P":"F",TMP="N":"R",1:"")
 ;
 ;--- OBR-44 - Division
 S RORSEG(44)=$$SITE^RORUTL03(CS)
 ;
 ;--- Store the segment
 D ADDSEG^RORHL7(.RORSEG)
 Q ERRCNT
