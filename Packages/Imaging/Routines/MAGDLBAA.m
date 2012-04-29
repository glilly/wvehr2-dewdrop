MAGDLBAA ;WOIFO/LB - Routine to move failed dicom images to ^MAG(2006.575 ; 03/08/2005  07:04
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
MOVE ;called from MAGDIR1 to move entries not matching Radiology case #.
 ;Not done thru FM because the system should be independent.
 ;These variable are needed to be defined before using this routine:
 ;PIDCHECK, FIRSTDCM, IMGSVC, MIDCM, MACHID,ACNUMB, CASENUMB, PNAMEDCM, PID
 ;MODALITY, CASETEXT
 N DATE,REASON,IEN,NIEN,ORIG,DCMPNME,CASE,CASENUM,PATIENT
 D NOW^%DTC S DATE=X
 ;ADD ENTRY
 L +^MAGD(2006.575,0):1E9 ; Background process MUST wait
 S X=$G(^MAGD(2006.575,0))
 S $P(X,"^",1,2)="DICOM FAILED IMAGES^2006.575"
 S IEN=$O(^MAGD(2006.575," "),-1)+1,$P(X,"^",3)=IEN
 S $P(X,"^",4)=$P(X,"^",4)+1 ; # entries
 S ^MAGD(2006.575,0)=X
 ;
 S REASON=$P(PIDCHECK,",",2)
 S PATIENT=LASTDCM_","_FIRSTDCM_$S($L(MIDCM)>0:" "_MIDCM,1:"")
 S MACHID=$G(MACHID,"A")
 ; PNAMEDCM usually contains an "^" between last & first name
 ; CHANGE ^ TO ~
 S CASE=$TR(ACNUMB,"^","~"),CASENUM=$TR(CASENUMB,"^","~")
 S DCMPNME=$TR(PNAMEDCM,"^","~")
 S ^MAGD(2006.575,IEN,0)=FROMPATH_"^"_REASON_"^"_PID_"^"_PATIENT_"^"_DCMPNME
 S ^MAGD(2006.575,IEN,1)=CASE_"^"_CASENUM_"^"_DATE_"^"_MACHID_"^"_LOCATION
 S ^MAGD(2006.575,IEN,"AIUID")=$G(IMAGEUID)
 S ^MAGD(2006.575,IEN,"ASUID")=STUDYUID
 S ^MAGD(2006.575,IEN,"AMFG")=$G(INSTNAME)_"^"_$G(ROWS)_"^"_$G(COLUMNS)_"^"_$G(OFFSET)_"^"_$G(MODIEN)_"^"_$G(MODALITY)_"^"_$$UP^MAGDFCNV($G(MFGR))_"^"_$$UP^MAGDFCNV($G(MODEL))_"^"_LOCATION
 S ^MAGD(2006.575,IEN,"ACSTXT")=$G(CASETEXT)
 ; Image type can be RAD, MEDICINE, SURGERY, etc.
 S ^MAGD(2006.575,IEN,"TYPE")=$G(IMGSVC)
 ;Setting xrefs
 S ^MAGD(2006.575,"B",FROMPATH,IEN)=""
 ; Clean up---no longer need this cross reference
 K ^MAGD(2006.575,"D") ; Used for Consults only
 L -^MAGD(2006.575,0)
 ;
 ;The following xref ("F") will be set on the 1st entry having a unique
 ;STUDYUID. The remaining entries with the same # will be added
 ;to the RELATED IMAGES multiple field for the entry that set the
 ;F xref.
 S ORIG=0
 I '$D(^MAGD(2006.575,"F",LOCATION,STUDYUID)) D  Q  ; Quit if 1st entry
 . S ^MAGD(2006.575,"F",LOCATION,STUDYUID,IEN)=""
 . Q
 S ORIG=$O(^MAGD(2006.575,"F",LOCATION,STUDYUID,0))
 Q:'ORIG
 I ORIG'=IEN D
 . I '$D(^MAGD(2006.575,ORIG,"RLATE",0)) D
 . . S ^MAGD(2006.575,ORIG,"RLATE",0)="^2006.57526PA^^"
 . S NIEN=$P(^MAGD(2006.575,ORIG,"RLATE",0),"^",3),NIEN=NIEN+1
 . S $P(^MAGD(2006.575,ORIG,"RLATE",0),"^",3)=NIEN ; #next ien entry
 . S $P(^MAGD(2006.575,ORIG,"RLATE",0),"^",4)=$P(^MAGD(2006.575,ORIG,"RLATE",0),"^",4)+1 ; #record for multiple field
 . S ^MAGD(2006.575,ORIG,"RLATE",NIEN,0)=IEN
 . S ^MAGD(2006.575,ORIG,"RLATE","B",IEN,NIEN)=""
 . Q
 Q
 ;
