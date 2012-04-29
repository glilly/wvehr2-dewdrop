BPSOSU ;BHAM ISC/FCS/DRS/FLS - Common utilities ;06/01/2004
 ;;1.0;E CLAIMS MGMT ENGINE;**1,2,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 Q
 ; Common utilities called a lot.
 ;
 ; SETSTAT - set status field for ^BPST(IEN59,
 ; Input:
 ;   IEN59   - BPS Transaction
 ;   STATUS  - Value to set into BPS Transaction
SETSTAT(IEN59,STATUS) ; EP - from many places
 ;
 ; In case there is a timing problem, make sure the Status is not
 ;   already more than the requested status
 I STATUS'=0,$P(^BPST(IEN59,0),U,2)>STATUS Q
 ;
 ; Lock the record - something is very wrong if you can't get the lock
 F  L +^BPST(IEN59):300 Q:$T  Q:'$$IMPOSS^BPSOSUE("L","RTI","LOCK +^BPST",,"SETSTAT",$T(+0))
 N DIE,DA,DR,X
 S DIE=9002313.59,DA=IEN59,DR="1///"_STATUS_";7///NOW" ; Status and Last Update
 I STATUS=0 S DR=DR_";15///NOW" ; If Status is 0, init START TIME
 D ^DIE
 ;
 ; Verify that there no other statuses in the X-ref
 S X=""
 F  S X=$O(^BPST("AD",X)) Q:X=""  D
 . I X'=STATUS K ^BPST("AD",X,IEN59)
 I STATUS=99 D STATUS99(IEN59)
 L -^BPST(IEN59)
 Q
 ;
 ; STATUS99 - Special activity when a claim reaches status 99
 ; Input:
 ;   IEN59 - BPS Transaction IEN
STATUS99(IEN59) ;
 N CLMSTAT,BPS57
 ;
 ; Get status of the claim
 S CLMSTAT=$$CATEG^BPSOSUC(IEN59)
 ;
 S BPS57=$$NEW57(IEN59)
 D LOG^BPSOSL(IEN59,$T(+0)_"-Created BPS Log of Transaction record "_BPS57)
 ;
 ; If claims completed normally, log its completion.
 ; Do not log error'ed or stranded claims as we don't want to show these in the
 ;   turn-around stats
 ; Needed for Turn-Around Stats - Do NOT delete/alter!!
 I CLMSTAT'["E OTHER",CLMSTAT'["E STRANDED",CLMSTAT'["E REVERSAL STRANDED" D LOG^BPSOSL(IEN59,$T(+0)_"-Claim Complete")
 ;
 ; If the Reverse Then Resubmit field is set to Resubmitting (2),
 ;   then set to 'Done' (0)
 I $P(^BPST(IEN59,1),U,12)=2 S $P(^BPST(IEN59,1),U,12)=0
 ;
 ; If resubmit flag is set to 'Reverse, then Resubmit' (1), see about
 ;   doing a resubmit
 I $P(^BPST(IEN59,1),U,12)=1 D
 . ;
 . ; Initialize variables
 . N SKIP,SITE
 . D LOG^BPSOSL(IEN59,$T(+0)_"-Reverse then Resubmit attempt")
 . ;
 . ; Initialize the skip flag
 . S SKIP=0
 . ;
 . ; Get Site info and make sure it exists
 . S SITE=$P(^BPST(IEN59,1),U,4)
 . I '$G(SITE) D
 .. D LOG^BPSOSL(IEN59,$T(+0)_" Cannot - No site information")
 .. S SKIP=1
 . ;
 . ; Check the ECME switch for the site
 . I $G(SITE),'$$ECMEON^BPSUTIL(SITE) D
 .. D LOG^BPSOSL(IEN59,$T(+0)_" Cannot - ECME switch is off for the site")
 .. S SKIP=1
 . ;
 . ; If reversal was not successful, log message and quit
 . I CLMSTAT'="E REVERSAL ACCEPTED" D
 .. D LOG^BPSOSL(IEN59,$T(+0)_" Cannot - Reversal failed - "_CLMSTAT)
 .. S SKIP=1
 . ;
 . ; Check if the MOREDATA array is defined
 . I '$D(^XTMP("BPSOSRB","MOREDATA",IEN59,"RESUB")) D
 .. D LOG^BPSOSL(IEN59,$T(+0)_" Cannot - MOREDATA array undefined")
 .. S SKIP=1
 . ;
 . ; If skip flag is set, clear the resubmit flag and kill the temp global
 . ; Else resubmit the claim
 . I SKIP D
 .. S $P(^BPST(IEN59,1),U,12)=0
 .. K ^XTMP("BPSOSRB","MOREDATA",IEN59)
 . E  D
 .. K MOREDATA
 .. M MOREDATA=^XTMP("BPSOSRB","MOREDATA",IEN59,"RESUB")
 .. K ^XTMP("BPSOSRB","MOREDATA",IEN59)
 .. ;
 .. ; Needed for Turn-Around Stats - Do NOT delete/alter!!
 .. D LOG^BPSOSL(IEN59,$T(+0)_"-Now resubmit")
 .. D CLAIM^BPSOSRB(IEN59,.MOREDATA)
 ;
 ; If the ECME Nightly Background job and CMOP release message are running at the same
 ;   time, there are unreleased RXs that are auto-reversed but then are released by
 ;   CMOP at the same time.  Unfortunately, if the auto-reversal is in progress, CMOP
 ;   can not resubmit the claim (due to the queuing issue) so we need to automatically
 ;   submit them here.
 ; Criteria:
 ;   Status is Reversal Accepted
 ;   RX is released
 ;   Normal Auto-Reversal
 I CLMSTAT="E REVERSAL ACCEPTED" D
 . N RX,RXR
 . S RX=$P(IEN59,"."),RXR=+$E($P(IEN59,".",2),1,4)
 . I '$$RXRLDT^PSOBPSUT(RX,RXR) Q
 . N CLAIMIEN,AUTOREV
 . S CLAIMIEN=$$GET1^DIQ(9002313.59,IEN59,3,"I")
 . I '$G(CLAIMIEN) Q
 . S AUTOREV=$$GET1^DIQ(9002313.02,CLAIMIEN,.07,"I")
 . I $G(AUTOREV)'=1 Q
 . N BDOS,BRES,BMES,BMSG
 . D LOG^BPSOSL(IEN59,$T(+0)_"-Submit released auto-reversal")
 . S BDOS=$$DOSDATE^BPSSCRRS(RX,RXR)
 . S BRES=$$EN^BPSNCPDP(RX,RXR,BDOS,"ARES")
 . D LOG^BPSOSL(IEN59,$T(+0)_"-Response from BPSNCPDP: "_BRES)
 . S BMSG=$P(BRES,U,2),BRES=+BRES
 . S BMES="Submitted to ECME: Resubmit for released autoreversal"
 . S BMES=BMES_$S(BRES=1:"-NO SUBMISSION VIA ECME",BRES=4:"-NOT PROCESSED",BRES=5:"-SOFTWARE ERROR",1:"")
 . D ECMEACT^PSOBPSU1(RX,RXR,BMES,.5)
 . I BRES=2 D ECMEACT^PSOBPSU1(RX,RXR,"Not ECME Billable: "_BMSG,.5)
 Q
 ;
 ; NEW57 - Copy the BPS Transaction into BPS Log of Transaction
 ;  Input
 ;    IEN59 - BPS Transaction
 ;  Returns
 ;    BPS Log of Transaction IEN
NEW57(IEN59) ;
 F  L +^BPSTL:300 Q:$T  Q:'$$IMPOSS^BPSOSUE("L","RTI","LOCK ^BPSTL",,"NEW57",$T(+0))
 ;
 ; Get next record number in BPS Log of Transactions
NEW57A N N,C
 S N=$P(^BPSTL(0),U,3)+1
 S C=$P(^BPSTL(0),U,4)+1
 S $P(^BPSTL(0),U,3,4)=N_U_C
 I $D(^BPSTL(N)) G NEW57A ; should never happen
 L -^BPSTL
 ;
 ; Merge BPS Transaction into Log of Transactions
 M ^BPSTL(N)=^BPST(IEN59)
 ;
 ; Indexing - First, fileman indexing
 D
 . N DIK,DA S DIK="^BPSTL(",DA=N N N D IX1^DIK
 ;
 ; Setup the NON-FILEMAN index on RX and Fill
 N A,B
 S A=$P(^BPSTL(N,1),U,11)
 S B=$P(^BPSTL(N,1),U)
 S ^BPSTL("NON-FILEMAN","RXIRXR",A,B,N)=""
 ;
 ; Quit with the new record number
 Q N
 ;
 ; ISREVES - Is this a reversal claim
 ; Input
 ;   CLAIMIEN - Pointer to BPS Claims
 ;
 ; Return Value
 ;   1 - Reversal claim
 ;   0 - Not a reversal claim
ISREVERS(CLAIM) ;
 Q $P($G(^BPSC(CLAIM,100)),"^",3)="B2"
 ;
 ; SETCSTAT - Set the status for every transaction associated with
 ;   this claim
SETCSTAT(CLAIM,STATUS) ;
 N IEN59,INDEX
 ;
 ; Determine correct index
 I $$ISREVERS(CLAIM) S INDEX="AER"
 E  S INDEX="AE"
 ;
 ; Loop through the transactions and set the status
 S IEN59=""
 F  S IEN59=$O(^BPST(INDEX,CLAIM,IEN59)) Q:IEN59=""  D SETSTAT(IEN59,STATUS)
 Q
 ;
 ; ERROR - Handle any errors
 ;   Log them into BPS Transactions
 ;   Change status to 99
 ;   Update the LOG
 ;   Increment the statistics
 ;   We should be okay for the resubmit flag since the STATUS
 ;     will be E OTHER instead of E REVERSAL ACCEPTED
 ; Input
 ;   RTN     - Routine reporting the error
 ;   IEN59   - BPS Transaction
 ;   ERROR   - Error Number (goes in RESULT CODE)
 ;   ERRTEXT - Error Text (goes in RESULT TEXT)
 ;
 ; To prevent conflicts, set the error number to the first digit of
 ;   Status and a unique number for the status.
ERROR(RTN,IEN59,ERROR,ERRTEXT) ;
 ;
 ; Check parameters
 I '$G(IEN59) Q
 I '$G(ERROR) S ERROR=0
 I $G(ERRTEXT)="" S ERRTEXT="ERROR - see LOG"
 ;
 ; Set Error and Error Text in BPS Transaction
 D SETRESU(IEN59,ERROR,ERRTEXT)
 ;
 ; Log Message
 D LOG^BPSOSL(IEN59,RTN_" returned error - "_ERRTEXT)
 ;
 ; Update unbillable count in stats
 D INCSTAT^BPSOSUD("R",1)
 ;
 ; Update Status to complete
 D SETSTAT(IEN59,99)
 Q
 ;
 ; SETRESU - Set Result into ^BPST(IEN59,2)
 ; Input
 ;   IEN59 - BPS Transaction IEN
 ;   RESULT - Result Code
 ;   TEXT   - Result Text.  Semi-colons (";") should not in the text data as
 ;            this is used as a separator between current and previous text
 ;            messages.  If there is a semi-colon, it is converted to a dash.
SETRESU(IEN59,RESULT,TEXT) ;
 ;
 ; First, store the Result Code
 S $P(^BPST(IEN59,2),U)=$G(RESULT)
 ;
 ; Second, store the Result Text
 ; Considerations:
 ;   Convert any semi-colons to dashes
 ;   Add semi-colon delimiter if needed
 ;   Truncate data if needed
 I $G(TEXT)]"" D
 . N X
 . S TEXT=$TR(TEXT,";","-")
 . S X=$P(^BPST(IEN59,2),U,2,99)
 . I X]"",$E(X)'=";" S X=";"_X
 . S X=$E(TEXT_X,1,255-$L(RESULT)-1)
 . S $P(^BPST(IEN59,2),U,2)=X
 Q
 ;
 ; SETCRESU - set the result code for every transaction assoc'd with
 ;   this claim.  Note that this will only work for billing requests (B1)
 ; Input
 ;   CLAIMIEN - BPS Claim IEN
 ;   RESULT   - Result Code
 ;   TEXT     - Result Text
SETCRESU(CLAIM,RESULT,TEXT) ;
 N IEN59
 S IEN59=""
 F  S IEN59=$O(^BPST("AE",CLAIM,IEN59)) Q:IEN59=""  D SETRESU(IEN59,RESULT,$G(TEXT))
 Q
 ;
 ; STATI(X) gives a text version of what status code X means.
 ;   For effeciency, put more common ones at the top.
 ; Also note that you should check the display on the stats screen if you
 ;   modify any of these.
STATI(X) ;
 I X=99 Q "Done"
 I X=60 Q "Transmitting"
 I X=0 Q "Waiting to start"
 I X=40 Q "Building the HL7 packet"
 I X=70 Q "Parsing response"
 I X=30 Q "Building the claim"
 I X=10 Q "Building the transaction"
 I X=90 Q "Processing response"
 I X=98 Q "Resubmitting" ; Used only by STATUS^BPSOSRX (Not stored in BPS Transactions)
 I X=50 Q "Preparing for transmit"
 I X=31 Q "Wait for retry (insurer asleep)"
 I X=80 Q "Waiting to process response"
 Q "?"_X_"?"
