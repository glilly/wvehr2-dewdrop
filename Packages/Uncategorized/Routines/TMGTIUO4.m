TMGTIUO4        ;TMG/kst-Text objects for use in CPRS ; 7/20/12
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
        ;
        ;"=======================================================================
        ;"PRIVATE FUNCTIONS
        ;"=======================================================================
        ;"BMI(HT,WT,BMI,IDEALWTS) -- Calculate Body Mass Index
        ;"BMICOMNT(BMI,PTAGE,IDEALWTS) -- provide comment on BMI
        ;"WTTREND(DFN,TIU) -- return text showing patient's trend in change of weight.
        ;"WTDELTA(DFN,TIU) -- return text showing patient's change in weight.
        ;"GETLAST2(ARRAY,NTLAST,LAST) -- Returns last 2 values in array (as created by PRIORVIT)
        ;"PRIORVIT(DFN,DATE,VITAL,ARRAY)  -- retrieve a list of prior vital entries for a patient
        ;"GETSPECL(DFN,STARTMARKERS,ENDMARKERS,MONTHS,ARRAY,MODE,SPACES) -- return a block of text from notes for patient
        ;"ARRAY2ST(ARRAY,SPACES) -- convert ARRAY (as created by GETSPECL) into one long string
        ;"=======================================================================
        ;"Dependancies :TMGTIUO3, TMGTIUO5, XLFSTR, %DT, %DTC  
        ;"=======================================================================
        ;
BMI(HT,WT,BMI,IDEALWTS) ;
               ;"Purpose: Calculate Body Mass Index
               ;"Input: HT -- height string.  E.g. '60 in [152.4 cm] (05/08/2009 13:47)'
               ;"       WT -- weight string   E.g. '160 lb [72.7 kg] (09/21/2010 11:06)'
               ;"       BMI -- PASS BY REFERENCE, AN OUT PARAMETER.  Filled with BMI
               ;"       IDEALWTS --PASS BY REFERENCE, AN OUT PARAMETER.  Filled with 'LowNormal^HighNormal'
               ;"Output: BMI string.  E.g.  '32.5 (09/21/2010 11:06)', or '' if invalid
               NEW RESULT SET RESULT=""
               SET BMI=0,IDEALWTS=""
               IF (WT'="")&(HT'="") DO
               . NEW SWT,SHT,NWT,NHT,S1,WTDT,EWTDT,HTDT,EHTDT,BMIDT,EBMIDT,X,%DT
               . SET EWTDT=$PIECE($PIECE($PIECE(WT,"(",2),")",1)," ",1) ;"WT date string
               . SET EHTDT=$PIECE($PIECE($PIECE(HT,"(",2),")",1)," ",1) ;"HT date string
               . SET X=EWTDT DO ^%DT SET WTDT=Y  ;"to FMFormat
               . SET X=EHTDT DO ^%DT SET HTDT=Y  ;"to FMFormat
               . IF HTDT<WTDT DO
               . . SET EBMIDT=EHTDT
               . . SET BMIDT=HTDT
               . ELSE  DO
               . . SET EBMIDT=EWTDT
               . . SET BMIDT=WTDT
               . SET SWT=$$REMOVEDT^TMGTIUO3(WT)
               . SET SHT=$$REMOVEDT^TMGTIUO3(HT)
               . SET S1=$PIECE(SWT,"[",2)  ;"convert '200 lb [91.2 kg]' --> '91.2 kg]'
               . SET NWT=+$PIECE(S1," ",1) ;"convert '91.2 kg]' --> 91.2
               . SET S1=$PIECE(SHT,"[",2)  ;"convert '56 in [130 cm]' --> '130 cm]'
               . SET NHT=+$PIECE(S1," ",1) ;"convert '130 cm]' --> 130
               . SET NHT=NHT/100 QUIT:(NHT=0)  ;"convert centimeters to meters
               . NEW MSQR SET MSQR=(NHT*NHT)
               . SET BMI=+$JUSTIFY(NWT/MSQR,0,1) QUIT:BMI=0
               . NEW IDEALLB1,IDEALLB2
               . SET IDEALLB1=((18.5*MSQR)*2.2)\1
               . SET IDEALLB2=((25*MSQR)*2.2)\1
               . SET IDEALWTS=IDEALLB1_"^"_IDEALLB2
               . SET RESULT=BMI_" ("_EBMIDT_")"
               QUIT RESULT
               ;
               ;
BMICOMNT(BMI,PTAGE,IDEALWTS)    ;"BMI COMMENT
               ;"Purpose: provide comment on BMI
               ;"Input: BMI -- numberical value of BMI
               ;"       PTAGE -- AGE in years
               ;"       IDEALWTS -- lowNormalLbs^HighNormalLbs
               ;"Output: comment string
               NEW RESULT
               IF BMI<18.5 SET RESULT=" (<18.5 = ""UNDER-WT"")"
               ELSE  IF BMI<25.01 SET RESULT=" (18.5-25 = ""HEALTHY"")"
               ELSE  IF BMI<30.01 SET RESULT=" (25-30 = ""OVER-WT"")"
               ELSE  IF BMI<40.01 SET RESULT=" (30-40 = ""OBESE"")"
               ELSE  SET RESULT=" (>40 = ""VERY OBESE"")"
               IF IDEALWTS'="" DO
               . NEW IDEALLB1,IDEALLB2
               . SET IDEALLB1=$PIECE(IDEALWTS,"^",1) QUIT:IDEALLB1=0
               . SET IDEALLB2=$PIECE(IDEALWTS,"^",2) QUIT:IDEALLB2=0
               . SET RESULT=RESULT_"; (Ideal Wt="_IDEALLB1_"-"_IDEALLB2_" lbs"
               . IF (WT>IDEALLB2)&(PTAGE'<18) DO
               . . SET RESULT=RESULT_"; "_(WT-IDEALLB2)_" lbs over weight); "
               . ELSE  IF (WT<IDEALLB1)&(PTAGE'<18) DO
               . . SET RESULT=RESULT_"; "_(IDEALLB1-WT)_" lbs under weight); "
               . ELSE  DO
               . . SET RESULT=RESULT_"); "
               QUIT RESULT
               ;
WTTREND(DFN,TIU)        ;
               ;"Purpose: return text showing patient's trend in change of weight.
               ;"         e.g. 215 <== 212 <== 256 <== 278
               ;"Input: DFN=the Patient's IEN in file #2
               ;"       TIU=PASS BY REFERENCE.  Should be an Array of TIU note info
               ;"                               See documentation in VITALS^TMGTIUOJ(DFN,TIU)
               ;"Results: Returns string describing changes in weight.
               ;
               NEW RESULT SET RESULT=""
               NEW DATE SET DATE=$GET(TIU("EDT"))
               IF +DATE'>0 DO  GOTO WTTRDONE
               . SET RESULT="(No wts available)"
               ;
               NEW ARRAY
               DO PRIORVIT(.DFN,DATE,"WEIGHT",.ARRAY)
               ;
               NEW DATE SET DATE=""
               FOR  SET DATE=$ORDER(ARRAY(DATE),-1) QUIT:(+DATE'>0)  DO
               . IF RESULT'="" SET RESULT=RESULT_" <== "
               . SET RESULT=RESULT_$ORDER(ARRAY(DATE,""))
               ;
               SET RESULT="Wt trend: "_RESULT
               ;
WTTRDONE        QUIT RESULT
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
               NEW DELTA
               NEW DATE SET DATE=$GET(TIU("EDT"))  ;"Episode date
               IF +DATE'>0 DO  GOTO WTDDONE
               . IF +$GET(NONULL)=0 SET RESULT="" QUIT
               . SET RESULT=RESULT_"change: ?"
               ;
               NEW ARRAY
               DO PRIORVIT(.DFN,DATE,"WEIGHT",.ARRAY)
               ;
               NEW NTLAST,LAST
               DO GETLAST2(.ARRAY,.NTLAST,.LAST)
               SET LAST=+LAST
               SET NTLAST=+NTLAST
               IF NTLAST=0 SET RESULT="" GOTO WTDDONE
               SET DELTA=LAST-NTLAST
               IF DELTA>0 SET RESULT=RESULT_"up "_DELTA_" lbs. "
               ELSE  IF DELTA<0 SET RESULT=RESULT_"down "_-DELTA_" lbs. "
               ELSE  DO
               . IF LAST=0 SET RESULT=RESULT_"change: ?" QUIT
               . SET RESULT=RESULT_"unchanged. "
               ;
               IF (LAST>0)&(NTLAST>0) DO
               . SET RESULT=RESULT_"("_LAST_" <== "_NTLAST_" prior wt)"
               ;
WTDDONE QUIT RESULT
               ;
               ;
GETLAST2(ARRAY,NTLAST,LAST)     ;
               ;"Purpose: Returns last 2 values in array (as created by PRIORVIT)
               ;"Input: ARRAY -- PASS BY REFERENCE.  Array as created by PRIORVIT
               ;"          ARRAY(FMDATE,VALUE)=""
               ;"          ARRAY(FMDATE,VALUE)=""
               ;"       NTLAST --PASS BY REFERENCE, an OUT PARAMETER.
               ;"                  Next-To-Last value in array list (sorted by ascending date)
               ;"       LAST --  PASS BY REFERENCE, an OUT PARAMETER.
               ;"                  Last value in array list (sorted by ascending date)
               ;"Results: None
               ;
               NEW NTLASTDATE,LASTDATE
               SET LASTDATE=""
               SET LASTDATE=$ORDER(ARRAY(""),-1)
               SET LAST=$ORDER(ARRAY(LASTDATE,""))
               ;
               SET NTLASTDATE=$ORDER(ARRAY(LASTDATE),-1)
               SET NTLAST=$ORDER(ARRAY(NTLASTDATE,""))
               ;
               QUIT
               ;
               ;
PRIORVIT(DFN,DATE,VITAL,ARRAY)   ;
               ;"Purpose: To retrieve a list of prior vital entries for a patient
               ;"         Note: entries up to *AND INCLUDING* the current day will be retrieved
               ;"Input: DFN: the IEN of the patient, in file #2 (PATIENT)
               ;"       DATE: Date (in FM format) of the current event.  Entries up to
               ;"             AND INCLUDING this date will be retrieved.
               ;"       VITAL: Vital to retrieve, GMRV VITAL TYPE file (#120.51)
               ;"              Must be .01 value of a valid record
               ;"              E.g. "ABDOMINAL GIRTH","BLOOD PRESSURE","HEIGHT", etc.
               ;"       ARRAY: PASS BY REFERENCE, an OUT PARAMETER. Prior values killed.  Format as below.
               ;"Output: ARRAY is filled as follows:
               ;"          ARRAY(FMDATE,VALUE)=""
               ;"          ARRAY(FMDATE,VALUE)=""
               ;"        Or array will be empty if no values found.
               ;"Result: None
               SET DFN=+$GET(DFN)
               IF DFN=0 GOTO GPVDONE
               IF +$GET(DATE)=0 GOTO GPVDONE
               IF $GET(VITAL)="" GOTO GPVDONE
               NEW VITALTIEN
               SET VITALTIEN=+$ORDER(^GMRD(120.51,"B",VITAL,""))
               IF VITALTIEN'>0 GOTO GPVDONE
               KILL ARRAY
               ;
               NEW IEN SET IEN=""
               NEW X,X1,X2,%Y
               FOR  SET IEN=$ORDER(^GMR(120.5,"C",DFN,IEN)) QUIT:(+IEN'>0)  DO
               . NEW STR SET STR=$GET(^GMR(120.5,IEN,0))
               . IF +$PIECE(STR,"^",3)'=VITALTIEN QUIT
               . SET X1=DATE
               . SET X2=+$PIECE(STR,"^",1)
               . DO ^%DTC  ;"date delta
               . IF %Y'=1 QUIT  ;"data unworkable
               . IF X>-1 SET ARRAY(+$PIECE(STR,"^",1),+$PIECE(STR,"^",8))=""
               ;
GPVDONE QUIT
               ;
GETSPECL(DFN,STARTMARKERS,ENDMARKERS,MONTHS,ARRAY,MODE,SPACES)  ;"GET SPECIAL
               ;"Purpose: to return a block of text from notes for patient, starting with
               ;"         STARTMARKERS, and ending with ENDMARKERS, searching backwards
               ;"         within time period of 'MONTHS'.
               ;"Input: DFN -- IEN of patient in PATIENT file.
               ;"       STARTMARKERS -- the string to search for that indicates start of block
               ;"       ENDMARKERS -- the string to search for that indicates the end of block.
               ;"              NOTE: if ENDMARKERS="BLANK_LINE", then search is
               ;"              ended when a blank line is encountered.
               ;"       MONTHS -- Number of Months to search in.
               ;"              E.g. 4 --> search in notes from last 4 months
               ;"       ARRAY -- PASS BY REFERENCE. an OUT PARAMETER.  Old values killed. Format below
               ;"       MODE: operation mode.  As follows:
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
               ;"       SPACES -- OPTIONAL.  Pass by reference. AN OUT PARAMETER.
               ;"                      Fill with the space length that found tables are indented with.
               ;"
               ;"Output: ARRAY will be filled as follows:
               ;"       ARRAY("text line")=""
               ;"       ARRAY("text line")=""
               ;"       ARRAY("KEY-VALUE",KEYName)=VALUE
               ;"       ARRAY("KEY-VALUE",KEYName,"LINE")=original line
               ;"Results: none
               ;
               NEW NOTESLIST
               KILL ARRAY
               SET DFN=+$GET(DFN)
               IF DFN'>0 GOTO GSDONE
               ;
               NEW INCDAYS SET INCDAYS=+$GET(MONTHS)*30
               DO GNOTELST^TMGTIUO5(DFN,.NOTESLIST,INCDAYS)
               ;
               NEW DIRECTION SET DIRECTION=1
               IF MODE=1 SET DIRECTION=-1
               NEW DONE SET DONE=0
               NEW STARTTIME SET STARTTIME=""
               FOR  SET STARTTIME=$ORDER(NOTESLIST(STARTTIME),DIRECTION) QUIT:(STARTTIME="")!DONE  DO
               . NEW IEN8925 SET IEN8925=""
               . FOR  SET IEN8925=$ORDER(NOTESLIST(STARTTIME,IEN8925),DIRECTION) QUIT:(+IEN8925'>0)!DONE  DO
               . . NEW TEMPARRAY
               . . IF $$XTRCTSPC^TMGTIUO5(IEN8925,.STARTMARKERS,.ENDMARKERS,.TEMPARRAY,.SPACES)=1 DO
               . . . DO MERGEIN^TMGTIUO5(.TEMPARRAY,.ARRAY)
               . . . IF MODE=1 SET DONE=1
               ;
GSDONE   QUIT
               ;
               ;
ARRAY2ST(ARRAY,SPACES)  ;
               ;"Purpose: to convert ARRAY (as created by GETSPECL) into one long string
               ;"Input: ARRAY.  Format as follows:
               ;"         //kt old --> ARRAY("text line")=""
               ;"         ARRAY(Seq#)="text line"
               ;"         ARRAY(Seq#)="text line"
               ;"         ARRAY("KEY-VALUE",KEYNAME)=VALUE
               ;"         ARRAY("KEY-VALUE",KEYNAME,"LINE")=original line
               ;"       SPACES : OPTIONAL.  Space to put before each added line.
               NEW RESULT SET RESULT=""
               NEW KEYNAME SET KEYNAME=""
               SET SPACES=$GET(SPACES)
               NEW TABLESPACE SET TABLESPACE=" "  ;"//kt need to figure how to have this work differently for text vs html
               NEW SORTER
               ;
               FOR  SET KEYNAME=$ORDER(ARRAY("KEY-VALUE",KEYNAME)) QUIT:(KEYNAME="")  DO
               . NEW LINE SET LINE=$$TRIM^XLFSTR($GET(ARRAY("KEY-VALUE",KEYNAME,"LINE")))
               . IF LINE="" QUIT
               . SET SORTER($$UP^XLFSTR(LINE))=LINE
               KILL ARRAY("KEY-VALUE")
               ;"Next, put standard lines
               NEW I SET I=""
               FOR  SET I=$ORDER(ARRAY(I)) QUIT:(I="")  DO
               . NEW LINE SET LINE=$$TRIM^XLFSTR($GET(ARRAY(I))) QUIT:I=""
               . IF LINE="" QUIT
               . SET SORTER($$UP^XLFSTR(LINE))=LINE
               ;"Now put in non-caps lines in CAP'd order
               NEW LINE SET LINE=""
               FOR  SET LINE=$ORDER(SORTER(LINE)) QUIT:LINE=""  DO
               . NEW ONELINE SET ONELINE=$GET(SORTER(LINE))
               . IF ONELINE="" QUIT
               . IF RESULT'="" SET RESULT=RESULT_$CHAR(13)_$CHAR(10)
               . SET RESULT=RESULT_SPACES_TABLESPACE_ONELINE
               ;
               ;""First, put in key-value lines
               ;"FOR  SET KEYNAME=$ORDER(ARRAY("KEY-VALUE",KEYNAME)) QUIT:(KEYNAME="")  DO
               ;". NEW LINE
               ;". SET LINE=$GET(ARRAY("KEY-VALUE",KEYNAME,"LINE"))
               ;". IF RESULT'="" SET RESULT=RESULT_$CHAR(13)_$CHAR(10)
               ;". SET RESULT=RESULT_SPACES_TABLESPACE_LINE
               ;"KILL ARRAY("KEY-VALUE")
               ;"
               ;""Next, put standard lines
               ;"NEW I SET I=""
               ;"FOR  SET I=$ORDER(ARRAY(I)) QUIT:(I="")  DO
               ;". NEW LINE SET LINE=$GET(ARRAY(I)) QUIT:I=""
               ;". IF RESULT'="" SET RESULT=RESULT_$CHAR(13)_$CHAR(10)
               ;". SET RESULT=RESULT_SPACES_TABLESPACE_LINE
               ;
               QUIT RESULT
               ;
               ;
