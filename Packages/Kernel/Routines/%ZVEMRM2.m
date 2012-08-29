%ZVEMRM2 ;DJB,VRR**Locate & Change ; 7/25/99 9:49pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
TOP ;
 NEW HELP,LN1,LN2,ND1,ND2,OFF,OLD,ON,NEW
 S HELP="   Enter code you want replaced.."
 S OLD=$$GETTEXT("REPLACE",HELP) G:OLD']"" EX
 S HELP="   Enter replacement code.."
 S NEW=$$GETTEXT("   WITH",HELP)
 D LINE G:LN1'>0 EX
 S @("ON="_VEE("RON")),@("OFF="_VEE("ROFF"))
 D LOCATE
EX ;
 KILL ^TMP("VEE","SAVE",$J)
 Q
 ;===================================================================
LINE ;Get start and end line numbers
 S HELP="   Enter starting line # of range you want edited.."
 S LN1=$$GETLINE^%ZVEMREJ("STARTING LINE",HELP)
 Q:LN1'>0
 S ND1=$$GETNODE^%ZVEMRU(LN1)
 I ND1=0 W $C(7) G LINE
 S HELP="   Enter ending line # of range you want edited.."
 S LN2=$$GETLINE^%ZVEMREJ("  ENDING LINE",HELP)
 G:LN2'>0 LINE
 S ND2=$$GETNODE^%ZVEMRU(LN2)
 I ND2<ND1 W $C(7) G LINE
 Q
GETTEXT(PROMPT,HELP) ;Get text from user. Maximum of 65 characters.
 ;Return: null if no text is entered.
 NEW TXT
 S PROMPT=$G(PROMPT)
 S HELP=$G(HELP)
 S DX=0,DY=VEET("S2")+1 X VEES("CRSR") W @VEES("BLANK_C_EOL")
 X VEES("CRSR") W @VEE("RON")," "_PROMPT_":",@VEE("ROFF")
GETTEXT1 S DX=$L(PROMPT)+3 X VEES("CRSR") W @VEES("BLANK_C_EOL")
 X VEES("CRSR") S TXT=$$READ^%ZVEMKRN("",65)
 ;--> The following codes are only returned if TXT="".
 I ",<ESC>,<F1E>,<F1Q>,<RET>,<TO>,"[(","_VEE("K")_",") Q ""
 I TXT="?"!(VEE("K")="<ESCH>"),HELP]"" D  G GETTEXT1
 . S DX=$L(PROMPT)+2 X VEES("CRSR") W @VEES("BLANK_C_EOL")
 . X VEES("CRSR") W HELP D PAUSE^%ZVEMKC(0)
 Q TXT
 ;===================================================================
LOCATE ;Locate nodes that contain TXT1
 NEW ADJUST,ASK,FLAGQ,I,LN,TG,TMP
 S FLAGQ=0
 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,ND1))
 I TMP=" <> <> <>" W $C(7) Q
 KILL ^TMP("VEE","SAVE",$J)
 S ^($J,ND1)="",YND=ND1
 S TG=$P(TMP,$C(30),1)
 S LN=$P(TMP,$C(30),2,999)
 F I=ND1+1:1 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,I)) D  Q:FLAGQ
 . I TMP']"" S FLAGQ=1 Q
 . I TMP=" <> <> <>" S FLAGQ=1 D:LN[OLD CHANGE Q
 . ;-> Scrolled part of line
 . I TMP'[$C(30) S LN=LN_$E(TMP,10,999),^TMP("VEE","SAVE",$J,I)="" Q
 . D:LN[OLD CHANGE Q:FLAGQ
 . S LN1=LN1+1 ;Show line # when asking to change.
 . I I>ND2 S FLAGQ=1 Q
 . S TG=$P(TMP,$C(30),1)
 . S LN=$P(TMP,$C(30),2,999)
 . KILL ^TMP("VEE","SAVE",$J)
 . S I=I+$G(ADJUST),ND2=ND2+$G(ADJUST) ;Adj for Del/Paste line# diff
 . S YND=I
 . S ^TMP("VEE","SAVE",$J,YND)=""
 Q
CHANGE ;Change TXT1 to TXT2
 ;ADJ will adjust START if NEW & OLD are different lengths
 ;--> Delete array: ^TMP("VEE","SAVE",$J)
 ;--> Paste array:  ^%ZVEMS("E","SAVEVRR",$J)
 NEW ADJ,FD,I,SHOW,START
 S FLAGSAVE=1
 S START=0
 S ADJ=$L(NEW)-$L(OLD)
 F I=1:1:($L(LN,OLD)-1) D  Q:FLAGQ
 . S FD=$F(LN,OLD,START)
 . S START=FD+ADJ
 . ;-> Used by ASK to display code to be changed
 . S SHOW=LN1_". "_$E(LN,(FD-$L(OLD)-7),FD-$L(OLD)-1)
 . S SHOW=SHOW_ON_OLD_OFF_$E(LN,FD,FD+6)
 . D:$G(ASK)'="A" ASK Q:ASK="N"!FLAGQ
 . S LN=$E(LN,1,(FD-$L(OLD)-1))_NEW_$E(LN,FD,999)
 S LN=TG_$C(30)_LN
 S ^%ZVEMS("E","SAVEVRR",$J,1)=$E(LN,1,VEE("IOM")-1)
 S LN=$E(LN,VEE("IOM"),9999)
 F I=2:1 Q:LN']""  D  ;
 . S ^%ZVEMS("E","SAVEVRR",$J,I)=$J("",9)_$E(LN,1,VEE("IOM")-11)
 . S LN=$E(LN,VEE("IOM")-10,9999)
 S ^%ZVEMS("E","SAVEVRR",$J,I)=""
 D ADJUST
 D DELETE^%ZVEMRP1(1)
 S YND=YND-1
 D PASTE^%ZVEMRP1
 Q
ASK ;
 NEW ZDY
 S ZDY=DY
ASK1 S DX=0,DY=ZDY-4 X VEES("CRSR") W @VEES("BLANK_C_EOS")
 X VEES("CRSR") W "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
 S DX=0,DY=ZDY-3 X VEES("CRSR") W "REPLACE: "_SHOW
 S DX=0,DY=ZDY-2 X VEES("CRSR") W "   WITH: ",ON,NEW,OFF
 S DX=0,DY=ZDY-1 X VEES("CRSR")
 W "Replace?  Y=Yes  N=No  A=YesToAll   Select: "
 S DX=0,DY=ZDY
 X VEES("CRSR") W "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
 S DX=44,DY=ZDY-1 X VEES("CRSR")
 S DY=ZDY
 R ASK:300 S:'$T ASK="^" I "^"[ASK S FLAGQ=1
 S ASK=$E(ASK) I "AaNnYy^"'[ASK W $C(7) G ASK1
 S ASK=$S("Yy"[ASK:"Y","Aa"[ASK:"A",1:"N")
 Q:ASK'="A"
 S DX=0,DY=ZDY-3 X VEES("CRSR") W @VEES("BLANK_C_EOS")
 S DX=0,DY=ZDY-2 X VEES("CRSR") W "Please wait.."
 S DX=0,DY=ZDY
 X VEES("CRSR") W "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
 S DY=ZDY
 Q
ADJUST ;Adjust for difference between lines deleted and lines pasted
 NEW DELETE,PASTE,X
 S (DELETE,PASTE,X)=0
 F  S X=$O(^TMP("VEE","SAVE",$J,X)) Q:X'>0  S DELETE=DELETE+1
 ;-> Can't use reverse $O due to nature of ^%ZVEMS("E","SAVEVRR")
 S X=0
 F  S X=$O(^%ZVEMS("E","SAVEVRR",$J,X)) Q:'X!(^(X)="")  S PASTE=PASTE+1
 S ADJUST=PASTE-DELETE
 Q
