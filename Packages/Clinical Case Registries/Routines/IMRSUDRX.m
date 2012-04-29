IMRSUDRX ;HCIOFO/NCA/FT/FAI-List Data on Outpatient Pharmacy Utilization ;07/17/00  15:40
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
 S X=$$RX1589^IMRUTL() ;get pharmacy archive date from File 158.9
DQ ; start report
 K ^TMP($J) S (IMRPG,IMRUT)=0
 D NOW^%DTC S IMRDTE=%,Y=IMRDTE D DD^%DT S IMRDTE=Y ;get report date/time
 S IMRDTE=$P(IMRDTE,":",1,2)
 F IMRRL=0:0 S IMRRL=$O(^IMR(158,IMRRL)) Q:IMRRL'>0  S X=+^(IMRRL,0),IMR1C=+$P(^(0),U,42) D XOR^IMRXOR S IMRDFN=X I $D(^DPT(IMRDFN,0)) F IMR0C=IMR1C,"T" I IMR2C!(IMR0C="T") S IMR1C="C"_IMR0C S DFN=IMRDFN D NS^IMRCALL K DFN D C1
 D ^IMRRXLA,RXPRNT^IMRRXL1
 I '$D(^TMP($J)) W !!,"No data for this report.",!
 D:'IMRUT EOP^IMRRXL1
 Q
KILL Q
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
