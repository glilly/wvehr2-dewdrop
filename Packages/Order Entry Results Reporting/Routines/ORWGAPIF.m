ORWGAPIF        ; SLC/STAFF - Graph Fast Data Retrieval ;11/1/06  12:49
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
FASTDATA(DATA,DFN)      ; from ORWGAPI
        I '$G(DFN) Q
        D FAST(.DATA,DFN,"ALL DATA")
        Q
        ;
FASTITEM(DATA,DFN)      ; from ORWGAPI
        I '$G(DFN) Q
        D FAST(.DATA,DFN,"ALL ITEMS")
        Q
        ;
FASTLABS(DATA,DFN)      ; from ORWGAPI
        I '$G(DFN) Q
        D FAST(.DATA,DFN,"ALL LABS")
        Q
        ;
FAST(DATA,DFN,SOURCE)   ;
        I '$L($G(^XTMP("ORGRAPH",0))) Q
        I '$G(DFN) Q
        I '$G(DUZ) Q
        N OK,PATUSER
        S PATUSER=DFN_U_DUZ
        S OK=0
        I $L($O(^XTMP("ORGRAPH",SOURCE,PATUSER,""))) S OK=1
        D LOG(DFN,DUZ,SOURCE)
        I 'OK Q
        L +^XTMP("ORGRAPH",SOURCE,PATUSER):3 I '$T Q  ; wait 3 sec for merge
        S DATA=$NA(^XTMP("ORGRAPH",SOURCE,PATUSER))
        L -^XTMP("ORGRAPH",SOURCE,PATUSER)
        Q
        ;
LOG(DFN,USER,SOURCE)    ;
        N GOLD,GNOW,GSTAMP,PATUSER,LINE,SIZE
        S GOLD=$G(^XTMP("ORGDATA","QT",USER_U_DFN))
        I 'GOLD Q
        S GSTAMP=GOLD_U_USER_U_DFN
        S PATUSER=DFN_U_USER
        I '$D(^XTMP("ORGDATA","Q",GSTAMP)) Q
        S GNOW=$$MNOW^ORWGTASK
        S SIZE=0
        S LINE=""
        F  S LINE=$O(^XTMP("ORGRAPH",SOURCE,PATUSER,LINE)) Q:LINE=""  D
        . S SIZE=$L(^XTMP("ORGRAPH",SOURCE,PATUSER,LINE))+SIZE
        I SOURCE="ALL ITEMS" D  Q
        . S $P(^XTMP("ORGDATA","Q",GSTAMP),U,13)=SIZE
        . I $P($G(^XTMP("ORGDATA","Q",GSTAMP)),U,10)<1 D
        .. D GSTAMP^ORWGTASK(GSTAMP,GOLD,GNOW,9)
        . S $P(^XTMP("ORGDATA","Q",GSTAMP),U,10)=(1+$P($G(^XTMP("ORGDATA","Q",GSTAMP)),U,10))
        I SOURCE="ALL LABS" D  Q
        . S $P(^XTMP("ORGDATA","Q",GSTAMP),U,14)=SIZE
        . D GSTAMP^ORWGTASK(GSTAMP,GOLD,GNOW,11)
        I SOURCE="ALL DATA" D  Q
        . S $P(^XTMP("ORGDATA","Q",GSTAMP),U,15)=SIZE
        . D GSTAMP^ORWGTASK(GSTAMP,GOLD,GNOW,12)
        Q
        ;
