IBXX1 ; COMPILED XREF FOR FILE #399 ; 09/19/10
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^DGCR(399,"C",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,3)
 I X'="" K ^DGCR(399,"D",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,3)
 I X'="" S IBN=$P(^DGCR(399,DA,0),"^",2) I $D(IBN) K ^DGCR(399,"APDT",IBN,DA,9999999-X),IBN
 S X=$P(DIKZ(0),U,3)
 I X'="" K ^DGCR(399,"ABNDT",DA,9999999-X)
 S X=$P(DIKZ(0),U,5)
 I X'="" K ^DGCR(399,"ABT",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,7)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.07,1,1,2.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X=0 X ^DD(399,.07,1,1,2.4)
 S X=$P(DIKZ(0),U,7)
 I X'="" K ^DGCR(399,"AD",$E(X,1,30),DA)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,8)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X="" X ^DD(399,.08,1,4,2.4)
 S X=$P(DIKZ(0),U,8)
 I X'="" K ^DGCR(399,"APTF",$E(X,1,30),DA)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,11)
 I X'="" D DEL^IBCU5
 S X=$P(DIKZ(0),U,11)
 I X'="" S DGRVRCAL=2
 S X=$P(DIKZ(0),U,11)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=$S($P(^DGCR(399,DA,0),U,11)'="i":1,"PST"'[$P(^DGCR(399,DA,0),U,21):1,1:0) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,21),X=X S DIU=X K Y S X="" X ^DD(399,.11,1,4,2.4)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,13)
 I X'="" I $P(^DGCR(399,DA,0),U,2) K ^DGCR(399,"AOP",$P(^(0),U,2),DA)
 S X=$P(DIKZ(0),U,13)
 I X'="" K ^DGCR(399,"AST",+X,DA)
 S X=$P(DIKZ(0),U,13)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,.13,1,4,2.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"TX")):^("TX"),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X=DIV S X="0" S DIH=$G(^DGCR(399,DIV(0),"TX")),DIV=X S $P(^("TX"),U,5)=DIV,DIH=399,DIG=24 D ^DICR
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,17)
 I X'="" K ^DGCR(399,"AC",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,19)
 I X'="" S DGRVRCAL=2
 S X=$P(DIKZ(0),U,19)
 I X'="" D ALLID^IBCEP3(DA,.19,2)
 S X=$P(DIKZ(0),U,19)
 I X'="" D ATTREND^IBCU1(DA,"","")
 S X=$P(DIKZ(0),U,21)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"MP")):^("MP"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399,.21,1,1,2.4)
 S X=$P(DIKZ(0),U,21)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=('$$REQMRA^IBEFUNC(DA)&$$NEEDMRA^IBEFUNC(DA)) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"TX")):^("TX"),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(399,.21,1,2,2.4)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,22)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U3")):^("U3"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" S DIH=$G(^DGCR(399,DIV(0),"U3")),DIV=X S $P(^("U3"),U,2)=DIV,DIH=399,DIG=243 D ^DICR
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,25)
 I X'="" D ALLID^IBCEP3(DA,.25,2)
 S DIKZ("S")=$G(^DGCR(399,DA,"S"))
 S X=$P(DIKZ("S"),U,1)
 I X'="" K ^DGCR(399,"APD",$E(X,1,30),DA)
 S X=$P(DIKZ("S"),U,7)
 I X'="" K ^DGCR(399,"APM",$E(X,1,30),DA)
 S X=$P(DIKZ("S"),U,10)
 I X'="" K ^DGCR(399,"APD3",$E(X,1,30),DA)
 S X=$P(DIKZ("S"),U,12)
 I X'="" K ^DGCR(399,"AP",$E(X,1,30),DA)
 S DIKZ("TX")=$G(^DGCR(399,DA,"TX"))
 S X=$P(DIKZ("TX"),U,2)
 I X'="" K ^DGCR(399,"ALEX",$E(X,1,30),DA)
 S DIKZ("C")=$G(^DGCR(399,DA,"C"))
 S X=$P(DIKZ("C"),U,14)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"C")):^("C"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X="" S DIH=$G(^DGCR(399,DIV(0),"C")),DIV=X S $P(^("C"),U,10)=DIV,DIH=399,DIG=60 D ^DICR
 S DIKZ("M")=$G(^DGCR(399,DA,"M"))
 S X=$P(DIKZ("M"),U,1)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $$COBN^IBCEF(DA)=1 I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"TX")):^("TX"),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(399,101,1,2,2.4)
 S DIKZ("M")=$G(^DGCR(399,DA,"M"))
 S X=$P(DIKZ("M"),U,2)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $$COBN^IBCEF(DA)=2 I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"TX")):^("TX"),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(399,102,1,3,2.4)
 S DIKZ("M")=$G(^DGCR(399,DA,"M"))
 S X=$P(DIKZ("M"),U,11)
 I X'="" D DEL^IBCU5
 S X=$P(DIKZ("M"),U,11)
 I X'="" S DGRVRCAL=2
 S X=$P(DIKZ("M"),U,12)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X="" X ^DD(399,112,1,1,2.4)
 S X=$P(DIKZ("M"),U,12)
 I X'="" D KIX^IBCNS2(DA,"I1")
 S X=$P(DIKZ("M"),U,12)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,112,1,3,2.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"MP")):^("MP"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399,112,1,3,2.4)
 S DIKZ("M")=$G(^DGCR(399,DA,"M"))
 S X=$P(DIKZ("M"),U,13)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399,113,1,1,2.4)
 S X=$P(DIKZ("M"),U,13)
 I X'="" D KIX^IBCNS2(DA,"I2")
 S X=$P(DIKZ("M"),U,13)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,113,1,3,2.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"MP")):^("MP"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399,113,1,3,2.4)
 S DIKZ("M")=$G(^DGCR(399,DA,"M"))
 S X=$P(DIKZ("M"),U,14)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"M")):^("M"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(399,114,1,1,2.4)
 S X=$P(DIKZ("M"),U,14)
 I X'="" D KIX^IBCNS2(DA,"I3")
 S X=$P(DIKZ("M"),U,14)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .X ^DD(399,114,1,3,2.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"MP")):^("MP"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(399,114,1,3,2.4)
 S DIKZ("M1")=$G(^DGCR(399,DA,"M1"))
 S X=$P(DIKZ("M1"),U,2)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"M1")):^("M1"),1:"") S X=$P(Y(1),U,2)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"M1")):^("M1"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X="" X ^DD(399,122,1,1,2.4)
 S DIKZ("M1")=$G(^DGCR(399,DA,"M1"))
 S X=$P(DIKZ("M1"),U,3)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"M1")):^("M1"),1:"") S X=$P(Y(1),U,3)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"M1")):^("M1"),1:"") S X=$P(Y(1),U,11),X=X S DIU=X K Y S X="" X ^DD(399,123,1,1,2.4)
 S DIKZ("M1")=$G(^DGCR(399,DA,"M1"))
 S X=$P(DIKZ("M1"),U,4)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"M1")):^("M1"),1:"") S X=$P(Y(1),U,4)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"M1")):^("M1"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X="" X ^DD(399,124,1,1,2.4)
 S DIKZ("MP")=$G(^DGCR(399,DA,"MP"))
 S X=$P(DIKZ("MP"),U,1)
 I X'="" D DEL^IBCU5
 S X=$P(DIKZ("MP"),U,1)
 I X'="" S DGRVRCAL=2
 S X=$P(DIKZ("MP"),U,2)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"MP")):^("MP"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X="" X ^DD(399,136,1,1,2.4)
 S DIKZ("U")=$G(^DGCR(399,DA,"U"))
 S X=$P(DIKZ("U"),U,1)
 I X'="" S DGRVRCAL=2
 S X=$P(DIKZ("U"),U,1)
 I X'="" K:$P(^DGCR(399,DA,0),"^",2) ^DGCR(399,"APDS",$P(^(0),U,2),-X,DA)
 S X=$P(DIKZ("U"),U,2)
 I X'="" S DGRVRCAL=2
 S DIKZ("U1")=$G(^DGCR(399,DA,"U1"))
 S X=$P(DIKZ("U1"),U,2)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,2)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(399,202,1,1,2.4)
 S DIKZ("U2")=$G(^DGCR(399,DA,"U2"))
 S X=$P(DIKZ("U2"),U,4)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV S X=DIU-X X ^DD(399,218,1,1,2.4)
 S DIKZ("U2")=$G(^DGCR(399,DA,"U2"))
 S X=$P(DIKZ("U2"),U,5)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV S X=DIU-X X ^DD(399,219,1,1,2.4)
 S DIKZ("U2")=$G(^DGCR(399,DA,"U2"))
 S X=$P(DIKZ("U2"),U,6)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV S X=DIU-X X ^DD(399,220,1,1,2.4)
 S DIKZ("U2")=$G(^DGCR(399,DA,"U2"))
 S X=$P(DIKZ("U2"),U,10)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U2")):^("U2"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X="" X ^DD(399,232,1,1,2.4)
 S X=$P(DIKZ("U2"),U,10)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U2")):^("U2"),1:"") S X=$P(Y(1),U,11),X=X S DIU=X K Y S X="" X ^DD(399,232,1,2,2.4)
 S X=$P(DIKZ("U2"),U,10)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=$$CLIAREQ^IBCEP8A(DA) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U2")):^("U2"),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$CLIA^IBCEP8A(DA) X ^DD(399,232,1,3,2.4)
 S X=$P(DIKZ("U2"),U,10)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U3")):^("U3"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" S DIH=$G(^DGCR(399,DIV(0),"U3")),DIV=X S $P(^("U3"),U,3)=DIV,DIH=399,DIG=244 D ^DICR
 S DIKZ("M1")=$G(^DGCR(399,DA,"M1"))
 S X=$P(DIKZ("M1"),U,8)
 I X'="" K ^DGCR(399,"AG",$E(X,1,30),DA)
 S DIKZ(0)=$G(^DGCR(399,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^DGCR(399,"B",$E(X,1,30),DA)
CR1 S DIXR=139
 K X
 S DIKZ("M")=$G(^DGCR(399,DA,"M"))
 S X(1)=$P(DIKZ("M"),U,1)
 S X(2)=$P(DIKZ("M"),U,2)
 S X(3)=$P(DIKZ("M"),U,3)
 S X(4)=$P(DIKZ("M"),U,13)
 S X(5)=$P(DIKZ("M"),U,12)
 S X(6)=$P(DIKZ("M"),U,14)
 S X=$G(X(1))
END G ^IBXX2
