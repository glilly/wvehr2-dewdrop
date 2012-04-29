PXCADXP2        ;ISL/dee & LEA/Chylton - Validates & Translates data from the PCE Device Interface into a call to V POV & update Problem List ; 6/6/05 12:16pm
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**115,130,168**;Aug 12, 1996;Build 14
        Q
        ;
PART2   ;
        ;Problem Active
        S PXCAITEM=$P(PXCADXPL,U,6)
        I '(PXCAITEM="A"!(PXCAITEM="I")!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,6)="Problem Active flag bad^"_PXCAITEM
        ;
        ;Problem Onset Date
        S PXCAITEM=$P(PXCADXPL,U,7)
        I PXCAITEM]"",PXCAITEM>DT!(PXCAITEM<1800000)!($P(+PXCAITEM,".")'=PXCAITEM)!(PXCAITEM>+$P($P(PXCA("ENCOUNTER"),"^"),".")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,7)="Problem Onset Date is bad^"_PXCAITEM
        ;
        ;Problem Resolved Date
        S PXCAITEM=$P(PXCADXPL,U,8)
        I PXCAITEM]"",PXCAITEM>DT!(PXCAITEM<1800000)!($P(+PXCAITEM,".")'=PXCAITEM)!(PXCAITEM>+$P($P(PXCA("ENCOUNTER"),"^"),".")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,8)="Problem Resolved Date is bad^"_PXCAITEM
        ;
        ;SC Condition
        S PXCAITEM=$P(PXCADXPL,U,9)
        I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,9)="SC flag bad^"_PXCAITEM
        ;
        ;AO Condition
        S PXCAITEM=$P(PXCADXPL,U,10)
        I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,10)="AO flag bad^"_PXCAITEM
        ;
        ;IR Condition
        S PXCAITEM=$P(PXCADXPL,U,11)
        I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,11)="IR flag bad^"_PXCAITEM
        ;
        ;EC Condition
        S PXCAITEM=$P(PXCADXPL,U,12)
        I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,12)="EC flag bad^"_PXCAITEM
        ;
        ;PX*1*115 - MST Condition
        S PXCAITEM=$P(PXCADXPL,U,15)
        I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,15)="MST flag bad^"_PXCAITEM
        ;
        ;PX*1*115 - HNC Condition
        S PXCAITEM=$P(PXCADXPL,U,16)
        I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,16)="HNC flag bad^"_PXCAITEM
        ;
        S PXCAITEM=$P(PXCADXPL,U,17)
        I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,17)="CV flag bad^"_PXCAITEM
        ;
        S PXCAITEM=$P(PXCADXPL,U,18)
        I '(PXCAITEM=1!(PXCAITEM=0)!(PXCAITEM="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,18)="PROJ 112/SHAD flag bad^"_PXCAITEM
        ;
        ;Narrative: Required for DX and for new Problem
        S PXCAITEM=$P(PXCADXPL,"^",13),PXCAITM2=$L(PXCAITEM)
        I PXCAITEM]"" D
        . I PXCAITM2<2!(PXCAITM2>80) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,13)="Provider's Narrative must be 2-80 Characters^"_PXCAITEM
        . E  D
        .. S PXCAITM3=+$$PROVNARR^PXAPI(PXCAITEM,9000010.07,$G(PXCACLEX))
        .. I PXCAITM3'>0 S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,13)="Could not get pointer to Provider's NARRATIVE^"_PXCAITEM
        .. E  S $P(PXCADXPL,"^",13)=PXCAITM3
        E  D
        .I PXCADIAG S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,13)="Provider's Narrative is required for DIAGNOSIS "
        .I PXCAPROB,($P(PXCADXPL,"^",4)="") S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,13)=$P($G(PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,13)),"^",1)_"Provider's Narrative is required for a new PROBLEM"
        ;
        ;Narrative Category
        S PXCAITEM=$P(PXCADXPL,"^",14),PXCAITM2=$L(PXCAITEM)
        I PXCAITEM]"" D
        . I PXCAITM2<2!(PXCAITM2>80) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,14)="Provider's NARRATIVE Category must be 2-80 Characters^"_PXCAITEM
        . E  D
        .. S PXCAITM3=+$$PROVNARR^PXAPI(PXCAITEM,9000010.07)
        .. I PXCAITM3'>0 S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,14)="Could not get pointer to Provider's NARRATIVE Category^"_PXCAITEM
        .. E  S $P(PXCADXPL,"^",14)=PXCAITM3
        ;
        Q
        ;
