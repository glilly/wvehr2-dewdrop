TMGGRCU ;TMG/kst-Growth Chart Data Utilities ;5/10/11
                 ;;1.0;TMG-LIB;**1**;10/5/10;Build 27
        ;
        ;"Utilities for pediatric growth chart.
        ;
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
               ;//Functions below copied from TMGDEBUG to prevent having to reference that file.
               ;
SHOWERROR(PRIORERRORFOUND,ERROR)        ;
               ;"Purpose: to output an error message
               ;"Input: [OPTIONAL] PRIORERRORFOUND -- var to see if an error already shown.
               ;"                if not passed, then default value used ('no prior error')
               ;"        Error -- a string to display
               ;"results: none
               ;
               DO POPUPBOX("<!> ERROR . . .",ERROR)
               SET PRIORERRORFOUND=1
               QUIT
               ;
GETERRSTR(ERRARRAY)     ;
               ;"Purpose: convert a standard DIERR array into a string for output
               ;"Input: ERRARRAY -- PASS BY REFERENCE.  example:
               ;"      array("DIERR")="1^1"
               ;"      array("DIERR",1)=311
               ;"      array("DIERR",1,"PARAM",0)=3
               ;"      array("DIERR",1,"PARAM","FIELD")=.02
               ;"      array("DIERR",1,"PARAM","FILE")=2
               ;"      array("DIERR",1,"PARAM","IENS")="+1,"
               ;"      array("DIERR",1,"TEXT",1)="The new record '+1,' lacks some required identifiers."
               ;"      array("DIERR","E",311,1)=""
               ;"Results: returns one long equivalent string from above array.
               ;
               NEW TMGERRSTR,TMGIDX,TMGERRNUM
               ;
               SET TMGERRSTR=""
               FOR TMGERRNUM=1:1:+$GET(ERRARRAY("DIERR")) DO
               . SET TMGERRSTR=TMGERRSTR_"Fileman says: '"
               . IF TMGERRNUM'=1 SET TMGERRSTR=TMGERRSTR_"(Error# "_TMGERRNUM_") "
               . SET TMGIDX=$ORDER(ERRARRAY("DIERR",TMGERRNUM,"TEXT",""))
               . IF TMGIDX'="" FOR  DO  QUIT:(TMGIDX="")
               . . SET TMGERRSTR=TMGERRSTR_$GET(ERRARRAY("DIERR",TMGERRNUM,"TEXT",TMGIDX))_" "
               . . SET TMGIDX=$ORDER(ERRARRAY("DIERR",TMGERRNUM,"TEXT",TMGIDX))
               . IF $GET(ERRARRAY("DIERR",TMGERRNUM,"PARAM",0))>0 DO
               . . SET TMGIDX=$ORDER(ERRARRAY("DIERR",TMGERRNUM,"PARAM",0))
               . . SET TMGERRSTR=TMGERRSTR_"Details: "
               . . FOR  DO  QUIT:(TMGIDX="")
               . . . IF TMGIDX="" QUIT
               . . . SET TMGERRSTR=TMGERRSTR_"["_TMGIDX_"]="_$GET(ERRARRAY("DIERR",1,"PARAM",TMGIDX))_"  "
               . . . SET TMGIDX=$ORDER(ERRARRAY("DIERR",TMGERRNUM,"PARAM",TMGIDX))
               ;
               QUIT TMGERRSTR
               ;
SHOWDIERR(ERRMSG,PRIORERRORFOUND)       ;
               ;"Purpose: To provide a standard output mechanism for the fileman DIERR message
               ;"Input:   ERRMSG -- PASS BY REFERENCE.  a standard error message array, as
               ;"                   put out by fileman calls
               ;"         PRIORERRORFOUND -- OPTIONAL variable to keep track if prior error found.
               ;"          Note -- can also be used as ErrorFound (i.e. set to 1 if error found)
               ;"Output -- none, displays error to console
               ;"Result -- none
               ;
               IF $DATA(ERRMSG("DIERR")) DO
               . NEW TMGERRSTR SET TMGERRSTR=$$GETERRSTR(.ERRMSG)
               . DO SHOWERROR(.PRIORERRORFOUND,.TMGERRSTR)
               QUIT
               ;
               ;//Functions below copied from TMGUSRIF
POPUPBOX(TMGHEADER,TMGTEXT,TMGWIDTH)    ;
               ;"PUBLIC FUNCTION
               ;"Purpose: To provide easy text output box
               ;"Input: TMGHEADER -- a short string for header
               ;"       TMGTEXT - the text to display
               ;"       [TMGWIDTH] -- optional width specifier. Value=0 same as not specified
               ;"       (TMGINDENT) -- uses a var with global scope (if defined) for indent amount
               ;"Note: If text width not specified, and TMGTEXT is <= 60,
               ;"        then all will be put on one line.
               ;"        Otherwise, width is set to 60, and text is wrapped.
               ;"        Also, text of the message can contain "\n", which will be interpreted
               ;"        as a new-line character.
               ;"Result: none
               ;
               NEW TMGNEWLN SET TMGNEWLN="\n"
               NEW TMGTEXTOUT
               NEW TMGTEXTI SET TMGTEXTI=0
               NEW TMGPARTB SET TMGPARTB=""
               NEW TMGPARTB1 SET TMGPARTB1=""
               SET TMGWIDTH=+$GET(TMGWIDTH,0)
               ;
               SET TMGTEXTOUT(TMGTEXTI)=TMGHEADER
               SET TMGTEXTI=TMGTEXTI+1
               ;
               IF TMGWIDTH=0 DO
               . NEW TMGHEADERBASED
               . NEW TMGNUMLINES
               . NEW TMGHLEN SET TMGHLEN=$LENGTH(TMGHEADER)+4
               . NEW TMGTLEN SET TMGTLEN=$LENGTH(TMGTEXT)+4
               . IF TMGTLEN>TMGHLEN DO
               . . SET TMGWIDTH=TMGTLEN
               . . SET TMGHEADERBASED=0
               . ELSE  DO
               . . SET TMGWIDTH=TMGHLEN
               . . SET TMGHEADERBASED=1
               . IF TMGWIDTH>75 SET TMGWIDTH=75
               . SET TMGNUMLINES=TMGTLEN/TMGWIDTH
               . IF TMGTLEN#TMGWIDTH>0 SET TMGNUMLINES=TMGNUMLINES+1
               . IF (TMGNUMLINES>1)&(TMGHEADERBASED=0) DO
               . . SET TMGWIDTH=(TMGTLEN\TMGNUMLINES)+4
               . . IF TMGWIDTH<TMGHLEN SET TMGWIDTH=TMGHLEN
               . IF TMGWIDTH>75 SET TMGWIDTH=75
               ;
PUWBL1  ;"Load string up into TMGTEXT array, to pass to PUARRAY
               IF TMGTEXT[TMGNEWLN DO
               . DO CLEAVESTR(.TMGTEXT,TMGNEWLN,.TMGPARTB1)
               DO SPLITSTR(.TMGTEXT,(TMGWIDTH-4),.TMGPARTB)
               SET TMGPARTB=TMGPARTB_TMGPARTB1 SET TMGPARTB1=""
               SET TMGTEXTOUT(TMGTEXTI)=TMGTEXT
               SET TMGTEXTI=TMGTEXTI+1
               IF $LENGTH(TMGPARTB)>0 DO  GOTO PUWBL1
               . SET TMGTEXT=TMGPARTB
               . SET TMGPARTB=""
               ;
               DO PUARRAY(.TMGINDENT,TMGWIDTH,.TMGTEXTOUT)
               QUIT
               ;
PUARRAY(TMGINDENTW,TMGWIDTH,TMGARRAY,TMGMODAL)  ;
               ;"PUBLIC FUNCTION
               ;"Purpose: To draw a box, of specified TMGWIDTH, and display text
               ;"Input: TMGINDENTW = width of indent amount (how far from left margin)
               ;"        TMGWIDTH = desired width of box.
               ;"        TMGHEADER = one line of text to put in header of popup box
               ;"        TMGARRAY: an array in following format:
               ;"                TMGARRAY(0)=TMGHEADER
               ;"                TMGARRAY(1)=Text line 1
               ;"                TMGARRAY(2)=Text line 2
               ;"                ...
               ;"                TMGARRAY(n)=Text line n
               ;"        TMGMODAL - really only has meaning for those time when
               ;"                box will be passed to GUI X dialog box.
               ;"                TMGMODAL=1 means stays in foreground,
               ;"                      0 means leave box up, continue script execution.
               ;"Note: Text will be clipped to fit in box.
               ;
               NEW TMGCMODAL SET TMGCMODAL="MODAL"
               SET TMGMODAL=$GET(TMGMODAL,TMGCMODAL)
               NEW TMGHEADER
               NEW TMGTEXT SET TMGTEXT=""
               NEW INDEX,TMGI,S
               ;
               ;"Scan array for any needed data substitution i.e. {{...}}
               NEW TMGTEMPRESULT
               SET INDEX=$ORDER(TMGARRAY(""))
               FOR  DO  QUIT:INDEX=""
               . SET S=TMGARRAY(INDEX)
               . ;"SET TMGTEMPRESULT=$$CheckSubstituteData(.S)  ;"Do any data lookup needed
               . SET TMGARRAY(INDEX)=S
               . SET INDEX=$ORDER(TMGARRAY(INDEX))
               ;
               SET TMGINDENTW=$GET(TMGINDENTW,1) ;"default indent=1
               SET TMGHEADER=$GET(TMGARRAY(0)," ")
               SET TMGWIDTH=$GET(TMGWIDTH,40)   ;"default=40
               ;
               WRITE !
               ;"Draw top line
               FOR TMGI=1:1:TMGINDENTW WRITE " "
               WRITE "+"
               FOR TMGI=1:1:(TMGWIDTH-2) WRITE "="
               WRITE "+",!
               ;
               ;"Draw Header line
               DO SETSTRLEN(.TMGHEADER,TMGWIDTH-4)
               FOR TMGI=1:1:TMGINDENTW WRITE " "
               WRITE "| ",TMGHEADER," |..",!
               ;
               ;"Draw divider line
               FOR TMGI=1:1:TMGINDENTW WRITE " "
               WRITE "+"
               FOR TMGI=1:1:(TMGWIDTH-2) WRITE "-"
               WRITE "+ :",!
               ;
               ;"Put out message
               SET INDEX=$ORDER(TMGARRAY(0))
PUBLOOP ;
               IF INDEX="" GOTO BTMLINE
               SET S=$GET(TMGARRAY(INDEX)," ")
               DO SETSTRLEN(.S,TMGWIDTH-4)
               FOR TMGI=1:1:TMGINDENTW WRITE " "
               WRITE "| ",S," | :",!
               SET INDEX=$ORDER(TMGARRAY(INDEX))
               GOTO PUBLOOP
               ;
BTMLINE ;
               ;"Draw Bottom line
               FOR TMGI=1:1:TMGINDENTW WRITE " "
               WRITE "+"
               FOR TMGI=1:1:(TMGWIDTH-2) WRITE "="
               WRITE "+ :",!
               ;
               ;"Draw bottom shaddow
               FOR TMGI=1:1:TMGINDENTW WRITE " "
               WRITE "  "
               WRITE ":"
               FOR TMGI=1:1:(TMGWIDTH-2) WRITE "."
               WRITE ".",!
               ;
               WRITE !
               ;
PUADONE ;
               QUIT
               ;
               ;//Functions below copied from TMGSTUTL
               ;
CLEAVESTR(TMGTEXT,TMGDIV,TMGPARTB)      ;
               ;"Purpse: To take a string, delineated by 'TMGDIV'
               ;"        and to split it into two parts: TMGTEXT and TMGPARTB
               ;"         e.g. TMGTEXT="Hello\nThere"
               ;"             TMGDIV="\n"
               ;"           Function will result in: TMGTEXT="Hello", TMGPARTB="There"
               ;"Input: TMGTEXT - the input string **SHOULD BE PASSED BY REFERENCE.
               ;"         TMGDIV - the delineating string
               ;"        TMGPARTB - the string to get second part **SHOULD BE PASSED BY REFERENCE.
               ;"Output: TMGTEXT and TMGPARTB will be changed
               ;"        Function will result in: TMGTEXT="Hello", TMGPARTB="There"
               ;"Result: none
               ;
               SET TMGINDENT=$GET(TMGINDENT,0)
               ;
               IF '$DATA(TMGTEXT) GOTO CSDONE
               IF '$DATA(TMGDIV) GOTO CSDONE
               SET TMGPARTB=""
               ;
               NEW TMGPARTA
               ;
               IF TMGTEXT[TMGDIV DO
               . SET TMGPARTA=$PIECE(TMGTEXT,TMGDIV,1)
               . SET TMGPARTB=$PIECE(TMGTEXT,TMGDIV,2,256)
               . SET TMGTEXT=TMGPARTA
               ;
CSDONE   ;
               QUIT
               ;
SPLITSTR(TMGTEXT,TMGWIDTH,TMGPARTB)     ;
               ;"PUBLIC FUNCTION
               ;"Purpose: To a string into two parts.  The first part will fit within 'TMGWIDTH'
               ;"           the second part is what is left over
               ;"          The split will be inteligent, so words are not divided (splits at a space)
               ;"Input:  TMGTEXT = input text.  **Should be passed by reference
               ;"          TMGWIDTH = the constraining width
               ;"        TMGPARTB = the left over part. **Should be passed by reference
               ;"output: TMGTEXT and TMGPARTB are modified
               ;"result: none.
               ;
               NEW LEN,TMGS1
               SET TMGWIDTH=$GET(TMGWIDTH,80)
               NEW SPACEFOUND SET SPACEFOUND=0
               NEW SPLITPOINT SET SPLITPOINT=TMGWIDTH
               SET TMGTEXT=$GET(TMGTEXT)
               SET TMGPARTB=""
               ;
               SET LEN=$LENGTH(TMGTEXT)
               IF LEN>TMGWIDTH DO
               . NEW TMGCH
               . FOR SPLITPOINT=SPLITPOINT:-1:1 DO  QUIT:SPACEFOUND
               . . SET TMGCH=$EXTRACT(TMGTEXT,SPLITPOINT,SPLITPOINT)
               . . SET SPACEFOUND=(TMGCH=" ")
               . IF 'SPACEFOUND SET SPLITPOINT=TMGWIDTH
               . SET TMGS1=$EXTRACT(TMGTEXT,1,SPLITPOINT)
               . SET TMGPARTB=$EXTRACT(TMGTEXT,SPLITPOINT+1,1024)  ;"max String length=1024
               . SET TMGTEXT=TMGS1
               ;
               QUIT
               ;
SETSTRLEN(TMGTEXT,TMGWIDTH)     ;
               ;"PUBLIC FUNCTION
               ;"Purpose: To make string exactly TMGWIDTH in length
               ;"  Shorten as needed, or pad with terminal spaces as needed.
               ;"Input: TMGTEXT -- should be passed as reference.  This is string to alter.
               ;"       TMGWIDTH -- the desired width
               ;"Results: none.
               ;
               SET TMGTEXT=$GET(TMGTEXT)
               SET TMGWIDTH=$GET(TMGWIDTH,80)
               NEW TMGRESULT SET TMGRESULT=TMGTEXT
               NEW TMGI,LEN
               ;
               SET LEN=$LENGTH(TMGRESULT)
               IF LEN>TMGWIDTH DO
               . SET TMGRESULT=$EXTRACT(TMGRESULT,1,TMGWIDTH)
               ELSE  IF LEN<TMGWIDTH DO
               . FOR TMGI=1:1:(TMGWIDTH-LEN) SET TMGRESULT=TMGRESULT_" "
               ;
               SET TMGTEXT=TMGRESULT  ;"pass back changes
               ;
               QUIT
               ;
