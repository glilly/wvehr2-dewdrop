SPNJRPML        ;BP/JAS - Send Mailman notifications ;JUN 25, 2007
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;;
        ;;  Reference to API $$GOTLOCAL^XMXAPIG supported by IA# 3006
        ;;  Reference to API SENDMSG^XMXAPI supported by IA# 2729
        ;;
        ;;  SUCCESS - RETURNS 1 FOR SUCCESS, 0 FOR FAILURE
        ;;  FROM - DUZ OF THE USER INITIATING THE NOTIFICATION
        ;;  SUBJECT - SUBJECT OF MAILMAN NOTIFICATION
        ;;  PAR - FOUR OPTIONS, SET TO 1 IF CHOSEN:
        ;;           PIECE 1 - PRIORITY
        ;;           PIECE 2 - INFORMATION ONLY
        ;;           PIECE 3 - CONFIRMATION REQUIRED
        ;;           PIECE 4 - COPY IN 'IN' BASKET
        ;;  ARRAY - CONTAINS MESSAGE AND RECIPIENTS:
        ;;           ARRAY("TEXT",1...n) = MESSAGE LINES (LIMIT TO 80 CHARS PER LINE)
        ;;           ARRAY("TO",1...n) = RECIPIENTS (DUZ CODES)
        ;;           
MAIL(SUCCESS,FROM,SUBJECT,PAR,TEXT,MLTO)        ; SEND VISTA MESSAGE
        S SUCCESS=0 K SPNT,TO,GROUP
        I $O(TEXT(0))="" Q
        I $O(MLTO(0))="" Q
        I $G(SUBJECT)="" Q
        I $G(FROM)="" Q
        F J=0:0 S J=$O(TEXT(J)) Q:J<1  S SPNT(J)=TEXT(J)
        F J=0:0 S J=$O(MLTO(J)) Q:J<1  D
        .S MAIL=MLTO(J)
        .I MAIL["@" S TO(MAIL)=""  Q
        .I $$GOTLOCAL^XMXAPIG(MAIL) D  Q
        ..S TO("G."_MAIL)=""
        .S TO(MAIL)=""
        S TITLE=SUBJECT
        I $G(PAR)]"" D
        .S PRIO=$P(PAR,U)
        .S INFO=$P(PAR,U,2)
        .S CONFIRM=$P(PAR,U,3)
        .I $P(PAR,U,4) S TO(FROM)="" ; SENDER'S IN BASKET
        D MSG
        K TEXT,TO,PAR,FROM,SUBJECT,IEN,J,MAIL
        Q
MSG     ;
        N XMINSTR
        Q:'$O(SPNT(0))
        Q:$O(TO(""))=""
        I $G(CONFIRM) S XMINSTR("FLAGS")=$G(XMINSTR("FLAGS"))_"R"
        I $G(PRIO) S XMINSTR("FLAGS")=$G(XMINSTR("FLAGS"))_"P"
        I $G(INFO) S XMINSTR("FLAGS")=$G(XMINSTR("FLAGS"))_"I"
        I '$D(FROM) S FROM=.5
        S XMINSTR("FROM")="POSTMASTER"
        I '$D(TITLE) S TITLE="Title not specified by sender"
        I $L(TITLE)>65 S TITLE=$E(TITLE,1,65)
        I $L(TITLE)<3 S TITLE=TITLE_"..."
        D SENDMSG^XMXAPI(FROM,TITLE,"SPNT",.TO,.XMINSTR)
        I $G(XMERR)'>0 S SUCCESS=1
        K CONFIRM,FROM,GROUP,INFO,PRIO,SPNT,TITLE,TO,^TMP("XMERR",$J),XMERR
        Q
