IMRLIST ;ISC-SF/JLI HCIOFO/FT-LIST PATIENTS IN THE IMR FILE ; 7/24/02 8:14am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5,18**;Feb 09, 1998
ENTRY ;[IMR PATIENT LIST] - Local Registry List - ICR Patients
 W !,?10,"####################################################"
 W !,?10,"#",?20,"Local Registry List - ICR Patients",?61,"#"
 W !,?10,"####################################################"
 D KILL,^IMRDATE  Q:$G(IMRHQUIT)
 S IMRPAT=1,IMRSCT=1,REIM=1,IMREXC="B"
 K DIR  S DIR(0)="S^A:alive;D:deceased;B:both"
 S DIR("A")="Select Type of Patients"
 S DIR("?")="^D HELP^IMRLIST"
 D ^DIR  K DIR  I $D(DIRUT)  D KILL  Q
 S IMREXC=Y
NEWP R !!,"List New Patients added to the registry during this time (Y/N)? N// ",X:DTIME G:'$T!(X[U) KILL S:X="" X="N" I "Yy"[$E(X) S IMRPAT=2
 I "YyNn"'[$E(X) W $C(7),"  ??",!!,"Enter YES or NO" G NEWP
 I $D(DIRUT) D KILL Q
 ;
CAT R !!,"Do you want the list sorted by Category (Y/N)? N// ",X:DTIME G:'$T!(X[U) KILL S:X="" X="N" I "Yy"[$E(X) S IMRSCT=2
 I "YyNn"'[$E(X) W $C(7),"  ??",!!,"Enter YES or NO" G CAT
 ;  IF LISTING BY CATEGORY IS NO GIVE THE FOLLOWING PROMPT
REIM I IMRSCT=2 G DEV
 R !!,"Do you want the list sorted by Reimbursement Level (Y/N)? N// ",X:DTIME G:'$T!(X[U) KILL S:X="" X="N" I "Yy"[$E(X) S REIM=2
 I "YyNn"'[$E(X) W $C(7),"  ??",!!,"Enter YES or NO" G REIM
 ;
DEV S %ZIS="MPQ" D IMRDEV^IMREDIT
 G:POP KILL
 I $D(IO("Q")) D  G KILL
 .S ZTRTN="DQ^IMRLIST",ZTDESC="List Immunology Patients"
 .S ZTSAVE("*")="",ZTIO=ION_";"_IOM_";"_IOSL
 .D ^%ZTLOAD K ZTRTN,ZTDESC,ZTSAVE,ZTSK
 .Q
DQ ;
 U IO K ^TMP($J),IMRLR,IMROUT,IMRPTF,IMRRX,IMRRXN,IMRSCH,IMRST,IMRSUF S IMRPG=0
 D GETNOW^IMRACESS
 S IMRHED="Patients Seen During "_$G(IMRHRANG)
 S IMRHED(1)="FOR "_$S(IMREXC="A":"LIVING ",IMREXC="B":"ALIVE & DECEASED ",IMREXC="D":"DECEASED ",1:"")_"PATIENTS IN THE FILE"
 F IMRI=0:0 S IMRI=$O(^IMR(158,IMRI)) Q:IMRI'>0  S X=+^(IMRI,0),IMRCAT=$P(^(0),U,42) D ^IMRXOR S (DFN,IMRDFN)=X I $D(^DPT(DFN,0)) D ADD
 D HEDR S I="",(K,N)=0,IMRUT=0
 D:(IMRSCT=1)&(REIM=1) PSRP
 D:(REIM=2)&(IMRSCT=1) PRBR
 D:(IMRSCT=2)&(REIM=1) PCTR
 S:$D(ZTQUEUED) ZTREQ="@"
 D:IOST["C-" PRTC
KILL D ^%ZISC
 K ^TMP($J),DFN,DRUG,FDT,FIP,IEN,IMNR,IMRI,IMRTYP,IMRUT,I,J,K,N,X,Y,POP,IMRFLG,IMRSTN,IMRCAT,VADM,VA,VAERR,VAEL,D,DISYS,IMREXC,IMRPG,IMRHED,IMRSD
 K IMRED,IMRPER,IMRAD,IMRCHK,IMRDD,IMRDFN,IMRDISP,IMRDOD,IMRDSP,IMRDTE,IMREC,IMRFB,IMRINP,IMRJ,IMRLAB
 K IMRLR,IMROUT,IMRPTF,IMRRX,IMRRXN,IMRSCH,IMRBL,IMRHQUIT,IMRHRANG,IMRHTART,IMRN,IMRPAT,IMRRI,IMRSCT,LCL,LCLAB,LG,LGROUP,LLOC,LNL,LNLT,LOCNM,LV3,IMRH1HED,IMRH2HED,IMRHENGD,IMRHNBEG,IMRHNEND,IMRST,IMRSUF
 Q
HELP ;
 ;;Patients who have no utilization in the provided date range or
 ;;whose date of death is before the start date will NOT be included
 ;;in the report of any type.
 ;;
 ;;A - Alive patients
 ;;Only patients who were alive during the whole time frame will be
 ;;included in the report. If the date of death is between start and
 ;;end dates, the patient will be skipped.
 ;;
 ;;D - Deceased patients
 ;;Only patients who died during the provided time frame will be
 ;;included in the report. If the patient is alive or the date of
 ;;death is after the end date, the patient will be skipped.
 ;;
 ;;B - Both alive and deceased
 ;;All patients (except those mentioned in the first paragraph) will
 ;;be included in the report.
 ;
 N DIR,I,L,TMP
 S L=IOSL-10  S:L<0 L=999
 F I=1:1  S TMP=$T(HELP+I)  Q:TMP'[";;"  D
 . I '(I#L)  W !  D  D ^DIR  W !
 . . S DIR(0)="FAO",DIR("A")="Enter RETURN to continue: "
 . W !,$P(TMP,";;",2)
 Q
PSRP ;standard format
 I '$D(^TMP($J)) W !!?5,"***NO PATIENTS FOUND IN DATE RANGE***"
 F  Q:IMRUT  S I=$O(^TMP($J,I)) Q:I=""  F J=0:0 S J=$O(^TMP($J,I,J)) Q:J'>0  D:($Y+3>IOSL) PRTC Q:IMRUT  D:($Y+3>IOSL) HEDR S K=K+1,N=N+1 W:'(K#5) ! W !,$J(N,5),?6,$P(^(J),U),?36,$P(^(J),U,2),?47,$P(^(J),U,3),?53,$P(^(J),U,5),?65,$P(^(J),U,4)
 Q
PRBR ;by arv use
 I '$D(^TMP($J)) W !!?5,"***NO PATIENTS FOUND IN THIS DATE RANGE***"
 S TY="" F  S TY=$O(^TMP($J,TY)),MC="" Q:TY=""  F  S MC=$O(^TMP($J,TY,MC)),RM="" Q:MC=""  F  S RM=$O(^TMP($J,TY,MC,RM)),PD="" Q:RM=""  F  S PD=$O(^TMP($J,TY,MC,RM,PD)) Q:PD=""  D:($Y+3>IOSL) HEDR S K=K+1,N=N+1 W:'(K#5) ! D PR2
 Q
PR2 S TYX=TY W:TY'=TYX !,"*** "_TY_" ***"
 W !,$J(N,5),?7,MC,?14,RM,?39,$P($G(^TMP($J,TY,MC,RM,PD)),U,2),?51,$P($G(^TMP($J,TY,MC,RM,PD)),U,3),?57,$P($G(^TMP($J,TY,MC,RM,PD)),U,4)
 Q
PCTR ;by  category
 I '$D(^TMP($J)) W !!?5,"***NO PATIENTS FOUND IN THIS DATE RANGE***"
 S MRC="" F  S MRC=$O(^TMP($J,MRC)),RNM="" Q:MRC=""  F  S RNM=$O(^TMP($J,MRC,RNM)),PID="" Q:RNM=""  F  S PID=$O(^TMP($J,MRC,RNM,PID)) Q:PID=""  D:($Y+3>IOSL) PRTC Q:IMRUT  D:($Y+3>IOSL) HEDR S K=K+1,N=N+1 W:'(K#5) ! D PC2
 Q
PC2 W !,$J(N,5),?7,MRC,?14,RNM,?39,$P($G(^TMP($J,MRC,RNM,PID)),U,2),?61,$P($G(^TMP($J,MRC,RNM,PID)),U,4),?71,$P($G(^TMP($J,MRC,RNM,PID)),U,3)
 Q
ADD ;
 N EXIT
 D 2^VADPT
 D PERCHK^IMRLCAT1 S DFN=IMRDFN Q:'IMRCHK  ;if date range check when patient was seen. quit if not seen in date range.
 Q:$G(IMRHNBEG)=""  Q:$G(IMRHNEND)=""
 S IMRDOD=$P($G(^IMR(158,IMRI,5)),U,19) ;get IMR DATE OF DEATH
 S IMRDOD=$S(+VADM(6)>0:+VADM(6),IMRDOD>0:IMRDOD,1:"")
 S EXIT=1
 I IMRDOD>0  D
 . ;--- Quit if date of death is before start date
 . Q:IMRDOD<IMRHNBEG
 . ;--- Quit if deceased selected and date of death after end date
 . I IMREXC="D"  Q:IMRDOD>IMRHNEND
 . ;--- Quit if alive selected and patient is dead
 . I IMREXC="A"  Q:IMRDOD'>IMRHNEND
 . ;--- Indicate where DOD came from; MAS or ICR
 . S IMRDOD=$$FMTE^XLFDT(IMRDOD,"2DF")_$S(+VADM(6)>0:"",1:" (ICR)")
 . K EXIT
 E  K:IMREXC'="D" EXIT
 Q:$G(EXIT)
 D ^IMRARVRL S:IMRCAT=4 IMRBL="AIDS"
 D STAND,ARVUSE,BYCAT
 K IMRLR,IMROUT,IMRPTF,IMRRX,IMRRXN,IMRSCH,IMRST,IMRSUF
 Q
STAND Q:IMRSCT'=1
 Q:REIM'=1
 S ^TMP($J,(VADM(1)),DFN)=VADM(1)_U_$P(VADM(2),U)_U_IMRCAT_U_IMRDOD_U_IMRBL
 Q
ARVUSE Q:REIM'=2
 Q:IMRSCT'=1
 S:IMRBL="ARV" ^TMP($J,"ARV",IMRBL,(VADM(1)),DFN)=VADM(1)_U_$P(VADM(2),U)_U_IMRCAT_U_IMRDOD
 S:IMRBL="NOARV" ^TMP($J,"NOARV",IMRBL,(VADM(1)),DFN)=VADM(1)_U_$P(VADM(2),U)_U_IMRCAT_U_IMRDOD
 S:IMRBL="AIDS" ^TMP($J,"AIDS",IMRBL,(VADM(1)),DFN)=VADM(1)_U_$P(VADM(2),U)_U_IMRCAT_U_IMRDOD
 Q
BYCAT Q:IMRSCT'=2
 Q:REIM'=1
 S ^TMP($J,IMRCAT,(VADM(1)),DFN)=VADM(1)_U_$P(VADM(2),U)_U_IMRDOD_U_IMRBL
 Q
 ;
PRTC ; press return to continue
 S K=0 Q:IMRUT!($D(IO("S")))
 I IOST["C-" K DIR W ! S DIR(0)="E" D ^DIR K DIR I 'Y S IMRUT=1
 Q
HEDR ; report header
 S IMRPG=IMRPG+1
 W:$Y>0 @IOF
 W !?37,"REGISTRY LIST",!?32,IMRDTE,?70,"Page: ",IMRPG
 I $G(IMRHED)]"" W !,?(IOM-$L(IMRHED)\2),IMRHED
 W !,?(IOM-$L(IMRHED(1))\2),IMRHED(1)
 W:(IMRSCT=1)&(REIM=1) !!,?7,"NAME",?36,"SSN",?47,"CAT",?53,"REIM LEV",?65,"DECEASED",!
 W:(REIM=2)&(IMRSCT=1) !!,?7,"*REIMB",!,?7,"LEVEL",?16,"NAME",?41,"SSN",?50,"CAT",?60,"DECEASED",!
 W:(IMRSCT=2)&(REIM=1) !!,?7,"CAT",?16,"NAME",?41,"SSN",?61,"REIM LEV",?71,"DECEASED",!
 Q
