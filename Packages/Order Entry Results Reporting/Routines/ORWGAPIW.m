ORWGAPIW        ; SLC/STAFF - Graph API Utilities, Generic ;8/19/06  15:20
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
DATA(ARRAY)     ; $$(application results) -> single string of results
        N NUM,RESULT,SUB
        S OUT=""
        S SUB=""
        F  S SUB=$O(ARRAY(SUB)) Q:SUB=""  D
        . I $D(ARRAY(SUB,0)) D  Q
        .. S OUT=OUT_SUB_"["
        .. S NUM=0
        .. F  S NUM=$O(ARRAY(SUB,NUM)) Q:NUM<1  D
        ... S RESULT=$G(ARRAY(SUB,NUM,0))
        ... S OUT=OUT_RESULT_";"
        .. S OUT=OUT_"]"
        . S RESULT=$G(ARRAY(SUB))
        . S OUT=OUT_SUB_"["_RESULT_"]"
        S OUT=$TR(OUT,U,"~")
        Q OUT
        ;
DATETFM(DATETIME)       ; $$(external date/time) -> fm date/time else 0
        N DATE,DAY,FMDT,HOUR,MIN,SEC,TIME,YEAR
        S DATE=$P(DATETIME,"@"),TIME=$P(DATETIME,"@",2)
        S YEAR=$P(DATE,",",2) I $L(YEAR)'=4 Q 0
        S YEAR=YEAR-1700 I YEAR<270 Q 0
        S MONTH=$P(DATE," ")
        S MONTH=$$MTN(MONTH) I MONTH<1 Q 0
        I MONTH<10 S MONTH="0"_MONTH
        S DAY=$P(DATE," ",2),DAY=$P(DAY,",")
        I DAY<1 Q 0
        I DAY<10 S DAY="0"_DAY
        S HOUR=$P(TIME,":")
        S MIN=$P(TIME,":",2)
        S SEC=$P(TIME,":",3)
        S TIME=HOUR_MIN_SEC
        S FMDT=YEAR_MONTH_DAY
        I '$L(TIME) Q FMDT
        Q FMDT_"."_TIME
        ;
GENERIC(VAL,FROM,DIR,FILE,REF,XREF,SCREEN)      ; Return a set of entries from xref in REF
        ; from ORWGAPI
        ; .VAL=returned list, FROM=text to $O from, DIR=$O direction,
        N CNT,IEN,NAME,NEXTNAME,NUM,OK,ROOT,ZERO S NUM=0,CNT=44 K VAL
        I FILE=405 Q
        S ROOT=""
        S FROM=$$UP^ORWGAPIX(FROM)
        I $E(REF,$L(REF))="," S ROOT=$E(REF,1,$L(REF)-1)_")"
        I $E(REF,$L(REF))="(" S ROOT=$P(REF,"(")
        I '$L(ROOT) Q
        S REF=REF_""""_XREF_""")"
        F  Q:NUM'<CNT  S FROM=$O(@REF@(FROM),DIR) Q:FROM=""  D
        . S IEN="" F  S IEN=$O(@REF@(FROM,IEN),DIR) Q:'IEN  D
        .. I FILE=100,$O(@REF@(FROM,IEN,""))>0 Q
        .. S ZERO=$G(@ROOT@(IEN,0)) I '$L(ZERO) Q
        .. X SCREEN I '$T Q
        .. S NUM=NUM+1
        .. I FILE="45DX"!(FILE=9000010.07)!(FILE=9000011)!(FILE="63AP;I") D  Q
        ... S VAL(NUM)=FILE_U_IEN_U_$$ICD9^ORWGAPIA(IEN) Q
        .. I FILE="45OP" S VAL(NUM)=FILE_U_IEN_U_$$ICD0^ORWGAPIA(IEN) Q
        .. I FILE=53.79 S VAL(NUM)=FILE_U_IEN_U_$$POINAME^ORWGAPIC(IEN) Q
        .. I FILE="55NVA" S VAL(NUM)=FILE_U_IEN_U_$$POINAME^ORWGAPIC(IEN) Q
        .. I FILE=9000010.18 S VAL(NUM)=FILE_U_IEN_U_$$ICPT^ORWGAPIA(IEN) Q
        .. I FILE=130 S VAL(NUM)=FILE_U_IEN_U_$$ICPT^ORWGAPIA(IEN) Q
        .. S VAL(NUM)=FILE_U_IEN_U_FROM
        I FILE=120.5 D
        . S (NUM,OK)=0
        . F  S NUM=$O(VAL(NUM)) Q:NUM<1  D  Q:OK
        .. S NAME=$P(VAL(NUM),U,3)
        .. S NEXTNAME=$P($G(VAL(NUM+1)),U,3)
        .. I "BODY MASS INDEX"]NAME,NEXTNAME]"BODY MASS INDEX" D
        ... S OK=1
        ... S VAL(NUM+.5)="120.5^99999^BODY MASS INDEX"
        Q
        ;
MTN(MONTH)      ; $$(external month) -> month number
        N MONTHS,NUM
        I $L(MONTH)'=3 Q 0
        S MONTHS="JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC"
        F NUM=1:1:13 I $P(MONTHS,U,NUM)=MONTH Q
        I NUM=13 Q 0
        Q NUM
        ;
OGROUP(OITEM)   ; $$(orderable item) -> ien display group^display group   - from ORWGAPIR
        N IEN
        S IEN=+$P($G(^ORD(101.43,+$G(OITEM),0)),U,5)
        Q IEN_U_"order - "_$P($G(^ORD(100.98,IEN,0)),U)
        ;
RETURN(TMP,ITEMS)       ; return TMP (0 use local, 1 use ^TMP(ITEMS,$J, where ITEMS is a namespaced string)
        ; from ORWGAPI, ORWGAPIP, ORWGAPIX
        N NMSP
        S NMSP=$G(ITEMS) K ITEMS S ITEMS=""
        S TMP=NMSP?1U1UN1.14UNP
        I TMP S ITEMS=NMSP
        Q
        ;
SETUP(DATA,RESULT,TMP,CNT)      ; from ORWGAPI1, ORWGAPI2, ORWGAPI3, ORWGAPI4, ORWGAPIP, ORWGAPIR, ORWGAPIX
        S CNT=CNT+1
        I TMP=2 S ^TMP(DATA,$J,$P(RESULT,U,1,2))=RESULT Q
        I TMP S ^TMP(DATA,$J,CNT)=RESULT
        I 'TMP S DATA(CNT)=RESULT
        Q
        ;
