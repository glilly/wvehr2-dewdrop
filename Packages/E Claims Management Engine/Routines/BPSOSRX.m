BPSOSRX ;BHAM ISC/FCS/DRS/FLS - callable from RPMS pharm ;06/01/2004
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ; There are only four callable entry points!
 ; $$CLAIM^BPSOSRX     Submit a claim to ECME
 ; $$UNCLAIM^BPSOSRX   Reverse a previously submitted claim.
 ; $$STATUS^BPSOSRX    Inquire about a claim's status
 ; SHOWQ^BPSOSRX       Display queue of claims to be processed
 Q
 ;
 ; $$CLAIM - Submit a claim to ECME
 ; Input
 ;   RXI - Prescription IEN
 ;   RXR - Fill Number
 ;   MOREDATA - Array of data needed for transaction/claim
 ; Return values:
 ;   1 = accepted for processing
 ;   0^reason = failure (should never happen)
 ;
 ; All this does is to put it on a list and start a background job.
 ;
 ; Note:  If the claim has already been processed, and it's
 ;        resubmitted, then a reversal will be done first,
 ;        and then the resubmit will be done.   Intervening calls
 ;        to $$STATUS may show progress of the reversal before
 ;        the resubmitted claim is processed.
CLAIM(RXI,RXR,MOREDATA) ;
 N RETVAL,STAT,TYPE,SUBMITDT
 I '$G(RXI) Q 0
 I '$G(RXR) S RXR=0
 I '$$LOCK("SUBMIT",5) Q 0
 S TYPE="CLAIM",SUBMITDT=$$NOW
 N X,X1,X2
 S X1=DT,X2=30 D C^%DTC
 K ^XTMP("BPS-PROC",TYPE,RXI,RXR)
 S ^XTMP("BPS-PROC",0)=X_U_DT_U_"ECME PROCESSING QUEUE"
 S ^XTMP("BPS-PROC",TYPE,RXI,RXR)=SUBMITDT
 I $D(MOREDATA) M ^XTMP("BPS-PROC",TYPE,RXI,RXR,"MOREDATA")=MOREDATA
 S ^XTMP("BPSOSRX",0)=X_U_DT_U_"ECME SUBMIT DATE FOR A RX AND FILL"
 S ^XTMP("BPSOSRX",RXI,RXR)=SUBMITDT
 D UNLOCK("SUBMIT")
 D RUNNING()
 S RETVAL=1
 Q RETVAL
 ;
 ; $$UNCLAIM - Reverse a previously submitted claim.
 ; Input
 ;   RXI - Prescription IEN
 ;   RXR - Fill Number
 ;   MOREDATA - Array of data needed for transaction/claim
 ; Return values:
 ;   1 = accepted for processing
 ;   0^reason = failure (should never happen)
 ;
 ;   All this does is to put it on a list and start a background job.
 ;
 ; Note:  The reversal will actually be done ONLY if the
 ;        most recent processing of the claim resulted in something
 ;        reversible, namely E PAYABLE or E REVERSAL REJECTED
UNCLAIM(RXI,RXR,MOREDATA) ;
 N RETVAL,STAT,RESULT,TYPE,SUBMITDT
 I '$G(RXI) Q 0
 I '$G(RXR) S RXR=0
 I '$$LOCK("SUBMIT",5) Q 0
 S TYPE="UNCLAIM",SUBMITDT=$$NOW
 N X,X1,X2
 S X1=DT,X2=30 D C^%DTC
 K ^XTMP("BPS-PROC",TYPE,RXI,RXR)
 S ^XTMP("BPS-PROC",0)=X_U_DT_U_"ECME PROCESSING QUEUE"
 S ^XTMP("BPS-PROC",TYPE,RXI,RXR)=SUBMITDT
 I $D(MOREDATA) M ^XTMP("BPS-PROC",TYPE,RXI,RXR,"MOREDATA")=MOREDATA
 S ^XTMP("BPSOSRX",0)=X_U_DT_U_"ECME SUBMIT DATE FOR A RX AND FILL"
 S ^XTMP("BPSOSRX",RXI,RXR)=SUBMITDT
 D UNLOCK("SUBMIT")
 D RUNNING()
 S RETVAL=1
 Q RETVAL
 ;
 ; $$STATUS(RXI,RXR,QUE) - Returns the Status of the prescription/fill
 ; Input
 ;   RXI - Prescription IEN (required)
 ;   RXR - Refill Number (required)
 ;   QUE:  0/null - Do not check if a RX/fill is on the queue (optional)
 ;         1 - Check if RX/fill is on the queue
 ;
 ; Returns
 ;    RESULT^LAST UPDATE DATE/TIME^DESCRIPTION^STATUS %
 ;    Returns null if there's no ECME record of this RX/fill
 ;
 ;    RESULT is either:
 ;      1. IN PROGRESS for incomplete claims
 ;      2. Final status for complete claims.  See comments for
 ;         BPSOSUC for complete list of possible statuses.
 ;    LAST UPDATE DATE/TIME is the Fileman date and time of the
 ;         last update to the status of this claim.
 ;    DESCRIPTION is either:
 ;      1. Incomplete claims will be the status (i.e., Waiting to Start,
 ;         Transmitting)
 ;      2. Completed claims will have the reason that the ECME process
 ;         was aborted if the result is  E OTHER.  Otherwise, it will
 ;         be similiar to the RESULT
 ;    STATUS % is the completion percentage.  Note that 99 is considered
 ;         complete.
STATUS(RXI,RXR,QUE) ;
 ;
 ; Setup needed variables
 N IEN59,SDT,A,SUBDT
 I '$G(RXI) Q ""
 I $G(RXR)="" Q ""
 I $G(QUE)="" S QUE=1
 S IEN59=$$IEN59(RXI,RXR)
 S SDT=$G(^XTMP("BPSOSRX",RXI,RXR))
 ;
 ; ECME record not created
 I '$D(^BPST(IEN59)) D  Q A
 . I QUE,SDT S A="IN PROGRESS"_U_SDT_U_$$STATI^BPSOSU(0)_U_-1 Q
 . I QUE,$D(^XTMP("BPS-PROC","CLAIM",RXI,RXR)) S A="IN PROGRESS"_U_SDT_U_$$STATI^BPSOSU(0)_U_-1 Q
 . S A=""
 ;
 ; Loop: Get data, quit if times and status match (no change during gather)
 N C,T1,T2,S1,S2 F  D  I T1=T2,S1=S2 Q
 . S T1=$$LASTUP59(IEN59)
 . S S1=$$STATUS59(IEN59)
 . I S1=99 D  ; completed
 . . S A=$$CATEG^BPSOSUC(IEN59)
 . . S C=$$RESTXT59(IEN59)
 . I S1'=99 D
 . . S A="IN PROGRESS"
 . . S C=$$STATI^BPSOSU(S1)
 . S T2=$$LASTUP59(IEN59)
 . S S2=$$STATUS59(IEN59)
 ;
 ; If the queue parameter is set and the submit date from the queue
 ;   follows the SUBMIT DATE/LAST UPDATE date from BPS TRANSACTION 
 ;   or the RX/fill is still on the queue, then change the response
 ;   to IN PROGRESS^Submit Date^WAITING TO START
 S SUBDT=$$SUBMIT59(IEN59)
 I SUBDT="" S SUBDT=T1
 I $G(QUE),SDT>SUBDT!($D(^XTMP("BPS-PROC","CLAIM",RXI,RXR)))!($D(^XTMP("BPS-PROC","UNCLAIM",RXI,RXR))) S A="IN PROGRESS",T1=SDT,S1=-1,C=$$STATI^BPSOSU(0)
 ;
 ; When finishing the reversal of a Reversal/Resubmit, display IN PROGRESS
 I $P($G(^BPST(IEN59,1)),"^",12)=1,S1=99 S A="IN PROGRESS",S1=98,C=$$STATI^BPSOSU(S1)
 ;
 ; Return results
 Q A_U_T1_U_$E(C,1,255-$L(A)-$L(T1)-2)_U_S1
 ;
 ; SHOWQ - Show RX/Fill on the Queue.  Since claims are generally processed
 ;   immediately, this report will generally have no output.
SHOWQ G SHOWQ^BPSOSR2
 ;
NOW() N %,%H,%I,X D NOW^%DTC Q %
 ;
 ; RESTXT59 - Return first semi-colon piece of the Result Text (202) field
 ;    from BPS Transaction
RESTXT59(IEN59) ;
 I '$G(IEN59) Q ""
 Q $P($P($G(^BPST(IEN59,2)),U,2,99),";",1)
 ;
 ; LASTUP59 - Return last update date/time from BPS Transactions
LASTUP59(IEN59) ;
 I '$G(IEN59) Q ""
 Q $P($G(^BPST(IEN59,0)),U,8)
 ;
 ; STATUS59 returns STATUS field from BPS Transaction
 ; Note: 99 means complete
STATUS59(IEN59) ;
 I '$G(IEN59) Q ""
 Q $P($G(^BPST(IEN59,0)),U,2)
 ;
 ; SUBMIT59 - Return Submit date/time from BPS Transactions
SUBMIT59(IEN59) ;
 I '$G(IEN59) Q ""
 Q $P($G(^BPST(IEN59,0)),U,7)
 ;
 ; RXRDEF - Get last refill
RXRDEF(RXI) ;
 I '$G(RXI) Q ""
 K ^TMP($J)
 N BPSPT S BPSPT=$$RXAPI1^BPSUTIL1(RXI,2,"I")
 I BPSPT="" Q ""
 D RX^PSO52API(BPSPT,"BPSREF",RXI,,"R")
 Q +$O(^TMP($J,"BPSREF",BPSPT,RXI,"RF",""),-1)
 ;
 ; Utilities
 ;
 ;  LOCKING:  Just one user of this routine at a time.
 ;  X = "SUBMIT" to interlock the claim submission
 ;  X = "BACKGROUND" to interlock the background job
LOCK(X,TIMEOUT) ;EP - BPSOSRB
 I $G(TIMEOUT)="" S TIMEOUT=0
 L +^XTMP("BPS-PROC",X):TIMEOUT
 Q $T
 ;
LOCKNOW(X) ;EP - BPSOSRB
 L +^XTMP("BPS-PROC",X):0
 Q $T
 ;
UNLOCK(X) ;EP - BPSOSRB
 L -^XTMP("BPS-PROC",X)
 Q
 ;
RUNNING() ;
 I '$$LOCKNOW("BACKGROUND") Q  ; it is running; don't start another
 D UNLOCK("BACKGROUND") ; it's not running; release our probing lock
 D TASK
 Q
 ;
IEN59(RXI,RXR) ;EP - from BPSOS, BPSOSRB
 I '$G(RXI) Q ""
 I '$G(RXR) S RXR=0
 Q RXI_"."_$TR($J(RXR,4)," ","0")_"1"
 ;
 ; The background job
TASK N X,Y,%DT
 S X="N",%DT="ST"
 D ^%DT,TASKAT(Y)
 Q
 ;
TASKAT(ZTDTH) ;
 N ZTIO S ZTIO="" ; no device
 N ZTRTN S ZTRTN="BACKGR^BPSOSRB"
 D ^%ZTLOAD
 Q
