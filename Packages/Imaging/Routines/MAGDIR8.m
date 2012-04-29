MAGDIR8 ;WOIFO/PMK - Read a DICOM image file ; 05/16/2005  09:23
 ;;3.0;IMAGING;**11,51**;26-August-2005
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
 Q
 ; M2MB server
 ;
 ; This routine is invoked by the M2M Broker RPC to process an image.
 ; It extracts each item from the REQUEST list and transfers control
 ; to the appropriate routine to process it.  These routines, in turn,
 ; add items to the RESULT list for processing back on the gateway.
 ;
ENTRY(RESULT,REQUEST) ; RPC = MAG DICOM IMAGE PROCESSING
 N ARGS ; ---- argument string of the REQUEST item
 N DATETIME ;- fileman date/time of the study
 N DCMPID ;--- DICOM patient id
 N DFN ;------ VistA's internal patient identifier
 N ERRCODE ;-- code for an error, if encountered
 N IREQUEST ;- pointer to item in REQUEST array
 N OPCODE ;--- operation code of the REQUEST item
 N RETURN ;--- intermediate return code
 ;
 ; pass the request list and determine what has to be done
 F IREQUEST=2:1:$G(REQUEST(1)) D
 . S OPCODE=$P(REQUEST(IREQUEST),"|")
 . S ARGS=$P(REQUEST(IREQUEST),"|",2,999)
 . I OPCODE="STORE1" D
 . . D ENTRY^MAGDIR81
 . . Q
 . E  I OPCODE="ACQUIRED" D
 . . D ACQUIRED^MAGDIR82
 . . Q
 . E  I OPCODE="PROCESSED" D
 . . D POSTPROC^MAGDIR82
 . . Q
 . E  I OPCODE="CORRECT" D
 . . D ENTRY^MAGDIR83
 . . Q
 . E  I OPCODE="PATIENT SAFETY" D
 . . D ENTRY^MAGDIR84
 . . Q
 . E  I OPCODE="ROLLBACK" D
 . . D ENTRY^MAGDIR85
 . . Q
 . E  I OPCODE="CRASH" D
 . . S I=1/0 ; generate an error on the server to test error trapping
 . . Q
 . E  W !,"#",IREQUEST," -- Ignored: ",REQUEST(IREQUEST)
 . Q
 Q
 ;
ERROR(OPCODE,ERRCODE,MSG,ROUTINE) ; build the RESULT array for the error
 ; this must be called after ^MAGDIRVE is invoked to put the message
 ; into the RESULT array - otherwise the message will be lost
 N I,X
 S X=ERRCODE_"|"_$G(MSG("TITLE"))_"|"_ROUTINE_"|"_$G(MSG("CRITICAL"))
 D RESULT^MAGDIR8(OPCODE,X)
 S I="" F  S I=$O(MSG(I)) Q:'I  D
 . I MSG(I)?1"Problem detected by routine".E  D
 . . ; add error code to the message
 . . S MSG(I)=MSG(I)_"  Error Code: "_ERRCODE
 . . Q
 . D RESULT^MAGDIR8("MSG","|"_MSG(I))
 . Q
 S $P(RESULT(RESULT(1)),"|",2)="END"
 Q
 ;
RESULT(OPCODE,ARGS) ; add an item to the RESULT list
 N LAST
 S LAST=$G(RESULT(1),1) ; first element in array is counter
 S LAST=LAST+1,RESULT(LAST)=OPCODE_"|"_ARGS,RESULT(1)=LAST
 Q
