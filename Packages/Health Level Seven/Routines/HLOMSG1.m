HLOMSG1 ;ALB/CJM-HL7 - APIs for files 777/778 (CONTINUED) ;02/04/2004
 ;;1.6;HEALTH LEVEL SEVEN;**126**;Oct 13, 1995
 ;
FINDMSG(MSGID,LIST) ;
 ;Given a message id, this function finds the file 778 entries having that message id.  The count is returned as the function value. If the message
 ;is within a batch, it might be in the subfile.  The list of found
 ;records is in the format LIST(1)=<IEN>^<SUBIEN>,LIST(2)=<IEN>^<SUBIEN>,
 ;etc., where SUBIEN="" if the message is not within a batch.
 ;
 N COUNT,MSG
 K LIST
 Q:$G(MSGID)="" 0
 S (MSG,COUNT)=0
 F  S MSG=$O(^HLB("B",MSGID,MSG)) Q:'MSG  S COUNT=COUNT+1,LIST(COUNT)=MSG
 S MSG=""
 F  S MSG=$O(^HLB("AE",MSGID,MSG)) Q:MSG=""  S COUNT=COUNT+1,LIST(COUNT)=MSG
 Q COUNT
 ;
ACKTOIEN(MSGID,ACKTO) ;
 ;finds the ien of the initial message
 ;Input:
 ;  MSGID - the msg id of the ack message
 ;  ACKTO - msgid of the original message
 ;Output: Function returns "" if not found, otherwise the IEN, or, if the message is in a batch, the <ien>^<subien>
 ;
 N LIST,RETURN
 S RETURN=""
 I $$FINDMSG(ACKTO,.LIST) D
 .N COUNT
 .S COUNT=0
 .F  S COUNT=$O(LIST(COUNT)) Q:'COUNT  D  Q:RETURN
 ..N IEN,SUBIEN
 ..S IEN=$P(LIST(COUNT),"^"),SUBIEN=$P(LIST(COUNT),"^",2)
 ..I 'SUBIEN D
 ...I $P($G(^HLB(IEN,0)),"^",7)=MSGID S RETURN=IEN
 ..E  D
 ...I $P($G(^HLB(IEN,3,SUBIEN,0)),"^",4)=MSGID S RETURN=IEN_"^"_SUBIEN
 Q RETURN
 ;
 ;
ACKBYIEN(MSGID,ACKBY) ;
 ;finds the ien of the ack message
 ;Input:
 ;  MSGID - the msg id of the initial message
 ;  ACKBY - msgid of the ack message
 ;Output: Function returns "" if not found, otherwise the IEN, or, if the message is in a batch, the <ien>^<subien>
 ;
 N LIST,RETURN
 S RETURN=""
 I $$FINDMSG(ACKBY,.LIST) D
 .N COUNT
 .S COUNT=0
 .F  S COUNT=$O(LIST(COUNT)) Q:'COUNT  D  Q:RETURN
 ..N IEN,SUBIEN
 ..S IEN=$P(LIST(COUNT),"^"),SUBIEN=$P(LIST(COUNT),"^",2)
 ..I 'SUBIEN D
 ...I $P($G(^HLB(IEN,0)),"^",3)=MSGID S RETURN=IEN
 ..E  D
 ...I $P($G(^HLB(IEN,3,SUBIEN,0)),"^",3)=MSGID S RETURN=IEN_"^"_SUBIEN
 Q RETURN
 ;
GETMSGB(MSG,SUBIEN,SUBMSG) ;
 ;gets a message from within a batch
 ;Input:
 ;  MSG (required, pass by reference) from $$GETMSG
 ;  SUBIEN - the subrecord #
 ;Output:
 ;  SUBMSG (pass by reference)  These subscripts are returned:
 ;    "ACK BY" - if this msg was app acked, the msg id if this msg that was app
 ;    "ACK TO" - if this msg is an app ack, the msg id of msg being acked
 ;    "EVENT" - HL7 Event
 ;    "HDR",1) - fields 1-6 of the header segment
 ;    "HDR",2) - fields 7-End of the header segment
 ;    "ID" - Message Control ID
 ;    "MESSAGE TYPE" - HL7 Message Type
 ;    "STATUS" - completion status for the individual message
 ;
 N NODE
 S NODE=$G(^HLB(MSG("IEN"),3,SUBIEN,0))
 S SUBMSG("ID")=$P(NODE,"^",2)
 S SUBMSG("ACK TO")=$P(NODE,"^",3)
 S SUBMSG("ACK BY")=$P(NODE,"^",4)
 S SUBMSG("STATUS")=$P(NODE,"^",5)
 S SUBMSG("HDR",1)=$G(^HLB(MSG("IEN"),3,SUBIEN,1)),SUBMSG("HDR",2)=$G(^(2))
 S NODE=$G(^HLA(MSG("BODY"),2,SUBIEN,0))
 S SUBMSG("MESSAGE TYPE")=$P(NODE,"^",2)
 S SUBMSG("EVENT")=$P(NODE,"^",3)
 Q
