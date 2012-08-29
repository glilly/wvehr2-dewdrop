%ZVEMRI ;DJB,VRR**INSERT - READ,HELP,ADD,DELETE ; 12/25/00 5:14pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
INSERT(MODE) ;Processes the line tag portion of a new line. When user
 ;hits <TAB>, return to EDIT mode.
 ;MODE: 1 = Open line above
 ;      2 = Open line below
 ;
 I $G(MODE)'>0 S MODE=1
 NEW CD,FLAGQ,LNNUM,X
 S FLAGQ=0
 S CD=""
 D @$S(MODE=2:"BELOW(YND)",1:"ABOVE(YND)") Q:FLAGQ
 S LNNUM=$$LINENUM^%ZVEMRU(YND)
 D OPEN^%ZVEMRI1
 F  D READ Q:FLAGQ
EX ;
 D LINECNT^%ZVEMRU
 KILL ^TMP("VEE",$J)
 Q
 ;
READ ;
 S X=$$READ^%ZVEMKRN("",1)
 I VEE("K")="<TAB>" D TAB^%ZVEMRI1 Q
 I ",<ESC>,<F1E>,<F1Q>,<RET>,"[(","_VEE("K")_",") D RETURN^%ZVEMRI1 Q
 I ",<AR>,<AL>,<AU>,<AD>,"[(","_VEE("K")_",") D ARROW Q
 I VEE("K")?1"<F1".E1">"!(VEE("K")?1"<F2".E1">") D OTHER Q
 I ",<BS>,<DEL>,"[(","_VEE("K")_",") D  D DELETE Q  ;Delete
 . S:$G(VEE("BS"))="SAME" VEE("K")="<BS>"
 Q:X']""
 D ADD ;Add character
 Q
 ;====================================================================
BELOW(ND) ;Open new line BELOW current line.
 ;ND = YND (Scroll array node)
 I $G(^TMP("VEE","IR"_VRRS,$J,ND))=" <> <> <>" D  Q
 . I ND'=1 S FLAGQ=1 W $C(7)
 NEW I,TMP
 F I=ND+1:1 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,I)) Q:TMP[$C(30)!(TMP=" <> <> <>")  D DOWN^%ZVEMRE(1)
 Q
 ;
ABOVE(ND) ;Open new line ABOVE current line.
 ;ND=YND (Scroll array node)
 NEW I,TMP
 F I=ND:-1 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,I)) Q:TMP[$C(30)!(I<1)!(^(I)=" <> <> <>")  D UP^%ZVEMRE(1)
 I ND=1 D  Q
 . I $G(^TMP("VEE","IR"_VRRS,$J,ND))'=" <> <> <>" S (YCUR,YND)=0
 D UP^%ZVEMRE(1)
 Q
 ;====================================================================
ADD ;Add character
 S CD=$E(CD,1,XCUR)_X_$E(CD,XCUR+1,9999)
 S XCUR=XCUR+1
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 W @VEES("BLANK_C_EOL")
 X VEES("XY")
 W $E(CD,XCUR+1,9999)
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;
DELETE ;Delete character
 I XCUR'>0,CD']""!(VEE("K")'="<DEL>") D  Q
 . D CLOSE^%ZVEMRI1
 . S FLAGQ=1
 I $G(VEE("K"))="<DEL>" S CD=$E(CD,1,XCUR)_$E(CD,XCUR+2,9999)
 E  S XCUR=XCUR-1,CD=$E(CD,1,XCUR)_$E(CD,XCUR+2,9999)
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 W @VEES("BLANK_C_EOL")
 X VEES("XY") W $E(CD,XCUR+1,9999)
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;====================================================================
ARROW ;Arrow Keys
 D @($E(VEE("K"),2,3))
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;
AL ;Arrow Left
 I XCUR<1 W $C(7) Q
 S XCUR=XCUR-1
 Q
 ;
AR ;Arrow Right
 Q:XCUR'<$L(CD)
 S XCUR=XCUR+1
 Q
 ;
AU ;Arrow Up
 W $C(7)
 Q
 ;
AD ;Arrow Down
 W $C(7)
 Q
 ;
OTHER ;F1 & F2 key combinations
 Q:",<F1AL>,<F1AR>,<F2AL>,<F2AR>,"'[(","_VEE("K")_",")
 D @($E(VEE("K"),2,5))
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;
F1AL ;Beginning of line
 S XCUR=0
 Q
 ;
F1AR ;End of line
 S XCUR=$L(CD)
 Q
 ;
F2AL ;Left 15
 S XCUR=XCUR-$S(XCUR-15>0:15,1:XCUR-0)
 Q
 ;
F2AR ;Right 15
 NEW L
 S L=$L(CD) Q:XCUR=L
 S XCUR=XCUR+$S(XCUR+15'>L:15,1:L-XCUR)
 Q
