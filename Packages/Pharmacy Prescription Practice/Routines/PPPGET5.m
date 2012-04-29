PPPGET5 ;alb/dmb - MISC GET ROUTINES ; 3/16/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
GETRANGE(MIN,MAX,PROMPT) ;
 ;
 ; This function will get a string of values from the user, check
 ; them for out-of-range values, and return a string containing the
 ; values delimited with ;.  You should not use this routine if the
 ; returned string length may exceed acceptable limits (i.e. 245).
 ;
 ; Parameters: MIN,MAX - The minimum and maximum acceptable values.
 ;
 ; Return: The full string of values selected or
 ;         -1 - User Timeout
 ;         -2 - User Abort
 ;         -3 - Format Error
 ;         -4 - Range Error
 ;
 N USRTMOUT,USRABORT,FMTERR,RNGERR
 N INRANGE,RANGE,ERR,HLP1,HLP2
 ;
 S USRTMOUT=-1,USRABORT=-2,FMTERR=-3,RNGERR=-4
 ;
 ; Get the desired range
 ;
 S HLP1="Enter single value, range of numbers or the letter A for ALL."
 S HLP2="D RNGHLP^PPPGET5"
 S INRANGE=$$GETRESP^PPPGET6(PROMPT,HLP1,HLP2,"","","")
 ;
 ; If response is -2 then the user timed out
 ;
 I INRANGE=-2 Q USRTMOUT
 ;
 ; If it a -1 or null then it's a user abort
 ;
 I (INRANGE=-1)!(INRANGE="") Q USRABORT
 ;
 ; If it an A then return all of the possible values
 ;
 I ($E(INRANGE)="A")!($E(INRANGE)="a") Q $$ALL(MIN,MAX)
 ;
 ; Check for proper format and return an error if incorrect
 ;
 I (INRANGE'?.NP)!(INRANGE<0) Q FMTERR
 ;
 ; If we're here then we must have a string of values.  Break them
 ; up and check for values out of range.
 ;
 S RANGE=$$XTRCTRNG(INRANGE,MIN,MAX)
 ;
 ; Check for errors and return
 ;
 I RANGE="" Q FMTERR
 I RANGE<0 S ERR=RANGE-2 Q ERR
 Q RANGE
 ;
ALL(MIN,MAX) ; Return the full range
 ;
 N I,RANGE
 ;
 S RANGE=""
 F I=MIN:1:MAX D
 .S RANGE=RANGE_I_","
 Q $E(RANGE,1,($L(RANGE)-1))
 ;
XTRCTRNG(INRANGE,MIN,MAX) ; Build the selected range string
 ;
 N FMTERR,RNGERR,ERR,RANGE,I,PC,TMIN,TMAX
 ;
 S FMTERR=-1,RNGERR=-2
 S RANGE=""
 S ERR=0
 ;
 ; For each piece of the string, check for range and format.
 ; Then concatonate each piece to the rest.
 ;
 F I=1:1:$L(INRANGE,",") D  Q:ERR<0
 .S PC=$P(INRANGE,",",I)
 .I (PC'?.N)&(PC'?1.N1"-"1.N) S ERR=FMTERR Q
 .I PC?1.N D  Q
 ..I (PC<MIN)!(PC>MAX) S ERR=RNGERR Q
 ..S RANGE=RANGE_PC_","
 .I PC?1.N1"-"1.N D
 ..S TMIN=$P(PC,"-"),TMAX=$P(PC,"-",2)
 ..I (TMIN<MIN)!(TMAX>MAX) S ERR=RNGERR Q
 ..S PC=$$ALL(TMIN,TMAX)
 ..S RANGE=RANGE_PC_","
 I ERR<0 Q ERR
 Q $E(RANGE,1,($L(RANGE)-1))
 ;
RNGHLP ;
 W !,*7
 W !,"You may respond to this prompt with a single value or"
 W !,"with a range of values in the form of 1,2,3,4-9,10 or"
 W !,"with the letter A for ALL possible values.",!!
 Q
