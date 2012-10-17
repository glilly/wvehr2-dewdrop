BPSOSRX4        ;ALB/SS - ECME REQUESTS ;04-JAN-08
        ;;1.0;E CLAIMS MGMT ENGINE;**7,8**;JUN 2004;Build 29
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;restore MOREDATA from the file 9002313.77
READMORE(BPIEN77,MOREDATA)      ;
        N BPIEN772,BPCOB,BPIEN78,BPACTTYP,BPDURCNT,BPPAYSEQ
        N BPY S BPY=""
        ;S MOREDATA=0
        S MOREDATA("USER")=$P($G(^BPS(9002313.77,BPIEN77,6)),U,2) ;6.02
        S BPPAYSEQ=$P($G(^BPS(9002313.77,BPIEN77,0)),U,3)
        S BPPAYSEQ=$S(BPPAYSEQ:BPPAYSEQ,1:1)
        S MOREDATA("PAYER SEQUENCE")=BPPAYSEQ
        S MOREDATA("RX ACTION")=$P($G(^BPS(9002313.77,BPIEN77,1)),U,1) ;1.01
        S BPACTTYP=MOREDATA("RX ACTION")
        S MOREDATA("ELIG")=$P($G(^BPS(9002313.77,BPIEN77,1)),U,6) ;1.06
        S $P(MOREDATA("BILL"),U,1)=$P($G(^BPS(9002313.77,BPIEN77,1)),U,5) ;1,05
        S $P(MOREDATA("BILL"),U,2)=$P($G(^BPS(9002313.77,BPIEN77,1)),U,7) ;1,07
        S $P(MOREDATA("BILL"),U,3)=$P($G(^BPS(9002313.77,BPIEN77,1)),U,6) ;1,06
        ;S MOREDATA("BILL")=$P($G(^BPS(9002313.77,BPIEN77,1)),U,5)_U_$P($G(^BPS(9002313.77,BPIEN77,1)),U,7)_U_$P($G(^BPS(9002313.77,BPIEN77,1)),U,6) ;1,05^1.07^1.06
        S MOREDATA("DATE OF SERVICE")=$P($G(^BPS(9002313.77,BPIEN77,2)),U,1) ;2.01
        S MOREDATA("REVERSAL REASON")=$P($G(^BPS(9002313.77,BPIEN77,2)),U,2) ;2.02
        S $P(MOREDATA("BPSDATA",1),U,1)=$P($G(^BPS(9002313.77,BPIEN77,4)),U,1) ;4.01
        S $P(MOREDATA("BPSDATA",1),U,2)=$P($G(^BPS(9002313.77,BPIEN77,4)),U,2) ;4.02
        S $P(MOREDATA("BPSDATA",1),U,3)=$P($G(^BPS(9002313.77,BPIEN77,4)),U,3) ;4.03
        S $P(MOREDATA("BPSDATA",1),U,4)=$P($G(^BPS(9002313.77,BPIEN77,4)),U,4) ;4.04
        S $P(MOREDATA("BPSDATA",1),U,5)=$P($G(^BPS(9002313.77,BPIEN77,4)),U,5) ;4.05
        S $P(MOREDATA("BPSDATA",1),U,6)=$P($G(^BPS(9002313.77,BPIEN77,4)),U,6) ;4.06
        S $P(MOREDATA("BPSDATA",1),U,7)=$P($G(^BPS(9002313.77,BPIEN77,4)),U,7) ;4.07
        I $L($P($G(^BPS(9002313.77,BPIEN77,2)),U,5))>0 S MOREDATA("BPSCLARF")=$$GET1^DIQ(9002313.77,BPIEN77_",",2.05,"E") ; clarification code
        ;DUR override codes Reason for Service Code, Professional Service Code, Result of Service Code
        ;
        S MOREDATA("RTYPE")=$P($G(^BPS(9002313.77,BPIEN77,1)),U,8)
        I BPPAYSEQ=2 D
        . S MOREDATA("PRIMARY BILL")=$P($G(^BPS(9002313.77,BPIEN77,1)),U,9)
        . S MOREDATA("PRIOR PAYMENT")=$P($G(^BPS(9002313.77,BPIEN77,1)),U,10)
        . S MOREDATA("337-4C")=$P($G(^BPS(9002313.77,BPIEN77,1)),U,11)        ;1.11 cob other payments count
        . S MOREDATA("308-C8")=$P($G(^BPS(9002313.77,BPIEN77,1)),U,12)        ;1.12 other coverage code
        . ;
        . ; build COB data array - esg - 6/10/10
        . N COBPIEN,APDIEN,REJIEN
        . K MOREDATA("OTHER PAYER")
        . S COBPIEN=0 F  S COBPIEN=$O(^BPS(9002313.77,BPIEN77,8,COBPIEN)) Q:'COBPIEN  D
        .. S MOREDATA("OTHER PAYER",COBPIEN,0)=$G(^BPS(9002313.77,BPIEN77,8,COBPIEN,0))
        .. ;
        .. ; retrieve data from other payer amount paid multiple
        .. S APDIEN=0 F  S APDIEN=$O(^BPS(9002313.77,BPIEN77,8,COBPIEN,1,APDIEN)) Q:'APDIEN  D
        ... S MOREDATA("OTHER PAYER",COBPIEN,"P",APDIEN,0)=$G(^BPS(9002313.77,BPIEN77,8,COBPIEN,1,APDIEN,0))
        ... Q
        .. ;
        .. ; retrieve data from other payer reject multiple
        .. S REJIEN=0 F  S REJIEN=$O(^BPS(9002313.77,BPIEN77,8,COBPIEN,2,REJIEN)) Q:'REJIEN  D
        ... S MOREDATA("OTHER PAYER",COBPIEN,"R",REJIEN,0)=$G(^BPS(9002313.77,BPIEN77,8,COBPIEN,2,REJIEN,0))
        ... Q
        .. Q
        . Q
        ;
        S BPDURCNT=0 F  S BPDURCNT=$O(^BPS(9002313.77,BPIEN77,3,BPDURCNT)) Q:+BPDURCNT=0  D
        . S MOREDATA("DUR",BPDURCNT,0)=$G(^BPS(9002313.77,BPIEN77,3,BPDURCNT,0))
        ;
        I $L($P($G(^BPS(9002313.77,BPIEN77,2)),U,7))>0 S $P(MOREDATA("BPSAUTH"),U,1)=$P($G(^BPS(9002313.77,BPIEN77,2)),U,7) ;preauth.code
        I $L($P($G(^BPS(9002313.77,BPIEN77,2)),U,8))>0 S $P(MOREDATA("BPSAUTH"),U,2)=$P($G(^BPS(9002313.77,BPIEN77,2)),U,8) ;preauth number
        I $L($P($G(^BPS(9002313.77,BPIEN77,2)),U,4))>0 S MOREDATA("BPOVRIEN")=$P($G(^BPS(9002313.77,BPIEN77,2)),U,4) ;override code (RED option)
        S BPIEN772=0 F  S BPIEN772=$O(^BPS(9002313.77,BPIEN77,5,BPIEN772)) Q:+BPIEN772=0  D
        . S BPCOB=+$G(^BPS(9002313.77,BPIEN77,5,BPIEN772,0)) ;.01
        . S BPIEN78=+$P($G(^BPS(9002313.77,BPIEN77,5,BPIEN772,0)),U,3) ;.03
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,1)=$P($G(^BPS(9002313.78,BPIEN78,0)),U,8) ;.08
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,2)=$P($G(^BPS(9002313.78,BPIEN78,1)),U,1) ;1.01
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,3)=$P($G(^BPS(9002313.78,BPIEN78,1)),U,2) ;1.02
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,4)=$P($G(^BPS(9002313.78,BPIEN78,4)),U,1) ;4.01
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,5)=$P($G(^BPS(9002313.78,BPIEN78,1)),U,3) ;1.03
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,6)=$P($G(^BPS(9002313.78,BPIEN78,1)),U,4) ;1.04
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,7)=$P($G(^BPS(9002313.78,BPIEN78,1)),U,5) ;1.05
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,8)=$P($G(^BPS(9002313.78,BPIEN78,1)),U,6) ;1.06
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,9)=$P($G(^BPS(9002313.78,BPIEN78,1)),U,7) ;1.07
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,10)=$P($G(^BPS(9002313.78,BPIEN78,1)),U,8) ;1.08
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,11)=$P($G(^BPS(9002313.78,BPIEN78,4)),U,2) ;4.02
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,12)=$P($G(^BPS(9002313.78,BPIEN78,4)),U,3) ;4.03
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,13)=$P($G(^BPS(9002313.78,BPIEN78,2)),U,6) ;2.06
        . S $P(MOREDATA("IBDATA",BPCOB,1),U,14)=$P($G(^BPS(9002313.78,BPIEN78,0)),U,7) ;.07
        . S $P(MOREDATA("IBDATA",BPCOB,2),U,1)=$P($G(^BPS(9002313.78,BPIEN78,2)),U,1) ;2.01
        . S $P(MOREDATA("IBDATA",BPCOB,2),U,2)=$P($G(^BPS(9002313.78,BPIEN78,2)),U,2) ;2.02
        . S $P(MOREDATA("IBDATA",BPCOB,2),U,3)=$P($G(^BPS(9002313.78,BPIEN78,2)),U,3) ;2.03
        . S $P(MOREDATA("IBDATA",BPCOB,2),U,4)=$P($G(^BPS(9002313.78,BPIEN78,2)),U,4) ;2.04
        . S $P(MOREDATA("IBDATA",BPCOB,2),U,5)=$P($G(^BPS(9002313.78,BPIEN78,2)),U,5) ;2.05
        . S $P(MOREDATA("IBDATA",BPCOB,3),U,1)=$P($G(^BPS(9002313.78,BPIEN78,3)),U,1) ;3.01
        . S $P(MOREDATA("IBDATA",BPCOB,3),U,2)=$P($G(^BPS(9002313.78,BPIEN78,3)),U,2) ;3.02
        . S $P(MOREDATA("IBDATA",BPCOB,3),U,3)=$P($G(^BPS(9002313.78,BPIEN78,3)),U,3) ;3.03
        . S $P(MOREDATA("IBDATA",BPCOB,3),U,4)=$P($G(^BPS(9002313.78,BPIEN78,3)),U,4) ;3.04 eligibility
        . S $P(MOREDATA("IBDATA",BPCOB,3),U,5)=$P($G(^BPS(9002313.78,BPIEN78,3)),U,5) ;3.05 insurance ien
        . S $P(MOREDATA("IBDATA",BPCOB,3),U,6)=$P($G(^BPS(9002313.78,BPIEN78,3)),U,6) ;3.06 COB
        Q
        ;
        ;change Process flag to "COMPLETED"
COMPLETD(BPIEN77)       ;
        Q $$CHNGPRFL^BPSOSRX6(BPIEN77,3)
        ;
        ;inactivate BPS REQUEST
INACTIVE(BPIEN77)       ;
        Q $$CHNGPRFL^BPSOSRX6(BPIEN77,5)
        ;activate the request - change Process flag to "ACTIVATED"
ACTIVATE(BPIEN77)       ;
        ;do we need to check what was the status of previous one - if it was rejected then we shouldn't activate it?
        Q $$CHNGPRFL^BPSOSRX6(BPIEN77,1)
        ;
        ;change Process flag to "IN PROCESS"
INPROCES(BPIEN77)       ;
        Q $$CHNGPRFL^BPSOSRX6(BPIEN77,2)
        ;
        ;delete BPS REQUEST record
DELREQST(BPIEN77)       ;
        N BPCOB
        N DIK,DA
        I $$INACTIVE(BPIEN77)
        ;Q
        S BPCOB=0
        F  S BPCOB=$O(^BPS(9002313.77,BPIEN77,5,BPCOB)) Q:+BPCOB=0  D
        . S DIK="^BPS(9002313.78,"
        . S DA=+$P($G(^BPS(9002313.77,BPIEN77,5,BPCOB,0)),U,3)
        . D ^DIK
        ;
        S DIK="^BPS(9002313.77,"
        S DA=BPIEN77
        D ^DIK
        Q
        ;
        ;update fields in BPS REQUEST and BPS TRANSACTION
UPD7759(BP77,IEN59)     ;
        N BPTYPE,BPSTIME,BPCOB,BPZ
        I +$G(BP77)=0!(+$G(IEN59)=0) Q
        D LOG^BPSOSL(IEN59,$T(+0)_"-Populating fields in BPS Transaction "_IEN59_" and request "_BP77)
        I $$FILLFLDS^BPSUTIL2(9002313.59,"16",IEN59,BP77)<1 D LOG^BPSOSL(IEN59,$T(+0)_"-Cannot populate (#16) of (#9002313.59)")
        S BPSTIME=+$P($G(^BPS(9002313.77,BP77,6)),U,1) I $$FILLFLDS^BPSUTIL2(9002313.59,"17",IEN59,BPSTIME)<1 D LOG^BPSOSL(IEN59,$T(+0)_"-Cannot populate (#17) of (#9002313.59)")
        S BPCOB=+$P($G(^BPS(9002313.77,BP77,0)),U,3) I $$FILLFLDS^BPSUTIL2(9002313.59,"18",IEN59,$S(BPCOB=0:1,1:BPCOB))<1 D LOG^BPSOSL(IEN59,$T(+0)_"-Cannot populate (#18) of (#9002313.59)")
        I $$FILLFLDS^BPSUTIL2(9002313.77,".06",BP77,IEN59)<1 D LOG^BPSOSL(IEN59,$T(+0)_"-Cannot populate (#.06) of (#9002313.77)")
        S BPZ=$$UPUSRTIM^BPSOSRX6(BP77,$S($G(DUZ):+DUZ,1:.5)) I +BPZ=0 D LOG^BPSOSL(IEN59,$T(+0)_$P(BPZ,U,2))
        S BPTYPE=$P($G(^BPS(9002313.77,BP77,1)),U,4)
        I BPTYPE="C"!(BPTYPE="U") D  Q
        . I $$FILLFLDS^BPSUTIL2(9002313.59,"19",IEN59,BPTYPE)<1 D LOG^BPSOSL(IEN59,$T(+0)_"-Cannot populate (#19) of (#9002313.59)")
        . I $$FILLFLDS^BPSUTIL2(9002313.59,"7",IEN59,+$$NOW^BPSOSRX())<1 D LOG^BPSOSL(IEN59,$T(+0)_"-Cannot populate (#7) of (#9002313.59)")
        . I BPTYPE="C" Q
        . ;if UNCLAIM (reversal)
        . I $$FILLFLDS^BPSUTIL2(9002313.59,"405",IEN59,BP77)<1 D LOG^BPSOSL(IEN59,$T(+0)_"-Cannot populate (#405) of (#9002313.59)")
        . I $$FILLFLDS^BPSUTIL2(9002313.59,"406",IEN59,BPSTIME)<1 D LOG^BPSOSL(IEN59,$T(+0)_"-Cannot populate (#406) of (#9002313.59)")
        ; verify and populate the field (#.06) of BPS REQUEST with the BPS TRANSACTION ien
        D LOG^BPSOSL(IEN59,$T(+0)_"-Unknown Transaction Type")
        Q
        ;
