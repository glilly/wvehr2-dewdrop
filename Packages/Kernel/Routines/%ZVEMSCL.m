%ZVEMSCL ;DJB,VSHL**Command Line History [1/17/97 9:05am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN(TYPE) ;TYPE=SHL/VEDD/VGL/VRR
 NEW CD,FLAGCLH,HOLD,X
 S FLAGCLH="CLH",HOLD=0,TYPE=$G(TYPE)
 D @$S(VEESHC="<AL>":"LIST",1:"STEP")
EX ;
 I TYPE="VSHL",VEESHC="TOO LONG" W ! D CLHSET("VSHL",CD) ;Shell's CLH. Line was too long, but save 245 characters to CLH.
 D CLEANUP
 Q
 ;===================================================================
STEP ;Step thru Commands 1 at a time
 Q:'$D(^%ZVEMS("CLH",VEE("ID"),TYPE))
 I VEESHC="<AU>" S X=$S(HOLD>0:HOLD-1,1:+^%ZVEMS("CLH",VEE("ID"),TYPE))
 I VEESHC="<AD>" S X=$S(HOLD>0:HOLD+1,1:$O(^%ZVEMS("CLH",VEE("ID"),TYPE,"")))
 Q:$G(X)'>0  Q:'$D(^%ZVEMS("CLH",VEE("ID"),TYPE,X))
 S CD=^%ZVEMS("CLH",VEE("ID"),TYPE,X)
STEP1 D SCREEN^%ZVEMKEA("",0,VEE("IOM")-2)
 I VEESHC="<ESCQ>" D QWIK^%ZVEMSCU(CD) Q
 I VEESHC="<RET>" S VEESHC="**"_CD Q
 I VEESHC="<AU>"!(VEESHC="<AD>") S HOLD=X G STEP
 I VEESHC="<ESCH>" D HELP^%ZVEMSCU G STEP1
 Q
 ;===================================================================
LIST ;List Command History (<AL>)
 W @VEE("IOF"),!?19,"C O M M A N D   L I N E   H I S T O R Y"
 S X="" F  S X=$O(^%ZVEMS("CLH",VEE("ID"),TYPE,X)) Q:X=""  W !?1,X,") ",^(X)
 W !
LIST1 R !?1,"Select: ",X:500 S:'$T X="^" I "^"[X Q
 I '$D(^%ZVEMS("CLH",VEE("ID"),TYPE)) W "   Command Line History for ",TYPE," is empty" G LIST1
 I '$D(^%ZVEMS("CLH",VEE("ID"),TYPE,X)) W "   Select number from left hand column" G LIST1
 S CD=^%ZVEMS("CLH",VEE("ID"),TYPE,X)
LIST2 D SCREEN^%ZVEMKEA("",0,VEE("IOM")-2)
 I VEESHC="<ESCQ>" D QWIK^%ZVEMSCU(CD) Q
 I VEESHC="<RET>" S VEESHC="**"_CD
 I VEESHC="<ESCH>" D HELP^%ZVEMSCU G STEP1
 Q
 ;===================================================================
CLEANUP ;Clean up extra characters if user hits arrow keys at the wrong time
 NEW I,Y X VEE("EOFF")
 F I=1:1:3 R *Y:0 ;If user types arrow key in wrong place
 X VEE("EON")
 Q
 ;=====================VPE modules call here==========================
CLHSET(TYPE,VALUE) ;Store Command Line.
 ;TYPE=SHL/VEDD/VGL/VRR
 ;VALUE=Command Line
 Q:$G(TYPE)']""  Q:$G(VALUE)']""
 NEW X
 I '$D(VEE("ID")) X ^%ZVEMS("ZS",3)
 ;-> Don't save if it matches last 2 commands
 S X=$G(^%ZVEMS("CLH",VEE("ID"),TYPE))
 I X>0 Q:$G(^(TYPE,X))=VALUE  Q:$G(^(X-1))=VALUE
 S X=$G(^%ZVEMS("CLH",VEE("ID"),TYPE))+1,^(TYPE)=X,^(TYPE,X)=VALUE
 I X>20 S X=$O(^%ZVEMS("CLH",VEE("ID"),TYPE,"")) KILL ^(X)
 Q
CLHEDIT(TYPE,PROMPT) ;Edit Command Line - TYPE=VEDD/VGL/VRR
 NEW CD,FLAGCLH S FLAGCLH=">>"
 S TYPE=$G(TYPE),PROMPT=$G(PROMPT) I TYPE']"" Q "^"
 I '$D(VEE("ID")) X ^%ZVEMS("ZS",3) ;Reset VShell variables
 D SCREEN^%ZVEMKEA(PROMPT,1,VEE("IOM")-2) I VEESHC="<RET>" Q CD
 I VEESHC="<AR>",$G(FLAGVPE)["VEDD",$G(FLAGDEF)]"" S CD=FLAGDEF Q CD
 I ",<ESC>,<ESCH>,<F1E>,<F1Q>,<TO>,"[(","_VEESHC_",") S CD=$S(VEESHC="<ESCH>":"?",1:"^") Q CD
 I "<AU>,<AD>,<AL>,<AR>"'[VEESHC Q VEESHC
 D EN(TYPE) S:VEESHC?1"**".E VEESHC=$P(VEESHC,"**",2,99) S:VEESHC="^" VEESHC=""
 Q VEESHC
