TMGTIUO3        ;TMG/kst-Text objects for use in CPRS ; 10/24/10, 7/17/12
                ;;1.0;TMG-LIB;**1,17**;10/24/10;Build 23
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
        ;"$$AGEONDAT(DFN,REFDATE)  -- Returns age on a given date
        ;
        ;"=======================================================================
        ;"PRIVATE FUNCTIONS
        ;"=======================================================================
        ;"ADDVITAL(RESULT,STR,LABEL,CURDT,NOTEDT,FORCESHOW) -- format and add a vital set, wrapping line if needed.
        ;"ADDPCTLE(RESULT,TYPE,VALUE,PTAGE,GENDER) --add percentile of vital measurement, if possible.
        ;"FORMATVT(RESULT,STR,LABEL,CURDT,NOTEDT) -- remove redundant text in formating Vitals
        ;"DELIFOLD(LABEL,AGE,VALUE) --remove vitals that re too old to be relevent. e.g. pulse from 2 months ago.
        ;"REMOVEDT(STR,DT) --remove a date-Time string, and return in DT
        ;"$$REMOVTIM(DT) --remove the time from a date/time string
        ;"$$FORMATHT(HEIGHTSTR,PTAGE) remove centimeters from patient's height for adults
        ;"DATEDELT(REFDATE,DT) --  determine the number of days between REFDATE and DT
        ;"TMGVISDT(TIU)  Return a string for date of visit
        ;"PTAGE(DFN,NOTEDT) --return patient's AGE (in years) on date of note 
        ;"HC(DFN,HC) --  Return formated head circumference reading 
        ;"LASTHC(DFN) --Return the patient's last head circumference 
        ;"FNAME(DFN) -- Return Patient's first name
        ;"MNAME(DFN) -- Return Patient's middle name(s)
        ;"LNAME(DFN)-- Return Patient's last name
        ;"NICENAME(DFN) -- Return Patient's name format: Firstname Middlename Lastname
        ;"PHONENUM(DFN) -- return the patient's phone number
        ;"ENSURE(ARRAY,KEY,PIVOT,VALUE) --add one (empty) entry, if a value for this doesn't already exist.
        ;"=======================================================================
        ;"Dependancies : TMGGRC1, XLFSTR, ^%DT, XLFDT, TIULS, %DTC, DIQ TMGGRC2 TMGSTUT2,
        ;"=======================================================================
        ;
ADDVITAL(RESULT,STR,LABEL,CURDT,NOTEDT,FORCESHOW,PTAGE,EXCLUDEARR)      ;
               ;"Purpose: To format and add a vital set, wrapping line if needed.
               ;"Input: RESULT -- PASS BY REFERENCE .. the cumulative string
               ;"         STR -- the string value result to add
               ;"         LABEL -- the text label
               ;"              Labels used: T, BP, R, P, Wt, Ht, HC, BMI,
               ;"         CURDT -- the last DT string shown
               ;"         NOTEDT -- [optional] DT string of date of note
               ;"                        If provided, then the date of the vital sign must equal NOTEDT, or
               ;"                        "" is returned (Unless FORCESHOW=1)
               ;"         FORCESHOW -- [optional] 1: Will force a return result, if otherwise wouldn't be shown
               ;"         PTAGE -- [optional], default is 99-- age in YRS of patient
               ;"         EXCLUDEARR -- [optional].  PASS BY REFERENCE.  If a particular
               ;"              vital is too old for inclusion, then this is array is filled 
               ;"                e.g. EXCLUDEARR("T")=1
               ;"Results: none (changes are passed back in result)
               NEW TEMPS SET TEMPS=""
               DO FORMATVT(.TEMPS,.STR,.LABEL,.CURDT,.NOTEDT,.FORCESHOW,.PTAGE,.EXCLUDEARR)
               IF (TEMPS'="")&(RESULT'="") SET RESULT=RESULT_"; "
               SET RESULT=RESULT_TEMPS
               QUIT
               ;
ADDPCTLE(RESULT,TYPE,VALUE,PTAGE,GENDER)        ;
               ;"Purpose: To add percentile of vital measurement, if possible.
               ;"Input:   RESULT -- PASS BY REFERENCE .. the cumulative string
               ;"         TYPE -- the type of percentile to add: 'Ht','Wt','HC', 'WtLen'
               ;"         VALUE -- the value of the vital sign, in metric
               ;"         PTAGE -- The patients age *In Years*
               ;"         gender -- must by 'M' or 'F'
               ;"Results: none (changes are passed back in RESULT)
               SET TYPE=$GET(TYPE)
               SET VALUE=$GET(VALUE)
               NEW TEMPS SET TEMPS=""
               ;
               IF TYPE="Ht" DO
               . SET VALUE=$PIECE($PIECE(VALUE,"[",2),"]",1)
               . SET VALUE=+VALUE
               . SET TEMPS=$$LENPCTL^TMGGRC1(.PTAGE,.GENDER,VALUE)
               ELSE  IF TYPE="Wt" DO
               . SET VALUE=$PIECE($PIECE(VALUE,"[",2),"]",1)
               . SET VALUE=+VALUE
               . SET TEMPS=$$WTPCTL^TMGGRC1(.PTAGE,.GENDER,VALUE)
               ELSE  IF TYPE="BMI" DO
               . SET TEMPS=$$BMIPCTL^TMGGRC1(.PTAGE,.GENDER,VALUE)
               ELSE  IF TYPE="HC" DO
               . SET TEMPS=$$HCPCTL^TMGGRC1(.PTAGE,.GENDER,VALUE)
               ELSE  IF TYPE="WtLen" DO
               . SET TEMPS=$$WTLENPCT^TMGGRC1(.PTAGE,.GENDER,VALUE)
               ;
               ;"SET RESULT=$$ADDWRAP^TMGSTUTL(RESULT,TEMPS,60,INDENTSTR)        
               IF (TEMPS'="")&(RESULT'="") SET RESULT=RESULT_", "
               SET RESULT=RESULT_TEMPS ;                
               QUIT
               ;
               ;
FORMATVT(OUTS,STR,LABEL,CURDT,NOTEDT,FORCESHOW,PTAGE,EXCLUDEARR)        ;"Format Vitals
               ;"Purpose: To remove redundant text in formating Vitals
               ;"Input:   OUTS -- PASS BY REFERENCE .. the cumulative string
               ;"         STR -- the string value result to add
               ;"         LABEL -- the text label
               ;"              Labels used: T, BP, R, P, Wt, Ht, HC, BMI,
               ;"         CURDT -- the last DT string shown
               ;"         NOTEDT -- [optional] DT string of date of note
               ;"                        If provided, then the date of the vital sign must equal NOTEDT, or
               ;"                        "" is returned (Unless FORCESHOW=1)
               ;"         FORCESHOW -- [optional] 1: Will force a return RESULT, if otherwise wouldn't be shown
               ;"                      NOTE: this is older system.  New system excludes
               ;"                      various vitals at various cutoffs. FORCESHOW doesn't override this.
               ;"         PTAGE -- [optional], default is 99-- age in YRS of patient
               ;"         EXCLUDEARR -- [optional].  PASS BY REFERENCE.  If a particular
               ;"              vital is too old for inclusion, then this is array is filled 
               ;"                e.g. EXCLUDEARR("T")=1
               ;"Results: none (changes are passed back in RESULT)
               ;
               SET OUTS=$GET(OUTS)
               NEW RESULT SET RESULT=""
               SET PTAGE=+$GET(PTAGE,99)
               IF $GET(STR)'="" DO
               . NEW VITALDT SET VITALDT=""
               . NEW DELTA
               . SET STR=$$REMOVEDT(STR,.VITALDT)
               . SET VITALDT=$$REMOVTIM(VITALDT)
               . SET DELTA=$$DATEDELT(.NOTEDT,.VITALDT) QUIT:(DELTA<0)  ;"Returns #days
               . IF (DELTA>0)&($GET(NOTEDT)'="")&($GET(FORCESHOW)'=1) QUIT  ;"If NOTEDT specified, don't allow delta>0
               . IF (OUTS'="")&($EXTRACT(OUTS,$LENGTH(OUTS))'=$CHAR(9)) SET RESULT=RESULT_", "
               . IF CURDT'=VITALDT DO
               . . SET CURDT=VITALDT
               . . IF (DELTA>0)&(VITALDT'="") DO
               . . . IF (PTAGE>18)!(DELTA<32) DO  QUIT
               . . . . IF $$DELIFOLD(LABEL,DELTA,.STR)=0 DO  QUIT
               . . . . . SET RESULT=""
               . . . . . SET EXCLUDEARR(LABEL)=1
               . . . . SET RESULT=RESULT_"("_VITALDT_") "
               . . . ELSE  DO
               . . . . NEW AGESTR,AGEATVIT SET AGEATVIT=$$AGEONDAT(DFN,VITALDT)
               . . . . IF AGEATVIT<2 SET AGESTR=$JUSTIFY(AGEATVIT/12,0,0)_" mo"
               . . . . ELSE  SET AGESTR=$JUSTIFY(AGEATVIT,0,1)_" yr"
               . . . . SET RESULT=RESULT_"("_VITALDT_" @ "_AGESTR_") "
               . IF STR'="" SET RESULT=RESULT_LABEL_" "_STR
               SET RESULT=$$TRIM^XLFSTR(RESULT)
               SET OUTS=OUTS_RESULT
FVDONE   QUIT
               ;
               ;
DELIFOLD(LABEL,AGE,VALUE)       ;"DELETE IF OLD
               ;"Purpose: To remove vitals that re too old to be relevent. e.g. pulse from 2 months ago.
               ;"         The relevent age will depend on the type of vital measurement
               ;"Input: LABEL: the vitals label, used here as a TYPE
               ;"              Labels used: T, BP, R, P, Wt, Ht, HC, BMI,
               ;"       AGE:age of vital measurement, in DAYS
               ;"       VALUE -- PASS BY REFERENCE.  Will be set to "" if too old
               ;"Result: 1 if OK to show, 0 if too old.
               NEW CUTOFF
               SET CUTOFF("T")=2      ;"2 DAYS
               SET CUTOFF("BP")=14    ;"1 WEEK
               SET CUTOFF("R")=2      ;"2 DAYS
               SET CUTOFF("P")=2      ;"2 DAYS
               SET CUTOFF("Wt")=14    ;"2 WEEKS
               SET CUTOFF("Ht")=9999  ;"(infinite)
               SET CUTOFF("HC")=180   ;"6 MONTH
               SET CUTOFF("BMI")=9999 ;"(infinite)
               NEW RESULT SET RESULT=1
               NEW ALLOWEDAGE SET ALLOWEDAGE=$GET(CUTOFF(LABEL),9999)
               IF AGE>ALLOWEDAGE DO
               . SET VALUE=""
               . SET RESULT=0
               QUIT RESULT
               ;
REMOVEDT(STR,DT)         ;
               ;"Purpose: to remove a date-Time string, and return in DT
               ;"    i.e. turn this:
               ;"        127/56 (12/25/04 16:50)
               ;"    into these:
               ;"        '127/56'   and   '12/25/04 16:50'
               ;"Input:  STR -- a string as above
               ;"       DT -- [Optional] an OUT parameter... must PASS BY REFERENCE
               ;"RESULT: returns input string with (date-time) removed
               ;"        Date-Time is returned in DT if passed by reference.
               ;
               NEW RESULT SET RESULT=$GET(STR)
               IF RESULT="" GOTO RDTDONE
               ;
               SET RESULT=$PIECE(STR,"(",1)
               SET RESULT=$$TRIM^XLFSTR(RESULT)
               SET DT=$PIECE(STR,"(",2)
               SET DT=$PIECE(DT,")",1)
               SET DT=$$TRIM^XLFSTR(DT)
               ;
RDTDONE QUIT RESULT
               ;
               ;
REMOVTIM(DT)    ;
               ;"Purpose: to remove the time from a date/time string
               ;"Input: DT -- the date/time string, i.e. '2/24/05 16:50'
               ;"RESULT: returns just the date, i.e. '2/25/05'
               NEW RESULT SET RESULT=$PIECE(DT," ",1)
               QUIT RESULT
               ;
               ;
FORMATHT(HEIGHTSTR,PTAGE)        ;
               ;"Purpose: to remove centimeters from patient's height for adults
               ;"Input: Ht, a height string, e.g. '74 in [154 cm] (1/1/1990)'
               ;"       PTAGE, patient's age in years
               ;"Result: returns patient height, with [154 cm] removed, if age > 16
               NEW RESULT SET RESULT=$GET(HEIGHTSTR)
               IF $GET(PTAGE)'<16 DO
               . SET RESULT=$PIECE(HEIGHTSTR,"[",1)
               . IF HEIGHTSTR["(" SET RESULT=RESULT_"("_$PIECE(HEIGHTSTR,"(",2,99)
               QUIT RESULT
               ;
               ;
DATEDELT(REFDATE,DT)    ;
               ;"Purpose: To determine the number of days between REFDATE and DT 
               ;"                i.e. How many days DT was before REFDATE.
               ;"Input:REFDATE -- a reference/baseline date/time string
               ;"                if not supplied, Current date/time used as default.
               ;"        DT -- a date/time string (i.e. '12/25/04 16:50')
               ;"Result: Return number of days between DT and REFDATE
               ;"        Positive numbers used when DT occured before current date
               ;"        i.e. RESULT=REFDATE-DT
               NEW INTREFDATE,INTDT  ;internal format of dates
               NEW RESULT SET RESULT=0
               SET X=DT DO ^%DT SET INTDT=Y         ;"Convert date into internal
               IF $GET(REFDATE)="" SET INTREFDATE=$$DT^XLFDT
               ELSE  SET X=REFDATE DO ^%DT SET INTREFDATE=Y   ;"Convert date into internal
               SET RESULT=$$FMDIFF^XLFDT(INTREFDATE,INTDT)
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
VDDONE   QUIT RESULT
               ;
               ;
AGEONDAT(DFN,REFDATE)   ;
               ;"Purpose: return patient age on given date, in years
               ;"Input: DFN -- Patient's IEN
               ;"       REFDATE -- Date of reference, in FMDATE, or external form.
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
PTAGE(DFN,NOTEDT)       ;
               ;"Purpose: return patient's AGE (in years) on date of note (or current
               ;"         date if date of note is empty)
               ;"Input: DFN -- Patient IEN
               ;"       NOTEDT -- Date of Note
               ;"Output: results in years.
               NEW PTAGE SET PTAGE=$$AGEONDAT(DFN,NOTEDT)
               IF PTAGE=0 DO
               . IF NOTEDT="" DO
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
               . . IF %Y=0 QUIT  ;"dates are unworkable
               . . SET PTAGE=$JUSTIFY(X/365,0,4)
               QUIT PTAGE
               ;
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
               ;"Results: FMDATE^VALUE(in)^VALUE(cm) or "" if invalid
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
               . NEW METRICVAL SET METRICVAL=$$CVTMETRC^TMGGRC2C("CG",VALUE)
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
               SET NAME=$$CAPWORDS^TMGSTUT2(NAME)
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
               SET NAME=$$CAPWORDS^TMGSTUT2(NAME)
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
               SET NAME=$$CAPWORDS^TMGSTUT2(NAME)
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
               SET NAME=$$CAPWORDS^TMGSTUT2(NAME)
               QUIT NAME
               ;
               ;
PHONENUM(DFN)   ;
               ;"Purpose: to return the patient's phone number
               ;"Input: DFN -- the patient's unique ID (record#)
               ;"Output: returns RESULT
               NEW RESULT SET RESULT=""
               SET DFN=+$GET(DFN)
               IF DFN=0 GOTO PNDONE
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
PNDONE   QUIT RESULT
               ;
               ;
        ;"-------------------------------------------------------------
        ;"-------------------------------------------------------------
ENSURE(ARRAY,KEY,PIVOT,VALUE)   ;
               ;"Purpose: to add one (empty) entry, if a value for this doesn't already exist.
               ;"Input: ARRAY.  Format as follows:
               ;"          ARRAY("text line")=""
               ;"          ARRAY("text line")=""
               ;"          ARRAY("KEY-VALUE",KEYNAME)=VALUE
               ;"          ARRAY("KEY-VALUE",KEYNAME,"LINE")=original line
               ;"       KEY -- the name of the study
               ;"       PIVOT -- ":", or "="  OPTIONAL.  Default = ":"
               ;"       VALUE -- the description of the needed value.  OPTIONAL.
               ;"              default value = '<no data>'
               ;
               SET PIVOT=$GET(PIVOT,":")
               SET VALUE=$GET(VALUE,"<no data>")
               IF $GET(KEY)="" GOTO AIADONE
               NEW UPKEY SET UPKEY=$$UP^XLFSTR(KEY)
               IF $DATA(ARRAY("KEY-VALUE",UPKEY))>0 GOTO AIADONE
               ;
               SET ARRAY("KEY-VALUE",UPKEY)=$GET(VALUE)
               NEW LINE SET LINE="        "_$GET(KEY)_" "_$GET(PIVOT)_" "_$GET(VALUE)
               SET ARRAY("KEY-VALUE",UPKEY,"LINE")=LINE
               ;
AIADONE QUIT
               ;
               ;
