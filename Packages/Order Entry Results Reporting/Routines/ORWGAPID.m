ORWGAPID        ; SLC/STAFF - Graph API Details ;12/21/05  08:19
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,243**;Dec 17, 1997;Build 242
        ;
DETAILS(DATA,DFN,DATE1,DATE2,FILEITEM)  ; from ORWGAPI (series click)
        N ITEM,FILE,SUBHEAD,TYPEITEM K SUBHEAD,TYPEITEM
        K ^TMP("LR7OGX",$J),^TMP("LRC",$J)
        K ^TMP("ORLRC",$J),^TMP("PSBO",$J),^TMP("TIUVIEW",$J)
        S FILE=$P(FILEITEM,U)
        S ITEM=$$UP^ORWGAPIX($P(FILEITEM,U,2))
        I '$L(ITEM) Q
        D
        . I FILE=63 D  Q
        .. D INTERIM^ORWLRR(.DATA,DFN,DATE1,DATE2)
        .. M ^TMP("ORWGRPC",$J)=^TMP("LR7OGX",$J,"OUTPUT")
        . I FILE="63MI" D  Q
        .. D MICRO^ORWLRR(.DATA,DFN,DATE1,DATE2)
        .. M ^TMP("ORWGRPC",$J)=^TMP("LR7OGX",$J,"OUTPUT")
        . I FILE="63AP" D   Q
        .. S SUBHEAD("CYTOPATHOLOGY")=""
        .. S SUBHEAD("SURGICAL PATHOLOGY")=""
        .. S SUBHEAD("EM")=""
        .. S SUBHEAD("AUTOPSY")=""
        .. D LABSUM^ORWGAPIC(.DATA,DFN,DATE1,DATE2,.SUBHEAD)
        .. M ^TMP("ORWGRPC",$J)=^TMP("LRC",$J)
        . I FILE="63BB" D  Q
        .. D BLR^ORWRP1(.DATA,DFN,"",DATE1,DATE2)
        .. M ^TMP("ORWGRPC",$J)=^TMP("ORLRC",$J)
        . I FILE="53.79" D  Q
        .. ;D BCMA1^ORWRP1A(.DATA,DFN,"",DATE1,DATE2) ***** BA 12/14/07
        .. D BCMA1^ORWRP1A(.DATA,DFN,"",DATE2,DATE1)
        .. M ^TMP("ORWGRPC",$J)=^TMP("PSBO",$J)
        . I FILE="8925" D  Q
        .. D NOTE(.DATA,DFN,DATE1,DATE2,ITEM)
        .. ;M ^TMP("ORWGRPC",$J)=^TMP("TIUVIEW",$J)
        . S TYPEITEM(1)=FILE_"^0"
        . D DETAIL(.DATA,DFN,DATE1,DATE2,.TYPEITEM)
        K ^TMP("LR7OGX",$J),^TMP("LRC",$J)
        K ^TMP("ORLRC",$J),^TMP("PSBO",$J),^TMP("TIUVIEW",$J)
        Q
        ;
DETAIL(DATA,DFN,DATE1,DATE2,TYPEITEM)   ; from ORWGAPI (legend click)
        N CNT,FILE,GMTSPX1,GMTSPX2,ITEM,TITEMS,TYPE
        N COMP,NEWITEMS K COMP,NEWITEMS
        K ^TMP("ORDATA",$J)
        S DFN=+$G(DFN) I 'DFN Q
        I '$L($O(TYPEITEM(0))) Q
        S TYPE=""
        F  S TYPE=$O(TYPEITEM(TYPE)) Q:TYPE=""  D
        . S TITEMS=TYPEITEM(TYPE)
        . S FILE=$P(TITEMS,U) I '$L(FILE) Q
        . S ITEM=$P(TITEMS,U,2) I '$L(ITEM) Q
        . S NEWITEMS(FILE,ITEM)=""
        S CNT=0
        S FILE=""
        F  S FILE=$O(NEWITEMS(FILE)) Q:FILE=""  D
        . S CNT=CNT+1
        . S COMP(CNT)=$$COMPTYPE^ORWGAPIT(FILE)
        S GMTSPX1=DATE1,GMTSPX2=DATE2
        D REPORT^ORWRP2(.DATA,.COMP,DFN)
        M ^TMP("ORWGRPC",$J)=^TMP("ORDATA",$J)
        ;K ^TMP("ORDATA",$J)
        ;Q
        ;
        S CNT=0
        S TYPE=""
        F  S TYPE=$O(TYPEITEM(TYPE)) Q:TYPE=""  D
        . S TITEMS=TYPEITEM(TYPE)
        . S CNT=CNT+1
        . S ^TMP("ORWGRPC",$J,CNT/10000)="~~~^"_TITEMS
        ;
        K ^TMP("ORDATA",$J)
        Q
        ;
GETDATES(DATA,REPORTID) ; from ORWGAPI
        N DAT,TMP K DAT
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S DAT(1)="S^Date Range..."
        S DAT(2)="1^Today"
        S DAT(3)="2^One Week"
        S DAT(4)="3^Two Weeks"
        S DAT(5)="4^One Month"
        S DAT(6)="5^Six Months"
        S DAT(7)="6^One Year"
        S DAT(8)="7^Two Years"
        S DAT(9)="8^All Results"
        D DATES^ORWGAPIP(.DAT,REPORTID)
        I TMP M ^TMP(DATA,$J)=DAT
        I 'TMP M DATA=DAT
        Q
        ;
NOTE(DATA,DFN,DATE1,DATE2,ITEM) ;
        N CNT,DATE,DOC,DOCCLASS,DOCTYPE,DUM,IEN,LINE,NUM,RESULTS K DUM
        K ^TMP("TIUR",$J),^TMP("TIUVIEW",$J)
        S CNT=$G(CNT)
        F DOCTYPE="P","D","C" D
        . S DOCCLASS=$$DOCCLASS^ORWGAPIA(DOCTYPE)
        . K ^TMP("TIUR",$J)
        . D TIU^ORWGAPIA(.DUM,DOCCLASS,5,DFN,DATE1,DATE2)
        . S DOC=0
        . F  S DOC=$O(^TMP("TIUR",$J,DOC)) Q:DOC<1  D
        .. S RESULTS=^TMP("TIUR",$J,DOC)
        .. S IEN=+$P(RESULTS,U)
        .. K ^TMP("TIUVIEW",$J)
        .. D GETTIU^ORWGAPIA(.DATA,IEN)
        .. S NUM=0
        .. F  S NUM=$O(^TMP("TIUVIEW",$J,NUM)) Q:NUM<1  D
        ... S LINE=$G(^TMP("TIUVIEW",$J,NUM))
        ... S CNT=CNT+1
        ... S ^TMP("ORWGRPC",$J,CNT)=LINE
        .. I CNT>1 D
        ... S CNT=CNT+1
        ... S ^TMP("ORWGRPC",$J,CNT)=" "
        ... S CNT=CNT+1
        ... S ^TMP("ORWGRPC",$J,CNT)=" "
        ... S ^TMP("ORWGRPC",$J,CNT/10000)="~~~^"_^TMP("TIUR",$J,DOC)
        K ^TMP("TIUR",$J),^TMP("TIUVIEW",$J)
        Q
        ;
TAX(DATA,ALL,REMTAX)    ; from ORWGAPI
        N CNT,REM,CODE,NUM,TMP
        K ^TMP("ORWG TEMP",$J)
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S CNT=0
        S REM=0
        I ALL F  S REM=$O(^PXD(811.2,REM)) Q:REM<1  D TEMP(REM)
        I 'ALL D
        . S NUM=0
        . F  S NUM=$O(REMTAX(NUM)) Q:NUM<1  D
        .. S REM=REMTAX(NUM)
        .. D TEMP(REM)
        S CODE=""
        F  S CODE=$O(^TMP("ORWG TEMP",$J,CODE)) Q:CODE=""  D
        . D SETUP^ORWGAPIW(.DATA,CODE,TMP,.CNT)
        K ^TMP("ORWG TEMP",$J)
        Q
        ;
TEMP(REM)       ;
        N NODE,NUM,SUB
        I $P($G(^PXD(811.2,REM,0)),U,6)=1 Q
        F SUB=80,80.1,81 D
        . S NUM=0
        . F  S NUM=$O(^PXD(811.3,REM,SUB,NUM)) Q:NUM<1  D
        .. S NODE=+$G(^PXD(811.3,REM,SUB,NUM,0))
        .. I 'NODE Q
        .. I SUB=80 D  Q
        ... S ^TMP("ORWG TEMP",$J,"45DX;"_NODE)=""
        ... S ^TMP("ORWG TEMP",$J,"9000010.07;"_NODE)=""
        ... S ^TMP("ORWG TEMP",$J,"9000011;"_NODE)=""
        .. I SUB=80.1 D  Q
        ... S ^TMP("ORWG TEMP",$J,"45OP;"_NODE)=""
        .. I SUB=81 D  Q
        ... S ^TMP("ORWG TEMP",$J,"9000010.18;"_NODE)=""
        Q
        ;
PLX2(ITEMS,DFN,FMT,OLDEST,NEWEST,CNT,TMP)       ; from ORWGAPIR
        N DATE,DTONSET,DTPLUS1,DTRESOLV,NODE,PRIORITY,PROB,PROBDX,PSTATUS,RESULT,STATUS,VALUE
        K ^TMP("ORWGRPC TEMP",$J)
        S DTPLUS1=$$FMADD^ORWGAPIX(DT,1)
        S STATUS=""
        F  S STATUS=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS)) Q:STATUS=""  D
        . S PRIORITY=""
        . F  S PRIORITY=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY)) Q:PRIORITY=""  D
        .. S ITEM=""
        .. F  S ITEM=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY,ITEM)) Q:ITEM=""  D
        ... S DATE=""
        ... F  S DATE=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY,ITEM,DATE)) Q:DATE=""  D
        .... S NODE=""
        .... F  S NODE=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY,ITEM,DATE,NODE)) Q:NODE=""  D
        ..... D PROB^ORWGAPIA(.PROB,.PSTATUS,.PROBDX,.DTONSET,.DTRESOLV,NODE)
        ..... I 'DTRESOLV S ^TMP("ORWGRPC TEMP",$J,PROBDX,DTONSET)=DTPLUS1 Q
        ..... S ^TMP("ORWGRPC TEMP",$J,PROBDX,DTONSET)=DTRESOLV
        S PROB=""
        F  S PROB=$O(^TMP("ORWGRPC TEMP",$J,PROB)) Q:PROB=""  D
        . S VALUE=$$EVALUE^ORWGAPIU(PROB,9000011,.01)
        . I FMT=0 D
        .. S CNT=CNT+1
        .. S RESULT=9999911_U_PROB_U_VALUE
        .. D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        . I FMT=6 D
        .. S OK=0
        .. S DATE=0
        .. F  S DATE=$O(^TMP("ORWGRPC TEMP",$J,PROB,DATE)) Q:DATE=""  Q:DATE>NEWEST  D  Q:OK
        ... S DTRESOLV=^TMP("ORWGRPC TEMP",$J,PROB,DATE)
        ... I DTRESOLV<OLDEST Q
        ... S CNT=CNT+1
        ... S OK=1
        ... S RESULT=9999911_U_PROB
        .. I OK D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        . I FMT=3 D
        .. S DATE=$O(^TMP("ORWGRPC TEMP",$J,PROB,""),-1)
        .. I 'DATE Q
        .. S CNT=CNT+1
        .. S RESULT=9999911_U_PROB_"^^"_VALUE_"^^"_DATE
        .. D SETUP^ORWGAPIW(.ITEMS,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J)
        Q
        ;
PROBX4(DATA,ITEM,START,DFN,CNT,TMP)     ; from ORWGAPIR
        N DATE,DTONSET,DTPLUS1,DTRESOLV,NODE,PRIORITY,PROB,PROBDX,PSTATUS,RESULT,STATUS,VALUE
        K ^TMP("ORWGRPC TEMP",$J)
        S CNT=$G(CNT),DTPLUS1=$$FMADD^ORWGAPIX(DT,1)
        S STATUS=""
        F  S STATUS=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS)) Q:STATUS=""  D
        . S PRIORITY=""
        . F  S PRIORITY=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY)) Q:PRIORITY=""  D
        .. S DATE=""
        .. F  S DATE=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY,ITEM,DATE)) Q:DATE=""  D
        ... I DATE>START Q
        ... S NODE=""
        ... F  S NODE=$O(^PXRMINDX(9000011,"PSPI",DFN,STATUS,PRIORITY,ITEM,DATE,NODE)) Q:NODE=""  D
        .... S ^TMP("ORWGRPC TEMP",$J,NODE)=""
        S NODE=""
        F  S NODE=$O(^TMP("ORWGRPC TEMP",$J,NODE)) Q:NODE=""  D
        . D PROB^ORWGAPIA(.PROB,.PSTATUS,.PROBDX,.DTONSET,.DTRESOLV,NODE)
        . I 'DTONSET Q
        . I 'DTRESOLV S DTRESOLV=DTPLUS1
        . S RESULT=9999911_U_PROBDX_U_DTONSET_U_DTRESOLV_U_$$EXT^ORWGAPIX(PSTATUS,9000011,.12)
        . D SETUP^ORWGAPIW(.DATA,RESULT,TMP,.CNT)
        K ^TMP("ORWGRPC TEMP",$J)
        Q
        ;
