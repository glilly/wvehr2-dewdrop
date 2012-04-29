ARJTDIM2 ;SFISC/XAK,GFT,TOAD-FileMan: M Syntax Checker, Exprs ;5/27/2004  00:19
 ;;3.0T1;OPENVISTA;;Jun 20, 2004
 ;
 ; Change History:
 ;    2004 05 27  WV/TOAD: commented up GLO and added check for extended
 ;                global ref. Fixed comment at end of ADD.
 ;
SUB ; "(": open paren situations (GG^ARJTDIM1)
 F %J=%I-1:-1 S %C1=$E(%,%J) I %C1'?1UN,%C1'="%" Q
 S %C1=$E(%,%J+1,%I-1)
 I %C1]"",%C1'?1U.UN,%C1'?1"%".UN G ERR
 I %C1]"",%[("."_%C1) G ERR
 S %(%N,0)=$S(%C1]""!($E(%,%J)="^"):"V^",$E(%,%J)="@":"@^",1:"0^")
 S %(%N,1)=0,%(%N,2)=0,%(%N,3)=0,%N=%N+1 G 1
 ;
UP ; ")": close paren situations (GG^ARJTDIM1)
 I %N=0 G ERR
 I "(,"[$E(%,%I-1),$P($G(%(%N-1,0)),"^")'["P" G ERR
 I $E(%,%I+1)]"","<>_[]:/\?'+-=!&#*),"""'[$E(%,%I+1) G ERR
 S %N=%N-1,%(%N,1)=%(%N,1)+1,%F=$P(%(%N,0),"^") I %F D  G ERR:%ERR
 . S %F=$P(%(%N,0),"^",2),%F1=%(%N,1)
 . I %F1<+%F S %ERR=1 Q  ; not enough commas for this function
 . I %F1>$P(%F,";",2) S %ERR=1 Q  ; too many commas for this function
 . I %(%N,2),'%(%N,3) S %ERR=1 ; we're in $S and haven't yet hit a :
 K %(%N+1)
 I '%F,%F'["V",%F'["@",%F'["P",%(%N,1)>1 G ERR
 G 1
 ;
AR ; ",": comma situations -- "P" below means "parameters" (GG^ARJTDIM1)
 I %N<1 G ERR
 I "(,"[$E(%,%I-1),$P($G(%(%N-1,0)),"^")'["P" G ERR
 I '%(%N-1,3),%(%N-1,2) G ERR
 I "@("[$E(%,1,2) G ERR
 S %(%N-1,1)=%(%N-1,1)+1,%(%N-1,3)=0 G 1
 ;
SEL ; ":": $SELECT delimiter (GG^ARJTDIM1)
 S %(%N-1,3)=%(%N-1,3)+1 G ERR:'%(%N-1,2)!(%(%N-1,3)>1),1
 ;
 ;
GLO ; "^": global reference (GG^ARJTDIM1)
 ;
 ; This does not deeply evaluate gvns. It just screens some bad
 ; syntax then passes them back to GG without the leading ^ for
 ; eval as either a local or a subscript/argument list (if the
 ; gvn was a naked).
 ;
 ; Inputs:
 ;    %: expr or argument to eval
 ;    %I: character position (#) of ^ in %
 ;    %C: ^
 ;
 D %INC ; advance %I & %C to character after ^
 I $E(%,%I,999)?1"["1.E1"]"1.E D ADD("^[]",.FOUND) ; log ext gvn
 I $E(%,%I,999)'?1U.UN.P.E,"%("'[%C G ERR ; ensure that what follows
 ; starts with an upper, a %, or a (, and no ctrl chars after an upper
 ; this could probably use some tightening up at some point
 I "=+-\/<>(,#!&*':@[]_"'[$E(%,%I-2) G ERR ; only one of the listed
 ; characters may precede a global ref; anythign else is an error
 S %I=%I-1 ; back up in prep for returning to GG
 G 1 ; evaluate rest of global name like a lvn or paren list
 ;
 ;
PAT ; "?": pattern match (GG^ARJTDIM1)
 G ERR:%I=1
 I $E(%,%I+1)="@" S FOUND("?@")="",FOUND=FIND="?@"!FOUND G 1
 S FOUND("?")=""
 D %INC,PATTERN G ERR:%ERR S %I=%I-1 G 1
 ;
PATTERN F  D PATATOM Q:%C'?1N&(%C'=".")!%ERR
 Q
PATATOM D REPCOUNT Q:%ERR
 I %C="""" D STRLIT,%INC:'%ERR Q
 I %C="(" D ALTRN8 Q
 D PATCODE
 Q
REPCOUNT ;
 I %C'?1N,%C'="." S %ERR=1 Q
 N FROM S FROM=+$E(%,%I,999) I %C?1N D INTLIT Q:%ERR
 I %C="." D %INC
 Q:%C'?1N  I +$E(%,%I,999)<FROM S %ERR=1 Q
 D INTLIT Q
INTLIT I %C'?1N S %ERR=1 Q
 F  D %INC Q:%C'?1N
 Q
STRLIT F  D %INC Q:%C=""  I %C="""" Q:$E(%,%I+1)'=""""  S %I=%I+1
 I %C="" S %ERR=1
 Q
PATCODE I "ACELNPU"'[%C!(%C="") S %ERR=1 Q
 F  D %INC Q:%C=""  Q:"ACELNPU"'[%C
 Q
ALTRN8 I %C'="(" S %ERR=1 Q
 I FIND="?(" D ADD("?(",.FOUND) S FOUND=1
 D %INC,PATATOM Q:%ERR
 F  Q:","'[%C  D %INC,PATATOM Q:%ERR
 I %C'=")" S %ERR=1 Q
 D %INC
 Q
 ;
BINOP ; binary operator (GG^ARJTDIM1)
 S %Z1=""")%'",%Z2="""($+-^%@'." G OPCHK
 ;
MTHOP ; math or relational operator (GG^ARJTDIM1)
 S %Z1=""")%",%Z2="""($+-^%@'." G OPCHK
 ;
UNOP ; unary operator (GG^ARJTDIM1)
 S %Z1=""":<>+-'\/()%@#&!*=_][,"
 S %Z2="""($+-=&!^%.@'" I %C="'" S %Z2=%Z2_"<>?[]"
 G OPCHK
 ;
IND ; "@": indirection (GG^ARJTDIM1)
 D ADD("@",.FOUND)
 I $E(%COM)="F" G ERR
 S %Z1="^?@(%+-=\/#*!&'_<>[]:,.",%Z2="""(+^-'$@%" G OPCHK
 ;
OPCHK ; ensure that the characters before and after the operator are OK
 S %L1=$E(%,%I-1),%L2=$E(%,%I+1) I %L1="'","[]&!<>="[%C S %L1=$E(%,%I-2)
 I %L1="","+-'@"'[%C G ERR ; binary: require before
 I %L1'?1UN,%Z1'[%L1 G ERR ; all: screen before
 F %F="*","]" I %C=%F,%L2=%F S %I=%I+1,%L2=$E(%,%I+1) Q
 I %L2="" G ERR ; all: require after
 I %L2'?1UN,%Z2'[%L2 G ERR ; all: screen after
 I %C="'","!&[]?=<>"'[%L2,%L1?1UN G ERR ; unary ': not binary
 G 1
 ;
1 ; common exit point for all of ^ARJTDIM2
 G GG^ARJTDIM1
 ;
DATA ; glvn arguments of $D,$G,$NA,$O, & $Q functions (FUNC^ARJTDIM1)
 D %INC G ERR:%C="",ERR:%C=")",DATA:"^@"[%C D VAR
 G ERR:"@(,)"'[%C!%ERR,GG1^ARJTDIM1
 ;
VAR ; variables encountered while parsing exprs (DATA, GG^ARJTDIM1)
 N %START S %START=%I-1 I $E(%,%START)="^" S %START=%START-1
 I %C="%" D %INC
 N OUT S OUT=0 F %J=%I:1 S %C=$E(%,%J) D  Q:OUT
 . I ",<>?/\[]+-=_()*&#!':"[%C S OUT=1 Q
 . I %C="@",$E(%,%J+1)="(",$E(%,%START)="@" S OUT=1 Q
 . I %C'?1UN S %ERR=1
 . I %C="^",$D(%(%N-1,"F")),%(%N-1,"F")["TEXT" S %ERR=0,OUT=1
 Q:%ERR
 I %C="@" S %I=%J Q
 S %F=$E(%,%I,%J-1)
 I %F="^",$E(%,%J)'="(" S %ERR=1
 I %F]"",%F'?1U.UN,$E(%,%I-1,%J-1)'?1"%".UN S %ERR=1
 S %I=%J Q
 ;
%INC S %I=%I+1,%C=$E(%,%I)
 Q
 ;
ADD(ELEMENT,FOUND) ; record element found
 ; Input: ELEMENT = code for element found, e.g., "F".
 ; Output: .FOUND(ELEMENT) = increment # times found
 S FOUND=1
 S FOUND(ELEMENT)=$G(FOUND(ELEMENT))+1
 Q  ; end of ADD
 ;
ERR S %ERR=1,%N=0
FINISH G ERR:%N'=0 K %C,%,%F,%F1,%I,%J,%L1,%L2,%N,%T,%Z1,%Z2,%FN,%FZ
Q Q
