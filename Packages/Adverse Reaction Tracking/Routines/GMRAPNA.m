GMRAPNA ;HIRMFO/WAA-PATIENT NOT ASKED ABOUT ALLERGIES ;12/1/95  14:15
        ;;4.0;Adverse Reaction Tracking;**30,33**;Mar 29, 1996;Build 5
EN1     ; Entry for LIST BY LOCATION OF UNDOCUMENTED ALLERGIES option
        D EN1^GMRACMR G:GMRAOUT EXIT
        D DEV
        D EXIT
        Q
DEV     ; *** Select output device, force queuing
        ;***** NOTE: CHECKS TO SEE IF VALID DEVICE IS SELECTED THEN ALL I HAVE TO DO IS RUN TASK MAN.
        S GMRAZIS="" S:GMRASEL'="1," GMRAZIS="Q"
        W !! D DEV^GMRAUTL I POP G EXIT
        I $D(IO("Q")) D  G EXIT
        . K IO("Q")
        . S ZTRTN="ENTSK^GMRAPNA"
        . S ZTSAVE("GMRA*")="",ZTSAVE("^TMP($J,")=""
        . S ZTDESC="List of patients who have not been asked of allergies"
        . D ^%ZTLOAD
        . W !!,$S($D(ZTSK):"Request queued...",1:"Request NOT queued please try later...")
        . Q
        E  D ENTSK
        Q
ENTSK   U IO
        D EN1^GMRACMR2,EN1^GMRACMR3
        S GMRAPAGE=0,X="NOW" D ^%DT S GMRAPDT=$$DATE^GMRAUTL1(Y)
        D PRINT
        G EXIT
PRINT   ;PRINT THE DATE
        D PRE
        S GMRAHLOC="" F  S GMRAHLOC=$O(^TMP($J,"GMRAWC","C",GMRAHLOC)) Q:GMRAHLOC=""!(GMRAOUT)  S GMRAX=0 F  S GMRAX=$O(^(GMRAHLOC,GMRAX)) Q:GMRAX<1  D  Q:GMRAOUT
        .S GMRA=$G(^TMP($J,"GMRAWC",GMRAX)),GMRACNT=0
        .I GMRA="" Q
        .D HEAD Q:GMRAOUT
        .W !!,?10,$S(GMRA="W":"WARD",GMRA="M":"MODULE",GMRA="C":"CLINIC",1:"UNKNOWN"),": ",$P(^SC(GMRAX,0),U)
        .S GMRADATE=0 F  S GMRADATE=$O(^TMP($J,"GMRAWC",GMRAX,GMRADATE))  Q:GMRADATE=""  S GMRADFN=0 Q:GMRAOUT  F  S GMRADFN=$O(^TMP($J,"GMRAWC",GMRAX,GMRADATE,GMRADFN)) Q:GMRADFN<1  D  Q:GMRAOUT
        ..I '$D(^GMR(120.86,GMRADFN,0))
        ..E  I +$P(^GMR(120.86,GMRADFN,0),U,4)<$G(GMRAED,9999999) Q
        ..Q:'$D(^DPT(GMRADFN,0))
        ..Q:$$DECEASED^GMRAFX(GMRADFN)  ;GMRA*4*30 Prevent deceased patients from appearing on this report.
        ..Q:'$$PRDTST^GMRAUTL1(GMRADFN)  ;GMRA*4*33 Exclude test patient from report if production or legacy environment.
        ..S GMRACNT=GMRACNT+1
        ..W !,$P(^DPT(GMRADFN,0),U) S DFN=GMRADFN,VAINDT=$S(GMRADATE="CURRENT":DT,1:GMRADATE) D 1^VADPT W ?30,VA("PID") W:GMRA'="C" ?45,$P(VAIN(2),U,2)
        ..I VAIN(5)'="" W !,?5,"Room/Bed: ",VAIN(5)
        ..D KVAR^VADPT K VA,DFN
        ..I $Y>(IOSL-4) D HEAD Q:GMRAOUT
        ..Q
        .D NOPAT
        .Q
        D CLOSE^GMRAUTL
        Q
NOPAT   ; If there are no patients print informational message
        Q:GMRACNT
        W !,?24,"* No Patients for this ",$S(GMRA="W":"Ward",GMRA="M":"Module",GMRA="C":"Clinic",1:"UNKNOWN")," *"
        W !
        Q
HEAD    ;HEADER PAGE FOR PRINTOUT
        S GMRAPAGE=GMRAPAGE+1,GMRATL="" I $E(IOST,1)="C",GMRAPAGE=1 W @IOF
        I $E(IOST,1)="C",GMRAPAGE'=1 D  Q:GMRAOUT
        .S DIR(0)="E" D ^DIR I 'Y S GMRAOUT=1
        .K Y
        .Q
        I GMRAPAGE'=1 W @IOF
        W !,GMRAPDT,?23,"PATIENTS NOT ASKED ABOUT ALLERGIES",?70,"PAGE ",GMRAPAGE
        I GMRASEL["1" S GMRATL="CURRENT INPATIENTS"
        I GMRASEL["2" S GMRATL=$S(GMRATL="":"OUTPATIENTS",1:GMRATL_" / OUTPATIENTS")
        I GMRASEL["3" S GMRATL=$S(GMRATL="":"NEW ADMISSIONS",1:GMRATL_" / NEW ADMISSIONS")
        W !,?(40-($L(GMRATL)/2)),GMRATL
        I (GMRASEL["2"!(GMRASEL["3")) W !,?23,"FROM ",$$DATE^GMRAUTL1(GMRAST),?42,"TO ",$$DATE^GMRAUTL1(GMRAED)
        W !!,"PATIENT",?30,"SSN" W:GMRA'="C" ?45,"PROVIDER"
        W !,$$REPEAT^XLFSTR("-",78)
        I $D(ZTQUEUED) S:$$STPCK^GMRAUTL1 GMRAOUT=1 ; Check if stopped by user
        Q
PRE     ; This will validate the TMP global and fire off Xref
        N GMRAX,GMRAY,GMRAT1,GMRAT2,GMRAT3
        Q:'$D(^TMP($J,"GMRAWC"))
        S GMRAX=0  F  S GMRAX=$O(^TMP($J,"GMRAWC",GMRAX)) Q:GMRAX<1  D
        .S GMRAY=^TMP($J,"GMRAWC",GMRAX)
        .S GMRAT1=$P($G(^SC(GMRAX,0)),U,2)
        .S GMRAT2=$P($G(^SC(GMRAX,0)),U)
        .S GMRAT3=$S(GMRAT1'="":GMRAT1,1:GMRAT2)
        .S ^TMP($J,"GMRAWC","C",GMRAT3,GMRAX)=""
        .Q
        Q
EXIT    ;
        K ^TMP($J,"GMRAWC")
        D KILL^XUSCLEAN
        Q
