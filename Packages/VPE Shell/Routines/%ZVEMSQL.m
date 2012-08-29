%ZVEMSQL ;DJB,VSHL**QWIKs - List QWIKs [9/9/95 6:36pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
LISTQ(BOX,TYPE) ;List QWIKs. BOX=Display Box
 ;TYPE=1-User Desc,2-User Code,3-Sys Desc,4-Sys Code
 NEW X S X="ERROR^%ZVEMSQL",@($$TRAP^%ZVEMKU1) KILL X
 NEW CNT,FLAGQ,TEMP,X
 NEW DX,DY,VEET NEW:'$D(VEES) VEES
 S BOX=$G(BOX),FLAGQ=0 S:$G(TYPE)="" TYPE=1
 D IMPORT,@$S("34"[TYPE:"LISTS",1:"LISTU")
 D IMPORTF^%ZVEMKT KILL ^TMP("VEE",$J,"K")
 Q
LISTU ;List User QWIKs
 S CNT=1,X="@"
 F  S X=$O(^%ZVEMS("QU",VEE("ID"),X)) Q:X=""  D LISTU1 Q:FLAGQ
 I CNT=1 D
 . I BOX S VEET="No User QWIKs assigned to this box." D ^%ZVEMKT Q
 . S VEET="No User QWIKs on record. Is your DUZ correct?" D ^%ZVEMKT
 Q
LISTU1 ;
 Q:$G(^%ZVEMS("QU",VEE("ID"),X))']""
 I BOX,$P($G(^(X,"DSC")),"^",3)'=BOX Q
 S VEET=$J(CNT,3)_") "_X,VEET=VEET_$J("",15-$L(VEET))
 I 'BOX S VEET=VEET_$J($P($G(^%ZVEMS("QU",VEE("ID"),X,"DSC")),"^",3),4)_"  "
 I TYPE=1 D
 . S VEET=VEET_$P($G(^%ZVEMS("QU",VEE("ID"),X,"DSC")),"^")
 . D ^%ZVEMKT Q:FLAGQ
 . Q:$P($G(^%ZVEMS("QU",VEE("ID"),X,"DSC")),"^",2)']""
 . S TEMP=$S('BOX:21,1:15)
 . S VEET=$J("",TEMP)_"-> "_$P(^("DSC"),"^",2) D ^%ZVEMKT Q
 I TYPE=2 D
 . S TEMP=$S($D(^%ZVEMS("QU",VEE("ID"),X,VEE("OS"))):^(VEE("OS")),1:^%ZVEMS("QU",VEE("ID"),X)) D CD
 S CNT=CNT+1
 Q
LISTS ;List System QWIKs
 S CNT=1,X="@"
 F  S X=$O(^%ZVEMS("QS",X)) Q:X=""  D LISTS1 Q:FLAGQ
 I CNT=1 D
 . I 'BOX S VEET="No System QWIKs on record." D ^%ZVEMKT Q
 . S VEET="No System QWIKs assigned to this box." D ^%ZVEMKT
 Q
LISTS1 ;
 Q:$G(^%ZVEMS("QS",X))']""
 I BOX,$P($G(^(X,"DSC")),"^",3)'=BOX Q
 S VEET=$J(CNT,3)_") "_X,VEET=VEET_$J("",15-$L(VEET))
 I 'BOX S VEET=VEET_$J($P($G(^%ZVEMS("QS",X,"DSC")),"^",3),4)_"  "
 I TYPE=3 D
 . S VEET=VEET_$P($G(^%ZVEMS("QS",X,"DSC")),"^")
 . D ^%ZVEMKT Q:FLAGQ
 . Q:$P($G(^%ZVEMS("QS",X,"DSC")),"^",2)']""
 . S TEMP=$S('BOX:21,1:15)
 . S VEET=$J("",TEMP)_"-> "_$P(^("DSC"),"^",2) D ^%ZVEMKT Q
 I TYPE=4 D
 . S TEMP=$S($D(^%ZVEMS("QS",X,VEE("OS"))):^(VEE("OS")),1:^%ZVEMS("QS",X)) D CD
 S CNT=CNT+1
 Q
CD ;Print Code without wrapping
 I BOX D CDBX Q
 S VEET=VEET_$E(TEMP,1,57) D ^%ZVEMKT Q:FLAGQ  S TEMP=$E(TEMP,58,999)
CD1 Q:TEMP']""  S VEET=$J("",20)_$E(TEMP,1,57) D ^%ZVEMKT Q:FLAGQ
 S TEMP=$E(TEMP,58,999)
 G CD1
CDBX ;Print Code without wrapping when Boxes aren't displayed
 S VEET=VEET_$E(TEMP,1,63) D ^%ZVEMKT Q:FLAGQ  S TEMP=$E(TEMP,64,999)
CDBX1 Q:TEMP']""  S VEET=$J("",15)_$E(TEMP,1,63) D ^%ZVEMKT Q:FLAGQ
 S TEMP=$E(TEMP,64,999)
 G CDBX1
IMPORT ;Use Scroller
 NEW HD1,HD2,HD3,LINE,MAR
 S MAR=$G(VEE("IOM")) S:MAR'>0 MAR=80
 S $P(LINE,"=",MAR)=""
 S HD1="U S E R   Q W I K S   (.QWIK)    ID: "_VEE("ID")
 S HD2="S Y S T E M   Q W I K S   (..QWIK)    ID: "_VEE("ID")
 S HD3="BOX: "_BOX
 S VEET("HD")=2
 I "1,2"[TYPE S VEET("HD",1)=HD1_$J(HD3,MAR-1-$L(HD1)-$L(HD3))
 I "3,4"[TYPE S VEET("HD",1)=HD2_$J(HD3,MAR-1-$L(HD2)-$L(HD3))
 S VEET("HD",2)=LINE
 S VEET("S1")=3 D IMPORTS^%ZVEMKT("K")
 Q
ERROR ;
 D ENDSCR^%ZVEMKT2 KILL ^TMP("VEE",$J,"K")
 D ERRMSG^%ZVEMKU1("'Scroll QWIKs'"),PAUSE^%ZVEMKU(2)
 Q
