PPPFMA1 ;ALB/DMB - FOREIGN MEDICATION ALERT TEST ROUTINE ; 3/2/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
FMA(PATDFN) ; Foreign Medication Alert Call
 ;
 I $$DFL^PPPDSP2(PATDFN,"PPPPDX") K PPPPDX Q $$FMA1(PATDFN)
 Q 0
 ;
FMA1(PATDFN) ; Foreign Medication Alert
 ;
 ; This function determines if the patient has been to other hospitals
 ; and whether there is any prescription information in the PDX
 ; data file for the patient.  If there is data, the user is given the
 ; option of viewing it.
 ;
 ; Parameters: PATDFN - The patient DFN from the patient file.
 ;
 ; Return:     0 - Normal Termination
 ;         -9001 - Input Parameter Format Error
 ;         -9003 - Invalid Patient DFN
 ;
 N DIR,DUOUT,DTOUT,DIRUT,DIROUT,ERR,LKUPERR,PARMERR
 N TMP,PPPPDX,XTRCTERR,X,Y,ALRTIGND
 ;
 ; Note: ^TMP("PPP",$J) is killed in PPPPRT1
 ;
 S PARMERR=-9001
 S LKUPERR=-9003
 S XTRCTERR=-9010
 S ALRTIGND=1010
 S ERR=0
 ;
 I $G(PATDFN)<1 Q PARMERR
 I '$D(^DPT(PATDFN)) Q LKUPERR
 ;
 I $D(^PPP(1020.2,"B",PATDFN)) D
 .S ERR=$$DFL^PPPDSP2(PATDFN,"PPPPDX","V")
 .I ERR=1 D
 ..;
 ..;Increment alert issued statistic
 ..;
 ..S TMP=$$STATUPDT^PPPMSC1(3,1)
 ..W !
 ..S DIR(0)="Y"
 ..S DIR("A")="Do you wish to view the foreign profiles"
 ..S DIR("B")="YES"
 ..S DIR("?")="Answer YES to view the short form drug profiles from each facility."
 ..D ^DIR
 ..I Y D
 ...;
 ...; Get the PDX data and display it for the user
 ...;
 ...S ERR=$$GETPDX^PPPGET2("PPPPDX","^TMP(""PPP"","_$J_")")
 ...I ERR<0 D  Q
 ....W !,*7,"An unexpected error occurred while extracting the PDX data."
 ....W !,"Please contact your IRM representative and report this problem."
 ....R !,"Press <RETURN> to continue...",TMP:DTIME
 ....S TMP=$$LOGEVNT^PPPMSC1(XTRCTERR,"FMA1_PPPFMA1")
 ...S TMP=$$VFM^PPPPRT1(PATDFN,"^TMP(""PPP"","_$J_")")
 ...S TMP=$$STATUPDT^PPPMSC1(9,1)
 ..E  D
 ...S TMP=$$LOGEVNT^PPPMSC1(ALRTIGND,"FMA1_PPPFMA1","PATIENT = "_$$GETPATNM^PPPGET1(PATDFN))
 ...S TMP=$$STATUPDT^PPPMSC1(4,1)
 E  S ERR=LKUPERR
 Q ERR
 ;
FMAI ; Get foreign visit information interactively
 ;
 N TMP
 ;
 W @IOF
 S TMP=$$FMA1(+$$GETDFN^PPPGET1("",1))
 I TMP<1 D
 .W !,*7,"There is no foreign visit information available for this patient."
 .R !,"Press <RETURN> to continue...",TMP:DTIME
 W @IOF
 Q
