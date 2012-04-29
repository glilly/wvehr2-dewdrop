IBCBB0  ;ALB/ESG - IB edit check routine continuation ;12-Mar-2008
        ;;2.0;INTEGRATED BILLING;**377**;21-MAR-94;Build 23
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
PAYERADD(IBIFN) ; check to make sure payer address is present for all payers on the claim
        ; Address line 1, city, state, and zip must be present for all non-Medicare payers on the claim
        ;
        NEW IBZ,OK,Z,IBL,N,SEQ,ADDR,IBXDATA,IBXSAVE,IBXARRAY,IBXARRY,IBXERR
        ;
        ; check current payer address if not Medicare
        I '$$WNRBILL^IBEFUNC(IBIFN) D
        . D F^IBCEF("N-CURR INS CO FULL ADDRESS","IBZ",,IBIFN)
        . S OK=1
        . F Z=1,4,5,6 I $G(IBZ(Z))="" S OK=0 Q
        . I 'OK S IBER=IBER_"IB172;"
        . Q
        ;
        ; check other payer addresses if they exist
        D F^IBCEF("N-OTH INSURANCE SEQUENCE","IBL",,IBIFN)    ; other payer sequence array
        I '$O(IBXSAVE(1,0)) G PAYERAX                         ; no other payers on claim
        S N=0 F  S N=$O(IBXSAVE(1,N)) Q:'N  D
        . S SEQ=IBXSAVE(1,N)                                  ; other payer sequence letter
        . I $$WNRBILL^IBEFUNC(IBIFN,SEQ) Q                    ; ignore Medicare addresses
        . S ADDR=$$ADD^IBCNADD(IBIFN,SEQ)                     ; other payer address string
        . S OK=1
        . F Z=1,4,5,6 I $P(ADDR,U,Z)="" S OK=0 Q
        . I 'OK S IBER=IBER_"IB173;"
        . Q
        ;
PAYERAX ;
        Q
        ;
