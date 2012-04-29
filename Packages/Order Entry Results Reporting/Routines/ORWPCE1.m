ORWPCE1 ;SLC/KCM - PCE Calls from CPRS GUI; 10/26/04 ;4/9/08  07:44
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,85,116,132,148,187,190,215,243**;Dec 17, 1997;Build 242
        ;
        ; DBIA 1365   DSELECT^GMPLENFM   ^TMP("IB",$J)
        ;
GETVSIT(VSTR,DFN)       ; lookup a visit
        N PKG,SRC,ORPXAPI,OK,ORVISIT
        S PKG=$O(^DIC(9.4,"B","ORDER ENTRY/RESULTS REPORTING",0))
        S SRC="TEXT INTEGRATION UTILITIES"
        S ORPXAPI("ENCOUNTER",1,"ENC D/T")=$P(VSTR,";",2)
        S ORPXAPI("ENCOUNTER",1,"PATIENT")=DFN
        S ORPXAPI("ENCOUNTER",1,"HOS LOC")=+VSTR
        S ORPXAPI("ENCOUNTER",1,"SERVICE CATEGORY")=$P(VSTR,";",3)
        S ORPXAPI("ENCOUNTER",1,"ENCOUNTER TYPE")="P"
        S OK=$$DATA2PCE^PXAPI("ORPXAPI",PKG,SRC,.ORVISIT)
        Q ORVISIT
DQDEL   ; background call to DATA2PCE and DELVFILE
        N VISIT,VAL
        I $D(ZTQUEUED) S ZTREQ="@"
        S VISIT=$$GETVSIT(VSTR,DFN)
        S VAL=$$DELVFILE^PXAPI("ALL",VISIT,"","TEXT INTEGRATION UTILITIES")
        S ZTSTAT=0  ; clear sync flag
        Q
DQSAVE  ; Background Call to DATA2PCE
        N PKG,SRC,TYP,CODE,IEN,OK,I,X,ORPXAPI,ORPXDEL
        N CAT,NARR,ROOT,ROOT2,ORAVST
        N PRV,CPT,ICD,IMM,SK,PED,HF,XAM,TRT,MOD,MODCNT,MODIDX,MODS
        N COM,COMMENT,COMMENTS
        N DFN,PROBLEMS,PXAPREDT,ORCPTDEL
        I $D(ZTQUEUED) S ZTREQ="@"
        S PKG=$O(^DIC(9.4,"B","ORDER ENTRY/RESULTS REPORTING",0))
        S SRC="TEXT INTEGRATION UTILITIES"
        S (PRV,CPT,ICD,IMM,SK,PED,HF,XAM,TRT)=0
        S I="" F  S I=$O(PCELIST(I)) Q:'I  S X=PCELIST(I) D
        . S X=PCELIST(I),TYP=$P(X,U),CODE=$P(X,U,2),CAT=$P(X,U,3),NARR=$P(X,U,4)
        . I $E(TYP,1,3)="PRV" D  Q
        . . Q:'$L(CODE)
        . . S PRV=PRV+1
        . . S ROOT="ORPXAPI(""PROVIDER"","_PRV_")"
        . . S ROOT2="ORPXDEL(""PROVIDER"","_PRV_")"
        . . I $E(TYP,4)'="-" D
        . . . S @ROOT@("NAME")=CODE
        . . . S @ROOT@("PRIMARY")=$P(X,U,6)
        . . S @ROOT2@("NAME")=CODE
        . . S @ROOT2@("DELETE")=1
        . . S PXAPREDT=1 ;Allow edit of primary flag
        . I TYP="VST" D  Q
        . . S ROOT="ORPXAPI(""ENCOUNTER"",1)"
        . . I CODE="DT" S @ROOT@("ENC D/T")=$P(X,U,3) Q
        . . I CODE="PT" S @ROOT@("PATIENT")=$P(X,U,3),DFN=$P(X,U,3) Q
        . . I CODE="HL" S @ROOT@("HOS LOC")=$P(X,U,3) Q
        . . I CODE="PR" S @ROOT@("PARENT")=$P(X,U,3) Q
        . . ;prevents checkout!
        . . I CODE="VC" S @ROOT@("SERVICE CATEGORY")=$P(X,U,3) Q
        . . I CODE="SC" S @ROOT@("SC")=$P(X,U,3) Q
        . . I CODE="AO" S @ROOT@("AO")=$P(X,U,3) Q
        . . I CODE="IR" S @ROOT@("IR")=$P(X,U,3) Q
        . . I CODE="EC" S @ROOT@("EC")=$P(X,U,3) Q
        . . I CODE="MST" S @ROOT@("MST")=$P(X,U,3) Q
        . . I CODE="HNC" S @ROOT@("HNC")=$P(X,U,3) Q
        . . I CODE="CV" S @ROOT@("CV")=$P(X,U,3) Q
        . . I CODE="SHD" S @ROOT@("SHAD")=$P(X,U,3) Q
        . . I CODE="OL" D  Q
        . . . I +$P(X,U,3) S @ROOT@("INSTITUTION")=$P(X,U,3)
        . . . E  I $P(X,U,4)'="",$P(X,U,4)'="0" D
        . . . . I $$PATCH^XPDUTL("PX*1.0*96") S @ROOT@("OUTSIDE LOCATION")=$P(X,U,4)
        . . . . E  S @ROOT@("COMMENT")="OUTSIDE LOCATION:  "_$P(X,U,4)
        . I $E(TYP,1,3)="CPT" D  Q
        . . Q:'$L(CODE)
        . . S CPT=CPT+1,ROOT="ORPXAPI(""PROCEDURE"","_CPT_")"
        . . S IEN=+$O(^ICPT("B",CODE,0))
        . . S @ROOT@("PROCEDURE")=IEN
        . . I +$P(X,U,9) D
        . . . S MODS=$P(X,U,9),MODCNT=+MODS
        . . . F MODIDX=1:1:MODCNT D
        . . . . S MOD=$P($P(MODS,";",MODIDX+1),"/")
        . . . . S @ROOT@("MODIFIERS",MOD)=""
        . . S:$L(CAT) @ROOT@("CATEGORY")=CAT
        . . S:$L(NARR) @ROOT@("NARRATIVE")=NARR
        . . S:$L($P(X,U,5)) @ROOT@("QTY")=$P(X,U,5)
        . . S:$P(X,U,6)>0 @ROOT@("ENC PROVIDER")=$P(X,U,6)
        . . S:$L($P(X,U,10))>0 COMMENT($P(X,U,10))="PROCEDURE^"_CPT
        . . I $E(TYP,4)="-" S @ROOT@("DELETE")=1,@ROOT@("QTY")=0,ORCPTDEL=CPT
        . I $E(TYP,1,3)="POV" D  Q
        . . Q:'$L(CODE)
        . . S ICD=ICD+1,ROOT="ORPXAPI(""DX/PL"","_ICD_")"
        . . S IEN=+$O(^ICD9("AB",CODE_" ",0))
        . . S @ROOT@("DIAGNOSIS")=IEN
        . . S @ROOT@("PRIMARY")=$P(X,U,5)
        . . S:$L(CAT) @ROOT@("CATEGORY")=CAT
        . . S:$L(NARR) @ROOT@("NARRATIVE")=NARR
        . . S:$P(X,U,6)>0 @ROOT@("ENC PROVIDER")=$P(X,U,6)
        . . I $L($P(X,U,7)),$P(X,U,7)=1 S @ROOT@("PL ADD")=$P(X,U,7),PROBLEMS(ICD)=NARR_U_CODE
        . . S:$L($P(X,U,10))>0 COMMENT($P(X,U,10))="DX/PL^"_ICD
        . . I $E(TYP,4)="-" S @ROOT@("DELETE")=1
        . I $E(TYP,1,3)="IMM" D  Q
        . . Q:'$L(CODE)
        . . S IMM=IMM+1,ROOT="ORPXAPI(""IMMUNIZATION"","_IMM_")"
        . . S @ROOT@("IMMUN")=CODE
        . . S:$L($P(X,U,5)) @ROOT@("SERIES")=$P(X,U,5)
        . . S:$L($P(X,U,5)) @ROOT@("REACTION")=$P(X,U,7)
        . . S:$L($P(X,U,8)) @ROOT@("CONTRAINDICATED")=$P(X,U,8)
        . . S:$L($P(X,U,9)) @ROOT@("REFUSED")=$P(X,U,9)
        . . S:$P(X,U,6)>0 @ROOT@("ENC PROVIDER")=$P(X,U,6)
        . . S:$L($P(X,U,10))>0 COMMENT($P(X,U,10))="IMMUNIZATION^"_IMM
        . . I $E(TYP,4)="-" S @ROOT@("DELETE")=1
        . I $E(TYP,1,2)="SK" D  Q
        . . Q:'$L(CODE)
        . . S SK=SK+1,ROOT="ORPXAPI(""SKIN TEST"","_SK_")"
        . . S @ROOT@("TEST")=CODE
        . . S:$L($P(X,U,5)) @ROOT@("RESULT")=$P(X,U,5)
        . . S:$L($P(X,U,7)) @ROOT@("READING")=$P(X,U,7)
        . . S:$L($P(X,U,8)) @ROOT@("D/T READ")=$P(X,U,8)
        . . S:$L($P(X,U,9)) @ROOT@("EVENT D/T")=$P(X,U,9)
        . . S:$P(X,U,6)>0 @ROOT@("ENC PROVIDER")=$P(X,U,6)
        . . S:$L($P(X,U,10))>0 COMMENT($P(X,U,10))="SKIN TEST^"_SK
        . . I $E(TYP,3)="-" S @ROOT@("DELETE")=1
        . I $E(TYP,1,3)="PED" D  Q
        . . Q:'$L(CODE)
        . . S PED=PED+1,ROOT="ORPXAPI(""PATIENT ED"","_PED_")"
        . . S @ROOT@("TOPIC")=CODE
        . . S:$L($P(X,U,5)) @ROOT@("UNDERSTANDING")=$P(X,U,5)
        . . S:$P(X,U,6)>0 @ROOT@("ENC PROVIDER")=$P(X,U,6)
        . . S:$L($P(X,U,10))>0 COMMENT($P(X,U,10))="PATIENT ED^"_PED
        . . I $E(TYP,4)="-" S @ROOT@("DELETE")=1
        . I $E(TYP,1,2)="HF" D  Q
        . . Q:'$L(CODE)
        . . S HF=HF+1,ROOT="ORPXAPI(""HEALTH FACTOR"","_HF_")"
        . . S @ROOT@("HEALTH FACTOR")=CODE
        . . S:$L($P(X,U,5)) @ROOT@("LEVEL/SEVERITY")=$P(X,U,5)
        . . S:$P(X,U,6)'>0 $P(X,U,6)=$G(ORPXAPI("PROVIDER",1,"NAME"))
        . . S:$P(X,U,6)>0 @ROOT@("ENC PROVIDER")=$P(X,U,6)
        . . S:$L($P(X,U,11)) @ROOT@("EVENT D/T")=$P($P(X,U,11),";",1)
        . . S:$L($P(X,U,11)) SRC=$P($P(X,U,11),";",2)
        . . S:$L($P(X,U,10))>0 COMMENT($P(X,U,10))="HEALTH FACTOR^"_HF
        . . I $E(TYP,3)="-" S @ROOT@("DELETE")=1
        . I $E(TYP,1,3)="XAM" D  Q
        . . Q:'$L(CODE)
        . . S XAM=XAM+1,ROOT="ORPXAPI(""EXAM"","_XAM_")"
        . . S @ROOT@("EXAM")=CODE
        . . S:$L($P(X,U,5)) @ROOT@("RESULT")=$P(X,U,5)
        . . S:$P(X,U,6)>0 @ROOT@("ENC PROVIDER")=$P(X,U,6)
        . . S:$L($P(X,U,10))>0 COMMENT($P(X,U,10))="EXAM^"_XAM
        . . I $E(TYP,4)="-" S @ROOT@("DELETE")=1
        . I $E(TYP,1,3)="TRT" D  Q
        . . Q:'$L(CODE)
        . . S TRT=TRT+1,ROOT="ORPXAPI(""TREATMENT"","_TRT_")"
        . . S @ROOT@("IMMUN")=CODE
        . . S:$L(CAT) @ROOT@("CATEGORY")=CAT
        . . S:$L(NARR) @ROOT@("NARRATIVE")=NARR
        . . S:$L($P(X,U,5)) @ROOT@("QTY")=$P(X,U,5)
        . . S:$P(X,U,6)>0 @ROOT@("ENC PROVIDER")=$P(X,U,6)
        . . S:$L($P(X,U,10))>0 COMMENT($P(X,U,10))="TREATMENT^"_TRT
        . . I $E(TYP,4)="-" S @ROOT@("DELETE")=1,@ROOT@("QTY")=0
        . I $E(TYP,1,3)="COM" D  Q
        . . Q:'$L(CODE)
        . . Q:'$L(CAT)
        . . S COMMENTS(CODE)=$P(X,U,3,999)
        ;Store the comments
        S COM=""
        F  S COM=$O(COMMENT(COM)) Q:COM=""  S:$D(COMMENTS(COM)) ORPXAPI($P(COMMENT(COM),"^",1),$P(COMMENT(COM),"^",2),"COMMENT")=COMMENTS(COM)
        ;
        ;Remove any problems to add that the patient already has as active problems
        I $D(PROBLEMS),$D(DFN) D
        . N ORWPROB,ORPROBIX
        . K ^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS")
        . D DSELECT^GMPLENFM  ;DBIA 1365
        . S ORPROBIX=0
        . F  S ORPROBIX=$O(^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORPROBIX)) Q:'ORPROBIX  D  ;DBIA 1365
        .. S ORWPROB=$P(^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORPROBIX),"^",2,3)
        .. S ORWPROB($S($E(ORWPROB,1)="$":$E(ORWPROB,2,255),1:ORWPROB))=""
        . K ^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS")
        . Q:'$D(ORWPROB)
        . S ORPROBIX=""
        . F  S ORPROBIX=$O(PROBLEMS(ORPROBIX)) Q:'ORPROBIX  D
        .. S:$D(ORWPROB(PROBLEMS(ORPROBIX))) ORPXAPI("DX/PL",ORPROBIX,"PL ADD")=0
        ;
        I $$MDS(.ORPXAPI,$G(ORLOC)) S ORPXAPI("ENCOUNTER",1,"CHECKOUT D/T")=$$NOW^XLFDT
        S ORPXAPI("ENCOUNTER",1,"ENCOUNTER TYPE")="P"
DATA2PCE        ;
        I $G(PXAPREDT)!($G(ORCPTDEL)) D
        . M ORPXDEL("ENCOUNTER")=ORPXAPI("ENCOUNTER")
        . I $G(ORCPTDEL) M ORPXDEL("PROCEDURE",ORCPTDEL)=ORPXAPI("PROCEDURE",ORCPTDEL)
        . S OK=$$DATA2PCE^PXAPI("ORPXDEL",PKG,SRC,.ORAVST)
        S OK=$$DATA2PCE^PXAPI("ORPXAPI",PKG,SRC,.ORAVST)
        I OK>0,+NOTEIEN,+ORAVST D  ; NOTEIEN only set on inpatient encounters
        .N OROK,ORX
        .S ORX(1207)=ORAVST
        .D FILE^TIUSRVP(.OROK,NOTEIEN,.ORX,1)
        S ZTSTAT=0  ; clear sync flag
        Q
        ;
MDS(X,ORLOC)    ; return TRUE if checkout is needed
        I $$CHKOUT^ORWPCE2(ORLOC) Q 1
        N I,ORAUTO,OROK
        S (OROK,I)=0
        F  S I=$O(X("DX/PL",I)) Q:'I  D  Q:OROK
        . I $G(X("DX/PL",I,"DIAGNOSIS")) S OROK=1
        I 'OROK D
        .S I=0 F  S I=$O(X("PROCEDURE",I)) Q:'I  D  Q:OROK
        .. I $G(X("PROCEDURE",I,"PROCEDURE")) S OROK=1
        I $D(X("PROVIDER",1,"NAME")) S OROK=1
        Q OROK
NONCOUNT(ORY,ORLOC)     ;  Is the location a non-count clinic? (DBIA #964)
        Q:'ORLOC
        S ORY=$S($P($G(^SC(ORLOC,0)),U,17)="Y":1,1:0)
        Q
