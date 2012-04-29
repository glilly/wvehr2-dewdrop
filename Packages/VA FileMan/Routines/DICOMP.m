DICOMP ;SFISC/GFT-EVALUATE COMPUTED FLD EXPR ;29APR2003
 ;;22.0;VA FileMan;**6,76,114,118**
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S DICOMP=$G(DICOMP) N DLV,K S K=0 F DLV=0:1 G A:'$D(J(DLV+1))
EN1 ;
 S K=0 F  S DLV=K,K=$O(I(K)) G A:K="",A:$D(J(K))[0!($D(I(K\100*100))[0)
EN ;
 S DLV=+DICOMP
A N DICO,DPUNC,DLV0,DIM,DIMW,DG,DBOOL,DICV,V,T,DICN,DICF,DIC,DATE,DPS,M,W,DICOMPQI,D,%,%Y,DS,DZ,%DT ;Don't NEW the variable A!
 I DICOMP'["?",'$D(DIQUIET) N DIQUIET S DIQUIET=1
K K K S K=0 I DLV F I=0:100 Q:I>DLV  S K=K+1,K(K)="",K(K,1)=I
 I '$D(DQI) N DQI S DQI="Y(",DICOMPQI=1
 S I=DLV F  S I=$O(J(I)),DICO(1)=DLV Q:I=""  K:DLV I(I),J(I)
 S DPUNC=",'+-():[]!&\/*_=<>",DLV0=DLV\100*100,I=X,DIMW="" K X
 S DIC(0)="ZFO",(M,DPS)=0,DICO=I,DICO(1)=DLV,DICO(0)=DLV\100*100 F %=0:100 Q:'$D(J(%))  S DG(%)=%
TOOEASY G 0:" "[I!(+I=I)!(I'?.ANP)!(I?."?")!($E(I,$L(I))=":")
G D I I X?.NP G:X="" N:I]"",^DICOMP1 I +X=X,X<1700!'$D(DATE(K-1))!'$G(DBOOL) G N:W'=":",N:$D(DPS($$NEST,"$S"))
 G E:$L(X)>30,FUNC:W="(",N:X?1"$"1U
V I $D(DICOMPX(X))#2 D DATE^DICOMP0:$D(DICOMPX(X,"DATE")) S T=X,X=DICOMPX(X) G N:'$D(DICOMPX(T,U)) S T=DICOMPX(T,U),DICN=$P(T,U,2),T=+T,Y(0)=^DD(T,DICN,0),D=$P(Y(0),U,2) D S^DICOMP0 G N
E K Y D ^DICOMP0 G N:+X=X,N:$D(Y),0:$D(DICO("BACK"))-10 S X=DICO,DLV=DICO(1),DICO("BACK")=1 S:$G(DICOMPX)]"" DICOMPX="" G K
N ;
 I X]"" S K=K+1,K(K)=X
 S I=$E(I,M,999),M=0 G G:$F(DPUNC,W)<2
 I W=":",'$D(DPS($$NEST,"$S")) S I=$E(I,2,999) D I,M^DICOMPX,M^DICOMPW:$D(X) S W="" G N:$D(X),0
 S X=W,W="",M=2 G N:X=""
 G DPS:X=")",C:",:"[X,0:"+-'"[X&'$L($E(I,M,999)) I X="(" D ST G N
 S DBOOL="><]['=!&"[X,Y="[]!&/\_><*="
NOT I X="'" S %=$E(I,2) I "_"""[% G 0
 G N:Y'[X
BINOP I ")"'[$E(I_W,M),$G(K(K))]"",'$D(K(K,2)),'$F($TR(DPUNC,")'"),K(K)),$F(Y,W)<2 D:X="_"  G N:K(K)'="'" S K(K)="'"_X,X="" G N:DBOOL
CONCAT .I $D(DATE(K)) K DATE(K) S X=" S Y=X X ^DD(""DD"") S X=Y_"
0 G 0^DICOMP1
 ;
I I $A(I,M+1)=34 S M=$F(I,"""",M+2)-1 G I:M>0 S W=0,M=999,X=U Q
MR F M=M+1:1 S W=$E(I,M) Q:DPUNC[W
 S X=$E(I,1,M-1) Q
 ;
C I $D(DPS($$NEST,"SETDATA")) D  G Q^DICOMP1:'$D(X)
 .N DIFILE,DIAC S DIAC="WR",DIFILE=J(DLV0) D ^DIAC
 .I $P($G(^DD(J(DLV0),0,"DI")),U,2)["Y"!(J(DLV0)=200&($P($G(^DIC(200,0)),U)="NEW PERSON"))!'DIAC W:DICOMP["?" "   "_$$EZBLD^DIALOG(405,J(DLV0)) K X Q
 .S %Y=+$P(DICOMPX,U,2),%=$P($G(^DD(+DICOMPX,%Y,0)),U,2),DIAC=$G(^(9)) I %["C"!%!(%="")!(DIAC]""&(DUZ(0)'="@")&($TR(DIAC,DUZ(0))=DIAC)) N XD S XD("FILE")=J(DLV0),XD("FIELD")=%Y W:DICOMP["?" "  "_$$EZBLD^DIALOG(710,.XD) K X Q
 .S DICF="" F %=DLV0:1:DLV S DICF="_D"_(%#100)_"_"","""_DICF
 .S DPS($$NEST)=" N DIFDA S DIFDA("_J(DLV0)_","_$E(DICF,2,999)_","_%Y_")=X D FILE^DIE("""",""DIFDA"") S X="""""
 S DICF=X D DG S K(K+1,2)=0
 I $O(DPS($$NEST,"$"))["$" S DPS($$NEST)=DPS($$NEST)_Y_DICF G N
 G 0:'$D(W($$NEST)) S (W,W($$NEST))=W($$NEST)-1 K:W<2 W($$NEST) S DPS($$NEST)=" S X"_W_"="_Y_DPS($$NEST) G N
 ;
DPS I $D(DPS(DPS,"ST")) D DPS^DICOMPW S:X]"" K=K+1,K(K)=X G DPS
 I DPS D DPS^DICOMPW G N:'$D(W(DPS+1))
 G 0
 ;
FUNC S Y=$O(^DD("FUNC","B",X,0)) S:Y="" Y=-1 I '$D(^DD("FUNC",Y,0)),X'?1N.N2A,X'?1"$"1U G V
 I Y=90!(Y=91)!(Y=92) D PRIOR^DICOMPZ G N:$D(Y),0
 S DICF=X,DBOOL=$G(DBOOL,0) D ST I $D(^DD("FUNC",Y,1)) D 1 G B
 I DICF'?1"$"1U.U D ^DICOMPY S W="" G DPS:DPS,0
 S DPS(DPS,DICF)=DPS(DPS),DPS(DPS)=" S X="_DICF_W
B S M=M+1,W="" G 0:$E(I,M)=")",N
 ;
2 ;
 D ST
1 S DPS(DPS,DICF)="",DPS(DPS)=" "_^(1)_DPS(DPS)_" S X=X" I $D(^(2)) S %=$P(^(2),U) I %]"" S DPS(DPS,%)=""
 I DPS=1,$G(^(10))]"" S DPS(^(10))=""
 S %=$G(^(3),0) D:%'?.N
 .S %=1 F %Y=M+1:1 S Y=$E(I,%Y) Q:")"[Y  S:Y="," %=%+1
 .S DPS(DPS)=" K X"_%_DPS(DPS)
 S:%>1 W(DPS)=% Q
 ;
ST ;
 N Y
 S DPS=DPS+1,%="",Y=K I $D(DBOOL) S DPS(DPS,"BOOL")=DBOOL K DBOOL
S I 'Y S X="",DPS(DPS)=$P(" S X="_%_"X",U,%]"") Q
 I K(Y)="" S Y=Y-1 G S
 I "'"[K(Y)!(K(Y)="+"),$S(Y=1:1,1:K(Y-1)?1P!(K(Y-1)="")) S %=K(Y)_%,K=K-1,Y=Y-1 G S
 D DG S DPS(DPS)="" I K(K)?1P!(K(K)?2P) S DPS(DPS)=" S Y="_%_"X,X="_Y_",X=X",DPS(DPS,U)=K(K)_"Y",K=K-1
 S:$D(DATE(K)) DPS(DPS,"DATE")=1
 S K(K+1,2)=0 Q
 ;
NEST() N I
 F I=DPS:-1 Q:'$D(DPS(I,"ST"))
 Q I
 ;
DG S Y=$$DGI,X=" S "_Y_"=$G(X)"
 Q
DGI() S DG(DLV0)=$G(DG(DLV0))+1 Q DQI_DG(DLV0)_")"
 ;
EXPR(FILE,DICOMP,I,SUBS) ;I=input expression; DICOMP=flags
 S X=$G(DUZ),DICOMP=$G(DICOMP)
 N DUZ,J,DICOMPX,DICOMPW,DQI,DA,DICMX S DUZ=X,DUZ(0)="@" ;pretend he's programmer
 K X S X=I
 I DICOMP["m" S DICMX="X DICMX" ;Flag 'm' = allow returning multiple values
 S DICOMPW="",DA="X("
 S DICOMPX="",DICOMP=$TR(DICOMP,"F")_"X" ;(Why strip out "F"?)  We don't allow MUMPS
 M DICOMPX=SUBS ;list of terms to substitute
 D IJ^DIUTL(FILE) S FILE=$O(I(""),-1) I FILE S DICOMP=FILE_DICOMP ;FILE may be down a level or 2
 K SUBS,FILE
 D DICOMP
 I '$D(X) Q
 S X("USED")=$G(DICOMPX)
 Q
