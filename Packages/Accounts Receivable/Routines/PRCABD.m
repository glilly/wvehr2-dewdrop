PRCABD  ;SF-ISC/RSD-DISPLAY/PRINT BILL ;12/15/95  10:54
V       ;;4.5;Accounts Receivable;**29,57,104,109,154,233**;Mar 20, 1995;Build 4
        ;;Per VHA Directive 2004-038, this routine should not be modified.
DEV     Q:'$D(PRCABT)  K ZTSAVE S %ZIS="QM" D ^%ZIS Q:POP  G EN:IO=IO(0)
        I $D(IO("Q")) S ZTRTN=$S(PRCABT=3:"EN^PRCABD",1:"^PRCABP"_PRCABT),ZTDTH=$H,ZTSAVE("D0")="",ZTSAVE("PRCABT")="",ZTSAVE("PRCADFM")="" D ^%ZTLOAD G Q
        U IO
EN      Q:'$D(D0)  S PRCAD0=$G(^PRCA(430,D0,0)),PRCAD10=$G(^(100)),PRCAD14=$G(^(104)) G Q:PRCAD0=""!(PRCAD10="")
        S $P(PRCADUL,"-",80)="-" W @IOF,"BILL #: ",$P(PRCAD0,U,1),?30,"DATE: " S Y=$P(PRCAD0,U,10) D DT W ?60,"TYPE: ",$P("1081^1080^1114","^",PRCABT),!,"DEBTOR: ",?40,"BILLING AGENCY: ",!
        S Y=+$P(PRCAD0,U,9),X=$S($D(^RCD(340,Y,0)):$P(^(0),U,1),1:""),X(1)="" S:X]"" X(1)=$S($D(@("^"_$P(X,";",2)_+X_",0)")):$P(^(0),U,1),1:"")
        S PRCADB=$S($D(^RCD(340,+$P(PRCAD0,"^",9),0)):$P(^(0),"^"),1:"") S X=$$DADD^RCAMADD(PRCADB) K PRCADB S J=2 D ADD
        S Y=+$P(PRCAD10,U,7),X(6)=$P($G(^RC(342.1,+Y,0)),"^"),X=$$SADD^RCFN01(+Y_";RC(342.1,"),J=7 D ADD F I=1:1:5 I $D(X(I))!($D(X(I+5))) W !?1 W:$D(X(I)) X(I) W ?41 W:$D(X(I+5)) X(I+5)
        ;*****  PROBABLY WANT TO ENTER ACCT LINE INFO HERE   *****
        W !!,"CONTROL POINT :"
        W ?17,$P($G(^PRCA(430,D0,11)),U)
        W ! W:PRCABT=1 !?40,"AGENCY LOCATION CODE: ",$P(PRCAD10,U,3) W !,"APPROVING OFFICIAL: "
        I $P(PRCAD14,U,2)]"" S X=$P(PRCAD14,U,2),P=+PRCAD14,DA=D0 D DE^PRCASIG(.X,P,DA_+$P(PRCAD0,U,3)) W "/ES/ ",X,"   DATE: " S Y=$P(PRCAD14,U,3) D DT
        W ! F I=0:0 S I=$O(^PRCA(430,D0,2,I)) Q:'I  I $D(^(I,0)) S X=^(0) W !,"FY: ",$P(X,U,1),?12,"APPR. SYMBOL: ",$P($G(^PRCA(430,D0,11)),U,17),?50,"AMOUNT: ",$J($P(X,U,2),10,2)
        D DES(D0,PRCABT)
Q       D ^%ZISC K DA,DIWL,DIWR,DIWF,FLN,I,J,P,PRCAD,PRCAD0,PRCAD10,PRCAD14,PRCADFM,PRCADI,PRCADI0,PRCADQ,PRCADUL,X,Y,Z,ZTDTH,ZTRTN,ZTSAVE,%ZIS Q
DES(D0,PRCABT)  ;also entry from letter routine
        NEW DIWF,DIWL,DIWR,FLN,PRCAD,PRCADI,PRCADI0,PRCADQ
        W !! D HDR S (PRCADQ,PRCADI)=0
DESL    S PRCADI=$O(^PRCA(430,D0,101,PRCADI)) G:'PRCADI DESQ S PRCADI0=^(PRCADI,0),PRCAD=0,DIWL=1,DIWR=50,DIWF="" K ^UTILITY($J,"W"),FLN
        F  S PRCAD=$O(^PRCA(430,D0,101,PRCADI,1,PRCAD)) Q:'PRCAD  S X=$S($D(^(PRCAD,0)):^(0),1:"") D ^DIWP
        I $D(^UTILITY($J,"W",DIWL)) F I=0:0 S I=$O(^UTILITY($J,"W",DIWL,I)) Q:'I  S DIWF=^(I,0) D:'$D(FLN) FLN Q:PRCADQ  I $D(FLN),DIWF'="" W !,?11,DIWF
        I '$D(FLN) D FLN
        K ^UTILITY($J,"W") W !! G:'PRCADQ DESL
DESQ    Q
FLN     ;first line of detail after description
        Q:$D(FLN)  D ASK Q:PRCADQ  S FLN=1
        W:PRCABT=2 $P(PRCADI0,U,7),?11 S Y=$P(PRCADI0,U,1) D DT
        W ?11 I $L($G(DIWF))<25 W DIWF S DIWF=""
        W:$P(PRCADI0,U,3)]"" ?37,$J($S($P(PRCADI0,U,3)?1".".N:"0"_$P(PRCADI0,U,3),1:$P(PRCADI0,U,3)),8)
        W:$P(PRCADI0,U,4)]"" ?47,$J($P(PRCADI0,U,4),12,4) W ?62,$S($D(^PRCD(420.5,+$P(PRCADI0,U,5),0)):$P(^(0),U,1),1:"")
        W ?65,$J($P(PRCADI0,U,6),15,2)
        Q
ASK     I $E(IOST,1,2)="C-",($Y+4)>IOSL W !?8,"ENTER '^' TO HALT: " R X:DTIME S:X["^"!'$T PRCADQ=1 Q:PRCADQ  W @IOF D HDR Q
        I $E(IOST,1,2)'="C-",($Y+4)>IOSL W @IOF D HDR
        Q
HDR     I PRCABT=2 W !,"ORDER NO.",?11,"DATE",?37,"QUANTITY",?55,"COST",?61,"PER",?74,"AMOUNT"
        E  W !," DATE",?11,"DESCRIPTION",?37,"QUANTITY",?55,"COST",?61,"PER",?74,"AMOUNT"
        I '$D(PRCADUL) S PRCADUL="",$P(PRCADUL,"_",80)="_"
        W !,PRCADUL,! Q
ADD     F I=1:1:4 S:I<4&($P(X,U,I)]"") X(J)=$P(X,U,I),J=J+1 I I=4 S X(J)=$P(X,U,4) S:$P(X,U,5)'="" X(J)=X(J)_", "_$P(X,U,5)_" "_$P(X,U,6)
        Q
DT      Q:Y=""  W $$SLH^RCFN01(Y,"/")_" " Q
EN1     ;PRINT/DISPLAY BILL
EN10    D SVC^PRCABIL G EN1Q:'$D(PRCAP("S")) S DIC("S")="S Z0=$S($D(^PRCA(430.3,+$P(^(0),U,8),0)):$P(^(0),U,3),1:0) I Z0=205,$D(^PRCA(430,Y,100)),+$P(^(100),U,2)="_PRCAP("S")
        D BILLN^PRCAUTL G EN1Q:'$D(PRCABN) S PRCABT=+^PRCA(430,PRCABN,100) G EN1Q:'PRCABT S D0=PRCABN,PRCADFM=1 D DEV,EN1Q G EN10
EN1Q    K D0,DIC,PRCA,PRCABN,PRCADFM,PRCAP,PRCABT,PRCATY,Z0,ZTSK Q
