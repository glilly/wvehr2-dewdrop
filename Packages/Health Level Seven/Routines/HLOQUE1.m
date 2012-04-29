HLOQUE1 ;OIFO-OAK/RBN - HLO Developer API's for removing messages from queues ;08/11/2008
        ;;1.6;HEALTH LEVEL SEVEN;**138**;Oct 13, 1995;Build 34
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
        ; No direct calls - must use $$MSGDEL^HLOQUE1*(HLOLNAM,HLOQNAM,HLOPURDT)
        ;
        Q
        ;
MSGDEL(HLOLNAM,HLOQNAM,HLOPURDT,HLOERR) ;;  Delete messages from a queue
        ;;
        ;; Functional enhancement #6  Delete all messages on a queue.
        ;;
        ;;  Description:
        ;;               This API deletes all the messages from a given OUT queue.  This is
        ;;               the core non-interactive API.  It can be used in code, or via the
        ;;               separate interactive user interface QUEPUR^HLOAPI
        ;;
        ;;  Inputs :
        ;;            1 Name of link (if null assume sequence queues)
        ;;            2 Name of queue (required)
        ;;            3 Purge date/time (defaults to file 779.1 error purge)
        ;;            4 HLOERR, passed by reference (required if error report required)
        ;;
        ;;  Outputs:
        ;;            1. Success:
        ;;               HLORPT -> name of queue^link^number of messages deleted
        ;;               Returns number of messages deleted.
        ;;
        ;;            2. Failure:
        ;;               HLOERR("LINK")   -> "Invalid link name"
        ;;                                   "Required link parameter missing
        ;;               HLOERR("QUEUE")  -> "Queue name does not exist"
        ;;                                   "Required queue parameter missing"
        ;;               HLOERR("PURDAT") -> "Invalid purge date"
        ;;                                   "Required purge date parameter missing"
        ;;               HLOERR("PURGE")  -> "Message"_MessageIEN_"not purged"
        ;;               Returns 0
        ;;
        ;;  Variables used:
        ;;               HLOLNAM  - logical link name.
        ;;               HLOQNAM  - queue name.
        ;;               HLOPURDT- purge date/time.
        ;;               HLOQIEN  - ien of message in file #778.
        ;;               HLOSRPT  - summary report array.
        ;;               HLOERR   - error report array, passed by reference.
        ;;               HLOCNT   - number of messages deleted from queue.
        ;;               SUCCESS  - Return value.
        ;;
        ;
        ; Init variables
        N HLOQIEN,QIEN,MIEN,FLG,HLOCNT,FROMORTO
        S HLOCNT=0
        S FLG=1
        ;
        ; Check for presence of input parameters
        D PARAM
        ;
        ; Validate them
        D VAL
        ;
        ; If any of the input parameters are bad quit and return 0 (zero)
        Q:$D(HLOERR)=11 HLOCNT
        ;
        ; Start the actual purging of the queue
        I $G(HLOLNAM)'="" D HLOPUR
        I $G(HLOLNAM)="" D SEQPUR
        ;
        ; Return to calling routine
        Q HLOCNT
        ;
        ;****
        ;Subroutines
        ;****
        ;
VAL     ; Validate the link name, queue name and purge d/t
        N TMPLNAM,%DT,X,Y,SYSPARM
        S QIEN=""
        S TMPLNAM=$P(HLOLNAM,":",1)
        ;
        Q:$D(HLOERR)=11
        ;
        ; Are input parameters valid?
        S FLG=1                              ; LINK
        I $G(HLOLNAM)'="",$D(^HLCS(870,"B",TMPLNAM))=0 D
        . S HLOERR("LINK")="Invalid link name"_HLOLNAM
        . S FLG=0
        ;
        S FLG=0                              ; QUEUE
        I $G(HLOLNAM)'="" D
        .  F  S QIEN=$O(^HLB("QUEUE","OUT",HLOLNAM,QIEN)) Q:QIEN=""!FLG=1  D
        .  .  S:QIEN=HLOQNAM FLG=1
        .  S:FLG=0 HLOERR("QUEUE")="Queue "_HLOQNAM_" does not exist"
        I $G(HLOLNAM)="" D
        .  F  S QIEN=$O(^HLB("QUEUE","SEQUENCE",QIEN)) Q:QIEN=""!FLG=1  D
        .  .  S:QIEN=HLOQNAM FLG=1
        .  S:FLG=0 HLOERR("QUEUE")="Queue "_HLOQNAM_" does not exist"
        ;
        I $G(HLOPURDT)'=""  D
        .  S %DT="ST"
        .  S X=HLOPURDT
        .  D ^%DT
        .  S:Y<0 HLOERR("PURDAT")="Invalid purge date"
        ;
        ; could kill off the user entered purge date and force the standard
        ; purge date from the HLO SYSTEM PARAMETERS FILE
        ; S:Y<0 HLOPURDT=""
        ;
        I HLOPURDT="" D                      ; PURGE DATE/TIME
        .  D SYSPARMS^HLOSITE(.SYSPARM)
        .  S HLOPURDT=$$FMADD^XLFDT($$NOW^XLFDT,0,SYSPARM("ERROR PURGE"),0,0)
        Q
        ;
PARAM   ; Check for missing input parameters
        I $G(HLOQNAM)="" S HLOERR("QUEUE")="Required queue parameter missing" S FLG=0
        Q
        ;
HLOPUR  ; Process HLO queue
        N CONF
        D OWNSKEY^XUSRB(.CONF,"HLOMGR",DUZ)
        I CONF(0)'=1 D  Q
        . W !,"**** You are not authorized to use this option ****" D PAUSE^VALM1 Q
        N MSGNUM
        S MIEN=""
        I '$G(HLOPURDT) Q
        L +^HLB("QUEUE","OUT",HLOLNAM,HLOQNAM):15 I '$T D  Q
        .  W !!,?5,"Sorry, someone else is using that queue - try again later.",!!
        .  S DIR("0")="E"
        .  D ^DIR
        F  S MIEN=$O(^HLB("QUEUE","OUT",HLOLNAM,HLOQNAM,MIEN)) Q:'MIEN  D
        .  ; don't need to mess about with crossreferences since the call below handles
        .  ; related to purging
        .  S FLG=$$SETPURGE^HLOAPI3(MIEN,HLOPURDT)
        .  ; if the message does not purge log the fact
        .  ; and do not delete it.
        .  I 'FLG D  Q
        .  .  S MSGNUM=$P(^HLB(MIEN,0),"^",1)
        .  .  S HLOERR("PURGE",MSGNUM)="Message "_MSGNUM_"not purged"
        .  S $P(^HLB(MIEN,0),"^",21)="MESSAGE GENERATED IN ERROR AND NOT PROCESSED"
        .  D DEQUE^HLOQUE(HLOLNAM,HLOQNAM,"OUT",MIEN)
        .  ; If we actually want to delete the messages that were dequeued
        .  ; uncomment the next two lines.
        .  ; D GETWORK^HLOPURGE("OUT")
        .  ; D DOWORK^HLOPURGE("OUT")
        .  S HLOCNT=HLOCNT+1
        L -^HLB("QUEUE","OUT",HLOLNAM,HLOQNAM)
        Q
        ;
SEQPUR  ; Process sequential queue
        N CONF
        D FULL^VALM1
        D OWNSKEY^XUSRB(.CONF,"HLOMGR",DUZ)
        I CONF(0)'=1 D  Q
        . W !,"**** You are not authorized to use this option ****" D PAUSE^VALM1
        N MSGNUM,FLG,MIEN
        S MIEN=""
        I '$D(^HLB("QUEUE","SEQUENCE",HLOQNAM)) D  Q
        . S HLOERR("SEQUENCE")="Queue "_HLOQNAM_" does not exist"
        S MIEN=""
        L +^HLB("QUEUE","SEQUENCE",HLOQNAM):15 I '$T D  Q
        .  W !!,?5,"Sorry, someone else is using that queue - try again later.",!!
        .  S DIR("0")="E"
        .  D ^DIR
        F  S MIEN=$O(^HLB("QUEUE","SEQUENCE",HLOQNAM,MIEN)) Q:MIEN=""  D
        .  S FLG=$$SETPURGE^HLOAPI3(MIEN,HLOPURDT)
        .  I 'FLG D  Q
        .  .  S MSGNUM=$P(^HLB(MIEN,0),"^",1)
        .  .  S HLOERR("PURGE",MSGNUM)="Sequence message "_MSGNUM_"not purged"
        .  .  S $P(^HLB(MIEN,0),"^",21)="MESSAGE GENERATED IN ERROR AND NOT PROCESSED"
        .  K ^HLB("QUEUE","SEQUENCE",HLOQNAM,MIEN)
        .  S HLOCNT=HLOCNT+1
        K ^HLB("QUEUE","SEQUENCE",HLOQNAM)
        L -^HLB("QUEUE","SEQUENCE",HLOQNAM)
        ;
        Q
CLEAN   ; Remove variables not needed.
        K HLOLNAM,HLOQNAM,HLOPURDT
        Q
        ;
LMQUES  ; Called from List Manager to purge sequence queue.
        N CONF,FAIL
        D OWNSKEY^XUSRB(.CONF,"HLOMGR",DUZ)
        I CONF(0)'=1 D  Q
        . W !,"**** You are not authorized to use this option ****" D PAUSE^VALM1 Q
        Q:$$VERIFY^HLOQUE1()=-1
        N HLOLNAM,HLOQNAM,HLOPURDT,LOCERR,HLOCNT,TRYAGN,LNAM,QNAM,PURDT
AGAIN   ;
        S HLOCNT=0
SQ      ;I QUETYP="S" F  D  Q:LOCERR
        I QUETYP="S" F  D  Q:LOCERR'=""
        .  N HLPARMS
        .  S LOCERR=$$SEQQUE^HLOAPI5
        .  I LOCERR="Q" Q  ;
        .  I LOCERR="S" Q:$$LMERHD()  ; Quit if answer is no
        .  D LMPUR
        .  D SEQPUR  ; Kill sequence queues
        .  D SEARCH^HLOUSR4(.HLPARMS)
        .  S LOCERR=1
        .  D SEARCH^HLOUSR4(.HLPARMS)
        .  D RE^VALM4
OQ      I QUETYP="O" F  D  Q:LOCERR'=""
        .  S LOCERR=$$GETLNK^HLOAPI5
        .  I LOCERR="Q" Q  ;
        .  I LOCERR=1 Q:$$LMERHD
        .  S LOCERR=$$GETQUE^HLOAPI5
        .  I LOCERR="Q" Q  ;
        .  I LOCERR=2 Q:$$LMERHD
        .  D LMPUR
        .  I LOCERR=3 Q:$$LMERHD
        .  D HLOPUR  ; Kill OUT queues
        .  S LOCERR=1
        .  D OUTQUE^HLOUSR6
        .  D RE^VALM4
        I LOCERR="Q" Q  ;
        I '$$ASKYESNO^HLOUSR2("Would you like to delete another queue","YES")  S VALMBCK="R" Q
        G AGAIN
        Q
        ;
LMPUR   ; Prompt and return point purge date
        S LOCERR=$$GETPUR^HLOAPI5()
        Q
        ;
LMERHD()        ; Error handler for LMQUES
        W !,"OOPS.  That was an invalid entry",!
        S LOCERR=$$ASKYESNO^HLOUSR2("Would you like to try again","YES")
        Q LOCERR
        ;
VERIFY()        ; Verify that the user REALLY wants to do whatever they are about to do.
         D FULL^VALM1
         W !,"!!!!! WARNING! - What you are about to do can result in lost messages !!!!!" D PAUSE^VALM1
         I $G(DUOUT)!($G(DTOUT)) Q -1
         W !,"!!!!! message sequencing problems and database corruption " D PAUSE^VALM1
         I $G(DUOUT)!($G(DTOUT)) Q -1
         S DIR(0)="YO"
         S DIR("A")="          Are you sure you want to continue? Enter <Yes> to continue"
         S DIR("?")="Enter <Y> to continue."
         D ^DIR
         K DIR
         I $G(DUOUT)!($G(DTOUT))!$G(DIRUT) Q -1
         I Y'=1 Q -1
         S DIR(0)="FO"
         S DIR("A")="  Please verify by entering <ConTinue> EXACTLY as shown "
         S DIR("?")="Enter <ConTinue> to proceed."
         D ^DIR
         K DIR
         I $G(DUOUT)!($G(DTOUT))!$G(DIRUT) Q -1
         Q:X'="ConTinue" -1
         W !
         Q 0
         ;
