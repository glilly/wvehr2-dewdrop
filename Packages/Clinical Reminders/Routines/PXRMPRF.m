PXRMPRF ; SLC/AGP,PKR - Computed findings for PRF. ;11/04/2009
        ;;2.0;CLINICAL REMINDERS;**17**;Feb 4, 2005;Build 102
        ;==========================================
PRF(DFN,NGET,BDT,EDT,NFOUND,TEST,DATE,DATA,TEXT)        ;Computed finding for
        N ASSIGNDT,CAT,DONE,FLAG,FLAGKEEP,FLAGLIST,IND
        N NFLAGS,NOCC,OK,SDIR,SUB,TEMP,TYPE
        I (TEST="")!(NGET=0) S NFOUND=0 Q
        ;DBIA #3860
        S NFLAGS=$$GETACT^DGPFAPI(DFN,"FLAGLIST")
        ;If no flags are found quit
        I NFLAGS=0 S NFOUND=0 Q
        S SDIR=$S(NGET<0:1,1:-1)
        S NOCC=$S(NGET<0:-NGET,1:NGET)
        ;Search the parameter list for category, type, and flag.
        S CAT=$F(TEST,"C:")
        I CAT>0 S CAT=$E(TEST,CAT),CAT=$S(CAT="N":"NATIONAL",CAT="L":"LOCAL")
        S TYPE=$F(TEST,"T:")
        I TYPE>0 S TEMP=$E(TEST,TYPE,245),TYPE=$P(TEMP,U,1),TYPE=$S(TYPE="B":"BEHAVIORAL",TYPE="C":"CLINICAL",TYPE="O":"OTHER",TYPE="R":"RESEARCH")
        S FLAG=$F(TEST,"F:")
        I FLAG>0 S TEMP=$E(TEST,FLAG,245),FLAG=$P(TEMP,U,1)
        ;Check all the flags that were returned and keep those that meet
        ;the criteria. Order by assigned date.
        F IND=1:1:NFLAGS D
        . S OK=1
        . I CAT'=0,FLAGLIST(IND,"CATEGORY")'[CAT S OK=0
        . I TYPE'=0,TYPE'=$P(FLAGLIST(IND,"FLAGTYPE"),U,2) S OK=0
        . I FLAG'=0,FLAG'=$P(FLAGLIST(IND,"FLAG"),U,2) S OK=0
        . I OK S FLAGKEEP($P(FLAGLIST(IND,"ASSIGNDT"),U,1),IND)=""
        S ASSIGNDT="",(DONE,NFOUND)=0
        F  S ASSIGNDT=$O(FLAGKEEP(ASSIGNDT),SDIR) Q:(DONE)!(ASSIGNDT="")  D
        . S IND=0
        . F  S IND=$O(FLAGKEEP(ASSIGNDT,IND)) Q:(DONE)!(IND="")  D
        .. S NFOUND=NFOUND+1
        .. I NFOUND=NOCC S DONE=1
        .. S TEST(NFOUND)=1
        .. S DATE(NFOUND)=ASSIGNDT
        .. S SUB=""
        ..;Save the CSUB data.
        .. F  S SUB=$O(FLAGLIST(IND,SUB)) Q:SUB=""  D
        ... I SUB="NARR" Q
        ... S DATA(NFOUND,SUB)=$P($G(FLAGLIST(IND,SUB)),U,2)
        .. S TEXT(NFOUND)=DATA(NFOUND,"FLAG")_"; Category: "_DATA(NFOUND,"CATEGORY")_"; TYPE: "_DATA(NFOUND,"FLAGTYPE")
        Q
        ;
