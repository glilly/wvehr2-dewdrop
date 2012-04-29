MAGJUTL4        ;WIRMFO/JHC VistARad subroutines for RPC calls ; 15 Jul 2004  4:34 PM
        ;;3.0;IMAGING;**18,76**;Jun 22, 2007;Build 19
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;; +---------------------------------------------------------------+
        ;; | Property of the US Government.                                |
        ;; | No permission to copy or redistribute this software is given. |
        ;; | Use of unreleased versions of this software requires the user |
        ;; | to execute a written test agreement with the VistA Imaging    |
        ;; | Development Office of the Department of Veterans Affairs,     |
        ;; | telephone (301) 734-0100.                                     |
        ;; |                                                               |
        ;; | The Food and Drug Administration classifies this software as  |
        ;; | a medical device.  As such, it may not be changed in any way. |
        ;; | Modifications to this software may result in an adulterated   |
        ;; | medical device under 21CFR820, the use of which is considered |
        ;; | to be a violation of US Federal Statutes.                     |
        ;; +---------------------------------------------------------------+
        ;;
        Q
        ;
CPTGRP(MAGGRY,DATA)     ; RPC: MAGJ CPTMATCH
        ; FOR INPUT cpt code, return matching cpt's based on grouping criteria:
        ; INPUT in DATA: CPT Code ^ Criteria
        ; Criteria:
        ;   1=Matching cpt
        ;   2=Body Part
        ;   3=Body Part & Modality
        ;  10=Same CPT (used to return short description only)
        ; Return: List of CPTs with Short Name:  CPT ^ Short Name
        ; MAGGRY holds $NA reference to ^TMP for rpc return
        ;   all ref's to MAGGRY use subscript indirection
        ;
        N $ETRAP,$ESTACK S $ETRAP="G ERR1^MAGJUTL4"
        N REPLY,DIQUIET,CPT,CRIT,CT,MAGLST,NOD,NODLST
        N MATCHGRP,INDXLST,AND,RET,CPTGLB,CPTIN,CPTIEN,TCPT
        ;
        ; <*> Issue: Unable get specific body part for some non-specific CPTs (e.g., 75774-ANGIO SELECT EA ADD VESSEL-S)
        ;         --> For these, could just return matching CPTs (or equivalent CPT?)
        ;
        ; Produce List of cptiens for each INDX of interest
        ; AND with next list of cptiens; repeat until no more INDXs
        ; build output list of CPT codes (w/ short names [optional])
        S DIQUIET=1 D DT^DICRW
        S CT=0,MAGLST="MAGJCPT"
        K MAGGRY S MAGGRY=$NA(^TMP($J,MAGLST)) K @MAGGRY  ; assign MAGGRY value
        S CPTIN=$P(DATA,U),CRIT=$P(DATA,U,2)
        S REPLY="0^Getting matching CPT info."
        S:'CRIT CRIT=1 ; default equivalent
        I CPTIN="" S REPLY="0^Invalid CPT code ("_DATA_")." G CPTGRPZ
        I '(CRIT=1!(CRIT=2)!(CRIT=3)!(CRIT=10)) S REPLY="0^Invalid criteria ("_DATA_")." G CPTGRPZ
        S CPTGLB=$NA(^MAG(2006.67))
        S CPTIEN=$O(@CPTGLB@("B",CPTIN,""))
        I 'CPTIEN S REPLY="0^Input CPT code ("_CPTIN_") not defined in CPT Match table." G CPTGRPZ
        S X=@CPTGLB@(CPTIEN,0),MATCHGRP=+$P(X,U,4)
        ;CPTMATCH^BODYPART^MDL
        I CRIT=2!(CRIT=3) D
        . S X=0 F  S X=$O(@CPTGLB@(CPTIEN,1,"B",X)) Q:'X  D GETCPTS("BODYPART",X,"",.RET)
        . I CRIT=3 D
        . . M AND=RET K RET S X=0
        . . F  S X=$O(@CPTGLB@(CPTIEN,2,"B",X)) Q:'X  D GETCPTS("MDL",X,.AND,.RET)
        I CRIT=1 D
        . I MATCHGRP,(MATCHGRP'=CPTIEN) S RET(MATCHGRP)="" D GETCPTS("CPTMATCH",MATCHGRP,"",.RET)
        . D GETCPTS("CPTMATCH",CPTIEN,"",.RET)
        I CRIT=10 ; fall through answers this!
        I '$D(RET(CPTIEN)) S RET(CPTIEN)="" ; always report back input cpt
        S IEN=0 F  S IEN=$O(RET(IEN)) Q:'IEN  D
        . N LIN S X=$G(@CPTGLB@(IEN,0))
        . Q:'(X]"")  S TCPT=$P(X,U),LIN=TCPT_U_$P($$CPT^ICPTCOD(TCPT),U,3) ; _U_$$BODPART(IEN,"~")_U_$$MDLLST(IEN,"~")
        . S CT=CT+1,@MAGGRY@(CT)=LIN
        S REPLY=CT_U_"1~ "_CT_" CPT Matches returned for "_CPTIN
CPTGRPZ ;
        S @MAGGRY@(0)=REPLY
        Q
        ;
GETCPTS(INDEX,VALUE,AND,OUT)    ; return a list of CPTIENS in OUT
        ; if array AND is defined, reply only values contained in AND &  the index
        N X,GLBREF,CPTIEN
        S GLBREF=$NA(@CPTGLB@(INDEX,VALUE))
        S CPTIEN=0
        I $D(AND)>9 D
        . F  S CPTIEN=$O(AND(CPTIEN)) Q:CPTIEN=""  I $D(@GLBREF@(CPTIEN)) S OUT(CPTIEN)=""
        E  F  S CPTIEN=$O(@GLBREF@(CPTIEN)) Q:'CPTIEN  D
        . S OUT(CPTIEN)=""
        Q
        ;
BODPART(CPTIEN,DLM)     ; return DLM-delimited list of body part values for this CPT
        I +$G(CPTIEN)
        E  Q ""
        N LIST,CPTGLB S LIST=""
        S DLM=$E($G(DLM))
        I DLM="" S DLM="^"
        S CPTGLB=$NA(^MAG(2006.67))
        S NOD=0
        F  S NOD=$O(@CPTGLB@(CPTIEN,1,NOD)) Q:'NOD  S X=$P(^(NOD,0),U) I X]"" S LIST=LIST_DLM_X
        Q:$Q $E(LIST,2,999)  Q
        ;
MDLLST(CPTIEN,DLM)      ; return DLM-delimited list of modality values for this CPT
        I +$G(CPTIEN)
        E  Q ""
        N LIST,CPTGLB S LIST=""
        S DLM=$E($G(DLM))
        I DLM="" S DLM="^"
        S CPTGLB=$NA(^MAG(2006.67))
        S NOD=0
        F  S NOD=$O(@CPTGLB@(CPTIEN,2,NOD)) Q:'NOD  S X=$P(^(NOD,0),U) I X]"" S LIST=LIST_DLM_X
        Q:$Q $E(LIST,2,999)  Q
        ;
STATCHK(MAGGRY,DATA)    ;
        ; RPC: MAGJ RADSTATUSCHECK
        ; This may also be accessed by subroutine call. <*> do not change name of EP
        ; Exam Status check RPC and subroutine: determine if the exam has been Tech-Verified (at least).
        ; Images are assumed to be verified if Exam Status is Examined, or higher status.
        ;       ; Input in DATA: RADFN^RADTI^RACNI^RARPT
        ;   Input is either RADFN, RADTI, and RACNI; or, RARPT only may be input in piece 4
        ;   Return: Code^Text
        ;    0 = Problem, or exam was cancelled
        ;    1 = Not yet verified
        ;    2 = Tech Verified
        ;    3 = Radiologist Verified
        ;    4 = User is a Radiology professional--always allow access
        ;
        N $ETRAP,$ESTACK S $ETRAP="G ERR3^MAGJUTL4"
        N REPLY,STATUS,ORDER,VCAT,STOUT
        N DIQUIET,RARPT,RADFN,RADTI,RACNI
        S DIQUIET=1 D DT^DICRW
        S RADFN=$P(DATA,U),RADTI=$P(DATA,U,2),RACNI=$P(DATA,U,3),RARPT=$P(DATA,U,4)
        S STOUT="",REPLY="0^Getting image verification status."
        I RADFN,RADTI,RACNI
        E  I RARPT D RPT2DPT(RARPT,.X) I X S RADFN=+X,RADTI=$P(X,U,2),RACNI=$P(X,U,3) I RADFN,RADTI,RACNI
        E  S REPLY="0^Image Verification Status request contains invalid case pointer ("_DATA_")" G STATCHKZ
        S STATUS=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),U,3)
        I STATUS="" S REPLY="0^Image Verification Status request error--no Exam Status is defined for ("_DATA_")" G STATCHKZ
        S VCAT=$P(^RA(72,STATUS,0),U,9),ORDER=$P(^(0),U,3)
        I VCAT]"" D  G STATCHK2:STOUT
        . I "EDT"[VCAT S STOUT=$S(VCAT="E":2,1:3) ; Examined or Interpreted
        . E  I VCAT="W" S STOUT=1 ; Not yet Verified
        I ORDER=9 S STOUT=3  ; Completed exam
        E  I ORDER=0 S REPLY="0^Exam Cancelled"
        E  I ORDER=1 S STOUT=1  ; Waiting for exam
STATCHK2        ;
        I STOUT<2 D
        . F X="S","R","T" I $D(^VA(200,"ARC",X,DUZ)) S STOUT=4 Q  ; Radiologist or Tech -- OK to access
STATCHKZ        ;
        I STOUT S REPLY=STOUT_U_$S(STOUT=1:"Images not yet verified",STOUT=2:"Images verified by Technologist",STOUT=3:"Images interpreted by Radiologist",STOUT=4:"Radiology professional--OK to view images.",1:"")
        S MAGGRY=REPLY
        Q
        ;
REMSCRN(MAGGRY,DATA)    ; User set/clear flag to show/not show remote exams only
        ; RPC: MAGJ REMOTESCREEN
        ;       ; Input in DATA: 1/0 1=show remote only; 0=show all exams
        ;   Return: Reply^Code~msg
        ;    Reply -- 0=Problem; 1=Success
        ;    Code -- 4=Error; 1=ok
        ;    msg -- display text if error
        ;
        N $ETRAP,$ESTACK S $ETRAP="G ERR3^MAGJUTL4"
        N REPLY
        N DIQUIET S DIQUIET=1 D DT^DICRW
        I $D(DATA),(DATA=0!(DATA=1))
        E  S REPLY="0^4~REMOTESCREEN request has invalid parameter ("_$G(DATA)_")" G REMSCRNZ
        S MAGJOB("REMOTESCREEN")=DATA,REPLY="1^1~"_DATA
REMSCRNZ        ;
        S MAGGRY=REPLY
        Q
        ;
RPT2DPT(RARPT,RET)      ; Input RARPT. Return RET containing exam ss values for ^RADPT
        ;
        N DFN,DTI,CNI S (DFN,DTI,CNI)=""
        I RARPT?1N.N,$D(^RARPT(RARPT)) S X=$G(^(RARPT,0)) I X]"" D
        . S X=$P(X,U)
        . S X=$O(^RADPT("ADC",X,0)) I X S DFN=X,DTI=$O(^(X,0)),CNI=$O(^(DTI,0))
        . S RET=DFN_U_DTI_U_CNI
        E  S RET=""
        Q
        ;
ERR1    N ERR S ERR=$$EC^%ZOSV S @MAGGRY@(0)="0^4~"_ERR G ERR
ERR3    N ERR S ERR=$$EC^%ZOSV S MAGGRY="0^4~"_ERR
ERR     D @^%ZOSF("ERRTN")
        Q:$Q 1  Q
        ;
END     Q  ;
