C0CEVC   ; CCDCCR/GPL - SUPPORT FOR EWD VISTCOM PAGES ; 3/1/2010
 ;;1.0;C0C;;Mar 1, 2010;Build 2
gpltest2 ; experiment with sending a CCR to an ewd page
 N ZI
 S ZI=""
 D PSEUDO
 N ZIO
 S ZIO=IO
 S IO="/dev/null"
 OPEN IO
 U IO
 N G
 S G=$$URLTOKEN^C0CEWD
 D CCRRPC^C0CCCR(.GPL,2)
 S IO=ZIO
 OPEN IO
 U IO
 K GPL(0)
 F  S ZI=$O(GPL(ZI)) Q:ZI=""  W GPL(ZI),!
 Q
 ;
gpltest ; experiment with sending a CCR to an ewd page
 N ZI
 S ZI=""
 K ^GPL(0)
 S ^GPL(2)="<?xml-stylesheet type=""text/xsl"" href=""/resources/ccr.xsl""?>"
 F  S ZI=$O(^GPL(ZI)) Q:ZI=""  W ^GPL(ZI),!
 Q
 ;
TEST(sessid);
 d setSessionValue^%zewdAPI("person.Name","Rob",sessid)
 d setSessionValue^%zewdAPI("person.DateOfBirth","13/06/55",sessid)
 d setSessionValue^%zewdAPI("person.Address.PostCode","SW1 3QA",sessid)
 d setSessionValue^%zewdAPI("person.Address.Line1","1 The Street",sessid)
 d setSessionValue^%zewdAPI("person.Address.2.hello","world",sessid)
 d setJSONValue^%zewdAPI("json","person",sessid)
 Q ""
PARSE(INXML,INDOC) ;CALL THE EWD PARSER ON INXML, PASSED BY NAME
 ; INDOC IS PASSED AS THE DOCUMENT NAME TO EWD
 ; EXTRINSIC WHICH RETURNS THE DOCID ASSIGNED BY EWD
 N ZR
 M ^CacheTempEWD($j)=@INXML ;
 S ZR=$$parseDocument^%zewdHTMLParser(INDOC)
 Q ZR
 ;
TEST2(sessid) ; try to put a ccr in the session
 S U="^"
 D PSEUDO ; FAKE LOGIN
 S ZIO=$IO
 S DEV="/dev/null"
 O DEV U DEV
 N G
 N ZDFN
 S ZDFN=$$getSessionValue^%zewdAPI("vista.dfn",sessid)
 I ZDFN="" S ZDFN=2
 ;K ^TMP("GPL")
 ;M ^TMP("GPL")=^%zewdSession("session",sessid)
 D CCRRPC^C0CCCR(.GPL,ZDFN)
 K GPL(0)
 S GPL(2)="<?xml-stylesheet type=""text/xsl"" href=""/resources/ccr.xsl""?>"
 C DEV U ZIO
 ;M ^CacheTempEWD($j)=GPL
 S DOCNAME="CCR"
 ;ZWR GPL
 ;S ZR=$$parseDocument^%zewdHTMLParser(DOCNAME)
 ;d setSessionValues^%zewdAPI(DOCNAME,GPL,sessid)
 d mergeArrayToSession^%zewdAPI(.GPL,DOCNAME,sessid)
 Q ""
 ;
INITSES(sessid) ;initialize an EWD/CPRS session
 K ^TMP("GPL")
 ;M ^TMP("GPL")=^%zewdSession("session",sessid)
 N ZT,ZDFN
 S ZT=$$URLTOKEN^C0CEWD(sessid)
 ;S ^TMP("GPL")=ZT
 d trace^%zewdAPI("*********************ZT="_ZT)
 S ZDFN=$$PRSEORTK(ZT) ; PARSE THE TOKEN AND LOOK UP THE DFN
 S ^TMP("GPL","DFN")=ZDFN
 I ZDFN=0 S DFN=2 ; DEFAULT TEST PATIENT
 D setSessionValue^%zewdAPI("vista.dfn",ZDFN,sessid)
 ;M ^TMP("GPL","request")=requestArray
 ;D PSEUDO
 ;D ^%ZTER
 q ""
 ;
PRSEORTK(ZTOKEN) ;PARSES THE TOKEN SENT BY CPRS AND RETURNS THE DFN
 ; OF THE PATIENT ; HERE'S WHAT THE TOKEN LOOKS LIKE:
 ; ^TMP('ORWCHART',6547,'192.168.169.8',002E0FE6)
 N ZX,ZN1,ZIP,ZN2,ZDFN,ZG
 S ZDFN=0 ; DEFAULT RETURN
 S ZN1=$P(ZTOKEN,",",2) ; FIRST NUMBER
 S ZIP=$P(ZTOKEN,",",3) ; IP NUMBER
 S ZIP=$P(ZIP,"'",2) ; GET RID OF '
 S ZN2=$P(ZTOKEN,",",4) ; SECOND NUMBER
 S ZN2=$P(ZN2,")",1) ; GET RID OF )
 S ZG=$NA(^TMP("ORWCHART",ZN1,ZIP,ZN2)) ; BUILD THE GLOBAL NAME
 I $G(@ZG)'="" S ZDFN=@ZG ; ACCESS THE GLOBAL
 S ^TMP("GPL","FIRSTDFN")=ZDFN
 S ^TMP("GPL","FIRSTGLB")=ZG
 Q ZDFN
 ;
GETPATIENTLIST(sessid) ;
 D PSEUDO
 D LISTALL^ORWPT(.RTN,"NAME","1")
 N ZI
 S ZI=""
 F  S ZI=$O(RTN(ZI)) Q:ZI=""  D  ;
 . S data(ZI,"DFN")=$P(RTN(ZI),"^",1)
 . S data(ZI,"Name")=$P(RTN(ZI),"^",2)
 ; ZWR data
 ;S data(1,"DFN")=$P(RTN(1),"^",1)
 ;S data(1,"Name")=$P(RTN(1),"^",2)
 d deleteFromSession^%zewdAPI("patients",sessid)
 d createDataTableStore^%zewdYUIRuntime(.data,"patients",sessid)
 ;d mergeArrayToSession^%zewdAPI(.data,"patients",sessid)
 Q ""
 ;
PSEUDO
 S U="^"
 S DILOCKTM=3
 S DISYS=19
 S DT=3100219
 S DTIME=999
 S DUZ=10
 S DUZ(0)="@"
 S DUZ(1)=""
 S DUZ(2)=1
 S DUZ("AG")="V"
 S DUZ("BUF")=1
 S DUZ("LANG")=""
 ;S IO="/dev/pts/2"
 ;S IO(0)="/dev/pts/2"
 ;S IO(1,"/dev/pts/2")=""
 ;S IO("ERROR")=""
 ;S IO("HOME")="41^/dev/pts/2"
 ;S IO("ZIO")="/dev/pts/2"
 ;S IOBS="$C(8)"
 ;S IOF="#,$C(27,91,50,74,27,91,72)"
 ;S SIOM=80
 Q
 ;
PSEUDO2 ; FAKE LOGIN SETS SOME LOCAL VARIABLE TO FOOL FILEMAN
 S DILOCKTM=3
 S DISYS=19
 S DT=3100112
 S DTIME=9999
 S DUZ=10000000020
 S DUZ(0)="@"
 S DUZ(1)=""
 S DUZ(2)=67
 S DUZ("AG")="E"
 S DUZ("BUF")=1
 S DUZ("LANG")=1
 S IO="/dev/pts/0"
 ;S IO(0)="/dev/pts/0"
 ;S IO(1,"/dev/pts/0")=""
 ;S IO("ERROR")=""
 ;S IO("HOME")="50^/dev/pts/0"
 ;S IO("ZIO")="/dev/pts/0"
 ;S IOBS="$C(8)"
 ;S IOF="!!!!!!!!!!!!!!!!!!!!!!!!,#,$C(27,91,50,74,27,91,72)"
 ;S IOM=80
 ;S ION="GTM/UNIX TELNET"
 ;S IOS=50
 ;S IOSL=24
 ;S IOST="C-VT100"
 ;S IOST(0)=9
 ;S IOT="VTRM"
 ;S IOXY="W $C(27,91)_((DY+1))_$C(59)_((DX+1))_$C(72)"
 S U="^"
 S X="1;DIC(4.2,"
 S XPARSYS="1;DIC(4.2,"
 S XQXFLG="^^XUP"
 S Y="DEV^VISTA^hollywood^VISTA:hollywood"
 Q
 ;
