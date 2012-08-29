ORWGAPI ; SLC/STAFF - Graph API ;12/21/05  08:14
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,243**;Dec 17, 1997;Build 242
        ;
ALLITEMS(ITEMS,DFN)     ; API - return all items of data on patient (procedures, tests, codes,..)
        N CNT,SUB,TMP,TYPE
        K ^TMP("ORWGAPI",$J)
        S DFN=+$G(DFN) I 'DFN Q
        D TYPES("ORWGAPI",DFN)
        D RETURN^ORWGAPIW(.TMP,.ITEMS)
        S CNT=0
        S SUB=""
        F  S SUB=$O(^TMP("ORWGAPI",$J,SUB)) Q:SUB=""  D
        . S TYPE=$P(^TMP("ORWGAPI",$J,SUB),U)
        . D ITEMS^ORWGAPIR(.ITEMS,DFN,TYPE,0,,,.CNT,TMP)
        D SETLAST^ORWGTASK(DFN)
        K ^TMP("ORWGAPI",$J)
        Q
        ;
ALLVIEWS(DATA,VIEW,USER)        ; API - get all graph views
        D ALLVIEWS^ORWGAPIP(.DATA,+$G(VIEW),+$G(USER))
        Q
        ;
CLASS(DATA,TYPE)        ; API - get classification
        I TYPE=50.605 D DRUGC^ORWGAPIC(.DATA)
        I TYPE=68 D ACC^ORWGAPIC(.DATA)
        I TYPE=8925.1 D TIUTITLE^ORWGAPIA(.DATA)
        I TYPE=100.98 D OITEM^ORWGAPIA(.DATA)
        Q
        ;
DATEDATA(DATA,OLDEST,NEWEST,TYPEITEM,DFN)       ; API - return all data for an item on patient for date range
        N CNT,ITEM,SUB,TMP,TYPE
        S DFN=+$G(DFN) I 'DFN Q
        S OLDEST=+$G(OLDEST)
        S NEWEST=+$G(NEWEST,$$NOW^ORWGAPIX)
        S TYPEITEM=$G(TYPEITEM) I TYPEITEM'[U Q
        I 'OLDEST D ITEMDATA(.DATA,TYPEITEM,NEWEST,DFN,OLDEST) Q
        I OLDEST<NEWEST Q
        S TYPEITEM=$$UP^ORWGAPIX(TYPEITEM)
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S TYPE=$P(TYPEITEM,U)
        S ITEM=$P(TYPEITEM,U,2)
        S CNT=0
        D DATA^ORWGAPIR(.DATA,ITEM,TYPE,NEWEST,DFN,.CNT,TMP,OLDEST)
        Q
        ;
DATEITEM(ITEMS,OLDEST,NEWEST,TYPE,DFN)  ; API - return all file items on patient for date range
        N CNT,SUB,TMP
        K ^TMP("ORWGAPI",$J)
        S DFN=+$G(DFN) I 'DFN Q
        S OLDEST=+$G(OLDEST),NEWEST=+$G(NEWEST),TYPE=$G(TYPE)
        I $L(TYPE) S ^TMP("ORWGAPI",$J,1)=TYPE
        I '$L(TYPE) D TYPES("ORWGAPI",DFN)
        D RETURN^ORWGAPIW(.TMP,.ITEMS)
        S CNT=0
        S SUB=""
        F  S SUB=$O(^TMP("ORWGAPI",$J,SUB)) Q:SUB=""  D
        . S TYPE=$P(^TMP("ORWGAPI",$J,SUB),U)
        . D ITEMS^ORWGAPIR(.ITEMS,DFN,TYPE,6,OLDEST,NEWEST,.CNT,TMP)
        K ^TMP("ORWGAPI",$J)
        Q
        ;
DELVIEWS(DATA,NAME,PUBLIC)      ; API - delete a graph view
        D DELVIEWS^ORWGAPIP(.DATA,$G(NAME),$G(PUBLIC))
        Q
        ;
DETAIL(DATA,DFN,DATE1,DATE2,VAL,COMP)   ; API - get all reports for types of data from items and date range
        D DETAIL^ORWGAPID("ORWGRPC",DFN,DATE1,DATE2,.VAL)
        S DATA=$NA(^TMP("ORWGRPC",$J))
        Q
        ;
DETAILS(DATA,DFN,DATE1,DATE2,TYPE,COMP) ; API - get report for type of data for a date or date range
        D DETAILS^ORWGAPID("ORWGRPC",DFN,DATE1,DATE2,TYPE)
        S DATA=$NA(^TMP("ORWGRPC",$J))
        Q
        ;
FASTDATA(DATA,DFN)      ; API - get all data (non-lab) on patient
        D FASTDATA^ORWGAPIF(.DATA,DFN)
        Q
        ;
FASTITEM(ITEMS,DFN)     ; API - get all items on patient 
        D FASTITEM^ORWGAPIF(.ITEMS,DFN)
        D SETLAST^ORWGTASK(DFN)
        Q
        ;
FASTLABS(DATA,DFN)      ; API - get all lab data on patient
        D FASTLABS^ORWGAPIF(.DATA,DFN)
        Q
        ;
FASTTASK(STATUS,DFN,OLDDFN)     ; API - process cache of all data and items on patient, -1 if turned off
        ; this should be able to be turned off if needbe (D CLEAN^ORWGTASK)
        D UPDATE^ORWGTASK(.STATUS,DFN,DUZ,+$G(OLDDFN))
        Q
        ;
GETDATES(DATA,REPORTID) ; API - get graph date ranges
        D GETDATES^ORWGAPID(.DATA,$G(REPORTID))
        Q
        ;
GETPREF(DATA)   ; API - get graph settings
        D GETPREF^ORWGAPIP(.DATA)
        Q
        ;
GETSIZE(DATA)   ; API - get graph positions and sizes
        D GETSIZE^ORWGAPIP(.DATA)
        Q
        ;
GETVIEWS(DATA,ALL,PUBLIC,EXT,USER)      ; API - get graph views
        D GETVIEWS^ORWGAPIP(.DATA,$G(ALL),$G(PUBLIC),$G(EXT),+$G(USER))
        Q
        ;
ITEMDATA(DATA,TYPEITEM,START,DFN,BACKTO)        ; API - return data of an item on patient (glucose results)
        N CNT,ITEM,TMP,TYPE
        S DFN=+$G(DFN) I 'DFN Q
        S TYPEITEM=$G(TYPEITEM) I TYPEITEM'[U Q
        S TYPEITEM=$$UP^ORWGAPIX(TYPEITEM)
        S START=$G(START,$$NOW^ORWGAPIX)
        D RETURN^ORWGAPIW(.TMP,.DATA)
        S TYPE=$P(TYPEITEM,U)
        S ITEM=$P(TYPEITEM,U,2)
        S CNT=0
        D DATA^ORWGAPIR(.DATA,ITEM,TYPE,START,DFN,.CNT,TMP,$G(BACKTO))
        Q
        ; 
ITEMS(ITEMS,DFN,TYPE)   ; API - return items of a type of data on patient (lab tests)
        N CNT,TMP
        S DFN=+$G(DFN) I 'DFN Q
        S TYPE=$G(TYPE) I '$L(TYPE) Q
        D RETURN^ORWGAPIW(.TMP,.ITEMS)
        S CNT=0
        D ITEMS^ORWGAPIR(.ITEMS,DFN,TYPE,3,,,.CNT,TMP)
        I TYPE=63 D SETLAST^ORWGTASK(DFN)
        Q
        ;
LOOKUP(VAL,FILE,FROM,DIR)       ; API - get item names for long lookup
        N REF,SCREEN,XREF
        D FILE^ORWGAPIU($G(FILE),.REF,.XREF,.SCREEN)
        I '$L(REF) Q
        D GENERIC^ORWGAPIW(.VAL,.FROM,DIR,FILE,REF,XREF,SCREEN)
        Q
        ;
PUBLIC(USER)    ; API - $$(user) -> 1 if user can edit public settings and views
        Q $$PUBLIC^ORWGAPIP(USER)
        ;
RPTPARAM(IEN)   ; API - $$(ien) -> PARAM1^PARAM2 for graph report else ""
        Q $$RPTPARAM^ORWGAPIP(IEN)
        ;
SETPREF(DATA,VAL,PUBLIC)        ; API - set a graph setting
        D SETPREF^ORWGAPIP(.DATA,$G(VAL),$G(PUBLIC))
        Q
        ;
SETSIZE(DATA,VAL)       ; API - set graph positions and settings
        D SETSIZE^ORWGAPIP(.DATA,.VAL)
        Q
        ;
SETVIEWS(DATA,NAME,PUBLIC,VAL)  ; API - set a graph view
        D SETVIEWS^ORWGAPIP(.DATA,$G(NAME),$G(PUBLIC),.VAL)
        Q
        ;
TAX(DATA,ALL,REMTAX)    ; API - get reminder taxonomies
        D TAX^ORWGAPID(.DATA,+$G(ALL),.REMTAX)
        Q
        ;
TESTING(DATA)   ; API - return test data
        D TESTING^ORWGTEST(.DATA)
        Q
        ;
TESTSPEC(DATA)  ;  API - return test/spec info on all lab tests
        D TESTSPEC^ORWGAPIC(.DATA)
        Q
        ;
TYPES(TYPES,DFN,SUB)    ; API - return all types of data on patient (if no dfn, return all)
        N TMP
        S DFN=+$G(DFN)
        S SUB=+$G(SUB)
        D RETURN^ORWGAPIW(.TMP,.TYPES)
        D TYPES^ORWGAPIT(.TYPES,DFN,SUB,TMP)
        Q
