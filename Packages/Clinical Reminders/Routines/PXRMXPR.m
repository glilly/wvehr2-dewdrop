PXRMXPR ; SLC/PJH,PKR - Print Reminder Due report. ;05/05/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;
        ; Called/Jobbed after PXRMXSE1
        ;
START   N BMARG,CRITERIA,C1S,C2S,C3S,C1HS,C2HS,C3HS,DONE,FIRST,HEAD
        N INDENT,PAGE,MOD,DES,ADES,CDES,RDES,SDES,MISSED,SEP
        N PLSTCRIT,PXRMOPT,PXRMFLD,PXRMHDR,PXRMHDRS,PXRMT,PXRMH,VDUZ
        N BD,ED,EMPCHK,SD,RD
        N PXRMTX
        N IOP,POP,XMDUZ,XMQUIET,XMSUB,XMY,%ZIS
        ;Check for output to p-message. TaskMan will automatically copy
        ;^TMP("XM-MESS",$J) to the tasked job.
        I $D(^TMP("XM-MESS",$J)) D
        . S XMQUIET=1
        . S XMDUZ=$G(^TMP("XM-MESS",$J,"XMAPHOST","XMINSTR","FROM"))
        . I XMDUZ="" S XMDUZ=^TMP("XM-MESS",$J,"XMAPHOST","XMDUZ")
        . S XMSUB=^TMP("XM-MESS",$J,"XMAPHOST","XMSUB")
        . S VDUZ=""
        . F  S VDUZ=$O(^TMP("XM-MESS",$J,"XMY",VDUZ)) Q:VDUZ=""  S XMY(VDUZ)=""
        . I $D(XMY(DUZ)),$D(^TMP("XM-MESS",$J,"XMAPHOST","XMINSTR","SELF BSKT")) S XMY(DUZ,0)=^TMP("XM-MESS",$J,"XMAPHOST","XMINSTR","SELF BSKT")
        S IOP=PXRMIOP
        I $D(PXRMHFIO) S %ZIS("HFSNAME")=PXRMHFIO
        D ^%ZIS
        I POP G EXIT
        U IO
        S PXRMTX="due"
        I PXRMREP="D" D
        .S EMPCHK=$P($G(^PXRM(800,1,"TRUNCATE EMPLOYEE SSN")),U)
        .I EMPCHK="" S EMPCHK="Y"
        ;
        ; Format Date Range
        I PXRMSEL="L" D
        .S BD=$$FMTE^XLFDT(PXRMBDT,"5D")
        .S ED=$$FMTE^XLFDT(PXRMEDT,"5D")
        ; Format due effective date
        S SD=$$FMTE^XLFDT(PXRMSDT,"5P")
        ; Format run date
        S RD=$$FMTE^XLFDT(PXRMXST,"5P")
        S DONE=0
        ;
        ;Delimited report.
        S SEP=$S(PXRMTABS="Y":PXRMTABC,1:"")
        ;
        ;Setup initial formatting parameters.
        S INDENT=3
        S BMARG=2,PAGE=0,HEAD=1
        ;
        I +$G(XQY)>0 N XQOPT D OP^XQCHK
        S PXRMOPT=$P($G(XQOPT),U,2)
        I ($L(PXRMOPT)>0)&(PXRMOPT'["Clinical") S PXRMOPT="Clinical "_PXRMOPT
        I PXRMREP="D" D
        .S RDES=$P(REMINDER(1),U,2)
        .S PXRMOPT=PXRMOPT_" - Detailed Report"
        .N IC F IC=0,3,4 S PXRMH(IC)="",PXRMT(IC)=0
        .S PXRMH(1)="Date Due    Last Done   Next Appt"
        .S PXRMH(2)="--------    ---------   ---------"
        .I $G(PXRMINP) D
        ..S PXRMH(1)="Date Due    Last Done   Ward/Bed"
        ..S PXRMH(2)="--------    ---------   --------"
        .F IC=1,2 S PXRMT(IC)=40
        .S ADES="Next Appointment only"
        .I PXRMFUT="Y" S ADES="All Future Appointments"
        .S SDES="Sorted by Patient Name"
        .I PXRMSRT="Y" S SDES="Sorted by Appointment Date"
        I PXRMREP="S" D
        .S PXRMOPT=PXRMOPT_" - Summary Report"
        .S PXRMH(0)="# Patients with Reminders",PXRMT(0)=$S(PXRMPER=0:50,1:20)
        .I PXRMPER=1 D
        ..S PXRMH(1)="Applicable     Due       %Appl   %Due   %Done"
        ..S PXRMH(2)="----------     ---       -----   ----   -----"
        .I PXRMPER=0 D
        ..S PXRMH(1)="Applicable         Due"
        ..S PXRMH(2)="----------         ---"
        .N IC F IC=1,2 S PXRMT(IC)=$S(PXRMPER=0:50,1:20)
        .S PXRMH(3)="Denominator"
        .S PXRMH(4)="-----------"
        .F IC=3,4 S PXRMT(IC)=0
        ;
        ;Print Criteria Page if normal report
        S CRITERIA=0 I PXRMTABS="N" S CRITERIA=1
        ;or delimited report with notemplate
        I PXRMTABS="Y",PXRMTMP="" S CRITERIA=1
        ;
        ;Build array of locations/providers with no patients selected in
        ;MISSED.
        D NOPATS^PXRMXPR1(.MISSED)
        ;
        ;Print either criteria page or summary header
        I CRITERIA D  G:DONE EXIT
        .D PAGE^PXRMXGPR Q:DONE
        .D CRIT^PXRMXGPR(10,.PLSTCRIT) Q:DONE
        ;Header if delimited output from a template
        I 'CRITERIA D
        .N HDR1,HDR2,HDR3
        .S HDR1="",HDR2="",HDR3=""
        .I PXRMTMP]"" S HDR1="TITLE:"_$P(PXRMTMP,U,2)_U_"TEMPLATE:"_$P(PXRMTMP,U,3)
        .I PXRMTMP="" D
        ..N PXRMFLD,DES,CDES D LITS^PXRMXPR1 S HDR1=PXRMFLD_U_$G(DES)_U_$G(CDES)
        .I PXRMSEL="L" S HDR2="START:"_BD_U_"END:"_ED
        .S HDR2=HDR2_U_"RUN:"_RD_"Effective Date:"_SD
        .I PXRMFCMB="Y" S HDR3="COMBINED FACILITY"
        .I PXRMLCMB="Y" S $P(HDR3,SEP,2)="COMBINED LOCATION"
        .I PXRMTCMB="Y" S $P(HDR3,SEP,2)="COMBINED OE/RR TEAMS"
        .I PXRMREP="S" D
        ..N LIT1,LIT2,LIT3
        ..D LIT^PXRMXD
        ..I PXRMTOT="I" S $P(HDR3,SEP,3)=$$UP^XLFSTR(LIT1)
        ..I PXRMTOT="R" S $P(HDR3,SEP,3)=$$UP^XLFSTR(LIT2)
        ..I PXRMTOT="T" S $P(HDR3,SEP,3)=$$UP^XLFSTR(LIT3)
        .S PLSTCRIT(1)=HDR1,PLSTCRIT(2)=HDR2,PLSTCRIT(3)=HDR3
        .W !,HDR1,!,HDR2,!,HDR3,!
        ;
        ;Kill items marked as found
        K ^XTMP(PXRMXTMP,"MARKED AS FOUND")
        ;
        ;Setup the final formatting parameters.
        S C1HS=INDENT+3
        S C1S=0
        S C2HS=C1S+2
        S C2S=C2HS
        S C3HS=C2HS+5
        S C3S=C3HS
        S HEAD=1
        S INDENT=10
        ;
        ; Update last run date
        I $G(PXRMTMP)'="" D UPD^PXRMXTU
        ;
        ; Get report detail from ^XTMP
        N DUECNT,PNAM,SUB,DFN,BID,NAM,FAC,MOD,SRT,TOTAL,APPL,FACPNAME,PX,TTOTAL
        S TTOTAL=0
        ; Set subroutine label from report format
        S MOD="SUMARY" I PXRMREP="D" S MOD="DETAIL"
        ;
        S FAC=0,PX="PXRM"
        F  S FAC=$O(^XTMP(PXRMXTMP,PX,FAC)) Q:FAC=""  Q:DONE  D
        .;Get facility name for Location and PCMM team report
        .I "TL"[PXRMSEL,PXRMFCMB="N" D
        ..S FACPNAME=$P(PXRMFACN(FAC),U,1)_"  "_$P(PXRMFACN(FAC),U,2)
        .;Report from ^XTMP - label MOD is DETAIL/SUMARY
        .S (PNAM,SUB,NAM,SRT)=""
        .I PXRMSEL="I" S SUB="INDIVIDUAL PATIENTS" D @MOD Q:DONE
        .I PXRMSEL'="I" D
        ..;Sort internal IENs into alpha order
        ..D XSORT
        ..F  S SRT=$O(^TMP($J,"SORT",SRT)) Q:SRT=""  Q:DONE  D
        ...S SUB=$G(^TMP($J,"SORT",SRT)) D @MOD
        ..I MOD="SUMARY","RT"[PXRMTOT S SUB="TOTAL" D @MOD
        ;
        ; Null report if no patients selected
        I ('DONE),$O(^XTMP(PXRMXTMP,PX,""))="" D NULL^PXRMXGPR G EXIT
        ; Report selected patient sample with no patients
        I $D(MISSED),PXRMPML=1 D MISSED^PXRMXPR1(0,.MISSED)
        ;
        ;Print Patient List
        I $G(PATLST)="Y" D FOOTER^PXRMXPR1(.PLSTCRIT)
        ;
        ;Print Error message
        I $D(^XTMP(PXRMXTMP,"ERROR"))>0!($D(^XTMP(PXRMXTMP,"CNBD"))>0) D ERROR^PXRMXBSY
EXIT    ;
        D TIMING^PXRMXGUT
        D EXIT^PXRMXGUT
        ;
        ;Allow the task to be cleaned up upon successful completion.
        I $D(ZTQUEUED) S ZTREQ="@"
        D EOR^PXRMXGUT
        Q
        ;
        ;Report by Patient
DETAIL  N JJ,VA,DATE,COUNT,DDAT,EMP
        N BED,DDUE,DDONE,DNEXT,FDAT1,FDAT2,FDAT3,FNAM,FTXT
        S NAM=$G(^XTMP(PXRMXTMP,PX,FAC,SUB)),HEAD=1
        S COUNT=$P(NAM,U,2),TOTAL=$P(NAM,U,3),APPL=$P(NAM,U,4),NAM=$P(NAM,U,1)
        S DDAT="",JJ=0
        ; Get list of patients for each appointment date
        F  S DDAT=$O(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT)) Q:DDAT=""  Q:DONE  D PAT
        ; No patients due
        I JJ=0 D:'DONE NONE^PXRMXGPR
        ; Total patients
        D:'DONE TOTAL^PXRMXGPR
        S TTOTAL=TTOTAL+TOTAL
        Q
        ;
PAT     ;Extract and print patient detail
        N DNEXT1,NODE,PNUM
        F  S PNAM=$O(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT,PNAM)) Q:PNAM=""  Q:DONE  D
        .S JJ=JJ+1
        .;Format print line
        .S (BID,DNEXT1,FDAT1,FDAT2,FDAT3,DNEXT1)="" I PNAM'["No patients found" D
        ..S FDAT2="N/A",FDAT3="None"
        ..S NODE=$G(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT,PNAM))
        ..S DDUE=$P(NODE,U,2),DDONE=$P(NODE,U,3),DNEXT=$P(NODE,U,4)
        ..S BED=$P(NODE,U,5)
        ..S DFN=$P(NODE,U) S BID=$P($G(PNAM),U,2)
        ..I PXRMSSN="N" S BID=$E(BID,6,9)
        ..I PXRMSSN="Y",EMPCHK="Y" D EMP S:EMP BID=$E(BID,6,9)
        ..S BID="("_BID_")"
        ..S FDAT1=$$FMTE^XLFDT(DDUE,"5D")
        ..I DDONE S FDAT2=$$FMTE^XLFDT(DDONE,"5D")
        ..I BED'="NONE" S FDAT3=$P(NODE,U,5),DNEXT1=$$FMTE^XLFDT(DNEXT,"5D")
        ..I DNEXT,FDAT3="None" S FDAT3=$$FMTE^XLFDT(DNEXT,"5D")
        .;Print
        .D CHECK Q:DONE
        .;Normal output
        .I PXRMTABS="N" D
        ..S PNUM=JJ#10000
        ..S PNUM=$$RJ^XLFSTR(PNUM,4)
        ..W !,PNUM,?5,$E($P($G(PNAM),U),1,33-$L(BID))," ",BID,?40,FDAT1,?52,FDAT2
        ..I ('$G(PXRMINP)),PXRMFUT'="Y" W ?64,$S(BED'="NONE":BED_" (Inp.)",1:FDAT3)
        ..I $G(PXRMINP) W ?64,BED
        ..I DNEXT1'="",PXRMFUT'="Y" W !,?64,DNEXT1
        .;Delimited report
        .I PXRMTABS="Y" D
        ..N FNAM
        ..S FNAM=$P($G(PNAM),U)
        ..I FNAM'["No patients found" S FNAM=$E(FNAM,1,33-$L(BID))_" "_BID
        ..I "CES"[PXRMTABC S FNAM=$TR(FNAM,SEP,"_"),FDAT1=$TR(FDAT1,SEP,"_")
        ..I BED="NONE" S BED=" "
        ..W !,JJ_SEP_FNAM_SEP_FDAT1_SEP_FDAT2 I $G(PXRMINP) W SEP_BED
        ..I ('$G(PXRMINP)),PXRMFUT'="Y" W SEP_FDAT3_SEP_BED
        .;---
        .; Future Appointments
        .I PXRMFUT="Y" D
        ..N CNT,ADAT,ALOC,ATYP,FIRST,NONE
        ..S CNT=0,NONE=1,FIRST=1
        ..I '$D(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT,PNAM)) Q
        ..F  S CNT=$O(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT,PNAM,CNT)) Q:CNT'>0  D
        ...S ADAT=$P(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT,PNAM,CNT,0),U)
        ...I PXRMDLOC="Y" D
        ....S ALOC=$P(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT,PNAM,CNT,0),U,2)
        ....S ATYP=$P(^XTMP(PXRMXTMP,PX,FAC,SUB,DDAT,PNAM,CNT,0),U,3)
        ...S ADAT=$$FMTE^XLFDT(ADAT,"2P")
        ...I FIRST D  S FIRST=0,NONE=0
        ....I PXRMTABS="N" W ?64,$S(BED'="NONE":BED_" (Inp.)",1:"")
        ...D CHECK
        ...I PXRMDLOC="Y" D
        ....I PXRMTABS="N" W !,?8,ADAT,?30,$E(ALOC,1,25),?60,$E(ATYP,1,20)
        ....I PXRMTABS="Y" W SEP_ADAT_SEP_$E(ALOC,1,25)_SEP_$E(ATYP,1,20)
        ...I PXRMDLOC="N" D
        ....I PXRMTABS="N" W !,?10,ADAT
        ....I PXRMTABS="Y" W SEP_ADAT
        ..I NONE,PXRMTABS="N" W ?64,FDAT3
        ..I NONE,PXRMTABS="Y" W SEP_FDAT3
        ..I PXRMTABS="Y" W $S(BED'="NONE":SEP_BED_" (Inp.)",1:"")
        ..K ^UTILITY("VASD",$J)
        Q
        ;
        ;Summary by Reminder
SUMARY  ;
        N JJ,EVAL,DUE,RNAM,RNUM,ITEM,COUNT,FTXT,PAPPL,PDUE,PDONE,PERCENT
        S NAM=$G(^XTMP(PXRMXTMP,PX,FAC,SUB)),HEAD=1
        S TOTAL=$P(NAM,U,3),COUNT=$P(NAM,U,2),NAM=$P(NAM,U,1)
        S RNUM=$O(REMINDER(""),-1)
        ;Get reminders in alpha order
        F JJ=1:1:RNUM D  Q:DONE
        .S ITEM=$P(REMINDER(JJ),U,1),RNAM=$P(REMINDER(JJ),U,4)
        .S:RNAM="" RNAM=$P(REMINDER(JJ),U,2)
        .; zero lines will be printed
        .S DUE=$G(^XTMP(PXRMXTMP,PX,FAC,SUB,ITEM))
        .S EVAL=+$P(DUE,U,1),DUE=+$P(DUE,U,2)
        .D SUMP(RNAM,NAM,TOTAL,EVAL,DUE)
        D:'DONE TOTAL^PXRMXGPR
        I $G(SUB)'="TOTAL",PXRMTOT'="T" S TTOTAL=TTOTAL+TOTAL
        I $G(SUB)="TOTAL",PXRMTOT="T" S TTOTAL=TTOTAL+TOTAL
        I PXRMCCS="B" D
        .N LOC,SUBTOT
        .S LOC="" F  S LOC=$O(^XTMP(PXRMXCCS,PX,FAC,SUB,LOC)) Q:LOC=""  D
        ..S NAM=$G(^XTMP(PXRMXCCS,PX,FAC,SUB,LOC)),HEAD=1
        ..S TOTAL=$P(NAM,U,3),COUNT=$P(NAM,U,2),NAM=$P(NAM,U,1)
        ..S NAM="Clinic Stop "_SUB_" location "_NAM
        ..S RNUM=$O(REMINDER(""),-1)
        ..;Get reminders in alpha order
        ..F JJ=1:1:RNUM D  Q:DONE
        ...S ITEM=$P(REMINDER(JJ),U,1),RNAM=$P(REMINDER(JJ),U,4)
        ...S:RNAM="" RNAM=$P(REMINDER(JJ),U,2)
        ...; zero lines will be printed
        ...S DUE=$G(^XTMP(PXRMXCCS,PX,FAC,SUB,LOC,ITEM))
        ...S EVAL=+$P(DUE,U,1),DUE=+$P(DUE,U,2)
        ...D SUMP(RNAM,NAM,TOTAL,EVAL,DUE)
        ..D:'DONE TOTAL^PXRMXGPR
        Q
        ;
SUMP(RNAM,NAM,TOTAL,EVAL,DUE)   ;
        ;Print
        D CHECK Q:DONE
        ;Normal Report
        I PXRMTABS="N" D
        .I PXRMPER=1 D
        ..S PERCENT=$$DOPER^PXRMXGPR(TOTAL,EVAL,DUE)
        ..S PAPPL=$P(PERCENT,U),PDUE=$P(PERCENT,U,2),PDONE=$P(PERCENT,U,3)
        ..W !,JJ,?5,RNAM
        ..W !,?20,$J(EVAL,10),?29,$J(DUE,8),?45,$J(PAPPL,5),?53,$J(PDUE,4),?60,$J(PDONE,5)
        .I PXRMPER=0 D
        ..W !,JJ,?5,RNAM,?50,$J(EVAL,10),?62,$J(DUE,10)
        ;Condensed Report
        I PXRMTABS="Y" D
        .I "CES"[PXRMTABC S RNAM=$TR(RNAM,SEP,"_")
        .I PXRMPER=1 D
        ..S PERCENT=$$DOPER^PXRMXGPR(TOTAL,EVAL,DUE)
        ..S PAPPL=$P(PERCENT,U),PDUE=$P(PERCENT,U,2),PDONE=$P(PERCENT,U,3)
        ..W !,JJ_SEP_RNAM_SEP_EVAL_SEP_DUE_SEP_$TR(NAM,SEP,"_")_SEP_PAPPL_SEP_PDUE_SEP_PDONE_SEP
        .I PXRMPER=0 W !,JJ_SEP_RNAM_SEP_EVAL_SEP_DUE_SEP_$TR(NAM,SEP,"_")_SEP
        Q
        ;
        ;Check line count before writing line
CHECK   I ((PXRMTABS="N")&($Y>(IOSL-BMARG-3)))!(HEAD=1) D COL^PXRMXGPR(1)
        Q
        ;
        ;Check if employee
EMP     N VAEL
        D ELIG^VADPT
        ;Check TYPE (#391) field
        I $P($G(VAEL(6)),U,2)="EMPLOYEE" S EMP=1 Q
        ;Check PATIENT ELIGABILITY (#361) field
        N ELIG
        S ELIG=0,EMP=0
        F  S ELIG=$O(VAEL(1,ELIG)) Q:'ELIG  D  Q:EMP
        .I $P($G(VAEL(1,ELIG)),U,2)="EMPLOYEE" S EMP=1
        Q
        ;
        ;Sort internal numbers into Alpha order
XSORT   N SUB,NAM
        K ^TMP($J,"SORT")
        S SUB=""
        F  S SUB=$O(^XTMP(PXRMXTMP,PX,FAC,SUB)) Q:SUB=""  D
        .Q:SUB="TOTAL"
        .S NAM=$P(^XTMP(PXRMXTMP,PX,FAC,SUB),U)
        .I NAM="" S NAM=SUB
        .S ^TMP($J,"SORT",NAM)=SUB
        Q
        ;
