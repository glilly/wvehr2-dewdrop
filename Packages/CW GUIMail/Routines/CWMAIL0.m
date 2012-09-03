CWMAIL0 ;INDPLS/PLS- DELPHI MAIL SERVER, CONT'D ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        Q   ;ROUTINE CAN'T BE CALLED DIRECTLY
        ;
PROCMS(CWDATA,CWMSGN,CWNMFLG)   ;PROCESS MAIL MESSAGE THREAD
        N CWRE,CWCNT,CWRSP,CWNWMSG,CWDATT,CWLCNT,CWLP,CWCONFRM,CW
        N CWIM,CWIU,CWINSTR,CWFLAGS,CWIR
        D INMSG^XMXUTIL2(XMDUZ,$$BSKT^XMXUTIL2(XMDUZ,CWMSGN),CWMSGN,,"F",.CWIM,.CWINSTR,.CWIU)  ;SET-UP MESSAGE INFO
        S CWDATA=$NA(^TMP($J,"CWMAIL"))
        S CWNWMSG=$G(CWIM("FROM"))["@"  ;NETWORK MESSAGE
        S CWCNT=2,CWLCNT=0
        S @CWDATA@(CWCNT)="Mail Message From: "_$G(CWIM("FROM NAME"))_"  "_"Dated: "_$$FMDTE^CWMAIL4(CWIM("DATE FM"),"5MZ")
        S CWCNT=$$INCNT(CWCNT),@CWDATA@(CWCNT)="Subject: "_$G(CWIM("SUBJ"))
        S CWCNT=$$INCNT(CWCNT),@CWDATA@(CWCNT)=""
        ;I 'CWNMFLG!(CWNMFLG&($G(CWIM("RESP"))<1))!(CWNMFLG&(+$G(CWIM("RESP"))=+$G(CWIM("RESPS"))))
        I 'CWNMFLG!(CWNMFLG&(+$G(CWIU("RESP"))<1))!(CWNMFLG&(+$G(CWIU("RESP"))=+$G(CWIM("RESPS")))) D READM(.CWDATA,CWMSGN,.CWCNT)
        S CWCONFRM=""
        D LASTACC(CWMSGN,$$BSKT^XMXUTIL2(XMDUZ,CWMSGN),0,.CWCONFRM)  ;UPDATE LAST ACCESS DATE/TIME
        ;PROCESS RESPONSES
        I $G(CWIM("RESPS"))>0 D
        . S CWLP=$S(+$G(CWIU("RESP"))=+$G(CWIM("RESPS")):1,+$G(CWIU("RESP"))<1:1,CWNMFLG:+$G(CWIU("RESP")),1:1) F CWLP=CWLP:1:CWIM("RESPS") D
        . . D INRESP^XMXUTIL2(CWMSGN,CWLP,"F",.CWIR)  ;gather details on specific response
        . . S CWCNT=$$INCNT(CWCNT),@CWDATA@(CWCNT)=""
        . . S CWCNT=$$INCNT(CWCNT),@CWDATA@(CWCNT)="Response: "_CWLP_") "_$G(CWIR("FROM NAME"))_"  "_$$FMDTE^CWMAIL4($G(CWIR("DATE FM")),"5MZ")
        . . S CWCNT=$$INCNT(CWCNT),@CWDATA@(CWCNT)=""
        . . D READM(.CWDATA,CWIR("XMZ"),.CWCNT)
        . . D LASTACC(CWMSGN,$$BSKT^XMXUTIL2(XMDUZ,CWMSGN),CWLP)  ;UPDATES LAST RESPONSE READ
        D NONEW^XMXUTIL(XMDUZ,$$BSKT^XMXUTIL2(XMDUZ,CWMSGN),CWMSGN,1)  ;UNNEW MESSAGE
        I +CWCONFRM D  ;SEND CONFIRMATION IF NEEDED
        . S CWCNT=$$INCNT(CWCNT),@CWDATA@(CWCNT)=""
        . S CWCNT=$$INCNT(CWCNT),@CWDATA@(CWCNT)=">>Confirmation Message Sent to Sender.<<"
        I $O(@CWDATA@(1)) D
        . S @CWDATA@(1)="1^^DATA HAS BEEN FOUND"
        E  S @CWDATA@(1)="1^^Message text could not be found."
        S $P(@CWDATA@(1),U,2)=CWCNT-2
        Q
        ;
LASTACC(XMZ,CWBIEN,CWLRSP,XMCONFRM)     ;UPDATE LAST RESPONSE READ DATE
        ;INPUT    XMZ = MESSAGE NUMBER
        ;      CWBIEN = BASKET IEN
        ;      CWLRSP = LAST RESPONSE READ
        ;
        N CWIM,CWIU,CWINSTR,CWXINSTR,CWFLAGS
        D INMSG1^XMXUTIL2(XMDUZ,XMZ,,.CWFLAGS,.CWIM,.CWIU)   ;SET-UP FOR CALL
        D INMSG2^XMXUTIL2(XMDUZ,XMZ,,.CWIM,.CWXINSTR,.CWIU)
        S CWINSTR("FLAGS")=$S($G(CWXINSTR("FLAGS"))["R":"R",1:"")
        D LASTACC^XMXUTIL(XMDUZ,CWBIEN,XMZ,CWLRSP,.CWIM,.CWINSTR,.CWIU,.XMCONFRM)
        Q
        ;
READM(CWDATA,CWINPUT,CWCNT)     ;OUTPUT MAIL MESSAGE IN ARRAY
        S $ZT="READMER^CWMAIL"
        N CWRDATA,XMZ,CWMTYPE,CWTFLG,XMER,XMPOS
        S XMZ=+$G(CWINPUT),CWTFLG=0,CWMTYPE=$G(CWINSTR("TYPE"))
        F  S CWRDATA=$$READ^XMGAPI1() Q:XMER<0!(CWTFLG)  S CWCNT=CWCNT+1,@CWDATA@(CWCNT)=CWRDATA I CWMTYPE="K"!(CWMTYPE="X") S:CWRDATA["$END TXT" CWTFLG=1
        ;
READMER Q
        ;
INCNT(CWCNT)    ;INCREMENT COUNTER
        Q CWCNT+1
        ;
ADDMP(CWXMZ,CWVAL)      ;set data into DAT based on subscripted CWVAL
        ;INPUT  -  CWXMZ = message ien
        ;          CWVAL = input array (i.e. CWVAL(1)=first piece...CWVAL(n)=last piece
        ;OUTPUT -  data string holding delimited ('^') data
        S CWXMZ=$G(CWXMZ,0)
        I +$G(CWXMZ) D
        . N X,CWCONFRM,CWTYPE,CWCLOSED,CWINFO,CWCONFID,CWSDRDUZ,CWBRDCAS,CWSDRNAM,CWTRECPT,CWTREPLY
        . N CWIM,CWIU,CWINSTR,CWPMSG,CWLP,CWDAT
        . D INMSG^XMXUTIL2(XMDUZ,$$BSKT^XMXUTIL2(XMDUZ,CWXMZ),CWXMZ,,"F",.CWIM,.CWINSTR,.CWIU)  ;SET-UP MESSAGE INFO
        . S CWVAL(6)=$$UP^XLFSTR($G(CWINSTR("TYPE")))  ;message type(s)
        . S:$G(CWINSTR("FLAGS"))["P" CWVAL(6)="P"_CWVAL(6)   ;add priority flag as a type
        . S CWVAL(7)=$G(CWINSTR("FLAGS"))["R"       ;confirmation flag
        . S CWVAL(8)=$G(CWINSTR("FLAGS"))["X"       ;closed flag
        . S CWVAL(9)=$G(CWINSTR("FLAGS"))["I"       ;informational flag
        . S CWVAL(10)=$G(CWINSTR("FLAGS"))["C"      ;confidential flag
        . S CWVAL(11)=$G(CWIM("FROM DUZ"))          ;sender ien
        . S CWVAL(13)=$G(CWIM("FROM NAME"))         ;sender full name
        . S CWVAL(12)=$$BCAST^XMXSEC(CWXMZ)         ;broadcast flag
        . S CWVAL(14)=$G(CWIM("RECIPS"))            ;total # of recipients
        . S CWVAL(15)=$G(CWIM("RESPS"))             ;total # of replies
        . S CWVAL(16)=$G(CWINSTR("FLAGS"))["P"      ;priority flag
        . S CWVAL(17)=+$G(CWIU("RESP"))              ;# of last response read
        . S CWVAL(20)=+$$ANSWER^XMXSEC(XMDUZ,CWXMZ,$$ZNODE^XMXUTIL2(CWXMZ))  ;can user answer message
        ;set data into node
        S CWLP="" F  S CWLP=$O(CWVAL(CWLP)) Q:CWLP<1  D
        . S $P(CWDAT,U,CWLP)=CWVAL(CWLP)
        Q CWDAT
