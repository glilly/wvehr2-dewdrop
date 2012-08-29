MAGJLST1        ;WIRMFO/JHC VistARad RPC calls ; 29 Jul 2003  10:01 AM
        ;;3.0;IMAGING;**16,22,18,65,76**;Jun 22, 2007;Build 19
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
        ; Subroutines for fetching Exam Info for Radiology Workstation
        ; Exam listings:
        ;     PTLIST -- list subset of all exams for a patient
        ;        RPC Call: MAGJ PTRADEXAMS
        ;   PTLSTALL -- list ALL exams for a patient
        ;       RPC Call: MAGJ PT ALL EXAMS
        ;
        Q
ERR     N ERR S ERR=$$EC^%ZOSV S ^TMP($J,"RET",0)="0^4~"_ERR
        S MAGGRY=$NA(^TMP($J,"RET"))
        D @^%ZOSF("ERRTN")
        Q:$Q 1  Q
        ;
PTLSTALL(MAGGRY,DATA)   ; List ALL exams for a patient
        ;  RPC is MAGJ PT ALL EXAMS
        N PARAM
        I MAGJOB("P32") S PARAM="^99^999"
        E  S PARAM="^^^"_$P(DATA,U,2,3)
        D PTLIST(.MAGGRY,$P(DATA,U)_PARAM)
        Q
        ;
PTLIST(MAGGRY,DATA)     ; get list of exams for a patient
        ; 
        ; MAGGRY - indirect reference to return array of exams for a patient
        ; DATA   - DFN ^ LIMYEARS ^ LIMEXAMS ^ BEGDT ^ ONESHOT
        ;   DFN--Patient's DFN
        ;   LIMYRS--Restrict exams up to # Years back (defunct)
        ;   LIMEXAMS--Restrict exams up to # of exams
        ;   BEGDT--Begin date for exam fetch (Patch 18 addition--see below)
        ;   ONESHOT--Number days back to search, in one fell swoop
        ; Returns data in ^TMP($J,"MAGRAEX",0:n)
        ; RPC Call: MAGJ PTRADEXAMS
        ;
        ; Patch 18 eliminates "Patient Exams" / "All Patient Exams" distinction.
        ; It always retrieves ALL exams, but uses multiple RPC calls, so the client
        ; incrementally builds the list; this is to provide all the data, but without
        ; incurring any long pauses to provide the info to the user.
        ; Below, the P18 code fetches RAD data in one-year chunks, and repeats
        ;   until over 20 exams have been processed, at which point the RPC reply
        ;   is posted, along with the last date processed; this value is then used for
        ;   a subsequent RPC call to get the next chunk of the record; etc. till all done.
        ;   The P32 code is re-organized, and now exits only for LIMEXAMS (ignore LimYears)
        ;   
        N CNT,DFN,ISS,PATNAME,DIQUIET,MAGRACNT,MAGRET,REPLY,REMOTE,SNDREMOT
        N DAYCASE,DIV,EXCAT,MAGDT,XX,XX2,WHOLOCK,MODALITY,MYLOCK,PLACE,ENDLOOP
        N LIMEXAMS,BEGDT,SAVBEGDT,ENDDT,MORE,SHOWPLAC,RDRIST,PSSN,CPT,PARAM
        N CURPRIO,STATUS,RARPT,KEY,X2,REMOTE2,ONESHOT,LIMDAYS
        N IMGCNT,LRFLAG,MSG,ONL,PROCMOD,RASTCAT,RASTORD
        N $ETRAP,$ESTACK S $ETRAP="D ERR^MAGJLST1"
        S DIQUIET=1 D DT^DICRW
        S PARAM=$G(^MAG(2006.69,1,0))
        S SNDREMOT=+$P(PARAM,U,11) ; Site routes images remotely?
        I MAGJOB("P32") D
        . S LIMEXAMS=+$P(PARAM,U,15)
        . S:'LIMEXAMS LIMEXAMS=999 ; default to show ALL Exams
        . I $P(DATA,U,3) S LIMEXAMS=+$P(DATA,U,3)
        . I LIMEXAMS<20 S LIMEXAMS=20
        . S BEGDT=""
        E  S BEGDT=$P(DATA,U,4),ONESHOT=$P(DATA,U,5)  ; P65 chg
        K MAGGRY S DFN=+DATA
        S SHOWPLAC=$$SHOWPLAC^MAGJLS2B("")
        S MAGRACNT=1,CNT=0 K ^TMP($J,"MAGRAEX"),^("MAGRAEX2")
        S REPLY="0^4~Compiling list of Radiology Exams."
        I DFN,$D(^DPT(DFN,0)) S PATNAME=$P(^(0),U),PSSN=$P(^(0),U,9) D
        . S ENDLOOP=0,BEGDT=$S(+BEGDT:BEGDT,1:"")
        . I MAGJOB("P32"),+$G(MAGJOB("P32STOP")) S REPLY="0^4~VistARad Patch 32 is no longer supported; contact Imaging Support for the current version of the VistARad client software." Q  ; <*>
        . F  D  Q:'MORE  Q:ENDLOOP  S BEGDT=MORE+1
        . . I 'BEGDT S BEGDT=DT,X2=0
        . . E  S X2=-1
        . . S LIMDAYS=365,MORE=1
        . . I 'MAGJOB("P32") I ONESHOT,(ONESHOT>0) S LIMDAYS=+ONESHOT
        . . S ENDDT=$$FMADD^XLFDT(BEGDT,X2)
        . . S BEGDT=$$FMADD^XLFDT(ENDDT,-LIMDAYS)
        . . D GETEXAM3^MAGJUTL1(DFN,BEGDT,ENDDT,.MAGRACNT,.MAGRET,.MORE)
        . . I MAGJOB("P32") S ENDLOOP=(MAGRACNT>LIMEXAMS)
        . . E  S ENDLOOP=(MAGRACNT>20)!+ONESHOT ; For testing only, use >8
        . I 'MORE S SAVBEGDT=0
        . E  S SAVBEGDT=MORE+1 ; adding 1 correctly inits value for subseqent call
        . I MAGRACNT>1 D PTLOOP
        E  S REPLY="0^4~Invalid Radiology Patient"
        I MAGRACNT<2 S:(REPLY["Compiling") REPLY="0^2~No Exams Found for "_PATNAME
        I CNT!(REPLY["No Exams Found") D
        . I 'MORE S MSG="ALL exams are listed."
        . E  S MORE=$$FMTE^XLFDT(MORE) S MSG="Patient has more exams on file."
        . ; show SSN only if the user is a radiologist
        . S X=+MAGJOB("USER",1) I '(X=12!(X=15)) S PSSN=""
        . E  S PSSN=" ("_$E(PSSN,1,3)_"-"_$E(PSSN,4,5)_"-"_$E(PSSN,6,9)_")"
        . I CNT S REPLY=CNT_"^1~Radiology Exams for: "_PATNAME_PSSN_" -- "_MSG
        . E  S REPLY=REPLY_" -- "_MSG
        . S ^TMP($J,"MAGRAEX2",1)="^Day/Case~S3~1^Lock~~2^Procedure~~6^Modifier~~25^Image Date/Time~S1~7^Status~~8^# Img~S2~9^Onl~~10"_$S($G(SNDREMOT):"^RC~~12",1:"")_$S(SHOWPLAC:"^Site~~23",1:"")_"^Mod~~15^Interp By~~20^Imaging Loc~~11^CPT~~27"
        I MAGJOB("P32"),+$G(MAGJOB("P32STOP")) S ^TMP($J,"MAGRAEX2",1)="^^"
        I 'MAGJOB("P32") S $P(REPLY,"|",2)=SAVBEGDT
        S ^TMP($J,"MAGRAEX2",0)=REPLY
        S MAGGRY=$NA(^TMP($J,"MAGRAEX2"))
        K ^TMP($J,"RAE1"),^("MAGRAEX")
        Q
        ;
PTLOOP  ; loop through exam data & package it for VRAD use
        S ISS=0
        F  S ISS=$O(^TMP($J,"MAGRAEX",ISS)) Q:'ISS  S XX=^(ISS,1),XX2=^(2) D
        . S CNT=CNT+1,RARPT=$P(XX,U,10)
        . D IMGINFO^MAGJUTL2(RARPT,.Y)
        . S IMGCNT=$P(Y,U),ONL=$P(Y,U,2),MAGDT=$P(Y,U,3),REMOTE=$P(Y,U,4),MODALITY=$P(Y,U,5),PLACE=$P(Y,U,6),KEY=$P(Y,U,7)
        . S REMOTE2=REMOTE
        . S:PLACE PLACE=$P($G(^MAG(2006.1,PLACE,0)),U,9)
        . I PLACE]"",SHOWPLAC D
        .. I SHOWPLAC'[(","_PLACE_",") S PLACE="" ; don't show user's logon pl ; <*> chg for p18?
        . I SNDREMOT,REMOTE D
        .. S T="" F I=1:1:$L(REMOTE,",") S T=T_$S(T="":"",1:",")_$P($G(^MAG(2005.2,$P(REMOTE,",",I),3)),U,5)
        .. S REMOTE=T
        . S DIV="",X=$P(XX2,U,5) I X'=DUZ(2) S DIV=$$STATN(X)
        . I MAGDT="" S MAGDT=$P(XX,U,7)
        . S MAGDT=$$FMTE^XLFDT(MAGDT,"5Z")
        . S WHOLOCK=RARPT,MYLOCK="",DAYCASE=$P(XX,U,12)
        . I WHOLOCK]"" S T=$$CHKLOCK^MAGJLS2B(WHOLOCK,DAYCASE),WHOLOCK=$P(T,U),MYLOCK=$P(T,U,2)
        . S RDRIST=$P(XX2,U,3),PROCMOD=$P(XX2,U,8),CPT=$P(XX,U,17),RASTORD=$P(XX,U,15)
        . S Y=U_DAYCASE_U_WHOLOCK_U_$E($P(XX,U,9),1,26)_U_PROCMOD_U_MAGDT_U_$E($P(XX,U,14),1,16)_U_IMGCNT_U_ONL
        . I $G(SNDREMOT) S Y=Y_U_REMOTE
        . S Y=Y_$S(SHOWPLAC:U_PLACE,1:"")_U_MODALITY_U_RDRIST_U_$E($P(XX,U,13),1,11)_U_CPT
        . S STATUS=$P(XX,U,11),EXCAT="",CURPRIO=0,RASTCAT=$P(XX2,U,11),LRFLAG=$P(XX2,U,12)
        . I STATUS]"" D
        . . S EXCAT=RASTCAT
        . . I RASTORD<2!(EXCAT="W")!('IMGCNT) S CURPRIO=0 ; Cancelled/Waiting/No images: Ignore exam
        . . E  I EXCAT="E" S CURPRIO=1  ; Examined="Current" exam
        . . E  S CURPRIO=2  ; must be a "prior" exam
        . . I CURPRIO,'(ONL="Y") S CURPRIO=3 ; images on jukebox
        . . I MAGJOB("P32"),'(EXCAT="E") S EXCAT="" Q  ; P32 compat.
        . . I RASTORD=9 S EXCAT="C" ; Complete
        . . E  I EXCAT="D"!(EXCAT="T") S EXCAT="I" ; just display one value meaning Interpreted
        . S ^TMP($J,"MAGRAEX2",ISS)=Y_"^|"_$P(XX,U,1,3)_U_RARPT_"||"_EXCAT_U_WHOLOCK_U_MYLOCK_U_MODALITY_U_CPT_U_CURPRIO_U_RARPT_U_KEY_U_REMOTE2_U_LRFLAG
        . ; * Note: Keep Pipe-pieces in sync with svmag2a^magjls3 & lstout^magjls2b *
        Q
        ;
STATN(X)        ; get station #, else return input value
        N T
        I X]"" D GETS^DIQ(4,X,99,"E","T") S T=$G(T(4,X_",",99,"E")) I T]"" S X=T
        Q X
        ;
END     Q  ;
