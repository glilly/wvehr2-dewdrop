ARJTXRD ;PUG/TOAD - Routine Directory Tools ;2/27/02  14:12
 ;;8.0;KERNEL;;Jul 10, 1995;**LOCAL RTN: PUG/TOAD**
 ;
ANALYZE(ROUTINE,STATS) ; Analyze a routine in the directory
 ; ROUTINE = name of the routine
 ; STATS = array returned with summary info
 ;
 N LINE,LABEL,BODY
 N BYTES S BYTES=0 ; size of routine
 N CHAR S CHAR=0 ; absolute count of char position, incl. eol as $C(13)
 N LINECHAR ; relative count of char position within each line
 N CHECKSUM S CHECKSUM=0 ; absolute checksum of routine, incl. comments
 N LABEL,SECTION,FROM S SECTION="[anonymous]",FROM=1
 ;
 N NUM F NUM=1:1 S LINE=$T(+NUM^@ROUTINE) Q:LINE=""  D
 . I $E(LINE)'=" " D  ; deal with line label
 . . S STATS(NUM,0)=LINE
 . . S LABEL=$P($P(LINE," "),"(") ; get line label if any
 . . Q:LABEL=""  ; this should never happen, but who knows
 . . S STATS("B",LABEL,NUM)="" ; index of labels
 . . I NUM-FROM D  ; for all but anonymous, unless it has lines
 . . . S STATS("ALINE",FROM,NUM-1,SECTION)="" ; index lines by sec
 . . . S STATS("ASIZE",SECTION,NUM-FROM)="" ; index sections by # lines
 . . S SECTION=LABEL,FROM=NUM ; start next section
 . E  S LABEL="",BODY=LINE,$E(BODY)=""
 . S BYTES=BYTES+$L(LINE)+2
 . F LINECHAR=1:1:$L(LINE) D  ; add line to cumulative absolute checksum
 . . S CHAR=CHAR+1 ; advance absolute counter
 . . S CHECKSUM=CHECKSUM+($A(LINE,LINECHAR)*CHAR)
 . S CHAR=CHAR+1,CHECKSUM=CHECKSUM+(13*CHAR) ; incl. end of line
 S STATS("ALINE",FROM,NUM-1,SECTION)="" ; index lines by sec
 S STATS("ASIZE",SECTION,NUM-FROM)="" ; index sections by # lines
 S STATS(2,0)=$T(+2^@ROUTINE) ; grab 2nd line
 ;
 N NODE0 S NODE0=ROUTINE_U_$$HTFM^XLFDT($H)_U_(NUM-1)
 S NODE0=NODE0_U_BYTES_U_CHECKSUM
 S STATS(0)=NODE0
 Q
 ;
 ;
