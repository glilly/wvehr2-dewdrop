PXRMXDT1        ; SLC/PJH - Build Patient list SUBROUTINES;11/02/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,12,17**;Feb 04, 2005;Build 102
        ;
        ; Called by label from PXRMXSEO,PXRMXSE
        ;
        ;Combined report duplicate check (Summary report)
NEW(SUB,SUB1,SUB2)      ;
        ;Existing entry
        I $D(^TMP("PXRMCMB",$J,SUB,SUB1,SUB2)) Q 0
        ;New entry
        S ^TMP("PXRMCMB",$J,SUB,SUB1,SUB2)=""
        Q 1
        ;
        ;Individual patient report duplicate patient check
NEWIP(DFN)      ;
        ;Existing entry
        I $D(^TMP("PXRMCMB3",$J,DFN)) Q 0
        ;New entry
        S ^TMP("PXRMCMB3",$J,DFN)=""
        Q 1
        ;Combined report duplicate check (Detail report)
NEWP(SUB,DFN)   ;
        ;Existing entry
        I $D(^TMP("PXRMCMB1",$J,SUB,DFN)) Q 0
        ;New entry
        S ^TMP("PXRMCMB1",$J,SUB,DFN)=""
        Q 1
        ;
        ;Combined report duplicate check (Patient totals)
NEWT(FACILITY,DFN)      ;
        ;Existing entry
        I $D(^TMP("PXRMCMB2",$J,FACILITY,DFN)) Q 0
        ;New entry
        S ^TMP("PXRMCMB2",$J,FACILITY,DFN)=""
        Q 1
        ;
NEWCS(FACILITY,NAM,DFN,REM)     ;
        I $D(^TMP("PXRMCMB4",$J,FACILITY,NAM,DFN,REM)) Q 0
        S ^TMP("PXRMCMB4",$J,FACILITY,NAM,DFN,REM)=""
        Q 1
        ;
        ;Detailed report
SDET(DFN,STATUS,NAM,FACILITY,INP)       ;
        I $G(^XTMP(PXRMXTMP,PX,FACILITY,NAM))="" D
        .S ^XTMP(PXRMXTMP,PX,FACILITY,NAM)=NAM
        ;Applicable
        S DDAT="N/A"
        N APPL,FAPPTDT,DEFARR,DNEXT,DNEXT1,FIEV,PXRMDATE,BID,TMPSUB
        S APPL=0,FAPPTDT=0
        ;Add any that aren't N/A, Ignore on N/A or NEVER to applicable total
        I ($P(STATUS,U)'="")&(STATUS'["NEVER")&(STATUS'["N/A")&(STATUS'["ERROR")&(STATUS'["CNBD") S APPL=1
        ;If DUE NOW save details
        I $G(STATUS)'["DUE NOW" S PNAM=" "
        I $G(STATUS)["DUE NOW" D
        .N BED
        .S DDUE=$P($G(STATUS),U,2)
        .S DLAST=$P($G(STATUS),U,3)
        .;Demographics
        .S PNAM=$P($G(^DPT(DFN,0)),U),BID=$P($G(^DPT(DFN,0)),U,9)
        .I PNAM="" S PNAM=" "
        .E  S PNAM=PNAM_U_BID
        .;Next appointment for location or clinic
        .;For detailed provider report get next appoint. for assoc. clinic
        .S DNEXT=""
        .I PXRMSEL="L"!(PXRMSEL="P") S TMPSUB="PXRM FUTURE APPT"
        .E  S TMPSUB="SDAMA301"
        .I PXRMFCMB="Y",PXRMLCMB="Y",$D(^TMP($J,TMPSUB,DFN))>0 D
        ..N APPTCNT,LOC
        ..S LOC=0,APPTCNT=0
        ..F  S LOC=$O(^TMP($J,TMPSUB,DFN,LOC)) Q:(LOC'>0)!(APPTCNT=1)  D
        ...S DNEXT=$O(^TMP($J,TMPSUB,DFN,LOC,"")) I +DNEXT>0 S APPTCNT=1 Q
        .S DNEXT=$O(^TMP($J,TMPSUB,DFN,$G(INP),""))
        .I PXRMFCMB="N",PXRMLCMB="Y" D
        ..S DNEXT1=$O(^TMP($J,"PXRM FACILITY FUTURE APPT",DFN,FACILITY,"")) Q:DNEXT1'>0
        ..I +DNEXT=0!(DNEXT>DNEXT1) S DNEXT=DNEXT1
        .S BED=$G(^DPT(DFN,.101)) S:BED="" BED="NONE"
        .;Sort by next appointment date
        .I PXRMSRT="Y" S DDAT=$P(DNEXT,".") S:DDAT="" DDAT="NONE"
        .;Patient ward/bed used only for inpatient reports
        .I PXRMFUT="Y" S DNEXT=""
        .N TXT
        .S TXT=DFN_U_DDUE_U_DLAST_U_$G(DNEXT)_$S($G(BED)'="":U_BED,1:"")
        .I $G(BED)'="",BED'="NONE" S DDAT=BED
        .N BED
        .S BED=""
        .I $G(PXRMINP) D
        ..S BED=$G(^DPT(DFN,.101)) S:BED="" BED="NONE"
        ..S TXT=TXT_U_BED
        ..;Sort by bed
        ..I PXRMSRT="B" S DDAT=BED
        .;Duplicate check for combined report
        .I PXRMFCMB="Y",'$$NEW(NAM,DDAT,PNAM) Q
        .;Save entry in ^XTMP
        .S ^XTMP(PXRMXTMP,PX,FACILITY,NAM,DDAT,PNAM)=TXT
        .;Total of reminders overdue
        .N CNT
        .S CNT=$P(^XTMP(PXRMXTMP,PX,FACILITY,NAM),U,2)
        .S $P(^XTMP(PXRMXTMP,PX,FACILITY,NAM),U,2)=CNT+1
        ;Total of patients checked/applicable
        N CNT,NEW
        S NEW=1 I PXRMFCMB="Y" S NEW=$$NEWP(NAM,DFN)
        I NEW=1 D
        .S CNT=$P(^XTMP(PXRMXTMP,PX,FACILITY,NAM),U,3)
        .S $P(^XTMP(PXRMXTMP,PX,FACILITY,NAM),U,3)=CNT+1
        .S CNT=$P(^XTMP(PXRMXTMP,PX,FACILITY,NAM),U,4)
        .S $P(^XTMP(PXRMXTMP,PX,FACILITY,NAM),U,4)=CNT+APPL
        I PXRMFUT="Y"&($G(STATUS)["DUE NOW") D
        .N APPTARY,APPTDT,CIEN,CNT,NODE,SUB
        .S SUB="" I $D(^TMP($J,"PXRM FUTURE APPT",DFN))>0 S SUB="PXRM FUTURE APPT"
        .I SUB="",$D(^TMP($J,"SDAMA301",DFN))>0 S SUB="SDAMA301"
        .I SUB="" Q
        .S CNT=0
        .S CIEN=0 F  S CIEN=$O(^TMP($J,SUB,DFN,CIEN)) Q:CIEN'>0  D
        ..S APPTDT=0
        ..F  S APPTDT=$O(^TMP($J,SUB,DFN,CIEN,APPTDT)) Q:APPTDT'>0  D
        ...S NODE=$G(^TMP($J,SUB,DFN,CIEN,APPTDT))
        ...S APPTARY(APPTDT)=APPTDT_U_$P($P(NODE,U,2),";",2)_U_$P($P(NODE,U,22),";",2)
        .S APPTDT=0 F  S APPTDT=$O(APPTARY(APPTDT)) Q:APPTDT'>0  S CNT=CNT+1,^XTMP(PXRMXTMP,PX,FACILITY,NAM,DDAT,PNAM,CNT,0)=APPTARY(APPTDT)
        Q
        ;
SUM(DFN,STATUS,FACILITY,NAM,LOC)        ;
        N ADDCNT,DUE,EVAL
        S (DUE,EVAL)=0
        ;Add dues to totals of reminders due and reminders applicable
        I STATUS["DUE NOW" D
        .S DUE=1,EVAL=1
        ;Add any that aren't N/A, Ignore on N/A,ERROR or NEVER to applicable total
        S STATUS=$P(STATUS,U)
        I (STATUS'=" ")&(STATUS'["NEVER")&(STATUS'="N/A")&(STATUS'["ERROR")&(STATUS'["CNBD") S EVAL=1
        ;Update XTMP - Total of reminders due
        I "IR"[PXRMTOT D
        .S ADDCNT=0
        .;Combined facility duplicate check
        .I PXRMCCS'="B" S ADDCNT=1
        .I ADDCNT=0,PXRMCCS="B",$$NEWCS(FACILITY,NAM,DFN,ITEM)=1 S ADDCNT=1
        .I PXRMFCMB="Y",'$$NEW(NAM,DFN,ITEM) S ADDCNT=0
        .I ADDCNT=1 D
        ..N CNT
        ..S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,NAM,ITEM)),U,1)
        ..S $P(^XTMP(PXRMXTMP,PX,FACILITY,NAM,ITEM),U,1)=CNT+EVAL
        ..;Total of reminders evaluated
        ..S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,NAM,ITEM)),U,2)
        ..S $P(^XTMP(PXRMXTMP,PX,FACILITY,NAM,ITEM),U,2)=CNT+DUE
        .I PXRMCCS="B" D
        ..N CNT
        ..S CNT=$P($G(^XTMP(PXRMXCCS,PX,FACILITY,NAM,LOC,ITEM)),U,1)
        ..S $P(^XTMP(PXRMXCCS,PX,FACILITY,NAM,LOC,ITEM),U,1)=CNT+EVAL
        ..;Total of reminders evaluated
        ..S CNT=$P($G(^XTMP(PXRMXCCS,PX,FACILITY,NAM,LOC,ITEM)),U,2)
        ..S $P(^XTMP(PXRMXCCS,PX,FACILITY,NAM,LOC,ITEM),U,2)=CNT+DUE
        ;
        ;Totals
        I "RT"[PXRMTOT D
        .;Check for duplicate patient at FACILITY level
        .I $D(^TMP("PXRMDUP",$J,FACILITY,DFN,ITEM)) Q
        .;Set duplicate check
        .S ^TMP("PXRMDUP",$J,FACILITY,DFN,ITEM)=""
        .I $G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL"))="" D
        ..S ^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL")="TOTAL"
        .N CNT
        .S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL",ITEM)),U,1)
        .S $P(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL",ITEM),U,1)=CNT+EVAL
        .S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL",ITEM)),U,2)
        .S $P(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL",ITEM),U,2)=CNT+DUE
        ;
        ;Total of patients
        I "IR"[PXRMTOT D
        .S ADDCNT=1
        .I PXRMSEL="I",$$NEWIP(DFN)<1 S ADDCNT=0
        .I PXRMLCMB="Y",ADDCNT=1,$$NEWP(@SUB,DFN)=0 S ADDCNT=0
        .I ADDCNT=1,$$NEW(FACILITY,@SUB,DFN)=0 S ADDCNT=0
        .I ADDCNT=1 D
        ..N CNT
        ..I $G(^XTMP(PXRMXTMP,PX,FACILITY,@SUB))="" S ^XTMP(PXRMXTMP,PX,FACILITY,@SUB)=NAM
        ..S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,@SUB)),U,3)
        ..S $P(^XTMP(PXRMXTMP,PX,FACILITY,@SUB),U,3)=CNT+1
        .I PXRMCCS="B" D
        ..N CNT
        ..I $G(^XTMP(PXRMXCCS,PX,FACILITY,@SUB,LOC))="" S ^XTMP(PXRMXCCS,PX,FACILITY,@SUB,LOC)=LOC
        ..S CNT=$P($G(^XTMP(PXRMXCCS,PX,FACILITY,@SUB,LOC)),U,3)
        ..S $P(^XTMP(PXRMXCCS,PX,FACILITY,@SUB,LOC),U,3)=CNT+1
        ;
        ;Total reports
        I "TR"[PXRMTOT D
        .I '$$NEWT(FACILITY,DFN) Q
        .I $G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL"))="" D
        ..S ^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL")=NAM
        .N CNT
        .S CNT=$P($G(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL")),U,3)
        .S $P(^XTMP(PXRMXTMP,PX,FACILITY,"TOTAL"),U,3)=CNT+1
        Q
        ;
ERRMSG(TYPE)    ;
        N CNT,CNT1,CNT2,STR,SUBJECT,NLINES,OUTPUT,TIME,TO
        K ^TMP("PXRMXMZ",$J)
        S NLINES=0,CNT=0,CNT1=2
        I TYPE="C" D  Q
        .M ^TMP("PXRMXMZ",$J)=^TMP($J,"PXRM CNBD")
        .S SUBJECT="REMINDER REPORTS CNBD PATIENT LIST ("_$$FMTE^XLFDT($$NOW^XLFDT)_")"
        .S TO(DUZ)=""
        .D SEND^PXRMMSG("PXRMXMZ",SUBJECT,.TO)
        I 'PXRMQUE D
        .S STR(1)="The Reminders Due Report "_$G(TITLE)_" requested by "_$$GET1^DIQ(200,DUZ,.01)_" on "_$$FMTE^XLFDT($G(PXRMXST))_" for the following reason(s):"
        .F  S CNT=$O(DBERR(CNT)) Q:CNT'>0  S STR(CNT1)="\\"_DBERR(CNT),CNT1=CNT1+1
        .D FORMAT^PXRMTEXT(1,80,2,.STR,.NLINES,.OUTPUT)
        .F CNT=1:1:NLINES W !,OUTPUT(CNT)
        I PXRMQUE D
        .S ^TMP("PXRMXMZ",$J,1,0)="The Reminders Due Report "_$G(TITLE)_" requested by "_$$GET1^DIQ(200,DUZ,.01)_" on "_$$FMTE^XLFDT($G(PXRMXST))_"was cancelled for the following reason(s):"
        .F  S CNT=$O(DBERR(CNT)) Q:CNT'>0  S ^TMP("PXRMXMZ",$J,CNT1,0)=DBERR(CNT),CNT1=CNT1+1
        .S SUBJECT="Cancelled Reminders Due Report ("_$$FMTE^XLFDT($$NOW^XLFDT)_")"
        .S TO(DUZ)=""
        .D SEND^PXRMMSG("PXRMXMZ",SUBJECT,.TO)
        .S ZTSTOP=1
        Q
