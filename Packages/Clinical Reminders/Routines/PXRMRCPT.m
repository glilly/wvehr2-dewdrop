PXRMRCPT        ; SLC/PKR - Code to handle radiology CPT data. ;08/04/2008
        ;;2.0;CLINICAL REMINDERS;**4,12**;Feb 04, 2005;Build 73
        ;
        ;==============================================
FPDAT(DFN,TAXARR,NOCC,BDT,EDT,STATUSA,FLIST)    ;Find data for a
        ;patient. The expanded taxonomy stores radiology data by procedure
        ;ien i.e.,
        ;^PXD(811.3,N,71,"RCPTP",RADPROC,DA)
        ;^PXD(811.3,81,DA,0)=ICPTP
        N DA,DATE,FIEVT,ICPTP,IND,NOCCABS,NFOUND,PFINDPA
        N RADPROC,SDIR,TE,TDATE,TIND,TF,TLIST,TS
        I $G(^PXRMINDX(70,"DATE BUILT"))="" D  Q
        . D NOINDEX^PXRMERRH("TX",TAXARR("IEN"),70)
        I '$D(^PXRMINDX(70,"PI",DFN)) Q
        I '$D(TAXARR(71)) Q
        S $P(PFINDPA(0),U,8)=BDT
        S $P(PFINDPA(0),U,11)=EDT
        S $P(PFINDPA(0),U,14)=NOCC
        S SDIR=$S(NOCC<0:+1,1:-1)
        F IND=1:1:STATUSA(0) S PFINDPA(5,IND)=STATUSA(IND)
        ;Get the start and end of the taxonomy, for radiology these are
        ;actually radiology procedures, which we use to get to the CPT codes.
        S TS=$O(TAXARR(71,""))-1
        S TE=$O(TAXARR(71,""),-1)
        S NFOUND=0
        S RADPROC=TS
        F  S RADPROC=$O(^PXRMINDX(70,"PI",DFN,RADPROC)) Q:(RADPROC>TE)!(RADPROC="")  D
        . I '$D(TAXARR(71,RADPROC)) Q
        . K FIEVT
        . D FIEVAL^PXRMINDX(70,"PI",DFN,RADPROC,.PFINDPA,.FIEVT)
        . I FIEVT D
        .. S DA=$O(TAXARR(71,RADPROC,""))
        .. S ICPTP=TAXARR(71,RADPROC,DA,0)
        .. S IND=0
        .. F  S IND=+$O(FIEVT(IND)) Q:IND=0  D
        ... S NFOUND=NFOUND+1
        ... S TLIST(FIEVT(IND,"DATE"),NFOUND)=FIEVT(IND,"DAS")_U_ICPTP_U_RADPROC_U_"CPT"
        ... I NFOUND>NGET D
        .... S TDATE=$O(TLIST(""),-SDIR),TIND=$O(TLIST(TDATE,""))
        .... K TLIST(TDATE,TIND)
        ;Return up to NOCC of the most recent entries.
        S NOCCABS=$S(NOCC<0:-NOCC,1:NOCC)
        S NFOUND=0
        S DATE=""
        F  S DATE=$O(TLIST(DATE),SDIR) Q:(DATE="")!(NFOUND=NOCCABS)  D
        . S IND=0
        . F  S IND=$O(TLIST(DATE,IND)) Q:(IND="")!(NFOUND=NOCCABS)  D
        .. S NFOUND=NFOUND+1
        .. S FLIST(DATE,NFOUND,70)=TLIST(DATE,IND)
        Q
        ;
        ;==============================================
GPLIST(TAXARR,PFINDPA,PLIST)    ;Build a patient list for radiology CPT entries.
        N DA,DAS,DATE,DFN,ICPTP,NFOUND
        N RADPROC,TEMP,TF,TLIST,VALUE
        I $G(^PXRMINDX(70,"DATE BUILT"))="" D  Q
        . D NOINDEX^PXRMERRH("TX",TAXARR("IEN"),70)
        S TLIST="GPLIST_PXRMRCPT"
        S RADPROC=""
        F  S RADPROC=$O(TAXARR(71,RADPROC)) Q:RADPROC=""  D
        . I '$D(^PXRMINDX(70,"IP",RADPROC)) Q
        . S DA=$O(TAXARR(71,RADPROC,""))
        . S ICPTP=$P(TAXARR(71,RADPROC,DA,0),U,1)
        . K ^TMP($J,TLIST)
        . D GPLIST^PXRMINDL(70,"IP",RADPROC,.PFINDPA,TLIST)
        . F TF=0,1 D
        .. S DFN=0
        .. F  S DFN=$O(^TMP($J,TLIST,TF,DFN)) Q:DFN=""  D
        ... S NFOUND=0
        ... F  S NFOUND=$O(^TMP($J,TLIST,TF,DFN,RADPROC,NFOUND)) Q:NFOUND=""  D
        .... S TEMP=^TMP($J,TLIST,TF,DFN,RADPROC,NFOUND,70)
        .... S DAS=$P(TEMP,U,1)
        .... S DATE=$P(TEMP,U,2)
        .... S VALUE=$P(TEMP,U,4)
        .... S ^TMP($J,PLIST,TF,DFN,DATE,70)=DAS_U_DATE_U_ICPTP_U_"CPT"_U_VALUE
        K ^TMP($J,TLIST)
        Q
        ;
        ;==============================================
MHVOUT(INDENT,OCCLIST,IFIEVAL,NLINES,TEXT)      ;Produce the MHV output.
        N CODE,CPT,CPTDATA,DATE,ICPTP,IND,JND,NAME,NOUT,SNAME,TEMP,TEXTOUT
        S NAME="Radiology Procedure = "
        S IND=0
        F  S IND=$O(OCCLIST(IND)) Q:IND=""  D
        . S DATE=IFIEVAL(IND,"DATE")
        . S ICPTP=IFIEVAL(IND,"CODEP")
        . S CPTDATA=$$CPT^ICPTCOD(ICPTP)
        . S CODE=$P(CPTDATA,U,2)
        . S SNAME=$P(CPTDATA,U,3)
        . S TEMP=" "_IFIEVAL(IND,"PROCEDURE")
        . S TEMP=NAME_SNAME_" ("_$$EDATE^PXRMDATE(DATE)_")"
        . D FORMATS^PXRMTEXT(INDENT+2,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        . F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
        ;==============================================
OUTPUT(INDENT,OCCLIST,IFIEVAL,NLINES,TEXT)      ;Produce the clinical
        ;maintenance output. The CPT information is:  DATE, ICPT CODE,
        ;SHORT NAME, PROVIDER NARRATIVE.
        N CODE,CPT,CPTDATA,DATE,ICPTP,IND,JND,NOUT,SNAME,TAXIEN,TEMP,TEXTOUT
        S TEMP=IFIEVAL("FINDING")
        S TAXIEN=$P(TEMP,";",1)
        S TEMP="Radiology Procedure(s) from taxonomy "_$P(^PXD(811.2,TAXIEN,0),U,1)
        S NLINES=NLINES+1
        S TEXT(NLINES)=$$INSCHR^PXRMEXLC(INDENT," ")_TEMP
        S IND=0
        F  S IND=$O(OCCLIST(IND)) Q:IND=""  D
        . S DATE=IFIEVAL(IND,"DATE")
        . S TEMP=$$EDATE^PXRMDATE(DATE)
        . S ICPTP=IFIEVAL(IND,"CODEP")
        . S CPTDATA=$$CPT^ICPTCOD(ICPTP)
        . S CODE=$P(CPTDATA,U,2)
        . S SNAME=$P(CPTDATA,U,3)
        . S TEMP=TEMP_" "_IFIEVAL(IND,"PROCEDURE")
        . S TEMP=TEMP_"-CPT: "_CODE_" "_SNAME
        . S TEMP=TEMP_" Status: "_IFIEVAL(IND,"STATUS")
        . S TEMP=TEMP_"; Report Status: "_IFIEVAL(IND,"RPT STATUS")
        . D FORMATS^PXRMTEXT(INDENT+2,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        . F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
