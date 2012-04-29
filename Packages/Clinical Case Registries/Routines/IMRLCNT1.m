IMRLCNT1 ;ISC-SF/JLI-LOCAL COUNT OF PTS, STATUS, OP VISITS, IP STAYS, ETC. (CONTINUED) ;9/5/91  09:22
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 S IMR1C="" F IMR0C=0:0 S IMR1C=$O(^TMP($J,IMR1C)) Q:IMR1C=""  D ATOP
 Q
ATOP ;
 F I=0:0 S I=$O(^TMP($J,IMR1C,"PAT",I)) Q:I'>0  I $D(^(I,"OP")) S J=^("OP"),^("OP")=$S($D(^TMP($J,IMR1C,"OP")):^("OP"),1:0)+1,^("VIS")=$S($D(^("OP","VIS")):^("VIS"),1:0)+J,IMRCS="" D ATOP1
 F I=0:0 S I=$O(^TMP($J,IMR1C,"PAT",I)) Q:I'>0  I $D(^(I,"S")) S ^("S")=$S($D(^TMP($J,IMR1C,"S")):^("S"),1:0)+1 D A21 S ^("VIS")=$S($D(^TMP($J,IMR1C,"S","VIS")):^("VIS"),1:0)+V,^TMP($J,IMR1C,"PAT",I,"S")=V
 F I=0:0 S I=$O(^TMP($J,IMR1C,"PAT",I)) Q:I'>0  I $D(^(I,"S")) S J=^("S"),^(J)=$S($D(^TMP($J,IMR1C,"VIS",J)):^(J),1:0)+1
 F I=0:0 S I=$O(^TMP($J,IMR1C,"VIS",I)) Q:I'>0  S J=999999-I,^TMP($J,IMR1C,"VI",J)=^(I)_U_I K ^TMP($J,IMR1C,"VIS",I)
 F I=0:0 S I=$O(^TMP($J,IMR1C,"PAT",I)) Q:I'>0  S IMRBS="" F L=0:0 S IMRBS=$O(^TMP($J,IMR1C,"PAT",I,"IP","BS",IMRBS)) Q:IMRBS=""  S IMRN=^(IMRBS),IMRDAYS=^(IMRBS,"DAYS") D A3
 F I=0:0 S I=$O(^TMP($J,IMR1C,"PAT",I)) Q:I'>0  I $D(^(I,"IP")) D A4
 Q
ATOP1 ;
 F L=0:0 S IMRCS=$O(^TMP($J,IMR1C,"PAT",I,"OP",IMRCS)) Q:IMRCS=""  D A2
 Q
A21 ;
 S V=0
 F J=0:0 S J=$O(^TMP($J,IMR1C,"PAT",I,"S",J)) S:J'>0 ^(V)=$S($D(^TMP($J,IMR1C,"S",V)):^(V),1:0)+1 Q:J'>0  D A22
 Q
A22 ;
 S V=V+1,X1=+^TMP($J,IMR1C,"PAT",I,"S",J),K=0
 F K1=0:0 S K=$O(^TMP($J,IMR1C,"PAT",I,"S",J,K)) Q:K=""  S ^(K)=$S($D(^TMP($J,IMR1C,"SA",K)):^(K),1:0)+$E(1/X1,1,5) S ^(K)=$S($D(^TMP($J,IMR1C,"SV",K)):^(K),1:0)+$E(1/X1,1,5),^(I)=$S($D(^(K,I)):^(I),1:0)+$E(1/X1,1,5)
 Q
 ;
A2 ;
 S IMRCSN=^TMP($J,IMR1C,"PAT",I,"OP",IMRCS),^(IMRCS)=$S($D(^TMP($J,IMR1C,"OP",IMRCS)):^(IMRCS),1:0)+1,^("VIS")=$S($D(^(IMRCS,"VIS")):^("VIS"),1:0)+IMRCSN,^(IMRCSN)=$S($D(^(IMRCSN)):^(IMRCSN),1:0)+1
 S DFN=I D NS^IMRCALL K DFN S ^(IMRCS)=$S($D(^TMP($J,IMR1C,"SO",IMRCS)):^(IMRCS),1:0)+IMRCSN,^(I)=$S($D(^TMP($J,IMR1C,"SO",IMRCS,$E(IMRNAM,1,25),I)):^(I),1:0)+IMRCSN
 Q
 ;
A3 ;
 S ^(IMRBS)=$S($D(^TMP($J,IMR1C,"IP","BS",IMRBS)):^(IMRBS),1:0)+1,^("DAYS")=$S($D(^(IMRBS,"DAYS")):^("DAYS"),1:0)+IMRDAYS,^("STAYS")=$S($D(^("STAYS")):^("STAYS"),1:0)+IMRN
 F J=-1:0 S J=$O(^TMP($J,IMR1C,"PAT",I,"IP","BS",IMRBS,J)) Q:+J'=J  S K=^(J),^(J)=$S($D(^TMP($J,IMR1C,"IP","BS",IMRBS,J)):^(J),1:0)+K
 Q
 ;
A4 ;
 S X=^TMP($J,IMR1C,"PAT",I,"IP"),IMRDAYS=^("IP","DAYS"),^("IP")=$S(($D(^TMP($J,IMR1C,"IP"))#2):^("IP"),1:0)+1,^("ADMITS")=$S($D(^("IP","ADMITS")):^("ADMITS"),1:0)+X,^("DAYS")=$S($D(^("DAYS")):^("DAYS"),1:0)+IMRDAYS
 S ^(X)=$S($D(^TMP($J,IMR1C,"IP","N",X)):^(X),1:0)+1
 F J=-1:0 S J=$O(^TMP($J,IMR1C,"PAT",I,"IP",J)) Q:+J'=J  S X=^(J),^(J)=$S($D(^TMP($J,IMR1C,"IP",J)):^(J),1:0)+X
 Q
 ;
C4 ;
 I IMRBS="NO ID" S ^TMP($J,IMR1C,"NO BS",IMRDFN,IMRD1,IMRI)=""
 S ^(IMRBS)=$S($D(^TMP($J,IMR1C,"PAT",IMRDFN,"IP","BS",IMRBS)):^(IMRBS),1:0)+1,^("DAYS")=$S($D(^(IMRBS,"DAYS")):^("DAYS"),1:0)+IMRDAYS,^(IMRDAYS)=$S($D(^(IMRDAYS)):^(IMRDAYS),1:0)+1,K=1
 S ^(IMRSSN)=$S($D(^TMP($J,IMR1C,"BS",IMRBS,VADM(1),IMRSSN)):^(IMRSSN),1:0)+IMRDAYS,^(IMRSSN,$S(IMRD1=(IMRAD\1):IMRAD1,1:IMRD1))=IMRDAYS
 Q
 ;
ASKQ ;
 S IMRUT=0 R !!,"How many of the highest users do you want identified ? 0// ",IMRRMAX:DTIME S:'$T!(IMRRMAX="") IMRRMAX=0 S:IMRRMAX[U IMRUT=1,IMRRMAX=U
 I IMRRMAX["?" W !!,"Enter the number, 0 or greater of the individuals with the highest",!,"utilization of pharmacy fills and/or cost you wish listed" G ASKQ
 S IMRRMAX=+IMRRMAX
 Q
