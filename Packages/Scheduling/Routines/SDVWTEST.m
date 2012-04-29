SDVWTEST ; VWSD VOE SDAPI AND MAKE APPOINTMENT Test Exercises
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
EN1 N SDARRAY,SDCOUNT,SDDFN,SDDATE,SDAPPT,SDPAT,SDPATNAM,SDSTATUS
 N SDDATEP
 S SDARRAY(1)="3061106;3061109"
 S SDARRAY(2)=6 ;"VWVOE RADIOLOGY CLINIC"
 S SDARRAY("FLDS")="4;3"
 S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY)
 I SDCOUNT>0 D
 . ;get patient
 . S SDDFN=0 F  S SDDFN=$O(^TMP($J,"SDAMA301",6,SDDFN)) Q:SDDFN=""  D
 .. ;get appointment date/time
 .. S SDDATE=0
 ..F  S SDDATE=$O(^TMP($J,"SDAMA301",6,SDDFN,SDDATE)) Q:SDDATE=""  D
 ...S SDAPPT=$G(^TMP($J,"SDAMA301",6,SDDFN,SDDATE)) ;appointment data
 ...S SDSTATUS=$P($G(SDAPPT),"^",3) ;appointment status
 ...S SDPAT=$P($G(SDAPPT),"^",4) ;patient DFN and Name
 ...S SDPATNAM=$P($G(SDPAT),";",2) ;patient Name only
 ...;continue processing this appointment as needed
 ...S Y=SDDATE X ^DD("DD") S SDDATEP=Y
 ...W !,"RADIOLOGY CLINIC ","PATIENT: ",SDPATNAM," DATE/TIME: ",SDDATEP," STATUS=",SDSTATUS
 I SDCOUNT<0 D
 . W !,"SDCOUNT=",SDCOUNT ; do processing for errors 101 and 116
 ; when finished with all processing, kill the output array
 I SDCOUNT'=0 K ^TMP($J,"SDAMA301")
 Q
EN2 ;
 N SDARRAY,SDCOUNT,SDCLIEN,SDDATE,SDAPPT,SDSTATUS,SDCLINFO,SDCLNAME
 N SDDATEP
 S SDARRAY(1)="3061105;3061114"
 S SDARRAY(3)="R;I"
 S SDARRAY(4)=1 ;ZZ PATIENT,TEST ONE
 S SDARRAY("MAX")=3
 S SDARRAY("FLDS")="1;2;3"
 S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY)
 I SDCOUNT>0 D
 . ;get clinic
 . S SDCLIEN=0 F  S SDCLIEN=$O(^TMP($J,"SDAMA301",1,SDCLIEN)) Q:SDCLIEN=""  D
 .. ;get appointment date/time
 .. S SDDATE=0 F  S SDDATE=$O(^TMP($J,"SDAMA301",1,SDCLIEN,SDDATE)) Q:SDDATE=""  D
 ... S SDAPPT=$G(^TMP($J,"SDAMA301",1,SDCLIEN,SDDATE)) ;appointment data
 ... S SDSTATUS=$P(SDAPPT,"^",3) ;appt status
 ... S SDCLINFO=$P(SDAPPT,"^",2) ;clinic IEN and Name
 ... S SDCLNAME=$P(SDCLINFO,";",2) ;clinic Name only
 ... S Y=SDDATE X ^DD("DD") S SDDATEP=Y
 ... ;continue processing this appointment as needed
 ... W !,"ZZ PATIENT,TEST ONE ","CLINIC: ",SDCLNAME," DATE/TIME: ",SDDATEP," STATUS=",SDSTATUS
 I SDCOUNT<0 D
 .W !,"SDCOUNT=",SDCOUNT ;  ;do processing for errors 101 and 116
 ; when finished with all processing, kill output array
 I SDCOUNT'=0 K ^TMP($J,"SDAMA301")
 Q
EN3 ;
 N SDARRAY,SDCOUNT,SDDATE,SDAPPT,SDCRSTOP
 N SDATEP,SDCREDIN,SDCREDIT
 S SDARRAY(1)="3061101;3061130"
 S SDARRAY(2)=3  ;VWVOE DR. PHYSICIAN CLINIC
 S SDARRAY(4)=1  ;ZZ PATIENT,TEST ONE
 S SDARRAY("FLDS")="1;14;16"
 S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY)
 I SDCOUNT>0 D
 . ; GET APPOINTMENT DATA
 . S SDDATE=0 F  S SDDATE=$O(^TMP($J,"SDAMA301",1,3,SDDATE)) Q:SDDATE=""  D
 .. S SDAPPT=$G(^TMP($J,"SDAMA301",1,3,SDDATE)) ;appointment data
 .. S SDCREDIT=$P(SDAPPT,"^",14) ;credit stop code IEN
 .. S SDCREDIT=$P(SDCREDIT,";",1)
 .. S SDCREDIN=$P($G(^DIC(40.7,SDCREDIT,0)),"^",1)
 .. I $G(SDCREDIT)'=";" S SDCRIEN=$P(SDCREDIT,";",1) ;credit stop code IEN only
 .. S Y=SDDATE X ^DD("DD") S SDDATEP=Y
 .. W !,"ZZ PATIENT,TEST ONE ","CLINIC: ","VWVOE DR. PHYSICIAN CLINIC"," DATE/TIME: ",SDDATEP," CREDIT STOP=",SDCREDIN
 .. ;continue processing this appointment as needed
 I SDCOUNT<0 D
 . W !,"SDCOUNT=",SDCOUNT  ; ;do processing for errors 101 and 116
 ; when finished with all processing, kill output array
 I SDCOUNT'=0 K ^TMP($J,"SDAMA301")
 Q
EN4 ;
 N SDARRAY,SDCOUNT,SDCLIEN,SDDFN,SDDATE,SDAPPT,SDSTATUS
 N SDATEP,SDCREDIN,SDCREDIT
 S SDARRAY(1)="3061101;3061130"
 S SDARRAY(13)=323
 S SDARRAY("FLDS")="3;13;16"
 S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY)
 I SDCOUNT>0 D
 . ;get clinic
 . S SDCLIEN=0 F  S SDCLIEN=$O(^TMP($J,"SDAMA301",SDCLIEN)) Q:SDCLIEN=""  D
 .. ;get patient
 .. S SDDFN=0 F  S SDDFN=$O(^TMP($J,"SDAMA301",SDCLIEN,SDDFN)) Q:SDDFN=""  D
 ... ;get appointment date/time
 ... S SDDATE=0 F  S SDDATE=$O(^TMP($J,"SDAMA301",SDCLIEN,SDDFN,SDDATE)) Q:SDDATE=""  D
 ....S SDSTATUS=$P($G(^TMP($J,"SDAMA301",SDCLIEN,SDDFN,SDDATE)),"^",3) ;appointment status
 ....S SDAPPT=$G(^TMP($J,"SDAMA301",SDCLIEN,SDDFN,SDDATE)) ;appointment data
 ....S SDCREDIT=$P(SDAPPT,"^",13) ;credit stop code IEN
 .... S SDCREDIT=$P(SDCREDIT,";",1)
 .... S SDCREDIN=$P($G(^DIC(40.7,SDCREDIT,0)),"^",1)
 .... I $G(SDCREDIT)'=";" S SDCRIEN=$P(SDCREDIT,";",1) ;credit stop code IEN only
 .... S Y=SDDATE X ^DD("DD") S SDDATEP=Y
 .... ;continue processing this appointment as needed
 .... W !,"CLINIC: ",$P($G(^SC(SDCLIEN,0)),"^",1)," PATIENT: ",$P($G(^DPT(SDDFN,0)),"^",1)," DATE/TIME: ",SDDATEP," STATUS: ",SDSTATUS," STOP CODE=",SDCREDIN
 I SDCOUNT<0 D
 . ;do processing for errors 101 and 116
 . W !,"SDCOUNT=",SDCOUNT ;
 ; when finished with all processing, kill output array
 I SDCOUNT'=0 K ^TMP($J,"SDAMA301")
 Q
EN5 ;
 N SDARRAY,SDCOUNT,SDDFN,SDDATE,SDAPPT,SDPAT,SDPATNAM,SDSTATUS
 N SDATEP
 S SDARRAY(1)="3061107;3061107"
 S SDARRAY(2)=4    ; VWVOE PSYCHIATRIC CLINIC
 S SDARRAY("SORT")="P"
 S SDARRAY("FLDS")="4;3" ;order is irrelevant
 S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY)
 I SDCOUNT>0 D
 . ;get patient
 . S SDDFN=0 F  S SDDFN=$O(^TMP($J,"SDAMA301",SDDFN)) Q:SDDFN=""  D
 .. ;get appointment date/time
 .. S SDDATE=0 F  S SDDATE=$O(^TMP($J,"SDAMA301",SDDFN,SDDATE)) Q:SDDATE=""  D
 ... S SDAPPT=$G(^TMP($J,"SDAMA301",SDDFN,SDDATE)) ;appointment data
 ... S SDSTATUS=$P($G(SDAPPT),"^",3) ;appointment status
 ... S SDPAT=$P($G(SDAPPT),"^",4) ;patient DFN and Name
 ... S SDPATNAM=$P($G(SDPAT),";",2) ;patient Name only
 ... S Y=SDDATE X ^DD("DD") S SDDATEP=Y
 ... ;continue processing this appointment as needed
 ... W !,"CLINIC: ","VWVOE PSYCHIATRIC CLINIC"," PATIENT: ",SDPATNAM," DATE/TIME: ",SDDATEP," STATUS: ",SDSTATUS
 I SDCOUNT<0 D
 . W !,"SDCOUNT=",SDCOUNT ;
 . ;do processing for errors 101 and 116
 ; when finished with all processing, kill the output array
 I SDCOUNT'=0 K ^TMP($J,"SDAMA301")
 Q
EN6 ;
 N SDARRAY,SDCOUNT,SDCLIEN
 N SDDFN
 N SDDATE,SDAPPT,SDSTATUS
 N SDDATEP,SDAPPM
 S SDARRAY(1)="3061101;3061130"
 S SDARRAY(13)=323
 S ^SDDFN(1)=""
 S ^SDDFN(2)=""
 S ^SDDFN(3)=""
 S SDARRAY(4)="^SDDFN("
 S SDARRAY("FLDS")="3;16"
 S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY)
 I SDCOUNT>0 D
 . ;get clinic
 . S SDCLIEN=0 F  S SDCLIEN=$O(^TMP($J,"SDAMA301",SDCLIEN)) Q:SDCLIEN=""  D
 .. ;get patient
 .. S SDDFN=0 F  S SDDFN=$O(^TMP($J,"SDAMA301",SDCLIEN,SDDFN)) Q:SDDFN=""  D
 ... ;get appointment date/time
 ... S SDDATE=0 F  S SDDATE=$O(^TMP($J,"SDAMA301",SDCLIEN,SDDFN,SDDATE)) Q:SDDATE=""  D
 .... S SDSTATUS=$P($G(^TMP($J,"SDAMA301",SDCLIEN,SDDFN,SDDATE)),"^",3) ;appointment status
 .... S SDAPPM=$P($G(^TMP($J,"SDAMA301",SDCLIEN,SDDFN,SDDATE)),"^",16) ;date appointment made
 .... S Y=SDAPPM X ^DD("DD") S SDAPPM=Y
 .... S Y=SDDATE X ^DD("DD") S SDDATEP=Y
 .... ;continue processing this appointment as needed
 ... W !,"CLINIC: ",$P($G(^SC(SDCLIEN,0)),"^",1)," PATIENT: ",$P($G(^DPT(SDDFN,0)),"^",1)," DATE/TIME: ",SDDATEP," STATUS: ",SDSTATUS," DATE APPT MADE: ",SDAPPM
 I SDCOUNT<0 D
 . ;do processing for errors 101 and 116
 . W !,"SDCOUNT=",SDCOUNT ;
 ; when finished with all processing, kill output array and user-defined patient list
 I SDCOUNT'=0 K ^TMP($J,"SDAMA301")
 ;K ^SDDFN
 Q
MKPITEST ;
 N DFN,SD1,SC,STYP,X2,X,X1,SDARRAY,IER
 N XQORMUTE ; EXIST AS NON-INTERACTIVE SILENT NODE W/O WRITE FOR XQOR ROUTINES
 N SDVWNVAI ; EXIST AS NON-VA RELATED PFSS EVENT MODE
 ;                                = "D" DISABLING THE NEED FOR ICN
 ;                                = "O" AS OTHER NON-VA ICN SYSTEM ( FUTURE)
 S XQORMUTE=1    ;SILENT MODE FOR NON-INTERACTIVE MODE W/O WRITE
 S SDVWNVAI="D"  ; NON-VA TESTING HERE WITH DISABLING THE NEED FOR ICN
 S DFN=3 S SD1=3070123.10 S SC=3 S STYP=3
 D NOW^%DTC S X2=X\1 S SDARRAY("DATE NOW")=X2
 S SDARRAY("APPT TYPE")=9
    S SDARRAY("SCHED_REQ_TYPE")="O"
    S SDARRAY("NEXT APPT IND")=0
    S SDARRAY("FOLLOWUP VISIT INDICATOR")=0  ; 0 FOR NO
    S SDARRAY("DATA ENTRY CLERK")=DUZ
    S IER=$$EN^SDVWMKPI(DFN,SD1,SC,STYP,.SDARRAY)
    W "IER=",IER
    Q
