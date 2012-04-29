GMRAVFY ;HIRMFO/WAA,PWC-VERIFY AND SIGN OFF AN AGENT ; 5/23/07 10:32am
        ;;4.0;Adverse Reaction Tracking;**2,33**;Mar 29, 1996;Build 5
EN1     ;This is the main entry point for the verifier option.
        S GMRAVER=0,GMRADRUG=0
        I $P(GMRAPA(0),U,20)'["D" S GMRAFLAG=0 G VERIFY
        S GMRAFLAG=1,GMRADRUG=1
        I $P(GMRAPA(0),U,6)'="o" G VERIFY
        I '$D(GMRASITE) D SITE^GMRAUTL S GMRASITE(0)=$G(^GMRD(120.84,GMRASITE,0))
        I $P(^GMRD(120.84,+GMRASITE,0),U,7)'="y" G VERIFY
        I $D(^GMR(120.85,"C",GMRAPA)) G VERIFY
        W !,"Since this Causative Agent is an observed drug reaction and"
        W !,"FDA Data is required you must enter the Observer information"
        W !,"prior to verification."
        G EXIT
VERIFY  ;Verify an agent
        W !!,"Currently you have verifier access."
        F  W !,"Would you like to verify this Causative Agent now" S %=1 D YN^DICN Q:%'=0  W !?4,"ANSWER YES IF YOU WOULD LIKE TO VERIFY THIS DATA, ELSE ANSWER NO."
        S:%=-1 GMRAOUT=1 G EXIT:%'=1 S GMRAVFY=1 W @IOF,! D SITE^GMRAUTL,EN2^GMRAPEV0 K GMRAVFY G:GMRAOUT EXIT
        I GMRAVER S GMRANAME=$P($G(^DPT(+GMRAPA(0),0)),U),GMRALLER=$P(GMRAPA(0),U,2) K:GMRANAME]""&(GMRALLER]"") ^TMP($J,"GMRADSP",GMRANAME,GMRALLER,GMRAPA) K ^TMP("GMRA",$J)
        I 'GMRAVER!GMRAOUT G EXIT
        S GMRAPA(0)=$G(^GMR(120.8,GMRAPA,0)) Q:GMRAPA(0)=""
        I '$P(GMRAPA(0),U,12) S DA=GMRAPA,DIE="^GMR(120.8,",DR="15////1" D ^DIE D  ; Execute the event point for this reaction
        .Q:'$D(GMRAPA)  S GMRAPA(0)=$G(^GMR(120.8,GMRAPA,0)) Q:GMRAPA(0)=""
        .N OROLD,DFN,GMRACNT S DFN=$P(GMRAPA(0),U)
        .D INP^VADPT S X=$O(^ORD(101,"B","GMRA SIGN-OFF ON DATA",0))_";ORD(101," D EN^XQOR:X K VAIN,X
        .Q
        S GMRAPA(0)=$G(^GMR(120.8,GMRAPA,0)),GMRATYPE=$P(GMRAPA(0),U,20)
        S DA=GMRAPA,DIE="^GMR(120.8,",DR="19////1;20///N;21////"_DUZ D ^DIE D:'GMRAVER EN1^GMRAVAB S GMRAPA(0)=$S($D(^GMR(120.8,GMRAPA,0)):^(0),1:"")
        I $G(GMRANEW) D  ;send NOTIFICATION bulletin if this is new -- GMRA*4*33
        . I $P(GMRAPA(0),U,6)="o",GMRATYPE["D" D PTBUL^GMRAROBS
        I GMRAVER D EN1^GMRAPET0($P(GMRAPA(0),U),GMRAPA,"V",.GMRAOUT) I GMRAOUT S GMRAOUT=0
Q1      D UNLOCK^GMRAUTL(120.8,GMRAPA)
EXIT    K GMRAFLAG,DA,DIE,DR,GMRADRUG Q
