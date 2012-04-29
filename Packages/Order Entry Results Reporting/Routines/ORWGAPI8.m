ORWGAPI8        ; SLC/STAFF - Graph Data, non-index ;8/21/06  07:52
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
ADMIT(DATA,ITEM,START,DFN,CNT,TMP,BACKTO)       ; from ORWGAPIR
        N DATE,DATE2,DISCH,LINE,LST,NUM,RESULT,VALUE K LST
        S DATE="",DATE2="",CNT=$G(CNT),BACKTO=+$G(BACKTO)
        S ITEM=$G(ITEM,"ADMIT")
        D ADMITLST^ORWPT(.LST,DFN)
        S NUM=0
        F  S NUM=$O(LST(NUM)) Q:NUM<1  D
        . S LINE=LST(NUM)
        . S DATE=$P(LINE,U)
        . I DATE>START Q
        . S DISCH=$P(LINE,U,5)
        . S DATE2=$$DISCH^ORWGAPIA(DISCH)
        . I DATE2="" D
        .. S DATE2=$$FMADD^ORWGAPIX(DATE,$$LOS^ORWGAPIA(DISCH)+1)
        .. I DATE2=-1 S DATE2=$$FMADD^ORWGAPIX(DT,1) ; just make it today + 1
        .. S DATE2=DATE2\1
        . S VALUE=$P(LINE,U,3)_"  "_$P(LINE,U,4)_U_$P(LINE,U,5,6)
        . S CNT=CNT+1
        . S RESULT=405_U_ITEM_U_DATE_U_DATE2_U_VALUE
        . D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
SURG(DATA,ITEM,START,DFN,CNT,TMP,BACKTO)        ; from ORWGAPIR
        N CASE,DATE,DATE2,NUM,PROC,RESULT,RESULTS,SURG,SURGPROC,VALUE K SURG,SURGPROC
        S DATE2="",CNT=$G(CNT),BACKTO=+$G(BACKTO)
        D SURG^ORWGAPIA(.SURG,DFN)
        K SURG(0),SURG(1)
        S ITEM=$$UP^ORWGAPIX(ITEM)
        S NUM=0
        S CASE=0
        F  S CASE=$O(SURG(CASE)) Q:CASE<1  D
        . S RESULTS=SURG(CASE)
        . S PROC=$P(RESULTS,U,3)
        . I '$L(PROC) Q
        . S PROC=$$UP^ORWGAPIX(PROC)
        . I PROC'=ITEM Q
        . S NUM=NUM+1
        . S SURGPROC(PROC,NUM)=RESULTS
        K SURG
        S PROC=""
        F  S PROC=$O(SURGPROC(PROC)) Q:PROC=""  D
        . S NUM=0
        . F  S NUM=$O(SURGPROC(PROC,NUM)) Q:NUM<1  D
        .. S RESULTS=SURGPROC(PROC,NUM)
        .. S DATE=$P(RESULTS,U,5)
        .. I DATE>START Q
        .. I DATE<BACKTO Q
        .. S VALUE=""
        .. S RESULT=130_U_PROC_U_DATE_U_DATE2_U_VALUE
        .. S CNT=CNT+1
        .. D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
VISIT(DATA,ITEM,START,DFN,CNT,TMP,BACKTO)       ; from ORWGAPIR
        N DATE,DATE2,NODE,NUM,RESULT,VALUE
        S DATE="",DATE2="",CNT=$G(CNT),BACKTO=+$G(BACKTO)
        F  S DATE=$O(^AUPNVSIT("AET",DFN,DATE)) Q:DATE=""  D
        . I DATE>START Q
        . I DATE<BACKTO Q
        . S NODE=""
        . F  S NODE=$O(^AUPNVSIT("AET",DFN,DATE,ITEM,NODE)) Q:NODE=""  D
        .. S NUM=0
        .. F  S NUM=$O(^AUPNVSIT("AET",DFN,DATE,ITEM,NODE,NUM)) Q:NUM=""  D
        ... S DATE2=+$P($G(^AUPNVSIT(NUM,0)),U,18)
        ... I 'DATE2 S DATE2=DATE+.01
        ... I +$E($P(DATE2,".",2),1,2)>24 S DATE2=(DATE\1)+.2359
        ... S VALUE=""
        ... S CNT=CNT+1
        ... S RESULT=9000010_U_ITEM_U_DATE_U_DATE2_U_VALUE
        ... D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
