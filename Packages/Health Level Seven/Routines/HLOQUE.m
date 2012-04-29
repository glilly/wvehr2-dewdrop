HLOQUE  ;ALB/CJM/OAK/PIJ- HL7 QUEUE MANAGEMENT - 10/4/94 1pm ;07/07/2008
        ;;1.6;HEALTH LEVEL SEVEN;**126,132,134,137,138**;Oct 13, 1995;Build 34
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
INQUE(FROM,QNAME,IEN778,ACTION,PURGE)   ;
        ;Will place the message=IEN778 on the IN queue, incoming
        ;Input:
        ;  FROM - sending facility from message header.
        ;         For actions other than incoming messages, its the specified link.
        ;  QNAME - queue named by the application
        ;  IEN778 = ien of the message in file 778
        ;  ACTION - <tag^routine> that should be executed for the application
        ;  PURGE (optional) - PURGE=1 indicates that the purge dt/tm needs to be set by the infiler
        ;     If PURGE("ACKTOIEN") is set, it indicates that the purge dt/tm of
        ;     the original message to this application ack also needs to be set.
        ;Output: none
        ;
        I $G(FROM)="" S FROM="UNKNOWN"
        I '$L($G(QNAME)) S QNAME="DEFAULT"
        S ^HLB("QUEUE","IN",FROM,QNAME,IEN778)=ACTION_"^"_$G(PURGE)_"^"_$G(PURGE("ACKTOIEN"))
        I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","IN",FROM,QNAME)))
        Q
        ;
OUTQUE(LINKNAME,PORT,QNAME,IEN778)      ;
        ;Will place the message=IEN778 on the out-going queue
        ;Input:
        ;  LINKNAME = name of (.01) the logical link
        ;  PORT (optional) the port to connect to
        ;  QNAME - queue named by the application
        ;  IEN778 = ien of the message in file 778
        ;Output: none
        ;
        N SUB,FLG
        S FLG=0
        S SUB=LINKNAME
        I PORT S SUB=SUB_":"_PORT
        I '$L($G(QNAME)) S QNAME="DEFAULT"
        ;***Start HL*1.6*138 PIJ
        ;if recount in progress, give it up to 20 seconds to finish - if it takes longer than that the recount won't be exact, but a longer delay is unreasonable
        I $$RCNT^HLOSITE L +RECOUNT("OUT",SUB,QNAME):20 S:$T FLG=1
        ;***End HL*1.6*138 PIJ"
        S ^HLB("QUEUE","OUT",SUB,QNAME,IEN778)=""
        I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","OUT",SUB,QNAME)))
        L:FLG -RECOUNT("OUT",SUB,QNAME)
        Q
        ;
DEQUE(FROMORTO,QNAME,DIR,IEN778)        ;
        ;This routine will remove the message=IEN778 from its queue
        ;Input:
        ;  DIR = "IN" or "OUT", denoting the direction that the message is going in
        ;  FROMORTO = for outgoing: the .01 field of the logical link
        ;         for incoming: sending facility
        ;  IEN778 = ien of the message in file 778
        ;Output: none
        ;
        Q:(FROMORTO="")
        I ($G(QNAME)="") S QNAME="DEFAULT"
        D
        .I $E(DIR)="I" S DIR="IN" Q
        .I $E(DIR)="O" S DIR="OUT" Q
        I DIR'="IN",DIR'="OUT" Q
        Q:'$G(IEN778)
        D:$D(^HLB("QUEUE",DIR,FROMORTO,QNAME,IEN778))
        .K ^HLB("QUEUE",DIR,FROMORTO,QNAME,IEN778)
        .;don't let the count become negative
        .I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT",DIR,FROMORTO,QNAME)),-1)<0,$$INC^HLOSITE($NA(^HLC("QUEUECOUNT",DIR,FROMORTO,QNAME)))
        Q
        ;
STOPQUE(DIR,QUEUE)      ;
        ;This API is used to set a stop flag on a named queue.
        ;DIR=<"IN" or "OUT">
        ;QUEUE - the name of the queue to be stopped
        ;
        Q:$G(DIR)=""
        Q:$G(QUEUE)=""
        S ^HLTMP("STOPPED QUEUES",DIR,QUEUE)=1
        Q
STARTQUE(DIR,QUEUE)     ;
        ;This API is used to REMOVE the stop flag on a named queue.
        ;DIR=<"IN" or "OUT">
        ;QUEUE - the name of the queue to be stopped
        ;
        Q:$G(DIR)=""
        Q:$G(QUEUE)=""
        K ^HLTMP("STOPPED QUEUES",DIR,QUEUE)
        Q
STOPPED(DIR,QUEUE)      ;
        ;This API is used to DETERMINE if the stop flag on a named queue is set.
        ;Input:
        ;  DIR=<"IN" or "OUT">
        ;  QUEUE - the name of the queue to be checked
        ;Output:
        ;  Function returns 1 if the queue is stopped, 0 otherwise
        Q:$G(DIR)="" 0
        Q:$G(QUEUE)="" 0
        I $G(^HLTMP("STOPPED QUEUES",DIR,QUEUE)) Q 1
        Q 0
        ;
SQUE(SQUE,LINKNAME,PORT,QNAME,IEN778)   ;
        ;Will place the message=IEN778 on the sequencing queue. This is always done in the context of the application calling an HLO API to send a message.
        ;Input:
        ;  SQUE - name of the sequencing queue
        ;  LINKNAME = name of (.01) the logical link
        ;  PORT (optional) the port to connect to
        ;  QNAME (optional) outgoing queue
        ;  IEN778 = ien of the message in file 778
        ;Output: 1 if placed on the outgoing queue, 0 if placed on the sequence queue
        ;
        N NEXT,MOVED,FLG
        S (FLG,MOVED)=0
        ;
        ;keep a count of messages pending on sequence queues for the HLO System Monitor
        ;
        ;***Start HL*1.6*138 PIJ
        ;if recount in progress, pause up to 20 seconds to finish - if it takes longer than that the recount won't be exact, but a longer delay is unreasonable
        I $$RCNT^HLOSITE L +RECOUNT("SEQUENCE",SQUE):20 S:$T FLG=1
        ;***End HL*1.6*138 PIJ
        ;
        S NEXT=+$G(^HLB("QUEUE","SEQUENCE",SQUE))
        I NEXT=IEN778 L -^HLB("QUEUE","SEQUENCE",SQUE) Q 0  ;already queued!
        ;
        ;increment the counter for all sequence queues
        I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE")))
        ;
        ;*** Start HL*1.6*138 CJM
        ;also keep counter for the individual queue
        I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE",SQUE)))
        ;*** End HL*1.6*138 CJM
        ;
        L +^HLB("QUEUE","SEQUENCE",SQUE):200
        ;
        ;if the sequence queue is empty and not waiting on a message, then the message can be put directly on the outgoing queue, bypassing the sequence queue
        I '$O(^HLB("QUEUE","SEQUENCE",SQUE,0)),'NEXT D
        .S ^HLB("QUEUE","SEQUENCE",SQUE)=IEN778 ;to mean something moved to outgoing but not yet transmitted
        .D OUTQUE(.LINKNAME,.PORT,.QNAME,IEN778)
        .S MOVED=1
        E  D
        .;Put the message on the sequence queue.
        .S ^HLB("QUEUE","SEQUENCE",SQUE,IEN778)=""
        L -^HLB("QUEUE","SEQUENCE",SQUE)
        L:FLG -RECOUNT("SEQUENCE",SQUE)
        Q MOVED
        ;
ADVANCE(SQUE,MSGIEN)    ;
        ;Will move the specified sequencing queue to the next message.
        ;Input:
        ;  SQUE - name of the sequencing queue
        ;  MSGIEN - the ien of the message upon which the sequence queue was waiting.  If it is NOT the correct ien, then the sequence queue will NOT be advance.
        ;Output:
        ;  Function - 1 if advanced, 0 if not
        ;
        N NODE,IEN778,LINKNAME,PORT,QNAME
        Q:'$L($G(SQUE)) 0
        Q:'$G(MSGIEN) 0
        L +^HLB("QUEUE","SEQUENCE",SQUE):200
        ;
        ;do not advance if the queue wasn't pending the message=MSGIEN
        I (MSGIEN'=$P($G(^HLB("QUEUE","SEQUENCE",SQUE)),"^")) L -^HLB("QUEUE","SEQUENCE",SQUE) Q 0
        ;
        ;decrement the count of messages pending on all sequence queues
        I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE")),-1)<0,$$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE")))
        ;
        ;**Start HL*1.6*138 CJM
        ;decrement the count of messages pending on this individual queue
        I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE",SQUE)),-1)<0,$$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE",SQUE)))
        ;**End HL*1.6*138 CJM
        ;
        S IEN778=0
        ;look for the first message on the sequence que.  Make sure its valid, if not remove the invalid entry and keep looking.
        F  S IEN778=$O(^HLB("QUEUE","SEQUENCE",SQUE,0)) Q:'IEN778  S NODE=$G(^HLB(IEN778,0)) Q:$L(NODE)  D
        .;message does not exist! Remove from queue and try again.
        .K ^HLB("QUEUE","SEQUENCE",SQUE,IEN778)
        .I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE")),-1)<0,$$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE"))) ;decrement the count of messages pending sequence queues
        .;**Start HL*1.6*138 CJM
        .; also decrement the count of messages pending on this individual queue
        .I $$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE",SQUE)),-1)<0,$$INC^HLOSITE($NA(^HLC("QUEUECOUNT","SEQUENCE",SQUE)))
        .;**End HL*1.6*138 CJM
        ;
        ;IEN778 is the next pending msg on this sequence queue
        I IEN778 D
        .;
        .;parse out info needed to move to outgoing queue
        .S LINKNAME=$P(NODE,"^",5),PORT=$P(NODE,"^",8),QNAME=$P(NODE,"^",6)
        .;
        .S ^HLB("QUEUE","SEQUENCE",SQUE)=IEN778 ;indicates this sequence queue is now waiting for msg=IEN778 before advancing.  The second pieces is the timer, but will not be set until the message=IEN778 is actually transmitted.
        .K ^HLB("QUEUE","SEQUENCE",SQUE,IEN778) ;remove from sequence queue
        .L -^HLB("QUEUE","SEQUENCE",SQUE)
        .S $P(^HLB(IEN778,5),"^",2)=1
        .D OUTQUE(.LINKNAME,$G(PORT),$G(QNAME),IEN778) ;move to outgoing queue
        E  D
        .K ^HLB("QUEUE","SEQUENCE",SQUE) ;this sequence queue is currently empty and not needed
        .L -^HLB("QUEUE","SEQUENCE",SQUE)
        Q 1
        ;
SEQCHK(WORK)    ;functions under the HLO Process Manager
        ;check sequence queues for timeout
        N QUE,NOW
        S NOW=$$NOW^XLFDT
        S QUE=""
        F  S QUE=$O(^HLB("QUEUE","SEQUENCE",QUE)) Q:QUE=""  D
        .N NODE,MSGIEN,ACTION,NODE
        .S NODE=$G(^HLB("QUEUE","SEQUENCE",QUE))
        .Q:'$P(NODE,"^",2)
        .Q:$P(NODE,"^",2)>NOW
        .Q:$P(NODE,"^",3)
        .L +^HLB("QUEUE","SEQUENCE",QUE):2
        .;don't report if a lock wasn't obtained
        .Q:'$T
        .S NODE=$G(^HLB("QUEUE","SEQUENCE",QUE))
        .I '$P(NODE,"^",2) L -^HLB("QUEUE","SEQUENCE",QUE) Q
        .I ($P(NODE,"^",2)>NOW) L -^HLB("QUEUE","SEQUENCE",QUE) Q
        .I $P(NODE,"^",3) L -^HLB("QUEUE","SEQUENCE",QUE) Q  ;exception already raised
        .S MSGIEN=$P(NODE,"^")
        .I 'MSGIEN L -^HLB("QUEUE","SEQUENCE",QUE) Q
        .S ACTION=$$EXCEPT^HLOAPP($$GETSAP^HLOCLNT2(MSGIEN))
        .S $P(^HLB(MSGIEN,5),"^",3)=1
        .S $P(^HLB("QUEUE","SEQUENCE",QUE),"^",3)=1 ;indicates exception raised
        .L -^HLB("QUEUE","SEQUENCE",QUE)
        .D  ;call the application to take action
        ..N HLMSGIEN,MCODE,DUZ,QUE,NOW
        ..N $ETRAP,$ESTACK S $ETRAP="G ERROR^HLOQUE"
        ..S HLMSGIEN=MSGIEN
        ..S MCODE="D "_ACTION
        ..N MSGIEN,X
        ..D DUZ^XUP(.5)
        ..X MCODE
        ..;kill the apps variables
        ..D
        ...N ZTSK
        ...D KILL^XUSCLEAN
        Q
ERROR   ;error trap for application context
        S $ETRAP="D UNWIND^%ZTER"
        D ^%ZTER
        S $ECODE=",UAPPLICATION ERROR,"
        ;
        ;kill the apps variables
        D
        .N ZTSK,MSGIEN,QUEUE
        .D KILL^XUSCLEAN
        ;
        ;release all the locks the app may have set, except Taskman lock
        L:$D(ZTSK) ^%ZTSCH("TASK",ZTSK):1
        L:'$D(ZTSK)
        ;reset HLO's lock
        L +^HLTMP("HL7 RUNNING PROCESSES",$J):0
        ;return to processing the next message on the queue
        D UNWIND^%ZTER
        Q
