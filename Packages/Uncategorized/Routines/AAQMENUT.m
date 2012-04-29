AAQMENUT ;FGO/JHS; Programmer Mode TaskMan Menu ;03-06-98 [2/25/02 4:34am]
 ;;1.2;AAQ LOCAL;;Mar 6, 1998;For Kernel V8.0 and Cache/OpenM-NT
 ;;Logic and code from AHJZSYS routines from 557/THM
MENU I '$D(IOF) S IOP="HOME" D ^%ZIS K IOP
 W @IOF,"Programmer Mode TaskMan Menu:",!!
 S U="^" F I=1:1 S X=$T(OPT+I) Q:X["$END"  W ?($S(I<10:5,1:4)),I,".",?9,$P(X,";",3) W:X'["AAQ" ?45,"(",$P(X,";",2),")" W !
 S N=I-1,AAQMSG="Please enter a number between 1 and "_N_"   "
OPTION R !,?1,"Select Option Number: ",J:120 G:J[U!(J="") EXIT
 I J'?1.N!((J<1)!(J>N)) W !!,$C(7),AAQMSG H 1 G MENU
 S X=$T(OPT+J) W "   ",$P(X,";",3),!! W ! D @$P(X,";",2) H AAQH
 S:SAVIOF'=LFIOF IOF=LFIOF
 G MENU
 ;
OPT ;routine to execute;description
 ;^ZTMON;Monitor TaskMan
 ;DEV^AAQXUTMQ;List Tasks Waiting on Devices       (DEV^AAQXUTMQ)
 ;WAIT^ZTMKU;Place TaskMan in a WAIT state
 ;RUN^ZTMKU;Remove TaskMan from WAIT state
 ;STOP^ZTMKU;Stop Task Manager
 ;RESTART^ZTMB;Restart Task Manager
 ;$END
EXIT W ! K AAQMSG,I,J,N,X,ZTT Q
