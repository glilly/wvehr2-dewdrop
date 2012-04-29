HLOPURGE        ;IRMFO-ALB/CJM - Purging Old Messages;03/24/2004  14:43 ;07/25/2007
        ;;1.6;HEALTH LEVEL SEVEN;**126,134,136,137**;Oct 13, 1995;Build 21
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
GETWORK(WORK)   ;
        ;
        N OK
        S OK=0
        I $G(WORK)]"" L -HLPURGE(WORK)
        F WORK="IN","OUT","OLD778","OLD777" I '$G(WORK("DONE",WORK)) S WORK("DONE",WORK)=1 L +HLPURGE(WORK):0 S OK=$T Q:OK
        I 'OK K WORK("DONE") S WORK=""
        Q OK
        ;
DOWORK(WORK)    ;
        I WORK="OLD778" D OLD778
        I WORK="OLD777" D OLD777
        I (WORK="IN")!(WORK="OUT") D
        .N TIME,NOW
        .S NOW=$$NOW^XLFDT
        .S TIME=0
        .F  S TIME=$O(^HLB("AD",WORK,TIME)) Q:TIME=""  Q:TIME>NOW  D
        ..N MSGIEN
        ..S MSGIEN=0
        ..F  S MSGIEN=$O(^HLB("AD",WORK,TIME,MSGIEN)) Q:'MSGIEN  D
        ...K ^HLB("AD",WORK,TIME,MSGIEN)
        ...D DELETE(MSGIEN)
        L -HLPURGE(WORK)
        Q
OLD778  ;
        N OLD,START,END,APP,TYPE,TODAY,PARMS
        S TODAY=$$DT^XLFDT
        S OLD=$$FMADD^XLFDT(TODAY,-45)
        F START=0,100000000000,200000000000,300000000000 D
        .S END=(START+100000000000)-1
        .N MSGIEN,QUIT
        .S QUIT=0
        .S MSGIEN=START
        .F  S MSGIEN=$O(^HLB(MSGIEN)) Q:'MSGIEN  Q:(MSGIEN>END)  D  Q:QUIT
        ..N WHEN,BODY,NODE
        ..S NODE=$G(^HLB(MSGIEN,0))
        ..S WHEN=$P(NODE,"^",16)
        ..I WHEN,WHEN<OLD,$P(NODE,"^",9)<TODAY D DELETE(MSGIEN) Q
        ..I 'WHEN D
        ...S BODY=$P(NODE,"^",2)
        ...Q:'BODY
        ...S WHEN=+$G(^HLA(BODY,0))
        ...I WHEN,WHEN<OLD D  Q
        ....;I've seen messages sitting on outgoing queues forever, but it should never happen for incoming
        ....I $E($P(NODE,"^",4))="O",$P(NODE,"^",5)]"",$P(NODE,"^",6)]"" D
        .....N FROM
        .....S FROM=$P(NODE,"^",5)
        .....I $P(NODE,"^",8) S FROM=FROM_":"_$P(NODE,"^",8)
        .....Q:'$D(^HLB("QUEUE","OUT",FROM,$P(NODE,"^",6),MSGIEN))
        .....D DEQUE^HLOQUE(FROM,$P(NODE,"^",6),"OUT",MSGIEN)
        ....D DELETE(MSGIEN) Q
        ...;stop looking for old records?
        ...I WHEN,WHEN>OLD S QUIT=1
        ;
        ;also kill old errors left lying around
        D SYSPARMS^HLOSITE(.PARMS)
        S OLD=$$FMADD^XLFDT($$DT^XLFDT,-PARMS("ERROR PURGE"))
        S APP=""
        F  S APP=$O(^HLB("ERRORS",APP)) Q:APP=""  D
        .N TIME
        .S TIME=0
        .F  S TIME=$O(^HLB("ERRORS",APP,TIME)) Q:'TIME  Q:TIME>OLD  K ^HLB("ERRORS",APP,TIME)
        Q
OLD777  ;
        N OLD,TIME,TODAY
        S TODAY=$$DT^XLFDT
        S OLD=$$FMADD^XLFDT(TODAY,-45)
        S TIME=0
        F  S TIME=$O(^HLA("B",TIME)) Q:'TIME  Q:TIME>OLD  D
        .N MSGIEN
        .S MSGIEN=0
        .F  S MSGIEN=$O(^HLA("B",TIME,MSGIEN)) Q:'MSGIEN  D
        ..N IEN778,STOP
        ..S (STOP,IEN778)=0
        ..F  S IEN778=$O(^HLB("C",MSGIEN,IEN778)) Q:'IEN778  D
        ...I $P($G(^HLB(IEN778,0)),"^",9)>TODAY S STOP=1 Q
        ...D DELETE(IEN778,1)
        ..K:'STOP ^HLB("C",MSGIEN),^HLA("B",TIME,MSGIEN),^HLA(MSGIEN)
        Q
        ;
DELETE(MSGIEN,FLAG)     ;
        ;Input:
        ;  MSGIEN - IEN, file 778
        ;  FLAG - if $G(FLAG), will not delete the pointed to record in file 777
        N AC,SUBIEN,RAPP,SAPP,FS,CS,MSG
        I '$$GETMSG^HLOMSG(MSGIEN,.MSG) ;MSG is corrupted, but there sill may be nodes to delete
        S (RAPP,SAPP)=""
        D
        .S FS=$E(MSG("HDR",1),4)
        .Q:FS=""
        .S CS=$E(MSG("HDR",1),5)
        .S SAPP=$P($P(MSG("HDR",1),FS,3),CS)
        .I SAPP="" S SAPP="UNKNOWN"
        .S RAPP=$P($P(MSG("HDR",1),FS,5),CS)
        .I RAPP="" S RAPP="UNKNOWN"
        ;
        I 'MSG("BATCH") D KSEARCH(.MSG,MSG("MESSAGE TYPE"),MSG("EVENT"),SAPP,RAPP,MSGIEN)
        ;if an error status,take care of the "ERRORS" x-ref
        I MSG("STATUS")'="",MSG("STATUS")'="SU",MSG("BODY") D
        .K ^HLB("ERRORS",RAPP,MSG("DT/TM CREATED"),MSGIEN)
        .I MSG("STATUS")="ER" D
        ..N SUB
        ..S SUB=MSGIEN_"^"
        ..K ^HLB("ERRORS",RAPP,MSG("DT/TM CREATED"),SUB)
        ..F  S SUB=$O(^HLB("ERRORS",RAPP,MSG("DT/TM CREATED"),SUB)) Q:SUB=""  Q:+SUB'=MSGIEN  K ^HLB("ERRORS",RAPP,MSG("DT/TM CREATED"),SUB)
        ;
        ;kill the whole-file xrefs for the message ien within a batch
        S SUBIEN=0
        F  S SUBIEN=$O(^HLB(MSGIEN,3,SUBIEN)) Q:'SUBIEN  D
        .N MSGID
        .I FS]"" D
        ..N VALUE,HDR2,MSGTYPE,EVENT
        ..S HDR2=$G(^HLB(MSGIEN,3,SUBIEN,2))
        ..S VALUE=$P(HDR2,FS,4)
        ..S MSGTYPE=$P(VALUE,CS)
        ..S EVENT=$P(VALUE,CS,2)
        ..D KSEARCH(.MSG,MSGTYPE,EVENT,SAPP,RAPP,MSGIEN_"^"_SUBIEN)
        .S MSGID=$P($G(^HLB(MSGIEN,3,SUBIEN,0)),"^",2)
        .I MSGID]"" K ^HLB("AE",MSGID,MSGIEN_"^"_SUBIEN)
        ;
        I MSG("DIRECTION")="IN" D
        .Q:FS=""
        .N VALUE,HDR
        .S HDR("SENDING APPLICATION")=$P(MSG("HDR",1),FS,3)
        .S VALUE=$P(MSG("HDR",1),FS,4)
        .S HDR("SENDING FACILITY",1)=$P(VALUE,CS)
        .S HDR("SENDING FACILITY",2)=$P(VALUE,CS,2)
        .S HDR("SENDING FACILITY",3)=$P(VALUE,CS,3)
        .S AC=$S(HDR("SENDING FACILITY",2)]"":HDR("SENDING FACILITY",2),1:HDR("SENDING FACILITY",1))_HDR("SENDING APPLICATION")_MSG("ID")
        K ^HLB(MSGIEN)
        I MSG("STATUS","PURGE"),MSG("DIRECTION")'="" K ^HLB("AD",MSG("DIRECTION"),MSG("STATUS","PURGE"),MSGIEN)
        K:(MSG("ID")]"") ^HLB("B",MSG("ID"),MSGIEN)
        I MSG("DIRECTION")="IN" D
        .K:($G(AC)]"") ^HLB("AC",AC,MSGIEN)
        .I MSG("BODY"),'$G(FLAG) D KILL777(MSG("BODY"))
        I MSG("DIRECTION")="OUT" D
        .K ^HLB("C",+MSG("BODY"),MSGIEN)
        .I '$G(FLAG),'$O(^HLB("C",+MSG("BODY"),0)) D KILL777(MSG("BODY"))
        Q
        ;
KILL777(BODY)   ;
        Q:'$G(BODY)
        N TIME
        S TIME=$P($G(^HLA(BODY,0)),"^")
        K ^HLA(BODY)
        K:(TIME]"") ^HLA("B",TIME,BODY)
        Q
        ;
KSEARCH(MSG,MSGTYPE,EVENT,SAPP,RAPP,IEN)        ;
        ;Kills the ^HLB("SEARCH") x-ref
        ;
        N APP
        S:MSGTYPE="" MSGTYPE="<none>"
        S:EVENT="" EVENT="<none>"
        Q:'MSG("DT/TM CREATED")
        I MSG("DIRECTION")'="IN",MSG("DIRECTION")'="OUT" Q
        S APP=$S(MSG("DIRECTION")="IN":RAPP,1:SAPP)
        Q:APP=""
        K ^HLB("SEARCH",MSG("DIRECTION"),MSG("DT/TM CREATED"),APP,MSGTYPE,EVENT,IEN)
        Q
