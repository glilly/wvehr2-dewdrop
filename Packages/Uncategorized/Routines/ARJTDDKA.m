ARJTDDKA ;WV/TOAD - FileMan Search All Routines ;5/24/2004  19:39
 ;;3.0T1;OPENVISTA;;JUN 20, 2004
 ;
 ; not yet tested on GT.M on VMS
 ; not tested on DSM since the overhaul to add GT.M support
 ;
 ; This routine is part of the VistA Software Search program,
 ; designed to make it easy to search through all VistA
 ; software (which can be a problem both because some VistA
 ; software is in globals and because some searches are
 ; syntactic rather than simple contains operations). This
 ; particular routine is a companion to ARJTDDKR, which searches
 ; selected routines; this one searches all routines. Traversing
 ; all routines pre-1995-Standard-MUMPS is vendor-dependent, and
 ; not all MUMPS vendors have implemented ^$ROUTINE to make it
 ; portable. In particular, GT.M's routine directory handling
 ; makes this code a touch tricky, thus this routine. The main
 ; useful entry point is ALL^ARJTDDKA.
 ;
 ; need to write $$NEXTROU
 ; need to test results
 ; need to add to ARJTDDK* check for ^[]global
 ; call David and email verified code to him for his report
 ; then upload new Seattle meeting web page
 ;
 ; Change History:
 ;    2004 05 24-25  created based on ALL^ARJTDDKR & GT.M %RSEL
 ;                   program to make ALL not DSM-specific.
 ;
 ; Table of Contents:
 ;    ALL = public subroutine to search all routines
 ;    ROUDIR = public sub for GT.M to build array of paths
 ;    PATH = private sub for ROUDIR to check & format 1 path
 ;    $$NEXTROU = private function for ROUDIR to loop thru routines
 ;
 ;
ALL(CONTAINS,FIND,EXIT) ; public subroutine: search all routines
 ;
 ; input:
 ;   .CONTAINS - array of simple contains searches to do
 ;    FIND - special code (like DSM) for more complex searches
 ;    DSM-specific ^ () global (name = space) - routine directory
 ;    GT.M-specific: $ZROUTINES, host OS directories
 ; output:
 ;   .EXIT - whether user has asked searches to end ("^")
 ;    ^XTMP("DSMROUTINES") -- see ARJJTDDK routine for docs
 ;    current device for simple feedback
 ; called by ALL^ARJTDDK -- master search option
 ; calls:
 ;    $$FMADD^XLFDT - FileMan function to add days to a date
 ;    $$DT^XLFDT - today's date in FM format
 ;    ROUDIR - for GT.M, load array of source code directories
 ;    $$NEXTROU - for GT.M, return next routine name
 ;    FEEDBACK^ARJTDDKR - give routine search feedback
 ;    SEARCH^ARJTDDKR - search each routine
 ;    RESULTS^ARJTDDKU - report results of search
 ;
 W !!,"Searching all routines"
 K ^XTMP("DSMROUTINES")
 S ^XTMP("DSMROUTINES",0)=$$FMADD^XLFDT($$DT^XLFDT(),90)_U_$$DT^XLFDT()
 I $ZV["GT.M" N DIRECTRY D ROUDIR(.DIRECTRY) ; load rtn direc array
 ;
 S EXIT=0 ; not interrupted so far
 N PRE S PRE="" ; trace shifting prefixes
 N COUNT ; number of routines searched
 N FOUND S FOUND=0 ; number of matching routines found
 N ROU S ROU="" ; name of each routine
 F COUNT=0:1 D  Q:ROU=""!EXIT
 . I $ZV["GT.M" S ROU=$$NEXTROU(.DIRECTRY) ; GT.M stores in host OS
 . I $ZV["DSM" S ROU=$O(^ (ROU)) ; DSM stores rtn direc in ^[space]
 . Q:ROU=""
 . I COUNT,'(COUNT#100) D FEEDBACK^ARJTDDKR(COUNT,ROU,.PRE,.EXIT) Q:EXIT
 . D SEARCH^ARJTDDKR($P(ROU,"."),.CONTAINS,FIND,.FOUND)
 D RESULTS^ARJTDDKU(EXIT,COUNT,FOUND,"Search","routine")
 Q:EXIT
 ; D COMPILE^ARJTDDKS(1)
 ;
 QUIT  ; end of ALL
 ;
 ;
ROUDIR(DIRS) ; public subroutine for GT.M: build array of routine directories
 ;
 ; another time, document syntax and examples of $ZRO
 ;
 ; Input: $ZROUTINES = GT.M special variable IDing source code paths
 ; Output: .DIRS(#)=directory, source code directories
 ; Context: for GT.M only. Called by ALL, but public as needed. Calls PATH
 ;
 ;
 ; R1. set up variables & ensure $ZRO is not empty
 ;
 K DIRS ; clear output
 Q:'$L($ZRO)  ; done if no routine directory
 ;
 N PIECE ; each piece of $ZRO
 N PIECECNT ; count pieces of $ZRO traversed
 N DIRCNT S DIRCNT=0 ; count valid source code directories found in $ZRO
 ;
 N DELIM ; $ZRO piece delimiter
 I $ZV["VMS" S DELIM="," ; GT.M on VMS delimits $ZROUTINES with commas
 E  S DELIM=" " ; GT.M on Unix delimits it with spaces
 ;
 N END
 I $ZV["VMS" S END="" ; VMS directories do not end with "/"
 E  S END="/" ; Unix directories do end with "/"
 ;
 ;
 ; R2. loop through $ZRO's pieces
 ;
 F PIECECNT=1:1:$L($ZRO,DELIM) D  ; traverse all the pieces of $ZROUTINES
 . S PIECE=$P($ZRO,DELIM,PIECECNT) ; get next piece
 . ;
 . ;
 . ; R3. handle Unix directories
 . ;
 . I $ZV["Linux",PIECE'["(" D PATH Q  ; no source info - it does both
 . ;
 . ;
 . ; R4. handle VMS directories
 . ;
 . I $ZV["VMS",PIECE[".olb" Q  ; it's an object library and we don't poke in them
 . I $ZV["VMS",PIECE'["/" D PATH Q  ; no source info - it does both
 . ;
 . I $ZV["VMS" S PIECE=$P(PIECE,"=",2) ; grab 1st source directory
 . I $ZV["VMS",$E(PIECE)'="(" D PATH Q  ; /SRC or /NOSRC - we're done
 . ;
 . ;
 . ; R5. handle VMS & Linux: parentheses
 . ;
 . S PIECE=$P(PIECE,"(",2) ; strip the opening paren
 . I PIECE[")" S PIECE=$P(PIECE,")") D PATH Q  ; if only one path in parens
 . ;
 . ;
 . ; R6. handle VMS & Linux: list of paths in parens
 . ;
 . D PATH ; check and format first path name in list
 . N LISTEND S LISTEND=0 ; have we found the close paren yet?
 . F PIECECNT=PIECECNT+1:1 D  Q:LISTEND  ; traverse the rest of the paren list
 . . S PIECE=$P($ZRO,DELIM,PIECECNT) ; get the next path name in the parens
 . . Q:'$L(PIECE)  ; skip empties
 . . I PIECE[")" S LISTEND=1,PIECE=$P(PIECE,")") ; handle end of list
 . . D PATH ; check and format path from list
 ;
 QUIT  ; end of ROUDIR
 ;
 ;
PATH ; private subroutine: check and format path name
 ;
 ; Input:
 ;    PIECE = path name to check and format
 ;    END = proper end of path ("/" for Unix)
 ;
 ; Output:
 ;    DIRCNT = count of source code directories found
 ;    DIRS = array by count of source code directories
 ;
 ; Context:
 ;    Called only by ROUDIR. Calls nothing.
 ;
 I $L(PIECE) S PIECE=$P($ZPARSE(PIECE_END,"","*"),"*") ; if path not empty, format it
 I $L(PIECE) S DIRCNT=DIRCNT+1,DIRS(DIRCNT)=PIECE ; if valid, record it
 ;
 QUIT  ; end of PATH
 ;
 ;
NEXTROU(ROUDIRS) ; private function: for GT.M
 ;
 ; Consider eventually describing $ZSEARCH in here.
 ;
 ; This is the GT.M equivalent of DSM's $O(^ (routine)); it traverses GT.M's routine
 ; directories in the order they are prioritized in $ZROUTINES and returns each of
 ; the routine names found there, one routine per call. It uses the unusual GT.M
 ; intrinsic function $ZSEARCH which remembers its own context, which is why the
 ; previous routine name need not be passed in to get the next one. We are assuming
 ; $ZSEARCH is not already mid-search beneath us in the stack, but we use context
 ; number 1 just in case, leaving 0 in case someone else has one already running.
 ; See the GT.M Programmer Manual for documentation on how this unusual function
 ; works. We also use the GT.M $ZPARSE function to extract the routine name from the
 ; path and extension, since the former varies by OS.
 ;
 ; Input:
 ;    ROUDIRS(#)=source code path
 ;    ROUDIRS(0)=current path #
 ; Output:
 ;    ROUDIRS(0)=current path # (when changed--this slowly loops thru list)
 ; Context:
 ;    private, GT.M-specific, called only by ALL above. Calls nothing.
 ;
 I '$D(ROUDIRS(0)) S ROUDIRS(0)=1 ; if 1st call, we start with 1st path
 N ROUFILE S ROUFILE=$ZSEARCH(ROUDIRS(ROUDIRS(0))_"*.m",1) ; get next routine file
 I ROUFILE="" D  ; if we've run out of routine files in current directory
 . S ROUDIRS(0)=ROUDIRS(0)+1 ; advance to next source code directory
 . I '$D(ROUDIRS(ROUDIRS(0))) S ROUTINE="" Q  ; if we've run out of paths we're done
 . S ROUFILE=$$NEXTROU(.ROUDIRS) ; recursively get next routine file
 . I ROUFILE="" S ROUTINE="" Q  ; if rest of paths are empty we're done
 ;
 I ROUFILE'="" D  ; if we did get another routine source code file...
 . S ROUTINE=$ZPARSE(ROUFILE,"NAME") ; extract routine name from path & extension
 . I $E(ROUTINE)="_" S $E(ROUTINE)="%" ; GT.M translates % to _ for file naming
 ;
 QUIT ROUTINE ; end of NEXTROU
 ;
 ;
