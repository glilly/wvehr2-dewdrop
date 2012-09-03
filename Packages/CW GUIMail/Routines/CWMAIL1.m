CWMAIL1 ;INDPLS/PLS- GUI MAIL UTILITIES ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        ;MODIFIED FOR XM*7.1*50
LATER(CWXMZ,CWXMA)      ;LATER A MESSAGE
        S $ZT="LATERE^CWMAIL1"
        N CWFLG,X,Y,%H,NOW,CWINSTR,CWXMMSG,CWTMDF
        S CWFLG=0
        G:'CWXMZ!('$G(CWXMA)) LATERE
        ;S CWTMDF=$G(^XMB("TIMEDIFF"))  ;get time diff for site
        ;I CWXMA[":" D
        ;. I '$L(CWTMDF) S CWXMA=$P(CWXMA," ")  ;use date and not date/time
        ;. E  S CWXMA=CWXMA_" "_CWTMDF  ;append time zone diff
        S CWXMA=$$CONVERT^XMXUTIL1(CWXMA,$S(CWXMA[":":1,1:0))  ;convert to fileman date/time
CK      S NOW=$$NOW^XLFDT S CWXMA=$S(CWXMA>NOW:CWXMA,1:(NOW+.0010))  ;DEFAULT TO 10 MINUTES IN FUTURE
        I CWXMA>0 D
        . S CWINSTR("LATER")=CWXMA
        . D LATERMSG^XMXAPI(XMDUZ,"",CWXMZ,.CWINSTR,.CWXMMSG)
        . I CWXMMSG S CWFLG=1
LATERE  ;
        Q CWFLG
        ;
        ;
NETINFO(CWDAT,XMZ)      ;RETRIEVE NETWORK TRANMISSION INFORMATION
        ;
        K CWDAT
        S CWDAT=$NA(^TMP($J,"CWMAIL"))
        S $ZT="NETINFOE^CWMAIL1"
        N CWLP,CWCNT
        S CWLP=0,CWCNT=2
        D QN^XMXUTIL3(XMZ,,,)  ;DEFAULTS TO ALL LINES;START AT 0 AND SET TO ^TMP("XMLIST",$J)
        F  S CWLP=$O(^TMP("XMLIST",$J,CWLP)) Q:CWLP<1  D
        . S @CWDAT@(CWCNT)=^TMP("XMLIST",$J,CWLP),CWCNT=CWCNT+1
NETINFOE        ;
        I $O(@CWDAT@(1)) D
        . S @CWDAT@(1)="1^^DATA HAS BEEN FOUND"
        E  S @CWDAT@(1)="1^^There was no Transmission Information available."
        S $P(@CWDAT@(1),U,2)=CWCNT-2
        Q
        ;
ADRSTO(CWDAT,XMZ)       ;RETRIEVE ADDRESSED TO INFO
        ;
        K CWDAT
        S CWDAT=$NA(^TMP($J,"CWMAIL"))
        N CWLP,CWCNT
        S CWLP=0,CWCNT=2
        D Q^XMXUTIL3(XMZ)  ;DEFAULTS TO ALL LINES;START AT 0 AND SET TO ^TMP("XMLIST",$J)
        F  S CWLP=$O(^TMP("XMLIST",$J,CWLP)) Q:CWLP<1  D
        . S @CWDAT@(CWCNT)=$G(^TMP("XMLIST",$J,CWLP,"TO NAME")),CWCNT=CWCNT+1
        I $O(@CWDAT@(1)) D
        . S @CWDAT@(1)="1^^DATA HAS BEEN FOUND"
        E  S @CWDAT@(1)="1^^There was no ADDRESSED TO recipients found."
        S $P(@CWDAT@(1),U,2)=CWCNT-2
ADRSTOE Q
        ;
RECPT(CWDAT,XMZ)        ;BUILD RECIPIENT LIST
        K CWDAT
        S CWDAT=$NA(^TMP($J,"CWMAIL"))
        N CWLP,CWCNT,CWIM,CWIU,CWINSTR
        N CWRECPT,CWLR,CWLRSPRD,CWFR,CWFWD,CWTERM,CWRMI,CWNTT,CWSNT
        S CWLP=0,CWCNT=2
        D QD^XMXUTIL3(XMZ)  ;
        F  S CWLP=$O(^TMP("XMLIST",$J,CWLP)) Q:CWLP<1  D
        . S CWRECPT=$G(^TMP("XMLIST",$J,CWLP,"TO NAME"))  ;recipient name
        . S CWLR=$$FMDTE^CWMAIL4($G(^("LREAD")),"5MZ")  ;last read date/time
        . S CWLRSPRD=$G(^("RESP"))                      ;last response read
        . S CWFR=$$FMDTE^CWMAIL4($G(^("FREAD")),"5MZ")  ;first read date/time
        . S CWFWD=$S($D(^("FWD ON")):"*",1:"")          ;forwarded message
        . S CWTERM=$S($D(^("TERM")):"*",1:"")           ;terminated message
        . S CWRMI=$G(^("ID"))                           ;remote message id
        . S CWNTT=$G(^("SECS"))                         ;network trans time
        . S CWSNT=$$FMDTE^CWMAIL4($G(^("XDATE")),"5MZ") ;network sent date/time
        . S @CWDAT@(CWCNT)=U_CWRECPT_U_CWLR_U_CWFR_U_CWFWD_U_CWTERM_U_CWRMI_U_CWNTT_U_CWSNT_U_CWLRSPRD_U
        . S CWCNT=CWCNT+1
        D INMSG1^XMXUTIL2(XMDUZ,XMZ,,"F",.CWIM,.CWIU)   ;retrieve total recipients
        D INMSG2^XMXUTIL2(XMDUZ,XMZ,,.CWIM,.CWINSTR,.CWIU)  ;and responses.
RECPTE  I $O(@CWDAT@(1)) D
        . S @CWDAT@(1)="1^^DATA HAS BEEN FOUND"_U_+$G(CWIM("RECIPS"))_U_+$G(CWIM("RESPS"))
        E  S @CWDAT@(1)="1^^There were no recipients found."_U_0_U_0
        S $P(@CWDAT@(1),U,2)=CWCNT-2
        Q
