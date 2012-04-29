ORWGAPI2        ; SLC/STAFF - Graph API Items ;12/21/05  08:16
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,243**;Dec 17, 1997;Build 242
        ;
ADVERSE(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)    ; from ORWGAPIR
        N DATE,IEN,ITEM,RESULT
        K ^TMP("ORWGRPC SORT",$J),^TMP("ORWGRPC TEMP",$J)
        S IEN=0
        F  S IEN=$O(^GMR(120.8,"B",DFN,IEN)) Q:IEN<1  D
        . I '$D(^GMR(120.8,IEN,0)) Q
        . I $G(^GMR(120.8,IEN,"ER")) Q
        . I '$P(^GMR(120.8,IEN,0),U,12) Q
        . S DATE=+$P($G(^GMR(120.8,IEN,0)),U,4) I 'DATE Q
        . S ITEM=$P(^GMR(120.8,IEN,0),U,2) I '$L(ITEM) Q
        . S ^TMP("ORWGRPC SORT",$J,DATE,ITEM)="" ;ADVERSE
        I FMT=6 D
        . S DATE=OLDEST
        . F  S DATE=$O(^TMP("ORWGRPC SORT",$J,DATE)) Q:DATE<1  Q:DATE>NEWEST  D
        .. S ITEM=""
        .. F  S ITEM=$O(^TMP("ORWGRPC SORT",$J,DATE,ITEM)) Q:ITEM=""  D
        ... I $D(^TMP("ORWGRPC TEMP",$J,ITEM)) Q
        ... S ^TMP("ORWGRPC TEMP",$J,ITEM)=""
        ... S CNT=CNT+1
        ... S RESULT="120.8^"_ITEM
        ... D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        I FMT'=6 D
        . S DATE=0
        . F  S DATE=$O(^TMP("ORWGRPC SORT",$J,DATE)) Q:DATE<1  D
        .. S ITEM=""
        .. F  S ITEM=$O(^TMP("ORWGRPC SORT",$J,DATE,ITEM)) Q:ITEM=""  D
        ... I $D(^TMP("ORWGRPC TEMP",$J,ITEM)) Q
        ... S ^TMP("ORWGRPC TEMP",$J,ITEM)=""
        ... S CNT=CNT+1
        ... I FMT=3 S RESULT="120.8^"_ITEM_"^^"_ITEM_"^^"_DATE
        ... I FMT=0 S RESULT="120.8^"_ITEM_U_ITEM
        ... D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC SORT",$J),^TMP("ORWGRPC TEMP",$J)
        Q
        ;
PL(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP) ; from ORWGAPIR
        N DATE,ICD9,OK,PRIORITY,RESULT,STATUS
        K ^TMP("ORWGRPC TEMP",$J)
        S STATUS=""
        F  S STATUS=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS)) Q:STATUS=""  D
        . S PRIORITY=""
        . F  S PRIORITY=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY)) Q:PRIORITY=""  D
        .. S ICD9=""
        .. F  S ICD9=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY,ICD9)) Q:ICD9=""  D
        ... S OK=0
        ... I FMT=6 D
        .... S DATE=OLDEST
        .... F  S DATE=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY,ICD9,DATE)) Q:DATE=""  Q:DATE>NEWEST  D  Q:OK
        ..... S CNT=CNT+1
        ..... S OK=1
        ..... S RESULT=9000011_U_ICD9
        ... I FMT=3 D
        .... S DATE=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY,ICD9,""),-1)
        .... I DATE S ^TMP("ORWGRPC TEMP",$J,ICD9,DATE)=""
        ... I FMT=0 D
        .... S CNT=CNT+1
        .... S OK=1
        .... S RESULT=9000011_U_ICD9_U_$$EVALUE^ORWGAPIU(ICD9,9000011,.01)
        ... I OK D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        I FMT=3 D
        . S ICD9=""
        . F  S ICD9=$O(^TMP("ORWGRPC TEMP",$J,ICD9)) Q:ICD9=""  D
        .. S DATE=$O(^TMP("ORWGRPC TEMP",$J,ICD9,""),-1)
        .. I 'DATE Q
        .. S CNT=CNT+1
        .. S RESULT=9000011_U_ICD9_"^^"_$$EVALUE^ORWGAPIU(ICD9,9000011,.01)_"^^"_DATE
        .. D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J)
        Q
        ;
PLX(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)        ; from ORWGAPIR
        D PLX2^ORWGAPID(.ITEMS,DFN,FMT,OLDEST,NEWEST,.CNT,.TMP)
        Q
        ;
REG(ITEMS,DFN,FILE,FMT,OLDEST,NEWEST,CNT,TMP)   ; from ORWGAPIR
        N DATE,ICD,ITEM,NUM,OK,RESULT
        K ^TMP("ORWGRPC TEMP",$J)
        I $E(FILE,3,4)="DX" S ICD="ICD9"
        I $E(FILE,3,4)="OP" S ICD="ICD0"
        S NUM=""
        F  S NUM=$O(^PXRMINDX(45,ICD,"PNI",DFN,NUM)) Q:NUM=""  D
        . S ITEM=""
        . F  S ITEM=$O(^PXRMINDX(45,ICD,"PNI",DFN,NUM,ITEM)) Q:ITEM=""  D
        .. S OK=0
        .. I FMT=6 D
        ... S DATE=OLDEST
        ... F  S DATE=$O(^PXRMINDX(45,ICD,"PNI",DFN,NUM,ITEM,DATE)) Q:DATE=""  Q:DATE>NEWEST  D  Q:OK
        .... S CNT=CNT+1
        .... S OK=1
        .... S RESULT=FILE_U_ITEM
        .. I FMT=3 D
        ... S DATE=$O(^PXRMINDX(45,ICD,"PNI",DFN,NUM,ITEM,""),-1)
        ... I DATE S ^TMP("ORWGRPC TEMP",$J,ITEM,DATE)=""
        .. I FMT=0 D
        ... S CNT=CNT+1
        ... S OK=1
        ... S RESULT=FILE_U_ITEM_U_$$EVALUE^ORWGAPIU(ITEM,45_";"_ICD,.01)
        .. I OK D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        I FMT=3 D
        . S ITEM=""
        . F  S ITEM=$O(^TMP("ORWGRPC TEMP",$J,ITEM)) Q:ITEM=""  D
        .. S DATE=$O(^TMP("ORWGRPC TEMP",$J,ITEM,""),-1)
        .. I 'DATE Q
        .. S CNT=CNT+1
        .. S RESULT=FILE_U_ITEM_"^^"_$$EVALUE^ORWGAPIU(ITEM,45_";"_ICD,.01)_"^^"_DATE
        .. D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J)
        Q
        ;
