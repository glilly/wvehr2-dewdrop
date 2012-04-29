DGENACL ;ALB/MRY - NEW ENROLLEE APPOINTMENT CALL LIST - UPDATE ;02/15/2008
        ;;5.3;Registration;**779**;08/13/93;Build 11
        ;
EDIT    ;-Entry point - Edit Appointment Request Status and Comment option
        N DIC,DIE,DA,DR,Y,DFN
        S DIC="^DPT(",DIC(0)="AEQMZ" D ^DIC G Q:Y'>0 S DFN=+Y
        S DIE=DIC,DA=+Y,DR="[DGEN NEACL]" D ^DIE W !!
        G EDIT
Q       Q
        ;
REPORT(DGRPT)   ;-Entry point - Call List/Tracking reports
        ;
        ; DGRPT: 1 = Call List: New enrollee appt. request/no appt. assigned.
        ;        2 = Tracking Report: New enrollee appt. request/by date range
        ;
        N DGBEG,DGEND,DTOUT,DUOUT,DIRUT,DGFMT1,DGFMT2
        S (DGBEG,DGEND)=""
        I $G(DGRPT)'=1&($G(DGRPT)'=2) G Q
        I DGRPT=1 D FMT1 I $D(DTOUT)!($D(DUOUT)) G Q
        I DGRPT=2 D FMT2,DATE I $D(DTOUT)!($D(DUOUT)) G Q
        N ZTDESC,ZTRTN,ZTSAVE,ZTSK,ZUSR,ZTDTH,POP,X,ERR
        K IOP,%ZIS
        S %ZIS="Q" D ^%ZIS G:POP EXIT
        I $D(IO("Q")) D  Q
        . S (ZTSAVE("DGRPT"),ZTSAVE("DGFMT1"),ZTSAVE("DGFMT2"),ZTSAVE("DGBEG"),ZTSAVE("DGEND"))=""
        . S ZTRTN="BUILD^DGENACL",ZTDESC="NEW ENROLLEE APPT. CALL LIST REPORT",ZTDTH=$H
        . D ^%ZTLOAD
        . D ^%ZISC,HOME^%ZIS
        . W !,$S($D(ZTSK):"REQUEST QUEUED!",1:"REQUEST CANCELLED!")
        D BUILD
EXIT    D ^%ZISC,HOME^%ZIS
        Q
        ;
BUILD   ;-Build temp global
        K ^TMP($J,"DGEN NEACL")
        N DFNIEN,DGDT,DGEDT
        I DGRPT=1 S DFNIEN=0 F  S DFNIEN=$O(^DPT("AEAR",1,DFNIEN)) Q:'DFNIEN  D
        . I $$GET1^DIQ(2,DFNIEN,1010.159,"I") D EXTRACT
        I DGRPT=2 D
        . S DGDT=DGBEG-.01,DGEDT=DGEND_.999
        . F  S DGDT=$O(^DPT("AEACL",DGDT)) Q:'DGDT!(DGDT>DGEDT)  D
        .. S DFNIEN=0 F  S DFNIEN=$O(^DPT("AEACL",DGDT,DFNIEN)) Q:'DFNIEN  D
        ... I $$GET1^DIQ(2,DFNIEN,1010.159,"I") D EXTRACT
        D PRINT^DGENACL1
        Q
        ;
EXTRACT ;
        N DGNAM,DGSSN,DGRDTI,DGENRIEN,DGENR,DGENCAT,DGENSTA,DGENPRI,DGENCV,DGENCVDT,DGENCVEL,DGSTA,DGCOM
        N SDCNT,SDADT,SDARRY,SDCL,Y,FDATA
        ;if call list, don't list if appointment made or request status
        ;'filled' or 'completed'.
        D APPTCK Q:'DGRDTI
        S SDADT=$G(SDADT) I DGRPT=1 Q:(SDCNT>0)!(DGSTA="C")!(DGSTA="F")
        S DGNAM=$$GET1^DIQ(2,DFNIEN,.01),DGSSN=$E($$GET1^DIQ(2,DFNIEN,.09),6,9)
        S DGENRIEN=$$FINDCUR^DGENA(DFNIEN)
        I DGENRIEN,$$GET^DGENA(DGENRIEN,.DGENR) ;set-up enrollment arry
        ;I DGENR("APP"))>3050731 D
        S DGENCAT=$$CATEGORY^DGENA4(,$G(DGENR("STATUS"))) ;enrollment category
        I DGENCAT'="E" Q
        S DGENCAT=$$EXTERNAL^DILFD(27.15,.02,"",DGENCAT)
        S DGENSTA=$S($G(DGENR("STATUS")):$$EXT^DGENU("STATUS",DGENR("STATUS")),1:"")
        S DGENPRI=$S($G(DGENR("PRIORITY")):DGENR("PRIORITY"),1:"")_$S($G(DGENR("SUBGRP")):$$EXT^DGENU("SUBGRP",DGENR("SUBGRP")),1:"")
        S DGENCV=$$CVEDT^DGCV(DFNIEN),DGENCVDT=$P($G(DGENCV),"^",2),DGENCVEL=$P($G(DGENCV),"^",3)
        S ^TMP($J,"DGEN NEACL",$S(DGSTA="":1,DGSTA="I":2,DGSTA="E":3,DGSTA="F":4,1:DGSTA),DGRDTI,DGNAM,DFNIEN)=SDADT
        I $G(DGENCAT)'=""!($G(DGENSTA)'="")!($G(DGENPRI)'="")!($G(DGENCVEL)'="") D
        . S ^TMP($J,"DGEN NEACL",$S(DGSTA="":1,DGSTA="I":2,DGSTA="E":3,DGSTA="F":4,1:DGSTA),DGRDTI,DGNAM,DFNIEN,"PRIORITY")=DGENCAT_"^"_DGENSTA_"^"_DGENPRI_"^"_DGENCVEL
        Q
        ;
APPTCK  ;If appointment (SDCNT), get appointment date/time (SDADT).
        K ^TMP($J,"SDAMA301")
        ;quit, if no 'date appointment questioned asked?'
        S DGRDTI=$$GET1^DIQ(2,DFNIEN,1010.1511,"I") Q:'DGRDTI
        S DGSTA=$$GET1^DIQ(2,DFNIEN,1010.161,"I")
        S SDARRY(1)=DGRDTI_";",SDARRY(4)=DFNIEN,SDARRY("FLDS")=1,SDARRY("MAX")=1
        S SDCNT=$$SDAPI^SDAMA301(.SDARRY) Q:(SDCNT'>0)
        S SDCL=0 F  S SDCL=$O(^TMP($J,"SDAMA301",DFNIEN,SDCL)) Q:'SDCL  D
        . S SDADT=$O(^TMP($J,"SDAMA301",DFNIEN,SDCL,0))
        ;if appointment and no status or EWL, set status to 'filled'.
        ;I (DGSTA="")!(DGSTA="E") D
        ;if appointment and status '="filled", set status to 'filled'
        I DGSTA'="F" D
        . S DGCOM=$$GET1^DIQ(2,DFNIEN,1010.163)
        . S DGCOM=DGCOM_$S(DGCOM'="":"<>",1:"")_"AutoComm:"_$S(DGSTA="":"null",1:$S($$GET1^DIQ(2,DFNIEN,1010.161,"I")="I":"IN PROGRESS",1:$$GET1^DIQ(2,DFNIEN,1010.161)))_"|FILLED"
        . S FDATA(2,DFNIEN_",",1010.161)="F"
        . S FDATA(2,DFNIEN_",",1010.163)=DGCOM
        . D FILE^DIE("","FDATA","DPTERR")
        . S DGSTA=$$GET1^DIQ(2,DFNIEN,1010.161,"I")
        Q
        ;
DATE    N X1,X2,DIROUT
        S DIR(0)="DAO^,"_DT_",::EX"
        S X1=DT,X2=-7 D C^%DTC
        S Y=X D DD^%DT
        S DIR("A")="APPOINTMENT REQUEST ON 1010EZ START DATE: "
        S DIR("B")=Y
        S DIR("?")="Enter a date that an enrollee was asked question."
        D ^DIR K DIR
        I $D(DIROUT) S DTOUT=1
        I $D(DTOUT)!($D(DUOUT)) Q
        S DGBEG=Y
        S DIR(0)="DAO^"_DGBEG_","_DT_"::EX"
        S Y=DT D DD^%DT S DGDT=Y
        S DIR("B")=DGDT
        S DIR("A")="APPOINTMENT REQUEST ON 1010EZ END DATE: "
        S DIR("?")="Enter a date that an enrollee was asked question."
        D ^DIR K DIR
        I $D(DIROUT) S DTOUT=1
        I $D(DTOUT)!($D(DUOUT)) Q
        S DGEND=Y
        I $G(DGBEG)']""!($G(DGEND)']"") W !!,"DATE RANGE NOT SET.  EXITING"  S DUOUT=1
        Q
FMT1    ;Call List D/S
        N DIR
        K DIR S DIR("A")="Select report format",DIR(0)="S^D:DETAILED;S:SHORT"
        S DIR("?",1)="SHORT format lists enrollee appointment requests w/o an appointment."
        S DIR("?")="DETAILED format, in addition, lists patient lookup information."
        S DIR("B")="SHORT" D ^DIR Q:$D(DIRUT)
        S DGFMT1=Y
        Q
FMT2    ;Tracking Report D/S
        N DIR
        K DIR S DIR("A")="Select report format",DIR(0)="S^D:DETAILED;S:SUMMARY"
        S DIR("?",1)="SUMMARY format lists totals of enrollee appointment requests."
        S DIR("?")="DETAILED format, lists individual enrollee appointment requests."
        S DIR("B")="SUMMARY" D ^DIR Q:$D(DIRUT)
        S DGFMT2=Y
        Q
BCKJOB(DGRPT)   ;Queued entry point
        S DGRPT=$G(DGRPT) I DGRPT'=1 Q
        S DGFMT1="D"
        D BUILD
        Q
