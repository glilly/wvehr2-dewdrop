C0CLA7Q ;WV/JMC - CCD/CCR Lab HL7 Query Utility ;Jul 6, 2009
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;
 ;
 Q
 ;
 ;
LAB(C0CPTID,C0CSDT,C0CEDT,C0CSC,C0CSPEC,C0CERR,C0CDEST,C0CHL7) ; Entry point for Lab Result Query
 ;
 ;
 K ^TMP("C0C-VLAB",$J)
 ;
 ; Check and retrieve lab results from LAB DATA file (#63)
 S C0CDEST=$$GCPR^LA7QRY($G(C0CPTID),$G(C0CSDT),$G(C0CEDT),.C0CSC,.C0CSPEC,.C0CERR,$G(C0CDEST),$G(C0CHL7))
 ;
 ; If V LAB file present then check for lab results that are only in this file
 ; If results found in V Lab file then build results and add to above results.
 I $D(^AUPNVLAB) D
 . D VCHECK
 . I $D(^TMP("C0C-VLAB",$J,3)) D VBUILD
 ;
 ;K ^TMP("C0C-VLAB",$J)
 ;
 Q C0CDEST
 ;
 ;
VCHECK ; If V LAB file present then check for lab results that are only in this file.
 ;
 N C0CDA,C0CEND,C0CROOT,C0CVLAB,LA7PTID,LA7SC,LA7SCRC,LA7SPEC
 ;
 S LA7PTID=C0CPTID
 D PATID^LA7QRY2
 I $D(LA7ERR) Q
 ;
 ; Resolve search codes to lab datanames
 S LA7SC=$G(C0CSC)
 I $T(SCLIST^LA7QRY2)'="" D
 . N TMP
 . S LA7SCRC=$G(C0CSC)
 . S TMP=$$SCLIST^LA7QRY2(LA7SCRC)
 . S LA7SC=TMP
 ;
 I LA7SC'="*" D CHKSC^LA7QRY1
 ;
 ; Convert specimen codes to file #61 Topography entries
 S LA7SPEC=$G(C0CSPEC)
 I LA7SPEC'="*"  D SPEC^LA7QRY1
 ;
 S C0CROOT="^AUPNVLAB(""ALR4"",DFN,C0CSDT)",C0CEND=0
 ;
 F  S C0CROOT=$Q(@C0CROOT) Q:C0CROOT=""  D  Q:C0CEND
 . I $QS(C0CROOT,1)'="ALR4"!($QS(C0CROOT,2)'=DFN) S C0CEND=1 Q  ; Left x-ref or patient
 . I $QS(C0CROOT,3)>C0CEDT S C0CEND=1 Q  ; Exceeded end date/time
 . S C0CDA=$QS(C0CROOT,4)
 . I $D(^TMP("C0C-VLAB",$J,1,C0CDA)) Q  ; Already checked during scan of file #63
 . I $P($G(^AUPNVLAB(C0CDA,11)),"^",8)=1 Q  ; Source is LAB DATA file - skip
 . D VCHK1
 ;
 ;
 Q
 ;
 ;
VBUILD ; Build results found only in V LAB file into HL7 structure.
 ;
 ;
 Q
 ;
 ;
LNCHK ; Check for corresponding entry in V LAB file and related LOINC code for a result in file #63.
 ; Call from LA7QRY2
 ;
 N DFN,C0C60,C0C63,C0CACC,C0CDA,C0CDT,C0CLN,C0CPDA,C0CPTEST,C0CSPEC,C0CTEST,X
 ;
 S DFN=$P(^LR(LRDFN,0),"^",3)
 S C0C63(0)=^LR(LRDFN,LRSS,LRIDT,0)
 S C0CDT=$P(C0C63(0),"^"),C0CACC=$P(C0C63(0),"^",6),C0CSPEC=$P(C0C63(0),"^",5)
 S (C0CTEST,C0CTEST(64),C0CPTEST,C0CPTEST(64),C0CLN)=""
 ;
 ; ^AUPNVLAB("ALR1",5380,"EKT 0307 48",173,3080307.211055,5427197)=""
 ;
 S C0C60=""
 F  S C0C60=$O(^LAB(60,"C",LRSS_";"_LRSB_";1",C0C60)) Q:'C0C60  D  Q:C0CLN'=""
 . D FINDDT
 . I C0CDA<1 Q
 . I $P($G(^AUPNVLAB(C0CDA,11)),"^",8)'=1 Q  ; Source is not LAB DATA file - skip
 . S C0CLN=$P($G(^AUPNVLAB(C0CDA,11)),"^",13)
 . S C0CPDA=$P($G(^AUPNVLAB(C0CDA,12)),"^",8)
 . I C0CPDA,'$D(^AUPNVLAB(C0CPDA,0)) S C0CPDA="" ; Dangling pointer
 . I C0CPDA="" S C0CPDA=C0CDA
 . S C0CTEST=$P($G(^AUPNVLAB(C0CDA,0)),"^"),X=$P($G(^LAB(60,C0CTEST,64)),"^",2)
 . I X S C0CTEST(64)=$P($G(^LAM(X,0)),"^",2)
 . S C0CPTEST=$P($G(^AUPNVLAB(C0CPDA,0)),"^"),X=$P($G(^LAB(60,C0CPTEST,64)),"^")
 . I X S C0CPTEST(64)=$P($G(^LAM(X,0)),"^",2)
 . S ^TMP("C0C-VLAB",$J,1,C0CDA)=""
 . I C0CDA'=C0CPDA S ^TMP("C0C-VLAB",$J,1,C0CPDA)=""
 . S ^TMP("C0C-VLAB",$J,2,LRDFN,LRSS,LRIDT,LRSB)=C0CPTEST(64)_"^"_C0CTEST(64)_"^"_C0CLN_"^"_C0CDA_"^"_C0CTEST_"^"_C0CPDA_"^"_C0CPTEST
 ;
 S X=$P(LA7X,"^",3)
 ; If order NLT then update if no order NLT
 I C0CPTEST(64),$P(X,"!")="" S $P(X,"!")=C0CPTEST(64)
 ;
 ; If result NLT then update if no result NLT
 I C0CTEST(64),$P(X,"!",2)="" S $P(X,"!",2)=C0CTEST(64)
 ;
 ; If LOINC found then update variable with LN code
 I C0CLN'="",$P(X,"!",3)="" S $P(X,"!",3)=C0CLN
 ;
 S $P(LA7X,"^",3)=X
 ;
 Q
 ;
 ;
TMPCHK ; Check if LN/NLT codes saved from V LAB file above and use when building OBR/OBX segments
 ; Called from LA7VOBX1
 ;
 N I,X
 ;
 S X=$G(^TMP("C0C-VLAB",$J,2,LRDFN,LRSS,LRIDT,LRSB))
 I X="" Q
 F I=1:1:3 I $P(LA7X,"!",I)="",$P(X,"^",I)'="" S $P(LA7X,"!",I)=$P(X,"^",I)
 S $P(LA7VAL,"^",3)=LA7X
 ;
 Q
 ;
 ;
VCHK1 ; Check the entry in V Lab to determine if it meets criteria
 ;
 N C0CVLAB,I
 ;
 F I=0,12 S C0CVLAB(I)=$G(^AUPNVLAB(C0CDA,I))
 ;
 ; JMC 04/13/09 - Store anything for now that meets date criteria.
 D VSTORE
 ;
 Q
 ;
 ;
VSTORE ; Store entry for building in HL7 message when parent is from V LAB file.
 ;
 N C0CPDA,C0CPTEST
 ;
 ; Determine parent test to use for OBR segment
 S C0CPDA=$P(C0CVLAB(12),"^",8)
 I C0CPDA="" S C0CPDA=C0CDA
 ;
 ; Determine parent test
 S C0CPTEST=$P($G(^AUPNVLAB(C0CPDA,0)),"^")
 ;
 S ^TMP("C0C-VLAB",$J,3,$P(C0CVLAB(0),"^",2),$P(C0CVLAB(12),"^"),C0CPTEST,C0CDA)=C0CPDA
 ;
 Q
 ;
 ;
FINDDT ; Find entry in V LAB for the date/time or one close to it.
 ; RPMS stores related specimen entries under the same date/time.
 ; Lab file #63 creates unique entries with slightly different times.
 ;
 S C0CDA=$O(^AUPNVLAB("ALR1",DFN,C0CACC,C0C60,C0CDT,0))
 I C0CDA>0 Q
 ;
 ; If entry found then confirm that specimen type matches.
 N C0CDTY
 S C0CDTY=$O(^AUPNVLAB("ALR1",DFN,C0CACC,C0C60,0))
 I C0CDTY D
 . I $P(C0CDT,".")'=$P(C0CDTY,".") Q
 . S C0CDA=$O(^AUPNVLAB("ALR1",DFN,C0CACC,C0C60,C0CDTY,0))
 . I C0CSPEC'=$P($G(^AUPNVLAB(C0CDA,11)),"^",3) S C0CDA=""
 ;
 Q
