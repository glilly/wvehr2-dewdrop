SDVWHLI2 ;ENHANCED HL7 RECEIVE APPLICATION DRIVER (CONTINUED) FOR SDAPI and MAKE AN APPOINTMENT API 11/18/06
 ;;5.3;Scheduling;**502**;Aug 13, 1993  ;Build 14
 ; Copyright (C) 2007 WorldVistA
 ;
 ; This program is free software; you can redistribute it and/or modify
 ; it under the terms of the GNU General Public License as published by
 ; the Free Software Foundation; either version 2 of the License, or
 ; (at your option) any later version.
 ;
 ; This program is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ; GNU General Public License for more details.
 ;
 ; You should have received a copy of the GNU General Public License
 ; along with this program; if not, write to the Free Software
 ; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
 ;
OVERX ;
 ;PROCESS COMPLETE MESSAGE NOW
 ;
 ;DETERMINE IF SDAPI REQUEST OR MAKE APPOINTMENT API REQUEST
 ;
 ;
 ; SDAPI PROCESSING HERE BELOW AFTER REQUEST DATA RECEIVED
 ;
 ;
 ;;
 I (IEVN=0)!(IEVN="A19") D   ; SDAPI REQUEST THEN DO APPLICATION ACK WITH "A19" PATIENT INQUIRY APPLICATION ACK
 .I FLDS="" S ERROR=ERROR_"NO FLDS ARRAY ELEMENT PROVIDED"
 .;RESTABLISH SDARRAY(1) TO INTERNAL FM DATES
 .S SDARRAY(1)=STARTIM_";"_ENDTIME
 .;
 .I ERROR'="HOSPLOC NOT DEFINED" I $D(SDARRAY(2)) I CLINIEN'="" S SDARRAY(2)=CLINIEN  ; HOSP LOCATION 
 .I $D(SDARRAY(4)) D
 ..S PATIENID=SDARRAY(4)
 ..;
 ..;PATIENT ID AS SSN. TEST PATIENT NEEDS AT LEAST LEADING NON-ZERO DIGIT
 ..S IDX=0
 ..S IFLAG=0
 ..F  S IDX=$O(^DPT("SSN",IDX)) Q:(IDX="")!(IFLAG=1)  D
 ...I IDX=PATIENID S IFLAG=1
 ..I IFLAG=1 D
 ...S DFN=0
    ...S DFN=$O(^DPT("SSN",PATIENID,DFN))
 ...S SDARRAY(4)=DFN
 ...;
 ..E  D
 ...S ERROR=PATIENID_"PATIENTID NOT DEFINED"
 .I ERROR'="" G OVER
 .;NOW CALL SDAM301 ROUTINE TO GET APPOINTMENTS
 .;
 .S AJJ3CNT1=0
 .F  S AJJ3CNT1=$O(SDARRAY1(AJJ3CNT1)) Q:AJJ3CNT1=""  D
 ..;
 .I $D(SDARRAY("MAX")) D
 ..;;;I SDARRAY("MAX")>2 S SDARRAY("MAX")=2
 .S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY)
 .; 
 .I SDCOUNT>0 D
 ..;
 ..;get patient,or clinic arrays depending on sort by patient or clinic . 
 ..I (DFN'="")&(CLINIEN="") S ORDRSORT="P,C,D"
 ..I (CLINIEN'="")&(DFN="") S ORDRSORT="C,P,D"
 ..I (DFN'="")&(CLINIEN'="") S ORDRSORT="PS,CS,D"
 ..I (DFN="")&(CLINIEN="") S ORDRSORT="CN,PN,D"
 .E  D
 ..; ERROR CONDITION OR NO ELEMENTS RETURNED
OVER .;
 .;DETERMINE IF AN APPLICATION ACK HAS BEEN REQUESTED
 .;I HDR("APP ACK TYPE")="AL" D SDAPIACK
 .D SDAPIACK^SDVWHLI1
 ;
 ; MAKE APPOINTMENT API PROCESSING AFTER REQUEST DATA RECEIVED
 ;
 ;
 I IEVN="A08" D   ;MAKE APPOINTMENT API . NOW DO APPLICATION ACK
 .;CHECK FIRST IF STYP IS DEFINED (NOT "")
 .;
 .;
 .I STYP="" S ERRROR=ERROR_"UNDEFINED STYP"
 .;ALSO CHECK SDLOCATE IS DEFINED (NOT="")
 .I SDLOCATE="" S ERROR=ERROR_"UNDEFINED SDLOCATE"
 .I SDLOCATE'="" D  ; CONVERT TO INTERNAL FORMAT
 ..; CHECK FIRST IF SDLOCATE IN B CROSS-REF
 ..S IDX=""
 ..S IFLAG=0
 ..F  S IDX=$O(^SC("B",IDX)) Q:(IDX="")!(IFLAG=1)  D
 ...I IDX=SDLOCATE S IFLAG=1
 ..I IFLAG=1 D
 ...S CLINIEN=0
    ...S CLINIEN=$O(^SC("B",SDLOCATE,CLINIEN))
 ..E  D
 ...S ERROR=ERROR_"^"_"SDLOCATE NOT DEFINED"
 .;ALSO CHECK FOR SDARRAY("DATA ENTRY CLERK") AND CONVERT TO DUZ
 .I $D(SDARRAY("DATA ENTRY CLERK"))>0 S TEMP=SDARRAY("DATA ENTRY CLERK") D
 ..S TEMPC=0
 ..S IFLAG=0
 ..F  S TEMPC=$O(^VA(200,"B",TEMPC)) Q:(TEMPC="")!(IFLAG=1)  D
 ...I TEMPC=TEMP S IFLAG=1
 ..I IFLAG=1 D
 ...S PCIEN=0
    ...S PCIEN=$O(^VA(200,"B",TEMP,PCIEN))
 ...S SDARRAY("DATA ENTRY CLERK")=PCIEN
 ..E  D
 ...S ERROR=ERROR_"^"_"DATA CLERK UNDEFINED"
 .;PATIENT ID AS SSN. TEST PATIENT NEEDS AT LEAST LEADING NON-ZERO DIGIT
 .;
 .;
 .S IDX=0
 .S IFLAG=0
 .F  S IDX=$O(^DPT("SSN",IDX)) Q:(IDX="")!(IFLAG=1)  D
 ..I IDX=PATIENID S IFLAG=1
 .I IFLAG=1 D
 ..S DFN=0
    ..S DFN=$O(^DPT("SSN",PATIENID,DFN))
 .E  D
 ..S ERROR=ERROR_"^"_"PATIENTID NOT DEFINED"
 .;CONVERT ALL DATE/TIMES TO INTERNAL FM FORMAT
 .I $D(SDARRAY("DATE NOW"))>0 S X=SDARRAY("DATE NOW") D ^%DT S INTE=Y S SDARRAY("DATE NOW")=INTE
 .I $D(SDARRAY("LAB DATE TIME ASSOCIATED"))>0 S X=SDARRAY("LAB DATE TIME ASSOCIATED") S %DT="T" D ^%DT S INTE=Y S SDARRAY("LAB DATE TIME ASSOCIATED")=INTE
 .I $D(SDARRAY("X-RAY DATE TIME ASSOCIATED"))>0 S X=SDARRAY("X-RAY DATE TIME ASSOCIATED") S %DT="T" D ^%DT S INTE=Y S SDARRAY("X-RAY DATE TIME ASSOCIATED")=INTE
 .I $D(SDARRAY("EKG DATE TIME ASSOCIATED"))>0 S X=SDARRAY("EKG DATE TIME ASSOCIATED") S %DT="T" D ^%DT S INTE=Y S SDARRAY("EKG DATE TIME ASSOCIATED")=INTE
 .I $D(SDARRAY("DESIRED DATE TIME OF APPOINTMENT"))>0 S X=SDARRAY("DESIRED DATE TIME OF APPOINTMENT") S %DT="T" D ^%DT S INTE=Y S SDARRAY("DESIRED DATE TIME OF APPOINTMENT")=INTE
 .;
 .I ERROR'="" G OVER1
 .;ALSO UNDERSTAND THAT OPTIONAL SDVWNVAI COULD HAVE BEEN PASSED IN ($D(SDVWNVAI)>0)
 .S XQORMUTE=1    ;SILENT MODE FOR NON-INTERACTIVE MODE W/O WRITE IN XQOR ROUTINES
 .;
 .; MAKE SDVWMKPI CALL HERE
 .S SC=CLINIEN
 .S SD1=$G(SDDATE)      ;FROM PV1
 .;S DFN=      ;FROM PID AND CONVERTED SSN TO DFN ABOVE
 .;STYP SHOULD BE SET BY NOW
 .;AS MINIMALLY BELOW EXAMPLE
 .;S DFN=1 S SD1=3070123.0930 S SC=3 S STYP=3
 .;D NOW^%DTC S X2=X\1 S SDARRAY("DATE NOW")=X2
 .;S SDARRAY("APPT TYPE")=9
    .;S SDARRAY("SCHED_REQ_TYPE")="O"
    .;S SDARRAY("NEXT APPT IND")=0
    .;S SDARRAY("FOLLOWUP VISIT INDICATOR")=0  ; 0 FOR NO
    .;
    .;Q
    .S IER=$$EN^SDVWMKPI(DFN,SD1,SC,STYP,.SDARRAY)
    .;W "IER=",IER
    .S MAKEAPPT=1
 .; GET RETURNS
OVER1 .;
 .;DETERMINE IF AN APPLICATION ACK HAS BEEN REQUESTED
 .;I HDR("APP ACK TYPE")="AL" D MPKIACK
 .;I HDR("ACCEPT ACK TYPE")="AL" D MPKIACK
 .D SDAPIACK^SDVWHLI1 ; SHARE PARTS OF , NOT USE MPKIACK ;
 ;
 ;GO TO NEXT MESSAGE FOR THIS TEST
 ;
 ;
 Q
 ;;;;;OVER2   I (IEVN=0)!(IEVN="A19") K ^TMP($J,"SDAMA301")
 ;;;;Q
 ;;;;H 1 I $$NEXTMSG^HLOPRS(.HLMSTATE,HLMSGIEN,.HDR) G MSG1
 ;;;;S AJJ3CNT=AJJ3CNT+1
 ;;;;I AJJ3CNT>0 Q  ; GET OUT EVENTUALLY AS NON-PERSISTANT TASK
 ;;;;G OVER2
 ;
 ;
 ;
 ;
 Q
MPKIACK ; APPLICATION ACKNOWLEDGE TO MAKE APPOINTMENT API REQUEST
 N EXTRET
 S EXTRET=0
 ;;
 S APPARMS("ACK CODE")="AA"
 S APPARMS("MESSAGE TYPE")="ACK"
 S APPARMS("SECURITY")=MSGCTRL
 ;START THE APPLICATION ACKNOWLEDGE MESSAGE
 ;
 ;Q
 S ERROR1=""
 I (ERETURN'=0)!(ERROR'="")!(IER'=1)!(ERROR1'="") S APPARMS("ACK CODE")="AE"
 I '$$ACK^HLOAPI2(.HLMSTATE,.APPARMS,.ACK,.ERROR1) S ERETURN="START ACK MESSAGE"
 ;
 ;
 ; ADD ERR SEGMENT IF NEEDED
 ;
 I (ERETURN'=0)!(ERROR'="")!(IER'=1)!(ERROR1'="") S EXTRET=$$ERRORW^SDVWHLI1()
 ;
 I (ERETURN'=0)!(ERROR'="")!(EXTRET'=0)!(IER'=1)!(ERROR1'="") S APPARMS("ACK CODE")="AE"
 ;
 ; SEND APPLICATION ACKNOWLEDGEMENT
 ;
 I '$$SENDACK^HLOAPI2(.ACK,.ERROR1) S ERETURN="SENDAPPACK"
 ;
 Q
MSGPROC ; ACK PROCESSING ROUTINE FOR NO RECEIVE ACKS, ETC FOR SDAPI AND MAKE APPOINTMENT API RETURN DATA 
 Q
APPACKRR ;MAIN APPLICATION ACK RESPONSE FOR SDAPI AND MAKE APPOINTMENT API RETURN DATA
 Q
