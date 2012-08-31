PXRMDOUT        ; SLC/PKR - Handle outpatient med findings. ;12/15/2008
        ;;2.0;CLINICAL REMINDERS;**4,12**;Feb 04, 2005;Build 73
        ;DBIA #5187 for PSSCLINR
        ;
        ;===============================================
GETDATA(DAS,FIEVT)      ;Return data for an outpatient drug finding.
        ;DBIA #3793
        D PSRX^PSOPXRM1(DAS,.FIEVT)
        ;DBIA #5188
        S (FIEVT("STATUS"),FIEVT("VALUE"))=$$STAT^PSO52CLR(FIEVT("STATUS"))
        S FIEVT("START DATE")=FIEVT("RELEASED DATE/TIME")
        S FIEVT("STOP DATE")=$$FMADD^XLFDT(FIEVT("START DATE"),FIEVT("DAYS SUPPLY"))
        S FIEVT("DURATION")=$$DURATION^PXRMDATE(FIEVT("START DATE"),FIEVT("STOP DATE"))
        Q
        ;
        ;===============================================
EVALTERM(DFN,FINDPA,ENODE,TERMARR,TFIEVAL)      ;Evaluate terms.
        D EVALTERM^PXRMINDX(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL)
        Q
        ;
        ;===============================================
MHVOUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the MHV output.
        N DRUG,JND,NOUT,TEMP,TEXTOUT
        S DRUG=IFIEVAL("DISPENSE DRUG")
        ;DBIA #5187
        S DRUG=$S(+DRUG=0:DRUG,1:$$DRUG^PSSCLINR(DRUG))
        S TEMP="Outpatient Drug: "_DRUG_" = "
        S TEMP=TEMP_"("_$$EDATE^PXRMDATE(IFIEVAL("START DATE"))
        S TEMP=TEMP_" - "_$$EDATE^PXRMDATE(IFIEVAL("STOP DATE"))_")"
        D FORMATS^PXRMTEXT(INDENT+2,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        Q
        ;
        ;===============================================
OUTPUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the clinical
        ;maintenance output.
        N DRUG,JND,NOUT,TEMP,TEXTOUT
        S DRUG=IFIEVAL("DISPENSE DRUG")
        S DRUG=$S(+DRUG=0:DRUG,1:$$DRUG^PSSCLINR(DRUG))
        S NLINES=NLINES+1
        S TEXT(NLINES)=$$INSCHR^PXRMEXLC(INDENT," ")_"Outpatient Medication: "_DRUG
        S TEMP=$$EDATE^PXRMDATE(IFIEVAL("DATE"))
        S TEMP=TEMP_" Status: "_IFIEVAL("STATUS")
        S TEMP=TEMP_" Last release date: "_$$EDATE^PXRMDATE(IFIEVAL("RELEASED DATE/TIME"))
        S TEMP=TEMP_" Days supply: "_IFIEVAL("DAYS SUPPLY")
        S TEMP=TEMP_" Start date: "_$$EDATE^PXRMDATE(IFIEVAL("START DATE"))
        S TEMP=TEMP_" Stop date: "_$$EDATE^PXRMDATE(IFIEVAL("STOP DATE"))
        I $D(IFIEVAL("DURATION")) S TEMP=TEMP_"  Duration: "_IFIEVAL("DURATION")_" D"
        D FORMATS^PXRMTEXT(INDENT+2,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
