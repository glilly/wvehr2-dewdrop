PXRMLOCF        ; SLC/PKR - Handle location findings. ;05/18/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,11,12**;Feb 04, 2005;Build 73
        ;This routine is for location list patient findings.
        ;=================================================
ALL(FILENUM,DFN,PFINDPA,FIEVAL) ;Get all Visits with a location
        ;for a patient.
        N BDT,BTIME,CASESEN,COND,CONVAL,DAS,DATE,DEND,DONE,DS,EDT,ETIME,FIEVD
        N ICOND,INVBD,INVDATE,INVDT,INVED,NFOUND,NOCC
        N SAVE,SDIR,TEMP,TIME,UCIFS
        ;Set the finding search parameters.
        D SSPAR^PXRMUTIL(PFINDPA(0),.NOCC,.BDT,.EDT)
        S SDIR=$S(NOCC<0:-1,1:1)
        S NOCC=$S(NOCC<0:-NOCC,1:NOCC)
        D SCPAR^PXRMCOND(.PFINDPA,.CASESEN,.COND,.UCIFS,.ICOND,.VSLIST)
        S (DONE,NFOUND)=0
        S DEND=$S(EDT[".":EDT,1:EDT+.235959)
        S INVBD=9999999-$P(BDT,".",1),BTIME="."_$P(BDT,".",2)
        S INVED=9999999-$P(DEND,".",1),ETIME="."_$P(DEND,".",2)
        I SDIR=1 S DS=INVED-.000001
        I SDIR=-1 S DS=INVBD+.000001
        S INVDT=DS,(DONE,NFOUND)=0
        ;DBIA 2028
        F  S INVDT=$O(^AUPNVSIT("AA",DFN,INVDT),SDIR) Q:(DONE)!(INVDT="")  D
        . S INVDATE=$P(INVDT,".",1)
        . I (SDIR=1),INVDATE>INVBD S DONE=1 Q
        . I (SDIR=-1),INVDATE<INVED S DONE=1 Q
        . S TIME="."_$P(INVDT,".",2)
        . I INVDATE=INVED,TIME>ETIME Q
        . I INVDATE=INVBD,TIME<BTIME Q
        . S DAS=0
        . F  S DAS=$O(^AUPNVSIT("AA",DFN,INVDT,DAS)) Q:(DAS="")!(DONE)  D
        .. D GETDATA^PXRMDATA(FILENUM,DAS,.FIEVD)
        .. S DATE=$P(^AUPNVSIT(DAS,0),U,1)
        .. S FIEVD("DATE")=DATE
        .. S CONVAL=$S(COND="":1,1:$$COND^PXRMCOND(CASESEN,ICOND,VSLIST,.FIEVD))
        .. S SAVE=$S('UCIFS:1,(UCIFS&CONVAL):1,1:0)
        .. I SAVE D
        ... S NFOUND=NFOUND+1
        ... S FIEVAL(NFOUND)=CONVAL
        ... I COND'="" S FIEVAL(NFOUND,"CONDITION")=CONVAL
        ... S FIEVAL(NFOUND,"DAS")=DAS
        ... S FIEVAL(NFOUND,"DATE")=DATE
        ... M FIEVAL(NFOUND)=FIEVD
        ... I $G(PXRMDEBG) M FIEVAL(NFOUND,"CSUB")=FIEVD
        ... I NFOUND=NOCC S DONE=1
        ;Save the finding result.
        D SFRES^PXRMUTIL(-SDIR,NFOUND,.FIEVAL)
        S FIEVAL("FILE NUMBER")=FILENUM
        Q
        ;
        ;=================================================
EVALFI(DFN,DEFARR,ENODE,FIEVAL) ;Evaluate location findings.
        N BDT,EDT,FIEVT,FILENUM,FINDING,FINDPA,ITEM
        S FILENUM=$$GETFNUM^PXRMDATA(ENODE)
        S ITEM=""
        F  S ITEM=$O(DEFARR("E",ENODE,ITEM)) Q:+ITEM=0  D
        . S FINDING=""
        . F  S FINDING=$O(DEFARR("E",ENODE,ITEM,FINDING)) Q:+FINDING=0  D
        .. K FINDPA
        .. M FINDPA=DEFARR(20,FINDING)
        .. K FIEVT
        .. D FIEVAL(FILENUM,"PI",DFN,ITEM,.FINDPA,.FIEVT)
        .. M FIEVAL(FINDING)=FIEVT
        .. S FIEVAL(FINDING,"FINDING")=$P(FINDPA(0),U,1)
        Q
        ;
        ;=================================================
EVALTERM(DFN,FINDPA,ENODE,TERMARR,TFIEVAL)      ;Evaluate location terms.
        N FIEVT,FILENUM,ITEM,PFINDPA
        N TEMP,TFINDING,TFINDPA
        S FILENUM=$$GETFNUM^PXRMDATA(ENODE)
        S ITEM=""
        F  S ITEM=$O(TERMARR("E",ENODE,ITEM)) Q:+ITEM=0  D
        . S TFINDING=""
        . F  S TFINDING=$O(TERMARR("E",ENODE,ITEM,TFINDING)) Q:+TFINDING=0  D
        .. K FIEVT,PFINDPA,TFINDPA
        .. M TFINDPA=TERMARR(20,TFINDING)
        ..;Set the finding parameters.
        .. D SPFINDPA^PXRMTERM(.FINDPA,.TFINDPA,.PFINDPA)
        .. D FIEVAL(FILENUM,"PI",DFN,ITEM,.PFINDPA,.FIEVT)
        .. M TFIEVAL(TFINDING)=FIEVT
        .. S TFIEVAL(TFINDING,"FINDING")=$P(TFINDPA(0),U,1)
        Q
        ;
        ;=================================================
FIEVAL(FILENUM,SNODE,DFN,ITEM,PFINDPA,FIEVAL)   ;
        ;Evaluate regular patient findings.
        N BDT,CASESEN,COND,CONVAL,DAS,DATE,EDT,FIEVD,FLIST,HLOC
        N ICOND,IND,LNAME,NFOUND,NGET,NOCC,NP
        N SAVE,SDIR,STATUSA,TEMP,UCIFS,VSLIST
        S LNAME=$P(^PXRMD(810.9,ITEM,0),U,1)
        I LNAME="VA-ALL LOCATIONS" D ALL(FILENUM,DFN,.PFINDPA,.FIEVAL) Q
        ;Set the finding search parameters.
        D SSPAR^PXRMUTIL(PFINDPA(0),.NOCC,.BDT,.EDT)
        S SDIR=$S(NOCC<0:-1,1:1)
        D SCPAR^PXRMCOND(.PFINDPA,.CASESEN,.COND,.UCIFS,.ICOND,.VSLIST)
        S NOCC=$S(NOCC<0:-NOCC,1:NOCC)
        S NGET=$S(UCIFS:50,$D(STATUSA):50,1:NOCC)
        ;Get a list of unique locations.
        D LOCLIST(ITEM,"HLOCL")
        D FPDAT(DFN,"HLOCL",NGET,SDIR,BDT,EDT,.NFOUND,.FLIST)
        I NFOUND=0 S FIEVAL=0 Q
        S NP=0
        F IND=1:1:NFOUND Q:NP=NOCC  D
        . S DAS=$P(FLIST(IND),U,1)
        . D GETDATA^PXRMDATA(FILENUM,DAS,.FIEVD)
        . S FIEVD("DATE")=$P(FLIST(IND),U,2)
        . S CONVAL=$S(COND'="":$$COND^PXRMCOND(CASESEN,ICOND,VSLIST,.FIEVD),1:1)
        . S SAVE=$S('UCIFS:1,(UCIFS&CONVAL):1,1:0)
        . I SAVE D
        .. S NP=NP+1
        .. S FIEVAL(NP)=CONVAL
        .. I COND'="" S FIEVAL(NP,"CONDITION")=CONVAL
        .. S FIEVAL(NP,"DAS")=$P(FLIST(IND),U,1)
        .. S FIEVAL(NP,"DATE")=FIEVD("DATE")
        .. M FIEVAL(NP)=FIEVD
        .. I $G(PXRMDEBG) M FIEVAL(NP,"CSUB")=FIEVD
        ;
        ;Save the finding result.
        D SFRES^PXRMUTIL(-NOCC,NP,.FIEVAL)
        S FIEVAL("FILE NUMBER")=FILENUM
        Q
        ;
        ;=================================================
FPDAT(DFN,HLOCL,NOCC,SDIR,BDT,EDT,NFOUND,FLIST) ;Find patient data for
        ;visits at a specified hospital location. Return up to NOCC most
        ;recent entries in FLIST where FLIST(1) is the most recent.
        ;"AA" in Visit file is inverse date_.time instead of a full inverse
        ;date and time. For example if the date/time is 3030704.104449 then
        ;"AA" has 6969295.104449 instead of 6969295.89555
        N BTIME,DAS,DATE,DEND,DLIST,DONE,DS,ETIME,HLOC
        N INVBD,INVDATE,INVDT,INVED,NF,TEMP,TIME
        S DEND=$S(EDT[".":EDT,1:EDT+.235959)
        S INVBD=9999999-$P(BDT,".",1),BTIME="."_$P(BDT,".",2)
        S INVED=9999999-$P(DEND,".",1),ETIME="."_$P(DEND,".",2)
        I SDIR=1 S DS=INVED-.000001
        I SDIR=-1 S DS=INVBD+.000001
        ;DBIA #2028
        S INVDT=DS,(DONE,NFOUND)=0
        F  S INVDT=$O(^AUPNVSIT("AA",DFN,INVDT),SDIR) Q:(INVDT="")!(DONE)  D
        . S NF=0
        . S INVDATE=$P(INVDT,".",1)
        . I (SDIR=1),INVDATE>INVBD S DONE=1 Q
        . I (SDIR=-1),INVDATE<INVED S DONE=1 Q
        . S TIME="."_$P(INVDT,".",2)
        . I INVDATE=INVED,TIME>ETIME Q
        . I INVDATE=INVBD,TIME<BTIME Q
        . S DAS=0
        . F  S DAS=$O(^AUPNVSIT("AA",DFN,INVDT,DAS)) Q:(DAS="")!(DONE)  D
        .. S TEMP=^AUPNVSIT(DAS,0)
        .. S HLOC=$P(TEMP,U,22)
        .. I HLOC="" Q
        .. I '$D(^TMP($J,HLOCL,HLOC)) Q
        ..;Check the associated appointment for a valid status.
        .. I '$$VAPSTAT^PXRMVSIT(DAS) Q
        .. S DATE=$P(TEMP,U,1)
        .. S NF=NF+1,NFOUND=NFOUND+1
        .. I NFOUND=NOCC S DONE=1
        .. S DLIST(INVDT,NF)=DAS_U_DATE
        S INVDT="",NFOUND=0
        F  S INVDT=$O(DLIST(INVDT)) Q:INVDT=""  D
        . S NF=0
        . F  S NF=$O(DLIST(INVDT,NF)) Q:NF=""  D
        .. S NFOUND=NFOUND+1
        .. S FLIST(NFOUND)=DLIST(INVDT,NF)
        K ^TMP($J,"HLOCL")
        Q
        ;
        ;=================================================
LOCLIST(ITEM,SUB)       ;Build a list of unique locations based on stop code
        ;and/or hospital location. Reads of ^SC covered by DBIA #4482.
        N CSTOP,EXCL,EXCLNCS,EXCLP,IND,JND,HLOC,STOP
        K ^TMP($J,SUB)
        ;Process stop codes. EXCL is the list of credit stops to exclude.
        S IND=0
        F  S IND=+$O(^PXRMD(810.9,ITEM,40.7,IND)) Q:IND=0  D
        . S STOP=$P(^PXRMD(810.9,ITEM,40.7,IND,0),U,1)
        . K EXCL
        .;Check for individual credit stops to exclude entries.
        . S JND=0
        . F  S JND=+$O(^PXRMD(810.9,ITEM,40.7,IND,1,JND)) Q:JND=0  D
        .. S EXCL=$P(^PXRMD(810.9,ITEM,40.7,IND,1,JND,0),U,1)
        .. S EXCL(EXCL)=""
        .;Check for a list of credit stops to exclude.
        . S EXCLP=$G(^PXRMD(810.9,ITEM,40.7,IND,2))
        . I EXCLP'="" D
        .. S JND=0
        .. F  S JND=+$O(^PXRMD(810.9,EXCLP,40.7,JND)) Q:JND=0  D
        ... S EXCL=$P(^PXRMD(810.9,EXCLP,40.7,JND,0),U,1)
        ... S EXCL(EXCL)=""
        .;See if locations with no credit stop should be excluded.
        . S EXCLNCS=+$G(^PXRMD(810.9,ITEM,40.7,IND,3))
        . S HLOC=""
        . F  S HLOC=$O(^SC("AST",STOP,HLOC)) Q:HLOC=""  D
        .. ;See if there are any to exclude.
        .. S CSTOP=$P(^SC(HLOC,0),U,18)
        .. I CSTOP'="",$D(EXCL(CSTOP)) Q
        .. I CSTOP="",EXCLNCS Q
        .. S ^TMP($J,SUB,HLOC)=""
        ;Process locations.
        S IND=0
        F  S IND=+$O(^PXRMD(810.9,ITEM,44,IND)) Q:IND=0  D
        . S HLOC=^PXRMD(810.9,ITEM,44,IND,0)
        . S ^TMP($J,SUB,HLOC)=""
        Q
        ;
        ;=================================================
MHVOUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the MHV output.
        ;DBIAs (^DIC(4: #10090), (^DIC(40.7: #557), (^SC: #10040)
        N HLOC,IND,JND,LOC,NAME,NIN,NOUT,SC,TEMP,TEXTIN,TEXTOUT,VDATE
        S NAME="Outpatient Encounter = "
        S IND=0
        F  S IND=+$O(IFIEVAL(IND)) Q:IND=0  D
        . S NIN=0
        . S VDATE=IFIEVAL(IND,"DATE")
        . S LOC=$G(IFIEVAL(IND,"LOC. OF ENCOUNTER"))
        . S LOC=$S(LOC="":"?",1:$P($G(^DIC(4,LOC,0)),U,1))
        . S SC=$G(IFIEVAL(IND,"DSS ID"))
        . S SC=$S(SC="":"?",1:" "_$P($G(^DIC(40.7,SC,0)),U,1))
        . S HLOC=$G(IFIEVAL(IND,"HOSPITAL LOCATION"))
        . S HLOC=$S(HLOC="":"?",1:" "_$P($G(^SC(HLOC,0)),U,1))
        . S TEMP=NAME_LOC_HLOC_SC_" ("_$$EDATE^PXRMDATE(VDATE)_")"
        . D FORMATS^PXRMTEXT(INDENT+2,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        . F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
        ;=================================================
OUTPUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the clinical
        ;maintenance output.
        ;DBIAs (^DIC(4: #10090), (^DIC(40.7: #557), (^SC: #10040)
        N EM,HLOC,IND,JND,LOC,NIN,NOUT,SC,STATUS,TEMP,TEXTIN,TEXTOUT,VDATE
        S NLINES=NLINES+1
        S TEXT(NLINES)=$$INSCHR^PXRMEXLC(INDENT," ")_"PCE Encounter:"
        S IND=0
        F  S IND=+$O(IFIEVAL(IND)) Q:IND=0  D
        . S NIN=0
        . S VDATE=IFIEVAL(IND,"DATE")
        . S TEMP=$$EDATE^PXRMDATE(VDATE)
        . S LOC=$G(IFIEVAL(IND,"LOC. OF ENCOUNTER"))
        . S LOC=$S(LOC="":"?",1:$P($G(^DIC(4,LOC,0)),U,1))
        . S TEMP=TEMP_" Facility - "_LOC
        . D FORMATS^PXRMTEXT(INDENT+1,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        . F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        . S HLOC=$G(IFIEVAL(IND,"HLOC"))
        . I HLOC="" S HLOC="?"
        . S TEMP="Hospital Location: "_HLOC
        . S SC=$G(IFIEVAL(IND,"STOP CODE"))
        . I SC="" S SC="?"
        . S TEMP=TEMP_"; Clinic Stop: "_SC
        . S NIN=NIN+1,TEXTIN(NIN)=TEMP_"\\"
        . S SC=$G(IFIEVAL(IND,"SERVICE CATEGORY"))
        . S TEMP="Service Category: "_SC_"="_$$EXTERNAL^DILFD(9000010,.07,"",SC,.EM)
        . S NIN=NIN+1,TEXTIN(NIN)=TEMP_"\\"
        . S STATUS=$P($G(IFIEVAL(IND,"STATUS")),U,2)
        . I STATUS="" S STATUS="?"
        . S TEMP="Appointment Status: "_STATUS
        . S NIN=NIN+1,TEXTIN(NIN)=TEMP_"\\"
        . D FORMAT^PXRMTEXT(INDENT+2,PXRMRM,NIN,.TEXTIN,.NOUT,.TEXTOUT)
        . F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        . I IFIEVAL(IND,"COMMENTS")'="" D
        .. S TEMP="Comments: "_IFIEVAL(IND,"COMMENTS")
        .. D FORMATS^PXRMTEXT(INDENT+3,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        .. F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
