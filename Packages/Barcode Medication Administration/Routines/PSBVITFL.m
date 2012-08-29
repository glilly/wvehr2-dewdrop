PSBVITFL ;BIRMINGHAM/TEJ-BCMA VITAL MEASUREMENT FILER ;Mar 2004
 ;;3.0;BAR CODE MED ADMIN;*31*;Mar 2004;Build 1
 ; Per VHA Directive 2004-038, this routine should not be modified.
 ; 
 ; Reference/IA
 ; STORE^GMRVPCE0/1589
 ; 44/908
 ; 42/10039
 ; 
 ;
 ; Description:
 ; This routine is to service BCMA 3.0 functionality and store VITALs'
 ; data into the VITAL MEASUREMENT FILE - ^GMR(120.5  using the API
 ; GMRVPCE0
 ; 
 ; Parameters:
 ;       Input  -        DFN     (r) Pointer to the PATIENT (#2) file
 ;                       RATE    (r) BCMA trigger event/transaction
 ;                       VTYPE   (o) Pointer to GMRV VITAL TYPE FILE (#120.51)
 ;                                    (default = Pain ["PN"])
 ;                       DTTKN   (o) Date/time (FileMan) measurment was taken 
 ;                                    (default = $$NOW^XLFDT())
 ;                                    
 ;       Output -        RESULTS(0) = 1                                                                                             
 ;                       RESULTS(1) ="1^*** comment ***"                                                              
 ;                 or    RESULTS(1) ="-1^ERROR * Pain Score NOT filed 
 ;                                    successfully"
 ;
 ;       Process results in the storing of VITAL Measurement rate into the VITAL
 ;       MEASUREMENT FILE per the given patient and vital type.
 ;   
RPC(RESULTS,PSBDFN,PSBRATE,PSBVTYPE,PSBDTTKN) ;
 ;
 ; Set up the input array for the API
 ;
 ;PSB*3*31 Quit if patient has been discharged.
 K VADM,VAIN
 N DFN S DFN=$G(PSBDFN),VAIP("D")=""
 D DEM^VADPT,IN5^VADPT
 S RESULTS(0)=1,RESULTS(1)="-1^ERROR * "_$S($G(PSBVTYPE)']""!($G(PSBVTYPE)="PN"):"Pain Score",1:"Vital Measurement")_" NOT filed successfully."
 I 'VAIP(13)&('VADM(6)) S RESULTS(1)=RESULTS(1)_"  Patient has been DISCHARGED." Q
 S:$G(PSBVTYPE)']"" PSBVTYPE="PN"
 S:$G(PSBDTTKN)']"" PSBDTTKN=$$NOW^XLFDT()
 S PSBHLOC=^DIC(42,+$G(VAIP(5)),44)
 S GMRVDAT("ENCOUNTER")=U_PSBDFN_U_$G(PSBHLOC)
 S GMRVDAT("SOURCE")=U_$G(DUZ)
 S GMRVDAT("VITALS",$G(DUZ),1)=PSBVTYPE_U_$G(PSBRATE)_U_$G(PSBUNTS)_U_PSBDTTKN
 D STORE^GMRVPCE0(.GMRVDAT)
 I '$D(GMRVDAT("ERROR")) D NOW^%DTC,YX^%DTC S RESULTS(0)=1,RESULTS(1)="1^"_$S($G(PSBVTYPE)="PN":"Pain Score",1:PSBVTYPE)_" entered in Vitals via BCMA taken "_Y
 Q
 ;
