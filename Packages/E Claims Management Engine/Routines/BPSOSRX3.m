BPSOSRX3        ;ALB/SS - ECME REQUESTS ;02-JAN-08
        ;;1.0;E CLAIMS MGMT ENGINE;**7,8**;JUN 2004;Build 29
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;Input
        ;BPREQTYP - request type:
        ; "C" - Submit a claim to ECME
        ;  If the claim has already been processed, and it's  resubmitted, then a reversal will be
        ;   done first,  and then the resubmit. Intervening cal ;  to $$STATUS may show progress 
        ;  of the reversal before  the resubmitted claim is processed.
        ; "U"- Reverse submitted claim.
        ;  The reversal will actually be done ONLY if the  most recent processing of the claim
        ;   resulted in something reversible, namely E PAYABLE or E REVERSAL REJECTED
        ;RXI - Prescription IEN
        ;RXR - Fill Number
        ;MOREDATA - Array of data for transaction/claim
        ;BPCOBIND - payer sequence
        ;BILLNDC - NDC passed into EN^BPSNCPDP sent in BILLNDC variable or determined by EN^BPSNCPDP if it was null 
        ;at the very first time when EN^BPSNCPDP was called in "F" (foreground) mode
        ;BPSKIP(optional)=1 : skip the field, used when CLAIM request is created while the previous 
        ;request is in progress. That means - billing determination will be done upon activation)
        ;Return values:
        ; 1^BPS REQUEST ien = accepted for processing
        ; 0^reason = failure (should never happen)
MKRQST(BPREQTYP,RXI,RXR,MOREDATA,BPIENS78,BPCOBIND,BILLNDC,BPSKIP)      ;
        N BPIEN77,BPCOB,BPQ,BPIEN772,BPERRMSG,BPIEN59,BPIEN78,BPZ
        N RETVAL,STAT,TYPE,RESULT,SUBMITDT,BPNOW,BPACTTYP,BP77LCK
        N DUR,BPIEN771,BPCNT,BPSDUPL
        S BPSKIP=+$G(BPSKIP)
        I '$G(RXI) Q "0^Parameter error"
        I '$G(RXR) S RXR=0
        S BPIEN59=+$$IEN59^BPSOSRX(RXI,RXR,BPCOBIND)
        ; cannot be processed simultaneously
        ;new record
        S BPERRMSG="Cannot create record in BPS REQUEST"
        S BPIEN77=$$INSITEM^BPSUTIL2(9002313.77,"",RXI,"","","^BPS(9002313.77)",10) ;RX ien
        I BPIEN77<1 Q "0^"_BPERRMSG
        S BPNOW=$$NOW^BPSOSRX()
        S BPACTTYP=$G(MOREDATA("RX ACTION"))
        ; fill out the fields
        S BPERRMSG="Missing data for the "
        I $$FILLFLDS^BPSUTIL2(9002313.77,".02",BPIEN77,RXR)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,.02)
        I $$FILLFLDS^BPSUTIL2(9002313.77,".03",BPIEN77,BPCOBIND)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,.03)
        ;set delay with the testing tool
        S BPZ=+$$SETDELAY^BPSTEST(BPIEN59) I BPZ>0 I $$FILLFLDS^BPSUTIL2(9002313.77,".08",BPIEN77,BPZ)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,.08)
        ;set the process flag to "WAITING"
        I $$FILLFLDS^BPSUTIL2(9002313.77,".04",BPIEN77,0)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,.04)
        I $$FILLFLDS^BPSUTIL2(9002313.77,"6.01",BPIEN77,BPNOW)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,6.01)
        I $$FILLFLDS^BPSUTIL2(9002313.77,"6.05",BPIEN77,BPNOW)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,6.05)
        I $$ACTFIELD(BPSKIP,BPREQTYP,"6.02") I $$FILLFLDS^BPSUTIL2(9002313.77,"6.02",BPIEN77,+$G(MOREDATA("USER")))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,6.02)
        I $$FILLFLDS^BPSUTIL2(9002313.77,"6.06",BPIEN77,+DUZ)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,6.06)
        I $$ACTFIELD(BPSKIP,BPREQTYP,"1.01") I $$FILLFLDS^BPSUTIL2(9002313.77,"1.01",BPIEN77,$G(MOREDATA("RX ACTION")))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.01)
        I BPREQTYP="C" I $$FILLFLDS^BPSUTIL2(9002313.77,"1.04",BPIEN77,"C")<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.04)
        I BPREQTYP="U" I $$FILLFLDS^BPSUTIL2(9002313.77,"1.04",BPIEN77,"U")<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.04)
        ;if this is a queued "C" request then the billing will be done again upon activation so MOREDATA(BILL) is undefined
        ;that is why we are not checking this field
        I $$ACTFIELD(BPSKIP,BPREQTYP,"1.05") I $$FILLFLDS^BPSUTIL2(9002313.77,"1.05",BPIEN77,$P($G(MOREDATA("BILL")),U))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.05)
        I '$D(MOREDATA("ELIG")) I $$ACTFIELD(BPSKIP,BPREQTYP,"1.06") I $$FILLFLDS^BPSUTIL2(9002313.77,"1.06",BPIEN77,$P($G(MOREDATA("BILL")),U,3))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.06)
        I $D(MOREDATA("ELIG")) I $$ACTFIELD(BPSKIP,BPREQTYP,"1.06") I $$FILLFLDS^BPSUTIL2(9002313.77,"1.06",BPIEN77,$G(MOREDATA("ELIG")))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.06)
        I $P($G(MOREDATA("BILL")),U,2)'="" I $$ACTFIELD(BPSKIP,BPREQTYP,"1.07") I $$FILLFLDS^BPSUTIL2(9002313.77,"1.07",BPIEN77,$P($G(MOREDATA("BILL")),U,2))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.07)
        I $$ACTFIELD(BPSKIP,BPREQTYP,"2.01") I $$FILLFLDS^BPSUTIL2(9002313.77,"2.01",BPIEN77,+$G(MOREDATA("DATE OF SERVICE")))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,2.01)
        I $$ACTFIELD(BPSKIP,BPREQTYP,"2.02") I $$FILLFLDS^BPSUTIL2(9002313.77,"2.02",BPIEN77,$G(MOREDATA("REVERSAL REASON")))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,2.02)
        I $L($G(MOREDATA("BPOVRIEN")))>0 I $$FILLFLDS^BPSUTIL2(9002313.77,"2.04",BPIEN77,$G(MOREDATA("BPOVRIEN")))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,2.04)
        I $L($G(MOREDATA("BPSCLARF")))>0 I $$FILLFLDS^BPSUTIL2(9002313.77,"2.05",BPIEN77,$G(MOREDATA("BPSCLARF")))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,2.05)
        I $L($G(BILLNDC))>0 I $$FILLFLDS^BPSUTIL2(9002313.77,"2.06",BPIEN77,BILLNDC)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,2.06)
        I $L($P($G(MOREDATA("BPSAUTH")),U))>0 I $$FILLFLDS^BPSUTIL2(9002313.77,"2.07",BPIEN77,$E($P(MOREDATA("BPSAUTH"),U,1),1,2))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,2.07)
        I $L($P($G(MOREDATA("BPSAUTH")),U,2))>0 I $$FILLFLDS^BPSUTIL2(9002313.77,"2.08",BPIEN77,$E($P(MOREDATA("BPSAUTH"),U,2),1,11))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,2.08)
        I $$ACTFIELD(BPSKIP,BPREQTYP,"4.01") I $$FILLFLDS^BPSUTIL2(9002313.77,"4.01",BPIEN77,$P($G(MOREDATA("BPSDATA",1)),U,1))
        I $$ACTFIELD(BPSKIP,BPREQTYP,"4.02") I $$FILLFLDS^BPSUTIL2(9002313.77,"4.02",BPIEN77,$P($G(MOREDATA("BPSDATA",1)),U,2))
        I $$ACTFIELD(BPSKIP,BPREQTYP,"4.03") I $$FILLFLDS^BPSUTIL2(9002313.77,"4.03",BPIEN77,$P($G(MOREDATA("BPSDATA",1)),U,3))
        I $$ACTFIELD(BPSKIP,BPREQTYP,"4.04") I $$FILLFLDS^BPSUTIL2(9002313.77,"4.04",BPIEN77,$P($G(MOREDATA("BPSDATA",1)),U,4))
        I $P($G(MOREDATA("BPSDATA",1)),U,5)'="" I $$ACTFIELD(BPSKIP,BPREQTYP,"4.05") I $$FILLFLDS^BPSUTIL2(9002313.77,"4.05",BPIEN77,$P($G(MOREDATA("BPSDATA",1)),U,5))
        I $P($G(MOREDATA("BPSDATA",1)),U,6)'="" I $$ACTFIELD(BPSKIP,BPREQTYP,"4.06") I $$FILLFLDS^BPSUTIL2(9002313.77,"4.06",BPIEN77,$P($G(MOREDATA("BPSDATA",1)),U,6))
        I $$ACTFIELD(BPSKIP,BPREQTYP,"4.07") I $$FILLFLDS^BPSUTIL2(9002313.77,"4.07",BPIEN77,$P($G(MOREDATA("BPSDATA",1)),U,7))
        I $G(MOREDATA("CLOSE AFT REV"))=1 I $$FILLFLDS^BPSUTIL2(9002313.77,"7.01",BPIEN77,1)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,7.01)
        I $G(MOREDATA("CLOSE AFT REV REASON"))>0 I $$FILLFLDS^BPSUTIL2(9002313.77,"7.02",BPIEN77,+$G(MOREDATA("CLOSE AFT REV REASON")))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,7.02)
        I $L($G(MOREDATA("CLOSE AFT REV COMMENT")))>0 I $$FILLFLDS^BPSUTIL2(9002313.77,"7.03",BPIEN77,$G(MOREDATA("CLOSE AFT REV COMMENT")))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,7.03)
        I $G(BPSARRY("SC/EI OVR"))=1 I $$FILLFLDS^BPSUTIL2(9002313.77,"2.09",BPIEN77,1)<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,2.09)
        ;
        ; secondary billing and primary Tricare billing related fields
        I $G(MOREDATA("RTYPE"))'="" I $$FILLFLDS^BPSUTIL2(9002313.77,"1.08",BPIEN77,MOREDATA("RTYPE"))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.08)
        I $G(MOREDATA("PRIMARY BILL"))'="" I $$FILLFLDS^BPSUTIL2(9002313.77,"1.09",BPIEN77,MOREDATA("PRIMARY BILL"))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.09)
        I $G(MOREDATA("PRIOR PAYMENT"))'="" I $$FILLFLDS^BPSUTIL2(9002313.77,"1.1",BPIEN77,MOREDATA("PRIOR PAYMENT"))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.1)
        I $G(MOREDATA("337-4C"))'="" I $$FILLFLDS^BPSUTIL2(9002313.77,1.11,BPIEN77,MOREDATA("337-4C"))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.11)   ; cob other payments count
        I $G(MOREDATA("308-C8"))'="" I $$FILLFLDS^BPSUTIL2(9002313.77,1.12,BPIEN77,MOREDATA("308-C8"))<1 Q "0^"_$$ERRFIELD(BPIEN77,1,BPERRMSG,9002313.77,1.12)   ; other coverage code
        ;
        ; store secondary billing related data entered by the user - esg 6/8/10
        S BPQ=0,BPERRMSG=""
        I BPCOBIND=2 D
        . N AMTIEN,BPIEN1,BPIEN2,BPIEN778,BPZ,BPZ1,BPZ2,OPAMT,OPAPQ,OPAYD,OPREJ,PIEN,REJIEN
        . S PIEN=0 F  S PIEN=$O(MOREDATA("OTHER PAYER",PIEN)) Q:'PIEN!BPQ  D
        .. S OPAYD=$G(MOREDATA("OTHER PAYER",PIEN,0)) Q:OPAYD=""
        .. ;
        .. ; count up the number of multiples we have in each set
        .. S BPZ=0 F BPZ1=0:1 S BPZ=$O(MOREDATA("OTHER PAYER",PIEN,"P",BPZ)) Q:'BPZ
        .. S BPZ=0 F BPZ2=0:1 S BPZ=$O(MOREDATA("OTHER PAYER",PIEN,"R",BPZ)) Q:'BPZ
        .. I BPZ1,BPZ2 S BPQ=1,BPERRMSG="Can't have both payments and rejects for the same OTHER PAYER" Q
        .. ;
        .. ; add a new entry to subfile 9002313.778
        .. S BPIEN778=$$INSITEM^BPSUTIL2(9002313.778,BPIEN77,PIEN,PIEN,"",,0)
        .. I BPIEN778<1 S BPERRMSG="Can't create entry in COB OTHER PAYERS multiple of the BPS REQUESTS file",BPQ=1 Q
        .. S BPERRMSG="Can't populate field in COB OTHER PAYERS multiple"   ; just in case BPQ is set below
        .. ;
        .. ; set the rest of the pieces at this level
        .. I $P(OPAYD,U,2)'="" I $$FILLFLDS^BPSUTIL2(9002313.778,.02,PIEN_","_BPIEN77,$P(OPAYD,U,2))<1 S BPQ=1 Q
        .. I $P(OPAYD,U,3)'="" I $$FILLFLDS^BPSUTIL2(9002313.778,.03,PIEN_","_BPIEN77,$P(OPAYD,U,3))<1 S BPQ=1 Q
        .. I $P(OPAYD,U,4)'="" I $$FILLFLDS^BPSUTIL2(9002313.778,.04,PIEN_","_BPIEN77,$P(OPAYD,U,4))<1 S BPQ=1 Q
        .. I $P(OPAYD,U,5)'="" I $$FILLFLDS^BPSUTIL2(9002313.778,.05,PIEN_","_BPIEN77,$P(OPAYD,U,5))<1 S BPQ=1 Q
        .. I $$FILLFLDS^BPSUTIL2(9002313.778,.06,PIEN_","_BPIEN77,BPZ1)<1 S BPQ=1 Q
        .. I $$FILLFLDS^BPSUTIL2(9002313.778,.07,PIEN_","_BPIEN77,BPZ2)<1 S BPQ=1 Q
        .. S BPERRMSG=""
        .. ;
        .. ; now loop thru the other payer payment array
        .. S AMTIEN=0 F  S AMTIEN=$O(MOREDATA("OTHER PAYER",PIEN,"P",AMTIEN)) Q:'AMTIEN!BPQ  D
        ... S OPAMT=$G(MOREDATA("OTHER PAYER",PIEN,"P",AMTIEN,0))
        ... S OPAPQ=$P(OPAMT,U,2)   ; 342-HC other payer amt paid qualifier (ncpdp 5.1 blank is OK)
        ... S OPAMT=+OPAMT          ; 431-DV other payer amt paid
        ... ;
        ... ; add a new entry to subfile 9002313.7781
        ... S BPIEN1=$$INSITEM^BPSUTIL2(9002313.7781,PIEN_","_BPIEN77,OPAMT,AMTIEN,"",,0)
        ... I BPIEN1<1 S BPERRMSG="Can't create entry in 9002313.7781 subfile",BPQ=1 Q
        ... ;
        ... ; set piece 2
        ... I OPAPQ'="" I $$FILLFLDS^BPSUTIL2(9002313.7781,.02,AMTIEN_","_PIEN_","_BPIEN77,OPAPQ)<1 D
        .... S BPQ=1,BPERRMSG="Can't populate .02 field in 9002313.7781 subfile"
        .... Q
        ... Q
        .. ;
        .. ; now loop thru the other payer reject array
        .. S REJIEN=0 F  S REJIEN=$O(MOREDATA("OTHER PAYER",PIEN,"R",REJIEN)) Q:'REJIEN!BPQ  D
        ... S OPREJ=$G(MOREDATA("OTHER PAYER",PIEN,"R",REJIEN,0)) Q:OPREJ=""  Q:$P(OPREJ,U,1)=""
        ... ;
        ... ; add a new entry to subfile 9002313.7782
        ... S BPIEN2=$$INSITEM^BPSUTIL2(9002313.7782,PIEN_","_BPIEN77,$P(OPREJ,U,1),REJIEN,"",,0)
        ... I BPIEN2<1 S BPERRMSG="Can't create entry in 9002313.7782 subfile",BPQ=1 Q
        ... Q
        .. Q
        . Q
        I BPQ Q "0^"_BPERRMSG_" (COB DATA)"
        ;
        ;store DURREC info
        S BPQ=0
        S DUR=0
        F  S DUR=$O(MOREDATA("DUR",DUR)) Q:+DUR=0!(BPQ=1)  D
        . S BPIEN771=$$INSITEM^BPSUTIL2(9002313.771,BPIEN77,$P(MOREDATA("DUR",DUR,0),U),DUR,"",,0)
        . I BPIEN771<1 S BPERRMSG="Cannot create DUR record in DUR multiple of the BPS REQUEST file",BPQ=1 Q
        . S BPERRMSG="Cannot populate a field in DUR multiple"
        . I $$FILLFLDS^BPSUTIL2(9002313.771,".02",DUR_","_BPIEN77,$P(MOREDATA("DUR",DUR,0),U,2))<1 S BPQ=1 Q
        . I $$FILLFLDS^BPSUTIL2(9002313.771,".03",DUR_","_BPIEN77,$P(MOREDATA("DUR",DUR,0),U,3))<1 S BPQ=1 Q
        I BPQ=1 Q "0^"_BPERRMSG_" DUR DATA"
        ;
        ;store ins to IB INSURER DATA
        S BPQ=0
        S BPCOB=0 F  S BPCOB=$O(BPIENS78(BPCOB)) Q:+BPCOB=0!(BPQ=1)  D
        . S BPIEN772=$$INSITEM^BPSUTIL2(9002313.772,BPIEN77,BPCOB,BPCOB,"",,0)
        . I BPIEN772<1 S BPERRMSG="Cannot create record in IBDATA multiple of the BPS REQUEST file",BPQ=1 Q
        . S BPERRMSG="Cannot populate a field in IBDATA multiple"
        . I $$FILLFLDS^BPSUTIL2(9002313.772,".02",BPCOB_","_BPIEN77,$S(BPCOBIND=BPCOB:1,1:0))<1 S BPQ=1 Q
        . I $$FILLFLDS^BPSUTIL2(9002313.772,".03",BPCOB_","_BPIEN77,BPIENS78(BPCOB))<1 S BPQ=1 Q
        I BPQ=1 Q "0^"_BPERRMSG_"INSURER DATA"
        ;
        ;return 1 (success) and IEN of the 9002313.77
        Q "1^"_BPIEN77
        ;
        ;check if the field is used in MOREDATA for the specified REQUEST TYPE - CLAIM="C" /UNCLAIM="U"
ACTFIELD(BPSKIP,BPREQTYP,BPFLD) ;
        ;if reverse
        I (BPREQTYP="U")!(BPSKIP=1) Q ";1.01;2.01;2.02;6.02;"[(";"_BPFLD_";")
        Q 1  ;if "ERES","OF","RF"
        ;
        ;Lock BPS REQUEST
LOCK77(BPTIMOUT,IEN59,BPSRC)    ;
        N BPRET
        L +^BPS(9002313.77):+$G(BPTIMOUT)
        S BPRET=$T
        I $G(IEN59)>0 D LOG^BPSOSL(IEN59,$G(BPSRC)_$S(BPRET=1:"-Lock",1:"-Failed to Lock")_" BPS REQUEST file")
        Q BPRET
        ;
        ;UnLock BPS REQUEST
UNLOCK77(IEN59,BPSRC)   ;
        L -^BPS(9002313.77)
        I $G(IEN59)>0 D LOG^BPSOSL(IEN59,$G(BPSRC)_"-Unlock BPS REQUEST file")
        Q
        ;calculate new BPS REQUEST ien
NEWIEN77(BPRX,BPRF,BPTYPE)      ;
        N BPL,BPL1,BPDT,BPTM
        S BPRX="00"_BPRX
        S BPL=$L(BPRX)
        S BPDT=$H
        S BPL1=$L(+BPDT)
        S BPTM=$P(BPDT,",",2)_"00000"
        Q +($E(+BPDT,BPL1-3,BPL1)_$E(BPTM,1,5)_"."_$S($G(BPTYPE)="U":0,1:1)_$E(BPRX,BPL-2,BPL)_BPRF)
        ;
        ;BP77 - ien of BPS REQUEST
ERRFIELD(BP77,BPRFILE,BPMESS,BPFILENO,BPFLDNO)  ;
        I $G(BP77)>0 D DELREQST^BPSOSRX4(BP77) ;delete incomplete record
        Q $$FIELDMSG^BPSOSRX2(BPRFILE,BPMESS,BPFILENO,BPFLDNO)
        ;
        ;BPSOSRX3
