ARJTDDK2 ;PUG/TOAD-FileMan Search N Fields in 1 File ;7/8/02  10:43
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;
 ; Table of Contents:
 ;    SEARCHN = search N fields in every entry in 1 file
 ;
 ; Calls:
 ;    CHECK^ARJTDIM = to search each value (MUMPS code)
 ;
SEARCHN(LIST,CONTAINS,FIND) ; search N fields in every entry in 1 file
 ;
 ; S.1. Build Get Code
 ;
 N FILE S FILE=$O(@LIST@(0)) ; ID file to search
 N ROOT S ROOT=$G(^DIC(FILE,0,"GL")) Q:ROOT=""  ; file root
 W !,"Now searching the ",$O(^DD(FILE,0,"NM",""))," file "
 W "(",$P(@(ROOT_"0)"),U,4)," entries)..."
 ;
 N IEN S ROOT=ROOT_"IEN(1)" ; top-level IEN
 N ADVANCE S ADVANCE(1)="S IEN(1)=$O("_ROOT_"))" ; build traverse code
 ;
 N COUNT S COUNT=0 ; how many fields will we be searching?
 N NODE ; list of nodes containing the fields
 N FIELD ; list of fields to search
 S FIELD=0 F  S FIELD=$O(@LIST@(FILE,FIELD)) Q:'FIELD  D
 . N FIELDEF S FIELDEF=$G(^DD(FILE,FIELD,0)) Q:FIELDEF=""  ; field DD
 . Q:$P(FIELDEF,U,2)  ; subfiles have subfile# in 2nd piece
 . S COUNT=COUNT+1 ; we'll definitely search this field
 . N HOME S HOME=$P(FIELDEF,U,4) ; node;place of field
 . S NODE=ROOT_","_+HOME_")" ; build root to fetch node
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
 Q:'COUNT
 ;
 ;
 ; S.2. Traverse File
 ;
 N COUNT S COUNT=0 ; count of entries searched
 N VALUE ; the value of the field for each entry
 S IEN(1)=0 F  X ADVANCE(1) Q:'IEN(1)  D  ; traverse file entries
 . ;
 . ; load needed nodes into locals
 . S NODE="" F  S NODE=$O(NODE(NODE)) Q:NODE=""  X NODE(NODE,"GET")
 . ;
 . S FIELD=0 F  S FIELD=$O(FIELD(FIELD)) Q:'FIELD  D
 . . S COUNT=COUNT+1 I '(COUNT#1000) W "."
 . . X FIELD(FIELD,"GET") ; fetch field value for each entry
 . . Q:VALUE'[CONTAINS  ; skip those that clearly don't match
 . . ;
 . . N ZZDCOM ; clear array of commands & special elements found
 . . D CHECK^ARJTDIM(VALUE,FIND,.ZZDCOM) ; parse line
 . . Q:'ZZDCOM  ; skip values that don't match
 . . ;
 . . ; display match
 . . W !,IEN(1),"  " ; ID entry
 . . W ?20,FIELD,"  " ; ID field
 . . F  Q:VALUE=""  W ?30,$E(VALUE,1,50),! S $E(VALUE,1,50)="" ; wrap val
 ;
 QUIT  ; end of SEARCHN
 ;
