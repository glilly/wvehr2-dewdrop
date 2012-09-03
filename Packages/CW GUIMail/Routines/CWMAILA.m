CWMAILA ;INDPLS/PLS- DELPHI VISTA MAIL SERVER CONT'D ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        ;MODIFIED FOR XM*7.1*50
        Q   ;ROUTINE CAN'T BE CALLED DIRECTLY
%READ(CWDATA,CWINPUT)   ;
        ;CWINPUT FORMAT - DELIMITER ';'
        ;       1st  - IEN of message
        ;       4th  - New message (value >0 indicates new messages only)
        K CWDATA
        N CWMSGN,CWNMFLG
        S CWMSGN=$P(CWINPUT,";")
        S CWNMFLG=+$P(CWINPUT,";",4)
        D:CWMSGN PROCMS^CWMAIL0(.CWDATA,CWMSGN,CWNMFLG)
        Q
%LIST(CWDATA,CWINPUT)   ;
        ;CWINPUT - MAIL TYPE OR MAILBOX NUMBER - DELIMITER ';'
        ;     2nd - IEN of MailBasket or non-numeric for new mail
        ;CWARY format:  piece   value
        ;                 1     message basket
        ;                 2     message ien
        ;                 3     message subject
        ;                 4     message date sent
        ;                 5     not used
        ;                 6     message type
        ;                 7     confirmation flag
        ;                 8     closed flag
        ;                 9     info flag
        ;                10     confidential flag
        ;                11     sender ien
        ;                12     broadcast flag
        ;                13     sender name
        ;                14     total # of recipients
        ;                15     total # of replies
        ;                16     priority flag
        ;                17     last response read
        ;                18     message basket sequence number
        ;                19     new message flag
        ;                20     answer message flag
        ;
        S CWDATA(1)="0^AN ERROR HAS OCCURRED"
        N CWVAL,CWMSG,CWMSGSUB,CWMSGDT,CWDCNT,CWMAIB,CWMSGBX,CWMSGLP
        N CWARY
        S CWVAL=$P(CWINPUT,";",2)
        S CWMSG=0,CWDCNT=2,CWMSGLP=0
        S CWMAIB=CWVAL
        ;CALL API TO RETRIEVE MESSAGES
        I CWVAL=+CWVAL D
        . D LISTMSGS^XMXAPIB(XMDUZ,+CWMAIB,"BSKT;SUBJ;DATE;SEQN;NEW","",3500)  ; data put in ^TMP("XMLIST",$J
        . Q:'+$P($G(^TMP("XMLIST",$J,0)),U,1)  ;NO DATA FOUND
        . D BLDLST^CWMAILF(.CWDATA,$NA(^TMP("XMLIST",$J)),.CWDCNT)
        E  D  ;PROCESS NEW MESSAGE REQUEST
        . D LISTMSGS^XMXAPIB(XMDUZ,"*","BSKT;SUBJ;DATE;NEW","N",3500)   ;SEQN;NEW","N")
        . Q:'+$P($G(^TMP("XMLIST",$J,0)),U,1)  ;NO DATA FOUND
        . D BLDLST^CWMAILF(.CWDATA,$NA(^TMP("XMLIST",$J)),.CWDCNT)
        I $O(CWDATA(1)) S CWDATA(1)="1^^DATA HAS BEEN FOUND"
        E  S CWDATA(1)=$S(+CWVAL:"1^^No Messages Found in Specified Mail Box",1:"1^^"_"You have no NEW Messages")
        S $P(CWDATA(1),U,2)=CWDCNT-2
        Q
        ;
%DELETE(CWDATA,CWINPUT) ;
        ;CWINPUT - DELIMITER ';'
        ;   1st  - IEN of message
        ;   2nd  - IEN of mail basket
        N XMZ,XMDUZ,XMK,XMKZA,XMMSG
        S XMZ=$P(CWINPUT,";")
        S XMDUZ=DUZ
        S XMK=$P(CWINPUT,";",2)
        S XMKZA(XMZ)=""
        D DELMSG^XMXAPI(XMDUZ,"",.XMKZA,.XMMSG)
        I +$G(XMMSG) D
        . S CWDATA(1)="1^0^Message Deleted"
        E  S CWDATA(1)="0^0^Unable to delete message"
        Q
%SAVE(CWDATA,CWINPUT)   ;
        ;CWINPUT - DELIMITER ';'
        ;   1st  - IEN of message
        ;   2nd  - IEN of mail basket
        ;   3rd  - IEN of new mail basket
        N XMZ,XMK,XMKM,XMMSG,XMKZA
        S XMZ=$P(CWINPUT,";"),XMK=$P(CWINPUT,";",2)
        S XMKZA(XMZ)=""
        S XMKM=$P(CWINPUT,";",3)
        D MOVEMSG^XMXAPI(XMDUZ,"",.XMKZA,XMKM,.XMMSG)
        S CWDATA(1)=+$G(XMMSG)  ;Return Status
        Q
%MAKNEW(CWDATA,CWINPUT) ;
        ;CWINPUT - DELIMITER ';'
        ;   1st  - IEN of message
        ;   2nd  - IEN of mail basket
        N XMZ,XMK,XMKZA,XMMSG
        S CWDATA(1)=0
        S XMZ=$P(CWINPUT,";")
        S XMK=+$P(CWINPUT,";",2)
        D MAKENEW^XMXUTIL(XMDUZ,XMK,XMZ,1)
        I XMK<.6 D  ;MUST MOVE MESSAGE FROM WASTE BASKET TO IN BASKET
        . S XMKZA(XMZ)=""
        . D MOVEMSG^XMXAPI(XMDUZ,"",.XMKZA,1,.XMMSG)
        S CWDATA(1)="1^1"   ;FORCE TO SUCCESS
        Q
%NEWBSK(CWDATA,CWINPUT) ;CREATE A NEW MAIL BASKET
        ;CWINPUT - DELIMITER ';'
        ;   1st Piece  - New basket name
        N CWBASKET,CWBSKN,CWMSG
        S CWBASKET=$$UP^XLFSTR($P(CWINPUT,";"))  ;FORCE TO UPPER CASE
        D CRE8BSKT^XMXAPIB(XMDUZ,CWBASKET,.CWBSKN)
        I +$G(CWBSKN)>0 D
        . D QBSKT^XMXAPIB(XMDUZ,+CWBSKN,.CWMSG)
        . S CWDATA(1)="1"_U_CWBSKN_U_$P($G(CWMSG),U,2)
        E  S CWDATA(1)=0_U_"Error-unable to create basket."
        Q
%RESEQ(CWDATA,CWINPUT)  ;RESEQUENCE A VISTA MAIL BASKET
        ;CWINPUT - DELIMITER ';'
        ;   2nd  - IEN of mail basket
        N CWBASKET,CWDATT
        S CWBASKET=$P(CWINPUT,";",2)
        G:'CWBASKET RESEQE
        D RSEQBSKT^XMXAPIB(XMDUZ,CWBASKET,.CWDATT)
        I $L(CWDATT) S CWDATA(1)="1^1"
        E  S CWDATA(1)="0^0^Error-unable to resequence messages."
RESEQE  Q
        ;
%MSGSRC(CWDATA,CWINPUT,CWTEXT)  ;MESSAGE SEARCH
        ;INPUT - CWINPUT AND CWTEXT ARRAY HOLD CRITERIA
        ;OUTPUT - REFER TO %LIST
        S CWDATA(1)="0^AN ERROR HAS OCCURRED"
        N CWVAL,CWMSG,CWMSGSUB,CWMSGDT,CWDCNT,CWMAIB,CWMSGBX,CWMSGLP
        N CWARY,CWFLAGS
        S CWFLAGS=$P(CWINPUT,";")  ;Processing Flags
        S CWMAIB=$P(CWINPUT,";",2)  ;MailBasket
        S CWMSG=0,CWDCNT=2,CWMSGLP=0
        S CWMAIB=$S($L(CWMAIB):CWMAIB,1:"*")
        ;Convert External dates to FM Dates
        I $G(CWTEXT("FDATE")) D
        . S CWTEXT("FDATE")=$$CONVERT^XMXUTIL1(CWTEXT("FDATE"))
        I $G(CWTEXT("TDATE")) D
        . S CWTEXT("TDATE")=$$CONVERT^XMXUTIL1(CWTEXT("TDATE"))
        ;CALL API TO RETRIEVE MESSAGES
        D LISTMSGS^XMXAPIB(XMDUZ,CWMAIB,"BSKT;SUBJ;DATE;NEW",CWFLAGS,,,.CWTEXT)  ; data put in ^TMP("XMLIST",$J
        I +$P($G(^TMP("XMLIST",$J,0)),U,1) D   ;
        . D BLDLST^CWMAILF(.CWDATA,$NA(^TMP("XMLIST",$J)),.CWDCNT)
        I $O(CWDATA(1)) S CWDATA(1)="1^^DATA HAS BEEN FOUND"
        E  S CWDATA(1)="1^^No Messages Found In Search"
        S $P(CWDATA(1),U,2)=CWDCNT-2
MSGSRCE Q
