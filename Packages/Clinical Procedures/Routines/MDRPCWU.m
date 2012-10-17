MDRPCWU ; HOIFO/NCA - CPT Code Query; [05-28-2002 12:55] ;2/16/10  16:17
        ;;1.0;CLINICAL PROCEDURES;**21**;Apr 01, 2004;Build 30
        ; Reference Integration Agreement:
        ; IA #1573 [Supported] LEXU calls
        ; IA #1609 [Supported] CONFIG^LEXSET call
        ; IA #2950 [Supported] LOOK^LEXA call
        ;
CPTLEX(RESLT,MDSRCH,MDAPP)      ; CPT Code Query
        N CODE,LEX,MDLST,MDI,LEXIEN,MDVAL
        S RESLT=$NA(^TMP("MDLEX",$J)) K @RESLT
        S MDDATE=DT
        S:MDAPP="CPT" MDAPP="CHP" ; LEX PATCH 10
        D CONFIG^LEXSET(MDAPP,MDAPP,MDDATE)
        D LOOK^LEXA(MDSRCH,MDAPP,1,"",MDDATE)
        I '$D(LEX("LIST",1)) S @RESLT@(1)="-1^No matches found." Q
        S @RESLT@(1)=LEX("LIST",1),MDLST=1
        S MDI="" F  S MDI=$O(^TMP("LEXFND",$J,MDI)) Q:MDI'<0  D
        . S LEXIEN=$O(^TMP("LEXFND",$J,MDI,0))
        . S MDLST=MDLST+1,@RESLT@(MDLST)=LEXIEN_U_^TMP("LEXFND",$J,MDI,LEXIEN)
        K ^TMP("LEXFND",$J),^TMP("LEXHIT",$J)
        S MDI="" F  S MDI=$O(@RESLT@(MDI)) Q:'MDI  S MDVAL=$G(@RESLT@(MDI)) D
        . I MDAPP="ICD" S CODE=$$ICDONE^LEXU(+MDVAL,MDDATE),@RESLT@(MDI)=CODE_U_MDVAL
        . I MDAPP="CPT"!(MDAPP="CHP") S CODE=$$CPTONE^LEXU(+MDVAL,MDDATE),@RESLT@(MDI)=CODE_U_MDVAL
        . I CODE="",(MDAPP="CHP") S CODE=$$CPCONE^LEXU(+MDVAL,MDDATE),@RESLT@(MDI)=CODE_U_MDVAL
        Q
