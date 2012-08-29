PXRMTAX ; SLC/PKR - Handle taxonomy finding. ;08/06/2008
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;
        ;==================================================
EVALFI(DFN,DEFARR,ENODE,FIEVAL) ;Evaluate taxonomy findings.
        N FIEVT,FINDPA,FINDING
        N TAXIEN
        S TAXIEN=""
        F  S TAXIEN=$O(DEFARR("E",ENODE,TAXIEN)) Q:+TAXIEN=0  D
        . S FINDING=""
        . F  S FINDING=$O(DEFARR("E",ENODE,TAXIEN,FINDING)) Q:+FINDING=0  D
        .. K FINDPA
        .. M FINDPA=DEFARR(20,FINDING)
        .. K FIEVT
        .. D FIEVAL(DFN,TAXIEN,.FINDPA,.FIEVT)
        .. M FIEVAL(FINDING)=FIEVT
        Q
        ;
        ;==================================================
EVALPL(FINDPA,ENODE,TERMARR,PLIST)      ;Evaluate taxonomy terms for
        ;building patient lists.
        N PFIND3,PFIND4,PFINDPA,TAXIEN
        N TFINDPA,TFINDING
        S TAXIEN=""
        F  S TAXIEN=$O(TERMARR("E",ENODE,TAXIEN)) Q:+TAXIEN=0  D
        . S TFINDING=""
        . F  S TFINDING=$O(TERMARR("E",ENODE,TAXIEN,TFINDING)) Q:+TFINDING=0  D
        .. K PFINDPA,TFINDPA
        .. M TFINDPA=TERMARR(20,TFINDING)
        ..;Set the finding parameters.
        .. D SPFINDPA^PXRMTERM(.FINDPA,.TFINDPA,.PFINDPA)
        .. D GPLIST(TAXIEN,.PFINDPA,PLIST)
        Q
        ;
        ;==================================================
EVALTERM(DFN,FINDPA,ENODE,TERMARR,TFIEVAL)      ;Evaluate taxonomy
        ;terms.
        N FIEVT,PFINDPA
        N TAXIEN,TFINDPA,TFINDING
        S TAXIEN=""
        F  S TAXIEN=$O(TERMARR("E",ENODE,TAXIEN)) Q:+TAXIEN=0  D
        . S TFINDING=""
        . F  S TFINDING=$O(TERMARR("E",ENODE,TAXIEN,TFINDING)) Q:+TFINDING=0  D
        .. K FIEVT,PFINDPA,TFINDPA
        .. M TFINDPA=TERMARR(20,TFINDING)
        ..;Set the finding parameters.
        .. D SPFINDPA^PXRMTERM(.FINDPA,.TFINDPA,.PFINDPA)
        .. D FIEVAL(DFN,TAXIEN,.PFINDPA,.FIEVT)
        .. M TFIEVAL(TFINDING)=FIEVT
        Q
        ;
        ;==================================================
FIEVAL(DFN,TAXIEN,FINDPA,FIEVAL)        ;
        N BDT,CASESEN,COND,CONVAL,DAS,DATE,EDT,ENS,FIEVT,FILENUM,FLIST
        N ICOND,IND,INS,INVFD
        N NFOUND,NGET,NICD0,NICD9,NCPT,NOCC,NP,NRCPT,PLS
        N RAS,SAVE,SDIR,STATUSA,TAXARR,TLIST,UCIFS,USEINP,VSLIST
        ;Set the finding search parameters.
        D SSPAR^PXRMUTIL(FINDPA(0),.NOCC,.BDT,.EDT)
        S INVFD=$P(FINDPA(0),U,16)
        D TAX^PXRMLDR(TAXIEN,.TAXARR)
        I TAXARR(0)["NO LOCK" S FIEVAL(1)=0 Q
        D SETVAR^PXRMTAXS(.TAXARR,.ENS,.INS,.NICD0,.NICD9,.NCPT,.NRCPT,.PLS,.RAS)
        D SCPAR^PXRMCOND(.FINDPA,.CASESEN,.COND,.UCIFS,.ICOND,.VSLIST)
        S SDIR=$S(NOCC<0:+1,1:-1)
        S NOCC=$S(NOCC<0:-NOCC,1:NOCC)
        S NGET=$S(UCIFS:50,1:NOCC)
        ;
        I (NICD0>0),INS D FPDAT^PXRMDGPT(DFN,.TAXARR,NGET,SDIR,BDT,EDT,"ICD0",.TLIST)
        ;
        I (NICD9>0),INS D FPDAT^PXRMDGPT(DFN,.TAXARR,NGET,SDIR,BDT,EDT,"ICD9",.TLIST)
        I (NICD9>0),ENS D FPDAT^PXRMVPOV(DFN,.TAXARR,NGET,SDIR,BDT,EDT,.TLIST)
        I (NICD9>0),PLS D
        . K STATUSA
        . D GETSTATI^PXRMSTAT(9000011,.FINDPA,.STATUSA)
        . D FPDAT^PXRMPROB(DFN,.TAXARR,NGET,SDIR,BDT,EDT,.STATUSA,.TLIST)
        ;
        I (NCPT>0),(ENS) D FPDAT^PXRMVCPT(DFN,.TAXARR,NGET,SDIR,BDT,EDT,.TLIST)
        ;
        I (NRCPT>0),(RAS) D
        . K STATUSA
        . D GETSTATI^PXRMSTAT(70,.FINDPA,.STATUSA)
        . D FPDAT^PXRMRCPT(DFN,.TAXARR,NOCC,BDT,EDT,.STATUSA,.TLIST)
        ;
        ;Process the found list, returning the NOCC most recent results.
        S NFOUND=0
        S DATE=""
        F  S DATE=$O(TLIST(DATE),SDIR) Q:(DATE="")!(NFOUND=NOCC)  D
        . S IND=0
        . F  S IND=$O(TLIST(DATE,IND)) Q:(IND="")!(NFOUND=NOCC)  D
        .. S FILENUM=0
        .. F  S FILENUM=$O(TLIST(DATE,IND,FILENUM)) Q:FILENUM=""  D
        ... S NFOUND=NFOUND+1
        ... S DAS=$P(TLIST(DATE,IND,FILENUM),U,1)
        ... S FLIST(NFOUND)=TLIST(DATE,IND,FILENUM)
        ... S FLIST(NFOUND)=DAS_U_DATE_U_FILENUM_U_$P(TLIST(DATE,IND,FILENUM),U,2,10)
        I NFOUND=0 S FIEVAL=0 Q
        S NP=0
        F IND=1:1:NFOUND Q:NP=NOCC  D
        . S DAS=$P(FLIST(IND),U,1)
        . S FILENUM=$P(FLIST(IND),U,3)
        . D GETDATA^PXRMDATA(FILENUM,DAS,.FIEVT)
        . I $D(FIEVT("VISIT")) D GETDATA^PXRMVSIT(FIEVT("VISIT"),.FIEVT,0)
        . S FIEVT("DATE")=$P(FLIST(IND),U,2)
        . S CONVAL=$S(COND'="":$$COND^PXRMCOND(CASESEN,ICOND,VSLIST,.FIEVT),1:1)
        . S SAVE=$S('UCIFS:1,(UCIFS&CONVAL):1,1:0)
        . I SAVE D
        .. S NP=NP+1
        .. S FIEVAL(NP)=CONVAL
        .. S FIEVAL(NP,"CONDITION")=CONVAL
        .. S FIEVAL(NP,"CODEP")=$P(FLIST(IND),U,4)
        .. S FIEVAL(NP,"DAS")=DAS
        .. S FIEVAL(NP,"DATE")=FIEVT("DATE")
        .. S FIEVAL(NP,"FILE NUMBER")=FILENUM
        .. S FIEVAL(NP,"FILE SPECIFIC")=$P(FLIST(IND),U,5,10)
        .. S FIEVAL(NP,"FINDING")=TAXIEN_";PXD(811.2,"
        .. M FIEVAL(NP)=FIEVT
        .. I $G(PXRMDEBG) M FIEVAL(NP,"CSUB")=FIEVT
        ;Save the finding result.
        D SFRES^PXRMUTIL(SDIR,NP,.FIEVAL)
        Q
        ;
        ;==================================================
GPLIST(TAXIEN,FINDPA,PLIST)     ;Get the list of patients with
        ;taxonomy TAXIEN. Return the list as:
        ; ^TMP($J,PLIST,T/F,DFN,TAXIEN,COUNT,FILE NUMBER)
        ; =DAS^DATE^CODE^TYPE^file specific. TAXIEN is like the item for
        ;non-taxonomy findings.
        N BDT,COND,DATE,DFN,DLIST,EDT,ENS,FILENUM
        N ICOND,IND,INS,IPLIST
        N NF,NFOUND,NICD0,NICD9,NCPT,NF,NGET,NOCC,NRCPT
        N PLS,RAS,STATUSA,UCIFS,USEINP,TAXARR,TF,TLIST,VSLIST
        ;Set the finding search parameters.
        S TLIST="GPLIST_PXRMTAX"
        K ^TMP($J,TLIST)
        D SSPAR^PXRMUTIL(FINDPA(0),.NOCC,.BDT,.EDT)
        D TAX^PXRMLDR(TAXIEN,.TAXARR)
        D SETVAR^PXRMTAXS(.TAXARR,.ENS,.INS,.NICD0,.NICD9,.NCPT,.NRCPT,.PLS,.RAS)
        D SCPAR^PXRMCOND(.FINDPA,.COND,.UCIFS,.ICOND,.VSLIST)
        ;
        I (NICD0>0),INS D GPLIST^PXRMDGPT(.TAXARR,NOCC,BDT,EDT,"ICD0",TLIST)
        ;
        I (NICD9>0),INS D GPLIST^PXRMDGPT(.TAXARR,NOCC,BDT,EDT,"ICD9",TLIST)
        I (NICD9>0),PLS D 
        . K STATUSA
        . D GETSTATI^PXRMSTAT(9000011,.FINDPA,.STATUSA)
        . D GPLIST^PXRMPROB(.TAXARR,NOCC,BDT,EDT,.STATUSA,TLIST)
        I (NICD9>0),ENS D GPLIST^PXRMVPOV(.TAXARR,NOCC,BDT,EDT,TLIST)
        ;
        I (NCPT>0),ENS D GPLIST^PXRMVCPT(.TAXARR,NOCC,BDT,EDT,TLIST)
        ;
        I (NRCPT>0),RAS D GPLIST^PXRMRCPT(.TAXARR,.FINDPA,TLIST)
        ;Conditions for taxonomies only apply to radiology findings, this
        ;is taken care of in PXRMRCPT.
        ;Process the found list, return up to NOCC of the most recent entries.
        F TF=0,1 D
        . I '$D(^TMP($J,TLIST,TF)) Q
        . S DFN=""
        . F  S DFN=$O(^TMP($J,TLIST,TF,DFN)) Q:DFN=""  D
        .. K DLIST,IPLIST
        .. S NFOUND=0
        .. S NF=""
        .. F  S NF=$O(^TMP($J,TLIST,TF,DFN,NF),-1) Q:NF=""  D
        ... S FILENUM=0
        ... F  S FILENUM=$O(^TMP($J,TLIST,TF,DFN,NF,FILENUM)) Q:FILENUM=""  D
        .... S NFOUND=NFOUND+1
        .... S DATE=$P(^TMP($J,TLIST,TF,DFN,NF,FILENUM),U,2)
        .... S DLIST(DATE,NFOUND)=NF_U_FILENUM
        ..;
        .. S DATE="",NFOUND=0
        .. F  S DATE=$O(DLIST(DATE),-1) Q:(DATE="")!(NFOUND=NOCC)  D
        ... S NF=0
        ... F  S NF=$O(DLIST(DATE,NF)) Q:(NF="")!(NFOUND=NOCC)  D
        .... S NFOUND=NFOUND+1
        .... S IND=$P(DLIST(DATE,NF),U,1)
        .... S FILENUM=$P(DLIST(DATE,NF),U,2)
        .... S IPLIST(TF,DFN,TAXIEN,NFOUND,FILENUM)=^TMP($J,TLIST,TF,DFN,IND,FILENUM)
        .. M ^TMP($J,PLIST)=IPLIST
        K ^TMP($J,TLIST)
        Q
        ;
        ;==================================================
MHVOUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the MHV output.
        N IND,FILENUM,FNA,OCCLIST,TIFIEVAL
        S IND=0
        F  S IND=+$O(IFIEVAL(IND)) Q:IND=0  S FILENUM=IFIEVAL(IND,"FILE NUMBER"),FNA(FILENUM,IND)=""
        S FILENUM=""
        F  S FILENUM=$O(FNA(FILENUM)) Q:FILENUM=""  D
        . K OCCLIST
        . M OCCLIST=FNA(FILENUM)
        . I FILENUM=45 D MHVOUT^PXRMDGPT(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT) Q
        . I FILENUM=70 D MHVOUT^PXRMRCPT(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT) Q
        . I FILENUM=9000010.07 D MHVOUT^PXRMVPOV(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT) Q
        . I FILENUM=9000010.18 D MHVOUT^PXRMVCPT(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT) Q
        . I FILENUM=9000011 D MHVOUT^PXRMPROB(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT)
        Q
        ;
        ;==================================================
OUTPUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the clinical
        ;maintenance output.
        N IND,FILENUM,FNA,OCCLIST,TIFIEVAL
        S IND=0
        F  S IND=+$O(IFIEVAL(IND)) Q:IND=0  S FILENUM=IFIEVAL(IND,"FILE NUMBER"),FNA(FILENUM,IND)=""
        S FILENUM=""
        F  S FILENUM=$O(FNA(FILENUM)) Q:FILENUM=""  D
        . K OCCLIST
        . M OCCLIST=FNA(FILENUM)
        . I FILENUM=45 D OUTPUT^PXRMDGPT(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT) Q
        . I FILENUM=70 D OUTPUT^PXRMRCPT(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT) Q
        . I FILENUM=9000010.07 D OUTPUT^PXRMVPOV(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT) Q
        . I FILENUM=9000010.18 D OUTPUT^PXRMVCPT(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT) Q
        . I FILENUM=9000011 D OUTPUT^PXRMPROB(INDENT,.OCCLIST,.IFIEVAL,.NLINES,.TEXT)
        Q
        ;
