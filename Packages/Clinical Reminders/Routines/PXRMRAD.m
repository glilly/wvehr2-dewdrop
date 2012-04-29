PXRMRAD ; SLC/PKR - Handle radiology findings. ;08/04/2008
        ;;2.0;CLINICAL REMINDERS;**4,12**;Feb 04, 2005;Build 73
        ;
        ;=================================================
EVALFI(DFN,DEFARR,ENODE,FIEVAL) ;Evaluate radiology findings.
        D EVALFI^PXRMINDX(DFN,.DEFARR,ENODE,.FIEVAL)
        Q
        ;
        ;=================================================
EVALPL(FINDPA,ENODE,TERMARR,PLIST)      ;Evaluate radiology term findings
        ;for patient lists.
        D EVALPL^PXRMINDL(.FINDPA,ENODE,.TERMARR,PLIST)
        Q
        ;
        ;=================================================
EVALTERM(DFN,FINDPA,ENODE,TERMARR,TFIEVAL)      ;Evaluate radiology terms.
        D EVALTERM^PXRMINDX(DFN,.FINDPA,ENODE,.TERMARR,.TFIEVAL)
        Q
        ;
        ;=================================================
GETDATA(DAS,FIEVT)      ;Return data for a RAD/NUC MED PATIENT entry.
        ;DBIA #3731
        D EN1^RAPXRM(DAS,.FIEVT)
        S (FIEVT("STATUS"),FIEVT("VALUE"))=FIEVT("EXAM STATUS")
        Q
        ;
        ;=================================================
MHVOUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the MHV output.
        N CPT,CPTDATA,CODE,D0,IND,JND,NAME,NOUT,RADPROC,SNAME,TEMP,TEXTOUT
        S RADPROC=$P(IFIEVAL("FINDING"),";",1)
        ;DBIA #118-B
        S D0=^RAMIS(71,RADPROC,0)
        S NAME=$P(D0,U,1)
        S CPT=$P(D0,U,9)
        S CPTDATA=$$CPT^ICPTCOD(CPT)
        S CODE=$P(CPTDATA,U,2)
        S SNAME=$P(CPTDATA,U,3)
        S NAME="Radiology Procedure = "_SNAME
        S IND=0
        F  S IND=+$O(IFIEVAL(IND)) Q:IND=0  D
        . S TEMP=NAME_" ("_$$EDATE^PXRMDATE(IFIEVAL(IND,"DATE"))_")"
        . D FORMATS^PXRMTEXT(INDENT+2,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        . F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
        ;=================================================
OUTPUT(INDENT,IFIEVAL,NLINES,TEXT)      ;Produce the clinical
        ;maintenance output.
        N CPT,CPTDATA,CODE,D0,IND,JND,NAME,NOUT,RADPROC,SNAME,TEMP,TEXTOUT
        S RADPROC=$P(IFIEVAL("FINDING"),";",1)
        ;DBIA #118-B
        S D0=^RAMIS(71,RADPROC,0)
        S NAME=$P(D0,U,1)
        S CPT=$P(D0,U,9)
        S CPTDATA=$$CPT^ICPTCOD(CPT)
        S CODE=$P(CPTDATA,U,2)
        S SNAME=$P(CPTDATA,U,3)
        S TEMP="Radiology Procedure: "_CODE_" ("_NAME_") - "_SNAME
        D FORMATS^PXRMTEXT(INDENT+1,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S IND=0
        F  S IND=+$O(IFIEVAL(IND)) Q:IND=0  D
        . S TEMP=$$EDATE^PXRMDATE(IFIEVAL(IND,"DATE"))
        . S TEMP=TEMP_" Status: "_IFIEVAL(IND,"STATUS")
        . S TEMP=TEMP_"; Report Status: "_IFIEVAL(IND,"RPT STATUS")
        . D FORMATS^PXRMTEXT(INDENT+2,PXRMRM,TEMP,.NOUT,.TEXTOUT)
        . F JND=1:1:NOUT S NLINES=NLINES+1,TEXT(NLINES)=TEXTOUT(JND)
        S NLINES=NLINES+1,TEXT(NLINES)=""
        Q
        ;
