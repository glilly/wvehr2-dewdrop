ARJTDDK5 ;PUG/TOAD-FileMan Search "Free-Text" MUMPS Fields ;7/8/02  10:24
 ;;22.0;VA FileMan;;Mar 30, 1999;
 ;
 ; table of contents:
 ;    TEXT - find "free-text" MUMPS fields
 ;    LIKELY - function to guess if this is such a field
 ;    FEEDBACK - report finds & allow escape
 ;    TEST - test TEXT with alternation in pattern match
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
TEXT(CONTAINS,FIND,EXIT) ; subroutine: find "free-text" MUMPS fields
 ;
 ; calls:
 ;    $$LIKELY - guess whether each field is likely to be one
 ;    FEEDBACK - report finds & allow escape
 ;    SEARCHNS^ARJTDDK3 - search N fields in 1 file or subfile
 ;
 ; TEXT.1. BUILD LIST OF "FREE-TEXT" MUMPS FIELDS
 ;
 W !!,"Building list of ""free-text"" MUMPS fields..."
 K ^TMP("DIDUF",$J) ; clear master list array
 S EXIT=0 ; not interrupted yet
 N SEARCHED S SEARCHED=0
 N FOUND S FOUND=0
 N FILE S FILE=0 F  S FILE=$O(^DD(FILE)) Q:'FILE  D  Q:EXIT
 . N FIELD S FIELD=0 F  S FIELD=$O(^DD(FILE,FIELD)) Q:'FIELD  D  Q:EXIT
 . . S SEARCHED=SEARCHED+1
 . . N NODE S NODE=$G(^DD(FILE,FIELD,0))
 . . N POS S POS=$P(NODE,U,4)
 . . Q:$E($P(POS,";",2))'="E"  ; $extract, not $piece
 . . N FLDNAME S FLDNAME=$P(NODE,U)
 . . N TYPE S TYPE=$E($P(NODE,U,2))
 . . I TYPE="R" S TYPE=$E($P(NODE,U,2),2) ; R = required
 . . Q:TYPE'="F"&(TYPE'="M")  ; only want free text or "M"
 . . ; M is not a real field type, but several fields use it to mean MUMPS
 . . Q:'$$LIKELY(FLDNAME,FILE,FIELD)
 . . S FOUND=FOUND+1
 . . S ^TMP("DIDUF",$J,FILE,FIELD)=""
 . . D FEEDBACK(FILE,FIELD,FLDNAME,TYPE,.EXIT)
 N FENTITY S FENTITY="""free-text"" MUMPS field"
 D RESULTS^ARJTDDKU(EXIT,SEARCHED,FOUND,"Build","field","checked",FENTITY)
 I EXIT K ^TMP("DIDUF",$J)
 ;
 ; TEXT.2. TRAVERSE LIST OF FILES & SUBFILES, RUNNING A SEARCH ON EACH
 ;
 W !!,"Now searching the data in those ""free-text"" MUMPS fields..."
 S (SEARCHED,FOUND)=0 ; reset counters for the search
 N ARJTLIST ; list of fields within each file or subfile/report
 N FILE S FILE=0 F  S FILE=$O(^TMP("DIDUF",$J,FILE)) Q:'FILE  D  Q:EXIT
 . K ARJTLIST M ARJTLIST(FILE)=^TMP("DIDUF",$J,FILE)
 . ; search each DD #
 . D SEARCHNS^ARJTDDK3("ARJTLIST",.CONTAINS,FIND,.SEARCHED,.FOUND,.EXIT)
 K ^TMP("DIDUF",$J)
 D RESULTS^ARJTDDKU(EXIT,SEARCHED,FOUND,"Search","value","checked")
 W !!!,"End of report. Have a nice day."
 ;
 QUIT  ; end of TEXT
 ;
 ;
LIKELY(NAME,FILE,FIELD) ; function: flag likely fields
 ;
 ; input:
 ;    NAME - name of field
 ;    FILE - file DD #
 ;    FIELD - field DD #
 ; called by: EXTRACT
 ;
 I NAME["CODE" Q 1
 I NAME["ACTION" Q 1
 I NAME["LOGIC" Q 1
 I NAME["DIR(0)" Q 1
 I NAME["DIR(?)" Q 1
 I NAME["DIR(??)" Q 1
 I NAME["DR {DIE}" Q 1
 I $G(^DD(FILE,FIELD,3))["MUMPS" Q 1 ; 'Help'-Prompt attribute (3)
 I $G(^DD(FILE,FIELD,21,1,0))["MUMPS" Q 1 ; Description attribute (21)
 Q 0
 ;
 ;
FEEDBACK(FILE,FIELD,FLDNAME,TYPE,EXIT) ; subroutine: report finds & allow escape
 ;
 ; input:
 ;    FILE = file #
 ;    FIELD = field #
 ;    FLDNAME = name of field
 ;    TYPE = field's data type
 ; output: .EXIT = 1 if interrupted
 ; called by: EXTRACT
 ;
 N FILENAME S FILENAME=$O(^DD(FILE,0,"NM",""))
 I FILENAME="" S FILENAME=$P($G(^DIC(FILE,0)),U) ; for Function file (.7)
 W !,FILE,"  ",?10,FILENAME,"  "
 W ?40,FIELD,"  ",?50,FLDNAME,?79,TYPE
 N READ R READ:0 S EXIT=READ=U
 QUIT  ; end of FEEDBACK
 ;
 ;
TEST ; test TEXT with DO command
 ;
 ; calls:
 ;     ^%ZOSF("PRIINQ") - return current process priority
 ;    TEXT - search all "free-text" MUMPS fields
 ;    ^%ZOSF("PRIORITY") - lower & raise priority
 ;
 W !!,"Testing TEXT^ARJTDDK5 with DO command."
 W !!,"Lowering priority for duration of search.",!
 N ARJTPRI,Y X ^%ZOSF("PRIINQ") S ARJTPRI=Y
 N X S X=1 X ^%ZOSF("PRIORITY")
 D TEXT("D","D")
 S X=ARJTPRI X ^%ZOSF("PRIORITY")
 W !!,"Priority restored."
 QUIT  ; end of TEST
 ;
