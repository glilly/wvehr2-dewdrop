PPPBTCH ;ALB/DMB - DAILY BATCH ROUTINE FOR 3P ; 3/19/92
 ;;1.0;PHARMACY PRESCRIPTION PRACTICE;**2,35,38**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; -- This batch job accomplishes the following things
 ;
 ;    0. Logs event in PPP Log file, PPPBTCH STARTED
 ;    1. Scans FFX file for bad PDX results
 ;    2. Scans Clinic for patients to send PDX's for
 ;    3. Adds new patients to FFX file
 ;    4. Prints Clinical Medication Profiles
 ;    5. Logs event in PPP Log file, PPPBTCH Complete 
START ;
 ;
 N TMP
 ;
 ; -- Log event in PPP LOG file (#1020.4)
 K ^TMP($J,"PPPDOUG") S PPPFLAG=1
 S TMP=$$LOGEVNT^PPPMSC1(1023,"_PPPBTCH")
 ; -- Run night jobs
 D XREFSCAN^PPPSCN1
 D FFSCAN^PPPSCN2
 ;PPP*1*35 - Dave B - remove checking for new patients from CD-ROM
 ;since there is no longer a CD, the data can be obtained from
 ;the MPI/PD package
 ;VMP OIFO BAY PINES;ELR;PPP*1*38
 ;PUT CALL BACK IN to PPPBLD4
 D NEWPAT^PPPBLD4
 D START^PPPPRT2
 S TMP=$$LOGEVNT^PPPMSC1(1024,"PPPBTCH")
 K ^TMP($J,"PPPDOUG"),PPPFLAG
 Q
