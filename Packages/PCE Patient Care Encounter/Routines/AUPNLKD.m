AUPNLKD ; IHS/CMI/LAB - IHS PATIENT LOOKUP, QUICK DUPE CHECK ;1/29/07  09:05
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;SEA/AMF-ALB/RMO - CHECK FOR DUPLICATES ON NEW PATIENT ENTRY JUNE 1987
 ;
 ; Upon exiting this routine AUPD will be the number of potential
 ; duplicates found, and the array AUPD(n) will contain those
 ; potential duplicate where 'n' is the patient's DFN.
 ;
START ;
 D INIT ;                       Initialization
 D:$E(DOB,6,7)'="00" DOB ;      Check patients with similar DOBs
 D:SSN'="" SSN ;                Check patients with similar SSNs
 D EOJ
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
DOB ; CHECK SAME DOB + TRANSPOSED DAY
 F AUPIN=0:0 S AUPIN=$O(^DPT("ADOB",DOB,AUPIN)) Q:AUPIN=""  D DOB1
 S AUPDOB=DOB,DOB=$E(DOB,1,5)_$E(DOB,7)_$E(DOB,6)
 F AUPIN=0:0 S AUPIN=$O(^DPT("ADOB",DOB,AUPIN)) Q:AUPIN=""  D DOB1
 S DOB=AUPDOB
 Q
 ;
DOB1 ;
 W "."
 Q:$D(^VA(15,"AFR","DPT(",AUPIN))  ; Quit if verified duplicate
 S AUPV=^DPT(AUPIN,0),AUPV1=$P(AUPV,U,1)
 Q:$P(AUPV,U,18)="I"
 Q:$P(AUPV,U,2)'=SEX
 I AUPV1?.E1P.E S AUPT=AUPV1 D PUNC S AUPV1=AUPT
 S AUPV1L=$P(AUPV1,",",1),AUPV1F=$P($P(AUPV1,",",2)," ",1),AUPV1M=$P($P(AUPV1,",",2)," ",2)
 I ($E(AUPNL,1,2)_$E(AUPNF,1,2))=($E(AUPV1L,1,2)_$E(AUPV1F,1,2)) D HIT Q
 I AUPNF=AUPV1F D HIT Q
 I AUPNL=AUPV1L,AUPNM=AUPV1F D HIT Q
 I AUPNL=AUPV1L,AUPV1M=AUPNF D HIT Q
 I $D(^DPT(AUPIN,.01)) D ALIAS
 Q:SSN=""
 S AUPV1=$P(AUPV,U,9)
 Q:AUPV1=""
 S AUPF=0 F K=1:1:9 Q:(AUPF>2)  I $E(AUPV1,K)'=$E(SSN,K) S AUPF=AUPF+1
 I AUPF<3 D HIT Q
 Q
 ;
ALIAS ;
 F AUPAN=0:0 S AUPAF=1,AUPAN=$O(^DPT(AUPIN,.01,AUPAN)) Q:AUPAN'=+AUPAN  I $D(^(AUPAN,0)) D ALIAS2 I AUPAF D HIT Q
 K AUPAN,AUPAF
 Q
 ;
ALIAS2 ;
 S AUPV1=$P(^(0),U,1)
 S AUPV1L=$P(AUPV1,",",1),AUPV1F=$P($P(AUPV1,",",2)," ",1),AUPV1M=$P($P(AUPV1,",",2)," ",2)
 I AUPV1L=AUPNL Q
 I AUPV1F=AUPNF Q
 I AUPV1M=AUPNF Q
 I AUPNF=AUPV1M Q
 S AUPAF=0
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
SSN ; CHECK SSNS WITH SAME FIRST FIVE DIGITS
 S AUPSSN=$E(SSN,1,5)_"0000" F AUPSSN=0:0 S AUPSSN=$O(^DPT("SSN",AUPSSN)) Q:AUPSSN=""!($E(AUPSSN,1,5)'=$E(SSN,1,5))  F AUPIN=0:0 S AUPIN=$O(^DPT("SSN",AUPSSN,AUPIN)) Q:AUPIN=""  D SSN1
 Q
 ;
SSN1 ;
 W "."
 Q:$D(AUPD(AUPIN))  ; Quit if already found
 Q:$D(^VA(15,"AFR","DPT(",AUPIN))  ; Quit if verified duplicate
 S AUPV1=^DPT(AUPIN,0)
 Q:$P(AUPV1,U,2)'=SEX
 I $P(AUPV1,",",1)=$P(AUPN,",",1)!($E(AUPV1,1,2)_$E($P(AUPV1,",",2),1,2)=($E(AUPN,1,2)_$E($P(AUPN,",",2),1,2))) S AUPD(AUPIN)="",AUPD=AUPD+1 Q
 S AUPV=$E(SSN,6,9),AUPV1=$E(AUPSSN,6,9)
 S AUPF=0 F K=1:1:4 Q:(AUPF>2)  I $E(AUPV,K)'=$E(AUPV1,K) S AUPF=AUPF+1
 I AUPF<3 D HIT Q
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
HIT ; POTENTIAL DUPLICATE FOUND
 Q:$D(AUPD(AUPIN))
 S AUPD(AUPIN)=""
 S AUPD=AUPD+1
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
INIT ; INITIALIZATION
 K AUPD
 S AUPD=0,AUPN=AUPNM
 I $P(AUPN,",",1)?.E1P.E S AUPT=$P(AUPN,",",1) D PUNC S AUPN=AUPT_","_$P(AUPN,",",2,99)
 S AUPNL=$P(AUPN,",",1),AUPNF=$P($P(AUPN,",",2)," ",1),AUPNM=$P($P(AUPN,",",2)," ",2)
 Q
 ;
PUNC ;
 F I=1:1:$L(AUPT) I $E(AUPT,I)?1P,$E(AUPT,I)'=",",$E(AUPT,I)'=" " S AUPT=$E(AUPT,1,I-1)_$E(AUPT,I+1,99)
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
EOJ ;
 K AUPAF,AUPAN,AUPDOB,AUPF,AUPIN,AUPN,AUPNF,AUPNL,AUPNM,AUPSSN,AUPT,AUPV,AUPV1,AUPV1F,AUPV1L,AUPV1M
 Q
