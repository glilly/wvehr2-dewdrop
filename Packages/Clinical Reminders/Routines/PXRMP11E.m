PXRMP11E        ; SLC/PKR - Exchange inits for PXRM*2.0*11 ;09/26/2008
        ;;2.0;CLINICAL REMINDERS;**11**;Feb 04, 2005;Build 39
        Q
        ;=======================================================
DELEXI  ;If the Exchange File entry already exists delete it.
        N ARRAY,IC,IND,LIST,LUVALUE,NUM
        D EXARRAY^PXRMP11E("L",.ARRAY)
        S IC=0
        F  S IC=$O(ARRAY(IC)) Q:'IC  D
        . S LUVALUE(1)=ARRAY(IC,1)
        . D FIND^DIC(811.8,"","","U",.LUVALUE,"","","","","LIST")
        . I '$D(LIST) Q
        . S NUM=$P(LIST("DILIST",0),U,1)
        . I NUM'=0 D
        .. F IND=1:1:NUM D
        ... N DA,DIK
        ... S DIK="^PXD(811.8,"
        ... S DA=LIST("DILIST",2,IND)
        ... D ^DIK
        Q
        ;
        ;====================================================
EXARRAY(MODE,ARRAY)     ;List of exchange entries used by delete and install
        ;MODE values: I for include in build, A for include action.
        N LN
        S LN=0
        ;
        S LN=LN+1
        S ARRAY(LN,1)="PATCH 11 LOCATION LIST"
        I MODE["I" S ARRAY(LN,2)="09/22/2008@11:16:04"
        I MODE["A" S ARRAY(LN,3)="I"
        ;This version compatible with SD*5.3*537, not needed anymore.
        I MODE["L" D
        . S LN=LN+1
        . S ARRAY(LN,1)="PATCH 11 LOCATION LIST (SD)"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-ALCOHOL AUDIT-C POSITIVE F/U EVAL"
        I MODE["I" S ARRAY(LN,2)="09/22/2008@11:16:16"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-ALCOHOL USE SCREEN (AUDIT-C)"
        I MODE["I" S ARRAY(LN,2)="07/09/2008@11:51:46"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL OEF/OIF EMBEDDED FRAGMENTS"
        I MODE["I" S ARRAY(LN,2)="09/15/2008@13:30:58"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL OEF/OIF FEVER"
        I MODE["I" S ARRAY(LN,2)="06/30/2008@09:09:10"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL OEF/OIF GI SX"
        I MODE["I" S ARRAY(LN,2)="06/30/2008@09:09:53"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL OEF/OIF SKIN SX"
        I MODE["I" S ARRAY(LN,2)="06/30/2008@09:10:15"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-CV ELIG W/HF FOR NO SERVICE"
        I MODE["I" S ARRAY(LN,2)="09/25/2008@13:56:32"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-CV INELG W/HF FOR SERVICE"
        I MODE["I" S ARRAY(LN,2)="09/25/2008@13:56:09"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-DEPRESSION SCREENING"
        I MODE["I" S ARRAY(LN,2)="09/25/2008@11:48:34"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-IRAQ & AFGHAN POST-DEPLOY SCREEN"
        I MODE["I" S ARRAY(LN,2)="08/06/2008@15:16:29"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV BMI > 25.0"
        I MODE["I" S ARRAY(LN,2)="09/11/2008@13:21:53"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV CERVICAL CANCER SCREEN"
        I MODE["I" S ARRAY(LN,2)="07/31/2008@12:12:30"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV COLORECTAL CANCER SCREEN"
        I MODE["I" S ARRAY(LN,2)="07/28/2008@10:56:37"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV DIABETES FOOT EXAM"
        I MODE["I" S ARRAY(LN,2)="07/01/2008@15:10:54"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV DIABETES RETINAL EXAM"
        I MODE["I" S ARRAY(LN,2)="08/20/2008@09:55:06"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV HYPERTENSION"
        I MODE["I" S ARRAY(LN,2)="07/01/2008@15:08:56"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV INFLUENZA VACCINE"
        I MODE["I" S ARRAY(LN,2)="07/28/2008@10:56:58"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV LDL CONTROL"
        I MODE["I" S ARRAY(LN,2)="07/28/2008@10:57:07"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV MAMMOGRAM SCREENING"
        I MODE["I" S ARRAY(LN,2)="08/20/2008@11:25:06"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV PNEUMOVAX"
        I MODE["I" S ARRAY(LN,2)="07/28/2008@10:57:48"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-OEF/OIF MONITOR REPORTING"
        I MODE["I" S ARRAY(LN,2)="09/25/2008@09:07:55"
        I MODE["A" S ARRAY(LN,3)="I"
        ;This version compatible with SD*5.3*537, not needed anymore.
        I MODE["L" D
        . S LN=LN+1
        . S ARRAY(LN,1)="VA-OEF/OIF MONITOR REPORTING (SD)"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-PTSD SCREENING"
        I MODE["I" S ARRAY(LN,2)="08/06/2008@15:16:03"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-TBI SCREENING"
        I MODE["I" S ARRAY(LN,2)="08/26/2008@10:31:02"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="PATCH 11 ITEMS"
        I MODE["I" S ARRAY(LN,2)="08/14/2008@09:29:40"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        ;This version compatible with SD*5.3*537, not needed anymore.
        I MODE["L" D
        . S LN=LN+1
        . S ARRAY(LN,1)="PATCH 11 ITEMS (SD)"
        ;
        I MODE="IA" D BMES^XPDUTL("There are "_LN_" Reminder Exchange entries to be installed.")
        Q
        ;
        ;==========================================
EXFINC(Y)       ;Return a 1 if the Exchange file entry is in the list to
        ;include in the build. This is used in the build to determine which
        ;entries to include.
        N EXARRAY,FOUND,IEN,IC,LUVALUE
        D EXARRAY^PXRMP11E("I",.EXARRAY)
        S FOUND=0
        S IC=0
        F  S IC=+$O(EXARRAY(IC)) Q:(IC=0)!(FOUND)  D
        . M LUVALUE=EXARRAY(IC)
        . S IEN=+$$FIND1^DIC(811.8,"","KU",.LUVALUE)
        . I IEN=Y S FOUND=1 Q
        Q FOUND
        ;
        ;==========================================
SMEXINS ;Silent mode install.
        N ACTION,EXARRAY,IC,IEN,LUVALUE,PXRMINST,TEXT
        S PXRMINST=1
        D EXARRAY^PXRMP11E("IA",.EXARRAY)
        S IC=0
        F  S IC=$O(EXARRAY(IC)) Q:'IC  D
        . S LUVALUE(1)=EXARRAY(IC,1),LUVALUE(2)=EXARRAY(IC,2)
        . S IEN=+$$FIND1^DIC(811.8,"","KU",.LUVALUE)
        . I IEN=0 Q
        . S TEXT="Installing Reminder Exchange entry "_LUVALUE(1)
        . D BMES^XPDUTL(TEXT)
        . S ACTION=EXARRAY(IC,3)
        . D INSTALL^PXRMEXSI(IEN,ACTION,1)
        Q
        ;
