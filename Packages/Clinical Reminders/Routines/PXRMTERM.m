PXRMTERM        ; SLC/PKR - Handle reminder terms. ;05/07/2008
        ;;2.0;CLINICAL REMINDERS;**4,6,11**;Feb 04, 2005;Build 39
        ;
        ;=============================================
COPY(NOCC,SDIR,TFIEVAL,DATEORDR,FINDING,FIEVAL) ;Copy the NOCC date ordered
        ;findings from TFIEVAL to FIEVAL(FINDING).
        N DATE,IND,JND,MRS,NFOUND,TFI
        ;Start with most recent and go to oldest finding.
        S MRS=1
        S NFOUND=0
        S DATE=""
        F  S DATE=$O(DATEORDR(DATE),SDIR) Q:(NFOUND=NOCC)!(DATE="")  D
        . S TFI=0
        . F  S TFI=$O(DATEORDR(DATE,TFI)) Q:(NFOUND=NOCC)!(TFI="")  D
        .. I MRS D
        ...;Save the main result node.
        ... S FIEVAL(FINDING)=TFIEVAL(TFI)
        ... S MRS=0
        ... I 'FIEVAL(FINDING) Q
        ... S JND="@"
        ... F  S JND=$O(TFIEVAL(TFI,JND)) Q:JND=""  M FIEVAL(FINDING,JND)=TFIEVAL(TFI,JND)
        .. I 'FIEVAL(FINDING) Q
        .. S IND=0
        .. F  S IND=$O(DATEORDR(DATE,TFI,IND)) Q:(NFOUND=NOCC)!(IND="")  D
        ...;Only save true sub-results.
        ... I 'TFIEVAL(TFI,IND) Q
        ... S NFOUND=NFOUND+1
        ... M FIEVAL(FINDING,NFOUND)=TFIEVAL(TFI,IND)
        ... S FIEVAL(FINDING,NFOUND,"FILE NUMBER")=TFIEVAL(TFI,"FILE NUMBER")
        ... S FIEVAL(FINDING,NFOUND,"FINDING")=TFIEVAL(TFI,"FINDING")
        ... S JND=0
        ... F  S JND=$O(TFIEVAL(TFI,IND,JND)) Q:JND=""  M FIEVAL(FINDING,NFOUND,JND)=TFIEVAL(TFI,IND,JND)
        Q
        ;
        ;=============================================
DORDER(TFIEVAL,DATEORDR)        ;Order term findings by date, term finding,
        ;and term finding occurrence.
        N DATE,FI,IND
        K DATEORDR
        S FI=0
        F  S FI=+$O(TFIEVAL(FI)) Q:FI=0  D
        . S IND=0
        . F  S IND=+$O(TFIEVAL(FI,IND)) Q:IND=0  D
        .. S DATE=$G(TFIEVAL(FI,IND,"DATE"))
        .. I DATE'="" S DATEORDR(DATE,FI,IND)=""
        Q
        ;
        ;=============================================
EVALFI(DFN,DEFARR,ENODE,FIEVAL) ;Evaluate all reminder terms in a
        ;definition.
        N CASESEN,CONVAL,DATE,DATEORDR
        N FIEVT,FINDING,FINDPA,IND,NOCC
        N SDIR,TFIND3,TFIND4,TERMARR,TERMIEN,TFI,TFIEVAL,UCIFS
        S TERMIEN=""
        F  S TERMIEN=$O(DEFARR("E",ENODE,TERMIEN)) Q:+TERMIEN=0  D
        . I '$D(^PXRMD(811.5,TERMIEN,20,"E")) D  Q
        .. S ^TMP(PXRMPID,$J,PXRMITEM,"WARNING","NOFI",TERMIEN)="Warning no findings items in reminder term "_$P(^PXRMD(811.5,TERMIEN,0),U,1)
        .. S FINDING=""
        .. F  S FINDING=$O(DEFARR("E",ENODE,TERMIEN,FINDING)) Q:FINDING=""  S FIEVAL(FINDING)=0
        . D TERM^PXRMLDR(TERMIEN,.TERMARR)
        . S FINDING=""
        . F  S FINDING=$O(DEFARR("E",ENODE,TERMIEN,FINDING)) Q:+FINDING=0  D
        .. S FIEVAL(FINDING)=0
        .. S FIEVAL(FINDING,"TERM")=TERMARR(0)
        .. S FIEVAL(FINDING,"TERM IEN")=TERMIEN
        .. K FINDPA,TFIEVAL
        .. M FINDPA=DEFARR(20,FINDING)
        .. D EVALTERM(DFN,.FINDPA,.TERMARR,.TFIEVAL)
        .. I $G(PXRMTDEB) M ^TMP("PXRMTDEB",$J,FINDING)=TFIEVAL
        ..;Set NOCC and SDIR.
        .. S NOCC=$P(FINDPA(0),U,14)
        .. I NOCC="" S NOCC=1
        .. S SDIR=$S(NOCC<0:+1,1:-1)
        .. S NOCC=$S(NOCC<0:-NOCC,1:NOCC)
        ..;Order the term findings by date.
        .. D DORDER(.TFIEVAL,.DATEORDR)
        .. D COPY(NOCC,SDIR,.TFIEVAL,.DATEORDR,FINDING,.FIEVAL)
        Q
        ;
        ;=============================================
EVALTERM(DFN,FINDPA,TERMARR,TFIEVAL)    ;Evaluate all the findings in
        ;a term. Use the "E" cross-reference just like the finding evaluation.
        N ENODE
        S ENODE=""
        F  S ENODE=$O(TERMARR("E",ENODE)) Q:ENODE=""  D
        . I ENODE="AUTTEDT(" D EVALTERM^PXRMEDU(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="AUTTEXAM(" D EVALTERM^PXRMEXAM(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="AUTTHF(" D EVALTERM^PXRMHF(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="AUTTIMM(" D EVALTERM^PXRMIMM(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="AUTTSK(" D EVALTERM^PXRMSKIN(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="GMRD(120.51," D EVALTERM^PXRMVITL(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="LAB(60," D EVALTERM^PXRMLAB(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="ORD(101.43," D EVALTERM^PXRMORDR(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="PXD(811.2," D EVALTERM^PXRMTAX(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="PXRMD(810.9," D EVALTERM^PXRMLOCF(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="PXRMD(811.4," D EVALTERM^PXRMCF(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="PS(50.605," D EVALTERM^PXRMDRCL(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="PS(55," D EVALTERM^PXRMDIN(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="PS(55NVA," D EVALTERM^PXRMDNVA(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="PSDRUG(" D EVALTERM^PXRMDRUG(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="PSRX(" D EVALTERM^PXRMDOUT(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="PSNDF(50.6," D EVALTERM^PXRMDGEN(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="RAMIS(71," D EVALTERM^PXRMRAD(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        . I ENODE="YTT(601.71," D EVALTERM^PXRMMH(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL) Q
        Q
        ;
        ;=============================================
IEVALTER(DFN,FINDPA,TERMARR,FINDING,FIEVAL)     ;Evaluate an individual term
        ;put the result in FIEVAL(FINDING).
        N DATEORDR,NOCC,SDIR,TFIEVAL
        I $D(PXRMPDEM) G DEMOK
        N PXRMPDEM D DEM^PXRMPINF(DFN,DT,.PXRMPDEM)
        ;Create the local demographic variables for use in Condition.
        N PXRMAGE,PXRMDOB,PXRMDOD,PXRMLAD,PXRMSEX
        S PXRMAGE=PXRMPDEM("AGE"),PXRMDOB=PXRMPDEM("DOB"),PXRMDOD=PXRMPDEM("DOD")
        S PXRMLAD=PXRMPDEM("LAD"),PXRMSEX=PXRMPDEM("SEX")
DEMOK   S FIEVAL(FINDING)=0
        D EVALTERM(DFN,.FINDPA,.TERMARR,.TFIEVAL)
        ;Set NOCC and SDIR.
        S NOCC=$P(FINDPA(0),U,14)
        I NOCC="" S NOCC=1
        S SDIR=$S(NOCC<0:+1,1:-1)
        S NOCC=$S(NOCC<0:-NOCC,1:NOCC)
        ;Order the term findings by date.
        D DORDER(.TFIEVAL,.DATEORDR)
        D COPY(NOCC,SDIR,.TFIEVAL,.DATEORDR,FINDING,.FIEVAL)
        K ^TMP($J,"SVC",DFN)
        Q
        ;
        ;=============================================
MHVOUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the MHV output.
        D OPT(INDENT,.IFIEVAL,.NLINES,.TEXT,"MHV")
        Q
        ;
        ;=============================================
OUTPUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the clinical
        ;maintenance output.
        D OPT(INDENT,.IFIEVAL,.NLINES,.TEXT,"CM")
        Q
        ;
        ;=============================================
OPT(INDENT,IFIEVAL,NLINES,TEXT,TYPE)    ;General output.
        N DG,DGL,DGN,IEN,IND,JND,KND,INDENTT,FILENUM,TEMP,TIFIEVAL
        ;Build the display grouping.
        S FILENUM=IFIEVAL(1,"FILE NUMBER")
        S IEN=$P(IFIEVAL(1,"FINDING"),";",1)
        S DG(FILENUM,IEN)=1,DGL(1)=FILENUM_U_IEN,DGL(1,1)=""
        S (DGN,IND)=1
        F  S IND=+$O(IFIEVAL(IND)) Q:IND=0  D
        . S FILENUM=IFIEVAL(IND,"FILE NUMBER")
        . S IEN=$P(IFIEVAL(IND,"FINDING"),";",1)
        . I '$D(DG(FILENUM,IEN)) D
        .. S DGN=DGN+1,DG(FILENUM,IEN)=DGN
        .. S DGL(DGN)=FILENUM_U_IEN,DGL(DGN,IND)=""
        . I $D(DG(FILENUM,IEN)) D
        .. S TEMP=DG(FILENUM,IEN),DGL(TEMP,IND)=""
        S INDENTT=INDENT+1
        S TEMP=$$INSCHR^PXRMEXLC(INDENT," ")_"Reminder Term: "_$P(FIEVAL(FINDING,"TERM"),U,1)
        S NLINES=NLINES+1,TEXT(NLINES)=TEMP
        F IND=1:1:DGN D
        . K TIFIEVAL
        . S (JND,KND)=0
        . F  S JND=$O(DGL(IND,JND)) Q:JND=""  D
        .. S KND=KND+1
        .. I KND=1 M TIFIEVAL=IFIEVAL(JND)
        .. M TIFIEVAL(KND)=IFIEVAL(JND)
        . I TYPE="CM" D FOUT^PXRMOUTC(INDENTT,.TIFIEVAL,.NLINES,.TEXT)
        . I TYPE="MHV" D FOUT^PXRMOUTM(INDENTT,.TIFIEVAL,.NLINES,.TEXT)
        Q
        ;
        ;=============================================
SPFINDPA(FINDPA,TFINDPA,PFINDPA)        ;Set the finding parameter array
        ;for terms.
        N FIND0,PIECE,PFIND0,TFIND0,VAL
        S FIND0=$G(FINDPA(0))
        S (PFIND0,TFIND0)=TFINDPA(0)
        ;Set the 0 node.
        F PIECE=9,10,12,13,14,15,16 D
        . S VAL=$P(TFIND0,U,PIECE)
        . I VAL="" S VAL=$P(FIND0,U,PIECE)
        . S $P(PFIND0,U,PIECE)=VAL
        ;BDT and EDT are treated as a pair.
        I $P(TFIND0,U,8)="",$P(TFIND0,U,11)="" F PIECE=8,11 S $P(PFIND0,U,PIECE)=$P(FIND0,U,PIECE)
        E  F PIECE=8,11 S $P(PFIND0,U,PIECE)=$P(TFIND0,U,PIECE)
        S PFINDPA(0)=PFIND0
        I $P($G(TFINDPA(3)),U,1)'="" S PFINDPA(3)=TFINDPA(3),PFINDPA(10)=TFINDPA(10),PFINDPA(11)=TFINDPA(11)
        E  S PFINDPA(3)=$G(FINDPA(3)),PFINDPA(10)=$G(FINDPA(10)),PFINDPA(11)=$G(FINDPA(11))
        ;Get the status list.
        I $D(TFINDPA(5)) M PFINDPA(5)=TFINDPA(5)
        E  M PFINDPA(5)=FINDPA(5)
        I $D(TFINDPA(15)) S PFINDPA(15)=TFINDPA(15)
        E  S PFINDPA(15)=$G(FINDPA(15))
        Q
        ;
