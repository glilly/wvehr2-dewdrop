%ZVEMRID ;DJB,VRR**INSERT - Programmer Call ; 9/6/02 8:15am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;Insert programmer call into current program
 S ^TMP("VPE",$J)=$P(FLAGMENU,"^",1) ;...YND
 D SYMTAB^%ZVEMKST("C","VRR",VRRS) ;...Save/Clear symbol table
 D ENDSCR^%ZVEMKT2
 I '$D(^VEE(19200.113)) D  G EX ;...Quit if FM isn't in this UCI
 . W !,"I can't find the VPE files that support CALL..."
 . D PAUSE^%ZVEMKU(2,"P")
 I $G(^TMP("VEE","IR"_VRRS,$J,^TMP("VPE",$J)))=" <> <> <>" D  G EX
 . W !,"You may not insert a CALL while you are on the ' <> <> <>' line."
 . W !,"Move up one line."
 . D PAUSE^%ZVEMKU(2,"P")
 ;
 NEW %,CALL,CD
 S X="ERROR^%ZVEMRID",@($$TRAP^%ZVEMKU1) KILL X
 W !,"***INSERT PROGRAMMER CALL***"
 S FLAGQ=0
 D GETCALL G:FLAGQ EX
 D DELETE^%ZVEMRIE G:FLAGQ EX
 D DDS G:FLAGQ EX
 D CODE^%ZVEMRIE G:FLAGQ EX
 W @VEE("IOF")
 G:$$ASK^%ZVEMKU(" Insert this Call into your routine",1)'="Y" EX
 D INSERT
EX ;
 KILL ^TMP("VPE",$J)
 D SYMTAB^%ZVEMKST("R","VRR",VRRS) ;Restore symbol table
 X VEES("RM0")
 Q
 ;====================================================================
GETCALL ;Get programmer call
 NEW DA,DIC,X,Y
 S DIC="^VEE(19200.113,",DIC(0)="QEAM",DIC("A")="Select CALL: "
 S DIC("S")="I $P($G(^(0)),U,2)'=""n"""
 W ! D ^DIC I Y<0 S FLAGQ=1 Q
 S CALL=+Y
 Q
DDS ;Call ScreenMan
 NEW DA,DDSFILE,DDSPARM,DR,I
 S DDSFILE=19200.113,DR="[VEEM PGM CALL]",DA=CALL
 S DDSPARM="E" D ^DDS Q:'$G(DIERR)  S FLAGQ=1
 W !!,"Screenman couldn't load this form."
 S I=0
 F  S I=$O(^TMP("DIERR",$J,1,"TEXT",I)) Q:I'>0  W !,^(I)
 KILL ^TMP("DIERR",$J) D PAUSE^%ZVEMKU(2,"P")
 Q
INSERT ;Insert Call code into rtn
 NEW CNT,I,NUM,SUB,YND
 S YND=$G(^TMP("VPE",$J)) Q:YND'>0
 ;--> Get line number
 S NUM=$$LINENUM^%ZVEMRU(YND)+1
 ;--> Set YND to line number after wrapped lines
 F I=YND+1:1 Q:^TMP("VEE","IR"_VRRS,$J,I)[$C(30)  Q:^(I)=" <> <> <>"  S YND=YND+1
 S SUB=1 F CNT=1:1 Q:'$D(CD(CNT))  S CD=CD(CNT) D INSERT1 S NUM=NUM+1
 S ^%ZVEMS("E","SAVEVRR",$J,SUB)="" ;Mark clipboard ending point
 D PASTE^%ZVEMRP1
 Q
INSERT1 ;Build array of code to be inserted
 S ^%ZVEMS("E","SAVEVRR",$J,SUB)=NUM_$J("",9-$L(NUM))_$C(30)_$E(CD,1,VEE("IOM")-11)
 S SUB=SUB+1
 S CD=$E(CD,VEE("IOM")-10,9999)
 F  Q:CD']""  D  ;
 . S ^%ZVEMS("E","SAVEVRR",$J,SUB)=$J("",9)_$E(CD,1,VEE("IOM")-11)
 . S SUB=SUB+1
 . S CD=$E(CD,VEE("IOM")-10,9999)
 Q
 ;====================================================================
ERROR ;Error trap
 NEW ZE
 S @("ZE="_VEE("$ZE"))
 I ZE["<INRPT>" W !!?1,"....Interrupted.",!!
 E  D ERRMSG^%ZVEMKU1("VRR")
 D PAUSE^%ZVEMKU(2)
 G EX
 ;====================================================================
HELP(PC) ;Print param/variable help text in ScreenMan.
 ;PC=Global "Piece" where Parameter is located
 NEW I,PARAM,STRING
 Q:'$G(DDS)  Q:'$G(DA)  Q:'$G(PC)
 S PARAM=$P($G(^VEE(19200.113,DA,"P")),U,PC) Q:'PARAM
 F I=1:1 Q:'$D(^VEE(19200.114,PARAM,"WP",I,0))  S STRING(I)=^(0)
 Q:($D(STRING)<10)  D HLP^DDSUTL(.STRING)
 Q
DEFAULT(PC) ;Default value in ScreenMan. Set variable Y.
 ;PC=Global "Piece" where Parameter is located
 NEW DEFAULT,PARAM
 S Y=""
 Q:'$G(DDS)  Q:'$G(DA)  Q:'$G(PC)
 S PARAM=$P($G(^VEE(19200.113,DA,"P")),U,PC) Q:'PARAM
 S DEFAULT=$G(^VEE(19200.114,PARAM,"D")) Q:DEFAULT']""
 S Y=DEFAULT
 Q
 ;====================================================================
EDIT ;Add/Edit a Call. External calling point to build database.
 Q:'$D(^DD)!('$D(^DIC))  Q:'$D(^VEE(19200.113))
 NEW DA,DDSFILE,DDSPARM,DIC,DR,FLAGQ,I,X,Y
EDIT1 S FLAGQ=0 F  D  Q:FLAGQ
 . W @VEE("IOF"),!,"***ADD/EDIT A VPE PROGRAMMER CALL***"
 . S DIC="^VEE(19200.113,",DIC(0)="QEAML",DIC("A")="Select CALL: "
 . W ! D ^DIC I Y<0 S FLAGQ=1 Q
 . S DDSFILE=19200.113,DR="[VEEM PGM EDIT]",DA=+Y
 . S DDSPARM="E" D ^DDS Q:'$G(DIERR)
 . S FLAGQ=1
 . W !!?1,"Screenman couldn't load this form."
 . S I=0 F  S I=$O(^TMP("DIERR",$J,1,"TEXT",I)) Q:I'>0  W !?1,^(I)
 . KILL ^TMP("DIERR",$J)
 . D PAUSE^%ZVEMKU(2,"P")
 Q
