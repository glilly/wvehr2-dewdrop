HLOAPI5 ;OIFO-OAK/RBN - HLO User interface to MSGDEL delevoper's API ;07/17/2008
        ;;1.6;HEALTH LEVEL SEVEN;**138**;Oct 13, 1995;Build 34
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
        ; No direct calls - must use $$MSGDELUI^HLOAPI5
        ;
        Q
        ;
MSGDELUI        ;; User interface to MSGDEL^HLOQUE
        ;;
        ;;  Functional enhancement #6 - Delete all messages on a queue user interface
        ;;
        ;;  Description:
        ;;           This API provides a user interface to the $$MSGDEL^HLOQUE function
        ;;
        ;;  Inputs :
        ;;           1 Name of link (required)
        ;;           2 Name of queue (defaults to "DEFAULT")
        ;;           3 Purge date/time (defaults to NOW)
        ;;
        ;;           NOTE: All inputs are validated.
        ;;                 The user is given a change to review the inputs.
        ;;                 The user is warned prior to committing to the deletions.
        ;;
        ;;  Outputs:
        ;;           1. Success -
        ;;              Displays a report of the deleted message link, queue and count.
        ;;
        ;;           2. Failure -
        ;;              Returns a message to the user about what failed.
        ;;
        ;;  Variables used:
        ;;           HLOLNAM  - logical link name.
        ;;           HLOQNAM  - queue name.
        ;;           HLOPURDT - purge date/time.
        ;;           HLOQIEN  - ien of message in file #778.
        ;;           HLOSRPT  - summary report array.
        ;;           HLOERR   - error report array.
        ;;           HLOCNT   - number of messages deleted from queue.
        ;
        ; Must have HLOMGR key to use
        N CONF
        D OWNSKEY^XUSRB(.CONF,"HLOMGR",DUZ)
        I CONF(0)'=1 D  Q
        . W "**** You are not authorized to use this option ****",!
        . S DIR(0)="E" D ^DIR
        Q:$$VERIFY^HLOQUE1()=-1
        ;
        ; Init variables
        N HLOLNAM,HLOQNAM,HLOPURDT,HLOQIEN,HLOSRPT,HLOERR,HLOCNT,ERRTYP
        N LNAM,QNAM,PURDT
        N DELMSG,X,Y,ANS,QUETYP
        ;
        ; Entry point for "Delete Messages From Queue" user interface.
        ;
        D SPLASH ; Display splash screen for "Delete Messages From Queue".
        ;
        ; Ask user if they want to delete a sequence or outgoing queue
EN      ;
        S QUETYP=""
        S ERRTYP=$$SEQOUT
        I ERRTYP'=0 G ERRHNDL
        I $E(QUETYP)="S" D  G AGAIN
        .  S ERRTYP=$$SEQQUE
        .  I ERRTYP'=0 G ERRHNDL Q
        .  W !!,?10,"                      ******PLEASE NOTE *****",!
        .  W ?15,"Continuing will permenently delete the messages from the "_HLOQNAM_" queue.",!!
        .  I '$$ASKYESNO^HLOUSR2("Are you sure you want to do this?","NO") G EXIT
        . ;
        .  S DELMSG=$$MSGDEL^HLOQUE1("",HLOQNAM,"",.HLOERR)   ; CHANGE AFTER TESTING TO CORRECT ROUTINE
        .  ;
        .  I $D(HLOERR)=10 D ERRRPT
        ;
LK      ; Get link name
        D CLEAR
        S ERRTYP=0
        S ERRTYP=$$GETLNK
        I ERRTYP'=0 G ERRHNDL  ; Process link name error.
QU      ; Get queue name
        S ERRTYP=$$GETQUE
        I ERRTYP'=0 G ERRHNDL  ; Process queue name error.
PU      ; Get purge date time
        S ERRTYP=$$GETPUR
        I ERRTYP'=0 G ERRHNDL  ; Process purge date/time error.
        W !!,?10,"                      ******PLEASE NOTE *****",!
        W ?15,"Continuing will permenently delete the messages from the "_HLOQNAM_" queue.",!!
        I '$$ASKYESNO^HLOUSR2("Are you sure you want to continue","NO") G EXIT
        S ERRTYP=$$PROC
        I ERRTYP'=0 G ERRHNDL
AGAIN   ; See if user wants to do another queue.
        I ERRTYP'=0 G EXIT
        W:$G(DELMSG) !,"Number of messages deleted from "_HLOQNAM_": ",DELMSG
        I $$ASKYESNO^HLOUSR2("Would you like to continue with another queue","NO") D  G EN
        . D EXIT
        G EXIT
        Q
        ;
GETLNK()        ; Get link name from user and validate
        ;;INPUTS  : None.
        ;;OUTPUTS : HLOLNAM - Full name of link (NAME:PORT)on success.
        ;;                  - null on failure.
        ;;          LOCERR  - O on success.
        ;;                  - 1 on failure
        ;
        N FLG,X,TMPNAM,PORT,PIEN,COUNT,MSG,X,Y,DUOUT,LOCERR
        D FULL^VALM1
        S LOCERR=0
        S DIR(0)="F"
        S DIR("A")="Enter link name "
        S:$G(LNAM)'="" DIR("B")=LNAM
        S DIR("?")="Enter the link name as displayed in the HLO System Monitor."
        D ^DIR
        I $G(DUOUT)!($G(DTOUT)) S LOCERR="Q" G LEND
        S HLOLNAM=Y
        S TMPNAM=$P(X,":",1)
        S FLG=1
        I $D(^HLCS(870,"B",TMPNAM))=0 D  G LEND
        . S HLOERR("LINK")="Invalid link name"_HLOLNAM
        . S FLG=0
        . S LOCERR=1
PORT    ; Check to see if the user entered a port number
        S PORT=$P($G(X),":",2)
        I PORT="" D  G:LOCERR="Q" LEND
        .  ; They did not, so find assigned port numbers for them.
        .  S PIEN=""
        .  S COUNT=1
        .  W !,?5,"That link is currently configured for the following ports:",!
        .  F  S PIEN=$O(^HLB("QUEUE","OUT",PIEN)) Q:PIEN=""  D
        .  .  I $P(PIEN,":",1)=TMPNAM D
        .  .  .  W !,?10,COUNT,". Port number: ",$P(PIEN,":",2),!
        .  .  .  ;S DIR(0)="E"
        .  .  .  ;K DIR("A")
        .  .  .  ;D ^DIR
        .  .  .  S PORT(COUNT)=$P(PIEN,":",2)
        .  .  .  S COUNT=COUNT+1
        .  S COUNT=COUNT-1
        .  W !
        .  I COUNT>1 D  Q:LOCERR="Q"
        .  .  S DIR(0)="N^1:"_COUNT
        .  .  S DIR("A")="Which port would you like to use"
        .  .  S:$G(HLOPNAM) DIR("B")=HLOPNAM
        .  .  S DIR("?",1)="Enter the port number to be used"
        .  .  S DIR("?",2)="that is assigned to Outgoing Queue"
        .  .  S DIR("?",3)="you wish to delete."
        .  .  D ^DIR
        .  .  K DIR
        .  .  I $G(DUOUT) S LOCERR="Q" Q
        .  .  S $P(HLOLNAM,":",2)=PORT(Y)
        .  S:COUNT=1 $P(HLOLNAM,":",2)=PORT(1)
        S LNAM=HLOLNAM
LEND    Q LOCERR
        ;
GETQUE()        ; Get queue name from user and validate
        ;;INPUTS  : None.
        ;;OUTPUTS : HLOQNAM - Full name of a queue on success.
        ;;                  - null on failure.
        ;;          LOCERR  - O on success.
        ;;                  - 2 on failure
        ;
        N FLG,X,QIEN,Y,DUOUT,LOCERR
        S LOCERR=0
        S DIR(0)="F"
        S DIR("A")="Enter queue name "
        S:'$G(HLOQNAM) DIR("B")="DEFAULT"
        S:$G(QNAM)'="" DIR("B")=QNAM
        S DIR("?",1)="Enter the queue name as displayed in the HLO System Monitor"
        S DIR("?",2)="                 Outgoing Queue display."
        D ^DIR
        K DIR
        I $G(DUOUT)!(Y="") S LOCERR="Q" Q LOCERR
        S HLOQNAM=Y
        S FLG=0
        S FLG=$S($D(^HLB("QUEUE","OUT",HLOLNAM,HLOQNAM)):1,1:0)
        D:FLG<1
        .  S HLOERR("QUEUE")="Queue "_HLOQNAM_" does not exist"
        .  S LOCERR=2
        S QNAM=HLOQNAM
        Q LOCERR
        ;
GETPUR()        ; Get purge date/time from user and validate
        ;;INPUTS  : None.
        ;;OUTPUTS : HLOPURDT - Full name of a valid date on success.
        ;;                  - null on failure.
        ;;          LOCERR  - O on success.
        ;;                  - 3 on failure
        ;
        N FLG,X,Y,%DT,DTOUT,LOCERR,SYSPARM
        S LOCERR=0
        S MSG(0)=" "
        S MSG(1)="The queue of messages that you are about to delete will be purged."
        S MSG(2)="You may now set the planned purge date/time to whatever you would"
        S MSG(3)="like, or accept the default."
        S MSG(4)=" "
        D EN^DDIOL(.MSG,"","!")
        S %DT="AEST"
        S %DT("A")="Enter the purge date/time: "
        I $G(PURDT) D
        .  S Y=PURDT
        .  D DD^%DT
        .  S %DT("B")=Y
        I '$G(PURDT) D
        .  D SYSPARMS^HLOSITE(.SYSPARM)
        .  S Y=$$FMADD^XLFDT($$NOW^XLFDT,0,SYSPARM("ERROR PURGE"),0,0)
        .  D DD^%DT
        .  S %DT("B")=Y
        S %DT(0)="NOW"
        D ^%DT
        I ((Y<0)&('$D(DTOUT))) D  Q LOCERR
        .S HLOERR("PURDAT")="Invalid purge date"
        .S LOCERR=3
        S:((Y<0)&($G(X)="")) HLOPURDT=$$NOW^XLFDT
        S:$G(DUOUT) LOCERR="Q"
        S:Y>0 HLOPURDT=Y
        S PURDT=HLOPURDT
        Q LOCERR
        ;
PROC()  ; Process the request
        ;
        N LOCERR
        S DELMSG=0
        S DELMSG=$$MSGDEL^HLOQUE1(HLOLNAM,HLOQNAM,HLOPURDT)
        I $G(HLOERR)=11 D
        . D ERRRPT
        Q 0
        ;
ERRHNDL ; Process any errors
        N ANS,BACK
        ;
        I ERRTYP="Q" G EXIT
        I ERRTYP="S" D
        .  W !!,"That queue does not exit.",!
        .  S HLOQNAM=""
        .  W !
        ;
        I ERRTYP=1 D
        .  W !!,"Invalid link name.",!
        .  S HLOLNAM=""
        .  W !
        ;
        I ERRTYP=2 D
        .  W !!,"Invalid queue name.",!
        .  S HLOQNAM=""
        .  W !
        ;
        I ERRTYP=3 D
        .  W !!,"Invalid purge date/time name.",!
        .  S HLOPURDT=""
        .  W !
        ;
        ;S ANS=$$ASKYESNO^HLOUSR2("Do you want to try again?","YES")
        I ANS=0 G EXIT
        K HLOERR
        S BACK=$S(ERRTYP="S":"EN",ERRTYP=1:"LK",ERRTYP=2:"QU",ERRTYP=3:"PU",1:"EXIT")
        G @BACK
        Q
        ;
SPLASH  ; Splash screen for utility
        ;
        W @IOF   ; Clear the screen
        W "                                  DELETE MESSAGES FROM A QUEUE",!!
        Q
        ;
SEQOUT()        ; Promp user for type of queue
        N DIR,DUOUT,LOCERR
        S LOCERR=0
        S DIR(0)="F"
        S DIR("A")="Queue type (SEQUENCE/OUTGOING) "
        S DIR("B")="OUTGOING"
        S DIR("?",1)="Enter S for sequence or O for outgoing."
        D ^DIR
        K DIR
        I $G(DUOUT) S LOCERR="Q" Q LOCERR
        S QUETYP=Y
        Q LOCERR
        ;
SEQQUE()        ; Get the sequence queue name
        N DIR,DUOUT,LOCERR
        S LOCERR=0
        S DIR(0)="F"
        S DIR("A")="Name of sequence queue to delete"
        S DIR("?",1)="Enter the name of an existing sequence queue."
        D ^DIR
        K DIR
        I $G(DUOUT) S LOCERR="Q" Q LOCERR
        S HLOQNAM=Y
        I '$D(^HLB("QUEUE","SEQUENCE",HLOQNAM)) S LOCERR="S"
        Q LOCERR
        ;
ERRRPT  ; Display processing error report (HLOERR)
        ;
        N TYPE,MSGN
        I $D(HLOERR)'=10 Q
        W !!?5,"Errors occured during the deletion of the message on this queue:",!
        S TYPE=""
        F  S TYPE=$O(HLOERR(TYPE)) Q:TYPE=""  D
        .  I TYPE'="PURGE" W ?10,$S(TYPE="PURDAT":"Purge data/time:",TYPE="LINK":"Link name:",TYPE="QUEUE":"Queue name:",TYPE="SEQUENCE":"Queue name: ",1:"")," ",HLOERR(TYPE),!
        .  I TYPE="PURGE" D
        .  .  S MSGN=""
        .  .  F  S MSGN=$O(HLOERR(TYPE,MSGN)) Q:MSGNUM=""  D
        .  .  .  W ?10,TYPE," ",HLOERR(TYPE,MSGN),!
        W !!
        Q
        ;
CLEAR   ; Clear the variables for next call
        ;
        S (ERRTYP,DELMSG,X,Y)=""
        Q
        ;
EXIT    ; Clean up and quit
        I $D(HLOERR)=11 D ERRRPT
        ;
        K HLOLNAM,HLOQNAM,HLOPNAM,HLOPURDT,HLOERR,DIR,DIC,X,Y,%DT,MSGTYP,MSGNUM
        Q
        ;
