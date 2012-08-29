%ZVEMGPI ;DJB,VGL**PIECES - Scroller Import [5/5/97 5:40pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
IMPORT ;Import text to the scroller
 D SETARRAY,LIST
 Q
GETVEET ;Set VEET=Display text
 S VEET=$G(^TMP("VEE","IGP",$J,VEET("BOT")))
 Q
LIST ;Display text
 D GETVEET W !,VEET
 S VEET("BOT")=VEET("BOT")+1
 S:VEET("GAP") VEET("GAP")=VEET("GAP")-1
 I VEET=" <> <> <>"!'VEET("GAP") D READ
 Q:FLAGTYPE["SWITCH"!FLAGQ!FLAGE
 Q:'$D(^TMP("VEE","IGP",$J,VEET("BOT")))
 G LIST
SETARRAY ;Set scroll array
 I $G(VEET)']""!($G(VEET)=" <> <> <>") D  Q
 . S ^TMP("VEE","IGP",$J,VEET("BOT"))=" <> <> <>"
 S ^TMP("VEE","IGP",$J,VEET("BOT"))=VEET
 Q
ENDFILE() ;1=End-of-file  0=Ok
 I VEET("GAP") W $C(7) Q 1
 I ^TMP("VEE","IGP",$J,VEET("BOT")-1)=" <> <> <>"  W $C(7) Q 1
 Q 0
READ ;Get input
 W @VEES("CON") ;Turn cursor back on
 D CURSOR^%ZVEMKU1(9,VEET("S2")+VEET("FT")-1,1)
 S KEY=$$READ^%ZVEMKRN()
 I ",^, ,"[(","_KEY_",") S FLAGQ=1 Q
 I ",<ESC>,<F1E>,<F1Q>,<TAB>,<TO>,"[(","_VEE("K")_",") S FLAGQ=1 Q
 I ",<HOME>,<F4AL>,"[(","_VEE("K")_",") S VEET("TOP")=1 D REDRAW^%ZVEMKT2() Q
 I ",<END>,<F4AR>,"[(","_VEE("K")_",") D BOTTOM^%ZVEMKT2("IGP") Q
 I VEE("K")="<AU>" D  G READ
 . I VEET("TOP")'>1 W $C(7) Q
 . D UP^%ZVEMKT1("IGP")
 I VEE("K")="<AD>" G:$$ENDFILE() READ D DOWN^%ZVEMKT1 Q
 I ",<PGUP>,<F4AU>,"[(","_VEE("K")_","),VEET("TOP")'>1 W $C(7) G READ
 I ",<PGUP>,<F4AU>,"[(","_VEE("K")_",") D LEFT^%ZVEMKT1 Q
 I ",<PGDN>,<F4AD>,<RET>,"[(","_VEE("K")_",") G:$$ENDFILE() READ D RIGHT^%ZVEMKT1 Q
 S KEY=$$ALLCAPS^%ZVEMKU(KEY)
 I VEE("K")'="<ESCH>",",?,I,M,X,"'[(","_KEY_","),KEY'?1.N W $C(7) G READ
 I KEY="I" S FLAGTYPE="I^SWITCH" Q
 I KEY="X" S FLAGTYPE="X^SWITCH" Q
 D ENDSCR^%ZVEMKT2
 I KEY["?" D HELP
 I VEE("K")="<ESCH>" D HELP^%ZVEMKT2
 I KEY?1.N D INDIV^%ZVEMGP(KEY) Q:FLAGQ!FLAGE
 D REDRAW^%ZVEMKT2()
 Q
HELP ;
 W !?1,"'n'.........: Enter number from center column to view data dictionary"
 W !?2,"I .........: Display internal values on right side of screen"
 W !?2,"X .........: Display external values on right side of screen"
 D PAUSE^%ZVEMKC(2)
 Q
START ;Use Scroller
 NEW HD,LINE,MAR,TMP
 S MAR=$G(VEE("IOM")) S:MAR'>0 MAR=80
 S $P(LINE,"=",MAR)=""
 S TMP=GLNAM I TMP["""" S TMP=$$QUOTES2^%ZVEMKU(TMP)
 S HD=" "_Z1_") "_TMP,HD=HD_$J("",(MAR-17-$L(HD)))
 S HD=HD_$S(TYPE="X":"[EXTERNAL VALUE]",1:"[INTERNAL VALUE]")
 S VEET("HD")=2,VEET("FT")=3
 S VEET("HD",1)=HD
 S VEET("HD",2)=LINE
 S VEET("FT",1)=LINE
 S VEET("FT",2)="<>  'n'=FldDD  I=IntVal  X=ExtVal  ?=Help  <ESCH>=ScrollHelp"
 S VEET("FT",3)=" Select: "
 S VEET("S1")=3,VEET("S2")=(VEE("IOSL")-3)
 S VEET("GET")="D SETARRAY^%ZVEMGY"
 D IMPORTS^%ZVEMKT("IGP")
 Q
FINISH ;Call here AFTER calling IMPORT
 I 'FLAGQ,'FLAGE S VEET=" <> <> <>" D IMPORT
 KILL ^TMP("VEE","IGP",$J)
 D ENDSCR^%ZVEMKT2 ;Reset to full screen
 Q
