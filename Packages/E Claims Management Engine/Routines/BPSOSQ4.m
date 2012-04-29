BPSOSQ4 ;BHAM ISC/FCS/DRS/DLF - Process responses ;06/01/2004
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ; This routine has two components
 ;   Procedures to report Response info
 ;   Procedures to handle insurer asleep functions
 Q
 ;
 ; The following are separate little utilities called from elsewhere.
 ;
PAID(IEN59) ;quick query to see if it's paid
 N TMP D RESPINFO(IEN59,.TMP) Q:'$D(TMP("RSP")) 0
 N X S X=TMP("RSP")
 I X="Payable" Q 1
 Q 0
RESPINFO(RXI,DST) ;EP - BPSOS6M
 ; quick way to get all the response info for a given RXI
 ; IMPORTANT!!  Do not change spelling, case, wording, or spacing!!!
 ; If a reversal was attempted, it complicates things.
 ;  fills DST array as follows:
 ; DST("HDR")=Response Status (header)
 ; DST("RSP")=Response Status (prescription)
 ;   This could be:  "Payable"  "Rejected"  "Captured"  "Duplicate"
 ;   or  "Accepted reversal"  or  "Rejected reversal"
 ;   or  "null"   or "null reversal"  (no response or corrupt response
 ;    or maybe someone without insurance, so no request was sent)
 ; DST("REJ",0)=count of reject codes
 ; DST("REJ",n)=each reject code
 ; DST("MSG")=message with the response
 ; All of these are defined, even if originals were '$D.
 ; The external forms are returned.
 N REVERSAL S REVERSAL=$G(^BPST(RXI,4))>0
 N RESP
 I 'REVERSAL S RESP=$P(^BPST(RXI,0),U,5)
 E  S RESP=$P(^BPST(RXI,4),U,2)
 I 'RESP Q
 N ECME S POS=$P(^BPST(RXI,0),U,9) Q:'POS
 N FMT S FMT="E"
 S DST("HDR")=$$RESP500(RESP,FMT)
 S DST("RSP")=$$RESP1000(RESP,POS,FMT)
 S DST("REJ",0)=$$REJCOUNT(RESP,POS,FMT)
 I DST("REJ",0) D
 . N I F I=1:1:DST("REJ",0) S DST("REJ",I)=$$REJCODE(RESP,POS,I,FMT)
 S DST("MSG")=$$RESPMSG(RESP,POS,FMT)
 ; Dealing with oddities of PCS (and others'?) response to reversals
 I REVERSAL,DST("RSP")["null" D
 . I DST("RSP")["null" S DST("RSP")=DST("HDR")_" reversal"
 Q
 ; In the following quickies:
 ; RESP = RESPIEN, pointer to 9002313.03
 ; FMT = "I" for internal, "E" for external, defaults to internal
RESP500(RESP,FMT) ;EP - BPSOS57,BPSOSUC
 ; returns the response header status
 N X S X=$P($G(^BPSR(RESP,500)),U)
 I $G(FMT)'="E" Q X
 I X="" S X="null"
 S X=$S(X="A":"Accepted",X="R":"Rejected",1:"?"_X)
 Q X
RESP1000(RESP,POS,FMT) ;EP - BPSOSUC
 ; returns the prescription response status
 ; Note!  Could be DP or DC for duplicates
 N X S X=$P($G(^BPSR(RESP,1000,POS,500)),U)
 I $G(FMT)'="E" Q X
 I X="" S X="null"
 ;
 ;IHS/SD/lwj 10/07/02 NCPDP 5.1 changes - they will send an "A" back
 ; now on the transaction level to indicate that it has been accepted
 ; Next code line remarked out - following added
 ;
 S X=$S(X="A":"Accepted",X="P":"Payable",X="R":"Rejected",X="C":"Captured",X="D"!(X="DP")!(X="DC"):"Duplicate",1:"?"_X)
 Q X
 ;
REJCOUNT(RESP,POS,FMT) ; returns rejection count
 Q +$P($G(^BPSR(RESP,1000,POS,511,0)),U,3)
 ;
REJCODE(RESP,POS,N,FMT) ; returns Nth rejection code
 ; if FMT="E", returns code:text
 N CODE S CODE=$P($G(^BPSR(RESP,1000,POS,511,N,0)),U)
 I CODE="" S CODE="null"
 I FMT'="E" Q CODE
 N X S X=$O(^BPSF(9002313.93,"B",CODE,0))
 I X]"" S CODE=CODE_":"_$P($G(^BPSF(9002313.93,X,0)),U,2)
 E  S CODE="?"_CODE
 Q CODE
 ;
 ; NCPDP 5.1 changes - message may not come back in 504.  They may
 ;  come back in 526 instead
RESPMSG(RESP,POS,FMT) ; response message - additional text from insurer
 ;
 N MSG
 S MSG=""
 S MSG=$G(^BPSR(RESP,504))
 S:MSG="" MSG=$G(^BPSR(RESP,1000,POS,504))
 S:MSG="" MSG=$G(^BPSR(RESP,1000,POS,526))
 Q MSG
 ;
 ;
NOW() N %,%H,%I,X D NOW^%DTC Q %
 ;
 ; The xxxSLEEP functions are called from BPSOSQL
 ;
 ; REJSLEEP - Check if the insurer should be asleep
 ;   based on the reject codes
 ; Input
 ;   RESP - BPS Response IEN
 ;   POS  - Multiple IEN
 ; Return
 ;   1 if the insurer is asleep
 ;   0 if the insurer is not asleep
REJSLEEP(RESP,POS) ;EP - BPSOSQL
 ;
 ; DMB - Asleep functionality is disabled for VA until an analysis of reject
 ;   codes can be done and asleep code needs to handle a stranded prober.
 Q 0
 ;
 ; Validate parameters
 I '$G(RESP) Q 0
 I '$G(POS) Q 0
 ;
 ; This is basically old IHS logic
 I $G(^BPSR(RESP,1000,POS,504))?1"EV16-".E Q 1
 I $G(^BPSR(RESP,1000,POS,504))?1"EV38-".E Q 1
 I $G(^BPSR(RESP,1000,POS,504))?1"EV32-".E Q 1
 I $G(^BPSR(RESP,1000,POS,504))?1"EV25-".E Q 1 ; BPS*1.0T7*4
 ;
 ; NDC's, and theoretically, Envoy too, though they seem to do EV- msgs
 I $O(^BPSR(RESP,1000,POS,511,"B",90))="" Q 0 ; cheap check
 ;
 ; But for a PCS case we see, Code 99 + some code < 90 ; BPS*1.0T7*2
 ; isn't "asleep" - 99 is something PCS threw in       ; BPS*1.0T7*2
 ; so require 99 to be accompanied by something <99 too ; BPS*1.0T7*2
 ;
 N RET S RET=0 N I F I=92,93,99 D  Q:RET
 . I $D(^BPSR(RESP,1000,POS,511,"B",I)) S RET=1
 . Q:I'=99  Q:'RET  ; BPS*1.0T7*2
 . I I=99,$O(^BPSR(RESP,1000,POS,511,"B",0))<90 S RET=0 ; BPS*1.0T7*2
 Q RET
 ;
 ; INCSLEEP - Increment sleep time for this insurer, if necessary.
 ; Input
 ;   IEN59 - BPS Transaction IEN
 ;   PAYSH - Payer Sheet IEN
 ; Return the scheduled retry time
INCSLEEP(IEN59,PAYSH) ;EP - BPSOSQL
 ;
 ; Set retry time to be 10 minutes in the future
 N X,RETRY
 S X=600,RETRY=$$TADDNOWS^BPSOSUD(X)
 ;
 ; Set retry time to be 10 minutes
 S $P(^BPSF(9002313.92,PAYSH,1),U,12)=RETRY
 S $P(^BPST(IEN59,8),U,1)=RETRY
 S $P(^BPST(IEN59,8),U,3)=PAYSH
 ;
 ; Fire up a packet process 10 seconds after the RETRY time so that the
 ;   claims can be processed as soon as the retry time expires
 D TASKAT^BPSOSQA($$TADDNOWS^BPSOSUD(X+10))
 ;
 ; And run packeter right now, too, to stamp new times on the others in status 31
 D TASK^BPSOSQA
 Q RETRY
 ;
 ; Clear insurer sleeping condition
CLRSLEEP(IEN59,PAYSH) ;EP - BPSOSQL
 N RETRY
 ;
 ; Reset Retry Time and Prober Flga
 I $D(^BPST(IEN59,8)) S $P(^BPST(IEN59,8),U,1)="",$P(^BPST(IEN59,8),U,3)=""
 ;
 ; Get retry time from the payer sheet and quit if does not exist
 S RETRY=$P($G(^BPSF(9002313.92,PAYSH,1)),U,12)
 ;
 ; Reset Retry Time and Prober
 S $P(^BPSF(9002313.92,PAYSH,1),U,11)=""
 S $P(^BPSF(9002313.92,PAYSH,1),U,12)=""
 ;
 ; If this insurer was asleep and there are other asleep transactions, fire off
 ; the Packeter task to see if they should be done
 I RETRY,$D(^BPST("AD",31)) D TASK^BPSOSQA
 Q
