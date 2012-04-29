PSOP288F        ;FIX ERRONEOUS NON-VA MEDS RECORDS IN PHARMACY PATIENT FILE (#55)
        ;;7.0;OUTPATIENT PHARMACY;**288**;DEC 2007;Build 17
        ;
CLEAN   ;ALLOW USER TO CLEAN UP ERRONEOUS ENTRIES
        N PSOI,PSOPAT,PSONVA,PSONVA0,D,PSONOPAT,PSOPATN,PSOERR,PSOIENS,X,X1,X2,Y,PSODIV
        F PSOI=1:1 D  Q:PSONOPAT=2
        .D GETPAT
        .I PSONOPAT Q
        .D FIX
        Q
        ;
GETPAT  ;PROMPT FOR PATIENT
        S PSONOPAT=1
        W !!
        K DIC
        S DIC="^PS(55,",DIC(0)="ABEQTVZ",D="B" D IX^DIC
        S PSOPAT=+$G(Y(0)),PSOPATN=$G(Y(0,0))
        I 'PSOPAT S PSONOPAT=2 Q
        S PSODIV=0 F  S PSODIV=$O(^XTMP("PSOP288",PSODIV)) Q:PSODIV=""  D  Q:'PSONOPAT
        .I PSOPAT,$D(^XTMP("PSOP288",PSODIV,PSOPAT)) S PSONOPAT=0
        .I PSONOPAT W !,"??" S PSONOPAT=1 Q
        Q
        ;
FIX     ;FIX THE NON-VA MEDS ENTRY
        S PSONVA=0 F  S PSONVA=$O(^XTMP("PSOP288",PSODIV,PSOPAT,PSONVA)) Q:'PSONVA  D
        .W !!,"PATIENT: ",PSOPATN
        .S PSONVA0=$G(^PS(55,PSOPAT,"NVA",PSONVA,0))
        .S DIE="^PS(55,"_PSOPAT_",""NVA"","
        .S DA=PSONVA,DA(1)=PSOPAT
        .S DR=".01;1;2;3;4;5;6;7;8;11;12;13"
        .D ^DIE K DIE,DA,DR
        .W !!
        .S PSOIENS=PSONVA_","_PSOPAT_","
        .S DIR("A")="Would you like to edit the comments " S DIR(0)="Y" D ^DIR
        .I 'Y Q
        .S DIC="^PS(55,"_PSOPAT_",""NVA"","_PSONVA_",1"
        .S DWPK=1
        .D EN^DIWE
        .K DIC,DWPK,DIR
        Q
