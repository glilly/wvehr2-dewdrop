VBECA1B ;HIOFO/BNT - VBECS Patient Data APIs ; 01/21/05 8:30am
        ;;1.0;VBECS;;Apr 14, 2005;Build 35
        ; Note: This routine supports data exchange with an FDA registered
        ; medical device. As such, it may not be changed in any way without
        ; prior written approval from the medical device manufacturer.
        ; 
        ; Integration Agreements:
        ; Reference to ^DIC supported by IA #10006
        ; Reference to file 200 supported by IA #10035
        ; Reference to $$CHARCHK^XOBVLIB supported by IA #4090
        ; Reference to EN^MXMLPRSE supported by IA #4149
        ; Reference to ^DPT( supported by IA #10035
        ; 
        QUIT
        ;
        ; ----------------------------------------------------------
        ;      Private Method supports IA 4624
        ; ----------------------------------------------------------
ABORH(DFN,VBECTYP)      ; Returns VBECS Patient ABO Group and Rh Type
        ; Input:  DFN = PATIENT file (#2) IEN
        ;         VBECTYP = "ABORH" or "ABO" or "RH" as needed.
        IF '$D(^DPT(DFN,0)) S ARR("ERROR")="1^Invalid or Missing Patient Identifier" QUIT ARR("ERROR")
        IF VBECTYP'="ABORH"&(VBECTYP'="ABO")&(VBECTYP'="RH") S ARR("ERROR")="1^Invalid Input" QUIT ARR("ERROR")
        K ^TMP("VBECAPI",$J),^TMP("VBECAPI1",$J),ARR1
        D INITV^VBECRPCC("VBECS Patient ABO_RH")
        S VBECY="^TMP(""VBECAPI"",$J)",VBECPRMS("RESULTS")="^TMP(""VBECAPI1"",$J)"
        IF +VBECPRMS("ERROR") S ARR("ERROR")=VBECPRMS("ERROR") Q ARR("ERROR")
        SET VBECPRMS("PARAMS",1,"TYPE")="STRING"
        SET VBECPRMS("PARAMS",1,"VALUE")=$$CHARCHK^XOBVLIB(DFN)
        S VBECSTAT=$$EXECUTE^VBECRPCC(.VBECPRMS)
        D PARSE^VBECRPC1(.VBECPRMS,VBECY)
        I $D(@VBECY@("ERROR")) SET ARR("ERROR")="1^"_@VBECY@("ERROR") QUIT ARR("ERROR")
        D ABOEN(.ARR,VBECY)
        K ^TMP("VBECAPI",$J),^TMP("VBECAPI1",$J),ARR1
        ;K OPTION,VBECABHC,VBECLN,VBECMSBC,VBECPRMS,VBECRES
        K VBECSRC,VBECSTAT,VBECTRHC,VBECTSTC,VBECUNA,VBECUNC,VBECUND
        K VBECUNS,VBECY
        Q $G(@VBECTYP)
ABOEN(ARR,DOC)  ;
        N CBK,CNT
        S OPTION="",VBECRES=$NA(ARR1("API"))
        K @VBECRES
        S (VBECLN,VBECTRHC,VBECABHC,VBECTSTC,VBECMSBC,VBECSRC,VBECUNC,VBECUNS,VBECUNA,VBECUND)=0
        D ABOSET(.CBK)
        D EN^MXMLPRSE(DOC,.CBK,.OPTION)
        Q
ABOSET(CBK)     ;
        K CBK
        S CBK("STARTELEMENT")="ABOSTELE^VBECA1B1"
        S CBK("ENDELEMENT")="ENELE^VBECA1B1"
        S CBK("CHARACTERS")="CHAR^VBECA1B1"
        Q
        ;
        ; ----------------------------------------------------------
        ;      Private Method supports IA 4626
        ; ----------------------------------------------------------
TRRX(DFN)       ; Returns VBECS Patient Transfusion Reaction History
        K ^TMP("VBECAPI",$J),^TMP("VBECAPI1",$J)
        D INITV^VBECRPCC("VBECS Patient TRRX")
        S VBECY="^TMP(""VBECAPI"",$J)",VBECPRMS("RESULTS")="^TMP(""VBECAPI1"",$J)"
        IF +VBECPRMS("ERROR") S ARR("ERROR")=VBECPRMS("ERROR") Q
        SET VBECPRMS("PARAMS",1,"TYPE")="STRING"
        SET VBECPRMS("PARAMS",1,"VALUE")=$$CHARCHK^XOBVLIB(DFN)
        S VBECSTAT=$$EXECUTE^VBECRPCC(.VBECPRMS)
        D PARSE^VBECRPC1(.VBECPRMS,VBECY)
        D TRRXEN(.ARR,VBECY)
        I '$D(ARR("TRRX")) S ARR("TRRX")=""
        Q
        ;
TRRXEN(ARR,DOC) ;
        N CBK,CNT
        S OPTION="",VBECRES=$NA(^TMP("VBECA1B",$J))
        K @VBECRES
        S (VBECLN,VBECTRHC,VBECABHC,VBECTSTC,VBECMSBC,VBECSRC,VBECUNC,VBECUNS,VBECUNA,VBECUND)=0
        D TRRXSET(.CBK)
        D EN^MXMLPRSE(DOC,.CBK,.OPTION)
        M ARR("TRRX")=@VBECRES
        K VBECABHC,VBECLN,VBECMSBC,VBECPRMS,VBECRES,VBECSRC,VBECSTAT
        K VBECTRHC,VBECTSTC,VBECUNA,VBECUNC,VBECUND,VBECUNS,VBECY
        K ^TMP("VBECAPI",$J),^TMP("VBECAPI1",$J)
        Q
        ;
TRRXSET(CBK)    ;
        K CBK
        S CBK("STARTELEMENT")="TRSTELE^VBECA1B1"
        S CBK("ENDELEMENT")="ENELE^VBECA1B1"
        S CBK("CHARACTERS")="CHAR^VBECA1B1"
        Q
        ;
        ; ----------------------------------------------------------
        ;      Private Method supports IA 4625
        ; ----------------------------------------------------------
ABID(DFN)       ; Returns VBECS Patient Antibodies Identified
        D INITV^VBECRPCC("VBECS Patient ABID")
        S VBECY="^TMP(""VBECAPI"",$J)",VBECPRMS("RESULTS")="^TMP(""VBECAPI1"",$J)"
        K @VBECY,@VBECPRMS("RESULTS")
        IF +VBECPRMS("ERROR") S ARR("ERROR")=VBECPRMS("ERROR") Q
        SET VBECPRMS("PARAMS",1,"TYPE")="STRING"
        SET VBECPRMS("PARAMS",1,"VALUE")=$$CHARCHK^XOBVLIB(DFN)
        S VBECSTAT=$$EXECUTE^VBECRPCC(.VBECPRMS)
        D PARSE^VBECRPC1(.VBECPRMS,VBECY)
        D ABIDEN(.ARR,VBECY)
        ;K @VBECY,@VBECPRMS("RESULTS")
        K ARR1,ATR,ATR,CBK,CNT,DFN,DOC,ELE,OPTION,TEXT,VBECABHC,VBECLN
        K VBECMSBC,VBECPRMS,VBECRES,VBECSRC,VBECSTAT,VBECTRHC,VBECTSTC
        K VBECUNA,VBECUNC,VBECUND,VBECUNS,VBECY
        Q
        ;
ABIDEN(ARR,DOC) ;
        N CBK,CNT
        S OPTION="",VBECRES=$NA(^TMP("VBECA1B",$J))
        K @VBECRES
        S (VBECLN,VBECTRHC,VBECABHC,VBECTSTC,VBECMSBC,VBECSRC,VBECUNC,VBECUNS,VBECUNA,VBECUND)=0
        D ABSET(.CBK)
        D EN^MXMLPRSE(DOC,.CBK,.OPTION)
        M ARR("ABID")=@VBECRES
        Q
        ;
ABSET(CBK)      ;
        K CBK
        S CBK("STARTELEMENT")="ABSTELE^VBECA1B1"
        S CBK("ENDELEMENT")="ENELE^VBECA1B1"
        S CBK("CHARACTERS")="CHAR^VBECA1B1"
        Q
        ;
        ; ----------------------------------------------------------
        ;      Private Method supports IA 4620
        ; ----------------------------------------------------------
AVUNIT(TMPLOC,DFN)      ; Returns VBECS Patient Available Units
        ; Input variable;
        ; TMPLOC = Node in ^TMP to be used for output data array
        ; DFN = Internal number of patient
        ;
        ; Output is data array:
        ; ^TMP(TMPLOC,$J,n)
        ;
        Q:$G(TMPLOC)=""
        Q:'$G(DFN)
        K ^TMP("VBECAPI",$J),^TMP("VBECAPI1",$J),^TMP(TMPLOC,$J)
        D INITV^VBECRPCC("VBECS Patient Available Units")
        S VBECY="^TMP(""VBECAPI"",$J)",VBECPRMS("RESULTS")="^TMP(""VBECAPI1"",$J)"
        IF +VBECPRMS("ERROR") S ARR("ERROR")=VBECPRMS("ERROR") Q
        SET VBECPRMS("PARAMS",1,"TYPE")="STRING"
        SET VBECPRMS("PARAMS",1,"VALUE")=$$CHARCHK^XOBVLIB(DFN)
        S VBECSTAT=$$EXECUTE^VBECRPCC(.VBECPRMS)
        D PARSE^VBECRPC1(.VBECPRMS,VBECY)
        D AVUEN(.ARR,VBECY)
        I '$D(ARR("UNIT")) S ARR("UNIT")=""
        M ^TMP(TMPLOC,$J)=ARR
        K ARR
        Q
AVUEN(ARR,DOC)  ;
        N CBK,CNT
        S OPTION="",VBECRES=$NA(^TMP("VBECA1B",$J))
        K @VBECRES
        S (VBECLN,VBECTRHC,VBECABHC,VBECTSTC,VBECMSBC,VBECSRC,VBECUNC,VBECUNS,VBECUNA,VBECUND)=0
        D AVUSET(.CBK)
        D EN^MXMLPRSE(DOC,.CBK,.OPTION)
        M ARR=@VBECRES@("UNIT",$J)
        K VBECABHC,VBECLN,VBECMSBC,VBECPRMS,VBECRES,VBECSRC,VBECSTAT
        K VBECTRHC,VBECTSTC,VBECUNA,VBECUNC,VBECUND,VBECUNS,VBECY
        K ^TMP("VBECAPI",$J),^TMP("VBECAPI1",$J),ARR1
        Q
AVUSET(CBK)     ;
        K CBK
        S CBK("STARTELEMENT")="AVUSTELE^VBECA1B1"
        S CBK("ENDELEMENT")="ENELE^VBECA1B1"
        S CBK("CHARACTERS")="CHAR^VBECA1B1"
        Q
        ;
        ; ----------------------------------------------------------
        ;      Private Method supports IA 4621
        ; ----------------------------------------------------------
TRAN(DFN)       ; Returns VBECS Patient Transfusion History
        K ^TMP("VBECAPI",$J),^TMP("VBECAPI1",$J)
        D INITV^VBECRPCC("VBECS Patient Transfusion History")
        S VBECY="^TMP(""VBECAPI"",$J)",VBECPRMS("RESULTS")="^TMP(""VBECAPI1"",$J)"
        IF +VBECPRMS("ERROR") S ARR("ERROR")=VBECPRMS("ERROR") Q
        SET VBECPRMS("PARAMS",1,"TYPE")="STRING"
        SET VBECPRMS("PARAMS",1,"VALUE")=$$CHARCHK^XOBVLIB(DFN)
        S VBECSTAT=$$EXECUTE^VBECRPCC(.VBECPRMS)
        D PARSE^VBECRPC1(.VBECPRMS,VBECY)
        D TRANEN(.ARR,VBECY)
        Q
        ;
TRANEN(ARR,DOC) ;
        N CBK,CNT
        S OPTION="",VBECRES=$NA(^TMP("VBECA1B",$J))
        K @VBECRES
        S (VBECLN,VBECTRHC,VBECABHC,VBECTSTC,VBECMSBC,VBECSRC,VBECUNC,VBECUNS,VBECUNA,VBECUND)=0
        D TRANSET(.CBK)
        D EN^MXMLPRSE(DOC,.CBK,.OPTION)
        I '$D(@VBECRES@("TRAN")) S ARR="" Q
        M ARR=@VBECRES@("TRAN")
        K VBECABHC,VBECLN,VBECMSBC,VBECPRMS,VBECRES,VBECSRC,VBECSTAT
        K VBECTRHC,VBECTSTC,VBECUNA,VBECUNC,VBECUND,VBECUNS,VBECY
        K ^TMP("VBECAPI",$J),^TMP("VBECAPI1",$J),^TMP("VBECA1B",$J)
        Q
        ;
TRANSET(CBK)    ;
        K CBK
        S CBK("STARTELEMENT")="TRANSTEL^VBECA1B1"
        S CBK("ENDELEMENT")="ENELE^VBECA1B1"
        S CBK("CHARACTERS")="CHAR^VBECA1B1"
        Q
        ;
        ; ----------------------------------------------------------
        ;      Private Method supports IA 4623
        ; ----------------------------------------------------------
DFN(DFN)        ; Returns VBECS Patient Reports for CPRS
        D INITV^VBECRPCC("VBECS Patient Report")
        S VBECY="^TMP(""VBECAPI"",$J)",VBECPRMS("RESULTS")="^TMP(""VBECAPI1"",$J)"
        K @VBECY,@VBECPRMS("RESULTS")
        IF +VBECPRMS("ERROR") S ARR("ERROR")=VBECPRMS("ERROR") Q
        SET VBECPRMS("PARAMS",1,"TYPE")="STRING"
        SET VBECPRMS("PARAMS",1,"VALUE")=$$CHARCHK^XOBVLIB(DFN)
        S VBECSTAT=$$EXECUTE^VBECRPCC(.VBECPRMS)
        D PARSE^VBECRPC1(.VBECPRMS,VBECY)
        D RPTEN(.ARR,VBECY)
        ;K @VBECY,@VBECPRMS("RESULTS")
        K VBECABHC,VBECLN,VBECMSBC,VBECPRMS,VBECRES,VBECSRC,VBECSTAT
        K VBECTRHC,VBECTSTC,VBECUNA,VBECUNC,VBECUND,VBECUNS,VBECY
        Q
RPTEN(ARR,DOC)  ;
        N CBK,CNT
        S OPTION="",VBECRES=$NA(^TMP("VBDATA",$J))
        K @VBECRES
        S (VBECLN,VBECTRHC,VBECABHC,VBECTSTC,VBECMSBC,VBECSRC,VBECUNC,VBECUNS,VBECUNA,VBECUND,VBECSTC,VBECCRC)=0
        D RPTSET(.CBK)
        D EN^MXMLPRSE(DOC,.CBK,.OPTION)
        M ARR=@VBECRES
        Q
RPTSET(CBK)     ;
        K CBK
        S CBK("STARTELEMENT")="RPTSTELE^VBECA1B1"
        S CBK("ENDELEMENT")="ENELE^VBECA1B1"
        S CBK("CHARACTERS")="CHAR^VBECA1B1"
        Q
