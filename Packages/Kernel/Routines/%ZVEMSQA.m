%ZVEMSQA ;DJB,VSHL**QWIKs - Display,Msg [1/16/96 11:04pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
DISPLAY ;Display QWIK info
 NEW CD,I,LMAR,PROMPT,START,WIDTH
 W @VEE("IOF"),!?1,"ADD/EDIT USER QWIK",!?1 F I=1:1:VEE("IOM")-2 W "-"
 W !?1,"1) NAME:  ",NAM I NAM="TO" D TO
 W !?1,"2) CODE:" S CD=$G(^%ZVEMS("QU",VEE("ID"),NAM)) I CD]"" S PROMPT="",(LMAR,START)=11,WIDTH=VEE("IOM")-12 D LISTCD^%ZVEMKEA
 W !?1,"3) DESC:  " W $P($G(^(NAM,"DSC")),"^")
 W !?1,"4) PARAM: " W $P($G(^("DSC")),"^",2)
 W !?1,"5) BOX:   " W $P($G(^("DSC")),"^",3)
 W !?1 F I=1:1:VEE("IOM")-2 W "-"
 W !?1,"<ESC><ESC>=Quit  <TAB>=Restart  <ESC>H=Help  <ESC>1-5=Field  <ESC>U=UNsav"
 W ! Q
 ;====================================================================
TO ;WARNING - If QWIK is named TO, it'll be executed if VShell times-out.
 W $C(7),?22,"WARNING: This QWIK will be executed if VShell times-out."
 Q
 ;====================================================================
JUMP ;Set FLAGJMP=Field you wish to edit
 S FLAGJMP=0 I VEESHC?1"<ESC"1N1">",$E(VEESHC,5)>0,$E(VEESHC,5)<6 S FLAGJMP=$E(VEESHC,5)
 Q
 ;====================================================================
UNSAVE ;UNsave code SAved from a routine or global.
 NEW J
 I '$D(^%ZVEMS("E","SAVE",$J,1)) W $C(7),!?1,"No code saved.." Q
 S CD=^%ZVEMS("E","SAVE",$J,1)
 F J=1:1:($L(CD,$C(9))-1) S CD=$P(CD,$C(9),1)_$P(CD,$C(9),2,999)
 W !?1,"1 line of code UNsaved.."
 Q
 ;====================================================================
MSG(NUM) ;Messages
 ;NUM=Subroutine
 Q:$G(NUM)'>0  D @NUM
 Q
1 ;Name
 W !?3,"QWIK must be from 1 to 8 characters long."
 W !?3,"The 1st character must be alpha."
 W !?3,"Remaining 7 characters may be alpha/numeric."
 Q
2 W !?3,"Enter from 1 to 245 characters of M Code, or <ESC>U to UNsave code." Q
3 W !?3,"Enter from 1 to 55 Alph/Numeric/Punctuation. '^' Character not allowed." Q
4 W $C(7),!?3,"You can not have an '^' character in your text." Q
5 W !?3,"Enter display BOX number. Any whole number greater than zero." Q
6 W $C(7),!?3,"This QWIK already exists." Q
7 W !?3,"Enter '??' for a list of your QWIK Commands." Q
8 W !?3,"Enter the name of an existing QWIK." Q
