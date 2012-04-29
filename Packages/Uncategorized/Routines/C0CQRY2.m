LA7QRY2 ;DALOI/JMC - Lab HL7 Query Utility ; 04/13/09
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46**;Sep 27, 1994;Build 2
 ; JMC - mods to check for IHS V LAB file
 ;
 Q
 ;
PATID ; Resolve patient id and establish patient environment
 ;
 N LA7X
 ;
 S (DFN,LRDFN)="",LA7PTYP=0
 ;
 ; SSN passed as patient identifier
 I LA7PTID?9N.1A D
 . S LA7PTYP=1
 . S LA7X=$O(^DPT("SSN",LA7PTID,0))
 . I LA7X>0 D SETDFN(LA7X)
 ;
 ; MPI/ICN (integration control number) passed as patient identifier
 I LA7PTID?10N1"V"6N D
 . S LA7PTYP=2
 . S LA7X=$$GETDFN^MPIF001($P(LA7PTID,"V"))
 . I LA7X>0 D SETDFN(LA7X)
 ;
 ; If no patient identified/no laboratory record - return exception message
 I 'LA7PTYP S LA7ERR(1)="Invalid patient identifier passed"
 I 'DFN S LA7ERR(2)="No patient found with requested identifier"
 I DFN,'LRDFN S LA7ERR(3)="No laboratory record for requested patient"
 I LRDFN,'$D(^LR(LRDFN)) S LA7ERR(4)="Database error - missing laboratory record for requested patient"
 Q
 ;
 ;
BCD ; Search by specimen collection date.
 ;
 N LA763,LA7QUIT
 ;
 S (LA7SDT(0),LA7EDT(0))=0
 I LA7SDT S LA7SDT(0)=9999999-LA7SDT
 I LA7EDT S LA7EDT(0)=9999999-LA7EDT
 ;
 F LRSS="CH","MI","SP" D
 . S (LA7QUIT,LRIDT)=0
 . I LA7EDT(0) S LRIDT=$O(^LR(LRDFN,LRSS,LA7EDT(0)),-1)
 . F  S LRIDT=$O(^LR(LRDFN,LRSS,LRIDT)) Q:LA7QUIT  D
 . . ; Quit if reached end of data or outside date criteria
 . . I 'LRIDT!(LRIDT>LA7SDT(0)) S LA7QUIT=1 Q
 . . D SEARCH
 ;
 Q
 ;
 ;
BRAD ; Search by results available date (completion date).
 ; Assumes cross-references still exist for dates in LRO(69) global.
 ; Collects specimen date/time values for a given LRDFN and completion date.
 ; Cross-reference is by date only, time stripped from start date.
 ; Uses cross-reference ^LRO(69,DT,1,"AN",'LOCATION',LRDFN,LRIDT)=""
 ;
 N LA763,LA7DT,LA7ROOT,LA7SRC,X
 ;
 ; Check if orders still exist Iin file #69 for search range
 S LA7SDT(1)=(LA7SDT\1)-.0000000001,LA7EDT(1)=(LA7EDT\1)+.24,LA7SRC=0
 S X=$O(^LRO(69,LA7SDT(1)))
 I X,X<LA7EDT(1) S LA7SRC=1
 ;
 ; Search "AN" cross-reference in file #69.
 I LA7SRC D
 . S LA7DT=LA7SDT(1)
 . F  S LA7DT=$O(^LRO(69,LA7DT)) Q:'LA7DT!(LA7DT>LA7EDT(1))  D
 . . S LA7ROOT="^LRO(69,LA7DT,1,""AN"")"
 . . F  S LA7ROOT=$Q(@LA7ROOT) Q:LA7ROOT=""!($QS(LA7ROOT,2)'=LA7DT)!($QS(LA7ROOT,4)'="AN")  D
 . . . I $QS(LA7ROOT,6)'=LRDFN Q
 . . . S LRIDT=$QS(LA7ROOT,7)
 . . . F LRSS="CH","MI","SP" D SEARCH
 ;
 ; If no orders in #69 then do long search through file #63.
 I 'LA7SRC D
 . F LRSS="CH","MI","SP" D
 . . S LRIDT=0
 . . F  S LRIDT=$O(^LR(LRDFN,LRSS,LRIDT)) Q:'LRIDT  D
 . . . S LA763(0)=$G(^LR(LRDFN,LRSS,LRIDT,0))
 . . . I $P(LA763(0),"^",3)>LA7SDT(1),$P(LA763(0),"^",3)<LA7EDT(1) D SEARCH
 ;
 Q
 ;
 ;
SEARCH ; Search subscript for a specific collection date/time
 ;
 K LA763
 S LA763(0)=$G(^LR(LRDFN,LRSS,LRIDT,0))
 ;
 ; Only CH, MI, and BB subscripts store pointer to file #61 in 5th piece of zeroth node.
 ; Quit if specific specimen codes and they do not match
 I "CHMIBB"[LRSS S LA761=+$P(LA763(0),"^",5)
 E  S LA761=0
 I LA761,$D(^TMP("LA7-61",$J)),'$D(^TMP("LA7-61",$J,LA761)) Q
 ;
 ; --- Chemistry
 I LRSS="CH" D CHSS Q
 ; --- Microbiology
 I LRSS="MI" D MISS Q
 ; --- Surgical pathology
 I LRSS="SP" D APSS Q
 ; --- Cytology
 I LRSS="CY" D APSS Q
 ; --- Electron Micrscopsy
 I LRSS="EM" D APSS Q
 ; --- Autopsy
 I LRSS="AU" D APSS Q
 ; --- Blood Bank
 I LRSS="BB" D BBSS Q
 Q
 ;
 ;
CHSS ; Search "CH" datanames for matching codes
 ;
 N LA7X,LRSB
 ;
 S LRSB=1
 F  S LRSB=$O(^LR(LRDFN,LRSS,LRIDT,LRSB)) Q:'LRSB  D
 . S LA7X=$G(^LR(LRDFN,LRSS,LRIDT,LRSB))
 . I $D(^AUPNVLAB) D LNCHK^C0CLA7Q ; WV check for IHS.
 . S LA7CODE=$$DEFCODE^LA7VHLU5(LRSS,LRSB,$P(LA7X,"^",3),LA761)
 . D CHECK
 ;
 Q
 ;
 ;
MISS ; Search "MI" subscripts for matching codes
 ;
 N LA7ND,LRSB
 ;
 S LA7ND=0
 F LA7ND=1,5,8,11,16 I $D(^LR(LRDFN,LRSS,LRIDT,LA7ND)) D
 . S LRSB=$S(LA7ND=1:11,LA7ND=5:14,LA7ND=8:18,LA7ND=11:22,LA7ND=16:33,1:11)
 . S LA7CODE=$$DEFCODE^LA7VHLU5(LRSS,LRSB,"",LA761)
 . D CHECK
 Q
 ;
 ;
APSS ; Search AP subscripts for matching codes
 ; AP results are currently not coded - use defaults
 ;
 N LA7CODE,LRSB
 ;
 S LRSB=.012
 S LA7CODE=$$DEFCODE^LA7VHLU5(LRSS,LRSB,"","")
 D CHECK
 ;
 Q
 ;
 ;
BBSS ; Search BB subscript for matching codes
 ; *** This subscript currently not supported ***
 Q
 ;
 ;
CHECK ; Check NLT order/result and LOINC codes.
 ;
 N LA7QUIT
 ;
 ; If wildcard then store
 ; Otherwise check for specific NLT order/result and LOINC codes
 I LA7SC="*" D STORE Q
 S LA7QUIT=0
 F I=1:1:3 D  Q:LA7QUIT
 . ; If no test code then skip
 . I '$L($P(LA7CODE,"!",I)) Q
 . ; If test code does not match a search code then quit
 . I '$D(^TMP($S(I=3:"LA7-LN",1:"LA7-NLT"),$J,$P(LA7CODE,"!",I))) Q
 . D STORE S LA7QUIT=1
 ;
 Q
 ;
 ;
STORE ; Store entry for building in HL7 message
 ;
 S ^TMP("LA7-QRY",$J,LRDFN,LRIDT,LRSS,LA7CODE,LRSB)=""
 Q
 ;
 ;
SETDFN(LA7X) ; Setup DFN and other lab variables.
 ;
 S DFN=LA7X,LRDFN=$P($G(^DPT(DFN,"LR")),"^")
 Q
