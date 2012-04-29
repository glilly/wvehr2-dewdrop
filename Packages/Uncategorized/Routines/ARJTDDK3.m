ARJTDDK3 ;PUG/TOAD-FileMan Search All MUMPS Fields ;7/8/02  10:43
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;
 ; table of contents:
 ;    SEARCHNS - search N fields in every entry in 1 file or subfile
 ;    WALK - recursively traverse all entries in a file or subfile
 ;    TITLE - convert a string to Title Case
 ;    CONTAINS - function: does code contain what we're looking for
 ;
 ; calls:
 ;    CHECK^ARJTDIM = to search each value (MUMPS code)
 ;
 ; input:
 ;   .CONTAINS(string)="" to search any line containing the string
 ;    FIND = optional. special search, e.g., "DSM"
 ;
 ; output: report to current device
 ;    .EXIT = 1 if search interrupted
 ;    report to current device
 ;
 ;
SEARCHNS(LIST,CONTAINS,FIND,COUNT,MATCHES,EXIT) ; search N fields in 1 file or subfile
 ;
 ; input: .LIST(file #,field #)="" --> fields to search
 ; in/output:
 ;    .COUNT = # of field values checked
 ;    .MATCHES = # instances found
 ; calls:
 ;    $$TITLE - convert test to Title Case
 ;    WALK - recursively traverse all entries in file/subfile
 ; called by: MUMPS^ARJTDDKM, TEXT^ARJTDDK5
 ;
 ; table of contents:
 ;    1. Build File Code
 ;    2. Build Field Code
 ;    3. Search (Sub)File
 ;
 ;
 ; 1. BUILD FILE CODE
 ;
 ; 1.1. Trace DD's ancestry
 N DD S DD=$O(@LIST@(0)) ; ID file/subfile to search
 Q:'DD  ; we need a starting DD #
 Q:'$D(DD)  ; it needs to be a real file or subfile
 N LEVEL S LEVEL=1 ; default to top-level file
 N PARENT ; parent of each DD entry ("" for top-level files)
 ;
 F  D  Q:'PARENT  ; trace back through ancestry
 . ;
 . ; get subscript info for lower level after 1st loop
 . I LEVEL>1 D
 . . N FIELD S FIELD=+$O(^DD(DD,"B",DD(LEVEL-1,"NM"),0))
 . . S DD(LEVEL-1,"FD")=FIELD
 . . S DD(LEVEL-1,"SUB")=+$P($G(^DD(DD,FIELD,0)),U,4)
 . ;
 . ; get basic info for current level
 . S DD(LEVEL)=DD ; add current DD level to ancestry
 . S DD(LEVEL,"NM")=$O(^DD(DD,0,"NM","")) ; get DD level's name
 . I DD(LEVEL,"NM")="" S DD(LEVEL,"NM")=$P($G(^DIC(LEVEL,0)),U) ; for .7
 . S PARENT=$G(^DD(DD,0,"UP")) Q:'PARENT  ; does this DD have a parent
 . S LEVEL=LEVEL+1 ; parent adds a level of depth to ancestry
 . ;
 . S DD=PARENT ; next pass let's investigate the parent
 ;
 ; 1.2. Build top-level code
 ;
 N ROOT S ROOT=$G(^DIC(DD,0,"GL")) Q:ROOT=""  ; file root
 N IEN S ROOT(1)=ROOT_"IEN(1)" ; top-level IEN
 N ADVANCE
 S ADVANCE(1)="S IEN(1)=$O("_ROOT(1)_"))" ; build traverse code
 N NAME S NAME=$$TITLE(DD(LEVEL,"NM"))_" ("_DD_")"
 W !,"Now searching "
 I LEVEL=1 D
 . W NAME," file (",$P($G(@(ROOT_"0)")),U,4)," entries)..."
 ;
 ; 1.3. Append subfile code
 ;
 N DEPTH S DEPTH=1 ; already handled top level above
 F DD=LEVEL-1:-1:1 D  ; handle remaining levels
 . S NAME=NAME_"/"_$$TITLE(DD(DD,"NM"))_" ("_DD(DD)_")" ; extend name
 . S DEPTH=DEPTH+1 ; one level deeper
 . S ROOT(DEPTH)=ROOT(DEPTH-1)_","_DD(DD,"SUB")_",IEN("_DEPTH_")"
 . S ADVANCE(DEPTH)="S IEN("_DEPTH_")=$O("_ROOT(DEPTH)_"))"
 I DEPTH>1 W NAME," subfile..."
 ;
 ;
 ; 2. BUILD FIELD CODE
 ;
 N FLDCNT S FLDCNT=0 ; how many fields will we be searching?
 N NODE ; list of nodes containing the fields
 N FIELD ; list of fields to search
 S FIELD=0 F  S FIELD=$O(@LIST@(DD(1),FIELD)) Q:'FIELD  D
 . N FIELDEF S FIELDEF=$G(^DD(DD(1),FIELD,0)) Q:FIELDEF=""  ; field DD
 . S NAME(FIELD)=$$TITLE($P(FIELDEF,U)) ; save off name of field
 . Q:$P(FIELDEF,U,2)  ; subfiles have subfile# in 2nd piece
 . S FLDCNT=FLDCNT+1 ; we'll definitely search this field
 . N HOME S HOME=$P(FIELDEF,U,4) ; node;place of field
 . S NODE=ROOT(DEPTH)_","_+HOME_")" ; build root to fetch node
 . S NODE="$G("_NODE_")" ; protect against undefined errors
 . I '$D(NODE(+HOME)) D  ; if we haven't already handled this node
 . . S NODE(+HOME,"GET")="S NODE("_+HOME_")="_NODE ; build get code
 . ;
 . N GET
 . N PLACE S PLACE=$P(HOME,";",2) ; place to fetch
 . I PLACE D  ; $Piece fields have a numeric place
 . . S GET="S VALUE=$P(NODE("_+HOME_"),U,"_PLACE_")" ; build get code
 . E  D  ; $Extract fields have E#,#
 . . N FIRST S FIRST=+$P($P(PLACE,";"),"E",2) ; first position
 . . N LAST S LAST=$P(PLACE,",",2) ; last position
 . . S GET="S VALUE=$E(NODE("_+HOME_"),"_FIRST_","_LAST_")" ; get code
 . S FIELD(FIELD,"GET")=GET
 Q:'FLDCNT
 ;
 ;
 ; 3. SEARCH (SUB)FILE
 ;
 N IENS S IENS(0)="" ; array for "incrementing" IEN String
 S COUNT=+$G(COUNT) ; count of entries searched
 S MATCHES=+$G(MATCHES) ; count of entries searched
 D WALK(1) ; traverse file/subfile starting at top level
 ;
 QUIT  ; end of SEARCHNS
 ;
 ;
WALK(LEVEL) ; Recursively Traverse All Entries in a File or Subfile
 ;
 ; Each call traverses one level.
 ; When the leaf level is reached, each entry is searched.
 ; Called only by SEARCHNS.
 ;
 K IENS(LEVEL) ; clear the IENS for this level
 S IEN(LEVEL)=0 F  X ADVANCE(LEVEL) Q:'IEN(LEVEL)  D  Q:EXIT  ; traverse
 . S IENS(LEVEL)=IENS(LEVEL-1)_"/"_IEN(LEVEL) ; set up IENS for this record
 . I LEVEL'=DEPTH D WALK(LEVEL+1) Q  ; traverse children of internals
 . ;
 . ; otherwise, we're at a leaf level, so...
 . ; load needed nodes into locals
 . S NODE="" F  S NODE=$O(NODE(NODE)) Q:NODE=""  X NODE(NODE,"GET")
 . ;
 . S FIELD=0 F  S FIELD=$O(FIELD(FIELD)) Q:'FIELD  D  Q:EXIT
 . . S COUNT=COUNT+1
 . . I '(COUNT#1000) W "." N READ R READ:0 S EXIT=READ=U Q:EXIT
 . . X FIELD(FIELD,"GET") ; fetch field value for each entry
 . . Q:'$$CONTAINS(VALUE,.CONTAINS)  ; skip those that clearly don't match
 . . ;
 . . N ZZDCOM ; clear array of commands & special elements found
 . . D CHECK^ARJTDIM(VALUE,FIND,.ZZDCOM) ; parse line
 . . Q:'ZZDCOM  ; skip lines that don't match
 . . S MATCHES=MATCHES+1 ; this is a match
 . . ; S COUNT=0 ; reset count to postpone printing a dot
 . . ;
 . . ; display match
 . . ; match #, file/subfile path, field
 . . W !!,MATCHES_". "_NAME_"/"_NAME(FIELD)_" ("_FIELD_"):   "
 . . ; entry
 . . S $E(IENS(LEVEL))="" ; strip leading "/"
 . . N ENTRY S ENTRY="Entry # "_IENS(LEVEL)
 . . I 80-$X<$L(ENTRY) W ! ; keep IEN string to right
 . . W $J(ENTRY,80-$X) ; IEN string of record
 . . ; field value
 . . F  Q:VALUE=""  W !?10,$E(VALUE,1,70) S $E(VALUE,1,70)="" ; value
 . . N READ R READ:0 S EXIT=READ=U
 ;
 Q
 ;
TITLE(%STRING) ; Convert a string to Title Case
 ;
 ; create return value (which will be Title Case) from STRING
 N %UPPER S %UPPER="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 N %LOWER S %LOWER="abcdefghijklmnopqrstuvwxyz"
 N %TITLE S %TITLE=$G(%STRING)
 ;
 ; create parse string in which most punctuation are spaces
 N %REPLACE S %REPLACE="!""#$%&'()*+,-./:;<=>?@[\]^_`{|}~"
 N %WITH S %WITH="                                "
 N %PARSE S %PARSE=$TR(%STRING,%REPLACE,%WITH)
 ;
 ; traverse " "-pieces of parse string, clearing as we go
 N %PIECE ; each " "-piece
 N %LENGTH ; length of each " "-piece
 N %FROM,%TO S %FROM=1 ; character positions of each " "-piece
 N %COUNT F %COUNT=1:1:$L(%PARSE," ") D
 . S %PIECE=$P(%PARSE," ") ; examine the leading " "-piece
 . S %LENGTH=$L(%PIECE) ; measure it
 . S %TO=%FROM+%LENGTH-1 ; map its position back to %TITLE
 . ;
 . ; handle contractions specially--don't capitalize
 . I %LENGTH=1,$E(%TITLE,%FROM-1)="'",$E(%TITLE,%FROM-2)?1A D
 . . S %PIECE=$TR(%PIECE,%UPPER,%LOWER)
 . E  D  ; otherwise, follow the normal rules
 . . S $E(%PIECE)=$TR($E(%PIECE),%LOWER,%UPPER) ; capitalize 1st char
 . . S $E(%PIECE,2,$L(%PIECE))=$TR($E(%PIECE,2,$L(%PIECE)),%UPPER,%LOWER)
 . S $E(%TITLE,%FROM,%TO)=%PIECE ; overlay converted piece on %TITLE
 . ;
 . S $E(%PARSE,1,%LENGTH+1)="" ; clear the leading " "-piece
 . S %FROM=%TO+2 ; compute location of 1st character of next " "-piece
 ;
 Q %TITLE ; return the Title-Cased string
 ;
 ;
CONTAINS(CODE,CONTAINS) ; function: does code contain what we're looking for
 N DOES I $D(CONTAINS)#2 S DOES=CODE[CONTAINS Q DOES
 I $D(CONTAINS)>9 D  Q DOES
 . N SUB S SUB=""
 . F  S SUB=$O(CONTAINS(SUB)) Q:SUB=""  S DOES=CODE[SUB Q:DOES
 Q 0
 ;
