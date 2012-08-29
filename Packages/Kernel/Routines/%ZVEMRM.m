%ZVEMRM ;DJB,VRR**Menu Bar ; 12/17/00 4:08pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;Because of FndTag/LctStrng, I need to be able to change the lines
 ;displayed when exiting back to edit mode. FLAGMENU allows this.
 NEW FLAGMENU
 S FLAGMENU=YND_"^"_VEET("TOP")_"^"_YCUR_"^"_XCUR
 ;-> Do PAGE and then set scroll variables to new values.
 D PAGE
 S YND=$P(FLAGMENU,"^",1)
 S VEET("TOP")=$P(FLAGMENU,"^",2)
 S YCUR=$P(FLAGMENU,"^",3)
 Q
 ;
PAGE ;Get users response
 NEW KEY,XCHAR,XCUR,YCUR,YND,CD,CDHLD
PAGE1 S DX=0,DY=VEET("S2")+1 X VEES("CRSR")
 W @VEES("BLANK_C_EOL")
 S DX=8 X VEES("CRSR")
 W "[  ]  <RET>=Quit  R=Rtn  F=FndTg  L=LctStrg  G=Goto  ?=Help  M=More..."
 S DX=0 X VEES("CRSR")
 W @VEE("RON"),"Select:",@VEE("ROFF")
 S DX=9 X VEES("CRSR")
PAGE2 S KEY=$$READ^%ZVEMKRN(),KEY=$$ALLCAPS^%ZVEMKU(KEY)
 Q:KEY="^"
 Q:",<ESC>,<F1E>,<F1Q>,<RET>,<TO>,"[(","_VEE("K")_",")
 ;-> No editing if using the Rtn Reader
 I ",J,LC,SV,"[(","_KEY_","),$G(FLAGVPE)'["EDIT" D  Q
 . S (XCUR,YCUR)=0 D MSG^%ZVEMRUM(5)
 I ",?,ASC,FMC,I,RS,SV,VEDD,VGL,"[(","_KEY_",") D MODULES Q
 I VEE("K")="<ESCH>" D MODULES Q
 I KEY="CALL" D ^%ZVEMRID Q  ;.............Insert programmer call
 I KEY="F" D TAG^%ZVEMRMS Q
 I KEY="L" D LOCATE Q
 I KEY="G" D GOTO^%ZVEMRM1 Q
 I KEY="J" D JOIN^%ZVEMREJ Q
 I KEY="JC" D JOINA^%ZVEMREJ Q
 I KEY="LC" D ^%ZVEMRM2 Q
 I KEY="M" D MORE^%ZVEMRM1 G PAGE1
 I KEY="P" D PARAM^%ZVEMRM1 Q
 I KEY="PUR" D PUR Q
 I KEY="R" D ROUTINE Q
 I KEY="S" D SIZE Q
 W $C(7)
 G PAGE1
 ;
ROUTINE ;Branch to a routine
 D SYMTAB^%ZVEMKST("C","VRR",VRRS) ;.......Save/Clear symbol table
 D ENDSCR^%ZVEMKT2
 ;-> MSM NT needs this or no form feed occurs
 I $G(^%ZOSF("OS"))["MSM for Windows NT" H 1
 W !?1,"***BRANCH TO A ROUTINE***",!
 D START^%ZVEMR
 D SYMTAB^%ZVEMKST("R","VRR",VRRS) ;.......Restore symbol table
 Q
 ;
LOCATE ;Locate String
 NEW HELP,PROMPT,TXT
 S PROMPT=" STRING"
 S HELP="   Enter text & I'll search for matching string."
 S TXT=$$GETTEXT^%ZVEMRM2(PROMPT,HELP) Q:TXT']""
 ;S VRRFIND=TXT_$C(127)_KEY,YND=$P(FLAGMENU,"^",1)
 S VRRFIND=TXT
 S YND=$P(FLAGMENU,"^",1)
 D LCTSTRG^%ZVEMRM1(TXT)
 Q
 ;
LOCATE1 ;Called by <ESC>N (Find Next) in EDIT mode
 NEW FLAGMENU,TXT
 S VRRFIND=$G(VRRFIND)
 S TXT=$P(VRRFIND,$C(127),1)
 Q:TXT']""
 S FLAGMENU=YND_"^"_VEET("TOP")_"^"_YCUR_"^"_XCUR
 D LCTSTRG^%ZVEMRM1(TXT)
 S YND=$P(FLAGMENU,"^",1)
 S VEET("TOP")=$P(FLAGMENU,"^",2)
 S YCUR=$P(FLAGMENU,"^",3)
 Q
 ;
MODULES ;VGL,VEDD
 D ENDSCR^%ZVEMKT2
 I KEY="?"!(VEE("K")="<ESCH>") D HELP^%ZVEMKT("VRR1") Q
 I KEY="ASC",$G(VEESHL)="RUN" D ASCII^%ZVEMST,PAUSE^%ZVEMKC(1) Q
 I KEY="FMC",$G(VEESHL)="RUN" D ^%ZVEMSF Q
 I KEY="I" D INDEX^%ZVEMRMG Q  ;....................Run %INDEX
 I KEY="RS" D  D RSE^%ZVEMRY Q
 . W !?1,"***SEARCH ROUTINE(S)***"
 I KEY="SV" S FLAGQ=1 D SAVE^%ZVEMRMS S FLAGQ=0 Q  ;Save on the fly
 I KEY="VEDD" D  D VEDD^%ZVEMRY Q
 . W !?1,"***ELECTRONIC DATA DICTIONARY***",!
 I KEY="VGL" D  D VGL^%ZVEMRY Q
 . W !?1,"***GLOBAL LISTER***"
 Q
 ;
SIZE ;Display size of routine
 NEW NAM,XX,Y
 S DX=0,DY=VEET("S2")+1 X VEES("CRSR")
 W @VEES("BLANK_C_EOL")
 I '$D(^%ZOSF("SIZE")) D  R XX:50 Q
 . W "  Global node ^%ZOSF(""SIZE"") must be available.."
 I '$D(^TMP("VEE","VRR",$J,VRRS,"NAME")) D  R XX:50 Q
 . W "  Routine name unknown.."
 S (NAM,Y)=^("NAME") X "ZL @Y X ^%ZOSF(""SIZE"")"
 W "  ^",NAM,".....Routine size = ",Y R XX:50
 Q
 ;
PUR ;Purge clipboard
 NEW TMP
 D ENDSCR^%ZVEMKT2
 W !?1,"*** WARNING ***"
 W !!?1,"This option will purge the clipboard. If anyone is currently using the"
 W !?1,"editor and has saved lines to the clipboard, these lines will be lost."
 W ! S TMP=$$YN^%ZVEMKU1(" Shall I continue? ",1)
 I TMP=1 KILL ^%ZVEMS("E","SAVEVRR")
 W !!?1,"Clipboard",$S(TMP'=1:" not",1:"")," purged.."
 D PAUSE^%ZVEMKC(2)
 Q
 ;
REDRAW ;Redraw screen
 NEW DX,DY,I,TMP
 D SCROLL^%ZVEMKT2(1)
 S DY=VEET("S1")-2
 F I=VEET("TOP"):1:(VEET("BOT")-1) D  ;
 . S DX=0,DY=DY+1 X VEES("CRSR")
 . S TMP=$G(^TMP("VEE","IR"_VRRS,$J,I))
 . W $P(TMP,$C(30),1)
 . W $P(TMP,$C(30),2,99)
 Q
