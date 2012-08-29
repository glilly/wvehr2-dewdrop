%ZVEMG ;DJB,VGL**VGlobal Lister ; 9/4/02 12:54pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;Entry point
 I $G(DUZ)'>0 D ID^%ZVEMKU Q:$G(DUZ)=""
 NEW X S X="ERROR^%ZVEMGY",@($$TRAP^%ZVEMKU1) KILL X
START ;
 NEW DX,DY,VEES,VEET ;IMPORT (For scrolling)
 NEW ZGL,CHK,CNTX,CNTY,CODE,COL,DATA,I,II,KEY,NEWSUB,NODE,FLAGSKIP,SKIPHLD,SUBCHK,SUBNAM,SUBNUM,TABHLD,TEMP,TEMP1,TOTAL,TOTAL1,VGLREV,Z1,Z2,ZDSUB,ZREF
 NEW GL,GLNAM,GLSUB,GLVAL,GLVAL1,GLX
 NEW ZDELIM,ZDELIM1,ZDELIM2
 NEW FLAGC,FLAGC1,FLAGE,FLAGOPEN,FLAGPAR,FLAGQ
 ;FLAGVPE="VEDD^VGL^VRR^EDIT"
 I '$D(FLAGVPE) NEW FLAGVPE
 I $G(FLAGVPE)'["VGL" NEW GLS
 I $G(VEEIOF)="" NEW VEEIOST,VEELINE,VEELINE1,VEELINE2,VEESIZE,VEEX,VEEY
 I $D(VEE("OS"))#2=0 NEW VEE
 S VGLREV=0 I $G(REVERSE)="YES" S VGLREV=1 KILL REVERSE
 ;
 S FLAGQ=0 D INIT^%ZVEMGY G:FLAGQ EX D IMPORT
 ;
 S $P(FLAGVPE,"^",2)="VGL" ;Marks that VGL is running.
TOP ;Start of Loop
 ;  VEET("STATUS")="START^FINISH^HEADING^SEARCH^PROT"
 ;  START marks if STARTSCR^%ZVEMKT2 has been called.
 ;  FINISH marks if FINISH^%ZVEMGI has been called.
 ;  HEADING controls whether heading is displayed
 ;  SEARCH marks if code search is currently active
 ;  PROT marks <PROT> error so "No data" is displayed.
 S VEET("STATUS")=$S($G(VEET("STATUS"))["HEADING":"^^HEADING",1:0)
 KILL ^TMP("VEE","IG"_GLS,$J),^TMP("VEE","VGL"_GLS,$J),^TMP("VEE",$J)
 S (CODE,FLAGC,FLAGC1,FLAGE,FLAGOPEN,FLAGQ)=0,ZREF=1
 D GETGL^%ZVEMG1 G:FLAGQ=1 EX G:FLAGQ=2 TOP
 I $G(VEESHL)="RUN" D  ;Cmnd Line History
 . S:$G(FLAGPAR)=1 ZGL=$E(ZGL,1,$L(ZGL)-1)
 . D CLHSET^%ZVEMSCL("VGL",ZGL)
 D ^%ZVEMGR,FINISH^%ZVEMGI
 G TOP
IMPORT ;Set up for scroller
 NEW LINE,MAR
 S MAR=$G(VEE("IOM")) S:'MAR MAR=80
 S $P(LINE,"=",MAR)=""
 S VEET("S2")=(VEE("IOSL")-3)
 S VEET("GET")="D SETARRAY^%ZVEMGI"
 S VEET("HD")=1,VEET("FT")=3
 S VEET("HD",1)=$E(LINE,1,(MAR-12)\2)_"[Session "_GLS_"]"_$E(LINE,1,(MAR-12)\2)
 S VEET("FT",1)=LINE
 S VEET("FT",2)="<>  'n'=Pieces  A=Alt  G=Goto  S'n'=Skip  C=CdSrch  ?=Help  M=More..."
 S VEET("FT",3)=" Select: "
 Q
EX ;
 KILL ^TMP("VEE","IG"_GLS,$J)
 KILL ^TMP("VEE","VGL"_GLS,$J)
 KILL ^TMP("VEE",$J)
 S GLS=GLS-1 ;Make sure this line FOLLOWS previous line
 S ^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"GLS")=GLS
 I GLS=0 KILL ^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"GLS")
 Q
 ;====================================================================
R ;Reverse video
 I '$D(^DD)!('$D(^DIC)) D  Q  ;Needs Fileman
 . W $C(7),!?1,"Fileman must be present to use this calling point.",!
 I $G(DUZ)'>0 D ID^%ZVEMKU I $G(DUZ)="" KILL ^TMP("VEE",$J) Q
 NEW REVERSE S REVERSE="YES"
 G EN
PARAM(X) ;Parameter Passing....X=^Global -or- X=File Name
 S ^TMP("VEE",$J)=$G(X)
 I $G(DUZ)'>0 D ID^%ZVEMKU I $G(DUZ)="" KILL ^TMP("VEE",$J) Q
 I ^TMP("VEE",$J)]"" NEW FLAGPRM,%1 S FLAGPRM=1,%1=^($J)
 KILL ^TMP("VEE",$J)
 G EN
