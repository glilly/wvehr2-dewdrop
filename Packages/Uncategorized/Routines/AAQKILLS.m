AAQKILLS ;FGO/JHS;Kill Job/Task Routine ; 11/13/97 [12/8/00 12:35pm]
 ;;1.1;AAQ LOCAL;;Nov 3, 1997;For Kernel V8.0 and Cache/OpenM-NT
 I ^%ZOSF("OS")'["OpenM-NT" W $C(7),!,"This routine should be run only on Alpha OpenM-NT systems!  Exiting.",! H 1 Q
 I '$D(DTIME) W !,"DTIME is not set.  Calling XUP to set up required variables.",!,"Press RETURN at the Select OPTION NAME: prompt.",!! D ^XUP
 W !!,"Kill a Printer Job/Task or Interactive User Job",!!,"Do you want help" S %=2 D YN^DICN G:%Y="^" EXIT D:%=1 HELP
 S AAQXQ="^XUTL(""XQ""," S AAQQT=$C(34),AAQCM=$C(44) ;34=Quotes, 44=Comma
ASKPRT S %=2 W !!,"Do you want to kill a Printer Job" D YN^DICN S AAQPRT=% I %=0 W !!,"Answer 'Y' to kill a Printer Job/Task.",!,"Answer 'N' to kill an interactive User Job.",! G ASKPRT
 G:%Y="^" EXIT I AAQPRT=1 G PRTJOB
 W !!,"FIND USER: Helps to identify the Job, Device, and Menu Path.",!,"Press RETURN if you don't want to view this information.",!
 ; Find a User; code from XUS9
FU S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Select USER to Find: " D ^DIC S DA=+Y G:Y'>0 JOBEX S XUSER=$P(Y,"^",2)
 W !!,"User: ",XUSER,$S($D(^XUSEC(0,"CUR",DA))=10:" is found on;",1:" isn't currently on the system") G:DA'>0 JOBEX
 F XU5=0:0 S XU5=$O(^XUSEC(0,"CUR",DA,XU5)) Q:XU5'>0  D DISPU
 W !,"Done finding." G JOBEX
DISPU S XU3=$S($D(^XUSEC(0,XU5,0)):^(0),1:"")
 S XUCI=$P(XU3,"^",8),XUVOL=$P(XU3,"^",5),Y=XU5,XUJOB=$P(XU3,"^",3),XU6=XUJOB D DD^%DT S XUDT=Y
 I XUJOB>127 S X1=16,X=XUJOB D CNV^XTBASE S XU6=XUJOB_" ("_Y_")"
 W !,"Job: ",XU6," on ",XUCI,",",XUVOL,$S($P(XU3,"^",10)]"":":"_$P(XU3,"^",10),1:"")," from ",XUDT
 W !,"Device: ",$P(XU3,"^",2) W:$P(XU3,"^",9)]"" "  (",$P(XU3,"^",9),")"
 W !?3,"Menu path:"
 I $D(^XUTL("XQ",XUJOB,"T")) F I=1:1:^XUTL("XQ",XUJOB,"T") Q:'$D(^XUTL("XQ",XUJOB,I))  S Y=^(I) W !,?I*3+2,$P(Y,"^",3)
 W !
 Q
JOBEX W !!,"JOBEXAM: Examine a Job to check if it is still active."
 W !,"TTYFREE: Free up a terminal which remains busy without an active process."
ASKEXAM S %=2 W !!,"Do you want to use JOBEXAM and/or TTYFREEE" D YN^DICN S AAQEXAM=% I %=0 W !!,"Answer 'Y' to Examine a Job and/or Release a Terminal",!,"Answer 'N' to continue with killing a job." G ASKEXAM
 G:%Y="^" EXIT I AAQEXAM=2 G RESJOB
ASKJT R !,"Run (J)OBEXAM or (T)TYFREE?: J// ",AAQJT:60 G:AAQJT="^" EXIT W:$E(AAQJT,1)="J" "OBEXAM" W:$E(AAQJT,1)="T" "TYFREE"
 I (AAQJT="")!(AAQJT="J") S AAQJT="J" G CKXQ
 I $E(AAQJT,1)'="J",$E(AAQJT,1)'="T" W !!,"Enter the letter J or T, `^' to quit." G ASKJT
 I $E(AAQJT,1)="T" G ASKTTY
CKXQ D UCI^%ZOSV S AAQUCI=$P(Y,",",1)
 W !!,"You should try viewing the User Stack in ^XUTL first."
 W !,"It might provide the information you want and will not result"
 W !,"in a hung job like the Intersystems JOBEXAM will do at times."
 R !!,"Enter the Job/Process #, or Press RETURN to skip: ",AAQJ:60
 G:AAQJ="^" EXIT G:AAQJ="" ASKJOBX
 I ^%ZOSF("OS")["OpenM-NT" S AAQJI=$V(-1,AAQJ),AAQROU=$P($G(AAQJI),U,6)
 I '$D(^XUTL("XQ",AAQJ)) W !,"Job #"_AAQJ_" not found in ^XUTL User Stacks." G ASKXQX
 W ! S (AAQII,AAQIISV)="" F II=0:1 S AAQII=$O(^XUTL("XQ",AAQJ,AAQII)) Q:(AAQII="")!(AAQII'?.N)  S Y=^(AAQII),AAQIISV=AAQII
 I AAQII'="" W !,"  Last Menu Option Accessed = ",$P(Y,U,2),"   ",$P(Y,U,3)
 I AAQROU'="" W !,"Last Routine To Be Accessed = ",AAQROU
 S AAQSO=$P($G(^XUTL("XQ",AAQJ,0)),"^",1) I AAQSO="" S AAQSO="Unknown" G GETDUZ
 S AAQSO=$$FMTE^XLFDT(AAQSO,1)
GETDUZ S AAQDUZ=$G(^XUTL("XQ",AAQJ,"DUZ")) I (AAQDUZ="")!(AAQDUZ=0) S AAQDUZ="UNKNOWN" G WJOB
 S AAQDUZ=$P(^VA(200,AAQDUZ,0),"^",1)
WJOB W !,"Job has ",AAQDUZ," as User with sign-on time ",AAQSO
ASKXQX S %=2 W !!,"Do you want to view another Job in the User Stack" D YN^DICN S AAQXQX=% I %=0 W !!,"Answer 'Y' to run User Stack option again",!,"Answer 'N' to continue with JOBEXAM option." G ASKXQX
 G:%Y="^" EXIT I AAQXQX=1 G CKXQ
ASKJOBX S %=2 W !!,"Do you still want to use JOBEXAM" D YN^DICN S AAQJOBX=% I %=0 W !!,"Answer 'Y' to use the option 'Examine a Job'",!,"Answer 'N' to continue with option 'TTYFREE'." G ASKJOBX
 G:%Y="^" EXIT I AAQJOBX=2 G ASKTTY
 W !!,"JOBEXAM: Enter Process #, ? for System Status, or Press RETURN to skip."
 ZN "%SYS" D OLD^JOBEXAM ZN AAQUCI
ASKTTY S %=2 W !!,"Do you want to check TTYFREE for the Terminal or PID" D YN^DICN S AAQTTY=% I %=0 W !!,"Answer 'Y' to run TTYFREE.",!,"Answer 'N' to continue with killing a job." G ASKTTY
 G:%Y="^" EXIT I AAQTTY=2 G RESJOB
TTY D UCI^%ZOSV S AAQUCI=$P(Y,",",1)
 W !!,"TTYFREE: Enter device name to free up terminal if process failed to quit,",!,?9,"? for List of Terminals and PIDs, or Press RETURN to skip.",!!
 ZN "%SYS" D ^TTYFREE ZN AAQUCI
ASKTTYX S %=2 W !!,"Do you want to run TTYFREE again" D YN^DICN S AAQTTYX=% I %=0 W !!,"Answer 'Y' to run the option again",!,"Answer 'N' to continue with option to KILL JOB." G ASKTTYX
 G:%Y="^" EXIT I AAQTTYX=1 G TTY
RESJOB W !!,"KILL JOB:" D ^ZZRESJOB
 W !,"RELEASE USER: Clear the record of a sign-on session for a user.",!,?14,"Enter USER Name or Press RETURN to finish this option.",!
 W !,"NOTE: When the user has several sign-on records, this release function",!?6,"may not be able to properly identify what to release.  In this",!?6,"situation, use 'Release user' under the User Management Menu.",!
 S AAQCNT=0,XU5=0,RELQ=0
 I '$D(XUSER)  S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Select USER to Release: " D ^DIC S DA=+Y G:Y'>0 EXIT S XUSER=$P(Y,"^",2)
 W !,"User: ",XUSER,$S($D(^XUSEC(0,"CUR",DA))=10:" is found on:",1:" isn't currently on the system")
 F XU5=0:0 S XU5=$O(^XUSEC(0,"CUR",DA,XU5)) Q:(XU5'>0)!(RELQ=1)  G:DA'>0 EXIT D FINDSO
 G EXIT
FINDSO S XU3=$S($D(^XUSEC(0,XU5,0)):^(0),1:"") G REMOVE:XU3']"",REMOVE:$P($G(XU3),"^",4)
 S Y=XU5,XUJOB=$P(XU3,"^",3),XU6=XUJOB D DD^%DT S XUDT=Y
 W !!,"Job: ",XU6,$S($P(XU3,"^",10)]"":":"_$P(XU3,"^",10),1:"")," on Device: ",$P(XU3,"^",2)," from ",XUDT S AAQCNT=AAQCNT+1
REMOVE S %=2 W !,"Do you want Release the User from this sign-on" D YN^DICN S AAQREM=% I %=0 W !!,"Answer 'Y' to Release the User from this sign-on",!,"Answer 'N' to continue viewing other sign-ons." G REMOVE
 G:%Y="^" EXIT I AAQREM=1 G RELU
 Q
RELU K ^XUSEC(0,"CUR",DA,XU5) W !,"User is RELEASED!!",! S RELQ=1
 I AAQCNT=1 S $P(^VA(200,+Y,1.1),"^",3)=0
 Q
PRTJOB D ^AAQPRKIL
EXIT K %,%H,%Y,AAQCM,AAQCNT,AAQDUZ,AAQEXAM,AAQII,AAQJ,AAQJOBX,AAQJT,AAQPRT,AAQQT,AAQREM,AAQSO,AAQTTY,AAQTTYX,AAQUCI,AAQXQ,AAQXQX,ANS,DA,DIC,I,II,RELQ,X,X1,XU3,XU5,XU6,XUCI,XUDT,XUJOB,XUSER,XUVOL,Y
 Q
HELP W !!
 W "This will allow you to kill a job by automatically taking you",!
 W "through most of the necessary steps.  When a process fails to",!
 W "quit, it may be still tied to a device which isn't free (XOFF).",!
 W "You may have to LOGOUT a port or use TTYFREE.  You can access",!
 W "TTYFREE when killing an Interactive User job if you answer 'Y'",!
 W "to the JOBEXAM/TTYFREE prompt.  If TTYFREE is needed to kill a",!
 W "Printer job, reply 'N' to Printer Job and press Return at USER.",!
 W "When killing a Printer job, the related Task will be deleted",!
 W "automatically.  If you kill a queued job running without a",!
 W "device, you should use the Taskman option Cleanup Task List.",!
 W "If you want to kill a Printer Job while it's actively printing,",!
 W "answer the LOGOUT prompt with 'Y' to ignore the warning.",!
 W "For most prompts, '^' can be used to exit this option.",!
 W "Accepting the defaults and pressing the Return or Enter key",!
 W "at each prompt is the other way to exit the option.",!
 W !,"Press RETURN to continue: " R ANS:60
 Q
