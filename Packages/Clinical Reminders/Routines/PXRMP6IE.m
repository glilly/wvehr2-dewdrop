PXRMP6IE        ; SLC/PKR - Exchange inits for PXRM*2.0*6 ;12/03/2007
        ;;2.0;CLINICAL REMINDERS;**6**;Feb 04, 2005;Build 123
        Q
        ;=======================================================
DELEXI  ;If the Exchange File entry already exists delete it.
        N ARRAY,IC,IND,LIST,LUVALUE,NUM
        D EXARRAY^PXRMP6IE("L",.ARRAY)
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
        S ARRAY(LN,1)="PXRM*2*6 TAXONOMY UPDATES"
        I MODE["I" S ARRAY(LN,2)="05/25/2007@08:40:29"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-GEC REFERRAL CARE RECOMMENDATION"
        I MODE["I" S ARRAY(LN,2)="07/30/2007@15:15"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-GEC REFERRAL NURSING ASSESSMENT"
        I MODE["I" S ARRAY(LN,2)="07/30/2007@15:15"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MH TERM UPDATE"
        I MODE["I" S ARRAY(LN,2)="05/31/2007@14:06:20"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-WH HYSTERECTOMY W/CERVIX REMOVED"
        I MODE["I" S ARRAY(LN,2)="07/06/2007@08:26:25"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-ALCOHOL AUDIT-C POSITIVE F/U EVAL"
        I MODE["I" S ARRAY(LN,2)="12/03/2007@12:43:06"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-ALCOHOL USE SCREEN (AUDIT-C)"
        I MODE["I" S ARRAY(LN,2)="09/21/2007@17:52"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL ALCOHOL SCREEN"
        I MODE["I" S ARRAY(LN,2)="07/27/2007@15:38"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL ALCOHOL WITHIN SAFE LIMIT"
        I MODE["I" S ARRAY(LN,2)="08/13/2007@16:20"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL DEPRESSION SCREEN"
        I MODE["I" S ARRAY(LN,2)="07/27/2007@15:40"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL OEF/OIF FEVER"
        I MODE["I" S ARRAY(LN,2)="07/27/2007@15:41"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL OEF/OIF GI SX"
        I MODE["I" S ARRAY(LN,2)="07/27/2007@15:41"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL OEF/OIF OTHER SX"
        I MODE["I" S ARRAY(LN,2)="07/27/2007@15:41"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL OEF/OIF SERVICE INFO ENTERED"
        I MODE["I" S ARRAY(LN,2)="07/27/2007@15:41"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL OEF/OIF SKIN SX"
        I MODE["I" S ARRAY(LN,2)="07/27/2007@15:41"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL PTSD SCREEN"
        I MODE["I" S ARRAY(LN,2)="07/27/2007@15:43"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-DEPRESSION SCREENING"
        I MODE["I" S ARRAY(LN,2)="11/08/2007@17:11"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-IRAQ & AFGHAN POST-DEPLOY SCREEN"
        I MODE["I" S ARRAY(LN,2)="12/06/2007@09:27:06"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV INFLUENZA VACCINE"
        I MODE["I" S ARRAY(LN,2)="07/27/2007@11:34"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-PTSD SCREENING"
        I MODE["I" S ARRAY(LN,2)="10/09/2007@15:21"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-TBI SCREENING"
        I MODE["I" S ARRAY(LN,2)="12/03/2007@12:19:35"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="PXRM RESULT GROUP UPDATE REMINDER"
        I MODE["I" S ARRAY(LN,2)="12/12/2007@10:53:14"
        I MODE["A" S ARRAY(LN,3)="O"
        Q
        ;
        ;==========================================
EXFINC(Y)       ;Return a 1 if the Exchange file entry is in the list to
        ;include in the build. This is used in the build to determine which
        ;entries to include.
        N EXARRAY,FOUND,IEN,IC,LUVALUE
        D EXARRAY^PXRMP6IE("I",.EXARRAY)
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
        D EXARRAY^PXRMP6IE("IA",.EXARRAY)
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
