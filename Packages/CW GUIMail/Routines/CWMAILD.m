CWMAILD ;INDPLS/PLS- DELPHI VISTA MAIL SERVER CONT'D ;22-Jul-2005 07:10;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        Q   ;ROUTINE CAN'T BE CALLED DIRECTLY
        ;
%BMSGD(CWDATA,CWINPUT,CWTEXT)   ;BUILD MESSAGE DATA INTO GLOBAL
        ;USE CREATE OR REPLY TO SEND ACTUAL MESSAGE OR REPLY
        M ^TMP($J,"CWMAILLOAD")=CWTEXT
        S CWDATA(1)="1^1^DATA SET"
BMSGDE  Q
        ;
%PERPREF(CWDATA,CWPARAM)        ;retrieve personal preferences
        ;CWPARAM is not used
        N CWNAME,CWCNT
        S CWCNT=2
        S CWDATA(1)="0^^AN ERROR HAS OCCURRED"
        I $$GETPKPM^CWMAILE(.CWDATA) D
        .S CWCNT=$G(CWDATA(-9900))
        .K CWDATA(-9900)
        .S CWDATA(1)="1^1^Preferences have been retrieved"
        E  S CWDATA(1)="0^0^Unable to retrieve preferences"
        S $P(CWDATA(1),U,2)=CWCNT-2
PERPREFE        Q
        ;
%USRLOG(CWDATA,DUZ)     ;SET-UP USER PARTITION
        ;
        I +DUZ>0 D
        . N XMDISPI,XMDUN,XMDUZ,CWNAME,CWNKNM,CWNMAIL,CWPMAIL
        . S CWNKNM=$P($G(^VA(200,DUZ,.1)),U,4)
        . D INIT^XMVVITAE
        . S CWNMAIL=+$P($G(^XMB(3.7,DUZ,0)),U,6)
        . S CWDATA(1)="1^"
        . S $P(CWDATA(1),U,2)=XMV("DUZ NAME")  ; SET USER NAME
        . S $P(CWDATA(1),U,3)=CWNKNM  ;SET USER NICKNAME
        . S $P(CWDATA(1),U,4)=XMV("NEW MSGS")  ;SET # OF NEW MSGS
        . S $P(CWDATA(1),U,5)=$G(XMV("WARNING",1))="Priority Mail"  ;SET PRIORITY MAIL FLAG
        . S $P(CWDATA(1),U,6)=$P($G(XMV("NETNAME")),"@",2)  ;get domain name for mail server
        . S $P(CWDATA(1),U,7)=$S($P($G(^VA(200,DUZ,200)),U,10)>0:$P($G(^VA(200,DUZ,200)),U,10),1:300)  ;Timed read used for GuiMail timeout. -clc
        ;$G(^XMB("NETNAME"))  ;get domain name for mail server
        E  S CWDATA(1)="0^USER NOT FOUND"
USRLOGE Q
%CHKMAIL(CWDATA,DUZ)    ;CHECK FOR NEW MAIL
        ;
        N CWPMAIL,CWNMAIL,CWDAT
        I +DUZ>0 D
        . S CWDAT=$$NEWS^XMXUTIL(DUZ)  ;FORMAT #NEWMSGS^PRIORITY^#NMSGIN^DT LAST MSG^
        . S CWDATA(1)="1^"_U_U_+CWDAT_U_+$P(CWDAT,U,2)
        E  S CWDATA(1)="0^USER NOT FOUND"
CHKMAILE        Q
        ;
%PRTMSG(CWDATA,CWINPUT) ;PRINT A MESSAGE
        ; CWINPUT  - 1st piece:  XMZ message number
        ;          2nd piece:  XMK message basket number
        ;          3rd piece:  Print from response number 0=all
        ;          4th piece:  null = no recpts 0=summary; 1=detail
        ;          5th piece:  printer name
        ;          6th piece:  1=header, 0=headerless
        N XMZ,XMK,XMKN
        N XMINSTR,CWDAT1,CWDAT2,CWRESP,CWRECP,CWPRTN,XMMSG,XMTASK
        S XMZ=+$P(CWINPUT,";")
        S CWRESP=$P(CWINPUT,";",3)
        S CWRECP=$P(CWINPUT,";",4),CWRECP=$S($L(CWRECP):+CWRECP,1:-1)
        S CWPRTN=$P(CWINPUT,";",5)
        ;D INMSG1^XMXUTIL2(XMDUZ,XMZ,,.CWDAT1,.CWDAT2)  ;GET # OF RESPONSES - NOT CURRENTLY NEEDED
        S XMINSTR("HDR")=$S('$L($P(CWINPUT,";",6)):1,1:+$P(CWINPUT,";",6))  ;DEFAULT TO PRINTING HEADER
        S XMINSTR("RESPS")=$S(+CWRESP:+CWRESP_"-",1:"*")  ;DEFINE RANGE TO PRINT +$G((CWDAT("RESPS"))) HOLDS TOTAL # OF RESPONSES
        I CWRECP>-1 D
        . S XMINSTR("RECIPS")=$S(+CWRECP:2,1:1)  ;CONVERT CWMA TO XM NOMENCLATURE
        E  S XMINSTR("RECIPS")=0   ;Don't print recipient list
        D:$L($G(CWPRTN)) PRTMSG^XMXAPI(XMDUZ,,XMZ,CWPRTN,.XMINSTR,,.XMTASK)
        I +$G(XMTASK) S CWDATA(1)="1^1^"_$G(XMTASK)
        E  S CWDATA(1)="1^0^Message could not be printed"
PRTMSGE Q
        ;
%SUPREF(CWDATA,CWINPUT,CWTEXT)  ;Set user preferences
        ;
        N CWSDATA,CWSEDATA,CWLP
        N CWPRM,CWVAL,CWLP1,CWERR
        S CWDATA(1)="0^^AN ERROR HAS OCCURRED"
        S CWSDATA=$G(CWTEXT(-9902),"[START DATA]"),CWSEDATA=$G(CWTEXT(-9903),"[END DATA]")
        S CWLP=-1 D FNDLP^CWMAILB(.CWLP,CWSDATA)
        G:$G(CWLP)="" SUPREND
        F  S CWLP=$O(CWTEXT(CWLP)) Q:CWLP=""  Q:CWTEXT(CWLP)=CWSEDATA  D
        . I CWTEXT(CWLP)'?1"[".E1"]" D
        . . S CWPRM=$$GETPRM^CWMAILE($P(CWTEXT(CWLP),"="))   ;get parameter
        . . I $L(CWPRM) D
        . . . S CWVAL=$P(CWTEXT(CWLP),"=",2)                 ;get value
        . . . S CWERR=$$SETPARM(XMDUZ,CWPRM,CWVAL)                 ;set value into parameter
        S CWDATA(1)="1^1^Preferences have been stored"
SUPREND Q
        ;
SETPARM(CWDUZ,CWPARM,CWVALUE)   ;Set value into parameter instance
        ;Input:  CWPARM  - holds the return value of $$GETPRM^CWMAILE
        ;        CWVALUE - value to stuff (single value or comma delimited string)
        ;        CWDUZ - user
        Q:'CWDUZ 1 ;must have a valid user
        K CWERR
        I 'CWPARM D                     ;single instance
        . D EN^XPAR("USR.`"_CWDUZ,$P(CWPARM,"|",2),1,CWVALUE,.CWERR)
        E  D                            ;multiple instances
        . N CWLP,CWX,CWXA
        . S CWX=CWVALUE,CWLP=0
        . F  Q:$L(CWX,";")<(CWLP+1)  D
        . . S CWLP=CWLP+1
        . . S CWXA=$P(CWX,";",CWLP)  ;CWXA holds the column,width pair
        . . D EN^XPAR("USR.`"_CWDUZ,$P(CWPARM,"|",2),CWLP,CWXA,.CWERR)  ;stuff value
        Q CWERR
        ;
%GETSVER(CWDATA,CWPARAM)        ;GET SERVER VERSION
        S CWDATA(1)="1^1^"_+$$VERSION^XPDUTL("CWMA")
        Q
%OPENATT(CWDATA,CWPARAM)        ;OPEN ATTACHMENTS
        N X
        S X=$$GET^XPAR("ALL","CWMA ALLOW ATTACHMENTS OPEN")
        S CWDATA(1)="1^1^"_$S(X=0:X,1:1)
        Q
%TIMEROF(CWDATA,CWPARAM)        ;DISABLE TIMER
        N X
        S X=$$GET^XPAR("ALL","CWMA DISABLE GUIMAIL TIMEOUT")
        S CWDATA(1)="1^1^"_$S(X=0:X,1:1)
        Q
TIMERVAL(CWDATA,CWPARAM)        ;TIMEOUT VALUE
        N X
        S X=$$GET^XPAR("ALL","CWMA GUIMAIL TIMEOUT VALUE")
        S CWDATA(1)="1^1^"_$S(X>0:X,1:0)
        Q
