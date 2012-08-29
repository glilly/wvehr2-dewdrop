PXCAPOV ;ISL/dee & LEA/Chylton - Validates data from the PCE Device Interface into PCE's PXK format for POV ;3/20/97
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**24,27,33,121,130,124,168**;Aug 12, 1996;Build 14
        Q
        ; Variables
        ;   PXCADIAG  Copy of a Diagnosis node of the PXCA array
        ;   PXCAPRV   Pointer to the provider (200)
        ;   ;   PXCANPOV  Count of the number of POVs
        ;   PXCANUMB  Count of the number if POVs
        ;   PXCAINDX  Count of the number of Diagnoses for one provider
        ;
DIAG(PXCA,PXCABULD,PXCAERRS)    ;Validation routine for POV
        N PXCADIAG,PXCAPRV,PXCAINDX
        S PXCAPRV=""
        F  S PXCAPRV=$O(PXCA("DIAGNOSIS",PXCAPRV)) Q:PXCAPRV']""  D
        . I PXCAPRV>0 D
        .. I '$$ACTIVPRV^PXAPI(PXCAPRV,PXCADT) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,0,0)="Provider is not active or valid^"_PXCAPRV
        .. E  I PXCABULD!PXCAERRS D ANOTHPRV^PXCAPRV(PXCAPRV)
        . S PXCAINDX=0
        . F  S PXCAINDX=$O(PXCA("DIAGNOSIS",PXCAPRV,PXCAINDX)) Q:PXCAINDX']""  D
        .. S PXCADIAG=$G(PXCA("DIAGNOSIS",PXCAPRV,PXCAINDX))
        .. I PXCADIAG="" S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,0)="DIAGNOSIS data missing" Q
        .. S PXCANPOV=PXCANPOV+1
        .. N PXCAITEM,PXCAITM2,PXCAPNAR,PXCANARC,PXCACLEX
        .. ;
        .. S PXCAITEM=$P(PXCADIAG,"^",1)
        .. D
        ... ;N DIC,DR,DA,DIQ,PXCADIQ1
        ... ;S DIC=80
        ... ;S DR=".01;102"
        ... ;S DA=$S(PXCAITEM'="":PXCAITEM,1:-1)
        ... ;S DIQ="PXCADIQ1("
        ... ;S DIQ(0)="I"
        ... ;D EN^DIQ1
        ... ;I $G(PXCADIQ1(80,DA,.01,"I"))="" S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,1)="ICD9 Code not in file 80^"_PXCAITEM
        ... ;E  I $G(PXCADIQ1(80,DA,102,"I")),PXCADIQ1(80,DA,102,"I")'>+PXCADT S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,1)="ICD9 Code is INACTIVE^"_PXCAITEM
        ... N ICDSTR,ICDCN,ICDID
        ... S ICDSTR=$$ICDDX^ICDCODE($S(PXCAITEM'="":PXCAITEM,1:-1),+PXCADT)
        ... S ICDCN=$P(ICDSTR,"^",2)
        ... S ICDID=$P(ICDSTR,"^",12)
        ... I +ICDSTR=-1 S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,1)="ICD9 Code not in file 80^"_PXCAITEM
        ... E  I '$P(ICDSTR,"^",10) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,1)="ICD9 Code is INACTIVE^"_PXCAITEM
        ...;
        .. S PXCAITEM=$P(PXCADIAG,"^",2)
        .. I '(PXCAITEM=""!(PXCAITEM="P")!(PXCAITEM="S")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,2)="Diagnosis specification code must be P|S^"_PXCAITEM
        .. E  I PXCAITEM="P" D
        ... I 'PXCAPDX S PXCAPDX=$P(PXCADIAG,"^",1)
        ... E  I $P($G(^PX(815,1,"DI")),"^",2) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,2)="There is already a Primary Diagnosis for this encounter^"_PXCAITEM
        ... E  D
        .... S PXCA("WARNING","DIAGNOSIS",PXCAPRV,PXCAINDX,2)="There is already a Primary Diagnosis. This one is changed to Secondary^"_PXCAITEM
        .... S $P(PXCADIAG,"^",2)="S"
        .. S PXCAITEM=$P(PXCADIAG,"^",3)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,3)="SC flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCADIAG,"^",4)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,4)="AO flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCADIAG,"^",5)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,5)="IR flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCADIAG,"^",6)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,6)="EC flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCADIAG,"^",11)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,11)="MST flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCADIAG,"^",12)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,12)="HNC flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCADIAG,"^",13)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,13)="CV flag bad^"_PXCAITEM ;CV
        .. S PXCAITEM=$P(PXCADIAG,"^",14)
        .. I '(PXCAITEM="R"!(PXCAITEM="O")!(PXCAITEM="RO")!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,14)="Ordering/Resulting field bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCADIAG,"^",14)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,15)="PROJ 112/SHAD flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCADIAG,"^",7)
        .. I PXCAITEM]"" D
        ... I $G(^AUPNPROB(PXCAITEM,0))="" S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,7)="Problem not in file 9000011^"_PXCAITEM
        ... E  I PXCAPAT'=$P($G(^AUPNPROB(PXCAITEM,0)),"^",2) S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,7)="Problem in file 9000011 is for a different Patient^"_PXCAITEM
        .. ;
        .. ;Clinical Lexicon Term
        .. S PXCAITEM=$P(PXCADIAG,"^",10)
        .. I PXCAITEM]"" D
        ... I $D(^LEX(757.01)) D
        .... I $D(^LEX(757.01,PXCAITEM,0))#2'=1 S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,10)="Lexicon Utility term is not in file 757.01^"_PXCAITEM
        .... E  S PXCACLEX=PXCAITEM
        ... E  I $D(^GMP(757.01)) D
        .... I $D(^GMP(757.01,PXCAITEM,0))#2'=1 S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,10)="Clinical Lexicon Utility term is not in file 757.01^"_PXCAITEM
        .... E  S PXCACLEX=PXCAITEM
        ... E  S PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX,10)="Lexicon Utility is not installed^"_PXCAITEM
        .. ;
        .. D PART1^PXCAPOV1
        .. ;
        .. I PXCABULD&'$D(PXCA("ERROR","DIAGNOSIS",PXCAPRV,PXCAINDX))!PXCAERRS D POV^PXCADX(PXCADIAG,PXCANPOV,PXCAPRV,PXCAERRS)
        Q
        ;
ANOTHPOV(PXCAAPOV)      ; 
        ;Add the diagnosis to V POV if they are not there.
        ;Quit if the provider subscript is zero
        ; Variables
        ;   PXCAAPOV  Pointer to the DIAGNOSIS (80)
        ;   PXCAINDX  Subscript of the diagnosis in the temp array used to
        ;               look to see if the above diagnosis is already know.
        Q:PXCAAPOV'>0
        N PXCAINDX
        ;See if this diagnosis is in the ^TMP(PXCAGLB,$J,
        F PXCAINDX=1:1:PXCANPOV I PXCAAPOV=+$G(^TMP(PXCAGLB,$J,"POV",PXCAINDX,0,"AFTER")) S PXCAINDX=0 Q
        Q:PXCAINDX'>0
        S PXCAINDX=0
        ;See if this diagnosis is already in V POV for this Encounter
        F  S PXCAINDX=$O(^AUPNVPOV("AD",PXCAVSIT,PXCAAPOV)) Q:PXCAINDX'>0  I PXCAAPOV=$P(^AUPNVPOV(PXCAINDX,0),"^",1) Q
        Q:PXCAINDX>0
        S PXCANPOV=PXCANPOV+1
        S ^TMP(PXCAGLB,$J,"POV",PXCANPOV,"IEN")=""
        S ^TMP(PXCAGLB,$J,"POV",PXCANPOV,0,"BEFORE")=""
        S ^TMP(PXCAGLB,$J,"POV",PXCANPOV,0,"AFTER")=PXCAAPOV_"^"_PXCAPAT_"^"_PXCAVSIT_"^^^^^^^^^S"
        S ^TMP(PXCAGLB,$J,"POV",PXCANPOV,812,"BEFORE")=""
        S ^TMP(PXCAGLB,$J,"POV",PXCANPOV,812,"AFTER")="^"_PXCAPKG_"^"_PXCASOR
        Q
        ;
