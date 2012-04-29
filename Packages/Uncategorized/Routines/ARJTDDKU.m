ARJTDDKU ;PUG/TOAD-FileMan Search Utilities ;7/10/02  16:14
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;
 ; this routine was used for experimenting with search criteria
 ;
 ; table of contents:
 ;    EXTRACT - find non-MUMPS $EXTRACT fields
 ;    LIKELY - flag likely fields
 ;    RESULTS - report results of report
 ;    RTEST - test RSE^ARJTDDKR with alternation in pattern match
 ;    RDSM - test RSE^ARJTDDKR with DSM-specific code
 ;
 ; calls: nothing
 ; called by: nothing
 ;
EXTRACT ; subroutine: find "free text" MUMPS fields
 ;
 ; calls: LIKELY - flag likely fields
 ;
 W !!,"Building list of non-MUMPS $EXTRACT fields..."
 K ^TMP("DIDUF",$J) ; clear master list array
 N SEARCHED S SEARCHED=0
 N FOUND S FOUND=0
 N FILE S FILE=0 F  S FILE=$O(^DD(FILE)) Q:'FILE  D
 . N FIELD S FIELD=0 F  S FIELD=$O(^DD(FILE,FIELD)) Q:'FIELD  D
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
 . . W !,FILE,"  ",?10,$O(^DD(FILE,0,"NM","")),"  "
 . . W ?40,FIELD,"  ",?50,FLDNAME,?79,TYPE
 K ^TMP("DIDUF",$J) ; clear master list array
 W !!,SEARCHED," non-MUMPS fields examined."
 W !,FOUND," of them may contain MUMPS code."
 QUIT  ; end of EXTRACT
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
RESULTS(EXIT,COUNT,FOUND,STEP,SENTITY,SVERB,FENTITY) ;
 ;
 ; input:
 ;    EXIT = 1 if search was interrupted
 ;    COUNT = # of routines searched
 ;    FOUND = # of instances found
 ;    STEP = verb-name of step ended (e.g., "Search")
 ;    SENTITY = kind of entity being searched/checked (e.g., "routine")
 ;    SVERB = action being performed (e.g., "searched")
 ;    FENTITY = kind of entity being found (e.g., "instance")
 ; called by: ^ARJTDDK*
 ;
 S SVERB=$G(SVERB,"searched")
 S FENTITY=$G(FENTITY,"instance")
 W !!,STEP," ",$S(EXIT:"interrupted",1:"completed"),"."
 W !,$FN(COUNT,",")," ",SENTITY,$E("s",COUNT'=1)," ",SVERB,"."
 W !,$FN(FOUND,",")," ",FENTITY,$E("s",FOUND'=1)," found."
 QUIT  ; end of RESULTS
 ;
 ;
RTEST ; test RSE^ARJTDDKR with alternation in pattern match
 ;
 ; calls:
 ;     ^%ZOSF("PRIINQ") - return current process priority
 ;    RSE - search selected routines
 ;    ^%ZOSF("PRIORITY") - lower & raise priority
 ;
 W !!,"Testing RSE^ARJTDDKR with alternation in pattern match."
 W !!,"Lowering priority for duration of search.",!
 N ARJTPRI,Y X ^%ZOSF("PRIINQ") S ARJTPRI=Y
 N X S X=1 X ^%ZOSF("PRIORITY")
 K ^XTMP("DSMROUTINES")
 D RSE^ARJTDDKR("?","?(")
 S X=ARJTPRI X ^%ZOSF("PRIORITY")
 W !!,"Priority restored."
 QUIT  ; end of TEST
 ;
 ;
RDSM ; test RSE^ARJTDDKR with DSM-specific code
 ;
 ; calls:
 ;     ^%ZOSF("PRIINQ") - return current process priority
 ;    RSE - search selected routines
 ;    ^%ZOSF("PRIORITY") - lower & raise priority
 ;
 W !!,"Testing RSE^ARJTDDKR with DSM-specific code."
 I '$D(TOAD) N ARJTPRI D
 . W !!,"Lowering priority for duration of search.",!
 . N Y X ^%ZOSF("PRIINQ") S ARJTPRI=Y
 . N X S X=1 X ^%ZOSF("PRIORITY")
 K ^XTMP("DSMROUTINES")
 N CONTAINS
 S CONTAINS("Z")=""
 S CONTAINS("&")=""
 S CONTAINS("^%")=""
 S CONTAINS("(%")=""
 S CONTAINS("U ")=""
 S CONTAINS("U:")=""
 S CONTAINS("O ")=""
 S CONTAINS("O:")=""
 S CONTAINS("C ")=""
 S CONTAINS("C:")=""
 D RSE^ARJTDDKR(.CONTAINS,"DSM")
 I '$D(TOAD) D
 . S X=ARJTPRI X ^%ZOSF("PRIORITY")
 . W !!,"Priority restored."
 QUIT  ; end of DSM
 ;
