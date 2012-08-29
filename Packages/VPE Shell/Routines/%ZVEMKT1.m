%ZVEMKT1 ;DJB,KRN**Txt Scroll-List TEXT [8/20/98 10:25am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
GETVEET ;Set VEET=Display text
 I $D(^TMP("VEE","K",$J,VEET("BOT"))) S VEET=^(VEET("BOT")) Q
 Q:$G(VEET("IMPORT"))="YES"
 X VEET("GET") S VEET=$G(^TMP("VEE","K",$J,VEET("BOT")))
 Q
LIST ;Display text
 D GETVEET W !,VEET
 S VEET("BOT")=VEET("BOT")+1 ;Bottom line #
 S:VEET("GAP") VEET("GAP")=VEET("GAP")-1 ;Empty lines left on page
 I VEET=" <> <> <>"!'VEET("GAP") D READ Q:FLAGQ
 I $G(VEET("IMPORT"))="YES",'$D(^TMP("VEE","K",$J,VEET("BOT"))) Q
 G LIST
ENDFILE() ;1=End-of-file  0=Ok
 I VEET("GAP") W $C(7) Q 1
 I ^TMP("VEE","K",$J,VEET("BOT")-1)=" <> <> <>" W $C(7) Q 1
 Q 0
READ ;Get input
 I $G(VEET("FIND"))]"" D FINDCHK Q:$G(VEET("FIND"))]""  ;Find text
 NEW KEY,VK
READ1 S KEY=$$READ^%ZVEMKRN("",1,1),KEY=$$ALLCAPS^%ZVEMKU(KEY),VK=VEE("K")
 I VK="<AU>" W:VEET("TOP")'>1 $C(7) D:VEET("TOP")>1 UP("K") G READ1
 I VK="<AD>" G:$$ENDFILE() READ1 D DOWN Q
 I ",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VK_",") S FLAGQ=1 Q
 I KEY="^" S FLAGQ=1 Q
 I KEY=" " G READ1
 I KEY="?"!(VK="<ESCH>") D  Q
 . D HELP^%ZVEMKT2,REDRAW^%ZVEMKT2()
 I KEY="F"!(KEY="L") D FIND(KEY) Q
 I ",<PGUP>,<F4AU>,"[(","_VK_",")!(KEY="U") W:VEET("TOP")'>1 $C(7) G:VEET("TOP")'>1 READ1 D LEFT Q
 I ",<PGDN>,<F4AD>,<RET>,"[(","_VK_",")!(KEY="D") G:$$ENDFILE() READ1 D RIGHT Q
 I ",<HOME>,<F4AL>,"[(","_VK_",")!(KEY="T") S VEET("TOP")=1 D REDRAW^%ZVEMKT2() Q
 I ",<END>,<F4AR>,"[(","_VK_",")!(KEY="B") D BOTTOM^%ZVEMKT2() Q
 G READ1
 ;====================================================================
UP(PKG) ;Insert text at top.
 ;PKG=Calling package..."IG"_GLS=VGL,"K"=Generic
 S DX=0,DY=(VEET("S1")-2) X VEES("CRSR")
 W @VEES("INDEX"),@VEES("INSRT") X VEES("CRSR")
 I VEET("GAP") S VEET("GAP")=VEET("GAP")-1
 E  S VEET("BOT")=VEET("BOT")-1
 S VEET("TOP")=VEET("TOP")-1
 Q:^TMP("VEE",PKG,$J,VEET("TOP"))=" <> <> <>"  W !,^(VEET("TOP"))
 Q
DOWN ;Insert text at bottom
 S DX=0,DY=(VEET("S2")-1) X VEES("CRSR")
 S VEET("TOP")=VEET("TOP")+1
 Q
LEFT ;Back up a page
 S (VEET("BOT"),VEET("TOP"))=$S(VEET("TOP")>VEET("SL"):VEET("TOP")-VEET("SL"),1:1)
 S VEET("GAP")=VEET("SL") D SCROLL^%ZVEMKT2()
 Q
RIGHT ;Go forward a page
 S VEET("TOP")=VEET("BOT"),VEET("GAP")=VEET("SL")
 D SCROLL^%ZVEMKT2()
 Q
FIND(TYPE) ;
 D ENDSCR^%ZVEMKT2
 W !!?1,"S C R O L L E R   F I N D   U T I L I T Y"
 W !!?1,"Enter characters that you want the scroller to search for."
 W !?1,"If found, the line containing these characters will appear"
 W !?1,"at the bottom of the screen. If ""<> <> <>"" appears at the"
 W !?1,"bottom of the screen, you've reached the end of the display."
 W !!?1,"Enter CHARACTERS: "
 R VEET("FIND"):300 I '$T KILL VEET("FIND")
 D REDRAW^%ZVEMKT2()
 I $G(VEET("FIND"))']"" KILL VEET("FIND") Q
 S VEET("FIND")=TYPE_"^"_VEET("FIND")
 Q
FINDCHK ;Find text
 NEW FIND,TXT,TXT1,TYPE
 I VEET=" <> <> <>" W $C(7) KILL VEET("FIND") Q
 S TXT=$G(^TMP("VEE","K",$J,VEET("BOT")-1)) Q:TXT']""
 S TXT1=$S(TXT[$C(9):$P(TXT,$C(9),2,99),1:TXT)
 S TYPE=$P(VEET("FIND"),"^",1),FIND=$P(VEET("FIND"),"^",2,99)
 I TYPE="L",TXT[FIND KILL VEET("FIND") Q
 I TYPE="F" D  I $E(TXT1,1,$L(FIND))=FIND KILL VEET("FIND") Q
 . ;Remove leading numbers and spaces
 . F  Q:$E(TXT1)?1A!(TXT1']"")  S TXT1=$E(TXT1,2,99)
 S VEET("TOP")=VEET("TOP")+1
 Q
LISTSC ;Display text with no pause, for Screen capture
 D GETVEET Q:VEET=" <> <> <>"  W !,VEET
 I $G(VEEPAGE)>0,VEET("BOT")#VEEPAGE=0 D PAUSE^%ZVEMKU(2,"Q") Q:FLAGQ  W @VEE("IOF")
 S VEET("BOT")=VEET("BOT")+1 ;Bottom line #
 G LISTSC
