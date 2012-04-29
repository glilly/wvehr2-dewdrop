IMRKEYS ;ISC-SF/JLI,HCIOFO/FT-DISPLAY HOLDERS OF 'IMR' KEYS ;10/17/97  10:09
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 ;[IMR KEYS] - Show users with access to 'ICR' keys
 I '$D(^XUSEC("IMRMGR",DUZ)) S IMRLOC="IMRKEYS" D ACESSERR^IMRERR,H^XUS K IMRLOC
 W:$Y>0 @IOF
 W !,"Holders of KEYS for 'IMR' Package as of: ",$$FMTE^XLFDT($$NOW^XLFDT(),1)
 S A="IMR",J=0,IMRUT=0
 F I=0:0 S I=$O(^XUSEC(A,I)) Q:I'>0!(IMRUT)  D
 .W:J=0 !!,A," KEY HOLDERS:"
 .S J=1
 .I $Y>(IOSL-4) D PRTC Q:IMRUT  W @IOF
 .W !?20,$S($D(^VA(200,I,0)):$P(^(0),U),1:"UNKNOWN USER # "_I)
 .Q
 F I=0:0 S J=0,A=$O(^XUSEC(A)) Q:A=""!($E(A,1,3)'="IMR")!(IMRUT)  F K=0:0 S K=$O(^XUSEC(A,K)) Q:K'>0!(IMRUT)  D
 .W:J=0 !!,A," KEY HOLDERS:"
 .S J=1
 .I $Y>(IOSL-4) D PRTC Q:IMRUT  W @IOF
 .W !?20,$S($D(^VA(200,K,0)):$P(^(0),U),1:"UNKNOWN USER # "_K)
 .Q
 I 'IMRUT D PRTC
 K A,I,IMRUT,J,K,D,DISYS,X,Y
 Q
PRTC ; press return to continue
 Q:$E(IOST)'="C"  ;quit if terminal
 Q:$D(IO("S"))  ;quit if slave device
 K DIR S DIR(0)="E" D ^DIR K DIR S:$D(DIRUT) IMRUT=1
 Q
