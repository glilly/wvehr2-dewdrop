ARJTDIM4 ;SFISC/JFW,GFT,TOAD-FileMan: M Syntax Checker, Commands ;5/26/2004  21:16
 ;;3.0T1;OPENVISTA;;Jun 20, 2004
 ;
 ; I do not like calling ADD from within $$GLVN, but don't have time now to redo
 ; $$GLVN into a subroutine. This routine also needs extensive commenting.
 ;
 ; Change History:
 ;    2004 05 26  WV/TOAD: added ADD to file found search elements, and changed
 ;                GLVN to record extended global references if code "[]" passed.
 ;                commented GLVN.
 ;
BK ; BREAK and QUIT (B^ARJTDIM and Q^ARJTDIM)
 I %ARG]"" S %=%ARG D ^ARJTDIM1 G ER:%ERR
 G GC^ARJTDIM
 ;
CL ; CLOSE (C^ARJTDIM)
 G ER:%ERR I %ARG]"" F %Z=0:0 D S S %=%A D ^ARJTDIM1 G:%ARG=""!%ERR GC^ARJTDIM
 G GC^ARJTDIM
 ;
IX ; IF and XECUTE (I^ARJTDIM and X^ARJTDIM)
 G GC^ARJTDIM:%ARG=""!%ERR D S S %L=":" D S1 I %C=%L S %=%A1 D ^ARJTDIM1 G ER:%A1=""!%ERR
 S %=%A D ^ARJTDIM1 G IX
 ;
 ;
ST ; SET and MERGE (S^ARJTDIM and M^ARJTDIM)
 ; Inputs: %ARG = argument list remaining to parse
 ;         %COM = abbreviated commandword
 ;         %COM(1) = postcond
 ;         %END = full argument list
 ;         %ERR = whether we've encountered an error
 ;         %I = # chars into overall line to parse
 ;         %LAST = full line to parse
 ;         %X = unparsed part of line remaining
 ;
 ; if we've run out of args or have an error, we're done in ST
 G GC^ARJTDIM:%ARG=""!%ERR
 ;
 D S ; extract next argument
 G ER:%ERR!(%A=""&(%C=",")) ; bad if error or comma without argument
 ;
 I %A?1"@".E S %=%A D ^ARJTDIM1 G ST ; handle argument indirection
 ;
 S %L="=" D S1 ; split the argument at the "="
 G ER:(%A="")!(%A1="") ; both setleft & setright must be present
 ;
 G ER:%COM="M"&'$$GLVN(%A1) ; for MERGE, setright better be a glvn
 ;
 I %A="ZTIO",%A1="IO" S FOUND("ZTIO=IO")=""
 ;
 I %A="DIC(0)" D  ; search for DIC(0)["T"
 . I %A1["T" S FOUND("DIC(0)","T")="" ; intentionally loose check
 ;
 S %=%A1 D ^ARJTDIM1 G ER:%ERR ; ensure setright is a valid expr
 ;
 ; if it's a set many, deal with that in STM
 I %A?1"(".E1")" S %A=$E(%A,2,$L(%A)-1) G ER:%COM="M",STM
 ;
 D VV ; make sure setleft is valid
 G ST ; go handle next argument in arglist
 ;
STM ; SET (x,y)=... (ST) -- ()s have been stripped
 G ST:%ERR!(%A="") ; we're done in STM if error or no more setleft
 G ER:%A?1",".E ; we need a setleft before the 1st comma
 ;
 S %L="," D S1 ; separate the first setleft from the list
 G ER:%ERR!(%C=%L&(%A1="")) ; bad if error or trailing comma
 D VV ; make sure current setleft is valid
 S %A=%A1 G STM ; go handle rest of setlist
 ;
 ;
RD ; READ (R^ARJTDIM)
 G GC^ARJTDIM:%ARG=""!%ERR D S G ER:%ERR!(%C=","&(%A=""))
 I "!#?"[$E(%A,1) S %I=0 D FRM G RD
 I %A?1"""".E G ER:$P(%A,"""",3)'="" S %=%A D ^ARJTDIM1 G RD
 I %A?1"*".E S %A=$E(%A,2,999)
 I $E(%A)="^","^TMP^XTMP^"'[$P(%A,"(") G ER
 F %L=":","#" D  G ER:%ERR
 . D S1 Q:%ERR
 . I %A="" S %ERR=1 Q
 . I %A1="",%C=%L S %ERR=1 Q
 . S %=%A1 D ^ARJTDIM1
 D VV G ER:%ERR,RD
 ;
WR ; WRITE (W^ARJTDIM)
 G GC^ARJTDIM:%ARG=""!%ERR D S G ER:%ERR!(%A=""&(%C=","))
 I "!#?/"[$E(%A) S %I=0 D FRM G WR
 S:%A?1"*".E %A=$E(%A,2,999) S %=%A D ^ARJTDIM1 G WR
 ;
FRM ; format (RD and WR)
 S %I=%I+1,%C=$E(%A,%I) Q:%C=""  G FRM:"!#"[%C
 S %=$E(%A,%I+1,999) I %]"",%C="?" D ^ARJTDIM1 Q
 I %C="/",%COM="W" S:%?1"?".E %="A"_$E(%,2,999) I %?1AN.E D ^ARJTDIM1 Q
 S %ERR=1 Q
 ;
S ; split at first comma: end of first argument (*)
 ; returns %A = next argument to parse
 ;         %ARG = remaining unparsed arguments
 ;         %C = next character
 ;         %ERR = whether there was an error
 ;         %I = # chars into argument list
 S (%A,%C)="" Q:%ERR  S (%ERR,%I)=0
INC D %INC D QT:%C="""",P:%C="(" Q:%ERR  G OUT:","[%C,INC
QT D %INC Q:%C=""""  G QT:%C]"" S %ERR=1 Q
P S %P=1 F %J=0:0 D %INC D QT:%C="""" S %P=%P+$S(%C="(":1,%C=")":-1,1:0) Q:'%P  I %C="" S %ERR=1 Q
 Q
OUT S %A=$E(%ARG,1,%I-1),%ARG=$E(%ARG,%I+1,999) Q
%INC S %I=%I+1,%C=$E(%ARG,%I) Q
 ;
 ;
S1 ; split at first instance of %L (*)
 ; returns %A = setleft
 ;         %A1 = setright (part of argument remaining unparsed)
 ;         %C = "="
 ;         %ERR = whether there was an error
 ;         %I = # chars into argument (incl "=")
 ;         %L = "="
 S (%A1,%C)="" Q:%ERR  S (%ERR,%I)=0
INCR D %INC1 D QT1:%C="""",P1:%C="(" Q:%ERR  G OUT1:%L[%C,INCR
OUT1 S %A1=$E(%A,%I+1,999),%A=$E(%A,1,%I-1) Q
QT1 D %INC1 Q:%C=""""  G QT1:%C]"" S %ERR=1 Q
P1 S %P=1 F %J=0:0 D %INC1 D QT1:%C="""" S %P=%P+$S(%C="(":1,%C=")":-1,1:0) Q:'%P  I %C="" S %ERR=1 Q
 Q
%INC1 S %I=%I+1,%C=$E(%A,%I) Q
 ;
 ;
VV ; glvn or setleft (ST, STM, and RD)
 S %=%A Q:%ERR
 I %]"",$$GLVN(%)=0 D
 .I %COM'="S" S %ERR=1 Q
 .I %["(",(%?1"$P".E)!(%?1"$E".E) Q
 .I %="$X"!(%="$Y") Q
 .I %="$D"!(%="$DEVICE")!(%="$K")!(%="$KEY")!(%="$EC")!(%="$ECODE")!(%="$ET")!(%="$ETRAP") S %ERR=1 Q  ; SAC
 .S %ERR=1
 D ^ARJTDIM1:'%ERR Q
 ;
GLVN(%) ; glvn (not counting subscript syntax) (ST, VV)
 I %?.1"^"1U.UN Q 1 ; e.g., ^TMP or X
 I %?.1"^"1U.UN1"("1.E1")" Q 1 ; e.g., ^TMP(1) or X(1)
 I %?.1"^"1"%".UN Q 1 ; e.g., ^%ZTSK or %X
 I %?.1"^"1"%".UN1"("1.E1")" Q 1 ; e.g., ^%ZTSK(1) or %X(1)
 I %?1"^("1.E1")" Q 1 ; e.g., ^(1)
 I %?1"^$"1.U1"("1.E1")" Q 1 ; e.g., ^$JOB(1)
 I %?1"@"1.E Q 1 ; e.g., @X
 I %?1"^["1.E1"]"1.E D ADD("^[]",.FOUND) ; recorded extended global refs found
 Q 0
 ;
ADD(ELEMENT,FOUND) ; record element found (GLVN)
 ; Input: ELEMENT = code for element found, e.g., "F".
 ; Output: .FOUND(ELEMENT) = increment # times found
 S FOUND=1
 S FOUND(ELEMENT)=$G(FOUND(ELEMENT))+1
 Q  ; end of ADD
 ;
ER G ER^ARJTDIM
