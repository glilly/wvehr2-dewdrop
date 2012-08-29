%ZVEMREA ;DJB,VRR**EDIT - Add Character ; 12/25/00 5:09pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
TOP ;Add a character to CD string
 NEW CD,FLAGNEW,HLD,HLDX,HLDY1,HLDY2,I,NUM,WHERE,XSAVE,YSAVE,YNDSAVE
 S NUM=YND
 S CD(NUM)=$G(^TMP("VEE","IR"_VRRS,$J,NUM))
 S WHERE=$$CHKADD^%ZVEMREL() Q:WHERE="Q"
 D SET
 I $L(CD(NUM))<(VEE("IOM")-(CD(NUM)'[$C(30))) D SIMPLE G EX
 S HLDX=XCUR,HLDY1=YCUR ;Save cursor X&Y values. Used by SCROLL.
 D ADJARRAY
 D REDRAW
 D COMPLEX
EX ;Exit
 S XCUR=XSAVE,YCUR=YSAVE,YND=YNDSAVE
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 D ADJOPEN1
 Q
 ;
SET ;Adjust variables
 ;KEY=Character user typed. Set in ^%ZVEMRE
 S FLAGNEW=0
 S YSAVE=YCUR
 S YNDSAVE=YND
 S (XCUR,XSAVE)=XCUR+1
 S XCHAR=$$XCHARADD^%ZVEMRU(CD(NUM))
 I XCUR>$L(CD(NUM)) S KEY=$J("",XCUR-$L(CD(NUM))-(CD(NUM)'[$C(30)))_KEY
 S CD(NUM)=$E(CD(NUM),1,XCHAR-2)_KEY_$E(CD(NUM),XCHAR-1,9999)
 Q
 ;
SIMPLE ;Process a line that hasn't reached end yet
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 W @VEES("BLANK_C_EOL")
 X VEES("XY")
 W $E(CD(NUM),XCHAR,9999)
 Q
 ;
ADJARRAY ;Adjust CD() array for new character. FLAGNEW=1 Open new line
 NEW FLAGQ S FLAGQ=0
 F I=NUM+1:1 D  Q:FLAGQ  Q:$L(CD(I))<(VEE("IOM")-1)
 . S CD(I)=$G(^TMP("VEE","IR"_VRRS,$J,I))
 . I CD(I)[$C(30)!(CD(I)=" <> <> <>") D  ;Open new line
 . . S CD(I)=$J("",9),FLAGNEW=I,FLAGQ=1
 . S HLD=$E(CD(I-1),$L(CD(I-1))) ;Get last char of previous line
 . S CD(I-1)=$E(CD(I-1),1,$L(CD(I-1))-1) ;Remove it from previous line
 . S CD(I)=$E(CD(I),1,9)_HLD_$E(CD(I),10,9999) ;Add it to current line
 Q
 ;
REDRAW ;Redraw rest of adjusted current line
 I XCUR<(VEE("IOM")-2) D SIMPLE Q
 ;If cursor at line end, move cursor down
 S DX=VEE("IOM")-2,DY=YCUR X VEES("CRSR")
 W " "
 S (XCUR,XSAVE)=$S(XCUR=(VEE("IOM")-2):9,1:10)
 S YNDSAVE=YND+1
 I YND<(VEET("BOT")-1) S YSAVE=YCUR+1 Q
 Q:$G(^TMP("VEE","IR"_VRRS,$J,YND+1))[$C(30)
 Q:$G(^(YND+1))=" <> <> <>"
 D DOWN^%ZVEMRE(1)
 S YCUR=YCUR-1
 Q
 ;
COMPLEX ;Multiple lines and cursor position, need to be adjusted.
 S DY=YCUR
 F I=NUM+1:1 Q:'$D(CD(I))  D  Q:FLAGQ
 . I I=FLAGNEW D OPEN W $P(CD(I),$C(30),1),$P(CD(I),$C(30),2,99) Q
 . S DX=9,DY=DY+1
 . I DY>(VEET("BOT")-VEET("TOP")) S FLAGQ=1 Q  ;Quit at screen bottom
 . X VEES("CRSR")
 . W @VEES("BLANK_C_EOL")
 . X VEES("XY")
 . W $E(CD(I),10,9999)
 Q
 ;
OPEN ;Open new next line.
 NEW BOT
 S BOT=$O(CD(""),-1)-1 I YND<BOT D  ;
 . S YCUR=YCUR+BOT-YND,YND=YND+BOT-YND
 . S DX=XCUR,DY=YCUR X VEES("CRSR")
 S HLDY2=YCUR ;Save cursor Y value. Used by SCROLL.
 D OPEN^%ZVEMREO
 D ADJOPEN
SCROLL ;When new line is opened and character is drawn, move cursor back to previous location. Determine if it needs to scroll up 1 line.
 Q:HLDY2<(VEET("BOT")-VEET("TOP"))  ;Opened line not at screen bottom.
 I HLDX<(VEE("IOM")-2) S YSAVE=YSAVE-1 Q  ;Cursor not at line end. Always scroll up 1 line.
 Q:HLDY1=(VEET("BOT")-VEET("TOP"))  ;Cursor at screen bottom. Don't scroll up 1 line.
 S YSAVE=YSAVE-1 ;Scroll cursor up 1 line.
 Q
 ;
ADJOPEN ;Adjust scroll array - Open a line
 NEW END,I
 S END=$O(^TMP("VEE","IR"_VRRS,$J,""),-1)
 F I=(END+1):-1:YND D  ;
 . S ^TMP("VEE","IR"_VRRS,$J,I)=^TMP("VEE","IR"_VRRS,$J,I-1)
ADJOPEN1 F I=NUM:1 Q:'$D(CD(I))  S ^TMP("VEE","IR"_VRRS,$J,I)=CD(I)
 Q
