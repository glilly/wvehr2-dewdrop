PSORXI  ;IHS/DSD/JCM - logs pharmacy interventions ;03/19/93 11:56
        ;;7.0;OUTPATIENT PHARMACY;**268,324**;DEC 1997;Build 6
        ; This routine is used to create entries in the APSP INTERVENTION file.
START   ;   
        D INIT,DIC G:PSORXI("QFLG") END
        D EDIT
        S:'$D(PSONEW("PROVIDER")) PSONEW("PROVIDER")=$P(^APSPQA(32.4,PSORXI("DA"),0),"^",3)
END     D EOJ
        Q
INIT    ;
        W !!,"Now creating Pharmacy Intervention",!
        I $G(PSODRUG("IEN")) W "for  "_$P($G(^PSDRUG(PSODRUG("IEN"),0)),"^"),!
        K PSORXI S PSORXI("QFLG")=0
        Q
DIC     ;
        K DIC,DR,DA,X,Y,DD,DO S DIC="^APSPQA(32.4,",DLAYGO=9009032.4,DIC(0)="L",X=DT
        S DIC("DR")=".02////"_+PSODFN_";.04////"_DUZ_";.05////"_PSODRUG("IEN")_";.06///PHARMACY"
        S DIC("DR")=DIC("DR")_";.07"_$S($G(PSORX("INTERVENE"))=1:"////18",$G(PSORX("INTERVENE"))=2:"////19",1:"////6")_";.14////0"_";.16////"_$S($G(PSOSITE)]"":PSOSITE,1:"")
        D FILE^DICN K DIC,DR,DA
        I Y>0 S PSORXI("DA")=+Y,^TMP($J,"PSOINTERVENE",PSODFN)=+Y
        E  S PSORXI("QFLG")=1 G DICX
        D DIE
DICX    K X,Y
        Q
DIE     ;
        K DIE,DIC,DR,DA
        S DIE="^APSPQA(32.4,",DA=PSORXI("DA"),DR=$S($G(PSORXI("EDIT"))]"":".03:1600",1:".03;.08")
        L +^APSPQA(32.4,PSORXI("DA")):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3) D ^DIE K DIE,DIC,DR,X,Y,DA L -^APSPQA(32.4,PSORXI("DA"))
        W $C(7),!!,"See 'Pharmacy Intervention Menu' if you want to delete this",!,"intervention or for more options.",!
        Q
EDIT    ;
        K DIR W ! S DIR(0)="Y",DIR("A")="Would you like to edit this intervention ",DIR("B")="N" D ^DIR K DIR I $D(DIRUT)!'Y G EDITX
        S PSORXI("EDIT")=1 D DIE G EDIT
EDITX   W ! K X,Y
        Q
DUPINV  ;Duplicate and file intervention
        N PSOARY,PSOARYC,PSOMSG,PSODA,DUP,DIC,DA,DLAYGO,Y,X
        S DUP=^TMP($J,"PSOINTERVENE",+PSODFN),DIC="^APSPQA(32.4,",DIC(0)="AEQM"
        D GETS^DIQ(9009032.4,DUP,"**","I","PSOARY","PSOMSG")
        I $D(PSOMSG) W !,"Error Retrieving Last Duplicate..." G START
        L +^APSPQA(32.4):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3)
        K DIC,DR,DA,X,Y,DD,DO
        S DIC="^APSPQA(32.4,",DLAYGO=9009032.4,DIC(0)="",X=DT
        D FILE^DICN
        L -^APSPQA(32.4)
        I Y<1 W !,"Error Encountered Filing Duplicate..." Q
        S DA=+Y,PSORXI("DA")=+Y,X=0,^TMP($J,"PSOINTERVENE",PSODFN)=+Y
        F  S X=$O(PSOARY(9009032.4,DUP_",",X)) Q:'X  D
        .S PSOARYC(9009032.4,DA_",",X)=PSOARY(9009032.4,DUP_",",X,"I")
        S PSOARYC(9009032.4,DA_",",.05)=PSODRUG("IEN")
        S PSOARYC(9009032.4,DA_",",.15)=""
        D FILE^DIE("K","PSOARYC","PSOMSG") I $D(PSOMSG) D  G START
        .W !,"Error Encountered Filing Duplicate..."
        .N DIK S DA=PSORXI("DA"),DIK="^APSPQA(32.4," D ^DIK
        W ! D EN^DIQ,EDIT
        Q
EOJ     ;
        K PSORXI
        Q
EN1(PSOX)       ; Entry Point if have internal rx #
        N PSODFN,PSONEW,PSODRUG,PSOY
        I $G(^PSRX(+$G(PSOX),0))']"" W !,$C(7),"No prescription data" G EN1X
        S PSORXI("IRXN")=PSOX K PSOY S PSOY=^PSRX(PSORXI("IRXN"),0)
        S PSODFN=$P(PSOY,"^",2),PSONEW("PROVIDER")=$P(PSOY,"^",4),PSODRUG("IEN")=$P(PSOY,"^",6)
        D START
EN1X    Q
