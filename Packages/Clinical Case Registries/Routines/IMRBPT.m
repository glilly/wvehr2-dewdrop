IMRBPT ; HCIOFO/FAI - DATA EXTRACTION ; 10/18/02 10:02am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**13,16,18,19**;Feb 09, 1998
 ;
 ;***** DATA EXTRACTION FOR NEW PATIENT
ENTRY ;
 N IMRTRANS  S U="^"
 S IMRC=0                           ; Message line counter
 S IMRSET=0                         ; Message counter
 ;--- IMRED & IMRDT = Data extract end date/time
 S (IMRED,IMRDT)=$$NOW^XLFDT()
 ;--- Backpull from 01/01/1990 (instead of DT-365) for new patients
 S IMRSD=2900101 ; IMR*2.1*18
EN1 ;--- Entry point from post-init. The following variables must
 ;--- be defined: IMRSD,IMRED,IMRC,IMRSET,IMRDT.
 S IMRTRANS=1 ; Tell the system that this is a transmit to national
 D DOMAIN^IMRUTL                    ; Get the domain name for ICR
 S IMRDOMN="S.IMRHDATA@"_IMRDOMN    ; Append domain to server name
 S IMRDTT=DT,IMRM90=$$FMADD^XLFDT(DT,-90)
 K ^TMP($J)
 ;--- Get station number if it is not defined
 I '$D(IMRSTN) D IMROPN^IMRXOR  Q:'$D(IMRSTN)
 ;--- Create the message
 S X=10987654321  D XOR^IMRXOR  S IMRCODE=X
 D STARTSEG^IMRDAT1()
 ;--- Process patient's data
 S IMRSEND=0  D NXT,SEND^IMRDAT1(1)
 ;--- Cleanup
KIL K IMRDENT,IMRRAD,IMRRX,IMRLAB,IMRMI,IMRSCH,IMRCODE,IMRT1,IMRT2,IMRDFN,IMRFN,IMRED,IMRDT,IMR101,IMRNXT1,IMRNXT2,IMRSDV,IMRSET,IMRSTN,X,X1,X2,IMRC,IMRSSN,%DT,Y,%H,%,IMRTRANS
 K ^TMP($J),%T,DIC,IMRN,IMRSCH1,J,XCNP,XMZ,VAERR,D,DISYS,POP,IMRPAD,IMRADM,IMRDIS,IMRDOMN,IMRSEND,IMR5,IMRDTT,IMRL,IMRT,IMRTEST,IMRTRAN,IMRTSTI,IMRSD,IMRAD,IMRM90
 Q
 ;
 ;*****
NXT D CLEAR
 ;--- Node 101 contains last dates noted for various services provided
 S IMR101=$G(^IMR(158,IMRFN,101)),IMRI=+IMR101
 ;--- Node 5 is the date of death node
 S IMR5=$G(^IMR(158,IMRFN,5))
 ;--- Data transmitted for deceased (1:YES,0:NO)
 S IMRTRAN=$P(IMR5,U,21)  Q:IMRTRAN
 S IMRDOD=$P(IMR5,U,19) ; imr date of death
 ;--- IMRT1 is used to calculate the number of seconds needed
 ;--- to extract data for patient
 S IMRT1=$P($H,",",2)
 ;--- Decode patient id; quit if not in File 2
 S X=+^IMR(158,IMRFN,0)  D XOR^IMRXOR  Q:'$D(^DPT(X,0))
 S (DFN,IMRDFN)=X
 ;--- Piece #2 = LAST SCHEDULING DATE NOTED
 I $P(IMR101,U,2)=""  D
 . S IMRT2="NEW"  D DEMOG,CDC
 E  S IMRT2="UPD"  D DEMOG
 ;---
 I IMR101'=""  S IMRT1=$P($H,",",2)-IMRT1  D
 . S:IMRT1<0 IMRT1=IMRT1+(24*60*60)
 . S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="TIME"_"^"_IMRT2_"^"_IMRT1
 Q
 ;
CDC ; Get Patient Data From File 158
 I $D(^IMR(158,IMRFN,1)),$P(^(1),"^",6)>0,$P(IMR101,"^",14)<$P(^(1),"^",6) S IMRLD=$P(^IMR(158,IMRFN,1),"^",6),$P(IMR101,"^",14)=IMRLD K IMRLD ;piece 6=date cdc form completed, piece 14=last cdc form date
 D MOVCDC0^IMRBPT1
 Q
 ;
DEMOG Q:'$D(^DPT(DFN,0))
 D SEGS^IMRDAT1(1,1,1,.VADM)
 ;--- Race (IMR*2.1*19)
 D:$G(VADM(12))>0
 . N I  S I=""
 . F  S I=$O(VADM(12,I))  Q:I=""  D  D LCHK^IMRDAT
 . . S IMRC=IMRC+1
 . . S ^TMP($J,"IMRX",IMRC)="DER^"_$P(VADM(12,I),U)_"^"_$P($G(VADM(12,I,1)),U)
 ;--- Ethnicity (IMR*2.1*19)
 D:$G(VADM(11))>0
 . N I  S I=""
 . F  S I=$O(VADM(11,I))  Q:I=""  D  D LCHK^IMRDAT
 . . S IMRC=IMRC+1
 . . S ^TMP($J,"IMRX",IMRC)="DEE^"_$P(VADM(11,I),U)_"^"_$P($G(VADM(11,I,1)),U)
 ;--- Cleanup
 K VADM  S IMRFLG=0
 ;--- Inpatient Data
IP S IMRLD=+$P(IMR101,"^",3),IMRLD1=+$P(IMR101,"^",4),IMRLD2=+$P(IMR101,"^",5) ;piece 3=LAST ADMIT DATE NOTED,piece 4=LAST DISCHARGE DATE NOTED,piece 5=LAST PTF ADMIT DATE NOTED
 D ^IMRPTF
 S $P(IMR101,"^",3,5)=$S(IMRADM>IMRLD:IMRADM,1:IMRLD)_"^"_$S(IMRDIS>IMRLD1:IMRDIS,1:IMRLD1)_"^"_$S(IMRPAD>IMRLD2:IMRPAD,1:IMRLD2)
 K IMRLD,IMRLD1,IMRLD2
 D GETDAT^IMRBPT1
 Q
 ;
CLEAR ; Kill Variables
 K IMRT1,IMRT2,DFN,IMRLD,IMRLD1,IMRLD2
 Q
 ;
DQ ; Queue Data Extract
 K ZTUCI,ZTDTH,ZTIO,ZTSAVE
 S ZTRTN="EN1^IMRBPT"
 S ZTSAVE("IMRSD")="",ZTSAVE("IMRED")="",ZTSAVE("IMRC")="",ZTSAVE("IMRSET")="",ZTSAVE("IMRDT")=""
 S ZTDTH=$$NOW^XLFDT()
 S ZTIO="",ZTDESC="Process Data Extract for a Date Range"
 D ^%ZTLOAD
 K ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTIO,ZTSK
 Q
