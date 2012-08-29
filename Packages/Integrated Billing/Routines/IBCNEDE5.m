IBCNEDE5 ;DAOU/DAC - IIV DATA EXTRACTS ;15-OCT-2002
 ;;2.0;INTEGRATED BILLING;**184,271**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 Q    ; no direct calls allowed
 ;
SIDCHK(PIEN,DFN,BSID,SIDARRAY,FRESHDT) ; Checks the flag settings of 'Identification
 ; Requires Subscriber ID' and 'Use SSN as Subscriber ID'.  The function 
 ; returns a "^" delimited string.  The first value is between 1 and 5
 ; telling the calling program what action(s) it should perform.  The
 ; 2nd piece indicates the Subcriber ID that the calling program should
 ; use for setting the Subscriber IDs in the IIV Transmission Queue file
 ; (365.1).  The calling program is to address the blank Sub IDs and 
 ; make sure the data extract does not exceed the max extract number.
 ;
 ; PIEN - Payer's IEN (file 365.12)
 ; DFN - Patient's IEN (file 2)
 ; INREC - Insurance IEN of Patients record (subfile 2.312)
 ; BSID - Subscriber ID from buffer file (file 355.3 field )
 ; SIDARRAY - Array of active subscribers - may be subscripted by SSN 
 ; FRESHDT - Freshness Date - used for checking verified date
 ;
 ; Logic to follow:
 ;
 ; Id. Req.| Use SSN  | Sub ID|Action|
 ;  Sub ID | as Sub ID| found |  #   | Create
 ; ________|__________|_______|______|________
 ; YES        -         YES     1     1 Verification TQ entry w/ Sub ID
 ; YES       YES        NO      2     1 Ver. TQ entry, use SSN as Sub ID
 ; YES       NO         NO      3     new buffer entry or modify existing
 ;                                    saying manual verification required
 ; NO        NO         NO      4     1 Ver. TQ entry w/ blank Sub ID
 ; NO        YES        NO      5     2 Ver. TQ entries, 1 w/ SSN as Sub
 ;                                    ID and other w/ blank Sub ID
 ;
 N SIDACT,SID,APPIEN,SIDSTR,SIDREQ,SIDSSN,SSN
 N INSSTR,INSSTR1,SYMBOL,EXP,SUBID,SUBIDS,SIDCNT,INREC,MVER,VFLG
 ;
 S FRESHDT=$G(FRESHDT),VFLG=0
 ;
 I $G(BSID)'="" D  G SIDCHKX
 . S SID=BSID,(SIDACT,SIDCNT)=1
 . S SIDARRAY($$STRIP(SID,,DFN)_"_")=""
 S APPIEN=$$PYRAPP^IBCNEUT5("IIV",PIEN)
 S SIDSTR=$G(^IBE(365.12,PIEN,1,APPIEN,0))
 S SIDREQ=$P(SIDSTR,U,8)
 S SIDSSN=$P(SIDSTR,U,9)
 ;
 S INSSTR="",SIDCNT=0,INREC=$O(^DPT(DFN,.312,0)) S:'INREC INREC=1
 ;
 I $D(BSID),BSID="" G SIDC1
 I $G(^DPT(DFN,.312,INREC,0)) F  D  Q:'INREC
 . S INSSTR=$G(^DPT(DFN,.312,INREC,0))
 . S INSSTR1=$G(^DPT(DFN,.312,INREC,1))
 . S SYMBOL=$$INSERROR^IBCNEUT3("I",+INSSTR)
 . I $P(SYMBOL,U)="" D            ; no IIV related error w/ ins. company
 .. I PIEN'=$P(SYMBOL,U,2) Q      ; wrong payer ien
 .. S SUBID=$P(INSSTR,U,2)
 .. I SUBID="" Q                           ; missing Subscriber ID
 .. I $P(INSSTR,U,8)>DT Q                  ; future effective date
 .. S EXP=$P(INSSTR,U,4) I EXP,EXP<DT Q    ; expired
 .. S MVER=$P(INSSTR1,U,3)                 ; last verified date
 .. I MVER'="",FRESHDT'="",MVER>FRESHDT S VFLG=1 Q     ; verified recently
 .. S SUBIDS=$$STRIP(SUBID,,DFN)
 .. I $D(SIDARRAY(SUBIDS_"_"_INREC)) Q            ; already in the array
 .. S SIDARRAY(SUBIDS_"_"_INREC)="",SIDCNT=SIDCNT+1
 . S INREC=$O(^DPT(DFN,.312,INREC))
 . Q
 ;
 I SIDCNT S SIDACT=1 G SIDCHKX
 I 'SIDCNT,VFLG S SIDACT=1 G SIDCHKX
SIDC1 I SIDREQ,SIDSSN S SIDACT=2 D SSN(DFN) G SIDCHKX
 I SIDREQ,'SIDSSN S SIDACT=3 G SIDCHKX
 I 'SIDREQ,'SIDSSN S SIDACT=4 G SIDCHKX
 I 'SIDREQ,SIDSSN S SIDACT=5 D SSN(DFN)
 ;
SIDCHKX ; EXIT POINT
 ;
 Q SIDACT_U_SIDCNT
 ;
SSN(DFN) ; Get Patient SSN and update SIDARRAY, if needed
 S SSN=$$GETSSN(DFN)
 N SSNS
 S SSNS=$$STRIP(SSN,1,DFN)
 I $P($O(SIDARRAY(SSNS_"_")),"_")=SSNS Q
 I SSNS'="",'$D(SIDARRAY(SSNS_"_")) S SIDARRAY(SSNS_"_")="",SIDCNT=SIDCNT+1
 Q
 ;
GETSSN(DFN) ; Get Patient SSN
 Q:'$G(DFN) ""
 Q $P($G(^DPT(DFN,0)),U,9)
 ;
STRIP(ID,SS,DFN) ; Strip dashes and spaces if ssn
 ;         ID can be ssn or subid
 ;         if SS, ssn is being passed
 N SSN,IDS,IDB
 S SS=$G(SS)
 ; If a ssn is passed, strip dashes and spaces
 I SS Q $TR(ID,"- ")
 ; If not ssn format, do not strip
 S IDB=$TR(ID," ")
 I IDB'?3N1"-"2N1"-"4N,IDB'?9N Q ID
 ; Compare w/SSN - if it matches, strip dashes and spaces
 S IDS=$TR(ID,"- ")
 S SSN=$TR($$GETSSN(DFN),"- ")
 I SSN=IDS Q IDS
 Q ID
 ;
SIDCHK2(DFN,PIEN,SIDARRAY,FRESHDT) ;Checks the flag settings of 
 ; 'Identification Requires Subscriber ID' and 'Use SSN as Subscriber
 ; ID'.  The function returns a "^" delimited string.  The first value 
 ; is between 1 and 8 telling the calling program what action(s) it 
 ; should perform.  The 2nd piece indicates the number of unique 
 ; Subscriber IDs found for the patient/payer combo.  In addition, a
 ; local array of Subcriber IDs are passed back by reference that the
 ; calling program should use for setting the Subscriber IDs in IIV 
 ; Transmission Queue file (#365.1).  The calling program is to address
 ; the blank Sub IDs and make sure the data extract does not exceed the
 ; max extract number.
 ;
 ; PIEN - Payer's IEN (file 365.12)
 ; DFN - Patient's IEN (file 2)
 ; SIDARRAY - Local array passed by reference.  This function returns
 ;            the array populated with the possible Subscriber IDs for
 ;            that patient/payer combination.
 ; FRESHDT - Freshness date used for checking last verified condition
 ;
 ; Logic to follow:
 ;
 ; Id. Req.| Use SSN  | Sub ID|Action|
 ;  Sub ID | as Sub ID| found |  #   | Create
 ; ________|__________|_______|______|________
 ; YES       YES        YES     1     1 Identification TQ entry w/ SSN 
 ;                                    as Sub ID, & 1 Iden. TQ entry for
 ;                                    each unique old Sub ID
 ; YES       YES        NO      2     1 Iden. TQ entry, use SSN as Sub ID
 ; YES       NO         YES     3     1 Iden. TQ entry for each unique 
 ;                                    old Sub ID
 ; YES       NO         NO      4     No TQ entries (may flag as error)
 ; NO        NO         YES     5     1 Iden. TQ entry w/ blank Sub ID, 
 ;                                    & 1 Iden. TQ entry for each unique 
 ;                                    old Sub ID
 ; NO        NO         NO      6     1 Iden. TQ entry w/ blank Sub ID
 ; NO        YES        YES     7     1 Iden. TQ entry w/ blank Sub ID,
 ;                                    & 1 Iden. TQ entry w/ SSN as Sub 
 ;                                    ID, & 1 Iden. TQ entry for each 
 ;                                    unique old Sub ID
 ; NO        YES        NO      8     2 Iden. TQ entries, 1 w/ SSN as Sub
 ;                                    ID and other w/ blank Sub ID
 ;
 N SIDACT,SID,APPIEN,SIDSTR,SIDREQ,SIDSSN,SSN,INSSTR,INSSTR1,INREC
 N SYMBOL,SUBID,SUBIDS,SIDCNT,MVER,VFLG
 ;
 S FRESHDT=$G(FRESHDT),VFLG=0
 S APPIEN=$$PYRAPP^IBCNEUT5("IIV",PIEN)
 S SIDSTR=$G(^IBE(365.12,PIEN,1,APPIEN,0))
 S SIDREQ=$P(SIDSTR,U,8)
 S SIDSSN=$P(SIDSTR,U,9)
 S INSSTR="",(SID,SIDCNT)=0,INREC=$O(^DPT(DFN,.312,0)) S:'INREC INREC=1
 ;
 I $G(^DPT(DFN,.312,INREC,0)) F  D  Q:'INREC!VFLG
 . S INSSTR=$G(^DPT(DFN,.312,INREC,0))
 . S INSSTR1=$G(^DPT(DFN,.312,INREC,1))
 . S SYMBOL=$$INSERROR^IBCNEUT3("I",+INSSTR)
 . I $P(SYMBOL,U)="" D            ; no IIV related error w/ ins. company
 .. I PIEN'=$P(SYMBOL,U,2) Q      ; wrong payer ien
 .. S SUBID=$P(INSSTR,U,2)
 .. I SUBID="" Q                           ; missing Subscriber ID
 .. S MVER=$P(INSSTR1,U,3)                 ; last verified date
 .. I MVER'="",FRESHDT'="",MVER>FRESHDT S VFLG=1 Q    ; verified recently
 .. S SUBIDS=$$STRIP(SUBID,,DFN)
 .. I $D(SIDARRAY(SUBIDS_"_")) Q            ; already in the array
 .. S SIDARRAY(SUBIDS_"_"_INREC)="",SID=1,SIDCNT=SIDCNT+1
 . S INREC=$O(^DPT(DFN,.312,INREC))
 ;
 I VFLG K SIDARRAY S SIDCNT=0,SIDACT=4 G SIDCK2X
 I SID,SIDREQ,SIDSSN S SIDACT=1 D SSN(DFN) G SIDCK2X
 I 'SID,SIDREQ,SIDSSN S SIDACT=2 D SSN(DFN) G SIDCK2X
 I SID,SIDREQ,'SIDSSN S SIDACT=3 G SIDCK2X
 I 'SID,SIDREQ,'SIDSSN S SIDACT=4 G SIDCK2X
 I SID,'SIDREQ,'SIDSSN S SIDACT=5 G SIDCK2X
 I 'SID,'SIDREQ,'SIDSSN S SIDACT=6 G SIDCK2X
 I SID,'SIDREQ,SIDSSN S SIDACT=7 D SSN(DFN) G SIDCK2X
 I 'SID,'SIDREQ,SIDSSN S SIDACT=8 D SSN(DFN) G SIDCK2X
 ;
SIDCK2X ; EXIT POINT
 ;
 Q SIDACT_U_SIDCNT
 ;
