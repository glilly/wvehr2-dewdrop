CWMAILF ;INDPLS/PLS- DELPHI VISTA MAIL SERVER CONT'D ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        ;MODIFIED FOR XM*7.1*50
        Q   ;ROUTINE CAN'T BE CALLED DIRECTLY
BLDLST(CWDATA,CWDATSRC,CWDCNT)  ;  build list of messages - called by CWMAILA
        ;Input: CWDATA - pass by reference
        ;       CWDATSRC - $NA containing data
        ;       CWDCNT - node counter
        ;Return: CWDATA array
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
        N CWVAL,CWMSG,CWMSGSUB,CWMSGDT,CWMAIB,CWMSGBX,CWMSGLP
        N CWARY
        S CWMSG=0,CWDCNT=2,CWMSGLP=0
        ;CALL API TO RETRIEVE MESSAGES
        F  S CWMSGLP=$O(@CWDATSRC@(CWMSGLP)) Q:CWMSGLP<1  D
        . S CWARY(1)=+$G(@CWDATSRC@(CWMSGLP,"BSKT"))
        . S CWARY(2)=+$G(@CWDATSRC@(CWMSGLP))
        . S CWARY(3)=$G(@CWDATSRC@(CWMSGLP,"SUBJ"))
        . S CWARY(4)=$P($G(@CWDATSRC@(CWMSGLP,"DATE")),U)
        . I CWARY(4)?1.N1".".N S CWARY(4)=$$FMDTE^CWMAIL4(CWARY(4),"5MZ")
        . E  S CWARY(4)=$$FMDTE^CWMAIL4($$CONVERT^XMXUTIL1(CWARY(4),1),"5MZ")
        . S CWARY(18)=$G(@CWDATSRC@(CWMSGLP,"SEQN"))
        . S CWARY(19)=+$G(@CWDATSRC@(CWMSGLP,"NEW"))
        . S CWDATA(CWDCNT)=$$ADDMP^CWMAIL0(CWARY(2),.CWARY)
        . S CWDCNT=CWDCNT+1
        Q
        ;
%MSGISRC(CWDATA,CWINPUT)        ;SEARCH FOR A PARTICULAR MESSAGE NUMBER
        ;CWINPUT - IEN of Message
        N CWI,CWMIEN,CWDATT,CWDCNT
        K CWDATA
        S CWDCNT=2
        S CWMIEN=+$P($G(CWINPUT),";")
        I $$ACCESS^XMXSEC(XMDUZ,CWMIEN) D
        . D MSGINIT(CWMIEN,.CWDATT)
        . D BLDLST(.CWDATA,$NA(CWDATT),.CWDCNT)
        . ;S CWDATA(1)="1^^DATA HAS BEEN FOUND"
        ;E  S CWDATA(1)="1^^Message not found or you don't have access to it."
        I $O(CWDATA(1)) S CWDATA(1)="1^^DATA HAS BEEN FOUND"
        E  S CWDATA(1)="1^^Message not found or you lack access to it."
        S $P(CWDATA(1),U,2)=CWDCNT-2
MSGISRCE        Q
        ;
MSGINIT(CWMIEN,CWDATT)  ;Individual Message Pre-processor
        N CWIM,CWINSTR,CWIU
        D INMSG^XMXUTIL2(XMDUZ,"",CWMIEN,,,.CWIM,.CWINSTR,.CWIU)
        S CWDATT(1)=CWMIEN
        S CWDATT(1,"DATE")=$G(CWIM("DATE"))
        S CWDATT(1,"SUBJ")=$G(CWIM("SUBJ"))
        S CWDATT(1,"SEQN")=""
        S CWDATT(1,"BSKT")=$$BSKT^XMXUTIL2(XMDUZ,CWMIEN,1)
        S CWDATT(1,"NEW")=$G(CWIU("NEW"))>0
        Q
