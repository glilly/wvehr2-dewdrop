SDVWTES1 ; VWSD VOE SDAPI AND MAKE APPOINTMENT (CONTINUED) Test Exercises 
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
HL7SDAPI ;;
 ; HL7 SDAPI TEST PROGRAM ( RETURN LIST OF APPOINTMENTS)
 ;
 N FIRST,SSN,SDDATE,SDLOCATE,SDARRAY,PATIENTN,SSNPATN,AJJ3VIS,SDARRAY2
 N MSGCTRL,IER,RETURN,ORDRSORT,SSN,SDLOCATE,SDDATE,SDCOUNT,ACKCODE
 S MSGCTRL=0
 S SDARRAY(1)="Nov 6,2006;Nov 10,2006"  ;"FEB 5,2007;FEB 6,2007" ;"Nov 6,2006;JAN 29,2007"    ;"Nov 6,2006;Nov 10,2006"
 S SDARRAY(3)="R;I"
 S SDARRAY(2)="VWVOE RADIOLOGY CLINIC" ;"VWVOE DRPHYSICIAN CLINIC"   ;"VWVOE RADIOLOGY CLINIC"    ;"VWVOE DRPHYSICIAN CLINIC"
 ;"VWVOE RADIOLOGY CLINIC"
 ;"VWVOE DR. PHYSICIAN CLINIC"
 ;"VWVOE RADIOLOGY CLINIC"
 ;"VWVOE DR. PHYSICIAN CLINIC" ;"VWVOE RADIOLOGY CLINIC" ;"VWVOE DR. PHYSICIAN CLINIC" ;"VWVOE RADIOLOGY CLINIC" ;EXTERNAL NAME
 ;S SDARRAY(4)="100001298" ;EXTERNAL PATIENT ID AS SSN
 S SDARRAY("MAX")=2
 S SDARRAY("FLDS")="1;2;3"
 S IER=$$TRNSDAPI^SDVWHLE2(.SDARRAY,.MSGCTRL)
 I (IER="OK")&(MSGCTRL'=0) D
 .S AJJ3CNT=0
CHKAGAIN .I AJJ3CNT>27 Q
 .I $D(^XTMP(MSGCTRL,"RETURN"))=0 H 3 S AJJ3CNT=AJJ3CNT+1 G CHKAGAIN
 .;W !,"HERE"
 .S RETURN=^XTMP(MSGCTRL,"RETURN") ; THIS INCLUDES ACK CODE AS AA OR AE
 .S ACKCODE=$P(RETURN,"^",1)
 .I ACKCODE="OK" D
 ..;
 ..S ORDRSORT=$P(RETURN,"^",2)
 ..S SDCOUNT=$P(RETURN,"^",3)
 ..I SDCOUNT>0 D
 ...D
 ....I $E(ORDRSORT,1,1)="P" D
 .....S AJJ3VIS=0
 .....F  S AJJ3VIS=$O(^XTMP(MSGCTRL,"SDAMA301",AJJ3VIS)) Q:AJJ3VIS=""  D
 ......S SDARRAY2=^XTMP(MSGCTRL,"SDAMA301",AJJ3VIS)
 ......S SSNPATN=$P(SDARRAY2,"^",1)
 ......S SDLOCATE=$P(SDARRAY2,"^",2)
 ......S SDDATE=$P(SDARRAY2,"^",3)
 ......S FIRST=SSNPATN_"^"_SDLOCATE_"^"_SDDATE_"^"
 ......S SDARRAY2=$P(SDARRAY2,FIRST,2)
 ......S PATIENTN=$P(SSNPATN,"#",2)
 ......S SSN=$P(SSNPATN,"#",1)
 ......W !,"APPT/UNSCHED VISIT, PATIENT=",PATIENTN," SSN=",SSN," HOSP LOCATION=",SDLOCATE," DATE/TIME=",SDDATE
 ......W !,"                   DATA FIELDS=",SDARRAY2
 ....I $E(ORDRSORT,1,1)="C" D
 .....S AJJ3VIS=0
 .....F  S AJJ3VIS=$O(^XTMP(MSGCTRL,"SDAMA301",AJJ3VIS)) Q:AJJ3VIS=""  D
 ......S SDARRAY2=^XTMP(MSGCTRL,"SDAMA301",AJJ3VIS)
 ......S SSNPATN=$P(SDARRAY2,"^",2)
 ......S SDLOCATE=$P(SDARRAY2,"^",1)
 ......S SDDATE=$P(SDARRAY2,"^",3)
 ......S FIRST=SDLOCATE_"^"_SSNPATN_"^"_SDDATE_"^"
 ......S SDARRAY2=$P(SDARRAY2,FIRST,2)
 ......S PATIENTN=$P(SSNPATN,"#",2)
 ......S SSN=$P(SSNPATN,"#",1)
 ......W !,"APPT/UNSCHED VISIT, HOSP LOCATION=",SDLOCATE," PATIENT=",PATIENTN," SSN=",SSN," DATE/TIME=",SDDATE
 ......W !,"                   DATA FIELDS=",SDARRAY2
 ...;I $E(ORDRSORT,1,1)="C" D
 ...;.W !,"APPT/UNSCHED VISIT=",^XTMP(MSGCTRL,"SDAMA301",SDLOCATE,SSN,SDDATE)=SDARRAY
 ...;ANSWERS IN ORDERED ARRAYS ^XTMP(MSGCTRL,"SDAM301").
 ...;BELOW ORDRSORT IS 1ST PIECE RETURNED IN RETURN
 ...;I ($E(ORDRSORT,1,1)="P")&(SDCOUNT>0)
 ...;.S ^XTMP(MSGCTRL,"SDAMA301",SSN,SDLOCATE,SDDATE)=SDARRAY OR 
 ...;.S ^XTMP(MSGCTRL,"SDAMA301",SDLOCATE,SDDATE)=SDARRAY IF S SDARRAY("SORT")="C" WITH SDARRAY(4) SPECIFIED (PATIENT)
 ...;I ($E(ORDRSORT,1,1)="C")&(SDCOUNT>0)
 ...;.S ^XTMP(MSGCTRL,"SDAMA301",SDLOCATE,SSN,SDDATE)=SDARRAY OR
 ...;.S ^XTMP(MSGCTRL,"SDAMA301",SSN,SDDATE)=SDARRAY IF S SDARRAY("SORT")="P" WITH SDARRAY(2) SPECIFIED (CLINIC)
 ..E  D
 ...;LOOK AT ERRORS IN API CALL, ETC
 E  D
 . ; APP ACK CODE="AE". SOME OTHER ERRORS IN TRANSMISSION IN OTHER PIECES OF RETURN
 W !,"MSGCTRL=",MSGCTRL
 Q
HL7MKPI ;
 ;MAke Appointment HL7 TEST PROGRAM
 ;
 N MSGCTRL,IER,RETURN
 N PATIENTN,SSN,SD1,SC,STYP,SDARRAY,OUTIN,SDVWNVAI,X,Y,X2,ACKCODE
 N AJJ3CNT
 ;N VXSDNVAI
 S MSGCTRL=0  ;
 ;N DFN(SSN AND PATIENT NAME INSTEAD),SD1,SC(HOSP LOCATION (CLINIC) EXT FORMAT NAME INSTEAD,STYP,
 ;N SDARRAY (DATE/TIMES IN EXTERNAL FORMAT),IER
 S PATIENTN="ZZ PATIENT,TEST TWO"
    S SDVWNVAI="D"  ; NON-VA TESTING HERE WITH DISABLING THE NEED FOR ICN
 S SSN=100001298 ; DFN=1 NON TEST PATRIENT FOR PFSS EVENT GENERATION
 S SD1="JUN 4,2007@09:00"  ;"JAN 29,2007@09:00" ; SD1=3070123.1130  
 S SC="VWVOE RADIOLOGY CLINIC" ; S SC=3 
 S STYP=3  ;SCHEDULED APPT
 S OUTIN="O" ;for outpatient clinic
 ;
 D NOW^%DTC S X2=X\1 S Y=X2 D DD^%DT S SDARRAY("DATE NOW")=Y
 S SDARRAY("APPT TYPE")=9
    S SDARRAY("SCHED_REQ_TYPE")="O" ;'OTHER THAN NEXT AVAIABLE
    S SDARRAY("NEXT APPT IND")=0 ;0 FOR NO
    S SDARRAY("FOLLOWUP VISIT INDICATOR")=0  ; 0 FOR NO
    S SDARRAY("DATA ENTRY CLERK")="SCHLEHUBER,CAMERON" ; PERSON ON MACHINE MAKING APPT REMOTELY
    ;THEN PARAMETERS CONVERTED TO INTERNAL VALUE
    ;
 S IER=$$TRNSMKPI^SDVWHLE1(PATIENTN,SSN,SD1,SC,STYP,.SDARRAY,OUTIN,.MSGCTRL,SDVWNVAI)
 ;VWSDNVAI AS OPTIONAL LAST PARAMETER PASSED
 I (IER="OK")&(MSGCTRL'=0) D
 .S AJJ3CNT=0
CHKGAIN .I AJJ3CNT>8 Q
 .I $D(^XTMP(MSGCTRL,"RETURN"))=0 H 3 S AJJ3CNT=AJJ3CNT+1 G CHKGAIN
 .S RETURN=^XTMP(MSGCTRL,"RETURN") ; THIS INCLUDES ACK CODE AS AA OR AE
 .S ACKCODE=$P(RETURN,"^",1)
 .I ACKCODE="AA" D
 ..W !,"MAKE APPT GOOD RETURN"
 .E  D
 ..;ACKCODE="AE". LOOK AT SOME OTHER ERRORS IN TRNSMISSION IN OTHER PIECES OF RETURN
 ..W !,"RETURN=",RETURN
 W !,"MSGCTRL=",MSGCTRL
 Q
QUICK ;
 D
 . D
 . . ;S TEMP="S SDARRAY(1)="_""""_"Nov 6,2006;Nov 9,2006"_""""_""
 . . S TEMP="S SDARRAY(1)="_3 ;
 . . ;ZW TEMP
 . . ;X TEMP
 . . S AJJ3CNT1=0
 . . S IFLAG2=0
 . . S TEMP1=""
 . . F  S AJJ3CNT1=AJJ3CNT1+1 S AJJ3PIEC=$P(TEMP,"""",AJJ3CNT1) Q:(IFLAG2=1)  D
 . . .I AJJ3PIEC'="" S AJJ3CNT2=AJJ3CNT1+1 S AJJ3PIE2=$P(TEMP,"""",AJJ3CNT2) I AJJ3PIE2="" D
 . . . .S ILENX=$L(TEMP) I $E(TEMP,ILENX,ILENX)="""" D
 . . . . .S TEMP1=TEMP1_AJJ3PIEC_""""
 . . . .E  D
 . . . . .S TEMP1=TEMP1_AJJ3PIEC
 . . .I AJJ3PIEC="" S ILENX=$L(TEMP) I $E(TEMP,ILENX,ILENX)="""" D
 . . . . S TEMP1=TEMP1_"" S IFLAG2=1
 . . .E  D
 . . . . S IFLAG2=1
 . . X TEMP1
 Q
