PXRMP12E        ; SLC/PKR - Exchange inits for PXRM*2.0*12 ;08/13/2009
        ;;2.0;CLINICAL REMINDERS;**12**;Feb 04, 2005;Build 73
        ;====================================================
EXARRAY(MODE,ARRAY)     ;List of exchange entries used by delete and install
        ;MODE values: I for include in build, A for include action.
        N LN
        S LN=0
        ;
        S LN=LN+1
        S ARRAY(LN,1)="PATCH 12 ITEMS"
        I MODE["I" S ARRAY(LN,2)="03/13/2009@12:19:56"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="UPDATE VA-DIABETES"
        I MODE["I" S ARRAY(LN,2)="02/18/2009@10:04:31"
        I MODE["A" S ARRAY(LN,3)="I"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-EMBEDDED FRAGMENTS RISK EVALUATION"
        I MODE["I" S ARRAY(LN,2)="07/17/2009@13:31:39"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-EMBEDDED FRAGMENTS SCREEN"
        I MODE["I" S ARRAY(LN,2)="08/12/2009@11:09:31"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV BMI COLORECTAL UPDATES PATCH 12"
        I MODE["I" S ARRAY(LN,2)="04/10/2009@09:36:02"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV HIGH RISK TERMS"
        I MODE["I" S ARRAY(LN,2)="02/16/2009@13:59:14"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV HYPERTENSION"
        I MODE["I" S ARRAY(LN,2)="08/12/2009@11:07:26"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV MAMMOGRAM SCREENING"
        I MODE["I" S ARRAY(LN,2)="03/13/2009@15:22:43"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-MHV RETINOPATHY TERMS"
        I MODE["I" S ARRAY(LN,2)="02/16/2009@14:00:51"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="RT VA-ALCOHOL NONE PAST 1YR"
        I MODE["I" S ARRAY(LN,2)="02/03/2009@08:32:26"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="TX HIGH RISK FLU AND PNEUMONIA"
        I MODE["I" S ARRAY(LN,2)="02/09/2009@09:22:55"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-ALCOHOL AUDIT-C POSITIVE F/U EVAL"
        I MODE["I" S ARRAY(LN,2)="03/12/2009@08:48:11"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-DEPRESSION SCREENING"
        I MODE["I" S ARRAY(LN,2)="03/12/2009@13:17:22"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-OEF/OIF MONITOR"
        I MODE["I" S ARRAY(LN,2)="03/12/2009@14:17:53"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-TBI/POLY IDT EVALUATIONS ELEMENT UPDATE"
        I MODE["I" S ARRAY(LN,2)="05/12/2009@12:01:42"
        I MODE["A" S ARRAY(LN,3)="O"
        S LN=LN+1
        S ARRAY(LN,1)="VA-BL DEPRESSION SCREEN"
        I MODE["I" S ARRAY(LN,2)="04/30/2009@12:38:03"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="PXRM VISIT DATE MONTH REQ YEAR BLANK"
        I MODE["I" S ARRAY(LN,2)="05/06/2009@16:22:03"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-OEF/OIF MONITOR REPORTING"
        I MODE["I" S ARRAY(LN,2)="05/14/2009@15:14:46"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-IRAQ AFGHAN"
        I MODE["I" S ARRAY(LN,2)="06/25/2009@17:47:50"
        I MODE["A" S ARRAY(LN,3)="M"
        ;
        S LN=LN+1
        S ARRAY(LN,1)="VA-DISABLE BRANCHING LOGIC REPLACEMENT ELEMENT"
        I MODE["I" S ARRAY(LN,2)="06/30/2009@10:00:06"
        I MODE["A" S ARRAY(LN,3)="O"
        ;
        I MODE="IA" D BMES^XPDUTL("There are "_LN_" Reminder Exchange entries to be installed.")
        Q
        ;
