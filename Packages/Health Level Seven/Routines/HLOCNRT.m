HLOCNRT ;DAOU/ALA-Generate HL7 Optimized Message ;07/24/2007
        ;;1.6;HEALTH LEVEL SEVEN;**126,132,134,137**;Oct 13, 1995;Build 21
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;**Program Description**
        ;  This program takes a current HL7 1.6 message and converts
        ;  it to use the new HL Optimized code if it follows the standard
        ;  1.6 methodology of protocols.
        ;
        ;  **If the VistA HL7 Protocol does not exist, calls to HL Optimized
        ;  will have to be coded separately and this program cannot be used**
        Q
        ;
EN(HLOPRTCL,ARYTYP,HLP,HLL,RESULT)      ;Entry Point
        ;  Input Parameters
        ;   HLOPRTCL = Protocol IEN or Protocol Name
        ;   ARYTYP = The array where HL7 message resides
        ;   HLP = Additional HL7 message parameters (optional, pass by reference)
        ;        These optional subscripts to HLP are supported for input:
        ;             "APP ACK RESPONSE" = <tag^routine> to call when the app ack is received
        ;             "CONTPTR"
        ;             "SECURITY"
        ;             "SEQUENCE QUEUE" - queue used to maintain the order of the messages via application acks.  If used, the application MUST specify that both an accept ack and application ack be returned.
        ;
        ;   HLL  (optional, pass by reference) Additional message recipients being dynamically added
        ;
        ;  Output
        ;    RESULT (pass-by-reference)=<subscriber protocol ien>^<link ien>^<message id>^<0 if sucess, error code if failure>^<optional error message>
        ;             If the message was sent to more than 1 destination,
        ;             the addtional mssage ids returned as RESULT(1), RESULT(2), etc.
        ;    ZTSTOP = Stop processing flag (used by HDR)
        ;    Function returns 1 on success, else returns an error message
        ;
        NEW HLORESL,HLMSTATE,APPARMS,WHOTO,ERROR,WHO
        S ZTSTOP=0,HLORESL=1,RESULT=""
        ;
        ;  Get IEN of protocol if name is passed
        I '$L(HLOPRTCL) S HLORESL="^99^HL7 1.6 Protocol not found",RESULT="^^"_HLORESL,ZTSTOP=1 Q HLORESL
        I ('HLOPRTCL)!(HLOPRTCL'=+HLOPRTCL) S HLOPRTCL=+$O(^ORD(101,"B",HLOPRTCL,0))
        I 'HLOPRTCL S HLORESL="^99^HL7 1.6 Protocol not found",RESULT="^^"_HLORESL,ZTSTOP=1 Q HLORESL
        I '$D(^ORD(101,HLOPRTCL)) S HLORESL="^99^HL7 1.6 Protocol not found",RESULT="^^"_HLORESL,ZTSTOP=1 Q HLORESL
        ;
        ;  If the VistA HL7 Protocol exists, call the Conversion Utility
        ;  to set up the APPARMS, WHOTO arrays from protocol logical link,
        ;   and the optional HLL and HLP arrays
        D APAR^HLOCVU(HLOPRTCL,.APPARMS,.WHO,.WHOTO,.HLP,.HLL)
        ;
        ; If special HLP parameters are defined, convert them
        I $D(HLP) D
        . I $G(HLP("SECURITY"))'="" S APPARMS("SECURITY")=HLP("SECURITY")
        . I $G(HLP("CONTPTR"))'="" S APPARMS("CONTINUATION POINTER")=HLP("CONTPTR")
        . I $G(HLP("QUEUE"))'="" S APPARMS("QUEUE")=HLP("QUEUE")
        . I $G(HLP("SEQUENCE QUEUE"))'="" S APPARMS("SEQUENCE QUEUE")=HLP("SEQUENCE QUEUE")
        . I $G(HLP("APP ACK RESPONSE"))'="" S APPARMS("APP ACK RESPONSE")=HLP("APP ACK RESPONSE")
        ;
        ;  Create HL Optimized message
        I '$$NEWMSG^HLOAPI(.APPARMS,.HLMSTATE,.ERROR) S HLORESL="^99^"_ERROR,ZTSTOP=1,RESULT="^^"_HLORESL Q HLORESL
        I $E(ARYTYP,1)="G" S HLOMESG="^TMP(""HLS"",$J)"
        I $E(ARYTYP,1)="L" S HLOMESG="HLA(""HLS"")"
        ;
        ;  Move the existing message from array into HL Optimized
        D MOVEMSG^HLOAPI(.HLMSTATE,HLOMESG)
        ;
        ;  Send message via HL Optimized
        I $D(WHOTO) D
        .N COUNT
        .I '$$SENDMANY^HLOAPI1(.HLMSTATE,.APPARMS,.WHOTO) D
        ..S HLORESL="^99^Unable to send message",ZTSTOP=1
        .I $G(WHOTO(1,"IEN")) D
        ..S RESULT=WHO(1)_"^"_$P($G(^HLB(WHOTO(1,"IEN"),0)),"^")_"^"_$S($G(WHOTO(1,"QUEUED")):0,1:1)_"^"_$G(WHOTO(1,"ERROR"))
        .E  D
        ..S RESULT=WH0(1)_"^^1^"_$G(WHOTO(1,"ERROR"))
        ..S HLORESL="^99^"_$G(WHOTO(1,"ERROR")),ZTSTOP=1
        .S COUNT=1
        .F  S COUNT=$O(WHOTO(COUNT)) Q:'COUNT  D
        ..I $G(WHOTO(COUNT,"IEN")) D
        ...S RESULT(COUNT-1)=WHO(COUNT)_"^"_$P($G(^HLB(WHOTO(COUNT,"IEN"),0)),"^")_"^"_$S($G(WHOTO(COUNT,"QUEUED")):0,1:1)_"^"_$G(WHOTO(COUNT,"ERROR"))
        ..E  D
        ...S RESULT(COUNT-1)=WH0(COUNT)_"^^1^"_$G(WHOTO(COUNT,"ERROR"))
        ;
        E  S HLORESL="^99^Unable to send message",ZTSTOP=1,RESULT="^^"_HLORESL
        Q HLORESL
