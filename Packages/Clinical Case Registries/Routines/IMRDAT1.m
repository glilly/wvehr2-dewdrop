IMRDAT1 ;HCIOFO-NCA,FT/FAI-DATA EXTRACTION (cont.) ; 01/14/02 14:23 ; 12/24/02 9:30am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**1,9,5,14,13,16,15,18,19**;Feb 09, 1998
 ;
 Q
 ;
 ;***** GETS ALL ANCILLARY PACKAGE DATA
GETDAT ;
 ;--- Get Outpatient Pharmacy Data
RX D
 . S IMRLD=+$P(IMR101,"^",6) ; LAST OPT PHARMACY DATE NOTED
 . ;--- Perform the backpull if the start date is defined
 . I $G(IMRSDBP(5.3))'>0  D
 . . D:$D(IMRDTRX)>1 GET^IMRRX(IMRDTRX("S"),IMRDTRX("E"))
 . . D GET^IMRRX(IMRSD,IMRED)
 . E  D GET^IMRRX(IMRSDBP(5.3),IMRED)
 . ;--- Check FILL DATE against LAST OPT PHARMACY DATE NOTED
 . S IMRLD=$S(IMRRX>IMRLD:IMRRX,1:IMRLD)
 . S:IMRLD'>0 IMRLD=""
 . ; piece  6=LAST OPT PHARMACY DATE NOTED
 . ; piece  7=LAST INPT PHARMACY DATE NOTED
 . ; piece  8=LAST IV PHARMACY DATE NOTED,
 . ; piece 12=LAST LIMITED Rx dATE
 . S $P(IMR101,"^",6,8)=IMRLD_"^^",$P(IMR101,"^",12)=IMRLD
 . K IMRLD
 ;
 ;--- Get Lab Data
LAB D
 . S IMRLD=+$P(IMR101,"^",9)   ; LAST LABORATORY DATE NOTED
 . S IMRLD1=+$P(IMR101,"^",10) ; LAST MICROBIOLOGY DATE NOTED
 . ; Perform the backpull if the start date is defined
 . I $G(IMRSDBP(5.1))>0  N IMRSD  S IMRSD=$G(IMRSDBP(5.1))
 . D CHK^IMRLAB,^IMRBKLAB:'$G(IMRSDBP(5.1))
 . S IMRLD=$S(IMRLAB>IMRLD:IMRLAB,1:IMRLD)
 . S IMRLD1=$S(IMRMI>IMRLD1:IMRMI,1:IMRLD1)
 . S:IMRLD'>0 IMRLD=""  S:IMRLD1'>0 IMRLD1=""
 . S $P(IMR101,"^",9,10)=IMRLD_"^"_IMRLD1
 . ; piece 13=last limited lab date, piece 17=last limited micro date
 . S $P(IMR101,"^",13)=IMRLD,$P(IMR101,"^",17)=IMRLD1
 . K IMRLD,IMRLD1
 ;
 ;--- Get Radiology Data
RAD ;
 S IMRLD=+$P(IMR101,"^",11) D ^IMRRAD S:'IMRLD IMRLD="" ;LAST RADIOLOGY DATE NOTED
 S $P(IMR101,"^",11)=$S(IMRRAD>IMRLD:IMRRAD,1:IMRLD) K IMRLD ;check latest EXAM DATE against last radiology date noted
 ;
 ;--- Get Dental Data
DENT ;
 S IMRLD=+$P(IMR101,"^",15) D DENT^IMRRAD S:'IMRLD IMRLD="" ;last dental appt date
 S $P(IMR101,"^",15)=$S(IMRDENT>IMRLD:IMRDENT,1:IMRLD) K IMRLD
 ;
 ;--- Get Outpatient Activity Data
OP ;
 S IMRLD=+$P(IMR101,"^",16) D OP^IMRSCH S:'IMRLD IMRLD="" ;last OP date
 S $P(IMR101,"^",16)=$S(IMROP>IMRLD:IMROP,1:IMRLD) K IMRLD ;check latest scheduling date/time against last OP date
 ;
WRAP S:IMRT2="NEW"!(IMRNXT2<IMRFN) IMRNXT2=IMRFN ;IMRNXT2=last new case
 S ^IMR(158,IMRFN,101)=IMRDT_"^"_$P(IMR101,"^",2,99) ;IMRDT=LAST DATE DATA SURVEYED
 Q
 ;
 ;***** SENDS A MESSAGE TO THE NATIONAL REGISTRY
SEND(NEWPAT) ;
 N IMRGI,TMP,XMDUZ,XMSUB,XMTEXT,XMY
 ;--- Address message to coordinator if MAIL LIST flag is set to YES
 S IMRGI=0
 F  S IMRGI=$O(^IMR(158.9,1,1,IMRGI))  Q:IMRGI'>0  D
 . S TMP=^IMR(158.9,1,1,IMRGI,0)
 . S:$P(TMP,U,2)=1 XMY(+TMP)=""
 ;--- Send the message
 S XMTEXT="^TMP($J,""IMRX"","
 S TMP=$E(IMRDTT,4,5)_"-"_$E(IMRDTT,6,7)_"-"_$E(IMRDTT,2,3)
 S XMSUB="IMMUNOLOGY DATA. "_IMRSTN_" "_TMP_" ("_IMRSET_")"
 S:$G(NEWPAT) XMSUB=XMSUB_"  *NEW PATIENT*"
 S XMDUZ=.5,XMY(IMRDOMN)=""
 D ^XMD
 ;--- Create continuation message
 K ^TMP($J)  S IMRFLAG=1
 D STARTSEG(),SEGS(1)
 Q
 ;
MOVCDC0 ; Send nodes File 158 nodes if CDC form was generated.
 Q:'IMRSEND
 D CDC0()
 F IMRI=1,2,102,108:1:112 I $G(^IMR(158,IMRFN,IMRI))'="" S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="CDC"_IMRI_"^"_^IMR(158,IMRFN,IMRI) D
 .D LCHK^IMRDAT
 .I IMRI=1 D
 ..S IMRNODE1=$G(^TMP($J,"IMRX",IMRC))
 ..S IMRSTATE=$P(IMRNODE1,U,13) ;state at onset of illness/aids
 ..I IMRSTATE'="" S IMRSTATE=$$GET1^DIQ(5,IMRSTATE,1,"E") ;state abbr
 ..S $P(IMRNODE1,U,13)=IMRSTATE
 ..S IMRSTATE=$P(IMRNODE1,U,18) ;state of hospital - aids dx
 ..I IMRSTATE'="" S IMRSTATE=$$GET1^DIQ(5,IMRSTATE,1,"E") ;state abbr
 ..S $P(IMRNODE1,U,18)=IMRSTATE
 ..S IMRSTATN=$P(IMRNODE1,U,8)
 ..I IMRSTATN'="" S IMRSTATN=$$GET1^DIQ(4,IMRSTATN,99,"I") ;station #
 ..S $P(IMRNODE1,U,8)=IMRSTATN
 ..S $P(IMRNODE1,U,2)="*1*"
 ..S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)=IMRNODE1
 ..K IMRNODE1,IMRSTATE
 ..Q
 .Q
 Q
 ;
 ;***** GENERATES THE CDC0 SEGMENT
CDC0() ;
 Q:$G(^IMR(158,IMRFN,0))=""
 S IMRC=IMRC+1
 S ^TMP($J,"IMRX",IMRC)="CDC0"_U_^IMR(158,IMRFN,0)
 D LCHK^IMRDAT
 Q
 ;
 ;***** PA & DE SEGMENTS
SEGS(FPA,FDE,SIZECHK,VADM) ;
 Q:$G(DFN)=""  Q:'$D(^DPT(DFN,0))
 Q:'$D(^IMR(158,IMRFN,0))
 N IMRDOB,IMRDOD,IMRELIG,IMRPOS,IMRSEPD,IMRSEX,IMRZIP,VA,VAEL,VAPA,VASV
 D DEM^VADPT,ELIG^VADPT,SVC^VADPT,ADD^VADPT
 ;--- Encrypt the patient SSN
 S X=$P(VADM(2),U)  D XOR^IMRXOR  S IMRSSN=X
 ;--- PA^Coded SSN
 I $G(FPA)  D  D:$G(SIZECHK) LCHK^IMRDAT
 . S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="PA"_"^"_IMRSSN
 ;--- Encrypt patient's date of birth
 S X=$E($P(VADM(3),U),1,5)_"00"  D XOR^IMRXOR  S IMRDOB=X ;
 ;--- Sex, ZIP code, and period of service (external value)
 S IMRSEX=$P(VADM(5),U),IMRZIP=VAPA(6),IMRPOS=$P(VAEL(2),U,2)
 ;--- Current primary eligibility & service separation date
 S IMRELIG=$P(VAEL(1),U,2),IMRSEPD=$P(VASV(6,5),U)
 ;--- Date of Death
 S IMRDOD=$P(VADM(6),U)
 I IMRDOD>0  D
 . ;--- Save MAS DOD as IMR Date of Death, flag DOD as from MAS
 . S $P(^IMR(158,IMRFN,5),U,19,20)=IMRDOD_U_1
 . S $P(^IMR(158,IMRFN,1),U,34)=2
 . ;--- Do not send the data after 60 days since DOD
 . S:DT>$$FMADD^XLFDT(IMRDOD,60) $P(^IMR(158,IMRFN,5),U,21)=1
 E  D
 . S:$P(^IMR(158,IMRFN,1),U,34)=2 $P(^(1),U,34)=1
 . S $P(^IMR(158,IMRFN,5),U,19,20)=U
 ;--- DE^date of birth (encrypted)^sex^zip code^period of service
 ;--- ^eligibility code^service separation date^^date of death
 I $G(FDE)  D  D:$G(SIZECHK) LCHK^IMRDAT
 . S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="DE"_"^"_IMRDOB_"^"_IMRSEX_"^"_IMRZIP_"^"_IMRPOS_"^"_IMRELIG_"^"_IMRSEPD_"^^"_IMRDOD_"^"_DFN
 S IMRFLG=0
 Q
 ;
 ;***** START SEGMENT
STARTSEG() ;
 K ^TMP($J,"IMRX")
 ;--- START^station number^date of data collection^message sequence
 ;--- number^encryption code^IMR version number
 S IMRC=IMRC+1,IMRSET=IMRSET+1
 S ^TMP($J,"IMRX",IMRC)="START"_"^"_IMRSTN_"^"_IMRDT_"^"_IMRSET_"^"_IMRCODE_"^"_$$VERSION^XPDUTL("IMR")_"^19"
 Q
