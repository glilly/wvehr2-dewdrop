ORWGAPI3        ; SLC/STAFF - Graph Data ;12/21/05  08:17
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,243**;Dec 17, 1997;Build 242
        ;
        ;
ADVERSE(DATA,ITEM,START,DFN,CNT,TMP,BACKTO)     ; from ORWGAPIR
        N ADVERSE,DATE,DATE2,NODE,RESULT,RXN,VALUE
        S DATE="",DATE2="",CNT=$G(CNT),BACKTO=+$G(BACKTO)
        S ADVERSE=""
        S VALUE=ITEM_U_ITEM
        S NODE=""
        F  S NODE=$O(^GMR(120.8,"B",DFN,NODE)) Q:NODE=""  D
        . I '$D(^GMR(120.8,NODE,0)) Q
        . I $G(^GMR(120.8,NODE,"ER")) Q  ; entered in error
        . I '$P(^GMR(120.8,NODE,0),U,12) Q  ; signed
        . S DATE=+$P($G(^GMR(120.8,NODE,0)),U,4) I 'DATE Q
        . I DATE>START Q
        . I DATE<BACKTO Q
        . I ITEM'=$P(^GMR(120.8,NODE,0),U,2) Q
        . S RXN=0
        . F  S RXN=$O(^GMR(120.8,NODE,10,"B",RXN)) Q:RXN<1  D
        .. S ADVERSE=ADVERSE_$$EVALUE^ORWGAPIU(RXN,120.8)_", "
        . I $L(ADVERSE)>0 S ADVERSE=$E(ADVERSE,1,$L(ADVERSE)-2)
        . S CNT=CNT+1
        . S RESULT=120.8_U_ITEM_U_DATE_U_DATE2_U_ADVERSE
        . D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
DX(DATA,ITEM,START,DFN,CNT,TMP,BACKTO)  ; from ORWGAPIR
        N DATE,DATE2,NODE,NUM,RESULT,VALUE,VALUES K VALUE
        K ^TMP("ORWGRPC TEMP",$J)
        S DATE2="",CNT=$G(CNT),BACKTO=+$G(BACKTO)
        S NUM=""
        F  S NUM=$O(^PXRMINDX(45,"ICD9","PNI",DFN,NUM)) Q:NUM=""  D
        . S DATE=""
        . F  S DATE=$O(^PXRMINDX(45,"ICD9","PNI",DFN,NUM,ITEM,DATE)) Q:DATE=""  D
        .. I DATE>START Q
        .. I DATE<BACKTO Q
        .. S NODE=""
        .. F  S NODE=$O(^PXRMINDX(45,"ICD9","PNI",DFN,NUM,ITEM,DATE,NODE)) Q:NODE=""  D
        ... I '$D(^TMP("ORWGRPC TEMP",$J,ITEM,DATE)) S ^TMP("ORWGRPC TEMP",$J,ITEM,DATE)=NODE_U_NUM
        S ITEM=""
        F  S ITEM=$O(^TMP("ORWGRPC TEMP",$J,ITEM)) Q:ITEM=""  D
        . S DATE=""
        . F  S DATE=$O(^TMP("ORWGRPC TEMP",$J,ITEM,DATE)) Q:DATE=""  D
        .. S NODE=$G(^TMP("ORWGRPC TEMP",$J,ITEM,DATE)) I '$L(NODE) Q
        .. S NUM=$P(NODE,U,2)
        .. S NODE=$P(NODE,U)
        .. I '$L($G(^DGPT(+NODE,0))) Q  ; ****** remove this when PTF patch is released **********
        .. D PTF^ORWGAPIA(NODE,.VALUE,.VALUES) S VALUE=$$EXT^ORWGAPIX($G(VALUE("DISCHARGE STATUS")),45,6)
        .. I NUM="DXLS" S VALUE="(DXLS)  "_VALUE_U_U_VALUES ;*****************************
        .. S RESULT=45_"DX"_U_ITEM_U_DATE_U_DATE2_U_"  "_VALUE
        .. D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J)
        Q
        ;
LAB(DATA,ITEM,START,DFN,CNT,TMP,BACKTO) ; from ORWGAPIR
        N COMMENT,DATE,DATE2,NODE,RESULT,TYPE,VALUE K VALUE
        S DATE="",DATE2="",CNT=$G(CNT),BACKTO=+$G(BACKTO)
        D
        . I $E(ITEM)="A" S TYPE="AP" Q
        . I $E(ITEM)="M" S TYPE="MI" Q
        . S TYPE="" Q
        F  S DATE=$O(^PXRMINDX(63,"PI",DFN,ITEM,DATE)) Q:DATE=""  D
        . I DATE>START Q
        . I DATE<BACKTO Q
        . S NODE=""
        . F  S NODE=$O(^PXRMINDX(63,"PI",DFN,ITEM,DATE,NODE)) Q:NODE=""  D
        .. K VALUE
        .. D LAB^ORWGAPIC(.VALUE,NODE,ITEM)
        .. I TYPE="AP" S RESULT="63AP^"_ITEM_U_DATE_U_DATE2 ;_U_$P(VALUE,U,2)
        .. I TYPE="MI" S RESULT="63MI^"_ITEM_U_DATE_U_DATE2_U_$P(VALUE,U,4)
        .. I TYPE="" D
        ... S COMMENT=""
        ... I $L($G(VALUE("COMMENTS",1))) S COMMENT=1
        ... S RESULT="63^"_ITEM_U_DATE_U_DATE2_U_$P(VALUE,U,3)_U_$P(VALUE,U,4)_U_$G(VALUE("SPECIMEN"))_U_COMMENT
        .. D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
MED(DATA,ITEM,START,DFN,CNT,TMP,BACKTO) ; from ORWGAPIR
        D MED3^ORWGAPIE(.DATA,ITEM,START,DFN,.CNT,.TMP)
        Q
        ;
NOTE(DATA,ITEM,START,DFN,CNT,TMP,BACKTO)        ; from ORWGAPIR
        N DATE,DOC,DOCCLASS,DOCTYPE,DUM,IEN,RESULT,RESULTS,TITLE,VALUE K DUM
        K ^TMP("ORWGRPC TEMP",$J),^TMP("TIUR",$J)
        S CNT=$G(CNT),ITEM=$$UP^ORWGAPIX(ITEM),BACKTO=+$G(BACKTO)
        F DOCTYPE="P","D","C" D
        . S DOCCLASS=$$DOCCLASS^ORWGAPIA(DOCTYPE)
        . K ^TMP("TIUR",$J)
        . D TIU^ORWGAPIA(.DUM,DOCCLASS,5,DFN)
        . S DOC=0
        . F  S DOC=$O(^TMP("TIUR",$J,DOC)) Q:DOC<1  D
        .. S RESULTS=^TMP("TIUR",$J,DOC)
        .. S IEN=+$P(RESULTS,U)
        .. S TITLE=$$UP^ORWGAPIX($P(RESULTS,U,2))
        .. I TITLE'=ITEM Q
        .. ; do not use admission date S DATE=$P($G(^AUPNVSIT(+$P($G(^TIU(8925,IEN,0)),U,3),0)),U)
        .. S DATE=$P(RESULTS,U,3)
        .. I DATE>START Q
        .. I DATE<BACKTO Q
        .. S VALUE=$P(RESULTS,U,7)
        .. S CNT=CNT+1
        .. S RESULT=8925_U_TITLE_U_DATE_"^^"_VALUE
        .. I $D(^TMP("ORWGRPC TEMP",$J,RESULT)) Q
        .. S ^TMP("ORWGRPC TEMP",$J,RESULT)=""
        .. D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J),^TMP("TIUR",$J)
        Q
        ;
ORDER(DATA,ITEM,START,DFN,CNT,TMP,BACKTO)       ; from ORWGAPIR
        N DATE,DATE2,NODE,ORUPCHUK,RESULT,VALUE K ORUPCHUK
        S DATE="",CNT=$G(CNT),BACKTO=+$G(BACKTO)
        F  S DATE=$O(^PXRMINDX(100,"PI",DFN,ITEM,DATE)) Q:DATE=""  D
        . I DATE>START Q
        . I DATE<BACKTO Q
        . S DATE2=""
        . F  S DATE2=$O(^PXRMINDX(100,"PI",DFN,ITEM,DATE,DATE2)) Q:DATE2=""  D
        .. S NODE=""
        .. F  S NODE=$O(^PXRMINDX(100,"PI",DFN,ITEM,DATE,DATE2,NODE)) Q:NODE=""  D
        ... D EN^ORX8($P(NODE,";")) S VALUE=$P($G(ORUPCHUK("ORSTS")),U,2)
        ... S RESULT=100_U_ITEM_U_DATE_"^^"_VALUE
        ... D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
RAD(DATA,ITEM,START,DFN,CNT,TMP,BACKTO) ; from ORWGAPIR
        N DATE,DATE2,NODE,RESULT,VALUE,VALUES K VALUE
        S DATE="",DATE2="",CNT=$G(CNT),BACKTO=+$G(BACKTO)
        F  S DATE=$O(^PXRMINDX(70,"PI",DFN,ITEM,DATE)) Q:DATE=""  D
        . I DATE>START Q
        . I DATE<BACKTO Q
        . S NODE=""
        . F  S NODE=$O(^PXRMINDX(70,"PI",DFN,ITEM,DATE,NODE)) Q:NODE=""  D
        .. D RAD^ORWGAPIA(NODE,.VALUE,.VALUES) S VALUE=$G(VALUE("PDX"))_"-"_$G(VALUE("EXAM STATUS"))_U_U_VALUES
        .. S RESULT=70_U_ITEM_U_DATE_U_DATE2_U_VALUE
        .. D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        Q
        ;
