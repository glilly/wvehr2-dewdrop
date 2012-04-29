IMRPTF ; ISC-SF/JLI,HCIOFO/NCA,FT-EXTRACT PTF DATA FOR IMR REGISTRY DATABASE ; 7/5/02 1:54pm
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**14,18**;Feb 09, 1998
 ; Called from IMRDAT
 S (IMRADM,IMRDIS,IMRPAD,IMRPTX)=0
 ; check PTF file (#45) - IMREC=TYPE OF RECORD (1:PTF,2:CENSUS)
 S IMRPTF=0
 F  S IMRPTF=$O(^DGPT("B",IMRDFN,IMRPTF))  Q:IMRPTF'>0  D
 . D PTF^IMRUTL   Q:IMREC=2
 . I IMRDD  Q:IMRDD<IMRM90
 . S:'IMRPTX IMRPTX=IMRAD  D PTF
 K IMRBS,IMRDD,IMRM1,IMRM2,IMRMN,IMRPTF,IMRPTX,IMRFLG,IMRI,IMRN,IMRST,IMRDSP,IMRDISP,IMROUT,IMRX,IMRX1,IMRAR,IMREC,X,IMR3
 Q
PTF ; Process Data Extract for PTF
 Q:'IMRAD  ;quit if no admission date
 I IMRDD,IMRDD<IMRAD Q  ;quit if discharge date before admission date
 Q:IMRAD>IMRED  ;quit if admission date after end date
 ;--- Double check admission date. If not valid, set IMRFLG=1;
 ;--- pass back discharge date if it exists
 I 'IMRDD  S IMRFLG=0  D  Q:IMRFLG
 . D DBCHK^IMRLCNT(IMRDFN,IMRAD,.IMRDD,.IMRFLG)
 ;--- Send the admission IP segment once and wait for discharge
 I 'IMRDD  Q:IMRAD<IMRSD
 ;--- InPatient episode
 S IMRX="IP"_"^"_$S(IMRAD>0:IMRAD\1,1:"")_"^"
 I IMRAD>IMRADM S IMRADM=IMRAD I IMRDD'>0 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)=IMRX S IMRSEND=1 K IMRX Q
 Q:IMRDD'>0
 S:IMRDD>IMRDIS IMRDIS=IMRDD
 S IMRX=IMRX_(IMRDD\1)_"^"_IMRDSP_"^"_IMRDISP_"^"_IMROUT_"^" ;IMRDD=discharge date, IMRDSP=discharge specialty, IMRDISP=type of disposition, IMROUT=outpatient treatment
 D ICDP^IMRUTL S (IMRI,IMRX1)="" ;get ICD codes (in IMRAR array)
 G:'$D(IMRAR(45)) PTF1
 ; concatenate ICD codes
 S IMRI=$O(IMRAR(45,IMRI))
 I IMRI'="" F IMRN=0:0 S IMRN=$O(IMRAR(45,IMRI,IMRN)) Q:IMRN<1  S X=$G(IMRAR(45,IMRI,IMRN,"E")) S IMRX1=IMRX1_X_"^"
 S:IMRX1'="" IMRX1=$E(IMRX1,1,$L(IMRX1)-1) ;omit last up-arrow
PTF1 S IMRX=IMRX_IMRX1
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)=IMRX S IMRSEND=1 K IMRX
 ; IMRST=status, IMRPTX=admission date
 I IMRST>1&(IMRPTX=IMRAD) D PTFM S:IMRAD>IMRPAD IMRPAD=IMRAD S IMRPTX=0
 Q
PTFM ; IPM segment
 D ICDM^IMRUTL G:'$D(IMRAR(45.02)) PTFS ;get movement data
 D REORDER^IMRUTL
 S IMRM2=IMRAD\1,IMR3=0
 F  S IMR3=$O(IMR4502(IMR3)) Q:'IMR3  S IMRI="" F  S IMRI=$O(IMRAR(45.02,IMRI)) Q:IMRI=""  I $G(IMRAR(45.02,IMRI,10,"I"))=IMR3 D
 .S (IMRX,IMRX1)="",IMRM1=IMRM2
 .S IMRBS=$G(IMRAR(45.02,IMRI,2,"E")) ;losing specialty
 .F IMRN=5:1:9,11:1:15 S X=$G(IMRAR(45.02,IMRI,IMRN,"E")) S IMRX1=IMRX1_X_"^" ;concatenate ICD codes
 .S:IMRX1'="" IMRX1=$E(IMRX1,1,$L(IMRX1)-1) ;omit last up-arrow
 .S IMRM2=$G(IMRAR(45.02,IMRI,10,"I")) ;movement date
 .S IMRX=IMRX_"^"_IMRX1
 .S IMRBS=$S(IMRBS="":$$TREAT^IMRLCNT(IMRDFN),1:IMRBS) ;treatment specialty (external value)
 .S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="IPM"_"^"_(IMRM1\1)_"^"_(IMRM2\1)_"^"_IMRBS_IMRX_"^"_(IMRAD\1) S IMRSEND=1 K IMRX,IMRX1 ;IMRAD=admission date,IMRM1=begin movement,IMRM2=end movement,IMRBS=losing specialty
 .Q
PTFS ; Obtain Surgery/Procedure Operation Codes (#401)
 D SPROC^IMRUTL G:'$D(IMRAR(45.01)) PTFP S IMRI=""
 F  S IMRI=$O(IMRAR(45.01,IMRI)) Q:IMRI=""  D
 .S (IMRX,IMRX1)=""
 .S IMRX=($G(IMRAR(45.01,IMRI,.01,"I"))\1) ;surgery/procedure date
 .F IMRN=8:1:12 S X=$G(IMRAR(45.01,IMRI,IMRN,"E")) S IMRX1=IMRX1_X_"^" ;concatenate operation codes 1-5
 .Q:IMRX1=""
 .S:IMRX1'="" IMRX1=$E(IMRX1,1,$L(IMRX1)-1) ;omit last up-arrow
 .S IMRX=IMRX_"^"_IMRX1
 .S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="IPS"_"^"_(IMRAD\1)_"^"_IMRX K IMRX,IMRX1 S IMRSEND=1 ;IMRAD=admission date
 .Q
PTFP ; Obtain Procedure Codes (#601)
 D PROC^IMRUTL Q:'$D(IMRAR(45.05))  S IMRI=""
 F  S IMRI=$O(IMRAR(45.05,IMRI)) Q:IMRI=""  D
 .S (IMRX,IMRX1)=""
 .S IMRX=($G(IMRAR(45.05,IMRI,.01,"I"))\1) ;procedure date
 .S IMRX=IMRX_"^"_$G(IMRAR(45.05,IMRI,1,"E"))
 .F IMRN=4:1:8 S X=$G(IMRAR(45.05,IMRI,IMRN,"E")) S IMRX1=IMRX1_X_"^" ;concatenate procedure codes 1-5
 .Q:IMRX1=""
 .S:IMRX1'="" IMRX1=$E(IMRX1,1,$L(IMRX1)-1) ;omit last up-arrow
 .S IMRX=IMRX_"^"_IMRX1
 .S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="IPP"_"^"_(IMRAD\1)_"^"_IMRX S IMRSEND=1 ;IMRAD=admission date
 .K IMRX,IMRX1
 .Q
 Q
