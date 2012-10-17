MDRPCW  ; HOIFO/NCA - Calls to AICS;04/01/2003 ;01/21/10  11:51
        ;;1.0;CLINICAL PROCEDURES;**6,21**;Apr 01, 2004;Build 30
        ; Reference Integration Agreement:
        ; IA #142 [Subscription] Access ^DIC(31 NAME field (#.01) with FM
        ; IA #174 [Subscription] Access DPT(DFN,.372) node.
        ; IA #649 [Subscription] Access DG(391 with FM for
        ;                        IGNORE VETERAN CHECK field (#.02).
        ; IA #1296 [Subscription] IBDF18A call
        ; IA #1593 [Subscription] Access to Provider Narrative file
        ;                         (#9999999.27)
        ; IA #1894 [Subscription] PXAPI call
        ; IA #1995 [Supported] ICPTCOD calls
        ; IA #3990 [Supported] ICDCODE calls
        ; IA #10060 [Supported] Access File 200
        ; IA #10061 [Supported] VADPT calls
        ;
        Q
RPC(RESULTS,OPTION,DFN,MDSTUD)  ; [Procedure] Main RPC call
        ; RPC: [MD TMDCIDC]
        ;
        ; DFN=Patient internal entry number in Patient file (#2)
        ; MDSTUD=CP study internal entry number
        ;
        D CLEAN^DILF
        S RESULTS=$NA(^TMP("MDRPCW",$J)) K @RESULTS
        I $G(MDSTUD)="" S @RESULTS@(0)="-1^No Study." Q
        I $T(@OPTION)="" D  Q
        .S @RESULTS@(0)="-1^Error in RPC: MD TMDCIDC at "_OPTION_U_$T(+0)
        D @OPTION S:'$D(@RESULTS) @RESULTS@(0)="-1^No return"
        D CLEAN^DILF
        Q
PROC    ; get list of procedures for clinic
        N CLIN,MDARR,MDPR,MDV
        S MDV=$$GET1^DIQ(702,+MDSTUD_",",.07,"I")
        I $G(MDV)="" S @RESULTS@(0)="-1^No Visit." Q
        S MDPR=$$GET1^DIQ(702,+MDSTUD_",",.04,"I")
        I '$G(MDPR) S @RESULTS@(0)="-1^No CP Definition." Q
        S CLIN=$$GET1^DIQ(702.01,+MDPR_",",.05,"I")
        I 'CLIN S CLIN=+$P(MDV,";",3) I 'CLIN S @RESULTS@(0)="-1^No Hospital Location." Q
        D GETLST^IBDF18A(CLIN,"DG SELECT CPT PROCEDURE CODES","MDARR",,,1,DT)
        N MDIDX,MDMOD,CODES,MDFST S MDIDX=0 M @RESULTS=MDARR
        F  S MDIDX=$O(@RESULTS@(MDIDX)) Q:'+MDIDX  D
        . I @RESULTS@(MDIDX)="" K @RESULTS@(MDIDX) Q
        . S MDMOD=0,CODES="",MDFST=1
        . F  S MDMOD=$O(@RESULTS@(MDIDX,"MODIFIER",MDMOD)) Q:(MDMOD="")  D
        . . I MDFST S MDFST=0
        . . E  S CODES=CODES_";"
        . . S CODES=CODES_@RESULTS@(MDIDX,"MODIFIER",MDMOD)
        . K @RESULTS@(MDIDX,"MODIFIER")
        . I 'MDFST S $P(@RESULTS@(MDIDX),U,12)=CODES
        Q
DIAG    ; get list of diagnoses for clinic
        N CLIN,MDARR,MDPR,MDV
        S MDV=$$GET1^DIQ(702,+MDSTUD_",",.07,"I")
        I $G(MDV)="" S @RESULTS@(0)="-1^No Visit." Q
        S MDPR=$$GET1^DIQ(702,+MDSTUD_",",.04,"I")
        I '$G(MDPR) S @RESULTS@(0)="-1^No CP Definition." Q
        S CLIN=$$GET1^DIQ(702.01,+MDPR_",",.05,"I")
        I 'CLIN S CLIN=+$P(MDV,";",3) I 'CLIN S @RESULTS@(0)="-1^No Hospital Location." Q
        D GETLST^IBDF18A(CLIN,"DG SELECT ICD-9 DIAGNOSIS CODES","MDARR",,,,DT)
        M @RESULTS=MDARR
        Q
SCDISP  ; Return Service Connected % and Rated Disabilities
        N VAEL,VAERR,I,MDLST,DIS,MDSC,X2
        D ELIG^VADPT
        S:'+VAEL(3) @RESULTS@(1)="Service Connected: NO"
        S:+VAEL(3) @RESULTS@(1)="SC Percent: "_$P(VAEL(3),U,2)_"%"
        I 'VAEL(4),'$$GET1^DIQ(391,+VAEL(6)_",",.02,"I") S @RESULTS@(2)="Rated Disabilities: NOT A VETERAN." D KVAR^VADPT Q
        S @RESULTS@(2)="Rated Disabilities: "
        S I=0,MDLST=0 F  S I=$O(^DPT(DFN,.372,I)) Q:'I  S X2=^(I,0) D
        . S DIS=$$GET1^DIQ(31,+X2_",",.01,"E") Q:DIS=""
        . S MDSC=$S($P(X2,U,3):"SC",$P(X2,U,3)']"":"not specified",1:"NSC")
        . S MDLST=MDLST+1,@RESULTS@(MDLST+2)="                    "_DIS_" ("_$P(X2,U,2)_"%-"_MDSC_")"
        I 'MDLST S @RESULTS@(2)=@RESULTS@(2)_"NONE STATED"
        D KVAR^VADPT
        Q
PCEDISP ; Return print text to display PCE data
        ;S RESULTS=$NA(^TMP("MDENC",$J)) K @RESULTS
        S STUDY=+MDSTUD
        N MDDAR,MDDAR2,CAT,CODE,DIAG,GLOARR,MDCCON,MDX802,MDARR,MDCPT,MDCTR,MDDFN,MDENCDT,MDFLST,MDICD,MDLC,MDLL,MDLOCN,MDPROV,MDRP,MDRST,MDVST,MDVSTR,QTY,MDX,MDX0,MDX1,S S S=";"
        N DESC,GDIAG,LLB,MDDDN,MDDDV,MDCK,MDNCTR,MDPFLG,MDCLL,MDDESC S (MDCK,MDPFLG)=0
        Q:'$G(STUDY)
        Q:'$G(^MDD(702,+STUDY,0))
        D NOW^%DTC S MDDEF=% K % S MDCTR=0
        K ^TMP("MDDAR",$J),^TMP("MDLEX",$J),GLOARR,MDFLST
        S MDX=$G(^MDD(702,+STUDY,0)),MDX1=$G(^(1)),MDCCON=$P(MDX,U,5)
        S MDVST=$P(MDX1,U),MDDFN=$P(MDX,U) Q:'MDDFN
        S:+MDVST MDPFLG=1
        S MDVSTR=$P(MDX,U,7),MDDAR=$NA(^TMP("MDDAR",$J)),MDDAR2=$NA(GLOARR),@MDDAR2@("POV",0)=0,@MDDAR2@("CPT",0)=0,MDLC=0
        I 'MDVST S MDRP=0 F  S MDRP=$O(^MDD(702,STUDY,.1,MDRP)) Q:'MDRP  D
        .S MDRST=$P($G(^MDD(702,STUDY,.1,+MDRP,0)),"^",3)
        .I +MDRST D CICNV^MDHL7U3(+MDRST,.MDDAR) D SETGLO^MDRPCW1(.MDDAR,.MDDAR2)
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
        S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="Visit #: "_$S(MDVST>0:MDVST,1:"")
        I '+MDVST S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="Encounter Date/Time: "_$E(MDENCDT,4,5)_"/"_$E(MDENCDT,6,7)_"/"_$E(MDENCDT,2,3)
        I '+MDVST S MDVST=$$GETENC^PXAPI(MDDFN,MDENCDT,MDLOCN),MDVST=$S(+MDVST<1:0,1:+MDVST),MDCTR=MDCTR+1,@RESULTS@(MDCTR)="Visit # For Encounter Date: "_$S(MDVST>0:MDVST,1:"")
        I +MDVST>0 D ENCEVENT^PXAPI(MDVST)
        I +MDVST>0 S MDPROV=0 F  S MDPROV=$O(^TMP("PXKENC",$J,MDVST,"PRV",MDPROV)) Q:'MDPROV  D
        .Q:'MDPFLG
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"PRV",MDPROV,0))
        .S CODE=+$P(MDX0,U)
        .I +CODE S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="Provider: "_$$GET1^DIQ(200,+CODE_",",.01,"E")_" "_$S($P(MDX0,U,4)="P":"Primary",1:"")
        I +MDVST>0 S MDICD=0 F  S MDICD=$O(^TMP("PXKENC",$J,MDVST,"POV",MDICD)) Q:'MDICD  D
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"POV",MDICD,0)),MDX802=$G(^(802))
        .S CODE=+$G(MDX0,U),GDIAG=$$ICDDX^ICDCODE(CODE,"")
        .S:CODE DIAG=$P(GDIAG,U,2)_U_$P(GDIAG,U,4)
        .S CAT=$P(MDX802,U)
        .S:CAT CAT=$P($G(^AUTNPOV(CAT,0)),U)
        .S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="Diagnosis: "_$P(DIAG,U,2)_" "_$S($P(MDX0,U,12)="P":"Primary",1:""),MDCK=MDCK+1
        I +MDVST>0 S MDCPT=0 F  S MDCPT=$O(^TMP("PXKENC",$J,MDVST,"CPT",MDCPT)) Q:'MDCPT  D
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"CPT",MDCPT,0)),MDX802=$G(^(802))
        .S CODE=+$G(MDX0,U)
        .S:CODE CODE=$$CPT^ICPTCOD(CODE,MDVST)
        .S:CODE DIAG=$P(CODE,U,2,3)
        .S CAT=$P(MDX802,U)
        .S:CAT CAT=$P($G(^AUTNPOV(CAT,0)),U)
        .S QTY=$P(MDX0,U,16)
        .S MDDESC="" D CPTLEX^MDRPCWU(.RESLT,+$G(MDX0,U),"CPT")
        .S MDCLL="" F  S MDCLL=$O(^TMP("MDLEX",$J,MDCLL)) Q:MDCLL<1  S MDDESC=$P(^(MDCLL),"^",3)
        .S:$L(MDDESC)>230 MDDESC=$E(MDDESC,1,230) K ^TMP("MDLEX",$J),RESLT
        .S:MDDESC="" MDDESC=$P(DIAG,U,2)
        .S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="CPT: "_MDDESC_"-"_QTY,MDCK=MDCK+1
        K ^TMP("PXKENC",$J)
        I 'MDVST!(+MDCK<1) D
        .S MDDDN=$O(^MDD(702,"ACON",MDCCON,+STUDY),-1),MDVST=0
        .I MDDDN D
        ..S MDDDV=$P($G(^MDD(702,+MDDDN,0)),U,7)
        ..S:$L(MDDDV,";")>1 MDENCDT=$P(MDDDV,";",2),MDVST=+$G(^MDD(702,+MDDDN,1)),MDVST=$S(+MDVST<1:0,1:+MDVST)
        ..I +MDVST>0 S MDNCTR=0
        ..S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="Previous Study # Used: "_+MDDDN
        ..S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="Previous Visit #: "_MDVST_" "_$E(MDENCDT,4,5)_"/"_$E(MDENCDT,6,7)_"/"_$E(MDENCDT,2,3)
        I $G(MDFLST(1))'="" S MDLL=0 F  S MDLL=$O(MDFLST(MDLL)) Q:MDLL<1  S:$G(MDFLST(MDLL))'="" MDCTR=MDCTR+1,@RESULTS@(MDCTR)=$G(MDFLST(MDLL))
        Q:MDCK>0
        Q:'MDVST
        D ENCEVENT^PXAPI(MDVST) S:$G(MDNCTR)>0 MDCTR=MDNCTR
        S MDPROV=0 F  S MDPROV=$O(^TMP("PXKENC",$J,MDVST,"PRV",MDPROV)) Q:'MDPROV  D
        .Q
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"PRV",MDPROV,0))
        .S CODE=+$P(MDX0,U)
        .I +CODE S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="PRV"_U_CODE_U_U_$$GET1^DIQ(200,+CODE_",",.01,"E")_U_U_($P(MDX0,U,4)="P")
        ;^TMP("MDENC",$J,n)="POV"^ICD9 IEN^ICD9 CODE^provider narrative category^provider narrative (Short Description)^Primary (1=Yes,0=No)
        S MDICD=0 F  S MDICD=$O(^TMP("PXKENC",$J,MDVST,"POV",MDICD)) Q:'MDICD  D
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"POV",MDICD,0)),MDX802=$G(^(802))
        .S CODE=+$G(MDX0,U),GDIAG=$$ICDDX^ICDCODE(CODE,"")
        .S:CODE DIAG=$P(GDIAG,U,2)_U_$P(GDIAG,U,4)
        .S CAT=$P(MDX802,U)
        .S:CAT CAT=$P($G(^AUTNPOV(CAT,0)),U)
        .S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="Diagnosis: "_$P(DIAG,U,2)_" "_$S($P(MDX0,U,12)="P":"Primary",1:"")
        S MDCPT=0 F  S MDCPT=$O(^TMP("PXKENC",$J,MDVST,"CPT",MDCPT)) Q:'MDCPT  D
        .S MDX0=$G(^TMP("PXKENC",$J,MDVST,"CPT",MDCPT,0)),MDX802=$G(^(802))
        .S CODE=+$G(MDX0,U)
        .S:CODE CODE=$$CPT^ICPTCOD(CODE,MDVST)
        .S:CODE DIAG=$P(CODE,U,2,3)
        .S CAT=$P(MDX802,U)
        .S:CAT CAT=$P($G(^AUTNPOV(CAT,0)),U)
        .S QTY=$P(MDX0,U,16)
        .S MDDESC="" D CPTLEX^MDRPCWU(.RESLT,+$G(MDX0,U),"CPT")
        .S MDCLL="" F  S MDCLL=$O(^TMP("MDLEX",$J,MDCLL)) Q:MDCLL<1  S MDDESC=$P(^(MDCLL),"^",3)
        .S:$L(MDDESC)>230 MDDESC=$E(MDDESC,1,230) K ^TMP("MDLEX",$J),RESLT
        .S:MDDESC="" MDDESC=$P(DIAG,U,2)
        .S MDCTR=MDCTR+1,@RESULTS@(MDCTR)="CPT: "_MDDESC_"-"_QTY
        K ^TMP("PXKENC",$J)
        Q
TIMEMET ; Check if appointment time is met
        N MDNOW,MDTIM,MDV
        S MDV=$$GET1^DIQ(702,+MDSTUD_",",.07,"I")
        I $G(MDV)="" S @RESULTS@(0)="-1^No Visit." Q
        I $L(MDV,";")=1 S MDTIM=MDV
        E  S MDTIM=$P(MDV,";",2)
        I 'MDTIM S @RESULTS@(0)="-1^No Visit Date/Time." Q
        D NOW^%DTC S MDNOW=% K %
        I MDNOW<MDTIM S @RESULTS@(0)="0^Appointment/Visit Date/Time not met." Q
        S @RESULTS@(0)="1^Appointment/Visit Date/Time have met."
        Q
