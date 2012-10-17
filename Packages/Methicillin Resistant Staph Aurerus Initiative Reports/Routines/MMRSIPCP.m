MMRSIPCP        ;MIA/LMT - SETUP MRSA TOOLS SOFTWARE PARAMETERS ;11-18-08
        ;;1.0;MRSA PROGRAM TOOLS;;Mar 22, 2009;Build 35
        ;
DIV     ;Add a division and setup business rules
        N DIC,X,DINUM,DLAYGO,MMRSDIV,DIR,DIE,DA,DR,DIDEL,Y
        S DIC="^MMRS(104,"
        S DIC(0)="AELMQ"
        S DIC("A")="Select MRSA Site Parameters Division: "
        S DLAYGO=104
        D ^DIC
        K DLAYGO
        I $D(DTOUT)!($D(DUOUT))!(Y=-1) S EXTFLG=1 Q
        S MMRSDIV=+Y
        W !!
        ;RECEIVING UNIT SCREEN
        S DA=MMRSDIV
        S DIR("A")="1. Receiving unit screen on unit-to-unit transfers"
        S DIR(0)="104,1"
        D ^DIR
        I $D(DTOUT)!($D(DUOUT)) S EXTFLG=1 Q
        S DIE="^MMRS(104,"
        S DA=MMRSDIV
        S Y=+$P(Y,U,1)
        S DR="1////"_Y
        I Y=1!(Y=0) D ^DIE
        ;DISCHARGING UNIT SCREEN
        S DA=MMRSDIV
        S DIR("A")="2. Discharging unit screen on unit-to-unit transfers"
        S DIR(0)="104,2"
        D ^DIR
        I $D(DTOUT)!($D(DUOUT)) S EXTFLG=1 Q
        S DIE="^MMRS(104,"
        S DA=MMRSDIV
        S Y=+$P(Y,U,1)
        S DR="2////"_Y
        I Y=1!(Y=0) D ^DIE
        ;SCREEN POS ON TRANSFER IN
        S DA=MMRSDIV
        S DIR("A")="3. Screen patients with MRSA history on transfer-in"
        S DIR(0)="104,3"
        D ^DIR
        I $D(DTOUT)!($D(DUOUT)) S EXTFLG=1 Q
        S DIE="^MMRS(104,"
        S DA=MMRSDIV
        S Y=+$P(Y,U,1)
        S DR="3////"_Y
        I Y=1!(Y=0) D ^DIE
        ;SCREEN POS ON DISCHARGE
        S DA=MMRSDIV
        S DIR("A")="4. Screen patients with MRSA history on discharge/death/transfer-out"
        S DIR(0)="104,4"
        D ^DIR
        I $D(DTOUT)!($D(DUOUT)) S EXTFLG=1 Q
        S DIE="^MMRS(104,"
        S DA=MMRSDIV
        S Y=+$P(Y,U,1)
        S DR="4////"_Y
        I Y=1!(Y=0) D ^DIE
        Q
LAB     ;Entry to setup the Lab Search/Extract Parameters
        N EXTFLG,MMRSDIV,MDRO,DA,DO,DIC,DINUM,X,Y,DDSFILE,DR,DDSPAGE,DDSPARAM,DIR
        D CHECK^MMRSIPC
        I $D(EXTFLG) W ! H 2 Q
        W !
        S MMRSDIV=$$GETDIV^MMRSIPC Q:$D(EXTFLG)!(MMRSDIV="")
        W !
        S MDRO=$$GETMDRO Q:$D(EXTFLG)
        W !
        S DIR(0)="Y",DIR("B")="YES",DIR("A")="Do you want to see a description for "_$$GET1^DIQ(104.2,MDRO,.01)
        D ^DIR
        I $D(DTOUT)!($D(DUOUT)) S EXTFLG=1 Q
        I Y=1 D
        .N DIC,DA,DR,DIQ,DIR
        .W @IOF
        .S DIC="^MMRS(104.2,"
        .S DA=MDRO
        .S DR=2
        .D EN^DIQ
        .S DIR(0)="E",DIR("A")="Enter RETURN to continue" D ^DIR
        W !
        S DA=$O(^MMRS(104.1,"C",MMRSDIV,MDRO,0))
        I 'DA D  Q:$D(EXTFLG)!('DA)
        .K DA
        .S DIC="^MMRS(104.1,"
        .S DIC(0)="F"
        .S X=MDRO
        .S DIC("DR")="1////"_MMRSDIV
        .D FILE^DICN
        .I Y=-1 S EXTFLG=1 Q
        .S DA=+Y
        S DDSFILE="^MMRS(104.1,"
        S DR="[MMRSLABPARAM]"
        D ^DDS
        Q
GETMDRO()       ;
        N MDRO,DIC,DLAYGO,DINUM,Y,DLAYGO,X,DTOUT,DUOUT
        S MDRO=""
        S DIC="^MMRS(104.2,"
        S DIC(0)="AEMNQ"
        S DIC("A")="Select the MDRO: "
        D ^DIC K DIC
        I $D(DTOUT)!($D(DUOUT))!(Y=-1) S EXTFLG=1 Q ""
        S MDRO=+Y
        Q MDRO
WARDMAP ;Entry to setup the Ward Mappings
        N MMRSDIV,DIC,Y,DLAYGO,DINUM,X,DTOUT,DUOUT,DDSFILE,DR,DA,DDSPAGE,DDSPARAM,EXTFLG,DIE,DIDEL,MMRSDA
        D CHECK^MMRSIPC
        I $D(EXTFLG) W ! H 2 Q
        W !
        S MMRSDIV=$$GETDIV^MMRSIPC Q:$D(EXTFLG)!(MMRSDIV="")
        F  Q:$D(EXTFLG)  D
        .S DIC="^MMRS(104.3,"
        .S DIC(0)="AELMQ"
        .S DIC("A")="Select Geographical Unit: "
        .S DIC("DR")="1////"_MMRSDIV_";3;4"
        .S DLAYGO=104.3
        .W !! D ^DIC
        .K DLAYGO
        .I $D(DTOUT)!($D(DUOUT))!(Y=-1) S EXTFLG=1 Q
        .S MMRSDA=+Y
        .I '$P(Y,U,3) D
        ..S DIE="^MMRS(104.3,"
        ..S DA=MMRSDA
        ..S DR=".01;3;4"
        ..S DIDEL=104.3
        ..W !
        ..D ^DIE
        ..I $D(DTOUT)!('$D(DA)) S EXTFLG=1 Q
        .Q:$D(EXTFLG)
        .S DDSFILE="^MMRS(104.3,"
        .S DR="[MMRSMRSA WARD MAP]"
        .S DA=MMRSDA
        .D ^DDS
        .W @IOF
        Q
HISTDAY ;Historical Days Edit
        N EXTFLG,MMRSDIV,MDRO,DA,DO,DIC,DINUM,X,Y,DIR,NUMDAY,MMRSX,DIE,DR,DIDEL,DIRUT,DTOUT,DUOUT
        D CHECK^MMRSIPC
        I $D(EXTFLG) W ! H 2 Q
        W ! S MMRSDIV=$$GETDIV^MMRSIPC Q:$D(EXTFLG)!(MMRSDIV="")
        W !
        S MDRO=0 F  S MDRO=$O(^MMRS(104.2,MDRO)) Q:'MDRO  D  Q:$D(EXTFLG)
        .S DA=$O(^MMRS(104.2,MDRO,1,"B",MMRSDIV,0))
        .I 'DA D  Q:$D(EXTFLG)!('DA)
        ..K DA
        ..S DIC="^MMRS(104.2,"_MDRO_",1,"
        ..S DIC(0)="F"
        ..S DA(1)=MDRO
        ..S X=MMRSDIV
        ..D FILE^DICN
        ..I Y=-1 S EXTFLG=1 Q
        ..S DA=+Y
        .S DA(1)=MDRO
        .S DIR(0)="104.22,1^AO"
        .S DIR("PRE")="I X=""@"" S X=9876 S MMRSX=9876"
        .S DIR("A")="Enter the number of days to search for "_$P($G(^MMRS(104.2,MDRO,0)),U,1)
        .D ^DIR
        .I $D(DTOUT)!($D(DUOUT)) S EXTFLG=1 Q
        .I Y D
        ..S DIE="^MMRS(104.2,"_MDRO_",1,"
        ..I $G(MMRSX)'=9876 S DR="1////"_+Y
        ..I Y=9876,($G(MMRSX)=9876) S DR="1////@"
        ..K MMRSX
        ..D ^DIE
        W !
        Q
ISLTORD ;Entry to setup the Isolation Orders Parameters
        N EXTFLG,MMRSDIV,DA,DDSFILE,DR,DDSPAGE,DDSPARAM
        D CHECK^MMRSIPC
        I $D(EXTFLG) W ! H 2 Q
        W !
        S MMRSDIV=$$GETDIV^MMRSIPC Q:$D(EXTFLG)!(MMRSDIV="")
        W !
        S DA=MMRSDIV
        S DDSFILE="^MMRS(104,"
        S DR="[MMRSISLTORD]"
        D ^DDS
        Q
