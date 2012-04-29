PPPMSC1 ;ALB/DMB - MISC PPP UTILITIES ; 2/12/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
LOGEVNT(EVNTCODE,ROUTINE,TEXT) ; Log an event to the log file
 ;
 N DIC,X,Y,PARMERR,FMERR,DTOUT,DUOUT
 ;
 S PARMERR=-9001
 S FMERR=-9002
 ;
 ; Make sure the parameters are valid
 ;
 I '$D(^PPP(1020.6,"B",EVNTCODE)) S EVNTCODE=9999
 I '$D(TEXT) S TEXT=""
 I $D(TEXT),($L(TEXT))>245 Q PARMERR
 I '$D(ROUTINE) S ROUTINE=""
 ;
 ; Update DT so it has the correct date.
 ;
 D NOW^%DTC S DT=X K %,%H,%I,X
 ;
 S DIC="^PPP(1020.4,"
 S X=$O(^PPP(1020.6,"B",EVNTCODE,""))
 S DIC(0)=""
 I $D(TEXT) S DIC("DR")="4///"_ROUTINE_";5///"_TEXT
 K DD,DO ; -- required by FILE^DICN call
 D FILE^DICN
 ;
 I (Y=-1)!($D(DTOUT))!($D(DUOUT)) Q FMERR
 Q 0
 ;
STATUPDT(CODE,INCRMNT) ; Update statistics in stat file.
 ;
 ; This function is used to increment a specific statistic
 ; by the amount passed in INCRMNT.  The statistics are currently
 ; referenced by the FileMan field number.  They are currently
 ; defined as follows:
 ;
 ;   2 - Total PDX's Sent
 ;   3 - Total Alerts Issued
 ;   4 - Total Alerts Ignored
 ;   5 - Total Manual Entries Added
 ;   6 - Total Entries Deleted
 ;   7 - Total Entries Edited
 ;   8 - Total New Patients Added
 ;   9 - Total FMP's Viewed/Printed
 ;
 ; Return Values:
 ;
 ;   0 - Normal Termination
 ;   -9001 - Input Parameter Error
 ;   -9002 - Fileman Error
 ;
 N DA,DIC,DIE,DIDEL,DIQ,DR,ERR,PPPTMP,VAL,PARMERR,FMERR,PPPTMP
 ;
 S PARMERR=-9001
 S FMERR=-9002
 S ERR=0
 ;
 I '$D(CODE)!('$D(INCRMNT)) Q PARMERR
 I CODE<2!(CODE>9) Q PARMERR
 I '$D(INCRMNT) Q PARMERR
 I INCRMNT'>0 Q PARMERR
 ;
 ; Get the current value of the statistic
 ;
 S DIC=1020.3
 S DR=CODE
 S DA=1
 S DIQ="PPPTMP"
 S DIQ(0)="I"
 D EN^DIQ1
 I $D(PPPTMP) D
 .S VAL=PPPTMP(1020.3,DA,CODE,"I")
 .S VAL=VAL+INCRMNT
 .S DIE="^PPP(1020.3,"
 .S DR=CODE_"///"_VAL
 .D ^DIE
 .I $D(DTOUT) S ERR=FMERR
 E  S ERR=FMERR
 Q:ERR ERR
 Q 0
 ;
CLRSTAT ; Set all statistics to 0
 ;
 N DA,DIE,DR,ERR,FMERR
 N DIR,Y
 ;
 S FMERR=-9002
 ;
 I '$D(^PPP(1020.3)) D  Q
 .W !,"Error... PPP STATISTIC file missing"
 S DIR(0)="YA"
 S DIR("A")="Clear entries in PPP STATISTICS file: "
 S DIR("B")="NO"
 S DIR("?")="Enter yes to zero out entries in file."
 D ^DIR
 I Y D CLR1
 E  W !!,"PPP STATISTICS file unchanged"
 ;
 R !,"Press <RETURN> to continue...",PPPX:DTIME K PPPX
 Q
 ;
CLR1 ; -- Clears statistics
 I $D(^PPP(1020.3,1)) D
 .S DIK="^PPP(1020.3,"
 .S DA=1
 .D ^DIK
 ;
 S ERR=0
 S DIC="^PPP(1020.3,"
 S X=1
 S DIC(0)=""
 S DIC("DR")="1///NOW;2///0;3///0;4///0;5///0;6///0;7///0;8///0;9///0"
 K DD,DO ; -- required by FILE^DICN call
 D FILE^DICN
 I +Y=1 W !!,"All Statistics Set To 0."
 E  W !,"Error... Could not create entry in statistics file."
 Q
 ;
SNDBLTN(MSGSUB,MSGFROM,MSGTXT) ; Send a message
 ;
 ; This function will send a message via mailman.
 ;
 ; Parameters:
 ;    MSGSUB - The subject of the message.
 ;    MSGFROM - The sender of the message.  If this field is
 ;               not defined or NULL, the current DUZ is used.
 ;    MSGTXT - The array name which contains the text
 ;              of the message.
 ;
 ; Returns:
 ;    0 - Normal Termination
 ;    -9001 - Input Parameter Error
 ;
 N PARMERR,BULLERR,GRPERR,XMDUZ,XMTEXT,Y,ERR
 ;
 S PARMERR=-9001
 S GRPERR=-9016
 ;
 I '$D(MSGSUB) Q PARMERR
 I MSGSUB="" Q PARMERR
 S XMSUB=MSGSUB
 ;
 I '$D(MSGFROM) S MSGFROM=""
 I MSGFROM="" S XMDUZ=.5
 I MSGFROM'="" S XMDUZ=MSGFROM
 ;
 I $D(MSGTXT) S XMTEXT=MSGTXT
 ;
 S ERR=$$GETMBRS("PRESCRIPTION PRACTICES","XMY")
 I ERR<1 Q GRPERR
 ;
 S XMCHAN=1 ; -- Silents all interactive feed back
 D ^XMD
 D KILL^XM
 K XMCHAN
 Q 0
 ;
GETMBRS(MAILGRP,ARRAY) ; Get the members of a mail group
 ;
 ; Parameters:
 ;    MAILGRP - The name of the group without the 'G.'
 ;    ARRAY - The name of the array where you want the names stored.
 ;
 ; Returns:
 ;    The number of members found or a negative error code.
 ;
 N PARMERR,GRPERR,MGIFN,MEMBER,TMEMBER
 ;
 S PARMERR=-9001
 S GRPERR=-9016
 S TMEMBER=0
 ;
 I '$D(PARMERR) Q PARMERR
 I '$D(ARRAY) Q PARMERR
 I $L(MAILGRP)=""!($L(ARRAY)="") Q PARMERR
 ;
 S MGIFN=$O(^XMB(3.8,"B",MAILGRP,"")) Q:MGIFN="" GRPERR
 ;
 S MEMBER=""
 F I=0:0 D  Q:MEMBER=""
 .S MEMBER=$O(^XMB(3.8,MGIFN,1,"B",MEMBER)) Q:MEMBER=""
 .S @ARRAY@(MEMBER)=""
 .S TMEMBER=TMEMBER+1
 Q TMEMBER
