IMRRXL ;HCIOFO/NCA/FT/FAI-List Data on Outpatient Pharmacy Utilization ;07/17/00  16:54
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
 ;[IMR PHARM UTILIZATION LIST] - Pharmacy Prescription Utilization Data
ASK ; date range for report
 D ^IMRDATE Q:$G(IMRHNBEG)=""
 S IMRSD=IMRHNBEG,IMRED=IMRHNEND
 ;K %DT S %DT="AQEXP",%DT("A")="   Start Date for Period: " D ^%DT K %DT G:Y'>0 KILL S IMRSD=Y,%DT="AQEXP",%DT("A")="    End Date for Period: " D ^%DT K %DT G:Y'>0 KILL S IMRED=Y
 I IMRED<IMRSD W !,$C(7),"END CAN NOT BE BEFORE START",! G ASK
 K DIR S DIR(0)="N^1:999999",DIR("A")="Minimum number of fills to display",DIR("B")=2,DIR("?")="This determines the minimum number of fills for which a drug will be displayed in the listing by order of number of fills"
 D ^DIR G:$D(DIRUT) KILL S IMRN1=X
ASK1 ; minimum $ cost to display
 K DIR S DIR(0)="N^1:999999",DIR("A")="Minimum dollar cost of dispensed fills to be display",DIR("B")=10
 S DIR("?")="This determines the minimum cost of fills for which a drug will be displayed in the listing order of cost of drug dispensed"
 D ^DIR G:$D(DIRUT) KILL
 S IMRN2=X
ASK2 ; print report by category?
 K DIR S DIR(0)="Y",DIR("A")="Print Data by CATEGORY as well as totals",DIR("B")="NO",DIR("?")="Answer YES to get separate listings of utilization by HIV CATEGORY as well as the total population."
 D ^DIR G:$D(DIRUT) KILL
 K DIR S IMR2C=Y
 S IMRRMAX=0 I $D(^XUSEC("IMRMGR",DUZ)) D ASKQ G:$D(DIRUT) KILL
 S X=$$RX1589^IMRUTL() ;get pharmacy archive date from File 158.9
 I X,X'<IMRSD,X'>IMRED D ASKN I $D(DIRUT) D KILL Q  ;use nat'l registry?
 I X,X'<IMRSD,X>IMRED D ASKN I $D(DIRUT) D KILL Q  ;use nat'l registry?
 I $D(^XUSEC("IMRMGR",DUZ)) D IMRDEV^IMREDIT G:POP KILL ;select device
 I '$D(^XUSEC("IMRMGR",DUZ)) D ^%ZIS G:POP KILL
 I $D(IO("Q")) D SAVE G KILL
 U IO D DQ D ^%ZISC K %ZIS,IOP G KILL
SAVE ; ZTSAVE the variables used
 S ZTRTN="DQ^IMRRXL",ZTIO=ION_";"_IOM_";"_IOSL,ZTSAVE("IMRSD")="",ZTSAVE("IMRED")="",ZTSAVE("IMRN1")="",ZTSAVE("IMRN2")="",ZTSAVE("IMRRMAX")="",ZTSAVE("IMR2C")="",ZTDESC="RX Utility Activity Report"
 D ^%ZTLOAD K IO("Q"),ZTRTN,ZTIO,ZTSAVE,ZTDESC,ZTSK
 G KILL
 Q
DQ ; start report
 K ^TMP($J) S (IMRPG,IMRUT)=0
 D NOW^%DTC S IMRDTE=%,Y=IMRDTE D DD^%DT S IMRDTE=Y ;get report date/time
 S IMRDTE=$P(IMRDTE,":",1,2)
 F IMRRL=0:0 S IMRRL=$O(^IMR(158,IMRRL)) Q:IMRRL'>0  S X=+^(IMRRL,0),IMR1C=+$P(^(0),U,42) D XOR^IMRXOR S IMRDFN=X I $D(^DPT(IMRDFN,0)) F IMR0C=IMR1C,"T" I IMR2C!(IMR0C="T") S IMR1C="C"_IMR0C S DFN=IMRDFN D NS^IMRCALL K DFN D C1
 D ^IMRRXLA,RXPRNT^IMRRXL1
 S:$D(ZTQUEUED) ZTREQ="@"
 I '$D(^TMP($J)) W !!,"No data for this report.",!
 D:'IMRUT EOP^IMRRXL1
 Q
KILL D ^%ZISC K %,%DT,%I,IMRPG,IMRDTE,IMRFLG,IMRTOT,IMRTOTL,DIR,DIRUT,DIROUT,IMRCL,IMRDFN,IMRDR,IMRI,IMRRI,IMRM,IMRN,IMRQ,IMRRP,IMRRX,IMRRXDR,IMRRXD1,IMRUT,IMRY,IMRDSUP,DISYS
 K IMRSSN,IMRNAM,DFN,IMRF,IMRR,IMRV,IMRCOM,IMRTP,IMRCR,IMRCP,IMRYES,IMRDL,IMRFILDT,IMRCMAC,IMRCTOT,IMRJ,IMRNMAX,IMRRCOST,IMRX,C1,IMRCMAX
 K IMRSD,IMRS1,IMRED,IMRX,IMRD,IMRRL,IMRXX1,IMRRXD,IMREF,IMREC,IMRUCST,IMREXP,IMRDST,IMRDU,IMRAR,IMRPS,IMRPAT,IMRCRX,IMRDRX,IMRTTP,IMRN1,IMRN2,IMR0C,IMR1C,IMR2C,IMRLBL,^TMP($J),VAERR,%T,C,I,J,K,M,N,IMRRMAX,POP,Q,X,X1,X2,Y,Z,Z1
 Q
C1 ; Get the Outpatient Pharmacy Data
 S ^TMP($J,IMR1C,"PAT",IMRDFN)=""
 F IMRRP=0:0 S IMRRP=$O(^PS(55,IMRDFN,"P","A",IMRRP)) Q:IMRRP'>0  I IMRRP'<IMRSD F IMRR=0:0 S IMRR=$O(^PS(55,IMRDFN,"P","A",IMRRP,IMRR)) Q:IMRR'>0  D RX^IMRUTL,C2 ;RX^IMRUTL gets outpatient pharmacy data
 Q
C2 ;
 I 'IMRRXD1!('IMRXX1) Q  ;check issue date and drug ien
 S:'IMRUCST IMRUCST=IMRDU ;unit price of drugs=price per dispense units
 S:IMRCL="" IMRCL="UNDEF" ;if no amis reporting stop code
 S IMRY=0
 I IMRFILDT>IMRSD,IMRFILDT'>IMRED S IMRY=1 D  ;check if fill date is between start and end dates
 .S ^(IMRRXDR)=$S($D(^TMP($J,IMR1C,"PAT",IMRDFN,IMRRXDR)):^(IMRRXDR),1:0)+1
 .S ^("Q")=$S($D(^TMP($J,IMR1C,"PAT",IMRDFN,IMRRXDR,"Q")):^("Q"),1:0)+IMRQ
 .Q
 I IMRY S ^("C")=$S($D(^TMP($J,IMR1C,"PAT",IMRDFN,IMRRXDR,"C")):^("C"),1:0)+(IMRQ*IMRUCST),^(IMRCL)=$S($D(^(IMRCL)):^(IMRCL),1:0)+1,^("Q")=$S($D(^(IMRCL,"Q")):^("Q"),1:0)+IMRQ,^("C")=$S($D(^("C")):^("C"),1:0)+(IMRQ*IMRUCST)
 D RXF^IMRUTL ;get refill data
 Q:'$D(IMRAR(52.1))
 S IMRN=""
 F  S IMRN=$O(IMRAR(52.1,IMRN)) Q:IMRN=""  S IMRRXD=+$G(IMRAR(52.1,IMRN,.01,"I")) I IMRRXD>IMRSD,IMRRXD'>IMRED D C3
 Q
C3 ;
 S IMRQ=$G(IMRAR(52.1,IMRN,1,"I")),IMRRCOST=$G(IMRAR(52.1,IMRN,1.2,"I"))
 S:'IMRRCOST IMRRCOST=IMRUCST ;if no refill cost set it to unit price of  drug
 S ^(IMRRXDR)=$S($D(^TMP($J,IMR1C,"PAT",IMRDFN,IMRRXDR)):^(IMRRXDR),1:0)+1,^("Q")=$S($D(^(IMRRXDR,"Q")):^("Q"),1:0)+IMRQ,^("C")=$S($D(^("C")):^("C"),1:0)+(IMRQ*IMRRCOST)
 S ^(IMRCL)=$S($D(^TMP($J,IMR1C,"PAT",IMRDFN,IMRRXDR,IMRCL)):^(IMRCL),1:0)+1,^("Q")=$S($D(^(IMRCL,"Q")):^("Q"),1:0)+IMRQ,^("C")=$S($D(^("C")):^("C"),1:0)+(IMRQ*IMRRCOST)
 Q
ASKN ; Ask User whether they want to Query the National
 S IMRYES=0 D ASKQ1^IMRNTL Q:'IMRYES  S IMRDL="" D ASKQ2^IMRNTL Q:IMRDL=""  D MSG^IMRNTL,PH^IMRNTL1
 Q
ASKQ K DIR S DIR(0)="N^0:999999",DIR("A")="How many of the highest users do you want identified",DIR("B")=0
 S DIR("?")="This determines the number of individuals with the highest utilization of pharmacy fills you wish listed" D ^DIR K DIR Q:$D(DIRUT)
 S IMRRMAX=X
 Q
