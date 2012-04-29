GMRAPED0        ;HIRMFO/RM,WAA-VERIFIER EDIT OF DRUG A/AR ;11/16/07  10:03
        ;;4.0;Adverse Reaction Tracking;**17,41**;Mar 29, 1996;Build 8
        ;DBIA Section
        ;PSN50P41 - 4531
        ;PSN50P65 - 4543
        ;DICN     - 10009
        ;DIE      - 10018
        ;XLFDT    - 10103
EN1     ; ENTRY TO EDIT INFO SPECIFIC TO DRUG A/AR FOR VERIFIER
        K GMRAINGR,GMRACLAS,^TMP($J,"GMRAING"),^TMP($J,"GMRADCL") ;41 Add ^TMP to list
        I '$D(^XUSEC("GMRA-ALLERGY VERIFY",DUZ)) G Q1
        S GMRAPA(0)=$G(^GMR(120.8,GMRAPA,0)) G:GMRAPA(0)="" Q1
        F GMRAINGR=0:0 S GMRAINGR=$O(^GMR(120.8,GMRAPA,2,GMRAINGR)) Q:GMRAINGR'>0  D  ;41 Added block structure
        .S X=$S($D(^GMR(120.8,GMRAPA,2,GMRAINGR,0)):^(0),1:"") I +X>0 D ZERO^PSN50P41(+X,,$$DT^XLFDT,"GMRAING") S Y=$S($D(^TMP($J,"GMRAING",+X,.01)):^(.01),1:"") I $P(Y,U)'="" S GMRAINGR($P(Y,U),+X)=Y ;41 added call to ZERO
        F GMRACLAS=0:0 S GMRACLAS=$O(^GMR(120.8,GMRAPA,3,GMRACLAS)) Q:GMRACLAS'>0  D  ;41 Added dot structure
        .S X=$S($D(^GMR(120.8,GMRAPA,3,GMRACLAS,0)):^(0),1:"") I +X>0 D C^PSN50P65(+X,,"GMRADCL") S Y=$S($D(^TMP($J,"GMRADCL",+X,.01)):^(.01)_U_$G(^(1)),1:"") I $P(Y,U)'="" S GMRACLAS($P(Y,U),+X)=Y ;41 Added call to C^PSN50P65
        S GMRAPA(0)=$G(^GMR(120.8,GMRAPA,0))
        W @IOF
        W !,"CAUSATIVE AGENT: ",$P(GMRAPA(0),U,2)
        W !?11,"TYPE: ",$$OUTTYPE^GMRAUTL($P(GMRAPA(0),U,20))
        W !?4,"INGREDIENTS: " S Y="",GMRAPRSW=0 F  S Y=$O(GMRAINGR(Y)) Q:Y=""  F X=0:0 S X=$O(GMRAINGR(Y,X)) Q:X'>0  W:GMRAPRSW ! W ?17,Y S:'GMRAPRSW GMRAPRSW=1
        W !,"VA DRUG CLASSES: "
        S Y="",GMRAPRSW=0 F  S Y=$O(GMRACLAS(Y)) Q:Y=""  F X=0:0 S X=$O(GMRACLAS(Y,X)) Q:X'>0  W:GMRAPRSW ! W ?17,Y," - ",$P(GMRACLAS(Y,X),U,2) S:'GMRAPRSW GMRAPRSW=1
        W !,"       OBS/HIST: ",$S($P(GMRAPA(0),U,6)="o":"OBSERVED",$P(GMRAPA(0),U,6)="h":"HISTORICAL",1:"")
        D  ;Sign/Symptoms
        .N GMRAVFY
        .S GMRAVFY=1
        .D EN1^GMRADSP3
        .Q
        W !,"      MECHANISM: ",$S($P(GMRAPA(0),U,14)="A":"ALLERGY",$P(GMRAPA(0),U,14)="P":"PHARMACOLOGIC",$P(GMRAPA(0),U,14)="U":"UNKNOWN",1:"")
YNED    W !!,"Would you like to edit any of this data" S %=0 D YN^DICN I '% W !?4,$C(7),"ANSWER YES IF YOU WISH TO CHANGE ANY OF THE DATA ABOVE, ELSE ANSWER NO." G YNED
        S:%=-1 GMRAOUT=1 G Q1:%=2!GMRAOUT
        D EN1^GMRAPED3 G:GMRAOUT Q1 I GMRAAR'="" S DIE="^GMR(120.8,",DA=GMRAPA,DR=".02////^S X=GMRAAR(0);1////^S X=GMRAAR"_$S($D(GMRAAR("O")):";3.1////"_GMRAAR("O"),1:"") D ^DIE
        S GMRAPA(0)=$G(^GMR(120.8,+GMRAPA,0))
        S GMRAEN=GMRAPA_";GMR(120.8," D INPTYPE^GMRAUTL(GMRAEN) G Q1:GMRAOUT
        S DA=GMRAPA,DIE="^GMR(120.8,",DR="2" D ^DIE S:$D(Y) GMRAOUT=1 G Q1:GMRAOUT
        S GMRAPA(0)=$G(^GMR(120.8,+GMRAPA,0))
        D DRGCLS^GMRAPED1
        I 'GMRAOUT F  K Y D  Q:GMRAOUT!('$D(Y))
        .S GMRAPA(0)=$S($D(^GMR(120.8,GMRAPA,0)):^(0),1:"")
        .S DR="6(O)bserved or (H)istorical Allergy/Adverse Reaction",DIE="^GMR(120.8,",DA=GMRAPA D ^DIE
        .I $D(Y) S GMRAOUT=1 Q
        .S GMRANEW(0)=$S($D(^GMR(120.8,GMRAPA,0)):^(0),1:"")
        .I $P(GMRANEW(0),"^",6)="" W $C(7),"  Required??" S Y="" Q
        .Q:$P(GMRANEW(0),"^",6)=$P(GMRAPA(0),"^",6)
        .I $P(GMRAPA(0),"^",6)'=$P(GMRANEW(0),"^",6) D  Q
        ..W !!,"You cannot change the type of reaction.  If this is incorrect",!,"please exit and mark this entry as entered-in-error and then re-enter",!,"the correct information.",!
        ..S DIE="^GMR(120.8,",DR="6////"_$P(GMRAPA(0),"^",6),DA=GMRAPA D ^DIE S Y="" Q
        ..Q
        .Q
        I 'GMRAOUT D EN1^GMRAPER2(GMRAPA,"120.8",.GMRAOUT)
        I 'GMRAOUT D MECH Q:GMRAOUT
        S GMRAPA(0)=$S($D(^GMR(120.8,GMRAPA,0)):^(0),1:"")
        S GMRAOUT=0 G EN1
Q1      ;Exit
        K GMRAEN,X,GMRAAR,^TMP($J,"GMRAING"),^TMP($J,"GMRADCL") ;41 Added ^TMP
        K DA,DIE,DR
        Q
MECH    ;Mechanism for ADRs
        F  W !!,?5,"Choose one of the following:",! D  Q:GMRAOUT!('$D(Y))
        .F GMRAMEC="A - ALLERGY","P - PHARMACOLOGICAL","U - UNKNOWN" W !,?20,GMRAMEC
        .W ! S DIE="^GMR(120.8,",DA=GMRAPA,DR=17 D ^DIE
        .S:$D(Y) GMRAOUT=1
        .Q
        Q
HELP    ; HELP FOR A/AR LOOKUP
        D HELP^GMRAPED0 ;41 removed duplicate code and added call to HELP
        Q
DIC     ; VALIDATE LOOKUP FOR A/AR
        S:$D(DTOUT) X="^^" I X="^^" S GMRAOUT=1 Q
        S:$D(DUOUT) Y=0 Q:+Y'>0
YNOK    W !?3,X,"   OK" S %=1 D YN^DICN S:%=-1 GMRAOUT=1,Y=-1 S:%=2 Y=-1 I % W ! Q
        W !?5,$C(7),"ANSWER YES IF THIS IS THE CORRECT ALLERGY/ADVERSE REACTION,",!?5,"ELSE ANSWER NO."
        G YNOK
HEAD    ; Header for reactions
        W @IOF
        W !,"Reactions: (cont.) "
        Q
