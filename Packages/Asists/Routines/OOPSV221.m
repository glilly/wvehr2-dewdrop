OOPSV221        ;WIOFO/LLH-POST INIT ROUTINE, FILL FIELD 331 ;09/15/09
        ;;2.0;ASISTS;**21**;Jun 03, 2002;Build 7
        ;
        ; Patch 21 Pre Init Routine to clean up data in the Patient Source
        ; field (#34) and Contamination field (#35)
        ; and update 2263.3 T8 code
        ;
        Q  ; prevents excuting from top of routine
        ;
ENT     ;
        D BMES^XPDUTL("Starting Pre-install....") H 1
        D CLEAN,UPDATE
        D BMES^XPDUTL("Pre-install Complete!!!") H 1
        Q
CLEAN   ;CLEAN UP 2260 ENTRIES
        N OOPSCN,DA,DIC,DIE,DR,OOPSIEN,OOPSFILE,OOPSTYP,OOPSCONTAM,OOPSPAT,DR
        S OOPSFILE=2260,OOPSIEN=0
        D BMES^XPDUTL("Starting data clean up of PATIENT SOURCE (#34) and CONTAMINATION (#35) fields") H 1
        D MES^XPDUTL(" ")
        S DIE="^OOPS(2260,",DR=""
        F  S OOPSIEN=$O(^OOPS(OOPSFILE,OOPSIEN)) Q:OOPSIEN'>0  D
        .S OOPSTYP=$$GET1^DIQ(OOPSFILE,OOPSIEN,3,"I")
        .I OOPSTYP>10&(OOPSTYP<15) Q  ; these are blood borne incidents and should have data
        .; check to see if data in #34 or #35 - if so, kill then go on
        .S OOPSPAT=$$GET1^DIQ(OOPSFILE,OOPSIEN,34,"I"),OOPSCONTAM=$$GET1^DIQ(OOPSFILE,OOPSIEN,35,"I")
        .S OOPSCN=0,DR=""
        .I $G(OOPSPAT)'="" S OOPSCN=OOPSCN+1,DR(1,2260,OOPSCN)="34///@"
        .I $G(OOPSCONTAM)'="" S OOPSCN=OOPSCN+1,DR(1,2260,OOPSCN)="35///@"
        .I $D(DR)>1 S DA=OOPSIEN D ^DIE K DR
        D BMES^XPDUTL("Data Cleanup Complete") H 1
        D MES^XPDUTL(" ")
        Q
UPDATE  ;UPDATE 2263.3 IEN 59
        N OOPSIEN1,DA,DIE,DIK
        D BMES^XPDUTL("Starting update of the ASISTS DOL NATURE OF INJURY CODES file") H 1
        S OOPSIEN1=""
        S OOPSIEN1=$O(^OOPS(2263.3,"B","TRAUMATIC INJURY - UNCLASS. (EXCEPT DISEASE, ILLNESS)",0))
        I OOPSIEN1="" D BMES^XPDUTL("TRAUMATIC INJURY (T8) does not exist....quitting update") Q
        S DIK="^OOPS(2263.3,"
        S DA=OOPSIEN1,DIK(1)=.01
        D EN2^DIK
        S $P(^OOPS(2263.3,DA,0),"^")="TRAUMATIC INJURY- UNCLASS. (EXCEPT DISEASE, ILLNESS)"
        D EN1^DIK
        D BMES^XPDUTL("Update Complete") H 1
        K DA,DIE,DIK
        Q
