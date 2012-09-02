C0Q1P2  ; VEN/SMH - Kids utilities for C0Q 1.0 patch 2 ; 8/3/12 11:13am
        ;;1.0;QUALITY MEASURES;**2**;July 13, 2112;Build 23
        ; Licensed under package license. See Documentation for license and
        ; usage conditions.
        ;
        ; PEPs: PRE, POST
        ;
PRE     ; Unified Pre; PEP
        D PREREM
        QUIT
POST    ; Unified Post; PEP
        D POSTREM
        QUIT
        ;
        ; Rest of entry points are private
        ; 
        ; 
ARRAY(MODE,ARRAY)       ;List of exchange entries used by delete and install
        ;
        N LN S LN=1
        ;
        ; NQF 0024-alt-core_wt-kids
        S ARRAY(LN,1)="MU NQF0024-ALL"
        I MODE S ARRAY(LN,2)="07/31/2012@17:49:03"
        S LN=LN+1
        ;
        ; NQF 0013-core-HTN
        S ARRAY(LN,1)="MU NQF0013 HTN_MK"
        I MODE S ARRAY(LN,2)="07/06/2011@15:08:53"
        S LN=LN+1
        ;
        ; NQF 0028a-core-tobacco-access
        ; NQF 0028b-core-tobaocc-intervention
        S ARRAY(LN,1)="MU NQF0028 TOBACCO_MK"
        I MODE S ARRAY(LN,2)="07/06/2011@15:14:49"
        S LN=LN+1
        ;
        ; NQF 0041-alt-core-flu
        S ARRAY(LN,1)="MU NQF0041 FLU_MK"
        I MODE S ARRAY(LN,2)="07/06/2011@15:26:59"
        S LN=LN+1
        ;
        ; NQF 0059-option1-DM-Hbalc
        ; NQF 0061-option3-DM-BP
        ; NQF 0064-option2-DM-LDL
        ; All are in One Reminder Exchange entry
        S ARRAY(LN,1)="MU NQF0059_61_64_SMH"
        I MODE S ARRAY(LN,2)="07/16/2012@10:46:17"
        S LN=LN+1
        ;
        ; Inpatient Education Reminders (popularly known as ED-1 and ED-2)
        ; NQF 0495
        ; NQF 0497
        S ARRAY(LN,1)="MU NQF 0495 ED-1"
        I MODE S ARRAY(LN,2)="07/17/2012@11:47:55"
        S LN=LN+1
        S ARRAY(LN,1)="MU NQF 0497 ED-2"
        I MODE S ARRAY(LN,2)="07/17/2012@11:50:23"
        S LN=LN+1
        ;
        ; MU Stroke Measures
        ; NQF 0435
        ; NQF 0436
        ; NQF 0437
        ; NQF 0438
        ; NQF 0439
        ; NQF 0440
        ; NQF 0441
        ; NB: Contains two Labs! Must rematch if not on your system.
        ; Installation will become talkative
        S ARRAY(LN,1)="MU STROKE 2.3.4.5.6.8.10 SMH"
        I MODE S ARRAY(LN,2)="07/18/2012@10:33:53"
        S LN=LN+1
        ;
        ; MU VTE Measures
        ; NQF 0371
        ; NQF 0372
        ; NQF 0373
        ; NQF 0374
        ; NQF 0375
        ; NQF 0376
        ; NB: Contains several labs. Must rematch if not on your system.
        ; Installation will become talkative
        S ARRAY(LN,1)="MU VTE 1.2.3.4.5.6 SMH"
        I MODE S ARRAY(LN,2)="07/20/2012@09:48:30"
        S LN=LN+1
        ;
        ;
        ; NQF 0421-core-adult-weight
        ; NB: B/c of the presence of patient lists, measures sent as part of
        ; an extract.
        S ARRAY(LN,1)="MU NQF0421 ADULT BMI SMH"
        I MODE S ARRAY(LN,2)="07/26/2012@11:00:17"
        S LN=LN+1
        ;
        ; NQF 0038-alt-core-childImms
        ; NB: Again because of Patient Lists, measures sent as part of an extract
        S ARRAY(LN,1)="MU NQF0038 CHILD IMM SMH"
        I MODE S ARRAY(LN,2)="07/27/2012@17:48:33"
        S LN=LN+1
        ;
        ; CPRS Management Dialogs for Outpatient Stuff
        ; MU NQF0421 BMI DI
        ; MU NQF0041 INFLUENZA MANAGEMENT DI
        ; MU NQF0038 IMMUNE MANAGEMENT DI
        ; MU NQF0028AB MANAGEMENT DI
        ; MU SMOKING STATUS DI
        S ARRAY(LN,1)="MU CPRS HELP DIS"
        I MODE S ARRAY(LN,2)="08/01/2012@18:32:29"
        S LN=LN+1
        ;
        QUIT
        ;
        ;
        ;===============================================================
DELEI   ;If the Exchange File entry already exists delete it.
        N ARRAY,IC,IND,LIST,LUVALUE,NUM
        D ARRAY(1,.ARRAY)
        S IC=0
        F  S IC=$O(ARRAY(IC)) Q:'IC  D
        .S LUVALUE(1)=ARRAY(IC,1)
        .D FIND^DIC(811.8,"","","U",.LUVALUE,"","","","","LIST")
        .I '$D(LIST) Q
        .S NUM=$P(LIST("DILIST",0),U,1)
        .I NUM'=0 D
        ..F IND=1:1:NUM D
        ... N DA,DIK
        ... S DIK="^PXD(811.8,"
        ... S DA=LIST("DILIST",2,IND)
        ... D ^DIK
        Q
        ;
        ;===============================================================
EXFINC(Y)       ;Return a 1 if the Exchange file entry is in the list to
        ;include in the build. This is used in the build to determine which
        ;entries to include.
        N ARRAY,FOUND,IEN,IC,LUVALUE
        D ARRAY(1,.ARRAY)
        S FOUND=0
        S IC=0
        F  S IC=+$O(ARRAY(IC)) Q:(IC=0)!(FOUND)  D
        . M LUVALUE=ARRAY(IC)
        . S IEN=+$$FIND1^DIC(811.8,"","KU",.LUVALUE)
        . I IEN=Y S FOUND=1 Q
        Q FOUND
        ;
PREREM  ;
        D DELEI
        Q
POSTREM ;
        D SMEXINS
        Q
        ;===============================================================
SMEXINS ;Silent mode install.
        N ARRAY,IC,IEN,LUVALUE,PXRMINST
        S PXRMINST=1
        D ARRAY(1,.ARRAY)
        S IC=0
        F  S IC=$O(ARRAY(IC)) Q:'IC  D
        .M LUVALUE=ARRAY(IC)
        .S IEN=+$$FIND1^DIC(811.8,"","KU",.LUVALUE)
        .I IEN'=0 D
        .. N TEXT
        .. I LUVALUE(1)["PARAMETER" S TEXT="Installing entry "_LUVALUE(1)
        .. E  S TEXT="Installing reminder exchange entry "_LUVALUE(1)
        .. D BMES^XPDUTL(TEXT)
        .. D INSTALL^PXRMEXSI(IEN,"I",1)
        Q
        ;
