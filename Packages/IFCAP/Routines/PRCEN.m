PRCEN ;WISC/CLH-ENTER/EDIT 1358 ; 07/19/93  2:17 PM
V ;;5.1;IFCAP;**23**;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
EN ;new 1358 request
 N PRC,X,X1,DIC,DIE,DR,PRCS2,PRCSL,PRCSIP,DIR,DIRUT,PRCS,PRCSCP,PRCSN
 N PRCST,PRCST1,PRCSTT,PRC410,PRCUA
EN0 K PRC,X,X1,DIC,DIE,DR,PRCS2,PRCSL,PRCSIP,DIR,DIRUT,PRCS,PRCSCP,PRCSN
 K PRCST,PRCST1,PRCSTT,PRCAED,PRC410,PRCUA
 D EN^PRCSUT I '$D(PRC("SITE")) W !!,"You are not an authorized control point user.",!,"Contact your control point official." H 3 Q
 Q:'$D(PRC("QTR"))!(Y<0)
 D EN1^PRCSUT3 Q:'X
 S X1=X D EN2^PRCSUT3 Q:'$D(X1)  S X=X1 W !!,"This transaction is assigned Transaction number: ",X
 S PRC410=DA
 D  G:'$D(DA) EN0
 . L +^PRCS(410,DA):0
 . E  D EN^DDIOL("Transaction is being accessed by another user!") K DA
 . Q
 I $D(^PRC(420,PRC("SITE"),1,+PRC("CP"),0)) S:$P(^(0),"^",11)="Y" PRCS2=1
 S DIC(0)="AEMQ",DIE=DIC,DR="3///1"_$S($D(PRCSIP):";4////"_PRCSIP,1:""),X4=1 D ^DIE
 S PRCAED=1,PRCUA=""
 S DR="[PRCE NEW 1358]" D ^DIE
 I $D(Y)#10 S PRCUA=1 D YN^PRC0A(.X,.Y,"Delete this NEW entry","","No") I Y=1 D
 . D DELETE^PRC0B1(.X,"410;^PRCS(410,;"_DA) S:X=1 PRCAED=-1
 . D EN^DDIOL(" **** NEW ENTRY IS "_$S(X=1:"",1:"NOT ")_"DELETED ****")
 . QUIT
 I PRCAED'=-1 D
 . D:$O(^PRCS(410,DA,12,0)) SCPC0^PRCSED
 . K PRCSF
 . D W1^PRCSEB
 . I $D(PRCS2),+^PRCS(410,DA,0),'PRCUA D
 .. D W6^PRCSEB
 .. Q
 . S $P(^PRCS(410,DA,7),"^")=DUZ
 . Q
 L -^PRCS(410,PRC410)
 S DIR("B")="NO",DIR(0)="Y",DIR("A")="Do you want to enter another NEW request" D ^DIR Q:'Y!($D(DIRUT))
 W !! K PRCS2 G EN0
 Q
ED ;edit 1358
 N PRC410,PRC442,PRCHQ,PRCSDR,PRCSN,PRCST,PRCST1,Y,PRC,PRCS,TT,DIE,DA,DIC
 N DR,DIR,PRCSY,PRCSL,X,X1,T,T1,Z,PRCSDA
ED0 K PRCHQ,PRCSDR,PRCSN,PRCST,PRCST1,Y,PRC,PRCS,TT,DIE,DA,DIC,DR,DIR,PRCSY
 K PRCSL,X,X1,T,T1,Z,PRCSDA
 D EN3^PRCSUT I '$D(PRC("SITE")) W !!,"You are not an authorized control point user.",!,"Contact your control point official." H 3 Q
 Q:Y<0
 S DIC="^PRCS(410,",DIE=DIC,DIC(0)="AEQM",DIC("S")="I $P(^(0),U,4)=1,+$P(^(0),U)'=0,$D(^(3)),+^(3)=+PRC(""CP""),$P(^(0),""^"",5)=PRC(""SITE"") I $D(^PRC(420,""A"",DUZ,PRC(""SITE""),+PRC(""CP""),1))!($D(^(2)))"
 D ^PRCSDIC Q:Y<0  K DIC("S") S (DA,PRCSY,PRCSDA)=+Y ;D LOCK^PRCSUT G ED0:PRCSL=0
 D  G:'$D(DA) ED0
 . L +^PRCS(410,DA):0
 . E  D EN^DDIOL("Another user is editing this transaction! Try Later") K DA
 . Q
 D NODE^PRCS58OB(DA,.TRNODE) S PRC410=DA
 S X=^PRCS(410,DA,0) S:+X PRC("FY")=$P(X,"-",2),PRC("QTR")=+$P(X,"-",3),TT=$P(X,"^",2)
 D EN2B^PRCSUT3
 I $D(^PRCS(410,DA,7)),$P(^(7),U,6)]"" D SCPE G OUT ;if obligated
ED1 I TT="CA" S DR="[PRCSENCT]",DIE=DIC D ^DIE S DA=PRCSY L -^PRCS(410,PRCSY) G ED0
 ;  patch 23, fix problem of not able to exit with "^"
 I TT'="O" S DR="[PRCSENA 1358]" S DIE=DIC D ^DIE G:$D(Y)>9 ED0 S DA=PRCSY
 I TT="A" S PRC442=$P($G(^PRCS(410,PRC410,10)),U,3) I PRC442 G:$$EN1^PRCE0A(PRC410,PRC442,1) ED1
 I TT="A",$P(^PRCS(410,DA,0),U,4)=1 S X=$P(^(4),U,6),X1=$P(^(3),U,7) I $J(X,0,2)'=$J(X1,0,2)!('X)!('X1) W $C(7),!,"Adj $ Amt does not equal the total of BOC $ Amts.",!,"Please correct the error.",! K DR G ED1
 D:TT="A"&($O(^PRCS(410,PRCSY,12,0))) SCPC0^PRCSED
 I TT="A" D REV,W6^PRCSEB Q
 S DIE=DIC,DR="[PRCE NEW 1358]" D ^DIE,REV,W6^PRCSEB
 S DIR(0)="Y",DIR("B")="NO",DIR("A")="Do you want to edit another request" D ^DIR G OUT:'Y!($D(DIRUT))
 G ED0
SCPE ;sub control point edit
 S DR="[PRCSEDS]" D ^DIE
REV W !!,"Would you like to review this request" S %=2 D YN^DICN G REV:%=0 Q:%'=1  S (N,PRCSZ)=DA,PRCSF=1 D PRF1^PRCSP1 S DA=PRCSZ K X,PRCSF,PRCSZ Q
OUT L -^PRCS(410,PRCSDA) Q
