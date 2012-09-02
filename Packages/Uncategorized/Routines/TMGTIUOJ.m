TMGTIUOJ        ;TMG/kst-Text objects for use in CPRS ; 7/17/12
                ;;1.0;TMG-LIB;**1,17**;03/25/06;Build 23
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
        ;"     'VITALS' would be a TIU TEXT OBJECT, managed through menu option 
        ;"     TIUFJ CREATE OBJECTS MGR
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
        ;"$$GETTABL1(DFN,LABEL) -- return a table from prior notes.
        ;"$$GETTABLX(DFN,LABEL) -- return a table compiled from prior notes.
        ;"=======================================================================
        ;"PRIVATE FUNCTIONS
        ;"=======================================================================
        ;
        ;"=======================================================================
        ;"Dependancies :  TMGSTUT2 TMGTIUO3 TMGTIUO4 TMGTIUO6
        ;"                TIUL01 XLFDT TIULO XLFSTR
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
               ;"                  TIU("STOP") = mark to defer workload
               ;"                  TIU("TYPE")=1^title DA^title Name  i.e.:  1^128^OFFICE VISIT^OFFICE VISIT
               ;"                  TIU("SVC")=service, e.g. 'FAMILY PRACTICE'
               ;"                  TIU("EDT")=TIUEDT^DateStr  = event begin time: FMDate^DateStr
               ;"                  TIU("LDT")=TIULDT^DateStr  = event end time: FMDate^DateStr
               ;"                  TIU("VSTR")=LOC;VDT;VTYP  e.g. 'x;x;OFFICE VISIT'
               ;"                  TIU("VISIT")=Visit File IFN
               ;"                  TIU("LOC")=TIULOC
               ;"                  TIU("VLOC")=TIULOC
               ;"                  TIU("STOP")=0  ;0=FALSE, don't worry about stop codes.
               ;"      TYPE -- "Wt" - Returns the weight value
               ;"              "Ht" - Returns the height value
               ;"              "BMI" - Returns the BMI value
               ;"              "HC" - Returns the Head Circumference value
               ;"              "TEMP","BP","Pulse" -- usual values
               ;"              "ALL" - (Default value) Return all values
               ;"              or Combination, e.g. "WT,HT,HC"
               ;"Results: String with value units and percentile (if available) and date if not current date
               ;"Output: returns RESULT
               NEW DEBUG SET DEBUG=0
               IF DEBUG=1 DO
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
               NEW WT SET WT=$$WEIGHT^TIULO(DFN)
               NEW HT SET HT=$$HEIGHT^TIULO(DFN)
               ;
               NEW FORCESHOW SET FORCESHOW=$SELECT(TYPE="ALL":0,(1=1):1)
               NEW OLDEXCLD
               ;
               IF (TYPE["TEMP")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,$$TEMP^TIULO(DFN),"T",.CURDT,.NOTEDT,FORCESHOW,,.OLDEXCLD)
               IF (TYPE["BP")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,$$BP^TIULO(DFN),"BP",.CURDT,.NOTEDT,FORCESHOW,,.OLDEXCLD)
               IF (TYPE["RESP")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,$$RESP^TIULO(DFN),"R",.CURDT,.NOTEDT,FORCESHOW,,.OLDEXCLD)
               IF (TYPE["Pulse")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,$$PULSE^TIULO(DFN),"P",.CURDT,.NOTEDT,FORCESHOW,,.OLDEXCLD)
               IF (TYPE["WT")!(TYPE="ALL") DO
               . DO ADDVITAL^TMGTIUO3(.RESULT,WT,"Wt",.CURDT,.NOTEDT,1,PTAGE,.OLDEXCLD)
               . IF (PTAGE<18)&($GET(OLDEXCLD("Wt"))=0) DO ADDPCTLE^TMGTIUO3(.RESULT,"Wt",WT,PTAGE,GENDER)
               IF (TYPE["HT")!(TYPE="ALL") DO
               . NEW INCHHT SET INCHHT=$$FORMATHT^TMGTIUO3(HT,PTAGE)
               . DO ADDVITAL^TMGTIUO3(.RESULT,INCHHT,"Ht",.CURDT,.NOTEDT,1,PTAGE,.OLDEXCLD)
               . IF (PTAGE<18)&($GET(OLDEXCLD("Ht"))=0) DO ADDPCTLE^TMGTIUO3(.RESULT,"Ht",HT,PTAGE,GENDER)
               IF TYPE["HC" DO
               . NEW HC,HCSTR SET HCSTR=$$HC^TMGTIUO3(DFN,.HC)
               . DO ADDVITAL^TMGTIUO3(.RESULT,HC,"HC",.CURDT,.NOTEDT,1,PTAGE,.OLDEXCLD)
               . IF PTAGE<18 DO ADDPCTLE^TMGTIUO3(.RESULT,"HC",HC,PTAGE,GENDER)
               . IF RESULT="" SET RESULT="N/A"
               IF (TYPE["BMI")!(TYPE="ALL") DO
               . IF ($GET(OLDEXCLD("Ht"))=1)!($GET(OLDEXCLD("Wt"))=1) QUIT
               . NEW BMISTR,BMI,IDEALWTS
               . SET BMISTR=$$BMI^TMGTIUO4(HT,WT,.BMI,.IDEALWTS) QUIT:BMI=0  ;"Sets BMISTR and BMI
               . DO ADDVITAL^TMGTIUO3(.RESULT,BMISTR,"BMI",.CURDT,.NOTEDT,1,PTAGE,.OLDEXCLD)
               . IF PTAGE<18 DO ADDPCTLE^TMGTIUO3(.RESULT,"BMI",BMI,PTAGE,GENDER)
               . IF (PTAGE>17)&(TYPE="ALL") SET RESULT=RESULT_$$BMICOMNT^TMGTIUO4(BMI,PTAGE,IDEALWTS) ;"BMI COMMENT
               IF (TYPE["WT")!(TYPE="ALL") DO  ;"Wt done in two parts
               . IF $GET(OLDEXCLD("Wt"))=1 QUIT
               . NEW WTDELTA SET WTDELTA=$$WTDELTA^TMGTIUO4(DFN,.TIU,0)
               . IF WTDELTA="" QUIT
               . SET RESULT=RESULT_"; "_WTDELTA
               ;
               IF RESULT="" DO
               . SET RESULT="[See vital-signs documented in chart]"
               ELSE  DO
               . NEW OUTARRAY,I
               . NEW R2 SET R2=""
               . IF $$SPLITLN^TMGSTUT2(RESULT,.OUTARRAY,60,0,10,";")
               . SET I=0 FOR  SET I=$ORDER(OUTARRAY(I)) QUIT:(+I'>0)  DO
               . . IF R2'="" SET R2=R2_";"_$CHAR(13,10)
               . . SET R2=R2_OUTARRAY(I)
               . SET RESULT=$$TRIM^XLFSTR(R2,"l")
               QUIT RESULT
               ;
TMGVISDT(TIU)    ;" Visit date
               QUIT $$TMGVISDT^TMGTIUO3(.TIU)
               ;
FNAME(DFN)       ;
               QUIT $$FNAME^TMGTIUO3(DFN)
               ;
MNAME(DFN)      ;
               QUIT $$MNAME^TMGTIUO3(DFN)
               ;
LNAME(DFN)      ;
               QUIT $$LNAME^TMGTIUO3(DFN)
               ;
NICENAME(DFN)   ;
               QUIT $$NICENAME^TMGTIUO3(DFN)
               ;
PHONENUM(DFN)   ;
               QUIT $$PHONENUM^TMGTIUO3(DFN)
               ;
WTTREND(DFN,TIU)        ;
               QUIT $$WTTREND^TMGTIUO4(DFN,.TIU)
               ;"Purpose: return text showing patient's trend in change of weight.
               ;
GETTABL1(DFN,LABEL)     ;
               ;"Purpose: A call point for TIU objects, to return a table comprised from 1 prior table.
               QUIT $$GETTABL1^TMGTIUO6(DFN,LABEL)
               ;
GETTABLX(DFN,LABEL)     ;
               ;"Purpose: A call point for TIU objects, to return a table comprised from prior notes.
               QUIT $$GETTABLX^TMGTIUO6(DFN,LABEL)
               ;
MEDLIST(RESULT,DFN)      ;
               ;"Purpose: RPC (TMG GET MED LIST) to return a patient's med list
        SET RESULT=$$GETTABLX(DFN,"MEDICATIONS")
        QUIT
               ;
