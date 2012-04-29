ORWTPT  ; SLC/STAFF Personal Preference - Teams ;5/4/01  15:55
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**85,243**;Oct 24, 2000;Build 242
        ;
GETTEAM(USERS,TEAM)     ; RPC
        ; returns members of a team
        N CNT,NAME,NUM,USER K USERS
        S TEAM=+$G(TEAM),CNT=0
        S NUM=0 F  S NUM=$O(^OR(100.21,TEAM,1,NUM)) Q:NUM<1  S USER=+$G(^(NUM,0)) D
        .S NAME=$P($G(^VA(200,USER,0)),U)
        .I '$L(NAME) Q
        .S CNT=CNT+1
        .S USERS(CNT)=USER_U_NAME
        Q
        ;
TEAMS(TEAMS,USER)       ; from ORWTPP
        ; returns all teams a user is a member of (exculdes personal lists)
        N CNT,NUM,ZERO K TEAMS
        S USER=+$G(USER),CNT=0
        S NUM=0 F  S NUM=$O(^OR(100.21,"C",USER,NUM)) Q:NUM<1  D
        .S ZERO=$G(^OR(100.21,NUM,0))
        .I $P(ZERO,U,2)="P" Q
        .S CNT=CNT+1
        .S TEAMS(CNT)=NUM_U_ZERO
        Q
        ;
PLISTS(TEAMS,USER)      ; from ORWTPP
        ; returns a user's personal lists
        N CNT,NUM,ZERO K TEAMS
        S USER=+$G(USER),CNT=0
        S NUM=0 F  S NUM=$O(^OR(100.21,"C",USER,NUM)) Q:NUM<1  D
        .S ZERO=$G(^OR(100.21,NUM,0))
        .I $P(ZERO,U,2)'="P" Q
        .S CNT=CNT+1
        .N VIS S VIS=$P($G(^OR(100.21,NUM,11)),U)
        .I '$L(VIS) S VIS=1
        .S TEAMS(CNT)=NUM_U_ZERO_U_VIS
        Q
        ;
PLTEAMS(TEAMS,USER)     ; from ORWTPP
        ; returns all teams and personal lists for a user
        N CNT,NUM,ZERO K TEAMS
        S USER=+$G(USER),CNT=0
        S NUM=0 F  S NUM=$O(^OR(100.21,"C",USER,NUM)) Q:NUM<1  D
        .S ZERO=$G(^OR(100.21,NUM,0))
        .S CNT=CNT+1
        .S TEAMS(CNT)=NUM_U_ZERO
        Q
        ;
ATEAMS(TEAMS)   ; RPC
        ; all teams available to subscribe to
        N CNT,NAME,NODE,NUM K TEAMS
        S CNT=0
        S NUM=0 F  S NUM=$O(^OR(100.21,NUM)) Q:NUM<1  S NODE=$G(^(NUM,0)) D
        .I $P(NODE,U,6)'="Y" Q
        .I $P(NODE,U,2)="P" Q
        .S CNT=CNT+1
        .S TEAMS(CNT)=NUM_U_NODE ;$P(NODE,U)
        Q
        ;
ADDLIST(OK,VALUE,USER)  ; from ORWTPP
        ; adds a user to a team
        N DA,DIC,DLAYGO,X,Y K DA,DIC,DLAYGO
        S USER=+$G(USER)
        S DA=USER,DA(1)=+$G(VALUE),OK=1
        I '$D(^OR(100.21,DA(1),0)) Q
        S DIC(0)="LM"
        S DLAYGO=100.212
        S X=$P($G(^VA(200,USER,0)),U)
        S DIC="^OR(100.21,"_DA(1)_",1,"
        D
        .L +^OR(100.21,DA(1)):5 I '$T Q
        .D ^DIC
        .L -^OR(100.21,DA(1))
        I Y=-1 S OK=0
        K DA,DIC,DLAYGO
        Q
        ;
REMLIST(OK,VALUE,USER)  ; from ORWTPP
        ; removes a user from a team
        N DA,DIK K DA
        S DA=+$G(USER),DA(1)=+$G(VALUE),OK=1
        I '$D(^OR(100.21,DA(1),0)) Q
        S DIK="^OR(100.21,"_DA(1)_",1,"
        D
        .L +^OR(100.21,DA(1)):5 I '$T S OK=0 Q
        .D ^DIK
        .L -^OR(100.21,DA(1))
        K DA,DIK
        Q
        ;
GETCOMBO(VALUES,USER)   ; from ORWTPP
        ; get user's combo list definition
        N CNT,IEN,NAME,NODE,NUM,SOURCE K VALUES
        S USER=+$G(USER)
        I '$D(^OR(100.24,USER,0)) Q
        S CNT=0
        S NUM=0 F  S NUM=$O(^OR(100.24,USER,.01,NUM)) Q:NUM<1  S NODE=$G(^(NUM,0)) D
        .I '$L(NODE) Q
        .S IEN=+NODE,SOURCE=$P(NODE,";",2),NAME=""
        .D
        ..I SOURCE="DIC(42," S SOURCE="WARD",NAME=$P($G(^DIC(42,IEN,0)),U) Q
        ..I SOURCE="VA(200," S SOURCE="PROVIDER",NAME=$P($G(^VA(200,IEN,0)),U) Q
        ..I SOURCE="DIC(45.7," S SOURCE="SPECIALTY",NAME=$P($G(^DIC(45.7,IEN,0)),U) Q
        ..I SOURCE="OR(100.21," S SOURCE="LIST",NAME=$P($G(^OR(100.21,IEN,0)),U) Q
        ..I SOURCE="SC(" S SOURCE="CLINIC",NAME=$P($G(^SC(IEN,0)),U) Q
        ..I SOURCE="DIC(42," S SOURCE="WARD",NAME=$P($G(^DIC(42,IEN,0)),U) Q
        .I '$L(NAME) Q
        .S CNT=CNT+1
        .S VALUES(CNT)=SOURCE_U_NAME_U_IEN
        Q
        ;
SETCOMBO(OK,VALUES,USER)        ; from ORWTPP
        ; set user's combo list definition
        N CNT,DA,DIK,IEN,NUM,NVALUES,SOURCE,SOURCENM K NVALUES
        S USER=+$G(USER),OK=1
        I 'USER Q
        S NUM=0 F  S NUM=$O(VALUES(NUM)) Q:NUM<1  D
        .S IEN=+VALUES(NUM),SOURCENM=$$UP^XLFSTR($P(VALUES(NUM),U,2)),SOURCE=""
        .I 'IEN Q
        .I SOURCENM="WARD" S SOURCE=";DIC(42,"
        .I SOURCENM="PROVIDER" S SOURCE=";VA(200,"
        .I SOURCENM="SPECIALTY" S SOURCE=";DIC(45.7,"
        .I SOURCENM="LIST" S SOURCE=";OR(100.21,"
        .I SOURCENM="CLINIC" S SOURCE=";SC("
        .I '$L(SOURCE) Q
        .S NVALUES(NUM)=IEN_SOURCE
        I '$D(^OR(100.24,USER,0)) D  I '$D(^OR(100.24,USER,0)) Q
        .L +^OR(100.24,0):5 I '$T S OK=0 Q
        .S ^OR(100.24,USER,0)=USER
        .S $P(^OR(100.24,0),U,4)=$P(^OR(100.24,0),U,4)+1,$P(^(0),U,3)=USER
        .L -^OR(100.24,0)
        S CNT=0,DA=USER,DIK="^OR(100.24,"
        L +^OR(100.24,USER,0):5 I '$T Q
        K ^OR(100.24,USER,.01)
        S NUM=0 F  S NUM=$O(NVALUES(NUM)) Q:NUM<1  D
        .S CNT=CNT+1
        .S ^OR(100.24,USER,.01,CNT,0)=NVALUES(NUM)
        S ^OR(100.24,USER,.01,0)="^100.241V^"_CNT_U_CNT
        D IX1^DIK
        L -^OR(100.24,USER,0)
        K NVALUES
        Q
