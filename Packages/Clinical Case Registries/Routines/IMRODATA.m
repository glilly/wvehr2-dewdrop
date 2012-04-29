IMRODATA ; HCIOFO-FAI/SPS - SPECIAL DATA EXTRACT; 03/29/02 13:35 ;
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**15**;Feb 09, 1998
ENTRY ; Entry to run daily extract to gather past missing data.
 I $$PATCH^XPDUTL("IMR*2.1*15")=1 W !,?23,"***PATCH 15 EXTRACT HAS ALREADY BEEN RUN***" D KIL Q
 W !!,"This is a one-time run job to populate the National Database ",!,"with data starting from 1/1/84."
 S ZTDTH=XPDQUES("POS1")
 D ASK
 Q
EN1 ; Entry point from post-init. The following variables must be defined;
 ; IMRED,IMRC,IMRSET,IMRDT
 Q:'$D(^IMR(158.9,1,0))  ;quit if no site parameters
 N IMRTRANS S U="^",IMRC=0,IMRSET=0 ;IMRC=message line counter, IMRSET=message counter
 S (IMRED,IMRDT,IMRDTT)=$$NOW^XLFDT()  ;IMRED & IMRDT=set data extract end date/time
 S IMRTRANS=1,IMRSD="2840101" ; Tell the system that this is a transmit to national
 D DOMAIN^IMRUTL ;get the domain name for ICR
 S IMRDOMN="S.IMRHDATA@"_IMRDOMN ;append domain to server name
 K ^TMP($J)
 I '$D(IMRSTN) D IMROPN^IMRXOR Q:'$D(IMRSTN)
 S X=10987654321 D XOR^IMRXOR S IMRCODE=X ;encrypt patient SSN
 ;increment message line # & message sequence number below
 ; set segment=START^station number^date of data collection^message sequence number^encryption code^IMR version number
 S IMRC=IMRC+1,IMRSET=IMRSET+1
 S ^TMP($J,"IMRX",IMRC)="START"_"^"_IMRSTN_"^"_IMRDT_"^"_IMRSET_"^"_IMRCODE_"^"_$$VERSION^XPDUTL("IMR")_"^15" D SEGS,LCHK
 ; NEXT CASE node: piece #1=NEXT CASE, piece #2=LAST NEW CASE
 S:'$D(^IMR(158.9,1,"NXT")) ^("NXT")=0 S IMRNXT2=+$P(^("NXT"),"^",2),IMRNXT1=+^("NXT")
 ; Process new entries first, then process existing entries
 S IMRFN=0
 F  S IMRFN=$O(^IMR(158,IMRFN)) Q:IMRFN'>0  S IMRSEND=0 D NXT
 D SEND^IMRODAT1
 D LCHK
KIL K IMRDENT,IMRRAD,IMRRX,IMRLAB,IMRMI,IMRSCH,IMRCODE,IMRT1,IMRT2,DFN,IMRDFN,IMRFN,IMRED,IMRDT,IMR101,IMRNXT1,IMRNXT2,IMROP,IMRSET,IMRSTN,X,X1,X2,IMRC,IMRSSN,%DT,Y,%H,%,IMRTRANS
 K ^TMP($J),%T,DIC,IMRN,IMRSCH1,J,XCNP,XMZ,VAERR,D,DISYS,POP,IMRPAD,IMRADM,IMRDIS,IMRDOMN,IMRSEND,IMR5,IMRDTT,IMRL,IMRT,IMRTEST,IMRTRAN,IMRTSTI,IMRSD,IMRAD,IMRM90
 D POST^IMRPT15
 Q
HEADER ; set segment=START^station number^date of data collection^message sequence number^encryption code^IMR version number
 S IMRC=IMRC+1,IMRSET=IMRSET+1,^TMP($J,"IMRX",IMRC)="START"_"^"_IMRSTN_"^"_IMRDT_"^"_IMRSET_"^"_IMRCODE_"^"_$$VERSION^XPDUTL("IMR")_"^15" D SEGS,LCHK
 Q
NXT D CLEAR
 ; Node 101 contains last dates noted for various services provided
 ; Node 5 is the date of death node
 S IMR101=$G(^IMR(158,IMRFN,101)),IMRI=+IMR101,IMR5=$G(^IMR(158,IMRFN,5)),IMRTRAN=$P(IMR5,"^",21)
 S IMRT1=$P($H,",",2) ;IMRT1 is used to calculate the number of seconds needed to extract data for patient
 S X=+^IMR(158,IMRFN,0)
 D XOR^IMRXOR Q:'$D(^DPT(X,0))  ;decode patient id, quit if not in File 2
 S (DFN,IMRDFN)=X,IMRT2="" ;IMRT2 identify's record as new or update
 I $P(IMR101,"^",2)="" S IMRT2="NEW" D DEMOG ;piece #2=LAST SCHEDULING DATE NOTED
 I IMRT2="" S IMRT2="UPD" D DEMOG
 I IMR101'="" S IMRT1=$P($H,",",2)-IMRT1 S:IMRT1<0 IMRT1=IMRT1+(24*60*60) S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="TIME"_"^"_IMRT2_"^"_IMRT1 D LCHK
LCHK I (IMRC#5000)=0 D SEND^IMRODAT1 Q
 Q
DEMOG Q:'$D(^DPT(DFN,0))
 D DEM^VADPT,ELIG^VADPT,SVC^VADPT,ADD^VADPT
 Q:$G(VADM(2))=""  S X=$P(VADM(2),"^") D XOR^IMRXOR S IMRSSN=X ;encrypt patient SSN
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="PA"_"^"_IMRSSN D LCHK
 Q:$G(VADM(3))=""  S X=$E($P(VADM(3),"^"),1,5)_"00" D XOR^IMRXOR S IMRDOB=X ;encrypt patient's date of birth
 Q:$G(VADM(5))=""  S IMRSEX=$P(VADM(5),"^"),IMRZIP=$G(VAPA(6)),IMRPOS=$P($G(VAEL(2)),"^",2) ;sex, zip code, and IMRPOS=period of service (external value)
 S IMRELIG=$P($G(VAEL(1)),"^",2),IMRSEPD=$P($G(VASV(6,5)),"^") ;current primary eligibility & service separation date
 S IMRDOD=$P($G(VADM(6)),"^")
 I +IMRDOD>0 D
 . S $P(^IMR(158,IMRFN,5),"^",19,20)=IMRDOD_"^"_1,$P(^IMR(158,IMRFN,1),U,34)=2 ;save MAS DOD as IMR Date of Death, flag DOD as from MAS
 . I IMRDOD S $P(^IMR(158,IMRFN,5),"^",21)=1 ;is this data for deceased patient?
 I IMRDOD'>0 D
 . S:$P(^IMR(158,IMRFN,1),U,34)=2 $P(^(1),U,34)=1
 . S $P(^IMR(158,IMRFN,5),U,19,20)=""_U_""
 ; segment=DEmographic^date of birth (encrypted)^sex^zip code^period of service^eligibility code^service separation date^^date of death
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="DE"_"^"_IMRDOB_"^"_IMRSEX_"^"_IMRZIP_"^"_IMRPOS_"^"_IMRELIG_"^"_IMRSEPD_"^"_"^"_IMRDOD D LCHK
 K IMRDOB,IMRSEX,IMRZIP,IMRPOS,IMRELIG,IMRSEPD,IMRDOD,VA,VADM,VAEL,VAPA,VASV S IMRFLG=0
 D GETDAT^IMRODAT1
 Q
CLEAR ; Kill Variables
 K IMRT1,IMRT2,DFN,IMRLD,IMRLD1,IMRLD2
 Q
ASK ; Entry Point to Process Data Extract For A Given Date Range
 S IMRSD="2840101",(IMRDT,IMRED)=DT,IMRC=0,IMRSET=0
DQ ; Queue Data Extract
 D NOW^%DTC
 I $G(ZTDTH)="" S ZTDTH=%H
 S ZTRTN="EN1^IMRODATA"
 S ZTSAVE("*")="",ZTIO="",ZTDESC="Patch 15 One-Time IMR Data Extract"
 D ^%ZTLOAD
 K ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTIO,ZTSK
 Q
SEGS ;
 Q:$G(DFN)=""
 Q:'$D(^DPT(DFN,0))
 Q:'$D(^IMR(158,IMRFN,0))
 D DEM^VADPT,ELIG^VADPT,SVC^VADPT,ADD^VADPT
 S X=$P(VADM(2),"^") D XOR^IMRXOR S IMRSSN=X ;encrypt patient SSN
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="PA"_"^"_IMRSSN
 S X=$E($P(VADM(3),"^"),1,5)_"00" D XOR^IMRXOR S IMRDOB=X ;encrypt patient's date of birth
 S IMRSEX=$P(VADM(5),"^"),IMRZIP=VAPA(6),IMRPOS=$P(VAEL(2),"^",2) ;sex, zip code, and IMRPOS=period of service (external value)
 S IMRELIG=$P(VAEL(1),"^",2),IMRSEPD=$P(VASV(6,5),"^") ;current primary eligibility & service separation date
 S IMRDOD=$P(VADM(6),"^")
 I +IMRDOD>0 D
 . S $P(^IMR(158,IMRFN,5),"^",19,20)=IMRDOD_"^"_1,$P(^IMR(158,IMRFN,1),U,34)=2 ;save MAS DOD as IMR Date of Death, flag DOD as from MAS
 . I IMRDOD S $P(^IMR(158,IMRFN,5),"^",21)=1 ;is this data for deceased patient?
 I IMRDOD'>0 D
 . Q:'$D(^IMR(158,IMRFN,0))
 . S:$P(^IMR(158,IMRFN,1),U,34)=2 $P(^(1),U,34)=1
 . S $P(^IMR(158,IMRFN,5),U,19,20)=""_U_""
 ; segment=DEmographic^date of birth (encrypted)^sex^zip code^period of service^eligibility code^service separation date^^date of death
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="DE"_"^"_IMRDOB_"^"_IMRSEX_"^"_IMRZIP_"^"_IMRPOS_"^"_IMRELIG_"^"_IMRSEPD_"^"_"^"_IMRDOD
 S IMRFLG=0
 Q
