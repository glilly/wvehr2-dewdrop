PXRMP17E        ; SLC/PKR - Exchange inits for PXRM*2.0*17 ;04/13/2010
        ;;2.0;CLINICAL REMINDERS;**17**;Feb 04, 2005;Build 102
        ;====================================================
EXARRAY(MODE,ARRAY)     ;List of exchange entries used by delete and install
        ;MODE values: I for include in build, A for include action.
        N LN
        S LN=0
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-AAA SCREENING"
        I MODE["I" S ARRAY(LN,2)="01/25/2010@14:59:38"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-PTSD REASSESSMENT (PCL)"
        I MODE["I" S ARRAY(LN,2)="01/25/2010@15:03:44"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-POLYTRAUMA MARKER"
        I MODE["I" S ARRAY(LN,2)="04/12/2010@14:24:40"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL DEPRESSION SCREEN"
        I MODE["I" S ARRAY(LN,2)="12/16/2009@07:19:04"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-HF ETOH SELF SCORE AUD 10"
        I MODE["I" S ARRAY(LN,2)="01/07/2010@10:01:26"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-EMBEDDED FRAGMENTS RISK EVALUATION"
        I MODE["I" S ARRAY(LN,2)="01/08/2010@08:42:17"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-GP EF CONTACT INFORMATION"
        I MODE["I" S ARRAY(LN,2)="01/25/2010@14:45:55"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-GP ALC ADVICE2"
        I MODE["I" S ARRAY(LN,2)="01/25/2010@14:50:04"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MH STOP CODES FOR PTSD EVALUATION"
        I MODE["I" S ARRAY(LN,2)="02/11/2010@14:51:10"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-HF ACUTE ILLNESS EVAL"
        I MODE["I" S ARRAY(LN,2)="02/20/2010@09:09:52"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="DEPRESSION/PTSD REMINDER TERM UPDATES - PATCH 17"
        I MODE["I" S ARRAY(LN,2)="02/26/2010@12:07:38"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="PXRM*2*17 COMPUTED FINDINGS"
        I MODE["I" S ARRAY(LN,2)="01/26/2010@11:49:30"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        I MODE="IA" D BMES^XPDUTL("There are "_LN_" Reminder Exchange entries to be installed.")
        Q
        ;
