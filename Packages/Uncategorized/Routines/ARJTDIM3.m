ARJTDIM3 ;SFISC/JFW,GFT,TOAD-FileMan: M Syntax Checker, Commands ;7/19/02  16:29
 ;;1.0T5;ZZD ANALYSIS TOOL;;Jul 20, 2000
 ;
DG ; DO and GET (D^ARJTDIM and G^ARJTDIM)
 G GC^ARJTDIM:%ARG=""!%ERR D PARS G ER:%ERR
 S %L=":" D PARS1 G ER:%ERR
 I %C=%L G ER:%A1="" S %=%A1 D ^ARJTDIM1
 I $E(%A)="&" D  ; although disallowed, capture external reference
 . N REF S REF=$E(%A,1,$F(%A,"(")-2)
 . I REF="" S REF=$E(%A,1,$F(%A,",")-2)
 . I REF="" S REF=%A
 . I REF[".",$P(REF,".",2)'="" S REF=$P(REF,".",2)
 . D DSM("&",REF,FIND,.FOUND)
 I %A["@^" S %=%A D ^ARJTDIM1 G DG
 I %A["(",$E(%A)'="@",$E($P(%A,"^",2))'="@" D  G ER:%ERR
 . I %COM'="D" S %ERR=1 Q
 . S %=%A
 . I %'?.E1"(".E1")" S %ERR=1 Q
 . S %C=$P(%,"("),%C1=$P(%C,"^",2,999),%I=$F(%,"(")-1
 . I %C=""!(%C?.E1"^") S %ERR=1 Q
 . I %C1]"",%C1'?1U.7AN,%C1'?1"%".7AN S %ERR=1 Q
 . S %C=$P(%C,"^") I %C]"",%C'?1U.7AN,%C'?1"%".7AN,%C'?1.8N S %ERR=1 Q
 . Q:$E(%,%I,%I+1)="()"
 . S (%(-1,2),%(-1,3))=0,%N=1,%(0,0)="P^",(%(0,1),%(0,2),%(0,3))=0
 . D GG^ARJTDIM1
 E  D LABEL(0)
 G DG
 ;
LABEL(OFFSET) ; labelref, entryref, and $TEXT argument (DG and TEXT^ARJTDIM1)
 S %L="^" D PARS1 Q:%ERR  ; split the argument at the ^
 I %C=%L D  Q:%ERR  ; if the arg starts with ^
 . I $E(%A1)="%",$E(%A1,2)'="Z","^%DT^%DTC^%RCR^%XUCI^"'[(U_%A1_U) D
 . . D DSM(,%A1,FIND,.FOUND)
 . S:%A1=""!($E(%A1)="^") %ERR=1 ; ^ alone or ^^anything are bad
 . S %=%A1 D VV ; validate the name
 . D ^ARJTDIM1 ; handle parameter list?
 S %=%A D VV:%'=+%&'OFFSET
 D ^ARJTDIM1
 Q
 ;
KL ; KILL, LOCK, and NEW (K^ARJTDIM and LK)
 D PARS G ER:%ERR
 I %A="",%C="," G ER
 I %A?1"^"1UP.UN,%COM'="L" G ER
 I %A?1"(".E1")" D  G KL
 . S %ARG("E")=$L(%ARG)
 . S %A=$E(%A,2,$L(%A)-1) S %ARG=%A_$S(%ARG]"":","_%ARG,1:"")
 S %=%A I %COM="L","+-"[$E(%A) S $E(%A)=""
 I %COM="N",'$$LNAME(%) G ER
 I %COM="K",$D(%ARG("E")),'$$LNAME(%) G ER
 I $D(%ARG("E")),$L(%ARG)'>%ARG("E") K %ARG("E")
 D VV,^ARJTDIM1 G GC^ARJTDIM:%ARG=""!%ERR
 G KL
 ;
LK ; LOCK (L^ARJTDIM)
 S %A=%ARG,%L=":" S:"+-"[$E(%A) %A=$E(%A,2,999) D PARS1
 I %C=%L G ER:%A1="" S %=%A1 D ^ARJTDIM1
 S %ARG=%A G GC^ARJTDIM:%A="",KL
 ;
HN ; HANG (H^ARJTDIM)
 S %=%ARG D ^ARJTDIM1 G GC^ARJTDIM
 ;
OP ; OPEN and USE (O^ARJTDIM and U^ARJTDIM)
 G GC^ARJTDIM:%ARG=""!%ERR
 D PARS G ER:%ERR!(%C=","&(%A=""))
 G US:%COM="U"
 ;
 S %L=":" D PARS1
 S %A2=%A,%A=%A1 S:%C=%L&(%A="") %ERR=1 D PARS1 G ER:%ERR!(%C=%L&(%A1=""))
 ;
 F %L="%A1","%A2" S %=@%L D ^ARJTDIM1 G OP:%ERR
 G OP
 ;
US S %L=":" D PARS1 G ER:%C=%L&(%A1="")
 I %A'="IO",%A'="IO(0)" D DSM(,"USE",FIND,.FOUND)
 S %=%A D ^ARJTDIM1
 S %A=%A1 D PARS1 G ER:%C]""
 G OP
 ;
FR ; FOR (F^ARJTDIM)
 S %L="=",%A=%ARG D PARS1 G ER:%ERR!(%A1="")!(%A="") S %ARG=%A1
 S %=%A G ER:%A?1"^".E D VV,^ARJTDIM1 G ER:%ERR
FR1 G GC^ARJTDIM:%ARG=""!%ERR D PARS
 S %L=":" F %A=%A,%A1 D PARS1 G ER:%ERR!(%A=""&(%C=%L)) S %=%A D ^ARJTDIM1
 I %A1]"" S %=%A1 D ^ARJTDIM1
 G FR1
 ;
 ; this chunk, called usually at PARS, parses & extract the next argument
 ; In/Output:
 ;    %ARG = command argument buffer
 ;    %C = current character
 ;    %ERR = 1 if there's an error
 ;    %I = current character position
 ; Output:
 ;    %A = next argument
 ; Called by: DG, KL, OP, FR1
 ;
 S (%A,%C)="" Q:%ERR  S (%ERR,%I)=0 ; entry
 F  D  Q:","[%C!%ERR  ; main loop: advance to next top-level ","
 . D %INC
 . I %C="""" D  Q:%ERR  ; skip over strlit
 . . F  D %INC Q:%C=""""  I %C="" S %ERR=1 Q
 . I %C="(" D  Q:%ERR  ; skip over ()s
 . . N %P S %P=1
 . . N %J F %J=0:0 D  Q:'%P!%ERR
 . . . D %INC
 . . . I %C="""" D  Q:%ERR  ; skip over strlit
 . . . . F  D %INC Q:%C=""""  I %C="" S %ERR=1 Q  ; work on this
 . . . S %P=%P+$S(%C="(":1,%C=")":-1,1:0) Q:'%P
 . . . I %C="" S %ERR=1
 I '%ERR D
 . S %A=$E(%ARG,1,%I-1)
 . S %ARG=$E(%ARG,%I+1,999)
 Q
 ;
PARS S (%A,%C)="" Q:%ERR  S (%ERR,%I)=0 ; entry
INC D %INC D QT:%C="""",PARAN:%C="(" Q:%ERR  G OUT:","[%C,INC ; main loop
QT D %INC Q:%C=""""  G QT:%C]"" S %ERR=1 Q  ; skip over strlit
PARAN S %P=1 F %J=0:0 D  Q:'%P!%ERR  ; skip over ()s
 . D %INC D QT:%C=""""
 . S %P=%P+$S(%C="(":1,%C=")":-1,1:0) Q:'%P
 . I %C="" S %ERR=1
 Q
OUT S %A=$E(%ARG,1,%I-1),%ARG=$E(%ARG,%I+1,999) Q  ; set output & quit
%INC S %I=%I+1,%C=$E(%ARG,%I) Q  ; advance 1 character
 ;
 ;
PARS1 S (%A1,%C)="" Q:%ERR  S (%ERR,%I)=0
INCR D %INC1 D QT1:%C="""",PARAN1:%C="(" Q:%ERR=1  G OUT1:%L[%C,INCR
OUT1 S %A1=$E(%A,%I+1,999),%A=$E(%A,1,%I-1) Q
QT1 D %INC1 Q:%C=""""  G QT1:%C]"" S %ERR=1 Q
PARAN1 S %P=1 F %J=0:0 D %INC1 D QT1:%C="""" S %P=%P+$S(%C="(":1,%C=")":-1,1:0) Q:'%P  I %C="" S %ERR=1 Q
 Q
%INC1 S %I=%I+1,%C=$E(%A,%I) Q
 ;
 ;
VV ; variable, label, or routine name (LABEL, KL, and FR)
 I '%ERR,%]"",%'["@",%'?1U.UN,%'?1U.UN1"(".E1")",%'?1"%".UN1"(".E1")",%'?1"%".UN,%'?1"^"1U.UN1"(".E1")",%'?1"^%".UN1"(".E1")",%'?1"^(".E1")",%'?1"^"1U.UN S %ERR=1
 S:%["?@" %ERR=1 Q
 ;
LNAME(%) ; lname (KL)
 I %?1A.7UN!(%?1"%".7UN) Q 1
 I %?1"@".E Q 1
 Q 0
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
ER G ER^ARJTDIM
