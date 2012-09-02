TMGTIUO6        ;TMG/kst-Text objects for use in CPRS ; 7/20/12
                ;;1.0;TMG-LIB;**1,17**;7/20/12;Build 23
        ;
        ;"Kevin Toppenberg MD
        ;"(C) 10/2010
        ;"Released under: GNU General Public License (GPL)
        ;
        ;" This is spill over code from TMGTIUOJ, to make that file size smaller.
        ;"       
        ;"=======================================================================
        ;"PUBLIC FUNCTIONS
        ;"=======================================================================
        ;"GETTABL1(DFN,LABEL)--Entry point for TIU objects, to return a table comprised from 1 prior table.
        ;"GETTABLX(DFN,LABEL) --Entry point for TIU objects, to return a table comprised from prior notes.
        ;
        ;"=======================================================================
        ;"PRIVATE FUNCTIONS
        ;"=======================================================================
        ;"STUBRECS(DFN,ARRAY,LABEL)  -- add stubs for recommended studies to Array
        ;"=======================================================================
        ;"Dependancies : 
        ;"=======================================================================
STUBRECS(DFN,ARRAY,LABEL)        ;"STUB RECOMMENDATIONS
               ;"Purpose: to add stubs for recommended studies to Array
               ;"Get age from DFN
               SET DFN=+$GET(DFN)
               IF DFN=0 GOTO SRDONE
               NEW AGE SET AGE=+$$GET1^DIQ(2,DFN,.033)
               NEW SEX SET SEX=$$GET1^DIQ(2,DFN,.02)
               NEW DOB SET DOB=$$GET1^DIQ(2,DFN,.03,"I")
               ;
               IF LABEL="[STUDIES]" DO
               . IF (SEX="FEMALE") DO
               . . IF (AGE>39) DO ENSURE^TMGTIUO3(.ARRAY,"Mammogram")
               . . IF (AGE>59) DO ENSURE^TMGTIUO3(.ARRAY,"Bone Density")
               . . IF (AGE>20) DO ENSURE^TMGTIUO3(.ARRAY,"Pap")
               . . IF (AGE>8)&(AGE<27) DO ENSURE^TMGTIUO3(.ARRAY,"Gardasil",":","#1 <no data>; #2  <no data>; #3  <no data> ")
               . IF (SEX="MALE") DO
               . . ;"IF (AGE>49) DO ENSURE^TMGTIUO3(.ARRAY,"PSA")
               . . IF (AGE>8)&(AGE<21) DO ENSURE^TMGTIUO3(.ARRAY,"Gardasil",":","#1 <no data>; #2  <no data>; #3  <no data> ")
               . IF AGE>64 DO ENSURE^TMGTIUO3(.ARRAY,"Pneumovax")
               . IF (DOB>2440101)&(DOB<2661231) DO ENSURE^TMGTIUO3(.ARRAY,"Hepatitis C screen")  ;"DOB of 1945 through 1965
               . DO ENSURE^TMGTIUO3(.ARRAY,"Flu Vaccine")
               . IF (AGE>18) DO ENSURE^TMGTIUO3(.ARRAY,"Advance Directives")
               . ;"IF (AGE>49) DO ENSURE^TMGTIUO3(.ARRAY,"Td")
               . IF (AGE>59) DO ENSURE^TMGTIUO3(.ARRAY,"Zostavax")
               . IF (AGE>1)&(AGE<19) DO ENSURE^TMGTIUO3(.ARRAY,"MMR",":","#1 <no data>; #2  <no data>")
               . IF (AGE>0)&(AGE<21) DO ENSURE^TMGTIUO3(.ARRAY,"Hep B",":","#1 <no data>; #2  <no data>; #3  <no data> ")
               . IF (AGE>1)&(AGE<19) DO ENSURE^TMGTIUO3(.ARRAY,"Hep A",":","#1 <no data>; #2  <no data>")
               . IF (AGE>1)&(AGE<21) DO ENSURE^TMGTIUO3(.ARRAY,"Varivax",":","#1 <no data>; #2  <no data>")
               . IF (AGE>10)&(AGE<65) DO ENSURE^TMGTIUO3(.ARRAY,"TdaP / Td")
               . IF (AGE>10)&(AGE<23) DO ENSURE^TMGTIUO3(.ARRAY,"MCV4 (Menactra) #1 <no data>; #2 <no data>")
               . IF (AGE>50) DO ENSURE^TMGTIUO3(.ARRAY,"Colonoscopy")
               ELSE  IF LABEL="[DIABETIC STUDIES]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"HgbA1c","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Diabetic Eye Exam")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Urine Microalbumin")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Diabetic Foot Exam")
               . DO ENSURE^TMGTIUO3(.ARRAY,"EKG")
               . IF (AGE>39) DO ENSURE^TMGTIUO3(.ARRAY,"Anti-platelet Rx")
               . IF (AGE<60) DO ENSURE^TMGTIUO3(.ARRAY,"Hep-B vaccination")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Regimen")
               ELSE  IF LABEL="[LIPIDS]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Total Cholesterol","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"LDL Cholesterol","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"HDL Cholesterol","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Triglycerides","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Date of last lipid panel")
               . DO ENSURE^TMGTIUO3(.ARRAY,"LDL Goal")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Liver Enzymes")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Regimen")
               ELSE  IF LABEL="[SOCIAL HX]" DO
               . IF (AGE>13) DO ENSURE^TMGTIUO3(.ARRAY,"Tobacco")
               . IF (AGE>13) DO ENSURE^TMGTIUO3(.ARRAY,"EtOH")
               ELSE  IF LABEL="[THYROID]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Date of last study")
               . DO ENSURE^TMGTIUO3(.ARRAY,"TSH","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Regimen")
               ELSE  IF LABEL="[HYPERTENSION]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Date of last electrolytes")
               . DO ENSURE^TMGTIUO3(.ARRAY,"EKG")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Med-1")
               ELSE  IF LABEL="[ANEMIA]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Hgb")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Serum Fe")
               . DO ENSURE^TMGTIUO3(.ARRAY,"TIBC")
               . DO ENSURE^TMGTIUO3(.ARRAY,"% Sat")
               . DO ENSURE^TMGTIUO3(.ARRAY,"B12")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Folate")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Workup")
               ELSE  IF LABEL="[ASTHMA]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Peak Flow Personal Best")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Meds")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Rescue Inhaler Freq")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Pneumovax")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Triggers")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Smoker")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Nocturnal Symptoms")
               ELSE  IF LABEL="[COPD]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Meds")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Rescue Inhaler Freq")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Pneumovax")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Pulmonologist")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Home O2")
               . DO ENSURE^TMGTIUO3(.ARRAY,"PFT Testing")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Tobacco Cessation Counselling")
               ELSE  IF LABEL="[OSTEOPENIA/OSTEOPOROSIS]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Bone Density")
               . DO ENSURE^TMGTIUO3(.ARRAY,"T-Score Spine/Hips")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Regimen")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Advised Calcium ~1500 mg & Vit-D 1000-2000 IU")
               ELSE  IF LABEL="[CHF]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Pneumovax")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Anti-platelet Rx")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Beta-blocker")
               . DO ENSURE^TMGTIUO3(.ARRAY,"ACE-I/ARB")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Diuretic")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Digoxin")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Cardiologist")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Last echocardiogram")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Educated about sodium intake")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Dry Weight")
               ELSE  IF LABEL="[MEDICATIONS]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"*Source of information")
               . DO ENSURE^TMGTIUO3(.ARRAY,"*Reconciliation date")
               . DO ENSURE^TMGTIUO3(.ARRAY,"*Allergies sync'd with ERx on date")
               ;
SRDONE   QUIT
               ;
               ;
GETTABL1(DFN,LABEL)     ;
               ;"Purpose: A call point for TIU objects, to return a table comprised from 1 prior table.
               ;"NOTE: This type of table just gets the *LAST* table found (not a compilation)
GT1         NEW ARRAY,RESULT SET RESULT=""
               IF $GET(LABEL)="" GOTO GT1DONE
               NEW SPACES SET SPACES=""
               DO GETSPECL^TMGTIUO4(DFN,LABEL,"BLANK_LINE",48,.ARRAY,1,.SPACES)  ;"mode 1 = only last table; 2=compile
               ;"SET RESULT="     -- "_LABEL_" ---------"_$CHAR(13)_$CHAR(10)
               SET RESULT=SPACES_"-- "_LABEL_" ---------"_$CHAR(13)_$CHAR(10)
               DO STUBRECS(.DFN,.ARRAY,LABEL)
               SET RESULT=RESULT_$$ARRAY2ST^TMGTIUO4(.ARRAY,.SPACES)
GT1DONE QUIT RESULT
               ;
               ;
GETTABLX(DFN,LABEL)     ;
               ;"Purpose: A call point for TIU objects, to return a table comprised from prior notes.
               ;"NOTE: This compiles a table from all prior matching tables in date range.
               ;
               GOTO GT1 ;"<-- Hack to force TableX to really be a Table1 type table.
               ;
               ;"NEW ARRAY,RESULT SET RESULT=""
               ;"IF $GET(LABEL)="" GOTO GTXDONE
               ;"SET RESULT="     -- "_LABEL_" ---------"_$CHAR(13)_$CHAR(10)
               ;"DO GETSPECL^TMGTIUO4(DFN,LABEL,"BLANK_LINE",13,.ARRAY,2)  ;"mode 1 = only last table; 2=compile
               ;"DO STUBRECS(.DFN,.ARRAY,LABEL)
               ;"SET RESULT=RESULT_$$ARRAY2ST^TMGTIUO4(.ARRAY)
GTXDONE ;"QUIT RESULT
               ;
