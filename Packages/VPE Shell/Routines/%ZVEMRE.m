%ZVEMRE ;DJB,VRR**EDIT - READ,UP,DOWN,LEFT,RIGHT ; 9/24/02 7:55am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
READ ;Get input
 NEW X S X="ERROR1^%ZVEMRY",@($$TRAP^%ZVEMKU1) KILL X
 NEW DIRHLD,KEY,QUIT,TMP,VK
 I VEET("GAP"),YCUR>(VEET("BOT")-VEET("TOP")) D  ;
 . S YCUR=VEET("BOT")-VEET("TOP"),YND=VEET("TOP")+YCUR-1
 D HIGHON
READ1 ;
 S QUIT=0
 S KEY=$$READ^%ZVEMKRN("",1),VK=$G(VEE("K"))
 ;
WEB I FLAGMODE["WEB",VK="<F3>" D WEB^%ZVEMREW G READ1 ;Insert HTML tags
 ;
 ;===================================================================
BLOCK I FLAGMODE["BLOCK" D  Q:QUIT  G READ1
 . I $G(FLAGVPE)'["EDIT",$G(FLAGVPE)'["LBRY" D MSG^%ZVEMRUM(5) Q
 . I VK="<AU>" D UP^%ZVEMRP Q
 . I VK="<AD>" D DOWN^%ZVEMRP Q
 . I VK="<AR>" D RIGHT^%ZVEMRP2 Q
 . I VK="<AL>" D LEFT^%ZVEMRP2 Q
 . I VK="<HOME>" D BULKUP^%ZVEMRP Q
 . I VK="<END>" D BULKDN^%ZVEMRP Q
 . I VK="<F3>" D BLOCK^%ZVEMRE2 Q
 . I VK="<ESCC>" D BLOCK^%ZVEMRE2 Q
 . I $G(FLAGVPE)["LBRY" Q  ;Reviewing a version
 . I VK="<ESCD>" D BLOCK^%ZVEMRE2 Q
 . I VK="<ESCV>" D BLOCK^%ZVEMRE2 Q
 . I VK="<ESCX>" D BLOCK^%ZVEMRE2 Q
 . I VK="<DEL>" D BLOCK^%ZVEMRE2 Q
 . ;Any other key: Clear highlight lines and turn off Block mode.
 . D CLEARALL^%ZVEMRP,BLOCK^%ZVEMRER()
 I ",<F3>,<ESCD>,<ESCV>,"[(","_VK_",") D  Q:QUIT  G READ1
 . I $G(FLAGVPE)["LBRY",VK="<F3>" D BLOCK^%ZVEMRE2 Q
 . I $G(FLAGVPE)'["EDIT" D MSG^%ZVEMRUM(5) Q
 . D BLOCK^%ZVEMRE2
 ;===================================================================
 I VK="<AU>" D UP(1) G READ1
 I VK="<AD>" D DOWN(1) G READ1
 I VK="<AL>" D LEFT G READ1
 I VK="<AR>" D RIGHT G READ1
 ;
 D DO^%ZVEMRE1 Q:QUIT
 G READ1
 ;====================================================================
ENDFILE() ;1=End-of-file  0=Ok
 I VEET("GAP") W $C(7) Q 1
 I ^TMP("VEE","IR"_VRRS,$J,VEET("BOT")-1)=" <> <> <>" W $C(7) Q 1
 Q 0
 ;
TOPFILE() ;1=Top-of-file  0=Ok
 I VEET("TOP")'>1 W $C(7) Q 1
 Q 0
 ;====================================================================
UP(NUM) ;Scroll up NUM lines. Insert line at top.
 NEW I,ND,TMP
 I YCUR=1 Q:$$TOPFILE()
 S NUM=$G(NUM) D HIGHOFF
 I NUM=1 S YND=YND-1 D  D CURSOR("U"),HIGHON Q
 . I YCUR>1 S YCUR=YCUR-1 Q
 . D INSERT^%ZVEMRU(0,(VEET("S1")-2))
 . S DX=0,DY=(VEET("S1")-1) X VEES("CRSR")
 . S VEET("TOP")=VEET("TOP")-1
 . S TMP=$G(^TMP("VEE","IR"_VRRS,$J,VEET("TOP")))
 . W $P(TMP,$C(30),1),$P(TMP,$C(30),2,99)
 I YCUR=1 W $C(7) Q
 F I=1:1:NUM I YCUR>1 S YCUR=YCUR-1,YND=YND-1
 D CURSOR("U"),HIGHON
 Q
 ;
DOWN(NUM) ;Scroll down NUM lines. Insert line at bottom.
 NEW I,TMP
 I $G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>" W $C(7) Q
 S NUM=$G(NUM) D HIGHOFF
 ;--> When cursor's at screen bottom:
 I YCUR'<(VEET("BOT")-VEET("TOP")) D  D CURSOR("D"),HIGHON Q
 . I NUM>1 W $C(7) Q  ;Don't allow cursor jump
 . S YND=YND+1,VEET("BOT")=VEET("BOT")+1,VEET("TOP")=VEET("TOP")+1
 . S TMP=$G(^TMP("VEE","IR"_VRRS,$J,YND))
 . W !,$P(TMP,$C(30),1),$P(TMP,$C(30),2,99)
 ;--> Move cursor down
 F I=1:1:NUM Q:YCUR'<(VEET("BOT")-VEET("TOP"))  D  ;
 . S YCUR=YCUR+1,YND=YND+1
 D CURSOR("D"),HIGHON
 Q
 ;
LEFT ;Cursor left/up
 NEW ND KILL DIRHLD
 Q:XCUR'>0
 S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND)) Q:ND=" <> <> <>"
 I ND'[$C(30),XCUR<10 D  ;
 . D UP(1) S XCUR=VEE("IOM")-2 ;.....................Move up a line
 . S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND)) ;...........Reset ND
 I ND[$C(30) D  ;
 . I XCUR<10,$P(ND,$C(30),1)?1.N1." " S XCUR=1 Q  ;..Jump over tag
 S XCUR=XCUR-1,DX=XCUR X VEES("CRSR")
 Q
 ;
RIGHT ;Cursor right/down
 NEW ND,ND1 KILL DIRHLD
 S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND)),ND1=$G(^(YND+1))
 Q:ND=" <> <> <>"
 D  ;
 . ;-->End of main line
 . Q:(XCUR+2-(ND1[$C(30)))'>($L(ND)-(ND[$C(30)))
 . ;-->End of rtn
 . Q:(XCUR+2-(ND1=" <> <> <>"))'>($L(ND)-(ND[$C(30)))
 . I ND1=" <> <> <>"!(ND1[$C(30)) S XCUR=XCUR-1 Q
 . D DOWN(1) S XCUR=8 ;..............................Open new line
 . S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND)) ;...........Reset ND
 I ND[$C(30) D  ;
 . I XCUR<1,$P(ND,$C(30),1)?1.N1." " S XCUR=8 ;......Jump over tag
 S XCUR=XCUR+1,DX=XCUR X VEES("CRSR")
 Q
 ;===================================================================
HIGHON ;Draw highlite on right side of screen
 S DX=VEE("IOM")-1,DY=YCUR X VEES("CRSR")
 W @VEE("RON")
 X VEES("XY") W " "
 W @VEE("ROFF")
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;
HIGHOFF ;Remove highlite from right side of screen
 S DX=VEE("IOM")-1,DY=YCUR X VEES("CRSR")
 W " "
 Q
 ;
CURSOR(DIR) ;Position cursor when moving up & down
 ;DIR=Cursor Direction (U=Up D=Down)
 ;DIRHLD stores the starting column when moving UP or DOWN.
 NEW ND
 KILL:DIR="U" DIRHLD("D") KILL:DIR="D" DIRHLD("U")
 I '$D(DIRHLD(DIR)) S DIRHLD(DIR)=XCUR
 S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND))
 I $L(ND)>DIRHLD(DIR) S XCUR=DIRHLD(DIR) Q
 S XCUR=$L(ND)-$S(ND[$C(30):1,1:"")
 Q
