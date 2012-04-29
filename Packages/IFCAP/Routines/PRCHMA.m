PRCHMA  ;WISC/AKS-Amend to PO, req ;6/10/96  14:07
        ;;5.1;IFCAP;**21,79,100,113**;Oct 20, 2000;Build 4
        ;Per VHA Directive 2004-038, this routine should not be modified.
REQ     N PRCHREQ
        S PRCHREQ=1
PO      N PRCF,RETURN,PRCHAM,PRCHPO,PRCHNEW,OUT,CAN,PRCHAU,PRCHER,PRCHON,A,B,ER,FL,FIS,DELIVER,PRCHAMDA,PRCHAV,PRCHL1,PRCHLN,PRCHRET,LCNT
        N PRCHL2,ROU,DIC,I,PRCHAMT,PRCHAREC,PRCHEDI,X,Y,PRCHN,PRCHO,SFUND,PRCHX,PRCHIMP,PRCHNRQ,PRCHP,REPO,PRCHNORE,%,%A,%B,D0,D1,J
        N PRCFL,MSG
LOOP    D KILL^PRCHMA1 S PRCHNEW="",PRCHNORE=1,CAN=0
        ; See routine PRCHAMXA for information on variable PRCHNORE and undefined DIK, var PRCHPO is the basic premise of locks applied to amendments
        S PRCF("X")="S" D ^PRCFSITE Q:'$D(PRC("SITE"))
        ; Lock simultaneous entry of users in amend. module for the same record.  Var Y is saved in PRCHPO at the end of GETPO subrtn, when we start
        ; the process(AMENDNO) of amending the record we must have var PRCHPO.
        S PRCFL=0
        W !! D GETPO^PRCHAMU
        ; If no record is selected or time-out or up-arrow out then exit without unlocking a record.
        I $D(DTOUT)!$D(DUOUT)!$G(OUT)=1 G EXIT1
        I PRCFL=1 G LOOP
        I '$G(PRCHPO)!$D(FIS) G EXIT
        I '$$VERIFY^PRCHES5(PRCHPO) W !!,?5,"This purchase order has been tampered with.",!,?5,"Please notify IFCAP APPLICATION COORDINATOR.",! G EXIT
        D AMENDNO^PRCHAMU G:'$G(PRCHAM) EXIT
        S PRCHAMT=0,FL=0
        D INFO^PRCHAMU G:$D(PRCHAV)!ER EXIT
        S X=$P($G(^PRC(443.6,PRCHPO,0)),U,16) D EN2^PRCHAMXB
        I PRCHNEW="" S DA(1)=PRCHPO,DA=PRCHAM,PRCHX=X,X=0,PRCHAMDA=34 D EN8^PRCHAMXB S X=PRCHX
        I $P(^PRC(443.6,PRCHPO,6,PRCHAM,0),U,4)=5!($P(^(0),U,4)=15) S CAN=1
        I PRCHNEW=111&($G(CAN)=0) D REV
        I $G(CAN)>0 D ENC G:ER EXIT I $G(NOCAN)=0 S DA(1)=PRCHPO,DA=PRCHAM,PRCHAMDA=34,PRCHX=X,X=0 D EN8^PRCHAMXB S X=PRCHX G CAN1
ASK     K NOCAN,DTOUT,DUOUT,REPONUM D ASK^PRCHAMU
        G:$D(REPONUM)=1 CAN1
        I ER=0 D  G:'$D(REPO)&($G(CAN)=0) ASK
        . D @ROU
        . I $G(PRCHAMDA)=31 D MSG^PRCHAMU Q
        . I $G(PRCHAMDA)=24,$G(X)=2 D MSG1^PRCHAMU S SCE=1 Q
        I $P(^PRC(443.6,PRCHPO,6,PRCHAM,0),U,4)=5!($P(^(0),U,4)=15) S CAN=1
        I $D(DTOUT)!($D(DUOUT)) G EXIT
        I $G(NOCAN)=1 G ASK
        G:$P($G(^PRC(443.6,PRCHPO,6,PRCHAM,3,0)),U,4)'>1 EXIT
CAN1    S BFLAG=0
        S:$P($G(^PRC(443.6,PRCHPO,1)),U,7)'=6 BFLAG=1
        I $P($G(^PRC(443.6,PRCHPO,1)),U,7)=6  D
        .S THISHLD=0
        .F  S THISHLD=$O(^PRC(443.6,PRCHPO,2,THISHLD)) Q:'THISHLD!(BFLAG=1)  D
        ..S:$P($G(^PRC(443.6,PRCHPO,2,THISHLD,2)),U,2)'="" BFLAG=1
        .Q:BFLAG=1
        .S THISHLD=0
        .F  S THISHLD=$O(^PRC(442,PRCHPO,2,THISHLD)) Q:'THISHLD!(BFLAG=1)  D
        ..S:$P($G(^PRC(442,PRCHPO,2,THISHLD,2)),U,2)'="" BFLAG=1
        W:BFLAG=0 !,"This is now a contract order.  You must add a contract to this orders item(s)",!,"before approving the amendment.",!
        G:BFLAG=0 EXIT
        D:BFLAG=1 UPDATE^PRCHAMU G:$D(Y) EXIT
CHK     I '$$VERIFY^PRCHES5(PRCHPO) W !!,?5,"This purchase order has been tampered with.",!,?5,"Please notify IFCAP APPLICATION COORDINATOR." G EXIT
        I $P($G(^PRC(443.6,PRCHPO,6,PRCHAM,1)),U,4)']"" W !!,?5,"There is no Amendment Status." D
        .S POSTAT=+$G(^PRC(443.6,PRCHPO,7))
        .S AMSTAT=$S(POSTAT=25:26,POSTAT=30:31,POSTAT=40:71,POSTAT=6:83,POSTAT=84:85,POSTAT=86:87,POSTAT=90:91,POSTAT=92:93,POSTAT=94:95,POSTAT=96:97,POSTAT=45:45,1:POSTAT)
        .S AMSTAT=$P(^PRCD(442.3,AMSTAT,0),U)
        .S DIE="^PRC(443.6,PRCHPO,6,",DA(1)=PRCHPO,DA=PRCHAM,DR="9//^S X=AMSTAT"
        .D ^DIE K DIE,AMSTAT,POSTAT
        K PRCHER S LCNT=1 I $P($G(^PRC(443.6,PRCHPO,6,PRCHAM,1)),U,4)']"" W !!,?5,"There is no Amendment Status.",! S PRCHER=""
        I $P($G(^PRC(443.6,PRCHPO,2,0)),U,4)>0 D  G:$D(PRCHER) ERR
        .N END S END=IOSL-3
        .S PRCH=0 F  S PRCH=$O(^PRC(443.6,PRCHPO,2,PRCH)) Q:PRCH=""!(PRCH'>0)  D
        ..S PRCHLN=$G(^PRC(443.6,PRCHPO,2,PRCH,0)) D  Q
        ...I $P(PRCHLN,U,4)="" D:LCNT>END TOP W !!,?5,"Line item ",+$P(PRCHLN,U)," is missing BOC !",$C(7) S PRCHER="",LCNT=LCNT+2
        ...I $G(PRCHAUTH)'=1,$G(PRCHREQ) I $P(PRCHLN,U,13)="" D:LCNT>END TOP W !!,?5,"Line item ",+$P(PRCHLN,U)," is missing NSN!",$C(7) S PRCHER="",LCNT=LCNT+2
        ...S J=0 S J=$O(^PRC(443.6,PRCHPO,2,PRCH,1,J)) I J'>0 D:LCNT>END TOP W !!,?5,"Line item ",+$P(PRCHLN,U)," is missing its description!",$C(7) S PRCHER="",LCNT=LCNT+2
        ...I $P($G(^PRC(442,PRCHPO,23)),U,11)="D",$P($G(^PRC(443.6,PRCHPO,2,PRCH,2)),U,2)="" D:LCNT>END TOP W !!,?5,"Line item ",+$P(PRCHLN,U)," is missing contract number.",$C(7) S PRCHER="",LCNT=LCNT+2
        ...; PRC*5.1*79 - Check line items of PC orders with source code=6 to make sure that a contract number is entered
        ...D PCD^PRCHMA1
        ...Q
        ..Q
        .I $D(PRCHER) I LCNT>END N DIR S DIR(0)="E" D ^DIR S LCNT=1
        .Q
        D EN106^PRCHNPO7 I $G(ERROR)=1 G EXIT
        I $P($G(^PRC(443.6,PRCHPO,0)),U,13)>0 I $P($G(^PRC(443.6,PRCHPO,23)),U)="" W !!,?5,"This amendment has Est. Shipping and/or Handling charges without any",!,?5,"Est. Shipping BOC." S PRCHER=""
        I $P($G(^PRC(443.6,PRCHPO,6,PRCHAM,0)),U,4)=5!($P($G(^(0)),U,4)=15) S CAN=1
        I $G(CAN)'=1 D CHECK^PRCHAMDF(PRCHPO,PRCHAM,.PRCHER)
        I $G(PRCHAUTH)=1!($P($G(^PRC(443.6,PRCHPO,0)),U,2)=25) S FILE=443.6 D  I $G(ERROR) S PRCHER="" K ERROR,FILE
        .D ^PRCHSF3
        .D ADJ1^PRCHCD0
        .D LIMIT^PRCHCD0
        ;
ERR     I $D(PRCHER) W !!,?5,"This amendment needs to be re-edited before it can be signed.",!,"**REMINDER** Unsigned amendments are deleted from the system after 7 days." D:LCNT>20  G EXIT
        .N DIR S DIR(0)="E" D ^DIR
        .Q
        D REV:'$G(PRCPROST),APP G:%'=1 EXIT
        S PRCHRET=$$ASK^PRCHAM8(PRCHPO,PRCHAM) G:PRCHRET'=1 EXIT
        S RETURN="" D COMMIT^PRCHAM8(PRCHPO,PRCHAM,.RETURN)
        G:RETURN'=1 EXIT
        S DIE="^PRC(443.6,"_PRCHPO_",6,",DA=PRCHAM,DR="15///TODAY+4" D ^DIE
        D ^PRCHSF3
        I $P(^PRC(443.6,PRCHPO,0),U,2)'=25 S PRCHQ="^PRCHPAM8",PRCHQ("DEST")="F",D0=PRCHPO,D1=PRCHAM D ^PRCHQUE
        I '($P(^PRC(443.6,PRCHPO,0),U,2)=25!($P(^PRC(443.6,PRCHPO,0),U,19)=2)) D
        . W !?3,"SEND TO SUPPLY " S PRCHQ="^PRCHPAM8",D0=PRCHPO,D1=PRCHAM D ^PRCHQUE
        . S FILE=443.6 D:$D(PRCHPO) CHECK^PRCHSWCH
        . I $G(PRCHOBL)=1 D SUPP^PRCFFM2M K FILE Q
        . I $G(PRCHOBL)=2 S PRCOPODA=PRCHPO D ^PRCOEDI K FILE,PRCOPODA Q
        I $P($G(^PRC(443.6,PRCHPO,0)),U,2)=25 D  S:$G(PRCPROST) PRCPROST=PRCPROST+0.9 G EXIT
        .S MTOPDA=1
        .D SUPP^PRCFFM2M ;I $P($G(^PRC(442,PRCHPO,23)),"^",11)="P" W !!,"...now generating the PHA transaction..." S PRCOPODA=PRCHPO D NEW^PRCOEDI K PRCOPODA W !!
        .S PPTEMP=0,PP410=$P($G(^PRC(442,PRCHPO,0)),"^",12),PPAMT=$P($G(^PRC(442,PRCHPO,0)),"^",16) I PP410'="" S PPTEMP=$P($G(^PRCS(410,PP410,4)),"^",8),PPTEMP=-(PPAMT-PPTEMP)
        .I $P($G(^PRC(442,PRCHPO,7)),"^",2)=45 S PPTEMP=PPAMT,PPAMT=0
        .I PP410'="" S $P(^PRCS(410,PP410,4),"^",3)=0
        .I PP410'="" S $P(^PRCS(410,PP410,4),"^",8)=PPAMT
        .S A=$$DATE^PRC0C($P(PRCOAMT,"^",3),"I"),$P(PRCOAMT,"^",3,4)=$E(A,3,4)_"^"_$P(A,"^",2),$P(PRCOAMT,"^",5)=PPTEMP D EBAL^PRCSEZ(PRCOAMT,"O")
        .I PP410'="",$P($G(^PRC(442,PRCHPO,7)),"^",2)=45 S $P(^PRCS(410,PP410,0),"^",2)="CA" D ERS410^PRC0G(PP410_"^C")
        .D REMOVE^PRCSC2(PP410),ENCODE^PRCSC2(PP410,DUZ,.MESSAGE) K MESSAGE
        .I '$G(PRCPROST) W !?3,"SEND TO SUPPLY " S PRCHQ="^PRCHPAM",D0=PRCHPO,D1=PRCHAM D ^PRCHQUE
        .; Update file #440.5 after amendment has been approved. Consider orders created and amended in the same month and year and the user either
        .; cancels the order or enters other type of amendment that changes the final amount of the order. No credit is given for orders from a
        .; previous month and year. DT is the current date, system-supplied.
        .S PRCHCD=$P($G(^PRC(442,PRCHPO,23)),U,8)
        .S PRCNODE=$G(^PRC(442,PRCHPO,6,0)),PRCAMD=$P(PRCNODE,U,3)
        .S PRCCHG=$P($G(^PRC(442,PRCHPO,6,PRCAMD,0)),U,3)
        .S POSTAT=$P($G(^PRC(442,PRCHPO,7)),"^",2)
        .I $E($P(^PRC(442,PRCHPO,1),U,15),1,5)=$E(DT,1,5),POSTAT'=45 D
        ..I $G(PPAMT)<0 Q
        ..S $P(^PRC(440.5,PRCHCD,2),U)=$P($G(^PRC(440.5,PRCHCD,2)),U)+$G(PRCCHG)
        ..I $P($G(^PRC(440.5,PRCHCD,2)),U)<0 S $P(^PRC(440.5,PRCHCD,2),U)=0
        .;
        .I $E($P(^PRC(442,PRCHPO,1),U,15),1,5)=$E(DT,1,5),POSTAT=45 D
        ..I $G(PPTEMP)<0 Q
        ..S $P(^PRC(440.5,PRCHCD,2),U)=$P($G(^PRC(440.5,PRCHCD,2)),U)-$G(PPTEMP)
        ..I $P($G(^PRC(440.5,PRCHCD,2)),U)<0 S $P(^PRC(440.5,PRCHCD,2),U)=0
        .;
        .; Update file #440.5 only if the amendment is for non-cancellation
        .; of an order from a previous month regardless of the year.
        .I $E($P(^PRC(442,PRCHPO,1),U,15),1,5)'=$E(DT,1,5),POSTAT'=45 D
        ..I $G(PPAMT)<0 Q
        ..S $P(^PRC(440.5,PRCHCD,2),U)=$P($G(^PRC(440.5,PRCHCD,2)),U)+$G(PPAMT)
        .K DA,MTOPDA,PRCAMD,PRCHCD,PRCCHG,PRCNODE,POSTAT,PPTEMP,PPAMT,PP410
        S SFUND="" I $P($G(^PRC(443.6,PRCHPO,0)),U,19)=2 D SUPP^PRCFFM2M S SFUND=1
        I SFUND=1 W !?3,"SEND TO SUPPLY " S PRCHQ="^PRCHPAM",D0=PRCHPO,D1=PRCHAM D ^PRCHQUE
        D SOURCE^PRCHAMU:$G(SCE)
        G EXIT
ENC     S ER=0
        D CAN^PRCHMA3
        I $G(NOCAN)=1 W !?5,$S($D(PRCHREQ):"REQUISITION",1:"PURCHASE ORDER")_" HAS BEEN RECEIVED, CANNOT CANCEL !",$C(7) S ER=1 Q
        I $G(PRCHAUTH)=1 D PAID^PRCHINQ I $G(PAID)=1 D  S ER=1 Q
        . W !,?5,"THERE HAS BEEN PAYMENT MADE FOR THIS PURCHASE CARD ORDER, CANNOT CANCEL !",$C(7)
        S %="",%A="     SURE YOU WANT TO CANCEL THIS ORDER ",%B="" D ^PRCFYN
        I %'=1 W ?40,"    <NOTHING CANCELLED>" D  Q
        .I $D(PRCHAU) D
        ..S $P(^PRC(443.6,PRCHPO,6,PRCHAM,0),U,4)=PRCHAU
        ..S $P(^PRC(443.6,PRCHPO,6,PRCHAM,1),U,4)=""
        .S NOCAN=1
        S DA(1)=PRCHPO,DIE="^PRC(443.6,"_DA(1)_",6,",DA=PRCHAM,DR="9////^S X=$O(^PRCD(442.3,""C"",45,0))"
        D ^DIE K DIE,DA,DR S CAN=1
        S PRCHAMT=-$P(^PRC(443.6,PRCHPO,0),U,15) W !
        QUIT
APP     S %A="   Approve Amendment number "_PRCHAM_": ",%B="",%=$S($G(PRCPROST):1,1:2) D ^PRCFYN
        Q
REV     N PRCH
        S %=1,%B="",%A="   Review Amendment " D ^PRCHSF3 W ! D ^PRCFYN
        I %=1 S D0=PRCHPO,D1=PRCHAM,PRCH="^PRC(443.6," D ^PRCHDAM
        Q
EXIT    L -^PRC(442,PRCENTRY)
EXIT1   K ERROR,FIS,REPO,DEL
        QUIT:$G(PRCPROST)
        I $G(OUT)'=1 G LOOP
        QUIT
FLAG    I $G(FLAG)=1 K FLAG Q
        Q
NOSIGN  S $P(^PRC(443.6,PRCHPO,6,PRCHAM,0),U,4)=PRCHAU
NOSIGN1 S DA(1)=PRCHPO,DIE="^PRC(443.6,"_DA(1)_",6,",DA=PRCHAM,DR="9///@"
        D ^DIE K DIE,DA,DR
        Q
TOP     ;PAUSE AT BOTTOM OF SCREEN
        N DIR S DIR(0)="E"
        D ^DIR
        S LCNT=1
        Q
