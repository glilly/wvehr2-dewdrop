ORWGTASK        ; SLC/STAFF - Graph Task ;3/17/08  10:48
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
SETLAST(PAT)    ; from ORWGAPI - set whenever patient is graphed
        N NOW,USER
        S PAT=+$G(PAT)
        S USER=+$G(DUZ)
        S NOW=$$NOW^ORWGAPIX
        I USER,PAT D
        . S ^XTMP("ORGDATA","TP",PAT)=NOW
        . S ^XTMP("ORGDATA","TP",PAT,"U",USER)=NOW
        . S ^XTMP("ORGDATA","TU",USER)=NOW
        . D COUNT("G",PAT,USER)
        Q
        ;
INIT(OK)        ; from ORMTIM02 - run by ORMTIME (OK=0) 
        N BACKTO,CNT,DFN,ITEM,LASTDFN,NOW,PURGE,TASKED,TIME
        S OK=+$G(OK,0)
        I $G(^XTMP("ORGRAPH","FORCE"))="ON" D  ; set in ORY243 (post-init v27)
        . S OK=1
        . D CLEANALL
        I 'OK D  ; unless forced, run one time on Saturday
        . I $P($G(^XTMP("ORGRAPH",0)),U,2)=DT Q
        . I $E(DT,6)="0",$$DOW^XLFDT(DT)="Saturday",$L($G(^XTMP("ORGRAPH",0))) D  Q  ; cleanup on 1st Sat of the month
        .. S OK=1
        .. D CLEANALL
        . I $$DOW^XLFDT(DT)="Saturday",$L($G(^XTMP("ORGRAPH",0))) S OK=1 Q
        I 'OK Q
        S BACKTO=$$FMADD^XLFDT(DT,-30) ;clear old data on non-graphed patients backto this date 
        S PURGE=$$FMADD^XLFDT(DT,180) ; when to purge XTMP nodes
        S NOW=$$NOW^ORWGAPIX
        S ^XTMP("ORGDATA",0)=PURGE_U_DT_U_"CPRS Graphing - Patient Data Cache Stats"_U_NOW
        S ^XTMP("ORGRAPH",0)=PURGE_U_DT_U_"CPRS Graphing - Patient Data Cache"
        S CNT=0
        S LASTDFN=0
        S DFN=""
        F  S DFN=$O(^XTMP("ORGDATA","TP",DFN)) Q:DFN=""  D
        . S TIME=$O(^XTMP("ORGDATA","TP",DFN))
        . I '$L(TIME) Q
        . I TIME<BACKTO D CLRDATA(DFN) Q
        . S ^XTMP("ORGRAPH","QUEUE",NOW_"^0^"_DFN)=NOW ; put patients to update on queue
        . S LASTDFN=DFN
        . S CNT=CNT+1
        . S OK=1
        D UPDATE(.TASKED,LASTDFN,0,0) ; last patient starts the updates
        S ^XTMP("ORGRAPH","INIT")=NOW_U_$$NOW^ORWGAPIX_U_CNT
        S ^XTMP("ORGDATA",0)=^XTMP("ORGDATA",0)_U_$$NOW^ORWGAPIX_U_CNT
        Q
        ;
CLEANALL        ;
        K ^XTMP("ORGDATA")
        K ^XTMP("ORGRAPH")
        Q
        ;
CLRDATA(DFN)    ;
        N PATUSER,USER
        S USER=.9
        F  S USER=$O(^XTMP("ORGDATA","TP",DFN,"U",USER)) Q:USER<1  D
        . S PATUSER=DFN_U_USER
        . K ^XTMP("ORGRAPH","ALL DATA",PATUSER)
        . K ^XTMP("ORGRAPH","ALL ITEMS",PATUSER)
        . K ^XTMP("ORGRAPH","ALL LABS",PATUSER)
        . K ^XTMP("ORGRAPH","OLD DATA",DFN)
        . K ^XTMP("ORGRAPH","OLD LABS",DFN)
        K ^XTMP("ORGDATA","TP",DFN)
        Q
        ;
UPDATE(TASKED,DFN,USER,OLDDFN)  ; from ORWGAPI
        ; whenever patient is selected
        ; to update, cache must exist and user/patient combo has used graphs
        ;D CLEANALL Q  ; ******** temporary disabled BA 1/16/08 *********
        N NOW,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE K ZTSAVE
        ;S ^XTMP("ZZZBOB")=$G(TASKED)_U_$G(DFN)_U_$G(USER)_U_$G(OLDDFN)
        S TASKED=-1 ; cache turned off
        I '$L($G(^XTMP("ORGRAPH",0))) Q
        S TASKED=0 ; not building cache
        I USER,DFN D COUNT("P",DFN,USER)
        I USER,'$G(^XTMP("ORGDATA","TU",USER)) Q  ; user must use graphing to cache
        I USER,OLDDFN D CLEARPT(OLDDFN,USER)
        I 'DFN Q
        I '$G(^XTMP("ORGDATA","TP",DFN)) Q  ; patient must be used with graphing to cache
        I USER,'$G(^XTMP("ORGDATA","TP",DFN,"U",USER)) Q  ; pat/user combo to cache **** comment this out for better graph speed - but more cache
        S TASKED=1 ; building cache
        S NOW=$$NOW^ORWGAPIX
        I USER D CLEARPT(DFN,USER)
        S ZTIO="ORWG GRAPHING RESOURCE",ZTDTH=$H,ZTDESC="process graph data"
        S ZTSAVE("ORMTIME")=$$MNOW
        S ZTSAVE("ORPAT")=DFN
        S ZTSAVE("ORTSTMP")=NOW
        S ZTSAVE("ORUSER")=USER
        S ZTRTN="UP^ORWGTASK"
        D ^%ZTLOAD
        Q
        ;
COUNT(EVENT,DFN,USER)   ;
        I EVENT="P" D  Q
        . S ^("C")=1+$G(^XTMP("ORGDATA","P",DFN,"C"))
        . S ^(USER)=1+$G(^XTMP("ORGDATA","P",DFN,"C-U",USER))
        . S ^("C")=1+$G(^XTMP("ORGDATA","U",USER,"C"))
        . S ^(DFN)=1+$G(^XTMP("ORGDATA","U",USER,"C-P",DFN))
        I EVENT="G" D  Q
        . S ^("CG")=1+$G(^XTMP("ORGDATA","P",DFN,"CG"))
        . S ^(USER)=1+$G(^XTMP("ORGDATA","P",DFN,"CG-U",USER))
        . S ^("CG")=1+$G(^XTMP("ORGDATA","U",USER,"CG"))
        . S ^(DFN)=1+$G(^XTMP("ORGDATA","U",USER,"CG-P",DFN))
        Q
        ;
CLEARPT(DFN,USER)       ;
        N PATUSER
        S PATUSER=DFN_U_USER
        K ^XTMP("ORGRAPH","ALL DATA",PATUSER)
        K ^XTMP("ORGRAPH","ALL ITEMS",PATUSER)
        K ^XTMP("ORGRAPH","ALL LABS",PATUSER)
        Q
        ;
UP      ; dequeued from ORWGTASK
        ; ORUSER, ORPAT, ORTSTMP were saved
        N GNOW,GSTAMP,NOW,STAMP
        S STAMP=ORTSTMP_U_ORUSER_U_ORPAT
        S GSTAMP=ORMTIME_U_ORUSER_U_ORPAT
        S NOW=$$NOW^ORWGAPIX
        S GNOW=$$MNOW
        I $D(ZTQUEUED) S ZTREQ="@"
        S ^XTMP("ORGRAPH","QUEUE",STAMP)=NOW_U_ORMTIME
        S ^XTMP("ORGDATA","Q",GSTAMP)=GSTAMP
        S ^XTMP("ORGDATA","QT",ORUSER_U_ORPAT)=ORMTIME
        D GSTAMP(GSTAMP,ORMTIME,GNOW,4)
        I 'ORUSER S $P(^XTMP("ORGRAPH","INIT"),U,4)=NOW
        I $G(^XTMP("ORGRAPH","STATUS"))'="ACTIVE" D START
        S ^XTMP("ORGRAPH","STATUS")="INACTIVE"
        Q
        ;
START   ;
        S ^XTMP("ORGRAPH","STATUS")="ACTIVE"
        N COUNT,MAX,NEXT,STOP,TIMES
        S MAX=5
        S COUNT=0
        S STOP=0
        S NEXT=""
        F  S NEXT=$O(^XTMP("ORGRAPH","QUEUE",NEXT)) D  Q:STOP
        . I NEXT="" D  Q
        .. H 1
        .. S COUNT=COUNT+1
        .. I COUNT>MAX S STOP=1 Q
        . S TIMES=^XTMP("ORGRAPH","QUEUE",NEXT)
        . K ^XTMP("ORGRAPH","QUEUE",NEXT)
        . D PROCESS(NEXT,TIMES)
        . K ^XTMP("ORGRAPH","QUEUE",NEXT)
        Q
        ;
PROCESS(NEXT,TIMES)     ;
        N DFN,GSTAMP,IN,OUT,TSTMP,USER
        S TSTMP=+$P(NEXT,U)
        S USER=+$P(NEXT,U,2)
        S DFN=$P(NEXT,U,3)
        S GSTAMP=$P(TIMES,U,2)_U_USER_U_DFN
        D ALL(GSTAMP,DFN,USER)
        I 'USER S $P(^XTMP("ORGRAPH","INIT"),U,5)=$$NOW^ORWGAPIX
        Q
        ;
ALL(GSTAMP,DFN,USER)    ;
        N BACKTO,CNT,LASTDATE,NUM,PATUSER,PREV,START,TIMED,TIMEI,TIMEL,TIMEZ,TYPE
        K ^TMP("ORGAI",$J),^TMP("ORGI",$J),^TMP("ORGT",$J)
        S START=$$NOW^ORWGAPIX
        S DFN=+$G(DFN) I 'DFN Q
        S USER=+$G(USER)
        S PATUSER=DFN_U_USER
        S TIMEI=START
        D GSTAMP(GSTAMP,+GSTAMP,$$MNOW,5)
        S GTIME=$$MNOW
        D TYPES^ORWGAPI("ORGT",DFN)
        I '$L($O(^TMP("ORGT",$J,""))) Q
        S NUM=""
        F  S NUM=$O(^TMP("ORGT",$J,NUM)) Q:NUM=""  D
        . S TYPE=$P(^TMP("ORGT",$J,NUM),U)
        . K ^TMP("ORGI",$J)
        . S CNT=0
        . D ITEMS^ORWGAPIR("ORGI",DFN,TYPE,3,,,.CNT,2)
        . M ^TMP("ORGAI",$J)=^TMP("ORGI",$J)
        K ^TMP("ORGI",$J)
        S PREV=1
        I '$D(^XTMP("ORGRAPH","OLD DATA",DFN)) S PREV=0
        I '$D(^XTMP("ORGRAPH","OLD LABS",DFN)) S PREV=0
        I USER D  ; user is 0 when doing init
        . L +^XTMP("ORGRAPH","ALL ITEMS",PATUSER):1 I '$T Q
        . M ^XTMP("ORGRAPH","ALL ITEMS",PATUSER)=^TMP("ORGAI",$J)
        . L -^XTMP("ORGRAPH","ALL ITEMS",PATUSER)
        S LASTDATE=+$G(^XTMP("ORGRAPH","LAST BUILD",DFN))
        I 'LASTDATE S LASTDATE=DT
        S BACKTO=$$FMADD^XLFDT(LASTDATE,-30) ; *** backto value is 30 days ********************
        S TIMED=$$NOW^ORWGAPIX
        D GETDATA("DATA",GSTAMP,GTIME,PATUSER,START,BACKTO)
        S TIMEL=$$NOW^ORWGAPIX
        D GETDATA("LABS",GSTAMP,GTIME,PATUSER,START,BACKTO)
        S TIMEZ=$$NOW^ORWGAPIX
        S ^XTMP("ORGRAPH","LAST BUILD",DFN)=DT
        K ^TMP("ORGAI",$J),^TMP("ORGI",$J),^TMP("ORGT",$J)
        Q
        ;
GETDATA(TYPES,GSTAMP,GTIME,PATUSER,START,BACKTO)        ;
        N ALLSUBS,CNT,DATA,DFN,NUM,NUM1,OLDSUBS,SUB,TYPEITEM,USER
        K ^TMP("ORGD",$J),^TMP("ORGID",$J),^TMP("ORGNI",$J)
        S OLDSUBS="OLD "_TYPES
        S ALLSUBS="ALL "_TYPES
        S DFN=+PATUSER
        S USER=+$P(PATUSER,U,2)
        S SIZE=0
        I $D(^XTMP("ORGRAPH",OLDSUBS,DFN)) D
        . S SUB=""
        . F  S SUB=$O(^TMP("ORGAI",$J,SUB)) Q:SUB=""  D
        .. S TYPEITEM=$G(^TMP("ORGAI",$J,SUB))
        .. I TYPES="DATA",$P(TYPEITEM,U)=63 Q
        .. I TYPES="LABS",$P(TYPEITEM,U)'=63 Q
        .. I $P(TYPEITEM,U,6)>BACKTO S ^TMP("ORGNI",$J,SUB)=TYPEITEM
        . S CNT=0
        . S NUM=""
        . F  S NUM=$O(^TMP("ORGNI",$J,NUM)) Q:NUM=""  D
        .. S TYPEITEM=^TMP("ORGNI",$J,NUM)
        .. D SIZE(TYPEITEM,START,DFN,BACKTO,.SIZE)
        . D GSTAMP(GSTAMP,GTIME,$$MNOW,6)
        . S $P(^XTMP("ORGDATA","Q",GSTAMP),U,16)=SIZE+$P(^XTMP("ORGDATA","Q",GSTAMP),U,16)
        E  D
        . S NUM=""
        . F  S NUM=$O(^TMP("ORGAI",$J,NUM)) Q:NUM=""  D
        .. S TYPEITEM=^TMP("ORGAI",$J,NUM)
        .. I TYPES="DATA",$P(TYPEITEM,U)=63 Q
        .. I TYPES="LABS",$P(TYPEITEM,U)'=63 Q
        .. D SIZE(TYPEITEM,START,DFN,2700101,.SIZE)
        . D GSTAMP(GSTAMP,GTIME,$$MNOW,7)
        . S $P(^XTMP("ORGDATA","Q",GSTAMP),U,17)=SIZE+$P(^XTMP("ORGDATA","Q",GSTAMP),U,17)
        S GTIME=$$MNOW
        M ^XTMP("ORGRAPH",OLDSUBS,DFN)=^TMP("ORGD",$J)
        I USER D  ; user is 0 when doing init
        . L +^XTMP("ORGRAPH",ALLSUBS,PATUSER):1 I '$T Q
        . M ^XTMP("ORGRAPH",ALLSUBS,PATUSER)=^XTMP("ORGRAPH",OLDSUBS,DFN)
        . L -^XTMP("ORGRAPH",ALLSUBS,PATUSER)
        K ^TMP("ORGD",$J),^TMP("ORGID",$J),^TMP("ORGNI",$J)
        D GSTAMP(GSTAMP,GTIME,$$MNOW,8)
        Q
        ;
SIZE(TYPEITEM,START,DFN,BACKTO,SIZE)    ;
        N DATA,NUM
        K ^TMP("ORGID",$J)
        D ITEMDATA^ORWGAPI("ORGID",TYPEITEM,START,DFN,BACKTO)
        S NUM=""
        F  S NUM=$O(^TMP("ORGID",$J,NUM)) Q:NUM=""  D
        . S DATA=^TMP("ORGID",$J,NUM)
        . S ^TMP("ORGD",$J,$P(DATA,U,1,3))=DATA
        . S SIZE=$L(DATA)+SIZE
        Q
        ;
RESOURCE        ; from ORWGAPIU on post init, setup graphing resource device
        N X
        S X=$$RES^XUDHSET("ORWG GRAPHING RESOURCE",,3,"CPRS GUI graphing data retrieval")
        Q
        ;
GSTAMP(GSTAMP,TIME1,TIME2,PIECE)        ;
        S $P(^XTMP("ORGDATA","Q",GSTAMP),"^",PIECE)=TIME2-TIME1
        Q
        ;
MNOW()  ;
        Q $$ZZ^ORWGAPIX
        ;
CLEAN   ;
        K ^XTMP("ORGRAPH")
        Q
        ;
