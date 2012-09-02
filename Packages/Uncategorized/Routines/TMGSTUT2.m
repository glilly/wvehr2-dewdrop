TMGSTUT2        ;TMG/kst/SACC Compliant String Util Lib ;7/17/12
                ;;1.0;TMG-LIB;**1,17**;7/17/12;Build 23
        ;
        ;"TMG STRING UTILITIES v2
        ;"SAAC Compliant Version.
        ;"This file will be used to hold SACC compliant versions of 
        ;"  routines found in TMGSTUTL.
        ;"I don't initially have time to convert them all at once, so will 
        ;"  slowly move them over, as needed.
        ;
        ;"=======================================================================
        ;" API -- Public Functions.
        ;"=======================================================================
        ;"$$CAPWORDS(S,DIV) -- InitCap  each word in a string
        ;"CLEAVSTR(TMGTEXT,TMGDIV,TMGPARTB) ;Split string by divider
        ;"SPLITSTR(TMGTEXT,TMGWIDTH,TMGPARTB) ;Wrap string to specified width.
        ;"SETSTLEN(TMGTEXT,TMGWIDTH) ;Make string exactly TMGWIDTH in length
        ;"$$PAD2POS(POS,CH) -- return a string that can be used to pad up to POS 
        ;"$$SPLITLN(STR,LINEARRAY,WIDTH,SPECIALINDENT,INDENT,DIVSTR) -- Wrap by WIDTH to array
        ;"SPLIT2AR(TEXT,DIVIDER,ARRAY,INITINDEX) -- Slit into array, by DIVIDER
        ;"$$NUMLWS(S) -- Count the num of white space characters on left side of the string
        ;"$$MAKEWS(N)  -- Return a whitespace string that is n characters long
        ;"=======================================================================
        ;" Private Functions.
        ;"=======================================================================
        ;"$$NEEDEDWS(S,SPECIALINDENT,INDENT) -- create white space need for wrapped lines
        ;"=======================================================================
        ;"Dependancies: XLFSTR
        ;
        ;"=======================================================================
        ;"=======================================================================
        ;
        ;"------------------------------------------------------------------------
        ;"FYI, String functions in XLFSTR module:
        ;"------------------------------------------------------------------------
        ;"$$CJ^XLFSTR(s,i[,p]) -- Returns a center-justified string
        ;"        s=string, i=field size, p(optional)=pad character
        ;"$$LJ^XLFSTR(s,i[,p]) -- Returns a left-justified string
        ;"        s=string, i=field size, p(optional)=pad character
        ;"$$RJ^XLFSTR(s,i[,p]) -- Returns a right-justified string
        ;"        s=string, i=field size, p(optional)=pad character
        ;"$$INVERT^XLFSTR(s) -- returns an inverted string (i.e. "ABC"-->"CBA")
        ;"$$LOW^XLFSTR(s) -- returns string with all letters converted to lower-case
        ;"$$UP^XLFSTR(s) -- returns string with all letters converted to upper-case
        ;"$$TRIM^XLFSTR(s,[LRFlags],[char])
        ;"$$REPEAT^XLFSTR(s,Count) -- returns a string that is a repeat of s Count times
        ;"$$REPLACE^XLFSTR(s,.spec) -- Uses a multi-character $TRanslate to return a
        ;"                                string with the specified string replaced
        ;"        s=input string, spec=array passed by reference
        ;"        spec format:
        ;"        spec("Any_Search_String")="Replacement_String"
        ;"$$STRIP^XLFSTR(s,Char) -- returns string striped of all instances of Char 
        ;"=======================================================================
        ;
        ;
CAPWORDS(S,DIV)  ;
               ;"Purpose: convert each word in the string: '
               ;"       'test string' --> 'Test String'
               ;"       'TEST STRING' --> 'Test String'
               ;"Input: S -- the string to convert
               ;"        DIV -- [OPTIONAL] the character used to separate string (default is ' ' [space])
               ;"Result: returns the converted string
               NEW S2,PART,IDX
               NEW RESULT SET RESULT=""
               SET DIV=$GET(DIV," ")
               SET S2=$$LOW^XLFSTR(S)
               ;
               FOR IDX=1:1 DO  QUIT:PART=""
               . SET PART=$PIECE(S2,DIV,IDX)
               . IF PART="" QUIT
               . SET $EXTRACT(PART,1)=$$UP^XLFSTR($EXTRACT(PART,1))
               . IF RESULT'="" SET RESULT=RESULT_DIV
               . SET RESULT=RESULT_PART
               ;
               QUIT RESULT
               ;
CLEAVSTR(TMGTEXT,TMGDIV,TMGPARTB)       ;
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
               IF '$DATA(TMGTEXT) GOTO CSDONE
               IF '$DATA(TMGDIV) GOTO CSDONE
               SET TMGPARTB=""
               NEW TMGPARTA
               IF TMGTEXT[TMGDIV DO
               . SET TMGPARTA=$PIECE(TMGTEXT,TMGDIV,1)
               . SET TMGPARTB=$PIECE(TMGTEXT,TMGDIV,2,256)
               . SET TMGTEXT=TMGPARTA
CSDONE   QUIT
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
SETSTLEN(TMGTEXT,TMGWIDTH)      ;SET STRING LEN
               ;"PUBLIC FUNCTION
               ;"Purpose: To make string exactly TMGWIDTH in length
               ;"  Shorten as needed, or pad with terminal spaces as needed.
               ;"Input: TMGTEXT -- should be passed as reference.  This is string to alter.
               ;"       TMGWIDTH -- the desired width
               ;"Results: none.
               SET TMGTEXT=$GET(TMGTEXT)
               SET TMGWIDTH=$GET(TMGWIDTH,80)
               NEW TMGRESULT SET TMGRESULT=TMGTEXT
               NEW TMGI,LEN
               SET LEN=$LENGTH(TMGRESULT)
               IF LEN>TMGWIDTH DO
               . SET TMGRESULT=$EXTRACT(TMGRESULT,1,TMGWIDTH)
               ELSE  IF LEN<TMGWIDTH DO
               . FOR TMGI=1:1:(TMGWIDTH-LEN) SET TMGRESULT=TMGRESULT_" "
               SET TMGTEXT=TMGRESULT  ;"pass back changes
               QUIT
               ;      
PAD2POS(POS,CH) ;
               ;"Purpose: return a string that can be used to pad from the current $X
               ;"         screen cursor position, up to POS, using char Ch (optional)
               ;"Input: POS -- a screen X cursor position, i.e. from 1-80 etc (depending on screen width)
               ;"       CH -- Optional, default is " "
               ;"Result: returns string of padded characters.
               NEW WIDTH SET WIDTH=+$GET(POS)-$X IF WIDTH'>0 SET WIDTH=0
               QUIT $$LJ^XLFSTR("",WIDTH,.CH)
               ;
SPLITLN(STR,LINEARRAY,WIDTH,SPECIALINDENT,INDENT,DIVSTR)         ;"SPLIT LINE
               ;"Scope: PUBLIC FUNCTION
               ;"Purpose: To take a long line, and wrap into an array, such that each
               ;"        line is not longer than WIDTH.
               ;"        Line breaks will be made at spaces (or DIVSTR), unless there are 
               ;"        no spaces (of divS) in the entire line (in which case, the line
               ;"        will be divided at WIDTH).
               ;"Input: STR= string with the long line. **If passed by reference**, then
               ;"                it WILL BE CHANGED to equal the last line of array.
               ;"       LineArray -- MUST BE PASSED BY REFERENCE. This OUT variable will
               ;"                receive the resulting array.
               ;"                e.g. LineArray(1)=first Line.
               ;"                     LineArray(2)=Second Line. ...
               ;"       WIDTH = the desired wrap width.
               ;"       SPECIALINDENT [OPTIONAL]: if 1, then wrapping is done like this:
               ;"                "   This is a very long line......"
               ;"           will be wrapped like this:
               ;"                "   This is a very
               ;"                "   long line ...
               ;"          Notice that the leading space is copied subsequent line.
               ;"          Also, a line like this:
               ;"                "   1. Here is the beginning of a paragraph that is very long..."
               ;"            will be wrapped like this:
               ;"                "   1. Here is the beginning of a paragraph
               ;"                "      that is very long..."
               ;"          Notice that a pattern '#. ' causes the wrapping to match the start
               ;"                of the text on the line above.
               ;"       INDENT [OPTIONAL]: Any absolute amount that all lines should be indented by.
               ;"                This could be used if this long line is continuation of an
               ;"                indentation above it.
               ;"       DIVSTR [OPTIONAL] : Default is " ", this is the divider character 
               ;"                         or string, that will represent dividers between
               ;"                         words or phrases
               ;"Result: resulting number of lines (1 if no wrap needed).
               ;
               NEW RESULT SET RESULT=0
               KILL LINEARRAY
               IF ($GET(STR)="")!($GET(WIDTH)'>0) GOTO SPDONE
               NEW INDEX SET INDEX=0
               NEW TEMPSTR,SPLITPOINT
               SET DIVSTR=$GET(DIVSTR," ")
               NEW PRESPACE SET PRESPACE=$$NEEDEDWS(STR,.SPECIALINDENT,.INDENT)
               ;
               IF ($LENGTH(STR)>WIDTH) FOR  DO  QUIT:($LENGTH(STR)'>WIDTH)
               . FOR SPLITPOINT=1:1:WIDTH DO  QUIT:($LENGTH(TEMPSTR)>WIDTH)
               . . SET TEMPSTR=$PIECE(STR,DIVSTR,1,SPLITPOINT)
               . IF SPLITPOINT>1 DO
               . . SET TEMPSTR=$PIECE(STR,DIVSTR,1,SPLITPOINT-1)
               . . SET STR=$PIECE(STR,DIVSTR,SPLITPOINT,WIDTH)
               . ELSE  DO
               . . ;"We must have a word > WIDTH with no spaces--so just divide
               . . SET TEMPSTR=$EXTRACT(STR,1,WIDTH)
               . . SET STR=$EXTRACT(STR,WIDTH+1,999)
               . SET INDEX=INDEX+1
               . SET LINEARRAY(INDEX)=TEMPSTR
               . SET STR=PRESPACE_STR
               ;
               SET INDEX=INDEX+1
               SET LINEARRAY(INDEX)=STR
               SET RESULT=INDEX
SPDONE   QUIT RESULT
               ;
SPLIT2AR(TEXT,DIVIDER,ARRAY,INITINDEX)   ;"CleaveToArray
               ;"Purpose: To take a string, delineated by 'divider' and
               ;"        to split it up into all its parts, putting each part
               ;"        into an array.  e.g.:
               ;"        This/Is/A/Test, with '/' divider would result in
               ;"        ARRAY(1)="This"
               ;"        ARRAY(2)="Is"
               ;"        ARRAY(3)="A"
               ;"        ARRAY(4)="Test"
               ;"        ARRAY(CMAXNODE)=4    ;CMAXNODE="MAXNODE"
               ;"Input: TEXT - the input string -- should NOT be passed by reference.
               ;"         DIVIDER - the delineating string
               ;"         ARRAY - The array to receive output **SHOULD BE PASSED BY REFERENCE.
               ;"         INITINDEX - OPTIONAL -- The index of the array to start with, i.e. 0 or 1. Default=1
               ;"Output: ARRAY is changed, as outlined above
               ;"Result: none
               ;"Notes:  Note -- TEXT is NOT changed (unless passed by reference, in
               ;"                which case the next to the last piece is put into TEXT)
               ;"        ARRAY is killed, the filled with data **ONLY** IF DIVISIONS FOUND
               ;"        Limit of 256 nodes
               ;"        if CMAXNODE is not defined, "MAXNODE" will be used
               SET INITINDEX=$GET(INITINDEX,1)
               NEW PARTB
               NEW COUNT SET COUNT=INITINDEX
               NEW CMAXNODE SET CMAXNODE=$GET(CMAXNODE,"MAXNODE")
               KILL ARRAY  ;"Clear out any old data
               ;
C2AL1     IF '(TEXT[DIVIDER) DO  GOTO C2ADN
               . SET ARRAY(COUNT)=TEXT ;"put it all into line.
               . SET ARRAY(CMAXNODE)=COUNT
               DO CLEAVSTR(.TEXT,DIVIDER,.PARTB)
               SET ARRAY(COUNT)=TEXT
               SET ARRAY(CMAXNODE)=COUNT
               SET COUNT=COUNT+1
               IF '(PARTB[DIVIDER) DO  GOTO C2ADN
               . SET ARRAY(COUNT)=PARTB
               . SET ARRAY(CMAXNODE)=COUNT
               ELSE  DO  GOTO C2AL1
               . SET TEXT=$GET(PARTB)
               . SET PARTB=""
C2ADN     QUIT
               ;
NEEDEDWS(S,SPECIALINDENT,INDENT)        ;"NEEDED WHITE SPACE
               ;"Scope: PRIVATE/local
               ;"Purpose: Evaluate the line, and create the white space string
               ;"        need for wrapped lines
               ;"Input: s -- the string to eval.  i.e.
               ;"                "  John is very happy today ... .. .. .. .."
               ;"        or      "  1. John is very happy today ... .. .. .. .."
               ;"        SPECIALINDENT -- See SplitLine() discussion
               ;"        INDENT -- See SplitLine() discussion
               NEW RESULT SET RESULT=""
               IF $GET(S)="" GOTO NDWSDN
               NEW WSNUM SET WSNUM=+$GET(INDENT,0)
               SET WSNUM=WSNUM+$$NUMLWS(S)
               ;
               IF $GET(SPECIALINDENT)=1 DO
               . NEW TEMPS,FIRSTWORD
               . SET TEMPS=$$TRIM^XLFSTR(.S,"l")
               . SET FIRSTWORD=$PIECE(TEMPS," ",1)
               . IF (FIRSTWORD?.N1".")!(FIRSTWORD?1.4U1".") DO     ;"match for '#.' pattern
               . . SET WSNUM=WSNUM+$LENGTH(FIRSTWORD)
               . . SET TEMPS=$PIECE(TEMPS," ",2,9999)
               . . SET WSNUM=WSNUM+$$NUMLWS(.TEMPS)+1
               ;
               SET RESULT=$$MAKEWS(WSNUM)
NDWSDN   QUIT RESULT
               ;
NUMLWS(S)        ;"NUM LEFT WHITE SPACE
               ;"Scope: PUBLIC FUNCTION
               ;":Purpose: Count the num of white space characters on left side of the string
               NEW RESULT SET RESULT=0
               NEW I FOR I=1:1:$LENGTH(S) QUIT:$EXTRACT(S,I)'=" "  SET RESULT=RESULT+1
               QUIT RESULT
               ;
MAKEWS(N)        ;"MAKE WHITE SPACE
               ;"Scope: PUBLIC FUNCTION
               ;"Purpose: Return a whitespace string that is n characters long
               NEW RESULT SET RESULT=""
               SET N=+$GET(N)
               NEW I FOR I=1:1:N SET RESULT=RESULT_" "
MWSDN     QUIT RESULT
               ;
