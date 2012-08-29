%ZVEMRU ;DJB,VRR**Utilities ; 1/6/01 8:12am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
LNSTART(CD) ;Find start of line for EDIT mode.
 ;"2^11" - TAG starts at 2, LINE starts at 11
 I CD[$C(30) Q $$TAGSTART(CD)
 Q "10^10"
 ;
TAGSTART(CD) ;Find start of tag
 NEW L,START,TAG
 S TAG=$P(CD,$C(30),1),L=$L(TAG)
 I TAG?1.N1." "!(TAG?1." ") Q "11^11"
 F START=1:1 Q:$E(TAG)'=" "  S TAG=$E(TAG,2,999)
 Q START_"^"_(L+2)
 ;
LNSTART1(CD) ;Find start of line for INSERT mode
 NEW START,TAG
 S START=9,TAG=$P(CD,$C(30),1)
 I CD'[$C(30) Q START
 I +TAG>0 Q START
 I $L(TAG)'>9 Q START
 Q START+($L(TAG)-9)
 ;
XCHARADD(CD) ;Adjust XCHAR for $C(30) - When adding code
 ;XCUR=$L(CD)-1 because $X starts with zero.
 ;--> If XCUR is left of $C(30) XCHAR=XCUR+1. Else XCHAR=XCUR+2.
 I CD'[$C(30) Q (XCUR+1)
 ;--> Cursor is in space between tag and line
 I XCUR+2=$F(CD,$C(30)) Q (XCUR+1)
 I XCUR+1'<$F(CD,$C(30)) Q (XCUR+2)
 Q (XCUR+1)
 ;
XCHARDEL(CD) ;Adjust XCHAR for $C(30) - When deleting code
 I CD'[$C(30) Q (XCUR+1)
 ;--> Cursor is in space between tag and line
 I XCUR+2'<$F(CD,$C(30)) Q (XCUR+2)
 Q (XCUR+1)
 ;
LINENUM(ND) ;Get line number for new code. ND=Scroll array node
 I $G(ND)'>0 Q 1
 NEW NUM,X S NUM=1,X=0
 F  S X=$O(^TMP("VEE","IR"_VRRS,$J,X)) D  Q:X=ND
 . I ^(X)[$C(30) S NUM=NUM+1
 Q NUM
 ;
GETNODE(LN) ;Convert a line number to an array node. LN=Line #
 NEW ND,NM,X
 S (ND,NM,X)=0
 F  S X=$O(^TMP("VEE","IR"_VRRS,$J,X)) Q:^(X)=" <> <> <>"  D  Q:NM=LN
 . S ND=ND+1
 . I ^(X)[$C(30) S NM=NM+1
 I X']"" Q 0
 I ^(X)=" <> <> <>" Q 0
 Q ND
 ;==================================================================
INSERT(DX,DY) ;Insert a line. Uses escape sequences not supported by MSM NT.
 S DX=+$G(DX),DY=+$G(DY)
 I $G(^%ZOSF("OS"))["MSM for Windows NT" D ZINSERT(DX,DY) Q
 X VEES("CRSR") W @VEES("INDEX"),@VEES("INSRT")
 I VEET("GAP") D  Q
 . S VEET("GAP")=VEET("GAP")-1
 S VEET("BOT")=VEET("BOT")-1
 Q
 ;
ZINSERT(DX,DY) ;Insert a line. Don't use above escape sequences.
 S DX=+$G(DX),DY=+$G(DY)+1 X VEES("CRSR")
 W @VEES("BLANK_C_EOL") X VEES("XY")
 I VEET("GAP") S VEET("GAP")=VEET("GAP")-1
 E  S VEET("BOT")=VEET("BOT")-1
 D REDRAW^%ZVEMREO(YND+1,VEET("BOT"))
 S DX=0,DY=YCUR X VEES("CRSR")
 Q
 ;==================================================================
REDRAW(YVAL) ;Adjust line count and redraw from YVAL to bottom of screen
 Q:$G(YVAL)'>0
 NEW I,FLAGQ,TMP
 S FLAGQ=0
 F I=YVAL:1 D  Q:FLAGQ
 . S TMP=$G(^TMP("VEE","IR"_VRRS,$J,I))
 . I I'<VEET("BOT") D  Q:FLAGQ
 . . I 'VEET("GAP") S FLAGQ=1 Q
 . . S VEET("BOT")=VEET("BOT")+1,VEET("GAP")=VEET("GAP")-1
 . S DX=0,DY=I-VEET("TOP")+1
 . X VEES("CRSR") W @VEES("BLANK_C_EOL") X VEES("XY")
 . W $P(TMP,$C(30),1),$P(TMP,$C(30),2)
 . I TMP=" <> <> <>" S FLAGQ=1 Q
 D LINECNT
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;
REDRAW1 ;Adjust line count and then redraw top & bottom of screen
 D LINECNT,REDRAW^%ZVEMKT2(1)
 Q
 ;
REDRAW2 ;Redraw screen with no adjustments
 D REDRAW^%ZVEMKT2(1),REDRAW(VEET("TOP"))
 Q
 ;
REDRAW3 ;Adjust line count and then redraw screen
 D LINECNT,REDRAW^%ZVEMKT2(1),REDRAW(VEET("TOP"))
 Q
 ;
LINECNT ;Adjust line count at top of screen
 NEW NEWHIGH
 S NEWHIGH=VRRHIGH_$E("    ",1,3-$L(VRRHIGH))
 S VEET("HD",1)=$E(VEET("HD",1),1,59)_NEWHIGH_$E(VEET("HD",1),63,VEE("IOM"))
 S DX=59,DY=0 X VEES("CRSR") W $G(VRRHIGH)
 Q
 ;
MODEON(MODE,QUIT) ;MODE display in upper right of screen.
 ;MODE=BLOCK or WEB
 ;QUIT=1 Quit before repositioning the cursor
 S DX=$S($G(MODE)="WEB":65,1:72)
 S DY=(VEET("S1")-2) X VEES("CRSR")
 W @VEE("RON") X VEES("XY") W MODE,@VEE("ROFF")
 Q:$G(QUIT)
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;
MODEOFF(MODE,QUIT) ;Turn off MODE notice
 ;MODE=BLOCK or WEB
 S DX=$S($G(MODE)="WEB":65,1:72)
 S DY=(VEET("S1")-2) X VEES("CRSR") W "======"
 Q:$G(QUIT)
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
