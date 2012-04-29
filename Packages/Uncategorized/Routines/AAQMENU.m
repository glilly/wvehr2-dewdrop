AAQMENU ;FGO/JHS; Programmer Mode Menu ;03-06-98 [7/18/02 2:27pm]
 ;;1.2;AAQ LOCAL;;Mar 6, 1998;For Kernel V8.0 and Intersystems Cache
 ;;Logic and some code from AHJZSYS routines from 557/THM
 I '$D(DTIME) W !,"DTIME is not set.  Calling XUP to set up required variables.",!,"Press RETURN at the Select OPTION NAME: prompt.",!! D ^XUP W !
 I '$D(IOF) S IOP="HOME" D ^%ZIS K IOP S IOF=$S(IOST?1"C-".E:IOF,1:"!!")
 S SAVIOF=IOF,LFIOF=IOF,VAR="N",CJVAR="N"
ASKSLV S %=1 W !,"Do you want to Slave Print or Screen Capture",!,"using blank lines instead form feeds" D YN^DICN G:%=2 SETH I %=0 W !!,"If you answer NO, the menus will use normal form feeds." G ASKSLV
 G:%=-1 SETH
 W !!,"NOTE: Some options will not work properly using line feeds instead",!?6,"of form feeds.  The Editors and Read a Message will use the",!?6,"normal IOF value while in use and return to line feeds when done."
 R !!,"Press RETURN to Continue, '^' to Exit: ",X:DTIME G:X="^" EXIT
 S IOF="!!",LFIOF=IOF
SETH S AAQH=3 ;Sets HANG to 3.  Change to another value if you wish.
 S U="^" D UCI^%ZOSV S AAQUV=Y
 I DUZ(0)'="@" W !,"DUZ(0) will be changed for programmer access!" D Q^DI W "  DUZ(0) = ",DUZ(0)
MENU W @IOF,"Programmer Mode Menu for Package/Patch Installs:",!
 W !,"UCI is: ",AAQUV,"   ","DUZ is: ",DUZ,DUZ(0),"  U='^'"
 W !,"Today's $H, Date, and Time are: ",!
 W $H,"    " S X=$$NOW^XLFDT W $$FMTE^XLFDT(X),!
 W ! F I=1:1 S X=$T(OPT+I) Q:X["$END"  W ?($S(I<10:5,1:4)),I,".",?9,$P(X,";",3) W:X'["AAQ" ?45,"(",$P(X,";",2),")" W !
 S N=I-1,AAQMSG="Please enter a number between 1 and "_N_"   "
OPTION R !,?1,"Select Option Number: ",J:120 G:J[U!(J="") EXIT
 I J'?1.N!((J<1)!(J>N)) W !!,$C(7),AAQMSG H 1 G MENU
 S X=$T(OPT+J) W "   ",$P(X,";",3),!! D @$P(X,";",2)
 S:SAVIOF'=LFIOF IOF=LFIOF
 G MENU
 ;
OPT ;routine to execute;description
 ;AAQINH;Inhibit ALL Logins
 ;AAQENA;Enable Logins
 ;AAQCJINH;Inhibit Sending Critical Jobs Alerts
 ;AAQCJENA;Enable Sending Critical Jobs Alerts
 ;AAQGLK;Control Unsubscripted Global Kills
 ;^AAQMENUT;TaskMan Options
 ;AAQXM;Read a Message
 ;EN^AAQBAK;Make PackMan Backup Message
 ;^XPDKRN;KIDS Menu
 ;EN2^AAQBAK;KIDS - Backup a Transport Global
 ;^AAQMENUR;Routines Options
 ;Q^DI;FileMan Menu
 ;AAQSS;System Status
 ;AAQJOB;Examine Job                         (^JOBEXAM)
 ;^AAQKILLS;Kill a Process                      (^AAQKILLS)
 ;^XPDZPAT;Simple Patch Install
 ;$END
AAQINH S VAR="Y" W !,"This will prevent anyone from signing into the",!,"system, and from navigating through the menu tree.",!,"You can remain in Programmer Mode, while Inhibited.",!
 W !,"WARNING: If you enter a menu from programmer mode using XQ1,",!,?9,"you will be logged off the system.",!
 W !,"NOTE: The prompt 'Want KIDS to INHIBIT LOGONS during the install?'",!,"      should be answered with NO when you use this option.",!
 W !,"When INHIBIT LOGONS is answered with YES, Logons are enabled",!,"as soon as the KIDS portion of the install is finished."
 W !,"Using AAQMENU to Enable Logins will provide for more control",!,"as to when users should be able to sign on to the systems.",!
ASK S %=2 W !,"Are you sure you want to inhibit all Logins, including yourself " D YN^DICN Q:(%<0)!(%=2)
 I %=0 W !?7,"Answer YES if you are in Programmer Mode and want to inhibit logins." G ASK
 G LOGMSG
AAQENA S VAR="N"
LOGMSG W !,"INHIBIT LOGINS field in the VOLUME SET file will be set to ",VAR,"." H AAQH
 S DIC="^%ZIS(14.5,",DIC(0)="QEZ",X="ROU" D ^DIC S AAQ=$P(Y,U,1)
 S DR="1///^S X=VAR",DIE="^%ZIS(14.5,",DA=AAQ D ^DIE K DIC
 Q
AAQCJINH S CJVAR="Y" W !,"When installing a patch that requires stopping a Critical Job,",!,"the Critical Jobs Monitor should Inhibit the sending of alerts.",!
 W !,"Answer YES to INHIBIT CRITICAL JOBS MONITOR and stop sending alerts.",!
CJASK S %=2 W !,"Are you sure you want to Inhibit sending Critical Job alerts " D YN^DICN Q:(%<0)  I %=2 S CJVAR="N" Q
 I %=0 W !?5,"Answer YES to inhibit sending alerts.",!?5,"Answer NO to enable sending alerts." G CJASK
 G CJMSG
AAQCJENA S CJVAR="N"
CJMSG W !,"INHIBIT CRITICAL JOB MONITOR field in the VOLUME SET file will be set to ",CJVAR,"." H AAQH
 S DIC="^%ZIS(14.5,",DIC(0)="QEZ",X="ROU" D ^DIC S AAQ=$P(Y,U,1)
 S DR="618001///^S X=CJVAR",DIE="^%ZIS(14.5,",DA=AAQ D ^DIE K DIC
 Q
AAQGLK I ^%ZOSF("OS")'["OpenM-NT" W $C(7),!,"This option should be run only on Intersystems Cache systems!  Exiting.",! H 2 Q
 W !,"Protection for an Unsubscripted Global Node Kill"
ASKGLK R !,"(E)nable, (D)isable, or '^' to leave this option: ",AAQX:DTIME
 I AAQX?1L.E S AAQX=$$UP^XLFSTR(AAQX)
 I AAQX="E" W !,"Global Kills have been Enabled using S X=$ZU(68,28,0)" S X=$ZU(68,28,0) H AAQH Q
 I AAQX="D" W !,"Global Kills have been Disabled using S X=$ZU(68,28,1)" S X=$ZU(68,28,1) H AAQH Q
 I AAQX="^" Q
 W $C(7),!!,"You must answer with 'E', 'D', or '^'.",! G ASKGLK
AAQXM S IOF=SAVIOF,XMMENU(0)="XMUSER" D LOCK^XM,REC^XMA H AAQH
 D KILL^XM,UNLOCK^XM K XMMENU Q
AAQBK D CHECKIN^XM,PAKMAN^XMJMS,CHECKOUT^XM H AAQH Q
AAQJOB I ^%ZOSF("OS")'["OpenM-NT" W $C(7),!,"This option uses a Non-standard 'Z' command,",!,"which may only run on Intersystems Cache systems!  Exiting.",! H 2 Q
 D UCI^%ZOSV S AAQU=$P(Y,",",1)
 W !!,"JOBEXAM: Enter Process #, ? for System Status, or Press RETURN to skip."
 ZN "%SYS" D ^JOBEXAM ZN AAQU Q
AAQSS D:^%ZOSF("OS")["OpenM-NT" ^AAQSS Q:^%ZOSF("OS")["OpenM-NT"  W @IOF N DUZ,DT,DTIME X:$D(^%ZOSF("SS"))#2 ^("SS") D HOME^%ZIS Q
EXIT I (VAR="Y")!(CJVAR="Y") W $C(7),!!,"REMINDER: You have INHIBIT LOGINS or INHIBIT CRITICAL JOBS MONITOR",!?10,"set to YES.  You should Enable when finished."
 W ! K %,AAQ,AAQEA,AAQH,AAQMSG,AAQU,AAQUV,AAQX,CJVAR,DA,DIE,DR,I,J,LFIOF,N,SAVIOF,VAR,X,X1,Y D ^%ZISC Q
