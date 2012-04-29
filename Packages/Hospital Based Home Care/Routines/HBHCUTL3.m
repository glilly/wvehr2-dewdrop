HBHCUTL3 ; LR VAMC(IRMS)/MJT-HBHC Utility module, Entry points:  PSEUDO, PCEMSG, DX, DX80, & CPT ; Jan 2000
 ;;1.0;HOSPITAL BASED HOME CARE;**6,8,10,15,16,14**;NOV 01, 1993
PSEUDO ; Print pseudo SSN message
 W *7,!!,"Patient visit records with pseudo social security numbers (SSNs) exist.",!,"Print the 'Pseudo Social Security Number Report' located on the HBHC Reports"
 W !,"Menu to obtain a list of patients with invalid SSNs.  HBHC must determine",!,"what corrective action is appropriate to eliminate these records from the",!,"HBHC Information System.",!! H 5
 Q
PCEMSG ; Print PCE correction of errors message
 W !!,"Note:  Please use Appointment Management to Correct Visit Errors.  Run",!?7,"Edit Form Errors Data option when corrections are complete."
 Q
DX ; Diagnosis (DX) info, HBHCDFN must be defined prior to call, returns code plus text in local array HBHCDX
 K HBHCDX S $P(HBHCSP5," ",6)="",HBHCI=0
 F  S HBHCI=$O(^HBHC(632,HBHCDFN,3,HBHCI)) Q:HBHCI'>0  S HBHCICDP=$P(^HBHC(632,HBHCDFN,3,HBHCI,0),U),HBHCICD0=^ICD9(HBHCICDP,0),HBHCDX(HBHCI)=$P(HBHCICD0,U)_$E(HBHCSP5,1,(8-$L($P(HBHCICD0,U))))_$P(HBHCICD0,U,3)
 K HBHCI,HBHCICD0,HBHCICDP
 Q
DX80 ; Print DX info in 80 column format, HBHCDX( array must be defined prior to call
 S (HBHCFLG,HBHCI)=0 F  S HBHCI=$O(HBHCDX(HBHCI)) Q:HBHCI'>0  W ! W:HBHCFLG=0 "Diagnosis:   " W:HBHCFLG=1 ?13  W HBHCDX(HBHCI) S HBHCFLG=1
 K HBHCDX,HBHCFLG,HBHCI
 Q
CPT ; CPT code info, HBHCDFN must be defined prior to call, returns code plus text in local array HBHCCPTA
 K HBHCCPTA S $P(HBHCSP3," ",4)="",HBHCI=0 F  S HBHCI=$O(^HBHC(632,HBHCDFN,2,HBHCI)) Q:HBHCI'>0  S HBHCCPT=$$CPT^ICPTCOD(^HBHC(632,HBHCDFN,2,HBHCI,0)),HBHCCPTA(HBHCI)=$P(HBHCCPT,U,2)_HBHCSP3_$P(HBHCCPT,U,3) D CPTMOD
 K HBHCCPT,HBHCI,HBHCJ,HBHCMOD,HBHCSP3
 Q
CPTMOD ; Process CPT Modifier code plus text into local array HBHCCPTA(HBHCCPT,HBHCJ)
 S HBHCJ=0 F  S HBHCJ=$O(^HBHC(632,HBHCDFN,2,HBHCI,1,HBHCJ)) Q:HBHCJ'>0  S HBHCMOD=$$MOD^ICPTMOD($P(^HBHC(632,HBHCDFN,2,HBHCI,1,HBHCJ,0),U),"I"),HBHCCPTA(HBHCI,HBHCJ)=$P(HBHCMOD,U,2)_HBHCSP3_$P(HBHCMOD,U,3)
 Q
