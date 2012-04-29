VEPERIC ;KFK;REGISTRATION CHECK; 5/3/05 11:22am ; 6/2/05 1:56pm
 ;;1.0;VOEB;;Jun 12, 2005
 ;
 ; This routine will check an HL7 message that is generated through
 ; the registration process in COTS, a doctor's office package.
 ; The results of the lookup are returned in the variable MSG:
 ;
 ;    DFN = Match is found
 ;      0 = New patient flag
 ;      -1 = Error Flag
 ;
 ; The results of the error will be stored in the ^VEPER(19904.2
 ; file.
 ;
 Q  ;No direct entry
 ;
LKUP(HL7,HL7DT,VCOB,VDOB,VFI,VHRN,VNAME,VSEX) ;
 ;
 N DIC,DIE,DR,ERR,ERRDT,ERRMSG,ERRTYP,FCOB,FDOB,FE,FIN,FOUND,FSEX,MATCH
 N MSG,MULT,NAN,NOFI,NOHRN,NONAME,RESULTS,SCREEN,VAR,VPID,Y
 ;
 D FINDN,FINDF,FINDH
 I MULT=0 D MSGMP Q MSG
 I NONAME=0,NOFI=0,NOHRN=0 D MSGNP Q MSG
 I FIN'=NAN D PID,MSGID D:MATCH=1 MSGMM Q MSG
 D PID I MATCH'=1 D MSGID
 Q MSG
 ;
MSGM ; Error set if there is a piece of data missing from the VISTA file.
 ; Full verification can not be completed.
 S (FE,VAR)="" F  S VAR=$O(ERR(VAR)) Q:VAR=""  D
 . S FE=FE_$S(VAR="FSEX":"SEX",VAR="FDOB":"DATE OF BIRTH",1:"HEALTH RECORD NUMBER")_","
 I $E($L(FE))="," S FE=$E(FE,1,$L(FE)-1)
 S MSG="-1",ERRTYP="MD"
 S ERRMSG="Missing Data Error: Match could not be verified because the following pieces of data are missing in the VISTA file - "_FE
 D SAVE
 Q
 ;
MSGMP ; Multiple mathces were found for incoming data.
 S MSG="-1",ERRTYP="MP"
 S ERRMSG="Multiple Match Error: Multiple matches were found for the information that was entered."
 D SAVE
 Q
 ;
MSGNP ; Flag returned to indicate that this is a new patient.
 S MSG=0
 Q
 ;
MSGMM ; Error set as a patient mismatch.
 S MSG="-1",ERRTYP="MM"
 S ERRMSG="Patient Mismatch Error: Patient appears to already be registered under Patient ID - "_VFI
 D SAVE
 Q
 ;
MSGID ; Error set if a piece of registration data does not match stored
 ; data from patient file.
 S MSG="-1",ERRTYP="ID"
 S ERRMSG="Match Incomplete Error: Patient information sent in does not match patient information on file.  Possible new patient."
 D SAVE
 Q
 ;
PID ; Verification of patient demoghrapic information.
 S MATCH=0
 S VPID=^DPT(NAN,0),FSEX=$P(VPID,U,2),FDOB=$P(VPID,U,3)
 K ERR
 F VAR="FSEX","FDOB" D
 . I @VAR="" S ERR(VAR)=""
 I $D(ERR) D MSGM Q
 I FSEX'=VSEX Q
 I FDOB'=VDOB Q
 S MATCH=1,MSG=NAN
 Q
 ;
SAVE ; Save errors to error file.
 N DA,X,Y
 S ERRDT=""""_$$NOW^XLFDT_""""
 S DIC="^VEPER(19904.2,",DIC(0)="L",X=ERRDT
 D ^DIC
 S DIE=DIC,DA=+Y
 K DR
 S DR=".02///^S X=VNAME;.03////"_HL7_";.04////"_VFI_";.05////"_ERRTYP_";.06////"_HL7DT_";1.01////"_ERRMSG D ^DIE
 Q
 ;
FINDN ; Name lookup.
 S (MULT,NAN,NONAME)=1
 S FOUND="RESULTS",SCREEN="I $P(^(0),U,2)=VSEX&($P(^(0),U,3)=VDOB)"
 K RESULTS
 D FIND^DIC(2,,"@;.02;.03","O",VNAME,"*",,SCREEN,,FOUND)
 I $P(RESULTS("DILIST",0),U)=0 S NONAME=0 Q
 I $P(RESULTS("DILIST",0),U)>1 S MULT=0 Q
 S NAN=RESULTS("DILIST",2,1)
 Q
 ;
FINDF ; Foreign ID lookup.
 N D,X,Y
 S (FIN,NOFI)=1
 S DIC="^AUPNPAT(",DIC(0)="M",D="C",X=VFI
 D IX^DIC
 I Y=-1 S NOFI=0 Q
 S FIN=$P(Y,U)
 Q
 ;
FINDH ; Health Record Number lookup.
 N D,HRNN,X,Y
 S (HRNN,NOHRN)=1
 S DIC="^AUPNPAT(",DIC(0)="M",D="D",X=VHRN
 D IX^DIC
 I Y=-1 S NOHRN=0 Q
 S HRNN=$P(Y,U)
 Q
