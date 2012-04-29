DIPT ;SFISC/XAK,TKW-DISPLAY PRINT OR SORT TEMPLATE ;7/3/96  17:23
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q:'$D(^DIPT(D0,0))  S (DRK,J(0))=$P(^(0),U,4),L=0,DS(1)=0,D(L)="0FIELD",C=",",Q="""",D9="",Y=2
 F DS(1)=0:0 S DS(1)=$O(^DIPT(D0,"F",DS(1))) Q:DS(1)=""  S DY=^(DS(1)) D Y
 D:D9]"" UP F D=2:1 Q:'$D(DS(D))  S X=DS(D) W !?DIWD(D)*2,$S(D=2:"FIRST",1:"THEN")_$S($G(DDXP)=3:" EXPORT ",1:" PRINT ")_$P(DIWD(D),+DIWD(D),2)_": "_X_"//" I '$D(D) K DD
 W ! K DS,DIWD,D,DRK,J S X="" Q
Y ;
 S X=$P(DY,$C(126),1),DY=$P(DY,$C(126),2,99) Q:X=""
 I D9]"" G UP:$P(X,D9,1)]"" S X=$P(X,D9,2,99)
R I X'>0 G 0:$E(X,2)'=C&'X S:+X D9=D9_+X_C,DRK=-X S:X<0 L=L+1,D(L)=L_$P(^DIC(DRK,0),U,1)_" FIELD" G M
 G NC:X'[C S DA=$P(X,C,1) G NC:+DA'=DA
 S:DA<0 DA=-DA G Y:'$D(^DD(DRK,DA,0)) S X=$P(X,C,2,99),DS(Y)=$P(^(0),U,1),%=+X,D=+$P(^(0),U,2),DIWD(Y)=L_$P(^DD(DRK,0),U,1) G Y:'$D(^DD(D,.01,0)),W:$P(^(0),U,2)["W" S DRK=D,D9=D9_DA_C,Y=Y+1,L=L+1,(DIWD(Y),D(L))=L_$P(^DD(D,0),U,1) G R
NC S %=+X,D=DRK_U_% I $D(^DIPT(D0,"DCL",D)) S X=X_$E(^(D),$L(^(D)))
 G Y:'$D(^DD(DRK,%,0))
W S X=$P(^(0),U,1)_$E(X,$L(%)+1,999)
P S DS(Y)=X,DIWD(Y)=D(L),Y=Y+1 G Y
0 S:X?1"0".E X="NUMBER"_$E(X,2,999)
M S %=$F(X,";Z;""") I '% S D=X G P
 S %=%-$L($P(X,";",1)),X=";"_$P(X,";",2,99) F D=%:0 S D=$F(X,Q,D) I ";"[$E(X,D) S X=$E(X,%,D-2)_$E(X,1,%-5)_$E(X,D,999) G P
 ;
UP S DRK=J(0),%=D9,DA=""
DOWN I X[C,+X=$P(X,C,1),$P(D9,DA_+X_C,1)="" S DA=DA_+X_C,%=$P(%,C,2,99),DRK=$S(X'>0:-X,1:+$P(^DD(DRK,+X,0),U,2)),X=$P(X,C,2,99) G DOWN
NUL S D9=DA,DS(Y)="",DIWD(Y)=D(L),L=L-1,Y=Y+1,%=$P(%,C,2,99) G NUL:%]"",R
 ;
DIBT ; DISPLAY SORT FIELDS
 I '$D(^DIBT(D0,0))!'$D(^(2)) S X="" Q
 K DIPP,DPP N DIBTRPT,DIBTOLD,C,D,DCC
 S X=D0,(DJ,DIBTRPT)=1,C=",",D="^DIBT("_D0_",",DCC=$G(^DIC(+$P(^DIBT(D0,0),U,4),0,"GL")) D ENDIPT^DIP11 S X="" K DIBTRPT,DCC
 F DIJ=0:0 S DIJ=$O(DPP(DIJ)) Q:DIJ=""  S DIPP(DIJ)=DPP(DIJ),%=+DPP(DIJ),DJ=DIJ D E1^DIP0 S %X=0 D E2^DIP0
 K DPP,DIJJ F DIJ=0:0 S DIJ=$O(DIPP(DIJ)) Q:DIJ=""  D DJ
 K DIPP,DIJ,DPP,DJ,%X,%Y,C S X="" Q
 ;
DJ W !?DIJ*2-2,$S(DIJ>1:"WITHIN "_DPP(DIJ-1)_", ",1:"")_"SORT BY: "_$P($P(DIPP(DIJ),U,4),"""",1)_$P(DIPP(DIJ),U,3)_$P(DIPP(DIJ),U,5)_"//" S DPP(DIJ)=$P(DIPP(DIJ),U,3)
 I $D(^DD(+DIPP(DIJ),+$P(DIPP(DIJ),U,2),0)) S X=+$P(^(0),U,2) I X,$D(DIPP(DIJ,X)),$D(^DD(X,0)) W !?DIJ*2-2,$P(^(0),U,1)_": "_DIPP(DIJ,X)_"//" K DIPP(DIJ,X)
 F %=0:0 S %=$O(DIPP(DIJ,%)) Q:'%  I $D(DIPP(DIJ,%))#2 W !?DIJ*2-2,$S('$D(^DD(%,0,"UP")):$O(^("NM",0))_" ",1:""),$P(^DD(%,0),U,1)_": "_DIPP(DIJ,%)_"//" S DPP(DIJ)=DIPP(DIJ,%)
 I $D(^DIBT(D0,2,DIJ,"ASK")) W "    (User is asked range)" Q
 Q:'$D(^DIBT(D0,2,DIJ,"F"))&('$D(^("TXT")))
 I $D(^DIBT(D0,2,DIJ,"TXT")) W " ("_^("TXT")_")" Q
 S Y=^("F"),%Y=$S('$D(^("T")):"",^("T")="z":"",1:^("T")) S:Y[".9999" Y=$P(Y,".",1)+1 X:Y?1"2"6N.NP ^DD("DD") S %=$F(Y,"z"),X="     From '"_$S(%:$E(Y,1,%-3)_$C($A(Y,%-2)+1),1:Y)_"'",Y=%Y
 I Y]"" S:Y[".9999" Y=Y\1 X:Y?1"2"6N.NP ^DD("DD") S X=X_"  To '"_Y_"'"
 W X
