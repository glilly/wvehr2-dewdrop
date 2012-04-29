BPSNCPDP        ;BHAM ISC/LJE - API to submit a claim to ECME ;4/16/08  15:11
        ;;1.0;E CLAIMS MGMT ENGINE;**1,3,4,2,5,6**;JUN 2004;Build 10
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; For comments regarding this API, see routine BPSNCPD1.
        ;
EN(BRXIEN,BFILL,BFILLDAT,BWHERE,BILLNDC,REVREAS,DURREC,BPOVRIEN,BPSCLARF,BPSAUTH)       ;
EN1     N DFN,PNAME,BRX,BPSARRY,MOREDATA,SITE,WFLG,OLDRESP,IEN59,BPSELIG,%,%I,%H,X,TODAY,QUIT,CERTIEN,REBILL,REVONLY,CLMSTAT,RESPONSE,BPSTART,IB,RESP,BPSSTAT
        ;
        ; Default variables
        S RESPONSE="",CLMSTAT="",BFILL=$S('$G(BFILL):0,1:BFILL)
        ;
        ; Check for valid RX and fill
        I '$G(BRXIEN) S CLMSTAT="Prescription IEN parameter missing",RESPONSE=5 G END
        ;
        ; Setup IEN59, and initialize log
        S IEN59=$$IEN59^BPSOSRX(BRXIEN,BFILL)
        I IEN59="" S CLMSTAT="BPS Transaction IEN could not be calculated",RESPONSE=1 G END
        D LOG^BPSOSL(IEN59,$T(+0)_"-Start of claim","DT")
        ;
        ; Check for BWHERE parameter
        I $G(BWHERE)="" S CLMSTAT="RX Action parameter missing",RESPONSE=5 G END
        ;
        ; Get rx number
        S BRX=$$RXAPI1^BPSUTIL1(BRXIEN,.01,"I")
        ;
        ; Check that the rx exists
        I BRX="" S CLMSTAT="Prescription does not exist",RESPONSE=5 G END
        ;
        ; Get the NDC if it was not passed in
        I $G(BILLNDC)="" S BILLNDC=$$GETNDC^PSONDCUT(BRXIEN,BFILL)
        ;
        ; Patient Info
        S DFN=$$RXAPI1^BPSUTIL1(BRXIEN,2,"I"),PNAME=$$GET1^DIQ(2,DFN,.01)
        ;
        ; Set write flag
        S WFLG=1
        I ",ARES,AREV,CRLB,CRLR,CRLX,DDED,DE,EREV,HLD,PC,PE,PL,RS,"[(","_BWHERE_",") S WFLG=0
        ;
        ; Get status of previously submitted claim and set rebill/revonly flags
        S (REBILL,REVONLY)=0
        S OLDRESP=$P($$STATUS^BPSOSRX(BRXIEN,BFILL,1),U)
        I ",AREV,CRLR,CRLX,DC,DDED,DE,EREV,HLD,RS,"[(","_BWHERE_",") S REVONLY=1
        E  I OLDRESP="E PAYABLE"!(OLDRESP="E DUPLICATE") S REBILL=1
        ;
        ; Get Site info and check if the site has ECME turned on.  Note that
        ;   ECMEON will also return false if there is no NPI after the drop
        ;   dead date.  Do not do this check for reversals/rebill as these
        ;   need to be processed for the old site
        I 'BFILL S SITE=$$RXAPI1^BPSUTIL1(BRXIEN,20,"I")
        I BFILL S SITE=$$RXSUBF1^BPSUTIL1(BRXIEN,52,52.1,+BFILL,8,"I")
        I 'REVONLY,'REBILL D  I RESPONSE=1 G END
        . I '$G(SITE) S CLMSTAT="No Site Information",RESPONSE=1 Q
        . I '$$ECMEON^BPSUTIL(SITE) S CLMSTAT="ECME switch is not on for the site",RESPONSE=1
        ;
        ; In Progress/Stranded claims check
        I OLDRESP["IN PROGRESS" D IPSC^BPSNCPD4 G END
        ;
        ; Backbilling check
        I BWHERE="BB",OLDRESP'="" D BBC^BPSNCPD4 G END
        ;
        ; Do not reverse if the rx was not previously billed through ECME
        I OLDRESP="",(",AREV,CRLR,CRLX,DC,DDED,DE,EREV,HLD,RS,"[(","_BWHERE_",")) D NOR^BPSNCPD4 G END
        ;
        ; If returning to stock or deleting and the previous claim was not paid, then no reversal is needed
        ;   so close the prescription and quit
        I OLDRESP'["E PAYABLE",OLDRESP'["E REVERSAL REJECTED",(",RS,DE,"[(","_BWHERE_",")) D RSNR^BPSNCPD4 G END
        ;
        ; Do not reverse if the claim is not E PAYABLE
        I OLDRESP'["E PAYABLE",OLDRESP'["E DUPLICATE",(",AREV,CRLR,CRLX,DC,DDED,HLD,"[(","_BWHERE_",")) D DNR^BPSNCPD4 G END
        ;
        ; EREV can be re-reversed if the previous submission is Payable or Rejected Revesal
        I BWHERE="EREV",",E PAYABLE,E DUPLICATE,E REVERSAL REJECTED,E REVERSAL STRANDED,"'[(","_OLDRESP_",") D EREVRR^BPSNCPD4 G END
        ;
        ; Make sure fill date is not in the future or empty
        S TODAY=$P($$STTM,".",1)
        I '$G(BFILLDAT)!($G(BFILLDAT)>TODAY) S BFILLDAT=TODAY
        ;
        ; Store needed parameters into MOREDATA
        S MOREDATA("USER")=$S('DUZ:.5,1:DUZ)
        S MOREDATA("RX ACTION")=$G(BWHERE)
        S MOREDATA("DATE OF SERVICE")=$P($G(BFILLDAT),".")
        S MOREDATA("REVERSAL REASON")=$S($G(REVREAS)="":"UNKNOWN",1:$E($G(REVREAS),1,40))
        I $G(DURREC)]"" S MOREDATA("DUR",1,0)=DURREC
        I $G(BPOVRIEN)]"" S MOREDATA("BPOVRIEN")=BPOVRIEN
        I $G(BPSCLARF)]"" S MOREDATA("BPSCLARF")=BPSCLARF
        I $TR($G(BPSAUTH),U)]"" S MOREDATA("BPSAUTH")=BPSAUTH
        ;
        ; Do a reversal for the appropriate actions
        I ",AREV,CRLR,CRLX,DC,DDED,DE,EREV,HLD,RS,"[(","_BWHERE_",") D  G STATUS:RESPONSE=0,END:RESPONSE=4
        . ; If override flag is set, prompt for override values - TEST ONLY
        . I $$CHECK^BPSTEST D GETOVER^BPSTEST(BRXIEN,BFILL,OLDRESP,BWHERE,"R")
        . ;
        . ; Needed for Turn-Around Stats - Do NOT delete/alter!!
        . D LOG(IEN59,"Before Submit of Reversal")
        . S BPSTART=$$STTM()
        . S RESP=$$UNCLAIM^BPSOSRX(BRXIEN,BFILL,.MOREDATA)
        . D LOG(IEN59,"After Submit of Reversal. Return Value: "_RESP)
        . I RESP=1 D
        .. S RESPONSE=0,CLMSTAT="Reversing prescription "_BRX_"."
        .. I WFLG W !,CLMSTAT H 2
        . I RESP=0 D
        .. S RESPONSE=4,CLMSTAT="No claim submission made.  Unable to queue reversal."
        .. D LOG(IEN59,CLMSTAT)
        .. I WFLG W !,CLMSTAT,! H 2
        .. L -^BPST
        ;
        ; Can not resubmit reversed claims unless they are accepted
        I OLDRESP]"",OLDRESP["E REVERSAL",OLDRESP'="E REVERSAL ACCEPTED" D  G END
        . S CLMSTAT="Can not resubmit a rejected or stranded reversal",RESPONSE=1
        . I WFLG W !,CLMSTAT,! H 2
        ;
        ; Some actions require a paid claim (they will not do a reversal/resubmit)
        I OLDRESP]"",OLDRESP'="E REVERSAL ACCEPTED",OLDRESP'="E REJECTED",(",CRLB,ED,ERES,RL,RRL,"'[(","_BWHERE_",")) D  G END
        . S CLMSTAT="Previously billed through ECME: "_OLDRESP,RESPONSE=1
        . I WFLG W !,CLMSTAT,! H 2
        ;
        ; Certification Testing
        S QUIT=0,CERTIEN=""
        I ^BPS(9002313.99,1,"CERTIFIER")=DUZ D  I QUIT S CLMSTAT="User exited from certification questions",RESPONSE=1 G END
C1      . R !,"ENTER NDC: ",BILLNDC:120 S:BILLNDC=U QUIT=1 Q:QUIT  I BILLNDC="" G C1
C3      . R !,"CERTIFICATION ENTRY: ",CERTIEN:120 I '$D(^BPS(9002313.31,CERTIEN)) S:CERTIEN=U QUIT=1 Q:QUIT  W !,"INVALID IEN" G C3
        I WFLG W !!
        ;
        ; Build array BPSARRY with prescription data
        D STARRAY^BPSNCPD1(BRXIEN,BFILL,BWHERE,.BPSARRY,$G(SITE))
        ;
        ; Do IB billing determination and check response
        ; If IB=2, then not billable, so write messages
        S IB=0
        D EN^BPSNCPD2(DFN,BWHERE,.MOREDATA,.BPSARRY,.IB)
        I IB=2,(OLDRESP="E PAYABLE")!(OLDRESP="E DUPLICATE"),(",CRLB,ED,ERES,RL,RRL,"[(","_BWHERE_",")) D
        .S MOREDATA("REVERSE THEN RESUBMIT")=2
        .S CLMSTAT=$P(MOREDATA("BILL"),U,2)
        .D LOG(IEN59,CLMSTAT_" - Claim Will Be Reversed But Will Not Be Resubmitted")
        .I WFLG W !,CLMSTAT_" - Claim Will Be Reversed But Will Not Be Resubmitted" H 2
        ; need to run with writing on for Tricare
        I $G(MOREDATA("ELIG"))="T",(",PE,PL,PC,"[(","_BWHERE_",")) S WFLG=1
        ;
        I IB=2,$G(MOREDATA("REVERSE THEN RESUBMIT"))'=2 D  G END
        . S RESPONSE=$S($G(BPSARRY("NO ECME INSURANCE")):6,1:2)
        . S CLMSTAT=$P(MOREDATA("BILL"),U,2)
        . I OLDRESP]"" D LOG(IEN59,CLMSTAT)
        ;
        ; Check for missing data (Will IB billing determination catch this?)
        I $D(MOREDATA("IBDATA",1,1)),$P(MOREDATA("IBDATA",1,1),U)="",$G(MOREDATA("REVERSE THEN RESUBMIT"))'=2 D  G END
        . S RESPONSE=$S($G(BPSARRY("NO ECME INSURANCE")):6,1:2),CLMSTAT="Information missing from IB data."
        . I WFLG W !,CLMSTAT,! H 2
        ;
        ; Check for missing/invalid payer sheets (I think IB billing determination will catch this)
        I $P($G(MOREDATA("IBDATA",1,1)),U,4)="",$G(MOREDATA("REVERSE THEN RESUBMIT"))'=2 D  G END
        . S RESPONSE=$S($G(BPSARRY("NO ECME INSURANCE")):6,1:2),CLMSTAT="Invalid/missing payer sheet from IB data."
        . I WFLG W !,CLMSTAT,! H 2
        ;
        ; Check if IB says to bill
        I '$G(MOREDATA("BILL")),$G(MOREDATA("REVERSE THEN RESUBMIT"))'=2 D  G END
        . S RESPONSE=$S($G(BPSARRY("NO ECME INSURANCE")):6,1:2)
        . S CLMSTAT="Flagged by IB to not 3rd Party Insurance bill through ECME."
        . I WFLG W !,CLMSTAT,! H 2
        ;
        ; Log message to ECME log
        ; Needed for Turn-Around Stats - Do NOT delete/alter!!
        D LOG(IEN59,"Before submit of claim")
        ;
        ; If override flag is set, prompt for override values - TEST ONLY
        I $$CHECK^BPSTEST D GETOVER^BPSTEST(BRXIEN,BFILL,OLDRESP,BWHERE,"S")
        ;
        ; Get require data
        S BPSTART=$$STTM()
        ;
        ; Submit claim and check result
        S RESP=$$CLAIM^BPSOSRX(BRXIEN,BFILL,.MOREDATA)
        D LOG(IEN59,"After Submit of Claim.  Return Value: "_RESP)
        I RESP=1 D
        . S RESPONSE=0
        . I $G(MOREDATA("REVERSE THEN RESUBMIT"))=2 S CLMSTAT=$S($G(MOREDATA("ELIG"))="T":"TRICARE ",1:"")_"Prescription "_BRX_$S($G(MOREDATA("ELIG"))="T":"",1:" successfully")_" submitted to ECME for claim reversal."
        . E  S CLMSTAT=$S($G(MOREDATA("ELIG"))="T":"TRICARE ",1:"")_"Prescription "_BRX_$S($G(MOREDATA("ELIG"))="T":"",1:" successfully")_" submitted to ECME for claim generation."
        . I WFLG W !!,CLMSTAT
        I RESP=0 D  G END
        . S RESPONSE=4
        . S CLMSTAT="No claim submission made.  Unable to queue claim submission."
        . I WFLG W !!,CLMSTAT,!
        . D LOG(IEN59,CLMSTAT)
        ;
        ; Display status
STATUS  I 'WFLG H 1
        E  D STATUS^BPSNCPD1(BRXIEN,BFILL,REBILL,REVONLY,BPSTART,BWHERE)
        ;
        ;Update Response for Reversal but no Resubmit
        I $G(MOREDATA("REVERSE THEN RESUBMIT"))=2 S RESPONSE=10,CLMSTAT=$P($G(MOREDATA("BILL")),U,2)
        ;
        ;
END     S BPSELIG=$G(MOREDATA("ELIG"))
        ; need to look up current status and return (mm if tricare in progress)
        S BPSSTAT=$S($G(BRXIEN):$P($$STATUS^BPSOSRX(BRXIEN,BFILL),U),1:"")
        I BPSELIG="T",BPSSTAT="IN PROGRESS",DURREC'="RX RELEASE-NDC CHANGE" D BULL^BPSNCPD1(BRXIEN,BFILL,SITE,DFN,PNAME,1)
        ;
        K BRXIEN,BFILL,BFILLDAT,BWHERE,MOREDATA
        S:'$D(RESPONSE) RESPONSE=1
        I $G(IEN59) D
        . N MSG
        . S MSG="Foreground Process Complete-RESPONSE="_$G(RESPONSE)
        . I $G(RESPONSE)'=0 S MSG=MSG_", CLMSTAT="_$G(CLMSTAT)
        . D LOG(IEN59,MSG)
        ;
        Q RESPONSE_U_$G(CLMSTAT)_U_BPSELIG_U_BPSSTAT
        ;
LOG(IEN59,MSG)  ;
        D LOG^BPSOSL(IEN59,$T(+0)_"-"_MSG)
        Q
STTM()  ;
        Q $$NOW^XLFDT
