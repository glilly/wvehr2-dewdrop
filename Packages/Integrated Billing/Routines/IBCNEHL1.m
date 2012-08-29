IBCNEHL1 ;DAOU/ALA - HL7 Process Incoming RPI Messages ;26-JUN-2002  ; Compiled December 16, 2004 15:29:01
 ;;2.0;INTEGRATED BILLING;**300,345**;21-MAR-94;Build 28
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ;**Program Description**
 ;  This program will process incoming IIV response messages.
 ;  This includes updating the record in the IIV Response File,
 ;  updating the Buffer record (if there is one and creating a new
 ;  one if there isn't) with the appropriate Buffer Symbol and data
 ;  
 ;  This routine is based on IBCNEHLR which was introduced with patch 184, and subsequently
 ;  patched with patches 252 and 271.  IBCNEHLR is obsolete and deleted with patch 300.
 ;
 ;**Modified by  Date        Reason
 ;  DAOU/BHS     10/04/2002  Added logic to update the service date in
 ;                           the TQ entry so long as the Error Action is
 ;                           not Please submit original transaction.
 ;  DAOU/DB      03/11/2004  Added logic to utilize new status flag
 ;                           transmitted to VistA from EC (IIVSTAT)
 ;               03/15/2004  Update other retries to comm failure (if
 ;                           not response rcvd)
 ;  DAOU/BEE     07/14/2004  Cleaned up routine - Made more readable
 ;                           Cleaned up variables                          
 ;  PROXICOM/RTO 08/23/2006  Fixed logic issue when determining whether
 ;                           to update a buffer entry
 ;
 ;  Variables
 ;    SEG = HL7 Segment Name
 ;    MSGID = Original Message Control ID
 ;    ACK =  Acknowledgment (AA=Accepted, AE=Error)
 ;    ERTXT = Error Message Text
 ;    ERFLG = Error quit flag
 ;    ERACT = Error Action
 ;    ERCON = Error Condition
 ;    RIEN = Response Record IEN
 ;    IIVSTAT = EC generated flag interpreting status of response
 ;              1 = +
 ;              6 = -
 ;              V = #
 ;    MAP = Array that maps EC's IIV status flag to IIV STATUS TABLE (#365.15)   IEN
 ;
EN ; Entry Point
 N EBDA,ERFLG,ERROR,HCT,IIVSTAT,IRIEN,MAP,MGRP,RIEN,RSUPDT,SEG,SUBID,TRACE,UP,ACK
 S ERFLG=0,MGRP=$$MGRP^IBCNEUT5(),HCT=1,SUBID="",IIVSTAT=""
 ;
 ; Create map from EC to VistA
 S MAP(1)=8,MAP(6)=9,MAP("V")=21
 ;
 ;  Loop through the message and find each segment for processing
 F  S HCT=$O(^TMP($J,"IBCNEHLI",HCT)) Q:HCT=""  D  Q:ERFLG
 . D SPAR^IBCNEHLU
 . S SEG=$G(IBSEG(1))
 . ;
 . I SEG="MSA" D MSA^IBCNEHL2(.ERACT,.ERCON,.ERROR,.ERTXT,.IBSEG,MGRP,.RIEN,.TRACE) Q:ERFLG
 . ;
 . ;  Contact Segment
 . I SEG="CTD" D CTD^IBCNEHL2(.ERROR,.IBSEG,RIEN)
 . ;
 . ;  Patient Segment
 . I SEG="PID" D PID^IBCNEHL2(.ERFLG,.ERROR,.IBSEG,RIEN)
 . ;
 . ;  Guarantor Segment
 . I SEG="GT1" D GT1^IBCNEHL2(.ERROR,.IBSEG,RIEN,.SUBID)
 . ;
 . ;  Insurance Segment
 . I SEG="IN1" D IN1^IBCNEHL2(.ERROR,.IBSEG,RIEN,SUBID)
 . ;
 . ;  Addt'l Insurance Segment
 . ;I SEG="IN2" ; for future expansion, add IN2 tag to IBCNEHL2
 . ;
 . ;  Addt'l Insurance - Cert Segment
 . I SEG="IN3" D IN3^IBCNEHL2(.ERROR,.IBSEG,RIEN)
 . ;
 . ;  Eligibility/Benefit Segment
 . I SEG="ZEB" D ZEB^IBCNEHL2(.EBDA,.ERROR,.IBSEG,RIEN)
 . ;
 . ;  Notes Segment
 . I SEG="NTE" D NTE^IBCNEHL2(EBDA,.IBSEG,RIEN)
 ;
 D FIL
 Q
 ;
 ; =================================================================
FIL ;  Finish processing the response message
 ;
 ; Input Variables
 ; ERACT, ERFLG, ERROR, IIVSTAT, MAP, RIEN, TRACE
 ;
 ; If no record IEN, quit
 I $G(RIEN)="" Q
 ;
 N BUFF,DFN,FILEIT,IBFDA,IBIEN,IBQFL,RDAT0,RSRVDT,RSTYPE,SYMBOL,TQDATA,TQN,TQSRVDT
 ; Initialize variables from the Response File
 S RDAT0=$G(^IBCN(365,RIEN,0)),TQN=$P(RDAT0,U,5)
 S TQDATA=$G(^IBCN(365.1,TQN,0))
 S IBQFL=$P(TQDATA,U,11)
 S DFN=$P(RDAT0,U,2),BUFF=$P(RDAT0,U,4)
 S IBIEN=$P(TQDATA,U,5),RSTYPE=$P(RDAT0,U,10)
 S RSRVDT=$P($G(^IBCN(365,RIEN,1)),U,10)
 ;
 ; If an unknown error action or an error filing the response message,
 ; send a warning email message
 ; Note - A call to UEACT will always set ERFLAG=1
 I ",W,X,R,P,C,N,Y,S,"'[(","_$G(ERACT)_",")&($G(ERACT)'="")!$D(ERROR) D UEACT
 ;
 ; If an error occurred, processing complete
 I $G(ERFLG)=1 Q
 ;
 ;  For an original response, set the Transmission Queue Status to 'Response Received' &
 ;  update remaining retries to comm failure (5)
 I $G(RSTYPE)="O" D SST^IBCNEUT2(TQN,3),RSTA^IBCNEUT7(TQN)
 ;
 ; Update the TQ service date to the date in the response file
 ; if they are different AND the Error Action <>
 ; 'P' for 'Please submit original transaction'
 ;
 ; *** Temporary change to suppress update of service & freshness dates.
 ; *** To reinstate, remove comment (;) from next line.
 ;I TQN'="",$G(RSTYPE)="O" D
 ;. S TQSRVDT=$P($G(^IBCN(365.1,TQN,0)),U,12)
 ;. I RSRVDT'="",TQSRVDT'=RSRVDT,$G(ERACT)'="P" D SAVETQ^IBCNEUT2(TQN,RSRVDT)
 ;. ; update freshness date by same delta
 ;. D SAVFRSH^IBCNEUT5(TQN,+$$FMDIFF^XLFDT(RSRVDT,TQSRVDT,1))
 ;
 ;  Check for error action
 I $G(ERACT)'=""!($G(ERTXT)'="") D ERROR^IBCNEHL3(TQN,ERACT,ERCON,TRACE) G FILX
 ;
 ; Stop processing if identification response and not an active policy
 S FILEIT=1
 I $G(IIVSTAT)=6,TQN]"" D
 . I TQDATA="" Q
 . I IBQFL'="I" Q
 . S FILEIT=0
 I 'FILEIT G FILX
 ;
 ;  If there is an associated buffer entry & one or both of the following
 ;  is true, stop filing (don't update buffer entry)
 ;  1) buffer status is not 'Entered'
 ;  2) the buffer entry is verified (* symbol)
 I BUFF'="",($P(^IBA(355.33,BUFF,0),U,4)'="E")!($$SYMBOL^IBCNBLL(BUFF)="*") G FILX
 ;
 ;  Set buffer symbol based on value returned from EC
 S SYMBOL=MAP(IIVSTAT)
 ;
 ;  If there is an associated buffer entry, update the buffer entry w/
 ;  response data
 I BUFF'="" D RP^IBCNEBF(RIEN,"",BUFF)
 ;
 ;  If no associated buffer entry, create one & populate w/ response
 ;  data (routine call sets IBFDA)
 I BUFF="" D RP^IBCNEBF(RIEN,1) S BUFF=+IBFDA,UP(365,RIEN_",",.04)=BUFF
 ;
 ;  Set eIV Processed Date to now
 S UP(355.33,BUFF_",",.15)=$$NOW^XLFDT()
 D FILE^DIE("I","UP","ERROR")
FILX ;
 Q
 ;
 ; =================================================================
WARN ;  Create and send a response processing error warning message
 ;
 ; Input Variables
 ; ERROR, TRACE
 ;
 ; Output Variables
 ; ERFLG=1
 ;
 N MCT,MSG,SUBCNT,VEN,XMY
 S VEN=0,MCT=8,ERFLG=1,SUBCNT=""
 S MSG(1)="IMPORTANT: Error While Processing Response Message from the EC"
 S MSG(2)="-------------------------------------------------------------"
 S MSG(3)="*** IRM *** Please log a NOIS because the"
 S MSG(4)="response message received from the Eligibility Communicator"
 S MSG(5)="could not be processed.  Programming changes may be necessary"
 S MSG(6)="to properly handle the response."
 S MSG(7)="The associated Trace # is "_$S($G(TRACE)="":"Unknown",1:TRACE)_". If applicable,"
 S MSG(8)="please review the response with the eIV Response Report by Trace#."
 F  S VEN=$O(ERROR("DIERR",VEN)) Q:'VEN  D
 . F  S SUBCNT=$O(ERROR("DIERR",VEN,"TEXT",SUBCNT)) Q:'SUBCNT  D
 . . S MCT=MCT+1,MSG(MCT)=ERROR("DIERR",VEN,"TEXT",SUBCNT)
 . S MCT=MCT+1,MSG(MCT)=" "
 D MSG^IBCNEUT5(MGRP,MSG(1),"MSG(",,.XMY)
 Q
 ;
 ; =================================================================
UEACT ; Send warning msg if Unknown Error Action Code was received or
 ; encountered problem filing date
 ;
 ; Input Variables
 ; ERROR, IBIEN, IBQFL, RIEN, RSTYPE, TQDATA, TRACE
 ;
 ; Output Variables
 ; ERFLG=1 (SET IN WARN TAG)
 ;
 N DFN,SYMBOL
 D WARN  ; send warning msg
 ;
 ; If the response could not be created or there is no associated TQ entry, stop processing
 I '$G(RIEN)!(TQDATA="") Q
 ;
 ;  For an original response, set the Transmission Queue Status to 'Response Received' &
 ;  update remaining retries to comm failure (5)
 I $G(RSTYPE)="O" D SST^IBCNEUT2(TQN,3),RSTA^IBCNEUT7(TQN)
 ;
 ; If it is an identification and policy is not active don't
 ; create buffer entry
 I IBQFL="I",IIVSTAT'=1 Q
 ;
 ; If unsolicited message or no buffer in TQ, create new buffer entry
 I RSTYPE="U" S IBIEN=""
 I IBIEN="" D  Q
 .  S DFN=$P(TQDATA,U,2)        ; Determine Patient DFN
 .  S SYMBOL=22 D BUF^IBCNEHL3  ; Create a new buffer entry
 ;
 ;Update buffer symbol
 D BUFF^IBCNEUT2(IBIEN,22)
 ;
 Q
