ORWGAPI5        ; SLC/STAFF - Graph Items, Meds ;12/21/05  08:15
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
BCMA(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)       ; from ORWGAPIR
        N DATE,DRUG,ITEM,NUM,RESULT
        K ^TMP("ORWGRPC TEMP",$J)
        I FMT=6 D
        . S DATE=OLDEST
        . F  S DATE=$O(^PSB(53.79,"AADT",DFN,DATE)) Q:DATE<1  Q:DATE>NEWEST  D
        .. S NUM=0
        .. F  S NUM=$O(^PSB(53.79,"AADT",DFN,DATE,NUM)) Q:NUM<1  D
        ... S ITEM=$P($G(^PSB(53.79,NUM,0)),U,8) I 'ITEM Q
        ... I $D(^TMP("ORWGRPC TEMP",$J,ITEM)) Q
        ... S ^TMP("ORWGRPC TEMP",$J,ITEM)=""
        ... S CNT=CNT+1
        ... S RESULT="53.79^"_ITEM
        ... D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        I FMT'=6 D
        . S ITEM=""
        . F  S ITEM=$O(^PSB(53.79,"AOIP",DFN,ITEM)) Q:ITEM=""  D
        .. S DATE=$O(^PSB(53.79,"AOIP",DFN,ITEM,""),-1)
        .. I 'DATE Q
        .. S NUM=$O(^PSB(53.79,"AOIP",DFN,ITEM,DATE,""),-1)
        .. I 'NUM Q
        .. S CNT=CNT+1
        .. I FMT=3 S RESULT="53.79^"_ITEM_"^^"_$$POINAME^ORWGAPIC(ITEM)_"^^"_DATE
        .. I FMT=0 S RESULT="53.79^"_ITEM_U_$$POINAME^ORWGAPIC(ITEM)
        .. S DRUG=$$DRUG^ORWGAPIC(NUM)
        .. I DRUG S RESULT=RESULT_U_$$DRGCLASS^ORWGAPIC(DRUG)
        .. D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J)
        Q
        ;
DC(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP) ; from ORWGAPIR
        ; FMT,OLDEST,NEWEST not used
        N DATA,DATE,DATE1,DRUG,ITEM,FILE,NUM,REF,RESULT K DATA
        K ^TMP("ORWGRPC DC",$J)
        F FILE=52,55 D
        . S ITEM=""
        . F  S ITEM=$O(^PXRMINDX(FILE,"PI",DFN,ITEM)) Q:ITEM=""  D
        .. S RESULT=$$DRGCLASS^ORWGAPIC(ITEM)
        .. I RESULT="" Q
        .. S RESULT="50.605^"_RESULT
        .. S ^TMP("ORWGRPC DC",$J,RESULT)=""
        S ITEM=""
        F  S ITEM=$O(^PSB(53.79,"AOIP",DFN,ITEM)) Q:ITEM=""  D
        . S DATE=$O(^PSB(53.79,"AOIP",DFN,ITEM,""),-1)
        . I 'DATE Q
        . S NUM=$O(^PSB(53.79,"AOIP",DFN,ITEM,DATE,""),-1)
        . I 'NUM Q
        . S DRUG=$$DRUG^ORWGAPIC(NUM)
        . I 'DRUG Q
        . S RESULT=$$DRGCLASS^ORWGAPIC(DRUG)
        . I 'RESULT Q
        . S RESULT="50.605^"_RESULT
        . S ^TMP("ORWGRPC DC",$J,RESULT)=""
        S ITEM=""
        F  S ITEM=$O(^PXRMINDX("55NVA","PI",DFN,ITEM)) Q:ITEM=""  D
        . S DATE=$O(^PXRMINDX("55NVA","PI",DFN,ITEM,""),-1)
        . I 'DATE Q
        . S DATE1=$O(^PXRMINDX("55NVA","PI",DFN,ITEM,DATE,""),-1)
        . I '$L(DATE1) Q
        . S REF=$O(^PXRMINDX("55NVA","PI",DFN,ITEM,DATE,DATE1,""),-1)
        . I '$L(REF) Q
        . D RXNVA^ORWGAPIC(REF,.DATA)
        . S DRUG=+$G(DATA("DISPENSE DRUG"))
        . I 'DRUG Q
        . S RESULT=$$DRGCLASS^ORWGAPIC(DRUG)
        . I 'RESULT Q
        . S RESULT="50.605^"_RESULT
        . S ^TMP("ORWGRPC DC",$J,RESULT)=""
        S RESULT=""
        F  S RESULT=$O(^TMP("ORWGRPC DC",$J,RESULT)) Q:RESULT=""  S CNT=CNT+1 D
        . D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC DC",$J)
        Q
        ;
NVA(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)        ; from ORWGAPIR
        D NVA1^ORWGAPIE(.ITEMS,DFN,FMT,OLDEST,NEWEST,.CNT,.TMP)
        Q
        ;
