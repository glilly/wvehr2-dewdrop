PXRMDRGR        ; SLC/PKR - Handle groups of drug findings. ;01/25/2008
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;Groups are drug classes or VA Generic.
        ;==================================================
EVALFI(DFN,DEFARR,ENODE,XREF,FIEVAL)    ;Evaluate drug group findings.
        N DRGRIEN,FIEVT,FINDPA,FINDING,NOINDEX
        S NOINDEX=0
        I $G(^PXRMINDX(52,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("D",PXRMITEM,52)
        . S NOINDEX=1
        I $G(^PXRMINDX(55,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("D",PXRMITEM,55)
        . S NOINDEX=1
        S DRGRIEN=""
        F  S DRGRIEN=$O(DEFARR("E",ENODE,DRGRIEN)) Q:+DRGRIEN=0  D
        . S FINDING=""
        . F  S FINDING=$O(DEFARR("E",ENODE,DRGRIEN,FINDING)) Q:+FINDING=0  D
        .. I NOINDEX S FIEVAL(FINDING)=0 Q
        .. K FIEVT,FINDPA
        .. M FINDPA=DEFARR(20,FINDING)
        .. D FIEVAL(DFN,DRGRIEN,.FINDPA,.DEFARR,FINDING,XREF,.FIEVT)
        .. M FIEVAL(FINDING)=FIEVT
        .. S FIEVAL(FINDING,"FINDING")=$P(FINDPA(0),U,1)
        Q
        ;
        ;==================================================
EVALPL(FINDPA,ENODE,XREF,TERMARR,PLIST) ;Evaluate drug group
        ;terms for building patient lists.
        N DRGRIEN,NOINDEX,PFINDPA
        N TEMP,TFINDPA,TFINDING
        S NOINDEX=0
        I $G(^PXRMINDX(52,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),52)
        . S NOINDEX=1
        I $G(^PXRMINDX(55,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),55)
        . S NOINDEX=1
        I NOINDEX Q
        S DRGRIEN=""
        F  S DRGRIEN=$O(TERMARR("E",ENODE,DRGRIEN)) Q:+DRGRIEN=0  D
        . S TFINDING=""
        . F  S TFINDING=$O(TERMARR("E",ENODE,DRGRIEN,TFINDING)) Q:+TFINDING=0  D
        .. K PFINDPA,TFINDPA
        .. M TFINDPA=TERMARR(20,TFINDING)
        ..;Set the finding parameters.
        .. D SPFINDPA^PXRMTERM(.FINDPA,.TFINDPA,.PFINDPA)
        .. D GPLIST(DRGRIEN,.PFINDPA,XREF,.PLIST)
        Q
        ;
        ;==================================================
EVALTERM(DFN,FINDPA,ENODE,XREF,TERMARR,TFIEVAL) ;Evaluate drug
        ;group terms.
        N DRGRIEN,FIEVT,NOINDEX,PFINDPA
        N TEMP,TFINDPA,TFINDING
        S NOINDEX=0
        I $G(^PXRMINDX(52,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),52)
        . S NOINDEX=1
        I $G(^PXRMINDX(55,"DATE BUILT"))="" D
        . D NOINDEX^PXRMERRH("TR",TERMARR("IEN"),55)
        . S NOINDEX=1
        S DRGRIEN=""
        F  S DRGRIEN=$O(TERMARR("E",ENODE,DRGRIEN)) Q:+DRGRIEN=0  D
        . S TFINDING=""
        . F  S TFINDING=$O(TERMARR("E",ENODE,DRGRIEN,TFINDING)) Q:+TFINDING=0  D
        .. I NOINDEX S TFIEVAL(TFINDING)=0 Q
        .. K FIEVT,PFINDPA,TFINDPA
        .. M TFINDPA=TERMARR(20,TFINDING)
        ..;Set the finding parameters.
        .. D SPFINDPA^PXRMTERM(.FINDPA,.TFINDPA,.PFINDPA)
        .. D FIEVAL(DFN,DRGRIEN,.PFINDPA,.TERMARR,TFINDING,XREF,.FIEVT)
        .. M TFIEVAL(TFINDING)=FIEVT
        .. S TFIEVAL(TFINDING,"FINDING")=$P(TFINDPA(0),U,1)
        Q
        ;
        ;==================================================
FIEVAL(DFN,DRGRIEN,FINDPA,DEFARR,FINDING,XREF,FIEVAL)   ;
        ;Calls to PSSCLINR covered by DBIA #5187
        N DATE,DATEORDR,DRBEG,DREND,DRUG,DRUGIEN,IND,FIEVT,FIEVTL
        N NOCC,NFOUND,POI,POIBEG,POIEND,POIIEN,RXTYL
        N SDIR,TDATE,TIND
        S NOCC=$P(FINDPA(0),U,14)
        I NOCC="" S NOCC=1
        S SDIR=$S(NOCC<0:+1,1:-1)
        S NOCC=$S(NOCC<0:-NOCC,1:NOCC)
        ;Determine where we search.
        D SRXTYL^PXRMRXTY(FINDPA(0),.RXTYL)
        D GETPDR(DFN,.RXTYL,.DRBEG,.DREND,.POIBEG,.POIEND)
        I DREND=0,POIEND=0 S FIEVAL=0 Q
        D IX^PSSCLINR(XREF,DRGRIEN)
        S (DRUGIEN,NFOUND)=0
        F  S DRUGIEN=+$O(^TMP($J,XREF,DRGRIEN,DRUGIEN)) Q:DRUGIEN=0  D
        . I DRUGIEN'<DRBEG,DRUGIEN'>DREND S DRUG=DRUGIEN
        . E  S DRUG=0
        . S POIIEN=$$ITEM^PSSCLINR(DRUGIEN)
        . I POIIEN'<POIBEG,POIIEN'>POIEND S POI=POIIEN
        . E  S POI=0
        . K FIEVT
        . D DEVAL^PXRMDRUG(DFN,.FINDPA,.DEFARR,FINDING,.RXTYL,DRUG,POI,.FIEVT)
        . I FIEVT D
        .. S IND=0
        .. F  S IND=+$O(FIEVT(IND)) Q:IND=0  D
        ...;Make sure this is not already on the list
        ... I $$ONLIST(.FIEVTL,IND,.FIEVT) Q
        ... S NFOUND=NFOUND+1,FIEVTL(NFOUND,"DISPENSE DRUG")=DRUGIEN
        ... M FIEVTL(NFOUND)=FIEVT(IND)
        ... S DATEORDR(FIEVT(IND,"DATE"),NFOUND)=FIEVT(IND,"FINDING")
        ...;Don't keep more than NOCC occurrences on the list.
        ... I NFOUND>NOCC D
        .... S TDATE=$O(DATEORDR(""),-SDIR),TIND=$O(DATEORDR(TDATE,""))
        .... K FIEVTL(TIND),DATEORDR(TDATE,TIND)
        I NFOUND=0 S FIEVAL=0 Q
        ;Order by date.
        S DATE="",NFOUND=0
        F  S DATE=$O(DATEORDR(DATE),SDIR)  Q:(DATE="")!(NFOUND=NOCC)  D
        . S IND=0
        . F  S IND=$O(DATEORDR(DATE,IND)) Q:(IND="")!(NFOUND=NOCC)  D
        .. S NFOUND=NFOUND+1
        .. M FIEVAL(NFOUND)=FIEVTL(IND)
        ;Save the finding result.
        D SFRES^PXRMUTIL(SDIR,NFOUND,.FIEVAL)
        K ^TMP($J,XREF)
        Q
        ;
        ;==================================================
GETPDR(DFN,RXTYL,DRBEG,DREND,POIBEG,POIEND)     ;Return the beginning drug and
        ;ending drug for a patient.
        N IBEG,IEND,OBEG,OEND
        I $D(RXTYL("I")) D
        . S IBEG=+$O(^PXRMINDX(55,"PI",DFN,0))
        . S IEND=+$O(^PXRMINDX(55,"PI",DFN,""),-1)
        E  S (IBEG,IEND)=0
        I $D(RXTYL("O")) D
        . S OBEG=+$O(^PXRMINDX(52,"PI",DFN,0))
        . S OEND=+$O(^PXRMINDX(52,"PI",DFN,""),-1)
        E  S (OBEG,OEND)=0
        S DRBEG=$S(IBEG<OBEG:IBEG,1:OBEG)
        S DREND=$S(IEND>OEND:IEND,1:OEND)
        I $D(RXTYL("N")) D
        . S POIBEG=+$O(^PXRMINDX("55NVA","PI",DFN,0))
        . S POIEND=+$O(^PXRMINDX("55NVA","PI",DFN,""),-1)
        E  S (POIBEG,POIEND)=0
        Q
        ;
        ;==================================================
GPLIST(DRGRIEN,PFINDPA,XREF,PLIST)      ;
        ;Calls to PSSCLINR covered by DBIA #5187
        N DATE,DFN,DRUGIEN,FILENUM,IND,ITEM,NFOUND,NOCC,POI,RXTYL
        N TF,TEMP,TGLIST,TLIST
        S TGLIST="GPLIST_PXRMDRGR"
        K ^TMP($J,TGLIST)
        ;Determine where we search.
        D SRXTYL^PXRMRXTY(PFINDPA(0),.RXTYL)
        D IX^PSSCLINR(XREF,DRGRIEN)
        S DRUGIEN=0
        F  S DRUGIEN=+$O(^TMP($J,XREF,DRGRIEN,DRUGIEN)) Q:DRUGIEN=0  D
        . S POI=$$ITEM^PSSCLINR(DRUGIEN)
        . I $D(RXTYL("I")) D GPLIST^PXRMINDL(55,"IP",DRUGIEN,.PFINDPA,TGLIST)
        . I $D(RXTYL("N")),POI'="" D GPLIST^PXRMINDL("55NVA","IP",POI,.PFINDPA,TGLIST)
        . I $D(RXTYL("O")) D GPLIST^PXRMINDL(52,"IP",DRUGIEN,.PFINDPA,TGLIST)
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
        K ^TMP($J,TGLIST),^TMP($J,XREF)
        Q
        ;
        ;==================================================
ONLIST(FIEVTL,IND,FIEVT)        ;Return true if FIEVT(IND) is already on
        ;FIEVTL.
        N JND,ONLIST
        S (JND,ONLIST)=0
        F  S JND=$O(FIEVTL(JND)) Q:(ONLIST)!(JND="")  D
        . I FIEVTL(JND,"FILE NUMBER")'=FIEVT(IND,"FILE NUMBER") Q
        . I FIEVTL(JND,"DAS")'=FIEVT(IND,"DAS") Q
        . S ONLIST=1
        Q ONLIST
        ;
