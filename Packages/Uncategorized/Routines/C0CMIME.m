C0CMIME ; CCDCCR/GPL - MIME manipulation utilities; 3/8/11 ; 5/16/11 2:32pm
 ;;1.0;C0C;;Mar 8, 2011;Build 2
 ;Copyright 2008 George Lilly.  Licensed under the terms of the GNU
 ;General Public License See attached copy of the License.
 ;
 ;This program is free software; you can redistribute it and/or modify
 ;it under the terms of the GNU General Public License as published by
 ;the Free Software Foundation; either version 2 of the License, or
 ;(at your option) any later version.
 ;
 ;This program is distributed in the hope that it will be useful,
 ;but WITHOUT ANY WARRANTY; without even the implied warranty of
 ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ;GNU General Public License for more details.
 ;
 ;You should have received a copy of the GNU General Public License along
 ;with this program; if not, write to the Free Software Foundation, Inc.,
 ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ;
 Q
 ;
TEST(ZDFN) ;
 D CCRRPC^C0CCCR(.ZCCR,ZDFN) ; GET A CCR TO WORK WITH
 ;M ZCOPY=ZCCR
 S ZCOPY(1)=""
 N ZI S ZI=0
 F  S ZI=$O(ZCCR(ZI)) Q:ZI=""  D  ; FOR EACH LINE
 . S ZCOPY(1)=ZCOPY(1)_ZCCR(ZI)
 ;D ENCODE("ZCOPY",1,ZCOPY(1))
 S G(1)=$$ENCODE^RGUTUU(ZCOPY(1))
 D CHUNK("G2","G",45)
 Q
ENCODE(ZRTN,ZARY) ;
 ; ROUTINE TO ENCODE AN XML DOCUMENT FOR SENDING
 ; ZARY IS PASSED BY NAME
 ; ZRTN IS PASSED BY REFERENCE AND IS THE RETURN
 ;
 S ZCOPY(1)=""
 N ZI S ZI=0
 F  S ZI=$O(@ZARY@(ZI)) Q:ZI=""  D  ; FOR EACH LINE
 . S ZCOPY(1)=ZCOPY(1)_@ZARY@(ZI)
 N G
 S G(1)=$$ENCODE^RGUTUU(ZCOPY(1))
 D CHUNK(ZRTN,"G",45)
 Q
 ; THIS ROUTINE WAS COPIED FROM LRSRVR4 AND THEN MODIFIED . THANKS JOHN
ENCODEOLD(IARY,LRNODE,LRSTR) ; Encode a string, keep remainder for next line
 ; Call with LRSTR by reference, Remainder returned in LRSTR
 ; IARY IS PASSED BY NAME
 S LRQUIT=0,LRLEN=$L(LRSTR)
 F  D  Q:LRQUIT
 . I $L(LRSTR)<45 S LRQUIT=1 Q
 . S LRX=$E(LRSTR,1,45)
 . S LRNODE=LRNODE+1,@IARY@(LRNODE)=$$UUEN^LRSRVR4(LRX)
 . S LRSTR=$E(LRSTR,46,LRLEN)
 Q
 ;
TESTMAIL ;
 ; TEST OF MAILSEND
 ;S ZTO("glilly@glilly.net")=""
 S ZTO("mish@nhin.openforum.opensourcevista.net")=""
 ;S ZTO("martijn@djigzo.com")=""
 ;S ZTO("profmish@gmail.com")=""
 ;S ZTO("nanthracite@earthlink.net")=""
 S ZFROM="ANTHRACITE.NANCY"
 S ZATTACH=$NA(^GPL("CCR"))
 I $G(@ZATTACH@(1))="" D  ; NO CCR THERE
 . D CCRRPC^C0CCCR(.GPL,2) ; GET ONE FROM PATIENT 2
 . M @ZATTACH=GPL ; PUT IT IN THERE FOR NEXT TIME
 S ZSUBJECT="TEST OF THE NEW MAILSEND ROUTINE"
 D MAILSEND(.GR,ZFROM,"ZTO",,ZSUBJECT,,ZATTACH)
 ZWR GR
 Q
 ;
TESTMAIL2 ;
 ; TEST OF MAILSEND TO gpl.mdc-crew.net
 N C0CGM
 S C0CGM(1)="This is a test message."
 S C0CGM(2)="A Continuity of Care record is attached"
 S C0CGM(3)="It contains no Protected Health Information (PHI)"
 S C0CGM(4)="It is purely test data used for software development"
 S C0CGM(5)="It does not represent information about any person living or dead"
 ;S ZTO("glilly@glilly.net")=""
 ;S ZTO("george.lilly@pobox.com")=""
 ;S ZTO("george@nhin.openforum.opensourcevista.net")=""
 ;S ZTO("mish@nhin.openforum.opensourcevista.net")=""
 S ZTO("brooks.richard@securemail.opensourcevista.net")=""
 ;S ZTO("LILLY.GEORGE@mdc-crew.net")=""
 ;S ZTO("ncoal@live.com")=""
 ;S ZTO("martijn@djigzo.com")=""
 ;S ZTO("profmish@gmail.com")=""
 ;S ZTO("nanthracite@earthlink.net")=""
 S ZTO("gpl.doctortest@gmail.com")=""
 S ZFROM="LILLY.GEORGE"
 S ZATTACH=$NA(^GPL("CCR"))
 I $G(@ZATTACH@(1))="" D  ; NO CCR THERE
 . D CCRRPC^C0CCCR(.GPL,2) ; GET ONE FROM PATIENT 2
 . M @ZATTACH=GPL ; PUT IT IN THERE FOR NEXT TIME
 S ZSUBJECT="TEST OF THE NEW MAILSEND ROUTINE"
 D MAILSEND(.GR,ZFROM,"ZTO",,ZSUBJECT,"C0CGM",ZATTACH,"CCR.xml")
 ZWR GR
 Q
 ;
LINE(C0CFILE,C0CTO) ; read a file name passed in C0CFILE and send it to
 ; the email address in C0CTO
 ; the directory and the "from" are all hard coded
 ;
 N ZZFROM S ZZFROM="LILLY.GEORGE"
 N GN S GN=$NA(^TMP("C0CMIME2",$J))
 N GN1 S GN1=$NA(@GN@(1))
 K @GN
 I '$D(C0CFILE) Q  ; NO FILENAME PASSED
 I '$D(C0CTO) S C0CTO="brooks.richard@securemail.opensourcevista.net"
 S ZZTO(C0CTO)=""
 N ZMESS S ZMESS(1)="file transmission from wvehr3-09"
 N GD S GD="/home/wvehr3-09/EHR/" ; directory
 I '$$FTG^%ZISH(GD,C0CFILE,GN1,3) Q  D  ;
 . W !,"error reading file",C0CFILE
 D MAILSEND(.ZRTN,ZZFROM,"ZZTO",,"file transmission","ZMESS",GN,C0CFILE)
 K @GN ; CLEAN UP
 ;ZWR ZRTN
 W !,$G(ZRTN(1))
 Q
 ;
MAILSEND(RTN,FROM,TO,CC,SUBJECT,MESSAGE,ATTACH,FNAME,FLAGS) ; MAIL SENDING INTERFACE
 ; RTN IS THE RETURN ARRAY PASSED BY REFERENCE
 ; FROM IS PASSED BY VALUE AND IS THE EMAIL ADDRESS OF THE SENDER
 ;  IF NULL, WILL SEND FROM THE CURRENT DUZ
 ; TO AND CC ARE RECIEPIENT EMAIL ADDRESSES PASSED BY NAME
 ;  @TO@("addr1@domain1.net")
 ;  @CC@("addr2@domain2.com")  both can be multiples
 ; SUBJECT IS PASSED BY VALUE AND WILL GO IN THE SUBJECT LINE
 ; MESSAGE IS PASSED BY NAME AND IS AN ARRAY OF TEXT
 ; ATTACH IS PASSED BY NAME AND IS AN XML OR HTML FILE TO BE ATTACHED
 ; FNAME IS THE FILENAME OF THE ATTACHMENT, DEFAULT IS ccr.xml
 ;
 I '$D(FNAME) S FNAME="ccr.xml" ; default filename
 N GN
 S GN=$NA(^TMP($J,"C0CMIME"))
 K @GN
 S GM(1)="MIME-Version: 1.0"
 S GM(2)="Content-Type: multipart/mixed; boudary=""1234567"""
 S GM(3)=""
 S GM(4)=""
 ;S GM(5)="--123456788888"
 ;S GM(5)=$$REPEAT^XLFSTR("-",$L(X))
 S GM(5)="--123456899999"
 S GM(6)="Content-Type: text/xml; name="_FNAME
 S GM(7)="Content-Transfer-Encoding: base64"
 S GM(8)="Content-Disposition: attachment; filename="_FNAME
 S GM(9)=""
 S GM(10)="" ; FOR THE END
 ;S GM(11)="--123456788888--"
 S GM(11)="--123456899999--"
 S GM(12)=""
 S GM(13)=""
 S GG(1)="--123456899999"
 S GG(2)="Content-Type: text/plain; charset=ISO-8859-1; format=flowed"
 S GG(3)="Content-Transfer-Encoding: 7bit"
 S GG(4)=""
 S GG(5)="This is a test message."
 S GG(6)="A Continuity of Care record is attached"
 S GG(7)="It contains no Protected Health Information (PHI)"
 S GG(8)="It is purely test data used for software development"
 S GG(9)="It does not represent information about any person living or dead"
 S GG(10)=""
 S GG(11)="--123456899999--"
 ;S GG(11)="Content-Type: text/plain; charset=""us-ascii"""
 S GG(12)=""
 ;S GG(13)="This is a test message."
 S GG(14)="A Continuity of Care record is attached"
 S GG(15)="It contains no Protected Health Information (PHI)"
 S GG(16)="It is purely test data used for software development"
 S GG(17)="It does not represent information about any person living or dead"
 S GG(18)=""
 S GG(19)="--123456899999"
 S GG(20)="--987654321--"
 K GBLD
 ;D QUEUE^C0CXPATH("GBLD","GGG",1,3) ; THE MESSAGE
 ;D QUEUE^C0CXPATH("GBLD","GG",1,10) ; THE MESSAGE
 I $D(MESSAGE)'="" D  ; THERE IS A MESSAGE
 . D QUEUE^C0CXPATH("GBLD","GG",1,4) ; THE MIME BOUNDARY
 . D QUEUE^C0CXPATH("GBLD",MESSAGE,1,$O(@MESSAGE@(""),-1)) ;THE MESSAGE
 . D QUEUE^C0CXPATH("GBLD","GG",10,10) ;A BLANK LINE
 D QUEUE^C0CXPATH("GBLD","GM",5,9)
 I $D(ATTACH)'="" D  ; IF WE HAVE AN ATTACHMENT
 . D ENCODE("G2",ATTACH) ; ENCODE FOR SENDING
 . D QUEUE^C0CXPATH("GBLD","G2",1,$O(G2(""),-1))
 D QUEUE^C0CXPATH("GBLD","GM",11,12)
 D BUILD^C0CXPATH("GBLD",GN)
 ;S GGG=$NA(^GPL("MIME2"))
 K @GN@(0) ; KILL THE LINE COUNT
 K LRINSTR,LRTASK,LRTO,XMERR,XMZ
 M LRTO=@TO
 I $D(CC) M LRTO=@CC
 S LRINSTR("ADDR FLAGS")="R"
 S LRINSTR("FROM")=$G(FROM)
 S LRMSUBJ=$G(SUBJECT)
 S LRMSUBJ=$E(LRMSUBJ,1,65)
 D SENDMSG^XMXAPI(DUZ,LRMSUBJ,GN,.LRTO,.LRINSTR,.LRTASK)
 I $G(XMERR)=1 S RTN(1)="ERROR SENDING MESSAGE" Q  ;
 S RTN(1)="OK"
 Q
 ;
MAILSEND0(LRMSUBJ) ; Send extract back to requestor.
 ;
 ;D TEST
 S GN=$NA(^TMP($J,"C0CMIME"))
 K @GN
 ;M @GN=G2
 S GM(1)="MIME-Version: 1.0"
 S GM(2)="Content-Type: multipart/mixed; boudary=""1234567"""
 S GM(3)=""
 S GM(4)=""
 S GM(5)="--1234567"
 ;S GM(5)=$$REPEAT^XLFSTR("-",$L(X))
 S GM(6)="Content-Type: text/xml; name=""ccr.xml"""
 S GM(7)="Content-Transfer-Encoding: base64"
 S GM(8)="Content-Disposition: attachment; filename=""ccr.xml"""
 ;S GM(6)=$$UUBEGFN^LRSRVR2A("CCR.xml")
 S GM(9)=""
 S GM(10)="" ; FOR THE END
 S GM(11)="--frontier--"
 S GM(12)="."
 S GM(13)=""
 K GBLD
 ;D QUEUE^C0CXPATH("GBLD","GM",1,9)
 ;D QUEUE^C0CXPATH("GBLD","G2",1,$O(G2(""),-1))
 ;D QUEUE^C0CXPATH("GBLD","GM",10,13)
 ;D BUILD^C0CXPATH("GBLD",GN)
 S GGG=$NA(^GPL("MIME2"))
 ;D QUEUE^C0CXPATH("GBLD","GM",1,1)
 D QUEUE^C0CXPATH("GBLD",GGG,21,159)
 D BUILD^C0CXPATH("GBLD",GN)
 K @GN@(0) ; KILL THE LINE COUNT
 K LRINSTR,LRTASK,LRTO,XMERR,XMZ
 S XQSND="glilly@glilly.net"
 ;S XQSND="nanthracite@earthlink.net"
 ;S XQSND="dlefevre@orohosp.com"
 ;S XQSND="gregwoodhouse@me.com"
 ;S XQSND="rick.marshall@vistaexpertise.net"
 S LRTO(XQSND)=""
 S LRINSTR("ADDR FLAGS")="R"
 S LRINSTR("FROM")="CCR_PACKAGE"
 S LRMSUBJ="A SAMPLE CCR"
 S LRMSUBJ=$E(LRMSUBJ,1,65)
 D SENDMSG^XMXAPI(9,LRMSUBJ,GN,.LRTO,.LRINSTR,.LRTASK)
 I $G(XMERR)=1 W !,"ERROR SENDING MESSAGE" Q  ;
 ;S ^XMB(3.9,LRTASK,1,.1130590,0)="MIME-Version: 1.0"
 ;S ^XMB(3.9,LRTASK,1,.1130591,0)="Content-type: multipart/mixed; boundary=000e0cd6ae026c3d4b049e7befe9"
 Q
 ;
MAILSEND2(UDFN,ADDR) ; Send extract back to requestor.
 ;
 I +$G(UDFN)=0 S UDFN=2 ;
 D TEST(UDFN)
 S GN=$NA(^TMP($J,"C0CMIME"))
 K @GN
 ;M @GN=G2
 S GM(1)="MIME-Version: 1.0"
 S GM(2)="Content-Type: multipart/mixed; boudary=""1234567"""
 S GM(3)=""
 S GM(4)=""
 S GM(5)="--1234567"
 ;S GM(5)=$$REPEAT^XLFSTR("-",$L(X))
 S GM(6)="Content-Type: text/xml; name=""ccr.xml"""
 S GM(7)="Content-Transfer-Encoding: base64"
 S GM(8)="Content-Disposition: attachment; filename=""ccr.xml"""
 ;S GM(6)=$$UUBEGFN^LRSRVR2A("CCR.xml")
 S GM(9)=""
 S GM(10)="" ; FOR THE END
 S GM(11)="--1234567--"
 S GM(12)=""
 S GM(13)=""
 K GBLD
 D QUEUE^C0CXPATH("GBLD","GM",5,9)
 D QUEUE^C0CXPATH("GBLD","G2",1,$O(G2(""),-1))
 D QUEUE^C0CXPATH("GBLD","GM",10,12)
 D BUILD^C0CXPATH("GBLD",GN)
 S GGG=$NA(^GPL("MIME2"))
 ;D QUEUE^C0CXPATH("GBLD","GM",1,1)
 ;D QUEUE^C0CXPATH("GBLD",GGG,21,159)
 ;D BUILD^C0CXPATH("GBLD",GN)
 K @GN@(0) ; KILL THE LINE COUNT
 K LRINSTR,LRTASK,LRTO,XMERR,XMZ
 I $G(ADDR)'="" S XQSND=ADDR
 E  S XQSND="glilly@glilly.net"
 ;S XQSND="nanthracite@earthlink.net"
 ;S XQSND="dlefevre@orohosp.com"
 ;S XQSND="gregwoodhouse@me.com"
 ;S XQSND="rick.marshall@vistaexpertise.net"
 S LRTO(XQSND)=""
 ;S LRTO("glilly@glilly.net")=""
 S LRINSTR("ADDR FLAGS")="R"
 S LRINSTR("FROM")="ANTHRACITE.NANCY"
 S LRMSUBJ="Sending a CCR with Mailman"
 S LRMSUBJ=$E(LRMSUBJ,1,65)
 D SENDMSG^XMXAPI(9,LRMSUBJ,GN,.LRTO,.LRINSTR,.LRTASK)
 I $G(XMERR)=1 W !,"ERROR SENDING MESSAGE" Q  ;
 ;S ^XMB(3.9,LRTASK,1,.1130590,0)="MIME-Version: 1.0"
 ;S ^XMB(3.9,LRTASK,1,.1130591,0)="Content-type: multipart/mixed; boundary=000e0cd6ae026c3d4b049e7befe9"
 Q
 ;
SIMPLE ;
 S GN(1)="SIMPLE TEST MESSAGE"
 K LRINSTR,LRTASK,LRTO,XMERR,XMZ
 S XQSND="glilly@glilly.net"
 S LRTO(XQSND)=""
 S LRINSTR("ADDR FLAGS")="R"
 S LRINSTR("FROM")="CCR_PACKAGE"
 S LRMSUBJ="A SAMPLE CCR"
 S LRMSUBJ=$E(LRMSUBJ,1,65)
 D SENDMSG^XMXAPI(9,LRMSUBJ,"GN",.LRTO,.LRINSTR,.LRTASK)
 Q
CHUNK(OUTXML,INXML,ZSIZE) ; BREAKS INXML INTO ZSIZE BLOCKS
 ; INXML IS AN ARRAY PASSED BY NAME OF STRINGS
 ; OUTXML IS ALSO PASSED BY NAME
 ; IF ZSIZE IS NOT PASSED, 1000 IS USED
 I '$D(ZSIZE) S ZSIZE=1000 ; DEFAULT BLOCK SIZE
 N ZB,ZI,ZJ,ZK,ZL,ZN
 S ZB=ZSIZE-1
 S ZN=1
 S ZI=0 ; BEGINNING OF INDEX TO INXML
 F  S ZI=$O(@INXML@(ZI)) Q:+ZI=0  D  ; FOR EACH STRING IN INXML
 . S ZL=$L(@INXML@(ZI)) ; LENGTH OF THE STRING
 . F ZJ=1:ZSIZE:ZL D  ;
 . . S ZK=$S(ZJ+ZB<ZL:ZJ+ZB,1:ZL) ; END FOR EXTRACT
 . . S @OUTXML@(ZN)=$E(@INXML@(ZI),ZJ,ZK) ; PULL OUT THE PIECE
 . . S ZN=ZN+1 ; INCREMENT OUT ARRAY INDEX
 Q
 ;
CLEAN(IARY) ; RUNS THROUGH AN ARRAY PASSED BY NAME AND STRIPS OUT $C(13)
 ;
 N ZI S ZI=0
 F  S ZI=$O(@IARY@(ZI)) Q:+ZI=0  D  ;
 . S @IARY@(ZI)=$TR(@IARY@(ZI),$C(13)) ;
 . I $F(@IARY@(ZI)," <") S @IARY@(ZI)="<"_$P(@IARY@(ZI)," <",2) ; RM BLNKS
 Q
 ;
