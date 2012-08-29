%ZVEMRS1 ;DJB,VRR**Set Scroll Array ; 9/5/02 3:13pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SETGLB ;Put routine into global
 NEW I,TXT
 KILL ^TMP("VEE","VRR",$J,VRRS)
 KILL ^TMP("VEE","IR"_VRRS,$J)
 KILL ^TMP("VEE",$J)
 S ^TMP("VEE","VRR",$J,VRRS,"NAME")=VRRPGM
 I $G(VEESHL)="RUN" D CLHSET^%ZVEMSCL("VRR",VRRPGM) ;Cmnd Ln History
 I '$$EXIST^%ZVEMKU(VRRPGM) S VRRHIGH=0 Q
 X "F I=1:1 S TXT=$T(+I^"_VRRPGM_") Q:TXT=""""  S TXT=$P(TXT,"" "")_$C(9)_$P(TXT,"" "",2,999),^TMP(""VEE"",$J,I)=TXT"
 D SET
 KILL ^TMP("VEE",$J)
 Q
SET ;
 NEW CODE,CNT,END,END1,LINE,LN,TG,X
 S CNT=1,X=0
 F  S X=$O(^TMP("VEE",$J,X)) Q:X'>0  S CODE=^(X) D SET1
 S ^TMP("VEE","IR"_VRRS,$J,CNT)=" <> <> <>"
 Q
SET1 ;Set scroll array
 S VRRHIGH=X
 S TG=$P(CODE,$C(9)),LN=$P(CODE,$C(9),2,999)
 S (END,END1)=VEE("IOM")-11
 I $L(TG)>8 S END1=END1-($L(TG)-8)
 S TXT=$S(TG]"":$J("",8-$L(TG))_TG,1:X_$J("",8-$L(X))) ;Ln number
 S TXT=TXT_" "_$C(30)_$E(LN,1,END1)
 S ^TMP("VEE","IR"_VRRS,$J,CNT)=TXT,CNT=CNT+1
 S LN=$E(LN,(END1+1),999) Q:LN']""  F  D  Q:LN=""
 . S TXT=$J("",9)_$E(LN,1,END)
 . S LN=$E(LN,(END+1),999)
 . S ^TMP("VEE","IR"_VRRS,$J,CNT)=TXT,CNT=CNT+1
 Q
