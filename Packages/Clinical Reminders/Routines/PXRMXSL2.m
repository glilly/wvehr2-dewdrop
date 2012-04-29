PXRMXSL2        ; SLC/AGP - Process Visits/Appts Reminder Due report; 06/03/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;
APPTS   ;
        ;Call to SDAMA301 for future appointments
        N APPTDT,BDT,EDT,NODE,DFN,FACILITY,HLIEN,NAM
        S NAM="All Locations"
        S BDT=PXRMBDT
        I PXRMEDT["." S EDT=PXRMEDT
        E  S EDT=PXRMEDT+.2359
        D SDAM301(BDT,EDT,PXRMSEL,PXRMFD,PXRMREP)
        I DBDOWN=1 Q
        S DFN=0 F  S DFN=$O(^TMP($J,"SDAMA301",DFN)) Q:DFN'>0!(ZTSTOP=1)  D
        .;Remove test patients.
        .I 'PXRMTPAT,$$TESTPAT^VADPT(DFN)=1 Q
        .;Remove patients that are deceased.
        .I 'PXRMDPAT,$P($G(^DPT(DFN,.35)),U,1)>0 Q
        .S APPTDT=0 F  S APPTDT=$O(^TMP($J,"SDAMA301",DFN,APPTDT)) Q:APPTDT'>0!(ZTSTOP=1)  D
        ..S NODE=$G(^TMP($J,"SDAMA301",DFN,APPTDT))
        ..S HLIEN=$P($P(NODE,U,2),";")
        ..S FACILITY=$P(^XTMP(PXRMXTMP,"HLOC",HLIEN),U,1)
        ..S NAM=$P(^XTMP(PXRMXTMP,"HLOC",HLIEN),U,2)
        ..I PXRMREP="D" D
        ...S ^TMP($J,"PXRM FUTURE APPT",DFN,HLIEN,APPTDT)=NODE
        ...S ^TMP($J,"PXRM FACILITY FUTURE APPT",DFN,FACILITY,APPTDT)=NODE
        ..I $$S^%ZTLOAD S ZTSTOP=1 Q
        ..D TMP^PXRMXSL1(DFN,NAM,FACILITY,HLIEN),MARK^PXRMXSL1(HLIEN)
        ..S ^TMP($J,"PXRM PATIENT EVAL",DFN)=""
        K ^TMP($J,"SDAMA301")
        Q
        ;
GETHFAC(HLOCIEN)        ;
        N DIV,HFAC
        ;DBIA #2804
        S HFAC=$P(^SC(HLOCIEN,0),U,4)
        I HFAC="" S DIV=$P($G(^SC(HLOCIEN,0)),U,15) S:DIV'="" HFAC=$P($G(^DG(40.8,DIV,0)),U,7)
        I HFAC="" S HFAC=+$P($$SITE^VASITE,U,3)
        Q +HFAC
        ;
SDAM301(BD,ED,PXRMSEL,PXRMFD,PXRMREP)   ;
        N ARRAY,BUSY,FACILITY,NAM,OPIEN,STATUS,TEXT
        K ^TMP($J,"PXRM FUTURE APPT")
        K ^TMP($J,"PXRM FACILITY FUTURE APPT")
        ;
        I ED'>0 S ARRAY(1)=BD
        I ED>0 S ARRAY(1)=BD_";"_ED
        I PXRMREP="D",PXRMSEL="L",PXRMFD="P" S ARRAY(1)=BD
        ;
        I $D(^XTMP(PXRMXTMP,"HLOC"))>0 S ARRAY(2)="^XTMP(PXRMXTMP,""HLOC"","
        ;S ARRAY(3)=$S(PXRMFD="P":"R;I;NS;NSR;CP;CPR;CC;CCR;NT",1:"R;I")
        S ARRAY(3)=$S(PXRMFD="P":"R;I",1:"R;I;NT")
        I $D(^TMP($J,"PXRM PATIENT LIST"))>0 S ARRAY(4)="^TMP($J,""PXRM PATIENT LIST"""
        S ARRAY("FLDS")="1;2;3;10;12;13;14;22"
        I $D(^TMP($J,"PXRM PATIENT LIST"))=0 S ARRAY("SORT")="P"
        ;
        N COUNT,END,START,BUSY
        S START=$H
        ;Initialize the busy counter.
        S BUSY=0
        D NOTIFY^PXRMXBSY("Calling the scheduling package to gather appointment data",.BUSY)
        S COUNT=$$SDAPI^SDAMA301(.ARRAY)
        S END=$H
        S TEXT="Elapsed time for call to the Scheduling Package: "_$$DETIME^PXRMXSL1(START,END)
        S ^XTMP(PXRMXTMP,"TIMING","SCHEDULING")=TEXT
        I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) W !,TEXT
        I COUNT<0 D  Q
        .N CNT
        .S DBDOWN=1,CNT=0
        .F  S CNT=$O(^TMP($J,"SDAMA301",CNT)) Q:CNT'>0  D
        ..S DBERR(CNT)=$G(^TMP($J,"SDAMA301",CNT))
        .D ERRMSG^PXRMXDT1("E")
        ;
LOOP    ;
        I PXRMFD'="P"!(PXRMSEL'="L") Q
        N APPTDT,CIEN,DFN,FUTDT,NODE,TEXT,VIEN
        ;LOOP THROUGH PATIENT
        S START=$H
        S BUSY=0
        S FUTDT=$S(DT>$P(ED,"."):DT,1:$P(ED,"."))
        D NOTIFY^PXRMXBSY("Sorting scheduling output",.BUSY)
        S DFN=0 F  S DFN=$O(^TMP($J,"SDAMA301",DFN)) Q:DFN'>0  D
        .;
        .;LOOP THROUGH CLINICS
        .S CIEN=0
        .F  S CIEN=$O(^TMP($J,"SDAMA301",DFN,CIEN)) Q:CIEN'>0  D
        ..S APPTDT=0
        ..F  S APPTDT=$O(^TMP($J,"SDAMA301",DFN,CIEN,APPTDT)) Q:APPTDT'>0  D
        ...I PXRMREP="S",$P(APPTDT,".")>$P(ED,".") Q
        ...S NODE=$G(^TMP($J,"SDAMA301",DFN,CIEN,APPTDT))
        ...;S STATUS=$P($P(NODE,U,3),";")
        ...;I ($P(ED,".")+1)>($P(APPTDT,".")),STATUS'="I",STATUS'="R",STATUS'="NT" D
        ...;.K ^TMP($J,"PXRM PATIENT LIST",DFN,CIEN,APPTDT)
        ...;
        ...;if report is detailed report store future appointment
        ...I $P(APPTDT,".")>FUTDT D
        ....S ^TMP($J,"PXRM FUTURE APPT",DFN,CIEN,APPTDT)=NODE
        ....S ^TMP($J,"PXRM FACILITY FUTURE APPT",DFN,$$GETHFAC(CIEN),APPTDT)=NODE
        K ^TMP($J,"SDAMA301")
        S END=$H
        S TEXT="Elapsed time for sorting scheduling output: "_$$DETIME^PXRMXSL1(START,END)
        S ^XTMP(PXRMXTMP,"TIMING","SCHEDULE SORT")=TEXT
        I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) W !,TEXT
        Q
        ;
        ;Scan visit file to build list of patients
VISITS  ;
        N BUSY,DAS,DATE,DFN,DS,END,ETIME,HLOC,NF
        N SC,START,TEMP,TEXT,TGLIST,TIME
        S START=$H
        K ^TMP($J,"PXRM PATIENT LIST")
        ;Initialize the busy counter.
        S BUSY=0
        D NOTIFY^PXRMXBSY("Building patient list",.BUSY)
        K ^TMP($J,"HLOCL"),^TMP($J,"PLIST")
        M ^TMP($J,"HLOCL")=^XTMP(PXRMXTMP,"HLOC")
        D FPLIST^PXRMLOCL(9000010,"HLOCL",-1,PXRMBDT,PXRMEDT,"PLIST")
        K ^TMP($J,"HLOCL")
        S DFN=""
        F  S DFN=$O(^TMP($J,"PLIST",DFN)) Q:DFN=""  D
        . D NOTIFY^PXRMXBSY("Building patient list",.BUSY)
        . S NF=0
        . F  S NF=$O(^TMP($J,"PLIST",DFN,NF)) Q:NF=""  D
        .. S TEMP=^TMP($J,"PLIST",DFN,NF)
        .. S SC=$P(TEMP,U,4)
        .. I '$D(PXRMSCAT(SC)) Q
        .. ;Remove test Patients
        .. I 'PXRMTPAT,$$TESTPAT^VADPT(DFN)=1 Q
        .. ;Remove deceased patients
        .. I 'PXRMDPAT,$P($G(^DPT(DFN,.35)),U,1)>0 Q
        .. S DAS=$P(TEMP,U,1),DATE=$P(TEMP,U,2),HLOC=$P(TEMP,U,3)
        .. S ^TMP($J,"PXRM PATIENT LIST",DFN,HLOC,DATE,DAS)=""
        K ^TMP($J,"PLIST")
        S END=$H
        S TEXT="Elapsed time for building patient list: "_$$DETIME^PXRMXSL1(START,END)
        S ^XTMP(PXRMXTMP,"TIMING","PATIENT LIST")=TEXT
        I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) W !,TEXT
        I PXRMREP="D" D SDAM301(PXRMBDT,PXRMEDT,PXRMSEL,PXRMFD,PXRMREP)
        I DBDOWN=1 Q
        S START=$H
        ;Initialize the busy counter.
        S BUSY=0
        N HLIEN,NAM,FACILITY,LSEL,NODE
        S DFN=0 F  S DFN=$O(^TMP($J,"PXRM PATIENT LIST",DFN)) Q:DFN'>0  D
        .S HLIEN=0
        .F  S HLIEN=$O(^TMP($J,"PXRM PATIENT LIST",DFN,HLIEN)) Q:HLIEN'>0  D
        ..D NOTIFY^PXRMXBSY("Removing invalid encounter(s)",.BUSY)
        ..S NODE=$G(^XTMP(PXRMXTMP,"HLOC",HLIEN))
        ..S FACILITY=$P(NODE,U),NAM=$P(NODE,U,2)
        ..D TMP^PXRMXSL1(DFN,NAM,FACILITY,HLIEN)
        ..S TEMP=$P(PXRMLCSC,U,1)
        ..S LSEL=$S(TEMP="CS":$P(NODE,U,3),TEMP="GS":$P(NODE,U,3),1:HLIEN)
        ..D MARK^PXRMXSL1(LSEL)
        ..S ^TMP($J,"PXRM PATIENT EVAL",DFN)=""
        S END=$H
        S TEXT="Elapsed time for removing invalid encounter(s): "_$$DETIME^PXRMXSL1(START,END)
        S ^XTMP(PXRMXTMP,"TIMING","REMOVING INVALID ENCOUNTER(S)")=TEXT
        I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) W !,TEXT
        Q
        ;
