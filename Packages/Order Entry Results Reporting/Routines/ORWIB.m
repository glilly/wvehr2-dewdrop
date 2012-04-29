ORWIB ; SLC/KCM - wrap calls to AISC
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;;Dec 17, 1997
VISIT(LST,CLINIC) ; get list of visit types for clinic
 D GETLST^IBDF18A(CLINIC,"DG SELECT VISIT TYPE CPT PROCEDURES","LST")
 Q
PROC(LST,CLINIC) ; get list of procedures for clinic
 D GETLST^IBDF18A(CLINIC,"DG SELECT CPT PROCEDURE CODES","LST")
 Q
DIAG(LST,CLINIC) ; get list of diagnoses for clinic
 D GETLST^IBDF18A(CLINIC,"DG SELECT ICD-9 DIAGNOSIS CODES","LST")
 Q
EFVPD(LST,CLINIC) ; get list of encounter form elements
 N PFN
 S PFN(1)="DG SELECT VISIT TYPE CPT PROCEDURES"
 S PFN(2)="DG SELECT CPT PROCEDURE CODES"
 S PFN(3)="DG SELECT ICD-9 DIAGNOSIS CODES"
 D GLL^IBDF18A(CLINIC,.PFN,"LST")
 Q
SAVEPCE(OK,ORPXAPI) ; save encounter information
 N PKG,SRC,CODE,IEN,I
 S PKG=$O(^DIC(9.4,"B","ORDER ENTRY/RESULTS REPORTING",0))
 S SRC="TEXT INTEGRATION UTILITIES"
 S I=0 F  S I=$O(ORPXAPI("DX/PL",I)) Q:'I  D      ; ICD codes to ptrs
 . S CODE=ORPXAPI("DX/PL",I,"DIAGNOSIS"),IEN=+$O(^ICD9("AB",CODE_" ",0))
 . I IEN'>0 S IEN=$O(^ICD9("AB",CODE_"0 ",0))  ; do I need this??
 . S ORPXAPI("DX/PL",I,"DIAGNOSIS")=IEN
 S I=0 F  S I=$O(ORPXAPI("PROCEDURE",I)) Q:'I  D  ; CPT codes to ptrs
 . S CODE=ORPXAPI("PROCEDURE",I,"PROCEDURE"),IEN=+$O(^ICPT("B",CODE,0))
 . S ORPXAPI("PROCEDURE",I,"PROCEDURE")=IEN
 S OK=$$DATA2PCE^PXAPI("ORPXAPI",PKG,SRC)
 Q
SCSEL(VAL,DFN,ATM,LOC,VST) ; return SC conditions that may be selected
 ; VAL=SCallow^SCdflt;AOallow^AOdflt;IRallow^IRdflt;ECallow^ECdflt
 N X,S S S=";"
 D SCCOND^PXUTLSCC(DFN,ATM,LOC,$G(VST),.X)
 S VAL=$G(X("SC"))_S_$G(X("AO"))_S_$G(X("IR"))_S_$G(X("EC"))
 Q
SCDIS(LST,DFN) ; Return service connected % and rated disabilities
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
