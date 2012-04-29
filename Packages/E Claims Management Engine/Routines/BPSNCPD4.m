BPSNCPD4        ;OAK/ELZ - Extension of BPSNCPDP ;4/16/08  17:07
        ;;1.0;E CLAIMS MGMT ENGINE;**6**;JUN 2004;Build 10
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; This routine is just an extension of BPSNCPDP which was too long.
        ; *** ALL VARIABLES ASSUMED TO BE FROM CALLING BPSNCPDP ROUTINE ***
        ;
        ;
IPSC    ; In Progress/Stranded claims check
        S CLMSTAT="Previous request is IN PROGRESS.  It may need to be unstranded.",RESPONSE=4
        I WFLG W !,CLMSTAT,! H 2
        ; If not OP, then send an email to the OPECC
        I ",AREV,BB,ERES,EREV,"'[(","_BWHERE_",") D
        . ; don't send in progress AGAIN for Tricare
        . I $P($G(^BPST(+$$IEN59^BPSOSRX(BRXIEN,BFILL),9)),"^",4)="T" Q
        . D BULL^BPSNCPD1(BRXIEN,BFILL,$G(SITE),$G(DFN),$G(PNAME),"")
        Q
        ;
BBC     ; Backbilling check
        S CLMSTAT="Previously billed through ECME: "_OLDRESP,RESPONSE=1
        I WFLG W !,CLMSTAT,! H 2
        Q
        ;
NOR     ; Do not reverse if the rx was not previously billed through ECME
        S CLMSTAT="Prescription not previously billed through ECME.  Cannot Reverse claim.",RESPONSE=1
        I WFLG W !,CLMSTAT,! H 2
        Q
        ;
RSNR    ; If returning to stock or deleting and the previous claim was not paid, then no reversal is needed
        ; so close the prescription and quit
        D CLOSE2^BPSBUTL(BRXIEN,BFILL,BWHERE)
        S CLMSTAT="Claim was not payable so it has been closed.  No ECME claim created.",RESPONSE=3
        I WFLG W !,CLMSTAT,! H 2
        Q
        ;
DNR     ; Do not reverse if the claim is not E PAYABLE
        S CLMSTAT="Claim has status "_OLDRESP_".  Not reversed.",RESPONSE=1
        I WFLG W !,CLMSTAT,! H 2
        Q
        ;
EREVRR  ; EREV can be re-reversed if the previous submission is Payable or Rejected Revesal
        S CLMSTAT="Claim has status "_OLDRESP_".  Not reversed.",RESPONSE=1
        I WFLG W !,CLMSTAT,! H 2
        Q
        ;
