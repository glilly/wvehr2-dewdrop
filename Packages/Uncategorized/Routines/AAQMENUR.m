AAQMENUR ;FGO/JHS; Programmer Mode Routine Menu ;03-06-98 [2/25/02 4:33am]
 ;;1.2;LOCAL;; For Kernel V8.0 and OpenM-NT
 ;;Logic and code from AHJZSYS routines from 557/THM
MENU I '$D(IOF) S IOP="HOME" D ^%ZIS K IOP
 W @IOF,"Programmer Mode Routine Menu:",!!
 S U="^" F I=1:1 S X=$T(OPT+I) Q:X["$END"  W ?($S(I<10:5,1:4)),I,".",?9,$P(X,";",3) W:X'["AAQ" ?45,"(",$P(X,";",2),")" W !
 S N=I-1,AAQMSG="Please enter a number between 1 and "_N_"   "
OPTION R !,?1,"Select Option Number: ",J:120 G:J[U!(J="") EXIT
 I J'?1.N!((J<1)!(J>N)) W !!,$C(7),AAQMSG H 1 G MENU
 S X=$T(OPT+J) W "   ",$P(X,";",3),!! D @$P(X,";",2)
 S:SAVIOF'=LFIOF IOF=LFIOF
 G MENU
 ;
OPT ;routine to execute;description
 ;AAQRD;Routine Directory                   (^%RD)
 ;^%ZTPP;List Routines
 ;AAQDEL;Delete Routines                     (^%ZTRDEL)
 ;^XINDEX;%Index of Routines
 ;AAQZTP1;First Line Print                    (^%ZTP1)
 ;^AAQJCASE;Routine Name Case Changer           (^AAQJCASE)
 ;AAQCHK;Checksums for Routines              (CHECK^XTSUMBLD)
 ;^XPDZCHK;Checksums/2nd Line List
 ;AAQVPE;VPE Routine Editor                  (X ^%ZVEMS("E"))
 ;AAQOPM;OpenM Routine Editor                (^%rde)
 ;$END
AAQRD D ^%RD R !!,"Press RETURN to Continue: ",X:DTIME Q
AAQDEL D ^%ZTRDEL R !!,"Press RETURN to Continue: ",X:DTIME Q
AAQZTP1 D ^%ZTP1 R !!,"Press RETURN to Continue: ",X:DTIME Q
AAQCHK D CHECK^XTSUMBLD R !!,"Press RETURN to Continue: ",X:DTIME Q
AAQBLD D BUILD^%ZTP1 R !!,"Press RETURN to Continue: ",X:DTIME Q
AAQVPE I '$D(^%ZVEMS) W !,"Sorry.  VPE Editor is not available." H AAQH Q
 W !,"Use <ESC> <ESC> for Quit/Save Options.",!
 R !!,"Press RETURN to Continue, '^' to Exit: ",X:15 G:X="^" EXIT
 S IOF=SAVIOF X ^%ZVEMS("E") S IOF=LFIOF Q
AAQOPM I ^%ZOSF("OS")'["OpenM-NT" W $C(7),!,"This editor is only available on Alpha Cache/OpenM-NT systems!  Exiting.",! H 2 Q
 W !,"...Calling %rde OpenM Full Screen Editor.",!
 W !,"Use PF3 (or F3) for Bottom Menu Options."
 W !,"Use PF4 (or F4) for Quit/Save Options."
 W !,"Select Cache Terminal or VT100, enter routine name,"
 W !,"or press Return at Load Routine to exit.",!
 R !!,"Press RETURN to Continue, '^' to Exit: ",X:15 G:X="^" EXIT
 S IOF=SAVIOF D ^%rde S IOF=LFIOF Q
EXIT W ! K AAQMSG,I,J,N,X Q
