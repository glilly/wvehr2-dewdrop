HLOPROC1        ;ALB/CJM/OAK/PIJ- Process Manager - 10/4/94 1pm ;11/06/2008
        ;;1.6;HEALTH LEVEL SEVEN;**126,138,139**;Oct 13, 1995;Build 11
        ;
        ;
GETWORK(PROCESS)        ;
        ;finds a process that needs to be started
        ;
        N NAME,IEN,GOTWORK
        ;this is how  HL7 can be stopped via Taskman
        I $$S^%ZTLOAD D STOPHL7 Q 0
        S GOTWORK=0
        S IEN=+$G(PROCESS("IEN"))
        F  S IEN=$O(^HLD(779.3,"C",1,IEN)) Q:IEN=$G(PROCESS("IEN"))  I IEN D  Q:GOTWORK
        .N PROC,COUNT,QUEUED,RUNNING
        .Q:'$$GETPROC(IEN,.PROC)
        .Q:PROC("VMS SERVICE")
        .Q:PROC("NAME")="PROCESS MANAGER"
        .Q:'PROC("ACTIVE")
        .S PROCESS("COUNT")=1
        .S QUEUED=+$G(^HLC("HL7 PROCESS COUNTS","QUEUED",PROC("NAME")))
        .S:QUEUED<0 QUEUED=0
        .S RUNNING=+$G(^HLC("HL7 PROCESS COUNTS","RUNNING",PROC("NAME")))
        .S:RUNNING<0 RUNNING=0
        .S COUNT=QUEUED+RUNNING
        .I COUNT<PROC("MINIMUM") S GOTWORK=1,PROCESS("IEN")=IEN,PROCESS("NAME")=PROC("NAME"),PROCESS("COUNT")=(PROC("MINIMUM")-COUNT) Q
        .I COUNT<PROC("MAXIMUM"),$$FMDIFF^XLFDT($$NOW^XLFDT,PROC("LAST DT/TM"),2)>PROC("WAIT SECONDS"),'QUEUED S GOTWORK=1,PROCESS("IEN")=IEN,PROCESS("NAME")=PROC("NAME"),PROCESS("COUNT")=1 Q
        I 'GOTWORK K PROCESS
        Q GOTWORK
        ;
DOWORK(PROCESS) ;
        ;starts a process
        ;
        ;don't start a new task if stopped
        Q:$$CHKSTOP^HLOPROC
        ;
        N ZTRTN,ZTDESC,ZTSAVE,ZTIO,ZTSK,I,ZTDTH
        S:'$G(PROCESS("COUNT")) PROCESS("COUNT")=1
        F I=1:1:PROCESS("COUNT") D
        .S ZTRTN="PROCESS^HLOPROC"
        .S ZTDESC="HL7 - "_PROCESS("NAME")
        .S ZTIO=""
        .S ZTSAVE("PROCNAME")=PROCESS("NAME")
        .S ZTDTH=$H
        .D ^%ZTLOAD
        .I $D(ZTSK) D
        ..;lock before changing counts
        ..L +HL7("COUNTING PROCESSES"):20
        ..I $$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","QUEUED",PROCESS("NAME"))))
        ..S $P(^HLD(779.3,PROCESS("IEN"),0),"^",6)=$$NOW^XLFDT,^HLTMP("HL7 QUEUED PROCESSES",ZTSK)=$H_"^"_PROCESS("NAME")
        ..L -HL7("COUNTING PROCESSES")
        Q
        ;
GETPROC(IEN,PROCESS)    ;
        ;given the ien of the HL7 Process Registry entry, returns the entry as a subscripted array in .PROCESS
        ;
        ;Output: Function returns 0 on failure, 1 on success
        ;
        N NODE
        S NODE=$G(^HLD(779.3,IEN,0))
        Q:NODE="" 0
        S PROCESS("NAME")=$P(NODE,"^")
        S PROCESS("IEN")=IEN
        S PROCESS("ACTIVE")=$P(NODE,"^",2)
        S PROCESS("MINIMUM")=+$P(NODE,"^",3)
        S PROCESS("MAXIMUM")=+$P(NODE,"^",4)
        S PROCESS("WAIT SECONDS")=+($P(NODE,"^",5))*60
        I 'PROCESS("WAIT SECONDS") S PROCESS("WAIT SECONDS")=1000
        S PROCESS("LAST DT/TM")=$P(NODE,"^",6)
        S PROCESS("VMS SERVICE")=$P(NODE,"^",15)
        Q 1
        ;
STOPHL7 ;shut down HLO HL7
        N ZTSK,DOLLARJ
        ;let other processes know that starting/stopping is underway
        S $P(^HLD(779.1,1,0),"^",9)=0
        S ZTSK=""
        F  S ZTSK=$O(^HLTMP("HL7 QUEUED PROCESSES",ZTSK)) Q:ZTSK=""  D DQ^%ZTLOAD
        S DOLLARJ=""
        F  S DOLLARJ=$O(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)) Q:DOLLARJ=""  S ZTSK=$P($G(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)),"^",2) I ZTSK]"" D PCLEAR^%ZTLOAD(ZTSK) I $$ASKSTOP^%ZTLOAD(ZTSK)
        D CHKQUED
        Q
        ;
STARTHL7        ; Jim's changes
        ;start HL7 system, but first do some cleanup
        ;
        ;*****Start HL*1.6*138
        N STOPPED
        D STOPHL7^HLOPROC1
        L +^HLTMP("PROCESS MANAGER"):60
        S STOPPED=$T
        D RECOUNT() ;checks list of processes, both running and queued
        I STOPPED D
        .N ALLDEAD
        .;wait a little while to see if all the processes stop 
        .F I=1:1:4 S ALLDEAD=$S(($O(^HLTMP("HL7 RUNNING PROCESSES",""))=""):1,1:0) Q:ALLDEAD  H 5
        .Q:'ALLDEAD  ;giveup on recounting queues - processes
        .;
        .;start HL*1.6*138
        .D RESET ;;recounts the queues and sets counts
        .;*****End HL*1.6*138
        ;set the system status flag to active
        S $P(^HLD(779.1,1,0),"^",9)=1
        ;
        ;start the HL7 Process Manager, which will start everything else
        N PROCESS
        S PROCESS("NAME")="PROCESS MANAGER"
        S PROCESS("IEN")=$O(^HLD(779.3,"B","PROCESS MANAGER",0))
        L -^HLTMP("PROCESS MANAGER") ;signals that HLO process manager can be started again
        D DOWORK(.PROCESS)
        Q
        ;
QUIT1(COUNT)    ;just returns 1 as function value first time around,then 0, insuring that the DO WORK function is called just once
        I '$G(COUNT) S COUNT=1 Q 1
        Q 0
        ;
CHKDEAD(WORK)   ;
        ;did any process terminate without erasing itself?
        ;WORK (pass by reference, not required) by the Process Manager that is not used and not required
        N DOLLARJ S DOLLARJ=""
        L +HL7("COUNTING PROCESSES"):20
        Q:'$T
        F  S DOLLARJ=$O(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)) Q:DOLLARJ=""  I DOLLARJ'=$J L +^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ):1 D:$T
        .L -^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)
        .N PROC
        .S PROC=$P($G(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)),"^",3)
        .K ^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)
        .Q:PROC=""
        .I $$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)),-1)<0,$$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)),1)
        L -HL7("COUNTING PROCESSES")
        Q
CHKQUED ;did any queued task get dequeued without being erased?
        N PROC,JOB
        L +HL7("COUNTING PROCESSES"):20
        Q:'$T
        S JOB=""
        F  S JOB=$O(^HLTMP("HL7 QUEUED PROCESSES",JOB)) Q:JOB=""  I '$$QUEUED(JOB) D
        .N PROC
        .S PROC=$P($G(^HLTMP("HL7 QUEUED PROCESSES",JOB)),"^",2)
        .I PROC]"",$$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)),-1)<0,$$INC^HLOSITE($NA(^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)),1)
        .K ^HLTMP("HL7 QUEUED PROCESSES",JOB)
        L -HL7("COUNTING PROCESSES")
        Q
        ;
QUEUED(TASK)    ;
        ;function returns 0 if ZTSK is not queued to run, 1 if it is
        N ZTSK
        S ZTSK=TASK
        D ISQED^%ZTLOAD
        Q:ZTSK(0) 1
        Q 0
        ;
CNTLIVE ;count the running processes
        N JOB,COUNTS,PROC
        L +HL7("COUNTING PROCESSES"):20
        Q:'$T
        S JOB=""
        F  S JOB=$O(^HLTMP("HL7 RUNNING PROCESSES",JOB)) Q:JOB=""  S PROC=$P($G(^HLTMP("HL7 RUNNING PROCESSES",JOB)),"^",3) I PROC]"" S COUNTS(PROC)=$G(COUNTS(PROC))+1
        S PROC="" F  S PROC=$O(COUNTS(PROC)) Q:PROC=""  S ^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)=COUNTS(PROC)
        S PROC="" F  S PROC=$O(^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)) Q:PROC=""  S ^HLC("HL7 PROCESS COUNTS","RUNNING",PROC)=+$G(COUNTS(PROC))
        L -HL7("COUNTING PROCESSES")
        Q
        ;
CNTQUED ;count the queued tasks
        N JOB,COUNTS,PROC
        L +HL7("COUNTING PROCESSES"):20
        Q:'$T
        S JOB=""
        F  S JOB=$O(^HLTMP("HL7 QUEUED PROCESSES",JOB)) Q:JOB=""  S PROC=$P($G(^HLTMP("HL7 QUEUED PROCESSES",JOB)),"^",2) I PROC]"" S COUNTS(PROC)=$G(COUNTS(PROC))+1
        S PROC="" F  S PROC=$O(COUNTS(PROC)) Q:PROC=""  S ^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)=COUNTS(PROC)
        S PROC="" F  S PROC=$O(^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)) Q:PROC=""  S ^HLC("HL7 PROCESS COUNTS","QUEUED",PROC)=+$G(COUNTS(PROC))
        L -HL7("COUNTING PROCESSES")
        Q
        ;
RECOUNT(RECOUNT)        ;check that the processes that are supposed to be running actually are, same for the queued processes
        ;Input:
        ;  RECOUNT (pass by reference, optional) not used, but passed in by the process manager
        ;
        ;
        ;check for processes that are supposed to be running or queued but aren't
        D CHKDEAD(),CHKQUED
        ;
        ;recount the processes
        D CNTLIVE,CNTQUED
        Q
        ;
        ;*****Start HL*1.6*138 PIJ 10/26/2007
RESET   ;
        N CTR,DT,LINK,QUEUE,MSGIEN
        K ^HLTMP("FAILING LINKS")
        S LINK=""
        F  S LINK=$O(^HLB("QUEUE","OUT",LINK)) Q:LINK=""  D
        . S DT=$G(^HLB("QUEUE","OUT",LINK))
        . I DT'="" S ^HLTMP("FAILING LINKS",LINK)=DT ;; down link (has a DT/TM)
        ;
QCNT    ; reset QUEUECOUNT
        N LOCK,FROM
        N $ETRAP,$ESTACK S $ETRAP="G ERROR^HLOPROC1"
        D RCNT^HLOSITE("S") ;; SET RECOUNT FLAG on
        ;
        ; recount each OUT queue
        ;first delete counters for non-existent queues
        S LINK=""
        F  S LINK=$O(^HLC("QUEUECOUNT","OUT",LINK)) Q:LINK=""  D
        . S QUEUE=""
        . F  S QUEUE=$O(^HLC("QUEUECOUNT","OUT",LINK,QUEUE)) Q:QUEUE=""  I '$O(^HLB("QUEUE","OUT",LINK,QUEUE,0)) D
        . . S LOCK=$NA(RECOUNT("OUT",LINK,QUEUE))
        . . L +@LOCK:1 Q:'$T  ;should not fail, but if it does skip recount for this queue
        . .I '$O(^HLB("QUEUE","OUT",LINK,QUEUE,0)) S ^HLC("QUEUECOUNT","OUT",LINK,QUEUE)=0
        . . L -@LOCK
        ;
        ;now count the queues
        S LINK=""
        F  S LINK=$O(^HLB("QUEUE","OUT",LINK)) Q:LINK=""  D
        . S QUEUE=""
        . F  S QUEUE=$O(^HLB("QUEUE","OUT",LINK,QUEUE)) Q:QUEUE=""  D
        . . S LOCK=$NA(RECOUNT("OUT",LINK,QUEUE))
        . . L +@LOCK:1 Q:'$T  ;should not fail, but if it does skip recount for this queue
        . . S (MSGIEN,CTR)=0
        . . F  S MSGIEN=$O(^HLB("QUEUE","OUT",LINK,QUEUE,MSGIEN)) Q:MSGIEN=""  S CTR=CTR+1
        . . S ^HLC("QUEUECOUNT","OUT",LINK,QUEUE)=CTR
        . . L -@LOCK
        ;
        ; recount each sequence queue
        ;first delete counts for non-existent queues
        S QUEUE=""
        F  S QUEUE=$O(^HLC("QUEUECOUNT","SEQUENCE",QUEUE)) Q:QUEUE=""  D
        . Q:$G(^HLB("QUEUE","SEQUENCE",QUEUE))!$O(^HLB("QUEUE","SEQUENCE",QUEUE,0))
        . S LOCK=$NA(RECOUNT("SEQUENCE",QUEUE))
        . L +@LOCK:1 Q:'$T
        . I '$G(^HLB("QUEUE","SEQUENCE",QUEUE)),'$O(^HLB("QUEUE","SEQUENCE",QUEUE,0)) S ^HLC("QUEUECOUNT","SEQUENCE",QUEUE)=0
        . L -@LOCK
        ;
        ;now count the queues
        S QUEUE=""
        F  S QUEUE=$O(^HLB("QUEUE","SEQUENCE",QUEUE)) Q:QUEUE=""  D
        .S LOCK=$NA(RECOUNT("SEQUENCE",QUEUE))
        . L +@LOCK:1 Q:'$T  ;should not fail, but if it does, skip the recount  of this queue
        .;
        .S (MSGIEN,CTR)=0
        .;count msg even if not on the queue if the queue is waiting on it
        . I +$G(^HLB("QUEUE","SEQUENCE",QUEUE)) S CTR=1
        .;
        . F  S MSGIEN=$O(^HLB("QUEUE","SEQUENCE",QUEUE,MSGIEN)) Q:MSGIEN=""  S CTR=CTR+1
        . S ^HLC("QUEUECOUNT","SEQUENCE",QUEUE)=CTR
        . L -@LOCK
        ;
        ;recount flag not needed anymore
        D RCNT^HLOSITE("U")
        ;
        ; now caculate the all-inclusive counter
        S QUEUE=""
        S CTR=0
        F  S QUEUE=$O(^HLC("QUEUECOUNT","SEQUENCE",QUEUE)) Q:QUEUE=""  S CTR=CTR+$G(^HLC("QUEUECOUNT","SEQUENCE",QUEUE))
        S ^HLC("QUEUECOUNT","SEQUENCE")=CTR
        ;
        ;
        ; recount IN queues
        ;the infilers and server should currently be stopped, so there is no contention for these data structures
        ;
        ;first delete counts for non-existent queues
        S FROM=""
        F  S FROM=$O(^HLC("QUEUECOUNT","IN",FROM)) Q:FROM=""  D
        . S QUEUE=""
        . F  S QUEUE=$O(^HLC("QUEUECOUNT","IN",FROM,QUEUE)) Q:QUEUE=""  I '$O(^HLB("QUEUE","IN",FROM,QUEUE,0)) S ^HLC("QUEUECOUNT","IN",FROM,QUEUE)=0
        ;
        ;now count the queues
        S FROM=""
        F  S FROM=$O(^HLB("QUEUE","IN",FROM)) Q:FROM=""  D
        . S QUEUE=""
        . F  S QUEUE=$O(^HLB("QUEUE","IN",FROM,QUEUE)) Q:QUEUE=""  D
        . . S (MSGIEN,CTR)=0
        . . F  S MSGIEN=$O(^HLB("QUEUE","IN",FROM,QUEUE,MSGIEN)) Q:MSGIEN=""  D
        . . . S CTR=CTR+1
        . . S ^HLC("QUEUECOUNT","IN",FROM,QUEUE)=CTR
        ;
        Q
ERROR   ;
        ;cleanup if the error occurred during queue recount
        D RCNT^HLOSITE("U")
        I $L($G(LOCK)) L -@LOCK
        D ^%ZTER
        D UNWIND^%ZTER
        Q
        ;*****End HL*1.6*138
