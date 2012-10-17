PRSDSERV        ;WOIFO/MGD,PLT - PAID DOWNLOAD MESSAGE SERVER ;12/3/07
        ;;4.0;PAID;**6,78,82,116,107**;Sep 21, 1995;Build 2
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        D NOW^%DTC S TIME=% S XMPOS=1 D REC^XMS3 G:XMER'=0 EXIT
        S LPE=$E(XMRG,1,7) I LPE'?1"**"2N1"PDH",LPE'="****PDH" G EXIT
        ; EMPCNT = # emp in this mail message
        ; SEQNUM = Mail message sequence number if more than one message
        S EMPCNT=+$E(XMRG,9,12),SEQNUM=$E(XMRG,13,16),TYPE=$E(XMRG,23)
        S DATE=$E(XMRG,24,31),STA="",SUB="TMP"
        I "IEPTD"'[TYPE G EXIT
        ; Check to see if the message was previously loaded
        I $D(^PRSD(450.12,"B",XMZ)) G EXIT
        S MTYPE=$S(TYPE="I":"Initial",TYPE="E":"Edit & Update",TYPE="P":"Payrun",TYPE="T":"Transfer",1:"")
        ; Set Lines Per Employee (LPE) for the correct interface
        S LPE=$E(LPE,3,4),LPE=$S(LPE?2N:+LPE,TYPE="I":20,(TYPE="E")!(TYPE="T"):15,TYPE="P":9,1:0)
        D REC^XMS3 G:XMER'=0 EXIT S STA=$E(XMRG,1,3) I STA'?3N G EXIT
        I TYPE="D" D ^PRSDDL G EXIT  ; Process Separation download
        ; Mark message as received.  This info is for the reports sent to the
        ; PAD mail group.
        I $D(^XTMP("PRS","MNR",TYPE,DATE,STA,SEQNUM)) D  G EXIT
        .S ^TMP($J,"PRSD",999)=MTYPE_" message "_SEQNUM_" received."
        .D SETPRS S MNR="" D PROC^PRSDPROC
        I $D(^PRSD(450.12,"C",TYPE_"-"_DATE_"-"_STA_"-"_SEQNUM)) G EXIT
        K DD,DO S DIC="^PRSD(450.12,",DIC(0)="L",X=XMZ D FILE^DICN
        S PRSDIEN=+Y,$P(^PRSD(450.12,+Y,0),U,2)=TYPE_"-"_DATE_"-"_STA_"-"_SEQNUM
        S $P(^PRSD(450.12,+Y,0),U,3)="R",$P(^PRSD(450.12,+Y,0),U,4)=TIME
        S ^PRSD(450.12,"C",TYPE_"-"_DATE_"-"_STA_"-"_SEQNUM,+Y)=""
SETPRS  ;start employee record
        S XMPOS=2 F A=1:1:EMPCNT D SSNLOOP Q:SSN=999999999
        I $D(^XTMP("PRS","MNR",TYPE,DATE,STA,SEQNUM)) K ^XTMP("PRS","MNR",TYPE,DATE,STA,SEQNUM) Q
        S:SSN'=999999999 $P(^PRSD(450.12,PRSDIEN,0),U,3)="S"
EXIT    K %,%H,%I,A,AA,AAA,ADDFLG,B,BB,CC,DA,DATA,DATE,DBNAME,DIC,DIK,DINUM
        K DLAYGO,DLID,E1,E2,EE,ECNT,ECOUNT,EMPCNT,ERRCNT,ERRFLG,ERRID,ERRIEN,SUB
        K ERRMSG,FLD,FLDNUM,GNUM,GRP,GRPVAL,IEN,II,LPE,LTH,MO,MFLD,MTYPE,MULT
        K NAME,NODE,NODE459,PIC,PIECE,PIECE459,PP,PP455,PPIEN,PRSD,PRSDIEN,RCD
        K RTN,RTNNUM,RTYPE,SEQNUM,SSN,SSNLINE,STA,STA450,SUM,TMPIEN,TMPLINE
        K TIME,TYPE,X,XCNP,XMDUZ,XMSUB,XMTEXT,XMY,Y,YR,XMPOS,XMRG,XMER,XMLOC
        K XMMG,MNR,PDATE,CDATE,X1,X2
REMSB   I $D(XMZ) S XMSER="S.PRSD" D REMSBMSG^XMA1C K XMSER
        Q
SSNLOOP D REC^XMS3
        S SSN=$S(TYPE="I":$P(XMRG,":",2),1:$E(XMRG,4,12))
        S SSN=$E("000000000",$L(SSN)+1,9)_SSN
        ; The last employee in the last MailMan message has a SSN=999999999
        ; This triggers the software to begin processing the download.
        I SSN=999999999 D  Q
        .I TYPE="I" K ^XTMP("PRS","ERR")
        .S ^XTMP("PRS","LSN",TYPE,DATE,STA)=SEQNUM
        .S:$D(PRSDIEN) $P(^PRSD(450.12,PRSDIEN,0),U,3)="S" H 600
        .D REMSB S ECNT=0 D START,START,^PRSDERR,^PRSDSTAT S SSN=999999999
        S (PDATE,CDATE)=$P(TIME,".",1),X1=PDATE,X2=90 D C^%DTC S PDATE=X
        S ^XTMP("PRS",0)=PDATE_"^"_CDATE
        K KFLG S XMPOS=XMPOS-1
        F B=1:1:LPE D REC^XMS3 I (($L(XMRG,":")-1)'=$L(XMRG))!(TYPE="I") S TMPLINE=$E("000",$L(XMPOS)+1,3)_XMPOS,^XTMP("PRS",SUB,DATE,TYPE,STA,SSN,XMZ_"-"_TMPLINE_"-"_B)=XMRG I TYPE="T",B=6 D TRANSCK^PRSDERR
        I $D(KFLG) K ^XTMP("PRS",SUB,DATE,TYPE,STA,SSN),KFLG
        Q
START   ; Process download
        ; RTYPE is used to determine which series of routines to call to
        ; process the download
        S SSN="",RTYPE=$S(TYPE="I":"LD",(TYPE="E")!(TYPE="T"):"EU",TYPE="P":"PR",1:"")
        F  S SSN=$O(^XTMP("PRS",SUB,DATE,TYPE,STA,SSN)) Q:SSN=""  D
        . L +^XTMP("PRS",SUB,DATE,TYPE,STA,SSN):0
        . I $T D
        . . S TMPIEN=$O(^XTMP("PRS",SUB,DATE,TYPE,STA,SSN,""))
        . . I TMPIEN'="" D
        . . . S RCD=^(TMPIEN),ERRFLG=""
        . . . D SSN
        . . . D:ERRFLG'="Y" LDINIT,PROC,PROC2,LDFNL,LDCMP
        . . . D:ERRFLG="Y" TMPERR D UNL
        Q
        ; Piece together the routine name and call the routine
PROC    S TMPIEN="" F  S TMPIEN=$O(^XTMP("PRS",SUB,DATE,TYPE,STA,SSN,TMPIEN)) Q:TMPIEN=""  S RCD=^XTMP("PRS",SUB,DATE,TYPE,STA,SSN,TMPIEN),RTNNUM=$P(TMPIEN,"-",3) S:$L(RTNNUM)=1 RTNNUM=0_RTNNUM S RTN="^PRSD"_RTYPE_RTNNUM D:$T(@RTN)]"" @RTN
        Q
PROC2   I TYPE="P",PP'="" D ^PRSDCOMP  ;Compute calculated fields
        S NODE=0 F EE=1:1 S NODE=$O(^PRSPC(IEN,NODE)) Q:NODE=""  I $D(^PRSPC(IEN,NODE))#2 S DATA=^PRSPC(IEN,NODE) I $L(DATA,U)-1=$L(DATA) K ^PRSPC(IEN,NODE)
        K ^XTMP("PRS",SUB,DATE,TYPE,STA,SSN) Q
TMPERR  I TYPE="P",PP="" G TMPERR1
        S TMPIEN="" F  S TMPIEN=$O(^XTMP("PRS",SUB,DATE,TYPE,STA,SSN,TMPIEN)) Q:TMPIEN=""  S RCD=^XTMP("PRS",SUB,DATE,TYPE,STA,SSN,TMPIEN),^XTMP("PRS","ERR",DATE,TYPE,STA,SSN,TMPIEN)=RCD
TMPERR1 K ^XTMP("PRS",SUB,DATE,TYPE,STA,SSN) Q
UNL     L -^XTMP("PRS",SUB,DATE,TYPE,STA,SSN) Q
SSN     I TYPE="P",'$D(^PRSPC("SSN",SSN)) S ERRMSG="SSN "_$E(SSN,1,3)_"-"_$E(SSN,4,5)_"-"_$E(SSN,6,9)_" not found" D ERR Q
        I TYPE="I" S NAME=$P(RCD,":",4)
        I (TYPE="E")!(TYPE="T") S NAME=$P(RCD,":",2),DATA=$E(NAME,1,27) I DATA'="" D RTS^PRSDUTIL S NAME=DATA S:TYPE="T" ^TMP($J,"PRS",NAME,SSN)=""
        I '$D(^PRSPC("SSN",SSN)) D ^PRSDADD K DA,DIE,DR,OLDSSN,VAIEN,VANAME Q:ERRFLG="Y"  G SSNOUT
        S IEN=0,IEN=$O(^PRSPC("SSN",SSN,IEN))
SSNOUT  I TYPE="P" D ^PRSDPTYP I PP="" S ERRFLG="Y" Q
        S ECNT=ECNT+1
        Q
ERR     K DD,DO S DIC="^PRSD(450.11,",DIC(0)="L",X=TYPE_"-"_DATE_"-"_STA D FILE^DICN I Y>0 S $P(^PRSD(450.11,+Y,0),U,3)=ERRMSG
        S ERRFLG="Y"
        Q
LDINIT  ; Load Initial Labor Distribution Values
        S LDINIT=$$LDLOAD()
        Q
LDFNL   ; Load Final Labor Distribution Values
        S LDFNL=$$LDLOAD()
        Q
LDLOAD()        ; Retrieve current Labor Distribution Values from #450
        ;
        N LD,LDCC,LDCODE,LDFCP,LDPCT,PRSLD
        S LD=""
        F PRSLD=1:1:4 D
        . S LDCODE=$$GET1^DIQ(450.0757,PRSLD_","_IEN,1)
        . S LDPCT=$$GET1^DIQ(450.0757,PRSLD_","_IEN,2)
        . S LDCC=$$GET1^DIQ(450.0757,PRSLD_","_IEN,3)
        . S LDFCP=$$GET1^DIQ(450.0757,PRSLD_","_IEN,4)
        . S LD=LD_LDCODE_U_LDPCT_U_LDCC_U_LDFCP_U
        Q LD
        ;
LDCMP   ; Compare Initial and Final Labor Distribution for changes
        ; and update audit trail in #458 if necessary.
        Q:LDINIT=LDFNL
        N PPA,I,IENS,IENS1,INDX,J,LDA,PRSFDA,TLDPER,E458IEN
        ; Get IEN for current Pay Period
        S PPA=$P($G(^PRST(458,"AD",$P(TIME,".",1))),U,1)
        Q:PPA=""
        ;
        ; Get next multiple number
        S LDA="A",LDA=$O(^PRST(458,PPA,"E",IEN,"LDAUD",LDA),-1)
        S LDA=$S(LDA>0:LDA+1,1:1)
        ;
        ; Set Audit information into #450
        S DA=IEN,DIE="^PRSPC("
        S DR="755///^S X=$O(^VA(200,""B"",""CENTRAL,PAID"",0))"
        D ^DIE
        S DR="755.1///^S X=TYPE"
        D ^DIE
        S DR="756///^S X=TIME"
        D ^DIE
        ;
        ; If there is no entry for this employee in the Pay Period, create
        ; a record for them
        I '$D(^PRST(458,PPA,"E",IEN)) D
        . S IENS=","_PPA_","
        . S E458IEN(1)=IEN
        . S PRSFDA(458.01,"?+1"_IENS,.01)=IEN
        . S PRSFDA(458.01,"?+1"_IENS,1)="T"
        . D UPDATE^DIE("","PRSFDA","E458IEN")
        ;
        ; PRS*107 - undefined PPA caused errors
        ; PRS*107 - undefined LDA caused errors
        ; PRS*107 - IENS not set properly 
        S PPA=$P($G(^PRST(458,"AD",$P(TIME,".",1))),U,1)
        Q:PPA=""
        S LDA="A",LDA=$O(^PRST(458,PPA,"E",IEN,"LDAUD",LDA),-1)
        S LDA=$S(LDA>0:LDA+1,1:1)
        S IENS=","_IEN_","_PPA_","
        ;
        ; Set LD AUDIT record into #458.1105
        ; S IENS=","_IEN_IENS  - PRS*107 REPLACED WITH IENS SET 3 LINES ABOVE
        K PRSFDA
        S PRSFDA(458.1105,"?+1"_IENS,.01)=LDA
        S PRSFDA(458.1105,"?+1"_IENS,1)=TIME
        S PRSFDA(458.1105,"?+1"_IENS,2)=$O(^VA(200,"B","CENTRAL PAID",0))
        S PRSFDA(458.1105,"?+1"_IENS,3)=TYPE
        D UPDATE^DIE("","PRSFDA")
        ;
        ; Central PAID only sends LD fields that have changed.  Run check on 
        ; percentages and delete all LD fields in #450 after 99% has been reached
        S TLDPER=0
        F I=0:1:3 S TLDPER=TLDPER+$P(LDFNL,U,I*4+2) Q:TLDPER'<.99
        S J=(I+1)*4+1 ; Set counter for LDINIT
        F J=J:1:16 S $P(LDINIT,U,J)=""
        S I=I+2 ; Adjust counter for deletion of multiples
        K PRSFDA
        S DA(1)=IEN
        F I=I:1:4 D
        . S DA=I,DIK="^PRSPC("_DA(1)_",""LD"","
        . D ^DIK
        ;
        ; Set LABOR DISTRIBUTION (Multiple-458.11054)
        S LD=$O(^PRST(458,PPA,"E",IEN,"LDAUD",0))
        F PRSLD=0:1:3 D
        . S J=PRSLD+1
        . S IENS1="+"_J_","_LD_IENS
        . ; Don't record empty multiples
        . Q:$P(LDINIT,U,PRSLD*4+2)=""  ; PERCENT
        . K PRSFDA
        . S PRSFDA(458.11054,IENS1,.01)=PRSLD+1
        . S PRSFDA(458.11054,IENS1,1)=$P(LDINIT,U,PRSLD*4+1) ; CODE
        . S PRSFDA(458.11054,IENS1,2)=$P(LDINIT,U,PRSLD*4+2) ; PERCENT
        . S PRSFDA(458.11054,IENS1,3)=$P(LDINIT,U,PRSLD*4+3) ; COST CENTER
        . S PRSFDA(458.11054,IENS1,4)=$P(LDINIT,U,PRSLD*4+4) ; FUND CTRL PT
        . D UPDATE^DIE("","PRSFDA")
        K LDINIT,LDFNL
        Q
