HLOSRVR2        ;ALB/CJM-HL7 - HLO Server ;07/17/2009
        ;;1.6;HEALTH LEVEL SEVEN;**131,137,138,146**;Oct 13, 1995;Build 16
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
NEWMSG(HLCSTATE,HLMSTATE,HDR)   ;
        ;initialize the HLMSTATE array after reading the header
        ;Inputs:
        ;  HLCSTATE (pass by reference)
        ;  HDR (pass by reference) parsed header
        ;Output:
        ;  HLMSTATE (pass by reference)
        ;
        K HLMSTATE
        S HLMSTATE("IEN")=""
        S HLMSTATE("BODY")=""
        S HLMSTATE("DIRECTION")="IN"
        S HLMSTATE("CURRENT SEGMENT")=0 ;no segments in cache
        S HLMSTATE("UNSTORED LINES")=1 ;just the header in cache so far
        S HLMSTATE("LINE COUNT")=0 ;no lines within message stored to disk
        I HDR("SEGMENT TYPE")="BHS" D
        .S HLMSTATE("BATCH")=1
        .S HLMSTATE("ID")=HDR("BATCH CONTROL ID")
        .S HLMSTATE("BATCH","CURRENT MESSAGE")=0 ;no messages in batch
        .S HLMSTATE("UNSTORED MSH")=0
        E  D
        .S HLMSTATE("BATCH")=0
        .S HLMSTATE("ID")=HDR("MESSAGE CONTROL ID")
        M HLMSTATE("HDR")=HDR
        M HLMSTATE("SYSTEM")=HLCSTATE("SYSTEM")
        S HLMSTATE("STATUS")=""
        S HLMSTATE("STATUS","QUEUE")=""
        S HLMSTATE("STATUS","ACTION")=""
        S HLMSTATE("STATUS","LINK NAME")=HLCSTATE("LINK","NAME")
        S HLMSTATE("STATUS","PORT")=$P(HDR("SENDING FACILITY",2),":",2)
        ;
        ;if this is a batch, and it references another batch, assume it is a batch of app acks
        ;** START 138 CJM
        ;I HLMSTATE("BATCH"),HLMSTATE("ID")]"" D
        I HLMSTATE("BATCH"),HLMSTATE("HDR","REFERENCE BATCH CONTROL ID")]"" D
        .N IEN
        .;S HLMSTATE("ACK TO")=HLMSTATE("ID")
        .S HLMSTATE("ACK TO")=HLMSTATE("HDR","REFERENCE BATCH CONTROL ID")
        .S HLMSTATE("ACK TO","STATUS")="SU"
        .;S IEN=$O(^HLB("B",HLMSTATE("ID"),0))
        .S IEN=$O(^HLB("B",HLMSTATE("HDR","REFERENCE BATCH CONTROL ID"),0))
        .;** END 138 CJM
        .I IEN S HLMSTATE("ACK TO","IEN")=IEN_"^"
        E  S HLMSTATE("ACK TO")=""
        I 'HLMSTATE("BATCH"),HDR("ACCEPT ACK TYPE")="",HDR("APP ACK TYPE")="" D
        .S HLMSTATE("ORIGINAL MODE")=1
        E  D
        .S HLMSTATE("ORIGINAL MODE")=0
        N I F I=1,3 S HLMSTATE("MSA",I)=""
        S HLMSTATE("MSA",2)=HLMSTATE("ID")
        Q
