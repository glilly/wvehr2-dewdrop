OCXF22  ;SLC/RJS,CLA - GENERATES CODE FOR 'Free Text (String)' OPERATORS ;10/29/98  12:37
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,316**;Dec 17,1997;Build 17
        ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
        Q
        ;
        ;
LEN(X)  ;
        I ($E(X,1)="""") Q ($L(X)-2)
        Q "$L("_X_")"
        ;
START(DATA,CVAL)        ; DATA STARTS WITH VALUE
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL)) "" Q "($E("_DATA_",1,"_$$LEN(CVAL)_")="_CVAL_")"
        ;
END(DATA,CVAL)  ; DATA ENDS WITH VALUE
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL)) "" Q "($E("_DATA_",($L("_DATA_")-("_$$LEN(CVAL)_"-1)),$L("_DATA_"))="_CVAL_")"
        ;
PAT(DATA,CVAL)  ; MUMPS PATTERN MATCH
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL)) "" Q "("_DATA_"?"_CVAL_")"
        ;
        ;
CONT(DATA,CVAL) ; DATA CONTAINS VALUE
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL)) "" Q "("_DATA_"["_CVAL_")"
        ;
PREC(DATA,CVAL) ; DATA PRECEDES VALUE ALPHABETICALLY
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL)) "" Q "("_CVAL_"]"_DATA_")"
        ;
        ;
FOLLOW(DATA,CVAL)       ; DATA FOLLOWS VALUE ALPHABETICALLY
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL)) "" Q "("_DATA_"]"_CVAL_")"
        ;
AEQ(DATA,CVAL)  ; DATA EQUALS VALUE ALPHABETICALLY
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL)) "" Q "("_DATA_"="_CVAL_")"
        ;
AEQT(DATA,CVAL) ; DATA EQUALS STANDARD TERM ALPHABETICALLY
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL)) "" Q "$$EQTERM("_DATA_","_CVAL_")"
        ;
NAEQ(DATA,CVAL) ; DATA DOES NOT EQUAL VALUE ALPHABETICALLY
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL)) "" Q "'("_DATA_"="_CVAL_")"
        ;
AINCL(DATA,CVAL1,CVAL2) ; ALPHA INCLUSIVE BETWEEN
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL1)) "" Q:'$L($G(CVAL2)) ""
        ;
        Q "'("_$$PREC(DATA,CVAL1)_"!"_$$FOLLOW(DATA,CVAL2)_")"
        ;
AEXCL(DATA,CVAL1,CVAL2) ; ALPHA EXCLUSIVE BETWEEN
        ;
        Q:'$L($G(DATA)) "" Q:'$L($G(CVAL1)) "" Q:'$L($G(CVAL2)) ""
        ;
        Q "("_$$FOLLOW(DATA,CVAL1)_"&"_$$PREC(DATA,CVAL2)_")"
        ;
        ; *****  STRING LENGTH OPERATORS  *****
        ;
LGRT(DATA,CVAL) ; GREATER THAN SPECIFIED STRING LENGTH
        ;
        Q $$GRT^OCXF20("$L("_DATA_")",CVAL)
        ;
LESS(DATA,CVAL) ; LESS THAN SPECIFIED STRING LENGTH
        ;
        Q $$LESS^OCXF20("$L("_DATA_")",CVAL)
        ;
LEQ(DATA,CVAL)  ; EQUALS SPECIFIED STRING LENGTH
        ;
        Q $$EQ^OCXF20("$L("_DATA_")",CVAL)
        ;
LINCL(DATA,CVAL1,CVAL2) ; STRING LENGTH INCLUSIVE BETWEEN
        ;
        Q $$INCL^OCXF20("$L("_DATA_")",CVAL1,CVAL2)
        ;
LEXCL(DATA,CVAL1,CVAL2) ; STRING LENGTH EXCLUSIVE BETWEEN
        ;
        Q $$EXCL^OCXF20("$L("_DATA_")",CVAL1,CVAL2)
        ;
EQSET(DATA,CVAL)        ; STRING IS EQUAL TO ONE OF A LIST OF VALUES
        ;
        Q "$$LIST("_DATA_","_CVAL_")"
        ;
CONSET(DATA,CVAL)       ; STRING CONTAINS ONE OF A LIST OF VALUES
        ;
        Q "$$CLIST("_DATA_","_CVAL_")"
        ;
CONNCSET(DATA,CVAL)     ; CASE-INSENSITIVE STRING CONTAINS ONE OF A LIST OF VALUES ;DJE/VM *316 
        ;
        Q "$$CLIST($$UP^XLFSTR("_DATA_"),$$UP^XLFSTR("_CVAL_"))"
        ;
