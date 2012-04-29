CWMAILB ;INDPLS/PLS- DELPHI VISTA MAIL SERVER CON'T ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        ; modified 10/8/1999 to fix problem with reply text tab conversion
%FORWARD(CWDATA,CWINPUT,CWTEXT) ;
        ;Input:  1st Piece of CWINPUT holds IEN of Message
        ;        CWTEXT holds recipient list
        ;
        N XMZ,XMY,CWLP,CWSDATA,CWSEDATA,CWTMP,CWFILE,CWIEN,CWNAM,XMINSTR,CWMSG
        N XMKZA
        S XMZ=$P(CWINPUT,";")
        S CWDATA(1)="0^^AN ERROR HAS OCCURRED"
        G:'$G(XMZ) FOREND
        S CWSDATA=$G(CWTEXT(-9902),"[START DATA]"),CWSEDATA=$G(CWTEXT(-9903),"[END DATA]")
        S CWLP=-1 D FNDLP(.CWLP,CWSDATA)
        G:$G(CWLP)="" FOREND
        F  S CWLP=$O(CWTEXT(CWLP)) Q:CWLP=""  Q:CWTEXT(CWLP)=CWSEDATA  D
        .S CWTMP=$G(CWTEXT(CWLP)) Q:CWTMP=""
        .S CWFILE=+$P(CWTMP,"^"),CWIEN=+$P(CWTMP,"^",2),CWNAM=$P(CWTMP,"^",3)
        .I CWFILE=200 S XMY(CWIEN)=""
        .E  I CWFILE=3.8 S XMY("G."_CWNAM)=""
        .E  S XMY(CWNAM)=""
        I $D(XMY) D
        . S XMKZA(XMZ)=""
        . D FWDMSG^XMXAPI(XMDUZ,"",.XMKZA,.XMY,.XMINSTR,.CWMSG)
        ;RETURNS <number of messages> forwarded.
        S CWDATA(1)=+CWMSG_U_U_XMZ   ;FORCE TO SUCCESS
FOREND  Q
        ;
%TERMIN(CWDATA,CWINPUT) ;TERMINATE A MESSAGE THREAD
        ;Input:  1st piece = IEN of Message
        ;        2nd piece = IEN of Mail Basket
        ;
        N XMRC,XMZ,XMK,Y,CWMSGNM,CWMSGR
        S CWDATA(1)="0^^AN ERROR HAS OCCURRED"
        S XMZ=$P($G(CWINPUT),";"),XMK=$P($G(CWINPUT),";",2)
        S CWMSGNM(XMZ)=""
        D TERMMSG^XMXAPI(XMDUZ,"",.CWMSGNM,.CWMSGR)
        ;RETURNS <number of messages> terminated.
        S CWDATA(1)=+CWMSGR_U_U   ;return 1 for success or 0
        Q
FNDLP(CWLP,X)   ;FIND A CHARACTER STRING ENTRY
        F  S CWLP=$O(CWTEXT(CWLP)) Q:CWLP=""  Q:CWTEXT(CWLP)=X
        Q
        ;
INCNT(CWCNT)    ;INCREMENT COUNTER
        Q CWCNT+1
        ;
%CREATE(DATA,INPUT,TEXT)        ;CREATE A NEW MESSAGE
        ;BUILD RETURN CODES FOR ERROR MESSAGING
        D %CREATE^CWMAIL2
        Q
        ;
%REPLY(CWDATA,CWINPUT,CWTEXT)   ; This API uses global array for text
        ;INPUT -  Piece  1   : Message Number
        ;         Piece  2-4 : Not Used
        ;         Piece  5   : Network Reply Flag (0 = no; 1 = yes)
        ;
        N CWMSGN,CWRESULT,CWSDATA,CWSEDATA,CWTMP,CWNWCHK,CWDATT
        N CWMSGT,XMZR,CWLP,XMINSTR
        S CWMSGN=$P(CWINPUT,";")
        S CWNWCHK=$P(CWINPUT,";",5)
        S CWDATA(1)="0^UNDEFINED ERROR"
        S CWTEXT=$NA(^TMP($J,"CWMAILLOAD"))
        G:'$G(CWMSGN) REPEND
        S CWSDATA=$G(@CWTEXT@(-9900),"[START DATA]"),CWSEDATA=$G(@CWTEXT@(-9901),"[END DATA]")
        S CWLP=-1 D GFNDLP(.CWLP,CWSDATA)
        G:$G(CWLP)="" REPEND
        F  S CWLP=$O(@CWTEXT@(CWLP)) Q:CWLP=""  Q:@CWTEXT@(CWLP)=CWSEDATA  D
        .S ^TMP($J,"CWMAILOUT",CWLP)=$G(@CWTEXT@(CWLP))
        G:'$D(^TMP($J,"CWMAILOUT")) REPEND
        S CWMSGT=$NA(^TMP($J,"CWMAILOUT"))
        D CNVTAB^CWMAIL2(CWMSGT)  ;convert tabs to spaces
        S XMINSTR("NET REPLY")=$S(+$G(CWNWCHK):1,1:0)
        D REPLYMSG^XMXAPI(XMDUZ,"",CWMSGN,CWMSGT,.XMINSTR,.XMZR)
        I +$G(XMZR)>0 S CWDATA(1)=$S(CWNWCHK:2,1:1)_"^NO ERRORS"_U_CWMSGN   ;SUCCESS
        E  S CWDATA(1)="0^"_$G(CWDATA)_U_CWMSGN   ;RETURN ERROR MESSAGE
REPEND  K ^TMP($J,"CWMAILLOAD"),^TMP($J,"CWMAILOUT")
        Q
GFNDLP(CWLP,X)  ;FIND A CHARACTER STRING ENTRY IN GLOBAL
        F  S CWLP=$O(@CWTEXT@(CWLP)) Q:CWLP=""  Q:@CWTEXT@(CWLP)=X
        Q
        ;
%ANSWER(CWDATA,CWINPUT,CWTEXT)  ; This API uses global array for text to answer a message
        ;INPUT -  CWINPUT : Piece  1   : Message Number
        ;                   Piece  2   : Not Used
        ;                   Piece  3   : Message Attributes
        ;                   Pieces 4-5 : Not Used
        ;         CWTEXT :  Holds list of additional recipients
        ;
        N CWSDATA,CWSEDATA,CWLP,CWTXTARY,DA,DIE,DR,Y,XMTEXT
        N CWMSGABS,CWTMP,CWFILE,CWIEN,CWNAM
        N XMBODY,CWMSGN,XMY,XMZ,XMINSTR
        S CWMSGN=$P(CWINPUT,";")  ;MESSAGE NUMBER
        I $G(CWMSGN)<1 S CWDATA(1)="0^98- No message number given" G ANSEND
        S CWDATA(1)="0^99- UNDEFINED ERROR"
        ;TEXT ARRAY CONTAINS RECIPIENT LIST AND MESSAGE TEXT LOADED FROM BMSGD call
        ;BUILD XMY ARRAY
        S CWTEXT=$NA(^TMP($J,"CWMAILLOAD"))
        S CWSDATA=$G(@CWTEXT@(-9902),"[START XMY]"),CWSEDATA=$G(@CWTEXT@(-9903),"[END XMY]")
        S CWLP=-1 D GFNDLP^CWMAILB(.CWLP,CWSDATA)
        ;RETRIEVE RECIPIENTS
        I $G(CWLP)'="" D
        . F  S CWLP=$O(@CWTEXT@(CWLP)) Q:CWLP=""  Q:@CWTEXT@(CWLP)=CWSEDATA  D
        . . S CWTMP=$G(@CWTEXT@(CWLP)) Q:CWTMP=""
        . . S CWFILE=+$P(CWTMP,"^"),CWIEN=+$P(CWTMP,"^",2),CWNAM=$P(CWTMP,"^",3)
        . . I CWFILE=200 S XMY(CWIEN)=""
        . . E  I CWFILE=3.8 S XMY("G."_CWNAM)=""
        . . E  S XMY(CWNAM)=""  ;treat address as internet address
        ;BUILD MESSAGE @TEXT@ ARRAY
        S CWSDATA=$G(@CWTEXT@(-9900),"[START DATA]"),CWSEDATA=$G(@CWTEXT@(-9901),"[END DATA]")
        S CWLP=-1 D GFNDLP^CWMAILB(.CWLP,CWSDATA)
        I $G(CWLP)="" S CWDATA(1)="0^3- NO MESSAGE TEXT" G ANSEND
        F  S CWLP=$O(@CWTEXT@(CWLP)) Q:CWLP=""  Q:@CWTEXT@(CWLP)=CWSEDATA  D
        .S ^TMP($J,"CWMAILOUT",CWLP)=$G(@CWTEXT@(CWLP))
        ;I '$D(^TMP($J,"CWMAILOUT")) S CWDATA(1)="0^3- NO MESSAGE TEXT" G ANSEND   ;NO MESSAGE @CWTEXT@
        ;I '$L($P($G(CWINPUT),";")) S CWDATA(1)="0^4- MESSAGE SUBJECT NOT GIVEN" G ANSEND
        ;E  S XMSUBJ=$P($G(CWINPUT),";")
        ;PROCESS MESSAGE
        S XMBODY=$NA(^TMP($J,"CWMAILOUT"))
        S XMINSTR("FLAGS")=$P(CWINPUT,";",3)  ;GET MESSAGE ATTRIBUTES
        D ANSRMSG^XMXAPI(XMDUZ,"",CWMSGN,"",XMBODY,.XMY,.XMINSTR,.XMZ)
        I $G(XMZ)<1 S CWDATA(1)="0^5- MESSAGE ANSWER FAILED" G ANSEND
        I +$G(XMZ)>0 S CWDATA(1)="1^^"_$G(XMZ)
ANSEND  K ^TMP($J,"CWMAILOUT"),^TMP($J,"CWMAILLOAD")
        Q
