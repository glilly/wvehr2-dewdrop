%ZVEMRP ;DJB,VRR**Block Mode - Highlight Lines ; 12/28/00 7:56am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
UP ;F3 Up-arrow highlight
 Q:$$CHECK()
 I $D(^TMP("VEE","SAVE",$J,YND-1)) D CLEARUP Q
 Q:'$D(^TMP("VEE","IR"_VRRS,$J,YND))
 I ^(YND)=" <> <> <>" D UP^%ZVEMRE(1) Q
 D CHKBELOW ;See if line below is part of this line
UP1 I YCUR=1,VEET("TOP")'>1 D  Q
 . I $D(^TMP("VEE","SAVE",$J,YND)) W $C(7) Q
 . S ^TMP("VEE","SAVE",$J,YND)=^TMP("VEE","IR"_VRRS,$J,YND)
 . D MARK(YCUR,YND)
 . S DX=XCUR,DY=YCUR X VEES("CRSR")
 S ^TMP("VEE","SAVE",$J,YND)=^TMP("VEE","IR"_VRRS,$J,YND)
 D MARK(YCUR,YND)
 D UP^%ZVEMRE(1)
 Q:^TMP("VEE","IR"_VRRS,$J,YND+1)[$C(30)
 ;Loop back in case line has scrolled
 G UP1
 ;
DOWN ;F3 Down-arrow highlight
 Q:$$CHECK()
 I $D(^TMP("VEE","SAVE",$J,YND)) D CLEARDN1 Q
 I $D(^TMP("VEE","SAVE",$J,YND+1)) D CLEARDN Q
 Q:'$D(^TMP("VEE","IR"_VRRS,$J,YND))
 I ^(YND)=" <> <> <>" W $C(7) Q
 I ^(YND)'[$C(30) D CHKABOVE ;See if line above is part of this line
DOWN1 S ^TMP("VEE","SAVE",$J,YND)=^TMP("VEE","IR"_VRRS,$J,YND)
 D MARK(YCUR,YND)
 D DOWN^%ZVEMRE(1)
 Q:^TMP("VEE","IR"_VRRS,$J,YND)[$C(30)
 Q:^(YND)=" <> <> <>"
 G DOWN1 ;Do a loop in case line has scrolled
 ;
MARK(YVAL,ND) ;Mark selected lines. YVAL=$Y, ND=Node
 NEW TMP
 S DX=0,DY=YVAL X VEES("CRSR")
 W @VEES("BLANK_C_EOL")
 W @VEE("RON")
 X VEES("CRSR")
 S TMP=$G(^TMP("VEE","SAVE",$J,ND))
 W $P(TMP,$C(30),1)
 W $P(TMP,$C(30),2)
 W ?VEE("IOM")-1
 W @VEE("ROFF")
 Q
 ;
CHKABOVE ;Check if line above is part of this line
 NEW I,YVAL
 S YVAL=YCUR
 F I=YND-1:-1 Q:I<1  D  Q:^TMP("VEE","IR"_VRRS,$J,I)[$C(30)
 . S ^TMP("VEE","SAVE",$J,I)=^TMP("VEE","IR"_VRRS,$J,I)
 . S YVAL=YVAL-1
 . I YVAL>0 D MARK(YVAL,I)
 Q
 ;
CHKBELOW ;Check if line below is part of this line
 NEW I,YVAL
 S YVAL=YCUR
 F I=YND+1:1 Q:'$D(^TMP("VEE","IR"_VRRS,$J,I))  Q:^(I)[$C(30)  Q:^(I)=" <> <> <>"  D  ;
 . S ^TMP("VEE","SAVE",$J,I)=^TMP("VEE","IR"_VRRS,$J,I)
 . S YVAL=YVAL+1
 . I YVAL'>(VEET("BOT")-VEET("TOP")) D MARK(YVAL,I)
 Q
 ;
CLEARUP ;Clear one highlighted line - Cursor UP
 ;If line has scrolled clear scrolled portion as well
 NEW FLAGQ,TMP
 S FLAGQ=0
 F  D UP^%ZVEMRE(1) D  Q:FLAGQ  Q:'$D(^(YND-1))
 . S DX=0,DY=YCUR X VEES("CRSR")
 . S TMP=$G(^TMP("VEE","SAVE",$J,YND))
 . W $P(TMP,$C(30),1)
 . W $P(TMP,$C(30),2)
 . W ?VEE("IOM")-1
 . S DX=XCUR,DY=YCUR X VEES("CRSR")
 . S:TMP[$C(30) FLAGQ=1
 . KILL ^TMP("VEE","SAVE",$J,YND)
 Q
 ;
CLEARDN ;Clear one highlighted line - Cursor DOWN
 ;If line has scrolled clear scrolled portion as well
 NEW TMP
 F  D DOWN^%ZVEMRE(1) D  Q:'$D(^(YND+1))  Q:^(YND+1)[$C(30)
 . S DX=0,DY=YCUR X VEES("CRSR")
 . S TMP=$G(^TMP("VEE","SAVE",$J,YND))
 . W $P(TMP,$C(30),1)
 . W $P(TMP,$C(30),2)
 . W ?(VEE("IOM")-1)
 . S DX=XCUR,DY=YCUR X VEES("CRSR")
 . KILL ^TMP("VEE","SAVE",$J,YND)
 Q
 ;
CLEARDN1 ;Clear highlighted top line - Cursor DOWN
 NEW TMP
 F  D  Q:'$D(^(YND+1))  Q:^(YND+1)[$C(30)  D DOWN^%ZVEMRE(1)
 . S DX=0,DY=YCUR X VEES("CRSR")
 . S TMP=$G(^TMP("VEE","SAVE",$J,YND))
 . W $P(TMP,$C(30),1)
 . W $P(TMP,$C(30),2)
 . W ?(VEE("IOM")-1)
 . S DX=XCUR,DY=YCUR X VEES("CRSR")
 . KILL ^TMP("VEE","SAVE",$J,YND)
 Q
 ;
CLEARALL ;Clear all highlighted lines
 NEW CNT,DY,TMP,TMP1
 S CNT=0
 S DY=VEET("S1")-2
 F I=VEET("TOP"):1:VEET("BOT")-1 D  ;
 . S DX=0,DY=DY+1
 . S TMP=$G(^TMP("VEE","SAVE",$J,I))
 . S TMP1=$G(^TMP("VEE","SAVECHAR",$J,I))
 . I TMP']"",TMP1']"" Q
 . X VEES("CRSR")
 . ;
 . I TMP]"" D  ;
 .. W $P(TMP,$C(30),1)
 .. W $P(TMP,$C(30),2)
 .. W ?(VEE("IOM")-1)
 . E  D  ;
 .. W $P(TMP1,$C(30),1)
 .. W $P(TMP1,$C(30),2)
 .. W ?(VEE("IOM")-1)
 ;
 KILL ^TMP("VEE","SAVE",$J)
 KILL ^TMP("VEE","SAVECHAR",$J)
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;
BULKDN ;Bulk highlight from cursor to bottom of rtn
 Q:$$CHECK()
 I $D(^TMP("VEE","SAVE",$J)) D  Q
 . S FLAGMODE=0
 . D CLEARALL
 . D MODEOFF^%ZVEMRU("BLOCK")
 I $G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>" W $C(7) Q
 I ^(YND)'[$C(30) D CHKABOVE ;See if line above is part of this line
 F  D DOWN1 Q:$G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>"
 Q
 ;
BULKUP ;Bulk highlight from cursor to top of rtn
 Q:$$CHECK
 I $D(^TMP("VEE","SAVE",$J)) D  Q
 . S FLAGMODE=0
 . D CLEARALL
 . D MODEOFF^%ZVEMRU("BLOCK")
 D CHKBELOW ;See if line below is part of this line
 F  Q:YND=1  D UP
 I YND=1 D  ;
 . S ^TMP("VEE","SAVE",$J,YND)=^TMP("VEE","IR"_VRRS,$J,YND)
 . D MARK(YCUR,YND)
 . S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;
CHECK() ;
 I '$D(^TMP("VEE","SAVECHAR",$J))  Q 0
 S FLAGMODE=0
 D CLEARALL^%ZVEMRP
 D MODEOFF^%ZVEMRU("BLOCK")
 Q 1
