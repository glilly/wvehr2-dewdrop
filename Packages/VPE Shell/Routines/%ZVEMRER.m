%ZVEMRER ;DJB,VRR**EDIT - RUN menu choices ; 12/27/00 11:24pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
RUN ;
 KILL DIRHLD ;Tracks cursor for <AU> & <AD>
 I VK="<F1AU>" D SCRNTOP Q  ;Cursor to top of scrn
 I VK="<F2AU>" D UP^%ZVEMRE(5) Q  ;Cursor up 5 lines
 I $G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>" W $C(7) Q
 I VK="<F1AL>" D LNBEG^%ZVEMREM Q  ;Cursor left
 I VK="<F1AR>" D LNEND^%ZVEMREM Q  ;Cursor right
 I VK="<F1AD>" D SCRNBOT Q  ;Cursor to bottom of scrn
 I VK="<F2AL>" D LNLEFT^%ZVEMREM Q  ;Cursor left 15
 I VK="<F2AR>" D LNRIGHT^%ZVEMREM Q  ;Cursor right 15
 I VK="<F2AD>" D DOWN^%ZVEMRE(5) Q  ;Cursor down 5 lines
 I VK="<F1F1>" D LNLMAR^%ZVEMREM Q  ;Cursor to left margin
 I VK="<F2F2>" D LNRMAR^%ZVEMREM Q  ;Cursor to right margin
 I VK="<F1L>" D LNDOWN^%ZVEMREM Q  ;Cursor down 1 rtn line
 I ",<BS>,<DEL>,"[(","_VK_",") D  D ^%ZVEMREB Q  ;Delete
 . S:$G(VEE("BS"))="SAME" VK="<BS>" S FLAGSAVE=1
 Q
 ;
RUN2 ;Help Text
 D ENDSCR^%ZVEMKT2
 I VK="<ESCH>" D HELP^%ZVEMKT("VRR1") ;Help text
 I VK="<ESCK>" D HELP^%ZVEMKT("VRR2") ;Keyboard help
 D REDRAW1^%ZVEMRU
 Q
RUN3 ;Goto Top/Bottom of Rtn
 KILL DIRHLD ;Tracks cursor for <AU> & <AD>
 I ",<F4AR>,<END>,"[(","_VK_",") D  Q  ;Goto bottom of rtn
 . D BOTTOM^%ZVEMKT2("IR"_VRRS,1)
 . S YND=VEET("TOP")
 . S YCUR=$O(^TMP("VEE","IR"_VRRS,$J,""),-1)-YND
 . S:YCUR<1 YCUR=1
 I ",<F4AL>,<HOME>,"[(","_VK_",") D  Q  ;Goto top of rtn
 . S (YCUR,YND,VEET("TOP"))=1 D REDRAW1^%ZVEMRU
 Q
BLOCK(QUIT) ;Turn off Block mode
 S $P(FLAGMODE,"^",1)="" D MODEOFF^%ZVEMRU("BLOCK",$G(QUIT))
 Q
WEB ;Turn off Web mode
 S $P(FLAGMODE,"^",2)="" D MODEOFF^%ZVEMRU("WEB")
 Q
HTML ;Turn off HTML mode
 S $P(FLAGMODE,"^",3)="" D MODEOFF^%ZVEMRU("HTML")
 Q
BACKUP ;Backup a page
 S (VEET("BOT"),VEET("TOP"))=$S(VEET("TOP")'>VEET("SL"):1,1:VEET("TOP")-VEET("SL"))
 S YND=VEET("TOP")+YCUR-1,VEET("GAP")=VEET("SL")
 D SCROLL^%ZVEMKT2(1)
 Q
FORWARD ;Go forward a page
 S VEET("TOP")=VEET("BOT"),VEET("GAP")=VEET("SL")
 S YND=VEET("TOP")+YCUR-1
 D SCROLL^%ZVEMKT2(1)
 Q
SCRNTOP ;Go to top of screen
 S YND=VEET("TOP"),DX=XCUR,(DY,YCUR)=1 X VEES("CRSR")
 Q
SCRNBOT ;Go to bottom of screen
 S DX=XCUR,(DY,YCUR)=VEET("BOT")-VEET("TOP") X VEES("CRSR")
 S YND=VEET("BOT")-1
 Q:$G(^TMP("VEE","IR"_VRRS,$J,YND))'=" <> <> <>"
 S YND=YND-1,YCUR=YCUR-1
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
