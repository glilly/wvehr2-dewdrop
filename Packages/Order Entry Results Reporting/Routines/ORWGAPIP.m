ORWGAPIP        ; SLC/STAFF - Graph Parameters ;11/20/06  08:59
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,260,243**;Dec 17, 1997;Build 242
        ;
ALLVIEWS(DATA,VTYPE,USER)       ; from ORWGAPI
        N CNT,ENT,NUM,NUM1,PARAM,PROF,RESULT,TEST,TG,TGNUM,TGNAME,TMP,VIEW,VNUM K PROF,VIEW
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S CNT=0
        I VTYPE=-2 D
        . S ENT="SYS"
        . S USER=0
        I VTYPE=-1 D
        . S ENT="USR"
        . I USER S ENT="USR.`"_USER
        I VTYPE=-3 D  Q
        . ;LAB GROUPS
        . I 'USER S USER=DUZ
        . D TG^ORWLRR(.PROF,USER)
        . S NUM=0
        . F  S NUM=$O(PROF(NUM)) Q:NUM<1  D
        .. S TG=PROF(NUM)
        .. S TGNUM=+TG
        .. S TGNAME=$P(TG,U,2)
        .. ;I TGNAME[") " S TGNAME=$P(TGNAME,") ",2,99)
        .. S VNUM=CNT+1
        .. S RESULT="-3^V^"_VNUM_U_TGNAME_"^^^"_USER
        .. D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        .. K VIEW
        .. D ATG^ORWLRR(.VIEW,TGNUM,USER)
        .. S NUM1=0
        .. F  S NUM1=$O(VIEW(NUM1)) Q:NUM1<1  D
        ... S TEST=VIEW(NUM1)
        ... S RESULT="-3^C^"_VNUM_U_$P(TEST,U,2)_"^63^"_+TEST_U
        ... D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        D XGETLST^ORWGAPIX(.PROF,ENT,"ORWG GRAPH VIEW")
        S NUM=0
        F  S NUM=$O(PROF(NUM)) Q:NUM<1  D
        . S PARAM=$P(PROF(NUM),U)
        . S VNUM=CNT+1
        . S RESULT=VTYPE_"^V^"_VNUM_U_PARAM_"^^^"_USER
        . D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        . K VIEW
        . D XGETWP^ORWGAPIX(.VIEW,ENT,"ORWG GRAPH VIEW",PARAM)
        . D DEFVIEWS(.DATA,.VIEW,VTYPE,VNUM,TMP,.CNT)
        Q
        ;
DATES(DAT,REPORTID)     ; from ORWGAPI
        N BEGIN,END,INFO,NEXT,PARAM1,PARAM2,RPT,START,STOP
        S RPT=+$O(^ORD(101.24,"AC",+$G(REPORTID),0))
        I 'RPT Q  ; RPT=1150 is exported graph report
        S PARAM1=$P($G(^ORD(101.24,RPT,2)),U)
        S PARAM2=$P($G(^ORD(101.24,RPT,2)),U,2)
        S INFO=$$XGET^ORWGAPIX("ALL","ORWRP TIME/OCC LIMITS INDV",RPT,"I")
        S BEGIN=$P(INFO,";"),START=$$DATE^ORWGAPIX(BEGIN)
        S END=$P(INFO,";",2),STOP=$$DATE^ORWGAPIX(END)
        I START<1 Q
        I STOP<1 Q
        S NEXT=1+$O(DAT(""),-1)
        S DAT(NEXT)=U_BEGIN_" to "_END_"^^^"_INFO_U_START_U_STOP_U_PARAM1_U_PARAM2
        Q
        ;
DEFVIEWS(DATA,VIEW,VTYPE,VNUM,TMP,CNT)  ;
        N FIRST,NUM,PIECE,RESULT,RESULT1,SECOND,VALUE
        S NUM=""
        F  S NUM=$O(VIEW(NUM)) Q:NUM=""  D
        . S RESULT=$G(VIEW(NUM,0))
        . S PIECE=0
        . F  S PIECE=PIECE+1 S VALUE=$P(RESULT,"|",PIECE) D:$L(VALUE)  Q:'$L($P(RESULT,"|",PIECE+1,999))
        .. S FIRST=$P(VALUE,"~"),SECOND=$P(VALUE,"~",2)
        .. I FIRST=0 D
        ... I $E(SECOND,1,5)="63AP;" S RESULT1=VTYPE_"^C^"_VNUM_U_"Anatomic Path: "_$$ITEMPRFX^ORWGAPIU($E(SECOND,3,6))_" <any>"_U_SECOND_"^0^" Q
        ... I $E(SECOND,1,5)="63MI;" S RESULT1=VTYPE_"^C^"_VNUM_U_"Microbiology: "_$$ITEMPRFX^ORWGAPIU($E(SECOND,3,6))_" <any>"_U_SECOND_"^0^" Q
        ... S RESULT1=VTYPE_"^C^"_VNUM_U_$$FILENAME^ORWGAPIT(SECOND)_" <any>"_U_SECOND_"^0^"
        .. I FIRST'=0 S RESULT1=VTYPE_"^C^"_VNUM_U_$$EVALUE^ORWGAPIU(SECOND,FIRST)_U_FIRST_U_SECOND_U
        .. D SETUP^ORWGAPIW(.DATA,RESULT1,TMP,.CNT)
        Q
        ;
DELVIEWS(DATA,NAME,PUBLIC)      ; from ORWGAPI
        N ERR,TMP
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S ERR=0
        I '$L(NAME) S ERR=1
        I 'ERR D
        . S NAME=$$UP^ORWGAPIX(NAME)
        . I PUBLIC D XDEL^ORWGAPIX("SYS","ORWG GRAPH VIEW",NAME,.ERR)
        . I 'PUBLIC  D XDEL^ORWGAPIX("USR","ORWG GRAPH VIEW",NAME,.ERR)
        I TMP S ^TMP(DATA,$J)=ERR,^TMP(DATA,$J,1)=ERR
        I 'TMP S DATA=ERR,DATA(1)=ERR
        Q
        ;
GETPREF(DATA)   ; from ORWGAPI
        N CNT,NUM,PROF,RESULT,TMP,VAL K PROF
        I '$O(^PXRMINDX(63,"PI","")) Q  ; graphing is not used if no indexes
        S VAL=$$XGET^ORWGAPIX("PKG","ORWG GRAPH SETTING",1,"I")
        I '$L(VAL) Q  ; graphing not used if no pkg param on settings
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S PROF(2)=1
        I '$L($G(^XTMP("ORGRAPH",0))) S PROF(2)=-1
        S VAL=$$XGET^ORWGAPIX("DIV^SYS^PKG","ORWG GRAPH SETTING",1,"I")
        S PROF(1)=VAL
        S VAL=$$XGET^ORWGAPIX("ALL","ORWG GRAPH SETTING",1,"I")
        S PROF(0)=VAL
        S CNT=0
        S NUM=""
        F  S NUM=$O(PROF(NUM)) Q:NUM=""  D
        . S RESULT=$G(PROF(NUM))
        . D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
GETSIZE(DATA)   ; from ORWGAPI
        N CNT,NUM,PROF,RESULT,TMP K PROF
        D RETURN^ORWGAPIW(.TMP,.DATA)
        D XGETLST^ORWGAPIX(.PROF,"USR","ORWG GRAPH SIZING")
        S CNT=0
        S NUM=""
        F  S NUM=$O(PROF(NUM)) Q:NUM=""  D
        . S RESULT=$G(PROF(NUM))
        . D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
        ;GETVIEWS(DATA,ALL,PUBLIC,EXT,USER) ; from ORWGAPI
        ;N CNT,NUM,PROF,RESULT,TMP,USERPRM K PROF
        ;D RETURN^ORWGAPIW(.TMP,.DATA)
        ;I PUBLIC D
        ;. I ALL=1 D XGETLST^ORWGAPIX(.PROF,"SYS","ORWG GRAPH VIEW") ; get list of public views
        ;. I ALL'=1 D XGETWP^ORWGAPIX(.PROF,"SYS","ORWG GRAPH VIEW",ALL) ; get a public view definition
        ;I 'PUBLIC D
        ;. S USERPRM="USR"
        ;. I USER S USERPRM="USR.`"_USER
        ;. I ALL=1 D XGETLST^ORWGAPIX(.PROF,USERPRM,"ORWG GRAPH VIEW") ; get list of personal views
        ;. I ALL'=1 D XGETWP^ORWGAPIX(.PROF,USERPRM,"ORWG GRAPH VIEW",ALL) ; get a personal view definition
        ;S CNT=0
        ;I 'EXT D  Q
        ;. S NUM=""
        ;. F  S NUM=$O(PROF(NUM)) Q:NUM=""  D
        ;.. I ALL=1 S RESULT=$P($G(PROF(NUM)),U)
        ;.. I ALL'=1 S RESULT=$G(PROF(NUM,0))
        ;.. D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        ;D DEFVIEWS(.DATA,.PROF,"",TMP,.CNT)
        ;Q
        ;
GETVIEWS(DATA,ALL,PUBLIC,EXT,USER)      ; from ORWGAPI
        N CNT,FIRST,NUM,PIECE,PROF,RESULT,RESULT1,SECOND,TMP,VALUE K PROF
        D RETURN^ORWGAPIW(.TMP,.DATA)
        I PUBLIC D
        . I ALL=1 D XGETLST^ORWGAPIX(.PROF,"SYS","ORWG GRAPH VIEW") ; get list of public views
        . I ALL'=1 D XGETWP^ORWGAPIX(.PROF,"SYS","ORWG GRAPH VIEW",ALL) ; get a public view definition
        I 'PUBLIC D
        . S USERPRM="USR"
        . I USER S USERPRM="USR.`"_USER
        . I ALL=1 D XGETLST^ORWGAPIX(.PROF,USERPRM,"ORWG GRAPH VIEW") ; get list of personal views
        . I ALL'=1 D XGETWP^ORWGAPIX(.PROF,USERPRM,"ORWG GRAPH VIEW",ALL) ; get a personal view definition
        S CNT=0
        I 'EXT D  Q
        . S NUM=""
        . F  S NUM=$O(PROF(NUM)) Q:NUM=""  D
        .. I ALL=1 S RESULT=$P($G(PROF(NUM)),U)
        .. I ALL'=1 S RESULT=$G(PROF(NUM,0))
        .. D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        S NUM=""
        F  S NUM=$O(PROF(NUM)) Q:NUM=""  D
        . S RESULT=$G(PROF(NUM,0))
        . S PIECE=0
        . F  S PIECE=PIECE+1 S VALUE=$P(RESULT,"|",PIECE) D:$L(VALUE)  Q:'$L($P(RESULT,"|",PIECE+1,999))
        .. S FIRST=$P(VALUE,"~"),SECOND=$P(VALUE,"~",2)
        .. I FIRST=0 S CNT=CNT+1,RESULT1="0^"_SECOND_U_$$FILENAME^ORWGAPIT(SECOND)_" <any>"
        .. I FIRST'=0 S CNT=CNT+1,RESULT1=FIRST_U_SECOND_U_$$EVALUE^ORWGAPIU(SECOND,FIRST)
        .. D SETUP^ORWGAPIW(.DATA,RESULT1,TMP,.CNT)
        Q
        ;
INISET  ; from ORWGAPIU initial setup of package parameters
        N ERR,RPTNUM
        S RPTNUM=1150
        D SETPREF(.ERR,"63;53.79;55;55NVA;52;70;120.5|BCEFGHIKN|1|4|90|1|100||",9) ; default public settings
        I '$D(^ORD(101.24,RPTNUM,0)) D  ; make sure report has been added
        . L +^ORD(101.24,0):20 I '$T Q
        . S $P(^ORD(101.24,0),U,3)=RPTNUM,$P(^(0),U,4)=$P(^(0),U,4)+1
        . S ^ORD(101.24,RPTNUM,0)="ORWG GRAPHING^OR_GRAPHS^^2^^^1^R^^^^G^^T"
        . S ^ORD(101.24,RPTNUM,2)="^^Graphing (local only)^Graphing"
        . L -^ORD(101.24,0)
        . D INDEX^ORWGAPIX("^ORD(101.24,",RPTNUM)
        D XEN^ORWGAPIX("PKG","ORWRP REPORT LIST",12,RPTNUM)
        Q
        ;
PUBLIC(USER)    ; from ORWGAPI
        N ERR,IDX,ORSRV,USRCLASS,VAL K USRCLASS
        S VAL=0
        I '$G(USER) Q VAL
        S ORSRV=$$GET1^DIQ(200,DUZ,29,"I")
        D XGETLST1^ORWGAPIX(.USRCLASS,"SYS","ORWG GRAPH PUBLIC EDITOR CLASS","Q",.ERR)
        I ERR Q VAL
        S IDX=0
        F  S IDX=$O(USRCLASS(IDX)) Q:'IDX  D  Q:VAL
        . I $$ISA^ORWGAPIA(USER,$P(USRCLASS(IDX),U,2),.ERR) S VAL=1
        Q VAL
        ;
RPTPARAM(IEN)   ; from ORWGAPI
        N DATES,NODE,VAL
        S IEN=+$G(IEN)
        S VAL=""
        S NODE=$$UP^XLFSTR($P($G(^ORD(101.24,IEN,2)),U,1,2))
        I $L(NODE)<2 Q VAL
        Q NODE
        ;
SETPREF(DATA,VAL,PUBLIC)        ; from ORWGAPI
        N ERR,TMP
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S ERR=0
        I '$L(VAL) S ERR=1
        I 'ERR D
        . S VAL=$$UP^ORWGAPIX(VAL)
        . I PUBLIC=9 D XEN^ORWGAPIX("PKG","ORWG GRAPH SETTING",1,VAL,.ERR) ; only on postinit
        . I PUBLIC D XEN^ORWGAPIX("SYS","ORWG GRAPH SETTING",1,VAL,.ERR)
        . I 'PUBLIC D XEN^ORWGAPIX("USR","ORWG GRAPH SETTING",1,VAL,.ERR)
        I TMP S ^TMP(DATA,$J)=ERR,^TMP(DATA,$J,1)=ERR
        I 'TMP S DATA=ERR,DATA(1)=ERR
        Q
        ;
SETSIZE(DATA,VAL)       ; from ORWGAPI
        N ERR,NAME,NUM,VALUE,VALUES,TMP
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S ERR=0
        I '$L($O(VAL(0))) S ERR=1
        I 'ERR D
        . S NUM=0
        . F  S NUM=$O(VAL(NUM)) Q:NUM<1  D  Q:ERR
        .. S VALUES=VAL(NUM)
        .. S VALUES=$$UP^ORWGAPIX(VALUES)
        .. S NAME=$P(VALUES,U)
        .. S VALUE=$P(VALUES,U,2)
        .. D XEN^ORWGAPIX("USR","ORWG GRAPH SIZING",NAME,VALUE,.ERR)
        I TMP S ^TMP(DATA,$J)=ERR,^TMP(DATA,$J,1)=ERR
        I 'TMP S DATA=ERR,DATA(1)=ERR
        Q
        ;
SETVIEWS(DATA,NAME,PUBLIC,VAL)  ; from ORWGAPI
        N ERR,TMP
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S ERR=0
        I '$L(NAME) S ERR=1
        I '$L($O(VAL(""))) S ERR=1
        I 'ERR D
        . S NAME=$$UP^ORWGAPIX(NAME)
        . S VAL=NAME
        . I PUBLIC D XEN^ORWGAPIX("SYS","ORWG GRAPH VIEW",NAME,.VAL,.ERR)
        . I 'PUBLIC  D XEN^ORWGAPIX("USR","ORWG GRAPH VIEW",NAME,.VAL,.ERR)
        I TMP S ^TMP(DATA,$J)=ERR,^TMP(DATA,$J,1)=ERR
        I 'TMP S DATA=ERR,DATA(1)=ERR
        Q
        ;
