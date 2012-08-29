DGENDD ;ALB/CJM,JAN,LBD,AMA - Enrollment Data Dictionary Functions; 13 JUN 1997;6-28-01
 ;;5.3;Registration;**121,351,503,733**;Aug 13,1993;Build 15
 ;
SET1(DFN,DGENRIEN) ;
 ;Description: sets the "AENRC" X-ref on the patient file
 ;Inputs:
 ;  DFN - the patient ien
 ;  DGENRIEN - ien of current enrollment
 ;
 Q:'$G(DGENRIEN)
 Q:'$G(DFN)
 ;
 N STATUS
 S STATUS=$P($G(^DGEN(27.11,DGENRIEN,0)),"^",4)
 S:STATUS ^DPT("AENRC",STATUS,DFN)=""
 ;
 Q
 ;
KILL1(DFN) ;
 ;Description: This is the kill logic that corresponds to SET1.
 ;Input: DFN is the patient ien
 ;
 Q:'$G(DFN)
 ;
 N DGSTATUS,STATUS
 S DGSTATUS=$P(^DGEN(27.15,0),U,3)
 F STATUS=1:1:DGSTATUS K ^DPT("AENRC",STATUS,DFN)
 Q
 ;
SET2(DGENRIEN,STATUS) ;
 ;Description: This MUMPS x-ref on the Patient Enrollment file sets the
 ;  "AENRC" X-ref on the patient file.
 ;Inputs:
 ;  DGENRIEN - enrollment ien
 ;  STATUS - the enrollment status
 ;
 Q:'$G(DGENRIEN)
 Q:'$G(STATUS)
 ;
 N DFN
 S DFN=$P($G(^DGEN(27.11,DGENRIEN,0)),"^",2)
 Q:'DFN
 I $$FINDCUR^DGENA(DFN)=DGENRIEN D
 . S ^DPT("AENRC",STATUS,DFN)=""
 ;
 Q
 ;
KILL2(DGENRIEN,STATUS) ;
 ;Description: This is the kill logic that corresponds to SET2.
 ;Inputs:
 ;  DGENRIEN - enrollment ien
 ;  STATUS - the enrollment status
 ;
 Q:'$G(DGENRIEN)
 Q:'$G(STATUS)
 ;
 N DFN
 S DFN=$P($G(^DGEN(27.11,DGENRIEN,0)),"^",2)
 Q:'DFN
 I $$FINDCUR^DGENA(DFN)=DGENRIEN D
 . K ^DPT("AENRC",STATUS,DFN)
 Q
 ;
SETREM(DGENRIEN,STATUS) ;
 ;This set logic is called by the Enrollment Status field (#.04) in 
 ;the Patient Enrollment file (#27.11).  If the Enrollment Status
 ;contains the word REJECTED, then "**REJECTED**" will be stuffed
 ;into the Remarks field (#.091) of the Patient file (#2).  If the
 ;Enrollment Status does not contain REJECTED, then the word
 ;"**REJECTED**" will be removed.
 ;Input:
 ;  DGENRIEN - IEN of the enrollment record
 ;  STATUS - enrollment status
 ;
 Q:'$G(DGENRIEN)
 Q:'$G(STATUS)
 ;
 N DFN,REM
 S DFN=$P($G(^DGEN(27.11,DGENRIEN,0)),U,2)
 Q:'DFN  Q:$G(^DPT(DFN,0))=""
 L +^DPT(DFN,0):5 I '$T Q
 S REM=$P(^DPT(DFN,0),U,10)
 ;The enrollment status contains REJECTED, set REMARKS
 I "^11^12^13^14^22^"[(U_STATUS_U) D  G SETREMQ
 . I REM["**REJECTED**" Q  ;Remarks already contain REJECTED
 . S REM=REM_"**REJECTED**"
 . S $P(^DPT(DFN,0),U,10)=REM
 ;The enrollment status does not contain REJECTED, remove REMARKS
 I REM'["**REJECTED**" G SETREMQ
 S REM=$P(REM,"**REJECTED**",1)_$P(REM,"**REJECTED**",2,99)
 S $P(^DPT(DFN,0),U,10)=REM
SETREMQ L -^DPT(DFN,0)
 Q
 ;
CSI1010(DA) ;
 ;If COMBAT SERVICE INDICATED? (2/.5291) is "NO,"
 ;set COMBAT INDICATED ON 1010EZ (2/1010.157) to "NO."
 I $P($G(^DPT(DA,.52)),U,11)="N" D
 . N DGFDA
 . S DGFDA(2,DA_",",1010.157)=0
 . D FILE^DIE(,"DGFDA")
 Q
 ;
CTD1010(DA) ;
 ;If COMBAT SERVICE INDICATED? (2/.5291) is "YES" and
 ;COMBAT TO DATE (2/.5294) is greater than 11/11/1998,
 ;set COMBAT INDICATED ON 1010EZ (2/1010.157) to "YES."
 N NODE,ANS,DGFDA
 S NODE=$G(^DPT(DA,.52)),ANS=0
 I ($P(NODE,U,11)="Y"),($P(NODE,U,14)>2981111) S ANS=1
 S DGFDA(2,DA_",",1010.157)=ANS
 D FILE^DIE(,"DGFDA")
 Q
