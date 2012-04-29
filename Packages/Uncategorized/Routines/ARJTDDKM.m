ARJTDDKM ;PUG/TOAD-FileMan Search All MUMPS Fields ;7/8/02  10:23
 ;;22.0;VA FileMan;;Mar 30, 1999;
 ;
 ; table of contents:
 ;    MUMPS - search all MUMPS-type fields
 ;    FEEDBACK - report finds & allow escape
 ;    TEST - test MUMPS with alternation in pattern match
 ;
 ; calls:
 ;    SEARCHNS^ARJTDDK3 = search N fields in 1 file or subfile
 ;
 ; input:
 ;   .CONTAINS(string)="" to search any line containing the string
 ;    FIND = optional. special search, e.g., "DSM"
 ;
 ; output:
 ;    .EXIT = 1 if search interrupted
 ;    report to current device
 ;
 ;
MUMPS(CONTAINS,FIND,EXIT) ; search all MUMPS-type fields
 ;
 ; calls:
 ;    FEEDBACK - report finds & allow escape
 ;    SEARCHNS^ARJTDDK3 - search N fields in 1 file or subfile
 ;
 ; MUMPS.1. BUILD MASTER LIST OF MUMPS-TYPE FIELDS
 ;
 W !!,"Building list of files and fields to search..."
 K ^TMP("DIDUF",$J) ; clear master list array
 S EXIT=0 ; not interrupted yet
 N SEARCHED S SEARCHED=0
 N FOUND S FOUND=0
 N FILE S FILE=0 F  S FILE=$O(^DD(FILE)) Q:'FILE  D  Q:EXIT
 . N FIELD S FIELD=0 F  S FIELD=$O(^DD(FILE,FIELD)) Q:'FIELD  D  Q:EXIT
 . . S SEARCHED=SEARCHED+1
 . . S NODE=$G(^DD(FILE,FIELD,0))
 . . Q:$E($P(NODE,U,2))'="K"
 . . S FOUND=FOUND+1
 . . S ^TMP("DIDUF",$J,FILE,FIELD)=""
 . . D FEEDBACK(FILE,FIELD,$P(NODE,U),.EXIT)
 N FENTITY S FENTITY="MUMPS field"
 D RESULTS^ARJTDDKU(EXIT,SEARCHED,FOUND,"Build","field","checked",FENTITY)
 I EXIT K ^TMP("DIDUF",$J)
 ;
 ; MUMPS.2. TRAVERSE LIST OF FILES & SUBFILES, RUNNING A SEARCH ON EACH
 ;
 ; This is not the most efficient way to do this, since I'm retraversing
 ; files to handle different subfiles within them, but it's an efficient
 ; use of my time, since it will get me my answers sooner.
 ;
 W !!,"Now searching the data in those MUMPS fields..."
 N ARJTLIST ; list of fields within each file or subfile/report
 S (SEARCHED,FOUND)=0 ; reset counters for the search
 N FILE S FILE=0 F  S FILE=$O(^TMP("DIDUF",$J,FILE)) Q:'FILE  D  Q:EXIT
 . K ARJTLIST M ARJTLIST(FILE)=^TMP("DIDUF",$J,FILE)
 . ; run report on each DD #
 . D SEARCHNS^ARJTDDK3("ARJTLIST",.CONTAINS,FIND,.SEARCHED,.FOUND,.EXIT)
 K ^TMP("DIDUF",$J)
 D RESULTS^ARJTDDKU(EXIT,SEARCHED,FOUND,"Search","value","checked")
 W !!!,"End of report. Have a nice day."
 Q
 ;
FEEDBACK(FILE,FIELD,FLDNAME,EXIT) ; subroutine: report finds & allow escape
 ;
 ; input:
 ;    FILE = file #
 ;    FIELD = field #
 ;    FLDNAME = name of field
 ; output: .EXIT = 1 if interrupted
 ; called by: MUMPS
 ;
 N FILENAME S FILENAME=$O(^DD(FILE,0,"NM",""))
 I FILENAME="" S FILENAME=$P($G(^DIC(FILE,0)),U) ; for Function file (.7)
 W !,FILE,"  ",?10,FILENAME,"  "
 W ?40,FIELD,"  ",?50,FLDNAME
 N READ R READ:0 S EXIT=READ=U
 QUIT  ; end of FEEDBACK
 ;
 ;
TEST ; test MUMPS with alternation in pattern match
 ;
 ; calls:
 ;     ^%ZOSF("PRIINQ") - return current process priority
 ;    MUMPS - search all MUMPS fields
 ;    ^%ZOSF("PRIORITY") - lower & raise priority
 ;
 W !!,"Testing MUMPS^ARJTDDKM with alternation in pattern match."
 W !!,"Lowering priority for duration of search.",!
 N ARJTPRI,Y X ^%ZOSF("PRIINQ") S ARJTPRI=Y
 N X S X=1 X ^%ZOSF("PRIORITY")
 N EXIT S EXIT=0
 D MUMPS("D","D")
 S X=ARJTPRI X ^%ZOSF("PRIORITY")
 W !!,"Priority restored."
 QUIT  ; end of TEST
 ;
