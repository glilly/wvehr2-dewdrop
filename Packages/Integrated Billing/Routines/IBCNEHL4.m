IBCNEHL4 ;DAOU/ALA - HL7 Process Incoming RPI Msgs (cont.) ;26-JUN-2002  ; Compiled December 16, 2004 15:35:46
 ;;2.0;INTEGRATED BILLING;**300**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ;  This pgm will process the non-repeating segments of the
 ;  incoming IIV response msgs.
 ;  It was separated out from IBCNEHL2 to conserve space.
 ;  
 ;  This routine is based on IBCNEHLP which was introduced with patch 184, and subsequently
 ;  patched with patches 252 and 271.  IBCNEHLP is obsolete and deleted with patch 300.
 ;
 ; * Each of these tags are called by IBCNEHL2.
 ;
 ;  Variables
 ;    SEG = HL7 Seg Name
 ;    MSGID = Original Msg Control ID
 ;    ACK =  Acknowledgment (AA=Accepted, AE=Error)
 ;    ERTXT = Error Msg Text
 ;    ERFLG = Error quit flag
 ;    ERACT = Error Action
 ;    ERCON = Error Condition
 ;    RIEN = Response Record IEN
 ;    IBSEG = Array of the segment
 ;
 Q  ; No direct calls
 ;
MSA ;  Process the MSA seg
 ;
 ;  Input:
 ;  IBSEG,MGRP
 ;
 ;  Output:
 ;  ERACT,ERCON,ERROR,ERTXT,RIEN,TRACE,ACK
 ;
 N MSGID,RSUPDT,VRFDT
 S ACK=$G(IBSEG(2)),MSGID=$G(IBSEG(3)),TRACE=$G(IBSEG(4))
 S ERTXT=$$DECHL7^IBCNEHL2($P($G(IBSEG(7)),$E(HLECH),2)),ERACT=$G(IBSEG(6)),ERCON=$P($G(IBSEG(7)),$E(HLECH),1)
 ;
 ; If no Control Id, send Mailman error msg
 I MSGID="" D ERRMSA(TRACE,MGRP) S ERFLG=1 G MSAX
 ;
 ; Check for msg id/payer combination and get response IEN
 D PCK^IBCNEHL3
 ;
 ; If no record IEN, quit
 I $G(RIEN)="" G MSAX
 ;
 ; Update record w/info
 S RSUPDT(365,RIEN_",",.09)=TRACE,RSUPDT(365,RIEN_",",.06)=3
 S RSUPDT(365,RIEN_",",4.01)=ERTXT
 S VRFDT=$$NOW^XLFDT(),RSUPDT(365,RIEN_",",.07)=VRFDT
 ;
 ; Update w/internal values
 D FILE^DIE("I","RSUPDT","ERROR")
 ;
 S RSUPDT(365,RIEN_",",1.14)=ERCON,RSUPDT(365,RIEN_",",1.15)=ERACT
 ;
 ; Update w/external values
 D FILE^DIE("E","RSUPDT","ERROR")
MSAX ;
 Q
 ;
ERRMSA(TRACE,MGRP) ; Msg Control Id is blank -  Send Mailman error msg
 ;
 N HCT,ICN,MSG,MSGCT,NAME,XMSUB
 ;
 ;1st find the PID seg to extract ICN and patient name
 D GTICNM^IBCNEHLU(.ICN,.NAME)
 ;
 ;Send the Mailman error msg
 S XMSUB="Message Control Id Field is Blank",MSGCT=$S(TRACE="":4,1:3)
 S MSG(1)="A response was received w/a blank Message Control Id"
 I TRACE="" S MSG(1)=MSG(1)_" and Trace #"
 S MSG(2)="for "_$S(TRACE'="":"Trace #: "_TRACE_", ",1:"")_"ICN #: "_ICN_", Patient: "_NAME_"."
 I TRACE="" D
 . S MSG(3)="It is likely that there are communication issues with the EC."
 S MSG(MSGCT)="This response cannot be processed.  Please log a NOIS."
 D MSG^IBCNEUT5(MGRP,XMSUB,"MSG(")
 Q
 ;
PID ;  Process the PID seg
 N DFN,DOB,DOD,ICN,LFAC,LUPDT,NAME,RSUPDT,SEX,SSN,XDFN,IDLIST
 N SUBCNT,SUBC,SUBCID,SUBCDATA,IERN
 ;
 S ERFLG=0
 S DOB=$G(IBSEG(8)),SEX=$G(IBSEG(9))
 S NAME=$G(IBSEG(6))
 S DOD=$G(IBSEG(30)),LUPDT=$G(IBSEG(34)),LFAC=$G(IBSEG(35))
 ;
 ; Parse Repeating ID field to fill in other identifiers
 S (ICN,SSN,DFN)=""
 S IDLIST=$G(IBSEG(4))
 F SUBCNT=1:1:$L(IDLIST,$E(HLECH,2,2)) D
 . S SUBC=$P(IDLIST,$E(HLECH,2,2),SUBCNT)
 . S SUBCID=$P(SUBC,$E(HLECH),5)    ; Identifier Type Code
 . S SUBCDATA=$P(SUBC,$E(HLECH),1) ; Data Value
 . I SUBCID="PI" S DFN=SUBCDATA
 . I SUBCID="SS" S SSN=SUBCDATA
 . I SUBCID="NI" S ICN=SUBCDATA
 ;
 ;  Convert data from HL7 format to VistA format
 S NAME=$$DECHL7^IBCNEHL2($$FMNAME^HLFNC(NAME,HLECH))
 S DOD=$$FMDATE^HLFNC(DOD),DOB=$$FMDATE^HLFNC(DOB),LUPDT=$$FMDATE^HLFNC(LUPDT)
 ;
 ; Use ICN to find the patients DFN at this site
 I ICN'="" S XDFN=$$GETDFN^MPIF001(ICN)
 I +$G(XDFN)'>0,+$G(ICN)>0 D  Q
 . S ERFLG=1,IERN=$$ERRN^IBCNEUT7("ERROR(""DIERR"")")
 . S ERROR("DIERR",IERN,"TEXT",1)="Unable to determine the patient's DFN value for this site."
 . S ERROR("DIERR",IERN,"TEXT",2)=" The ICN for the patient in this response is ICN: "_ICN
 . S ERROR("DIERR",IERN,"TEXT",3)=" eIIV was unable to file the response information."
 ;
 I +ICN>0 S DFN=XDFN
 ;
 ;  Perform date of death check
 I DOD'="" D DODCK^IBCNEHLU(DFN,DOD,MGRP,NAME,RIEN,SSN)
 ;
 I $P(^IBCN(365,RIEN,0),U,2)="" S RSUPDT(365,RIEN_",",.02)=DFN
 S RSUPDT(365,RIEN_",",1.02)=DOB,RSUPDT(365,RIEN_",",1.04)=SEX
 S RSUPDT(365,RIEN_",",1.03)=SSN,RSUPDT(365,RIEN_",",1.16)=DOD
 S RSUPDT(365,RIEN_",",1.01)=NAME,RSUPDT(365,RIEN_",",1.08)="v"
 S RSUPDT(365,RIEN_",",1.09)="01"
 D FILE^DIE("I","RSUPDT","ERROR")
PIDX ;
 Q
 ;
GT1 ;  Process the GT1 Guarantor seg
 ;
 ; Input:
 ; IBSEG,RIEN
 ;
 ; Output:
 ; ERROR,SUBID
 ;
 N DOB,NAME,RSUPDT,SEX,SSN,SUBIDC
 S NAME=$G(IBSEG(4)),DOB=$G(IBSEG(9)),SEX=$G(IBSEG(10))
 S SSN=$G(IBSEG(13))
 ; 
 S SUBIDC=$G(IBSEG(3))  ; Raw field with sub-comp.
 S SUBID=$P(SUBIDC,$E(HLECH),1)
 S SUBID=$$DECHL7^IBCNEHL2(SUBID)
 ;
 S DOB=$$FMDATE^HLFNC(DOB),NAME=$$DECHL7^IBCNEHL2($$FMNAME^HLFNC(NAME,HLECH))
 ;
 S RSUPDT(365,RIEN_",",1.01)=NAME,RSUPDT(365,RIEN_",",1.08)=""
 S RSUPDT(365,RIEN_",",1.02)=DOB,RSUPDT(365,RIEN_",",1.04)=SEX
 S RSUPDT(365,RIEN_",",1.03)=SSN
 S RSUPDT(365,RIEN_",",1.18)=SUBID
 D FILE^DIE("I","RSUPDT","ERROR")
GT1X ;
 Q
