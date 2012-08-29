%ZVEMR ;DJB,VRR**SCROLL VRoutine Reader ; 9/4/02 1:10pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;Entry Point
 I $G(DUZ)'>0 D ID^%ZVEMKU Q:$G(DUZ)=""
 NEW X S X="ERROR^%ZVEMRY",@($$TRAP^%ZVEMKU1) KILL X
START ;
 NEW CD,CDHLD,DX,DY,XCHAR,XCUR,YCUR,YND
 NEW FLAGGLB,FLAGMODE,FLAGQ,I,VEET,VRRFIND,VRRHIGH,VRRPGM
 I $G(VEELINE)="" NEW VEEIOST,VEELINE,VEELINE1,VEELINE2,VEESIZE,VEEX,VEEY
 ;
 ;FLAGVPE="VEDD^VGL^VRR^EDIT"
 I '$D(FLAGVPE) NEW FLAGVPE
 I $G(FLAGVPE)'["VRR" NEW VEES,VRRS
 I $G(FLAGVPE)'["EDIT",$D(VEE("OS"))#2=0 NEW VEE ;...Mumps system
 ;
 S FLAGQ=0
 D INIT^%ZVEMRY G:FLAGQ EX
 I $G(FLAGVPE)'["EDIT"!(VRRS>1) NEW FLAGSAVE
 X VEES("RM0")
 S $P(FLAGVPE,"^",3)="VRR" ;...Marks VRR as running
 S FLAGMODE="" ;...............BLOCK,WEB modes
 D EN^%ZVEMRS G:FLAGQ EX ;.....Get Program
 D LIBRARY^%ZVEMRLU(VRRPGM) ;..Is it signed out of Rtn Library?
 ;FLAGGLB: Used to select global from screen
TOP ;
 X VEES("RM0")
 D IMPORT
 D SCROLL^%ZVEMKT2(1)
 D LIST
 D ENDSCR^%ZVEMKT2
EX ;
 I $G(FLAGVPE)'["EDIT" D  Q
 . KILL ^TMP("VEE","VRR",$J,VRRS),^TMP("VEE","IR"_VRRS,$J)
 . S VRRS=VRRS-1 Q:VRRS>1
 . X $G(VEES("RM80"))
 . W @(VEES("WRAP"))
 ;Editing
 I VRRS>1 D  ;Unlock rtn if not a duplicate
 . NEW CHK,I,PGM
 . S PGM=$G(^TMP("VEE","VRR",$J,VRRS,"NAME"))
 . S CHK=0
 . F I=1:1 Q:'$D(^TMP("VEE","VRR",$J,I,"NAME"))  D  ;
 .. I I'=VRRS,^("NAME")=PGM S CHK=1
 . I 'CHK,PGM]"" L -VRRLOCK(PGM)
 . KILL ^TMP("VEE","VRR",$J,VRRS)
 . KILL ^TMP("VEE","IR"_VRRS,$J)
 S VRRS=VRRS-1
 Q:VRRS>0
 W @(VEES("WRAP"))
 X $G(VEES("RM80"))
 Q
 ;
GETVEET ;Set VEET=Display text
 I $D(^TMP("VEE","IR"_VRRS,$J,VEET("BOT"))) S VEET=^(VEET("BOT")) Q
 S (VEET,^TMP("VEE","IR"_VRRS,$J,VEET("BOT")))=" <> <> <>"
 Q
 ;
LIST ;Display text
 D GETVEET
 W !,$P(VEET,$C(30),1)
 W $P(VEET,$C(30),2,99)
 S VEET("BOT")=VEET("BOT")+1 ;Bottom line #
 S:VEET("GAP") VEET("GAP")=VEET("GAP")-1 ;Empty lines left on page
 I VEET=" <> <> <>"!'VEET("GAP") D READ^%ZVEMRE Q:FLAGQ
 G LIST
 ;
IMPORT ;Set up for scroller
 NEW LINE,MAR,NAME,SPACE,TMP
 S VRRHIGH=+$G(VRRHIGH)
 S MAR=$G(VEE("IOM")) S:MAR'>0 MAR=80
 S $P(LINE,"=",MAR)=""
 S SPACE="          "
 S NAME=$E($G(^TMP("VEE","VRR",$J,VRRS,"NAME")),1,8)
 S NAME=NAME_$E(SPACE,1,8-$L(NAME))
 S VEET("HD")=1
 S VEET("FT")=2
 S VEET("HD",1)="|=======|"_$E(LINE,1,11)_"[^"_NAME_"]======["_VRRS_" of 4]======[Lines: "_VRRHIGH_$E("    ",1,3-$L(VRRHIGH))_"]"_$E(LINE,1,MAR-65)_"|"
 S VEET("FT",1)="|=======|"_$E(LINE,1,MAR-11)_"|"
 S VEET("FT",2)="<>  <TAB>=MenuBar  <F3>=Block  <RET>=Insert  <ESC>K=Keybrd  <ESC><ESC>=Quit"
 S VEET("GET")=1
 D INIT^%ZVEMKT
 D INIT1^%ZVEMKT
 D INIT2^%ZVEMKT
 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,1))
 S XCUR=9,(YCUR,YND)=1
 I $G(%2)]"" D MOVETO
 ;--> Adj for $C(30)
 I TMP[$C(30) S XCUR=$F(TMP,$C(30))-2
 Q
 ;
MOVETO ;Adjust YND/YCUR to move to a passed in line tag.
 NEW CHK,CNT,LINE,NUM,TAG
 S (CHK,CNT,NUM)=0
 F  S CNT=$O(^TMP("VEE","IR"_VRRS,$J,CNT)) Q:'CNT!CHK  D  ;
 . S NUM=NUM+1
 . S LINE=^(CNT)
 . Q:(LINE'[$C(30))
 . S TAG=$P(LINE,$C(30),1)
 . Q:$E(TAG)?1N
 . S TAG=$P(TAG,"(",1)
 . ;Strip leading spaces
 . F  Q:$E(TAG)'=" "  S TAG=$E(TAG,2,$L(TAG))
 . ;Strip trailing spaces
 . F  Q:$E(TAG,$L(TAG))'=" "  S TAG=$E(TAG,1,$L(TAG)-1)
 . S:TAG=$G(%2) CHK=1
 I CHK S (VEET("BOT"),VEET("TOP"),YND)=NUM
 Q
 ;
PARAM(RTN,TAG) ;Parameter Passing....X=Routine Name
 S RTN=$G(RTN),TAG=$G(TAG)
 G:RTN="" EN
 S ^TMP("VEE",$J)=RTN_"^"_TAG
 I $G(DUZ)'>0 D ID^%ZVEMKU I $G(DUZ)="" KILL ^TMP("VEE",$J) Q
 ;
 NEW FLAGPRM,%1,%2
 S FLAGPRM=1
 S %1=$P(^TMP("VEE",$J),"^",1) ;Routine
 S %2=$P(^TMP("VEE",$J),"^",2) ;Tag
 KILL ^TMP("VEE",$J)
 G EN
