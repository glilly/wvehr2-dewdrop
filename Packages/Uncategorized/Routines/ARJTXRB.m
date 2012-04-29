ARJTXRB ;PUG/TOAD - Routine Buffer Tools ;2/27/02  13:58
 ;;8.0;KERNEL;;Jul 10, 1995;**LOCAL RTN: PUG/TOAD**
 ;
LOAD(ROUTINE,ROOT) ; Load a routine into a global
 ; ROUTINE = name of the routine
 ; ROOT = name of the global root, closed array format (e.g., "^TMP($J)")
 ;
 K @ROOT
 N LINE,LABEL,BODY
 N BYTES S BYTES=0 ; size of routine
 N CHAR S CHAR=0 ; absolute count of char position, incl. eol as $C(13)
 N LINECHAR ; relative count of char position within each line
 N CHECKSUM S CHECKSUM=0 ; absolute checksum of routine, incl. comments
 N LABEL,SECTION,FROM S SECTION="[anonymous]",FROM=1
 ;
 N NUM F NUM=1:1 S LINE=$T(+NUM^@ROUTINE) Q:LINE=""  D
 . I $E(LINE)'=" " D  ; deal with line label
 . . S LABEL=$P($P(LINE," "),"(") ; get line label if any
 . . Q:LABEL=""  ; this should never happen, but who knows
 . . S @ROOT@("B",LABEL,NUM)="" ; index of labels
 . . I NUM-FROM D  ; for all but anonymous, unless it has lines
 . . . S @ROOT@("ALINE",FROM,NUM,SECTION)="" ; index lines by sec
 . . . S @ROOT@("ASIZE",SECTION,NUM-FROM)="" ; index sections by # lines
 . . S SECTION=LABEL,FROM=NUM ; start next section
 . E  S LABEL="",BODY=LINE,$E(BODY)=""
 . S @ROOT@(NUM,0)=LINE
 . S BYTES=BYTES+$L(LINE)+2
 . F LINECHAR=1:1:$L(LINE) D  ; add line to cumulative absolute checksum
 . . S CHAR=CHAR+1 ; advance absolute counter
 . . S CHECKSUM=CHECKSUM+($A(LINE,LINECHAR)*CHAR)
 . S CHAR=CHAR+1,CHECKSUM=CHECKSUM+(13*CHAR) ; incl. end of line
 ;
 N NODE0 S NODE0=ROUTINE_U_$$HTFM^XLFDT($H)_U_(NUM-1)
 S NODE0=NODE0_U_BYTES_U_CHECKSUM
 S @ROOT@(0)=NODE0
 Q
 ;
 ;
RCMP1(ROU1,ROU2) ; compare sections in two routines
 ;
 K ^TMP("ARJTXR",$J) ; clear routine buffers
 ;
 N GLO1 S GLO1=$NA(^TMP("ARJTXR",$J,ROU1))
 D LOAD(ROU1,GLO1)
 N STATS1
 D SUMM1(GLO1,.STATS1) ; summarize 1st routine
 ;
 N GLO2 S GLO2=$NA(^TMP("ARJTXR",$J,ROU2))
 D LOAD(ROU2,GLO2)
 N STATS2
 D SUMM1(GLO2,.STATS2) ; summarize 2nd routine
 ;
 QUIT  ;
 ;
SUMM1(ROOT,STATS) ; summarize the routine loaded into @ROOT
 ;
 N NODE0 S NODE0=$G(@ROOT@(0))
 K STATS
 S STATS("NAME")=$P(NODE0,U) W !!,STATS("NAME")
 S STATS("LINES")=$P(NODE0,U,3) W ?13,STATS("LINES")," lines"
 S STATS("BYTES")=$P(NODE0,U,4) W ?27,STATS("BYTES")," bytes"
 S STATS("CSUM")=$P(NODE0,U,5) W ?42,"Checksum = ",STATS("CSUM")
 ;
 N SECTION
 N ALINE S ALINE=$NA(@ROOT@("ALINE"))
 N SUBS S SUBS=$QL(ALINE)
 N NODE S NODE=ALINE
 F  S NODE=$Q(@NODE) Q:NODE=""  Q:$NA(@NODE,SUBS)'=ALINE  D
 . S SECTION=$QS(NODE,SUBS+3)
 . W !?13,SECTION,?26,$O(@ROOT@("ASIZE",SECTION,0))," lines"
 ;
 QUIT
 ;
 ;
RCMP2(ROU1,ROU2) ; compare sections in two routines
 ;
 K ^TMP("ARJTXR",$J) ; clear routine buffers
 ;
 N GLO1 S GLO1=$NA(^TMP("ARJTXR",$J,ROU1))
 D LOAD(ROU1,GLO1)
 N STATS1
 D SUMM2(GLO1,.STATS1) ; summarize 1st routine
 ;
 N GLO2 S GLO2=$NA(^TMP("ARJTXR",$J,ROU2))
 D LOAD(ROU2,GLO2)
 N STATS2
 D SUMM2(GLO2,.STATS2) ; summarize 2nd routine
 ;
 W !!,"Routine comparison of ",ROU1," and ",ROU2,"."
 W !!?13,ROU1,?40,ROU2
 W !,"Lines",?13,STATS1("LINES"),?40,STATS2("LINES")
 W !,"Bytes",?13,STATS1("BYTES"),?40,STATS2("BYTES")
 W !,"Checksum",?13,STATS1("CSUM"),?40,STATS2("CSUM")
 W !,"Sections:"
 N SECTION
 F SECTION=1:1 Q:'$D(STATS1(SECTION))&'$D(STATS2(SECTION))  D
 . W !?5,SECTION
 . I $D(STATS1(SECTION)) D
 . . W ?13,$P(STATS1(SECTION),U)
 . . W ?26,$P(STATS1(SECTION),U,2)," lines"
 . I $D(STATS2(SECTION)) D
 . . W ?40,$P(STATS2(SECTION),U)
 . . W ?53,$P(STATS2(SECTION),U,2)," lines"
 ;
 QUIT  ;
 ;
 ;
SUMM2(ROOT,STATS) ; summarize the routine loaded into @ROOT
 ;
 N NODE0 S NODE0=$G(@ROOT@(0))
 K STATS
 S STATS("NAME")=$P(NODE0,U)
 S STATS("LINES")=$P(NODE0,U,3)
 S STATS("BYTES")=$P(NODE0,U,4)
 S STATS("CSUM")=$P(NODE0,U,5)
 ;
 N SECTION
 N COUNT
 N ALINE S ALINE=$NA(@ROOT@("ALINE"))
 N SUBS S SUBS=$QL(ALINE)
 N NODE S NODE=ALINE
 F COUNT=1:1 S NODE=$Q(@NODE) Q:NODE=""  Q:$NA(@NODE,SUBS)'=ALINE  D
 . S SECTION=$QS(NODE,SUBS+3)
 . S STATS(COUNT)=SECTION_U_$O(@ROOT@("ASIZE",SECTION,0))
 ;
 QUIT
 ;
 ;
