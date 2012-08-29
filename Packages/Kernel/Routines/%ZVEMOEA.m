%ZVEMOEA ;DJB,VRROLD**CHANGE - READ,HELP ; 12/15/00 8:31pm
 ;;7.0;VPE;;COPYRIGHT David Bolduc @1993
 ;
 NEW CDHLD,FLAGQ,START,TAB1,TAB2,TEMP,TOP,VK,WIDTH,X,VEES
 NEW XCHAR,XCUR,YCNT,YCNTHLD,YCUR
 S FLAGQ=0 D INIT Q:FLAGQ
 X VEES("RM0")
 D BOTTOM^%ZVEMOU,PRINTA^%ZVEMOEP
 S CDHLD=CD ;Save original code. Restore old tag if new is illegal
 F  D READ Q:FLAGQ
EX ;
 I YCUR<YCNT F I=1:1:(YCNT-YCUR) W ! ;Reposition cursor to bottom line
 I $$TAGCHK^%ZVEMOEU(CD) D DELTAG
 I $$LINECHK^%ZVEMOEU(CD) D DELLINE 
 X VEES("RM80")
 Q
READ ;
 S X=$$READ^%ZVEMKR("",1),VK=$G(VEE("K"))
 I VK="<RET>"!(VK="<ESC>") S FLAGQ=1 Q
 I +TAB1>0,",<F1>,<F2>,<F3>,<F4>,<AU>,<AD>,<AL>,<AR>,<ESCD>,<ESCT>,"'[(","_VK_",") S (TAB1,TAB2)=0 D PRINTA^%ZVEMOEP Q  ;Clear Bulk Delete
 I VK="<ESCT>" D BULKDEL^%ZVEMOEB Q
 I VK="<ESCD>" D BULKDEL1^%ZVEMOEB Q
 I VK="<ESCH>" D HELP,PRINTA^%ZVEMOEP Q
 I ",<AR>,<AL>,<AU>,<AD>,"[(","_VK_",") D ARROW^%ZVEMOEB,CLRSCRN1^%ZVEMOEU Q
 I VK?1"<F".E1">" D OTHER^%ZVEMOEB,CLRSCRN1^%ZVEMOEU Q
 I ",<BS>,<DEL>,"[(","_VK_",") D  D DELETE^%ZVEMOEB Q
 . S:$G(VEE("BS"))="SAME" VK="<BS>"
 I VK?1"<".E1">".E Q
 D INSERT^%ZVEMOEB
 Q
DELLINE ;Delete line if all the code has been deleted out.
 F I=VRRLN:1:(VRRHIGH-1) S ^TMP("VEE","VRR",$J,VRRS,"TXT",I)=^TMP("VEE","VRR",$J,VRRS,"TXT",(I+1))
 KILL ^TMP("VEE","VRR",$J,VRRS,"TXT",VRRHIGH) S VRRHIGH=VRRHIGH-1
 Q
DELTAG ;Delete invalid TAG
 S $P(CD,$C(9),1)=$P(CDHLD,$C(9),1)
 S ^TMP("VEE","VRR",$J,VRRS,"TXT",VRRLN)=CD
 Q
HELP ;
 S DX=0,DY=TOP X VEES("CRSR") W @VEES("BLANK_TOS_C")
 S DY=0 X VEES("CRSR")
 W !?1,@VEE("RON"),"QUIT",@VEE("ROFF")
 S DX=0,DY=$Y X VEES("XY")
 W " Press <RETURN> to quit EDIT session and return  to the routine."
 W !!?1,@VEE("RON"),"INSERT/DELETE",@VEE("ROFF")
 S DX=0,DY=$Y X VEES("XY")
 W " Type any character to insert that character to the left of the"
 W !?1,"cursor. <BACKSPACE>/<DELETE> deletes the character to the left of the cursor."
 W !!?1,@VEE("RON"),"ARROW KEYS",@VEE("ROFF")
 S DX=0,DY=$Y X VEES("XY")
 W " Use the <ARROW> keys to position the curser. To edit the TAG, use"
 W !?1,"<UP ARROW> to move cursor to the TAG area, then make desired changes."
 W !!?1,@VEE("RON"),"PF KEYS",@VEE("ROFF")
 S DX=0,DY=$Y X VEES("XY")
 W " Use F/PF keys to rapidly position the cursor when Inserting & Deleting."
 W !?3,"<F1><AL> = Cursor to line begin      <F1><AR> = Cursor to line end"
 W !?3,"<F2><AL> = Cursor left 15 spaces     <F2><AR> = Cursor right 15 spaces"
 W !!?1,@VEE("RON"),"BULK DELETE",@VEE("ROFF")
 S DX=0,DY=$Y X VEES("XY")
 W " Position cursor and press <ESC>T. Reposition cursor and press"
 W !?1,"<ESC>T again. Press <ESC>D to delete from the 1st highlighted character to"
 W !?1,"the 2nd, or press any alpha key to terminate the delete."
 Q
INIT ;
 D:'$D(VEE("OS")) OS^%ZVEMKY Q:FLAGQ
 D SCRNVAR^%ZVEMKY2,CRSRMOVE^%ZVEMKY2,BLANK^%ZVEMKY3
 S (TAB1,TAB2)=0,(XCHAR,YCUR)=1,(START,XCUR)=9,WIDTH=69
 S CODELN=$P(CD,$C(9),2,999)
 F YCNTHLD=1:1 Q:$L(CODELN)'>(WIDTH*YCNTHLD)  ;If YCNT becomes greater than YCNTHLD, then handle the scrolling.
 S TOP=19 I YCNTHLD>2 S TOP=TOP-(YCNTHLD-2)
 Q
