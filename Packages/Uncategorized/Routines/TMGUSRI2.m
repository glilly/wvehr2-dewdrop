TMGUSRI2        ;TMG/kst/SACC-compliant USER INTERFACE API FUNCTIONS ;7/17/12
                ;;1.0;TMG-LIB;**1,17**;07/17/12;Build 23
        ;
        ;"TMG USER INTERFACE API FUNCTIONS
        ;"SACC-Compliant version
        ;"Kevin Toppenberg MD
        ;"GNU General Public License (GPL) applies
        ;"7-17-12
        ;
        ;"NOTE: This will contain SACC-compliant versions of code from TMGUSRIF
        ;"      If routine is not found here, the please migrate the code 
        ;"=======================================================================
        ;" API -- Public Functions.
        ;"=======================================================================
        ;"POPUPBOX(TMGHEADER,TMGTEXT,TMGWIDTH) -- Provide an easy text output box
        ;"PUARRAY(TMGINDENTW,TMGWIDTH,TMGARRAY,TMGMODAL) -- Draw a box and display text
        ;"PRESS2GO -- Provide a 'press key to continue' action
        ;"KEYPRESD(WANTCH,WAITTIME)  -- Check for a keypress
        ;"USRABORT(ABORTLABEL) -- Checks if user pressed ESC key.  If so, verify 
        ;"PROGBAR(VALUE,LABEL,MIN,MAX,WIDTH,STARTTIME)  -- Animate a progress bar
        ; 
        ;"=======================================================================
        ;"Private Functions
        ;"=======================================================================
        ;
        ;"=======================================================================
        ;"DEPENDENCIES: TMGSTUT2, TMGTERM
        ;"=======================================================================
        ;
POPUPBOX(TMGHEADER,TMGTEXT,TMGWIDTH,TMGINDENT)  ;
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
               . DO CLEAVSTR^TMGSTUT2(.TMGTEXT,TMGNEWLN,.TMGPARTB1)
               DO SPLITSTR^TMGSTUT2(.TMGTEXT,(TMGWIDTH-4),.TMGPARTB)
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
               ;"Result: None
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
               DO SETSTLEN^TMGSTUT2(.TMGHEADER,TMGWIDTH-4)
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
PUBLOOP IF INDEX="" GOTO BTMLINE
               SET S=$GET(TMGARRAY(INDEX)," ")
               DO SETSTLEN^TMGSTUT2(.S,TMGWIDTH-4)
               FOR TMGI=1:1:TMGINDENTW WRITE " "
               WRITE "| ",S," | :",!
               SET INDEX=$ORDER(TMGARRAY(INDEX))
               GOTO PUBLOOP
               ;
BTMLINE ;"Draw Bottom line
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
PUADONE QUIT
               ;
PRESS2GO        ;"PRESS TO CONTINUE / PRESSTOCONT
               ;"Purpose: to provide a 'press key to continue' action
               ;"RESULT: none
               ;"Output: will SET TMGPTCABORT=1 if user entered ^
               NEW STR SET STR="----- Press Key To Continue -----"
               NEW LENSTR SET LENSTR=$LENGTH(STR)
               WRITE STR
               NEW CH SET CH=$$KEYPRESD(0,240)
               IF (CH=94) SET TMGPTCABORT=1  ;"set abort user entered ^
               ELSE  KILL TMGPTCABORT
               DO CUB^TMGTERM(LENSTR)
               SET $X=$X-LENSTR
               NEW I FOR I=1:1:LENSTR WRITE " "
               DO CUB^TMGTERM(LENSTR)
               SET $X=$X-LENSTR
               ;"WRITE !
               QUIT
               ;
KEYPRESD(WANTCH,WAITTIME)        ;
               ;"Purpose: to check for a keypress
               ;"Input: WANTCH -- OPTIONAL, if 1, then Character is returned, not ASCII value
               ;"       WAITTIME -- OPTIONAL, default is 0 (immediate return)
               ;"Result: ASCII value of key, if pressed, -1 otherwise ("" if WANTCH=1)
               ;"Note: this does NOT wait for user to press key
               NEW INITXGRT SET INITXGRT=($DATA(XGRT)'=0)
               IF 'INITXGRT DO INITKB^XGF("*")
               NEW TEMP SET TEMP=$$READ^XGF(1,+$GET(WAITTIME))
               IF $GET(WANTCH)'=1 SET TEMP=$ASCII(TEMP)
               IF 'INITXGRT DO RESETKB^XGF
               QUIT TEMP
               ;
               ;"SET WAITTIME=$GET(WAITTIME,0)
               ;"READ *TEMP:WAITTIME   //<--- NOT SACC COMPLIANT
               ;"IF $GET(WANTCH)=1 SET TEMP=$CHAR(TEMP)
               ;"QUIT TEMP
               ;
USRABORT(ABORTLABEL)     ;
               ;"Purpose: Checks if user pressed ESC key.  If so, then ask if abort wanted
               ;"Note: return is immediate.
               ;"Returns: 1 if user aborted, 0 if not.
               NEW RESULT SET RESULT=0
               IF $$KEYPRESD=27 DO
               . NEW % SET %=2
               . WRITE !,"Abort"
               . IF $GET(ABORTLABEL)'="" DO
               . . WRITE " "_ABORTLABEL
               . DO YN^DICN WRITE !
               . SET RESULT=(%=1)
               QUIT RESULT
               ;
PROGBAR(VALUE,LABEL,MIN,MAX,WIDTH,STARTTIME)     ;"ProgressBar
               ;"Purpose: to draw a progress bar on a line of the screen
               ;"Input:   VALUE -- the current value to graph out
               ;"         LABEL -- OPTIONAL -- a label to describe progres.  Default="Progress"
               ;"         MIN -- OPTIONAL -- the minimal number that value will be.  Default is 0
               ;"                      if MAX=-1 and MIN=-1 then turn on spin mode (see below)
               ;"         MAX -- OPTIONAL -- the max number that value will be. Default is 100
               ;"                      if MAX=-1 and MIN=-1 then turn on spin mode (see below)
               ;"         WIDTH -- OPTIONAL -- the number of characters that the progress bar
               ;"                              will be in WIDTH.  Default is 70
               ;"         STARTTIME -- OPTIONAL -- start time of process.  If provided, it will
               ;"              be used to determine remaining time.  Format should be same as $H
               ;"Note: will use global ^TMP("TMG","PROGRESS-BAR",$J)
               ;"Note: bar will look like this:
               ;"              Progress:  27%-------->|-----------------------------------| (Time)
               ;"Note--Spin Mode: To show motion without knowing the max amount, a spin mode is needed.
               ;"              Progress:  |-----<==>--------------------------------------|
               ;"              And the bar will move back and forth.
               ;"              In this mode, value is ignored and is thus optional.
               ;"              To use this mode, set MAX=-1,MIN=-1
               ;"Result: None
               ;
               ;"FYI -- The preexisting way to do this, from Dave Whitten
               ;"
               ;"Did you try using the already existing function to do this?
               ;"ie: try out this 'mini program'
               ;">; need to set up vars like DUZ,DTIME, IO, IO(0), etc.
               ;" D INIT^XPDID
               ;" S XPDIDTOT=100
               ;" D TITLE^XPDID("hello world")
               ;" D UPDATE^XPDID(50)
               ;" F AJJ=90:1:100 D UPDATE^XPDID(I)
               ;" D EXIT^XPDID()
               ;"
               ;"The XPDID routine does modify the scroll region and make the
               ;"application seem a bit more "GUI"-like, by the way...
               ;"
               ;"David
               ;
               DO  ;"Turn off cursor display, to prevent flickering
               . NEW $ETRAP SET $ETRAP=""
               . XECUTE ^%ZOSF("TRMOFF")
               ;
               NEW PREMARK,TEMPI,POSTMARK,PCT
               NEW REFCT SET REFCT=$NAME(^TMP("TMG","PROGRESS-BAR",$J))
               SET MAX=+$GET(MAX,100),MIN=+$GET(MIN,0)
               SET WIDTH=+$GET(WIDTH,70)
               SET LABEL=$GET(LABEL,"Progress")
               ;
               NEW SPINMODE SET SPINMODE=((MAX=-1)&(MIN=-1))
               IF SPINMODE GOTO SPIN1  ;"<-- skip all this for spin mode
               ;
               IF (MAX-MIN)=0 SET PCT=0
               ELSE  SET PCT=(VALUE-MIN)/(MAX-MIN)
               IF PCT>1 SET PCT=1
               IF PCT<0 SET PCT=0
               IF (PCT<1)&($GET(STARTTIME)="") SET STARTTIME=$H
               ;
               SET STARTTIME=$GET(STARTTIME)  ;" +$GET 61053,61748 --> 61053
               ;
               NEW BARBERPOLE SET BARBERPOLE=+$GET(@REFCT@("BARBER POLE"))
               IF $GET(@REFCT@("BARBER POLE","LAST INC"))'=$H DO
               . SET BARBERPOLE=(BARBERPOLE-1)#4
               . SET @REFCT@("BARBER POLE")=BARBERPOLE ;"should be 0,1,2, or 3)
               . SET @REFCT@("BARBER POLE","LAST INC")=$H
               ;
               NEW CURRATE SET CURRATE=""
               IF $GET(@REFCT@("START-TIME"))=STARTTIME DO
               . NEW INTERVAL SET INTERVAL=$GET(@REFCT@("SAMPLING","INTERVAL"),10)
               . SET CURRATE=$GET(@REFCT@("LATEST-RATE"))
               . NEW COUNT SET COUNT=$GET(@REFCT@("SAMPLING","COUNT"))+1
               . IF COUNT#INTERVAL=0 DO
               . . NEW DELTATIME,DELTAVAL
               . . SET DELTATIME=$$HDIFF^XLFDT($H,$GET(@REFCT@("SAMPLING","REF-TIME")),2)
               . . IF DELTATIME=0 SET INTERVAL=INTERVAL*2
               . . ELSE  IF DELTATIME>1000 SET INTERVAL=INTERVAL\1.5
               . . SET DELTAVAL=VALUE-$GET(@REFCT@("SAMPLING","VALUE COUNT"))
               . . IF DELTAVAL>0 SET CURRATE=DELTATIME/DELTAVAL  ;"dT/dValue
               . . ELSE  SET CURRATE=""
               . . SET @REFCT@("LATEST-RATE")=CURRATE
               . . SET @REFCT@("SAMPLING","REF-TIME")=$H
               . . SET @REFCT@("SAMPLING","VALUE COUNT")=VALUE
               . SET @REFCT@("SAMPLING","COUNT")=COUNT#INTERVAL
               . SET @REFCT@("SAMPLING","INTERVAL")=INTERVAL
               ELSE  DO
               . KILL @REFCT
               . SET @REFCT@("START-TIME")=STARTTIME
               . SET @REFCT@("SAMPLING","COUNT")=0
               . SET @REFCT@("SAMPLING","REF-TIME")=$H
               . SET @REFCT@("SAMPLING","VALUE COUNT")=VALUE
               ;
               NEW TIMESTR SET TIMESTR="  "
               NEW REMAININGTIME SET REMAININGTIME=""
               NEW DELTA SET DELTA=0
               ;
               IF CURRATE'="" DO
               . NEW REMAINVAL SET REMAINVAL=(MAX-VALUE)
               . IF REMAINVAL'<0 DO
               . . SET REMAININGTIME=CURRATE*REMAINVAL
               . ELSE  DO
               . . SET DELTA=-1,REMAININGTIME=$$HDIFF^XLFDT($H,STARTTIME,2)
               ELSE  IF $DATA(STARTTIME) DO
               . IF PCT=0 QUIT
               . SET TIMESTR=""
               . SET DELTA=$$HDIFF^XLFDT($H,STARTTIME,2)
               . IF DELTA<0 SET REMAININGTIME=-DELTA ;"just report # sec's overrun.
               . SET REMAININGTIME=DELTA*((1/PCT)-1)
               ;
               IF REMAININGTIME'="" DO
               . NEW DAYS SET DAYS=REMAININGTIME\86400  ;"86400 sec per day.
               . IF DAYS>5 SET TIMESTR="<Stalled>  " QUIT
               . SET REMAININGTIME=REMAININGTIME#86400
               . NEW HOURS SET HOURS=REMAININGTIME\3600  ;"3600 sec per hour
               . SET REMAININGTIME=REMAININGTIME#3600
               . NEW MINUTES SET MINUTES=REMAININGTIME\60  ;"60 sec per min
               . NEW SECONDS SET SECONDS=(REMAININGTIME#60)\1
               . IF DAYS>0 SET TIMESTR=TIMESTR_DAYS_"d, "
               . IF HOURS>0 SET TIMESTR=TIMESTR_HOURS_"h:"
               . IF (MIN=0)&(SECONDS=0) DO
               . . SET TIMESTR="       "
               . ELSE  DO
               . . SET TIMESTR=TIMESTR_MINUTES_":"
               . . IF SECONDS<10 SET TIMESTR=TIMESTR_"0"
               . . SET TIMESTR=TIMESTR_SECONDS_"   "
               . IF DELTA<0 SET TIMESTR="+"_TIMESTR ;"just report # sec's overrun.
               ELSE  SET TIMESTR="?? Time"
               ;
               SET WIDTH=WIDTH-$LENGTH(LABEL)-($LENGTH(TIMESTR)+1)
               SET PREMARK=(WIDTH*PCT)\1
               SET POSTMARK=WIDTH-PREMARK
               ;
               IF (MAX-MIN)=0 SET PCT=0
               ELSE  SET PCT=(VALUE-MIN)/(MAX-MIN)
               IF PCT>1 SET PCT=1
               IF PCT<0 SET PCT=0
               IF (PCT<1)&($GET(STARTTIME)="") SET STARTTIME=$H
               ;
               WRITE LABEL,":"
               IF PCT<1 WRITE " "
               IF PCT<0.1 WRITE " "
               WRITE (PCT*100)\1,"% "
               FOR TEMPI=0:1:PREMARK-1 DO
               . IF (BARBERPOLE+TEMPI)#4=0 WRITE "~"
               . ELSE  WRITE "-"
               WRITE ">|"
               FOR TEMPI=1:1:(POSTMARK-1) WRITE "-"
               IF POSTMARK>0 WRITE "| "
               WRITE TIMESTR
               ;
               GOTO PBD1
               ;
SPIN1     NEW SPINBAR SET SPINBAR=+$GET(@REFCT@("SPIN BAR"))
               NEW SPINDIRECTION SET SPINDIRECTION=+$GET(@REFCT@("SPIN BAR","DIR")) ;"1=forward, -1=backwards
               IF SPINDIRECTION=0 SET SPINDIRECTION=1
               SET SPINBAR=SPINBAR+SPINDIRECTION
               IF SPINBAR>100 DO
               . SET SPINDIRECTION=-1
               . SET SPINBAR=100
               IF SPINBAR<0 DO
               . SET SPINDIRECTION=1
               . SET SPINBAR=0
               SET @REFCT@("SPIN BAR")=SPINBAR
               SET @REFCT@("SPIN BAR","DIR")=SPINDIRECTION
               SET @REFCT@("SPIN BAR","LAST INC")=$H
               ;
               NEW MARKER SET MARKER="<=>"
               SET WIDTH=WIDTH-$LENGTH(LABEL)-$LENGTH(MARKER)
               SET PCT=SPINBAR/100
               SET PREMARK=(WIDTH*PCT)\1
               SET POSTMARK=WIDTH-PREMARK
               ;
               WRITE LABEL," |"
               FOR TEMPI=0:1:PREMARK-1 WRITE "-"
               WRITE MARKER
               FOR TEMPI=1:1:(POSTMARK-1) WRITE "-"
               IF PCT<1 WRITE "-"
               WRITE "|"
               ;
PBD1       ;"WRITE $CHAR(13) SET $X=0
               WRITE !
               DO CUU^TMGTERM(1)
               ;
PBDONE   DO  ;"Turn cursor display back on.
               . ;"NEW $ETRAP SET $ETRAP=""
               . ;"XECUTE ^%ZOSF("TRMON")
               . ;"U $I:(TERMINATOR=$C(13,127))
               ;
               QUIT
               ;
MENU(OPTIONS,DEFCHOICE,USERRAW)  ;
               ;"Purpose: to provide a simple menuing system
               ;"Input:  OPTIONS -- PASS BY REFERENCE
               ;"        Format:
               ;"              OPTIONS(0)=Header Text   <--- optional, default is MENU
               ;"              OPTIONS(0,n)=Additional lines of header Text   <--- optional
               ;"              OPTIONS(DispNumber)=MenuText_$C(9)_ReturnValue <-- _$C(9)_ReturnValue OPTIONAL, default is DispNumber
               ;"              OPTIONS(DispNumber)=MenuText_$C(9)_ReturnValue
               ;"              OPTIONS(DispNumber)=MenuText_$C(9)_ReturnValue
               ;"              OPTIONS(-1,"COLOR","FG")=foreground color  (optional)
               ;"              OPTIONS(-1,"COLOR","BG")=foreground color  (optional)
               ;"        DEFCHOICE: OPTIONAL, the default menu value
               ;"        USERRAW : OPTIONAL, PASS BY REFERENCE, an OUT PARAMETER.  Returns users raw input
               ;"Results: The selected ReturnValue (or DispNumber if no ReturnValue provided), or ^ for abort
               NEW RESULT SET RESULT="^"
               NEW S,FG,BG,HDREXTRA
               NEW WIDTH SET WIDTH=50
               NEW LINE SET $PIECE(LINE,"=",WIDTH+1)=""
MNU1       IF $DATA(OPTIONS(-1,"COLOR")) DO
               . SET FG=$GET(OPTIONS(-1,"COLOR","FG"),0)
               . SET BG=$GET(OPTIONS(-1,"COLOR","BG"),1)
               . DO VCOLORS^TMGTERM(FG,BG)
               WRITE LINE,!
               WRITE $GET(OPTIONS(0),"MENU"),$$PAD2POS^TMGSTUT2(WIDTH),!
               SET HDREXTRA=0
               FOR  SET HDREXTRA=$ORDER(OPTIONS(0,HDREXTRA)) QUIT:HDREXTRA=""  DO
               . WRITE OPTIONS(0,HDREXTRA),$$PAD2POS^TMGSTUT2(WIDTH),!
               WRITE LINE,!
               WRITE "OPTIONS:",$$PAD2POS^TMGSTUT2(WIDTH),!
               ;
               NEW DISPNUMBER SET DISPNUMBER=$ORDER(OPTIONS(0))
               IF DISPNUMBER'="" FOR  DO  QUIT:(DISPNUMBER="")
               . SET S=$GET(OPTIONS(DISPNUMBER))
               . WRITE $$RJ^XLFSTR(DISPNUMBER,4),".",$$PAD2POS^TMGSTUT2(6)
               . IF $DATA(OPTIONS(DISPNUMBER,"COLOR")) DO
               . . SET FG=$GET(OPTIONS(DISPNUMBER,"COLOR","FG"),0)
               . . SET BG=$GET(OPTIONS(DISPNUMBER,"COLOR","BG"),1)
               . . DO VCOLORS^TMGTERM(FG,BG)
               . WRITE $PIECE(S,$CHAR(9),1),$$PAD2POS^TMGSTUT2(WIDTH-1)
               . IF $DATA(OPTIONS(DISPNUMBER,"COLOR")) DO
               . . DO VTATRIB^TMGTERM(0) ;"Reset colors
               . WRITE " ",!
               . SET DISPNUMBER=$ORDER(OPTIONS(DISPNUMBER))
               ;
               WRITE LINE,!
               ;
               SET DEFCHOICE=$GET(DEFCHOICE,"^")
               NEW INPUT
               WRITE "Enter selection (^ to abort): ",DEFCHOICE,"// "
               READ INPUT:$GET(DTIME,3600),!
               IF INPUT="" SET INPUT=DEFCHOICE
               SET USERRAW=INPUT
               IF INPUT="^" GOTO MNUDONE
               ;
               SET S=$GET(OPTIONS(INPUT))
               IF S="" SET S=$GET(OPTIONS($$UP^XLFSTR(INPUT)))
               ;"IF S="" WRITE "??",!! GOTO MNU1
               SET RESULT=$PIECE(S,$CHAR(9),2)
               IF RESULT="" SET RESULT=INPUT
               ;
MNUDONE IF $DATA(OPTIONS(-1,"COLOR")) DO VTATRIB^TMGTERM(0) ;"Reset colors
               QUIT RESULT
