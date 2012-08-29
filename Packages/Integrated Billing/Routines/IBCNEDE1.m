IBCNEDE1 ;DAOU/DAC - IIV INSURANCE BUFFER EXTRACT ;04-JUN-2002
 ;;2.0;INTEGRATED BILLING;**184,271**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ; This routine loops through the insurance buffer and 
 ; creates IIV transaction queue entries when approriate.
 ; Periodically check for stop request for background task
 ;
 Q   ; no direct calls allowed
 ;
EN ; Loop through designated cross-references for updates
 ; Insurance Buffer Extract
 ;
 N TODAYSDT,FRESHDAY,LOOPDT,IEN,OVRFRESH,FRESHDT
 N DFN,PDOD,SRVICEDT,VERIFDDT,PAYERSTR,PAYERID,SYMBOL,PAYRNAME
 N PIEN,PNIEN,TQIEN,TRIEN,TRSRVCDT,TQCRTDT,TRANSNO,DISYS
 N ORIGINSR,ORGRPSTR,ORGRPNUM,ORGRPNAM,ORGSUBCR
 N MAXCNT,CNT,ISYMBOLM,DATA1,DATA2,ORIG,SETSTR,ISYMBOL,IBCNETOT
 N SIDDATA,SID,SIDACT,BSID,FDA,PASSBUF,SCNT5,SIDCNT,SIDARRAY
 N TQDT,TQIENS,TQOK,STATIEN
 ;
 S SETSTR=$$SETTINGS^IBCNEDE7(1) ; Returns buffer extract settings
 I 'SETSTR Q                    ; Quit if extract is not active
 S MAXCNT=$P(SETSTR,U,4)        ; Max # TQ entries that may be created
 S:MAXCNT="" MAXCNT=9999999999
 ;
 S FRESHDAY=$P($G(^IBE(350.9,1,51)),U,1) ; System freshness days
 ;
 S CNT=0       ; Initialize count of TQ entries created
 S IBCNETOT=0  ; Initialize count for periodic TaskMan check
 ;
 S LOOPDT="" ; Date used to loop throught the IB global
 F  S LOOPDT=$O(^IBA(355.33,"AEST","E",LOOPDT)) Q:LOOPDT=""!(CNT=MAXCNT)  D  Q:$G(ZTSTOP)
 . S IEN=""
 . F  S IEN=$O(^IBA(355.33,"AEST","E",LOOPDT,IEN)) Q:IEN=""!(CNT=MAXCNT)  D  Q:$G(ZTSTOP)
 .. ; Update count for periodic check
 .. S IBCNETOT=IBCNETOT+1
 .. ; Check for request to stop background job, periodically
 .. I $D(ZTQUEUED),IBCNETOT#100=0,$$S^%ZTLOAD() S ZTSTOP=1 Q
 .. ;
 .. ; Get symbol, if symbol'=" " OR "!" then quit
 .. S ISYMBOL=$$SYMBOL^IBCNBLL(IEN) ; Insurance buffer symbol
 .. I (ISYMBOL'=" ")&(ISYMBOL'="!") Q
 .. ;
 .. ; Get the IIV STATUS IEN and quit for response related errors
 .. S STATIEN=+$P($G(^IBA(355.33,IEN,0)),U,12)
 .. I ",11,12,15,"[(","_STATIEN_",") Q  ; Prevent update for response errors
 .. ;
 .. S OVRFRESH=$P($G(^IBA(355.33,IEN,0)),U,13) ; Freshness OvrRd flag
 .. S DFN=$P($G(^IBA(355.33,IEN,60)),U,1) ; Patient DFN
 .. Q:DFN=""
 .. I $P($G(^DPT(DFN,0)),U,21) Q           ; Exclude if test patient
 .. ;
 .. S PDOD=$P($G(^DPT(DFN,.35)),U,1)\1     ; Patient's date of death
 .. S SRVICEDT=DT I PDOD S SRVICEDT=PDOD             ; Service Date
 .. S FRESHDT=$$FMADD^XLFDT(SRVICEDT,-FRESHDAY)
 .. S PAYERSTR=$$INSERROR^IBCNEUT3("B",IEN)          ; Payer String
 .. S PAYERID=$P(PAYERSTR,U,3),PIEN=$P(PAYERSTR,U,2) ; Payer ID
 .. S SYMBOL=+PAYERSTR                               ; Payer Symbol
 .. ;
 .. ; If payer symbol is returned set symbol in Ins. Buffer and quit
 .. I SYMBOL D BUFF^IBCNEUT2(IEN,SYMBOL) Q
 .. ;
 .. D CLEAR^IBCNEUT4(IEN)                ; remove any existing symbol
 .. ;
 .. ; If no payer ID or no payer IEN is returned quit
 .. I (PAYERID="")!('PIEN) Q
 .. ;
 .. ; Update service date and freshness date based on payer's allowed
 .. ;  date range
 .. D UPDDTS^IBCNEDE6(PIEN,.SRVICEDT,.FRESHDT)
 .. ;
 .. ; Update service dates for inquiries to be transmitted
 .. D TQUPDSV^IBCNEUT5(DFN,PIEN,SRVICEDT)
 .. ;
 .. ; If freshness overide flag is set, file to TQ and quit
 .. I OVRFRESH=1 D  Q
 ... NEW DIE,X,Y,DISYS
 ... S FDA(355.33,IEN_",",.13)="" D FILE^DIE("","FDA") K FDA
 ... D TQ
 .. ;
 .. ; If ADDTQ^IBCNEUT5 is 1 set TQ, otherwise stop processing that entry
 .. I '$$ADDTQ^IBCNEUT5(DFN,PIEN,SRVICEDT,FRESHDAY) Q
 .. ; Check the existing TQ entries to confirm that this buffer IEN is
 .. ; not included
 .. S (TQDT,TQIENS)="",TQOK=1
 .. F  S TQDT=$O(^IBCN(365.1,"AD",DFN,PIEN,TQDT)) Q:'TQDT!'TQOK  D
 ... F  S TQIENS=$O(^IBCN(365.1,"AD",DFN,PIEN,TQDT,TQIENS)) Q:'TQIENS!'TQOK  D
 ....    I $P($G(^IBCN(365.1,TQIENS,0)),U,5)=IEN S TQOK=0 Q
 .. I TQOK D TQ
 Q
TQ ; Determine how many entries to create in the TQ file and set entries
 ;
 S BSID=$P($G(^IBA(355.33,IEN,60)),U,4)     ; Subscriber ID from buffer
 K SIDARRAY
 S SIDDATA=$$SIDCHK^IBCNEDE5(PIEN,DFN,BSID,.SIDARRAY,FRESHDT) ;determine rules to follow
 S SIDACT=$P(SIDDATA,U,1)
 S SIDCNT=$P(SIDDATA,U,2)                   ;Pull cnt of SIDs - shd be 1
 ;
 I SIDACT=3 D BUFF^IBCNEUT2(IEN,18) Q    ; update buffer w/ bang & quit
 S SCNT5=$S(SIDACT=5:1,1:0)
 I CNT+SCNT5+SIDCNT>MAXCNT Q
 S SID=""
 F  S SID=$O(SIDARRAY(SID)) Q:SID=""  D
 . I SIDACT=5 D SET(IEN,OVRFRESH,0,$P(SID,"_")) Q  ; set TQ w/o 'Pass Buffer' flag
 . D SET(IEN,OVRFRESH,1,$P(SID,"_"))       ; set TQ w/ 'Pass Buffer' flag
 I SIDACT=4!(SIDACT=5) D SET(IEN,OVRFRESH,1,"")  ; set TQ w/ 'Pass Buffer' flag
 Q
 ;
RET ; Record Retrieval - Insurance Buffer
 ;
 S ORIGINSR=$P($G(^IBA(355.33,IEN,20)),U,1) ;Original ins. co.
 S ORGRPSTR=$G(^IBA(355.33,IEN,40)) ; Original group string
 S ORGRPNUM=$P(ORGRPSTR,U,3) ;Original group number
 S ORGRPNAM=$P(ORGRPSTR,U,2) ;Original group name
 S ORGSUBCR=$P($G(^IBA(355.33,IEN,60)),U,4) ; Original subscriber
 ;
 Q
 ;
SET(BUFFIEN,OVRFRESH,PASSBUF,SID1) ; Set data and check if set already
 D RET
 ;
 ; The hard coded '1' in the 3rd piece of DATA1 sets the Transmission
 ; status of file 365.1 to "Ready to Transmit"
 S DATA1=DFN_U_PIEN_U_1_U_$G(BUFFIEN)_U_SID1_U_FRESHDT_U_PASSBUF ; SETTQ parameter 1
 ;
 ;The hardcoded '1' in the 1st piece of DATA2 is the value to tell
 ; the file 365.1 that it is the buffer extract.
 S DATA2=1_U_"V"_U_SRVICEDT_U_"" ; SETTQ parameter 2
 ;
 S ORIG=ORIGINSR_U_ORGRPNUM_U_ORGRPNAM_U_ORGSUBCR ; SETTQ parameter 3
 S TQIEN=$$SETTQ^IBCNEDE7(DATA1,DATA2,ORIG,$G(OVRFRESH)) ; File TQ entry
 I TQIEN'="" S CNT=CNT+1 ; If filed increment count
 ;
 Q
