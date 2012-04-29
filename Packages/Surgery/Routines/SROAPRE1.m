SROAPRE1        ;BIR/MAM - EDIT PAGE 1 PREOP ;11/26/07
        ;;3.0; Surgery ;**38,47,125,135,141,166**;24 Jun 93;Build 7
        K DA D @EMILY Q
1       ; edit general information
        W ! K DIR S X=$P(SRAO(1),"^") I X'="" S DIR("B")=X
        S DIR(0)="130,402",DIR("A")="GENERAL" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
        I X="@" S SRCAT="General" D SURE Q:SRSOUT  G:'SRYN 1 S (SRAX,X)="",$P(^SRF(SRTN,200),"^")="" D NOGEN Q
        S SRAX=Y,$P(^SRF(SRTN,200),"^")=SRAX I Y["N" D NOGEN Q
        I Y["Y" D GEN
        Q
2       ; edit pulmonary information
        W ! K DIR S X=$P(SRAO(2),"^") I X'="" S DIR("B")=X
        S DIR(0)="130,241",DIR("A")="PULMONARY" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
        I X="@" S SRCAT="Pulmonary" D SURE Q:SRSOUT  G:'SRYN 2 S (SRAX,X)="",$P(^SRF(SRTN,200),"^",9)="" D NOPULM Q
        S SRAX=Y,$P(^SRF(SRTN,200),"^",9)=SRAX I Y["N" D NOPULM Q
        I Y["Y" D PULM
        Q
3       ; edit hepatobiliary information
        W ! K DIR S X=$P(SRAO(3),"^") I X'="" S DIR("B")=X
        S DIR(0)="130,244",DIR("A")="HEPATOBILIARY" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
        I X="@" S SRCAT="Hepatobiliary" D SURE Q:SRSOUT  G:'SRYN 3 S (SRAX,X)="",$P(^SRF(SRTN,200),"^",13)="" D NOHEP Q
        S SRAX=Y,$P(^SRF(SRTN,200),"^",13)=SRAX I Y["N" D NOHEP Q
        I Y["Y" D HEP
        Q
GEN     ; general
        N SRUP S SRUP=""
        W ! K DR,DIE S DA=SRTN,DIE=130,DR="236T;237T;346T;202T;246T;325T;238T" D ^DIE K DIE,DR I $D(Y) Q
        K DIR S DA=SRTN,DIR(0)="130,492",DIR("A")="Functional Health Status at Evaluation for Surgery" D ^DIR K DIR D
        .I $D(DTOUT)!$D(DUOUT) Q
        .I X="@" K DIE,DR S DIE=130,DR="492///@" D ^DIE K DA,DIE,DR Q
        .K DIE,DR S DIE=130,DR="492////"_Y D ^DIE K DA,DIE,DR
        S SRACLR=0
        Q
NOGEN   ; no general problems
        S $P(^SRF(SRTN,200),"^",6)=$S(X="":"",1:1) F I=2,3,4,7 S $P(^SRF(SRTN,200),"^",I)=SRAX
        S $P(^SRF(SRTN,200.1),"^",2)=$S(X="":"",X="NS":"NS",1:1)
        Q
PULM    ; pulmonary
        W ! K DR,DIE S DA=SRTN,DIE=130,DR="204T;203T;326T" D ^DIE K DR
        S SRACLR=0
        Q
NOPULM  ; no pulmonary problems
        F I=10:1:12 S $P(^SRF(SRTN,200),"^",I)=SRAX
        Q
HEP     ; hepatobiliary
        K DR,DIE S DIE=130,DA=SRTN,DR="212////Y" D ^DIE K DR
        S SRACLR=0
        Q
NOHEP   ; no hepatobiliary problems
        S $P(^SRF(SRTN,200),"^",15)=SRAX
        Q
RET     W !! K DIR S DIR(0)="E" D ^DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
        Q
SURE    W ! K DIR S DIR("A")="   Sure you want to delete all "_SRCAT_" information ? ",DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR S SRYN=Y I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
        Q
NO2ALL  ; set all fields to NO
        S SRAX="N",$P(^SRF(SRTN,200),"^")=SRAX D NOGEN
        S $P(^SRF(SRTN,200),"^",9)=SRAX D NOPULM
        S $P(^SRF(SRTN,200),"^",13)=SRAX D NOHEP
        S $P(^SRF(SRTN,200.1),"^")=SRAX D NOGAST^SROAPR1A
        S $P(^SRF(SRTN,200),"^",30)=SRAX D NOCARD^SROAPR1A
        S $P(^SRF(SRTN,200),"^",40)=SRAX D NOVAS^SROAPR1A
        Q
