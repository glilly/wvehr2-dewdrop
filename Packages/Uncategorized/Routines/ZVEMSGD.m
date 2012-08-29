ZVEMSGD ;DJB,VSHL**VShell Global - ZR,ZS,ZT ; 9/6/02 7:56am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
ZR ;;;Load ^%ZVEMS("ZR")
 NEW CD,FLAGCLH,PROMPT,Y S:'$D(VEE("IOM")) VEE("IOM")=80 X ^%ZVEMS("ZR",2) S CD="",FLAGCLH=">>" D SCREEN^%ZVEMKEA(PROMPT,0,VEE("IOM")-2) X ^%ZVEMS("ZR",4),^%ZVEMS("ZR",3)
 X:$D(^%ZOSF("UCI"))&($D(^%ZVEMS("PARAM",VEE("ID"),"PROMPT"))) ^%ZOSF("UCI")  S PROMPT=$G(Y)_">>" X ^%ZVEMS("ZR",5)
 S VEESHC=$S(VEESHC="<RET>":CD,VEESHC?1"<".E1">".E&(CD']""):VEESHC,1:"")
 I VEESHC="TOO LONG" W ! D CLHSET^%ZVEMSCL("VSHL",CD) S VEESHC=""
 KILL ^%ZVEMS("ERROR",VEE("ID"))
 ;;;***
ZS ;;;Load ^%ZVEMS("ZS")
 NEW % S ^%ZVEMS("%",$J_$G(^%ZVEMS("SY")))=+$H_"^Scratch Area" X ^%ZVEMS("ZS",7)
 Q:$G(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"SV"))=""  X ^%ZVEMS("ZS",8)
 X ^%ZVEMS("ZS",2) D BS^%ZVEMKY1 NEW I F I=1:1:9 KILL @("%"_I) ;kill parameter variables
 Q:VEESHC?1"<".E1">"!(",^,H,h,HALT,halt,"[(","_VEESHC_","))  NEW CHK,X S CHK=0,X=$G(^%ZVEMS("CLH",VEE("ID"),"VSHL")) X ^%ZVEMS("ZS",6) Q:CHK  X ^%ZVEMS("ZS",5)
 S X=$G(^%ZVEMS("CLH",VEE("ID"),"VSHL"))+1,^("VSHL")=X,^("VSHL",X)=VEESHC I X>20 S X=$O(^%ZVEMS("CLH",VEE("ID"),"VSHL","")) KILL ^(X)
 I X>0,$G(^%ZVEMS("CLH",VEE("ID"),"VSHL",X))=VEESHC!($G(^(X-1))=VEESHC) S CHK=1
 NEW %,LIST,VAR X ^%ZVEMS("ZS",9) S ^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"SV")="" F %=1:1:$L(LIST,"^") S VAR=$P(LIST,"^",%) S ^("SV")=^("SV")_$S($D(@VAR)#2:@VAR,1:"")_"^"
 NEW %,LIST X ^%ZVEMS("ZS",9) F %=1:1:$L(LIST,"^") S @($P(LIST,"^",%)_"=$P(^%ZVEMS(""%"",$J_$G(^%ZVEMS(""SY"")),""SV""),""^"",%)")
 S LIST="VEE(""ID"")^VEE(""EON"")^VEE(""EOFF"")^VEE(""IOF"")^VEE(""IOSL"")^VEE(""OS"")^VEE(""IO"")^VEE(""IOM"")^VEE(""TRMON"")^VEE(""TRMOFF"")^VEE(""TRMRD"")^VEE(""$ZE"")"
 ;;;***
ZT ;;;Shell timed out
 S VEESHC=$G(^%ZVEMS("QU",VEE("ID"),"TO")) Q:VEESHC=""  S:VEESHC="HALT"!(VEESHC="halt") VEESHC="^"
 ;;;***
