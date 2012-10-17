PXRMDIN ; SLC/PKR - Handle inpatient med findings. ;01/25/2008
        ;;2.0;CLINICAL REMINDERS;**4,12**;Feb 04, 2005;Build 73
        ;DBIA #5187 for PSSCLINR
        ;
        ;===============================================
GETDATA(DAS,FIEVT)      ;Return data for an inpatient drug finding.
        ;DBIA #3836
        D OEL^PSJPXRM1(DAS,.FIEVT)
        S (FIEVT("STATUS"),FIEVT("VALUE"))=FIEVT("STAT") K FIEVT("STAT")
        S FIEVT("START DATE")=FIEVT("START") K FIEVT("START")
        S FIEVT("STOP DATE")=FIEVT("STOP") K FIEVT("STOP")
        S FIEVT("DURATION")=$$DURATION^PXRMDATE(FIEVT("START DATE"),FIEVT("STOP DATE"))
        Q
        ;
        ;===============================================
GETFNAME(DRUG,FIEVT)    ;Return the name of the drug.
        Q $S(+DRUG=0:DRUG,1:$$DRUG^PSSCLINR(DRUG))
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
        S DRUG=$S(+DRUG=0:DRUG,1:$$DRUG^PSSCLINR(DRUG))
        S TEMP="Inpatient Drug: "_DRUG_" = "
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
        S TEXT(NLINES)=$$INSCHR^PXRMEXLC(INDENT," ")_"Inpatient Medication: "_DRUG
        S TEMP=$$EDATE^PXRMDATE(IFIEVAL("DATE"))
        S TEMP=TEMP_" Status: "_IFIEVAL("STATUS")
        S TEMP=TEMP_", Start date: "_$$EDATE^PXRMDATE(IFIEVAL("START DATE"))
        S TEMP=TEMP_", Stop date: "_$$EDATE^PXRMDATE(IFIEVAL("STOP DATE"))
        I $D(IFIEVAL("DURATION")) S TEMP=TEMP_"  Duration: "_IFIEVAL("DURATION")_" D"
        D FORMATS^PXRMTEXT(INDENT+1,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
