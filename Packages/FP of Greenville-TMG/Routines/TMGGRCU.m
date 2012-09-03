TMGGRCU ;TMG/kst-Growth Chart Data Utilities ;5/10/11, 5/17/12
                 ;;1.0;TMG-LIB;**1,17**;10/5/10;Build 23
        ;
        ;"Utilities for pediatric growth chart.
        ;"
        ;"Kevin Toppenberg MD
        ;"(C) 5/10/11
        ;"Released under: GNU General Public License (GPL)
        ;
        ;"=======================================================================
        ;" RPC -- Public Functions.
        ;"=======================================================================
        ;
        ;"=======================================================================
        ;"PRIVATE API FUNCTIONS
        ;"=======================================================================
        ;"GETLMS(CHART,MONTHS,GENDER,L,M,S) -- return the LMS values for a given chart
        ;"GEXCTLMS(CHART,MONTHS,GENDER,L,M,S)--return the LMS values for a given chart -- ROUNDING AGE TO EXACT INTERVAL
        ;"INTRPLMS(MONTHS,MO1,MO2,L1,M1,S1,L2,M2,S2,L,M,S) -- return an interpolated LMS based on input values
        ;"INTERPLT(X,X1,X2,Y1,Y2) -- Return an interpolated value
        ;"LMS2Z(X,L,M,S) -- convert Input Patient measurement value X, and L,M,S SET  into a Z score
        ;"LMSZ2Y(L,M,S,Z) --convert a LMS pair + Z score into a value (e.g. weight FOR 5th %tile, Z=-1.645)
        ;"LMSP2Y(L,M,S,P) -- convert a LMS pair + Percentil into a value (e.g. weight FOR 5th %tile)
        ;"Z2PCTL(Z) -- convert a Z score into a Percentile
        ;"ERRZ2PTL    ; Process Error from Z2Percenticle function.
        ;"PCTL2Z(P) Convert a percentile to an approximated Z-score
        ;"SETSUFIX(NUM) --Return a suffix, e.g. 1-->"st %tile", 2--> "2nd %tile" etc.
        ;"TEST -- Test system
        ;
        ;"=======================================================================
        ;"Dependancies:  DIC, XLFMTH, TMGGRC1, %ZTER, DIQ
        ;"=======================================================================
        ;
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
PC2ZDN   QUIT RESULT
               ;
SETSUFIX(NUM)          ;
               ;"Purpose: Return a suffix, e.g. 1-->"st %tile", 2--> "2nd %tile" etc.
               ;"Input: NUM -- integer >0
               SET NUM=+$GET(NUM)
               NEW ENDNUM SET ENDNUM=$E(NUM,$L(NUM))+1 SET:(ENDNUM>5) ENDNUM=5
               QUIT NUM_$PIECE("th^st^nd^rd^th","^",ENDNUM)_" %tile"
               ;
               ;"=======================================================================
               ;"=======================================================================
TEST       ;
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
