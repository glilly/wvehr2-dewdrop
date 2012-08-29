%ZVEMRP2 ;DJB,VRR**Block Mode - Highlight Characters ; 8/31/02 12:29pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
LEFT ;Char highlight - cursor left
 NEW CHAR,ND,TAGL,TMP
 ;
 Q:$$CHECK()
 ;
 S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND))
 Q:ND=" <> <> <>"
 ;
 S TAGL=$L($P(ND,$C(30),1))
 I ND[$C(30),XCUR<TAGL Q
 I ND[$C(30),XCUR=TAGL,'$D(^TMP("VEE","SAVECHAR",$J,"CHAR")) Q
 ;
 ;Beginning of scrolled line
 I ND'[$C(30),XCUR<9!($G(MARK)) D  ;
 . D UP^%ZVEMRE(1) ;...Move up a line
 . S (DX,XCUR)=VEE("IOM")-$S($G(MARK):2,1:3) X VEES("CRSR")
 . S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND)) ;...Reset ND
 ;
 ;Add/Remove highlight character
 S TMP=$G(^TMP("VEE","SAVECHAR",$J))
 S CHAR=(XCUR+1+(ND[$C(30)))
 I '$D(^TMP("VEE","SAVECHAR",$J,"CHAR",YND,CHAR-1)) D LEFTON Q
 D LEFTOFF
 Q
 ;
LEFTON ;Add highlight character
 KILL MARK
 S ^TMP("VEE","SAVECHAR",$J)=$E(ND,CHAR)_TMP
 S ^TMP("VEE","SAVECHAR",$J,YND)=ND ;Used to clear highlighted chars
 S ^TMP("VEE","SAVECHAR",$J,"CHAR",YND,CHAR)=XCUR_"^"_YCUR
 W @VEE("RON")
 W $E(ND,CHAR)
 W @VEE("ROFF")
 S XCUR=XCUR-1
 S DX=XCUR X VEES("CRSR")
 ;
 ;D WRITE
 Q
 ;
LEFTOFF ;Remove highlight character
 ;
 KILL MARK
 S XCUR=XCUR-1
 S DX=XCUR X VEES("CRSR")
 S CHAR=(XCUR+1+(ND[$C(30)))
 ;
 S ^TMP("VEE","SAVECHAR",$J)=$E(TMP,1,$L(TMP)-1) ;Strip last char
 KILL ^TMP("VEE","SAVECHAR",$J,"CHAR",YND,CHAR)
 W $E(ND,CHAR)
 X VEES("CRSR")
 ;
 ;If MARK=1, next <AL> moves up a line
 I ND'[$C(30),XCUR=9 S MARK=1
 ;
 ;D WRITE
 Q
 ;
RIGHT ;Char highlight - cursor right
 NEW CHAR,ND,ND1,TAGL,TMP,TMP1
 ;
 Q:$$CHECK()
 ;
 S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND))
 S ND1=$G(^(YND+1))
 Q:ND=" <> <> <>"
 ;
 ;If cursor is in line tag area, move it to start of line.
 S TAGL=$L($P(ND,$C(30),1))
 I ND[$C(30),XCUR<TAGL S (DX,XCUR)=(TAGL-1) X VEES("CRSR")
 ;
 ;Quit if at end of line.
 I XCUR+1>($L(ND)-(ND[$C(30))),ND1[$C(30)!(ND1=" <> <> <>") Q
 ;
 ;Move down a scrolled line
 I XCUR+1>($L(ND)-(ND[$C(30)))!($G(MARK)) D  ;End of main line
 . D DOWN^%ZVEMRE(1) ;...Move down a line
 . S (DX,XCUR)=$S($G(MARK):8,1:9) X VEES("CRSR")
 . S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND)) ;...Reset ND
 ;
 ;Add character to saved string.
 S TMP=$G(^TMP("VEE","SAVECHAR",$J))
 S CHAR=(XCUR+1+(ND[$C(30)))
 I '$D(^TMP("VEE","SAVECHAR",$J,"CHAR",YND,CHAR+1)) D RIGHTON Q
 D RIGHTOFF
 Q
 ;
RIGHTON ;Add highlight character
 KILL MARK
 S ^TMP("VEE","SAVECHAR",$J)=TMP_$E(ND,CHAR)
 S ^TMP("VEE","SAVECHAR",$J,YND)=ND ;Used to clear highlighted chars
 S ^TMP("VEE","SAVECHAR",$J,"CHAR",YND,CHAR)=XCUR_"^"_YCUR
 W @VEE("RON")
 W $E(ND,CHAR)
 W @VEE("ROFF")
 S XCUR=XCUR+1
 S DX=XCUR X VEES("CRSR")
 ;
 ;D WRITE
 Q
 ;
RIGHTOFF ;Remove highlight character
 KILL MARK
 S XCUR=XCUR+1
 S DX=XCUR X VEES("CRSR")
 S CHAR=(XCUR+1+(ND[$C(30)))
 ;
 S ^TMP("VEE","SAVECHAR",$J)=$E(TMP,2,$L(TMP)) ;Strip last char
 KILL ^TMP("VEE","SAVECHAR",$J,"CHAR",YND,CHAR)
 W $E(ND,CHAR)
 X VEES("CRSR")
 ;
 ;If MARK=1, next <AR> moves down a line
 I ND[$C(30),XCUR=(VEE("IOM")-3) S MARK=1
 ;
 ;D WRITE
 Q
 ;
INSERT ;Insert code into current line
 NEW CD,I,KEY,ND,TAGL
 ;
 ;Disallow restore into line tag area.
 S ND=$G(^TMP("VEE","IR"_VRRS,$J,YND))
 I ND[$C(30) S TAGL=$L($P(ND,$C(30),1)) I XCUR<TAGL Q
 ;
 D HIGHOFF^%ZVEMRE ;..Highlight off
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 ;
 S CD=$G(^%ZVEMS("E","SAVEVRR",$J,1))
 F I=1:1 S KEY=$E(CD,I) Q:KEY']""  W KEY D ^%ZVEMREA
 D HIGHON^%ZVEMRE ;...Highlite on
 S FLAGSAVE=1
 Q
 ;
DELETE ;Delete code from current line (<ESCX>).
 Q:'$D(^TMP("VEE","SAVECHAR",$J,"CHAR",YND))
 NEW CHAR,ND,ND1,VK,YNDHLD
 S VK="<BS>"
 S YND=""
 F  S YND=$O(^TMP("VEE","SAVECHAR",$J,"CHAR",YND),-1) Q:'YND  D  ;
 . S YNDHLD=YND
 . S ND=^TMP("VEE","IR"_VRRS,$J,YND)
 . S CHAR=""
 . F  S CHAR=$O(^TMP("VEE","SAVECHAR",$J,"CHAR",YND,CHAR),-1) Q:'CHAR  D  ;
 .. S ND1=^(CHAR)
 .. S (DX,XCUR)=($P(ND1,"^",1)+1)
 .. S (DY,YCUR)=$P(ND1,"^",2)
 .. X VEES("CRSR")
 .. D ^%ZVEMREB
 .. S YND=YNDHLD ;...Reset YND after call to ^%ZVEMREB
 S YND=YNDHLD ;Get last value of YND
 D REDRAW^%ZVEMRU(YND)
 X VEES("CRSR")
 S FLAGSAVE=1
 Q
 ;
CHECK() ;
 I '$D(^TMP("VEE","SAVE",$J))  Q 0
 S FLAGMODE=0
 D CLEARALL^%ZVEMRP
 D MODEOFF^%ZVEMRU("BLOCK")
 Q 1
 ;
WRITE(TXT) ;Display contents of clipboard - for testing purposes.
 NEW DXHLD,DYHLD
 S DXHLD=DX,DYHLD=DY
 S DX=1,DY=15 X VEES("CRSR")
 W "|"_TXT_"|"
 S DX=DXHLD,DY=DYHLD X VEES("CRSR")
 Q
