XPDCOMF ;SFISC/GFT/MSC - COMPARE FILES ;08/14/2008
        ;;8.0;KERNEL;**506,539**;Jul 10, 1995;Build 11
        ; Per VHA Directive 2004-038, this routine should not be modified.
        ;DI1 & DI2 are left & right roots
        ;DIFLAG[1 -->compare files   [2-->compare entries   ["L" --> IGNORE EXTRA ENTRIES ON RIGHT SIDE
        ;DITCPT is array of TITLES, called by reference
EN(DI1,DI2,DIDD,DIFLAG,DITCPT)  ;
N       I '$D(@DI1),'$D(@DI2) Q
        N I,DIR,DID,W,DIL,DIN1,DIN2,DIV1,DIV2,DIGL,DIDDN,DIO,DIV,DIT,DIOX,DITM,DIN,D1,D2
        K DIRUT
        S DIL=+DIFLAG
        I '$D(DITCPT(1)),$G(DITCPT)'>DIL D
        .I DIDD S DITCPT(1)="ENTRIES IN FILE #"_DIDD_" ("_$P($G(^DIC(DIDD,0)),U)_")"
        .E  S X="" D  S DITCPT(1)="DATA DICTIONARY #"_$QS(DI2,1)_" ("_X_")"
        ..S I=$NA(@DI1,1) I '$D(@I@(0,"NM")) S I=$NA(@DI2,1)
        ..F  S X=X_$O(@I@(0,"NM",0)) Q:'$D(@I@(0,"UP"))  S X=X_" SUBFIELD" Q
        ;
KILL    S DIV=$D(^DD(DIDD,.001)),(DIOX,U)="^",IOM=$G(IOM,80) F  S X=$O(^UTILITY("DITCP",$J,DIL)) Q:$D(DIRUT)!'X  K ^(X)
        I '$D(@DI1) D  Q
        .S D1="{Missing}" I '$D(@DI2) S D2="{Also Missing}" D WB Q
        .I DIL#2 S D2="" D WB Q
        .S DIN2=$QS(DI2,$QL(DI2)),DIGL=0,DIN=1 D RIGHT(DI2)
        I '$D(@DI2) D  Q
        .I DIL#2 S D1="",D2="{Missing}" D WB Q
        .S DIGL=0,DIN=1,^UTILITY("DITCP",$J,"X1",DIDD,$QS(DI1,$QL(DI1)))=$P(@DI1@(0),U) G END
        I 'DIDD,DIL=1 D
        .N P,DITCPL F X=1,2 S Y=@("DI"_X),P=1,%="" D  S P(X)=P-1
        ..F  S %=$O(@Y@(0,"ID",%)) Q:%=""  S A=$S(+%=%:%,1:+$P(%,"WDI",2)) S:$D(@Y@(A,0))=1 DITCPL(X,P)=$S(A:$P($G(@Y@(A,0)),U),1:%_" (Display only)"),P=P+1
        .I DIFLAG'["L"!$D(DITCPL(1)) D DITCPL("IDENTIFIERS")
        .F P="DIC","ACT" K DITCPL M DITCPL(1,1)=@DI1@(0,P),DITCPL(2,1)=@DI2@(0,P) I DIFLAG'["L"!$D(DITCPL(1)) D DITCPL($S(P="DIC":"SPECIAL LOOKUP",1:"POST-SELECTION ACTION"))
S       I DIL#2 S DIN1=$O(@DI1@(0)) K ^UTILITY("DITCP",$J,DIL) G ENTRY  ;WE ARE AT ROOT OF A (SUB)-FILE  FIND 1ST ENTRY ON LEFT SIDE
        S (DIN1,DIN2)=-1
        I DIL'<DIFLAG D  ;Build a header for this Entry
        .N D,O S D=$G(DIDD(DIL),DIDD),O=$G(@DI2@(0)) I D-.1 S O=$P(O,U,1,D=.11+1) ;For INDEX, take FILE + NAME field
        .I 'D S O="FIELD: "_O
        .E  S O=$O(^DD(D,0,"NM",0))_": "_$$EXT(O,.01,2) I D=.4!(D=.401)!(D=.402) S D=$P($G(@DI1@(0)),U,4) S:D O=O_" (File "_D_")"
        .I DIV S O=O_" (#"_$QS(DI2,$QL(DI2))_")"
        .S DITCPT(DIL)=O
        G INPUT:DIDD=.402,SORT:DIDD=.401,PRINT:DIDD=.4
GET2D   S DIN1=$O(@DI1@(DIN1)),DIN2=$O(@DI2@(DIN2))
        ;NOW CHECK IF WE'RE AT THE SAME NODE ON BOTH SIDES
NEXTD   G END:$D(DIRUT) I DIN1=DIN2 G UP:DIN1="",D2:$D(@DI2@(DIN2))>9 S DIV2=@DI2@(DIN2),DIV1=@DI1@(DIN1) G GET2D:DIV2=DIV1 S DIN="",DIGL=DIN1 D  G GET2D
        .F  S DIN=$O(^DD(DIDD,"GL",DIGL,DIN)) Q:DIN=""!$D(DIRUT)  D
        ..I 'DIN S %X=+$E(DIN,2,9),%Y=$P(DIN,",",2),D2=$E(DIV2,%X,%Y),D1=$E(DIV1,%X,%Y)
        ..E  S D1=$P(DIV1,U,DIN),D2=$P(DIV2,U,DIN) I DIN=2 S:DIDD=0 D1=$TR(D1,"a"),D2=$TR(D2,"a") I DIDD=.4031 D BLOCK(D1) ;SPECIFIER OR HEADER BLOCK
        ..I D1'=D2 D:D1]""!(DIFLAG'["L") DIO12($$TITLE) Q
        .I DIGL=0,'DIDD,'$D(DIRUT) S D1=$P(DIV1,U,5,99),D2=$P(DIV2,U,5,99) Q:D1=D2  D DIO12($S($P(DIV1,U,2)["C":"COMPUTED EXPRESSION",1:"INPUT TRANSFORM")) Q
        D X G END:$D(DIRUT),NEXTD
        ;
D2      G ENTRY:DIL#2 S Y=$O(^DD(DIDD,"GL",DIN1,0,0)) ;DOWN TO A MULTIPLE FIELD
        I Y,$D(^DD(DIDD,+Y,0)) S Y=$P(^(0),U,2) I Y]"",Y-.15,$D(^DD(+Y,.01,0)) G WP:$P(^(0),U,2)["W" D DN S DIDD=+Y G S
        G GET2D
        ;
WP      S X=$P(^(0),U),%Y=0
        F %X=0:0 S %X=$O(@DI1@(DIN1,%X)) Q:$D(^(+%X,0))[0  S I=^(0),%Y=$O(@DI2@(DIN2,%Y)) G WPD:$G(^(+%Y,0))'=I ;IS EVERY LINE IDENTICAL?
        G GET2D:'$O(@DI2@(DIN2,%Y))
WPD     D SUBHD W !?IOM-$L(X)\2,X,"..."
        G GET2D
        ;
        ;^UTILITY("DITCP",$J,"X1",DIDD,DIN1) = new entry
        ;^UTILITY("DITCP",$J,"X2",DIDD,DIN1) = KIDS will delete
ENTRY   S DIGL=0,DIN=1 G NEXTENT:'$D(@DI1@(+DIN1,0)) S X=$P(^(0),U)
        ;check if we are comparing to KIDS
        I $E(DI1,1,12)="^XTMP(""XPDI""" D  G NEXTENT:Y
        .;check KIDS action,(0,3)=continue processing
        .S Y=+$G(@DI1@(+DIN1,-1)) I Y=3!'Y S Y=0 Q
        .;delete: save & goto next entry
        .I Y=1 S ^UTILITY("DITCP",$J,"X2",DIDD,DIN1)=X
        .Q
        I DIDD=.11,$G(DITCPIF),DITCPIF-X G NEXTENT ;Skip INDEXes not for this DD
        I DIDD=.4032 D  D BLOCK(X) G NEXTENT
        .N V S V=$$EXT(X,.01,1) I V]"" S V=$O(@($$NS(2)_"DIST(.404,""B"",V,0)")) I V S X=V
        .S ^UTILITY("DITCP",$J,DIL,X)=""
        S DIV=$D(^DD(DIDD,.001)) G UP:DIDD=.4032!(DIDD=19.01) ;for now, give up matching BLOCKS or MENUS
        I DIDD=.1 S DIN2=+DIN1,X=@DI1@(DIN1,0) G NEW:'$D(@DI2@(DIN2,0)),NEW:^(0)'=X,OLD ;CROSS-REFERENCE matches on entire 0 node
BIX     I $P($G(@DI2@(DIN1,0)),U)=X S DIN2=DIN1 G OLD:$$MATCH,NEW:DIV
        I $P(^DD(DIDD,.01,0),U,2)["P" S MSCP=$$EXT(X,.01,1) F DIN2=0:0 S DIN2=$O(@DI2@(DIN2)) G NEW:DIN2'>0  I $$EXT($P($G(^(DIN2,0)),U),2)=MSCP G OLD:$$MATCH
        S DIN2=0 I '$D(^DD(DIDD,0,"IX","B",DIDD,.01)) F  S DIN2=$O(@DI2@(DIN2)) G NEW:DIN2'>0 I $P($G(^(DIN2,0)),U)=X G OLD:$$MATCH
BI      S DIN2=$O(@DI2@("B",X,DIN2)) I 'DIN2 S:$L(X)>30 DIN2=$O(@DI2@("B",$E(X,1,30),DIN2)) G NEW:'DIN2
        I $D(@DI2@(DIN2,0)),$P(^(0),X)="" G OLD:$$MATCH ;COMPARE BY NAME
        G BI
        ;
NEW     S ^UTILITY("DITCP",$J,"X1",DIDD,DIN1)=X ;WILL SHOW EXTRA ENTRY ON LEFT SIDE
NEXTENT S DIN1=$O(@DI1@(DIN1))
N2      I DIN1 G ENTRY
        I DIFLAG'["L" F DIN2=0:0 S DIN2=$O(@DI2@(DIN2)) Q:'DIN2  Q:+DIN2'=DIN2  D  Q:$D(DIRUT)  ;Print extras on right
        .I '$D(^UTILITY("DITCP",$J,DIL,DIN2)) D RIGHT($NA(@DI2@(DIN2)))
        G END:$D(DIRUT),UP
        ; 
RIGHT(X)        Q:'$D(@X@(0))#2  I DIDD=.11,$G(DITCPIF),DITCPIF-^(0) Q
        D XTRAM($P(^(0),U,1,$S(DIDD=.1:99,1:1)),2) Q  ;If X-REF, compare entire node
        ;
        ;DID=title, X: 1=left,2=right, P=prefix to title
XTRAM(DID,X,P)  Q:DIDD=.15  ;FORGET TRIGGERED-BY
        F I=DIL+(DIL#2):1 K DITCPT(I) I $O(DITCPT(I))="" Q  ;S:$G(DITCPT)>(I-1) DITCPT=I-1 B:DIDD=8994  Q
        I DIDD=.11 S DID="@DI"_X_"@(DIN"_X_",0)",DID=$P(@DID,U,2,3)
        S DIDDN=$S(DIDD:$O(^DD(DIDD,0,"NM","")),1:"FIELD")_$S(DIV:" #"_@("DIN"_X),$D(^DIC(DIDD)):"",1:" Multiple")_": ",Y=^DD(DIDD,.01,0)
        S:$G(P)]"" DIDDN=P_DIDDN
        D DIT,DIO
        Q
        ;
        ;
        ;
        ;
MATCH() I DIV,DIN1'=DIN2 Q 0 ;DO ENTRIES MATCH?  NOT IF NUMBERS DON'T AND IT'S NUMBER-MEANINGFUL
        I $D(^UTILITY("DITCP",$J,DIL,DIN2)) Q 0 ;We already matched this one
        I DIDD=.11 Q '$$MISMATCH(.02) ;INDEX must match on NAME
        I DIDD=.403 Q '$$MISMATCH(7) ;FORM must match on PRIMARY FILE
        I DIDD=.4!(DIDD=.401)!(DIDD=.402) Q '$$MISMATCH(4) ;TEMPLATES must match on FILE
        I DIDD=19 Q 1 ;OPTION matches on NAME alone
        S DITM=.01
ID      S DITM=$O(^DD(DIDD,0,"ID",DITM)) I DITM="" Q 1
        S I=DITM S:I?1"W"1.NP I=$E(I,2,99) I $$MISMATCH(I) Q 0 ;MATCH EACH NON-NULL IDENTIFIER
        G ID
        ;
MISMATCH(I)     K B S A=$P($G(^DD(DIDD,I,0)),U,2) I A=""!(A["P")!(A["V") Q 0 ;DON'T TRY TO MATCH POINTERS
        D  Q:W="" 0 S B=W Q:'$D(^DD(DIDD,I,0)) 0 D  Q:W="" 0 Q W'=B ;If two non-null values aren't equal it's a mismatch
        .S A=$P(^(0),U,4),%=$P(A,";",2),W=$P(A,";"),A=$S($D(B):DI2,1:DI1) I W?." " S W="" Q
        .I $D(@A@($S($D(B):DIN2,1:DIN1),W))[0 S W="" Q
        .I % S W=$P(^(W),U,%)
        .E  S W=$E(^(W),+$E(%,2,9),$P(%,",",2))
        .S:W?.E1L.E W=$$UP^DILIBF(W)
        ;
OLD     S ^UTILITY("DITCP",$J,DIL,DIN2)="" ;Remember that we found DIN2 as a match
        D DN G S
        ;
        ;
DN      S DIDD(DIL)=DIDD
        N X,%X F X=1,2 S %X=@("DIN"_X),(W,W(X,DIL))=@("DI"_X),W=$NA(@W@(%X)),@("DI"_X)=W  ;ADD A SUBSCRIPT
        S DIL=DIL+1 Q
        ;
UP      ;
        G END:'$D(W(2,DIL-1))
        S DIN1=$O(@DI1) I DIL#2=0 S:$G(DITCPT)>DIL DITCPT=DIL D U G N2
        D LEFT Q:$D(DIRUT)  S DIN2=$O(@DI2),DIDD=DIDD(DIL-1)
        D U G NEXTD
U       S (DIL,Y)=DIL-1,DI1=W(1,Y),DI2=W(2,Y)
        Q
        ;
        ;
2       ;
X       G XTRA1:DIN2="",XTRA2:DIN1="" I +DIN1=DIN1 G XTRA1:+DIN2'=DIN2!(DIN2>DIN1),XTRA2
        G XTRA2:+DIN2=DIN2!(DIN1]DIN2)
XTRA1   S X=1,DIGL=DIN1
        D XTRA S DIN1=$O(@DI1@(DIN1)) Q
XTRA2   S X=2,DIGL=DIN2 D:DIFLAG'["L" XTRA S DIN2=$O(@DI2@(DIN2)) Q
        ;
XTRA    S DIR="@DI"_X_"@(DIGL)" I $D(@DIR)<9 S DIN="",DIV=@DIR G GL
        S I=$O(^(DIGL,0)) Q:'I  S I=$O(^(I)),DIN=$O(^DD(DIDD,"GL",DIGL,0,0)) Q:$D(^DD(DIDD,+DIN,0))[0
        S DIDDN=$P(^(0),U)_$S($P(^DD(+$P(^(0),U,2),.01,0),U,2)["W":"...",1:" Multiple"_$E("s",I>0)),(DID,DIT)="" D DIO S DIOX=0 Q
        ;
GL      S DIN=$O(^DD(DIDD,"GL",DIGL,DIN)) Q:DIN=""  S Y=$O(^(DIN,0)) G GL:'$D(^DD(DIDD,+Y,0)) S DIO=$P(^(0),U)_": "
        I DIN S DID=$P(DIV,U,DIN) G:DID="" GL:$P(DIV,U,DIN,999)]"",Q
        E  S DID=$E(DIV,+$E(DIN,2,9),$P(DIN,",",2)) Q:DID?." "
        S DIDDN=$$TITLE G GL:DIDDN="" S DIDDN=DIDDN_": "
        D DIO G GL:'$D(DIRUT)
END     D LEFT Q:$D(DIRUT)
        I 'DIDD,DIFLAG#2 N DITCPIF,DIDD D  G ENTRY ;INDEXES for File #DITCPIF
        .S DITCPIF=$QS(DI1,1),DIDD=.11,DI1=$NA(@DI1,0)_"(""IX"")",DI2=$NA(@DI2,0)_"(""IX"")",(DIN1,DIN2)=0
Q       Q
        ;
        ;
        ;
LEFT    ;display left side; "X1" subscript, these are new records
        N DIN1
        F DIN1=0:0 S DIN1=$O(^UTILITY("DITCP",$J,"X1",DIDD,DIN1)) Q:'DIN1  D XTRAM(^(DIN1),1,"*ADD* ") K ^UTILITY("DITCP",$J,"X1",DIDD,DIN1) Q:$D(DIRUT)
        ;"X2" subscript, these are KIDS delete records
        Q:'$D(^UTILITY("DITCP",$J,"X2",DIDD))
        F DIN1=0:0 S DIN1=$O(^UTILITY("DITCP",$J,"X2",DIDD,DIN1)) Q:'DIN1  D XTRAM(^(DIN1),1,"*DELETE* ") K ^UTILITY("DITCP",$J,"X2",DIDD,DIN1) Q:$D(DIRUT)
        Q
        ;
        ;
TITLE() S Y=$$FLDNUM I '$D(^DD(DIDD,+Y,0)) Q "" ;decide whether this FIELD is interesting
        I $O(^(5,0)) Q "" ;Forget TRIGGERED FIELDS! (INTERESTING!)
        I DIDD=.403,Y'>5 Q ""
        I DIDD=19,DIGL\1=99!(Y=3.6) Q ""
        I 'DIDD,Y=50!(DIGL="DT")!(DIGL=8)!(DIGL=8.5)!(DIGL=9)!(Y=1.1) Q ""
        I 'DIDD,Y=.3,$G(DIV1)[":" Q "SET OF CODES" ;INSTEAD OF "POINTER"
        S Y=^DD(DIDD,+Y,0) D DIT Q $P(Y,U)
        ;
FLDNUM()        I DIN]"" Q $O(^DD(DIDD,"GL",DIGL,DIN,0))
        Q .01
        ;
DIT     ;
        S DIT=$P(Y,U,2),I=$P(Y,U,3) Q
        ;
EXT(X,C,MSCSIDE)        I X]"" N Y I C S C=$P($G(^DD(DIDD,C,0)),U,2),Y=X D:$G(MSCSIDE)  D S^DIQ I Y]"" Q Y ;101.41 BOMBED IN $$EXTERNAL^DIDU(DIDD,$$FLDNUM,,X)
        .F  Q:C'["P"  Q:'$D(@($$NS(MSCSIDE)_$P(^(0),U,3)_"0)"))  S C=$P(^(0),U,2) Q:'$D(^(+Y,0))  S Y=$P(^(0),U),C=$P($G(^DD(+C,.01,0)),U,2)
        Q X
        ;
NS(MSCSIDE)     N N S N=@("DI"_MSCSIDE) I $E(N,2)="[" Q $E(N,1,$F(N,"]")-1) ;returns "^" OR "^[NS]"
        Q U
        ;
DIO     ;X=1 MEANS LEFT SIDE, X=2 MEANS RIGHT SIDE
        ;DID=WHAT WE HAVE TO PRINT
        S DIOX=$Y D SUBHD Q:$D(DIRUT)  S DIO=DIDDN_$$EXT(DID,$$FLDNUM,X)
DIO1    ;DIO IS OUTPUT
        I X=1 S DIOX(1)=DIDDN D LF
        Q:$D(DIRUT)
        I X=2 D:$S(DIOX-1:1,'$D(DIOX(1)):1,1:$P(DIO,DIOX(1))]"") LF Q:$D(DIRUT)  W ?IOM\2 K DIOX(1)
        W !,$J("",DIL),$E(DIO,1,IOM\2-DIL-1) S DIO=$E(DIO,IOM\2-DIL,999) I $L(DIO)<$S(X=1:17,X=2:2) W DIO S DIOX=X Q  ;WRITE A LITTLE MORE THAN HALF A LINE
        S DIOX=0 G DIO1
        ;
        ;
DIO12(T)        ;WRITE D1 AND D2 SIDE BY SIDE
        N D,V
        Q:D1=D2!(T="") 
        F D=1,2 D
        .S V="D"_D Q:@V=""
        .S @V=T_": "_$$EXT(@V,$$FLDNUM,D)
        Q:D1=D2  ;EXTERNAL VERSIONS MAY BE SAME
WB      D SUBHD
        F  Q:D1=""&(D2="")  D LF Q:$D(DIRUT)  F D=1,2 S X="D"_D W:D=2 ?IOM\2 W $J("",DIL),$E(@X,1,IOM\2-DIL-1) S @X=$E(@X,IOM\2-DIL,999)
        Q
        ;
        ;
SUBHD   ;
        N Y,L S Y=$O(DITCPT("")) Q:Y=""
        I $G(DITCPT) S L=DITCPT
        E  S L=Y F Y=$G(DIL):-1:Y D LF G Q:$D(DIRUT)
        F  Q:L>$G(DIL)!$D(DIRUT)  D LF Q:$D(DIRUT)  W:$D(DITCPT(L)) ?IOM-$L(DITCPT(L))\2,DITCPT(L) S L=L+1
        K DITCPT S DITCPT=L-1 Q  ;REMEMBER HOW DEEP WE WERE AT LAST OUTPUT
        ;
        ;
LF      W ! Q:$Y+3<IOSL!$D(DIRUT)
        D:$E($G(IOST),1,2)="C-"
        .N DIR,X,Y
        .S DIR(0)="E" W ! D ^DIR S $Y=0
        I '$D(DIRUT) W @IOF
        Q
        ;
INPUT   I $T(GET^DIETED)="" Q
        N DITCPL F DITCPL=1,2 D GET^DIETED($NA(DITCPL(DITCPL)),@("DI"_DITCPL))
        D DITCPL("EDIT FIELDS") G UP
        ;
SORT     I $T(GET^DIBTED)="" Q
        N DITCPL,DHD,DIBTA,DIBT0,MSCS F DITCPL=1,2 D
        .S DIBTA=$NA(DITCPL(DITCPL))
        .S DIBT0=-(DITCPL/10+$J) K ^DIBT(DIBT0) M ^DIBT(DIBT0)=@("@DI"_DITCPL),MSCS(DITCPL)=^DIBT(DIBT0,"O") ;GRAB SORT TEMPLATES INTO NEGATIVELY-NUMBERED ^DIBT NODE!
        .D GET^DIBTED(DIBTA) K ^DIBT(DIBT0)
        D DITCPL("SORT FIELDS")
        K DITCPL M DITCPL=MSCS D DITCPL("SEARCH SPECIFICATIONS")
        G UP
        ;
PRINT   I $T(GET^DIPTED)'["," Q
        N DITCPL,DISH,DHD F DITCPL=1,2 D GET^DIPTED($NA(DITCPL(DITCPL)),@("DI"_DITCPL))
        D DITCPL("PRINT FIELDS") G UP
        ;
DITCPL(H)       D EN^XPDCOML("DITCPL(1)","DITCPL(2)",H)
        Q
        ;
BLOCK(X)        N D S D=DIL+(DIL#2=0)+1 N DIL S DIL=D,DIDD(DIL)=DIDD S:$G(DITCPT)>2 DITCPT=2 D E(.404,$P($G(^DIST(.404,+X,0)),U)) ;compare ScreenMan BLOCKs
        Q
E(XPDI,NAME,DIFL)       N X,N,MSC,S Q:NAME=""!'XPDI
        S MSCF=$G(^DIC(XPDI,0,"GL")) Q:MSCF'?1"^".E  S MSCF=$E($$CREF^DILF(MSCF),2,99)
        F X=1,2 S N=$$NS(X)_MSCF D  S:'S S=-999 S MSC(X)=$NA(@N@(S))
        .F S=0:0 S S=$O(@N@("B",NAME,S)) Q:'S  Q:'$G(DIFL)  Q:XPDI<.4!(XPDI>.402)  Q:$P($G(@N@(S,0)),U,4)=DIFL  ;TEMPLATE FILE# MUST MATCH
        D EN(MSC(1),MSC(2),XPDI,$G(DIL,2),.DITCPT)
        Q
