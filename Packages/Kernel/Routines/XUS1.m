XUS1    ;SF-ISC/STAFF - SIGNON ;02/03/10  16:01
        ;;8.0;KERNEL;**9,59,111,165,150,252,265,419,469,523**;Jul 10, 1995;Build 16
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;User setup
USER    ;
        K XUTEXT S XUM=$$USER^XUS1A(),$Y=0
        ;Show post sign-on text
        F I=0:0 S I=$O(XUTEXT(I)) Q:I'>0  D:$Y>20  W:$E(XUTEXT(I),1)="!" ! W $E(XUTEXT(I),2,999)
        . N DIR S DIR(0)="E",DIR("A")="Enter RETURN to continue" D ^DIR W @IOF Q
        ;if XUM=9 multi sign-on NOT allowed
        I XUM=9 W !!,?8,$$EZBLD^DIALOG(30810.45)
        Q:XUM  ;User can't sign-on.
SET     ;
        S Y=$$CHKDIV()
        I $P(Y,U,2)>0,$D(^DIC(4,0)) D ASKDIV
        S DUZ(2)=+Y D DUZ^XUS1A
        ;Check verify code
        I $$VCHG D CVC^XUS2 G:$D(DUOUT) H^XUS
        S:$P(XOPT,"^",5) XUTT=1 ;Ask Device
        D ENQ ;Inquire to Terminal Type
        Q
        ;
VCHG()  ;Check if the Verify code needs to be changed
        I $D(DUZ("ASH")) Q 0 ;rwf 403
        D:'$D(XUSER) USER^XUS(DUZ)
        Q:'$L($P(XUSER(1),U,2)) 1 ;Null VC
        I $$BROKER^XWBLIB Q:$P(XUSER(0),U,8)=1 0 ;VC never expires, only for BROKER
        Q (XUSER(1)+$P(XOPT,U,15))'>$H ;Time to change
        ;
ASKDIV  ;Ask the user for the Division, return Y
        N X
        S DIC="^VA(200,DUZ,2,",DIC(0)="AEMQ",DIC("P")="200.02P",X=$O(^VA(200,DUZ,2,"AX1",1,0)) S:X>0 DIC("B")=$P($$NS^XUAF4(X),U)
        D ^DIC I Y'>0 W !,*7,"You must select one." G ASKDIV
        Q
        ;
CHKDIV(CD)      ;ef,sr Check if user needs to select Division.
        N %,%1,%2,%3,%4
        I $G(DUZ("DIV"))>0 Q DUZ("DIV") ;p469 Set outside
        S %=$O(^VA(200,DUZ,2,0)),%1=$O(^(%))
        I %1,$D(CD) D
        . S %2=0,%3=0,CD=0
        . F  S %2=$O(^VA(200,DUZ,2,%2)) Q:%2'>0  S %4=^(%2,0),%3=%3+1,CD(%3)=%2_"^"_$$NS^XUAF4(%2)_$S($P(%4,"^",2):"^1",1:"")
        . S CD=%3
        Q %_"^"_%1
        ;
ENQ     ;Get terminal type
        S XUT1="" I XUTT X XUEOFF R X:0 X ^%ZOSF("TYPE-AHEAD") W $C(27,91,99) R *X:2 I X=27 F  R X#1:2 S XUT1=XUT1_X Q:'$T!(X="c")
        ;Commented out the next line as Wyse 75 are not used
        ;I XUTT,(XUT1'["[") R X:0 S XUT1="" W *5 R *X:2 R:$T XUT1:2 S X=$S(X=6:"C-WYSE 75",1:$C(X)_XUT1),XUT1=""
        X XUEON I XUTT,XUT1["[" S Y=$O(^%ZIS(3.22,"B",XUT1,0)) I Y>0 S X=$P($G(^%ZIS(3.22,Y,0)),"^",2)
        I X?1.ANP S DIC="^%ZIS(2,",DIC(0)="MO" D ^DIC I Y>0 S XUIOP(1)=$P(Y,U,2),$P(XUIOP,";",2)=XUIOP(1),^VA(200,DUZ,1.2)=+Y
        I '$D(XUIOP(1)),$D(^VA(200,DUZ,1.2)) S X=+^(1.2) I X>0,$D(^%ZIS(2,X,0)) S $P(XUIOP,";",2)=$P(^(0),U)
        Q
        ;
NEXT    ;Jump to the next routine
        S IOP=XUIOP D ^%ZIS D SAVE ;Save off device/user info
        S X=$G(^DISV(DUZ)) ;Add kill by session or day here
        S ^DISV(DUZ)=$H
        ;Removed UCI jump p469
        ;S X=%UCI,N1=XUCI I PGM["[" S X=$P(PGM,"[",2,4),PGM=$P(PGM,"[",1)
        ;S:X["""" X=$P(X,"""",2) S:X?.E1"]"&(X'["[") X=$E(X,1,$L(X)-1) S XUM=14,XUM(0)=X
        ;S %UCI=X I "PRODMGR"'[X,$D(^%ZOSF("UCICHECK")) X ^("UCICHECK") G NO:Y="" S:N1=Y %UCI=""
        ;S XUM=15,XUM(0)=PGM G NO:PGM'?1AP.AN
        ;G NO:":"_XUA_":"'[(":"_PGM_":")
        D AUDIT
        S X=$S($D(^VA(200,DUZ,0)):$P($P(^(0),U),","),1:"Unk"),X=$E(X,1,10)_"_"_($J#10000) D SETENV^%ZOSV ;Set Process Name
        ;S X=$P(XOPT,U,16) X:X ^%ZOSF("PRIORITY")
        D LOG:DUZ,KILL
        ;I %UCI]"" K ^XUTL("XQ",$J) S $P(^VA(200,DUZ,1.1),U,3)=0 G GO^%XUCI
        K ^XUTL("OR",$J),^UTILITY($J),%UCI
        G ^XQ ;@(U_PGM)
        ;
SAVE    ;
        N X
        S X="DUZ" F  S X=$Q(@X) Q:X=""  I $D(@X) S ^XUTL("XQ",$J,$TR(X,""""))=@X
        F X="DUZ","IO","IO(""IP"")","IO(""CLNM"")","XQVOL" I $D(@X) S ^XUTL("XQ",$J,X)=@X
        D SAVEVAR^%ZIS ;Save the HOME device variables
        Q
        ;
LOG     ;used by R/S and Broker
        N %,XP1,XP2
        S XQXFLG("LLOG")=$P($G(^VA(200,DUZ,1.1)),U) ;Save for LOGIN templates
        S XP1=$$SLOG($P(XUVOL,U,1),,XUDEV,XUCI,$P(XUENV,U,3))
        S %=$$COOKIE($P(^VA(200,DUZ,0),U),XP1) I $L(%) S XQXFLG("ZEBRA")=XP1_"~"_%,$P(^XUSEC(0,XP1,0),U,13)=% L +^XWB("SESSION",XQXFLG("ZEBRA")):60
        Q
        ;
        ;Division updated in DIVSET^XUSRB2
        ;The other parameters are in the symbol table with known names.
        ;P1=DUZ,P2=$I,P3=$J,P4=EXIT D/T,P5=VOLUME,P6=TASKMAN,P7=XUDEV,P8=UCI,P9=ZIO,P10=NODE,P11=IP,P12=CLNM,P13=HANDLE,P14=REMOTE SITE,P15=REMOTE IEN
SLOG(P5,P6,P7,P8,P10,P14,P15)   ;
        N %,I,DA,DIK,N,XL1,XL2 S XL1=$$NOW^XLFDT
        S P5=$G(P5),P6=$G(P6),P7=$G(P7),P8=$G(P8),P10=$G(P10)
        S N=DUZ_"^"_$I_"^"_$J_"^^"_P5_"^"_P6_"^"_P7_"^"_P8_"^"_$G(IO("ZIO"))_"^"_P10_"^"_$G(IO("IP"))_"^"_$G(IO("CLNM"))
        S:$D(DUZ("VISITOR")) $P(N,U,14,15)=DUZ("VISITOR") ;p523
        S:$G(DUZ(2))>0 $P(N,"^",17)=DUZ(2)
        S:$D(DUZ("REMAPP")) $P(N,U,18)=$P(DUZ("REMAPP"),U) ;p523
        F I=XL1:.00000001 L +^XUSEC(0,I):1 Q:'$D(^XUSEC(0,I))  L -^XUSEC(0,I)
        S ^XUSEC(0,I,0)=N
        L -^XUSEC(0,I)
        S $P(^XUSEC(0,0),"^",3,4)=I_U_(1+$P(^XUSEC(0,0),"^",4))
        S (XL1,DA)=I,DIK="^XUSEC(0," D IX^DIK ;index new entry
        S ^XUTL("XQ",$J,0)=XL1 ;save for sign-off
        I 'P6 S XL2=$G(^VA(200,DUZ,1.1)),$P(XL2,U,1,3)=XL1_"^0^1",$P(XL2,U,5)="",^VA(200,DUZ,1.1)=XL2  ;Set last Sign-on
        Q XL1
        ;
COOKIE(J1,J2)   ;Call VAdeamon for a cookie
        N ZZ,%
        I $G(XQXFLG("ZEBRA"))=-1 K XQXFLG("ZEBRA") Q "" ;Disabled
        Q:$G(IO("IP"))="" "" ;Not using Telnet
        Q:$D(DUZ("VISITOR")) "" ;Don't create Handles for visitors p523
        ;
        S %=$$CMD^XWBCAGNT(.ZZ,"XWB CREATE HANDLE",J1_"^"_J2) Q:'% ""
        Q $G(ZZ(1))
        ;
AUDIT   ;Set-up Audit info
        N I,I1,I2
        S I=$G(^XTV(8989.3,1,19)),I1=$P(I,U),I2=$P(I,U,2) Q:"asu"'[I1  I (I2>XUNOW)!($P(I,U,3)<XUNOW) Q
        I "au"[I1 S:(I1="a")!($D(^XTV(8989.3,1,19.3,"B",DUZ))>1) XQAUDIT=1 Q
        S XQAUDIT="" F I=0:0 S I=$O(^XTV(8989.3,1,19.1,"B",I)) Q:I'>0!($L(XQAUDIT)>245)  S XQAUDIT=XQAUDIT_"2^"_I_U
        S I1="" F I=0:0 S I1=$O(^XTV(8989.3,1,19.2,"B",I1)) Q:I1']""!($L(XQAUDIT)>245)  S XQAUDIT=XQAUDIT_"3^"_I1_U
        Q
        ;
DD(Y)   Q $$FMTE^XLFDT(Y,1)
        ;
KILL    N %UCI,PGM,U,XQUR,XMCHAN G KILL1^XUSCLEAN
        Q
NO      G NO^XUS
