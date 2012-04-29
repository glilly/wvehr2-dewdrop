ZZRESJOB  ;(KSO,PK) Kill a job by VMS PID ; DKA187 08/30/93  ; Compiled 04/22/97 06:19PM for M/WNT
 ; +--------------------------------------------------------+
 ; | Copyright 1986-1997 by InterSystems Corporation,       |
 ; | Cambridge, Massachusetts, U.S.A.                       |
 ; | All rights reserved.                                   |
 ; |                                                        |
 ; | Confidential, unpublished property of InterSystems.    |
 ; |                                                        |
 ; | This media contains an authorized copy or copies       |
 ; | of material copyrighted by InterSystems and is the     |
 ; | confidential, unpublished property of InterSystems.    |
 ; | This copyright notice and any other copyright notices  |
 ; | included in machine readable copies must be reproduced |
 ; | on all authorized copies.                              |
 ; +--------------------------------------------------------+
BEGIN ;
 N %D,%X,JOB,KJ,PROC
 W !,"Force a process to quit Open M"
ASK R !!,"Process ID (? for status report): ",JOB:DTIME I JOB="" W ! Q
 ; **MODIFICATION:  ^%SS replaced with ^AAQSS...
 I JOB="?" W ! D ^AAQSS G ASK
 ; **************
 S:0 JOB=JOB
 D FIND
 I 'KJ W $C(7)," [no such Open M process]" G ASK
 I JOB=$J W $C(7),!,"This is your current process, not proceeding with kill." G ASK
 S PROC="",$ZT="ASK1",PROC=$P($V(-1,JOB),"^",10)
ASK1 S $ZT=""
 I PROC?2U1N S PROC="" ;network daemons can be killed
 I PROC]"",PROC'="JOBSRV" D  G ASK
 .  W $C(7),!,"Can NOT kill the "_PROC_" process. "
 S ZZ=$ZU(4,KJ)
 I ZZ=-1 W !,"Process not responding" G ASK
 I ZZ=-2 W !,"Process died, not responding" G ASK
 I ZZ=-3 W !,"Process already died" G ASK
 I PROC="JOBSRV" G ASK
 F I=1:1:5 H 1 D FIND G ASK:'KJ
 W !,"Process failed to quit" G ASK
FIND S %D=JOB F KJ=0:0 S KJ=+$ZJ(KJ) Q:'KJ!(KJ=%D)
 Q
INT(JOB) ;EXTRINSIC FUNCTION. GIVEN JOB=PROCESS ID#. QUITS 1 IF TERMINATES, ELSE QUITS 0. (LIBERMAN) APR87
 S:0 JOB=JOB
 N %D,%X,I,KJ D FIND I 'KJ Q 0 ;QUIT 0 IF CANNOT FIND THAT PROCESS
 I $ZU(4,KJ)=1 F I=1:1:5 H 1 D FIND G Q1:'KJ
 Q 0 ;PROCESS DEAD OR NOT RESPONDING
Q1 Q 1
