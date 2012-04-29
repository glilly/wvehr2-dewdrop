ORWGAPI1        ; SLC/STAFF - Graph Items ;12/21/05  08:15
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,243**;Dec 17, 1997;Build 242
        ;
AA(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP) ; from ORWGAPIR
        ; FMT,OLDEST,NEWEST not used
        N ITEM,FILE,NUM,REF,RESULT
        K ^TMP("ORWGRPC DC",$J)
        S ITEM=""
        F  S ITEM=$O(^PXRMINDX(63,"PI",DFN,ITEM)) Q:ITEM=""  D
        . I $E(ITEM)="A" Q
        . I $E(ITEM)="M" Q
        . S RESULT=$$AALAB^ORWGAPIC(ITEM)
        . I RESULT="" Q
        . S RESULT="68^"_RESULT
        . S ^TMP("ORWGRPC DC",$J,RESULT)=""
        S RESULT=""
        F  S RESULT=$O(^TMP("ORWGRPC DC",$J,RESULT)) Q:RESULT=""  S CNT=CNT+1 D
        . D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC DC",$J)
        Q
        ;
AP(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP) ; from ORWGAPIR
        N DATE,ITEM,OK,RESULT
        S ITEM="A"
        F  S ITEM=$O(^PXRMINDX(63,"PI",DFN,ITEM)) Q:ITEM=""  Q:ITEM]"AZ"  D
        . S OK=0
        . I FMT=6 D
        .. S DATE=OLDEST
        .. F  S DATE=$O(^PXRMINDX(63,"PI",DFN,ITEM,DATE)) Q:DATE=""  Q:DATE>NEWEST  D  Q:OK
        ... S CNT=CNT+1
        ... S OK=1
        ... S RESULT="63AP"_U_ITEM
        . I FMT=3 D
        .. S DATE=$O(^PXRMINDX(63,"PI",DFN,ITEM,""),-1)
        .. I 'DATE Q
        .. S OK=1
        .. S CNT=CNT+1
        .. S RESULT="63AP^"_ITEM_"^^"_$$ITEMPRFX^ORWGAPIU(ITEM)_": "_$$EVALUE^ORWGAPIU(ITEM,63,.01)_"^^"_DATE
        . I FMT=0 D
        .. S OK=1
        .. S CNT=CNT+1
        .. S RESULT="63AP^"_ITEM_U_$$ITEMPRFX^ORWGAPIU(ITEM)_": "_$$EVALUE^ORWGAPIU(ITEM,63,.01)
        . I OK D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        Q
        ;
LAB(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)        ; from ORWGAPIR
        N DATE,ITEM,OK,RESULT
        S ITEM=0
        F  S ITEM=$O(^PXRMINDX(63,"PI",DFN,ITEM)) Q:ITEM<1  D
        . S OK=0
        . I FMT=6 D
        .. S DATE=OLDEST
        .. F  S DATE=$O(^PXRMINDX(63,"PI",DFN,ITEM,DATE)) Q:DATE=""  Q:DATE>NEWEST  D  Q:OK
        ... S CNT=CNT+1
        ... S OK=1
        ... S RESULT=63_U_ITEM
        . I FMT=3 D
        .. S DATE=$O(^PXRMINDX(63,"PI",DFN,ITEM,""),-1)
        .. I 'DATE Q
        .. S CNT=CNT+1
        .. S OK=1
        .. S RESULT=63_U_ITEM_"^^"_$$EVALUE^ORWGAPIU(ITEM,63,.01)_"^^"_DATE
        . I FMT=0 D
        .. S CNT=CNT+1
        .. S OK=1
        .. S RESULT=63_U_ITEM_U_$$EVALUE^ORWGAPIU(ITEM,63,.01)
        . I OK D
        .. S RESULT=RESULT_U_$$AALAB^ORWGAPIC(ITEM)
        .. D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        Q
        ;
MI(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP) ; from ORWGAPIR
        N DATE,ITEM,OK,RESULT
        S ITEM="M"
        F  S ITEM=$O(^PXRMINDX(63,"PI",DFN,ITEM)) Q:ITEM=""  Q:ITEM]"MZ"  D
        . S OK=0
        . I FMT=6 D
        .. S DATE=OLDEST
        .. F  S DATE=$O(^PXRMINDX(63,"PI",DFN,ITEM,DATE)) Q:DATE=""  Q:DATE>NEWEST  D  Q:OK
        ... S CNT=CNT+1
        ... S OK=1
        ... S RESULT="63MI"_U_ITEM
        . I FMT=3 D
        .. S DATE=$O(^PXRMINDX(63,"PI",DFN,ITEM,""),-1)
        .. I 'DATE Q
        .. S CNT=CNT+1
        .. S OK=1
        .. S RESULT="63MI^"_ITEM_"^^"_$$ITEMPRFX^ORWGAPIU(ITEM)_": "_$$EVALUE^ORWGAPIU(ITEM,63,.01)_"^^"_DATE
        . I FMT=0 D
        .. S CNT=CNT+1
        .. S OK=1
        .. S RESULT="63MI^"_ITEM_U_$$ITEMPRFX^ORWGAPIU(ITEM)_": "_$$EVALUE^ORWGAPIU(ITEM,63,.01)
        . I OK D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        Q
        ;
MED(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)        ; from ORWGAPIR
        D MED1^ORWGAPIE(.ITEMS,DFN,FMT,OLDEST,NEWEST,.CNT,.TMP)
        Q
        ;
NOTES(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)      ; from ORWGAPIR
        N DATE,DOC,DOCCLASS,DOCIEN,DOCTYPE,DUMMY,RESULT,RESULTS,TITLE K DUMMY
        K ^TMP("ORWGRPC TEMP",$J),^TMP("TIUR",$J)
        S CNT=$G(CNT)
        I FMT=6 D
        . F DOCTYPE="P","D","C" D
        .. S DOCCLASS=$$DOCCLASS^ORWGAPIA(DOCTYPE)
        .. K ^TMP("TIUR",$J)
        .. D TIU^ORWGAPIA(.DUMMY,DOCCLASS,5,DFN,$G(OLDEST),$G(NEWEST))
        .. S DOC=0
        .. F  S DOC=$O(^TMP("TIUR",$J,DOC)) Q:DOC<1  D
        ... S RESULTS=^TMP("TIUR",$J,DOC)
        ... S TITLE=$P(RESULTS,U,2)
        ... S DATE=$P(RESULTS,U,3)
        ... I '$L(TITLE) Q
        ... S ^TMP("ORWGRPC TEMP",$J,TITLE,DATE)=RESULTS
        I FMT'=6 D
        . F DOCTYPE="P","D","C" D
        .. S DOCCLASS=$$DOCCLASS^ORWGAPIA(DOCTYPE)
        .. K ^TMP("TIUR",$J)
        .. D TIU^ORWGAPIA(.DUMMY,DOCCLASS,5,DFN)
        .. S DOC=0
        .. F  S DOC=$O(^TMP("TIUR",$J,DOC)) Q:DOC<1  D
        ... S RESULTS=^TMP("TIUR",$J,DOC)
        ... S TITLE=$P(RESULTS,U,2)
        ... S DATE=$P(RESULTS,U,3)
        ... I '$L(TITLE) Q
        ... S ^TMP("ORWGRPC TEMP",$J,TITLE,DATE)=RESULTS
        S TITLE=""
        F  S TITLE=$O(^TMP("ORWGRPC TEMP",$J,TITLE)) Q:TITLE=""  D
        . S CNT=CNT+1
        . I FMT=6 S RESULT=8925_U_TITLE
        . I FMT=3 D
        .. S DATE=+$O(^TMP("ORWGRPC TEMP",$J,TITLE,""),-1)
        .. S DOCIEN=+$G(^TMP("ORWGRPC TEMP",$J,TITLE,DATE))
        .. S RESULT=8925_U_TITLE_"^^"_TITLE_"^^"
        .. S RESULT=RESULT_DATE
        .. S RESULT=RESULT_U_$$TITLE^ORWGAPIA(DOCIEN)
        . I FMT=0 S RESULT=8925_U_TITLE_U_TITLE
        . S RESULT=$$UP^ORWGAPIX(RESULT)
        . D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J),^TMP("TIUR",$J)
        Q
        ;
TITLE(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)      ; from ORWGAPIR
        ; FMT,OLDEST,NEWEST not used
        N ITEM,FILE,NUM,REF,RESULT
        K ^TMP("ORWGRPC DC",$J)
        S ITEM=""
        F  S ITEM=$O(^PXRMINDX(63,"PI",DFN,ITEM)) Q:ITEM=""  D
        . I $E(ITEM)="A" Q
        . I $E(ITEM)="M" Q
        . S RESULT=$$AALAB^ORWGAPIC(ITEM)
        . I RESULT="" Q
        . S RESULT="68^"_RESULT
        . S ^TMP("ORWGRPC DC",$J,RESULT)=""
        S RESULT=""
        F  S RESULT=$O(^TMP("ORWGRPC DC",$J,RESULT)) Q:RESULT=""  S CNT=CNT+1 D
        . D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC DC",$J)
        Q
        ;
