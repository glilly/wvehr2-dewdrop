IMRLLAB ;HCIOFO/FAI-LOCAL LISTING OF LAB UTILIZATION ;07/17/00  17:23
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
 ;[IMR LAB UTILIZATION LIST] - Laboratory Utilization Data
ASK D ^IMRDATE Q:$G(IMRHNBEG)=""
 S IMRSD=IMRHNBEG,IMRED=IMRHNEND
 I IMRED<IMRSD W !,$C(7),"END CAN NOT BE BEFORE START",! G ASK
 K DIR S DIR(0)="N",DIR("A")="Minimum number of results reported for a test to be listed",DIR("B")=3
 S DIR("?")="This number (1 or greater) is used to keep from showing long lists of infrequent tests by setting a minimum number of results for display" D ^DIR K DIR G:$D(DIRUT) KILL S:Y'>0 Y=1 S IMRN1=+Y
 S DIR(0)="Y",DIR("A")="Print Data by CATEGORY as well as totals",DIR("B")="NO",DIR("?")="Answer YES to get separate listings of utilization by HIV CATEGORY as well as the total population." D ^DIR K DIR S IMR2C=Y
 D LRARC^IMRUTL ;check Lab archive date
 I IMRLRC,IMRLRC'<IMRSD,IMRLRC'>IMRED D ASKN I $D(DIRUT) D KILL Q
 I IMRLRC,IMRLRC'<IMRSD,IMRLRC>IMRED D ASKN I $D(DIRUT) D KILL Q
 S IMRUT=0,IMRRMAX=0
 I $D(^XUSEC("IMRMGR",DUZ)) D ASKQ G:IMRUT KILL
 S %ZIS="NQ" D IMRDEV^IMREDIT:$D(^XUSEC("IMRMGR",DUZ)),^%ZIS:'$D(^XUSEC("IMRMGR",DUZ)) G:POP KILL
 I $D(IO("Q")) D  G KILL
 .S ZTRTN="DQ^IMRLLAB",ZTIO=ION_";"_IOM_";"_IOSL,ZTSAVE("IMRSD")="",ZTSAVE("IMRED")="",ZTSAVE("IMRN1")="",ZTSAVE("IMRRMAX")="",ZTDESC="Selected LAB Activity",ZTSAVE("IMR2C")=""
 .D ^%ZTLOAD
 .K ZTRTN,ZTIO,ZTSAVE,ZTDESC,ZTSK
 .D HOME^%ZIS
 .Q
DQ ;
 U IO D GETNOW^IMRACESS
 K ^TMP($J) S IMRC="CANC",IMRC1="canc"
 F I=0:0 S I=$O(^IMR(158,I)) Q:I'>0  S X=+^(I,0),IMR1C=+$P(^(0),U,42) D XOR^IMRXOR S IMRDFN=X I $D(^DPT(IMRDFN,0)) D DQ1
 F IMR0C=1:1:4,"T" S IMR1C="C"_IMR0C D A1
 D ^IMRLLAB1
 S:$D(ZTQUEUED) ZTREQ="@"
CLOSE D ^%ZISC
KILL K IMRC,IMRC1,IMRFLG,IMRRMAX,IMRN1,IMRSD,IMRED,IMRX,IMRD,IMRAD,IMRDD,IMRDFN,IMRI,IMRLRFN,IMRUT,IMR0C,IMR1C,IMR2C,IMRLBL,I,J,K,M,N,POP,X,X1,Y,Z,Z1,D,DISYS,%T,IMRDTE,IMRYES,IMRDL,IMRLRC D ^%ZISC
 Q
DQ1 ;
 F IMR0C=IMR1C,"T" S IMR1C="C"_IMR0C,^TMP($J,IMR1C,"PAT",IMRDFN)="" I $D(^DPT(IMRDFN,"LR")) S IMRLRFN=+^("LR") I IMRLRFN>0 D C1
 Q
 ;
C1 ;
 S IMRI=IMRED+1
 F IMRI=9999999-IMRI:0 S IMRI=$O(^LR(IMRLRFN,"CH",IMRI)) Q:IMRI'>0!(IMRI>(9999999-IMRSD))  I $O(^(IMRI,0))>0 D C2
 Q
 ;
C2 ;
 S K=0
 F J=0:0 S J=$O(^LR(IMRLRFN,"CH",IMRI,J)) Q:J'>0  I $D(^(J))#2 S X=$P(^(J),U) I $D(^DD(63.04,J,0)),X'[IMRC,X'[IMRC1 D C21
 Q
C21 ;
 S:K=0 ^(IMRDFN)=$S($D(^TMP($J,IMR1C,"PAT",IMRDFN)):^(IMRDFN),1:0)+1,K=1 S ^(J)=$S($D(^TMP($J,IMR1C,"PAT",IMRDFN,J)):^(J),1:0)+1
 Q
 ;
A1 ;
 S ^TMP($J,IMR1C,"LR")=0,^("LR","TST")=0 F IMRDFN=0:0 S IMRDFN=$O(^TMP($J,IMR1C,"PAT",IMRDFN)) Q:IMRDFN'>0  D:^(IMRDFN)>0 AA1 S:^TMP($J,IMR1C,"PAT",IMRDFN)>0 X=^(IMRDFN),^TMP($J,IMR1C,"MAX",(999999-X),IMRDFN)=X D A2
 F I=0:0 S I=$O(^TMP($J,IMR1C,"LR",I)) Q:I'>0  S X=^(I),X1=^(I,"N"),N=$P(^DD(63.04,I,0),U),^TMP($J,IMR1C,"A",(999999-X1),N)=X_U_X1 D A3 K ^TMP($J,IMR1C,"LR",I)
 Q
 ;
AA1 S I=0,J=0 F K=0:0 S K=$O(^TMP($J,IMR1C,"PAT",IMRDFN,K)) Q:K'>0  S I=I+1,J=J+^(K)
 S ^(IMRDFN)=^TMP($J,IMR1C,"PAT",IMRDFN)_U_J_U_I
 Q
 ;
A2 ;
 S:$O(^TMP($J,IMR1C,"PAT",IMRDFN,0))>0 ^("LR")=^TMP($J,IMR1C,"LR")+1
 S K=0 F J=0:0 S J=$O(^TMP($J,IMR1C,"PAT",IMRDFN,J)) Q:J'>0  S K=K+1,X=^(J),^("TST")=^TMP($J,IMR1C,"LR","TST")+X,^(J)=$S($D(^TMP($J,IMR1C,"LR",J)):^(J),1:0)+1,^("N")=$S($D(^(J,"N")):^("N"),1:0)+X,^(X)=$S($D(^(X)):^(X),1:0)+1
 S K=+^TMP($J,IMR1C,"PAT",IMRDFN),J=999999-K,^(J)=($S($D(^TMP($J,IMR1C,"LR","N",J)):+^(J),1:0)+1)_U_K
 Q
 ;
A3 S M=0 F K=0:0 S K=$O(^TMP($J,IMR1C,"LR",I,K)) Q:K'>0  S M=K_U_^(K)
 S ^TMP($J,IMR1C,"A",(999999-X1),N,"MAX")=M
 Q
 ;
ASKQ R !!,"How many of the highest users do you want identified ? 0// ",IMRRMAX:DTIME S:'$T!(IMRRMAX="") IMRRMAX=0 S:IMRRMAX[U IMRUT=1,IMRRMAX=U
 I IMRRMAX["?" W !!,"Enter the number, 0 or greater, of the individuals with the highest",!,"utilization of laboratory orders you wish listed" G ASKQ
 S IMRRMAX=+IMRRMAX
 Q
ASKN ; Ask User Whether they Want to Query the National Registry
 S IMRYES=0 D ASKQ1^IMRNTL Q:'IMRYES
 S IMRRMAX="" D ASKQ^IMRNTL Q:IMRRMAX=""
 S IMRDL="" D ASKQ2^IMRNTL Q:IMRDL=""
 D MSG^IMRNTL,LAB^IMRNTL1
 Q
