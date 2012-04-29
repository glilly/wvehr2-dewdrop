ORWGAPIB        ; SLC/STAFF - Graph Blood Bank ;12/21/05  08:21
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,243**;Dec 17, 1997;Build 242
        ;
BBITEM(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)     ; from ORWGAPIR
        N DATE,IDATE,INEWEST,IOLDEST,ITEM,LRDFN,OK,RESULT
        K ^TMP("ORWGRPC TEMP",$J)
        S INEWEST=$$LRIDT^ORWGAPIC(NEWEST),IOLDEST=$$LRIDT^ORWGAPIC(OLDEST)
        S LRDFN=$$LRDFN^ORWGAPIC(DFN)
        S IDATE=0
        F  S IDATE=$O(^LR(LRDFN,1.6,IDATE)) Q:IDATE<1  D
        . S ITEM=+$P($G(^LR(LRDFN,1.6,IDATE,0)),U,2)
        . I 'ITEM Q
        . S OK=0
        . I FMT=6 D
        .. Q:IDATE<INEWEST  Q:IDATE>IOLDEST
        .. S OK=1
        .. S CNT=CNT+1
        .. S RESULT="63BB"_U_ITEM
        . I FMT=3 D
        .. I '$D(^TMP("ORWGRPC TEMP",$J,ITEM)) D
        ... S OK=1
        ... S ^TMP("ORWGRPC TEMP",$J,ITEM)=""
        ... S DATE=$$LRIDT^ORWGAPIC(IDATE)
        ... S CNT=CNT+1
        ... S RESULT="63BB^"_ITEM_"^^"_$P($G(^LAB(66,ITEM,0)),U)_"^^"_DATE
        . I FMT=0 D
        .. S OK=1
        .. S CNT=CNT+1
        .. S RESULT="63BB^"_ITEM_U_$P($G(^LAB(66,ITEM,0)),U)
        . I OK D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J)
        Q
        ;
BBDATA(DATA,ITEM,START,DFN,CNT,TMP,BACKTO)      ; from ORWGAPIR
        N DATE,IDATE,LRDFN,NITEM,RESULT
        S LRDFN=$$LRDFN^ORWGAPIC(DFN)
        S IDATE="",CNT=$G(CNT),BACKTO=+$G(BACKTO)
        F  S IDATE=$O(^LR(LRDFN,1.6,IDATE)) Q:IDATE=""  D
        . S NITEM=+$P($G(^LR(LRDFN,1.6,IDATE,0)),U,2)
        . I NITEM'=ITEM Q
        . S DATE=$$LRIDT^ORWGAPIC(IDATE)
        . I DATE>START Q
        . I DATE<BACKTO Q
        . S RESULT="63BB^"_ITEM_U_DATE_U
        . D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
BBX(DFN)        ; $$(dfn) -> 1 if patient has blood bank data ,else 0
        Q $L($O(^LR(+$$LRDFN^ORWGAPIC($G(DFN)),1.6,"")))>0
        ;
