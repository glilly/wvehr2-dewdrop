PSBRPC3 ;BIRMINGHAM/VRN - BCMA RPC BROKER CALLS ;6/18/10 11:16am
        ;;3.0;BAR CODE MED ADMIN;**6,3,4,16,13,10,32,28,42**;Mar 2004;Build 23
        ;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
        ;
GUICHK(RESULTS,DUMMY)   ;
        ;
        ; RPC : PSB VERSION CHECK
        ;
        K RESULTS
        N PSBCURR,PSBPREV,PSBCNT
        S PSBCURR="3.0.42.*",PSBPREV="",PSBCNT=0
        S PSBCNT=PSBCNT+1
        S RESULTS(PSBCNT)=PSBCURR_U_PSBPREV
        S RESULTS(0)=PSBCNT
        Q
        ;
