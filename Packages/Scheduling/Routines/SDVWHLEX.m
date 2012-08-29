SDVWHLEX ;ENHANCED HL7 ACK RECEIVERS FOR SDAPI and MAKE AN APPOINTMENT REQUEST 11/18/06
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
MSGPROC ; ACK PROCESSING ROUTINE FOR NO RECEIVE ACKS, ETC FOR SDAPI AND MAKE APPOINTMENT API RETURN DATA 
 Q
APPACKRR ;MAIN APPLICATION ACK RESPONSE FOR SDAPI AND MAKE APPOINTMENT API RETURN DATA 
 N IER,MSGCTRL,SEG,HLMSTATE,HDR,CONTIN
APPACKR2 ;
 S CONTIN=0
 S MSGCTRL=0
 S IER=$$APPACKR1(.MSGCTRL,.CONTIN)
 I (MSGCTRL'=0) S ^XTMP(MSGCTRL,"RETURN")=IER
 I CONTIN=1 G APPACKR2
 Q
APPACKR1(MSGCTRL,CONTIN) ;APPLICATION ACK RESPONSE FOR SDAPI RETURN DATA AND MAKE APPOINTMENT API 
 ; AND MAKE APPT API ACK 
 N HLVWNOVA,HLMSGTMP,AJJ3CNT,AJJ3CNT1,AJJ3CNT2,SSNPATN,AJJ3VIS
 N APPARMS,ERROR,HLMSGIEN,WHO,QRDSORT,SORTORDR,OVERAPPT ;
 N SEGTYPE,IRECAPP,ISNDFAC,IEVN,IFLAGA19,IFLAGACK,POSITION
 N PATIENID,PATIENT,SSN,PATIENTC,SDLOCATI,PRIMCRED,PRIMSTOP
 N SDDATE,ELIGIB,EXPECTDT,APPTST,DATEAPTM
 N PIDVALUE,PV1VALUE,PV2VALUE
 N SDARRAY,SDCOUNT,ERR,TEMP8
 N SDLOCATE,HOSPLOC,ORDRSORT,MSGMAKAP,COMMENT,X,Y,MSGCTRL1
 N MSGCTRX,HLMSGIE1
 ;APPLICATION ACK REPONSE ROUTINE
 ;
 ;FOR SDAPI APPLICATION ACK BELOW
 ;INPUT
 ;           
 ;OUTPUT IF NO ERRORS AND SDCOUNT RETURNED >0 ( ALL FIELDS IN EXTERNAL FORMAT BELOW)
 ;.I $E(ORDRSORT,1,1)="P"
 ;..S ^XTMP(MSGCTRL,"SDAMA301",SSN,SDLOCATE,SDDATE)=SDAPPNT (UP TO 20 PIECES OF 20 SPECIFIED "FLDS: FIELDS IN SDARRAY("FLDS")
 ;.I $E(ORDRSORT,1,1)="C"
 ;..S ^XTMP(MSGCTRL,"SDAMA301",SDLOCATE,SSN,SDDATE)=SDAPPNT (UP TO 20 PIECES OF 20 SPECIFIED "FLDS: FIELDS IN SDARRAY("FLDS")
 ;
 ; AND S ^XTMP(MSGCTRL,"RETURN")=IER  RETURNED 
 ;
 ;AS EXPLAINED IN CODE BELOW
 ; FOR ELEMENTS RANGES OF SDLOCATE ( HOSPITAL LOCATION (CLINIC) EXTERNAL FORMAT ) IN APPOINTMENTS RETURNED
 ;              RANGES OF SSN FOR PATIENT'S UNIQUE SSN IN APPOINTMENTS RETURNED
 ;
 ; 
 ;RETURN  POSITION_"^"_SDCOUNT_"^"_HDR("APP ACK TYPE") 
 ;                            POSITION IS NUMBER OF RETURNED APPOINTMENTS/VISITS
 ;
 ;                            SDCOUNT IS SAME UNLESS ERROR 
 ;                            WITH ERROR RETURNS AS 
 ;                            FROM $$SDAPI^SDAM301 AND OTHER ERRORS FOUND FROM RECEIVING APPLICATION
 ;
 ;                            APP ACK TYPE ACTUALLY RETURNED, IE "AA"OR "AE"
 ;
 ;        OR ONE OF THE FOLLOWING FROM HIS REPONSE ROUTINE TO THE APPLICATION ACKNOWLEDGE TO THE 
 ;                            REQUESTING APPLICATION
 ;                                            
 ;        "STARTMSG" 
 ;        "ERR"_$$GET^HLOPRS(.SEQ,1)
 ;        "NOTRETURNED ACK"
 ;        "HOSPLOC"
 ;         VWSD
 ;PARSE ACK MESSAGE WITH REPEATING ADT RESPONSE (PID,PV1,PV2,NTE,NTE)
 ;WITH EVENT TYPE A19 WITH APPLICATION REPLY TO PATIENT INQUIRY REQUEST 
 ;
 ;FOR MAKE APPT API RETURN   COMMENT_"^"_HDR("APP ACK TYPE") 
 ;                 WHERE COMMENT IS AS RETURNED FROM VWSDMKPI CALL RETURN
 ;
 ;
 ;
 ;PASS THE HEADER AND RETURN INDIVIDUAL VALUES
 ;
 S HLVWNOVA=1  ; ALLOW NON-VA STATION NODE WITH ASSOCIATED INSTITUTION 
 ; FOR DETERMINING FACILITY LINK WHEN SENDING APPLICATION BECOMES RECEIVING 
 ; APPLICATION, AND TO FIGURE "SENDING FACILITY LINK" 
 S HLMSGTMP="AC" ;200000000000  
 ;^HLB("AC","HL7.VWSD INTERNAL MULTILISTENER:5026VWSD HLO EXT100 XXXXX",200000000XXX)
 S HLMSGIEN=$O(^HLB(HLMSGTMP),-1)
 S HDR="" S HLMSTATE=""
 ;
 I '$$STARTMSG^HLOPRS(.HLMSTATE,HLMSGIEN,.HDR) Q "STARTMSG"
 ;
 ;
MSG1 ;CHECK RECEIVING APPLICATION
 ;;S IRECAPP=HDR("RECEIVING APPLICATION")
 ;W !,"IRECAPP=",IRECAPP
 ;;S ISNDFAC=HDR("FACILITY LINK NAME")
 S MSGCTRL1=HDR("SECURITY")
 ;
 ;CHECK TO SEE IF RETURN FROM MAKE APPT ( HAS # AND ACK CONDITION AA OR AEFOLLOWING)
 S MSGCTRX=""
 I MSGCTRL1["#" D
 . S MSGCTRL=$P(MSGCTRL1,"#",1)
 E  D
 .S MSGCTRX=MSGCTRL1
 ;
 S IFLAGA19=0
 S POSITION=0
 S IEVN=0
 S SDCOUNT=0
 S SDLOCATE=""
 S ORDRSORT=""
 S MSGMAKAP=0 ;
 S COMMENT="" ;
 S SDARRAY=""
 S ERR=""
 S AJJ3CNT=0
 S SEG=""
 ;I HDR("MESSAGE TYPE")'="ACK" S ERR="NONRETURNED ACK"
 ; ADVANCE TO EACH SEGMENT IN THE MESSAGE
 ;
 S VWSDFLAG=1
 S AJJ3CNT1=0
 S AJJ3CNT2=0
 S AJJ3VIS=0
SEQ I '$$NEXTSEG^HLOPRS(.HLMSTATE,.SEG) G EXIT
 ;
 S VWSDFLAG=VWSDFLAG+1
 S AJJ3CNT1=AJJ3CNT1+1
 ;
 S SEGTYPE=$$GET^HLOPRS(.SEG,0)
 S AJJ3CNT=AJJ3CNT+1
 ;
 ;
 ; NEED TO GET REQUESTING APPLICATION'S MSGCTRL ID STORED IN SECURITY FIELD IN MSH SEGMENT.
 ; ALSO IN HLMSTATE OR HDR
 ;
 ;CODED BELOW ?
 I SEGTYPE="MSH" D
 .;GET SYNC (MSGCTRL) IN SECURITY FIELD
 .;;;;;;;;;S MSGCTRL=$$GET^HLOPRS(.SEG,8)  ; OR GET SECURITY OUT OF HDR OR HLMSTATE, IE HDR("SECURITY) OT HLMSTATE("SECURITY")
 .;
 I SEGTYPE="ERR" D
 .S ERR=$$GET^HLOPRS(.SEG,1)
 .;
 I (MSGCTRL1["#")&(SEGTYPE="ERR") G SEQ
 I SEGTYPE="QRD" D
 .S QRDSORT=$$GET^HLOPRS(.SEG,8) ; WHO SUBJECT FILTER
 .S QRDSORT=$P(QRDSORT,",",1) ; P,PS,C,CN
 .S SDCOUNT=$$GET^HLOPRS(.SEG,11) ; WHAT DATA CD VALUE QUA
 .;
 I SEGTYPE="EVN" D
 . S IEVN=$$GET^HLOPRS(.SEG,1)
 . ;
 ;
 ;NOW GET COMBINATION SEQUENCES OF PID,PV1,PV2,NTE
 ;
 ;FOR MAKE APPT BELOW
 I (MSGCTRL1["#")&(SEGTYPE="PID") G SEQ
 I SEGTYPE="PID" D
 . ;S POSITION=POSITION+1
 . S POSITION=+$P($G(^XTMP(MSGCTRX,"NUMBER")),"^",1)+1
 . S $P(^XTMP(MSGCTRX,"NUMBER"),"^",1)=POSITION
 . I MSGCTRX'="" I POSITION=1 S $P(^XTMP(MSGCTRX,"NUMBER"),"^",2)=SDCOUNT
 . S SDARRAY=""
 . ;GET PATIENT INTERNAL ID
 . S PATIENID=$$GET^HLOPRS(.SEG,3)
 . S PATIENT=$$GET^HLOPRS(.SEG,5)
 . S SSN=$$GET^HLOPRS(.SEG,19)
 . S PIDVALUE=PATIENID_"^"_PATIENT_"^"_SSN
 . ;
 I (MSGCTRL1["#")&(SEGTYPE="PID") G SEQ
 I SEGTYPE="PV1" D
 . S AJJ3VIS=AJJ3VIS+1
 . ;GET PATIENT INTERNAL ID
 . S PATIENTC=$$GET^HLOPRS(.SEG,2)  ; PATIENT CLASS
 . S SDLOCID=$$GET^HLOPRS(.SEG,3) ; INTERNAL ID ONLY, EXTERNAL IN NTE SEGMENT
 . S PURPVISI=$$GET^HLOPRS(.SEG,10) ; HOSPITAL SERVICE (PURPOSE OF VISIT)
 . S PRIMSTOP=$$GET^HLOPRS(.SEG,18) ; PATIENT TYPE (PRIME STOP CODE)
 . S PRIMCRED=$$GET^HLOPRS(.SEG,41) ; ACCOUNT STATUS (CREDIT STOP CODE)
 . S SDDATE=$$GET^HLOPRS(.SEG,44) ; ADMIT-VISIT DATE/TIME
 . ; CONVERT FROM TS TO FM DATE
 . S SDDATE=$$FMDATE^HLFNC(SDDATE)
 . ; THEN FM DATE TO EXTERNAL DATE FORMAT
 . S Y=SDDATE D DD^%DT S SDDATE=Y
 . ;
 . ; S XXXX=$$GET^HLOPRS(.SEG,51) ;
 . S PVIVALUE=PATIENTC_"^"_SDLOCID_"^"_PURPVISI_"^"_PRIMSTOP_"^"_PRIMCRED_"^"_SDDATE
 . ;
 I SEGTYPE="PV2" D
 . S ELIGIB=$$GET^HLOPRS(.SEG,7) ; VISIT USER ID-ELIGIBILITY FOR UNSCHEDULED VISITS 
 . S EXPECTDT=$$GET^HLOPRS(.SEG,8) ; EXPECTED DATE/TIME
 . S APPTST=$$GET^HLOPRS(.SEG,24)  ;APPOINT STATUS
 . S DATEAPTM=$$GET^HLOPRS(.SEG,46) ;DATE APPT MADE
 . S PV2VALUE=ELIGIB_"^"_EXPECTDT_"^"_APPTST_"^"_DATEAPTM
 . ;
 I SEGTYPE="NTE" D
 . S AJJ3CNT2=AJJ3CNT2+1
 . S TEMP=$$GET^HLOPRS(.SEG,3) ; UP TO 20 PIECES OF DATA FROM ARRAY DEFINITION FOR SDAPI
 . ;
 . I $E(TEMP,1,9)="SDLOCATE=" D
 . .S SDLOCATE=$P(TEMP,"SDLOCATE=",2)
 . .S SDLOCATE=$P(SDLOCATE,"""",2) ;STRIP OFF LEADING QUOTE
 . .S SDLOCATE=$P(SDLOCATE,"""",1) ;STRIP OFF TRAILING QUOTE
 . .;
 . E  D
 . . S SDARRAY=TEMP
 . . ;
 ;EVERY TIME GET A PID SEGMENT INCREMENT POSITION
 ;AND STUFF IN ^XTMP ARRAY ACCORDING TO SORT ORDER
 ;
 ;
 ;;;;;;;;I MSGCTRL=0 S ERR="ERROR MSGCTRL=0" G SEQ
 I (SDARRAY'="")&(SDLOCATE="")&(COMMENT="") Q "HOSPLOC"
 I (SDARRAY'="")&(QRDSORT="")&(COMMENT="") Q "ORDERSORT"
 I (SDARRAY'="")&(SDCOUNT>0) D
 .;CONVERT EMBEDDED # IN SDARRAY BACK INTO LEGAL"^" IN DATA
 .S TEMP8=SDARRAY
 .D REPLACE1(.TEMP8)
 .S SDARRAY=TEMP8
 .I $E(QRDSORT,1,1)="P" D
 ..S SSNPATN=SSN_"#"_PATIENT
 ..S ^XTMP(MSGCTRX,"SDAMA301",POSITION)=SSNPATN_"^"_SDLOCATE_"^"_SDDATE_"^"_SDARRAY
 .I $E(QRDSORT,1,1)="C" D
 ..S SSNPATN=SSN_"#"_PATIENT
 ..S ^XTMP(MSGCTRX,"SDAMA301",POSITION)=SDLOCATE_"^"_SSNPATN_"^"_SDDATE_"^"_SDARRAY
 .;
 ;
 I SDARRAY'="" S SDARRAY=""
 G SEQ
 ;
 ;
EXIT ;
 ;NOT GO TO NEXT MESSAGE FOR THIS TEST
 ;
 ;
 ;I $$NEXTMSG^HLOPRS(.HLMSTATE,HLMGIEN,.HDR) G SEQ
 ;
 ;IF MAKE APPNT API APP ACK RESPONSE ( IE, COMMENT'="")
 ;RETURN RETURN NOW FROM CAll to VWSDMKPI CALL RETURNED FROM RECEIVING APPLICATION
 ;
 ;CHECK TO SEE IF ADDITIONAL MESSAGES
 ;H 15
 S HLMSGTMP="AC" ;200000000000  
 S HLMSGIE1=$O(^HLB(HLMSGTMP),-1)
 I HLMSGIE1'=HLMSGIEN S CONTIN=1
 ;
 I MSGCTRL1["#" S MSGCTRL1=$P(MSGCTRL1,"#",2)_"^"_ERR Q MSGCTRL1 ; RETURN FOR MAKE APPT
 I ERR'="" Q HDR("APP ACK TYPE")_"^"_ERR ; MAKE APPT API RETURN
 ;
 S SDCOUNT=+$P($G(^XTMP(MSGCTRX,"NUMBER")),"^",2)
 I SDCOUNT>0 D
 .S POSITION=+$P($G(^XTMP(MSGCTRX,"NUMBER")),"^",1)
 .I POSITION=SDCOUNT S MSGCTRL=MSGCTRX
 E  D
 . S MSGCTRL=MSGCTRX
 Q "OK"_"^"_QRDSORT_"^"_SDCOUNT_"^"_POSITION ;SDAPI RETURN
 ;
REPLACE1(TEMP8) ;
 N REST,LEN8,L8,PIEC8
 S REST=TEMP8
 S LEN8=$L(TEMP8)
 F  Q:REST=""  D
 .S PIEC8=$P(TEMP8,"#",1)
 .S L8=$L(PIEC8)+2
 .I L8>LEN8 D
 ..S REST="" I $E(TEMP8,LEN8,LEN8)="#" S $E(TEMP8,LEN8,LEN8)="^"
 .E  D
 ..S REST=$E(TEMP8,L8,LEN8)
 .I (PIEC8'="")&(REST'="") D
 ..S TEMP8=PIEC8_"^"_REST
 Q
