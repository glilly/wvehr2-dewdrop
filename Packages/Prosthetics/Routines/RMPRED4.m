RMPRED4 ;PHX/RFM,RVD-EDIT ISSUE FROM STOCK ;8/29/1994
        ;;3.0;PROSTHETICS;**33,35,46,53,62,154**;Feb 09, 1996;Build 6
        ;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
        ;RVD patch #62 - PCE interface
        K DIR
        ;I $P(R1(0),U,13)=11&($P(R1(0),U,14)="C")&'$G(RMLOC) D
        S DIR(0)="667.3,3",DIR("A")="UNIT COST",DIR("B")=$P(R1(0),U,16)/$P(R1(0),U,7)
        I $D(RMLOC),$D(RMHCDA),$D(RMITDA) S DIR("B")=$$COST^RMPR5NU1
        D ^DIR G:$D(DIRUT)!$D(DTOUT)!$D(DUOUT) CO^RMPRED6
        S (ACNT,RMPRREL)=Y*$P(R1(0),U,7),$P(R3("D"),U,16)=ACNT,$P(R1(0),U,16)=ACNT
        K DIR
QTY     ;
        S DIR(0)="660,5",DIR("B")=$P(R1(0),U,7),RMPRCUST=$P(R1(0),U,16)/$P(R1(0),U,7) D ^DIR G:$D(DIRUT) CO^RMPRED6
        I $D(RMUBA),((RMUBA+$P(R1(0),U,7))-Y<0) D LOWBA^RMPRSTI G LOC^RMPRED6
        S $P(R1(0),U,7)=Y,$P(R1(0),U,16)=Y*RMPRCUST K DIR
DATE    S:$P(R1(0),U,12) DIR("B")=$P(R3("D"),U,12) S DIR("A")="DELIVERY DATE",DIR(0)="660,10" D ^DIR K DIR
        G:X["^" CO^RMPRED6 G:$D(DTOUT) EXIT W:$P(R1(0),U,12)&(X="@") !?5,"Deleted..." H 1 I $P(R1(0),U,12)=""&(X="@") W ?16,"??" G DATE
        S $P(R1(0),U,12)=Y,Y=$P(R1(0),U,12) D DD^%DT S $P(R3("D"),U,12)=Y
REQ     S DIR(0)="660,9" S:$P(R1(0),U,11)'="" DIR("B")=$P(R1(0),U,11) D ^DIR G:$D(DIRUT) CO^RMPRED6 G:$D(DTOUT) EXIT
        I X["^" W !,"Jumping not allowed!" G REQ
        I $P(R1(0),U,11)'=""&(X="@") W !?5,"Deleted..." H 1 S $P(R1(0),U,11)="" G LOT
        S $P(R1(0),U,11)=X
LOT     K DIR S DIR(0)="660,21" S:$P(R1(0),U,24)'="" DIR("B")=$P(R1(0),U,24) D ^DIR G:$D(DUOUT) CO^RMPRED6
        I X["^" W !,"Jumping not allowed!" G LOT
        I $P(R1(0),U,24)'=""&(X="@") W !?5,"Deleted..." H 1 S $P(R1(0),U,24)="" G REMA
        S $P(R1(0),U,24)=X
REMA    K DIR S DIR(0)="660,16" S:$P(R1(0),U,18)'="" DIR("B")=$P(R1(0),U,18) D ^DIR G:$D(DIRUT) CO^RMPRED6 G:$D(DTOUT) EXIT
        I X["^" W !,"Jumping not allowed!" G REMA
        I $P(R1(0),U,18)'=""&(X="@") W !?5,"Deleted..." H 1 S $P(R1(0),U,18)="" G CC
        S $P(R1(0),U,18)=X
CC      G CO^RMPRED6
        ;
POST    ;POSTS EDITED TRANSACTION TO 660
        W !,"Posting...."
        S RIPNEW=$P($G(R1(1)),U,3),RITNEW=$P(R1(0),U,6),RMQNEW=$P(R1(0),U,7)
        S:$G(RITNEW) RITNEW=$P($G(^RMPR(661,RITNEW,0)),U,1)
        S:$G(RITOLD) RITOLD=$P($G(^RMPR(661,RITOLD,0)),U,1)
        S ^RMPR(660,RMPRIEN,0)=R1(0),^("AM")=R1("AM"),^(1)=R1(1),^(2)=R1(2)
        I RMHCNEW'=RMHCOLD D
        .K ^RMPR(660,RMPRIEN,"DES")
        .MERGE ^RMPR(660,RMPRIEN,"DES")=^RMPR(661.1,RMHCNEW,2)
        .S $P(^RMPR(660,RMPRIEN,"DES",0),U,2)=""
        S DIK="^RMPR(660,",DA=RMPRIEN D IX1^DIK K DIK
        S RMVAR=RMLOCNEW_"^"_RMHCNEW_"^"_RMHCOLD_"^"_RMLOCOLD_"^"_RMITNEW_"^"_RMITOLD_"^"_RMQNEW_"^"_RMQOLD_"^"_RMSO_"^"_RMDFN
        I $G(RMQOLD)'=$G(RMQNEW)&($G(RMLOCNEW)=$G(RMLOCOLD))&($G(RMHCNEW)=$G(RMHCOLD))&(RMITNEW=RMITOLD) D QTYN^RMPRED5(RMVAR) G EXIT
        I $G(RMHCOLD)'=$G(RMHCNEW)!(RMITNEW'=RMITOLD)!($G(RMLOCNEW)'=$G(RMLOCOLD)) D NHCPC^RMPRED5(RMVAR)
        G EXIT
        ;end posting (edit 2319)
        ;
DEL1    ;ENTRY POINT TO DELETE AN ISSUE FROM STOCK
        K DIR
        S DIR("A")="Are you sure you want to DELETE this entry",DIR("B")="N",DIR(0)="Y"
        D ^DIR I $D(DTOUT)!$D(DUOUT)!$D(DIRUT) G EXIT
        I Y'=1 G CO^RMPRED6
        I $P(^RMPR(669.9,RMPRSITE,0),U,3)'=1!(RMPRPF=11) G DEL2
        I $G(RMPRIP),+$P(^RMPR(660,RMPRIEN,1),U,3)
        I  S DIC="^PRCP(445,",DIC(0)="M",X=RMPRIP,DIC("S")="I $P(^(0),U,2)=""Y"",$D(^PRCP(445,+Y,4,DUZ,0))" D ^DIC G:+Y<0 ERR K DIC S PRCP("I")=+Y,RMPRDTD=1
        I '$D(RMPRDTD) S DIC="^PRCP(445,",DIC(0)="AEMQ",DIC("S")="I $P(^(0),U,2)=""Y"",$D(^PRCP(445,+Y,4,DUZ,0))" D ^DIC K DIC S PRCP("I")=+Y
        S PRCP("ITEM")=$P(R3("D"),U,6),PRCP("QTY")=$P(R1(0),U,7),PRCP("TYP")="A" D ^PRCPUSA G:$D(PRCP("ITEM")) ERR
DEL2    I RMPRPF=11 S RM1=$G(^RMPR(660,RMPRIEN,1)),R6612=$P(RM1,U,5) D:$G(R6612)
        .S RM0=$G(^RMPR(660,RMPRIEN,0)),RMQTY=$P(RM0,U,7)
        .S RM10=$G(^RMPR(660,RMPRIEN,10))
        .;check if SUSPENSE and PCE entry has been created.  added by #62.
        .S RMIPCE=$P(RM10,U,12) I RMIPCE D
        ..S RMCHK=$$DEL^RMPRPCED(RMPRIEN)
        .;if no pce link, only delete entry in #668
        .I 'RMIPCE D
        ..S RMAMIS=$G(^RMPR(660,RMPRIEN,"AMS"))
        ..S RMIE68=$O(^RMPR(668,"F",RMPRIEN,0))
        ..Q:'$G(RMIE68)
        ..S DA=$O(^RMPR(668,RMIE68,10,"B",RMPRIEN,0))
        ..S DA(1)=RMIE68,DIK="^RMPR(668,"_DA(1)_",10," D ^DIK
        ..S RMAMIEN=$O(^RMPR(668,RMIE68,11,"B",RMAMIS,0)),RMCNT=0
        ..F I=0:0 S I=$O(^RMPR(668,RMIE68,10,"B",I)) Q:I'>0  D
        ...S RMAMIS68=$G(^RMPR(660,I,"AMS")) S:RMAMIS68=RMAMIS RMCNT=RMCNT+1
        ..I RMCNT=1 D
        ...S DA=RMAMIEN
        ...S DA(1)=RMIE68,DIK="^RMPR(668,"_DA(1)_",11,"
        ...D ^DIK
        .S RMSTO=$G(^RMPR(661.2,R6612,0)),RMLOC=$P(RMSTO,U,16)
        .S RMDAHC=$P(RM1,U,4),RMIT=$P(RMSTO,U,9)
        .S RMHCDA=$O(^RMPR(661.3,RMLOC,1,"B",RMDAHC,0))
        .Q:'$G(RMHCDA)
        .S:$D(^RMPR(661.3,RMLOC,1,RMHCDA)) RMITDA=$O(^RMPR(661.3,RMLOC,1,RMHCDA,1,"B",RMIT,0))
        .Q:'$G(RMITDA)
        .S RBAL=0 D
        ..S RMBA=$P(^RMPR(661.3,RMLOC,1,RMHCDA,1,RMITDA,0),U,2),RBAL=RMBA+RMQTY
        ..S (RAVA,RAV)=$P(^RMPR(661.3,RMLOC,1,RMHCDA,1,RMITDA,0),U,10)
        ..S $P(^RMPR(661.3,RMLOC,1,RMHCDA,1,RMITDA,0),U,2)=RBAL
        ..S $P(^RMPR(661.3,RMLOC,1,RMHCDA,1,RMITDA,0),U,3)=RBAL*RAV
        ..S $P(^RMPR(661.3,RMLOC,1,RMHCDA,1,RMITDA,0),U,12)=RMQTY
        .D BAL^RMPR5NU1
        .S X=DT,DIC(0)="AEQL",DLAYGO=661.2,DIC="^RMPR(661.2," K DD,DO
        .D FILE^DICN K DLAYGO S RMCOM="Returned from STOCK ISSUE"
        .S ^RMPR(661.2,+Y,0)=DT_"^^^"_RMDAHC_"^^^"_DUZ_"^"_RMQTY_"^"_RMIT_"^^"_RMQTY_"^"_RMTOBA_"^"_RMCOM_"^"_$J(RMTOCO,0,2)_"^"_RMPR("STA")_"^"_RMLOC_"^"_RAVA
        .S DA=+Y,DIK=DIC D IX1^DIK
        .W !,"****Current Balance @ Location ",$P(^RMPR(661.3,RMLOC,0),U,1)," is now: ",RBAL
        S DIK="^RMPR(660,",DA=RMPRIEN D ^DIK
        W $C(7),!?10,"Deleted..." H 1
        G EXIT
ERR     W !!,"Error encountered while posting to GIP.  Patient 10-2319 not deleted!! Please check with your Application Coordinator." H 5 G EXIT
EXIT    ;KILL VARIABLES AND EXIT ROUTINE
        I $G(RMPRIEN),$D(^RMPR(660,RMPRIEN)) L -^RMPR(660,RMPRIEN)
        N RMPRSITE,RMPR D KILL^XUSCLEAN Q
