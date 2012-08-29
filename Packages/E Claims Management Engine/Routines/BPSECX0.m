BPSECX0 ;BHAM ISC/FCS/DRS/VA/DLF - Retrieve Claim submission record ;05/17/2004
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 Q
 ;----------------------------------------------------------------------
 ;Retrieve Claim submission record
 ;
 ;Input Variables:   CLAIMIEN -  Claim Submission IEN (9002313.02)
 ;                   .BPS     -  Pass by reference, output only
 ;
 ;Output Variables:  BPS(9002313.02,CLAIMIEN,<field #>,"I")  = Value
 ;----------------------------------------------------------------------
 ; IHS/SD/lwj  08/13/02  NCPDP 5.1 changes
 ; Many fields that were once a part of the "header" of the claim
 ; were shifted to appear on the "rx" or "detail" segments of the
 ; claim in 5.1. Additionally, MANY new fields were added beyond 499. 
 ; For these reasons, we had to change the GETBPS3
 ; subroutine to pull fields 308 through 600 rather than just 
 ; 402 - 499. The really cool thing is that because we are at the
 ; subfile level, the duplicated fields (between header and rx)
 ; will only pull at the appropriate level.  3.2 claims should
 ; be unaffected by this change, as the adjusted and new fields
 ; were not populated for 3.2
 ;
 ; New subroutine added GETBPS4 to pull out the repeating fields for
 ; the DUR/PPS records
 ;----------------------------------------------------------------------
 ; 
GETBPS2(CLAIMIEN,BPS) ;EP - from BPSECA1 from BPSOSQG from BPSOSQ2
 ;Manage local variables
 N DIC,DR,DA,DIQ,D0,DIQ2
 ;
 ;Make sure input variables are defined
 Q:$G(CLAIMIEN)=""
 ;
 ;Set input variables for FileMan data retrieval routine
 ;IHS/SD/lwj 9/9/02  need to expand the field range to include
 ; the "500" range fields now used in the header segments
 ; for NCPDP 5.1
 ;
 S DIC=9002313.02
 ; IHS/SD/lwj 9/9/02 NCPDP 5.1 changes
 S DR="101:600"
 S DA=CLAIMIEN
 S DIQ="BPS",DIQ(0)="I"
 ;
 ;Execute data retrieval routine
 D EN^DIQ1
 Q
 ;----------------------------------------------------------------------
 ;Retrieve Claim Submission, Prescription(s) multiple record
 ;
 ;Input Variables:   CLAIMIEN - Claim Submission IEN (9002313.02)
 ;                   CRXIEN   - Prescription Multiple IEN (9002313.0201)
 ;
 ;Output Variables:  BPS(9002313.0201,CRXIEN,<field #>,"I") = Value
 ;----------------------------------------------------------------------
GETBPS3(CLAIMIEN,CRXIEN,BPS) ;EP - from BPSECA1
 ;Manage local variables
 N DIC,DR,DA,DIQ,D0,DIQ2
 ;
 ;Make sure input variables are defined
 Q:$G(CLAIMIEN)=""
 Q:$G(CRXIEN)=""
 ;
 ;S input variables for FileMan data retrieval routine
 S DIC=9002313.02
 ;
 S DR="400",DR(9002313.0201)="308:600"  ;need new RX fields
 ;IHS/SD/lwj 8/13/02 end changes
 S DA=CLAIMIEN,DA(9002313.0201)=CRXIEN
 S DIQ="BPS",DIQ(0)="I"
 ;
 ;Execute data retrieval routine
 D EN^DIQ1
 Q
 ;----------------------------------------------------------------------
 ;Retrieve Claim Submission, Prescription(s) multiple, DUR/PPS multiple 
 ; record
 ;
 ;Input Variables:   CLAIMIEN - Claim Submission IEN (9002313.02)
 ;                   CRXIEN   - Prescription Multiple IEN (9002313.0201)
 ;                   CDURIEN  - DUR/PPS Multiple IEN (9002313.1001)
 ;
 ;Output Variables:  BPS(9002313.1001,CDURIEN,<field #>,"I") = Value
 ;----------------------------------------------------------------------
GETBPS4(CLAIMIEN,CRXIEN,CDURIEN,BPS) ;EP - from BPSECA1
 ;
 ;Manage local variables
 N DIC,DR,DA,DIQ,D0,DIQ2
 ;
 ;Make sure input variables are defined
 Q:$G(CLAIMIEN)=""
 Q:$G(CRXIEN)=""
 Q:$G(CDURIEN)=""
 ;
 ;S input variables for FileMan data retrieval routine
 S DIC=9002313.02
 ;
 S DR="400",DR(9002313.0201)=473.01  ;fields
 S DR(9002313.1001)=".01;439;440;441;474;475;476"  ;fields
 S DA=CLAIMIEN,DA(9002313.0201)=CRXIEN,DA(9002313.1001)=CDURIEN
 S DIQ="BPS",DIQ(0)="I"
 ;
 ;Execute data retrieval routine
 D EN^DIQ1
 ;
 Q
