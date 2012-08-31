PRCHAM4 ;WISC/AKS,ID/RSD,SF-ISC/TKW-ADJUSTMENT VOUCHER ;6/8/96  13:06
V       ;;5.1;IFCAP;**124**;Oct 20, 2000;Build 2
        ;Per VHA Directive 2004-038, this routine should not be modified.
EN      ;ADJUSTMENT VOUCHER
        I $D(^PRC(443.6,PRCHPO)) D  Q
        .W !!,"There is a pending amendment against this purchase order." Q
        S PRCHAV="" D ENAV^PRCHAM Q:'$D(PRCHPO)
PAR     S DIC="^PRC(442,PRCHPO,11,",DIC(0)="QEANZ"
        S DIC("S")="I $P(^PRC(442,PRCHPO,11,+Y,0),U,12)'<0" D ^DIC K DIC
        ;I $G(PRCHAUTH)=1 S DIC("S")="I $P(^PRC(442,PRCHPO,11,+Y,0),U,12)'<0,$P(^PRC(442,PRCHPO,23),U,11)=""P"""
        ;I $G(PRCHAUTH)=2 S DIC("S")="I $P(^PRC(442,PRCHPO,11,+Y,0),U,12)'<0,$P(^PRC(442,PRCHPO,23),U,11)=""D"""
        G:Y<0 Q^PRCHAM
        I $P(^PRC(442,PRCHPO,11,+Y,0),U,6)="",$P($G(^PRC(442,PRCHPO,0)),U,2)'=25,'$G(PRCHAUTH) W !,"This Receiving Report has not been processed in Fiscal Service." G PAR
        S (PRCHRPTO,PRCHRPT)=+Y,PRCHAV0=Y(0),PRCHRD=$P(Y(0),U)
        S (PRCHRTT,PRCHRT)=0
        S:$D(^PRC(442,PRCHPO,11,PRCHRPTO,1)) PRCHAV1=^(1),$P(PRCHAV1,U,16)=PRCHRPTO
        S PRCHSAM1=$P(PRCHAV0,U,3),PRCHSAM2=$P(PRCHAV0,U,5)
        D NOW^%DTC
        I X>($P(^PRC(442,PRCHPO,11,PRCHRPTO,0),U)+30) D  I %'=1 G Q^PRCHAM
        .W !!,?10,"This partial receipt is more than 30 days old."
        .W !,?10,"Please check payment status with Fiscal.",!,"         "
        .S %="",%A="    Would you like to continue? ",%B="" D ^PRCFYN
        S ^TMP("PRCHW",$J,1)="Adjustment Voucher for Purchase Order "_$P(PRCH(0),U)
        S (PRCHII,PRCHNN)=0 F  S PRCHNN=$O(^PRC(442,PRCHPO,11,PRCHNN)) Q:'PRCHNN  S PRCHII=PRCHII+1
        S PRCHRPTN=PRCHII+1,PRCHATOT=0
        S PRCHJ=3,PRCHL1="*",(PRCHO,PRCHN,PRCHL2)="" D EN^PRCHAM
ITEM    S DIC("S")="I $O(^PRC(443.6,PRCHPO,2,""AB"",PRCHRD,+Y,0))"
        K PRCHI,^TMP("PRCHW",$J) D MV^PRCHAM2,EN^PRCHAM2 K DIC
        I '$D(PRCHNFLG) G Q^PRCHAM
        G LST:Y<0,ITEM:'$D(^PRC(443.6,PRCHPO,2,+PRCHI,2))
        S PRCHI(0)=^PRC(443.6,PRCHPO,2,+PRCHI,0),PRCHI(2)=^(2),I=PRCHJ
        D MES^PRCHAM2 S PRCHAV=+$O(^PRC(443.6,PRCHPO,2,"AB",PRCHRD,+PRCHI,0))
        G:'$D(^PRC(443.6,PRCHPO,2,+PRCHI,3,PRCHAV,0)) ITEM S (PRCHITR,Y)=^(0)
        ;S PRCHO=$S($P(Y,U,7):$P(Y,U,7),1:$P(Y,U,2)),PRCHAMT1=$P(Y,U,3)
        S PRCHO=$P(Y,U,2),PRCHAMT1=$P(Y,U,3)
        I $P(Y,U,7)]"" S PRCHO=$P(Y,U,7),PRCHAMT1=$P(Y,U,8)
        S PRCHDA=$P(Y,U,5),PRCHK=K+1
        S ^TMP("PRCHW",$J,PRCHK)=" ORIGINALLY QTY RECEIVED = "_PRCHO_" ,COST = $ "_PRCHAMT1
        S PRCHK=PRCHK+1 D EN2^PRCHAM44 G ITEM:'$D(X)
        S PRCHN=PRCHXX G:PRCHO=+PRCHN ITEM
        S PRCHADAM=$S($P(PRCHITR,U,8):$P(PRCHITR,U,8),1:$P(PRCHITR,U,3))+PRCHAMT1
        S $P(^PRC(443.6,PRCHPO,2,+PRCHI,3,PRCHAVLD,0),U,8)=PRCHADAM
        S ^TMP("PRCHW",$J,PRCHK)=" will now read: QTY RECEIVED="_PRCHQTY_", COST=$"_PRCHADAM
        S PRCHJ=PRCHK+1,PRCHL1="*",PRCHL2="",PRCHJ=1 D EN^PRCHAM S PRCHATOT=PRCHATOT+1 G ITEM
LST     S (PRCHAMT1,PRCHDA)=0,PRCHAVA=$P(PRCHAV0,U,3)+$P(PRCHAV0,U,5)
        I 'PRCHCHK!(PRCHATOT=0) D Q G Q^PRCHAM
        S I=0 F  S I=$O(^PRC(443.6,PRCHPO,2,"AB",PRCHRD,I)) Q:'I  D
        .S J=0 F  S J=$O(^PRC(443.6,PRCHPO,2,"AB",PRCHRD,I,J)) Q:'J  D
        ..S PRCHAV=J I $D(^PRC(443.6,PRCHPO,2,I,0)),$D(^(2)) S PRCHRS=$P(^(2),U,7) I $D(^(3,PRCHAV,0)) S (PRCHITSB,Y)=^(0) D SUB
        D TM^PRCHREC2,EN2^PRCHREC S K=1
        S ^TMP("PRCHW",$J,K)=" Vendor: "_$P(^PRC(440,$P(^PRC(442,PRCHPO,1),U),0),U),K=K+1
        S ^TMP("PRCHW",$J,K)=" APPROPRIATION: "_$P(^PRC(442,PRCHPO,0),U,4),K=K+1
        S ^TMP("PRCHW",$J,K)=" This Receiving Report will now read: ",K=K+1
        I PRCHDA D
        .S ^TMP("PRCHW",$J,K)="          Discounted Amount: "_PRCHDA,K=K+1
        S ^TMP("PRCHW",$J,K)="               Total Amount: "_PRCHRAM
        I PRCHRT S PRCHRTT=PRCHRAM*PRCHRT D
        .S ^TMP("PRCHW",$J,K+1)="       Term Discount Amount: "_$J(PRCHRTT,8,2)
        .S ^TMP("PRCHW",$J,K+2)="                 Net Amount: "_$J(PRCHRAMN,10,2)
        S (PRCHAMT1,PRCHDA)=0,PRCHAVA=$P(PRCHAV0,U,3)+$P(PRCHAV0,U,5) K PRCHR
        ;I 'PRCHCHK D Q G Q^PRCHAM
        S I=0 F  S I=$O(^PRC(443.6,PRCHPO,2,"AB",PRCHRD,I)) Q:'I  D
        .S J=0 F  S J=$O(^PRC(443.6,PRCHPO,2,"AB",PRCHRD,I,J)) Q:'J  D
        ..I '$D(^PRC(442,PRCHPO,11,J)) S PRCHAV=J I $D(^PRC(443.6,PRCHPO,2,I,0)),$D(^(2)) S PRCHRS=$P(^(2),U,7) I $D(^(3,PRCHAV,0)) S (PRCHITSB,Y)=^(0) D SUB
        D TM^PRCHREC2,EN2^PRCHREC S K=1
        S $P(PRCHAV0,U,2,5)=PRCHR(1)_U_PRCHR(2)
        S X=$P(PRCHAV0,U,9) S:X]""&($D(PRCHAF)) $P(PRCHAV0,U,9)=""
        S $P(PRCHAV0,U,19)=""
        S $P(PRCHAV0,U,10)=$S($D(PRCHROV):"Y",1:""),$P(PRCHAV0,U,12)=PRCHRAM
        S X=$P(^PRC(443.6,PRCHPO,0),U,17),X=X-PRCHAVA,$P(^(0),U,17)=X
        S $P(PRCHAV0,U,6)="",$P(PRCHAV0,U,9)=""
        S ^PRC(443.6,PRCHPO,11,PRCHRPT,0)=PRCHAV0,PRCHL1="*"
        S:$D(PRCHAV1) ^PRC(443.6,PRCHPO,11,PRCHRPT,1)=PRCHAV1
        S (PRCHO,PRCHN,PRCHL2)="" D EN^PRCHAM,Q G EN2^PRCHAM
SUB     S PRCHDA=PRCHDA+$P(Y,U,5) S:PRCHRS="" PRCHRS="**"
        S:'$D(PRCHR("SA",PRCHRS)) PRCHR("SA",PRCHRS)=0
        S PRCHR("SA",PRCHRS)=PRCHR("SA",PRCHRS)+$P(Y,U,3)-$P(Y,U,5) Q
SETC    ;IF ESTIMATED ORDER, PARTIAL ORDER RECEIVED, RESET 'C' X-REF ON ALL ITEMS
        Q:'$D(^PRC(442,PRCHPO,7))  Q:$P(^(7),U,3)'="Y"  Q:$P(^(7),U,2)'=26
        F I=0:0 S I=$O(^PRC(442,PRCHPO,2,I)) Q:'I  I $D(^(I,0)) D
        .S X=+^(0),PRCHX(X,X)="^PRC(442,PRCHPO,2,""C"",X,"_I_")"
        Q
W1      W:$E(X)'="?" " ??",$C(7)
        W !,"Enter the quantity (a number between 0 & 999,999 with up to two decimal places)" Q
Q       K PRCHAMT1,PRCHDA,PRCHRD,PRCHR,PRCHRPT,PRCHRES,PRCHRAM,PRCHRAMN,PRCHRT,PRCHATOT
        K PRCHRT2,PRCHRS,PRCHRQ,PRCHRQ1,PRCHROV,PRCHAV0,PRCHAVA,PRCHAF,PRCHRTT
        QUIT
EN2Q    K X
        QUIT
