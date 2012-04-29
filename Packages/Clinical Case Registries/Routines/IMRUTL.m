IMRUTL ;HCIOFO/SPS - Immunology Data Gathering Utility Routine ; 10/7/02 11:24am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**8,9,5,18,19**;Feb 09, 1998
 ;
 ; Referrence to EN^PSOORDER supported by DBIA #1878
 ;
RAD ; Get Radiology exam data. Output is in ^TMP($J,"RAE1"))
 D EN1^RAO7PC1(IMRDFN,IMRSD,IMRED,999999)
 Q
RXARC(DFN) ; Input IMRDFN and Return the last Deletion Date of patient in Variable Y
 N IMRARC,IMRRI S Y="" D GETS^DIQ(55,DFN,"101*","I","IMRARC") ;101*=archive date of pharmacy patient file
 G:'$D(IMRARC) EXIT
 S IMRRI="A" F  S IMRRI=$O(IMRARC(55.13,IMRRI),-1) Q:IMRRI=""  D
 .S Y=$P(IMRRI,",",1) Q:'Y
 .Q
EXIT Q Y
RX1589() ; Return the archive date stored in File 158.9
 Q $P($G(^IMR(158.9,1,"A")),U,1)
 ;
RX ; Gathering the Outpatient Pharmacy Data
 N BUF,I,L
 D EN^PSOORDER(,IMRR)
 ;
 S BUF=$G(^TMP("PSOR",$J,IMRR,0))
 S IMRRXD1=$P(BUF,U)                         ; issue date
 S IMRFILDT=$P(BUF,U,2)                      ; fill date
 S IMRRXD=$P(BUF,U,3)                        ; last dispensed date
 S IMRDST=$$UP^XLFSTR($P($P(BUF,U,4),";",2)) ; status
 S IMRQ=$P(BUF,U,6)                          ; qty
 S IMRDSUP=$P(BUF,U,7)                       ; days supply
 S IMREF=$P(BUF,U,8)                         ; # of refills
 S IMRUCST=$P(BUF,U,10)                      ; unit price of drugs
 S IMREXP=$P(BUF,U,12)                       ; expiration date
 ;
 S BUF=$G(^TMP("PSOR",$J,IMRR,1))
 S IMRPS=$P($P(BUF,U,5),";",2)               ; patient status
 S IMRCL=+$P(BUF,U,4)                        ; clinic
 S IMRCL=+$$ARSC^IMRUTL(+IMRCL)              ; pointer to File 40.7
 ;                                           ; AMIS stop code
 S IMRCL=$S(IMRCL:$P($G(^DIC(40.7,IMRCL,0)),U,2),1:"")
 ;
 S BUF=$G(^TMP("PSOR",$J,IMRR,"DRUG",0))
 S IMRRXDR=$P($P(BUF,U),";",2)               ; drug
 S IMRXX1=+$P(BUF,U)
 ; Price per dispensed unit
 S IMRDU=$S(IMRXX1:$$GET1^DIQ(50,IMRXX1,16,"I"),1:0)
 ;
 S (I,IMRXSIG)="",L=245
 F  S I=$O(^TMP("PSOR",$J,IMRR,"SIG1",I))  Q:I=""  D  Q:L'>0
 . S BUF=$G(^TMP("PSOR",$J,IMRR,"SIG1",I,0))
 . S IMRXSIG=IMRXSIG_" "_$E(BUF,1,L)
 . S L=L-$L(BUF)-1  S:L<-1 IMRXSIG=IMRXSIG_"..."
 S IMRXSIG=$$TRIM^XLFSTR(IMRXSIG)
 Q
 ;
RXF ; Get the Refill Information
 K IMRAR D GETS^DIQ(52,IMRR,"52*","I","IMRAR") ;refill
 Q
PTF ; Get PTF Data
 S IMRAD=$$GET1^DIQ(45,IMRPTF,2,"I") ;admission date
 S IMRST=$$GET1^DIQ(45,IMRPTF,6,"I") ;status
 S IMREC=$$GET1^DIQ(45,IMRPTF,11,"I") ;type of record
 S IMRDD=$$GET1^DIQ(45,IMRPTF,70,"I") ;discharge date
 S IMRDSP=$$GET1^DIQ(45,IMRPTF,71,"E") ;discharge specialty
 S IMRDISP=$$GET1^DIQ(45,IMRPTF,72,"E") ;type of disposition
 S IMROUT=$$GET1^DIQ(45,IMRPTF,73,"I") ;outpatient treatment
 S IMRSUF=$$GET1^DIQ(45,IMRPTF,5,"I") ;suffix
 S IMRFB=$$GET1^DIQ(45,IMRPTF,4,"I") ;fee basis
 Q
ICDP ; Get the ICD Codes
 K IMRAR D GETS^DIQ(45,IMRPTF,"79;79.16;79.17;79.18;79.19;79.201;79.21;79.22;79.23;79.24","E","IMRAR") ;79=dxls, 79.16-79.24=icd2-icd10
 Q
ICDM ; Get the ICD Codes
 K IMRAR D GETS^DIQ(45,IMRPTF,"50*","EI","IMRAR") ;501->movement record
 Q
SPROC ; Get Surgery/Procedure Operation Code
 K IMRAR D GETS^DIQ(45,IMRPTF,"40*","EI","IMRAR") ;401->surgery/procedure
 Q
PROC ; Get Procedure Code
 K IMRAR D GETS^DIQ(45,IMRPTF,"60*","EI","IMRAR") ;601->procedure date
 Q
CAT ; Check Category of Patient For a Specified Date Range
 N XC0,Y1,Y2,Y3,Y4 S XC0=$G(^IMR(158,IMRRL,0)),Y1=$P(XC0,"^",36),Y3=$P(XC0,"^",35),Y4=$P(XC0,"^",23),Y2=$P(XC0,"^",44)
 S IMR0C=$S(Y4>0&(Y4'>IMRED):4,Y3>0&(Y3'>IMRED):3,Y2>0&(Y2'>IMRED):2,Y1>0&(Y1'>IMRED):1,1:$S(+$G(IMR0C):+$G(IMR0C),1:0))
 ; piece 36->date of hiv+ (cat 1) status
 ; piece 35->date of aids (cat 3) status
 ; piece 23->date of aids (cat 4)
 ; piece 44->date of hiv+ (cat 2) status
 Q
LAB60 ; Retrieve the Laboratory Test Name
 S IMRLAB60=$$GET1^DIQ(60,IMR60,.01,"E")
 Q
NLAB ; Retrieve the National Lab Name
 S IMRNLAB=""
 S IMRNLAB=$$GET1^DIQ(60,IMRLABT,64,"E")
 Q
LRARC ; Return the Date of Lab data Purge in variable IMRLRC
 N IMRAR,IMRI D GETS^DIQ(69.9,1,"600*","I","IMRAR") ;archive data field of the laboratory site file
 S IMRLRC="" Q:'$D(IMRAR)
 S IMRI="" F  S IMRI=$O(IMRAR(69.9003,IMRI)) Q:IMRI=""  S IMRLRC=$G(IMRAR(69.9003,IMRI,4,"I")) ;4->for data before date
 Q
REORDER ; re-order IMRAR array for File 45, field #50 (501) to make data
 ; in order of date
 S IMRLOOP="" K IMR4502,IMRFIRST
 F  S IMRLOOP=$O(IMRAR(45.02,IMRLOOP)) Q:IMRLOOP=""  D
 .I +$P(IMRLOOP,",",1)=1 S IMRFIRST=IMRAR(45.02,IMRLOOP,2,"E")
 .I +IMRAR(45.02,IMRLOOP,10,"I")>0 D
 ..S IMRMOVE=+IMRAR(45.02,IMRLOOP,10,"I") Q:'IMRMOVE
 ..S IMR4502(IMRMOVE)=IMRAR(45.02,IMRLOOP,2,"E")
 ..Q
 .Q
 K IMRLOOP,IMRMOVE
 Q
DENT ; retrieve dental entry for a patient
 ; Input=IMRRAI which is the .01 value (date/time) of File 221 entry
 K IMRAR
 Q:$G(IMRRAI)'>0
 D GETS^DIQ(221,IMRRAI,"*","EI","IMRAR")
 Q
SDV ; get data from Scheduling Visits file (#409.5)
 ; Input=IMRSDVI
 K IMRAR
 Q:$G(IMRSDVI)'>0
 D GETS^DIQ(409.5,IMRSDVI,"*","EI","IMRAR")
 Q
SDVCS ; get Clinic Stop Codes (#10) from Scheduling Visits file (#409.5)
 K IMRAR
 K IMRAR D GETS^DIQ(409.5,IMRSDVI,"10*","EI","IMRAR")
 Q
PSOAC ; Store archive data from Pharmacy package
 ; Called from the PSOARCCO routine
 Q:$G(PSOAC)'>0  ;PSOAC must be defined
 Q:PSOAC<$$RX1589^IMRUTL()  ;quit if new archive date is before existing
 N DA,DIE,DR
 S DA=$O(^IMR(158.9,0)) Q:'DA
 S DIE="^IMR(158.9,",DR="99///"_PSOAC
 D ^DIE
 Q
DOMAIN ; Return Domain name for Immunology in variable IMRDOMN
 S IMR1589=$O(^IMR(158.9,0)) I 'IMR1589 S IMRDOMN="" Q
 S IMRDOMN=+$G(^IMR(158.9,1,"DOMAIN")) I 'IMRDOMN S IMRDOMN="" Q
 S IMRDOMN=$$GET1^DIQ(4.2,IMRDOMN,.01,"I") ;domain name
 K IMR1589
 Q
ARSC(IMRARSC) ; AMIS Reporting Stop Code
 Q $$GET1^DIQ(44,IMRARSC,8,"I")
 ;
RESULT(IMRESULT) ; Massage lab result to return a number
 S IMRESULT=$$UP^XLFSTR(IMRESULT)
 S IMRESULT=$TR(IMRESULT,"ABCDEFGHIJKLMNOPQRSTUVWXYZ,<>!@#$%^&*-_+=':;/?\`~","")
 S IMRESULT=+IMRESULT
 Q IMRESULT
 ;
AGE(X1,X2) ; calculate number of years between two dates (e.g., age)
 ; X1 is the first date (in FileMan format), for example, date of birth
 ; X2 is the second date (in FileMan format), for example, DT
 ; if X2 is undefined, then it is assumed to be DT
 ; X1 is subtracted from X2
 ; returns value in IMRAGE
 N IMRAGE
 S IMRAGE=""
 S:'$D(X2) X2=DT
 I X1'="" S IMRAGE=$E(X2,1,3)-$E(X1,1,3)-($E(X2,4,7)<$E(X1,4,7))
 Q IMRAGE
NTLAB1(X) ; Get pointer to NTLF from file 158.9
 ;   X = Local lab file entry
 ;   NTL = NTL IEN
 N NTL
 S NTL=""
 I $D(^IMR(158.9,"ALR",X)) D
 .N L1,L2,L3,LINE
 .S (L1,L2,L3)=0
 .S L1=$O(^IMR(158.9,"ALR",X,L1)) Q:L1<1
 .S L2=$O(^IMR(158.9,"ALR",X,L1,L2)) Q:L2<1
 .S L3=$O(^IMR(158.9,"ALR",X,L1,L2,L3)) Q:L3<1
 .S NTL=+$G(^IMR(158.9,L1,3,L2,1,L3,0)) Q:NTL=""
 .Q
 Q NTL
