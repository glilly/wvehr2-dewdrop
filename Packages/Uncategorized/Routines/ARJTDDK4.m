ARJTDDK4 ;PUG/TOAD-FileMan Search DD ;7/8/02  10:45
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;
 ; Table of Contents:
 ;    SEARCHDD = search entire DD
 ;    CHECK = check 1 value (MUMPS code)
 ;    UNQUOTE = unquote the contents of a string
 ;    CONTAINS = function: does code contain what we're looking for
 ;    TEST = test SEARCHDD with alternation in pattern match
 ;
 ; input:
 ;   .CONTAINS(string)="" to search any line containing the string
 ;    FIND = optional. special search, e.g., "DSM"
 ;
 ; output:
 ;    .EXIT = returns 1 if interrupted.
 ;    report to current device
 ;
 ; Calls:
 ;    CHECK^ARJTDIM = to search each value (MUMPS code)
 ;
SEARCHDD(CONTAINS,FIND,EXIT) ; search entire DD
 ;
 S EXIT=0 ; not interrupted yet
 N FILE,FIELD,HOOK,VALUE,ID,IX,NODE,OF,MESSAGE
 N COUNT S COUNT=0
 N MATCHES S MATCHES=0
 N FILENAME,FLDNAME
 ; check the File-level attributes
 S FILE=-1 F  S FILE=$O(^DD(FILE)) Q:FILE'=0&'FILE  D  Q:EXIT
 . S FILENAME=$O(^DD(FILE,0,"NM",""))
 . ;
 . S FIELD=0
 . S VALUE=$G(^DD(FILE,0,"ACT")) I VALUE'="" D  Q:EXIT
 . . D CHECK(VALUE,"Post-Action")
 . ;
 . I $D(^DD(FILE,0,"ID")) D
 . . S ID=0 F  S ID=$O(^DD(FILE,0,"ID",ID)) Q:ID=""  D  Q:EXIT
 . . . S VALUE=$G(^DD(FILE,0,"ID",ID)) I VALUE'="" D CHECK(VALUE,"ID")
 . ;
 . S VALUE=$G(^DD(FILE,0,"SCR")) I VALUE'="" D  Q:EXIT
 . . D CHECK(VALUE,"Whole-File Screen")
 . ;
 . S FIELD=0 F  S FIELD=$O(^DD(FILE,FIELD)) Q:'FIELD  D  Q:EXIT
 . . S FLDNAME=$P($G(^DD(FILE,FIELD,0)),U)
 . . ;
 . . S VALUE=$P($G(^DD(FILE,FIELD,0)),U,5,9999) I VALUE'="" D  Q:EXIT
 . . . D CHECK(VALUE,"Input Transform")
 . . ;
 . . I $D(^DD(FILE,FIELD,1)) D  Q:EXIT
 . . . S IX=0 F  S IX=$O(^DD(FILE,FIELD,1,IX)) Q:'IX  D  Q:EXIT
 . . . . S NODE=0 F  D  Q:'NODE!EXIT
 . . . . . S NODE=$O(^DD(FILE,FIELD,1,IX,NODE)) Q:'NODE
 . . . . . Q:NODE=3  ; No Deletion Message
 . . . . . S VALUE=$G(^DD(FILE,FIELD,1,IX,NODE)) Q:VALUE=""
 . . . . . I NODE=1 S MESSAGE=" Set Logic"
 . . . . . E  I NODE=2 S MESSAGE=" Kill Logic"
 . . . . . E  S MESSAGE=" Overflow Logic"
 . . . . . D CHECK(VALUE,"Cross-Reference "_IX_MESSAGE)
 . . ;
 . . S VALUE=$G(^DD(FILE,FIELD,2)) I VALUE'="" D  Q:EXIT
 . . . D CHECK(VALUE,"Output Transform")
 . . ;
 . . S VALUE=$G(^DD(FILE,FIELD,4)) I VALUE'="" D  Q:EXIT
 . . . D CHECK(VALUE,"Executable Help")
 . . ;
 . . S VALUE=$G(^DD(FILE,FIELD,7.5)) I VALUE'="" D  Q:EXIT
 . . . D CHECK(VALUE,"Pre-Lookup Transform")
 . . ;
 . . F OF=9.2:.1:9.9 S VALUE=$G(^DD(FILE,FIELD,OF)) I VALUE'="" D  Q:EXIT
 . . . D CHECK(VALUE,"Overflow Code Node "_OF)
 . . ;
 . . S VALUE=$G(^DD(FILE,FIELD,12.1)) I VALUE'="" D  Q:EXIT
 . . . D CHECK(VALUE,"Pointer or Set-of-Codes Screen")  Q:EXIT
 . . . N SCREEN S SCREEN=$P(VALUE,"S DIC(""S"")=",2)
 . . . Q:$E(SCREEN)'=""""  Q:$E(SCREEN,$L(SCREEN))'=""""
 . . . S SCREEN=$$UNQUOTE(SCREEN)
 . . . D CHECK(SCREEN,"Pointer or Set-of-Codes Screen")
 . . ;
 . . S VALUE=$G(^DD(FILE,FIELD,"AX")) I VALUE'="" D  Q:EXIT
 . . . D CHECK(VALUE,"Audit Condition")
 . . ;
 . . I $D(^DD(FILE,FIELD,"DEL")) D
 . . . S NODE=0 F  S NODE=$O(^DD(FILE,FIELD,"DEL",NODE)) Q:'NODE  D  Q:EXIT
 . . . . S VALUE=$G(^DD(FILE,FIELD,"DEL",NODE,0)) Q:VALUE=""
 . . . . D CHECK(VALUE,"Delete Condition "_NODE)
 . . ;
 . . I $D(^DD(FILE,FIELD,"LAYGO")) D  Q:EXIT
 . . . S NODE=0 F  S NODE=$O(^DD(FILE,FIELD,"LAYGO",NODE)) Q:'NODE  D  Q:EXIT
 . . . . S VALUE=$G(^DD(FILE,FIELD,"LAYGO",NODE,0)) Q:VALUE=""
 . . . . D CHECK(VALUE,"LAYGO Condition "_NODE)
 N SENTITY S SENTITY="DD attribute value"
 D RESULTS^ARJTDDKU(EXIT,COUNT,MATCHES,"Search",SENTITY,"checked")
 W !!!,"End of report. Have a nice day."
 Q
 ;
 ;
CHECK(VALUE,HOOK) ; Check out this value
 S COUNT=COUNT+1
 I '(COUNT#1000) D  Q:EXIT
 . W "."
 . I '(COUNT#10000) D
 . . W !,$FN(COUNT,",")," DD attributes searched. "
 . N READ R READ:0 S EXIT=READ=U Q:EXIT
 Q:'$$CONTAINS(VALUE,.CONTAINS)  ; skip those that clearly don't match
 ;
 N ZZDCOM ; clear array of commands & special elements found
 D CHECK^ARJTDIM(VALUE,FIND,.ZZDCOM) ; parse line
 Q:'ZZDCOM  ; skip lines that don't match
 S MATCHES=MATCHES+1 ; this is a match
 ; S COUNT=0 ; reset count to postpone printing a dot
 ;
 ; display match
 ; match #, file/subfile path, field
 W !!,MATCHES_". "_FILENAME_" ("_FILE_") file, "
 I FIELD W FLDNAME_" ("_FIELD_") field, " ; if a field attribute
 W HOOK ; which attribute contained the match
 ; field value
 F  Q:VALUE=""  W !?10,$E(VALUE,1,70) S $E(VALUE,1,70)="" ; value
 N READ R READ:0 S EXIT=READ=U
 ;
 QUIT  ; end of CHECK
 ;
 ;
UNQUOTE(STRING) ; unquote the contents of a string
 ;
 S $E(STRING)="",$E(STRING,$L(STRING))="" ; remove bracketing "s
 N CHAR F CHAR=1:1:$L(STRING)-1 I $E(STRING,CHAR,CHAR+1)="""""" D
 . S $E(STRING,CHAR)="" ; remove one of the doubled quotes
 Q STRING
 ;
 ;
CONTAINS(CODE,CONTAINS) ; function: does code contain what we're looking for
 N DOES I $D(CONTAINS)#2 S DOES=CODE[CONTAINS Q DOES
 I $D(CONTAINS)>9 D  Q DOES
 . N SUB S SUB=""
 . F  S SUB=$O(CONTAINS(SUB)) Q:SUB=""  S DOES=CODE[SUB Q:DOES
 Q 0
 ;
 ;
TEST ; test SEARCHDD with alternation in pattern match
 W !!,"Testing SEARCHDD^ARJTDDK4 with alternation in pattern match."
 W !!,"Lowering priority for duration of search.",!
 N ARJTPRI,Y X ^%ZOSF("PRIINQ") S ARJTPRI=Y
 N X S X=1 X ^%ZOSF("PRIORITY")
 D SEARCHDD("?","?(")
 S X=ARJTPRI X ^%ZOSF("PRIORITY")
 W !!,"Priority restored."
 QUIT  ; end of TEST
 ;
