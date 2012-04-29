PXRMDRUG        ; SLC/PKR - Handle drug findings. ;01/25/2008
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;DBIA #5187 for PSSCLINR
        ;
        ;===============================================
DEVAL(DFN,FINDPA,DEFARR,FINDING,RXTYL,DRUG,POI,FIEVAL)  ;Evaluate a drug
        ;finding.
        I DRUG=0,POI=0 S FIEVAL=0 Q
        N DTERM,FIEVT
        ;Create the pseudo term.
        S DTERM(0)="DTERM",DTERM("IEN")=0
        I $D(RXTYL("I")),DRUG>0 D
        . M DTERM(20,1)=DEFARR(20,FINDING)
        . S $P(DTERM(20,1,0),U,1)=DRUG_";PS(55,"
        . S DTERM("E","PS(55,",DRUG,1)=""
        I $D(RXTYL("O")),DRUG>0 D
        . M DTERM(20,3)=DEFARR(20,FINDING)
        . S $P(DTERM(20,3,0),U,1)=DRUG_";PSRX("
        . S DTERM("E","PSRX(",DRUG,3)=""
        I $D(RXTYL("N")),POI>0 D
        . M DTERM(20,2)=DEFARR(20,FINDING)
        . S $P(DTERM(20,2,0),U,1)=POI_";PS(55NVA,"
        . S DTERM("E","PS(55NVA,",POI,2)=""
        K FIEVT
        D IEVALTER^PXRMTERM(DFN,.FINDPA,.DTERM,1,.FIEVT)
        M FIEVAL=FIEVT(1)
        I FIEVAL S FIEVAL("FINDING")=DRUG_";PSDRUG(",FIEVAL("DISPENSE DRUG")=DRUG
        Q
        ;
        ;===============================================
EVALFI(DFN,DEFARR,ENODE,FIEVAL) ;Evaluate drug findings.
        N DRUGIEN,DTERM,FIEVT,FINDPA,FINDING
        N NOINDEX,POI,RXTYL
        S NOINDEX=0
        I $G(^PXRMINDX(52,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("D",PXRMITEM,52)
        . S NOINDEX=1
        I $G(^PXRMINDX(55,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("D",PXRMITEM,55)
        . S NOINDEX=1
        S DRUGIEN=""
        F  S DRUGIEN=$O(DEFARR("E",ENODE,DRUGIEN)) Q:+DRUGIEN=0  D
        . S POI=$$ITEM^PSSCLINR(DRUGIEN)
        . S FINDING=""
        . F  S FINDING=$O(DEFARR("E",ENODE,DRUGIEN,FINDING)) Q:+FINDING=0  D
        .. I NOINDEX S FIEVAL(FINDING)=0 Q
        .. M FINDPA=DEFARR(20,FINDING)
        .. K FIEVT,RXTYL
        ..;Determine where we search.
        .. D SRXTYL^PXRMRXTY(FINDPA(0),.RXTYL)
        .. D DEVAL(DFN,.FINDPA,.DEFARR,FINDING,.RXTYL,DRUGIEN,POI,.FIEVT)
        .. M FIEVAL(FINDING)=FIEVT
        Q
        ;
        ;===============================================
EVALPL(FINDPA,ENODE,TERMARR,PLIST)      ;Evaluate drug terms for
        ;building patient lists.
        N BDT,EDT,DATE,DFN,DRUGIEN,ITEM,FILENUM,IND,LIST,NFOUND,NOCC,NOINDEX
        N PFINDPA,POI,RXTYL,TEMP,TF,TFINDPA,TFINDING,TGLIST,TLIST
        S NOINDEX=0
        I $G(^PXRMINDX(52,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),52)
        . S NOINDEX=1
        I $G(^PXRMINDX(55,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),55)
        . S NOINDEX=1
        I NOINDEX Q
        S TGLIST="EVALPL_PXRMDRUG"
        K ^TMP($J,TGLIST)
        S DRUGIEN=""
        F  S DRUGIEN=$O(TERMARR("E",ENODE,DRUGIEN)) Q:+DRUGIEN=0  D
        . S POI=$$ITEM^PSSCLINR(DRUGIEN)
        . S TFINDING=""
        . F  S TFINDING=$O(TERMARR("E",ENODE,DRUGIEN,TFINDING)) Q:+TFINDING=0  D
        .. K PFINDPA,TFINDPA
        .. M TFINDPA=TERMARR(20,TFINDING)
        ..;Set the finding parameters.
        .. D SPFINDPA^PXRMTERM(.FINDPA,.TFINDPA,.PFINDPA)
        ..;Determine where we search.
        .. D SRXTYL^PXRMRXTY(PFINDPA(0),.RXTYL)
        .. I $D(RXTYL("I")) D GPLIST^PXRMINDL(55,"IP",DRUGIEN,.PFINDPA,TGLIST)
        .. I $D(RXTYL("N")),POI'="" D GPLIST^PXRMINDL("55NVA","IP",POI,.PFINDPA,TGLIST)
        .. I $D(RXTYL("O")) D GPLIST^PXRMINDL(52,"IP",DRUGIEN,.PFINDPA,TGLIST)
        ;Return the NOCC most recent results for each DFN.
        S NOCC=$P(FINDPA(0),U,14)
        S NOCC=$S(NOCC<0:-NOCC,NOCC="":1,1:NOCC)
        F TF=0,1 D
        . S DFN=0
        . F  S DFN=$O(^TMP($J,TGLIST,TF,DFN)) Q:DFN=""  D
        .. K TLIST
        .. S ITEM=""
        .. F  S ITEM=$O(^TMP($J,TGLIST,TF,DFN,ITEM)) Q:ITEM=""  D
        ... S NFOUND=""
        ... F  S NFOUND=$O(^TMP($J,TGLIST,TF,DFN,ITEM,NFOUND)) Q:NFOUND=""  D
        .... S FILENUM=""
        .... F  S FILENUM=$O(^TMP($J,TGLIST,TF,DFN,ITEM,NFOUND,FILENUM)) Q:FILENUM=""  D
        ..... S TEMP=^TMP($J,TGLIST,TF,DFN,ITEM,NFOUND,FILENUM)
        ..... S DATE=+$P(TEMP,U,3)
        ..... S TLIST(TF,DATE,ITEM,NFOUND,FILENUM)=""
        .. S DATE="",NFOUND=0
        .. F  S DATE=$O(TLIST(TF,DATE),-1) Q:(DATE="")!(NFOUND=NOCC)  D
        ... S ITEM=""
        ... F  S ITEM=$O(TLIST(TF,DATE,ITEM)) Q:(ITEM="")!(NFOUND=NOCC)  D
        .... S IND=""
        .... F  S IND=$O(TLIST(TF,DATE,ITEM,IND)) Q:(IND="")!(NFOUND=NOCC)  D
        ..... S FILENUM=""
        ..... F  S FILENUM=$O(TLIST(TF,DATE,ITEM,IND,FILENUM)) Q:(FILENUM="")!(NFOUND=NOCC)  D
        ...... S NFOUND=NFOUND+1
        ...... S ^TMP($J,PLIST,TF,DFN,ITEM,NFOUND,FILENUM)=^TMP($J,TGLIST,TF,DFN,ITEM,IND,FILENUM)
        K ^TMP($J,TGLIST)
        Q
        ;
        ;===============================================
EVALTERM(DFN,FINDPA,ENODE,TERMARR,TFIEVAL)      ;Evaluate drug terms.
        N DATEORDR,DRUGIEN,DTERM,DTFIEVAL,IND,JND,NOINDEX,PFINDPA,POI
        N RXTYL,TEMP,TFINDING,TFINDPA
        N DATEORDR,NOCC,SDIR
        S NOINDEX=0
        I $G(^PXRMINDX(52,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),52)
        . S NOINDEX=1
        I $G(^PXRMINDX(55,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),55)
        . S NOINDEX=1
        ;Set NOCC and SDIR.
        S NOCC=$P(FINDPA(0),U,14)
        I NOCC="" S NOCC=1
        S SDIR=$S(NOCC<0:+1,1:-1)
        S NOCC=$S(NOCC<0:-NOCC,1:NOCC)
        S DRUGIEN=""
        F  S DRUGIEN=$O(TERMARR("E",ENODE,DRUGIEN)) Q:+DRUGIEN=0  D
        . S POI=$$ITEM^PSSCLINR(DRUGIEN)
        . S TFINDING=""
        . F  S TFINDING=$O(TERMARR("E",ENODE,DRUGIEN,TFINDING)) Q:+TFINDING=0  D
        .. S TFIEVAL(TFINDING)=0
        .. I NOINDEX Q
        .. K DTERM,DTFIEVAL,PFINDPA,TFINDPA
        .. S DTERM(0)="DTERM",DTERM("IEN")=0
        .. M TFINDPA=TERMARR(20,TFINDING)
        ..;Set the finding parameters.
        .. D SPFINDPA^PXRMTERM(.FINDPA,.TFINDPA,.PFINDPA)
        ..;Determine where we search.
        .. D SRXTYL^PXRMRXTY(PFINDPA(0),.RXTYL)
        .. I $D(RXTYL("I")) D
        ... M DTERM(20,1)=TERMARR(20,TFINDING)
        ... S $P(DTERM(20,1,0),U,1)=DRUGIEN_";PS(55,"
        ... S DTERM("E","PS(55,",DRUGIEN,1)=""
        .. I $D(RXTYL("N")),POI'="" D
        ... M DTERM(20,2)=TERMARR(20,TFINDING)
        ... S $P(DTERM(20,2,0),U,1)=POI_";PS(55NVA,"
        ... S DTERM("E","PS(55NVA,",POI,2)=""
        .. I $D(RXTYL("O")) D
        ... M DTERM(20,3)=TERMARR(20,TFINDING)
        ... S $P(DTERM(20,3,0),U,1)=DRUGIEN_";PSRX("
        ... S DTERM("E","PSRX(",DRUGIEN,3)=""
        .. D IEVALTER^PXRMTERM(DFN,.PFINDPA,.DTERM,TFINDING,.DTFIEVAL)
        .. D DORDER^PXRMTERM(.DTFIEVAL,.DATEORDR)
        .. D COPY^PXRMTERM(NOCC,SDIR,.DTFIEVAL,.DATEORDR,TFINDING,.TFIEVAL)
        ..;Save the dispense drug
        .. S JND=0
        .. F  S JND=+$O(TFIEVAL(TFINDING,JND)) Q:JND=0  S TFIEVAL(TFINDING,JND,"DISPENSE DRUG")=DRUGIEN
        Q
        ;
        ;===============================================
MHVOUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the MHV output.
        N DRUG,DRUGIEN,IND,FTYPE,NAME,PFIEVAL,TEMP
        S DRUGIEN=IFIEVAL("DISPENSE DRUG")
        S DRUG=$$DRUG^PSSCLINR(DRUGIEN)
        S NAME="Drug: "_DRUG_" = "
        S NLINES=NLINES+1
        S TEXT(NLINES)=$$INSCHR^PXRMEXLC(INDENT," ")_"Drug: "_DRUG
        S IND=0
        F  S IND=+$O(IFIEVAL(IND)) Q:IND=0  D
        . S TEMP=IFIEVAL(IND,"FINDING")
        . S FTYPE=$P(TEMP,";",2)
        . K PFIEVAL M PFIEVAL=IFIEVAL(IND)
        . S PFIEVAL("DISPENSE DRUG")=DRUG
        . I FTYPE="PS(55," D MHVOUT^PXRMDIN(INDENT+1,.PFIEVAL,.NLINES,.TEXT) Q
        . I FTYPE="PS(55NVA," D MHVOUT^PXRMDNVA(INDENT+1,.PFIEVAL,.NLINES,.TEXT) Q
        . I FTYPE="PSRX(" D MHVOUT^PXRMDOUT(INDENT+1,.PFIEVAL,.NLINES,.TEXT) Q
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
        ;===============================================
OUTPUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the clinical
        ;maintenance output.
        N DRUG,FTYPE,IND,PFIEVAL,TEMP,TEXTOUT
        S DRUG=$$DRUG^PSSCLINR(IFIEVAL("DISPENSE DRUG"))
        S NLINES=NLINES+1
        S TEXT(NLINES)=$$INSCHR^PXRMEXLC(INDENT," ")_"Drug: "_DRUG
        S IND=0
        F  S IND=+$O(IFIEVAL(IND)) Q:IND=0  D
        . S TEMP=IFIEVAL(IND,"FINDING")
        . S FTYPE=$P(TEMP,";",2)
        . K PFIEVAL M PFIEVAL=IFIEVAL(IND)
        . S PFIEVAL("DISPENSE DRUG")=DRUG
        . I FTYPE="PS(55," D OUTPUT^PXRMDIN(INDENT+1,.PFIEVAL,.NLINES,.TEXT) Q
        . I FTYPE="PS(55NVA," D OUTPUT^PXRMDNVA(INDENT+1,.PFIEVAL,.NLINES,.TEXT) Q
        . I FTYPE="PSRX(" D OUTPUT^PXRMDOUT(INDENT+1,.PFIEVAL,.NLINES,.TEXT) Q
        Q
        ;
