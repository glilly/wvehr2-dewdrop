PPPPDA1 ;ALB/DMB - PHARMACY DATA ALERT ROUTINE ; 3/2/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**10**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
PDA(PATDFN) ; Pharmacy Data Alert Call
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
 N PARMERR,LKUPERR,XTRCTERR,ALRTIGND,ERR,TARRY,TMP,X,Y
 ; New DA because XQORM2 will kill it.
 N DA
 ;
 S PARMERR=-9001
 S LKUPERR=-9003
 S XTRCTERR=-9010
 S ALRTIGND=1010
 S ERR=0
 S TARRY="^TMP(""PPP"",$J,""ALERT"")"
 ;
 I $G(PATDFN)<1 Q PARMERR
 I '$D(^DPT(PATDFN)) Q LKUPERR
 ;
 I $$GETVIS^PPPGET7(PATDFN,TARRY)>0 D
 .;
 .; Increment Alert Issued
 .;
 .S TMP=$$STATUPDT^PPPMSC1(3,1)
 .;
 .I $$VPDAT(PATDFN,TARRY) D
 ..S TMP=$$STATUPDT^PPPMSC1(4,1)
 ..S TMP=$$LOGEVNT^PPPMSC1(ALRTIGND,"PDA_PPPPDA1","PATIENT = "_$$GETPATNM^PPPGET1(PATDFN))
 K @TARRY
 Q 0
 ;
VPDAT(PATDFN,TARRY) ; View the pharmacy data
 ;
 ; This routine displays the other locations and then prompts the
 ; user for viewing pharmacy data.
 ;
 N TMP,DIR,DTOUT,DUOUT,DIRUT,DIROUT,IGNORED,X,Y
 ;
 S IGNORED=0
 W !!
 ;S TMP=$$POF^PPPPRT8(PATDFN,TARRY)
 S TMP=$$POF^PPPDSP4(PATDFN,TARRY)
 Q IGNORED
 ;
PDAI ; Get foreign visit information interactively
 ;
 N TMP,TARRY,PATDFN
 ;
 S TARRY="^TMP(""PPP"",$J,""FMAI"")"
 ;
 F IX1=0:0 D  Q:PATDFN<0
 .S BANNER="Display Pharmacy Data from other Facilities"
 .S TMP=$$BANNER^PPPDSP1(BANNER) W !!
 .S PATDFN=+$$GETDFN^PPPGET1("",1)
 .I PATDFN<0 Q
 .K ^TMP("PPP",$J,"FMAI") ;Dave B (24June97)
 .I $$GETVIS^PPPGET7(PATDFN,TARRY) S TMP=$$VPDAT(PATDFN,TARRY)
 .E  D
 ..W !,*7,"No pharmacy data available from other facilities for this patient."
 ..R !!,"Press <RETURN> to continue...",TMP:DTIME
 K @TARRY
 Q
