HLOTCP  ;ALB/CJM- TCP/IP I/O - 10/4/94 1pm ;08/18/2008
        ;;1.6;HEALTH LEVEL SEVEN;**126,131,134,137,138**;Oct 13, 1995;Build 34
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
OPEN(HLCSTATE,LOGICAL)  ;
        ;This may be called either in the context of a client or a server.
        ;For the server, there are 3 situations:
        ; 1) The server is not concurrent.  In this case the TCP device should be opened.
        ; 2) The server is concurrent, but this process was spawned by the OS
        ;    (via a VMS TCP Service)  In this case, the device should be opened
        ;    via the LOGICAL that was passed in.
        ;  3) The server is concurrent, but this process was spawned by the
        ;     TaskMan multi-listener.  In this case TaskMan already opened the
        ;     device.  This case can be determined by the absence of the LOGICAL
        ;     input parameter.
        ;
        N IP,PORT,DNSFLAG
        ;
        S DNSFLAG=0 ;DNS has not been contacted for IP
        ;
        S:'$G(HLCSTATE("SERVER")) IP=HLCSTATE("LINK","IP")
        S PORT=HLCSTATE("LINK","PORT")
        S HLCSTATE("CONNECTED")=0
        S HLCSTATE("READ HEADER")="READHDR^HLOTCP"
        S HLCSTATE("WRITE HEADER")="WRITEHDR^HLOTCP"
        S HLCSTATE("READ SEGMENT")="READSEG^HLOTCP"
        S HLCSTATE("WRITE SEGMENT")="WRITESEG^HLOTCP"
        S HLCSTATE("END MESSAGE")="ENDMSG^HLOTCP"
        S HLCSTATE("CLOSE")="CLOSE^HLOTCP"
        S HLCSTATE("TCP BUFFER")=""
        S HLCSTATE("TCP BUFFER $X")=0
        ;
        ;spawned by TaskMan multi-listener? If so, the device has already been opened
        I $G(HLCSTATE("SERVER")),$G(HLCSTATE("LINK","SERVER"))="1^M",$G(LOGICAL)="" D  Q
        .S HLCSTATE("DEVICE")=IO(0),HLCSTATE("FLUSH")="!",HLCSTATE("TCP BUFFER SIZE")=512
        .S HLCSTATE("CONNECTED")=1
        ;
        ;if no IP, not a server, give DNS a shot
        I '$G(HLCSTATE("SERVER")),IP="" S DNSFLAG=1,IP=$$DNS(HLCSTATE("LINK","DOMAIN")),HLCSTATE("LINK","IP")=IP Q:IP=""
        ;
RETRY   ;
        ;
        I HLCSTATE("SYSTEM","OS")="DSM" D
        .S HLCSTATE("TCP BUFFER SIZE")=512
        .I $G(LOGICAL)]"" S HLCSTATE("DEVICE")=LOGICAL
        .E  S HLCSTATE("DEVICE")=PORT
        .S HLCSTATE("FLUSH")="!"
        .I $G(HLCSTATE("SERVER")) D
        ..O:$G(LOGICAL)]"" HLCSTATE("DEVICE"):(TCPDEV,BLOCKSIZE=512):HLCSTATE("OPEN TIMEOUT")
        ..O:$G(LOGICAL)="" HLCSTATE("DEVICE"):(TCPCHAN,BLOCKSIZE=512):HLCSTATE("OPEN TIMEOUT")
        ..I $T D
        ...S HLCSTATE("CONNECTED")=1
        ...U HLCSTATE("DEVICE"):NOECHO
        .E  D  ;client
        ..O HLCSTATE("DEVICE"):(TCPCHAN,ADDRESS=IP,BLOCKSIZE=512):HLCSTATE("OPEN TIMEOUT")
        ..I $T D
        ...S HLCSTATE("CONNECTED")=1
        ...U HLCSTATE("DEVICE"):NOECHO
        E  I HLCSTATE("SYSTEM","OS")="CACHE" D
        .S HLCSTATE("FLUSH")="!"
        .I $G(LOGICAL)]"" S HLCSTATE("DEVICE")=LOGICAL
        .E  S HLCSTATE("DEVICE")="|TCP|"_PORT
        .S HLCSTATE("TCP BUFFER SIZE")=512
        .I $G(HLCSTATE("SERVER")) D
        ..I HLCSTATE("SERVER")="1^S" D  Q
        ...;single server (no concurrent connections)
        ...O HLCSTATE("DEVICE"):(:PORT:"+A-S":::):HLCSTATE("OPEN TIMEOUT")
        ...I $T D
        ....N A
        ....S HLCSTATE("CONNECTED")=1
        ....U HLCSTATE("DEVICE")
        ....F  R *A:HLCSTATE("READ TIMEOUT") Q:$T  I $$CHKSTOP^HLOPROC S HLCSTATE("CONNECTED")=0 D CLOSE(.HLCSTATE) Q
        ..;
        ..;multi-server spawned by OS - VMS TCP Services
        ..O HLCSTATE("DEVICE")::HLCSTATE("OPEN TIMEOUT") I '$T S HLCSTATE("CONNECTED")=0 Q
        ..S HLCSTATE("CONNECTED")=1
        ..U HLCSTATE("DEVICE"):(::"-S")
        ..;
        .E  D  ;client
        ..S HLCSTATE("TCP BUFFER SIZE")=512
        ..O HLCSTATE("DEVICE"):(IP:PORT:"-S":::):HLCSTATE("OPEN TIMEOUT")
        ..I $T D
        ...S HLCSTATE("CONNECTED")=1
        E  D  ;any other system but Cache or DSM
        .S HLCSTATE("TCP BUFFER SIZE")=256
        .D CALL^%ZISTCP(IP,PORT,HLCSTATE("OPEN TIMEOUT"))
        .S HLCSTATE("CONNECTED")='POP
        .I HLCSTATE("CONNECTED") S HLCSTATE("DEVICE")=IO
        ;
        ;if not connected, not the server, give DNS a shot if not tried already
        I '$G(HLCSTATE("SERVER")),'HLCSTATE("CONNECTED"),'DNSFLAG S DNSFLAG=1,IP=$$DNS(HLCSTATE("LINK","DOMAIN")) I IP]"",IP'=HLCSTATE("LINK","IP") S HLCSTATE("LINK","IP")=IP Q:IP=""  G RETRY
        ;
        I HLCSTATE("CONNECTED"),DNSFLAG S $P(^HLCS(870,HLCSTATE("LINK","IEN"),400),"^")=IP
        Q
        ;
DNS(DOMAIN)     ;
        Q $P($$ADDRESS^XLFNSLK(DOMAIN),",")
        ;
WRITEHDR(HLCSTATE,HDR)  ;
        ;
        ;insure that package buffer is empty
        K HLCSTATE("BUFFER")
        S HLCSTATE("BUFFER","BYTE COUNT")=0
        S HLCSTATE("BUFFER","SEGMENT COUNT")=0
        ;
        ;Start the message with <SB>, then write the header
        N SEG
        S SEG(1)=$C(11)_HDR(1)
        S SEG(2)=HDR(2)
        Q $$WRITESEG(.HLCSTATE,.SEG)
        ;
WRITESEG(HLCSTATE,SEG)  ;
        N I,LAST
        S HLCSTATE("BUFFER","SEGMENT COUNT")=HLCSTATE("BUFFER","SEGMENT COUNT")+1
        S I=0,LAST=$O(SEG(99999),-1)
        F  S I=$O(SEG(I)) Q:'I  D
        .I HLCSTATE("BUFFER","BYTE COUNT")>HLCSTATE("SYSTEM","BUFFER") D FLUSH
        .I I=LAST S SEG(I)=SEG(I)_$C(13)
        .S HLCSTATE("BUFFER",HLCSTATE("BUFFER","SEGMENT COUNT"),I)=SEG(I),HLCSTATE("BUFFER","BYTE COUNT")=HLCSTATE("BUFFER","BYTE COUNT")+$L(SEG(I))+20
        Q HLCSTATE("CONNECTED")
        ;
FLUSH   ;flushes the HL7 package buffer, and the system TCP buffer when full
        N SEGMENT,MAX
        S SEGMENT=0
        ;
        S MAX=HLCSTATE("TCP BUFFER SIZE")-2
        ;
        U HLCSTATE("DEVICE") I (HLCSTATE("SYSTEM","OS")="CACHE") S HLCSTATE("CONNECTED")=($ZA\8192#2) I 'HLCSTATE("CONNECTED") D CLOSE(.HLCSTATE)
        F  S SEGMENT=$O(HLCSTATE("BUFFER",SEGMENT)) Q:'SEGMENT  D
        .N I S I=0
        .F  S I=$O(HLCSTATE("BUFFER",SEGMENT,I)) Q:'I  D
        ..N LINE
        ..S LINE=HLCSTATE("BUFFER",SEGMENT,I)
        ..;put the line in the TCP buffer, or as much as will fit - flush the buffer when it gets full
        ..F  Q:LINE=""  D
        ...N INC
        ...;INC is how much space is left in the buffer
        ...S INC=MAX-HLCSTATE("TCP BUFFER $X")
        ...I '($L(LINE)>INC) D
        ....S HLCSTATE("TCP BUFFER")=HLCSTATE("TCP BUFFER")_LINE
        ....S HLCSTATE("TCP BUFFER $X")=HLCSTATE("TCP BUFFER $X")+$L(LINE)
        ....S LINE=""
        ...E  D
        ....S HLCSTATE("TCP BUFFER")=HLCSTATE("TCP BUFFER")_$E(LINE,1,INC)
        ....S HLCSTATE("TCP BUFFER $X")=MAX
        ....S LINE=$E(LINE,INC+1,99999)
        ...I HLCSTATE("TCP BUFFER $X")=MAX D
        ....W HLCSTATE("TCP BUFFER"),@HLCSTATE("FLUSH")
        ....S HLCSTATE("TCP BUFFER")="",HLCSTATE("TCP BUFFER $X")=0
        K HLCSTATE("BUFFER")
        S HLCSTATE("BUFFER","SEGMENT COUNT")=1
        S HLCSTATE("BUFFER","BYTE COUNT")=0
        Q
        ;
READSEG(HLCSTATE,SEG)   ;
        ;
        ;Output:
        ;  SEG - returns the segment (pass by reference)
        ;  Function returns 1 on success, 0 on failure
        ;
        N SUCCESS,COUNT,BUF
        S (COUNT,SUCCESS)=0
        K SEG
        ;
        ;anything left from last read?
        S BUF=HLCSTATE("READ")
        S HLCSTATE("READ")=""
        I BUF]"" D  ;something was left!
        .S COUNT=1
        .I BUF[$C(13) D  Q
        ..S SEG(1)=$P(BUF,$C(13)),BUF=$P(BUF,$C(13),2,999999)
        ..S SUCCESS=1
        .S SEG(1)=BUF,BUF=""
        I 'SUCCESS U HLCSTATE("DEVICE") F  R BUF:HLCSTATE("READ TIMEOUT") Q:'$T  D  Q:SUCCESS
        .I BUF[$C(13) S SUCCESS=1,COUNT=COUNT+1,SEG(COUNT)=$P(BUF,$C(13)),BUF=$P(BUF,$C(13),2,999999) Q
        .S COUNT=COUNT+1,SEG(COUNT)=BUF
        ;
        I SUCCESS D
        .S HLCSTATE("READ")=BUF ;save the leftover
        .I COUNT>1,SEG(COUNT)="" K SEG(COUNT) S COUNT=COUNT-1
        ;Cache can return the connection status
        E  I (HLCSTATE("SYSTEM","OS")="CACHE") S HLCSTATE("CONNECTED")=($ZA\8192#2) I 'HLCSTATE("CONNECTED") D CLOSE(.HLCSTATE)
        ;
        ;if the <EB> character was encountered, then there are no more segments in the message, set the end of message flag
        I SUCCESS,SEG(COUNT)[$C(28) D
        .K SEG
        .S SUCCESS=0
        .S HLCSTATE("MESSAGE ENDED")=1
        Q SUCCESS
        ;
READHDR(HLCSTATE,HDR)   ;
        ;reads the next header segment in the message stream, discarding everything that comes before it
        ;
        N SEG,SUCCESS,J,I
        S SUCCESS=0
        K HDR
        F  Q:'$$READSEG(.HLCSTATE,.SEG)  D  Q:SUCCESS
        .S I=0
        .;look for the <SB>
        .;perhaps the <SB> isn't in the first line
        .F  S I=$O(SEG(I)) Q:'I  D  Q:SUCCESS
        ..I (SEG(I)'[$C(11)) K SEG(I) Q
        ..S SEG(I)=$P(SEG(I),$C(11),2)
        ..S SUCCESS=1
        ..K:SEG(I)="" SEG(I)
        I SUCCESS S (I,J)=0 F  S J=$O(SEG(J)) Q:'J  S I=I+1,HDR(I)=SEG(J)
        Q SUCCESS
        ;
CLOSE(HLCSTATE) ;
        CLOSE HLCSTATE("DEVICE")
        Q
        ;
ENDMSG(HLCSTATE)               ;
        N SEG
        S SEG(1)=$C(28)
        I $$WRITESEG(.HLCSTATE,.SEG) D  Q 1
        .D FLUSH
        .I HLCSTATE("TCP BUFFER $X") D
        ..U HLCSTATE("DEVICE")
        ..W HLCSTATE("TCP BUFFER"),@HLCSTATE("FLUSH")
        ..S HLCSTATE("TCP BUFFER")=""
        ..S HLCSTATE("TCP BUFFER $X")=0
        Q 0
