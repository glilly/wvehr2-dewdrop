PPPGET6 ;ALB/DMB - PPP UTILITIES ; 4/23/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
GETRESP(PROMPT,HELP1,HELP2,DFLTRESP,PATTERN,LEN) ;
 ;
 ; This function queries the user with the prompt passed in the
 ; parameter list.
 ;
 ; Parameters:
 ;   PROMPT - Text string to prompt user with (may be NULL)
 ;   HELP1 - Help string to display if user enters "?" (may be NULL)
 ;   HELP2 - Help string to be executed if user enters "??" (may be NULL)
 ;   DFLTRESP - Default response (may be NULL)
 ;   PATTERN - Pattern to verify users response with (may be NULL)
 ;   LEN - Maximum length of response (may be NULL)
 ;
 ; Returns:
 ;   User Response - Guarranteed to conform to Pattern ans length
 ;   -1 - User Responded with up-arrow
 ;   -2 - User Timed out
 ;
 N RESP,GOTRESP
 ;
 F GOTRESP=0:0 D  Q:GOTRESP
 .W PROMPT
 .I DFLTRESP'="" W DFLTRESP_" // "
 .R RESP:DTIME
 .I '$T S RESP=-2,GOTRESP=1 Q
 .I RESP["^" S RESP=-1,GOTRESP=1 Q
 .I RESP="?" D  Q
 ..I HELP1="" D
 ...W *7,"  ??",!!
 ..E  D
 ...W !!,*7,HELP1,!!
 ..S GOTRESP=0
 .I RESP="??" D  Q
 ..I HELP2="" D
 ...W *7,"  ??",!!
 ..E  D
 ...X HELP2
 ..S GOTRESP=0
 .I RESP="" S RESP=DFLTRESP W RESP
 .I PATTERN'="" D  Q:GOTRESP=0
 ..I RESP'?@PATTERN D
 ...W !!,*7,"Invalid Format... Please Re-enter.",!!
 ...S GOTRESP=0
 ..E  D
 ...S GOTRESP=1
 .I LEN'="" D  Q:GOTRESP=0
 ..I RESP>LEN D
 ...W !!,*7,"Response too long... Please Re-enter.",!!
 ...S GOTRESP=0
 ..E  D
 ...S GOTRESP=1
 .S GOTRESP=1
 Q RESP
 ;
SAMPLE ; Sample routine using GETRESP -- SAMPLE CODE -- NOT USED BY PPP
 ;
 S PROMPT="Enter Your Name: "
 S DFLTRESP="SMITH,FRED"
 S HELP1="Enter as LASTNAME,FIRSTNAME 30 characters max."
 S HELP2="D EXTHLP"
 S PATTERN="1.30U1"",""1.30U"
 S LEN=30
 S ANSWER=$$GETRESP(PROMPT,HELP1,HELP2,DFLTRESP,PATTERN,LEN)
 I ANSWER'<0 W !!,"Response = ",ANSWER
 I ANSWER=-1 W !!,"You entered ^"
 I ANSWER=-2 W !!,"You timed out"
 K PROMPT,DFLTRESP,HELP1,HELP2,PATTERN,LEN,ANSWER
 Q
 ;
EXTHLP ;
 W !!,*7,"Sample of extented help, this could be any text!",!!
 Q
