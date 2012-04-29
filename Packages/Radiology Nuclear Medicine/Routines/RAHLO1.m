RAHLO1  ;HIRMFO/GJC/BNT-File rpt (data from bridge program) ;6/25/04  11:49
        ;;5.0;Radiology/Nuclear Medicine;**4,5,12,17,21,27,48,55,66,87,84**;Mar 16, 1998;Build 13
        ; 11/15/2007 BAY/KAM RA*5*87 Rem Call 216332 Correct UNDEF on null dx code
        ; 09/07/2005 108405 - KAM/BAY Allow Radiology to accept dx codes from Talk Technology
        ; 09/29/2005 114302 KAM/BAY Code Added to trigger alert on 2ndary dx
        ;
        ;Integration Agreements
        ;----------------------
        ;DIE(10018); ,FILE^DIE(2053); IX^DIK(10013); CREATE^WVRALINK(4793); $$NOW^XLFDT(10103)
        ;EN^XUSHSHP(10045)
        ;
FILE    ;Create Entry in File 74 and File Data
        I '$D(ZTQUEUED) N ZTQUEUED S ZTQUEUED="1^dummy to suppress screen displays in UP2^RAUTL1 and elsewhere"
        I '$D(RAQUIET) N RAQUIET S RAQUIET="1^dummy to suppress screen display in PTR^RARTE2"
        N RADATIME S RADATIME=$$NOW^XLFDT() I $L($P(RADATIME,".",2))>4 S RADATIME=$P(RADATIME,".",1)_"."_$E($P(RADATIME,".",2),1,4) S RADATIME=+RADATIME
        S RADPIECE=$S($D(^VA(200,"ARC","S",+$G(RAVERF))):15,$D(^VA(200,"ARC","R",+$G(RAVERF))):12,1:"")
        N:'$D(RAPRTSET) RAPRTSET N:'$D(RAMEMARR) RAMEMARR
        D EN2^RAUTL20(.RAMEMARR) ; 04/30/99 always recalculate RAPRTSET
        ; If the report (stub/real) exists, unverify the existing report... Else create a new report
        I RARPT,$D(^RARPT(RARPT,0)) S RASAV=RARPT D  S RARPT=RASAV K RASAV Q:$D(RAERR)  G LOCK1
        . ; must save off RARPT, RAVERF and other RA* variables because
        . ; they are being killed off somewhere in the 'Unverify A Report'
        . ; option. 'Unverify A Report' does lock the the report record in file 74!
        . N RADFN,RADTI,RACNI,RARPTSTS,RASSN,RADATE,RALONGCN,RAVERF
        . ; if report isn't a stub report, then consider it being edited
        . S:'$$STUB^RAEDCN1(RARPT) RAEDIT=1
        . I $D(RADENDUM)#2,($P(^RARPT(RARPT,0),"^",5)="V") D  Q  ; edit on current record (for activity log)
        .. D UNVER^RARTE1(RARPT)
        .. Q
        . K ^RARPT(RARPT,"I"),^("R"),^("H")
        . Q
        ; New report logic @NEW1
NEW1    S I=$P(^RARPT(0),"^",3)
        ;since this is a new report (not linked to an exam), directly lock the new record *1 lR*
LOCK    S I=I+1 L +^RARPT(I):1 G:'$T LOCK I ($D(^RARPT(I))#2) L -^RARPT(I) G LOCK
        S ^RARPT(I,0)=RALONGCN,RARPT=I,^(0)=$P(^RARPT(0),"^",1,2)_"^"_I_"^"_($P(^(0),"^",4)+1)
        ;if case is member of a print set, then create sub-recs for file #74
        G:'RAPRTSET LOCK1
        I '$D(RARPTN) N RARPTN S RARPTN=RALONGCN
        N RAXIT D PTR^RARTE2 ;create corresponding subrecs in ^RARPT()
        ;
        ;if RAERR unlock the report record (locked @LOCK), kill vars, & exit
        I $D(RAERR) D LOCKR^RAHLTCPU(.RAERR,1) D KVAR Q  ; *1 uR*
        ;
LOCK1   I $D(RAESIG) S X=RAESIG,X1=$G(RAVERF),X2=RARPT D EN^XUSHSHP S RAESIG=X
        K DA,DIE,DQ,DR S DA=RARPT,DIE="^RARPT("
        S DR="5////"_RARPTSTS ; rpt status
        ;Verifier & Verified date will be set if RAVERF exists for new
        ;reports, edits, and addendums.  Date rpt entered and reported date
        ;will be set for new reports, and not reset for edits and addendums
        S DR=DR_";6////"_$S($D(RAEDIT):"",1:RADATIME) ; date/time rpt entered
        S DR=DR_";7////"_$S($G(RAVERF)&(RARPTSTS="V"):RADATIME,1:"") ; v'fied date/time
        S DR=DR_";8////"_$S($D(RAEDIT):"",1:RADATE) ; reported date
        S DR=DR_";9////"_$S($G(RAVERF)&(RARPTSTS="V"):RAVERF,1:"") ; v'fying phys
        S:$L($G(RATELENM)) DR=DR_";9.1////"_RATELENM ;Teleradiologist name - Patch 84
        S:$L($G(RATELEPI)) DR=DR_";9.2////"_RATELEPI ;Teleradiologist NPI  - Patch 84
        S DR=DR_";11////"_$S($G(RATRANSC):RATRANSC,$G(RAVERF):RAVERF,1:"") ; transcriptionist
        I $G(RAVERF),(RARPTSTS="V") S DR=DR_";17////"_$G(^TMP("RARPT-REC",$J,RASUB,"RAWHOCHANGE")) ;status changed to 'verified' by
        ; D ^DIE K DA,DR ;BNT- Moved the DIE call down three lines due to a
        ; problem found at Indy while testing PowerScribe.  Site was doing a
        ; local MUMPS cross reference on one of the nodes that are set below.
        S $P(^RARPT(RARPT,0),"^",2)=RADFN,$P(^(0),"^",3)=(9999999.9999-RADTI),$P(^(0),"^",4)=$P(RALONGCN,"-",2) ;must set manually due uneditable
        S $P(^RARPT(RARPT,0),"^",10)=$S($D(RAESIG)&(RARPTSTS="V"):RAESIG,1:"") ; hard set because Elec Sig Code may contain a semi-colon which causes errors in DIE
        D ^DIE K DA,DR
        ;don't file a Pri. Dx code for teleradiology reports in the released status (P84v11 bus. rule)
        S RARELTEL=$S(($D(RATELE)#2)&(RARPTSTS="R"):1,1:"")
        ;
        ; 02/08/2008 GJC replaced $G w/($D(RADX)#2) p84
        ; 11/15/2007 BAY/KAM RA*5*87 Rem Call 216332 Changed next line to $G
        ; 09/07/2005 108405 KAM/BAY Removed('$D(RADENDUM)#2) from next line
        I ($D(RADX)#2),RARELTEL="" D  Q:($D(RAERR))#2
        .;now a silent FM call w/p84 due to xref being killed when stuffing an identical Dx code
        .;as the one already on file.
        .N RAFDA,RAIENS S RAIENS=RACNI_","_RADTI_","_RADFN_","
        .S RAFDA(70.03,RAIENS,13)=RADX
        .;lock the exam record, if the lock fails unlock the report record (locked @LOCK) & quit
        .D LOCKX^RAHLTCPU(.RAERR) ;*1 lE*
        .I ($D(RAERR)#2) D LOCKR^RAHLTCPU(.RAERR,1) Q  ;*1 uR*
        .K RAERR D FILE^DIE(,"RAFDA","RAERR") D LOCKX^RAHLTCPU(.RAERR,1) ;*1 uE*
        .I ($D(RAERR("DIERR"))#2) D  Q
        ..;set the error dialog; unlock the report (locked @LOCK) *1 uR*
        ..D LOCKR^RAHLTCPU(.RAERR,1) S RAERR=$G(RAERR("DIERR",1,"TEXT",1))
        ..Q
        .S:$P(^RA(78.3,+RADX,0),"^",4)="y" RAAB=1
        .Q
        ;
        K RARELTEL
        ; 09/29/2005 114302 KAM/BAY Code Added to trigger alert on 2ndary dx
        I $D(RASECDX) D
        . N RAX S RAX=0
        . F  S RAX=$O(RASECDX(RAX)) Q:RAX'>0  D
        .. S:$P(^RA(78.3,+RAX,0),"^",4)="y" RAAB=1
        ;
        I '$D(RADENDUM)#2,($G(^TMP("RARPT-REC",$J,RASUB,"RASTAFF"))!$G(^("RARESIDENT"))) D
        . K DIE,DA S DR=""
        . S RAPRIMAR=+$G(^TMP("RARPT-REC",$J,RASUB,"RARESIDENT")) I $D(^VA(200,"ARC","R",RAPRIMAR)) S DR="12////"_RAPRIMAR
        . S RAPRIMAR=+$G(^TMP("RARPT-REC",$J,RASUB,"RASTAFF")) I $D(^VA(200,"ARC","S",RAPRIMAR)) S DR=$S(DR]"":DR_";",1:"")_"15////"_RAPRIMAR
        . Q:'$G(DR)
        . S DA=RACNI,DA(1)=RADTI,DA(2)=RADFN
        . D LOCKX^RAHLTCPU(.RAERR) ;*2 lE*
        . S DIE="^RADPT("_DA(2)_",""DT"","_DA(1)_",""P"","
        . D ^DIE K DIE,DA,DR
        . D LOCKX^RAHLTCPU(.RAERR,1) ;*2 uE*
        . Q
        ;
        S $P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),"^",17)=RARPT I $G(RADPIECE),$P(^(0),"^",RADPIECE)="",('$D(RADENDUM)#2) D SETPHYS^RAHLO4
        ; file impression text if present & not an addendum
        I '$D(RADENDUM) D
        . S J=0 I $O(^TMP("RARPT-REC",$J,RASUB,"RAIMP",0)) S I=0 F J=0:1 S I=$O(^TMP("RARPT-REC",$J,RASUB,"RAIMP",I)) Q:I'>0  I $D(^(I)) S ^RARPT(RARPT,"I",(J+1),0)=$G(^TMP("RARPT-REC",$J,RASUB,"RAIMP",I))
        . S:J ^RARPT(RARPT,"I",0)="^^"_J_"^"_J_"^"_RADATE
        . Q
        ; file report text if present & not an addendum
        I '$D(RADENDUM) D
        . S J=0 I $O(^TMP("RARPT-REC",$J,RASUB,"RATXT",0)) S I=0 F J=0:1 S I=$O(^TMP("RARPT-REC",$J,RASUB,"RATXT",I)) Q:I'>0  I $D(^(I)) S ^RARPT(RARPT,"R",(J+1),0)=$G(^TMP("RARPT-REC",$J,RASUB,"RATXT",I))
        . S:J ^RARPT(RARPT,"R",0)="^^"_J_"^"_J_"^"_RADATE
        . Q
        ; if addendum, add addendum text to impression or report
        I $D(RADENDUM),($O(^TMP("RARPT-REC",$J,RASUB,"RAIMP",0))!$O(^TMP("RARPT-REC",$J,RASUB,"RATXT",0))) D ADENDUM^RAHLO2 ; store new lines at the end of existing text
        ;
        ;
        ; Check for History from Dictation
        ; If history sent, check if previous history exists.  If previous
        ; history then current history will follow adding 'Addendum:' before
        ; the text.
        I $O(^TMP("RARPT-REC",$J,RASUB,"RAHIST",0)) D
        . S RACNT=+$O(^RARPT(RARPT,"H",9999999),-1),RAHSTNDE=RACNT+1
        . S RANEW=$S(RACNT>0:0,1:1)
        . S I=0 F  S I=$O(^TMP("RARPT-REC",$J,RASUB,"RAHIST",I)) Q:I'>0  D
        . . S RACNT=RACNT+1
        . . S RALN=$G(^TMP("RARPT-REC",$J,RASUB,"RAHIST",I))
        . . S:'RANEW&(I=$O(^TMP("RARPT-REC",$J,RASUB,"RAHIST",0))) RALN="Addendum: "_RALN ; if the first line, append 'Addendum:'
        . . I (RAHSTNDE=RACNT),(RACNT>1) S ^RARPT(RARPT,"H",RACNT,0)=" ",RACNT=RACNT+1
        . . S ^RARPT(RARPT,"H",RACNT,0)=RALN
        . . Q
        . S ^RARPT(RARPT,"H",0)="^^"_RACNT_"^"_RACNT_"^"_RADATE
        . Q
        ;
        ;
        I $P(^RARPT(RARPT,0),U,5)="V",$T(CREATE^WVRALINK)]"" D CREATE^WVRALINK(RADFN,RADTI,RACNI) ; women's health
        G:'RAPRTSET UPACT ; the next section is for printsets only
        ; copy DX (prim & sec), Prim Resid, Prim Staff
        N RACNISAV,RA7
        N RA13,RA12,RA15 ;prim dx, prim resid, prim staff, rpt pointer
        S RACNISAV=RACNI,RA7=0
        S RA13=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,13),RA12=$P(^(0),U,12),RA15=$P(^(0),U,15)
        F  S RA7=$O(RAMEMARR(RA7)) Q:RA7=""  I RACNISAV'=RA7 S RACNI=RA7 D UPMEM^RAHLO4 I $D(RASECDX),('$D(RADENDUM)#2) D SECDX^RAHLO2
        S RACNI=RACNISAV
        ;Update Activity Log
UPACT   S DA=RARPT,DIE="^RARPT(",DR="100///""NOW""",DR(2,74.01)="2////"_$S(RARPTSTS="V":"V",$D(RAEDIT):"E",1:"I")_";3////"_$S($G(RAVERF):RAVERF,$G(RATRANSC):RATRANSC,1:"") D ^DIE K DA,DR,DE,DQ,DIE
        ; use ix^dik to kill before setting xrefs
        S DA=RARPT,DIK="^RARPT(",RAQUEUED=1 D IX^DIK
        L -^RARPT(RARPT) ;(1 uR) conventionally unlock the report locked @LOCK
        ;
        ;If verified, update report & exam statuses; else, just update exam status
        ;Note: be careful; exam locks are executed within UP1^RAUTL1!
        I $D(RAMDV),RAMDV'="" D:RARPTSTS="V" UPSTAT^RAUTL0 D:RARPTSTS'="V" UP1^RAUTL1
        D:'$D(RAERR)&($G(^TMP("RARPT-REC",$J,RASUB,"VENDOR"))'="KURZWEIL") GENACK^RAHLTCPB ; generate 'ACK' message
        ;
PACS    ;If there are subscribers to RA RPT xxx events broadcast ORU mesages to those subscribers
        ;via TASK^RAHLO4. If VOICE DICTATION AUTO-PRINT (#26) field is set to 'Y' print the report to
        ;the printer defined in the REPORT PRINTER NAME (#10) field via VOICE^RAHLO4.
        I ($P(^RARPT(RARPT,0),U,5)="V")!($P(^(0),U,5)="R") D TASK^RAHLO4,VOICE^RAHLO4
        ;
KVAR    K RAAB,RAEDIT,RAESIG,RAQUEUED,RARPT,RAHIST
        Q
        ;
