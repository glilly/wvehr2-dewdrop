%ZVEMRMG ;DJB,VRR**Goto Tag+Offset,%INDEX ; 1/8/01 8:38am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;
 I '$D(^TMP("VEE","IR"_VRRS,$J,1)) W $C(7) Q
 I $G(^TMP("VEE","IR"_VRRS,$J,1))=" <> <> <>" W $C(7) Q
 NEW FLAGQ,TAG,OFFSET
 Q:$G(LN)'["+"
 S TAG=$P(LN,"+",1)
 S OFFSET=$P(LN,"+",2) Q:OFFSET'>0
 S FLAGQ=0
 D FINDTAG Q:FLAGQ
 D OFFSET
 Q
 ;
FINDTAG ;Find line tag that contains TXT
 NEW CHK,I,TG,TMP
 S CHK=0
 F I=1:1 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,I)) Q:TMP']""  Q:TMP=" <> <> <>"  D  Q:CHK
 . Q:TMP'[$C(30)
 . D GETTAG Q:TG'[TAG
 . ;Note: FLAGMENU=YND^VEET("TOP")^YCUR^XCUR
 . S FLAGMENU=I_"^"_I_"^"_1
 . S CHK=1
 I 'CHK S FLAGQ=1,(XCUR,YCUR)=0 D MSG^%ZVEMRUM(16)
 Q
 ;
GETTAG ;Get tag from scroll array and convert to external format
 S TG=$P(TMP," "_$C(30),1)
 I TG?1.N1." " S TG="" Q
 F  Q:$E(TG)'=" "  S TG=$E(TG,2,999) ;Strip starting spaces
 Q
 ;
OFFSET ;Go to offset
 NEW HELP,NUM,X
 ;Convert node array number to line number
 S (NUM,X)=$P(FLAGMENU,U,1)
 S OFFSET=NUM+OFFSET
 F  S X=$O(^TMP("VEE","IR"_VRRS,$J,X)) Q:X'>0  D  Q:NUM=OFFSET
 . I ^(X)[$C(30) S NUM=NUM+1
 ;Show at least 1 line of code
 I X'>0 S X=$O(^TMP("VEE","IR"_VRRS,$J,""),-1) S:X>1 X=X-1
 S FLAGMENU=X_"^"_X_"^"_1
 Q
 ;====================================================================
INDEX ;Run %INDEX
 D SYMTAB^%ZVEMKST("S","VRR",VRRS) ;......Save symbol table
 NEW RTN
 S RTN=$G(^TMP("VEE","VRR",$J,VRRS,"NAME"))
 W !,"*** RUNNING %INDEX ("_RTN_") ***",!
 D  ;
 . NEW VEE,VEES,VRRS
 . D ^%INDEX
 . KILL
 D SYMTAB^%ZVEMKST("R","VRR",VRRS) ;......Restore symbol table
 X ^%ZVEMS("ZS",3) ;......................Reset VShell variables
 D PAUSE^%ZVEMKC(2)
 Q
