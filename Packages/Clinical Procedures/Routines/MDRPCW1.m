MDRPCW1 ; HOIFO/NCA - MD TMDENCOUNTER Object; [05-28-2002 12:55] ;4/4/06  08:45
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ; Reference Integration Agreement:
        ; IA #1573 [Supported] ICDONE^LEXU call
        ; IA #1593 [Subscription] Access to Provider Narrative file
        ;                         (#9999999.27)
        ; IA #1609 [Supported] CONFIG^LEXSET call
        ; IA #1894 [Subscription] PXAPI call
        ; IA #1995 [Supported] ICPTCOD calls
        ; IA #2288 [Supported] CPCONE^LEXU call
        ; IA #2348 [Subscription] SCCOND^PXUTLSCC call
        ; IA #2950 [Supported] LOOK^LEXA call
        ; IA #10082 [Supported] Global Access to ICD Diagnosis file (#80)
        ; IA #10060 [Supported] FILE 200 references
        ;
CPTMODS(RESULTS,MDCPT)  ;Return CPT Modifiers for a CPT Code
        N MDARR,MDIDX,MDI,MDNAME
        S RESULTS=$NA(^TMP("MDMODS",$J)) K @RESULTS
        S MDDATE=DT
        I +($$CODM^ICPTCOD(MDCPT,$NA(MDARR),0,MDDATE)),+$D(MDARR) D
        . S MDIDX="",MDI=0
        . F  S MDIDX=$O(MDARR(MDIDX)) Q:(MDIDX="")  D
        . . S MDI=MDI+1,MDNAME=$P(MDARR(MDIDX),U,1)
        . . S @RESULTS@(MDNAME_MDI)=$P(MDARR(MDIDX),U,2)_U_MDNAME_U_MDIDX
        Q
LEX(RESULTS,MDSRCH,MDAPP)         ; return list after lexicon lookup
        N CODE,LEX,MDLST,MDI,LEXIEN,MDVAL
        S RESULTS=$NA(^TMP("MDLEX",$J)) K @RESULTS
        S MDDATE=DT
        S:MDAPP="CPT" MDAPP="CHP" ; LEX PATCH 10
        D CONFIG^LEXSET(MDAPP,MDAPP,MDDATE)
        D LOOK^LEXA(MDSRCH,MDAPP,1,"",MDDATE)
        I '$D(LEX("LIST",1)) S @RESULTS@(1)="-1^No matches found." Q
        S @RESULTS@(1)=LEX("LIST",1),MDLST=1
        S MDI="" F  S MDI=$O(^TMP("LEXFND",$J,MDI)) Q:MDI'<0  D
        . S LEXIEN=$O(^TMP("LEXFND",$J,MDI,0))
        . S MDLST=MDLST+1,@RESULTS@(MDLST)=LEXIEN_U_^TMP("LEXFND",$J,MDI,LEXIEN)
        K ^TMP("LEXFND",$J),^TMP("LEXHIT",$J)
        S MDI="" F  S MDI=$O(@RESULTS@(MDI)) Q:'MDI  S MDVAL=$G(@RESULTS@(MDI)) D
        . I MDAPP="ICD" S CODE=$$ICDONE^LEXU(+MDVAL,MDDATE),@RESULTS@(MDI)=CODE_U_MDVAL
        . I MDAPP="CPT"!(MDAPP="CHP") S CODE=$$CPTONE^LEXU(+MDVAL,MDDATE),@RESULTS@(MDI)=CODE_U_MDVAL
        . I CODE="",(MDAPP="CHP") S CODE=$$CPCONE^LEXU(+MDVAL,MDDATE),@RESULTS@(MDI)=CODE_U_MDVAL
        Q
GETENC(RESULTS,STUDY)   ; Return the current encounter data entered
        S RESULTS=$NA(^TMP("MDENC",$J)) K @RESULTS
        N MDDAR,MDDAR2,CAT,CODE,DIAG,GLOARR,MDCCON,MDX802,MDARR,MDCPT,MDCTR,MDDFN,MDENCDT,MDFLST,MDICD,MDLC,MDLL,MDLOCN,MDPROV,MDRP,MDRST,MDVST,MDVSTR,QTY,MDX,MDX0,MDX1,S S S=";"
        N LLB,MDDDN,MDDDV,MDCK,MDNCTR,MDPFLG S (MDCK,MDPFLG)=0
        Q:'$G(STUDY)
        Q:'$G(^MDD(702,+STUDY,0))
        D NOW^%DTC S MDDEF=% K % S MDCTR=0
        K ^TMP("MDDAR",$J),GLOARR,MDFLST
        S MDX=$G(^MDD(702,+STUDY,0)),MDX1=$G(^(1)),MDCCON=$P(MDX,U,5)
        S MDVST=$P(MDX1,U),MDDFN=$P(MDX,U) Q:'MDDFN
        S:+MDVST MDPFLG=1
        S MDVSTR=$P(MDX,U,7),MDDAR=$NA(^TMP("MDDAR",$J)),MDDAR2=$NA(GLOARR),@MDDAR2@("POV",0)=0,@MDDAR2@("CPT",0)=0,MDLC=0
        I 'MDVST S MDRP=0 F  S MDRP=$O(^MDD(702,STUDY,.1,MDRP)) Q:'MDRP  D
        .S MDRST=$P($G(^MDD(702,STUDY,.1,+MDRP,0)),"^",3)
        .I +MDRST D CICNV^MDHL7U3(+MDRST,.MDDAR) D SETGLO(.MDDAR,.MDDAR2)
        .K ^TMP("MDDAR",$J) Q
        I 'MDVST&(+$G(@MDDAR2@("POV",0))>0) F MDLL=1:1:+$G(@MDDAR2@("POV",0)) S MDLC=MDLC+1,MDFLST(MDLC)=$G(@MDDAR2@("POV",MDLL))
        I 'MDVST&(+$G(@MDDAR2@("CPT",0))>0) F MDLL=1:1:+$G(@MDDAR2@("CPT",0)) S MDLC=MDLC+1,MDFLST(MDLC)=$G(@MDDAR2@("CPT",MDLL))
        I MDVST>0 S MDENCDT=$P(MDVSTR,";",2),MDLOCN=$P(MDVSTR,";",3)
        ;E  S MDENCDT=$$PDT^MDRPCOT1(STUDY)
        E  S MDENCDT=$P(MDVSTR,";",2)
        S:$L(MDVSTR,";")=1 MDVSTR=";"_MDVSTR
        S MDVSTR=$$GETVSTR^MDRPCOT1(MDDFN,MDVSTR,+$P(MDX,U,4),$P(MDX,U,2)),MDLOCN=$P(MDVSTR,";",1)
        S:'MDENCDT MDENCDT=$P(MDVSTR,";",2)
        S:'MDENCDT MDENCDT=MDDEF
        S:'MDLOCN MDLOCN=$P(MDVSTR,";")
        D SCCOND^PXUTLSCC(MDDFN,MDENCDT,MDLOCN,MDVST,.MDARR)
        S MDCTR=MDCTR+1
        ; ^TMP("MDENC",$J,n)="SC";0/1^0/1;"AO";0/1^0/1;"IR";0/1^0/1;"EC";0/1^0/1;"MST";0/1^0/1;"HNC";0/1^0/1;"CV";0/1^0/1
        ;first piece 1 if the condition can be answered
        ;            0 if the condition should be null not asked
        ;second piece - If Scheduling has the answer, 1 = yes 0 = no
        S @RESULTS@(MDCTR)="SC"_S_$G(MDARR("SC"))_S_"AO"_S_$G(MDARR("AO"))_S_"IR"_S_$G(MDARR("IR"))_S_"EC"_S_$G(MDARR("EC"))_S_"MST"_S_$G(MDARR("MST"))_S_"HNC"_S_$G(MDARR("HNC"))_S_"CV"_S_$G(MDARR("CV"))
        I 'MDVST S MDVST=$$GETENC^PXAPI(MDDFN,MDENCDT,MDLOCN),MDVST=$S(+MDVST<1:0,1:+MDVST)
        I +MDVST>0 D ENCEVENT^PXAPI(MDVST)
        ;^TMP("MDENC",$J,n)="PRV"^CODE^^NARR^^Primary (1=Yes,0=No)
        I +MDVST>0 S MDPROV=0 F  S MDPROV=$O(^TMP("PXKENC",$J,MDVST,"PRV",MDPROV)) Q:'MDPROV  D
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"PRV",MDPROV,0))
        .S CODE=+$P(MDX0,U)
        .I +CODE S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="PRV"_U_CODE_U_U_$$GET1^DIQ(200,+CODE_",",.01,"E")_U_U_($P(MDX0,U,4)="P")
        ;^TMP("MDENC",$J,n)="POV"^ICD9 IEN^ICD9 CODE^provider narrative category^provider narrative (Short Description)^Primary (1=Yes,0=No)
        I +MDVST>0 S MDICD=0 F  S MDICD=$O(^TMP("PXKENC",$J,MDVST,"POV",MDICD)) Q:'MDICD  D
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"POV",MDICD,0)),MDX802=$G(^(802))
        .S CODE=+$G(MDX0,U)
        .S:CODE DIAG=$P($G(^ICD9(+CODE,0)),U)_U_$P($G(^ICD9(+CODE,0)),U,3)
        .S CAT=$P(MDX802,U)
        .S:CAT CAT=$P($G(^AUTNPOV(CAT,0)),U)
        .S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="POV"_U_+$G(MDX0,U)_U_$P(DIAG,U)_U_CAT_U_$P(DIAG,U,2)_U_($P(MDX0,U,12)="P"),MDCK=MDCK+1
        ;^TMP("MDENC",$J,n)="CPT"^CPT IEN^CPT CODE^provider narrative category^provider narrative (Short Description)^^Quantity
        I +MDVST>0 S MDCPT=0 F  S MDCPT=$O(^TMP("PXKENC",$J,MDVST,"CPT",MDCPT)) Q:'MDCPT  D
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"CPT",MDCPT,0)),MDX802=$G(^(802))
        .S CODE=+$G(MDX0,U)
        .S:CODE CODE=$$CPT^ICPTCOD(CODE,MDVST)
        .S:CODE DIAG=$P(CODE,U,2,3)
        .S CAT=$P(MDX802,U)
        .S:CAT CAT=$P($G(^AUTNPOV(CAT,0)),U)
        .S QTY=$P(MDX0,U,16)
        .S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="CPT"_U_+$G(MDX0,U)_U_$P(DIAG,U)_U_CAT_U_$P(DIAG,U,2)_U_U_QTY,MDCK=MDCK+1
        K ^TMP("PXKENC",$J)
        I 'MDVST!(+MDCK<1) D
        .S MDDDN=$O(^MDD(702,"ACON",MDCCON,+STUDY),-1),MDVST=0
        .I MDDDN D
        ..S MDDDV=$P($G(^MDD(702,+MDDDN,0)),U,7)
        ..S:$L(MDDDV,";")>1 MDENCDT=$P(MDDDV,";",2),MDVST=+$G(^MDD(702,+MDDDN,1)),MDVST=$S(+MDVST<1:0,1:+MDVST)
        ..I +MDVST>0 S MDNCTR=MDCTR F LLB=2:1:MDCTR K @RESULTS@(MDCTR) S MDNCTR=MDNCTR-1
        I $G(MDFLST(1))'="" S MDLL=0 F  S MDLL=$O(MDFLST(MDLL)) Q:MDLL<1  S:$G(MDFLST(MDLL))'="" MDCTR=MDCTR+1,@RESULTS@(MDCTR)=$G(MDFLST(MDLL))
        Q:MDCK>0
        Q:'MDVST
        D ENCEVENT^PXAPI(MDVST) S:$G(MDNCTR)>0 MDCTR=MDNCTR
        ;^TMP("MDENC",$J,n)="PRV"^CODE^^NARR^^Primary (1=Yes,0=No)
        S MDPROV=0 F  S MDPROV=$O(^TMP("PXKENC",$J,MDVST,"PRV",MDPROV)) Q:'MDPROV  D
        .Q
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"PRV",MDPROV,0))
        .S CODE=+$P(MDX0,U)
        .I +CODE S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="PRV"_U_CODE_U_U_$$GET1^DIQ(200,+CODE_",",.01,"E")_U_U_($P(MDX0,U,4)="P")
        ;^TMP("MDENC",$J,n)="POV"^ICD9 IEN^ICD9 CODE^provider narrative category^provider narrative (Short Description)^Primary (1=Yes,0=No)
        S MDICD=0 F  S MDICD=$O(^TMP("PXKENC",$J,MDVST,"POV",MDICD)) Q:'MDICD  D
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"POV",MDICD,0)),MDX802=$G(^(802))
        .S CODE=+$G(MDX0,U)
        .S:CODE DIAG=$P($G(^ICD9(+CODE,0)),U)_U_$P($G(^ICD9(+CODE,0)),U,3)
        .S CAT=$P(MDX802,U)
        .S:CAT CAT=$P($G(^AUTNPOV(CAT,0)),U)
        .S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="POV"_U_+$G(MDX0,U)_U_$P(DIAG,U)_U_CAT_U_$P(DIAG,U,2)_U_($P(MDX0,U,12)="P")
        ;^TMP("MDENC",$J,n)="CPT"^CPT IEN^CPT CODE^provider narrative category^provider narrative (Short Description)^^Quantity
        S MDCPT=0 F  S MDCPT=$O(^TMP("PXKENC",$J,MDVST,"CPT",MDCPT)) Q:'MDCPT  D
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"CPT",MDCPT,0)),MDX802=$G(^(802))
        .S CODE=+$G(MDX0,U)
        .S:CODE CODE=$$CPT^ICPTCOD(CODE,MDVST)
        .S:CODE DIAG=$P(CODE,U,2,3)
        .S CAT=$P(MDX802,U)
        .S:CAT CAT=$P($G(^AUTNPOV(CAT,0)),U)
        .S QTY=$P(MDX0,U,16)
        .S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="CPT"_U_+$G(MDX0,U)_U_$P(DIAG,U)_U_CAT_U_$P(DIAG,U,2)_U_U_QTY
        K ^TMP("PXKENC",$J)
        Q
SETGLO(MDGLO1,MDGLO2)   ; Set the ICD and CPT from device into a global array
        N MDA,MDB,MDC
        I +$G(@MDGLO1@(1))<1&(+$G(@MDGLO1@(2))<1) Q
        S MDA=$O(@MDGLO2@("POV",""),-1)
        S MDB=$O(@MDGLO2@("CPT",""),-1)
        F MDC=1:1:+$G(@MDGLO1@(1)) S MDA=MDA+1,@MDGLO2@("POV",MDA)=$G(@MDGLO1@(1,MDC))
        F MDC=1:1:+$G(@MDGLO1@(2)) S MDB=MDB+1,@MDGLO2@("CPT",MDB)=$G(@MDGLO1@(2,MDC))
        S @MDGLO2@("POV",0)=MDA,@MDGLO2@("CPT",0)=MDB
        Q
NTIU(P1)        ; Create New TIU note for Result
        I $G(^MDD(702,+P1,0))="" Q 0
        N MDNEWN
        S:$P($G(^MDS(702.01,+$P(^MDD(702,+P1,0),U,4),0)),U,6)=2 MDNEWN=$$NEWTIUN^MDRPCOT2(+P1)
        Q 1
