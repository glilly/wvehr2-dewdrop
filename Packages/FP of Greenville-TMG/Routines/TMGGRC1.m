TMGGRC1        ;TMG/kst-Work with Growth Chart Data ;10/5/10 ; 5/31/11 
                ;;1.0;TMG-LIB;**1,17**;10/5/10;Build 23
               ;
               ;"Code for working with pediatric growth chart data.
               ;"NOTE: Data is stored in custom file 22713
               ;"      TMGGRC0 can load in this data
               ;"
               ;"Kevin Toppenberg MD
               ;"(C) 10/5/10
               ;"Released under: GNU General Public License (GPL)
               ;
               ;"=======================================================================
               ;" RPC -- Public Functions.
               ;"=======================================================================
               ;"LENPCTL(AGEYR,GENDER,LEN,NONULL)    -- Return percentile of length FOR age 
               ;"HCPCTL(AGEYR,GENDER,HC,NONULL)      -- Return percentile of head circumference for age 
               ;"WTPCTL(AGEYR,GENDER,WT,NONULL)      -- Return percentile of weight for age
               ;"BMIPCTL(AGEYR,GENDER,BMI,NONULL)    -- Return percentile of BMI FOR age
               ;"WTLENPCT(AGEYR,GENDER,WT,LEN,NONULL) - Return percentile of WT, LEN combo
               ;"WHHAPCTL(AGEYR,GENDER,LEN,NONULL)   -- Return percentile of WHO height FOR age 
               ;"WHHCPCTL(AGEYR,GENDER,HC,NONULL)    -- Return percentile of WHO head circumference for age 
               ;"WHWAPCTL(AGEYR,GENDER,WT,NONULL)    -- Return percentile of WHO weight for age
               ;"WHBAPCTL(AGEYR,GENDER,BMI,NONULL)   -- Return percentile of WHO BMI FOR age
               ;"WHOWLPCT(AGEYR,GENDER,WT,LEN,NONULL)-- Return percentile of WHO WT, LEN combo
               ;"WHWSPCTL(AGEYR,GENDER,WT,LEN,NONULL)-- Return percentile of WHO WT,Stature combo
               ;"--- 
               ;"LENREF(MODE,GENDER,ARRAY,RLINES)    -- Return array with data for %tile curves
               ;"HCREF(MODE,GENDER,ARRAY,RLINES)     -- Return array with data for %tile curves
               ;"WTREF(MODE,GENDER,ARRAY,RLINES)     -- Return array with data for %tile curves
               ;"BMIREF(MODE,GENDER,ARRAY,RLINES)    -- Return array with data for %tile curves
               ;"WTLENREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHBMIREF(MODE,GENDER,ARRAY,RLINES) -- Return array with data for %tile curves
               ;"WHHAREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHWAREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHHCREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHWLREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHWSREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"=======================================================================
               ;"PRIVATE API FUNCTIONS
               ;"=======================================================================
               ;"COMMON(GRAPH,YVAL,XVAL,GENDER,NONULL) -- common lookup for all graphs
               ;"COMMNREF(MODE,GENDER,GRAPH,ARRAY,RLINES) -- Return array filled with data for percentile curves
               ;"=======================================================================
               ;"DEPENDENCIES: TMGGRC1, TMGGRC0, TMGGRCU, XLFSTR, DIC 
               ;"=======================================================================
               ;
LENPCTL(AGEYR,GENDER,LEN,NONULL)               ;
               ;"Purpose: Return percentile of length for age 
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       LEN: stature or recumbent length in *Cm*
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               NEW GRAPH,RESULT
               IF (+$GET(AGEYR)*12)<24 SET GRAPH="LENGTH BY AGE -- INFANT"
               ELSE  SET GRAPH="STATURE BY AGE"
               NEW MONTHS SET MONTHS=+$GET(AGEYR)*12
               SET RESULT=$$COMMON(GRAPH,.LEN,.MONTHS,.GENDER,.NONULL) ;
               QUIT RESULT
               ;        
HCPCTL(AGEYR,GENDER,HC,NONULL)         ;
               ;"Purpose: Return percentile of head circumference for age 
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       HC: Head circumference in *Cm*
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               NEW MONTHS SET MONTHS=+$GET(AGEYR)*12
               NEW RESULT
               SET RESULT=$$COMMON("HEAD CIRC BY AGE -- INFANT",.HC,.MONTHS,.GENDER,.NONULL) ;
               QUIT RESULT
               ;
WTPCTL(AGEYR,GENDER,WT,NONULL)         ;
               ;"Purpose: Return percentile of weight for age
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       WT: weight in *Kg* 
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               NEW GRAPH,RESULT
               IF (+$GET(AGEYR)*12)<24 SET GRAPH="WEIGHT BY AGE -- INFANT"
               ELSE  SET GRAPH="WEIGHT BY AGE"
               NEW MONTHS SET MONTHS=+$GET(AGEYR)*12
               SET RESULT=$$COMMON(GRAPH,.WT,.MONTHS,.GENDER,.NONULL) ;
               QUIT RESULT
               ;
BMIPCTL(AGEYR,GENDER,BMI,NONULL)               ;
               ;"Purpose: Return percentile of BMI FOR age
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       BMI: weight in Kg/M**2 
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               NEW MONTHS SET MONTHS=+$GET(AGEYR)*12
               NEW RESULT
        IF MONTHS<24 SET MONTHS=24 ;"CATCH VALUES BELOW 24 (e.g. 23.998)
               SET RESULT=$$COMMON("BMI BY AGE",.BMI,.MONTHS,.GENDER,.NONULL) ;
               QUIT RESULT
               ;
WTLENPCT(AGEYR,GENDER,WT,LEN,NONULL)           ;
               ;"Purpose: Return percentile of WT, LEN combo
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       WT: weight in Kg
               ;"       LEN: stature or recumbent length in *Cm*
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               NEW GRAPH,RESULT
               IF ((+$GET(AGEYR)*12)<12)!(LEN<77)  DO
               . SET GRAPH="WEIGHT FOR LENGTH -- INFANT"
               ELSE  DO
               . SET GRAPH="WEIGHT FOR STATURE"
               SET RESULT=$$COMMON(GRAPH,.WT,.LEN,.GENDER,.NONULL) ;
               QUIT RESULT
               ;        
WHHAPCTL(AGEYR,GENDER,LEN,NONULL)                ;
               ;"Purpose: Return percentile of WHO length for age 
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       LEN: stature or recumbent length in *Cm*
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               NEW RESULT
               NEW MONTHS SET MONTHS=+$GET(AGEYR)*12
               SET RESULT=$$COMMON("WHO-HEIGHT BY AGE",.LEN,.MONTHS,.GENDER,.NONULL) ;
               QUIT RESULT
               ;        
WHHCPCTL(AGEYR,GENDER,HC,NONULL)                 ;
               ;"Purpose: Return percentile of WHO head circumference for age 
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       HC: Head circumference in *Cm*
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               NEW MONTHS SET MONTHS=+$GET(AGEYR)*12
               NEW RESULT
               SET RESULT=$$COMMON("WHO-HEAD CIRC BY AGE",.HC,.MONTHS,.GENDER,.NONULL) ;
               QUIT RESULT
               ;
WHWAPCTL(AGEYR,GENDER,WT,NONULL)                 ;
               ;"Purpose: Return percentile of WHO weight for age
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       WT: weight in *Kg* 
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               NEW RESULT
               NEW MONTHS SET MONTHS=+$GET(AGEYR)*12
               SET RESULT=$$COMMON("WHO-WEIGHT BY AGE",.WT,.MONTHS,.GENDER,.NONULL) ;
               QUIT RESULT
               ;
WHBAPCTL(AGEYR,GENDER,BMI,NONULL)        ;
               ;"Purpose: Return percentile of WHO BMI FOR age
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       BMI: weight in Kg/M**2 
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               NEW MONTHS SET MONTHS=+$GET(AGEYR)*12
               NEW RESULT
               SET RESULT=$$COMMON("WHO-BMI BY AGE",.BMI,.MONTHS,.GENDER,.NONULL) ;
               QUIT RESULT
               ;
WHWLPCTL(AGEYR,GENDER,WT,LEN,NONULL)            ;
               ;"Purpose: Return percentile of WHO WT, LEN combo
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       WT: weight in Kg
               ;"       LEN: stature or recumbent length in *Cm*
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               NEW RESULT
               SET RESULT=$$COMMON("WHO-WEIGHT FOR LENGTH",.WT,.LEN,.GENDER,.NONULL) ;
               QUIT RESULT
               ;
WHWSPCTL(AGEYR,GENDER,WT,LEN,NONULL)            ;
               ;"Purpose: Return percentile of WHO WT, STATURE combo
               ;"Input: AGEYR: age in *Years*
               ;"       GENDER: should be M or F
               ;"       WT: weight in Kg
               ;"       LEN: stature or recumbent length in *Cm*
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               NEW RESULT
               SET RESULT=$$COMMON("WHO-WEIGHT FOR STATURE",.WT,.LEN,.GENDER,.NONULL) ;
               QUIT RESULT
               ;
COMMON(GRAPH,YVAL,XVAL,GENDER,NONULL)          ;
               ;"Purpose: common lookup for all graphs
               ;"Input: GRAPH -- The name of the graph to lookup.
               ;"       YVAL -- the value to lookup on the graph
               ;"       XVAL: Will be: Months or Length
               ;"       GENDER: should be M or F
               ;"       NONNULL: OPTIONAL, default=0.  If 1 then 'N/A' is returned instead of ''
               ;"Results: e.g. 54th %tile, or "" IF invalid.  If NONNULL=1, then return 'N/A'
               ;
               NEW DIC,X,Y,L,M,S
               SET NONULL=$GET(NONULL)
               NEW RESULT SET RESULT=$SELECT(+NONULL'=0:"N/A",1:"")  ;"default
               IF +$GET(XVAL)=0 GOTO COMQT
               SET GENDER=$EXTRACT($$UP^XLFSTR(GENDER),1)
               IF (GENDER'="M")&(GENDER'="F") GOTO COMQT
               SET YVAL=+$GET(YVAL) IF YVAL=0 GOTO COMQT
               SET DIC=22713,DIC(0)="M",X=$GET(GRAPH)
               DO ^DIC
               IF +Y'>0 GOTO COMQT
               ;"IF GRAPH="WHO-WEIGHT FOR LENGTH" SET XVAL=XVAL\1    ;"ELH TEST
               IF +$$GETLMS^TMGGRCU(Y,XVAL,GENDER,.L,.M,.S)<0 GOTO COMQT
               NEW Z SET Z=$$LMS2Z^TMGGRCU(YVAL,L,M,S)
               NEW W SET W=$$Z2PCTL^TMGGRCU(Z)\1
               IF W=-1 SET RESULT="Invalid value" GOTO COMQT
               SET RESULT=$$SETSUFIX^TMGGRCU(W)
               ;
COMQT     QUIT RESULT
               ;
LENREF(MODE,GENDER,ARRAY,RLINES)                ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: MODE -- 1 if for age range 0-36 months, 2 if age 2-20 yrs
               ;"       GENDER -- M OR F
               ;"       ARRAY -- PASS BY REFERENCE.  AN OUT PARAMETER.  PRIOR VALUES KILLED. 
               ;"           ARRAY(%tile,Age)=x^y
               ;"       RLINES -- OPTIONAL.  Default='5,10,25,50,75,95' Listing of which lines to get 
               ;"Result: none
               NEW GRAPH
               IF +$GET(MODE)=1 SET GRAPH="LENGTH BY AGE -- INFANT"
               ELSE  SET GRAPH="STATURE BY AGE"
               DO COMMNREF(MODE,GENDER,GRAPH,.ARRAY,.RLINES) ;
               QUIT
               ;        
HCREF(MODE,GENDER,ARRAY,RLINES)        ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for LENREF (see above)
               DO COMMNREF(MODE,GENDER,"HEAD CIRC BY AGE -- INFANT",.ARRAY) ;
               QUIT
               ;
WTREF(MODE,GENDER,ARRAY,RLINES)        ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for LENREF (see above)
               NEW GRAPH
               IF +$GET(MODE)=1 SET GRAPH="WEIGHT BY AGE -- INFANT"
               ELSE  SET GRAPH="WEIGHT BY AGE"
               DO COMMNREF(MODE,GENDER,GRAPH,.ARRAY,.RLINES) ;
               QUIT
               ;
BMIREF(MODE,GENDER,ARRAY,RLINES)               ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for LENREF (see above)
               DO COMMNREF(MODE,GENDER,"BMI BY AGE",.ARRAY,.RLINES) ;
               QUIT
               ;
WTLENREF(MODE,GENDER,ARRAY,RLINES)             ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: MODE -- 1 if for age range 0-36 months, 2 if age 2-20 yrs
               ;"       GENDER -- M OR F
               ;"       ARRAY -- PASS BY REFERENCE.  AN OUT PARAMETER.  PRIOR VALUES KILLED. 
               ;"           ARRAY(%tile,x)=x^y  ;x=LengthOrStature
               ;"       RLINES -- OPTIONAL.  Default='5,10,25,50,75,95' Listing of which lines to get 
               NEW GRAPH
               IF +$GET(MODE)=1 SET GRAPH="WEIGHT FOR LENGTH -- INFANT"
               ELSE  SET GRAPH="WEIGHT FOR STATURE"
               DO COMMNREF(MODE,GENDER,GRAPH,.ARRAY,.RLINES) ;
               QUIT
               ;
WHBMIREF(MODE,GENDER,ARRAY,RLINES)              ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: MODE -- 1 if for age range 0-36 months, 2 if age 2-20 yrs, 3 if age range 0-60 months 
               DO COMMNREF(MODE,GENDER,"WHO-BMI BY AGE",.ARRAY,.RLINES) ;
               QUIT
               ;
WHHAREF(MODE,GENDER,ARRAY,RLINES)                ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMNREF(MODE,GENDER,"WHO-HEIGHT BY AGE ",.ARRAY,.RLINES) ;
               QUIT
               ;
WHWAREF(MODE,GENDER,ARRAY,RLINES)                ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMNREF(MODE,GENDER,"WHO-WEIGHT BY AGE",.ARRAY,.RLINES) ;
               QUIT
               ;
WHHCREF(MODE,GENDER,ARRAY,RLINES)                ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMNREF(MODE,GENDER,"WHO-HEAD CIRC BY AGE",.ARRAY,.RLINES) ;
               QUIT
               ;
WHWLREF(MODE,GENDER,ARRAY,RLINES)                ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMNREF(MODE,GENDER,"WHO-WEIGHT FOR LENGTH",.ARRAY,.RLINES) ;
               QUIT
               ;
WHWSREF(MODE,GENDER,ARRAY,RLINES)                ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMNREF(MODE,GENDER,"WHO-WEIGHT FOR STATURE",.ARRAY,.RLINES) ;
               QUIT
               ;
COMMNREF(MODE,GENDER,GRAPH,ARRAY,RLINES)               ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: MODE -- 1 if for age range 0-36 months, 2 if age 2-20 yrs, 3 if age range 0-60 months 
               ;"        4 age range 0-24 months, 5 age range 24-60 months, 6 age range 0-6 months, 
               ;"        7 age range 6-24 months, 8 age range 0-13 months 
               ;"       GENDER -- M OR F
               ;"       GRAPH -- Name of graph
               ;"       ARRAY -- PASS BY REFERENCE.  AN OUT PARAMETER.  PRIOR VALUES KILLED. 
               ;"           ARRAY(%tile,x)=x^y
               ;"       RLINES -- OPTIONAL.  Default='5,10,25,50,75,95' Listing of which %tile lines to get 
               ;"Result: none
               NEW DIC,X,Y,L,M,S
               KILL ARRAY
               SET GENDER=$EXTRACT($$UP^XLFSTR(GENDER),1)
               IF (GENDER'="M")&(GENDER'="F") GOTO CMRFQT
               SET DIC=22713,DIC(0)="M",X=$GET(GRAPH)
               DO ^DIC
               IF +Y'>0 GOTO CMRFQT
               NEW IEN SET IEN=+Y
               NEW X0,XINC,XMAX
               IF (GRAPH="WEIGHT FOR LENGTH -- INFANT") DO
               . SET X0=80,XINC=5,XMAX=140  ;"X axis here is LENGTH, and Y = Weight
               . ;"SET X0=45,XINC=10,XMAX=105  ;"X axis here is LENGTH, and Y = Weight
               ELSE  IF (GRAPH="WEIGHT FOR STATURE") DO
               . SET X0=75,XINC=5,XMAX=125  ;"X axis here is STATURE, and Y = Weight
               ELSE  IF (GRAPH="WHO-WEIGHT FOR LENGTH") DO
               . SET X0=65,XINC=5,XMAX=130
               ELSE  DO
               . IF MODE=1 SET X0=0,XINC=1,XMAX=36
               . ELSE  IF MODE=2 SET X0=24,XINC=12,XMAX=240
               . ELSE  IF MODE=3 SET X0=0,XINC=2,XMAX=60
               . ELSE  IF MODE=4 SET X0=0,XINC=1,XMAX=24
               . ELSE  IF MODE=5 SET X0=24,XINC=2,XMAX=60
               . ELSE  IF MODE=6 SET X0=0,XINC=1,XMAX=6
               . ELSE  IF MODE=7 SET X0=6,XINC=2,XMAX=24
               . ELSE  SET X0=0,XINC=1,XMAX=3
               SET RLINES=$GET(RLINES,"5,10,25,50,75,95")
               SET X=X0
               NEW ZARRAY,Z
               NEW ABORT SET ABORT=0
               FOR  DO  SET X=X+XINC QUIT:(X>XMAX)!ABORT
               . IF +$$GETLMS^TMGGRCU(IEN,X,GENDER,.L,.M,.S)<0 SET ABORT=1 QUIT
               . NEW P,PCTLNUM
               . FOR PCTLNUM=1:1:$LENGTH(RLINES,",")  DO
               . . SET P=+$PIECE(RLINES,",",PCTLNUM) QUIT:(P'>0)
               . . IF $GET(ZARRAY(P))="" SET ZARRAY(P)=$$PCTL2Z^TMGGRCU(P)
               . . SET Z=ZARRAY(P)
               . . NEW VAL SET VAL=$$LMSZ2Y^TMGGRCU(L,M,S,Z)
               . . SET VAL=+$JUSTIFY(VAL,0,2)
               . . SET ARRAY(P,X)=X_"^"_VAL
               ;
CMRFQT   QUIT
