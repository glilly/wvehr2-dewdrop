ORWPCE  ; SLC/JM/REV - wrap calls to PCE and AICS;04/01/2003 ;09/15/08
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,85,116,173,190,195,215,243,295**;Dec 17, 1997;Build 63
        ;
        ; DBIA 2950   LOOK^LEXA          ^TMP("LEXFND",$J)
        ; DBIA 1609   CONFIG^LEXSET      ^TMP("LEXSCH",$J)
        ; DBIA 1365   DSELECT^GMPLENFM   ^TMP("IB",$J)
        ; DBIA 3991   $$STATCHK^ICDAPIU
        ; 
        Q
VISIT(LST,CLINIC,ORDATE)        ; get list of visit types for clinic
        S:'+$G(ORDATE) ORDATE=DT
        D GETLST^IBDF18A(CLINIC,"DG SELECT VISIT TYPE CPT PROCEDURES","LST",,,,ORDATE)
        Q
PROC(LST,CLINIC,ORDATE) ; get list of procedures for clinic P12 for CPTMods
        S:'+$G(ORDATE) ORDATE=DT
        D GETLST^IBDF18A(CLINIC,"DG SELECT CPT PROCEDURE CODES","LST",,,1,ORDATE)
        N IDX,MOD,CODES,FIRST S IDX=0
        F  S IDX=$O(LST(IDX)) Q:'+IDX  D
        . I LST(IDX)="" K LST(IDX) Q
        . S MOD=0,CODES="",FIRST=1
        . F  S MOD=$O(LST(IDX,"MODIFIER",MOD)) Q:(MOD="")  D
        . . I FIRST S FIRST=0
        . . E  S CODES=CODES_";"
        . . S CODES=CODES_LST(IDX,"MODIFIER",MOD)
        . K LST(IDX,"MODIFIER")
        . I 'FIRST S $P(LST(IDX),U,12)=CODES
        Q
CPTMODS(LST,ORCPTCOD,ORDATE)    ;Return CPT Modifiers for a CPT Code
        N ORM,ORIDX,ORI,MODNAME
        S:'+$G(ORDATE) ORDATE=DT
        I +($$CODM^ICPTCOD(ORCPTCOD,$NA(ORM),0,ORDATE)),+$D(ORM) D
        . S ORIDX="",ORI=0
        . F  S ORIDX=$O(ORM(ORIDX)) Q:(ORIDX="")  D
        . . S ORI=ORI+1,MODNAME=$P(ORM(ORIDX),U,1)
        . . S LST(MODNAME_ORI)=$P(ORM(ORIDX),U,2)_U_MODNAME_U_ORIDX
        Q
GETMOD(MODINFO,ORMODIEN,ORDATE) ;Returns info for a specific CPT Modifier
        N ORDATA
        S:'+$G(ORDATE) ORDATE=DT
        S ORDATA=$$MOD^ICPTMOD(ORMODIEN,"I",ORDATE,1)
        I +ORDATA>0 S MODINFO=ORMODIEN_U_$P(ORDATA,U,3)_U_$P(ORDATA,U,2)
        Q
DIAG(LST,CLINIC,ORDATE) ; get list of diagnoses for clinic
        S:'+$G(ORDATE) ORDATE=DT
        D GETLST^IBDF18A(CLINIC,"DG SELECT ICD-9 DIAGNOSIS CODES","LST",,,,ORDATE)
        Q
IMM(LST,CLINIC) ;get list of immunizations for clinic
        D GETLST^IBDF18A(CLINIC,"PX SELECT IMMUNIZATIONS","LST")
        Q
SK(LST,CLINIC)  ;get list of skin test for clinic
        D GETLST^IBDF18A(CLINIC,"PX SELECT SKIN TESTS","LST")
        Q
HF(LST,CLINIC)  ;get list of health factors for clinic
        D GETLST^IBDF18A(CLINIC,"PX SELECT HEALTH FACTORS","LST")
        Q
PED(LST,CLINIC) ;get list of education topices for clinic
        D GETLST^IBDF18A(CLINIC,"PX SELECT EDUCATION TOPICS","LST")
        Q
TRT(LST,CLINIC) ;get list of treatments for clinic
        D GETLST^IBDF18A(CLINIC,"PX SELECT TREATMENTS","LST")
        Q
XAM(LST,CLINIC) ;get list of exams for clinic
        D GETLST^IBDF18A(CLINIC,"PX SELECT EXAMS","LST")
        Q
ACTPROB(GLST,DFN,ORDATE)        ;get list of patient's active problems
        K ^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS")
        S:'+$G(ORDATE) ORDATE=DT
        D DSELECT^GMPLENFM  ;DBIA 1365
        N ORPROB,ORPROBIX,ORPRCNT
        S ORPRCNT=0
        S ORPROBIX=0
        F  S ORPROBIX=$O(^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORPROBIX)) Q:'ORPROBIX  D  ;DBIA 1365
        . S ORPROB=$P(^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORPROBIX),"^",2,3)
        . I $E(ORPROB,1)="$" S ORPROB=$E(ORPROB,2,255)
        . I '$D(ORPROB(ORPROB)) D
        .. S ORPROB(ORPROB)=""
        .. S ORPRCNT=ORPRCNT+1
        .. S $P(^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORPROBIX),"^",2,3)=ORPROB
        . E  K ^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORPROBIX)
        ; DBIA   10082     NAME: ICD DIAGNOSIS FILE
        N ORWINDEX,ORITEM
        S ORWINDEX=0
        F  S ORWINDEX=$O(^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORWINDEX)) Q:'ORWINDEX  D:$P(^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORWINDEX),"^",1)]""
        . S ORITEM=^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORWINDEX)
        . I '+$$STATCHK^ICDAPIU($P(ORITEM,"^",3),ORDATE) S $P(ORITEM,"^",11)="#"  ;DBIA 3991
        . S ^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",ORWINDEX)=ORITEM
        S ^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",0)=ORPRCNT
        S GLST="^TMP(""IB"","_$J_",""INTERFACES"",""GMP SELECT PATIENT ACTIVE PROBLEMS"")"
        Q
SCSEL(VAL,DFN,ATM,LOC,VST)      ; return SC conditions that may be selected
        ; VAL=SCallow^SCdflt;AOallow^AOdflt;IRallow^IRdflt;ECallow^ECdflt;
        ;     MSTallow^MSTdflt;HNCallow^HNCdflt;CVAllow^CVDflt;SHADAllow^SHADDflt
        N ORX,S S S=";"
        D SCCOND^PXUTLSCC(DFN,ATM,LOC,$G(VST),.ORX)
        S VAL=$G(ORX("SC"))_S_$G(ORX("AO"))_S_$G(ORX("IR"))_S_$G(ORX("EC"))_S_$G(ORX("MST"))_S_$G(ORX("HNC"))_S_$G(ORX("CV"))_S_$G(ORX("SHAD"))
        Q
SCDIS(LST,DFN)  ; Return service connected % and rated disabilities
        N VAEL,VAERR,I,ILST,DIS,SC,X
        D ELIG^VADPT
        S LST(1)="Service Connected: "_$S(+VAEL(3):$P(VAEL(3),U,2)_"%",1:"NO")
        I 'VAEL(4),'$P($G(^DG(391,+VAEL(6),0)),U,2) S LST(2)="NOT A VETERAN." Q
        S I=0,ILST=1 F  S I=$O(^DPT(DFN,.372,I)) Q:'I  S X=^(I,0) D
        . S DIS=$P($G(^DIC(31,+X,0)),U) Q:DIS=""
        . S SC=$S($P(X,U,3):"SC",$P(X,U,3)']"":"not specified",1:"NSC")
        . S ILST=ILST+1,LST(ILST)=DIS_" ("_$P(X,U,2)_"% "_SC_")"
        I ILST=1 S LST(2)="Rated Disabilities: NONE STATED"
        Q
CPTREQD(VAL,IEN)        ; return 1 in VAL if note still needs a CPT code
        S VAL=+$P(^TIU(8925,IEN,0),U,11)
        Q
NOTEVSTR(VAL,IEN)       ; return the VSTR^AUTHOR for a note
        N X0,X12,VISIT
        S X0=$G(^TIU(8925,+IEN,0)),X12=$G(^(12)),VISIT=$P(X12,U,7)
        I +VISIT S VAL=$$VSTRBLD^TIUSRVP(VISIT) I 1
        E  S VAL=$P(X12,U,11)_";"_$P(X0,U,7)_";"_$P(X0,U,13)
        Q
HASVISIT(ORY,IEN,DFN,ORLOC,ORDTE)       ;Has visit or is stand alone
        N ORVISIT
        S ORY=-1
        I +$G(IEN)>0 S ORVISIT=+$P($G(^TIU(8925,+IEN,0)),U,3)
        I +$G(ORVISIT)'>0 S ORVISIT=$$GETENC^PXAPI(DFN,ORDTE,ORLOC)
        I +$G(ORVISIT)>0 S ORY=$$VST2APPT^PXAPI(ORVISIT)
        Q
DELETE(VAL,VSTR,DFN)    ; delete PCE info when deleting a note
        N VISIT,ORCOUNT,ORLOC,ORDTE
        N ZTIO,ZTRTN,ZTDTH,ZTSAVE,ZTDESC,ZTSYNC,ZTSK
        S ORLOC=$P(VSTR,";"),ORDTE=$P(VSTR,";",2)
        I '$D(^TMP("ORWPCE",$J,VSTR))&('$$GETENC^PXAPI(DFN,ORDTE,ORLOC)) S VAL=0 Q  ; no PCE data saved yet
        I $P(VSTR,";",3)="H" S VAL=0 Q           ; leave inpatient alone
        I $L($T(DOCCNT^TIUSRVLV))=0 S VAL=0 Q    ; leave if no tiu entry point
        D DOCCNT^TIUSRVLV(.ORCOUNT,DFN,VSTR)     ; Do not delete if another
        I ORCOUNT>0 S VAL=0 Q                    ; title points to visit
        S ZTIO="ORW/PXAPI RESOURCE",ZTRTN="DQDEL^ORWPCE1",ZTDTH=$H
        S (ZTSAVE("VSTR"),ZTSAVE("DFN"))="",ZTDESC="CPRS Delete Note/PCE"
        S ZTSYNC="ORW"_VSTR
        D ^%ZTLOAD I '$D(ZTSK) D DQDEL^ORWPCE1
        Q
SAVE(OK,PCELIST,NOTEIEN,ORLOC)  ; save PCE information
        N VSTR,GMPLUSER
        N ZTIO,ZTRTN,ZTDTH,ZTSAVE,ZTDESC,ZTSYNC,ZTSK
        S VSTR=$P(PCELIST(1),U,4) K ^TMP("ORWPCE",$J,VSTR)
        M ^TMP("ORWPCE",$J,VSTR)=PCELIST
        S GMPLUSER=$$CLINUSER^ORQQPL1(DUZ),NOTEIEN=+$G(NOTEIEN)
        S ZTIO="ORW/PXAPI RESOURCE",ZTRTN="DQSAVE^ORWPCE1",ZTDTH=$H
        S ZTSAVE("PCELIST(")="",ZTDESC="Data from CPRS to PCE"
        S ZTSAVE("GMPLUSER")="",ZTSAVE("NOTEIEN")="",ZTSAVE("DUZ")=""
        I VSTR'["E" S ZTSYNC="ORW"_VSTR
        S ZTSAVE("ORLOC")=""
        D ^%ZTLOAD I '$D(ZTSK) D DQSAVE^ORWPCE1
        Q
LEX(LST,X,APP,ORDATE)     ; return list after lexicon lookup
        N LEX,ILST,I,IEN
        S:APP="CPT" APP="CHP" ; LEX PATCH 10
        S:'+$G(ORDATE) ORDATE=DT
        D CONFIG^LEXSET(APP,APP,ORDATE)  ;DBIA 1609
        I APP="CHP" D
        . ; Set the filter for CPT only using CS APIs - format is the same as for DIC("S")
        . S ^TMP("LEXSCH",$J,"FIL",0)="I $L($$CPTONE^LEXU(+Y,$G(ORDATE)))!($L($$CPCONE^LEXU(+Y,$G(ORDATE))))"  ;DBIA 1609
        . ; Set Applications Default Flag (Lexicon can not overwrite filter)
        . S ^TMP("LEXSCH",$J,"ADF",0)=1
        D LOOK^LEXA(X,APP,1,"",ORDATE)
        I '$D(LEX("LIST",1)) S LST(1)="-1^No matches found." Q
        S LST(1)=LEX("LIST",1),ILST=1
        S (I,IEN)=""
        F  S I=$O(^TMP("LEXFND",$J,I)) Q:I=""  D  ;DBIA 2950
        .F  S IEN=$O(^TMP("LEXFND",$J,I,IEN)) Q:IEN=""  D
        ..S ILST=ILST+1,LST(ILST)=IEN_U_^TMP("LEXFND",$J,I,IEN)
        K ^TMP("LEXFND",$J),^TMP("LEXHIT",$J),^TMP("LEXSCH",$J)
        Q
LEXCODE(VAL,IEN,APP,ORDATE)         ; return code for a lexicon entry
        S VAL=""
        S:'+$G(ORDATE) ORDATE=DT
        I APP="ICD" S VAL=$$ICDONE^LEXU(IEN,ORDATE)
        I APP="CPT"!(APP="CHP") S VAL=$$CPTONE^LEXU(IEN,ORDATE) ; LEX PATCH 10
        I VAL="",(APP="CHP") S VAL=$$CPCONE^LEXU(IEN,ORDATE) ; LEX PATCH 10
        Q
ADDRES  ; Add the ORW/PXAPI RESOURCE device
        N X
        S X=$$RES^XUDHSET("ORW/PXAPI RESOURCE",,5,"CPRS to PCE transactions")
        Q
GETSVC(NEWSVC,SVC,LOC,INP)      ; Returns the correct Service Connected Category
        N DSS,ORWSVC
        S DSS=$P($G(^SC(+LOC,0)),U,7)
        Q:'+DSS
        M ORWSVC=SVC
        S NEWSVC=$$SVC^PXKCO(.ORWSVC,DSS,INP,LOC) ; DBIA #3225
        Q
