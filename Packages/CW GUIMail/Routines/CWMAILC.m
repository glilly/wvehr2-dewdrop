CWMAILC ;INDPLS/PLS- DELPHI VISTA MAIL SERVER CONT'D ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        ;MODIFIED FOR XM*7.1*50
        Q   ;ROUTINE CAN'T BE CALLED DIRECTLY
        ;
%LATER(CWDATA,CWINPUT)  ;LATER A MESSAGE
        ;CWINPUT - HOLDS MESSAGE NUMBER AND LATER DATE/TIME - DELIMITER ';'
        ;    1st - IEN of message
        ;    2nd - Later date
        N XMZ,XMDUZ,XMA
        S CWDATA(1)="0^^AN ERROR HAS OCCURRED"
        S XMZ=$P(CWINPUT,";")
        S XMDUZ=DUZ
        S XMA=$P(CWINPUT,";",2)
        G:'XMZ!('$G(XMA)) LATERE
        I $$LATER^CWMAIL1(XMZ,XMA) D
        .S CWDATA(1)="1^1^Message has been latered"
        E  S CWDATA(1)="0^0^Unable to Later Message Number: "_XMZ
LATERE  Q
        ;
%MBOX(CWDATA,CWINPUT)   ;RETRIEVE MAILBOXES
        ;CWINPUT NOT USED
        ;VARIABLES :    CWNMSG = NEW MESSAGES
        ;               CWTMSG = TOTAL MESSAGE COUNT
        K ^TMP($J,"CWMBSKT")
        D LISTBSKT^XMXAPIB(XMDUZ,,,,,"^TMP($J,""CWMBSKT"")")
        N CWLP,CWLP1,CWCNT,CWNMSG,CWTMSG,CWFPES,CWHSN,CWBNAME,CWBIEN
        S CWDATA(1)="0^^AN ERROR HAS OCCURRED",CWCNT=2
        S CWLP=0 F  S CWLP=$O(^TMP($J,"CWMBSKT","XMLIST",CWLP)) Q:CWLP=""  D
        . S CWBIEN=+$G(^TMP($J,"CWMBSKT","XMLIST",CWLP))
        . I CWBIEN D
        . . S CWDATA(CWCNT)=$G(^TMP($J,"CWMBSKT","XMLIST",CWLP))
        . . S CWCNT=CWCNT+1
        I $O(CWDATA(1)) S CWDATA(1)="1^^DATA HAS BEEN FOUND"
        E  S CWDATA(1)="1^^No Mail Boxes could be found"
        S $P(CWDATA(1),U,2)=CWCNT-2
MBOXE   K ^TMP($J,"CWMBSKT")
        Q
%PMBOX(CWDATA,CWINPUT)  ;PURGE ENTIRE MAIL BOX
        ;CWINPUT = MAIL BOX IEN
        N CWLP,XMZ,XMK,CWX,CWY,XMKZA,XMMSG,CWCNT
        S XMK=$P(CWINPUT,";",2)
        G PMBOXE:'XMK
        S CWDATA(1)="0^^AN ERROR HAS OCCURRED",CWCNT=2
        ;delete basket regardless of content
        D DELBSKT^XMXAPIB(XMDUZ,XMK,"D")
        S CWDATA(1)="1^1"
        ;E  S CWDATA(1)="0^0"
PMBOXE  Q
%RNMBOX(CWDATA,CWINPUT) ;RENAME EXISTING MAILBOX
        ;CWINPUT - DELIMITER ';'
        ;   1st  - IEN of mailbox
        ;   2nd  - New name of mailbox
        D NAMEBSKT^XMXAPIB(XMDUZ,$P(CWINPUT,";"),$P(CWINPUT,";",2))
        S CWDATA(1)="1^1^MAILBOX NAME WAS CHANGED"   ;FORCE TO SUCCESS
RNMBOXE Q
%MSGRCP(CWDATA,CWINPUT) ; RETURNS A LIST OF MESSAGE RECIPIENTS
        ;CWINPUT = IEN of message
        N CWDAT,CWI,XMZ
        K CWDATA
        S XMZ=+$P($G(CWINPUT),";",2)
        D RECPT^CWMAIL1(.CWDATA,XMZ)
MSGRCPE Q
%NETINFO(CWDATA,CWINPUT)        ; RETURNS NETWORK TRANSMISSION INFO
        ;INPUT - IEN of message
        N CWDAT,CWI,XMZ
        K CWDATA
        S XMZ=+$P($G(CWINPUT),";",2)
        D NETINFO^CWMAIL1(.CWDATA,XMZ)
NETINFOE        Q
        ;
%ADRSTO(CWDATA,CWINPUT) ;RETURNS ARRAY OF ADDRESSED TO
        ;CWINPUT - IEN of message
        N CWDAT,CWI,XMZ
        K CWDATA
        S XMZ=+$P($G(CWINPUT),";",2)
        D ADRSTO^CWMAIL1(.CWDATA,XMZ)
ADRSTOE Q
%GRPINF(CWDATA,CWINPUT) ;MAIL GROUP INFO
        ;CWINPUT - IEN of mail group
        N CWDAT,CWI,XMZ
        K CWDATA
        S CWI=2
        S CWIEN=+$P($G(CWINPUT),";",2)
        I $$GRPINFO^CWMAIL3(.CWDAT,CWIEN) D
        .S CWI=+$G(CWDAT(-9900)) K CWDAT(-9900)
        .M CWDATA=CWDAT
        .S CWDATA(1)="1^^DATA HAS BEEN FOUND"
        E  S CWDATA(1)="1^^There was no Mail Group information found."
        S $P(CWDATA(1),U,2)=CWI-2
GRPINFE Q
%USRINF(CWDATA,CWINPUT) ;MAIL USER INFO
        ;CWINPUT - IEN of mail user
        N CWDAT,CWI,CWIEN
        K CWDATA
        S CWI=2
        S CWIEN=+$P($G(CWINPUT),";",2)
        ;G:'CWIEN USRINFE
        I $$USRINFO^CWMAIL3(.CWDAT,CWIEN) D
        .S CWI=+$G(CWDAT(-9900)) K CWDAT(-9900)
        .M CWDATA=CWDAT
        .S CWDATA(1)="1^^DATA HAS BEEN FOUND"
        E  S CWDATA(1)="1^^There was no Mail User information found."
        S $P(CWDATA(1),U,2)=CWI-2
USRINFE Q
MBOXD(CWDAT,CWUSR,CWIEN)        ;RETURN DATA FOR MAILBOX
        ;API NOT CURRENTLY USED
        ;INPUT CWDAT = RETURN ARRAY
        ;      CWIEN = MAILBASKET IEN TO 3.7 FOR USER
        ;OUTPUT CWDAT("NAME")
        ;       CWDAT("TMSG")
        ;       CWDAT("NMSG")
        ;       CWDAT("IEN")
        N CWDATT
        D QBSKT^XMXAPIB(CWUSR,CWIEN,.CWDATT)
        S CWDAT("IEN")=$P(CWDATT,U)
        S CWDAT("NAME")=$P(CWDATT,U,2)
        S CWDAT("TMSG")=+$P(CWDATT,U,3)
        S CWDAT("NMSG")=+$P(CWDATT,U,4)
        Q
