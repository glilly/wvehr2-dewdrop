SDRRISRL        ;10N20/MAH;Recall Reminder Open Slots Report;01/18/2008
        ;;5.3;Scheduling;**536**;Aug 13, 1993;Build 53
        ; Option: SDRR RECALL LIST
EN      ;
        N SDRRST,SDRRND,SDRRSTX,SDRRNDX,SDRRBRK,SDRRABORT,DIRUT,I,ZTSAVE,XMDUZ,XMSUB,ZTQUEUED,ZTSK
        N SDRRDIV,ZTDESC
        S SDRRABORT=0
        W !!,"Select a time period and a set of clinics, and I'll tell you all the"
        W !,"patients who are on the Recall List for that time period at those clinics."
        W !,"For each month, I'll also tell you how many slots are available in each clinic.",!
        W !,"First select the Recall Date range."
        S SDRRST=$E(DT,1,5)_"01" ; 1st of this month
        I $E(DT,4,5)>27 S SDRRST=$E($$FMADD^XLFDT(SDRRST,31),1,5)_"01" ; 1st of next month
        S SDRRND=$E($$SCH^XLFDT("3M",SDRRST),1,7) ; 3 months later
        D DRANGE^SDRRUTL(.SDRRST,.SDRRND,.SDRRSTX,.SDRRNDX,.SDRRABORT,SDRRST,$$FMADD^XLFDT(DT,366),1) Q:SDRRABORT
        K ^TMP("SDRR",$J)
        D ASKDIV^SDRRPXC(.SDRRDIV) Q:'SDRRDIV
        D ASKCLIN^SDRRPXC(.SDRRDIV,SDRRST,SDRRND) Q:'$D(^TMP("SDRR",$J))
        W !
        N DIR,X,Y
        S DIR(0)="Y"
        S DIR("A")="Page break on clinic"
        S DIR("B")="Yes"
        D ^DIR Q:$D(DIRUT)
        S SDRRBRK=Y ; Page break on Clinic
        S XMSUB="Future Recall Slots, "_$S(SDRRST=SDRRND:SDRRSTX,1:SDRRSTX_"-"_SDRRNDX)
        F I="SDRRDIV","SDRRDIV(","SDRRST","SDRRSTX","SDRRND","SDRRNDX","SDRRBRK","^TMP(""SDRR"",$J," S ZTSAVE(I)=""
        D EN^XUTMDEVQ("CONTROL^SDRRISRL",XMSUB,.ZTSAVE,,1)
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
        N SDRRDT,SDRRIEN,SDRRDFN,SDRRREC,SDRRDFN0,SDRRCLIN,SDRRCLERK,SDRRSDT,SDRRPHONE,DFN,VA,VADM,VAPA,Z
        S SDRRND=SDRRND+.9999
        S SDRRDT=SDRRST-.1
        S SDRRIEN="" ; "D" xref is on the RECALL DATE field
        F  S SDRRDT=$O(^SD(403.5,"D",SDRRDT)) Q:SDRRDT>SDRRND!'SDRRDT  D
        . F  S SDRRIEN=$O(^SD(403.5,"D",SDRRDT,SDRRIEN)) Q:'SDRRIEN  D
        . . S SDRRREC=$G(^SD(403.5,SDRRIEN,0))
        . . S SDRRCLIN=+$P(SDRRREC,U,2)
        . . Q:'$D(SDRRCLIST(SDRRCLIN))  ; Must be clinic we want
        . . S SDRRDFN=+SDRRREC
        . . Q:$$TESTPAT^VADPT(SDRRDFN)  ; Test patient
        . . S SDRRSDT=$P(SDRRREC,U,10) ; Reminder sent date
        . . S SDRRCLERK=+$P(SDRRREC,U,11) ; Clerk who entered the recall
        . . S Z=$P(SDRRREC,U,13) I Z'="" S Z="*"
        . . S DFN=SDRRDFN
        . . D ADD^VADPT,DEM^VADPT
        . . S ^TMP("SDRR",$J,"PRT",SDRRCLIST(SDRRCLIN)_U_SDRRCLIN,SDRRDT,$P(VADM(1),U)_U_SDRRDFN)=$P(VA("BID"),U)_U_$P(VAPA(8),U)_U_SDRRCLERK_U_SDRRSDT_U_Z
        D KVAR^VADPT
        Q
PRINT   ;
        N SDRRTODAY,SDRRCLIN,SDRRCLSAV,SDRRDT,SDRRDTSAV,SDRRREC,SDRRPAGE,SDRRABORT,SDRRDR,SDRRRP
        N SDRRCLERK,SDRRPAT,SDRRSSN,SDRRCNT,SDRRDTX,SDRRPHONE,SDRRSDT,SDRRMDT,SDRRMDTX
        N SDRRPROV
        S SDRRMDT=$$FMADD^XLFDT(DT,1) ; earliest date to look for slot availability
        S SDRRMDTX=$$FMTE^XLFDT(SDRRMDT,"2Z")
        S (SDRRABORT,SDRRPAGE,SDRRCNT)=0
        I SDRRIA W @IOF
        S SDRRTODAY=$$FMTE^XLFDT(DT)
        S SDRRDR=$$CJ^XLFSTR(ZTDESC,IOM-1)
        S $E(SDRRDR,1,$L(SDRRTODAY))=SDRRTODAY
        S SDRRDR=$E(SDRRDR,1,IOM-8)_"Page"
        D HEADER
        I '$D(^TMP("SDRR",$J,"PRT")) W !,"No Recalls found for this date range." Q
        S (SDRRCLIN,SDRRDT,SDRRPAT)=""
        S SDRRCLSAV=SDRRCLIN
        F  S SDRRCLIN=$O(^TMP("SDRR",$J,"PRT",SDRRCLIN)) Q:SDRRCLIN=""  D  Q:SDRRABORT
        . I SDRRCLSAV'="",SDRRBRK!($Y+5+SDRRIA>IOSL) D  Q:SDRRABORT
        . . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . . W @IOF D HEADER
        . S SDRRCLSAV=SDRRCLIN
        . S SDRRPROV=$$PRDEF^SDCO31($P(SDRRCLIN,U,2))
        . I SDRRPROV="" S SDRRPROV="(No Default Provider)"
        . W !!,$$CJ^XLFSTR(" "_$P(SDRRCLIN,U)_"    "_SDRRPROV_" ",79,"-")
        . S SDRRDTSAV=SDRRDT
        . F  S SDRRDT=$O(^TMP("SDRR",$J,"PRT",SDRRCLIN,SDRRDT)) Q:'SDRRDT  D  Q:SDRRABORT
        . . S SDRRDTX=$$FMTE^XLFDT(SDRRDT,"2Z")
        . . I SDRRDTSAV'=$E(SDRRDT,1,5) D  Q:SDRRABORT
        . . . I SDRRDTSAV D SUBTOT
        . . . S SDRRCNT=0
        . . . S SDRRDTSAV=$E(SDRRDT,1,5)
        . . . I $Y+2+SDRRIA>IOSL D  Q:SDRRABORT
        . . . . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . . . . W @IOF D HEADER
        . . . W !
        . . F  S SDRRPAT=$O(^TMP("SDRR",$J,"PRT",SDRRCLIN,SDRRDT,SDRRPAT)) Q:SDRRPAT=""  S SDRRREC=^(SDRRPAT) D  Q:SDRRABORT
        . . . S SDRRCNT=SDRRCNT+1
        . . . S SDRRSSN=$E(SDRRREC,1,4)
        . . . S SDRRPHONE=$P(SDRRREC,U,2)
        . . . S SDRRCLERK=$P(SDRRREC,U,3) S SDRRCLERK=$$NAME^XUSER(SDRRCLERK,"F")
        . . . S SDRRSDT=$P(SDRRREC,U,4)
        . . . S SDRRRP=$P(SDRRREC,U,5)
        . . . I $Y+2+SDRRIA>IOSL D  Q:SDRRABORT
        . . . . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . . . . W @IOF D HEADER
        . . . W !,SDRRDTX,?10,SDRRRP_$$FMTE^XLFDT(SDRRSDT,"2Z"),?20,$E($P(SDRRPAT,U),1,17),?38,SDRRSSN,?43,SDRRPHONE,?64,$E(SDRRCLERK,1,15)
        . Q:SDRRABORT
        . D SUBTOT
        Q:SDRRABORT
        I SDRRIA D WAIT^XMXUTIL
        Q
HEADER  ;
        S SDRRPAGE=SDRRPAGE+1
        W SDRRDR,$J(SDRRPAGE,3)
        W !!,?10,"Reminder",?64,"Recall"
        W !,"Recall",?10,"Sent",?20,"Patient",?38,"SSN",?43,"Home Phone",?64,"Entered by"
        Q
SUBTOT  ;
        I $Y+3+SDRRIA>IOSL D  Q:SDRRABORT
        . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . W @IOF D HEADER
        W !!,$$FMTE^XLFDT(SDRRDTSAV_"00",1)," Patient Recalls: ",SDRRCNT,", Available Slots: ",$$OPENSLOT^SDRRISRU($P(SDRRCLIN,U,2),$S(SDRRDTSAV=$E(SDRRMDT,1,5):SDRRMDT,1:SDRRDTSAV_"01"))
        I SDRRDTSAV=$E(SDRRMDT,1,5) W " (",SDRRMDTX," through EOM)"
        Q
