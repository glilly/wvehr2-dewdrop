ORWTPR  ; SLC/STAFF Personal Preference - Reminders ; 4/20/07 10:00am
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**85,173,215,243**;Oct 24, 2000;Build 242
        ;
GETREM(VALUES,USER)     ; from ORWTPP
        ; get user's reminders
        N CLASS,CNT,ERR,IEN,NUM,OK,TMPLIST,ZERO K VALUES
        D GETLST^XPAR(.TMPLIST,"USR.`"_USER,"ORQQPX SEARCH ITEMS","Q",.ERR)
        S CNT=0,IEN=0 F  S IEN=$O(^PXD(811.9,IEN)) Q:IEN<1  S ZERO=$G(^(IEN,0)) I $L($P(ZERO,U,3)),'$P(ZERO,U,6) D
        .S CNT=CNT+1
        .S VALUES(CNT)=IEN_"^0^"_$P(ZERO,U,3)_U_$P(ZERO,U)
        .S CLASS=$P($G(^PXD(811.9,IEN,100)),U)
        .S $P(VALUES(CNT),U,5)=$S(CLASS="N":"NATIONAL",CLASS="L":"LOCAL",1:CLASS)
        .S OK=0,NUM=0 F  S NUM=$O(TMPLIST(NUM)) Q:NUM<1  D  Q:OK
        ..I IEN=$P(TMPLIST(NUM),U,2) S OK=1
        .I OK S $P(VALUES(CNT),U,2)=$P(TMPLIST(NUM),U)
        Q
        ;
SETREM(OK,VALUES,USER)  ; from ORWTPP
        ; save user's reminders
        N NUM,ERR
        S OK=1
        D NDEL^XPAR("USR.`"_USER,"ORQQPX SEARCH ITEMS",.ERR)
        S NUM=0 F  S NUM=$O(VALUES(NUM)) Q:NUM<1  D
        .D EN^XPAR(USER_";VA(200,","ORQQPX SEARCH ITEMS",$P(VALUES(NUM),U,1),"`"_$P(VALUES(NUM),U,2),.ERR)
        Q
        ;
GETOC(VALUES,USER)      ; from ORWTPP
        ; get user's order checks
        N CNT,IEN,LIST,NUM,VAL,VALOK K LIST,VALUES
        S IEN=0 F  S IEN=$O(^ORD(100.8,IEN)) Q:IEN<1  D
        .S VAL=$$GET^XPAR("ALL","ORK PROCESSING FLAG",IEN,"I")
        .I '$L(VAL) Q
        .S VALOK=$$GET^XPAR("ALL","ORK EDITABLE BY USER",IEN,"I")
        .S LIST(IEN)=VAL_U_VALOK
        S NUM=0,CNT=0 F  S NUM=$O(LIST(NUM)) Q:NUM<1  D
        .S CNT=CNT+1
        .S VALUES(CNT)=NUM_U_$P($G(^ORD(100.8,NUM,0)),U)_U_$S($P(LIST(NUM),U)="E":"ON",1:"OFF")_U_$S($P(LIST(NUM),U,2)="0":"MANDATORY",1:"")
        Q
        ;
SAVEOC(OK,VALUES,USER)  ; from ORWTPP
        ; save user's order checks
        N NUM,ERR
        S OK=1
        S NUM=0 F  S NUM=$O(VALUES(NUM)) Q:NUM<1  D
        .D EN^XPAR(USER_";VA(200,","ORK PROCESSING FLAG","`"_+VALUES(NUM),$S($P(VALUES(NUM),U,2)="ON":"E",1:"D"),.ERR)
        Q
        ;
        ;
GETNOT(VALUES,USER)     ; from ORWTPP
        ; get user's notifications
        N CNT,IEN,NAME,RESULT K VALUES
        S CNT=0
        S NAME="" F  S NAME=$O(^ORD(100.9,"B",NAME)) Q:NAME=""  D
        .S IEN=0  F  S IEN=$O(^ORD(100.9,"B",NAME,IEN)) Q:IEN<1  D
        ..S RESULT=$$ONOFF^ORB3USER(IEN,USER,"","") I $L($G(RESULT)) D
        ...S CNT=CNT+1
        ...S VALUES(CNT)=IEN_U_NAME_U_$P(RESULT,U)_U_$S($$UP^XLFSTR($P(RESULT,U,3))["MANDATORY":"MANDATORY",1:"")
        Q
        ;
SAVENOT(OK,VALUES,USER) ; from ORWTPP
        ; save user's notifications
        N ERR,NUM
        S OK=1
        S NUM=0 F  S NUM=$O(VALUES(NUM)) Q:NUM<1  D
        .D EN^XPAR(USER_";VA(200,","ORB PROCESSING FLAG","`"_+VALUES(NUM),$S($P(VALUES(NUM),U,2)="ON":"E",1:"D"),.ERR)
        Q
        ;
CLEARNOT(OK,USER)       ; from ORWTPP
        ; clear user's notifications
        D RECIPURG^XQALBUTL(USER)
        S OK=1
        Q
        ;
GETNOTO(INFO,USER)      ; from ORWTPP
        ; get user's other info for notifications
        I $$GET^XPAR("USR.`"_USER,"ORB FLAGGED ORDERS BULLETIN",1,"Q")="Y" S $P(INFO,U,2)=1
        I $$GET^XPAR("ALL^USR.`"_USER,"ORB ERASE ALL",1,"Q") S $P(INFO,U,3)=1
        Q
        ;
GETSURR(INFO,USER)      ; from ORWTPP
        ; get user's surrogate info
        N SURR
        D SUROLIST^XQALSURO(USER,.SURR)
        S INFO=$G(SURR(1))
        Q
        ;
SAVESURR(OK,INFO,USER)  ; from ORWTPP
        ; save user's surrogate info
        N START,STOP,SURR,RET
        S OK=1
        S SURR=$P(INFO,U,1)
        S START=$P(INFO,U,2)
        S STOP=$P(INFO,U,3)
        S RET=$$SAVESURR^ORWTPUA(USER,SURR,START,STOP)
        I 'RET S OK="0^"_RET
        Q
        ;
SAVENOTO(OK,INFO,USER)  ; from ORWTPP
        ; save user's notification settings
        N ERR,FLAG,VAL
        S OK=1
        S FLAG=$P(INFO,U,3)
        S VAL=$S(FLAG>0:"Y",1:"@")
        D EN^XPAR(USER_";VA(200,","ORB FLAGGED ORDERS BULLETIN",1,VAL,.ERR)
        Q
        ;
OCDESC(TEXT,IEN)        ; from RPC
        N CNT,LINE,NUM K TEXT
        S IEN=+$G(IEN) I IEN<1 Q
        S TEXT(1)=$P($G(^ORD(100.8,IEN,0)),U)
        S TEXT(2)=""
        S CNT=2
        S NUM=0 F  S NUM=$O(^ORD(100.8,IEN,1,NUM)) Q:NUM<1  S LINE=$G(^(NUM,0)) D
        .S CNT=CNT+1
        .S TEXT(CNT)=LINE
        S TEXT(CNT+1)=""
        Q
        ;
NOTDESC(TEXT,IEN)       ; from RPC
        K TEXT
        S IEN=+$G(IEN) I IEN<1 Q
        S TEXT(1)=$P($G(^ORD(100.9,IEN,0)),U)
        S TEXT(2)=""
        S TEXT(3)=$P($G(^ORD(100.9,IEN,4)),U)
        S TEXT(4)=""
        Q
