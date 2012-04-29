HLOUSR1 ;ALB/CJM/OAK/PIJ -ListManager Screen for viewing messages;12 JUN 1997 10:00 am ;08/11/2008
        ;;1.6;HEALTH LEVEL SEVEN;**126,134,137,138**;Oct 13, 1995;Build 34
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
EN      ;
        N MSGIEN,SEGS
        S MSGIEN=$$PICKMSG
        I 'MSGIEN S VALMBCK="R" Q
        D EN^VALM("HLO SINGLE MESSAGE DISPLAY")
        Q
        ;
HDR     ;
        ;
        Q
        ;
BLANK   ;
        S VALMCNT=0
        D EXIT
        Q
DISPLAY ;
        K @VALMAR
        S VALMBCK="R"
        N MSG
        S VALMBG=1
        Q:'MSGIEN
        D SHOWMSG($P(MSGIEN,"^"),$P(MSGIEN,"^",2))
        Q
        ;
PICKMSG(DEFAULT)        ;
        ;ask the user to select a message & return its ien
        ;Input: DEFAULT (optional) message id to display to user as default
        N MSGIEN,DIR,COUNT,LIST
        D FULL^VALM1
        S DIR(0)="F3:30"
        S DIR("A")="Message ID"
        S:$L($G(DEFAULT)) DIR("B")=DEFAULT
        S DIR("?")="Enter the full Message Control ID or Batch Control ID of the message, or '^' to exit."
PICK    D ^DIR
        I $D(DIRUT)!(Y="") Q 0
        I $G(@VALMAR@("INDEX",Y)) Q $G(@VALMAR@("INDEX",Y))
        S COUNT=$$FINDMSG^HLOMSG1(Y,.LIST)
        I COUNT="0" W !!,"That message can not be found! Try Again",! G PICK
        I COUNT=1 Q LIST(1)
        I COUNT>1 D
        .N ITEM
        .W !,"There is more than one message with that ID! You must choose one to display.",1
        .S ITEM=0
        .F  S ITEM=$O(LIST(ITEM)) Q:'ITEM  D
        ..N MSG
        ..Q:'$$GETMSG^HLOMSG(+LIST(ITEM),.MSG)
        ..W !,"[",ITEM,"]","  DT/TM: ",$$FMTE^XLFDT(MSG("DT/TM CREATED"),2),"   STATUS: ",MSG("STATUS")
        .S DIR(0)="NO^1:"_COUNT,DIR("A")="Choose",DIR("?")="Choose one message from the list"
        .D ^DIR
        .I Y S Y=LIST(Y)
        Q Y
        ;
HELP    ;Help code
        S X="?" D DISP^XQORM1 W !!
        Q
        ;
EXIT    ;Exit code
        D CLEAN^VALM10
        D CLEAR^VALM1
        S VALMBCK="R"
        ;
        Q
        ;
EXPND   ;Expand code
        Q
        ;
CJ(STRING,LEN)  ;
        Q $$CJ^XLFSTR(STRING,LEN)
LJ(STRING,LEN)  ;
        Q $$LJ^XLFSTR(STRING,LEN)
SP(LEN,CHAR)    ;
        ;return padding - " " is the default pad character
        N STR
        S:$G(CHAR)="" CHAR=" "
        S $P(STR,CHAR,LEN)=CHAR
        Q STR
        ;
SHOWMSG(MSGIEN,SUBIEN)  ;
        ;Description:
        ;
        ;Input:
        ;Output:
        ;
        N MSG,I,TEMP,LINE,HDR,TRIES,STATUS
        S VALMCNT=0
        S SUBIEN=+$G(SUBIEN)
        I '$$GETMSG^HLOMSG(MSGIEN,.MSG) W !,"UNABLE TO DISPLAY THE MESSAGE",!! Q
        I SUBIEN S STATUS=MSG("STATUS") D GETMSGB^HLOMSG1(.MSG,SUBIEN,.MSG) I MSG("STATUS")="" S MSG("STATUS")=STATUS
        S HDR(1)=MSG("HDR",1),HDR(2)=MSG("HDR",2)
        I $$PARSEHDR^HLOPRS(.HDR)
        S I=0
        ;** administrative information **
        S @VALMAR@($$I,0)=$$CJ("Administrative Information",80)
        D CNTRL^VALM10(VALMCNT,26,30,IORVON,IORVOFF)
        ;; ***patch HL*1.6*138 start
        S LINE="MsgID: "_$$LJ(MSG("ID"),18) ;;
        S:MSG("ACK TO")]"" LINE=LINE_$$LJ(" Application Ack To:",26)_MSG("ACK TO") ;;
        S:MSG("ACK BY")]"" LINE=LINE_$$LJ(" Application Ack'd By:",26)_MSG("ACK BY") ;;
        S @VALMAR@($$I,0)=LINE ;;
        ;;
        S LINE=""
        S:MSG("DIRECTION")="OUT" TRIES=$G(^HLB(MSGIEN,"TRIES"))
        ;
        ;determine current status - as opposed to final status
        D
        .I MSG("STATUS")="SU" S MSG("STATUS")="SUCCESSFUL" Q
        .I MSG("STATUS")="ER" S MSG("STATUS")="ERROR" Q
        .I MSG("DIRECTION")="IN" D  Q
        ..I '$G(MSG("STATUS","APP HANDOFF")) S MSG("STATUS")="PENDING ON RECEIVING APPLICATION" Q
        .I MSG("DIRECTION")="OUT" D  Q
        ..I MSG("DT/TM")="" D  Q
        ...I $O(^HLB("QUEUE","OUT",MSG("STATUS","LINK NAME")_":"_MSG("STATUS","PORT"),MSG("STATUS","QUEUE"),0))=MSG("IEN") S MSG("STATUS")="TRANSMISSION IN PROGRESS" Q
        ...S MSG("STATUS")="PENDING ON OUTGOING QUEUE" Q
        ..I $G(HDR("APP ACK TYPE"))="AL",'$G(MSG("STATUS","APP ACK'D")),$G(MSG("ACK BY"))="" S MSG("STATUS")="TRANSMITTED, PENDING RECEIPT OF APPLICATION ACKNOWLEDGEMENT" Q
        ;; ***patch HL*1.6*138 end
        ;
        S LINE="Status: "_$$LJ(MSG("STATUS"),79)
        S @VALMAR@($$I,0)=LINE
        I MSG("STATUS","ERROR TEXT")]"" S @VALMAR@($$I,0)="Error: "_"** "_MSG("STATUS","ERROR TEXT")_" **"
        ;;**138 start cjm
        ;S @VALMAR@($$I,0)="Dir:   "_$$LJ($S(MSG("DIRECTION")="IN":"INCOMING",1:"OUTGOING"),10)_$$LJ("  Trans Dt/Tm: ",12)_$$FMTE^XLFDT(MSG("DT/TM"),2)_$$LJ("  Purge DT/TM: ",8)_$$FMTE^XLFDT(MSG("STATUS","PURGE"),2)
        S @VALMAR@($$I,0)="Direction: "_$$LJ($S(MSG("DIRECTION")="IN":"IN",1:"OUT"),4)_$$LJ("  TransDt/Tm"_$S($G(TRIES):"("_TRIES_"x): ",1:": "),12)_$$FMTE^XLFDT(MSG("DT/TM"),2)_$$LJ("  Purge DT/TM: ",8)_$$FMTE^XLFDT(MSG("STATUS","PURGE"),2)
        ;** 138 end cjm
        S @VALMAR@($$I,0)="Link:  "_$$LJ(MSG("STATUS","LINK NAME"),29)_"   "_$$LJ("Queue: ",13)_MSG("STATUS","QUEUE")
        I $L($G(MSG("STATUS","SEQUENCE QUEUE"))) D
        .S @VALMAR@($$I,0)="Sequence Queue: "_MSG("STATUS","SEQUENCE QUEUE")_"    Moved: "_$S(MSG("STATUS","MOVED TO OUT QUEUE"):"YES",1:"NO")
        I MSG("STATUS","ACCEPT ACK'D") D
        .S @VALMAR@($$I,0)="Accept Ack: "_$$LJ(MSG("STATUS","ACCEPT ACK ID"),26)_$$LJ(" DT/TM Ack'd: ",14)_$$FMTE^XLFDT(MSG("STATUS","ACCEPT ACK DT/TM"),2)
        .S @VALMAR@($$I,0)="   "_MSG("STATUS","ACCEPT ACK MSA")
        I MSG("DIRECTION")="IN" D
        .S LINE="App Response Rtn: "
        .;START HL*1.6*138 CJM
        .;I $L($G(MSG("STATUS","APP ACK RESPONSE"))) S LINE=$$LJ(LINE_MSG("STATUS","APP ACK RESPONSE"),38)_" Executed: "_$S(MSG("STATUS","APP HANDOFF"):"   YES",1:"   NO")
        .S LINE=$$LJ(LINE_$S($L($G(MSG("STATUS","ACTION"))):MSG("STATUS","ACTION"),1:"n/a"),38)_" Executed: "_$S('$L($G(MSG("STATUS","ACTION"))):"n/a",MSG("STATUS","APP HANDOFF"):"   YES",1:"   NO")
        .;;END HL*1.6*138 CJM
        .S @VALMAR@($$I,0)=LINE
        I MSG("DIRECTION")="OUT",(MSG("STATUS","APP ACK'D")!MSG("STATUS","ACCEPT ACK'D")) D
        .S LINE=""
        .I MSG("STATUS","ACCEPT ACK'D") D
        ..I MSG("STATUS","ACCEPT ACK RESPONSE")="" S MSG("STATUS","ACCEPT ACK RESPONSE")="n/a"
        ..S LINE="Accept Ack Rtn: "_MSG("STATUS","ACCEPT ACK RESPONSE")
        .S LINE=$$LJ(LINE,39)
        .I MSG("STATUS","APP ACK'D") D
        ..I MSG("STATUS","APP ACK RESPONSE")="" S MSG("STATUS","APP ACK RESPONSE")="n/a"
        ..S LINE=LINE_"App Ack Rtn: "_MSG("STATUS","APP ACK RESPONSE")
        .S @VALMAR@($$I,0)=LINE
        ;
        ;** the message text **
        S @VALMAR@($$I,0)=""
        I '$G(SUBIEN) D
        .S @VALMAR@($$I,0)=$$CJ("Message Text",80)
        .D CNTRL^VALM10(VALMCNT,33,16,IORVON,IORVOFF)
        E  D
        .S @VALMAR@($$I,0)=$$CJ("Individual Message Text (Batched)",80)
        .D CNTRL^VALM10(VALMCNT,23,35,IORVON,IORVOFF)
        ;; START 138
        ;D SHOWBODY(.MSG,$G(SUBIEN))
        D SHOWBODY(.MSG,$G(SUBIEN),.SEGS)
        ;; END 138
        ;
        ;** display its application acknowledgment **
        I MSG("ACK BY")]"",$$FINDMSG^HLOMSG1(MSG("ACK BY"),.TEMP)=1 S MSGIEN=TEMP(1) D
        .N MSG,STATUS
        .Q:'$$GETMSG^HLOMSG(+MSGIEN,.MSG)
        .I $P(MSGIEN,"^",2) S STATUS=MSG("STATUS") D GETMSGB^HLOMSG1(.MSG,SUBIEN,.MSG) I MSG("STATUS")="" S MSG("STATUS")=STATUS
        .S @VALMAR@($$I,0)=""
        .S @VALMAR@($$I,0)=$$CJ("Application Acknowledgment",80)
        .D CNTRL^VALM10(VALMCNT,26,30,IORVON,IORVOFF)
        .D SHOWBODY(.MSG,$P(MSGIEN,"^",2))
        ;
        ;** display the original message **
        I MSG("ACK TO")]"",$$FINDMSG^HLOMSG1(MSG("ACK TO"),.TEMP)=1 S MSGIEN=TEMP(1) D
        .N MSG
        .Q:'$$GETMSG^HLOMSG(+MSGIEN,.MSG)
        .I $P(MSGIEN,"^",2) S STATUS=MSG("STATUS") D GETMSGB^HLOMSG1(.MSG,SUBIEN,.MSG) I MSG("STATUS")="" S MSG("STATUS")=STATUS
        .S @VALMAR@($$I,0)=""
        .S @VALMAR@($$I,0)=$$CJ("Original Message",80)
        .D CNTRL^VALM10(VALMCNT,26,30,IORVON,IORVOFF)
        .D SHOWBODY(.MSG,$P(MSGIEN,"^",2))
        Q
        ;
SHOWBODY(MSG,SUBIEN,SEGS)       ;
        N NODE,I,SEG,QUIT
        S QUIT=0
        S SEGS("ARY")=VALMAR
        S SEGS("TOP")=VALMCNT+1
        M SEG=MSG("HDR")
        D ADD(.SEG,.SEGS)
        S MSG("BATCH","CURRENT MESSAGE")=0
        I MSG("BATCH") D
        .I $G(SUBIEN) D  Q
        ..S MSG("BATCH","CURRENT MESSAGE")=SUBIEN
        ..F  Q:'$$HLNEXT^HLOMSG(.MSG,.SEG)  D ADD(.SEG,.SEGS)
        .S MSG("BATCH","CURRENT MESSAGE")=0
        .N LAST S LAST=0
        .F  Q:'$$NEXTMSG^HLOMSG(.MSG,.SEG)  D  Q:QUIT
        ..D ADD(.SEG,.SEGS)
        ..S LAST=MSG("BATCH","CURRENT MESSAGE")
        ..F  Q:'$$HLNEXT^HLOMSG(.MSG,.SEG)  D ADD(.SEG,.SEGS)
        .I MSG("DIRECTION")="OUT" K SEG S SEG(1)="BTS"_$E($G(MSG("HDR",1)),4)_LAST D ADD(.SEG,.SEGS)
        .;
        E  D
        .F  Q:'$$HLNEXT^HLOMSG(.MSG,.SEG)  D  Q:QUIT
        ..D ADD(.SEG,.SEGS)
        S SEGS("BOT")=VALMCNT
        Q
I()     ;
        S VALMCNT=VALMCNT+1
        Q VALMCNT
ADD(SEG,SEGS)   ;
        N QUIT,I,J,LINE
        S QUIT=0
        S SEGS=$G(SEGS)+1
        S (I,J)=1
        S LINE(1)=$E(SEG(1),1,80),SEG(1)=$E(SEG(1),81,9999)
        I SEG(1)="" K SEG(1)
        D SHIFT(.I,.J)
        S @VALMAR@($$I,0)=LINE(1)
        ;; START 138
        D CNTRL^VALM10(VALMCNT,1,3,IOINHI,IOINORM)
        ;;END 138
        S SEGS(SEGS)=VALMCNT
        S I=1
        F  S I=$O(LINE(I)) Q:'I  D
        .S @VALMAR@($$I,0)=LINE(I)
        .;;START 138
        .;D CNTRL^VALM10(VALMCNT,1,1,IORVON,IORVOFF)
        .;END 138
        Q
        ;
SHIFT(I,J)      ;
        I '$D(SEG(I)) S I=$O(SEG(0)) Q:'I
        I $L(LINE(J))<80 D
        .N LEN
        .S LEN=$L(LINE(J))
        .S LINE(J)=LINE(J)_$E(SEG(I),1,80-LEN)
        .S SEG(I)=$E(SEG(I),81-LEN,9999)
        .I SEG(I)="" K SEG(I)
        E  D
        .S J=J+1
        .S LINE(J)=""
        D SHIFT(.I,.J)
        Q
        ;
SCRLMODE        ;scroll mode
        Q:'$L(HLRFRSH)
        N QUIT,IOTM,IOBM,DX,DY,LINE,IOTM,IOBM
        W !!,IOINHI,"Hit any key to escape scroll mode...",IOINORM
        S IOTM=3,IOBM=23
        S QUIT=0
        S LINE=$S(VALMCNT<17:1,1:17)
        W @IOSTBM
        S DX=1,DY=$S(VALMCNT<17:VALMCNT+1,1:17) X IOXY
        F I=1:1 D  Q:QUIT
        .;every 10 seconds refresh the data
        .I I>42 D @HLRFRSH S I=0
        .I LINE+1>VALMCNT D
        ..S TEMP=$G(@VALMAR@(LINE,0))
        ..W !,IOUON,TEMP_$$SP(80-$L(TEMP)),IOUOFF
        .E  W !,$G(@VALMAR@(LINE,0))
        .S LINE=LINE+1
        .I LINE>VALMCNT S LINE=1
        .I (I=22)!(I=43) R *C:5 I $T S QUIT=1 Q
        S VALMBG=LINE-23 I VALMBG<0 S VALMBG=1
        S VALMBCK="R"
        Q
HLP     ;
        Q
        ;
IFOPEN(LINK)    ;
        ;returns 1 if the link can be opened, otherwise 0
        ;
        ;Inputs:
        ;  LINK - name of the link (required), optionally post-fixed with ":"_<port #>, will default to that defined for link
        ;
        N LINKNAME,LINKARY,POP,IO,IOF,IOST,OPEN,PORT
        S OPEN=0
        S LINKNAME=$P(LINK,":")
        S PORT=$P(LINK,":",2)
        Q:LINKNAME="" 0
        Q:'$$GETLINK^HLOTLNK(LINKNAME,.LINKARY) 0
        S:PORT LINKARY("PORT")=PORT
        Q:'$G(LINKARY("PORT")) 0
        I LINKARY("IP")="",LINKARY("DOMAIN")="",LINKARY("LLP")="TCP",LINKARY("SERVER") D
        .N DATA
        .S LINKARY("DOMAIN")=$P($G(^HLD(779.1,1,0)),"^")
        .Q:LINKARY("DOMAIN")=""
        .S DATA(.08)=LINKARY("DOMAIN")
        .Q:$$UPD^HLOASUB1(870,LINKARY("IEN"),.DATA)
        D:$G(LINKARY("IP"))'=""
        .D CALL^%ZISTCP(LINKARY("IP"),LINKARY("PORT"),15)
        .S OPEN='POP
        I 'OPEN,LINKARY("DOMAIN")'="",$G(^HLTMP("DNS LAST",LINKARY("IEN")))<$$DT^XLFDT D
        .N IP
        .S ^HLTMP("DNS LAST",LINKARY("IEN"))=$$DT^XLFDT
        .S IP=$$DNS^HLOTCP(LINKARY("DOMAIN"))
        .I IP'="",IP'=LINKARY("IP") D
        ..N DATA
        ..S DATA(400.01)=IP,LINKARY("IP")=IP
        ..Q:$$UPD^HLOASUB1(870,LINKARY("IEN"),.DATA)
        ..D CALL^%ZISTCP(LINKARY("IP"),LINKARY("PORT"),15)
        ..S OPEN='POP
        C:OPEN IO
        ;D CLOSE^%ZISTCP
        Q OPEN
