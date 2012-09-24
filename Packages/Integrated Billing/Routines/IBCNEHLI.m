IBCNEHLI        ;DAOU/ALA - Incoming HL7 messages ;16-JUN-2002
        ;;2.0;INTEGRATED BILLING;**184,252,251,271,300,416**;21-MAR-94;Build 58
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;**Program Description**
        ;  This program parses each incoming HL7 message.
        ;
EN      ;  Starting point - put message into a TMP global
        ;
        N ACK,BUFF,DFN,ERACT,ERCON,ERFLG,ERTXT,EVENT,HCT,HLECH,HLEID
        N HLEIDS,HLFS,HLQ,IBPRTCL,IDUZ,MGRP,MSGID,RDAT0,RIEN,SBDEP,SEG
        N SEGMT,SEGMT2,TAG,TQN,TRACE,VRFDT,DISYS,IPCT,PAYRID,PIEN,CNT
        N ERROR,IRIEN,RSTYPE,SUBID,TQIEN
        N DA,EBDA,IBFDA,II,MSGP,SYMBOL,IBSEG,PP,PRIEN,QFL,IBIEN,TQDATA,IBQFL
        N DATAMFK,EPHARM
        ;
        K ^TMP($J,"IBCNEHLI")
        F SEGCNT=1:1 X HLNEXT Q:HLQUIT'>0  D
        . S CNT=0
        . S ^TMP($J,"IBCNEHLI",SEGCNT,CNT)=HLNODE
        . F  S CNT=$O(HLNODE(CNT)) Q:'CNT  D
        .. S ^TMP($J,"IBCNEHLI",SEGCNT,CNT)=HLNODE(CNT)
        ;
        ;  Get the eIV user
        S IDUZ=$$FIND1^DIC(200,"","X","INTERFACE,IB EIV")
        ;   Determine which protocol to use
        S SEGMT=$G(^TMP($J,"IBCNEHLI",1,0))
        I $E(SEGMT,1,3)'="MSH" D  D ERR Q
        . S MSG(1)="MSH Segment is not the first segment found"
        . S MSG(2)="Please call the Help Desk and report this problem."
        S HLFS=$E(SEGMT,4)
        S EVENT=$P(SEGMT,HLFS,9),IBPRTCL=""
        ;
        ;  The event type determines protocol
        I EVENT="MFN^M01" S TAG="TBL",IBPRTCL="IBCNE IIV MFN IN"
        I EVENT="RPI^I01" S TAG="RSP",IBPRTCL="IBCNE IIV IN" I '$$HL7VAL G XIT
        I EVENT="MFK^M01" S TAG="ACK",IBPRTCL="IBCNE IIV REGISTER"
        I IBPRTCL="" S MSG(1)="Unable to find a protocol for Event = "_EVENT D ERR G XIT
        ; S HLEID=$$HLP^IBCNEHLU(IBPRTCL)
        ;
        ;  Initialize the HL7 variables
        D INIT^HLFNC2(IBPRTCL,.HL)
        ; S HLEIDS=$O(^ORD(101,HLEID,775,"B",0))
        ;
        ;  Call the event tag
        D @TAG
        ;
XIT     K ^TMP($J,"IBCNEHLI"),HL,HLNEXT,HLNODE,HLQUIT,SEGCNT
        Q
        ;
TBL     ;  Table Update Processing
        D ^IBCNEHLT
        ;
        I ERFLG D ERR
        K ERFLG
        ;
        ; Send MFK Message (Application Acknowledgement)?
        I HL("APAT")="AL",$G(EPHARM) D ^IBCNRMFK
        Q
        ;
RSP     ;  Response Processing
        D ^IBCNEHL1
        ;
        K ACK,BUFF,DFN,ERACT,ERCON,ERFLG,ERTXT,EVENT,HCT,HL,HLECH,HLEID
        K HLEIDS,HLFS,HLQ,IBPRTCL,IDUZ,MGRP,MSGID,RDAT0,RIEN,SBDEP,SEG
        K SEGMT,SEGMT2,TAG,TQN,TRACE,VRFDT,DISYS,IPCT,PAYRID,PIEN
        K ERROR,IRIEN,RSTYPE,SUBID,TQIEN
        K DA,EBDA,IBFDA,II,MSGP,SYMBOL,IBSEG,PP,PRIEN,QFL
        Q
        ;
ACK     ;  Acknowledgement Processing
        D ^IBCNEHLK
        ;
        Q
        ;
ERR     ; Process an error
        S MGRP=$$MGRP^IBCNEUT5()
        D MSG^IBCNEUT5(MGRP,"INCOMING eIV HL7 PROBLEM","MSG(")
        K MSG,MGRP
        Q
        ; 
HL7VAL()        ; Check for valid post 300 response
        N X,HCT
        S X=0,HCT=0
        F  S HCT=$O(^TMP($J,"IBCNEHLI",HCT)) Q:HCT=""  D SPAR^IBCNEHLU I $G(IBSEG(1))="PRD" S X=1 Q
        Q X
