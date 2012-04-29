BPSOSQF ;BHAM ISC/FCS/DRS/FLS - Insurer asleep - status 31 ;06/01/2004
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 Q
 ;
 ; Check for insurer asleep claims
 ;
STATUS31 ;EP - BPSOSQ2
 ; Situation:  you have 1 or 2 or maybe 200 claims in status 31,
 ; because we've determined that the insurer is asleep.
 ; change at most one claim per insurer to status 30, to let it
 ; go through and try again.  But if the insurer is awake for sure,
 ; let all of the claims for that insurer go on through.
 ;
 ; Initialization
 N RETRY,PROBER,IEN59,PAYERSH,X
 S IEN59=""
 K ^TMP("BPSOSQF",$J) ; build ^TMP("BPSOSQF",$J,PAYERSH,IEN59)=""
 ;
 ; Make sure we can get the lock
 I '$$LOCK59^BPSOSQ2(31) Q
 ;
 ; Loop through transaction that are 31 per cent
 F  S IEN59=$$NEXT59^BPSOSQ2(IEN59,31) Q:'IEN59  D
 . ; if $$NEXT59() returned us an IEN59, then the waiting time
 . ; has expired - or better yet, the insurer has awakened
 . ;
 . ; Get the payer sheet for the transaction
 . S PAYERSH=$$PAYERSH(IEN59)
 . I PAYERSH="" D LOG^BPSOSL(IEN59,$T(+0)_"-No payersheet was found") Q
 . ;
 . ; Get Retry Time and Prober
 . S X=$G(^BPSF(9002313.92,PAYERSH,1))
 . S RETRY=$P(X,U,12),PROBER=$P(X,U,11)
 . ;
 . ; If still in wait, but wait expired, just allow one claim thru.
 . ; But if wait has been canceled - that is, we had a successful
 . ; transmit, meaning the insurer has awakened - then let them all
 . ; go through to status 30.
 . ; if somehow the prober became complete, without clearing 101;6
 . ; (maybe this happens if cancellation takes place?)
 . I PROBER D
 .. S X=$P($G(^BPST(PROBER,0)),U,2)
 .. I X=99!(X="") S PROBER=""
 . I RETRY,PROBER,PROBER'=IEN59 Q  ; only prober can go thru during wait
 . ;
 . ; Don't we need to compare RETRY time to the current time?
 . I RETRY S $P(^BPSF(9002313.92,PAYERSH,1),U,11)=IEN59,PROBER=IEN59
 . S ^TMP("BPSOSQF",$J,PAYERSH,IEN59)=""
 D UNLOCK59^BPSOSQ2(31)
 ;
 ; Loop through payer sheet and transactions and change status to 30%
 S PAYERSH="" F  S PAYERSH=$O(^TMP("BPSOSQF",$J,PAYERSH)) Q:'PAYERSH  D
 . S IEN59="" F  S IEN59=$O(^TMP("BPSOSQF",$J,PAYERSH,IEN59)) Q:'IEN59  D
 . . D SETSTAT^BPSOSU(IEN59,30) ; reset to status 30
 . . D LOG^BPSOSL(IEN59,$T(+0)_"-Retrying Asleep Claim.  Prober? "_$S(PROBER=IEN59:"YES",1:"NO"))
 Q
 ;
 ; Function to get the payer sheet for a given transaction
PAYERSH(IEN59) ;
 N POS
 S POS=$P($G(^BPST(IEN59,9)),U,1)
 I POS="" Q ""
 Q $$GET1^DIQ(9002313.59902,POS_","_IEN59_",",902.02,"I")
