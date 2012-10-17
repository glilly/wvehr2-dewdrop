XINDX9  ;SF/RWF - XINDEX SYNTAX CHECKER ;06/24/08  15:39
        ;;7.3;TOOLKIT;**20,27,48,61,66,68,110,121**;Apr 25, 1995;Build 7
        ; Per VHA Directive 2004-038, this routine should not be modified.
        N CH1,EC,OP
        D PARSE S LI=0,AC=255 F %=0:0 S %=$O(LV(%)) Q:%'>0  S LI(%)=0
        Q
        ;LV is a set of Linked Values
PARSE   K LV,LI S (ERR,LI,I)=0,(LL,LV)=1,(OP,CH)="",Q=""""
        ;
PA2     S I=I+1,CH=$E(STR,I),CH1=$E(STR,I+1) G:CH="" PEND
        G E:CH=";"!(CH'?1ANP) I """$()"[CH D QUOTE:CH=Q,FUNC:CH="$",DN:CH="(",UP:CH=")" G PA2
        I CH="^",CH1="$" D SSVN G PA2
        I CH="^",I=LL G PA2:CH1'="[" S I=I+1,X=$E(STR,LL,I) D ADD S LL=I+1 G PA2
        I CH?1A!(CH="%") D VAR G PA2
        I CH?1N D NUM G PA2
        S:"+-#'/*_&![]<>?"[CH OP=CH
        I CH="?",",!#"'[$E(STR,I-1) D AR,PAT G PA2
        I CH=",",CH1=":" D E^XINDX1(21) ;P121
        I CH?1P D  ;Check for dup operators
        . D AR
        . Q:(CH_CH1="]]")
        . I ((CH=CH1)&(",_/\[]&|"[CH))&($$FNC()'="$$") D E^XINDX1(21) ;p110
        G PA2
        ;End of parse
PEND    D AR,E^XINDX1(5):LV>1,E^XINDX1(21):($G(LV(1,1))=",") ;LV>1 means mis-match ()
        Q
        ;
DN      D STR S X=CH D ADD,NEW S LI(LV)=LI,LV=LV+1 S:'$D(LI(LV)) LI(LV)=0 S LI=LI(LV),LI(LV-1,1)=LI
        Q
UP      I LV<2 D E^XINDX1(5) Q
        D STR S EC=LI-LI(LV-1,1),X=$C(10) D ADD,NEW S LI(LV)=LI,LV=LV-1,LI=LI(LV)
        S X=EC D ADD S X=CH D ADD I CH1]"",",_=+-*/\#'):<>[]?&!@"'[CH1 D E^XINDX1(43)
        Q
NEW     S LL=I+1
        Q
AR      D STR S X=CH D ADD,NEW Q
STR     S X=$E(STR,LL,I-1) Q:'$L(X)  ;Drop into ADD
ADD     S LI=LI+1,LV(LV,LI)=X Q
        ;
FNC(NEW)        ;Sets or returns the current function
        I $D(NEW) S LV(LV+1,"FNC",$G(LI(LV))+1)=NEW Q
        N W S W=+$S($D(LV(LV,"FNC",LI)):LI,$O(LV(LV,"FNC",LI)):$O(LV(LV,"FNC",LI)),1:$O(LV(LV,"FNC",LI),-1)) ;patch 119
        Q $G(LV(LV,"FNC",W))
        ;
OP(NEW) ;Sets or returns the current operator
        I $D(NEW) S LV(LV,"OP",LI)=NEW Q
        N W S W=+$S($D(LV(LV,"OP",LI)):LI,1:$O(LV(LV,"OP",LI),-1))
        Q $G(LV(LV,"OP",W))
        ;
QUOTE   F I=I+1:1 S CH=$E(STR,I) Q:CH=""!(CH=Q)
        I $E(STR,I+1)=Q S I=I+1 G QUOTE
        I OP'="?",$E(STR,I+1)]"","[]()<>\/+-=&!_#*,:'|"'[$E(STR,I+1) D E^XINDX1(46) Q
        Q:CH]""  D E^XINDX1(6) Q
GVAR()  ;EF get var
        N % D VAR S %=$E(STR,LL,I),LL=I+1
        Q %
VAR     F J=I+1:1 S CH=$E(STR,J) Q:CH'?1AN
        S I=J-1 D SUM("V")
        Q
NUM     F J=I+1:1 S CH=$E(STR,J) Q:"0123456789."'[CH!(CH="")
        I CH="E" S CH=$E(STR,J+1) I CH?1N!("+-"[CH) S I=J G NUM
        I CH]"",CH'?1P S ERR=53 D ^XINDX1
        S I=J-1 D SUM("N")
        Q
INC     S I=I+1,CH=$E(STR,I)
        Q
FUNC    ;Functions and special var's.
        D INC S X=CH,S=$$GVAR() G EXT:S["$$",PKG:S["$&",SPV:CH'="("
        S S=$$CASE($E(S,2,11)),F1=$G(IND("FNC",S)) I '$L(F1) D E^XINDX1(3) S F1=S G FX
        I "ZV"[X S ERR=$S("Z"[X:31,1:27) D ^XINDX1
FX      S X="$"_F1,CH="" D FNC("$F"),ADD,SUM("F") Q
SPV     S X=S D FNC("$V"),ADD,SUM("V") S X=$E(S,2,9),CH=""
        I $E(S,2)="Z" D E^XINDX1(28) Q
        I '$D(IND("SVN",X)) D E^XINDX1(4)
        Q
EXT     ;EXTRINSIC
        S X=S,CH="" D FNC("$$"),ADD,SUM("V") Q
SSVN    ;Error 54 access for Kernel only
        D INC S X=$$GVAR() I '$D(IND("SSVN",$E(X,3,99))) D E^XINDX1(4) Q  ;Need new #
        D E^XINDX1(54),ADD,SUM("V") Q
PKG     ;External Function
        S J=$F(STR,"(",I),I=J-2,X=S_$E(STR,LL,I),LL=J-1,CH=""
        D ADD,E^XINDX1(55) ;Not standard VA
        Q
E       D E^XINDX1(11)
        Q
PAT     N PC S PC=0
        F I=I+1:1 S CH=$E(STR,I) D PATQ:CH=Q,PATD:CH="(",PATU:CH=")",PATC:CH="," I CH=""!(CH'?1N&("ACELNPUacelnpu."'[CH)) Q
        I PC D E^XINDX1(5)
        S I=I-1 I ":),@+-_*/\!&'"'[CH D E^XINDX1(16),SEP Q
        Q
        ;Quote in Pattern
PATQ    F I=I+1:1 S CH=$E(STR,I) Q:CH=""!(CH=Q)
        D:CH="" E^XINDX1(6) S I=I+1,CH=$E(STR,I) G:CH=Q PATQ
        Q
PATD    S PC=PC+1,CH="." ;p110 Start Alt.
        Q
PATU    I 'PC,LV>1 S CH="" Q  ;End
        S PC=PC-1,CH="." ;p110 End Alt.
        Q
PATC    I PC<1 Q  ;
        S CH="." ;p110 Comma in Alt.
        Q
PAREN   F I=I+1:1 S CH=$E(STR,I) Q:CH=""!(CH=")")
        D:CH="" E^XINDX1(5) S CH="."
        Q
SEP     ;Find sep
        Q
SUM(P)  ;Build summry line
        S LV(LV,"S")=$G(LV(LV,"S"))_P
        Q
CASE(%) ;UpperCase
        Q $TR(%,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        ;
TEST    S STR=$E($T(TEST+2),4,999) D XINDX9
        Q
        ;;NUMVAL?.1(1"+",1"-")1(1.N.1".".N,.N.1"."1.N).1(1"E".1(1"+",1"-")1.N)
