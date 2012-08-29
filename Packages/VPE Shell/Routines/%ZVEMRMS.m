%ZVEMRMS ;DJB,VRR**Save Changes ; 12/17/00 6:32pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SAVE ;Save changes on-the-fly.
 ;Rtns calling here should have FLAGQ=1. FLAGQ is set to 0 if user
 ;is not to be exited but returned to current rtn to continue editing.
 ;
 Q:$$ASK^%ZVEMKU(" Do you wish to save your changes",1)'="Y"
 ;
 NEW VEES,VRRPGM,VRRUPDAT,X
 ;
 S X="ERROR^%ZVEMRMS",@($$TRAP^%ZVEMKU1) KILL X
 KILL ^UTILITY($J)
 ;
 D BUILD G:$G(VRRPGM)']"" EX
 G:$$DUP() EX
 D VERIFY^%ZVEMRV(VRRS) G:'FLAGQ EX
 X "S X=VRRPGM X VEES(""ZS"")"
 I VRRS>1 L -VRRLOCK(VRRPGM)
 W !!,"Changes saved to disk..."
 ;
 D ADD^%ZVEMRLU(VRRPGM) ;Routine Library
 D ADD^%ZVEMRLV(VRRPGM) ;Routine Versioning
 ;
 S FLAGSAVE=0
 D PAUSE^%ZVEMKC(2)
 ;
EX ;Exit
 KILL ^UTILITY($J)
 Q
 ;
BUILD ;Build ^UTILITY array
 NEW FLAGQ,LN,TG
 S FLAGQ=0
 D INIT^%ZVEMRC
 I FLAGQ S VRRPGM="" Q
 S VRRPGM=$G(^TMP("VEE","VRR",$J,VRRS,"NAME"))
 Q:VRRPGM']""
 D CONVERT^%ZVEMRV(VRRS)
 S TMP=$G(^UTILITY($J,0,1))
 I TMP']""!(TMP=" <> <> <>") S VRRPGM="" Q
 S TG=$P(TMP," ",1),LN=$P(TMP," ",2,99)
 D DATE^%ZVEMRC
 Q
 ;
DUP() ;Can't save changes to rtn you are editing in another session
 ;0=Ok  1=Quit
 ;
 I VRRS'>1 Q 0
 ;
 NEW CHK,I
 S CHK=0
 F I=1:1 Q:$G(^TMP("VEE","VRR",$J,I,"NAME"))']""  I I'=VRRS,$G(^("NAME"))=VRRPGM S CHK=1 D  Q
 . W $C(7),!!,"You are currently editing this program in another session."
 I CHK D PAUSE^%ZVEMKU(2) Q 1
 Q 0
 ;
ERROR ;Error trap
 KILL ^UTILITY($J) D ERRMSG^%ZVEMKU1("VRR"),PAUSE^%ZVEMKU(2)
 Q
 ;
TAG ;Option 'T' on menu bar. Select a line tag to move to.
 NEW FLAGQ,TAG
 S FLAGQ=0
 D ENDSCR^%ZVEMKT2
 D TAGLIST Q:FLAGQ
 D TAGASK Q:FLAGQ
 D REDRAW^%ZVEMRM
 Q
 ;
TAGLIST ;List line tags
 NEW CNT,I,TG,TMP
 S CNT=1
 F I=2:1 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,I)) Q:TMP']""  Q:TMP=" <> <> <>"  D  ;
 . Q:TMP'[$C(30)
 . D GETTAG^%ZVEMRM1
 . Q:TG']""
 . I CNT=1 W !,"Move to a line tag."
 . W !,"  " I $L(CNT)=1 W " "
 . W CNT,". ",TG
 . S TAG(CNT)=I
 . S CNT=CNT+1
 . I $Y>(VEE("IOSL")-4) D PAUSE^%ZVEMKU(2,"P") W @VEE("IOF")
 ;
 I CNT=1 D  Q
 . S FLAGQ=1
 . W !,"There are no line tags in this routine."
 . D PAUSE^%ZVEMKC(2)
 Q
 ;
TAGASK ;Select a tag
 W !
TAGASK1 W !,"Select NUMBER: "
 R TAG:100 S:'$T TAG="^" I "^"[TAG S FLAGQ=1 Q
 I '$D(TAG(TAG)) D  G TAGASK1
 . W "   Enter a number from the left hand column."
 ;
 ;Move to selected tag.
 ;Note: FLAGMENU=YND^VEET("TOP")^YCUR^XCUR
 S FLAGMENU=TAG(TAG)_"^"_TAG(TAG)_"^"_1
 Q
