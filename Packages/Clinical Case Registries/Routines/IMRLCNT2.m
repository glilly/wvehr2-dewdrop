IMRLCNT2 ;ISC-SF/JLI-LOCAL COUNT OF PTS, STATUS, OP VISITS, IP STAYS, ETC. CONTINUED (PRINT) ;9/2/97  14:10
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**6**;Feb 09, 1998
 S (IMRPG,IMRUT)=0
 F IMR0C=0:1:4,"T" Q:IMRUT  S IMRLBL=$S(+IMR0C=IMR0C:$P("NO CATEGORY DEFINED^HIV+^HIV+ (CD4<500)^AIDS-3^AIDS","^",IMR0C+1),1:"TOTAL HIV+ (ALL CATEGORIES) POPULATION"),IMR1C="C"_IMR0C D OPPRNT Q:IMRUT  D IPPRNT^IMRLCNT3
 Q
 ;
OPPRNT ;
 S IMRD="FOR THE PERIOD "_$E(IMRSD,4,5)_"/"_$E(IMRSD,6,7)_"/"_$E(IMRSD,2,3)_" TO "_$E(IMRED,4,5)_"/"_$E(IMRED,6,7)_"/"_$E(IMRED,2,3)
 D GETNOW^IMRACESS
 Q:'$D(^TMP($J,IMR1C,"OP"))  S IMRX="SELECTED OUTPATIENT ACTIVITY" D HEDR
 W !!,"A 'stop' is credited for each entry of a stop code, while a 'visit' is split",!,"among each stop credited on a given date.  Thus, a single visit with two stop",!,"codes credited will show as 0.5 visit for each stop code.  "
 W "A total of 1.00",!,"visit is given for out patient activity on a given date.",!!
 W !!,"Totals:      " S X=^TMP($J,IMR1C,"S"),Y=^("S","VIS") W X," patients for ",Y," visits   (",^TMP($J,IMR1C,"OP","VIS")," stops)",!
 F I=0:0 S I=$O(^TMP($J,IMR1C,"VI",I)) Q:I'>0!(IMRUT)  D
 .I ($Y+4)>IOSL D PRTC Q:IMRUT  D HEDR
 .S X=+^TMP($J,IMR1C,"VI",I),Y=$P(^(I),U,2) W !?10,$J(X,4)," patient",$S(X>1:"s",1:""),?25,$J(Y,4)," visit",$S(Y>1:"s",1:"")
 .Q
 Q:IMRUT  D PRTC Q:IMRUT  D HEDR S X1="NOT IDENTIFIED"
 F I=-1:0 S I=$O(^TMP($J,IMR1C,"OP",I)) Q:+I'=I!(IMRUT)  D
 .I ($Y+4)>IOSL D PRTC Q:IMRUT  D HEDR
 .S X=^TMP($J,IMR1C,"OP",I),Y=^(I,"VIS"),L=$O(^DIC(40.7,"C",I,0)),Z=$S($D(^TMP($J,IMR1C,"SA",I)):^(I),1:0)
 .D OPP1
 .Q
 Q:IMRUT
 I $D(^XUSEC("IMRMGR",DUZ)),$D(^TMP($J,IMR1C,"NO SC")) D
 .D PRTC Q:IMRUT  D HEDR
 .W !!,"OCCURRENCES OF NO STOP CODE ID",!!
 .F IMRDFN=0:0 S IMRDFN=$O(^TMP($J,IMR1C,"NO SC",IMRDFN)) Q:IMRDFN'>0!(IMRUT)  D OPP2
 .Q
 Q
OPP1 W !,$J(I,3),". ",$S(L'>0:X1,'$D(^DIC(40.7,+L,0)):X1,1:$P(^(0),U)),?35,$J(X,3)," patient",$S(X>1:"s",1:" "),"  ",$J(Z,8,2)," visit",$S(Y>1:"s",1:" "),"   ",$J(Y,4)," stops"
 Q
OPP2 S DFN=IMRDFN D NS^IMRCALL
 F IMRD11=0:0 S IMRD11=$O(^TMP($J,IMR1C,"NO SC",IMRDFN,IMRD11)) Q:IMRD11'>0!(IMRUT)  D
 .I ($Y+4)>IOSL D PRTC Q:IMRUT  D HEDR W !!,"OCCURRENCES OF NO STOP CODE ID",!!
 .W !,$E(IMRNAM,1,25),?27,IMRSSN,"     ",$E(IMRD11,4,5),"/",$E(IMRD11,6,7),"/",$E(IMRD11,2,3),"  ",$S($D(^TMP($J,IMR1C,"NO SC",IMRDFN,IMRD11,1)):"ADD/EDIT STOP CODE",1:"SCHEDULED VISIT")
 .Q
 K VA,VADM,DFN,IMRD11
 Q
 ;
PRTC ; press return to continue
 Q:$E(IOST)'="C"!(IMRUT)!($D(IO("S")))
 K DIR S DIR(0)="E" D ^DIR S:$D(DIRUT)!(Y=0) IMRUT=1
 Q
HEDR ;
 S IMRZ="INPATIENT AND OUTPATIENT ACTIVITY"
 W:$Y>0 @IOF W:IOST'["C-" !!! W !,?(IOM-$L(IMRZ)\2),IMRZ,!,?(IOM-$L(IMRX)\2),IMRX,!?(IOM-$L(IMRD)\2),IMRD,!?(IOM-$L(IMRLBL)\2),IMRLBL,!?(IOM-$L(IMRDTE)\2),IMRDTE,!! S IMRPG=IMRPG+1
 Q
 ;
HEDRA W ?69,"DIFFERENT",!,"PATIENT NAME",?35,"SSN",?48,"VISITS",?60,"STOPS",?68,"STOP CODES",!
 Q
 ;
HEDRB W "PATIENT NAME",?35,"SSN",?48,"# STAYS",?66,"# DAYS",!
 Q
 ;
