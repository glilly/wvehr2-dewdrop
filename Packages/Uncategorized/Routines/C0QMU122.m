C0QMU122        ;VEN/SMH - Patient Reminder List, cont. again ; 7/31/12 12:33pm
        ;;1.0;C0Q;;May 21, 2012;Build 68
        ;
        ; Licensed under package license.
        ;
DEMO    ; patient demographics
        K PTDOB
        N PTNAME,PTSEX,PTHRN,PTRLANG,PTLANG,RACE,RACEDSC,ETHN,ETHNDSC,RB
        S PTNAME=$P(^DPT(DFN,0),U) ;patient name
        S PTDOB=$$FMTE^XLFDT($P($G(^DPT(DFN,0)),U,3)) ;date of birth
        S PTSEX=$P($G(^DPT(DFN,0)),U,2) ;patient sex
        D PID^VADPT ;VADPT call to grab PISD based on PT Eligibility
        S PTHRN=$P($G(VA("PID")),U) ;health record number
        S PTRLANG=$P($G(^DPT(DFN,256000)),U) ;ptr to language file
        I $G(PTRLANG)'="" S PTLANG=$P(^DI(.85,PTRLANG,0),U) ;PLS extrnl
        S RACE=""
        F  D  Q:RACE=""
        . S RACE=$O(^DPT(DFN,.02,"B",RACE)) ;race code IEN
        . Q:'RACE
        . S RACEDSC=$P($G(^DIC(10,RACE,0)),U) ;race description
        S ETHN=""
        F  D  Q:ETHN=""
        . S ETHN=$O(^DPT(DFN,.06,"B",ETHN)) ;ethnicity IEN
        . Q:'ETHN
        . S ETHNDSC=$P($G(^DIC(10.2,ETHN,0)),U) ;ethnincity description
        S RB=$P($G(^DPT(DFN,.101)),U) ;room and bed
        N DEMOYN S DEMOYN=1
        I $G(PTSEX)="" S DEMOYN=0
        I $G(PTDOB)="" S DEMOYN=0
        I $G(PTHRN)="" S DEMOYN=0
        I $G(PTLANG)="" S DEMOYN=0
        I $G(RACEDSC)="" S DEMOYN=0
        I $G(ETHNDSC)="" S DEMOYN=0
        I DEMOYN S C0QLIST(ZYR_"HasDemographics",DFN)=""
        E  S C0QLIST(ZYR_"FailedDemographics",DFN)=""
        Q
        ;
