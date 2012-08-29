%ZVEMKTM ;DJB,KRN**Txt Scroll-Highlight Menu [3/6/96 6:23pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
ENDFILE() ;1=End-of-file  0=Ok
 I VEET("GAP") W $C(7) Q 1
 I $G(^TMP("VEE",PKG,$J,VEET("BOT")-1))=" <> <> <>"  W $C(7) Q 1
 Q 0
READ(PKG) ;PKG=Calling package's subscript ("IG"_GLS=VGL,"ID"_VEDDS=VEDD,etc)
 NEW HL,KEY,VK
READ1 I $G(TABHLD)]"" D  KILL TABHLD ;Keeps highlight at same node
 . S VEET("HLN")=$P(TABHLD,"^",1),VEET("H$Y")=$P(TABHLD,"^",2)
 D HIGHLITE("ON"),CURSOR^%ZVEMKU1(9,VEET("S2")+VEET("FT")-1,1)
 S KEY=$$READ^%ZVEMKRN(),KEY=$$ALLCAPS^%ZVEMKU(KEY),VK=VEE("K")
 I VK="<AU>" D  G READ1
 . I (VEET("HLN")-1)>VEET("TOP") D  Q
 . . D HIGHLITE("OFF") S VEET("HLN")=VEET("HLN")-1
 . . S VEET("H$Y")=VEET("H$Y")-1
 . I VEET("TOP")>1 D UP Q
 . W $C(7)
 I VK="<AD>",VEET("HLN")<VEET("BOT") D  G READ1
 . D HIGHLITE("OFF") S VEET("HLN")=VEET("HLN")+1
 . S VEET("H$Y")=VEET("H$Y")+1
 I VK="<AD>" G:$$ENDFILE() READ1 D DOWN Q "QUIT"
 I KEY=" " G READ1
 I KEY="^" S FLAGQ=1 Q "QUIT"
 I ",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VK_",") S FLAGQ=1 Q "QUIT"
 I KEY="?" Q KEY
 I VK="<ESCH>" Q VK
 I ",<HOME>,<F4AL>,"[(","_VK_",")!(KEY="T") S VEET("TOP")=1 D REDRAW^%ZVEMKT2() Q "QUIT"
 I ",<END>,<F4AR>,"[(","_VK_",")!(KEY="B") D BOTTOM^%ZVEMKT2(PKG) Q "QUIT"
 I VK="<F1AU>" D  G READ1
 . Q:(VEET("HLN")-1)'>VEET("TOP")
 . D HIGHLITE("OFF") S VEET("HLN")=VEET("TOP")+1
 . S VEET("H$Y")=VEET("S1")
 I VK="<F1AD>" D  G READ1
 . Q:VEET("HLN")'<VEET("BOT")
 . D HIGHLITE("OFF") S VEET("HLN")=VEET("BOT")
 . S VEET("H$Y")=$S(VEET("GAP"):VEET("S2")-VEET("GAP"),1:VEET("S2"))
 I ",<PGUP>,<F4AU>,"[(","_VK_",")!(KEY="U") W:VEET("TOP")'>1 $C(7) G:VEET("TOP")'>1 READ1 D LEFT Q "QUIT"
 I ",<PGDN>,<F4AD>,<RET>,"[(","_VK_",")!(KEY="D") G:$$ENDFILE() READ1 D RIGHT Q "QUIT"
 S:KEY']"" KEY=VK
 Q KEY
 ;===================================================================
UP ;Insert text at top.
 D HIGHLITE("OFF")
 S DX=0,DY=(VEET("S1")-2) X VEES("CRSR")
 W @VEES("INDEX"),@VEES("INSRT") X VEES("CRSR")
 I VEET("GAP") S VEET("GAP")=VEET("GAP")-1
 E  S VEET("BOT")=VEET("BOT")-1
 S VEET("TOP")=VEET("TOP")-1,VEET("HLN")=VEET("HLN")-1
 NEW TXT
 S TXT=$G(^TMP("VEE",PKG,$J,VEET("TOP")))
 Q:TXT=" <> <> <>"  I $G(VGLREV) D REVERSE^%ZVEMGI1(TXT) Q
 W !,TXT
 Q
DOWN ;Insert text at bottom
 D HIGHLITE("OFF")
 S DX=0,DY=(VEET("S2")-1) X VEES("CRSR")
 S VEET("TOP")=VEET("TOP")+1
 Q
LEFT ;Go back a page
 S VEET("TOP")=$S(VEET("TOP")>VEET("SL"):VEET("TOP")-VEET("SL"),1:1)
 S VEET("BOT")=VEET("TOP"),VEET("GAP")=VEET("SL")
 S VEET("HLN")=VEET("TOP"),VEET("H$Y")=VEET("S1")
 D SCROLL^%ZVEMKT2()
 Q
RIGHT ;Go forward a page
 S VEET("TOP")=VEET("BOT"),VEET("GAP")=VEET("SL")
 S VEET("HLN")=VEET("TOP"),VEET("H$Y")=VEET("S1")-1
 D SCROLL^%ZVEMKT2()
 Q
HIGHLITE(MODE) ; MODE="ON"  - Draw highlight
 ;      MODE="OFF" - Redraw with no highlight
 NEW HL I $G(MODE)'="ON" S MODE="OFF"
 S DX=0,DY=VEET("H$Y")-1 X VEES("CRSR")
 W:MODE="ON" @VEE("RON")
 S HL=$E($G(^TMP("VEE",PKG,$J,VEET("HLN")-1))) W $S(HL]"":HL,1:" ")
 W:MODE="ON" @VEE("ROFF")
 Q
