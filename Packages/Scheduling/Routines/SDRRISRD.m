SDRRISRD        ;10N20/MAH;-Recall List Delinquencies ;01/18/2008  11:32
        ;;5.3;Scheduling;**536**;Aug 13, 1993;Build 53
        ;
        ; Option: SDRR RECALL DELINQUENCIES
EN      ;
        N SDRRST,SDRRND,SDRRSTX,SDRRNDX,SDRRBRK,SDRRABORT,I,ZTSAVE,XMDUZ,XMSUB,ZTSK,VA,VADM,VAPA
        N SDRRDIV,SDRRDAYS,DIR,X,Y,Z,ZTDESC,ZTQUEUED
        S SDRRABORT=0
        W !!,"Select a time period and a set of clinics, and I'll tell you all the"
        W !,"patients who are on the Recall List for that time period at those clinics"
        W !,"who've been sent reminders, but haven't yet made an appointment."
        W !!,"First select the Recall Date range."
        S SDRRND=$$FMADD^XLFDT(DT,-1)
        D DRANGE^SDRRUTL(.SDRRST,.SDRRND,.SDRRSTX,.SDRRNDX,.SDRRABORT) Q:SDRRABORT
        K ^TMP("SDRR",$J)
        D ASKDIV^SDRRPXC(.SDRRDIV) Q:'SDRRDIV
        D ASKCLIN^SDRRPXC(.SDRRDIV,SDRRST,SDRRND) Q:'$D(^TMP("SDRR",$J))
        W !
        K DIR,X,Y
        S DIR(0)="Y"
        S DIR("A")="Page break on clinic"
        S DIR("B")="Yes"
        D ^DIR Q:$D(DIRUT)
        K DIRUT
        S SDRRBRK=Y ; Page break on Clinic
        S XMSUB="Recall Delinquency List, "_$S(SDRRST=SDRRND:SDRRSTX,1:SDRRSTX_"-"_SDRRNDX)
        F I="SDRRDIV","SDRRDIV(","SDRRST","SDRRSTX","SDRRND","SDRRNDX","SDRRBRK","SDRRDAYS","^TMP(""SDRR"",$J," S ZTSAVE(I)=""
        D EN^XUTMDEVQ("CONTROL^SDRRISRD",XMSUB,.ZTSAVE,,1)
        I '$D(ZTQUEUED),$D(ZTSK) W !,"Request queued.  (Task: ",ZTSK,")"
        Q
CONTROL ;
        N SDRRIA,SDRRCLIST
        S SDRRIA=$E($G(IOST),1,2)="C-"
        D CLINLIST^SDRRISB(.SDRRCLIST)
        D GATHER
        D PRINT
        K ^TMP("SDRR",$J)
        Q
GATHER  ; Gather Patient from Recall List
        N SDRRDT,SDRRIEN,SDRRDFN,SDRRREC,SDRRDFN0,SDRRCLIN,SDRRSDT,SDRRPH,SDRRDDAYS,DFN,VA,VADM,VAPA
        S SDRRND=SDRRND+.9999
        S SDRRDT=SDRRST-.1
        S SDRRIEN="" ; "D" xref is on the RECALL DATE field
        F  S SDRRDT=$O(^SD(403.5,"D",SDRRDT)) Q:SDRRDT>SDRRND!'SDRRDT  D
        . F  S SDRRIEN=$O(^SD(403.5,"D",SDRRDT,SDRRIEN)) Q:'SDRRIEN  D
        . . S SDRRREC=$G(^SD(403.5,SDRRIEN,0))
        . . S SDRRCLIN=+$P(SDRRREC,U,2)
        . . Q:'$D(SDRRCLIST(SDRRCLIN))  ; Must be clinic we want
        . . S SDRRSDT=$P(SDRRREC,U,10) ; Reminder sent date
        . . S Z=$P(SDRRREC,U,13) I Z'="" S Z="*"
        . . Q:'SDRRSDT  ; Reminder must have been sent
        . . S SDRRDFN=+SDRRREC
        . . Q:$$TESTPAT^VADPT(SDRRDFN)  ; Test patient
        . . S DFN=SDRRDFN
        . . D ADD^VADPT,DEM^VADPT
        . . Q:$G(VADM(6),U)'=""
        . . S SDRRDDAYS=$$FMDIFF^XLFDT(DT,SDRRDT)
        . . N SDRRPW
        . . S SDRRPW="" S SDRRPW=$$GET1^DIQ(2,DFN_",",.132)
        . . S ^TMP("SDRR",$J,"PRT",SDRRCLIST(SDRRCLIN)_U_SDRRCLIN,SDRRDDAYS,$P(VADM(1),U)_U_SDRRDFN)=$P(VA("BID"),U)_U_$P(VAPA(8),U,1)_U_SDRRPW_U_SDRRDT_U_Z_U_SDRRSDT
        D KVAR^VADPT
        Q
PRINT   ;
        N SDRRTODAY,SDRRCLIN,SDRRCLSAV,SDRRDT,SDRRREC,SDRRPAGE,SDRRABORT,SDRRDR,SDRRRP
        N SDRRPAT,SDRRSSN,SDRRCNT,SDRRDTX,SDRRPH,SDRRPW,SDRRSDT,SDRRDDAYS,SDRRPROV
        S (SDRRABORT,SDRRPAGE)=0
        I SDRRIA W @IOF
        S SDRRTODAY=$$FMTE^XLFDT(DT)
        S SDRRDR=$$CJ^XLFSTR(ZTDESC,IOM-1)
        S $E(SDRRDR,1,$L(SDRRTODAY))=SDRRTODAY
        S SDRRDR=$E(SDRRDR,1,IOM-8)_"Page"
        D HEADER
        I '$D(^TMP("SDRR",$J,"PRT")) W !,"No Recall Delinquencies found for this date range." Q
        S (SDRRCLIN,SDRRPAT,SDRRDDAYS)=""
        S SDRRCLSAV=SDRRCLIN
        F  S SDRRCLIN=$O(^TMP("SDRR",$J,"PRT",SDRRCLIN)) Q:SDRRCLIN=""  D  Q:SDRRABORT
        . I SDRRCLSAV'="",SDRRBRK!($Y+4+SDRRIA>IOSL) D  Q:SDRRABORT
        . . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . . W @IOF D HEADER
        . S SDRRCLSAV=SDRRCLIN
        . S SDRRPROV=$$PRDEF^SDCO31($P(SDRRCLIN,U,2))
        . I SDRRPROV="" S SDRRPROV="(No Default Provider)"
        . W !!,$$CJ^XLFSTR(" "_$P(SDRRCLIN,U)_"    "_SDRRPROV_" ",79,"-")
        . S SDRRCNT=0
        . F  S SDRRDDAYS=$O(^TMP("SDRR",$J,"PRT",SDRRCLIN,SDRRDDAYS),-1) Q:SDRRDDAYS=""  D  Q:SDRRABORT
        . . F  S SDRRPAT=$O(^TMP("SDRR",$J,"PRT",SDRRCLIN,SDRRDDAYS,SDRRPAT)) Q:SDRRPAT=""  S SDRRREC=^(SDRRPAT) D  Q:SDRRABORT
        . . . S SDRRCNT=SDRRCNT+1
        . . . S SDRRSSN=$E(SDRRREC,1,4)
        . . . S SDRRPH=$P(SDRRREC,U,2)
        . . . S SDRRPW=$P(SDRRREC,U,3)
        . . . S SDRRDT=$P(SDRRREC,U,4)
        . . . S SDRRRP=$P(SDRRREC,U,5)
        . . . S SDRRSDT=$P(SDRRREC,U,6)
        . . . I $Y+2+SDRRIA>IOSL D  Q:SDRRABORT
        . . . . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . . . . W @IOF D HEADER
        . . . W !,$E($P(SDRRPAT,U),1,14),?15,SDRRSSN,?20,$E(SDRRPH,1,18),?38,$E(SDRRPW,1,20),?58,$$FMTE^XLFDT(SDRRDT,"2Z"),?66,$J(SDRRDDAYS,4),?71,SDRRRP_$$FMTE^XLFDT(SDRRSDT,"2Z")
        . Q:SDRRABORT
        . D SUBTOT
        Q:SDRRABORT
        I SDRRIA D WAIT^XMXUTIL
        Q
HEADER  ;
        S SDRRPAGE=SDRRPAGE+1
        W SDRRDR,$J(SDRRPAGE,3)
        W !!,?71,"Reminder"
        W !,"Patient",?15,"SSN",?20,"Home Phone",?38,"Work Phone",?58,"Recall",?66,"Days",?71,"Sent"
        Q
SUBTOT  ;
        I $Y+3+SDRRIA>IOSL D  Q:SDRRABORT
        . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . W @IOF D HEADER
        W !!,"Delinquent Patient Recalls: ",SDRRCNT
        Q
