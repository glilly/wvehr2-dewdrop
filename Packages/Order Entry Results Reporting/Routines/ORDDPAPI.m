ORDDPAPI        ; SLC/AGP - Misc. Order Dialog functions; 04/11/2006
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
ADMTIME(ORARRAY)        ;
        N ERR,I
        D GETWP^XPAR(.X,"SYS","OR ADMIN TIME HELP TEXT",,.ERR)
        S I=0  F  S I=$O(X(I)) Q:I'>0  S ORARRAY(I)=$G(X(I,0))
        Q
        ;
LRD1()  ;
        N IEN
        K ^TMP($J,"ORDDPAPI LRD1")
        D ZERO^PSS51P1("","ONE TIME","LR",,"ORDDPAPI LRD1")
        I $G(^TMP($J,"ORDDPAPI LRD1",0))'>0 Q ""
        S IEN=$O(^TMP($J,"ORDDPAPI LRD1","B","ONE TIME",""))
        K ^TMP($J,"ORDDPAPI LRD1")
        Q IEN
        ;
LRD2(IEN)       ;
        N RESULT
        K ^TMP($J,"ORDDPAPI LRD2")
        D ZERO^PSS51P1(IEN,,,,"ORDDPAPI LRD2")
        S RESULT=$P($G(^TMP($J,"ORDDPAPI LRD2",IEN,5)),U)
        K ^TMP($J,"ORDDPAPI LRD2")
        Q RESULT
        ;
CLOZMSG(ORARRAY)        ;
        N ERR,I
        D GETWP^XPAR(.X,"SYS","OR CLOZ INPT MSG",,.ERR)
        S I=0  F  S I=$O(X(I)) Q:I'>0  S ORARRAY(I)=$G(X(I,0))
        Q
        ;
