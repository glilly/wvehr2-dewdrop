ARJTDDK1 ;PUG/TOAD-FileMan Search 1 Field in 1 File ;7/8/02  10:42
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;
 ; Table of Contents:
 ;    SEARCH1 = search 1 field in every entry in 1 file
 ;
 ; Calls:
 ;    CHECK^ARJTDIM = to search each value (MUMPS code)
 ;
 ;
SEARCH1(FILE,FIELD) ; search 1 field in every entry in 1 file
 ;
 ; S.1. Build Get Code
 ;
 N ROOT S ROOT=$G(^DIC(FILE,0,"GL")) Q:ROOT=""  ; file root
 W !,"Now searching the ",$O(^DD(FILE,0,"NM",""))," file "
 W "(",$P(@(ROOT_"0)"),U,4)," entries)..."
 ;
 N ENTRY S ROOT=ROOT_"ENTRY(1)" ; top-level IEN
 N ADVANCE S ADVANCE(1)="S ENTRY(1)=$O("_ROOT_"))" ; build traverse code
 ;
 N FIELDEF S FIELDEF=$G(^DD(FILE,FIELD,0)) Q:FIELDEF=""  ; field DD
 Q:$P(FIELDEF,U,2)  ; subfiles have subfile# in 2nd piece
 N HOME S HOME=$P(FIELDEF,U,4) ; node;place of field
 N NODE S NODE=ROOT_","_+HOME_")" ; build root to fetch node
 S NODE="$G("_NODE_")" ; protect against undefined errors
 N PLACE S PLACE=$P(HOME,";",2) ; place to fetch
 ;
 ; N GET ; array of get commands
 I PLACE D  ; $Piece fields have a numeric place
 . S GET(1)="S VALUE=$P("_NODE_",U,"_PLACE_")" ; build get code
 E  D  ; $Extract fields have E#,#
 . N FIRST S FIRST=+$P($P(PLACE,";"),"E",2) ; first position
 . N LAST S LAST=$P(PLACE,",",2) ; last position
 . S GET(1)="S VALUE=$E("_NODE_","_FIRST_","_LAST_")" ; build get code
 ;
 ; S.2. Traverse File
 ;
 N COUNT S COUNT=0 ; count of entries searched
 N VALUE ; the value of the field for each entry
 S ENTRY(1)=0 F  X ADVANCE(1) Q:'ENTRY(1)  D  ; traverse file entries
 . S COUNT=COUNT+1 I '(COUNT#1000) W "."
 . X GET(1) ; fetch field value for each entry
 . Q:VALUE'["?"  ; skip those that clearly lack pattern match
 . ;
 . N ZZDCOM ; clear array of commands & special elements found
 . D CHECK^ARJTDIM(VALUE,"?",.ZZDCOM) ; parse line
 . Q:'ZZDCOM  ; skip values that lack pattern match
 . ;
 . W !,ENTRY(1),"  ",?15 ; display match (IEN  value wrapped)
 . N LINE F  W $E(VALUE,1,65) S $E(VALUE,1,65)="" Q:VALUE=""  W !?15
 ;
 QUIT  ; end of SEARCH1
 ;
