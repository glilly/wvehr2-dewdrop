IMRPDATA ; HCIOFO/FAI - DATA EXTRACTION ;10/02/01  11:10
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**16**;Feb 09, 1998
ENTRY ; Entry to run daily extract to gather past missing data.
 W !!,"This job will queue the nightly job for a particular date range for messages",!,"that were missed in the past when the background job did not finish."
 W !!,?5,"***WARNING*** This job will generate a large amount of mail messages.",!!,"Please do not select more than 7 days of data for each run of this extract.",!,"I will now search for entries to update your lab files with before starting"
 W !,"the extract.  You must then tell me a date range for extraction.",!,"This may take a while.....",!!
 G ASK
 Q
BETRAD N IMRTRANS
 Q:'$D(^IMR(158.9,1,0))  ;quit if no site parameters
 D ^IMRUTST
 D ^IMRDATE
 S IMRHNBEG=IMRHNBEG_".1800",IMRDTT=IMRHNBEG,$P(^IMR(158.9,1,0),"^",9)=IMRDTT ;set last start time equal to beginning date of range needed to pickup lost data
 S IMRC=0,IMRSET=0,X=^IMR(158.9,1,0) ;IMRC=message line counter, IMRSET= message counter
 S (IMRED,IMRDT)=IMRHNEND ;IMRED & IMRDT=set data extract end date/time
 S IMRSD=IMRHNBEG
 S IMRSD=$S(IMRSD>0:IMRSD\1,1:0)
EN1 ; Entry point from post-init. The following variables must be defined;
 ; IMRSD,IMRED,IMRC,IMRSET,IMRDT.
 S IMRTRANS=1 ; Tell the system that this is a transmit to national
 D DOMAIN^IMRUTL ;get the domain name for ICR
 S IMRDOMN="S.IMRHDATA@"_IMRDOMN ;append domain to server name
 S IMRM90=$$FMADD^XLFDT(DT,-90)
 K ^TMP($J)
 I '$D(IMRDTT) S IMRDTT=$$NOW^XLFDT(),$P(^IMR(158.9,1,0),U,9)=IMRDTT ;set LAST START TIME if doesn't exist
 I '$D(IMRSTN) D IMROPN^IMRXOR Q:'$D(IMRSTN)
 S X=10987654321 D XOR^IMRXOR S IMRCODE=X ;encrypt patient SSN
 S IMRC=IMRC+1,IMRSET=IMRSET+1 ;increment message line # & message sequence number
 ; set segment=START^station number^date of data collection^message sequence number^encryption code^IMR version number
 S ^TMP($J,"IMRX",IMRC)="START"_"^"_IMRSTN_"^"_IMRDT_"^"_IMRSET_"^"_IMRCODE_"^"_$$VERSION^XPDUTL("IMR")_"^4"
 ; NEXT CASE node: piece #1=NEXT CASE, piece #2=LAST NEW CASE
 S:'$D(^IMR(158.9,1,"NXT")) ^("NXT")=0 S IMRNXT2=+$P(^("NXT"),"^",2),IMRNXT1=+^("NXT")
 ; Process new entries first, then process existing entries
 S IMRFN=0
 F  S IMRFN=$O(^IMR(158,IMRFN)) Q:IMRFN'>0  S IMRSEND=0 D NXT,SEND
 S ^IMR(158.9,1,"NXT")="0^"_IMRNXT2
 S $P(^IMR(158.9,1,0),"^",10)=$$NOW^XLFDT() ;last completion date
KIL K IMRDENT,IMRRAD,IMRRX,IMRLAB,IMRMI,IMRSCH,IMRCODE,IMRT1,IMRT2,DFN,IMRDFN,IMRFN,IMRED,IMRDT,IMR101,IMRNXT1,IMRNXT2,IMRSDV,IMRSET,IMRSTN,X,X1,X2,IMRC,IMRSSN,%DT,Y,%H,%,IMRTRANS
 K ^TMP($J),%T,DIC,IMRN,IMRSCH1,J,XCNP,XMZ,VAERR,D,DISYS,POP,IMRPAD,IMRADM,IMRDIS,IMRDOMN,IMRSEND,IMR5,IMRDTT,IMRL,IMRT,IMRTEST,IMRTRAN,IMRTSTI,IMRSD,IMRAD,IMRM90
 Q
SEND ; Send Message To National Registry
 K XMY
 S XMTEXT="^TMP($J,""IMRX"",",XMSUB="IMMUNOLOGY DATA. "_IMRSTN_" "_$E(IMRDTT,4,5)_"-"_$E(IMRDTT,6,7)_"-"_$E(IMRDTT,2,3)_" ("_IMRSET_")",XMDUZ=.5,XMY(IMRDOMN)="" ;set up mail message variables
 D:IMRSEND ^XMD ;send message if more than START,PA,DE & TIME segments
 K ^TMP($J),XMTEXT,XMDUZ,XMY,XMSUB,IMRGI
 S IMRC=1,IMRSET=IMRSET+1
 S:IMRSEND=0 IMRSET=IMRSET-1
 S ^TMP($J,"IMRX",IMRC)="START"_"^"_IMRSTN_"^"_IMRDT_"^"_IMRSET_"^"_IMRCODE_"^"_$$VERSION^XPDUTL("IMR")
 Q
NXT D CLEAR
 ; Node 101 contains last dates noted for various services provided
 ; Node 5 is the date of death node
 S IMR101=$G(^IMR(158,IMRFN,101)),IMRI=+IMR101,IMR5=$G(^IMR(158,IMRFN,5))
 S IMRTRAN=$P(IMR5,"^",21) Q:IMRTRAN  ;data transmitted for deceased (1:YES,0:NO)
 S IMRDOD=$P(IMR5,"^",19) ;imr date of death
 S IMRT1=$P($H,",",2) ;IMRT1 is used to calculate the number of seconds needed to extract data for patient
 S X=+^IMR(158,IMRFN,0)
 D XOR^IMRXOR Q:'$D(^DPT(X,0))  ;decode patient id, quit if not in File 2
 S (DFN,IMRDFN)=X,IMRT2="" ;IMRT2 identify's record as new or update
 I $P(IMR101,"^",2)="" S IMRT2="NEW" D DEMOG ;piece #2=LAST SCHEDULING DATE NOTED
 I IMRT2="" S IMRT2="UPD" D DEMOG
 I IMR101'="" S IMRT1=$P($H,",",2)-IMRT1 S:IMRT1<0 IMRT1=IMRT1+(24*60*60) S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="TIME"_"^"_IMRT2_"^"_IMRT1
 Q
DEMOG Q:'$D(^DPT(DFN,0))
 D DEM^VADPT,ELIG^VADPT,SVC^VADPT,ADD^VADPT
 S X=$P(VADM(2),"^") D XOR^IMRXOR S IMRSSN=X ;encrypt patient SSN
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="PA"_"^"_IMRSSN
 S X=$E($P(VADM(3),"^"),1,5)_"00" D XOR^IMRXOR S IMRDOB=X ;encrypt patient's date of birth
 S IMRSEX=$P(VADM(5),"^"),IMRZIP=VAPA(6),IMRPOS=$P(VAEL(2),"^",2) ;sex, zip code, and IMRPOS=period of service (external value)
 S IMRELIG=$P(VAEL(1),"^",2),IMRSEPD=$P(VASV(6,5),"^") ;current primary eligibility & service separation date
 I 'IMRDOD S IMRDOD=$P(VADM(6),"^"),$P(^IMR(158,IMRFN,5),"^",19,20)=IMRDOD_"^"_1 ;save MAS DOD as IMR Date of Death, flag DOD as from MAS
 I IMRDOD,DT>$$FMADD^XLFDT(IMRDOD,60) S $P(^IMR(158,IMRFN,5),"^",21)=1 ;continue sending data for 60 days after date of death
 ; segment=Demographic^date of birth (encrypted)^sex^zip code^period of service^eligibility code^service separation date^^date of death
 S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="DE"_"^"_IMRDOB_"^"_IMRSEX_"^"_IMRZIP_"^"_IMRPOS_"^"_IMRELIG_"^"_IMRSEPD_"^^"_IMRDOD
 K IMRDOB,IMRSEX,IMRZIP,IMRPOS,IMRELIG,IMRSEPD,IMRDOD,VA,VADM,VAEL,VAPA,VASV S IMRFLG=0
IP S IMRLD=+$P(IMR101,"^",3),IMRLD1=+$P(IMR101,"^",4),IMRLD2=+$P(IMR101,"^",5) ;piece 3=LAST ADMIT DATE NOTED,piece 4=LAST DISCHARGE DATE NOTED,piece 5=LAST PTF ADMIT DATE NOTED
 D ^IMRPTF
 S $P(IMR101,"^",3,5)=$S(IMRADM>IMRLD:IMRADM,1:IMRLD)_"^"_$S(IMRDIS>IMRLD1:IMRDIS,1:IMRLD1)_"^"_$S(IMRPAD>IMRLD2:IMRPAD,1:IMRLD2)
 K IMRLD,IMRLD1,IMRLD2
 D GETDAT^IMRDAT1
 Q
CLEAR ; Kill Variables
 K IMRT1,IMRT2,DFN,IMRLD,IMRLD1,IMRLD2
 Q
ASK ; Entry Point to Process Data Extract For A Given Date Range
 D ^IMRUTST
 K %DT S %DT="AQEXP",%DT("A")="   Start Date for Period: " D ^%DT K %DT G:Y'>0 KIL S IMRSD=Y,%DT="AQEXP",%DT("A")="    End Date for Period: " D ^%DT K %DT G:Y'>0 KIL S IMRED=Y
 I IMRED<IMRSD W !,$C(7),"END CAN NOT BE BEFORE START",! G ASK
 S X1=IMRED,X2=IMRSD D ^%DTC I 'X S X1=IMRSD,X2=-1 D C^%DTC S IMRSD=X
 S IMRED=IMRED+.3,IMRDT=IMRED
 S $P(^IMR(158.9,1,0),"^",9)=$$NOW^XLFDT() ;LAST START TIME
 S IMRC=0,IMRSET=0
DQ ; Queue Data Extract
 W !!!
 K ZTUCI,ZTDTH,ZTIO,ZTSAVE
 S ZTRTN="EN1^IMRDAT"
 S ZTSAVE("*")=""
 S ZTIO="",ZTDESC="Process IMR Data Extract for a Date Range"
 D ^%ZTLOAD
 K ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTIO,ZTSK
 Q
