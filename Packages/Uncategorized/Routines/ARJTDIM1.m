ARJTDIM1 ;SFISC/JFW,GFT,TOAD-FileMan: M Syntax Checker, Exprs ;5/26/2004  23:44
 ;;3.0T1;OPENVISTA;;Jun 20, 2004
 ;
 ; Change History:
 ;    2004 05 26  WV/TOAD: add comments to GG to help document code
 ;                leading to extended global refs
 ;
 Q:%ERR  N %A,%A1 S (%I,%N,%ERR,%(-1,2),%(-1,3))=0
 ;
GG ; expr, expratom, expritem, subscript, parameter (called everywhere)
 D %INC ; advance cursor to next character in expr
 I %C="" G FINISH^ARJTDIM2 ; no next character? then done
 I %C=";"!($A(%C)>95)!($A(%C)<33) G E ; semicolons or control chars are errors
 I %C="""" G QUOTE ; strings
 I %C="$" G FUNC ; functions, vars, and extrinsics
 I %C="(" G SUB^ARJTDIM2 ; start of nested parens (subs or args)
 I %C=")" G UP^ARJTDIM2 ; end of nested parens
 I %C="," G AR^ARJTDIM2 ; commas (e.g., subscripts)
 I %C=":" G SEL^ARJTDIM2 ; colons (e.g., $SELECT)
 I %C="^" G GLO^ARJTDIM2 ; gvn
EXP I %C="E",$E(%,%I-1)?1N D  G E:%ERR S %I=%I-1 G GG
 . S %L1=$E(%,%I+1)
 . I %L1'="-",%L1'="+",%L1'?1N S %ERR=1 Q
 . N %OUT S %OUT=0 F %I=%I+2:1 D  Q:%ERR!%OUT
 . . S %C=$E(%,%I)
 . . I "<>=!&'[]+-*/\#_?,:)"[%C S %OUT=1 Q
 . . I %C'?1N S %ERR=1 Q
 I %C?1U!(%C="%") D VAR^ARJTDIM2 ; lvn
 I %ERR G E ; errors
 I %C="" G GG ; if done, get next character of expr
 I %C="?" G PAT^ARJTDIM2 ; pattern match
 I "=[]<>&!"[%C G BINOP^ARJTDIM2 ; string & logic operators
 I "/\*#_"[%C G MTHOP^ARJTDIM2 ; math operators
 I "'+-"[%C G UNOP^ARJTDIM2 ; unary operators
 I %C="@" G IND^ARJTDIM2 ; indirection
PERIOD I %C="." D  G E:%ERR ; periods
 . I $P($G(%(%N-1,0)),"^")="P" D  Q
 . . N %C S %C=$E(%,%I+1) I %C?1N Q  ; decimal pass by value
 . . I %C'="@",%C'?1U,%C'="%" S %ERR=1 ; bad pass by reference
 . D %INC N %L1,%P S %L1=$E(%,%I-2),%P="':=+-\/<>[](,*&!_#"
 . I %L1?1N,%C?1N Q  ; 4.2
 . I %P[%L1,%C?1N Q  ; +.2
 . S %ERR=1 ; illegal period
 I %C?1N,$E(%,%I+1)]"",$E(%,%I+1)'?1NP,$E(%,%I+1)'="E" G E ; bad numbers
GG1 ;
 I %C]"","$(),:"""[%C S %I=%I-1 ; if at start of next expr, back up 1 char
 G GG ; process next expr
 ;
QUOTE ; strlit (GG)
 F %J=0:0 D %INC Q:%C=""!(%C="""")
 G E:%C=""!("[]()><\/+-=&!_#*,;:'"""'[$E(%,%I+1)) D:$D(%(%N-1,"F")) FN:%(%N-1,"F")["FN" G E:%ERR,GG
 ;
 ;
FUNC ; intrinsics & extrinsics, mainly intrinsic functions (GG)
 D %INC ; check next character
 G EXT:%C="$" ; $$ = extrinsic function
 I %C="&" D  ; external function, not valid but capture
 . N REF S REF=$E(%,1,$F(%,"(",%I)-2) ; e.g., "$&ZLIB.%SPAWN(...)"
 . I REF="" S REF=$E(%,1,$F(%,",",%I)-2) ; e.g., "$&%UCI"
 . I REF[".",$P(REF,".",2)'="" S REF=$P(REF,".",2) ; e.g., return %SPAWN
 . D DSM(,REF,FIND,.FOUND)
 G E:%C'?1U ; otherwise, MUST be an uppercase character next
 G SPV:$E(%,%I,999)'?.U1"(".E ; if no (, then it's a special variable
 G FUNC1:%C="Z"!($E(%,%I+1)="(") ; Z-functions & 1-character abbrevs
 ;
 ; 2-character-abreviated functions
 S %T=$E(%,%I,$F(%,"(",%I)-2) ; full abbrev
 I %T="ST"!(%T="STACK") G E ; SAC
 F %F1="FNUMBER^2;3","TRANSLATE^2;3","NAME^1;2","QLENGTH^1;1","QSUBSCRIPT^2;2","REVERSE^1;1" G FUNC2:$E(%F1,1,2)=%T,FUNC2:$P(%F1,"^")=%T
 ;
 ; can a function ever pass this line?
 G E:$T(FNC)'[(","_%T_"^")
 ;
 ; this list of functions is used by FUNC1
FNC ;;,ASCII^1;2,CHAR^1;999,DATA^1;1,EXTRACT^1;3,FIND^2;3,GET^1;2,JUSTIFY^2;3,LENGTH^1;2,ORDER^1;2,PIECE^2;4,QUERY^1;1,RANDOM^1;1,SELECT^1;999,TEXT^1;1,VIEW^1;999,ZFUNC^1;999
 ;
FUNC1 ; this line not only validates 1-char-abbrev functions, it also allows
 ; Z-functions
 S %F1=$P($T(FNC),",",$F("ACDEFGJLOPQRSTVZ",%C)) G E:%F1=""
 S %F1("CODE")=$E(%,%I,$F(%,"(",%I)-2) ; capture form in code
 ;
FUNC2 ; I think this remembers function context in prep for arg eval
 S %I=$F(%,"(",%I)-1 ; advance to (
 S %(%N,0)="1^"_$P(%F1,"^",2) ; min;max # of args to expect
 S %(%N,1)=0
 S %(%N,2)=0
 S %(%N,3)=0
 S %(%N,"F")=%F1 ; function name
 S %N=%N+1 ; expression nesting depth?
 S:$E(%F1)="S" %(%N-1,2)=1 ; $SELECT
 ;
 ; these operate on namevalues
 I ",DATA,NAME,ORDER,QUERY,GET,"[(","_$P(%F1,"^")_",") G DATA^ARJTDIM2
 ;
 ; validation of $TEXT
 I $E(%F1)="T",$E(%F1,2)'="R" D  I %ERR G ERR^ARJTDIM2
 . S %A=%I,%I=$F(%,")",%A)-1,%N=%N-1,%A=$P($E(%,%A,%I-1),"(",2,99)
 . I %A?1"+"1N.E S %A=$E(%A,2,999)
 . N %,%I,%N S %=%A D LABEL^ARJTDIM3(1)
 ;
 ; capture of $VIEW
 I $P($G(%F1),U)="VIEW" D
 . D DSM("$V","$VIEW",FIND,.FOUND)
 ;
 ; capture of $ZCALL
 ; W !?40,%F1,"  ",%F1("CODE"),"  ",%,!
 I $P($G(%F1),U)="ZFUNC",%F1("CODE")="ZC"!(%F1("CODE")="ZCALL") D
 . N ARG S ARG=$E(%,%I+1,$F(%,")",%I)-2) I ARG["," S ARG=$P(ARG,",")
 . D DSM(,ARG,FIND,.FOUND)
 ;
 ; capture other $Z functions
 E  I $P($G(%F1),U)="ZFUNC" D
 . D DSM("$Z","$"_%F1("CODE"),FIND,.FOUND)
 ;
 ; go evaluate the arguments
 G GG
 ;
 ;
SPV ; intrinsic special variables (FUNC)
 I $E(%,%I+1)?1U S %I=%I+1,%C=%C_$E(%,%I) G SPV
 I ",D,EC,ES,ET,K,P,Q,ST,SY,TL,TR,"[(","_%C_",") G E ; SAC
 I "HIJSTXYZ"[%C&(%C?1U)!(%C?1"Z".U) D  G GG
 . Q:$E(%C)'="Z"
 . D DSM("$Z*","$"_%C,FIND,.FOUND)
 I "[],)><=_&#!'+-*\/?"'[$E(%,%I+1) G E
 I ",DEVICE,ECODE,ESTACK,ETRAP,KEY,PRINCIPAL,QUIT,STACK,SYSTEM,TLEVEL,TRESTART,"[(","_%C_",") G E ; SAC
 I ",HOROLOG,IO,JOB,STORAGE,TEST,"[(","_%C_",") G GG
E G ERR^ARJTDIM2
 ;
%INC S %I=%I+1,%C=$E(%,%I) Q
 ;
FN ; literal string argument 2 of $FNUMBER (QUOTE)
 Q:%(%N-1,1)'=1  F %FZ=%I-1:-1 S %FN=$E(%,%FZ) Q:%FN=""""
 S %FN=$TR($E(%,%FZ+1,%I-1),"pt","PT")
 F %FZ=1:1 Q:$E(%FN,%FZ)=""  I "+-,TP"'[$E(%FN,%FZ) S %ERR=1 Q
 Q:%ERR  I %FN["P" F %FZ=1:1 Q:$E(%FN,%FZ)=""  I "+-T"[$E(%FN,%FZ) S %ERR=1 Q
 Q
 ;
EXT ; extrinsic functions and variables (FUNC)
 D %INC
 F %I=%I+1:1 S %C1=$E(%,%I) Q:%C1?1PC&("^%"'[%C1)!(%C1="")  S %C=%C_%C1
 G:%C="" E G:%C?.E1"^" E G:%C["^^" E
 S %C1=$P(%C,"^",2) I %C1]"",%C1'?1U.7AN,%C1'?1"%".7AN G E
 S %C=$P(%C,"^") I %C]"",%C'?1U.7AN,%C'?1"%".7AN,%C'?1.8N G E
 I $E(%,%I)="(",$E(%,%I+1)'=")" S %(%N,0)="P^",(%(%N,1),%(%N,2),%(%N,3))=0,%N=%N+1 G GG
 S %I=%I+$S($E(%,%I,%I+1)="()":1,1:-1)
 G GG:"[],)><=_&#!'+-*/\?"[$E(%,%I+1),E
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
 . ;JOHN HARVEY 7/20/02 CHECK 'ELEMENT' for NOT NULL
 . ;S FOUND("DSM",ELEMENT)=$G(FOUND("DSM",ELEMENT))+1
 . ;JOHN HARVEY 7/20/02 Add screen to fix $&% type elements
 . I ELEMENT["$&%" S ELEMENT="%"_$P(ELEMENT,"%",2)
 . I ELEMENT'="" S FOUND("DSM",ELEMENT)=$G(FOUND("DSM",ELEMENT))+1
 Q  ; end of DSM
 ;
