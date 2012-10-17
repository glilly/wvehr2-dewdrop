XUSBSE2 ;FO-OAK/JLI-CONNECT WITH HTTP SERVER AND GET REPLY ;04/29/09  12:47
        ;;8.0;KERNEL;**404,439,523**;Jul 10, 1995;Build 16
        Q
        ;
        ; Original version, returns only first line after headers
POST(SERVER,PORT,PAGE,DATA)     ;
        N RESULTS
        Q $$ENTRY1(.RESULTS,SERVER,$G(PORT),$G(PAGE),"POST",$G(DATA))
        ;
        ; updated, returns entire conversation
POST1(RESULTS,SERVER,PORT,PAGE,DATA)    ;
        Q $$ENTRY1(.RESULTS,SERVER,$G(PORT),$G(PAGE),"POST",$G(DATA))
        ;
GET(SERVER,PORT,PAGE)   ;
        N RESULTS
        Q $$ENTRY1(.RESULTS,SERVER,$G(PORT),$G(PAGE),"GET")
        ;
GET1(RESULTS,SERVER,PORT,PAGE)  ;
        Q $$ENTRY1(.RESULTS,SERVER,$G(PORT),$G(PAGE),"GET")
        ;
ENTRY(SERVER,PORT,PAGE,HTTPTYPE,DATA)   ;
        N RESULTS
        S HTTPTYPE=$G(HTTPTYPE,"GET")
        Q $$ENTRY1(.RESULTS,SERVER,$G(PORT),$G(PAGE),HTTPTYPE,$G(DATA))
        ;
ENTRY1(RESULTS,SERVER,PORT,PAGE,HTTPTYPE,DATA)  ;
        N DONE,XVALUE,XWBICNT,XWBRBUF,XWBSBUF,XWBTDEV,I
        N XWBDEBUG,XWBOS,XWBT,XWBTIME,POP,RESLTCNT,LINEBUF,OVERFLOW
        N $ESTACK,$ETRAP S $ETRAP="D TRAP^XUSBSE2"
        K RESULTS
        S PAGE=$G(PAGE,"/") I PAGE="" S PAGE="/"
        S HTTPTYPE=$G(HTTPTYPE,"GET")
        S DATA=$G(DATA),PORT=$G(PORT,80)
        D SAVDEV^%ZISUTL("XUSBSE") ;S IO(0)=$P
        D INIT^XWBTCPM
        D OPEN^XWBTCPM2(SERVER,PORT)
        I POP Q "DIDN'T OPEN CONNECTION"
        S XWBSBUF=""
        U XWBTDEV
        D WRITE^XWBRW(HTTPTYPE_" "_PAGE_" HTTP/1.0"_$C(13,10))
        I HTTPTYPE="POST" D
        . D WRITE^XWBRW("Referer: http://"_$$KSP^XUPARAM("WHERE")_$C(13,10))
        . D WRITE^XWBRW("Content-Type: application/x-www-form-urlencoded"_$C(13,10))
        . D WRITE^XWBRW("Cache-Control: no-cache"_$C(13,10))
        . D WRITE^XWBRW("Content-Length: "_$L(DATA)_$C(13,10,13,10))
        . D WRITE^XWBRW(DATA)
        D WRITE^XWBRW($C(13,10))
        D WBF^XWBRW
        S XWBRBUF="",DONE=0,XWBICNT=0
        S OVERFLOW=""
        S XVALUE=$$DREAD($C(13,10)) I $G(RESULTS(1))'[200 S XVALUE=$P($G(RESULTS(1))," ",2,5)
        D CLOSE ;I IO="|TCP|80" U IO D ^%ZISC
        I LINEBUF'="" S RESLTCNT=RESLTCNT+1,RESULTS(RESLTCNT)=LINEBUF
        I $G(RESULTS(1))[200 F I=1:1 I RESULTS(I)="" S XVALUE=$G(RESULTS(I+1)) Q
        Q XVALUE
        ;
CLOSE   ;
        D CLOSE^%ZISTCP,GETDEV^%ZISUTL("XUSBSE") I $L(IO) U IO
        Q
        ;
DREAD(D,TO)     ;Delimiter Read
        N R,S,DONE,C,L
        ; ZEXCEPT: LINEBUF,OVERFLOW,RESLTCNT,RESULTS,XWBRBUF - NEWed and set in ENTRY
        ; ZEXCEPT: XWBDEBUG,XWBTDEV,XWBTIME - XWB global variables
        N $ES,$ET S $ET="S DONE=1,$EC="""" Q"
        S R="",DONE=0,D=$G(D,$C(13)),C=0
        S TO=$S($G(TO)>0:TO,$G(XWBTIME(1))>0:XWBTIME(1),1:60)/2+1
        U XWBTDEV
        F  D  Q:DONE
        . S L=$F(XWBRBUF,D),L=$S(L>0:L,1:$L(XWBRBUF)+1),R=R_$E(XWBRBUF,1,L-1),XWBRBUF=$E(XWBRBUF,L,32000)
        . ; I (R[D)!(C>TO) S DONE=1 Q
        . I C>TO S DONE=1 Q
        . R XWBRBUF:2 S:'$T C=C+1 S:$L(XWBRBUF) C=0
        . S LINEBUF=OVERFLOW_XWBRBUF F  S L=$F(LINEBUF,D) Q:'L  S RESLTCNT=$G(RESLTCNT)+1,RESULTS(RESLTCNT)=$E(LINEBUF,1,L-3),LINEBUF=$E(LINEBUF,L,32000)
        . S OVERFLOW=LINEBUF
        . I $G(XWBDEBUG)>2,$L(XWBRBUF) D LOG^XWBDLOG($E("rd ("_$L(XWBRBUF)_"): "_XWBRBUF,1,255))
        . Q
        Q R
        ;
TRAP    ;
        I '(($EC["READ")!($EC["WRITE")) D ^%ZTER
        D CLOSE,LOG^XWBDLOG("Error: "_$$EC^%ZOSV):$G(XWBDEBUG),UNWIND^%ZTER
        Q
        ;
EN(ADDRESS)     ;  test with input address or 10.161.12.182 if none entered
        N RESULTS
        D EN1(ADDRESS,.RESULTS)
        Q
        ;
EN1(ADDRESS,RESULTS,NOHEADERS)  ;
        N VALUE,PAGE,SERVER,PORT
        S NOHEADERS=$G(NOHEADERS,1)
        S PAGE="/",SERVER=ADDRESS,PORT=80
        I SERVER["/" D
        . I SERVER["//" S SERVER=$P(SERVER,"//",2)
        . I SERVER["/" S PAGE="/"_$P(SERVER,"/",2,99),SERVER=$P(SERVER,"/")
        . I SERVER[":" S PORT=$P(SERVER,":",2),SERVER=$P(SERVER,":")
        . Q
        S VALUE=$$ENTRY1(.RESULTS,SERVER,PORT,PAGE)
        D HOME^%ZIS ;I IO="|TCP|80" U IO D ^%ZISC
        ; if NOHEADERS selected (default) remove the headers and first blank line
        I NOHEADERS D
        . N I,J,X
        . ; remove header lines and first blank line
        . F I=1:1 Q:'$D(RESULTS(I))  S X=(RESULTS(I)="") K:'X RESULTS(I) I X K RESULTS(I) Q
        . ; move lines down to start at 1 again
        . S J=I,I=0 F  S J=J+1,I=I+1 Q:'$D(RESULTS(J))  S RESULTS(I)=RESULTS(J) K RESULTS(J)
        . Q
        Q
        ;
