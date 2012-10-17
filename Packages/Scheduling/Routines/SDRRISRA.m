SDRRISRA        ;10N20/MAH;Recall Reminder Scheduled Report;01/18/2008
        ;;5.3;Scheduling;**536**;Aug 13, 1993;Build 53
        ; Option: SDRR RECALL APPOINTMENTS
EN      ;
        N ARHST,ARHND,ARHSTX,ARHNDX,ARHBRK,ARHABORT,I,ZTSAVE,XMDUZ,XMSUB,ZTSK
        N ARHDIV,ARHDAYS,DIR,X,Y,Z,ZTDESC,ZTQUEUED
        I '$D(^SD(403.56,"C")) W !!,"***No Entries Have Been Scheduled For Appointments***" Q
        S ARHABORT=0
        W !!,"Select a time period and a set of clinics, and I'll tell you all the"
        W !,"patients who were on the Recall List, but were deleted from the list"
        W !,"because they've made appointments."
        W !!,"First select the Recall Date range. The default dates are determined by the"
        W !,"entries in Recall Reminders Removed File."
        S ARHST=$O(^SD(403.56,"C",""))
        S ARHND=$O(^SD(403.56,"C",""),-1)
        D DRANGE^SDRRUTL(.ARHST,.ARHND,.ARHSTX,.ARHNDX,.ARHABORT,ARHST,ARHND) Q:ARHABORT
        K ^TMP("SDRR",$J)
        D ASKDIV^SDRRPXC(.ARHDIV) Q:'ARHDIV
        D ASKCLIN^SDRRPXC(.ARHDIV,ARHST,ARHND) Q:'$D(^TMP("SDRR",$J))
        W !
        K DIR,X,Y
        S DIR(0)="Y"
        S DIR("A")="Page break on clinic"
        S DIR("B")="Yes"
        D ^DIR Q:$D(DIRUT)
        K DIRUT
        S ARHBRK=Y ; Page break on Clinic
        S XMSUB="Scheduled Recall Appointments, "_$S(ARHST=ARHND:ARHSTX,1:ARHSTX_"-"_ARHNDX)
        F I="ARHDIV","ARHDIV(","ARHST","ARHSTX","ARHND","ARHNDX","ARHBRK","ARHDAYS","^TMP(""SDRR"",$J," S ZTSAVE(I)=""
        D EN^XUTMDEVQ("CONTROL^SDRRISRA",XMSUB,.ZTSAVE,,1)
        I '$D(ZTQUEUED),$D(ZTSK) W !,"Request queued.  (Task: ",ZTSK,")"
        Q
CONTROL ;
        N ARHIA,ARHCLIST
        S ARHIA=$E($G(IOST),1,2)="C-"
        D CLINLIST^SDRRISB(.ARHCLIST)
        D GATHER
        D PRINT
        K ^TMP("SDRR",$J)
        Q
GATHER  ; Gather Patient from Recall Deletions List
        N ARHDT,ARHIEN,ARHDFN,ARHREC,ARHDFN0,ARHCLIN,ARHSDT,ARHADT,ARHADAYS,DFN,ARHMADE,ARHCOM
        S ARHND=ARHND+.9999
        S (ARHCLIN,ARHIEN)="" ; "D" xref is on Clinic and Recall Date
        F  S ARHCLIN=$O(ARHCLIST(ARHCLIN)) Q:'ARHCLIN  D
        . Q:'$D(^SD(403.56,"D",ARHCLIN))
        . S ARHDT=ARHST-.1
        . F  S ARHDT=$O(^SD(403.56,"D",ARHCLIN,ARHDT)) Q:ARHDT>ARHND!'ARHDT  D
        . . F  S ARHIEN=$O(^SD(403.56,"D",ARHCLIN,ARHDT,ARHIEN)) Q:'ARHIEN  D
        . . . S ARHADT=+$G(^SD(403.56,ARHIEN,1)) ; Appointment date
        . . . Q:'ARHADT  ; got appt.?
        . . . S ARHREC=$G(^SD(403.56,ARHIEN,0))
        . . . S ARHDFN=+ARHREC
        . . . Q:$$TESTPAT^VADPT(ARHDFN)  ; Test patient
        . . . S DFN=ARHDFN
        . . . D ADD^VADPT,DEM^VADPT
        . . . Q:$G(VADM(6),U)'=""
        . . . S ARHSDT=$P(ARHREC,U,10) ; Reminder sent date
        . . . N SDARRAY,SDCOUNT,SDDATE,SDAPPT
        . . . S SDARRAY(1)=""_$P(ARHADT,".",1)_";"_$P(ARHADT,".",1)_""
        . . . S SDARRAY(2)=ARHCLIN
        . . . S SDARRAY(4)=DFN
        . . . S SDARRAY("FLDS")="16"
        . . . S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY)
        . . . I SDCOUNT>0 D
        . . . . S SDDATE=0 F  S SDDATE=$O(^TMP($J,"SDAMA301",DFN,ARHCLIN,SDDATE)) Q:SDDATE=""  D
        . . . . . S SDAPPT=$G(^TMP($J,"SDAMA301",DFN,ARHCLIN,SDDATE))
        . . . . . S ARHMADE=$P(SDAPPT,"^",16)
        . . . I SDCOUNT'=0 K ^TMP($J,"SDAMA301")
        . . . S ARHADAYS=$$FMDIFF^XLFDT(ARHADT,ARHDT)
        . . . S ARHCOM=$P($G(ARHREC),"^",7)
        . . . S ^TMP("SDRR",$J,"PRT",ARHCLIST(ARHCLIN)_U_ARHCLIN,ARHADAYS,$P(VADM(1),U)_U_ARHDFN,ARHADT)=$P(VA("BID"),U)_U_ARHDT_U_ARHSDT_U_ARHMADE_U_ARHCOM
        D KVAR^VADPT
        Q
PRINT   ;
        N ARHTODAY,ARHCLIN,ARHCLSAV,ARHDT,ARHREC,ARHPAGE,ARHABORT,ARHDR,ARHADT,ARHSP
        N ARHPAT,ARHSSN,ARHCNT,ARHDTX,ARHSDT,ARHADAYS,ARHPROV,ARHDFN,ARHOTHER,ARHCOMM
        S (ARHABORT,ARHPAGE)=0
        I ARHIA W @IOF
        S ARHTODAY=$$FMTE^XLFDT(DT)
        S ARHDR=$$CJ^XLFSTR(ZTDESC,IOM-1)
        S $E(ARHDR,1,$L(ARHTODAY))=ARHTODAY
        S ARHDR=$E(ARHDR,1,IOM-8)_"Page"
        D HEADER
        I '$D(^TMP("SDRR",$J,"PRT")) W !,"No Scheduled Recall Appointments found for this date range." Q
        S (ARHCLIN,ARHPAT,ARHADAYS,ARHADT)=""
        S ARHCLSAV=ARHCLIN
        F  S ARHCLIN=$O(^TMP("SDRR",$J,"PRT",ARHCLIN)) Q:ARHCLIN=""  D  Q:ARHABORT
        . I ARHCLSAV'="",ARHBRK!($Y+5+ARHIA>IOSL) D  Q:ARHABORT
        . . I ARHIA D PAGE^XMXUTIL(.ARHABORT) Q:ARHABORT
        . . W @IOF D HEADER
        . S ARHCLSAV=ARHCLIN
        . S ARHPROV=$$PRDEF^SDCO31($P(ARHCLIN,U,2))
        . I ARHPROV="" S ARHPROV="(No Default Provider)"
        . W !!,$$CJ^XLFSTR(" "_$P(ARHCLIN,U)_"    "_ARHPROV_" ",79,"-")
        . S ARHCNT=0
        . F  S ARHADAYS=$O(^TMP("SDRR",$J,"PRT",ARHCLIN,ARHADAYS),-1) Q:ARHADAYS=""  D  Q:ARHABORT
        . . F  S ARHPAT=$O(^TMP("SDRR",$J,"PRT",ARHCLIN,ARHADAYS,ARHPAT)) Q:ARHPAT=""  D  Q:ARHABORT
        . . . S ARHDFN=$P(ARHPAT,U,2)
        . . . F  S ARHADT=$O(^TMP("SDRR",$J,"PRT",ARHCLIN,ARHADAYS,ARHPAT,ARHADT)) Q:'ARHADT  S ARHREC=^(ARHADT) D  Q:ARHABORT
        . . . . S ARHCNT=ARHCNT+1
        . . . . S ARHSSN=$E(ARHREC,1,4)
        . . . . S ARHDT=$P(ARHREC,U,2)
        . . . . S ARHSDT=$P(ARHREC,U,3)
        . . . . S ARHMADE=$P(ARHREC,U,4)
        . . . . S ARHCOMM=$P(ARHREC,U,5)
        . . . . I $Y+2+($L(ARHCOMM)>18)+ARHIA>IOSL D  Q:ARHABORT
        . . . . . I ARHIA D PAGE^XMXUTIL(.ARHABORT) Q:ARHABORT
        . . . . . W @IOF D HEADER
        . . . . W !,$E($P(ARHPAT,U),1,14),?15,ARHSSN,?20,$$FMTE^XLFDT($E(ARHSDT,1,7),"2Z"),?29,$$FMTE^XLFDT($E(ARHDT,1,7),"2Z"),?38,$$FMTE^XLFDT($E(ARHADT,1,7),"2Z"),?47,$J(ARHADAYS,4)
        . . . . W ?52,$$FMTE^XLFDT($E(ARHMADE,1,7),"2Z") I $L(ARHCOMM)<19 W ?61,ARHCOMM Q
        . . . . Q:ARHCOMM=""
        . . . . W !,$$RJ^XLFSTR($E(ARHCOMM,1,79),79)
        . Q:ARHABORT
        . D SUBTOT
        Q:ARHABORT
        I ARHIA D WAIT^XMXUTIL
        Q
HEADER  ;
        S ARHPAGE=ARHPAGE+1
        W ARHDR,$J(ARHPAGE,3)
        W !!,?20,"Reminder",?47,"Days",?52,"Appt"
        W !,"Patient",?15,"SSN",?20,"Sent",?29,"Recall",?38,"Appt",?47,"Diff",?52,"Made",?61,"Other Info"
        W !,"-------------- ---- -------- -------- -------- ---- -------- ------------------"
        Q
SUBTOT  ;
        I $Y+3+ARHIA>IOSL D  Q:ARHABORT
        . I ARHIA D PAGE^XMXUTIL(.ARHABORT) Q:ARHABORT
        . W @IOF D HEADER
        W !!,"Scheduled Recall Appointments: ",ARHCNT
        Q
