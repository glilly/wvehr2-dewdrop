IBCNEDE2 ;DAOU/DAC - IIV PRE REG EXTRACT (APPTS) ;18-JUN-2002
 ;;2.0;INTEGRATED BILLING;**184,271,249,345**;21-MAR-94;Build 28
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ;**Program Description**
 ;  This program finds veterans who are scheduled to be seen within a
 ;  specified date range.
 ;  Periodically check for stop request for background task
 ;
 Q   ; can't be called directly
 ;
EN ; Loop through designated cross-references for updates
 ; Pre reg extract (Appointment extract)
 ;
 N TODAYSDT,FRESHDAY,SLCCRIT1,MAXCNT,CNT,ENDDT,CLNC,FRESHDT
 N APTDT,INREC,INSIEN,PAYER,PIEN,PAYERSTR,SYMBOL,SUPPBUFF
 N DFN,OK,VAIN,INS,DATA1,DATA2,ELG,PAYERID,SETSTR,SRVICEDT,ACTINS
 N TQIEN,IBINDT,IBOUTP,QURYFLAG,INSNAME,FOUND1,FOUND2,IBCNETOT
 N SID,SIDACT,SIDDATA,SCNT5,SIDARRAY,SIDCNT,IBDDI,IBINS,DISYS
 ;
 S SETSTR=$$SETTINGS^IBCNEDE7(2)     ;  Get setting for pre reg. extract 
 I 'SETSTR Q                         ; Quit if extract is not active
 S SLCCRIT1=$P(SETSTR,U,2)           ; Selection Criteria #1
 S MAXCNT=$P(SETSTR,U,4)             ; Max # of TQ entries to create
 S:MAXCNT="" MAXCNT=9999999999
 S SUPPBUFF=$P(SETSTR,U,5)                   ; Suppress Buffer Flag
 S FRESHDAY=$P($G(^IBE(350.9,1,51)),U,1)     ; Freshness days span
 S CNT=0                                     ; Init. TQ entry counter
 S ENDDT=$$FMADD^XLFDT(DT,SLCCRIT1)   ; End of appt. date selection range
 S IBCNETOT=0               ; Initialize count for periodic TaskMan check
 K ^TMP($J,"SDAMA301"),^TMP("IBCNEDE2",$J)   ; Clean TMP globals
 ;
 S CLNC=0 ; Init. clinic
 ; Loop through clinics 
 F  S CLNC=$O(^SC(CLNC)) Q:'CLNC!(CNT'<MAXCNT)  D  Q:$G(ZTSTOP)
 . ;
 . D CLINICEX Q:'OK     ; Check for clinic exclusion
 . ;
 . S ^TMP("IBCNEDE2",$J,CLNC)=""
 ;
 ; Set up variables for scheduling call and call
 S IBSDA("FLDS")=8
 S IBSDA(1)=DT_";"_ENDDT
 S IBSDA(2)="^TMP(""IBCNEDE2"",$J,"
 S IBSDA(3)="R"
 I $$SDAPI^SDAMA301(.IBSDA)<1 D ERRMSG G ENQ
 ;
 ;
 S CLNC=0 ; Init. clinic
 ; Loop through clinics returned
 F  S CLNC=$O(^TMP($J,"SDAMA301",CLNC)) Q:'CLNC  D  Q:$G(ZTSTOP)!(CNT'<MAXCNT)
 . ;
 . ; Loop through patients returned
 . S DFN=0 F  S DFN=$O(^TMP($J,"SDAMA301",CLNC,DFN)) Q:'DFN!(CNT'<MAXCNT)  D  Q:$G(ZTSTOP)
 .. ;
 .. S APTDT=DT           ; Check for appointment date
 .. ;
 .. ; Loop through dates in range at clinic
 .. F  S APTDT=$O(^TMP($J,"SDAMA301",CLNC,DFN,APTDT)) Q:('APTDT)!((APTDT\1)>ENDDT)!(CNT'<MAXCNT)  D  Q:$G(ZTSTOP)
 ... ;
 ... S SRVICEDT=APTDT\1 ;Set service date equal to appointment date
 ... S FRESHDT=$$FMADD^XLFDT(SRVICEDT,-FRESHDAY)
 ... ;
 ... ; Update count for periodic check
 ... S IBCNETOT=IBCNETOT+1
 ... ; Check for request to stop background job, periodically
 ... I $D(ZTQUEUED),IBCNETOT#100=0,$$S^%ZTLOAD() S ZTSTOP=1 Q
 ... ;
 ... S IBSDATA=$G(^TMP($J,"SDAMA301",CLNC,DFN,APTDT))
 ... S ELG=$P(IBSDATA,U,8)
 ... S ELG=$S(ELG'="":ELG,1:$P($G(^DPT(DFN,.36)),U,1))
 ... I $P($G(^DPT(DFN,0)),U,21) Q         ; Exclude if test patient
 ... I $P($G(^DPT(DFN,.35)),"^",1)'="" Q  ; Exclude if patient is deceased
 ... ;
 ... D ELG Q:'OK     ; Check for eligibility exclusion
 ... ; D INP Q:'OK     ; No longer check for inpatient status
 ... ;
 ... K ACTINS
 ... D ALL^IBCNS1(DFN,"ACTINS",1)
 ... ;
 ... I '$D(ACTINS(0)) D NOACTIVE Q   ; Patient has no active ins
 ... ;
 ... S INREC=0 ; Record ien
 ... F  S INREC=$O(ACTINS(INREC)) Q:('INREC)!(CNT'<MAXCNT)  D
 ... . S INSIEN=$P($G(ACTINS(INREC,0)),U,1) ; Insurance ien
 ... . S INSNAME=$P($G(^DIC(36,INSIEN,0)),U)
 ... . ;
 ... . ; check for ins. to exclude (i.e. Medicare/Medicaid)
 ... . I $$EXCLUDE^IBCNEUT4(INSNAME) Q
 ... . ;
 ... . S PAYERSTR=$$INSERROR^IBCNEUT3("I",INSIEN) ; Get payer info
 ... . ;
 ... . S SYMBOL=+PAYERSTR ; error symbol
 ... . S PAYERID=$P(PAYERSTR,U,3)               ; (National ID) payer id
 ... . S PIEN=$P(PAYERSTR,U,2)                  ; Payer ien
 ... . ;
 ... . ; If error symbol exists, set record in insurance buffer & quit
 ... . I SYMBOL D  Q
 ... . . I 'SUPPBUFF,'$$BFEXIST^IBCNEUT5(DFN,INSNAME) D PT^IBCNEBF(DFN,INREC,SYMBOL,"",1)
 ... . ;
 ... . ; Update service date and freshness date based on payers allowed
 ... . ;  date range
 ... . D UPDDTS^IBCNEDE6(PIEN,.SRVICEDT,.FRESHDT)
 ... . ;
 ... . ; Update service dates for inquiry to be transmitted
 ... . D TQUPDSV^IBCNEUT5(DFN,PIEN,SRVICEDT)
 ... . ;
 ... . ; Quit before filing if outstanding entries in TQ
 ... . I '$$ADDTQ^IBCNEUT5(DFN,PIEN,SRVICEDT,FRESHDAY) Q
 ... . ;
 ... . S QURYFLAG="V"
 ... . K SIDARRAY
 ... . S SIDDATA=$$SIDCHK^IBCNEDE5(PIEN,DFN,,.SIDARRAY,FRESHDT)
 ... . S SIDACT=$P(SIDDATA,U),SIDCNT=$P(SIDDATA,U,2)
 ... . I SIDACT=3,'SUPPBUFF,'$$BFEXIST^IBCNEUT5(DFN,INSNAME) D PT^IBCNEBF(DFN,INREC,18,"",1) Q
 ... . S SCNT5=$S(SIDACT=5:1,1:0)
 ... . I CNT+SCNT5+SIDCNT>MAXCNT S CNT=MAXCNT Q  ;exceeds MAXCNT
 ... . ;
 ... . S SID=""
 ... . F  S SID=$O(SIDARRAY(SID)) Q:SID=""  D SET($P(SID,"_"),$P(SID,"_",2))
 ... . I SIDACT=4!(SIDACT=5) D SET("","")
 ... . Q
 ... Q
ENQ K ^TMP($J,"SDAMA301"),^TMP("IBCNEDE2",$J)
 Q
 ;
CLINICEX ; Clinic exclusion
 S OK=1
 I $D(^DG(43,1,"DGPREC","B",CLNC)) S OK=0
 Q
 ;
ELG ;  Eligibility exclusion
 I ELG="" S OK=0 Q
 I $D(^DG(43,1,"DGPREE","B",ELG)) S OK=0 Q
 S OK=1
 Q
 ;
INP ;  Inpatient status
 D INP^VADPT
 I $G(VAIN(1))'="" K VAIN S OK=0 Q
 K VAIN
 S OK=1
 Q
 ;
NOACTIVE ; No active insurance
 ;
 ; Call IB utility to search for patient's inactive insurance
 ; IBCNS passes back IBINS = 1 if active insurance was found
 ; IBCNS sets the array IBDD to the patient's valid insurance
 ; IBCNS sets the array IBDDI to the patient's invalid insurance
 ;
 N SVIBDDI
 K IBINS,IBDD,IBDDI
 S IBINDT=APTDT,IBOUTP=2,(FOUND1,FOUND2)=0
 ;
 D ^IBCNS
 K IBDD           ; don't need this array
 I $G(IBINS)=1 Q  ; if active insurance was found quit
 M SVIBDDI=IBDDI
 ; Inactive Insurance
 I CNT<MAXCNT,$D(IBDDI)>0 S FOUND2=$$INAC^IBCNEDE6(.CNT,MAXCNT,.IBDDI,SRVICEDT,FRESHDAY,1)
 M IBDDI=SVIBDDI
 ;
 ; Most Popular Payer
 I CNT<MAXCNT S FOUND1=$$POP^IBCNEDE4(.CNT,MAXCNT,SRVICEDT,FRESHDAY,1,.IBDDI)
 ;
 I 'FOUND1,'FOUND2,(CNT<MAXCNT) D BLANKTQ
 ;
 K INS,IBBDI
 Q
 ;
SET(SID,INR) ; Set data in TQ
 ;
 ; The hard coded '1' in the 3rd piece of DATA1 sets the Transmission
 ; status of file 365.1 to "Ready to Transmit"
 S DATA1=DFN_U_PIEN_U_1_U_""_U_SID_U_FRESHDT ; SETTQ 1st parameter
 ;
 ; The hardcoded '2' in the 1st piece of DATA2 is the value to tell
 ; the file 365.1 that it is the appointment extract.
 S DATA2=2_U_QURYFLAG_U_SRVICEDT_U_INR    ; SETTQ 2nd parameter
 ;
 S TQIEN=$$SETTQ^IBCNEDE7(DATA1,DATA2)       ; Sets in TQ
 I TQIEN'="" S CNT=CNT+1                    ; If filed increment count
 ;
 Q
 ;
BLANKTQ ; no new records were created in file 365.1 for this DFN
 ; need to check if a blank inquiry exists (patient w/o a payer)
 ; if it doesn't exist create a new blank inquiry
 ;
 ; Check for at least 1 other VAMC a patient has traveled to
 I $$TFL^IBCNEDE6(DFN)=0 Q
 ;
 N DISYS
 S PIEN=$$FIND1^DIC(365.12,,"X","~NO PAYER"),SID=""
 ;
 ; Update service date and freshness date based on payer allowed
 ;  date range
 D UPDDTS^IBCNEDE6(PIEN,.SRVICEDT,.FRESHDT)
 ; 
 ; Update service dates for inquiry to be transmitted - necessary here?
 D TQUPDSV^IBCNEUT5(DFN,PIEN,SRVICEDT)
 ;
 I '$$ADDTQ^IBCNEUT5(DFN,PIEN,SRVICEDT,FRESHDAY,1) G BLANKXT
 ;
 S QURYFLAG="I" D SET("","")
 S PIEN=""
BLANKXT ;
 Q
 ;
ERRMSG ; Send a message indicating an extract error has occured
 N MGRP,XMSUB,MSG,IBX,IBM
 ;
 ; Set to IB site parameter MAILGROUP
 S MGRP=$$MGRP^IBCNEUT5()
 ;
 S XMSUB="IIV Problem: Appointment Extract"
 S MSG(1)="On "_$$FMTE^XLFDT(DT)_" the Appointment Extract for IIV encountered one or more"
 S MSG(2)="errors while attempting to get Appointment data from the scheduling"
 S MSG(3)="package."
 S MSG(4)=""
 S MSG(5)="Error(s) encountered: "
 S MSG(6)=""
 S MSG(7)="  Error Code   Error Message"
 S MSG(8)="  ----------   -------------"
 S IBM=8,IBX=0 F  S IBX=$O(^TMP($J,"SDAMA301",IBX)) Q:IBX=""  S IBM=IBM+1,MSG(IBM)="  "_$$LJ^XLFSTR(IBX,13)_$G(^TMP($J,"SDAMA301",IBX))
 S IBM=IBM+1,MSG(IBM)=""
 S IBM=IBM+1,MSG(IBM)="As a result of this error the extract was not done.  The extract"
 S IBM=IBM+1,MSG(IBM)="will be attempted again the next night automatically.  If you"
 S IBM=IBM+1,MSG(IBM)="continue to receive error messages you should contact your IRM"
 S IBM=IBM+1,MSG(IBM)="and possibly log a NOIS call for assistance."
 ;
 D MSG^IBCNEUT5(MGRP,XMSUB,"MSG(")
 ;
 Q
