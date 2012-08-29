%ZVEMDX ;DJB,VEDD**List Old-style Xrefs ; 12/9/00 1:36pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 NEW CHK,CNT,CNTINDEX,CNTKEY,DATA,FILE,FLD,GLTEMP,INDENT
 NEW LEV,LINE,NAM,PAGE,VEES,ZDATA
TOP ;
 W "   Please wait.."
 D INIT
 D INIT^%ZVEMDPR ;Print heading
 D KEYS G:FLAGQ EX
 D NEWSTYLE G:FLAGQ EX
 D OLDSTYLE
EX ;
 KILL ^TMP("VEE","XREF",$J)
 Q
 ;
KEYS ;Display Keys, introduced with FM22.
 D KEYS^%ZVEMDXK(ZNUM)
 Q
 ;
NEWSTYLE ;Display new-style indexes introduced with FM22.
 D INDEX^%ZVEMDXK(ZNUM)
 Q
 ;
OLDSTYLE ;Display old-style indexes
 ;
 ;Heading
 I CNTINDEX>1!(CNTKEY>1) W ! D:$Y>VEESIZE PAGE^%ZVEMDXK Q:FLAGQ
 I FLAGP,$E(VEEIOST,1,2)="P-" D  ;...Printer
 . W !!,"<<< OLD-STYLE INDEXES >>>",!
 E  D  ;...CRT
 . W !,@VEE("RON")," OLD-STYLE INDEXES ",@VEE("ROFF")
 D:$Y>VEESIZE PAGE^%ZVEMDXK Q:FLAGQ
 W ! D:$Y>VEESIZE PAGE^%ZVEMDXK Q:FLAGQ
 ;
 D LOOP Q:FLAGQ
 D:CNTINDEX=1 HD ;Use New-style Indexes heading
 D PRINT
 Q
 ;
LOOP ;Loop thru ^DD
 S (CNT,LEV,PAGE)=1
 S FILE(LEV)=ZNUM
 S FLD(LEV)=0
 F  S FLD(LEV)=$O(^DD(FILE(LEV),FLD(LEV))) D  Q:'LEV!(FLAGQ)
 . I +FLD(LEV)=0 S LEV=LEV-1 Q
 . Q:'$D(^DD(FILE(LEV),FLD(LEV),0))
 . S ZDATA=^DD(FILE(LEV),FLD(LEV),0)
 . D:$D(^DD(FILE(LEV),FLD(LEV),1)) XREF
 . Q:$P($P(ZDATA,U,4),";",2)'=0
 . S LEV=LEV+1
 . S FILE(LEV)=+$P(ZDATA,U,2)
 . S FLD(LEV)=0
 Q
 ;
XREF ;
 NEW DATA,K,FNAM
 S K=0
 F  S K=$O(^DD(FILE(LEV),FLD(LEV),1,K)) Q:'K!FLAGQ  D  ;
 . S DATA=^(K,0)
 . S NAM=$P(DATA,U,2)
 . I NAM']"" S NAM=$E($P(DATA,U,3),1,8) I NAM]"" S NAM="["_NAM_"]"
 . S:NAM']"" NAM="[Unknown]"
 . I LEV>1 S NAM=$E(INDENT,1,LEV-1)_NAM
 . S FNAM=$P(^DD(FILE(LEV),FLD(LEV),0),U,1)
 . S ^TMP("VEE",$J,NAM,CNT)=FILE(LEV)_U_FLD(LEV)_U_FNAM
 . S CNT=CNT+1
 Q
 ;
PRINT ;Print Xref's
 NEW X,Y S X=""
 F  S X=$O(^TMP("VEE",$J,X)) Q:X=""!FLAGQ  S Y="" F  S Y=$O(^TMP("VEE",$J,X,Y)) Q:Y=""!FLAGQ  D  ;
 . S DATA=^(Y)
 . S NAM=$TR(X,"}","-")
 .
 . ;Mark Index indicating data
 . I "-,["'[$E(NAM) D  ;..Ignore multiples, triggers, & bulletins
 .. S GLTEMP=ZGL_""""_NAM_""""_")"
 .. S NAM=$S($D(@GLTEMP):"*",1:"")_NAM
 . I $E(NAM)'="*" S NAM=" "_NAM
 . ;
 . W !,NAM,?20,$P(DATA,U,1),?37,$P(DATA,U,3)_" (#"_$P(DATA,U,2)_")"
 . D:$Y>VEESIZE PAGE
 Q
 ;
HD ;Heading
 W !?7,"INDEX",?25,"FILE",?52,"FIELD(S)"
 W !,"------------------",?20,"---------------",?37,"----------------------------------------"
 Q
 ;
PAGE ;
 I FLAGP,$E(VEEIOST,1,2)="P-" W @VEE("IOF"),!!! D HD Q
 D PAUSEQE^%ZVEMKC(2) Q:FLAGQ  W @VEE("IOF") D HD
 Q
 ;
INIT ;
 KILL ^TMP("VEE",$J)
 S INDENT="}}}}}}}}}}}}}}}}}}}}}}}}}}}"
 S $P(LINE,".",220)=""
 S CNTINDEX=1
 S CNTKEY=1
 D REVVID^%ZVEMKY2
 Q
