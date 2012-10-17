BPSFLD01        ;ALB/SS - ePharmacy secondary billing - COB fields processing ;27-FEB-09
        ;;1.0;E CLAIMS MGMT ENGINE;**8**;JUN 2004;Build 29
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
SET337  ; 337-4C Other Payments Count
        ; This field is used twice.
        ; The total count is stored in 9002313.0201,337.  BPSOPIEN is not defined for this case.
        ; The individual counter is stored in 9002313.0401,.01 where BPSOPIEN is defined.
        ;
        I '$G(BPSOPIEN) S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),330),U,7)=BPS("X") Q
        ;
        S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,0),U,1)=BPS("X")
        S ^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,"B",BPS("X"),BPSOPIEN)=""
        S ^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,0)="^9002313.0401A^"_BPSOPIEN_U_BPSOPIEN
        Q
        ;
SET338  ; 338-5C Other Payer Coverage Type
        I $G(BPSOPIEN) S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,0),U,2)=BPS("X")
        Q
        ;
SET339  ; 339-6C Other Payer ID Qualifier
        I $G(BPSOPIEN) S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,0),U,3)=BPS("X")
        Q
        ;
SET340  ; 340-7C Other Payer ID
        I $G(BPSOPIEN) S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,0),U,4)=BPS("X")
        Q
        ;
SET443  ; 443-E8 Other Payer Date
        I $G(BPSOPIEN) S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,0),U,5)=BPS("X")
        Q
        ;
SET341  ; 341-HB Other Payer Amount Paid Count
        I $G(BPSOPIEN) S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,0),U,6)=BPS("X")
        Q
        ;
SET471  ; 471-5E Other Payer Reject Count
        I $G(BPSOPIEN) S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,0),U,7)=BPS("X")
        Q
        ;
SET342  ; 342-HC Other Payer Amount Paid Qualifier
        ; .01 field in the 9002313.401342 sub-file
        I '$G(BPSOPIEN)!'$G(BPSOAIEN) Q
        S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,1,BPSOAIEN,0),U,1)=BPS("X")
        S ^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,1,"B",BPS("X"),BPSOAIEN)=""
        S ^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,1,0)="^9002313.401342A^"_BPSOAIEN_U_BPSOAIEN
        Q
        ;
SET431  ; 431-DV Other Payer Amount Paid
        I '$G(BPSOPIEN)!'$G(BPSOAIEN) Q
        S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,1,BPSOAIEN,0),U,2)=BPS("X")
        ;;;;;;
        ;;; this field is also being moved into 9002313.0201,431 OTHER PAYER AMOUNT
        ;;; But this field is a multiple so their could be many other payer amounts......
        S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),430),U,1)=BPS("X")
        ;;;;;;
        Q
        ;
SET472  ; 472-6E Other Payer Reject Code
        ; .01 field in the 9002313.401472 sub-file
        I '$G(BPSOPIEN)!'$G(BPSORIEN) Q
        S $P(^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,2,BPSORIEN,0),U,1)=BPS("X")
        S ^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,2,"B",BPS("X"),BPSORIEN)=""
        S ^BPSC(BPS(9002313.02),400,BPS(9002313.0201),337,BPSOPIEN,2,0)="^9002313.401472A^"_BPSORIEN_U_BPSORIEN
        Q
        ;
