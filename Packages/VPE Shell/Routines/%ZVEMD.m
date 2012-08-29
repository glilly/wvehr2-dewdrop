%ZVEMD ;DJB,VEDD**Electronic Data Dictionary ; 9/23/02 1:31pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;Entry point
 I '$D(^DD(0)) D  Q
 . W $C(7),!!?2,"You don't have Filemanager in this UCI.",!
 . D:$G(FLAGVPE)["VGL"!($G(FLAGVPE)["VRR") PAUSE^%ZVEMKC(2)
 I $G(DUZ)'>0 D ID^%ZVEMKU Q:$G(DUZ)=""
 NEW X S X="ERROR^%ZVEMDY",@($$TRAP^%ZVEMKU1) KILL X
START ;
 NEW FLAGE,FLAGG,FLAGGL,FLAGGL1,FLAGH,FLAGM,FLAGP,FLAGP1,FLAGQ
 NEW DIC,VEDDATE,I,PRINTING,X,Y,Z1,ZGL,ZNAM,ZNUM,ZZGL
 I $G(VEEX)]"" D  KILL VEEX
 . S:VEEX="TAG-DIR"!(VEEX="TAG-PARAM") FLAGH=1 Q
 I $D(VEE("OS"))#2=0 NEW VEE
 I $G(VEELINE)']"" NEW VEEIOST,VEELINE,VEELINE1,VEELINE2,VEESIZE,VEEX,VEEY
 ;FLAGVPE="VEDD^VGL^VRR^EDIT"
 I '$D(FLAGVPE) NEW FLAGVPE
 S $P(FLAGVPE,"^",1)="VEDD" ;Marks that VEDD is running
 ;
 S FLAGQ=0 D INIT^%ZVEMDY G:FLAGQ EX
 ;
TOP ;
 S (FLAGP,FLAGQ)=0 KILL ^TMP("VEE","VEDD",$J)
 D:'FLAGH HD^%ZVEMD1 D GETFILE G:FLAGQ EX
 I $G(VEESHL)="RUN" D CLHSET^%ZVEMSCL("VEDD",ZNAM) ;Cmnd Line History
 D MULT^%ZVEMDPR,MENU^%ZVEMD1 G:FLAGE EX
 S FLAGH=1 G TOP ;Set FLAGH to bypass opening screen
EX ;Exit
 KILL ^TMP("VEE","VEDD",$J)
 Q
 ;==================================================================
GETFILE ;File lookup
 NEW DIC
 I $G(FLAGPRM)="VEDD" S FLAGQ=1 Q  ;Onetime pass when parameter passing.
 I $G(FLAGPRM)=1 S FLAGPRM="VEDD",X=%1 G GETFILE1
 I $G(VEESHL)="RUN" D  G:X?1"<".E1">" GETFILE G GETFILE1
 . S X=$$CLHEDIT^%ZVEMSCL("VEDD"," Select FILE: ")
 W !?2,"Select FILE: "
 R X:VEE("TIME") S:'$T X="^"
GETFILE1 ;Parameter passing
 I "^"[X S FLAGQ=1 Q
 S DIC="^DIC(",DIC(0)="QEM" D ^DIC I Y<0 D  Q:FLAGQ  G GETFILE
 . Q:$G(FLAGPRM)'="VEDD"  S FLAGQ=1
 . W !!?2,"First parameter is not a valid file name/number.",!
 S ZNUM=+Y,ZNAM=$P(Y,U,2)
 I '$D(^DIC(ZNUM,0,"GL")) D  S FLAGQ=1 Q
 . W $C(7),!!?2,"WARNING...This file is missing node ^DIC(",ZNUM,",0,""GL"")",!
 I ^DIC(ZNUM,0,"GL")']"" D  S FLAGQ=1 Q
 . W $C(7),!!?2,"WARNING...Node ^DIC(",ZNUM,",0,""GL"") is null.",!
 S VEEX=^DIC(ZNUM,0,"GL")_"0)" I '$D(@VEEX) D  S FLAGQ=1 Q
 . W $C(7),!!?2,"WARNING...This file is missing its data global - ",^DIC(ZNUM,0,"GL"),!
 I '$D(^DD(ZNUM,0)) D  S FLAGQ=1 Q
 . W $C(7),!!?2,"WARNING...This file is missing the zero node of the data dictionary.",!?12,"--> ^DD(",ZNUM,",0)",!
 S ZGL=^DIC(ZNUM,0,"GL")
 Q
DIR ;Supress heading
 I $G(DUZ)'>0 D ID^%ZVEMKU I $G(DUZ)="" Q
 S VEEX="TAG-DIR" G EN
PARAM(X,Y,Z) ;Parameter Passing
 ;   X = ^Global -or- File name
 ;   Y = EDD Main Menu option
 ;   Z = Fields
 S ^TMP("VEE",$J)=$G(X)_"]]"_$G(Y)_"]]"_$G(Z)
 I $G(DUZ)'>0 D ID^%ZVEMKU I $G(DUZ)="" KILL ^TMP("VEE",$J) Q
 I $P(^TMP("VEE",$J),"]]",1)]"" S X=^($J) NEW FLAGPRM,%1,%2,%3 S FLAGPRM=1 D
 . S %1=$P(X,"]]",1),%2=$P(X,"]]",2),%3=$P(X,"]]",3)
 . I %2]"" D CHECK^%ZVEMDM I %2']"" S FLAGPRM="QUIT"
 KILL X,^TMP("VEE",$J) S VEEX="TAG-PARAM"
 I $G(FLAGPRM)="QUIT" KILL VEEX Q
 G EN
