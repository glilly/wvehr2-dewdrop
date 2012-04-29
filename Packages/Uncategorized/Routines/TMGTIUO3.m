TMGTIUOJ        ;TMG/kst-Text objects for use in CPRS ; 10/24/10
                ;;1.0;TMG-LIB;**1**;10/24/10;Build 23
        ;
        ;"Kevin Toppenberg MD
        ;"(C) 10/2010
        ;"Released under: GNU General Public License (GPL)
        ;
        ;"=======================================================================
        ;" This is spill over code from TMGTIUOBJ, to make that file size smaller.
        ;"=======================================================================
        ;"TMG text objects
        ;"
        ;"=======================================================================
        ;"PUBLIC FUNCTIONS
        ;"=======================================================================
        ;"$$AGEONDAT(DFN,REFDATE)  -- Returns age on a given date
        ;
        ;"=======================================================================
        ;"PRIVATE FUNCTIONS
        ;"=======================================================================
        ;"ADDVITAL(RESULT,s,Label,CurDT,NoteDT,ForceShow) -- format and add a vital set, wrapping line if needed.
        ;"ADDPCTILE(RESULT,TYPE,Value,PTAGE,Gender) --add percentile of vital measurement, if possible.
        ;"FormatVitals(RESULT,s,Label,CurDT,NoteDT) -- remove redundant text in formating Vitals
        ;"REMOVEDT(S,DT) --remove a date-Time string, and return in DT
        ;"$$RemoveTime(DT) --remove the time from a date/time string
        ;"$$FORMATHT(HtS,PTAGE) remove centimeters from patient's height for adults
        ;"DateDelta(RefDT,DT) --  determine the number of days between RefDT and DT
        ;"TMGVISDT(TIU)  Return a string for date of visit
        ;"GetLast2(Array,NTLast,Last) Returns last 2 values in array (as created by PRIORVIT)
        ;"PRIORVIT(DFN,Date,Vital,Array) retrieve a list of prior vital entries for a patient
        ;"LASTHC(DFN) --Return the patient's last head circumference
        ;"GetNotesList(DFN,List,IncDays)
        ;"ExtractSpecial(IEN8925,StartMarkerS,EndMarkerS,Array)
        ;"MergeInto(partArray,masterArray)
        ;"GetSpecial(DFN,StartMarkerS,EndMarkerS,Months,Array,Mode)
        ;"ARRAY2STR(ARRAY) convert Array (as created by GetSpecial) into one long string
        ;"ENSURE(ARRAY,KEY,PIVOT,VALUE) --add one (empty) entry, if a value for this doesn't already exist.
        ;"HTML2TXT(Array) -- ;Depreciated  Moved to TMGHTM1
        ;"=======================================================================
        ;"Dependancies :  TMGSTUTL, TMGGRC1, TMGGRC2
        ;"=======================================================================
        ;
ADDVITAL(RESULT,s,Label,CurDT,NoteDT,ForceShow,PTAGE)   ;
               ;"Purpose: To format and add a vital set, wrapping line if needed.
               ;"Input: RESULT -- PASS BY REFERENCE .. the cumulative string
               ;"         s -- the string value result to add
               ;"         Label -- the text label
               ;"         CurDT -- the last DT string shown
               ;"         NoteDT -- [optional] DT string of date of note
               ;"                        If provided, then the date of the vital sign must equal NoteDT, or
               ;"                        "" is returned (Unless ForceShow=1)
               ;"         ForceShow -- [optional] 1: Will force a return result, if otherwise wouldn't be shown
               ;"         PTAGE -- [optional], default is 99-- age in YRS of patient
               ;"Results: none (changes are passed back in result)
               NEW tempS SET tempS=""
               DO FormatVitals(.tempS,.s,.Label,.CurDT,.NoteDT,.ForceShow,.PTAGE)
               IF (tempS'="")&(RESULT'="") SET RESULT=RESULT_"; "
               SET RESULT=RESULT_tempS;
               QUIT
               ;
ADDPCTILE(RESULT,TYPE,Value,PTAGE,Gender)       ;
               ;"Purpose: To add percentile of vital measurement, if possible.
               ;"Input:   RESULT -- PASS BY REFERENCE .. the cumulative string
               ;"         TYPE -- the type of percentile to add: 'Ht','Wt','HC', 'WtLen'
               ;"         Value -- the value of the vital sign, in metric
               ;"         PTAGE -- The patients age *In Years*
               ;"         gender -- must by 'M' or 'F'
               ;"Results: none (changes are passed back in RESULT)
               SET TYPE=$GET(TYPE)
               SET Value=$GET(Value)
               NEW tempS SET tempS=""
               ;
               IF TYPE="Ht" DO
               . SET Value=$PIECE($PIECE(Value,"[",2),"]",1)
               . SET Value=+Value
               . SET tempS=$$LENPCTL^TMGGRC1(.PTAGE,.Gender,Value)
               ELSE  IF TYPE="Wt" DO
               . SET Value=$PIECE($PIECE(Value,"[",2),"]",1)
               . SET Value=+Value
               . SET tempS=$$WTPCTL^TMGGRC1(.PTAGE,.Gender,Value)
               ELSE  IF TYPE="BMI" DO
               . SET tempS=$$BMIPCTL^TMGGRC1(.PTAGE,.Gender,Value)
               ELSE  IF TYPE="HC" DO
               . SET tempS=$$HCPCTL^TMGGRC1(.PTAGE,.Gender,Value)
               ELSE  IF TYPE="WtLen" DO
               . SET tempS=$$WTLENPCTL^TMGGRC1(.PTAGE,.Gender,Value)
               ;
               ;"SET RESULT=$$ADDWRAP^TMGSTUTL(RESULT,tempS,60,INDENTSTR)
               IF (tempS'="")&(RESULT'="") SET RESULT=RESULT_", "
               SET RESULT=RESULT_tempS;
               QUIT
               ;
               ;
FormatVitals(RESULT,s,Label,CurDT,NoteDT,ForceShow,PTAGE)       ;
               ;"Purpose: To remove redundant text in formating Vitals
               ;"Input:   RESULT -- PASS BY REFERENCE .. the cumulative string
               ;"         s -- the string value result to add
               ;"         Label -- the text label
               ;"         CurDT -- the last DT string shown
               ;"         NoteDT -- [optional] DT string of date of note
               ;"                        If provided, then the date of the vital sign must equal NoteDT, or
               ;"                        "" is returned (Unless ForceShow=1)
               ;"         ForceShow -- [optional] 1: Will force a return RESULT, if otherwise wouldn't be shown
               ;"         PTAGE -- [optional], default is 99-- age in YRS of patient
               ;"Results: none (changes are passed back in RESULT)
               ;
               SET RESULT=$GET(RESULT)
               SET PTAGE=+$GET(PTAGE,99)
               IF $GET(s)'="" DO
               . NEW VITALDT SET VITALDT=""
               . NEW Delta
               . SET s=$$REMOVEDT(s,.VITALDT)
               . SET VITALDT=$$RemoveTime(VITALDT)
               . SET Delta=$$DateDelta(.NoteDT,.VITALDT) QUIT:(Delta<0)
               . IF (Delta>0)&($GET(NoteDT)'="")&($GET(ForceShow)'=1) QUIT ;"If NoteDT specified, don't allow delta>0
               . IF (RESULT'="")&($EXTRACT(RESULT,$LENGTH(RESULT))'=$char(9)) SET RESULT=RESULT_", "
               . IF CurDT'=VITALDT DO
               . . SET CurDT=VITALDT
               . . IF (Delta>0)&(VITALDT'="") DO
               . . . IF (PTAGE>18)!(Delta<32) DO  QUIT
               . . . . SET RESULT=RESULT_"("_VITALDT_") "
               . . . ELSE  DO
               . . . . NEW AGESTR,AGEATVIT SET AGEATVIT=$$AGEONDAT(DFN,VITALDT)
               . . . . IF AGEATVIT<2 SET AGESTR=$JUSTIFY(AGEATVIT/12,0,0)_" mo"
               . . . . ELSE  SET AGESTR=$JUSTIFY(AGEATVIT,0,1)_" yr"
               . . . . SET RESULT=RESULT_"("_VITALDT_" @ "_AGESTR_") "
               . SET RESULT=RESULT_Label_" "_s
FVDone   QUIT
               ;
               ;
REMOVEDT(S,DT)   ;
               ;"Purpose: to remove a date-Time string, and return in DT
               ;"    i.e. turn this:
               ;"        127/56 (12/25/04 16:50)
               ;"    into these:
               ;"        '127/56'   and   '12/25/04 16:50'
               ;"Input:  S -- a string as above
               ;"       DT -- [Optional] an OUT parameter... must PASS BY REFERENCE
               ;"RESULT: returns input string with (date-time) removed
               ;"        Date-Time is returned in DT if passed by reference.
               ;
               NEW RESULT SET RESULT=$GET(S)
               IF RESULT="" GOTO RDTDone
               ;
               SET RESULT=$PIECE(S,"(",1)
               SET RESULT=$$Trim^TMGSTUTL(.RESULT)
               SET DT=$PIECE(S,"(",2)
               SET DT=$PIECE(DT,")",1)
               SET DT=$$Trim^TMGSTUTL(.DT)
               ;
RDTDone QUIT RESULT
               ;
               ;
RemoveTime(DT)  ;
               ;"Purpose: to remove the time from a date/time string
               ;"Input: DT -- the date/time string, i.e. '2/24/05 16:50'
               ;"RESULT: returns just the date, i.e. '2/25/05'
               NEW RESULT SET RESULT=$PIECE(DT," ",1)
               QUIT RESULT
               ;
               ;
FORMATHT(HtS,PTAGE)      ;
               ;"Purpose: to remove centimeters from patient's height for adults
               ;"Input: Ht, a height string, e.g. '74 in [154 cm] (1/1/1990)'
               ;"       PTAGE, patient's age in years
               ;"Result: returns patient height, with [154 cm] removed, if age > 16
               NEW RESULT SET RESULT=$GET(HtS)
               IF $GET(PTAGE)'<16 DO
               . SET RESULT=$PIECE(HtS,"[",1)
               . IF HtS["(" SET RESULT=RESULT_"("_$PIECE(HtS,"(",2,99)
               QUIT RESULT
               ;
               ;
DateDelta(RefDT,DT)     ;
               ;"Purpose: To determine the number of days between RefDT and DT
               ;"                i.e. How many days DT was before RefDT.
               ;"Input:RefDT -- a reference/baseline date/time string
               ;"                if not supplied, Current date/time used as default.
               ;"        DT -- a date/time string (i.e. '12/25/04 16:50')
               ;"Result: Return number of days between DT and RefDT
               ;"        Positive numbers used when DT occured before current date
               ;"        i.e. RESULT=RefDT-DT
               NEW iNowDT,iRefDT,iDT  ;internal format of dates
               NEW RESULT SET RESULT=0
               SET X=DT DO ^%DT SET iDT=Y         ;"Convert date into internal
               IF $GET(RefDT)="" SET iRefDT=$$DT^XLFDT
               ELSE  SET X=RefDT DO ^%DT SET iRefDT=Y   ;"Convert date into internal
               SET RESULT=$$FMDIFF^XLFDT(iRefDT,iDT)
               ;
               QUIT RESULT
               ;
               ;
TMGVISDT(TIU)    ;" Visit date
               ;"Purpose: Return a string for date of visit
               ;"Note: This is based on the function VISDATE^TIULO1(TIU)
               ;"        However, that function seemed to return the appointment date associated
               ;"                with a note, rather than the specified date of the note
               ;"        Also, this will return date only--not time.
               ;"Input: TIU -- this is an array created by TIU system.  See documentation above.
               ;"Output: returns RESULT
               ;
               N TIUX,TIUY
               NEW RESULT
               IF $GET(TIU("VISIT"))'="" DO
               . SET RESULT=$PIECE(TIU("VISIT"),U,2)
               ELSE  IF $GET(TIU("VSTR"))'="" DO
               . SET RESULT=$PIECE(TIU("VSTR"),";",2)
               ELSE  DO
               . SET RESULT="(Visit Date Unknown)"
               ;
               IF +RESULT>0 DO
               . SET RESULT=$$DATE^TIULS(RESULT,"MM/DD/YY HR:MIN")
               . SET RESULT=$PIECE(RESULT," ",1)  ;"cut off time.
               ;
VDDone   QUIT RESULT
               ;
               ;
AGEONDAT(DFN,REFDATE)   ;
               ;"Purpose: return patient age on given date, in years
               ;"Input: DFN -- Patient's IEN
               ;"       REFDATE -- Date of reference, in FMDate, or external form.
               ;"Output: age, in YEARS.
               NEW DOB SET DOB=$PIECE($GET(^DPT(DFN,0)),"^",3)
               NEW RESULT SET RESULT=0
               SET REFDATE=$GET(REFDATE)
               IF +REFDATE'=REFDATE DO
               . NEW %DT,X,Y
               . SET X=REFDATE DO ^%DT SET REFDATE=Y
               IF REFDATE'>0 GOTO AODDN
               NEW X1 SET X1=REFDATE
               NEW X2 SET X2=DOB
               DO ^%DTC  ;"RETURNS X=X1-X2, in days
               SET RESULT=X/365
               IF RESULT>17 SET RESULT=RESULT\1 GOTO AODDN
               IF RESULT>2 SET RESULT=+$JUSTIFY(X/365,0,1) GOTO AODDN
               SET RESULT=+$JUSTIFY(X/365,0,2) GOTO AODDN
AODDN     QUIT RESULT
               ;
               ;
PTAGE(DFN,NoteDT)       ;
               ;"Purpose: return patient's AGE (in years) on date of note (or current
               ;"         date if date of note is empty)
               ;"Input: DFN -- Patient IEN
               ;"       NoteDT -- Date of Note
               ;"Output: results in years.
               NEW PTAGE SET PTAGE=$$AGEONDAT(DFN,NoteDT)
               IF PTAGE=0 DO
               . IF NoteDT="" DO
               . . NEW X DO NOW^%DTC
               . . SET PTAGE=$$AGEONDAT(DFN,X)
               . ELSE  DO
               . . SET PTAGE=+$$GET1^DIQ(2,DFN_",",.033) ;"returns INTEGER yrs
               . . IF PTAGE>17 QUIT
               . . NEW DOB SET DOB=$PIECE($GET(^DPT(DFN,0)),"^",3)
               . . NEW %,X,X1,X2,%Y
               . . DO NOW^%DTC
               . . SET X1=X ;"now
               . . SET X2=DOB
               . . DO ^%DTC  ;"RESULT out in X (days delta)
               . . IF %Y=0 QUIT ;"dates are unworkable
               . . SET PTAGE=$JUSTIFY(X/365,0,4)
               QUIT PTAGE
               ;
               ;
BMI(Ht,Wt,BMI,IDEALWTS) ;
               ;"Purpose: Calculate Body Mass Index
               ;"Input: Ht -- height string.  E.g. '60 in [152.4 cm] (05/08/2009 13:47)'
               ;"       Wt -- weight string   E.g. '160 lb [72.7 kg] (09/21/2010 11:06)'
               ;"       BMI -- PASS BY REFERENCE, AN OUT PARAMETER.  Filled with BMI
               ;"       IDEALWTS --PASS BY REFERENCE, AN OUT PARAMETER.  Filled with 'LowNormal^HighNormal'
               ;"Output: BMI string.  E.g.  '32.5 (09/21/2010 11:06)', or '' if invalid
               NEW RESULT SET RESULT=""
               SET BMI=0,IDEALWTS=""
               IF (Wt'="")&(Ht'="") DO
               . NEW sWt,sHt,nWt,nHt,s1,WtDt,eWtDt,HtDt,eHtDt,BMIDt,eBMIDt,X,%DT
               . SET eWtDt=$PIECE($PIECE($PIECE(Wt,"(",2),")",1)," ",1) ;"Wt date string
               . SET eHtDt=$PIECE($PIECE($PIECE(Ht,"(",2),")",1)," ",1) ;"Ht date string
               . SET X=eWtDt DO ^%DT SET WtDt=Y  ;"to FMFormat
               . SET X=eHtDt DO ^%DT SET HtDt=Y  ;"to FMFormat
               . IF HtDt<WtDt DO
               . . SET eBMIDt=eHtDt
               . . SET BMIDt=HtDt
               . ELSE  DO
               . . SET eBMIDt=eWtDt
               . . SET BMIDt=WtDt
               . SET sWt=$$REMOVEDT(Wt)
               . SET sHt=$$REMOVEDT(Ht)
               . SET s1=$PIECE(sWt,"[",2)  ;"convert '200 lb [91.2 kg]' --> '91.2 kg]'
               . SET nWt=+$PIECE(s1," ",1) ;"convert '91.2 kg]' --> 91.2
               . SET s1=$PIECE(sHt,"[",2)  ;"convert '56 in [130 cm]' --> '130 cm]'
               . SET nHt=+$PIECE(s1," ",1) ;"convert '130 cm]' --> 130
               . SET nHt=nHt/100 QUIT:(nHt=0) ;"convert centimeters to meters
               . NEW MSqr SET MSqr=(nHt*nHt)
               . SET BMI=+$JUSTIFY(nWt/MSqr,0,1) QUIT:BMI=0
               . NEW idealLb1,idealLb2
               . SET idealLb1=((18.5*MSqr)*2.2)\1
               . SET idealLb2=((25*MSqr)*2.2)\1
               . SET IDEALWTS=idealLb1_"^"_idealLb2
               . SET RESULT=BMI_" ("_eBMIDt_")"
               QUIT RESULT
               ;
               ;
BMICOMNT(BMI,PTAGE,IDEALWTS)    ;"BMI COMMENT
               ;"Purpose: provide comment on BMI
               ;"Input: BMI -- numberical value of BMI
               ;"       PTAGE -- Age in years
               ;"       IDEALWTS -- lowNormalLbs^HighNormalLbs
               ;"Output: comment string
               NEW RESULT
               IF BMI<18.5 SET RESULT=" (<18.5 = ""UNDER-WT"")"
               ELSE  IF BMI<25.01 SET RESULT=" (18.5-25 = ""HEALTHY"")"
               ELSE  IF BMI<30.01 SET RESULT=" (25-30 = ""OVER-WT"")"
               ELSE  IF BMI<40.01 SET RESULT=" (30-40 = ""OBESE"")"
               ELSE  SET RESULT=" (>40 = ""VERY OBESE"")"
               IF IDEALWTS'="" DO
               . NEW idealLb1,idealLb2
               . SET idealLb1=$PIECE(IDEALWTS,"^",1) QUIT:idealLb1=0
               . SET idealLb2=$PIECE(IDEALWTS,"^",2) QUIT:idealLb2=0
               . SET RESULT=RESULT_"; (Ideal Wt="_idealLb1_"-"_idealLb2_" lbs"
               . IF (Wt>idealLb2)&(PTAGE'<18) DO
               . . SET RESULT=RESULT_"; "_(Wt-idealLb2)_" lbs over weight); "
               . ELSE  IF (Wt<idealLb1)&(PTAGE'<18) DO
               . . SET RESULT=RESULT_"; "_(idealLb1-Wt)_" lbs under weight); "
               . ELSE  DO
               . . SET RESULT=RESULT_"); "
               QUIT RESULT
               ;
HC(DFN,HC)      ;
               ;"Purpose: Return formatedd head circumference reading
               ;"Input: DFN -- The patient's IEN
               ;"       HC -- PASS BY REFERENCE, an OUT PARAMETER.  Returns value in centimeters (cm)
               ;"Result: Head circumference string, e.g. 123 cm (1/1/1980), or "" if invalid
               NEW RESULT SET RESULT="",HC=""
               NEW HEADCIR SET HEADCIR=$$LASTHC(DFN)
               IF HEADCIR="" GOTO HCDN
               SET HC=$PIECE(HEADCIR,"^",3)
               NEW DATEOFHC SET DATEOFHC=$PIECE(HEADCIR,"^",1)
               SET RESULT=$PIECE(HEADCIR,"^",2)_" in ["_HC_"cm] ("_$$FMTE^XLFDT(DATEOFHC,"5D")_")" ;"OUTPUT MM/DD/YYYY
HCDN       QUIT RESULT
               ;
               ;
LASTHC(DFN)       ;
               ;"Purpose: Return the patient's last head circumference
               ;"NOTE: this assumes that head circumference is store in CIRC/GIRTH vital type.
               ;"Input: DFN -- Patient's DFN
               ;"Output: none
               ;"Results: FMDate^Value(in)^Value(cm) or "" if invalid
               NEW RESULT
               NEW THISDT SET THISDT=9999999
               NEW VITIEN SET VITIEN=+$ORDER(^GMRD(120.51,"B","CIRCUMFERENCE/GIRTH",0))
               SET THISDT=$ORDER(^PXRMINDX(120.5,"PI",DFN,VITIEN,THISDT),-1)
               IF THISDT'>0 SET RESULT="" GOTO GHCDN
               NEW RECIEN SET RECIEN=0
               SET RECIEN=+$ORDER(^PXRMINDX(120.5,"PI",DFN,VITIEN,THISDT,RECIEN))
               NEW VALUE SET VALUE=$PIECE($GET(^GMR(120.5,RECIEN,0)),"^",8)
               IF VALUE'>0 SET RESULT=""
               ELSE  DO
               . NEW METRICVAL SET METRICVAL=$$CVTMETRIC^TMGGRC2("CG",VALUE)
               . SET THISDT=THISDT\1  ;"Trim off Time
               . SET RESULT=THISDT_"^"_VALUE_"^"_$JUSTIFY(METRICVAL,0,1)
GHCDN     QUIT RESULT
               ;
FNAME(DFN)       ;
               ;"Purpose: Return Patient's first name
               ;"Input: DFN -- the patient's unique ID (record#)
               ;"Output: returns RESULT
               NEW NAME
               SET NAME=$PIECE($GET(^DPT(DFN,0)),"^",1)
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
               NEW NAME
               SET NAME=$PIECE($GET(^DPT(DFN,0)),"^",1)
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
               NEW NAME
               SET NAME=$PIECE($GET(^DPT(DFN,0)),"^",1)
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
               NEW NAME
               SET NAME=$PIECE($GET(^DPT(DFN,0)),"^",1)
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
               . NEW temp SET temp=RESULT
               . SET RESULT="("_$EXTRACT(RESULT,1,3)_") "_$EXTRACT(RESULT,4,6)_"-"_$EXTRACT(RESULT,7,10)
               ;
               IF $LENGTH(RESULT)=7 DO
               . NEW temp SET temp=RESULT
               . SET RESULT=$EXTRACT(RESULT,1,3)_"-"_$EXTRACT(RESULT,4,7)
               ;
PNDone   QUIT RESULT
               ;
               ;
        ;"-------------------------------------------------------------
        ;"-------------------------------------------------------------
WTTREND(DFN,TIU)        ;
               ;"Purpose: return text showing patient's trend in change of weight.
               ;"         e.g. 215 <== 212 <== 256 <== 278
               ;"Input: DFN=the Patient's IEN in file #2
               ;"       TIU=PASS BY REFERENCE.  Should be an Array of TIU note info
               ;"                               See documentation in VITALS(DFN,TIU)
               ;"Results: Returns string describing changes in weight.
               ;
               NEW RESULT SET RESULT=""
               NEW Date SET Date=$GET(TIU("EDT"))
               IF +Date'>0 DO  GOTO WTTRDone
               . SET RESULT="(No wts available)"
               ;
               NEW ARRAY
               DO PRIORVIT(.DFN,Date,"WEIGHT",.ARRAY)
               ;
               NEW Date SET Date=""
               FOR  SET Date=$order(ARRAY(Date),-1) QUIT:(+Date'>0)  DO
               . IF RESULT'="" SET RESULT=RESULT_" <== "
               . SET RESULT=RESULT_$order(ARRAY(Date,""))
               ;
               SET RESULT="Wt trend: "_RESULT
               ;
WTTRDone        QUIT RESULT
               ;
               ;
WTDELTA(DFN,TIU)        ;
               ;"Purpose: return text showing patient's change in weight.
               ;"Input: DFN=the Patient's IEN in file #2
               ;"       TIU=PASS BY REFERENCE.  Should be an Array of TIU note info
               ;"                               See documentation in VITALS(DFN,TIU)
               ;"Results: Returns string describing change in weight.
               ;
               NEW RESULT SET RESULT="Weight "
               NEW delta
               NEW Date SET Date=$GET(TIU("EDT"))  ;"Episode date
               IF +Date'>0 DO  GOTO WTDDone
               . SET RESULT=""
               . ;"SET RESULT=RESULT_"change: ?"
               ;
               NEW ARRAY
               DO PRIORVIT(.DFN,Date,"WEIGHT",.ARRAY)
               ;
               NEW NTLast,Last
               DO GetLast2(.ARRAY,.NTLast,.Last)
               SET Last=+Last
               SET NTLast=+NTLast
               IF NTLast=0 SET RESULT="" GOTO WTDDone
               SET delta=Last-NTLast
               IF delta>0 SET RESULT=RESULT_"up "_delta_" lbs. "
               ELSE  IF delta<0 SET RESULT=RESULT_"down "_-delta_" lbs. "
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
GetLast2(ARRAY,NTLast,Last)     ;
               ;"Purpose: Returns last 2 values in array (as created by PRIORVIT)
               ;"Input: ARRAY -- PASS BY REFERENCE.  Array as created by PRIORVIT
               ;"          ARRAY(FMDate,Value)=""
               ;"          ARRAY(FMDate,Value)=""
               ;"       NTLast --PASS BY REFERENCE, an OUT PARAMETER.
               ;"                  Next-To-Last value in array list (sorted by ascending date)
               ;"       Last --  PASS BY REFERENCE, an OUT PARAMETER.
               ;"                  Last value in array list (sorted by ascending date)
               ;"Results: None
               ;
               NEW NTLastDate,LastDate
               SET LastDate=""
               SET LastDate=$order(ARRAY(""),-1)
               SET Last=$order(ARRAY(LastDate,""))
               ;
               SET NTLastDate=$order(ARRAY(LastDate),-1)
               SET NTLast=$order(ARRAY(NTLastDate,""))
               ;
               QUIT
               ;
               ;
PRIORVIT(DFN,Date,Vital,ARRAY)
               ;"Purpose: To retrieve a list of prior vital entries for a patient
               ;"         Note: entries up to *AND INCLUDING* the current day will be retrieved
               ;"Input: DFN: the IEN of the patient, in file #2 (PATIENT)
               ;"       Date: Date (in FM format) of the current event.  Entries up to
               ;"             AND INCLUDING this date will be retrieved.
               ;"       Vital: Vital to retrieve, GMRV VITAL TYPE file (#120.51)
               ;"              Must be .01 value of a valid record
               ;"              E.g. "ABDOMINAL GIRTH","BLOOD PRESSURE","HEIGHT", etc.
               ;"       ARRAY: PASS BY REFERENCE, an OUT PARAMETER. Prior values killed.  Format as below.
               ;"Output: ARRAY is filled as follows:
               ;"          ARRAY(FMDate,Value)=""
               ;"          ARRAY(FMDate,Value)=""
               ;"        Or array will be empty if no values found.
               ;"Result: None
               SET DFN=+$GET(DFN)
               IF DFN=0 GOTO GPVDone
               IF +$GET(Date)=0 GOTO GPVDone
               IF $GET(Vital)="" GOTO GPVDone
               NEW VitalTIEN
               SET VitalTIEN=+$order(^GMRD(120.51,"B",Vital,""))
               IF VitalTIEN'>0 GOTO GPVDone
               KILL ARRAY
               ;
               NEW IEN SET IEN=""
               NEW X,X1,X2,%Y
               FOR  SET IEN=$order(^GMR(120.5,"C",DFN,IEN)) QUIT:(+IEN'>0)  DO
               . NEW s SET s=$GET(^GMR(120.5,IEN,0))
               . IF +$PIECE(s,"^",3)'=VitalTIEN QUIT
               . SET X1=Date
               . SET X2=+$PIECE(s,"^",1)
               . DO ^%DTC  ;"date delta
               . IF %Y'=1 QUIT  ;"data unworkable
               . IF X>-1 SET ARRAY(+$PIECE(s,"^",1),+$PIECE(s,"^",8))=""
               ;
GPVDone QUIT
               ;
        ;"-------------------------------------------------------------
        ;"-------------------------------------------------------------
               ;
GetNotesList(DFN,List,IncDays)  ;
               ;"Purpose: Return a list of notes for patient in given time span
               ;"Input: DFN -- IEN in PATIENT file (the patient record number)
               ;"       List -- PASS BY REFERENCE, an OUT PARAMETER. (Format below)
               ;"       IncDays -- Number of DAYS to search in.
               ;"              E.g. 4 --> get notes from last 4 days
               ;"Output: List format:
               ;"              List(FMTimeOfNote,IEN8925)=""
               ;"              List(FMTimeOfNote,IEN8925)=""
               ;"              List(FMTimeOfNote,IEN8925)=""
               ;"        If no notes found, then array is left blank.  Prior entries KILLED
               ;"Results: none
               ;
               KILL List
               SET DFN=+$GET(DFN)
               IF DFN'>0 GOTO GNLDone
               SET IncDays=+$GET(IncDays)
               NEW temp,i
               MERGE temp=^TIU(8925,"C",DFN)
               SET IEN=""
               FOR  SET IEN=$order(temp(IEN)) QUIT:(IEN="")  DO
               . NEW X,X1,X2,%Y,StartDate
               . DO NOW^%DTC SET X1=X
               . SET StartDate=$PIECE($GET(^TIU(8925,IEN,0)),"^",7)
               . SET X2=StartDate
               . DO ^%DTC ;"calculate X=X1-X2.  Returns #days between
               . IF X>IncDays QUIT
               . SET List(StartDate,IEN)=""
               ;
GNLDone QUIT
               ;
               ;
IsHTML(IEN8925) ;"Depreciated  Moved to TMGHTM1
               GOTO ISHTML+1^TMGHTM1
               ;
HTML2TXT(Array)  ;"Depreciated.  Moved to TMGHTM1
               GOTO HTML2TXT+1^TMGHTM1
               ;
ExtractSpecial(IEN8925,StartMarkerS,EndMarkerS,ARRAY)   ;
               ;"Purpose: To scan the REPORT TEXT field in given document and return
               ;"         paragraph of text that is started by StartMarkerS, and ended by EndMarkerS.
               ;"         I.E. Search for a line that contains MarkerS.  Return that line and
               ;"         all following lines until line found with EndMarkerS, or
               ;"         end of text.
               ;"Input: IEN8925 -- IEN in file 8925 (TIU DOCUMENT)
               ;"       StartMarkerS -- the string to search for that indicates start of block
               ;"       EndMarkerS -- the string to search for that indicates the end of block.
               ;"              NOTE: if EndMarkerS="BLANK_LINE", then search is
               ;"              ended when a blank line is encountered.
               ;"       ARRAY -- PASS BY REFERENCE, an OUT PARAMETER.  Prior values killed.
               ;"              Format:  ARRAY(0)=MaxLineCount
               ;"                       ARRAY(1)="Text line 1"
               ;"                       ARRAY(2)="Text line 2" ...
               ;"Result: 1 if data found, otherwise 0
               ;
               NEW RESULT SET RESULT=0
               KILL ARRAY
               SET IEN8925=+$GET(IEN8925)
               IF IEN8925'>0 GOTO ESDone
               IF $data(^TIU(8925,IEN8925,"TEXT"))'>0 GOTO ESDone
               IF $GET(StartMarkerS)="" GOTO ESDone
               IF $GET(EndMarkerS)="" GOTO ESDone
               NEW ref SET ref=$NAME(^TIU(8925,IEN8925,"TEXT"))
               NEW tempARRAY
               IF $$ISHTML^TMGHTM1(IEN8925) DO
               . MERGE tempARRAY=^TIU(8925,IEN8925,"TEXT")
               . DO HTML2TXT^TMGHTM1(.tempARRAY)
               . SET ref="tempARRAY"
               NEW line,i,BlockFound,Done
               SET line=0,i=0,BlockFound=0,Done=0
               FOR  SET line=$order(@ref@(line)) QUIT:(line="")!Done  DO
               . NEW lineS SET lineS=$GET(@ref@(line,0))
               . IF (BlockFound=0) DO  QUIT  ;"don't include header line with output
               . . IF lineS[StartMarkerS SET BlockFound=1
               . IF (BlockFound=1) DO
               . . SET i=i+1,ARRAY(0)=i
               . . NEW s2 SET s2=$$Trim^TMGSTUTL(lineS," ")
               . . SET s2=$$Trim^TMGSTUTL(s2,$char(9))
               . . SET ARRAY(i)=lineS
               . . IF s2="" SET ARRAY(i)=s2
               . . SET RESULT=1
               . . IF (EndMarkerS="BLANK_LINE")&(s2="") SET BlockFound=0,Done=1 QUIT
               . . IF lineS[EndMarkerS SET BlockFound=0,Done=1 QUIT ;"include line with END marker
               ;
ESDone   QUIT RESULT
               ;
               ;
MergeInto(partARRAY,masterARRAY)        ;
               ;"Purpose: to combine partARRAY into MasterARRAY.
               ;"Input: partARRAY -- PASS BY REFERENCE
               ;"       masterARRAY -- PASS BY REFERENCE
               ;"Note:  Arrays are combine in a 'transparent' manner such that newer entries
               ;"       will overwrite older entries only for identical values.  For example:
               ;"                  -- BLOCK --   <--- MasterArray
               ;"                      TSH = 1.56
               ;"                      LDL = 140
               ;"                  -- END BLOCK --
               ;"
               ;"                  -- BLOCK --   <--- partArray
               ;"                      LDL = 150
               ;"                  -- END BLOCK --
               ;"
               ;"             The above two blocks will result in this final array
               ;"                  -- BLOCK --
               ;"                      TSH = 1.56
               ;"                      LDL = 150   <--- this value overwrote older entry
               ;"                  -- END BLOCK --
               ;"
               ;"              In this mode, only data that is in a LABEL <--> VALUE format
               ;"                 will be checked for newer vs older entries.  All other
               ;"                 lines will simply be included in one large summation block.
               ;"              And the allowed format for LABEL <--> VALUE will be:
               ;"                      Label = value      or
               ;"                      Label : value
               ;"
               ;"Output: MasterARRAY will be filled as follows:
               ;"       ARRAY("text line")=""
               ;"       ARRAY("text line")=""
               ;"       ARRAY("KEY-VALUE",KeyName)=Value
               ;"       ARRAY("KEY-VALUE",KeyName,"LINE")=original line
               ;
               NEW lineNum SET lineNum=0
               FOR  SET lineNum=$order(tempARRAY(lineNum)) QUIT:(+lineNum'>0)  DO
               . NEW line SET line=$GET(tempARRAY(lineNum))
               . IF (line["=")!(line[":") DO
               . . NEW key,shortKey,value,pivot
               . . IF line["=" SET pivot="="
               . . ELSE  SET pivot=":"
               . . SET key=$PIECE(line,pivot,1)
               . . SET shortKey=$$UP^XLFSTR($$Trim^TMGSTUTL(key))
               . . SET value=$PIECE(line,pivot,2,999)
               . . SET ARRAY("KEY-VALUE",shortKey)=value
               . . SET ARRAY("KEY-VALUE",shortKey,"LINE")=line
               . ELSE  DO
               . . IF line="" QUIT
               . . SET ARRAY(line)=""
               ;
               QUIT
               ;
               ;
GetSpecial(DFN,StartMarkerS,EndMarkerS,Months,ARRAY,Mode)       ;
               ;"Purpose: to return a block of text from notes for patient, starting with
               ;"         StartMarkerS, and ending with EndMarkerS, searching backwards
               ;"         within time period of 'Months'.
               ;"Input: DFN -- IEN of patient in PATIENT file.
               ;"       StartMarkerS -- the string to search for that indicates start of block
               ;"       EndMarkerS -- the string to search for that indicates the end of block.
               ;"              NOTE: if EndMarkerS="BLANK_LINE", then search is
               ;"              ended when a blank line is encountered.
               ;"       Months -- Number of Months to search in.
               ;"              E.g. 4 --> search in notes from last 4 months
               ;"       ARRAY -- PASS BY REFERENCE. an OUT PARAMETER.  Old values killed. Format below
               ;"       Mode: operation mode.  As follows:
               ;"              1 = return only block from most recent match
               ;"              2 = compile all.
               ;"                  In this mode, the search is carried out from oldest to most
               ;"                  recent, and newer blocks overlay older ones in a 'transparent'
               ;"                  manner such that newer entries will overwrite older entries
               ;"                  only for identical values.  For example:
               ;"                  -- BLOCK --   <--- from date 1/1/1980
               ;"                      TSH = 1.56
               ;"                      LDL = 140
               ;"                  -- END BLOCK --
               ;"
               ;"                  -- BLOCK --   <--- from date 2/1/1980
               ;"                      LDL = 150
               ;"                  -- END BLOCK --
               ;"
               ;"             The above two blocks will result in this final block
               ;"                  -- BLOCK --
               ;"                      TSH = 1.56
               ;"                      LDL = 150   <--- this value overwrote older entry
               ;"                  -- END BLOCK --
               ;"
               ;"              In this mode, only data that is in a LABEL <--> VALUE format
               ;"                 will be checked for newer vs older entries.  All other
               ;"                 lines will simply be included in one large summation block.
               ;"              And the allowed format for LABEL <--> VALUE will be:
               ;"                      Label = value      or
               ;"                      Label : value
               ;"
               ;"Output: ARRAY will be filled as follows:
               ;"       ARRAY("text line")=""
               ;"       ARRAY("text line")=""
               ;"       ARRAY("KEY-VALUE",KeyName)=Value
               ;"       ARRAY("KEY-VALUE",KeyName,"LINE")=original line
               ;"Results: none
               ;
               NEW NotesList
               KILL ARRAY
               SET DFN=+$GET(DFN)
               IF DFN'>0 GOTO GSDone
               ;
               NEW IncDays SET IncDays=+$GET(Months)*30
               DO GetNotesList(DFN,.NotesList,IncDays)
               ;
               NEW direction SET direction=1
               IF Mode=1 SET direction=-1
               NEW Done SET Done=0
               NEW StartTime SET StartTime=""
               FOR  SET StartTime=$order(NotesList(StartTime),direction) QUIT:(StartTime="")!Done  DO
               . NEW IEN8925 SET IEN8925=""
               . FOR  SET IEN8925=$order(NotesList(StartTime,IEN8925),direction) QUIT:(+IEN8925'>0)!Done  DO
               . . NEW tempARRAY
               . . IF $$ExtractSpecial(IEN8925,.StartMarkerS,.EndMarkerS,.tempARRAY)=1 DO
               . . . DO MergeInto(.tempARRAY,.ARRAY)
               . . . IF Mode=1 SET Done=1
               ;
GSDone   QUIT
               ;
               ;
ARRAY2STR(ARRAY,Spaces) ;
               ;"Purpose: to convert ARRAY (as created by GetSpecial) into one long string
               ;"Input: ARRAY.  Format as follows:
               ;"         ARRAY("text line")=""
               ;"         ARRAY("text line")=""
               ;"         ARRAY("KEY-VALUE",KeyName)=Value
               ;"         ARRAY("KEY-VALUE",KeyName,"LINE")=original line
               ;"       Spaces : OPTIONAL.  Space to put before each added line.
               NEW RESULT SET RESULT=""
               NEW keyName SET keyName=""
               SET Spaces=$GET(Spaces)
               ;
               ;"First, put in key-value lines
               FOR  SET keyName=$order(ARRAY("KEY-VALUE",keyName)) QUIT:(keyName="")  DO
               . NEW line
               . SET line=$GET(ARRAY("KEY-VALUE",keyName,"LINE"))
               . IF RESULT'="" SET RESULT=RESULT_$char(13)_$char(10)
               . SET RESULT=RESULT_Spaces_line
               KILL ARRAY("KEY-VALUE")
               ;
               ;"Next, put standard lines
               NEW line SET line=""
               FOR  SET line=$order(ARRAY(line)) QUIT:(line="")  DO
               . IF RESULT'="" SET RESULT=RESULT_$char(13)_$char(10)
               . SET RESULT=RESULT_line
               ;
               QUIT RESULT
               ;
               ;
ENSURE(ARRAY,KEY,PIVOT,VALUE)   ;
               ;"Purpose: to add one (empty) entry, if a value for this doesn't already exist.
               ;"Input: ARRAY.  Format as follows:
               ;"          ARRAY("text line")=""
               ;"          ARRAY("text line")=""
               ;"          ARRAY("KEY-VALUE",KeyName)=VALUE
               ;"          ARRAY("KEY-VALUE",KeyName,"LINE")=original line
               ;"       KEY -- the name of the study
               ;"       PIVOT -- ":", or "="  OPTIONAL.  Default = ":"
               ;"       VALUE -- the description of the needed value.  OPTIONAL.
               ;"              default value = '<no data>'
               ;
               SET PIVOT=$GET(PIVOT,":")
               SET VALUE=$GET(VALUE,"<no data>")
               IF $GET(KEY)="" GOTO AIADone
               NEW UPKEY SET UPKEY=$$UP^XLFSTR(KEY)
               IF $data(ARRAY("KEY-VALUE",UPKEY))>0 GOTO AIADone
               ;
               SET ARRAY("KEY-VALUE",UPKEY)=$GET(VALUE)
               NEW LINE SET LINE="        "_$GET(KEY)_" "_$GET(PIVOT)_" "_$GET(VALUE)
               SET ARRAY("KEY-VALUE",UPKEY,"LINE")=LINE
               ;
AIADone QUIT
               ;
               ;
