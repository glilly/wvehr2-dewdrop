IMRSCNT1 ;ISC-SF/JLI-LOCAL COUNT OF PTS, STATUS, OP VISITS, IP STAYS, ETC. CONTINUED (PRINT) ;9/26/91  13:00
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 S IMRUT=0 D OPPRNT I 'IMRUT D IPPRNT
 Q
 ;
OPPRNT ;
 S IMRD="FOR THE PERIOD "_$E(IMRSD,4,5)_"/"_$E(IMRSD,6,7)_"/"_$E(IMRSD,2,3)_" TO "_$E(IMRED,4,5)_"/"_$E(IMRED,6,7)_"/"_$E(IMRED,2,3)
 Q:'$D(^TMP($J,"CT","SO"))  S IMRX="SPECIFIC OUTPATIENT ACTIVITY"
 S IMRUT=0,I="" F IMRI1=0:0 Q:IMRUT  S I=$O(^TMP($J,"SOP",I)) Q:I=""  I $D(^TMP($J,"CT","SO",I)) S IMRN=^(I),IMRSC=+$O(^DIC(40.7,"C",I,0)),IMRSC=$S($D(^DIC(40.7,IMRSC,0)):$P(^(0),U,1,2),1:"NO ID^"),IMRV=^TMP($J,"CT","SV",I) D SC
 Q
SC S N=0,A="" F J=0:0 S A=$O(^TMP($J,"CT","SO",I,A)) Q:A=""  F K=0:0 S K=$O(^TMP($J,"CT","SO",I,A,K)) Q:K'>0  S N=N+1
 D HEDR Q:IMRUT  S X1=$J($P(IMRSC,U,2),4)_"   "_$E($P(IMRSC,U),1,25) W !,X1,?32,$J(N,4)," patient",$S(N'=1:"s",1:" "),"     ",$J(IMRV,7,2)," visit",$S(IMRV'=1:"s",1:" "),"    ",$J(IMRN,4)," stop",$S(IMRN'=1:"s",1:""),!
 S A=""
 F J=0:0 S A=$O(^TMP($J,"CT","SO",I,A)) Q:A=""  F N=0:0 S N=$O(^TMP($J,"CT","SO",I,A,N)) Q:N'>0  S IMRN=^(N),IMRV=^TMP($J,"CT","SV",I,N) S DFN=N D NS^IMRCALL K DFN D SC2
 Q
SC2 ;
 S L=$S($Y+4>IOSL:1,1:0) D:L HEDR Q:IMRUT  W:L !,X1," (Continued)",! W !?5,A,?32,IMRSSN,?44,$J(IMRV,7,2)," visit",$S(IMRV'=1:"s",1:" "),"   ",$J(IMRN,4)," stop",$S(IMRN'=1:"s",1:"")
 Q
 ;
IPPRNT ;
B Q:'$D(^TMP($J,"CT","BS"))  S IMRX="SPECIFIC INPATIENT ACTIVITY",IMRUT=0
 S I="" F IMRII=0:0 Q:IMRUT  S I=$O(^TMP($J,"SBS",I)) Q:I=""  I $D(^TMP($J,"CT","BS",I)) D BS
 Q
BS S N=0,N1=0,ND=0,A=""
 F J=0:0 S A=$O(^TMP($J,"CT","BS",I,A)) Q:A=""  S IMRSS="" F IMRSSI=0:0 S IMRSS=$O(^TMP($J,"CT","BS",I,A,IMRSS)) Q:IMRSS=""  S N=N+1,ND=ND+^(IMRSS) F K=0:0 S K=$O(^TMP($J,"CT","BS",I,A,IMRSS,K)) Q:K'>0  S N1=N1+1
 D HEDR Q:IMRUT  S X1=I W !,X1,?32,$J(N,4)," patient",$S(N'=1:"s",1:" "),"     ",$J(N1,4)," stay",$S(N1'=1:"s",1:" "),"   ",$J(ND,6)," day",$S(ND'=1:"s",1:""),!
 S A=""
 F J=0:0 S A=$O(^TMP($J,"CT","BS",I,A)) Q:A=""!IMRUT  S IMRSS="" F IMRSSI=0:0 Q:IMRUT  S IMRSS=$O(^TMP($J,"CT","BS",I,A,IMRSS)) Q:IMRSS=""  D BS0
 Q
BS0 ;
 F N=0:0 S N=$O(^TMP($J,"CT","BS",I,A,IMRSS,N)) Q:N'>0  S N1=^(N) S L=$S($Y+4>IOSL:1,1:0) D:L HEDR Q:IMRUT  D BS1
 Q
BS1 ;
 W:L !,X1," (Continued)",! W !?5,A,?32,IMRSS,?50,$E(N,4,5),"/",$E(N,6,7),"/",$E(N,2,3),?67,$J(N1,4)," day",$S(N1'=1:"s",1:"")
 Q
 ;
HEDR ;
 S IMRUT=0 I IOST["C-",IMRPG R !!?15,"Enter RETURN to continue or '^' to exit: ",X:DTIME S:'$T IMRUT=1 I 'IMRUT,X[U S IMRUT=1
 I 'IMRUT W:$Y>0 @IOF W:IOST'["C-" !!! W !,?(IOM-$L(IMRX)\2),IMRX,!?(IOM-$L(IMRD)\2),IMRD,!?(IOM-$L(IMRDTE)\2),IMRDTE,!! S IMRPG=IMRPG+1
 Q
