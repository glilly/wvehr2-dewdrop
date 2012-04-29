ORWGAPI6        ; SLC/STAFF - Graph API Items, non-indexed ;12/21/05  08:16
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
ADMITS(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)     ; from ORWGAPIR
        N DATE,DATE2,DISCH,LINE,LST,NUM,OK,RESULT K LST
        K ^TMP("ORWGRPC TEMP",$J)
        D ADMITLST^ORWPT(.LST,DFN)
        S OK=0
        S NUM=0
        F  S NUM=$O(LST(NUM)) Q:NUM<1  D  Q:OK
        . S LINE=LST(NUM)
        . S DATE=$P(LINE,U)
        . S DISCH=$P(LINE,U,5)
        . S DATE2=$$DISCH^ORWGAPIA(DISCH)
        . I DATE2="" S DATE2=DATE2\1
        . I FMT=6 D  Q
        .. I DATE>NEWEST Q
        .. I DATE2>0,DATE2<OLDEST Q
        .. I $D(^TMP("ORWGRPC TEMP",$J,"ADMIT")) Q
        .. S ^TMP("ORWGRPC TEMP",$J,"ADMIT")=""
        .. S CNT=CNT+1
        .. S OK=1
        .. S RESULT="405^ADMIT"
        . I FMT=3 D  Q
        .. I $D(^TMP("ORWGRPC TEMP",$J,"ADMIT")) Q
        .. S ^TMP("ORWGRPC TEMP",$J,"ADMIT")=""
        .. S CNT=CNT+1
        .. S OK=1
        .. S RESULT="405^ADMIT^^ADMIT^^"_DATE
        . I FMT=0 D  Q
        .. S ^TMP("ORWGRPC TEMP",$J,"ADMIT")=""
        .. S CNT=CNT+1
        .. S OK=1
        .. S RESULT="405^ADMIT^ADMIT"
        I OK D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J)
        Q
        ;
SURGERY(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)    ; from ORWGAPIR
        N CASE,DATE,PROC,RESULT,RESULTS,SURG,SURGPROC K SURG,SURGPROC
        D SURG^ORWGAPIA(.SURG,DFN)
        K SURG(0),SURG(1)
        I FMT=6 D
        . S CASE=0
        . F  S CASE=$O(SURG(CASE)) Q:CASE<1  D
        .. S RESULTS=SURG(CASE)
        .. S PROC=$P(RESULTS,U,3)
        .. I '$L(PROC) Q
        .. S DATE=$P(RESULTS,U,5)
        .. I DATE>NEWEST Q
        .. I DATE<OLDEST Q
        .. I $D(SURGPROC(PROC)) Q
        .. S SURGPROC(PROC)=""
        .. S CNT=CNT+1
        .. S RESULT=130_U_PROC
        .. D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        I FMT'=6 D
        . S CASE=0
        . F  S CASE=$O(SURG(CASE)) Q:CASE<1  D
        .. S RESULTS=SURG(CASE)
        .. S PROC=$P(RESULTS,U,3)
        .. I '$L(PROC) Q
        .. S SURGPROC(PROC)=RESULTS
        . K SURG S PROC=""
        . F  S PROC=$O(SURGPROC(PROC)) Q:PROC=""  D
        .. S CNT=CNT+1
        .. I FMT=3 S RESULT=130_U_PROC_"^^"_PROC_"^^"_$P(SURGPROC(PROC),U,5)
        .. I FMT=0 S RESULT=130_U_PROC_U_PROC
        .. D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        Q
        ;
VISITS(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)     ; from ORWGAPIR
        N DATE,DATE2,ITEM,NODE,NUM,OK,RESULT
        K ^TMP("ORWGRPC TEMP",$J)
        I FMT=6 D
        . S DATE=0
        . F  S DATE=$O(^AUPNVSIT("AET",DFN,DATE)) Q:DATE<1  Q:DATE>NEWEST  D
        .. S ITEM=""
        .. F  S ITEM=$O(^AUPNVSIT("AET",DFN,DATE,ITEM)) Q:ITEM=""  D
        ... S NODE=""
        ... F  S NODE=$O(^AUPNVSIT("AET",DFN,DATE,ITEM,NODE)) Q:NODE=""  D
        .... S NUM=0
        .... F  S NUM=$O(^AUPNVSIT("AET",DFN,DATE,ITEM,NODE,NUM)) Q:NUM=""  D
        ..... S DATE2=+$P($G(^AUPNVSIT(NUM,0)),U,18)
        ..... I 'DATE2 S DATE2=DATE+.01
        ..... I +$E($P(DATE2,".",2),1,2)>24 S DATE2=(DATE\1)+.2359
        ..... S ^TMP("ORWGRPC TEMP",$J,ITEM,DATE)=DATE2
        . S ITEM=0
        . F  S ITEM=$O(^TMP("ORWGRPC TEMP",$J,ITEM)) Q:ITEM<1  D
        .. S OK=0
        .. S DATE=0
        .. F  S DATE=$O(^TMP("ORWGRPC TEMP",$J,ITEM,DATE)) Q:DATE<1  Q:DATE>NEWEST  D  Q:OK
        ... S DATE2=$G(^TMP("ORWGRPC TEMP",$J,ITEM,DATE))
        ... I DATE2<OLDEST Q
        ... S CNT=CNT+1
        ... S OK=1
        ... S RESULT="9000010^"_ITEM
        ... D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        I FMT'=6 D
        . S DATE=0
        . F  S DATE=$O(^AUPNVSIT("AET",DFN,DATE)) Q:DATE<1  D
        .. S ITEM=0
        .. F  S ITEM=$O(^AUPNVSIT("AET",DFN,DATE,ITEM)) Q:ITEM<1  D
        ... I $D(^TMP("ORWGRPC TEMP",$J,ITEM)) Q
        ... S ^TMP("ORWGRPC TEMP",$J,ITEM)=""
        ... S CNT=CNT+1
        ... I FMT=3 S RESULT="9000010^"_ITEM_"^^"_$$EVALUE^ORWGAPIU(ITEM,9000010,.22)_"^^"_DATE
        ... I FMT=0 S RESULT="9000010^"_ITEM_U_$$EVALUE^ORWGAPIU(ITEM,9000010,.22)
        ... D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J)
        Q
        ;
