ARJTDIM ;SFISC/JFW,GFT,TOAD-FileMan: M Syntax Checker, Main ;5/27/2004  00:26
 ;;3.0T1;OPENVISTA;;Jun 20, 2004
 ;
 ; Change History:
 ;    2004 05 27  WV/TOAD: added "^[]" to FIND in Input
 ;
CHECK(CODE,FIND,FOUND) ; ** Parse & Evaluate a Line of Code **
 ;
 ; Input:
 ;    FIND = Optional. Code for special search to include.
 ;       Defaults to normal parsing with no special search.
 ;       "DSM" looks for potentially DSM-specific language elements.
 ;       "DSM2" is a tighter version, e.g., flag USE only if params.
 ;       "?(" looks for alternation in pattern match.
 ;       "?@" looks for pattern indirection.
 ;       "D" looks for DO commands (for testing).
 ;       "^[]" looks for extended global references.
 ;       each new special search must be hand-coded.
 ; In/Output:
 ;    .FOUND = results of special search. 1 = successful.
 ;    .FOUND(language element) = # times that element was found.
 ;       for example, FOUND("D") means found DO command.
 ;       "DSM" search also returns FOUND("DSM",element).
 ;    Both of these in/outputs are cumulative. That is, if passed in
 ;    with values, they are additive; if not, they initialize.
 ;
 S FIND=$G(FIND)
 S FOUND=+$G(FOUND) ; nothing special found
 S %X=CODE ; parse buffer
 S %END=""
 S %ERR=0 ; no error so far
 S %LAST=""
 I CODE'?.ANP D  I %X'?.ANP G ER ; no control characters allowed
 . D DSM(,"CONTROL CHARACTER",FIND,.FOUND)
 . S %X=$TR(%X,$C(9)," ")
 ;
GC ; get next command on line (*)
 ;
 ; Errors
 G ER:%ERR ; bail out if we've found an error
 G LAST:";"[$E(%X) ; we're done if the next item is a comment
 ; otherwise it must be a command
 I "BCDEFGHIKLMNOQRSUWXZ"'[$E(%X) D:$E(%X)="V"  G ER
 . D DSM("V","VIEW",FIND,.FOUND)
 ;
 ; Command words
 S %LAST=%X D SEP G ER:%ERR ; extract command word with optional timeout
 S %COM=$P(%ARG,":") ; separate command word from timeout
 S %COMMAND=%COM ; unabbreviated command word
 I $L(%COM)>1 D  G ER:%ERR ; deal with spelled out command words
 . I $T(COMMAND)'[(";"_%COM_";"),%COM'?1"Z"1.U S %ERR=1
 . E  S %COM=$E(%COM) ; re-abbreviate for later select
 ;
 ; Post-Conditions
 S %=$P(%ARG,":",2,99) ; extract post-condition
 S %COM(1)=% ; save it off
 I %ARG[":",%="" G ER ; empty postcond is an error
 I %]"" D ^ARJTDIM1 G ER:%ERR ; otherwise it better be an expr
 ;
 ; Argument List
 D SEP G ER:%ERR ; extract argument list into %ARG
 I %ARG="","CGMORSUWXZ"[%COM G ER ; some commands can be argumentless
 S %END=%ARG
 I $G(MAH) W !?10,%COM,!
 G @%COM ; Handle each command as a separate case
 ;
B D DSM("B","BREAK",FIND,.FOUND)
 G GC:%ARG=""&(%COM(1)="")
 G BK^ARJTDIM4
C D DSM("C","CLOSE",FIND,.FOUND)
 G CL^ARJTDIM4
D D ADD("D",.FOUND) S FOUND=FIND="D"!FOUND G DG^ARJTDIM3
E D ADD("E",.FOUND) G GC:%ARG=""&(%COM(1)=""),ER
F D ADD("F",.FOUND) G ER:%COM(1)]"",GC:%ARG="",FR^ARJTDIM3
G D ADD("G",.FOUND) G DG^ARJTDIM3
H D ADD("H",.FOUND) G GC:%ARG=""&(%COM(1)="")&(%X]""),HN^ARJTDIM3:%ARG]"",ER Q
I D ADD("I",.FOUND) G ER:%COM(1)]"",IX^ARJTDIM4
K D:'$D(ZZDNEW) ADD("K",.FOUND) K ZZDNEW
 G GC:%ARG=""&(%COM(1)="")&(%X]"")
 G KL^ARJTDIM3:%ARG]""
 G ER
L D ADD("L",.FOUND) G LK^ARJTDIM3
M D ADD("M",.FOUND) G S
N D ADD("N",.FOUND) G ER:%ARG=""&(%X="") S ZZDNEW=1 G K
O D DSM("O","OPEN",FIND,.FOUND)
 G OP^ARJTDIM3
Q D ADD("Q",.FOUND) G ER:%ARG]"",GC:%ARG=""&(%COM(1)=""),BK^ARJTDIM4
R D ADD("R",.FOUND) G RD^ARJTDIM4
S D ADD("S",.FOUND) G ST^ARJTDIM4
U D ADD("U",.FOUND) G OP^ARJTDIM3
W D ADD("W",.FOUND) G WR^ARJTDIM4
X D ADD("X",.FOUND) G IX^ARJTDIM4
Z D DSM(%COM,%COMMAND,FIND,.FOUND) G GC ; don't parse args of Z commands
 ;
SEP ; remove first " "-piece of %X into %ARG: parse commands (GC)
 F %I=1:1 S %C=$E(%X,%I) D:%C=""""  Q:" "[%C
 . N %OUT S %OUT=0 F  D  Q:%OUT!%ERR
 . . S %I=%I+1,%C=$E(%X,%I) I %C="" S %ERR=1 Q
 . . Q:%C'=""""  S %I=%I+1,%C=$E(%X,%I) Q:%C=""""  S %OUT=1
 S %ARG=$E(%X,1,%I-1),%I=%I+1,%X=$E(%X,%I,999)
 Q
 ;
COMMAND ;;BREAK;CLOSE;DO;ELSE;FOR;GOTO;HALT;HANG;IF;KILL;LOCK;MERGE;NEW;OPEN;QUIT;READ;SET;USE;WRITE;XECUTE;
 ;
LAST ; check to ensure no trailing "," or " " at end of command (GC)
 S %L=$L(%LAST),$E(%LAST,%L+1-$L(%X),%L)=""
 I $E(%END,$L(%END))="," G ER
 I $E(%X)="",$E(%LAST,%L)=" " G ER
 G END
 ;
ADD(ELEMENT,FOUND) ; record element found
 ; Input: ELEMENT = code for element found, e.g., "F".
 ; Output: .FOUND(ELEMENT) = increment # times found
 S FOUND(ELEMENT)=$G(FOUND(ELEMENT))+1
 Q  ; end of DSM
 ;
DSM(ABBREV,ELEMENT,FIND,FOUND) ; record DSM-specific element found
 ; Input:
 ;    ABBREV = code for element found, e.g., "V"
 ;    ELEMENT = name of element found, e.g., "VIEW".
 ; Output:
 ;    .FOUND(ABBREV) = increment # times found
 ;    .FOUND("DSM",ELEMENT) = ditto
 I $G(ABBREV)'="" D ADD(ABBREV,.FOUND)
 I FIND["DSM" D
 . S FOUND=1
 . S FOUND("DSM",ELEMENT)=$G(FOUND("DSM",ELEMENT))+1
 Q  ; end of DSM
 ;
ER D ADD("ERROR",.FOUND) ;
END K %,%A,%A1,%A2,%ARG,%C1,%C,%COM,%END,%ERR,%H,%I,%L,%LAST,%P,%X,%Z Q
