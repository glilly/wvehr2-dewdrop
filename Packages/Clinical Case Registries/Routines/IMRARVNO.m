IMRARVNO ;HCIOFO-FAI/PATIENTS WITH NO ARV ;07/20/00  10:49
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
ENTRY S (IMRPAT,IMRSCT,REIM)=1,IMRI=0,IMRPG=0,IMREXC="B" K ^TMP($J),IMRLR,IMROUT,IMRPTF,IMRRX,IMRRXN,IMRSCH,IMRST,IMRSUF
 F IMRI=0:0 S IMRI=$O(^IMR(158,IMRI)) Q:IMRI'>0  S X=+^(IMRI,0),IMRCAT=$P(^(0),U,42) D ^IMRXOR S (DFN,IMRDFN)=X I $D(^DPT(DFN,0)) D ADD
 D HEDR S I="",(CTNOARV,K,N)=0,IMRUT=0
 D PRBR
 Q
PRBR ;by arv use
 I '$D(^TMP($J)) W !!?5,"***NO PATIENTS FOUND IN THIS DATE RANGE***"
 S TY="" F  S TY=$O(^TMP($J,TY)),MC="" Q:TY=""  F  S MC=$O(^TMP($J,TY,MC)),RM="" Q:MC=""  F  S RM=$O(^TMP($J,TY,MC,RM)),PD="" Q:RM=""  F  S PD=$O(^TMP($J,TY,MC,RM,PD)) Q:PD=""  D PR2
 Q
PR2 S IMRPCT=$P($G(^TMP($J,TY,MC,RM,PD)),U,3) Q:IMRPCT'=4
 S CTNOARV=CTNOARV+1,K=K+1,N=N+1 W:IMRC4=1 !,$J(N,5),?7,RM,?33,$P($G(^TMP($J,TY,MC,RM,PD)),U,2),?48,$P($G(^TMP($J,TY,MC,RM,PD)),U,3),?53,$P($G(^TMP($J,TY,MC,RM,PD)),U,4),?65,MC
 Q
ADD ;
 D 2^VADPT
 D PERCHK^IMRLCAT1 S DFN=IMRDFN Q:'IMRCHK  ;if date range check when patient was seen. quit if not seen in date range.
 Q:$G(IMRHNBEG)=""  Q:$G(IMRHNEND)=""
 S IMRDOD=$P($G(^IMR(158,IMRI,5)),U,19) ;get IMR DATE OF DEATH
 S IMRDOD=$S(+VADM(6)>0:+VADM(6),IMRDOD>0:IMRDOD,1:"")
 I $E(IMREXC)="A",IMRDOD>0,+IMRDOD<IMRHNBEG Q  ;quit if date range, alive selected and date of death is before start date
 I IMREXC="D",IMRDOD>0,IMRDOD<IMRHNBEG Q  ;quit if date range, deceased selected and date of death before start date
 I IMREXC="D",IMRDOD>0,IMRDOD>IMRHNEND Q  ;quit if date range, deceased selected and date of death after end date
 I IMREXC="D",IMRDOD'>0 Q  ;quit if date range, deceased selected and no date of death
 I IMREXC="A",IMRDOD>0 Q  ;quit if no date range, alive selected and patient is dead
 I IMREXC="D",IMRDOD'>0 Q  ;quit if no date range, deceased selected and patient is not dead
 I IMREXC="B",IMRDOD>0,IMRDOD<IMRHNBEG Q  ;quit if date range, both selected and date of death before start date
 I IMREXC="B",IMRDOD>0,IMRDOD>IMRHNEND Q  ;quit if date range, both selected and date of death after end date
 I IMRDOD>0 S IMRDOD=$E(IMRDOD,4,5)_"/"_$E(IMRDOD,6,7)_"/"_$E(IMRDOD,2,3)_$S(+VADM(6)>0:"",1:" (ICR)") ;indicate where DOD came from; MAS or ICR
 D ^IMRARVRL
 D ARVUSE
 K IMRLR,IMROUT,IMRPTF,IMRRX,IMRRXN,IMRSCH,IMRST,IMRSUF
 Q
ARVUSE S:IMRBL="NOARV" ^TMP($J,"NOARV",IMRBL,(VADM(1)),DFN)=VADM(1)_U_$P(VADM(2),U)_U_IMRCAT_U_IMRDOD
 Q
HEDR ; report header
 W:IMRC4=1 !!,?10,"===================================================",!!,?20,"Unique Category 4 Patients NOT on ARVs",!!,?7,"NAME",?36,"SSN",?47,"CAT",?53,"DECEASED",?65,"REIM LEVEL",!
 Q
