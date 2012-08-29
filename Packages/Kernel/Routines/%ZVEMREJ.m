%ZVEMREJ ;DJB,VRR**EDIT - JOIN,BREAK [10/22/96 12:11pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
BREAK ;Break a line
 NEW CD,CD1,CD2,XVAL
 S CD=^TMP("VEE","IR"_VRRS,$J,YND),XVAL=$$XCHARDEL^%ZVEMRU(CD)
 I CD[$C(30),XVAL-XCUR'>1 W $C(7) Q
 I CD'[$C(30),XVAL'>9 W $C(7) Q
 S CD1=$E(CD,1,XVAL-1),CD2=$E(CD,XVAL,9999)
 ;-> Strip starting/trailing spaces
 F  Q:$E(CD1,$L(CD1))'=" "  D  Q:CD1']""
 . S CD1=$E(CD1,1,$L(CD1)-1)
 . S XCUR=XCUR-1
 F  Q:$E(CD2,1)'=" "  S CD2=$E(CD2,2,999) Q:CD2']""
 I CD1[$C(30),$P(CD1,$C(30),2)']"" W $C(7) Q
 I CD2']"" W $C(7) Q
 S FLAGSAVE=1,^TMP("VEE","IR"_VRRS,$J,YND)=CD1
 I CD1']"" D  ;.................................Delete this node
 . KILL ^TMP("VEE","SAVE",$J) S ^($J,YND)=""
 . D DELETE^%ZVEMRP1(1)
 . S YCUR=YCUR-1,YND=YND-1
 D BALANCE
 Q
BALANCE ;Rebuild balance of line plus any additional scrolled lines.
 NEW I,NUM
 KILL ^TMP("VEE","SAVE",$J)
 S NUM=$$LINENUM^%ZVEMRU(YND)+1
 F I=YND+1:1 Q:^TMP("VEE","IR"_VRRS,$J,I)[$C(30)  Q:^(I)=" <> <> <>"  S CD2=CD2_$E(^(I),10,9999) S ^TMP("VEE","SAVE",$J,I)=""
 S ^%ZVEMS("E","SAVEVRR",$J,1)=NUM_$J("",9-$L(NUM))_$C(30)_$E(CD2,1,VEE("IOM")-11)
 S CD2=$E(CD2,VEE("IOM")-10,9999)
 F I=2:1 Q:CD2']""  D  ;
 . S ^%ZVEMS("E","SAVEVRR",$J,I)=$J("",9)_$E(CD2,1,VEE("IOM")-11)
 . S CD2=$E(CD2,VEE("IOM")-10,9999)
 S ^%ZVEMS("E","SAVEVRR",$J,I)=""
 I $D(^TMP("VEE","SAVE",$J)) D DELETE^%ZVEMRP1(1)
 D PASTE^%ZVEMRP1
 Q
 ;====================================================================
JOINMSG ;You may not use Line 1 in a join.
 W $C(7)
 S DX=$X X VEES("CRSR") W @VEES("BLANK_C_EOL")
 X VEES("CRSR") W "  Line 1 may not be used in a JOIN"
 D PAUSE^%ZVEMKC(0)
 Q
JOINA ;Join current line to next line
 NEW CD,CD1,CD2,HELP,LN1,LN2,ND1,ND2,X,YNDSAVE
 S LN1=$$LINENUM^%ZVEMRU($P(FLAGMENU,"^",1))-1
 I LN1=1 D JOINMSG Q  ;.................Can't use title line in Join
 I LN1'>0!(LN1=VRRHIGH) W $C(7) Q
 S ND1=$$GETNODE^%ZVEMRU(LN1) I ND1=0 W $C(7) Q
 S LN2=LN1+1
 S ND2=$$GETNODE^%ZVEMRU(LN2) I ND2=0 W $C(7) Q
 S FLAGSAVE=1 D JOIN2
 Q
JOIN ;Join 2 lines selected by user
 NEW CD,CD1,CD2,HELP,LN1,LN2,ND1,ND2,X,YNDSAVE
 S HELP="  Enter a #. Line 2 will be joined to Line 1."
JOIN1 S LN1=$$GETLINE("1ST LINE NUMBER",HELP) Q:LN1'>0
 I LN1=1 D JOINMSG G JOIN1
 S ND1=$$GETNODE^%ZVEMRU(LN1) I ND1=0 W $C(7) G JOIN1
 S LN2=$$GETLINE("2ND LINE NUMBER",HELP) G:LN2'>0 JOIN1
 I LN2=1 D JOINMSG G JOIN1
 S ND2=$$GETNODE^%ZVEMRU(LN2) I ND2=0 W $C(7) G JOIN1
 I ND1=ND2 W $C(7) G JOIN1
 S FLAGSAVE=1 D JOIN2
 Q
JOIN2 ;Join line 2 to the end of line 1
 ;DELETE^%ZVEMRP1 deletes nodes in ^TMP("VEE","SAVE",$J,NODE) array
 ;-> Collapse 1st line
 S CD1=^TMP("VEE","IR"_VRRS,$J,ND1)
 S ^TMP("VEE","SAVE",$J,ND1)=""
 F I=ND1+1:1 Q:^TMP("VEE","IR"_VRRS,$J,I)[$C(30)  Q:^(I)=" <> <> <>"  D  ;
 . S CD1=CD1_$E(^TMP("VEE","IR"_VRRS,$J,I),10,9999)
 . S ^TMP("VEE","SAVE",$J,I)=""
 ;-> Delete 1st line and adjust line numbers
 S X=0
 I ND2>ND1 F  S X=$O(^TMP("VEE","SAVE",$J,X)) Q:X'>0  S ND2=ND2-1
 D DELETE^%ZVEMRP1(1)
 ;-> Collapse 2nd line
 S CD2=$P(^TMP("VEE","IR"_VRRS,$J,ND2),$C(30),2,999)
 S ^TMP("VEE","SAVE",$J,ND2)=""
 F I=ND2+1:1 Q:^TMP("VEE","IR"_VRRS,$J,I)[$C(30)  Q:^(I)=" <> <> <>"  D  ;
 . S CD2=CD2_$E(^(I),10,9999)
 . S ^TMP("VEE","SAVE",$J,I)=""
 ;-> Delete 2nd line and adjust line numbers
 S X=0
 I ND1>ND2 F  S X=$O(^TMP("VEE","SAVE",$J,X)) Q:X'>0  S ND1=ND1-1
 D DELETE^%ZVEMRP1(1)
 ;-> Join lines, re-insert, and adjust line numbers.
 S CD=CD1_" "_CD2
 S ^%ZVEMS("E","SAVEVRR",$J,1)=$E(CD,1,VEE("IOM")-1)
 S CD=$E(CD,VEE("IOM"),9999)
 F I=2:1 Q:CD']""  D  ;
 . S ^%ZVEMS("E","SAVEVRR",$J,I)=$J("",9)_$E(CD,1,VEE("IOM")-11)
 . S CD=$E(CD,VEE("IOM")-10,9999)
 S ^%ZVEMS("E","SAVEVRR",$J,I)=""
 S YND=ND1-1 S:YND<1 YND=1
 D PASTE^%ZVEMRP1
 Q
GETLINE(PROMPT,HELP,OFFSET) ;Return line number or zero to quit
 ;OFFSET=1 Allow TAG+OFFSET
 NEW LN
 S PROMPT=$G(PROMPT),HELP=$G(HELP)
 S DX=0,DY=VEET("S2")+1 X VEES("CRSR") W @VEES("BLANK_C_EOL")
 X VEES("CRSR") W @VEE("RON")," "_PROMPT_":",@VEE("ROFF")
GETLINE1 S DX=$L(PROMPT)+3 X VEES("CRSR") W @VEES("BLANK_C_EOL")
 X VEES("CRSR") F I=1:1:4 W "_"
 X VEES("CRSR") S LN=$$READ^%ZVEMKRN()
 I LN="^" Q 0
 I LN?1.E1"+"1.N,$G(OFFSET)=1 Q LN ;Goto Tag+Offset
 I ",<ESC>,<F1E>,<F1Q>,<RET>,<TO>,"[(","_VEE("K")_",") Q 0
 I LN'?1.N!(LN<0) D  G GETLINE1
 . W:"??"'[LN $C(7)
 . S DX=$L(PROMPT)+2 X VEES("CRSR") W @VEES("BLANK_C_EOL")
 . X VEES("CRSR") W HELP D PAUSE^%ZVEMKC(0)
 Q LN
