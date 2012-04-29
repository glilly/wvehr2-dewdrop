HLOCLNT3        ;ALB/CJM- Updates messages missing application acks - 10/4/94 1pm ;07/10/2007
        ;;1.6;HEALTH LEVEL SEVEN;**126,130,134,137**;Oct 13, 1995;Build 21
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
DOWORK(WORK)    ;
        ;
        N CUTOFF,MSGIEN,QUIT,NOW,SYSTEM
        S NOW=$$NOW^XLFDT
        S QUIT=0
        D SYSPARMS^HLOSITE(.SYSTEM)
        S PURGE=$$FMADD^XLFDT($$NOW^XLFDT,,24*SYSTEM("ERROR PURGE"))
        ;
        ;7 day wait for an application ack is more than reasonable
        S CUTOFF=$$FMADD^XLFDT(NOW,-3)
        ;
        S MSGIEN=+$G(^HLTMP("LAST IEN CHECKED FOR MISSING APPLICATION ACK"))
        F  S MSGIEN=$O(^HLB(MSGIEN)) Q:'MSGIEN  Q:MSGIEN>99999999999  D  Q:QUIT
        .N MSG,HDR
        .Q:'$$GETMSG^HLOMSG(MSGIEN,.MSG)
        .Q:'MSG("DT/TM")
        .Q:'MSG("BODY")
        .I MSG("DT/TM")>CUTOFF S:MSG("DT/TM CREATED")>CUTOFF QUIT=1,MSGIEN=MSGIEN-1 Q
        .Q:MSG("STATUS")'=""
        .Q:MSG("DIRECTION")'="OUT"
        .Q:MSG("BATCH")
        .Q:MSG("STATUS","APP ACK'D")
        .;Q:MSG("STATUS","APP ACK RESPONSE")=""
        .;message has been in a non-complete status for a longtime, pending an application ack - set status to error and schedule for purging
        .S $P(^HLB(MSGIEN,0),"^",9)=PURGE
        .S ^HLB("AD","OUT",PURGE,MSGIEN)=""
        .S $P(^HLB(MSGIEN,0),"^",20)="ER"
        .S $P(^HLB(MSGIEN,0),"^",21)="MISSING APPLICATION ACKNOWLEDGMENT"
        .M HDR=MSG("HDR")
        .Q:'$$PARSEHDR^HLOPRS(.HDR)
        .S ^HLB("ERRORS",$S($L(HDR("RECEIVING APPLICATION")):HDR("RECEIVING APPLICATION"),1:"UNKNOWN"),NOW,MSGIEN)=""
        .D COUNT^HLOESTAT("OUT",HDR("RECEIVING APPLICATION"),HDR("SENDING APPLICATION"),$S(MSG("BATCH"):"BATCH",1:$G(HDR("MESSAGE TYPE"))),$G(HDR("EVENT")))
        S:MSGIEN>99999999999 MSGIEN=0
        S ^HLTMP("LAST IEN CHECKED FOR MISSING APPLICATION ACK")=MSGIEN
        Q
