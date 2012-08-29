%ZVEMKTT ;DJB,KRN**Txt Scroll-SELECTOR READ ; 11/30/00 1:44pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
READ ;Get input
 ;Move highlight to top line
 I $G(VEET("FIND-TOP"))]"" D FINDTOP KILL VEET("FIND-TOP")
 NEW KEY,PKG,VK
 S PKG="K",U="^"
READ1 D HIGHLITE("ON")
 S KEY=$$READ^%ZVEMKRN("",1,1),KEY=$$ALLCAPS^%ZVEMKU(KEY),VK=VEE("K")
 I VK="<AU>" D  G READ1
 . I (VEET("HLN")-1)>VEET("TOP") D  Q
 . . D HIGHLITE("OFF")
 . . S VEET("HLN")=VEET("HLN")-1,VEET("H$Y")=VEET("H$Y")-1
 . I VEET("TOP")>1 D UP Q
 . W $C(7)
 I VK="<AD>",VEET("HLN")<VEET("BOT") D  G READ1
 . D HIGHLITE("OFF") S VEET("HLN")=VEET("HLN")+1
 . S VEET("H$Y")=VEET("H$Y")+1
 I VK="<AD>" G:$$ENDFILE() READ1 D DOWN Q
 I KEY="^" S FLAGQ=1 Q
 I ",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VK_",") S FLAGQ=1 Q
 I VK="<ESCH>" D HELP^%ZVEMKT2,REDRAW^%ZVEMKT2() Q
 I KEY="?" D HELP^%ZVEMKTU,REDRAW^%ZVEMKT2() Q
 I KEY=" " D TAG^%ZVEMKTS G READ1
 I KEY="A" D ALL^%ZVEMKTS Q
 I KEY="C" D CLEAR^%ZVEMKTS Q
 ;I KEY="L" D FIND^%ZVEMKT1(KEY) Q
 I KEY="L" D LOCATE,REDRAW^%ZVEMKT2() Q
 I KEY="F" D FIND,REDRAW^%ZVEMKT2() Q
 I KEY="G" D GOTO,REDRAW^%ZVEMKT2() Q
 I KEY="+" D FIND^%ZVEMKTS("+") Q
 I KEY="-" D FIND^%ZVEMKTS("-") Q
 I KEY="M" D MORE^%ZVEMKTU,REDRAW^%ZVEMKT2() Q
 I KEY="N",$G(NEW)=1 D  S FLAGQ=1 Q
 . KILL ^TMP("VPE","SELECT",$J)
 . R KEY:1 ;Pause in case user hits N,<RETURN>
 . S ^TMP("VPE","SELECT",$J,"NEW")=""
 I KEY="P" D PAGE^%ZVEMKTS Q
 I KEY="S" D SHOW^%ZVEMKTU,REDRAW^%ZVEMKT2() Q
 I VK="<F4T>" D CURSORUP^%ZVEMKTS Q  ;Tag cursor to top line
 I VK="<F4B>" D CURSORDN^%ZVEMKTS Q  ;Tag cursor to bottom line
 I KEY="CT"!(VK="<F1AU>") D  G READ1 ;Cursor to top of page
 . Q:(VEET("HLN")-1)'>VEET("TOP")
 . D HIGHLITE("OFF") S VEET("HLN")=VEET("TOP")+1
 . S VEET("H$Y")=VEET("S1")
 I KEY="CD"!(VK="<F1AD>") D  G READ1 ;Cursor to bottom of page
 . Q:VEET("HLN")'<VEET("BOT")
 . D HIGHLITE("OFF") S VEET("HLN")=VEET("BOT")
 . S VEET("H$Y")=$S(VEET("GAP"):VEET("S2")-VEET("GAP"),1:VEET("S2"))
 I ",<PGUP>,<F4AU>,"[(","_VK_",")!(KEY="U") W:VEET("TOP")'>1 $C(7) G:VEET("TOP")'>1 READ1 D LEFT^%ZVEMKTM Q
 I ",<PGDN>,<F4AD>,<RET>,"[(","_VK_",")!(KEY="D") G:$$ENDFILE() READ1 D RIGHT^%ZVEMKTM Q
 I ",<HOME>,<F4AL>,"[(","_VK_",")!(KEY="T") S VEET("TOP")=1 D REDRAW^%ZVEMKT2() Q
 I ",<END>,<F4AR>,"[(","_VK_",")!(KEY="B") D BOTTOM^%ZVEMKT2(PKG) Q
 D HIGHLITE("OFF")
 G READ1
 ;====================================================================
ENDFILE() ;1=End-of-file  0=Ok
 I VEET("GAP") W $C(7) Q 1
 I ^TMP("VEE","K",$J,VEET("BOT")-1)=" <> <> <>" W $C(7) Q 1
 Q 0
HIGHLITE(MODE) ; MODE="ON"  - Draw highlight
 ;       MODE="OFF" - Redraw with no highlight
 NEW HL I $G(MODE)'="ON" S MODE="OFF"
 S DX=0,DY=VEET("H$Y")-1 X VEES("CRSR")
 W:MODE="ON" @VEE("RON")
 W $S($D(^TMP("VPE","SELECT",$J,VEET("HLN")-1)):"=>",1:"  ")
 W:MODE="ON" @VEE("ROFF")
 Q
 ;====================================================================
UP ;Insert text at top.
 D HIGHLITE("OFF")
 S DX=0,DY=(VEET("S1")-2) X VEES("CRSR")
 W @VEES("INDEX"),@VEES("INSRT") X VEES("CRSR")
 I VEET("GAP") S VEET("GAP")=VEET("GAP")-1
 E  S VEET("BOT")=VEET("BOT")-1
 S VEET("TOP")=VEET("TOP")-1,VEET("HLN")=VEET("HLN")-1
 NEW TXT
 S TXT=$G(^TMP("VEE",PKG,$J,VEET("TOP")))
 Q:TXT=" <> <> <>"
 W !?3 W:$G(NUMBER) $J(VEET("TOP"),3)_". "
 W $S(TXT[$C(9):$P(TXT,$C(9),2,999),1:TXT)
 Q
DOWN ;Insert text at bottom
 D HIGHLITE("OFF")
 S DX=0,DY=(VEET("S2")-1) X VEES("CRSR")
 S VEET("TOP")=VEET("TOP")+1
 Q
GOTO ;Goto line number
 NEW NUM
 D ENDSCR^%ZVEMKT2
GOTO1 W !,"Select LINE NUMBER: "
 R NUM:300 S:'$T NUM="^" I "^"[NUM Q
 I '$D(^TMP("VEE","K",$J,NUM)) W $C(7),"   Invalid" G GOTO1
 S (VEET("BOT"),VEET("TOP"))=NUM,VEET("GAP")=VEET("SL")
 S VEET("HLN")=VEET("TOP")+1,VEET("H$Y")=VEET("S1")-1
 Q
FIND ;Find text using "B" xref. Only 1st 10 characters of each line is
 ;stored in "B" xref.
 NEW FIND,FINDHLD,NUM
 D ENDSCR^%ZVEMKT2
 W !!,"F I N D   U T I L I T Y"
 W !!,"Enter characters you want to search for. If found, the line starting"
 W !,"with these characters will appear at the top of the screen."
 W !!,"Enter CHARACTERS: "
 R FIND:300 S:'$T FIND="" Q:FIND=""
 S FINDHLD=FIND
 S FIND=$O(^TMP("VEE","K",$J,"B",FIND))
 Q:$E(FIND,1,$L(FINDHLD))'=FINDHLD
 S NUM=$O(^TMP("VEE","K",$J,"B",FIND,"")) Q:'NUM
 D SET
 Q
LOCATE ;Locate line that contains text.
 NEW FLAGQ,LOCATE,ND,NUM
 D ENDSCR^%ZVEMKT2
 W !!,"L O C A T E   U T I L I T Y"
 W !!,"Enter characters you want to search for. If found, the line containing"
 W !,"these characters will appear at the top of the screen."
 W !!,"Enter CHARACTERS: "
 R LOCATE:300 S:'$T LOCATE="" Q:LOCATE=""
 S FLAGQ=0
 S NUM=VEET("TOP")
 F  S NUM=$O(^TMP("VEE","K",$J,NUM)) Q:'NUM  Q:FLAGQ  S ND=$G(^(NUM)) Q:ND=" <> <> <>"  D  ;
 . Q:ND'[LOCATE
 . D SET
 . S FLAGQ=1
 Q
SET ;Reset variables to correct line
 S (VEET("BOT"),VEET("TOP"))=NUM
 S VEET("GAP")=VEET("SL")
 S VEET("HLN")=VEET("TOP")+1
 S VEET("H$Y")=VEET("S1")-1
 S VEET("FIND-TOP")=1 ;So highlight is moved to top of screen
 Q
FINDTOP ;Move highlight at top of screen
 S VEET("HLN")=VEET("TOP")+1,VEET("H$Y")=VEET("S1")
 Q
