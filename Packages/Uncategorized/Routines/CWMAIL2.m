CWMAIL2 ;INDPLS/PLS- DELPHI VISTA MAIL SERVER, CONT'D ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        ;Input - CWINPUT : 1 - Subject
        ;                : 2 - Flags
        ;                : 3 - Attachment Flag
        ;
        Q   ;ROUTINE CAN'T BE CALLED DIRECTLY
%CREATE(CWDATA,CWINPUT,CWTEXT)  ;CREATE A NEW MESSAGE
        N CWSDATA,CWSEDATA,CWLP,CWTXTARY,DA,DIE,DR,Y,XMTEXT,CWMSGABS,CWTMP,CWFILE,CWIEN,CWNAM
        N XMBODY,XMSUBJ,XMY,XMINSTR,XMZ
        S CWDATA(1)="0^99- UNDEFINED ERROR"
        ;INPUT CONTAINS SUBJECT;PARAMETER ARRAY (IE. TESTING API;PCSI
        ;P=PRIORITY, X=CLOSED, C=CONFIDENTIAL, I=INFORMATIONAL, R=CONFIRMATION
        ;TEXT ARRAY CONTAINS RECIPIENT LIST AND MESSAGE TEXT LOADED FROM BMSGD call
        ;BUILD XMY ARRAY
        S CWTEXT=$NA(^TMP($J,"CWMAILLOAD"))
        S CWSDATA=$G(@CWTEXT@(-9902),"[START XMY]"),CWSEDATA=$G(@CWTEXT@(-9903),"[END XMY]")
        S CWLP=-1 D GFNDLP^CWMAILB(.CWLP,CWSDATA)
        I $G(CWLP)="" S CWDATA(1)="0^1- NO RECIPIENTS LISTED" G CRTEND
        ;RETRIEVE RECIPIENTS
        F  S CWLP=$O(@CWTEXT@(CWLP)) Q:CWLP=""  Q:@CWTEXT@(CWLP)=CWSEDATA  D
        .S CWTMP=$G(@CWTEXT@(CWLP)) Q:CWTMP=""
        .S CWFILE=+$P(CWTMP,"^"),CWIEN=+$P(CWTMP,"^",2),CWNAM=$P(CWTMP,"^",3)
        .I CWFILE=200 S XMY(CWIEN)=""
        .E  I CWFILE=3.8 S XMY("G."_CWNAM)=""
        .E  S XMY(CWNAM)=""
        I '$D(XMY) S CWDATA(1)="0^1- NO RECIPIENTS LISTED" G CRTEND  ; NO RECIPIENTS LISTED
        ;BUILD MESSAGE @TEXT@ ARRAY
        S CWSDATA=$G(@CWTEXT@(-9900),"[START DATA]"),CWSEDATA=$G(@CWTEXT@(-9901),"[END DATA]")
        S CWLP=-1 D GFNDLP^CWMAILB(.CWLP,CWSDATA)
        I $G(CWLP)="" S CWDATA(1)="0^3- NO MESSAGE TEXT" G CRTEND
        F  S CWLP=$O(@CWTEXT@(CWLP)) Q:CWLP=""  Q:@CWTEXT@(CWLP)=CWSEDATA  D
        .S ^TMP($J,"CWMAILOUT",CWLP)=$G(@CWTEXT@(CWLP))
        I '$D(^TMP($J,"CWMAILOUT")) S CWDATA(1)="0^3- NO MESSAGE TEXT" G CRTEND   ;NO MESSAGE @CWTEXT@
        ;I '$L($P($G(CWINPUT),";")) S CWDATA(1)="0^4- MESSAGE SUBJECT NOT GIVEN" G CRTEND
        ;E
        S XMSUBJ=$P($G(CWINPUT),";")
        ;subject can be null or between 3-65 characters. Length is handled on client side.
        I $L(XMSUBJ),$L(XMSUBJ)<3 S XMSUBJ=XMSUBJ_$E("__",1,3-$L(XMSUBJ))
        ;PROCESS MESSAGE
        S XMBODY=$NA(^TMP($J,"CWMAILOUT"))
        D CNVTAB(XMBODY)  ;convert tabs to spaces
        S XMINSTR("FLAGS")=$P(CWINPUT,";",2)  ;GET MESSAGE ATTRIBUTES
        I '$P($G(CWINPUT),";",3) D
        . D SENDMSG^XMXAPI(XMDUZ,XMSUBJ,XMBODY,.XMY,.XMINSTR,.XMZ)
        E  D
        . D CRE8XMZ^XMXAPI(XMSUBJ,.XMZ)  ;create message stub
        . I +$G(XMZ) D
        . . D TEXT^XMXEDIT(XMZ,XMBODY)  ;stuff message text
        . . D BLDNETI(XMZ,XMSUBJ)  ;stuff network header information
        . . D ADDRNSND^XMXAPI(XMDUZ,XMZ,.XMY,.XMINSTR)  ;send message
        I +$G(XMZ)<1 S CWDATA(1)="0^5- MESSAGE CREATION FAILED" G CRTEND
        I +$G(XMZ)>0 S CWDATA(1)="1^^"_$G(XMZ)
CRTEND  K ^TMP($J,"CWMAILOUT"),^TMP($J,"CWMAILLOAD")
        Q
CNVTAB(CWSRC)   ;Convert TABS to spaces (use 6 char per tab)
        ;PASS $NA() VARIABLE NAME CONTAINING DATA
        N CWLP,CWLINE
        S CWLP=+$G(CWLP)
        F  S CWLP=$O(@CWSRC@(CWLP)) Q:CWLP=""  D
        . S CWLINE=@CWSRC@(CWLP)
        . S @CWSRC@(CWLP)=$$LNCNV(CWLINE)
        Q
LNCNV(CWL)      ; data line tab extracter
        N CWTMP,CWTMPL,CWP,CWPR,CWPADL
        Q:'$F(CWL,$C(9)) CWL  ; no tabs to convert
        S CWTMP=CWL,CWTMPL=""
        F  D  Q:CWTMP'[$C(9)
        . S CWP=$P(CWTMP,$C(9)) ; left portion of string
        . S CWPR=$P(CWTMP,$C(9),2,999) ; remainder of string
        . S CWPADL=6-($L(CWP)#6)    ; pad length
        . I ($L(CWP)+CWPADL+$L(CWPR))>250 Q  ;line is to long
        . S CWTMP=CWP_$$REPEAT^XLFSTR(" ",CWPADL)_CWPR
        Q CWTMP
        ;
BLDNETI(CWXMZ,CWSUBJ)   ;build network header information
        ;From: <user@domain>
        ;Subject:
        ;Date: 9 Jul 1999 09:02:27 -0500 (EST)
        ;X-Mailer: VISTA Mail
        N CWCNT
        I $L($$ZNODE^XMXUTIL2(CWXMZ)) D
        . S ^XMB(3.9,CWXMZ,2,.001,0)="From: "_$$LOW^XLFSTR($G(XMV("NETNAME")))
        . ;S ^XMB(3.9,CWXMZ,2,.002,0)="To:"  ;refet to bldnetit api
        . S ^XMB(3.9,CWXMZ,2,.003,0)="Subject: "_$G(CWSUBJ)
        . S ^XMB(3.9,CWXMZ,2,.004,0)="Date:"_$$INDT^XMXUTIL1($$NOW^XLFDT)
        . S ^XMB(3.9,CWXMZ,2,.005,0)="X-Mailer: Vista GuiMail"  ;VISTA MAIL"
        . S ^XMB(3.9,CWXMZ,2,.006,0)="Encoding: x-uuencode"  ;X-UUENCODE"
        . S CWCNT=.007
        . D BLDNETIT(CWXMZ,.XMY,.CWCNT)
        Q
BLDNETIT(CWXMZ,CWXMY,CWCTN)     ; build To: section
        ;Input - CWXMZ - Message Number
        ;        CWXMY - Array of Recipients
        ;        CWCTN - Counter
        ;
        N LP,CWINSTR,CWFULL,CWSET,CWTO,CWTO1,CWRHDR
        K ^TMP($J,"CWNETH")
        S CWINSTR("ADDR FLAGS")="RX"
        S CWFLG=0,CWTO="To: ",CWTO1="    ",CWRHDR=""
        S LP="" F  S LP=$O(CWXMY(LP)) Q:LP=""  D
        . D TOWHOM^XMXAPI(XMDUZ,,"S",LP,.CWINSTR,.CWFULL)
        . I $L($G(CWFULL)) D
        . . I CWFULL'["@" D
        . . .S CWFULL=$TR(CWFULL,", .","._+")  ; set internet naming convention
        . . .S CWFULL=CWFULL_"@"_$G(^XMB("NETNAME"))
        . . I ($L(CWRHDR)+$L(CWFULL)+1)<140 D  ;line not full
        . . . S CWRHDR=CWRHDR_$S($L(CWRHDR)>0&($E(CWRHDR,$L(CWRHDR))'=","):",",1:"")_CWFULL
        . . E  D
        . . . S ^TMP($J,"CWNETH",CWCTN)=CWRHDR
        . . . S CWCTN=CWCTN+.001
        . . . S CWRHDR=CWFULL
        I $L(CWRHDR) S ^TMP($J,"CWNETH",CWCTN)=CWRHDR  ;set remaining data
        S LP=0 F  S LP=$O(^TMP($J,"CWNETH",LP)) Q:LP<.001  D
        . S ^XMB(3.9,CWXMZ,2,LP,0)=$S(CWFLG:"   "_^TMP($J,"CWNETH",LP),1:"To: "_^TMP($J,"CWNETH",LP))
        K ^TMP($J,"CWNETH")  ;KILL TEMP GLOBAL BUFFER
        Q
