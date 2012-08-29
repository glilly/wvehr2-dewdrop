%ZVEMSS1 ;DJB,VSHL**..SAVE cont.. ; 9/7/02 1:46pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
BUILD ;Build ^UTILITY($J,0) Global
 NEW CNT,QWIK,VRRPGM,X
 W "   Please wait.."
 KILL ^UTILITY($J)
 S ^UTILITY($J,0,1)=RTN_" ;VPE**Saved User QWIKs ("_$H_")"
 S ^UTILITY($J,0,2)=" ;;VSHELL;;"
 S ^UTILITY($J,0,3)="QWIK ;Saved QWIK Commands"
 S ^UTILITY($J,0,4000)=" ;;***"
 ;
 S CNT=4
 S QWIK="@" F  S QWIK=$O(^%ZVEMS("QU",VEE("ID"),QWIK)) Q:QWIK=""  D
 . S ^UTILITY($J,0,CNT)=" ;;"_QWIK_";D;"_$G(^%ZVEMS("QU",VEE("ID"),QWIK,"DSC")) ;Description
 . S CNT=CNT+1
 . S ^UTILITY($J,0,CNT)=" ;;"_QWIK_";C;"_^%ZVEMS("QU",VEE("ID"),QWIK) ;Code
 . S CNT=CNT+1,X="" ;Next is Vendor specific code
 . F  S X=$O(^%ZVEMS("QU",VEE("ID"),QWIK,X)) Q:X'>0  S ^UTILITY($J,0,CNT)=" ;;"_QWIK_";"_X_";"_^%ZVEMS("QU",VEE("ID"),QWIK,X),CNT=CNT+1
 ;
 S VRRPGM=RTN
 X ^%ZVEMS("E",2)
 KILL ^UTILITY($J)
 Q
 ;
RESTORE ;Code used to build saving routine
 NEW CODE,FLAGQ,I,QWIK,TXT,TYPE
 D CHECK G:FLAGQ EX D STUFF
EX ;
 Q
CHECK ;Check for existing QWIKs
 S FLAGQ=0
 W !!
 F I=1:1 S @("TXT=$T(QWIK+"_I_"^"_RTN_")") Q:$P(TXT,";",3)="***"  S QWIK=$P(TXT,";",3) I $P(TXT,";",4)="D",$D(^%ZVEMS("QU",ID,QWIK)) S FLAGQ=1 W " ",QWIK I $X>65 W !
 Q:'FLAGQ
 S FLAGQ=0
 W !!,"This routine contains the above QWIK(s) which already exist on your"
 W !,"system. If I continue I will overwrite them. You may stop the load"
 W !,"here and edit ^",RTN," to change the names.",!
ASK R !,"Should I continue? YES// ",CODE:600 S:'$T CODE="^" S:CODE="" CODE="Y" S CODE=$E(CODE)
 I "^YyNn"'[CODE W "   Y=Yes  N=No" G ASK
 S:"Yy"'[CODE FLAGQ=1
 Q
 ;
STUFF ;Load the QWIKs
 F I=1:1 S @("TXT=$T(QWIK+"_I_"^"_RTN_")") Q:$P(TXT,";",3)="***"  S QWIK=$P(TXT,";",3),TYPE=$P(TXT,";",4) D
 . I TYPE="D" S ^%ZVEMS("QU",ID,QWIK,"DSC")=$P(TXT,";",5,999) I $G(BOX)]"" S $P(^("DSC"),"^",3)=BOX ;Description
 . I TYPE="C" S ^%ZVEMS("QU",ID,QWIK)=$P(TXT,";",5,999) ;Code
 . I TYPE?1.N S ^%ZVEMS("QU",ID,QWIK,TYPE)=$P(TXT,";",5,999) ;Vendor specific code
 Q
