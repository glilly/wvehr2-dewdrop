PPPGET7 ;ALB/DMB - EXTRACT UTILITIES ; 4/30/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**1,10,19**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
GETVIS(PATDFN,TARRY) ; Get the other visit information.
 ;
 ; This functions builds an array with the patient visit information
 ; which can then pe printed or displayed to the user.
 ; It returns a 1 if there is pharmacy data available from any
 ; of the other facilties or a zero if not.
 ;
 ; The Output array looks like -->
 ;
 ; @TARRY@(StationName,0)=DataAvailable^PDXDataFileIFN^StationNumber
 ; @TARRY@(StationName,1)=PatientName^DateOfBirth
 ; @TARRY@(StationName,2)=StationName^LastPDXDate^LastPDXStatus^PharmacyDataAvailable
 ;
 N DATAV,IFN,PDXDATA,PDXNODE,POVNAME,POVNUM,POVPTR,U,DI,C,D0,I
 ;
 S U="^",DATAV=0
 ;
 F IFN=0:0 S IFN=$O(^PPP(1020.2,"B",PATDFN,IFN)) Q:IFN=""  D
 .;
 .;  -- Check for bad pointer
 .I '$D(^PPP(1020.2,IFN,0)) Q
 .;
 .; -- Get Place Of Visit
 .S POVPTR=+$P(^PPP(1020.2,IFN,0),U,2)
 .S POVNAME=$$GETSTANM^PPPGET1(POVPTR)
 .S POVNUM=(POVPTR) ;dave
 .I POVNAME="" S POVNAME="NOT FOUND"
 .I POVNUM<0 S POVNUM=0
 .;
 .; Get PDX Pointer Data
 .;
 .S PDXNODE=$$GETPDXND(IFN)
 .Q:$P(PDXNODE,U,1)<1
 .;
 .; Get the PDX Pharmacy Data
 .;
 .S PDXDATA=$$PDXDAT^PPPDSP2(+PDXNODE)
 .Q:$P(PDXDATA,U,1)<1
 .;
 .; Now Store the values in the array
 .;
 .S @TARRY@(POVNAME,0)=+$P(PDXDATA,U)_U_$P(PDXNODE,U)_U_POVNUM
 .S @TARRY@(POVNAME,1)=$P(PDXDATA,U,2)_U_$P(PDXDATA,U,3)
 .S @TARRY@(POVNAME,2)=POVNAME_U_$$SLASHDT^PPPCNV1($P(PDXNODE,U,3))_U_$P(PDXNODE,U,2)_U_$S(+$P(PDXDATA,U)<1:"NOT ",1:"")_"AVAILABLE"
 .I +$P(PDXDATA,U)=1 S DATAV=1
 ;
 Q DATAV
 ;
GETPDXND(FFXIFN) ; Get the PDX node
 ;
 ; This function returns the data in the PDX node of the
 ; FFX file.
 ;
 ; The return format is:
 ;    PDX_POINTER^STATUS_DESCRIPTION^LAST_PDX_DATE or
 ;    -1 for entry not found
 ;
 ; The date is returned in internal FM format.
 ;
 N U,PDXNODE,PDXPTR,PDXDATE,PDXSTPTR,PDXSTAT
 ;
 I $G(FFXIFN)="" Q -1
 S U="^"
 ;
 S PDXNODE=$G(^PPP(1020.2,FFXIFN,1))
 S PDXPTR=+$P(PDXNODE,U)
 S PDXDATE=+$P(PDXNODE,U,2)
 S PDXSTPTR=+$P(PDXNODE,U,3)
 I PDXSTPTR=0 S PDXSTAT="NONE"
 E  S PDXSTAT=$P($$GETPDXST(PDXSTPTR),U,2)
 Q PDXPTR_U_PDXSTAT_U_PDXDATE
 ;
GETPDXST(STATPTR) ; Get the PDX status from the status file
 ;
 ; This function looks up the status code and the description
 ; from the IFN of the PDX Status File.
 ;
 ; The return format is:
 ;    STATUS_CODE^DESCRIPTION  or
 ;    -1 for status not found or not supported
 ;
 Q:('(+$G(STATPTR))) "-1^Unknown"
 N STATUS,TEXT
 ;GET STATUS CODE
 S STATUS=$P($G(^VAT(394.85,STATPTR,0)),"^",1)
 Q:(STATUS="") "-1^Unknown"
 ;DETERMINE DESCRIPTION
 S TEXT=""
 S:(STATUS="VAQ-AMBIG") TEXT="Patient was ambiguous"
 S:(STATUS="VAQ-AUTO") TEXT="Processing automatically"
 S:(STATUS="VAQ-NTFND") TEXT="Patient was not found"
 S:(STATUS="VAQ-PROC") TEXT="Requires processing"
 S:(STATUS="VAQ-REJ") TEXT="Information not returned"
 S:(STATUS="VAQ-RQACK") TEXT="Request waiting for processing"
 S:(STATUS="VAQ-RQST") TEXT="Request has been sent"
 S:(STATUS="VAQ-RSLT") TEXT="Results received"
 S:(STATUS="VAQ-RTRNS") TEXT="Retransmitting"
 S:(STATUS="VAQ-TUNSL") TEXT="Unsolicited has been sent"
 S:(STATUS="VAQ-UNACK") TEXT="Unsolicited sent/received"
 S:(STATUS="VAQ-UNSOL") TEXT="Unsolicited PDX"
 S:(TEXT="") STATUS="-1",TEXT="Unknown"
 Q (STATUS_"^"_TEXT)
 ;
GETSTPTR(CODE) ; Get pointer to PDX status
 ;INPUT  : CODE - Code that identifies PDX status
 ;OUTPUT : Pointer to PDX status
 ;         If status not found, returns -1
 ;
 ;CHECK INPUT
 Q:($G(CODE)="") -1
 ;DECLARE VARIABLES
 N POINTER
 ;GET POINTER
 S POINTER=+$O(^VAT(394.85,"B",CODE,""))
 Q:('POINTER) -1
 ;VERIFY POINTER
 Q:($P($G(^VAT(394.85,POINTER,0)),"^",1)'=CODE) -1
 Q POINTER
