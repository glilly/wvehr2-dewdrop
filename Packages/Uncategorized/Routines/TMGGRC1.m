TMGGRC1        ;TMG/kst-Work with Growth Chart Data ;10/5/10 ; 5/31/11
                ;;1.0;TMG-LIB;**1**;10/5/10;Build 27
               ;
               ;"Code FOR working with pediatric growth chart data.
               ;"NOTE: Data is stored in custom file 22713
               ;"      TMGFIX3 loaded in this data
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
               ;"WHOHAPCTL(AGEYR,GENDER,LEN,NONULL)  -- Return percentile of WHO height FOR age
               ;"WHOHCPCTL(AGEYR,GENDER,HC,NONULL)   -- Return percentile of WHO head circumference for age
               ;"WHOWAPCTL(AGEYR,GENDER,WT,NONULL)   -- Return percentile of WHO weight for age
               ;"WHOBAPCTL(AGEYR,GENDER,BMI,NONULL)  -- Return percentile of WHO BMI FOR age
               ;"WHOWLPCT(AGEYR,GENDER,WT,LEN,NONULL) - Return percentile of WHO WT, LEN combo
               ;"WHOWSPCTL(AGEYR,GENDER,WT,LEN,NONULL) - Return percentile of WHO WT,Stature combo
               ;"---
               ;"LENREF(MODE,GENDER,ARRAY,RLINES)    -- Return array with data for %tile curves
               ;"HCREF(MODE,GENDER,ARRAY,RLINES)     -- Return array with data for %tile curves
               ;"WTREF(MODE,GENDER,ARRAY,RLINES)     -- Return array with data for %tile curves
               ;"BMIREF(MODE,GENDER,ARRAY,RLINES)    -- Return array with data for %tile curves
               ;"WTLENREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHOBMIREF(MODE,GENDER,ARRAY,RLINES) -- Return array with data for %tile curves
               ;"WHOHAREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHOWAREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHOHCREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHOWLREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"WHOWSREF(MODE,GENDER,ARRAY,RLINES)  -- Return array with data for %tile curves
               ;"=======================================================================
               ;"PRIVATE API FUNCTIONS
               ;"=======================================================================
               ;"COMMON(GRAPH,YVAL,XVAL,GENDER,NONULL) -- common lookup for all graphs
               ;"GETLMS(CHART,MONTHS,GENDER,L,M,S) --return the LMS values for a given chart
               ;"LMS2Z(X,L,M,S) --convert Input value X, and L,M,S SET  into a Z score
               ;"LMSZ2Y(L,M,S,Z) --convert a LMS pair + Z score into a value (e.g. weight for Z=-1.645)
               ;"LMSP2Y(L,M,S,P) --convert  LMS pair + %tile --> value (e.g. weight for 5th %tile)
               ;"Z2PCTL(Z)-- Convert a Z score into a Percentile
               ;"PCTL2Z(P) -- Convert a percentile to an approximated Z-score
               ;"SETSUFFIX(NUM) --Return a suffix, e.g. 1-->'st %tile', 2--> '2nd %tile' etc.
               ;"
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
WHOHAPCTL(AGEYR,GENDER,LEN,NONULL)               ;
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
WHOHCPCTL(AGEYR,GENDER,HC,NONULL)                ;
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
WHOWAPCTL(AGEYR,GENDER,WT,NONULL)                ;
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
WHOBAPCTL(AGEYR,GENDER,BMI,NONULL)       ;
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
WHOWLPCTL(AGEYR,GENDER,WT,LEN,NONULL)           ;
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
WHOWSPCTL(AGEYR,GENDER,WT,LEN,NONULL)           ;
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
               IF +$$GETLMS(Y,XVAL,GENDER,.L,.M,.S)<0 GOTO COMQT
               NEW Z SET Z=$$LMS2Z(YVAL,L,M,S)
               NEW W SET W=$$Z2PCTL(Z)\1
               IF W=-1 SET RESULT="Invalid value" GOTO COMQT
                  SET RESULT=$$SETSUFFIX(W)
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
               DO COMMONREF(MODE,GENDER,GRAPH,.ARRAY,.RLINES) ;
               QUIT
               ;
HCREF(MODE,GENDER,ARRAY,RLINES)        ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for LENREF (see above)
               DO COMMONREF(MODE,GENDER,"HEAD CIRC BY AGE -- INFANT",.ARRAY) ;
               QUIT
               ;
WTREF(MODE,GENDER,ARRAY,RLINES)        ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for LENREF (see above)
               NEW GRAPH
               IF +$GET(MODE)=1 SET GRAPH="WEIGHT BY AGE -- INFANT"
               ELSE  SET GRAPH="WEIGHT BY AGE"
               DO COMMONREF(MODE,GENDER,GRAPH,.ARRAY,.RLINES) ;
               QUIT
               ;
BMIREF(MODE,GENDER,ARRAY,RLINES)               ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for LENREF (see above)
               DO COMMONREF(MODE,GENDER,"BMI BY AGE",.ARRAY,.RLINES) ;
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
               DO COMMONREF(MODE,GENDER,GRAPH,.ARRAY,.RLINES) ;
               QUIT
               ;
WHOBMIREF(MODE,GENDER,ARRAY,RLINES)             ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: MODE -- 1 if for age range 0-36 months, 2 if age 2-20 yrs, 3 if age range 0-60 months
               DO COMMONREF(MODE,GENDER,"WHO-BMI BY AGE",.ARRAY,.RLINES) ;
               QUIT
               ;
WHOHAREF(MODE,GENDER,ARRAY,RLINES)               ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMONREF(MODE,GENDER,"WHO-HEIGHT BY AGE ",.ARRAY,.RLINES) ;
               QUIT
               ;
WHOWAREF(MODE,GENDER,ARRAY,RLINES)               ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMONREF(MODE,GENDER,"WHO-WEIGHT BY AGE",.ARRAY,.RLINES) ;
               QUIT
               ;
WHOHCREF(MODE,GENDER,ARRAY,RLINES)               ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMONREF(MODE,GENDER,"WHO-HEAD CIRC BY AGE",.ARRAY,.RLINES) ;
               QUIT
               ;
WHOWLREF(MODE,GENDER,ARRAY,RLINES)               ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMONREF(MODE,GENDER,"WHO-WEIGHT FOR LENGTH",.ARRAY,.RLINES) ;
               QUIT
               ;
WHOWSREF(MODE,GENDER,ARRAY,RLINES)               ;
               ;"Purpose: Return array filled with data for percentile curves
               ;"Input: Same as for WHOBMIREF (see above)
               DO COMMONREF(MODE,GENDER,"WHO-WEIGHT FOR STATURE",.ARRAY,.RLINES) ;
               QUIT
               ;
COMMONREF(MODE,GENDER,GRAPH,ARRAY,RLINES)              ;
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
               . IF +$$GETLMS(IEN,X,GENDER,.L,.M,.S)<0 SET ABORT=1 QUIT
               . NEW P,PCTLNUM
               . FOR PCTLNUM=1:1:$LENGTH(RLINES,",")  DO
               . . SET P=+$PIECE(RLINES,",",PCTLNUM) QUIT:(P'>0)
               . . IF $GET(ZARRAY(P))="" SET ZARRAY(P)=$$PCTL2Z(P)
               . . SET Z=ZARRAY(P)
               . . NEW VAL SET VAL=$$LMSZ2Y(L,M,S,Z)
               . . SET VAL=+$JUSTIFY(VAL,0,2)
               . . SET ARRAY(P,X)=X_"^"_VAL
               ;
CMRFQT          QUIT
               ;
               ;"====================================================================
               ;"====================================================================
GETLMS(CHART,MONTHS,GENDER,L,M,S)              ;
               ;"Purpose: return the LMS values for a given chart
               ;"Input: CHART --Name of the chart to reference, OR, IEN^Name of chart to use.
               ;"       MONTHS -- The age to use for lookup in the chart
               ;"       GENDER -- MUST be "M" or "F" FOR male or female
               ;"       L, M, S -- PASS BY REFERENCE, OUT Parameters.  Prior values killed
               ;"Results: 1 IF successful, -1^Message IF error (Message is optional)
               ;"Output:  L,M,S are filled with data IF valid
               NEW RESULT SET RESULT=0
               NEW IEN SET IEN=+$GET(CHART)
               IF IEN'>0 DO
               . NEW DIC,X,Y
               . SET DIC=22713,DIC(0)="M"
               . SET X=$GET(CHART)
               . DO ^DIC
               . SET IEN=+Y
               IF IEN'>0 DO  GOTO GLMSDN
               . SET RESULT="-1^Unable to find chart: '"_$GET(CHART)_"'"
               SET GENDER=$GET(GENDER)
               IF (GENDER'="M")&(GENDER'="F") DO  GOTO GLMSDN
               . SET RESULT="-1^Invalid GENDER. Should be 'M' or 'F'.  Got: '"_GENDER_"'"
               SET MONTHS=$GET(MONTHS)
               IF +MONTHS'=MONTHS DO  GOTO GLMSDN
               . SET RESULT="-1^Invalid AGE.  Should be numeric value.  Got: '"_MONTHS_"'"
               KILL L,M,S
               NEW MO1,MO2
               IF (CHART="13")!(CHART["13^WHO") DO  ;"WHO-WEIGHT FOR LENGTH
               . NEW N SET N=$JUSTIFY(MONTHS,0,1)
               . NEW D SET D=$PIECE(N,".",2)
               . SET N=$PIECE(N,".",1)
               . IF D'<0.5 DO
               . . SET MO1=N_".5"
               . . SET MO2=MONTHS\1+1
               . ELSE  DO
               . . SET MO1=MONTHS\1
               . . SET MO2=MO1+0.5
               ELSE  DO
               . SET MO1=(MONTHS\1)-.01
               . IF MO1<0 DO
               . . SET MO1=0
               . . SET MO2=0.99
               . ELSE  SET MO2=MO1+1
               ;
               IF MO1=23.99 DO
               . IF (CHART="1")!(CHART="5")!(CHART="4")!(CHART["1^BMI")!(CHART["5^WEIGHT")!(CHART["4^STATURE") SET MO1=24
               NEW L1,L2,M1,M2,S1,S2
               ;
               IF $$GEXCTLMS(IEN,MO1,GENDER,.L1,.M1,.S1)=0 DO  GOTO GLMSDN
               . SET RESULT="-1^Unable to find LMS data for lower end of age range."
               IF $$GEXCTLMS(IEN,MO2,GENDER,.L2,.M2,.S2)=0 DO  GOTO GLMSDN
               . SET RESULT="-1^Unable to find LMS data for upper end of age range."
               ;
               DO INTRPLMS(MONTHS,MO1,MO2,L1,M1,S1,L2,M2,S2,.L,.M,.S)
               ;
               ;"Get correct Age interval
               ;"IF $DATA(^TMG(22713,IEN,"D","B",MONTHS))=0 DO  GOTO:(+RESULT=-1) GLMSDN
               ;". NEW MONTHS2 SET MONTHS2=$ORDER(^TMG(22713,IEN,"D","B",MONTHS))  ;"convert e.g. 31.2 --> 31.99
               ;". IF CHART'["13^WHO" DO  ;"WHO-WEIGHT FOR LENGTH
               ;". . IF (MONTHS\1)'=(MONTHS2\1) SET MONTHS2=""  ;"Ensure e.g. 31.2 doesn't goto 40.99
               ;". IF MONTHS2="" DO  QUIT
               ;". . SET RESULT="-1^Unable to find age interfal FOR AGE:  Got: '"_MONTHS_"'"
               ;". SET MONTHS=MONTHS2
               ;"NEW DONE SET DONE=0
               ;"NEW I SET I=0
               ;"FOR  SET I=$ORDER(^TMG(22713,IEN,"D","B",MONTHS,I)) QUIT:(+I'>0)!DONE  DO
               ;". NEW NODE SET NODE=$GET(^TMG(22713,IEN,"D",I,0)) QUIT:NODE=""
               ;". IF $PIECE(NODE,"^",2)'=GENDER QUIT
               ;". SET DONE=1,RESULT=1
               ;". SET L=$PIECE(NODE,"^",3)
               ;". SET M=$PIECE(NODE,"^",4)
               ;". SET S=$PIECE(NODE,"^",5)
GLMSDN   QUIT RESULT
               ;
GEXCTLMS(CHART,MONTHS,GENDER,L,M,S)             ;
               ;"Purpose: return the LMS values for a given chart -- ROUNDING AGE TO EXACT INTERVAL
               ;"Note: input validation not done in this function.  Private API
               ;"Input: CHART -- IEN of the chart to reference
               ;"       MONTHS -- The age to use for lookup in the chart -- ROUNDED TO EXACT INTERVAL
               ;"          It is expected that this month will EXACTLY match the intervals in the data
               ;"       GENDER -- MUST be "M" or "F" FOR male or female
               ;"       L, M, S -- PASS BY REFERENCE, OUT Parameters.  Prior values killed
               ;"Results: 1 IF successful, 0 otherwise
               ;"Output:  L,M,S are filled with data IF valid
               KILL L,M,S
               NEW DONE SET DONE=0
               NEW I SET I=0
               IF $EXTRACT(MONTHS,1)="." SET MONTHS="0"_MONTHS
               FOR  SET I=$ORDER(^TMG(22713,IEN,"D","B",MONTHS,I)) QUIT:(+I'>0)!DONE  DO
               . NEW NODE SET NODE=$GET(^TMG(22713,IEN,"D",I,0)) QUIT:NODE=""
               . IF $PIECE(NODE,"^",2)'=GENDER QUIT
               . SET DONE=1,RESULT=1
               . SET L=$PIECE(NODE,"^",3)
               . SET M=$PIECE(NODE,"^",4)
               . SET S=$PIECE(NODE,"^",5)
               QUIT ($DATA(L)'=0)
               ;
INTRPLMS(MONTHS,MO1,MO2,L1,M1,S1,L2,M2,S2,L,M,S)               ;
               ;"Purpose: to return an interpolated LMS based on input values
               ;"Input: MONTHS -- the patient's actual age
               ;"       MO1,M02 -- the patient's age rounded to lower and upper ends of age range
               ;"       L1,M1,S2 -- the LMS values for the lower end of the age range
               ;"       L2,M2,S2 -- the LMS values for the upper end of the age range
               ;"       L,M,S -- PASS BY REFERENCE.  This is the output values
               SET L=$$INTERPLT(MONTHS,MO1,MO2,L1,L2)
               SET M=$$INTERPLT(MONTHS,MO1,MO2,M1,M2)
               SET S=$$INTERPLT(MONTHS,MO1,MO2,S1,S2)
               QUIT
               ;
INTERPLT(X,X1,X2,Y1,Y2)         ;
               ;"Purpose: Return an interpolated value
               ;"Input: X - the measured value
               ;"       X1,X2 -- the lower and upper known x values
               ;"       Y1,Y2 -- the lower and upper known y values
               ;"Results: returns the interpolated value
               NEW SLOPE SET SLOPE=(Y2-Y1)/(X2-X1)
               NEW B SET B=Y1-(SLOPE*X1)
               NEW RESULT SET RESULT=(SLOPE*X)+B
               QUIT RESULT
               ;
LMS2Z(X,L,M,S)         ;
               ;"Purpose: convert Input Patient measurement value X, and L,M,S SET  into a Z score
               ;"Input: X -- This is the value of the patient measurement, units should
               ;"            be the same as specified in INPUT UNITS field FOR record
               ;"      L,M,S -- These are Values as may be obtained by GETLMS()
               ;"Results: Outputs the Z score
               ;"
               ;"formula used is Z = [((X/M)**L) - 1] / LS  where L <> 0
               ;"             or Z = ln(X/M)/S  where L=0
               NEW RESULT SET RESULT=0
               SET L=+$GET(L),M=+$GET(M),S=+$GET(S),X=+$GET(X)
               IF L=0 DO
               . NEW T
               . SET T=X/M
               . SET T=$$LN^XLFMTH(T)
               . SET RESULT=T/S
               ELSE  DO
               . NEW T
               . SET T=X/M
               . SET T=(T**L)-1
               . SET RESULT=T/(L*S)
               QUIT RESULT
               ;
LMSZ2Y(L,M,S,Z)        ;
               ;"Purpose: To convert a LMS pair + Z score into a value (e.g. weight FOR 5th %tile, Z=-1.645)
               ;"Input: L,M,S -- LMS pair that describes normal distribution
               ;"         Z -- The z-score corelating to the desired %tile
               ;"Results: Returns value requested
               ;"Formula used: X= M (1 +LSZ)**(1/L) IF L<>0  or X = M exp(SZ) IF L=0
               ;
               NEW RESULT SET RESULT=0
               SET L=+$GET(L),M=+$GET(M),S=+$GET(S),X=+$GET(X),Z=+$GET(Z)
               NEW T
               IF L=0 DO
               . SET T=$$EXP^XLFMTH(S*Z)
               ELSE  DO
               . SET T=((L*S*Z)+1)**(1/L)
               SET RESULT=M*T
               QUIT RESULT
               ;
LMSP2Y(L,M,S,P)        ;
               ;"Purpose: To convert a LMS pair + Percentil into a value (e.g. weight FOR 5th %tile)
               ;"Input: L,M,S -- LMS pair that describes normal distribution
               ;"         P -- Percentile of desired value.  0-100
               ;"Results: Returns value requested, or -1 IF error
               NEW RESULT SET RESULT=-1
               NEW Z SET Z=$$PCTL2Z(+$GET(P))
               IF Z="E" GOTO LP2XDN
               SET RESULT=$$LMSZ2Y(.L,.M,.S,Z)
LP2XDN          QUIT RESULT
               ;
Z2PCTL(Z)              ;
               ;"Purpose: To convert a Z score into a Percentile
               ;"Input: Z : zscore
               ;"Output: the Percentile, or -1 if invalid
               ;"NOTE: Code from Cameron Schlehuber
               ;
                  NEW $ETRAP SET $ETRAP="G ERRZ2PTL^TMGGRC1"
                  NEW TMGERR SET TMGERR=0
                  SET Z=+$GET(Z)
               NEW ABZ SET ABZ=$$ABS^XLFMTH(Z)
                  ; Overflow error can happen here. TMGERR set to 1 if error occurs
               NEW P
               SET P=1-((1/$$SQRT^XLFMTH(2*3.14159265))*$$EXP^XLFMTH(-(ABZ**2)/2)*(0.4361836*(1/(1+(0.33267*ABZ)))-(0.1201676*((1/(1+(0.33267*ABZ)))**2))+(0.937298*((1/(1+(0.33267*ABZ)))**3))))
               IF TMGERR QUIT -1  ; Error happened.
                  IF Z>0 SET P=P*100
               ELSE  SET P=100-(P*100)
               ;" SET P=P\1  ;"truncate decimal portion
               QUIT P
               ;
ERRZ2PTL           ; Process Error from Z2Percenticle function.
                   S $ETRAP="D ^%ZTER H"
                   I $ECODE[",M92," SET $ECODE="",TMGERR=1 QUIT:$QUIT "" QUIT  ; Process Numeric Overflow error
                   E  QUIT:$QUIT "" QUIT  ; Otherwise, let default error handler do its work
PCTL2Z(P)              ;
               ;"Purpose: To Convert a percentile to an approximated Z-score
               ;"Input: P : Percentile (should be 0-100)
               ;"Code from function critz found at http://www.fourmilab.ch/rpkp/experiments/analysis/zCalc.js
               ;"   notes state that code was in public domain
               ;"Results: returns percentile, or "E" IF error
               ;
               NEW RESULT SET RESULT="E"
               NEW ZEPSILON SET ZEPSILON=0.000001  ;"Accuracy of Z approximation
               NEW MINZ SET MINZ=-6
               NEW MAXZ SET MAXZ=6
               NEW ZVAL SET ZVAL=0
               NEW PVAL
               SET P=+$GET(P)/100
               IF (P<0)!(P>1) GOTO PC2ZDN
               FOR  QUIT:((MAXZ-MINZ)'>ZEPSILON)  DO
               . SET PVAL=$$Z2PCTL(ZVAL)/100
               . IF PVAL>P SET MAXZ=ZVAL
               . ELSE  SET MINZ=ZVAL
               . SET ZVAL=(MAXZ+MINZ)*0.5
               SET RESULT=ZVAL
PC2ZDN          QUIT RESULT
               ;
SETSUFFIX(NUM)         ;
               ;"Purpose: Return a suffix, e.g. 1-->"st %tile", 2--> "2nd %tile" etc.
               ;"Input: NUM -- integer >0
               SET NUM=+$GET(NUM)
               NEW ENDNUM SET ENDNUM=$E(NUM,$L(NUM))+1 SET:(ENDNUM>5) ENDNUM=5
               QUIT NUM_$PIECE("th^st^nd^rd^th","^",ENDNUM)_" %tile"
               ;
               ;"=======================================================================
               ;"=======================================================================
TEST           ;
               NEW DIC,X,Y,AGE,GENDER
               SET DIC=22713,DIC(0)="MAEQ"
               DO ^DIC
               IF +Y'>0 QUIT
               WRITE !
               WRITE "The age range FOR this graph is: ",$$GET1^DIQ(22713,+Y,.06),!
               WRITE "Please input ",$$GET1^DIQ(22713,+Y,.02)," (in ",$$GET1^DIQ(22713,+Y,.03),"): "
               READ AGE:60
               WRITE !
               IF AGE="^" QUIT
               WRITE "Please enter patient value FOR ",$$GET1^DIQ(22713,+Y,.04)," (in ",$$GET1^DIQ(22713,+Y,.05),"): "
               READ X:60,!
               IF X="^" QUIT
               READ "Please Enter GENDER (must be 'M' or 'F'): ",GENDER:60,!
               IF (GENDER'="M")&(GENDER'="F") WRITE "??",! QUIT
               NEW L,M,S
               NEW TEMP SET TEMP=$$GETLMS(Y,AGE,GENDER,.L,.M,.S)
               IF +TEMP<0 WRITE $P(TEMP,"^",2),! QUIT
               WRITE "L=",L,!
               WRITE "M=",M,!
               WRITE "S=",S,!
               NEW Z SET Z=$$LMS2Z(X,L,M,S)
               WRITE "That Z score is: ",Z,!
               WRITE "%tile=",$$Z2PCTL(Z)\1,!
               WRITE "For this input, we have the following normal values:",!
               NEW PCTL
               FOR PCTL=3,5,10,25,50,75,85,90,95,97 DO
               . WRITE PCTL,"th: ",$$LMSP2Y(L,M,S,PCTL),!
               QUIT
               ;
