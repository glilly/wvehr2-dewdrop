%ZVEMREM ;DJB,VRR**EDIT - Move to different parts of a line ; 12/26/00 7:56am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
LNBEG ;Go to beginning of line
 NEW TMP
 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,YND)) Q:TMP=" <> <> <>"!(TMP']"")
 I TMP'[$C(30) S TMP=YND D  ;
 . F  S TMP=$O(^TMP("VEE","IR"_VRRS,$J,TMP),-1) D  Q:$G(^(TMP))[$C(30)!(YND=1)
 . . I YND=VEET("TOP") D UP^%ZVEMRE(1) Q
 . . S:YCUR>1 YCUR=YCUR-1 S:YND>1 YND=YND-1
 S (DX,XCUR)=$$LNBEG1() X VEES("CRSR")
 Q
LNBEG1() ;Return beginning of line.
 NEW I,START,TMP,TMP1
 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,YND)) I TMP']"" Q 0
 S DY=YCUR,START=0
 F I=1:1 S TMP1=$E(TMP,I) Q:TMP1?1ACP&(TMP1'=" ")  S START=START+1
 Q START
LNEND ;Go to end of line
 Q:$G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>"
 NEW TMP,X S X=YND
 F  S X=$O(^TMP("VEE","IR"_VRRS,$J,X)) Q:^(X)[$C(30)!(^(X)=" <> <> <>")  D  ;
 . I YND=(VEET("BOT")-1) D DOWN^%ZVEMRE(1) Q
 . S YCUR=YCUR+1,YND=YND+1
 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,YND))
 S DY=YCUR,(DX,XCUR)=$L(TMP)-(TMP[$C(30)) X VEES("CRSR")
 Q
LNLEFT ;Go left 15 spaces
 NEW START
 S START=$$LNBEG1(),DY=YCUR
 I XCUR-15>START S (DX,XCUR)=XCUR-15 X VEES("CRSR") Q
 S (DX,XCUR)=XCUR-(XCUR-START) X VEES("CRSR")
 Q
LNRIGHT ;Go right 15 spaces
 NEW L,TMP
 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,YND)) Q:TMP']""  Q:TMP=" <> <> <>"
 S L=$L(TMP)-(TMP[$C(30)) Q:XCUR=L  S DY=YCUR
 I XCUR+15'>L S (DX,XCUR)=XCUR+15 X VEES("CRSR") Q
 S (DX,XCUR)=XCUR+(L-XCUR) X VEES("CRSR")
 Q
LNLMAR ;Left margin of current line
 NEW L,TMP
 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,YND)) Q:TMP']""  Q:TMP=" <> <> <>"
 I TMP'[$C(30) S L=9
 E  S L=$L($P(TMP,$C(30),1))
 S DY=YCUR,(DX,XCUR)=L X VEES("CRSR")
 Q
LNRMAR ;Right margin of current line
 NEW L,TMP
 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,YND)) Q:TMP']""  Q:TMP=" <> <> <>"
 S L=$L(TMP)-(TMP[$C(30)) Q:XCUR=L
 S DY=YCUR,(DX,XCUR)=L X VEES("CRSR")
 Q
LNDOWN ;Scroll down 1 routine line (<ESC>L).
 KILL DIRHLD ;Tracks cursor for <AU> & <AD>
 NEW ND
 Q:$G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>"
 D HIGHOFF^%ZVEMRE
 F  D  Q:ND=" <> <> <>"!(ND[$C(30))
 . S YND=YND+1,ND=$G(^TMP("VEE","IR"_VRRS,$J,YND))
 . I YCUR'<(VEET("BOT")-VEET("TOP")) D  Q
 . . S VEET("BOT")=VEET("BOT")+1,VEET("TOP")=VEET("TOP")+1
 . . W !,$P(ND,$C(30),1),$P(ND,$C(30),2,99)
 . S YCUR=YCUR+1
 D HIGHON^%ZVEMRE
 Q
