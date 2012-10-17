SDRRISRX        ;10N20/MAH;-Recall List Clerk Deletions;01/18/2008  11:32
        ;;5.3;Scheduling;**536**;Aug 13, 1993;Build 53
        ; Option: SDRR RECALL DELETIONS
EN      ;
        N SDRRST,SDRRND,SDRRSTX,SDRRNDX,SDRRBRK,SDRRABORT,I,ZTSAVE,XMDUZ,XMSUB,ZTSK,VA,VADM,VAPA
        N SDRRDIV,SDRRDAYS,DIR,X,Y,Z,DIRUT,ZTQUEUED,ZTDESC,DFN
        I '$D(^SD(403.56,"C")) W !!,"***No Entries Have Been Deleted***" Q
        S SDRRABORT=0
        W !!,"Select a time period and a set of clinics, and I'll tell you all the patients"
        W !,"who were on the Recall List, but were deleted from the list by clerks."
        W !!,"First select the Recall Date range. The default dates are determined by the"
        W !,"entries in Recall Reminders Removed File."
        S SDRRST=$O(^SD(403.56,"C",""))
        S SDRRND=$O(^SD(403.56,"C",""),-1)
        D DRANGE^SDRRUTL(.SDRRST,.SDRRND,.SDRRSTX,.SDRRNDX,.SDRRABORT,SDRRST,SDRRND) Q:SDRRABORT
        K ^TMP("SDRR",$J)
        D ASKDIV^SDRRPXC(.SDRRDIV) Q:'SDRRDIV
        D ASKCLIN^SDRRPXC(.SDRRDIV,SDRRST,SDRRND) Q:'$D(^TMP("SDRR",$J))
        W !
        K DIR,X,Y
        S DIR(0)="Y"
        S DIR("A")="Page break on clinic"
        S DIR("B")="Yes"
        D ^DIR Q:$D(DIRUT)
        S SDRRBRK=Y ; Page break on Clinic
        S XMSUB="Recall List Clerk Deletions, "_$S(SDRRST=SDRRND:SDRRSTX,1:SDRRSTX_"-"_SDRRNDX)
        F I="SDRRDIV","SDRRDIV(","SDRRST","SDRRSTX","SDRRND","SDRRNDX","SDRRBRK","SDRRDAYS","^TMP(""SDRR"",$J," S ZTSAVE(I)=""
        D EN^XUTMDEVQ("CONTROL^SDRRISRX",XMSUB,.ZTSAVE,,1)
        I '$D(ZTQUEUED),$D(ZTSK) W !,"Request queued.  (Task: ",ZTSK,")"
        Q
CONTROL ;
        N SDRRIA,SDRRCLIST
        S SDRRIA=$E($G(IOST),1,2)="C-"
        D CLINLIST^SDRRISB(.SDRRCLIST)
        D GATHER
        D PRINT
        K ^TMP("SDRR",$J)
        D KVAR^VADPT
        Q
GATHER  ; Gather Patient from Recall Deletions List
        N SDRRDT,SDRRIEN,SDRRDFN,SDRRREC,SDRRDFN0,SDRRCLIN,SDRRSDT,SDRRDDT,SDRRREC2,SDRRCLERK,SDRRREASN
        S SDRRND=SDRRND+.9999
        S (SDRRCLIN,SDRRIEN)="" ; "D" xref is on Clinic and Recall Date
        F  S SDRRCLIN=$O(SDRRCLIST(SDRRCLIN)) Q:'SDRRCLIN  D
        . Q:'$D(^SD(403.56,"D",SDRRCLIN))
        . S SDRRDT=SDRRST-.1
        . F  S SDRRDT=$O(^SD(403.56,"D",SDRRCLIN,SDRRDT)) Q:SDRRDT>SDRRND!'SDRRDT  D
        . . F  S SDRRIEN=$O(^SD(403.56,"D",SDRRCLIN,SDRRDT,SDRRIEN)) Q:'SDRRIEN  D
        . . . S SDRRREC2=$G(^SD(403.56,SDRRIEN,2))
        . . . S SDRRDDT=+SDRRREC2 ; Deletion date
        . . . Q:'SDRRDDT  ; got appt.?
        . . . S SDRRCLERK=$P(SDRRREC2,U,2)
        . . . S SDRRREASN=$P(SDRRREC2,U,3)
        . . . S SDRRREC=$G(^SD(403.56,SDRRIEN,0))
        . . . S SDRRDFN=+SDRRREC
        . . . Q:$$TESTPAT^VADPT(SDRRDFN)  ; Test patient
        . . . S DFN=SDRRDFN
        . . .D ADD^VADPT,DEM^VADPT
        . . . S SDRRSDT=$P(SDRRREC,U,10) ; Reminder sent date
        . . . S Z=$P(SDRRREC,U,13) I Z'="" S Z="*"
        . . . S ^TMP("SDRR",$J,"PRT",SDRRCLIST(SDRRCLIN)_U_SDRRCLIN,$P(VADM(1),U)_U_SDRRDFN,SDRRDT)=$P(VA("BID"),U)_U_SDRRSDT_U_Z_U_SDRRDDT_U_SDRRCLERK_U_SDRRREASN
        Q
PRINT   ;
        N SDRRTODAY,SDRRCLIN,SDRRCLSAV,SDRRDT,SDRRREC,SDRRPAGE,SDRRABORT,SDRRDR,SDRRRP
        N SDRRPAT,SDRRSSN,SDRRCNT,SDRRDTX,SDRRSDT,SDRRPROV,SDRRDFN,SDRRDDT,SDRRREASN
        S (SDRRABORT,SDRRPAGE)=0
        I SDRRIA W @IOF
        S SDRRTODAY=$$FMTE^XLFDT(DT)
        S SDRRDR=$$CJ^XLFSTR(ZTDESC,IOM-1)
        S $E(SDRRDR,1,$L(SDRRTODAY))=SDRRTODAY
        S SDRRDR=$E(SDRRDR,1,IOM-8)_"Page"
        D HEADER
        I '$D(^TMP("SDRR",$J,"PRT")) W !,"No Recall List deletions found for this date range." Q
        S (SDRRCLIN,SDRRPAT,SDRRDT)=""
        S SDRRCLSAV=SDRRCLIN
        F  S SDRRCLIN=$O(^TMP("SDRR",$J,"PRT",SDRRCLIN)) Q:SDRRCLIN=""  D  Q:SDRRABORT
        . I SDRRCLSAV'="",SDRRBRK!($Y+5+SDRRIA>IOSL) D  Q:SDRRABORT
        . . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . . W @IOF D HEADER
        . S SDRRCLSAV=SDRRCLIN
        . S SDRRPROV=$$PRDEF^SDCO31($P(SDRRCLIN,U,2))
        . I SDRRPROV="" S SDRRPROV="(No Default Provider)"
        . W !!,$$CJ^XLFSTR(" "_$P(SDRRCLIN,U)_"    "_SDRRPROV_" ",79,"-")
        . S SDRRCNT=0
        . F  S SDRRPAT=$O(^TMP("SDRR",$J,"PRT",SDRRCLIN,SDRRPAT)) Q:SDRRPAT=""  D  Q:SDRRABORT
        . . S SDRRDFN=$P(SDRRPAT,U,2)
        . . F  S SDRRDT=$O(^TMP("SDRR",$J,"PRT",SDRRCLIN,SDRRPAT,SDRRDT)) Q:'SDRRDT  S SDRRREC=^(SDRRDT) D  Q:SDRRABORT
        . . . S SDRRCNT=SDRRCNT+1
        . . . S SDRRSSN=$E(SDRRREC,1,4)
        . . . S SDRRSDT=$P(SDRRREC,U,2)
        . . . S SDRRRP=$P(SDRRREC,U,3)
        . . . S SDRRDDT=$P(SDRRREC,U,4)
        . . . S SDRRCLERK=$P(SDRRREC,U,5) S SDRRCLERK=$$NAME^XUSER(SDRRCLERK,"F")
        . . . S SDRRREASN=$S($P(SDRRREC,U,6)=1:"FTR",$P(SDRRREC,U,6)=2:"MOVED",$P(SDRRREC,U,6)=3:"DECEASED",$P(SDRRREC,U,6)=4:"DNWC",$P(SDRRREC,U,6)=5:"RCOVA",$P(SDRRREC,U,6)=6:"OTHER",1:"")
        . . . I $Y+2+SDRRIA>IOSL D  Q:SDRRABORT
        . . . . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . . . . W @IOF D HEADER
        . . . W !,$E($P(SDRRPAT,U),1,14),?15,SDRRSSN,?20,SDRRRP_$$FMTE^XLFDT($E(SDRRSDT,1,7),"2Z"),?29,$$FMTE^XLFDT($E(SDRRDT,1,7),"2Z"),?38,$$FMTE^XLFDT($E(SDRRDDT,1,7),"2Z"),?47,$E(SDRRCLERK,1,19),?67,SDRRREASN
        . Q:SDRRABORT
        . D SUBTOT
        Q:SDRRABORT
        I SDRRIA D WAIT^XMXUTIL
        Q
HEADER  ;
        S SDRRPAGE=SDRRPAGE+1
        W SDRRDR,$J(SDRRPAGE,3)
        W !!,?20,"Reminder"
        W !,"Patient",?15,"SSN",?20,"Sent",?29,"Recall",?38,"Deleted",?47,"Deleted by",?67,"Reason"
        W !,"-------------- ---- -------- -------- -------- ------------------- ------"
        Q
SUBTOT  ;
        I $Y+3+SDRRIA>IOSL D  Q:SDRRABORT
        . I SDRRIA D PAGE^XMXUTIL(.SDRRABORT) Q:SDRRABORT
        . W @IOF D HEADER
        W !!,"Patient Recall List Deletions: ",SDRRCNT
        Q
