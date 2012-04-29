PXRMFF  ;SLC/PKR - Clinical Reminders function finding evaluation. ;03/17/2008
        ;;2.0;CLINICAL REMINDERS;**4,6,11**;Feb 04, 2005;Build 39
        ;===========================================
EVAL(DFN,DEFARR,FIEVAL) ;Evaluate function findings.
        N FFIND,FFN,FILIST,FN,FUN,FUNIND,FUNN,FVALUE,JND
        N LOGIC,NL,ROUTINE,TEMP
        I '$D(DEFARR(25)) Q
        S FFN="FF"
        F  S FFN=$O(DEFARR(25,FFN)) Q:FFN'["FF"  D
        . K FN
        . S FUNIND=0
        . F  S FUNIND=+$O(DEFARR(25,FFN,5,FUNIND)) Q:FUNIND=0  D
        .. S FUNN=$P(DEFARR(25,FFN,5,FUNIND,0),U,1)
        .. S FUN=$P(DEFARR(25,FFN,5,FUNIND,0),U,2)
        .. S TEMP=^PXRMD(802.4,FUN,0)
        .. S ROUTINE=$P(TEMP,U,2,3)_"(.FILIST,.FIEVAL,.FVALUE)"
        .. K FILIST
        .. S (JND,NL)=0
        .. F  S JND=+$O(DEFARR(25,FFN,5,FUNIND,20,JND)) Q:JND=0  D
        ... S NL=NL+1
        ... S FILIST(NL)=DEFARR(25,FFN,5,FUNIND,20,JND,0)
        .. S FILIST(0)=NL
        .. D @ROUTINE
        .. S FN(FUNIND)=FVALUE
        . S LOGIC=$G(DEFARR(25,FFN,10))
        . S LOGIC=$S(LOGIC'="":LOGIC,1:0)
        . I @LOGIC
        . S FIEVAL(FFN)=$T
        . S FIEVAL(FFN,"NUMBER")=$P(FFN,"FF",2)
        . S FIEVAL(FFN,"FINDING")=$G(FUN)_";PXRMD(802.4,"
        . I $G(PXRMDEBG) D
        .. N IND,FSTRING
        .. S IND="",FSTRING=DEFARR(25,FFN,10)
        .. I $D(PXRMAGE) S FSTRING=$$STRREP^PXRMUTIL(FSTRING,"PXRMAGE",PXRMAGE)
        .. I $D(PXRMDOB) S FSTRING=$$STRREP^PXRMUTIL(FSTRING,"PXRMDOB",PXRMDOB)
        .. I $D(PXRMDOD) S FSTRING=$$STRREP^PXRMUTIL(FSTRING,"PXRMDOD",PXRMDOD)
        .. I $D(PXRMLAD) S FSTRING=$$STRREP^PXRMUTIL(FSTRING,"PXRMLAD",PXRMLAD)
        .. I $D(PXRMSEX) S FSTRING=$$STRREP^PXRMUTIL(FSTRING,"PXRMSEX",PXRMSEX)
        .. F  S IND=$O(FN(IND)) Q:IND=""  S FSTRING=$$STRREP^PXRMUTIL(FSTRING,"FN("_IND_")",FN(IND))
        .. S ^TMP("PXRMFFDEB",$J,FFN,"DETAIL")=FIEVAL(FFN)_U_DEFARR(25,FFN,3)_U_FSTRING
        Q
        ;
        ;===========================================
EVALPL(DEFARR,FFIND,PLIST)      ;Build a list of patients based on a function
        ;finding.
        N COUNT,DAS,DATE,DFN
        N FI,FIEVAL,FIEVT,FIL,FILIST,FILENUM,FINDPA,FN
        N FUN,FUNNM,FUNN,FUNNUM,FVALUE
        N IND,ITEM,JND,LOGIC,LNAME,NFI,NFUN,ROUTINE,TEMP,TERMARR,UNIQFIL
        S LOGIC=DEFARR(25,FFIND,10)
        I LOGIC="" Q
        ;Build the list of functions and findings used by the function finding.
        S (FUNNUM,NFUN)=0
        F  S FUNNUM=+$O(DEFARR(25,FFIND,5,FUNNUM)) Q:FUNNUM=0  D
        . S NFUN=NFUN+1
        . S FUNN=$P(DEFARR(25,FFIND,5,FUNNUM,0),U,1)
        . S FUN=$P(DEFARR(25,FFIND,5,FUNNUM,0),U,2)
        . S TEMP=^PXRMD(802.4,FUN,0)
        . S ROUTINE(NFUN)=$P(TEMP,U,2,3)_"(.FIL,.FIEVAL,.FVALUE)"
        . S (FI,NFI)=0
        . F  S FI=+$O(DEFARR(25,FFIND,5,FUNNUM,20,FI)) Q:FI=0  D
        .. S NFI=NFI+1,FILIST(NFUN,NFI)=DEFARR(25,FFIND,5,FUNNUM,20,FI,0)
        . S FILIST(NFUN,0)=NFI
        ;A finding may be used in more than one function in the function
        ;finding so build a list of the unique findings.
        F IND=1:1:NFUN D
        . F JND=1:1:FILIST(IND,0) D
        .. S TEMP=$P(DEFARR(20,FILIST(IND,JND),0),U,1)
        .. S ITEM=$P(TEMP,";",1)
        .. S FILENUM=$$GETFNUM^PXRMDATA($P(TEMP,";",2))
        .. S UNIQFIL(FILIST(IND,JND))=""
        K ^TMP($J,"PXRMFFDFN")
        S IND=0
        F  S IND=$O(UNIQFIL(IND)) Q:IND=""  D
        . S FINDPA(0)=DEFARR(20,IND,0)
        . S FINDPA(3)=DEFARR(20,IND,3)
        . S FINDPA(10)=DEFARR(20,IND,10)
        . S FINDPA(11)=DEFARR(20,IND,11)
        . D GENTERM^PXRMPLST(FINDPA(0),IND,.TERMARR)
        . S LNAME(IND)="PXRMFF"_IND
        . K ^TMP($J,LNAME(IND))
        . D EVALPL^PXRMTERL(.FINDPA,.TERMARR,LNAME(IND))
        .;Get rid of the false part of the list.
        . K ^TMP($J,LNAME(IND),0)
        .;Build a complete list of patients.
        . S DFN=0
        . F  S DFN=$O(^TMP($J,LNAME(IND),1,DFN)) Q:DFN=""  S ^TMP($J,"PXRMFFDFN",DFN)=""
        ;Evaluate the function finding for each patient. If the function
        ;finding is true then add the patient to PLIST.
        S DFN=0
        F  S DFN=$O(^TMP($J,"PXRMFFDFN",DFN)) Q:DFN=""  D
        . K FIEVAL
        . S IND=""
        . F  S IND=$O(UNIQFIL(IND)) Q:IND=""  D
        .. S FIEVAL(IND)=0
        .. S ITEM=""
        .. F  S ITEM=$O(^TMP($J,LNAME(IND),1,DFN,ITEM)) Q:ITEM=""  D
        ... S COUNT=0
        ... F  S COUNT=$O(^TMP($J,LNAME(IND),1,DFN,ITEM,COUNT)) Q:COUNT=""  D
        .... S FILENUM=$O(^TMP($J,LNAME(IND),1,DFN,ITEM,COUNT,""))
        .... S TEMP=^TMP($J,LNAME(IND),1,DFN,ITEM,COUNT,FILENUM)
        .... S DAS=$P(TEMP,U,1)
        .... S DATE=$P(TEMP,U,2)
        .... K FIEVT
        .... D GETDATA^PXRMDATA(FILENUM,DAS,.FIEVT)
        .... M FIEVAL(IND,COUNT)=FIEVT
        .... S FIEVAL(IND,COUNT,"DATE")=DATE,FIEVAL(IND,COUNT)=1
        .;Save the top level results for each finding.
        . S IND=0
        . F  S IND=$O(FIEVAL(IND)) Q:IND=""  D
        .. K FIEVT M FIEVT=FIEVAL(IND)
        .. S NFI=+$O(FIEVT(""),-1)
        .. D SFRES^PXRMUTIL(-1,NFI,.FIEVT)
        .. K FIEVAL(IND) M FIEVAL(IND)=FIEVT
        .;Evaluate the function finding for this patient.
        . K FN
        . F IND=1:1:NFUN D
        .. K FIL M FIL=FILIST(IND)
        .. D @ROUTINE(IND)
        .. S FN(IND)=FVALUE
        . I @LOGIC S ^TMP($J,PLIST,1,DFN,1,FFIND)=""
        ;Clean up.
        K ^TMP($J,"PXRMFFDFN")
        S IND=""
        F  S IND=$O(UNIQFIL(IND)) Q:IND=""  K ^TMP($J,LNAME(IND))
        Q
        ;
        ;===========================================
MHVOUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the MHV output.
        ;None currently defined.
        Q
        ;
        ;===========================================
OUTPUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the clinical
        ;maintenance output. None currently defined.
        Q
        ;
