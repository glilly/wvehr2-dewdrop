%ZVEMGO ;DJB,VGL**CODE SEARCH,SKIP [11/10/94]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SKIP ;Skipping over nodes. Also, see first line of PRINT^%ZVEMGI.
 Q:'$G(FLAGSKIP)  NEW SUBCHK D GETSUB Q:$G(SUBCHK)']""
 S FLAGSKIP=$S(FLAGSKIP<1:0,FLAGSKIP>$L(SUBCHK,ZDELIM):0,1:FLAGSKIP)
 Q:'FLAGSKIP  S SKIPHLD=$P(SUBCHK,ZDELIM,FLAGSKIP)
 Q
GETSUB ;Get SUBCHK
 NEW ND,NUM S NUM=VEET("BOT")-1
 F NUM=NUM:-1:0 S ND=$G(^TMP("VEE","IG"_GLS,$J,"SCR",NUM)) Q:ND>0
 Q:ND'>0  S ND=^TMP("VEE","VGL"_GLS,$J,ND),SUBCHK=$$ZDELIM^%ZVEMGU(ND)
 Q
SKIPCHK ;See if node should be skipped
 NEW ND,NUM S NUM=VEET("BOT")-1
 I '$D(^TMP("VEE","IG"_GLS,$J,"SCR",NUM)) D  Q
 . S VEET("TOP")=VEET("TOP")+1
 S ND=^(NUM),ND=^TMP("VEE","VGL"_GLS,$J,ND)
 S SUBCHK=$$ZDELIM^%ZVEMGU(ND)
 I $P(SUBCHK,ZDELIM,FLAGSKIP)=SKIPHLD D  Q
 . S VEET("TOP")=VEET("TOP")+1
 S FLAGSKIP=0 KILL SKIPHLD
 S VEET("TOP")=VEET("BOT")-1 D REDRAW^%ZVEMKT2()
 Q
 ;====================================================================
CODE ;Get CODE for doing a Code Search.
 W !!?2,"The following variables are available:"
 W !!?5,"GLNAM = ""^DIC(4,1,0)"""
 W !?5,"   GL = ""^DIC"""
 W !?5,"GLSUB = ""4,1,0"""
 W !?5,"GLVAL = The data in node ^DIC(4,1,0)"
 W !?5,"    U = ""^""",!
CODE1 R !?1,"Enter Mumps Code: ",CODE:VEE("TIME") S:'$T CODE=0
 I "^"[CODE S CODE=0 Q:CODE=0
 I $E(CODE)="?" D  G CODE1
 . W "   If code evaluates to TRUE, node will be displayed."
 NEW X S X="ERROR1^%ZVEMGY",@($$TRAP^%ZVEMKU1) KILL X X CODE
 Q
CDSRCH ;CODE search. Quit if search is currently active
 NEW GLNAM,GLSUB,GLVAL,I,ZREF
 Q:VEET("STATUS")["SEARCH"  S $P(VEET("STATUS"),"^",4)="SEARCH"
 KILL ^TMP("VEE",$J),^TMP("VEE","IG"_GLS,$J)
 S ^TMP("VEE","IG"_GLS,$J,1)=" CODE SEARCH IN PROGRESS.."
 S ^TMP("VEE","IG"_GLS,$J,2)=" Hit any key to abort. BEEP indicates search is finished."
 S ^TMP("VEE","IG"_GLS,$J,3)="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
 S ZREF=0,VEET("BOT")=4,VEET("TOP")=1
 F  S ZREF=$O(^TMP("VEE","VGL"_GLS,$J,ZREF)) Q:ZREF'>0  D  Q:CODE=0
 . S GLNAM=^(ZREF),GL=$P(GLNAM,"("),GLVAL=@GLNAM
 . S GLSUB=$P($E(GLNAM,1,$L(GLNAM)-1),"(",2,99)
 . X CODE E  R VEEX#1:0 S:$T CODE=0 Q  ;Hit any key to quit
 . S ^TMP("VEE",$J,ZREF)=GLNAM
 . S VEET=GLNAM D SETARRAY^%ZVEMGI
 . F I=VEET("BOT"):1 I '$D(^TMP("VEE","IG"_GLS,$J,I)) Q
 . S VEET("BOT")=I ;Reset to include number of lines displayed
 KILL ^TMP("VEE","VGL"_GLS,$J)
 I $D(^TMP("VEE",$J)) S ZREF=0 F  S ZREF=$O(^TMP("VEE",$J,ZREF)) Q:ZREF'>0  S ^TMP("VEE","VGL"_GLS,$J,ZREF)=^(ZREF)
 KILL ^TMP("VEE",$J)
 I VEET("STATUS")["FINISH" D
 . S CODE=0,^TMP("VEE","IG"_GLS,$J,VEET("BOT"))=" <> <> <>"
 . W $C(7),$C(7) S $P(VEET("STATUS"),"^",4)=""
 S VEET("BOT")=VEET("TOP")
 S VEET("HLN")=VEET("TOP"),VEET("H$Y")=VEET("S1")-1
 Q
