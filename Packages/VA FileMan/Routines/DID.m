DID ;SFISC/XAK-LIST DD'S ;2:19 PM  5 Mar 2002
 ;;22.0;VA FileMan;**24,105**;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 D KL,L^DICRW1 I $D(DIC) S (DUB,DIB,DFF)=+Y G O:Y'=+DIB(1),SUB
KL K DIS,DIJS,DHIT,DIB,DINM,DIDX,DIGR,DIDH,BY,DICMX,DIOEND,FLDS
 K DFF,DIFF,DID,DUB,DHD,DIC,DICS,POP,DA,DR,S,F,J,K,Z,W,X,Y,M,G,N,I
 K DIWF,DIPP,DPP,DIMS,DIPQ,DJ,DDL1,DDL2,DDL3,DDLF,DDN1,X1,DDRG,I1
 K DIDRANGE,DIDFLD,DIDTYP
 Q
 ;
SUB S DIC="^DD("_+Y_"," G O:$O(^DD(+Y,"SB",0))'>0 S DIC(0)="AEQZ",DIC("A")="      Select SUB-FILE: ",DIC("S")="I $P(^(0),U,2)" D ^DIC G KL:$D(DTOUT) I Y>0 S (DFF,Y)=+$P(Y(0),U,2) G SUB
 G KL:X[U
O K DIC S:DFF-DUB DIC("S")="I Y-5" S DIC="^DOPT(""DID"",",DIC(0)="AEQ",DIC("B")=1 D ^DIC G KL:Y<0
O1 K DIC S DIC="^DD(DFF,"
 I +Y=3 D  D EN^DIP G KL
 .I $D(^DIC(DFF)) S DIB(1)=$O(^DD($O(^DIC(DIB(1)))),-1)
 .S DIS(0)="I $D(^DD(DFF,D0,0))",DIOEND="G L^DIDC"
 .S DIOBEG="S L=0 I $G(DQI),$D(^UTILITY($J,2)) S ^(1.5)=""W $O(^DD(DIB,0,""""NM"""",0)),"""" """" W:'$D(^DIC(DIB)) """"SUB-"""" W """"FILE """""",^(2)=""X ^(1.5) ""_^(2)"
 I +Y=4,'$D(DIFORMAT) D MOD^DID2 G KL:X[U
 S L=0,FLDS="",BY="@.001" I +Y=5 S (FR,TO)=.01,DHIT="S F(1)=DUB",DHD="W """" D H1^DIDG",DIOEND="D T^DID" G G
 I +Y=8 D  G:DIDTYP=""!(DIDFLD=-1) KL G G
 . S DIDTYP=$$ASKTYP Q:DIDTYP=""
 . S DIDFLD=$$ASKFLD(DFF) Q:DIDFLD=-1
 . S (FR,TO)=.01,DHIT="S F(1)=DFF"
 . S DHD="W """" D IXHEAD1^DID"
 . S DIOEND="D IX^DID"
 I +Y=9 S (FR,TO)=.01,DHIT="S F(1)=DFF",DHD="W """" D KEYHEAD1^DID",DIOEND="D KEY^DID" G G
 S DHIT="D ^DID1",DHD="W """" D ^DIDH",(FR,TO)="",DIOEND="D END^DID"
 I +Y=6 S DHIT="D ^DIDG",DIOEND="D END^DIDG"
 I +Y=2 S DHIT="D ^DIDX",DIDX=0,%=2 I '$D(DIFORMAT) D AH^DIDX G KL:%<1
 I +Y=7 S DHIT="S (X1,X2)=DFF D ^DIDC",DHD="@" S DIOEND="D IOF^DID"
 I "^1^2^4^"[(U_+Y_U),'$D(DIGR) D ASKRANGE(DFF,BY,.FR,.TO) G:FR=-1 KL S DIDRANGE=FR]""
G Q:DIB=0  S DIOEND(1)=DIOEND,DIOEND="D LOOP^DID" D EN1^DIP G KL
LOOP I $D(Y),Y=U Q
 X DIOEND(1) I $D(M),M=U Q
 I IOST?1"C-".E W $C(7) R X:DTIME I X[U!'$T Q
 S DN=1,D0=0,DIB=$O(^DIC(+DIB)) Q:DIB>DIB(1)!(+DIB'=DIB)  S (F(1),DUB,DFF)=DIB,DC="," D ^DIO2 I $D(M),M=U Q
 G LOOP
 ;
END ;
 I $D(^UTILITY($J,"P")) W !!!?6,"FILES POINTED TO",?44,"FIELDS",! D PTR^DIDC
D K ^UTILITY($J,"P") G IOF:DHIT["DIDX"!$G(DIDRANGE)
 D IX I M=U S DN=0 Q
T ;
 S S=0,M=1
T1 S S=S+1 D:$Y+3>IOSL HDR^DIDG Q:M=U
 W !!,$S(S<4:$P("INPU^PRIN^SOR",U,S)_"T TEMPLATE(S):",1:"FORM(S)/BLOCK(S):")
 S DFF="^DI"_$P("E^PT^BT^ST(.403)",U,S),DA=""
 F  S DA=$O(@DFF@("F"_F(1),DA)) Q:DA=""  D  Q:M=U
 . S DUB=0 F  S DUB=$O(@DFF@("F"_F(1),DA,DUB)) Q:'DUB  D  Q:M=U
 .. I $D(@DFF@(DUB,0))#2 S %1=^(0) D TEMPL
 K %1 G Q:M=U,T1:S<4
IOF W:IOST'?1"C".E @IOF Q
 ;
TEMPL I $Y+3>IOSL D HDR^DIDG Q:M=U
 W !,$P(%1,U),?30 G:DFF["DIST" FORM
 S W="",Y=$P(%1,U,2) I Y D DD^%DT W Y
 W ?50,"USER #"_+$P(%1,U,5),?61 I $D(@(DFF_"(DUB,""ROU"")")) W ^("ROU")_$P("*",U,DFF["DIBT")_" "
 I $D(^("H")) S Y=^("H"),%=$L(Y) W:65+%>IOM ! W "   ",?IOM-%-1,$E(Y,1,IOM-4)
 G DES:DFF'="^DIBT"
 I $D(^("DIPT")) W ?55 S Y=" '"_^("DIPT")_"' Print Template always used" W:$X+$L(Y)>IOM ! W ?IOM-$L(Y)-1,Y
 I $D(^(2)) S D0=DUB,DICMX="W !?4,X" X $P(^DD(.401,1620,0),U,5,99)
 F Y=1:1 Q:'$D(^DIBT(DUB,"O",Y,0))  W "  " S %=^(0),D=IOM-$L(%)-5 W:$X>D !?$S(D>55:55,1:D) W %
DES N A1,%1,X S A1=$P($G(@(DFF_"(DUB,""%D"",0)")),U,3) F %1=0:0 S %1=$O(@(DFF_"(DUB,""%D"",%1)")) Q:%1'>0  Q:+A1&(%1>A1)  S X=^(%1,0) W !,?5,X
Q W:DFF["DIBT" ! Q
DT G DT^DIO2
 ;
EN ;
 Q:'$D(DIC)  I 'DIC,$D(@(DIC_"0)")) S DIC=+$P(^(0),U,2)
 Q:'DIC!'$D(^DIC(DIC,0,"GL"))  S (DFF,DUB,DIB,DIB(1))=DIC
 G O:'$D(DIFORMAT) S Y=DIFORMAT I 'Y S Y=$O(^DOPT("DID","B",Y,0))
 Q:Y>9!'Y  G O1
 ;
FORM ;
 S Y=$P(%1,U,5) I Y D DD^%DT W ?30,Y
 W ?50,"USER #"_+$P(%1,U,4)
 ;
 N B,L,P
 S L=1,L(1)=U
 S P=0 F  S P=$O(^DIST(.403,DUB,40,P)) Q:'P  D  Q:M=U
 . Q:$D(^DIST(.403,DUB,40,P,0))[0  S B=$P(^(0),U,2) D:B BLOCK  Q:M=U
 . S B=0 F  S B=$O(^DIST(.403,DUB,40,P,40,B)) Q:'B  D BLOCK  Q:M=U
 S %1=0 F  S %1=$O(@DFF@(DUB,15,%1)) Q:'%1  W:$D(^(%1,0))#2 !?5,^(0)
 W !
 Q
BLOCK ;
 N I
 F I=1:1:L I L(I)[(U_B_U) G BLOCKQ
 S:$L(L)+$L(B)+1>245 L=L+1,L(L)=U S L(L)=L(L)_B_U
 Q:$D(^DIST(.404,B,0))[0  S %1=^(0)
 ;
 I $Y+3>IOSL D HDR^DIDG Q:M=U
 W !?2,$P(%1,U) W:$P(%1,U,2)]"" ?32,"DD #"_$P(%1,U,2)
BLOCKQ Q
 ;
IX ;Print index details
 N DIDPG,DIDFLG
 S DIDPG("H")="W """" D IXHEAD^DID S:M=U PAGE(U)=1"
 D WRLN^DIKCP("",0,.DIDPG) Q:M=U
 I DHIT="S F(1)=DFF" D
 . S DIDFLG=$S(DIDTYP="B":"",DIDTYP="T":"O",1:"FR")_$E("M",'$G(DIDFLD))
 E  S DIDFLG="RM"
 S DIDFLG=DIDFLG_"SL2"_$E("N",$D(DINM)#2)
 D PRINT^DIKCP(F(1),$G(DIDFLD),DIDFLG,.DIDPG)
 Q
 ;
IXHEAD S DC=DC+1 I IOST?1"C".E W $C(7) R M:DTIME S:'$T M=U Q:M=U
IXHEAD1 W:$D(DIFF)&($Y) @IOF S DIFF=1
 W $S("B"[$G(DIDTYP):"INDEX AND CROSS-REFERENCE",DIDTYP="T":"TRADITIONAL CROSS-REFERENCE",1:"NEW-STYLE INDEX")
 W " LIST -- FILE #"_DIB_$S($G(DIDFLD):", FIELD #"_DIDFLD,1:"")
 W ?(IOM-20),$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)_"    PAGE "_DC
 S M="",$P(M,"-",IOM)="" W !,M
 Q
 ;
KEY ;Print keys
 N DIDPG
 S DIDPG("H")="W """" D KEYHEAD^DID S:M=U PAGE(U)=1"
 D WRLN^DIKKP("",0,.DIDPG) Q:M=U
 D PRINT^DIKKP(F(1),"","ML2",.DIDPG)
 Q
 ;
KEYHEAD S DC=DC+1 I IOST?1"C".E W $C(7) R M:DTIME S:'$T M=U Q:M=U
KEYHEAD1 W:$D(DIFF)&($Y) @IOF S DIFF=1 W "KEY LIST -- FILE #"_DIB,?(IOM-20),$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)_"    PAGE "_DC
 S M="",$P(M,"-",IOM)="" W !,M
 Q
 ;
ASKFLD(DIDFILE) ;Ask for a single field
 Q:'$G(DIDFILE) ""
 ;
 N %,D,D0,DA,DDD,DIC,DICR,DIX,DO,DP,DZ,X,Y,DTOUT,DUOUT
 S DIC="^DD("_DIDFILE_",",DIC(0)="QAEN"
 S DIC("S")="I '$P(^(0),U,2)&($P(^(0),U,2)'[""C"")"
 S DIC("A")="Which field: ALL// "
 D ^DIC K DIC
 Q $S(X="":"",1:+Y)
 ;
ASKTYP() ;Ask for type of cross-reference
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="SAM^T:TRADITIONAL;N:NEW;B:BOTH"
 S DIR("A")="What type of cross-reference (Traditional or New)? "
 S DIR("B")="Both"
 S DIR("?",1)="Enter 'T' to print only traditional cross-references."
 S DIR("?",2)="  Traditional cross references are stored in the data"
 S DIR("?",3)="  dictionary under ^DD(file#,field#,1)."
 S DIR("?",4)=" "
 S DIR("?",5)="Enter 'N' to print only new-style cross-references."
 S DIR("?",6)="  New-Style cross references are stored in the Index file."
 S DIR("?",7)=" "
 S DIR("?")="Enter 'B' to print both kinds of cross-references."
 D ^DIR
 Q $S($D(DIRUT):"",1:Y)
 ;
ASKRANGE(DIDFILE,DIDBY,DIDFR,DIDTO) ;Ask for a range of fields
 Q:'$G(DIDFILE)
 ;
 N %,D,D0,DA,DDD,DIC,DICR,DIX,DO,DP,DZ,X,Y,DTOUT,DUOUT
 S DIC="^DD("_DIDFILE_",",DIC(0)="QAEN"
 S DIC("A")="Start with field: FIRST// "
 D ^DIC K DIC
 I X="" S (DIDFR,DIDTO)="" Q
 I Y=-1 S (DIDFR,DIDTO)=-1 Q
 S DIDFR=$S(DIDBY[".001":+Y,1:$P(Y,U,2))
 ;
 S DIC="^DD("_DIDFILE_",",DIC(0)="QAEN"
 S DIC("A")="Go to field: "
 D ^DIC K DIC
 I X="" S DIDTO="" Q
 I Y=-1 S (DIDFR,DIDTO)=-1 Q
 S DIDTO=$S(DIDBY[".001":+Y,1:$P(Y,U,2))
 ;
 S:DIDTO']]DIDFR %=DIDTO,DIDTO=DIDFR,DIDFR=%
 Q
 ;
FILELST(DIDROOT) ;
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 N DIDARRAY
 D EN4^DIQGDD
 M @DIDROOT=DIDARRAY
 Q
 ;
FILE(DIQGR,DIQGPARM,DR,DIQGTA,DIQGERRA,DIQGIPAR) ;
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 G EN2^DIQGDDF
 ;
FIELDLST(DIDROOT) ;
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 N DIDARRAY
 D EN5^DIQGDD
 M @DIDROOT=DIDARRAY
 Q
 ;
FIELD(DIQGR,DA,DIQGPARM,DR,DIQGTA,DIQGERRA,DIQGIPAR) ;
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 G EN1^DIQGDD
 ;
GET1(DIQGR,DA,DIQGPARM,DR,DIQGETA,DIQGERRA,DIQGIPAR) ;
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 G EN3^DIQGDD
 ;
PIECE(DIQGR,DA,DIQGPARM,DR,DIQGTA,DIQGERRA,DIQGIPAR) ;CLOSEDREF,PIECE,FLAG,ATTRIBUTE,TARGETARRAY,ERRORARRAY,INTERNAL
 ;PROCEDURE CALL AND  * * RETURN RESULTS IN TARGET ARRAY * *
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 G EN6^DIQGDD0
