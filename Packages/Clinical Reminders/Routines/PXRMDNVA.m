PXRMDNVA        ; SLC/PKR - Handle non-VA med findings. ;02/10/2010
        ;;2.0;CLINICAL REMINDERS;**4,6,17**;Feb 04, 2005;Build 102
        ;
        ;===============================================
GETDATA(DAS,FIEVT)      ;Return data for an non-VA med finding.
        ;DBIA #3793
        D NVA^PSOPXRM1(DAS,.FIEVT)
        S FIEVT("VALUE")=FIEVT("STATUS")
        I $G(FIEVT("START DATE"))="" S FIEVT("START DATE")=FIEVT("DOCUMENTED DATE")
        S FIEVT("DURATION")=$$DURATION^PXRMDATE(FIEVT("START DATE"),FIEVT("DISCONTINUED DATE"))
        Q
        ;
        ;===============================================
EVALTERM(DFN,FINDPA,ENODE,TERMARR,TFIEVAL)      ;Evaluate terms.
        D EVALTERM^PXRMINDX(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL)
        Q
        ;
        ;====================================================
MHVOUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the MHV output.
        N DATE,JND,NOUT,TEMP,TEXTOUT
        S TEMP="Non-VA med: "_IFIEVAL("ORDERABLE ITEM")_" = "
        S TEMP=TEMP_"("_$$EDATE^PXRMDATE(IFIEVAL("START DATE"))
        S DATE=IFIEVAL("DISCONTINUED DATE")
        S DATE=$S(DATE="":"NONE",1:$$EDATE^PXRMDATE(DATE))
        S TEMP=TEMP_" - "_DATE_")"
        D FORMATS^PXRMTEXT(INDENT+1,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        Q
        ;
        ;===============================================
OUTPUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the clinical
        ;maintenance output.
        N DATE,JND,NOUT,TEMP,TEXTOUT
        S NLINES=NLINES+1
        S TEXT(NLINES)=$$INSCHR^PXRMEXLC(INDENT," ")_"Non-VA med: "_IFIEVAL("ORDERABLE ITEM")
        S DATE=IFIEVAL("DATE")
        S TEMP=$$EDATE^PXRMDATE(DATE)_" Status: "_IFIEVAL("STATUS")_"\\"
        S TEMP=TEMP_"Start Date: "_$$EDATE^PXRMDATE(DATE)
        S DATE=IFIEVAL("DISCONTINUED DATE")
        S DATE=$S(DATE="":"NONE",1:$$EDATE^PXRMDATE(DATE))
        S TEMP=TEMP_" Discontinued Date: "_DATE
        I $D(IFIEVAL("DURATION")) S TEMP=TEMP_"  Duration: "_IFIEVAL("DURATION")_" D"_"\\"
        S TEMP=TEMP_"Dosage Form: "_IFIEVAL("DOSAGE FORM")
        S TEMP=TEMP_" Dosage: "_IFIEVAL("DOSAGE")
        S TEMP=TEMP_" Medication Route: "_IFIEVAL("MEDICATION ROUTE")
        D FORMATS^PXRMTEXT(INDENT+1,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
