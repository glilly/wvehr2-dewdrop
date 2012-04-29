TMGTIUOJ        ;TMG/kst-Text objects for use in CPRS ; 03/12/09; 10/10/10
                ;;1.0;TMG-LIB;**1**;03/25/06;Build 23
        ;
        ;"Kevin Toppenberg MD
        ;"(C) 10/2010
        ;"Released under: GNU General Public License (GPL)
        ;
        ;"=======================================================================
        ;"TMG text objects
        ;"
        ;"These are bits of code that return text to be included in progress notes etc.
        ;"They are called when the user puts text like this in a note:
        ;"     ... Mrs. Jone's vitals today are |VITALS|, measured in the office...
        ;"     'VITALS' would be a TIU TEXT OBJECT, managed through menu option TIUFJ CREATE OBJECTS MGR
        ;
        ;"=======================================================================
        ;"PUBLIC FUNCTIONS
        ;"=======================================================================
        ;"$$VITALS(DFN,.TIU)
        ;"$$ONEVITAL(DFN,.TIU,TYPE)
        ;"$$NICENAME(DFN)
        ;"$$FNAME(DFN)
        ;"$$MNAME(DFN)
        ;"$$LNAME(DFN)
        ;"$$PHONENUM(DFN)
        ;"$$GETTABLX(DFN,LABEL)
        ;"$$WTTREND(DFN,.TIU) return text showing patient's trend in change of weight.
        ;"$$WTDELTA(DFN,.TIU,NONULL) return text showing patient's change in weight.
        ;"$$GETTABL1(DFN,LABEL) -- return a table from prior notes.
        ;"$$GETTABLX(DFN,LABEL) -- return a table compiled from prior notes.
        ;"=======================================================================
        ;"PRIVATE FUNCTIONS
        ;"=======================================================================
        ;"TMGVISDT(TIU)  Return a string for date of visit
        ;"ENSURE^TMGTIUO3(ARRAY,KEY,PIVOT,VALUE) add one (empty) entry, if a value for this doesn't already exist.
        ;"StubRecommendations(DFN,ARRAY,Label) add stubs for recommended studies to Array
        ;"=======================================================================
        ;"Dependancies :  TMGSTUTL, TMGHTM1, TMGGRC1, TMGGRC2, TMGTIUO3, %DTC, DIQ
        ;"=======================================================================
        ;
VITALS(DFN,TIU) ;
               ;"Purpose: Return a composite Vitals string
               ;"Input: DFN -- the patient's unique ID (record#)
               ;"       TIU -- See documentation below.
               ;"Output: returns RESULT
               QUIT $$ONEVITAL(.DFN,.TIU,"ALL")
               ;
ONEVITAL(DFN,TIU,TYPE)     ;
               ;"Purpose: From GETVITALS, except only returns a single vital specified by TYPE
               ;"Input: DFN -- the patient's unique ID (record#)
               ;"       TIU -- this is an array created by TIU system that
               ;"              contains information about the document being
               ;"              edited/created.  I believe it has this structure:
               ;"                  TIU("VSTR") = LOC;VDT;VTYP
               ;"                  TIU("VISIT") = Visit File IFN^date?
               ;"                  TIU("LOC")
               ;"                  TIU("VLOC")
               ;"                  TIU("STOP") = mark to defer workload
               ;"                  TIU("TYPE")=1^title DA^title Name  i.e.:  1^128^OFFICE VISIT^OFFICE VISIT
               ;"                  TIU("SVC")=service, e.g. "FAMILY PRACTICE"
               ;"                  TIU("EDT")=TIUEDT^DateStr  = event begin time: FMDate^DateStr
               ;"                  TIU("LDT")=TIULDT^DateStr  = event end time: FMDate^DateStr
               ;"                  TIU("VSTR")=LOC;VDT;VTYP  e.g. "x;x;OFFICE VISIT"
               ;"                  TIU("VISIT")=Visit File IFN
               ;"                  TIU("LOC")=TIULOC
               ;"                  TIU("VLOC")=TIULOC
               ;"                  TIU("STOP")=0  ;"0=FALSE, don't worry about stop codes.
               ;"      TYPE -- "WT" - Returns the weight value
               ;"              "HT" - Returns the height value
               ;"              "BMI" - Returns the BMI value
               ;"              "HC" - Returns the Head Circumference value
               ;"              "TEMP","BP","Pulse" -- usual values
               ;"              "ALL" - (Default value) Return all values
               ;"              or Combination, e.g. "WT,HT,HC"
               ;"Results: String with value units and percentile (if available) and date if not current date
               ;"Output: returns RESULT
               NEW debug SET debug=0
               IF debug=1 DO
               . MERGE TIU=^TMG("TMP","RPC","VITALS^TMGTIUOJ","TIU")
               . MERGE DFN=^TMG("TMP","RPC","VITALS^TMGTIUOJ","DFN")
               KILL ^TMG("TMP","RPC","VITALS^TMGTIUOJ")
               MERGE ^TMG("TMP","RPC","VITALS^TMGTIUOJ","TIU")=TIU
               MERGE ^TMG("TMP","RPC","VITALS^TMGTIUOJ","DFN")=DFN
               SET TYPE=$GET(TYPE,"ALL")
               NEW RESULT SET RESULT=""
               NEW CURDT SET CURDT=""
               NEW NOTEDT SET NOTEDT=""
               NEW INDENTSTR SET INDENTSTR="          "
               SET DFN=+$GET(DFN)
               NEW GENDER SET GENDER=$PIECE($GET(^DPT(DFN,0)),"^",2)
               SET NOTEDT=$$VISDATE^TIULO1(.TIU) ;"Get date of current note (in MM/DD/YY HR:MIN)
               SET NOTEDT=$PIECE(NOTEDT," ",1)   ;"Drop time
               NEW X SET X=$$DT^XLFDT()
               IF X'=NOTEDT\1 DO
               . SET CURDT=$$FMTE^XLFDT(X,"5D") ;"Outputs MM/DD/YYYY
               . ;"SET RESULT=RESULT_"("_CURDT_") "
               ELSE  SET CURDT=NOTEDT
               ;
               NEW PTAGE SET PTAGE=$$PTAGE^TMGTIUO3(DFN,NOTEDT) ;
               NEW Wt SET Wt=$$WEIGHT^TIULO(DFN)
               NEW Ht SET Ht=$$HEIGHT^TIULO(DFN)
               ;
               NEW FORCESHOW SET FORCESHOW=$SELECT(TYPE="ALL":0,(1=1):1)
               ;
               IF (TYPE["TEMP")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,$$TEMP^TIULO(DFN),"T",.CURDT,.NOTEDT,FORCESHOW)
               IF (TYPE["BP")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,$$BP^TIULO(DFN),"BP",.CURDT,.NOTEDT,FORCESHOW)
               IF (TYPE["RESP")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,$$RESP^TIULO(DFN),"R",.CURDT,.NOTEDT,FORCESHOW)
               IF (TYPE["Pulse")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,$$PULSE^TIULO(DFN),"P",.CURDT,.NOTEDT,FORCESHOW)
               IF (TYPE["WT")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,Wt,"Wt",.CURDT,.NOTEDT,1,PTAGE)
               . IF PTAGE<18 DO ADDPCTILE^TMGTIUO3(.RESULT,"Wt",Wt,PTAGE,GENDER)
               IF (TYPE["HT")!(TYPE="ALL") DO
               . NEW inchHt SET inchHt=$$FORMATHT^TMGTIUO3(Ht,PTAGE)
               . DO ADDVITAL^TMGTIUO3(.RESULT,inchHt,"Ht",.CURDT,.NOTEDT,1,PTAGE)
               . IF PTAGE<18 DO ADDPCTILE^TMGTIUO3(.RESULT,"Ht",Ht,PTAGE,GENDER)
               IF TYPE["HC" DO
               . NEW HC,HCSTR SET HCSTR=$$HC^TMGTIUO3(DFN,.HC)
               . DO ADDVITAL^TMGTIUO3(.RESULT,HC,"HC",.CURDT,.NOTEDT,1,PTAGE)
               . IF PTAGE<18 DO ADDPCTILE^TMGTIUO3(.RESULT,"HC",HC,PTAGE,GENDER)
               . IF RESULT="" SET RESULT="N/A"
               IF (TYPE["BMI")!(TYPE="ALL") DO
               . NEW BMISTR,BMI,IDEALWTS
               . SET BMISTR=$$BMI^TMGTIUO3(Ht,Wt,.BMI,.IDEALWTS) QUIT:BMI=0 ;"Sets BMISTR and BMI
               . DO ADDVITAL^TMGTIUO3(.RESULT,BMISTR,"BMI",.CURDT,.NOTEDT,1,PTAGE)
               . IF PTAGE<18 DO ADDPCTILE^TMGTIUO3(.RESULT,"BMI",BMI,PTAGE,GENDER)
               . IF (PTAGE>17)&(TYPE="ALL") SET RESULT=RESULT_$$BMICOMNT^TMGTIUO3(BMI,PTAGE,IDEALWTS) ;"BMI COMMENT
               IF (TYPE["WT")!(TYPE="ALL") DO  ;"Wt done in two parts
               . NEW WTDELTA SET WTDELTA=$$WTDELTA(DFN,.TIU,0)
               . IF WTDELTA="" QUIT
               . SET RESULT=RESULT_"; "_WTDELTA
               ;
               IF RESULT="" DO
               . SET RESULT="[See vital-signs documented in paper chart]"
               ELSE  DO
               . NEW OUTARRAY,i
               . NEW R2 SET R2=""
               . IF $$SplitLine^TMGSTUTL(RESULT,.OUTARRAY,60,0,10,";")
               . SET i=0 FOR  SET i=$ORDER(OUTARRAY(i)) QUIT:(+i'>0)  DO
               . . IF R2'="" SET R2=R2_";"_$CHAR(13,10)
               . . SET R2=R2_OUTARRAY(i)
               . SET RESULT=$$TrimL^TMGSTUTL(R2)
               QUIT RESULT
               ;
TMGVISDT(TIU)    ;" Visit date
               ;"Purpose: Return a string for date of visit
               ;"Note: This is based on the function VISDATE^TIULO1(TIU)
               ;"        However, that function seemed to return the appointment date associated
               ;"                with a note, rather than the specified date of the note
               ;"        Also, this will return date only--not time.
               ;"Input: TIU -- this is an array created by TIU system.  See documentation above.
               ;"Output: returns RESULT
               NEW TIUX,TIUY,RESULT
               IF $GET(TIU("VISIT"))'="" DO
               . SET RESULT=$PIECE(TIU("VISIT"),U,2)
               ELSE  IF $GET(TIU("VSTR"))'="" DO
               . SET RESULT=$PIECE(TIU("VSTR"),";",2)
               ELSE  DO
               . SET RESULT="(Visit Date Unknown)"
               IF +RESULT>0 DO
               . SET RESULT=$$DATE^TIULS(RESULT,"MM/DD/YY HR:MIN")
               . SET RESULT=$PIECE(RESULT," ",1)  ;"cut off time.
VDDone   QUIT RESULT
               ;
               ;
FNAME(DFN)       ;
               ;"Purpose: Return Patient's first name
               ;"Input: DFN -- the patient's unique ID (record#)
               ;"Output: returns RESULT
               NEW NAME SET NAME=$PIECE($GET(^DPT(DFN,0)),"^",1)
               SET NAME=$PIECE(NAME,",",2)
               SET NAME=$PIECE(NAME," ",1)
               SET NAME=$$CapWords^TMGSTUTL(NAME)
               QUIT NAME
               ;
               ;
MNAME(DFN)      ;
               ;"Purpose: Return Patient's middle name(s)
               ;"Input: DFN -- the patient's unique ID (record#)
               ;"Output: returns RESULT
               NEW NAME SET NAME=$PIECE($GET(^DPT(DFN,0)),"^",1)
               SET NAME=$PIECE(NAME,",",2)
               SET NAME=$PIECE(NAME," ",2,100)
               SET NAME=$$CapWords^TMGSTUTL(NAME)
               QUIT NAME
               ;
               ;
LNAME(DFN)      ;
               ;"Purpose: Return Patient's last name
               ;"Input: DFN -- the patient's unique ID (record#)
               ;"Output: returns RESULT
               NEW NAME SET NAME=$PIECE($GET(^DPT(DFN,0)),"^",1)
               SET NAME=$PIECE(NAME,",",1)
               SET NAME=$$CapWords^TMGSTUTL(NAME)
               QUIT NAME
               ;
               ;
NICENAME(DFN)   ;
               ;"Purpose: Return Patient's name format: Firstname Middlename Lastname
               ;"                      only the first letter of each name capitalized.
               ;"Input: DFN -- the patient's unique ID (record#)
               ;"Output: returns RESULT
               NEW NAME SET NAME=$PIECE($GET(^DPT(DFN,0)),"^",1)
               SET NAME=$PIECE(NAME,",",2)_" "_$PIECE(NAME,",",1) ;"put first NAME first
               SET NAME=$$CapWords^TMGSTUTL(NAME)
               QUIT NAME
               ;
               ;
PHONENUM(DFN)   ;
               ;"Purpose: to return the patient's phone number
               ;"Input: DFN -- the patient's unique ID (record#)
               ;"Output: returns RESULT
               NEW RESULT SET RESULT=""
               SET DFN=+$GET(DFN)
               IF DFN=0 GOTO PNDone
               SET RESULT=$$GET1^DIQ(2,DFN_",",.131)
               SET RESULT=$TRANSLATE(RESULT," ","")
               IF $LENGTH(RESULT)=10 DO
               . NEW TEMP SET TEMP=RESULT
               . SET RESULT="("_$EXTRACT(RESULT,1,3)_") "_$EXTRACT(RESULT,4,6)_"-"_$EXTRACT(RESULT,7,10)
               ;
               IF $LENGTH(RESULT)=7 DO
               . NEW TEMP SET TEMP=RESULT
               . SET RESULT=$EXTRACT(RESULT,1,3)_"-"_$EXTRACT(RESULT,4,7)
               ;
PNDone   QUIT RESULT
               ;
               ;
WTTREND(DFN,TIU)        ;
               ;"Purpose: return text showing patient's trend in change of weight.
               ;"         e.g. 215 <== 212 <== 256 <== 278
               ;"Input: DFN=the Patient's IEN in file #2
               ;"       TIU=PASS BY REFERENCE.  Should be an Array of TIU note info
               ;"                               See documentation in VITALS(DFN,TIU)
               ;"Results: Returns string describing changes in weight.
               ;
               NEW RESULT SET RESULT=""
               NEW DATE SET DATE=$GET(TIU("EDT"))
               IF +DATE'>0 DO  GOTO WTTRDone
               . SET RESULT="(No wts available)"
               NEW ARRAY
               DO PRIORVIT^TMGTIUO3(.DFN,DATE,"WEIGHT",.ARRAY)
               SET DATE=""
               FOR  SET DATE=$ORDER(ARRAY(DATE),-1) QUIT:(+DATE'>0)  DO
               . IF RESULT'="" SET RESULT=RESULT_" <== "
               . SET RESULT=RESULT_$ORDER(ARRAY(DATE,""))
               SET RESULT="Wt trend: "_RESULT
               ;
WTTRDone        QUIT RESULT
               ;
               ;
WTDELTA(DFN,TIU,NONULL) ;
               ;"Purpose: return text showing patient's change in weight.
               ;"Input: DFN=the Patient's IEN in file #2
               ;"       TIU=PASS BY REFERENCE.  Should be an Array of TIU note info
               ;"                               See documentation in VITALS(DFN,TIU)
               ;"       NONULL -- optional.  Default=1.  If 0, no "?" returned
               ;"Results: Returns string describing change in weight.
               ;
               NEW RESULT SET RESULT="Weight "
               SET NONULL=+$GET(NONULL,1)
               NEW DELTA
               NEW DATE SET DATE=$GET(TIU("EDT"))  ;"Episode date
               IF +DATE'>0 DO  GOTO WTDDone
               . IF NONULL=0 SET RESULT="" QUIT
               . SET RESULT=RESULT_"change: ?"
               ;
               NEW ARRAY
               DO PRIORVIT^TMGTIUO3(.DFN,DATE,"WEIGHT",.ARRAY)
               ;
               NEW NTLast,Last
               DO GetLast2^TMGTIUO3(.ARRAY,.NTLast,.Last)
               SET Last=+Last
               SET NTLast=+NTLast
               IF NTLast=0 SET RESULT="" GOTO WTDDone
               SET DELTA=Last-NTLast
               IF DELTA>0 SET RESULT=RESULT_"up "_DELTA_" lbs. "
               ELSE  IF DELTA<0 SET RESULT=RESULT_"down "_-DELTA_" lbs. "
               ELSE  DO
               . IF Last=0 SET RESULT=RESULT_"change: ?" QUIT
               . SET RESULT=RESULT_"unchanged. "
               ;
               IF (Last>0)&(NTLast>0) DO
               . SET RESULT=RESULT_"("_Last_" <== "_NTLast_" prior wt)"
               ;
WTDDone QUIT RESULT
               ;
               ;
               ;
IsHTML(IEN8925) ;"Depreciated  Moved to TMGHTM1
               GOTO ISHTML+1^TMGHTM1
               ;
HTML2TXT(Array)  ;"Depreciated.  Moved to TMGHTM1
               GOTO HTML2TXT+1^TMGHTM1
               ;
               ;
StubRecommendations(DFN,ARRAY,Label)     ;
               ;"Purpose: to add stubs for recommended studies to Array
               ;"Get age from DFN
               SET DFN=+$GET(DFN)
               IF DFN=0 GOTO SRDone
               NEW AGE SET AGE=+$$GET1^DIQ(2,DFN,.033)
               NEW SEX SET SEX=$$GET1^DIQ(2,DFN,.02)
               ;
               IF Label="[STUDIES]" DO
               . IF (SEX="FEMALE") DO
               . . IF (AGE>39) DO ENSURE^TMGTIUO3(.ARRAY,"Mammogram")
               . . IF (AGE>59) DO ENSURE^TMGTIUO3(.ARRAY,"Bone Density")
               . . IF (AGE>18) DO ENSURE^TMGTIUO3(.ARRAY,"Pap")
               . . IF (AGE>8)&(AGE<27) DO ENSURE^TMGTIUO3(.ARRAY,"Gardasil",":","#1 <no data>; #2  <no data>; #3  <no data> ")
               . IF (SEX="MALE")&(AGE>49) DO ENSURE^TMGTIUO3(.ARRAY,"PSA")
               . IF AGE>64 DO ENSURE^TMGTIUO3(.ARRAY,"Pneumovax")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Flu Vaccine")
               . IF (AGE>18) DO ENSURE^TMGTIUO3(.ARRAY,"Advance Directives")
               . ;"IF (AGE>49) DO ENSURE^TMGTIUO3(.ARRAY,"Td")
               . IF (AGE>59) DO ENSURE^TMGTIUO3(.ARRAY,"Zostavax")
               . IF (AGE>1)&(AGE<19) DO ENSURE^TMGTIUO3(.ARRAY,"MMR",":","#1 <no data>; #2  <no data>")
               . IF (AGE>0)&(AGE<21) DO ENSURE^TMGTIUO3(.ARRAY,"Hep B",":","#1 <no data>; #2  <no data>; #3  <no data> ")
               . IF (AGE>1)&(AGE<19) DO ENSURE^TMGTIUO3(.ARRAY,"Hep A",":","#1 <no data>; #2  <no data>")
               . IF (AGE>1)&(AGE<21) DO ENSURE^TMGTIUO3(.ARRAY,"Varivax",":","#1 <no data>; #2  <no data>")
               . IF (AGE>10)&(AGE<65) DO ENSURE^TMGTIUO3(.ARRAY,"TdaP / Td")
               . IF (AGE>10)&(AGE<23) DO ENSURE^TMGTIUO3(.ARRAY,"MCV4 (Menactra)")
               . IF (AGE>50) DO ENSURE^TMGTIUO3(.ARRAY,"Colonoscopy")
               ELSE  IF Label="[DIABETIC STUDIES]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"HgbA1c","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Diabetic Eye Exam")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Urine Microalbumin")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Diabetic Foot Exam")
               . DO ENSURE^TMGTIUO3(.ARRAY,"EKG")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Regimen")
               ELSE  IF Label="[LIPIDS]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Total Cholesterol","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"LDL Cholesterol","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"HDL Cholesterol","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Triglycerides","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Date of last lipid panel")
               . DO ENSURE^TMGTIUO3(.ARRAY,"LDL Goal")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Liver Enzymes")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Regimen")
               ELSE  IF Label="[SOCIAL]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Tobacco")
               . DO ENSURE^TMGTIUO3(.ARRAY,"EtOH")
               ELSE  IF Label="[THYROID]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Date of last study")
               . DO ENSURE^TMGTIUO3(.ARRAY,"TSH","=")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Regimen")
               ELSE  IF Label="[HYPERTENSION]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Date of last electrolytes")
               . DO ENSURE^TMGTIUO3(.ARRAY,"EKG")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Med-1")
               ELSE  IF Label="[ANEMIA]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Hgb")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Serum Fe")
               . DO ENSURE^TMGTIUO3(.ARRAY,"TIBC")
               . DO ENSURE^TMGTIUO3(.ARRAY,"B12")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Folate")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Workup")
               ELSE  IF Label="[ASTHMA]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Peak Flow Personal Best")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Meds")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Rescue Inhaler Freq")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Pneumovax")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Triggers")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Smoker")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Nocturnal Symptoms")
               ELSE  IF Label="[COPD]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Meds")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Rescue Inhaler Freq")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Pneumovax")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Pulmonologist")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Home O2")
               . DO ENSURE^TMGTIUO3(.ARRAY,"PFT Testing")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Tobacco Cessation Counselling")
               ELSE  IF Label="[OSTEOPENIA/OSTEOPOROSIS]" DO
               . DO ENSURE^TMGTIUO3(.ARRAY,"Bone Density")
               . DO ENSURE^TMGTIUO3(.ARRAY,"T-Score Spine/Hips")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Regimen")
               . DO ENSURE^TMGTIUO3(.ARRAY,"Advised Calcium ~1500 mg & Vit-D 1000-2000 IU")
               ;
SRDone   QUIT
               ;
               ;
        ;"-------------------------------------------------------------
        ;"-------------------------------------------------------------
GETTABL1(DFN,LABEL)     ;
               ;"Purpose: A call point for TIU objects, to return a table comprised from 1 prior table.
               ;"NOTE: This type of table just gets the *LAST* table found (not a compilation)
GT1         NEW ARRAY,RESULT SET RESULT=""
               IF $GET(LABEL)="" GOTO GT1Done
               SET RESULT="     -- "_LABEL_" ---------"_$CHAR(13)_$CHAR(10)
               DO GetSpecial^TMGTIUO3(DFN,LABEL,"BLANK_LINE",48,.ARRAY,1)  ;"mode 1 = only last table; 2=compile
               DO StubRecommendations(.DFN,.ARRAY,LABEL)
               SET RESULT=RESULT_$$ARRAY2STR^TMGTIUO3(.ARRAY)
GT1Done QUIT RESULT
               ;
               ;
GETTABLX(DFN,LABEL)     ;
               ;"Purpose: A call point for TIU objects, to return a table comprised from prior notes.
               ;"NOTE: This compiles a table from all prior matching tables in date range.
               ;
               GOTO GT1 ;"<-- Hack to force TableX to really be a Table1 type table.
               ;
               NEW ARRAY,RESULT SET RESULT=""
               IF $GET(LABEL)="" GOTO GTXDone
               SET RESULT="     -- "_LABEL_" ---------"_$CHAR(13)_$CHAR(10)
               DO GetSpecial^TMGTIUO3(DFN,LABEL,"BLANK_LINE",13,.ARRAY,2)  ;"mode 1 = only last table; 2=compile
               DO StubRecommendations(.DFN,.ARRAY,LABEL)
               SET RESULT=RESULT_$$ARRAY2STR^TMGTIUO3(.ARRAY)
GTXDone QUIT RESULT
