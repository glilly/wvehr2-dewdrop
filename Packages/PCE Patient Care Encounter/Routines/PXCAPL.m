PXCAPL  ;ISL/dee & LEA/Chylton - Validates data from the PCE Device Interface into a call to update Problem List ;6/6/05
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**24,27,115,130,168**;Aug 12, 1996;Build 14
        Q
        ;   PXCAPROB  Copy of a Problem node of the PXCA array
        ;   PXCAPRV   Pointer to the provider (200)
        ;   PXCAINDX  Count of the number of problems for one provider
        ;   PXCAPL    The parameter array passed to Problem List
        ;   PXCARES   The result back from Problem List
        ;   PXCANUMB  Count of the total number of problems
        ;
        ;
PROBLEM(PXCA,PXCABULD,PXCAERRS) ;
        Q:'$D(PXCA("PROBLEM"))
        I '$D(^AUPNPROB)!($T(UPDATE^GMPLUTL)="") S PXCA("WARNING","PROBLEM",0,0,0)="Problem List Package is not installed" Q
        N PXCAPROB,PXCAPRV,PXCAINDX
        N PXCAITEM,PXCAITM2
        S PXCAPRV=""
        F  S PXCAPRV=$O(PXCA("PROBLEM",PXCAPRV)) Q:PXCAPRV']""  D
        . I '$$ACTIVPRV^PXAPI(PXCAPRV,PXCADT) S PXCA("ERROR","PROBLEM",PXCAPRV,0,0)="Provider is not active or valid^"_PXCAPRV
        . E  I PXCABULD!PXCAERRS D ANOTHPRV^PXCAPRV(PXCAPRV)
        . S PXCAINDX=0
        . F  S PXCAINDX=$O(PXCA("PROBLEM",PXCAPRV,PXCAINDX)) Q:PXCAINDX']""  D
        .. S PXCAPROB=$G(PXCA("PROBLEM",PXCAPRV,PXCAINDX))
        .. I PXCAPROB="" S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,0)="PROBLEM data missing" Q
        .. S PXCAITEM=$P(PXCAPROB,U,1),PXCAITM2=$L(PXCAITEM)
        .. I PXCAITEM]"",PXCAITM2<2!(PXCAITM2>80) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,1)="Problem Name must be 2-80 Characters^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,2)
        .. I PXCAITEM]"",PXCAITEM>DT!(PXCAITEM<1800000)!($P(+PXCAITEM,".")'=PXCAITEM)!(PXCAITEM>+$P($P(PXCA("ENCOUNTER"),"^"),".")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,7)="Problem Onset Date is bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,3)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,3)="Problem Active flag bad^"_PXCAITEM
        .. E  I PXCAITEM="" S $P(PXCA("PROBLEM",PXCAPRV,PXCAINDX),U,3)=1
        .. S PXCAITEM=$P(PXCAPROB,U,4)
        .. I PXCAITEM]"",PXCAITEM>DT!(PXCAITEM<1800000)!($P(+PXCAITEM,".")'=PXCAITEM)!(PXCAITEM>+$P($P(PXCA("ENCOUNTER"),"^"),".")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,7)="Problem Resolved Date is bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,5)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,5)="SC flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,6)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,6)="AO flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,7)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,7)="IR flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,8)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,8)="EC flag bad^"_PXCAITEM
        .. ;PX*1*115 - ADD MST & HNC
        .. S PXCAITEM=$P(PXCAPROB,U,13)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,13)="MST flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,14)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,14)="HNC flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,15)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,14)="CV flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,16)
        .. I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,16)="PROJ 112/SHAD flag bad^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,9)
        .. I PXCAITEM>0 D
        ... N DIC,DR,DA,DIQ,PXCADIQ1
        ... S DIC=80
        ... S DR=".01;102"
        ... S DA=PXCAITEM
        ... S DIQ="PXCADIQ1("
        ... S DIQ(0)="I"
        ... D EN^DIQ1
        ... I $G(PXCADIQ1(80,DA,.01,"I"))="" S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,9)="ICD9 Code not in file 80^"_PXCAITEM
        ... E  I $G(PXCADIQ1(80,DA,102,"I")),PXCADIQ1(80,DA,102,"I")'>+PXCADT S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,9)="ICD9 Code is INACTIVE^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,10)
        .. I PXCAITEM]"" D
        ... I $G(^AUPNPROB(PXCAITEM,0))="" S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,10)="Problem not in file 9000011^"_PXCAITEM
        ... E  I PXCAPAT'=$P($G(^AUPNPROB(PXCAITEM,0)),"^",2) S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,10)="Problem in file 9000011 is for a different Patient^"_PXCAITEM
        .. E  S PXCAITEM=$P(PXCAPROB,U,1) I PXCAITEM']"" S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,1)="Problem Name required for a new Problem List entry^"_PXCAITEM
        .. S PXCAITEM=$P(PXCAPROB,U,11),PXCAITM2=$L(PXCAITEM)
        .. I PXCAITM2>60 S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,11)="PROBLEM comment must be 1-60 Characters^"_PXCAITEM
        .. ;
        .. ;Clinical Lexicon Term
        .. S PXCAITEM=$P(PXCAPROB,"^",12)
        .. I PXCAITEM]"" D
        ... I $D(^LEX(757.01)) D
        .... I $D(^LEX(757.01,PXCAITEM,0))#2'=1 S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,12)="Lexicon Utility term is not in file 757.01^"_PXCAITEM
        .... E  S PXCACLEX=PXCAITEM
        ... E  I $D(^GMP(757.01)) D
        .... I $D(^GMP(757.01,PXCAITEM,0))#2'=1 S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,12)="Clinical Lexicon Utility term is not in file 757.01^"_PXCAITEM
        .... E  S PXCACLEX=PXCAITEM
        ... E  S PXCA("ERROR","PROBLEM",PXCAPRV,PXCAINDX,12)="Lexicon Utility is not installed^"_PXCAITEM
        ;
        Q
        ;
