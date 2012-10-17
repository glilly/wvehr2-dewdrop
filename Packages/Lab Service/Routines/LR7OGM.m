LR7OGM  ;DALOI/STAFF- Interim report rpc memo ;7/1/09  07:28
        ;;5.2;LAB SERVICE;**187,220,312,286,395**;Sep 27, 1994;Build 27
        ;
TEST    ; test use only
        N TESTS,I K TESTS,^TMP("LR7OGX",$J)
        ;S TESTS(548)=548
        ;F I=1:1:10 I $D(^LAB(60,I,0)) S TESTS(I)=I
        D SELECT(16,3090730,2700202,.TESTS,1,0)
        S I=0 F  S I=$O(^TMP("LR7OGX",$J,"OUTPUT",I)) Q:I<1  W !,^(I)
        K ^TMP("LR7OGX",$J)
        Q
        ;
INTERIM(ROOT,DFN,SDATE,EDATE)   ; from ORWLRR
        N FORMAT,MICROCHK,TESTS K TESTS
        S (FORMAT,MICROCHK)=""
        S ROOT=$NA(^TMP("LR7OGX",$J,"OUTPUT"))
        D SELECT(DFN,SDATE,EDATE,.TESTS,FORMAT,MICROCHK) ;
        Q
        ;
INTERIMG(ROOT,DFN,SDATE,DIR,FORMAT)     ; from ORWLRR
        N MICROCHK,TESTS K TESTS
        S MICROCHK=1,FORMAT=$G(FORMAT,1)
        S ROOT=$NA(^TMP("LR7OGX",$J,"OUTPUT"))
        D SELECT(DFN,SDATE,DIR,.TESTS,FORMAT,MICROCHK) ;
        Q
        ;
INTERIMS(ROOT,DFN,SDATE,EDATE,TESTLIST) ; from ORWLRR
        N FORMAT,MICROCHK,NUM,TESTS K TESTS
        S (FORMAT,MICROCHK)=""
        S NUM=0 F  S NUM=$O(TESTLIST(NUM)) Q:NUM<1  S TESTS(+TESTLIST(NUM))=""
        S ROOT=$NA(^TMP("LR7OGX",$J,"OUTPUT"))
        D SELECT(DFN,SDATE,EDATE,.TESTS,FORMAT,MICROCHK) ;
        Q
        ;
MICRO(ROOT,DFN,SDATE,EDATE)     ; from ORWLRR
        N FORMAT,MICROCHK,TESTS K TESTS
        S FORMAT="",MICROCHK=-1
        S ROOT=$NA(^TMP("LR7OGX",$J,"OUTPUT"))
        D SELECT(DFN,SDATE,EDATE,.TESTS,FORMAT,MICROCHK) ;
        Q
        ;
SELECT(DFN,SDATE,EDATE,TESTS,FORMAT,MICROCHK)   ;
        ; get patient info, and expand tests
        ; route setup chem and/or micro data
        ; 9th piece of output indicates FORMAT, when set, seems to get used when evaluating next result
        ;     (2: CH subscript, 3: MI subscript, else 1 or "")
        N AGE,ALL,ASK,AVAIL,CNIDT,DIRECT,DONE,SKIP,EDT,FOK,I,IDT,LRCAN,LRDFN,MICROSUB,MNIDT,OUTCNT,PNM,ROUTE,SEX,SDT,NEWOLD
        K MICROSUB
        K ^TMP("LR7OG",$J),^TMP("LR7OGX",$J,"OUTPUT"),^TMP("LRPLS",$J)
        S OUTCNT=1,DONE=0,SKIP=0
        D DEMO^LR7OGU(DFN,.LRDFN,.PNM,.AGE,.SEX)
        I '$G(LRDFN) Q
        D NEWOLD^LR7OGMU(.NEWOLD,DFN)
        S ^TMP("LR7OG",$J,"G")=DFN_U_PNM_U_LRDFN_U_AGE_U_SEX_"^8"
        S ALL=$S($O(TESTS(0)):0,1:1)
        I 'ALL D TESTSGET^LR7OGU(.TESTS,.MICROSUB)
        S DIRECT=1
        I FORMAT S DIRECT=EDATE,EDATE=2700101
        S EDATE=EDATE\1
        S (IDT,SDT)=9999999-SDATE,EDT=9999999-EDATE
        I FORMAT>1 S FOK=0 D  I FOK Q
        . I DIRECT=1 D  Q
        .. I FORMAT=2 D  Q
        ... D MI^LR7OGMM(LRDFN,IDT,.MICROSUB,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ... I SKIP S SKIP=0 Q
        ... S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=3
        ... S FOK=1
        .. I FORMAT=3 D  Q
        ... S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=1
        . I DIRECT=-1 D  Q
        .. I FORMAT=2 D  Q
        ... S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=1
        .. I FORMAT=3 D  Q
        ... D CH^LR7OGMC(LRDFN,IDT,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ... I SKIP S SKIP=0 Q
        ... S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=2
        ... S FOK=1
        I ALL S ASK="BOTH"
        E  I $O(MICROSUB(0)) D
        . S ASK="MI" I $O(^TMP("LR7OG",$J,"TMP",0)) S ASK="BOTH"
        E  S ASK="CH"
        S I=IDT,CNIDT=0 F  S I=$O(^LR(LRDFN,"CH",I),DIRECT) Q:'I  S CNIDT=I Q
        S I=IDT,MNIDT=0 F  S I=$O(^LR(LRDFN,"MI",I),DIRECT) Q:'I  S MNIDT=I Q
        S AVAIL="NONE"
        I CNIDT,CNIDT'>EDT D
        . S AVAIL="CH" I MNIDT,MNIDT'>EDT S AVAIL="BOTH"
        E  I MNIDT,MNIDT'>EDT S AVAIL="MI"
        I DIRECT=-1 S AVAIL="BOTH"
        S ROUTE="NONE"
        I ASK="BOTH" S ROUTE=AVAIL
        I ASK="CH",AVAIL="CH"!(AVAIL="BOTH") S ROUTE="CH"
        I ASK="MI",AVAIL="MI"!(AVAIL="BOTH") S ROUTE="MI"
        I MICROCHK=-1 S ROUTE="MI"
        I ROUTE="NONE" D  Q
        . K ^TMP("LR7OG",$J)
        ;
        I ROUTE="CH" D  Q
        . F  S IDT=$O(^LR(LRDFN,"CH",IDT),DIRECT) Q:IDT<1  Q:IDT>EDT  D  Q:DONE
        .. D CH^LR7OGMC(LRDFN,IDT,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        .. I SKIP S SKIP=0
        . I 'FORMAT,$D(^TMP("LRPLS",$J)) D PLS^LR7OGMP
        . K ^TMP("LR7OG",$J),^TMP("LRPLS",$J)
        ;
        I ROUTE="MI" D  Q
        . F  S IDT=$O(^LR(LRDFN,"MI",IDT),DIRECT) Q:IDT<1  Q:IDT>EDT  D  Q:DONE
        .. D MI^LR7OGMM(LRDFN,IDT,.MICROSUB,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        .. I SKIP S SKIP=0
        . K ^TMP("LR7OG",$J)
        F  D  Q:DONE
        . S I=IDT,CNIDT=0 F  S I=$O(^LR(LRDFN,"CH",I),DIRECT) Q:'I  S CNIDT=I Q
        . S I=IDT,MNIDT=0 F  S I=$O(^LR(LRDFN,"MI",I),DIRECT) Q:'I  S MNIDT=I Q
        . I 'CNIDT,'MNIDT S DONE=1 Q
        . D  I IDT>EDT S DONE=1 Q
        .. I CNIDT=MNIDT D  Q  ; both chem and micro at this date/time
        ... S IDT=CNIDT
        ... I IDT'>EDT D
        .... I FORMAT D  Q
        ..... I SDT=(9999999-2700101)!(DIRECT=-1) D  Q
        ...... D MI^LR7OGMM(LRDFN,IDT,.MICROSUB,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ...... I SKIP S SKIP=0 D  Q
        ....... D CH^LR7OGMC(LRDFN,IDT,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ....... I SKIP S SKIP=0 Q
        ....... I $P(NEWOLD,"^",1),$P(NEWOLD,"^",1)'=IDT S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=3 Q
        ....... S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=1
        ...... S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=3
        ..... D CH^LR7OGMC(LRDFN,IDT,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ..... I SKIP S SKIP=0 D  Q
        ...... D MI^LR7OGMM(LRDFN,IDT,.MICROSUB,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ...... I SKIP S SKIP=0 Q
        ...... I $P(NEWOLD,"^",1),$P(NEWOLD,"^",1)'=IDT S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=3 Q
        ...... S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=1
        ..... I $P(NEWOLD,"^",1),$P(NEWOLD,"^",1)'=IDT S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=2 Q
        ..... S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,9)=2
        .... I MICROCHK'=1 D  Q:DONE
        ..... D CH^LR7OGMC(LRDFN,IDT,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ..... I SKIP S SKIP=0 Q
        ..... I FORMAT S MICROCHK=1
        .... D MI^LR7OGMM(LRDFN,IDT,.MICROSUB,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        .... I SKIP S SKIP=0 Q
        .. I 'MNIDT D  Q  ; no micro since this date/time, only chem at this date/time
        ... S IDT=CNIDT
        ... I IDT'>EDT D CH^LR7OGMC(LRDFN,IDT,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ... I SKIP S SKIP=0 Q
        .. I 'CNIDT D  Q  ; no chem since this date/time, only micro at this date/time
        ... S IDT=MNIDT
        ... I IDT'>EDT D MI^LR7OGMM(LRDFN,IDT,.MICROSUB,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ... I SKIP S SKIP=0 Q
        .. I (DIRECT=1&(CNIDT<MNIDT))!(DIRECT=-1&(CNIDT>MNIDT)) D  Q  ;chem and micro data, chem is more recent
        ... S IDT=CNIDT
        ... I IDT'>EDT D CH^LR7OGMC(LRDFN,IDT,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        ... I SKIP S SKIP=0 Q
        .. S IDT=MNIDT
        .. I IDT'>EDT D MI^LR7OGMM(LRDFN,IDT,.MICROSUB,ALL,.OUTCNT,FORMAT,.DONE,.SKIP)
        .. I SKIP S SKIP=0 Q
        ;
        I 'FORMAT,$D(^TMP("LRPLS",$J)) D PLS^LR7OGMP
        ;
        K ^TMP("LR7OG",$J),^TMP("LRPLS",$J)
        Q
