XINDX2  ;ISC/REL,GRK,RWF - PROCESS "GRB" ;4/2/08  16:35
        ;;7.3;TOOLKIT;**20,27,48,110**;Apr 25, 1995;Build 11
%       S LINE=GRB,(CM,COM)="" F I=0:0 S STR=$P(LINE,$C(9),1),LINE=$P(LINE,$C(9),2,999),NOA=0 D:STR]"" ARGG Q:LINE']""
        Q
        ;Process argument
ARGG    D ^XINDX9 S I=0,AC=999 F %=0:0 S %=$O(LV(%)) Q:%'>0  S I(%)=0
ARGS    ;Proccess all agruments at this level
        S AC=LI+AC F  Q:AC'>LI  D INC Q:S=""  D ARG
        Q
        ;
ARG     ;Process one argument
        I CH="," D PEEK,E^XINDX1(21):(","[Y)&($$FNC()'="$$") Q
        Q:CH=Q
        I (CH?1A)!(CH="%") D LOC Q
        I CH="^" S LOC="G" G NAK:S="^",EXTGLO:S["[",EXTGLO:S["|",GLO Q
        I CH="$" D FUN Q
        I CH="?" D PAT Q
        I CH="(" D INC S NOA=S D DN,INC Q
        Q
        ;
NAK     S LOC="N"
        G GLO
EXTGLO  D E^XINDX1(50),EG,INC S S=U_S
        G GLO
EG      N GK,LOC S GK="",LOC="L" ;HANDLE EXTENDED GLOBAL
        F  D INC Q:"]"[CH  Q:"|"[CH  D ARG
        Q
GLO     S X=$E(S,2,99) I X]"",S'["^$",X'?1(1U,1"%").7UN D E^XINDX1(12)
        I GK["*",$E(S,1,2)["^%" D E^XINDX1(45)
        I S1="(" S S=S_S1 D PEEKDN S:(Y?1N.NP)!($A(Y)=34)!("^$J^$I^$H^"[(U_Y)) S=S_Y
        D ST(LOC,S) I S1="(" D INC2 S NOA=S D DN,INC
        Q
        ;
LOC     S LOC="L" ;Check variables at end. I S'?1.8UN,S'?1"%".7UN,S'?1.8LN,S'?1"%".7LN D E^XINDX1(11)
        I S1="(" S S=S_S1 D PEEKDN S:(Y?1.N)!($A(Y)=34) S=S_Y
        D ST(LOC,S) I S1="(" D INC2 S NOA=S D DN,INC
        Q
        ;
PEEK    S Y=$G(LV(LV,LI+1)) Q
        ;
INC2    S LI=LI+1 ;Drop into INC
INC     S LI=LI+1,S=$G(LV(LV,LI)),S1=$G(LV(LV,LI+1)),CH=$E(S) G:$A(S)=10 ERR Q
        ;
DN      S LI(LV)=LI,LI(LV,1)=AC,LV=LV+1,LI=LI(LV),AC=NOA
        D ARGS,UP Q
UP      ;Inc LI as we save to skip the $C(10).
        D PEEK D:$A(Y)'=10 ERR S LI(LV)=LI+1,LV=LV-1,LI=LI(LV),AC=LI(LV,1) Q
        ;
PEEKDN  S Y=$G(LV(LV+1,LI(LV+1)+1)) Q
        ;
ERR     D E^XINDX1(43) S (S,S1,CH)="" Q
        S Z=$P(LV(LV+1),$C(9),LI(LV+1),99),Z=$P(Z,$C(10)) W !,"COUNT=",$L(Z,",")
        ;functions
FUN     N FUN S FUN=S G EXT:S["$$",PKG:S["$&",SPV:S1'["(" S NOA=$P(S,"^",2)
        D INC2 I S'>0 D E^XINDX1(43) ;Sit on NOA
        G:FUN["$TE" TEXT
        S Y=1 F Z1=LI(LV+1)+1:1 S X=$G(LV(LV+1,Z1)) Q:$A(X)=10!(X="")  S:X="," Y=Y+1
        I NOA,Y<NOA!(Y>$P(NOA,";",2)) D E^XINDX1(43)
        S NOA=S D DN,INC Q
        ;
TEXT    S Y=$$ASM^XINDX3(LV+1,LI(LV+1)+1,$C(10)) D ST("MK","$T("_$S($E(Y)'="+":Y,1:""))
        I $$VT(Y) D ST("I",Y)
        I Y["^",$$VT($P(Y,"^",2)) N X1,X2 S X1=$P(Y,"^"),X2=$P(Y,"^",2) D ST("X",X2_$S($$VT(X1):" "_X1,1:""))
        D FLUSH(LV+1) Q
        ;special variables
SPV     ;
        I "^$D^$EC^$ES^$ET^$I^$K^$P^$Q^$ST^$SY^"[("^"_X_"^") D ST("MK",X)
        Q
        ;
EXT     ;Extrinsic functions
        I $E(S1)="^" S Y=$E(S1,2,99)_" "_S D INC S S=Y ;Build S and fall thru
        D ST($S(S[" ":"X",1:"I"),S) ;Internal, eXternal
        I S1["(" D INC2 S NOA=S D DN,INC ;Process param.
        Q
        ;
PKG     ;External Package
        D ST("X",S) ;Record External name
        I S1["(" D INC2 S NOA=S D DN,INC ;Process param.
        Q
        ;
PAT     D INC I $E(S)="@" D INC,ARG Q
        F  D REPCNT,PATCODE Q:$E(S)=""
        Q
        ;
REPCNT  F I=1:1 Q:("0123456789."'[$E(S,I))!($E(S,I)="")
        S X=$E(S,1,I-1),S=$E(S,I,999) I ('$L(X))!($L(X,".")>2) S S="" D E^XINDX1(16)
        Q
        ;
PATCODE I $E(S)=Q S I=1 D PATQ S S=$E(S,I,999) S:$L(CH)&(",)"[CH) S=$E(S,2,999) Q
        F I=1:1 Q:("ACELNPUacelnpu()"'[$E(S,I))!($E(S,I)="")
        S X=$E(S,1,I-1),S=$E(S,I,999) I I=1 S S="" D E^XINDX1(16)
        I $E(S)="," S S=$E(S,2,999) ;Pull ',' out of alternation
        Q
        ;
PATQ    F I=I+1:1 S CH=$E(S,I) Q:CH=""!(CH=Q)
        S I=I+1 D:CH="" E^XINDX1(6) S CH=$E(S,I) G:CH=Q PATQ
        Q
        ;
ST(LOC,S)       S:'$D(V(LOC,S)) V(LOC,S)="" I $D(GK),GK]"",V(LOC,S)'[GK S V(LOC,S)=V(LOC,S)_GK
        S GK=""
        Q
        ;
VT(X)   ;Check if a valid label
        Q (X?1A.31AN)!(X?1"%".31UN)!(X?1.31N)
        ;
VA(X)   ;Check if VA Standard label
        Q (X?1U.7UN)!(X?1"%".7UN)!(X?1.8N)
        ;
FLUSH(L)        ;Flush rest of list with this offset
        N I,CH S I=LI(L)+1 F I=I:1 S CH=$G(LV(L,I)) Q:$C(10)[CH  D:CH="(" FLUSH(L+1)
        S LI(L)=I Q
        ;
FNC(NEW)        ;Sets or returns the current function
        I $D(NEW) S LV(LV+1,"FNC",LI)=NEW Q
        N W S W=+$S($D(LV(LV,"FNC",LI)):LI,1:$O(LV(LV,"FNC",LI),-1))
        Q $G(LV(LV,"FNC",W))
        ;
OP(NEW) ;Sets or returns the current operator
        I $D(NEW) S LV(LV,"OP",LI)=NEW Q
        N W S W=+$S($D(LV(LV,"OP",LI)):LI,1:$O(LV(LV,"OP",LI),-1))
        Q $G(LV(LV,"OP",W))
        ;
