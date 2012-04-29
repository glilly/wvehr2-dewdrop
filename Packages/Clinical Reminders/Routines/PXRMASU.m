PXRMASU ;SLC/PKR - Clinical Reminder ASU routines. ;01/29/2010
        ;;2.0;CLINICAL REMINDERS;**17**;Feb 04, 2005;Build 102
        ;==========================================================
CLASS(DFN,NGET,BDT,EDT,NFOUND,TEST,DATE,DATA,TEXT)      ;Computed finding
        ;for user class. Use of USRLM covered by DBIA #2324.
        S NFOUND=0
        Q:NGET=0
        N CLASSOK,CLIST,CNAME,EFFDATE,EXPDATE,FEFFDATE,DONE,IND,JND,LIST
        N NOCC,OLIST,OVERLAP,SDIR,TCLASS,USER
        S TCLASS=TEST
        S USER=DUZ
        D WHATIS^USRLM(USER,"LIST",1)
        ;Order the list by Effective Date.
        S IND=0
        F  S IND=$O(LIST(IND)) Q:IND=""  D
        . S EFFDATE=+$P(LIST(IND),U,4),EXPDATE=$P(LIST(IND),U,5)
        . I EXPDATE="" S EXPDATE=$$NOW^PXRMDATE
        .;Only keep the entries whose date range, defined by Effective Date
        .;and Expiration Date is in the date range defined by BDT and EDT.
        . I $$OVERLAP^PXRMINDX(EFFDATE,EXPDATE,BDT,EDT)'="O" Q
        .;If TCLASS is not null then check for membership in the specified
        .;class or subclass.
        . S CLASSOK=$S(TCLASS="":1,TCLASS=$P(LIST(IND),U,3):1,1:$$SUBCLASS^USRLM($P(LIST(IND),U,1),TCLASS))
        . I CLASSOK S JND(EFFDATE)=+$G(JND(EFFDATE))+1,OLIST(EFFDATE,JND(EFFDATE))=LIST(IND)
        S SDIR=$S(NGET>0:-1,1:1)
        S NOCC=$S(NGET>0:NGET,1:-NGET)
        S DONE=0,EFFDATE=""
        F  S EFFDATE=$O(OLIST(EFFDATE),SDIR) Q:(DONE)!(EFFDATE="")  D
        . S IND=0
        . F  S IND=$O(OLIST(EFFDATE,IND)) Q:(DONE)!(IND="")  D
        .. S CNAME=$P(OLIST(EFFDATE,IND),U,3)
        .. S EXPDATE=$P(OLIST(EFFDATE,IND),U,5)
        .. S NFOUND=NFOUND+1
        .. I NFOUND=NOCC S DONE=1
        .. S TEST(NFOUND)=1
        .. S DATE(NFOUND)=EFFDATE
        .. S DATA(NFOUND,"ASU CLASS")=CNAME
        .. S DATA(NFOUND,"EFFECTIVE DATE")=EFFDATE
        .. S DATA(NFOUND,"EXPIRATION DATE")=EXPDATE
        .. S FEFFDATE=$S(EFFDATE=0:"00/00/0000",1:$$FMTE^XLFDT(EFFDATE,"5Z"))
        .. I EXPDATE'="" S EXPDATE=$$EDATE^PXRMDATE(EXPDATE)
        .. S TEXT(NFOUND)=CNAME_" ("_FEFFDATE_" - "_EXPDATE_")"
        Q
        ;
