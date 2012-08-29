PXRMXSE1        ; SLC/PJH - Build Patient lists for Reminder Due report; 06/08/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;
        ; Called/jobbed from PXRMXD
        ;
        ; Input - PXRMSEL,PXRMXTMP
        ;         PXRM*
        ; Output- ^XTMP(PXRMXTMP
        ;
        ;
START   ;  
        N LIT,TOTAL,TODAY,ZTSTOP,BUSY
        S DBDOWN=0
        S TOTAL=0,ZTSTOP="",TODAY=$$DT^XLFDT-.0001
        ;
        K ^TMP($J,"PXRM PATIENT LIST"),^TMP($J,"PXRM PATIENT EVAL")
        K ^TMP($J,"PXRM FUTURE APPT"),^TMP($J,"SDAMA301")
        K ^TMP($J),^TMP(PXRMRT,$J),^TMP("PXRMDUP",$J)
        K ^TMP("PXRMCMB",$J),^TMP("PXRMCMB1",$J),^TMP("PXRMCMB2",$J)
        K ^TMP("PXRMCMB3",$J),^TMP("PXRMCMB4",$J)
        N PXRMRERR
        ;
        ;Initialize the busy counter.
        S BUSY=0
        ;
        ;OE/RR team selected (PXRMOTM)
        I PXRMSEL="O" D OERR^PXRMXSL1
        ; 
        ;PCMM team selected (PXRMPCM)
        I PXRMSEL="T" D PCMMT^PXRMXSL1
        ;
        N HLIEN,FACILITY
        ;Location selected (PXRMLCHL,PXRMCGRP)
        I PXRMSEL="L" D  G:ZTSTOP=1 EXIT
        .;Build Clinic List
        .D BHLOC^PXRMXSL1
        .;Prior Visits - build patient list in ^TMP
        .I PXRMFD="P" D VISITS^PXRMXSL2 I DBDOWN=1 Q
        .;Inpatient Admissions and current inpatient locations
        .I PXRMFD="A"!(PXRMFD="C") D INPADM^PXRMXSL1
        .;Future Appointments - build patient list in ^TMP
        .I PXRMFD="F" D APPTS^PXRMXSL2 I DBDOWN=1 Q
        .;End task requested
        .Q:ZTSTOP=1
        ;Update ^XTMP from ^TMP
        ;Initialize the busy counter.
        S BUSY=0
        ;
        ;PCMM provider selected (PXRMPRV)
        I PXRMSEL="P" D PCMMP^PXRMXSL1
        ;
        ;Individual Patients selected (PXRMPAT)
        I PXRMSEL="I" D IND^PXRMXSL1
        ;
        ;Patient List selected (PXRMLIST)
        I PXRMSEL="R" D LIST^PXRMXSL1
        ;
        I DBDOWN=1 G EXIT
        S START=$H
        D EVAL^PXRMXEVL("PXRM PATIENT EVAL",.REMINDER)
        D XTMP(START)
        ;
        ;Update patient list
        I PXRMSEL'="I"&(PXRMUSER'="Y")&($G(PXRMLIS1)'="") D
        .;If no patients due delete patient list
        .I +$O(^TMP($J,"PXRMXPAT",""))=0 D  Q
        ..N DA,DIK S DA=PXRMLIS1,DIK="^PXRMXP(810.5," D ^DIK
        .;Otherwise create patient list
        .D UPDLST^PXRMRULE("PXRMXPAT",PXRMLIS1,"","","",PXRMDPAT,PXRMTPAT)
        .S $P(^PXRMXP(810.5,PXRMLIS1,0),U,9)=1
        K ^TMP($J,"PXRMXPAT")
        K ^TMP($J),^TMP(PXRMRT,$J),^TMP("PXRMDUP",$J)
        K ^TMP("PXRMCMB",$J),^TMP("PXRMCMB1",$J),^TMP("PXRMCMB2",$J)
        K ^TMP("PXRMCMB3",$J),^TMP("PXRMCMB4",$J)
        K DBDOWN
        ;Sorting is done, produce the output.
        D START^PXRMXPR
        Q
        ;
ERROR(STATUS,ITEM)      ;
        ;Create XTMP entry for Reminders that error out or could not be
        ;determing on evaluation
        N ERRNAME
        S STATUS=$P(STATUS,U)
        S ERRNAME=$P(^PXD(811.9,ITEM,0),U)
        I $D(^XTMP(PXRMXTMP,STATUS,ERRNAME))>0,^XTMP(PXRMXTMP,STATUS,ERRNAME)>0 D
        .S ^XTMP(PXRMXTMP,STATUS,ERRNAME)=^XTMP(PXRMXTMP,STATUS,ERRNAME)+1
        E  S ^XTMP(PXRMXTMP,STATUS,ERRNAME)=1
        Q
        ;
        ;End Task requested
EXIT    ;
        S ZTSK=$G(^XTMP(PXRMXTMP,"PRZTSK"))
        I ZTSK>0 D KILL^%ZTLOAD
        D EXIT^PXRMXGUT
        K DBDOWN
        Q
        ;
XTMP(START)     ;
        N CNT,CCNT,DDAT,II,INP,ITEM,LIT,LOC,LSSN,MCNBD,MCNBDR,NAME
        N SUB,STATUS,TEMP,TEXT
        K ^TMP($J,"PXRM CNBD")
        S CCNT=0,MCNBD=$G(^PXRM(800,1,"MIERR")),MCNBDR=0
        S BUSY=0,SUB="NAM",TEMP=0,PX="PXRM"
        N DDAT,DDUE,DEMARR,DFN,DLAST,DNEXT,FACILITY,NAM,PNAM
        S FACILITY="",DDAT="N/A"
        F  S FACILITY=$O(^TMP(PXRMRT,$J,FACILITY)) Q:FACILITY=""  D
        .S NAM=""
        .F  S NAM=$O(^TMP(PXRMRT,$J,FACILITY,NAM)) Q:NAM=""  D
        ..S LOC=""
        ..F  S LOC=$O(^TMP(PXRMRT,$J,FACILITY,NAM,LOC)) Q:LOC=""  D
        ...S DFN=""
        ...F  S DFN=$O(^TMP(PXRMRT,$J,FACILITY,NAM,LOC,DFN)) Q:DFN=""  D
        ....D NOTIFY^PXRMXBSY("Evaluating reminders",.BUSY)
        ....S INP=$G(^TMP(PXRMRT,$J,FACILITY,NAM,LOC,DFN))
        ....S CNT=0 F  S CNT=$O(REMINDER(CNT)) Q:CNT'>0  D
        .....S ITEM=$P(REMINDER(CNT),U,1),LIT=$P(REMINDER(CNT),U,4)
        .....I LIT="" S LIT=$P(REMINDER(CNT),U,2)
        .....S STATUS=$G(^TMP($J,"PXRM PATIENT EVAL",DFN,ITEM))
        .....I STATUS="" Q
        .....I STATUS["ERROR"!(STATUS["CNBD") D
        ......D ERROR(STATUS,ITEM) I STATUS["ERROR"!(MCNBDR=1) Q
        ......I CCNT=0 D
        .......S ^TMP($J,"PXRM CNBD",1,0)=" "_$$LJ^XLFSTR("PATIENT NAME",30)_$$RJ^XLFSTR("LAST 4",8)_"  REMINDER"
        .......S TEMP=" "
        .......F II=1:1:30 S TEMP=TEMP_"-"
        .......S TEMP=TEMP_"  "
        .......F II=1:1:6 S TEMP=TEMP_"-"
        .......S TEMP=TEMP_"  "
        .......F II=1:1:30 S TEMP=TEMP_"-"
        .......S ^TMP($J,"PXRM CNBD",2,0)=TEMP
        .......S CCNT=2
        ......S CCNT=CCNT+1
        ......I CCNT>MCNBD S MCNBDR=1 Q
        ......S NAME=$P(^DPT(DFN,0),U)
        ......S LSSN=$E($P(^DPT(DFN,0),U,9),6,9)
        ......S ^TMP($J,"PXRM CNBD",CCNT,0)=" "_$$LJ^XLFSTR(NAME,30)_$$RJ^XLFSTR(LSSN,8)_"  "_$$LJ^XLFSTR(LIT,30)
        .....;Add reminder status to patient list TMP Global
        .....I STATUS["DUE NOW" S ^TMP($J,"PXRMXPAT",DFN,"REM",ITEM)=ITEM_U_STATUS
        .....I PXRMREP="D" D SDET^PXRMXDT1(DFN,STATUS,NAM,FACILITY,INP)
        .....I PXRMREP="S" D SUM^PXRMXDT1(DFN,STATUS,FACILITY,NAM,LOC)
        I $D(^TMP($J,"PXRM CNBD"))>0 D ERRMSG^PXRMXDT1("C")
        K ^TMP($J,"PXRM CNBD")
        S TEXT="Elapsed time for reminder evaluation: "_$$DETIME^PXRMXSL1(START,$H)
        S ^XTMP(PXRMXTMP,"TIMING","REMINDER EVALUATION")=TEXT
        I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) W !,TEXT
        K ^TMP($J,"PXRM PATIENT EVAL")
        Q
        ;
