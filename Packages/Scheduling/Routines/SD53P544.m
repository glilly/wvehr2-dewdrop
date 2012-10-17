SD53P544        ;ALB/RC - POST-INSTALL SD*5.3*544 ; 8/3/09 11:13am
        ;;5.3;Scheduling;**544**;Aug 13, 1993;Build 11
        Q
EN      ;Post install entry point
        N SDX,Y
        F SDX="POST" D
        .S Y=$$NEWCP^XPDUTL(SDX,SDX_"^SD53P544")
        .I 'Y D BMES^XPDUTL("ERROR creating "_SDX_" checkpoint.")
        Q
POST    ;Post-Install
        D CLERK
        D DEL
        Q
CLERK   ;Find entries and match up the data entry clerk/time
        N SDPT,SDAPPT,SDCLINIC,SDAPTNUM,SDCLK,SDAPDTM,SDIENS
        N DA,DIE
        I '$D(^XTMP("SD53P544-"_$J,0)) S ^XTMP("SD53P544-"_$J,0)=$$FMADD^XLFDT(""_DT_"",30)_U_DT_U_"Records updated by SD*5.3*544"
        S (SDCLK,SDAPDTM)=""
        S SDPT=0
        F  S SDPT=$O(^DPT(SDPT)) Q:SDPT'>0  D
        .S SDAPPT=3080930.999999
        .F  S SDAPPT=$O(^DPT(SDPT,"S",SDAPPT)) Q:SDAPPT'>0  D
        ..I $P(^DPT(SDPT,"S",SDAPPT,0),"^",18)="" D
        ...S SDCLINIC=$P(^DPT(SDPT,"S",SDAPPT,0),"^",1),SDAPTNUM=0 Q:SDCLINIC'>0
        ...F  S SDAPTNUM=$O(^SC(SDCLINIC,"S",SDAPPT,1,SDAPTNUM)) Q:SDAPTNUM'>0  D
        ....I $P($G(^SC(SDCLINIC,"S",SDAPPT,1,SDAPTNUM,0)),"^",1)=SDPT D
        .....S SDIENS=""_SDAPTNUM_","_SDAPPT_","_SDCLINIC_","_""
        .....S SDCLK=$$GET1^DIQ(44.003,SDIENS,7,"I")
        .....S SDAPDTM=$$GET1^DIQ(44.003,SDIENS,8,"I")
        .....I $G(SDCLK) S $P(^DPT(SDPT,"S",SDAPPT,0),"^",18)=SDCLK,$P(^XTMP("SD53P544-"_$J,SDPT,SDAPPT),U)=SDCLK
        .....I $G(SDAPDTM) S $P(^DPT(SDPT,"S",SDAPPT,0),"^",19)=SDAPDTM,$P(^XTMP("SD53P544-"_$J,SDPT,SDAPPT),U,2)=SDAPDTM
        Q
DEL     ;
        N DIK,DA
        Q:'$D(^DD(2.011,1.5))  ;Quit if global doesn't exist.
        S DIK="^DD(2.011,",DA=1.5,DA(1)=2
        D ^DIK
        Q
