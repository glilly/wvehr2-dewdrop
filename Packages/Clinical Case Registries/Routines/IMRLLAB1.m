IMRLLAB1 ;ISC-SF.SEA/JLI-LOCAL LISTING OF LAB UTILIZATION (PRINT) ;9/2/97  10:11
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
LABPRNT ;
 S IMRD="FOR THE PERIOD "_$E(IMRSD,4,5)_"/"_$E(IMRSD,6,7)_"/"_$E(IMRSD,2,3)_" TO "_$E(IMRED,4,5)_"/"_$E(IMRED,6,7)_"/"_$E(IMRED,2,3),IMRUT=0
 F IMR0C=0:1:4,"T" Q:IMRUT  S IMRLBL=$S(+IMR0C=IMR0C:$P("NO CATEGORY DEFINED^HIV+^HIV+ (CD4<500)^AIDS-3^AIDS","^",IMR0C+1),1:"TOTAL HIV+ (ALL CATEGORIES) POPULATION"),IMR1C="C"_IMR0C I IMR2C!(IMR0C="T") D LABPRN
 Q
LABPRN ;
 Q:'$D(^TMP($J,IMR1C,"A"))  S IMRX="LABORATORY UTILIZATION DATA" D HEDR Q:IMRUT
 S Z1=0 F I=0:0 S I=$O(^TMP($J,IMR1C,"PAT",I)) Q:I'>0  S Z1=Z1+^(I)
 S Z=0 F I=0:0 S I=$O(^TMP($J,IMR1C,"A",I)) Q:+I'=I  S J="" F K=0:0 S J=$O(^TMP($J,IMR1C,"A",I,J)) Q:J=""  S Z=Z+1
 W !,"Totals:  " S X=^TMP($J,IMR1C,"LR"),Y=^("LR","TST") W Z1," orders placed (",Y," results reported)",!?15," during this period for ",X," patients",!!,?10,"These include ",Z," different entries from LAB TEST file",!
 F I=0:0 S I=$O(^TMP($J,IMR1C,"LR","N",I)) W:I'>0 ! Q:I'>0!(IMRUT)  D
 .I ($Y+3>IOSL) D PRTC Q:IMRUT  D HEDR
 .D LABPRN1
 .Q
 Q:IMRUT
 D HEDR1
 F I=0:0 Q:IMRUT  S I=$O(^TMP($J,IMR1C,"A",I)) Q:+I'=I!(IMRUT)  S N="" F J=0:0 S N=$O(^TMP($J,IMR1C,"A",I,N)) Q:N=""!(IMRUT)  D
 .I ($Y+3>IOSL) D PRTC Q:IMRUT  D HEDR,HEDR1
 .D PRNT1
 .Q
 Q:IMRUT
 S IMRJ=0 I IMRRMAX D PRTC Q:IMRUT  D HEDR,HEDR2
 F IMRI=0:0 Q:IMRUT!(IMRJ'<IMRRMAX)  S IMRI=$O(^TMP($J,IMR1C,"MAX",IMRI)) Q:+IMRI'=IMRI!(IMRUT)  D LABPRN2
 D PRTC
 K IMRI,IMRJ,IMRXX,DFN,VA,VADM,VAERR
 Q
LABPRN2 ;
 F DFN=0:0 S DFN=$O(^TMP($J,IMR1C,"MAX",IMRI,DFN)) Q:DFN'>0!(IMRUT)  S IMRJ=IMRJ+1,IMRXX=^(DFN) D DEM^VADPT D
 .I ($Y+3)>IOSL D PRTC Q:IMRUT  D HEDR,HEDR2
 .W !,$E(VADM(1),1,20),?23,VA("PID"),?35,$J(+IMRXX,7),?45,$J($P(IMRXX,U,2),9),?61,$J($P(IMRXX,U,3),9)
 .Q
 Q
LABPRN1 ;
 S X=+^TMP($J,IMR1C,"LR","N",I),Y=$P(^(I),U,2) W !?8,$J(Y,7)," order",$S(Y'=1:"s",1:" ")," placed for ",$J(X,5)," patient",$S(X>1:"s",1:"") I Y=0 W " in file, not included above"
 Q
PRNT1 ;
 S X=+^TMP($J,IMR1C,"A",I,N),Y=$P(^(N),U,2) Q:Y<IMRN1  W !,N,?30,$J(Y,7),"       ",$J(X,6) I X'=Y&(X'=1) W ?55,$J(+^(N,"MAX"),7)," (",$P(^("MAX"),U,2)," pat)"
 Q
 ;
PRTC ; press return to continue
 Q:$E(IOST)'="C"!(IMRUT)!($D(IO("S")))
 K DIR S DIR(0)="E" D ^DIR K DIR S:$D(DIRUT)!(Y=0) IMRUT=1
 Q
HEDR ;
 W:$Y>0 @IOF W:IOST'["C" !!! W !,?(IOM-$L(IMRX)\2),IMRX,!?(IOM-$L(IMRD)\2),IMRD,!?(IOM-$L(IMRLBL)\2),IMRLBL,!?(IOM-$L(IMRDTE)\2),IMRDTE,!
 Q
HEDR2 ;
 W !,?37,"# OF",?48,"# OF",?60,"# OF DIFFERENT",!,"NAME",?25,"SSN",?36,"ORDERS",?47,"RESULTS",?63,"LAB TESTS",!
 Q
HEDR1 Q:IMRUT
 W !?30,"# Results",?55,"Max # Results",!?30,"Reported",?44,"Patients",?55,"Per Patient (# patients)",!
 Q
