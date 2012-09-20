PSOHLNEW        ;BIR/RTR - CPRS orders ;2/25/09 11:01am
        ;;7.0;OUTPATIENT PHARMACY;**1,7,15,46,71,98,111,124,117,131,146,132,143,223,235,148,239,249,225,324**;DEC 1997;Build 6
        ;40.8-728,50-221,SC-2675,100-2219,50.7-2223,EN^ORERR-2187
EN(MSG) ;
        N PSODDRUG,ENTERED,LOCATION,PLACER,PSOOC,ROUTE,NATURE,PREV,ROUTING,OO,OR,STAT,ZZ,DFN,COMM,QCOUNT,OCOUNT,Q1I,QTARRAY,QTARRAY2,EE,PP,XOFLAG,PSODYSPL,PSOFILNM
        N ONEFLAG,SERV,WPCT,EFFECT,PROV,PENDING,RRX,PSOLQ1I,PSOLQ1II,PSOQWX,PSOLQ1IX,PSONVA,PSOICD,PSOSCP,EEE
        N OBXAR,AA,II,SIG1,FILLER,COMM,GG,FF,JJ,JJJ,CT,LIM,VAR,VAR1,QQQ,PSRNFLAG,PSRNQFLG,RCOMM,XOFLAGZ,NWFLAG,PFLAG,PSINPTR,INPTRX,PSOIBN,PSOIBY
        N DSIG,PSOCHFFL,PSOCVI,PSOMO,PSOXRP,NN,LL,LLL,WPARRAY,QTVAR,POVAR,POVAR1,ORCSEG,NNN,OOO,AAA,NNNN,POLIM,NNCK,PRIOR,IPPLACER,PLACERXX,EER,PSERRPID,PSERRPV1,PSERRORC,PSOEXFLG,PSOMSORR,PDFN,VAL
        S (SEND,PSOSND,OCOUNT)=0 K PSOPLC,PSOFFL,PSORSO,PSOSUSZ
        F OO=0:0 S OO=$O(MSG(OO)) Q:'OO!(SEND)!(PSOSND)  D:$P(MSG(OO),"|")="PID" SPDFN I $P(MSG(OO),"|")="ORC",$P(MSG(OO),"|",2)'="NW",$P(MSG(OO),"|",2)'="XO" D
        .S OR("STAT")=$P(MSG(OO),"|",2),OR("PLACE")=+$P(MSG(OO),"|",3),PLACERXX=+$P($P(MSG(OO),"|",3),";",2),OR("COMM")=$P(MSG(OO),"|",17),OR("USER")=$P(MSG(OO),"|",11) I $P(MSG(OO),"|",2)'="DE",$P(MSG(OO),"|",2)'="NA" S SEND=1 D FILL Q
        .S PSOPLC=+$P(MSG(OO),"|",3),PSOFFL=+$P(MSG(OO),"|",4),PSOSND=1,PSOCHFFL=$P($P(MSG(OO),"|",4),"^")
        I $G(OR("COMM"))["^" S OR("COMM")=$P(OR("COMM"),"^",5)
        I PSOSND,$G(PSOCHFFL)["S",$G(OR("STAT"))="NA" D CHCS^PSOHLNE1 Q
        I PSOSND,'$D(^PSRX(+$G(PSOFFL),0)) S COMM="Order was not located by Pharmacy" D EN^ORERR(COMM,.MSG) D KL Q
        I PSOSND,$G(PDFN),PDFN'=+$P($G(^PSRX(+$G(PSOFFL),0)),"^",2) S COMM="Patient does not match" D EN^ORERR(COMM,.MSG) D KL Q
        I PSOSND,$G(OR("STAT"))'="DE" N PSONAS S PSONAS=$S($P($G(^PSRX(PSOFFL,"OR1")),"^",2)="":1,1:0) S $P(^PSRX(PSOFFL,"OR1"),"^",2)=PSOPLC,^PSRX("APL",PSOPLC,PSOFFL)="" D:PSONAS EN^PSOHDR("PRES",PSOFFL) D KL Q
        D KL
        I SEND,$G(OR("STAT"))="Z@" G PURGE^PSOHLNE2
        I SEND,$G(OR("STAT"))="ZF" G REF^PSOHLNE2
        I SEND,$G(OR("STAT"))'="CA",$G(OR("STAT"))'="DC",$G(OR("STAT"))'="HD",$G(OR("STAT"))'="RL",$G(OR("STAT"))'="SS" S RCOMM="Invalid Order Control Code" D EN^ORERR(RCOMM,.MSG) Q
        I SEND K SEND G:$G(OR("STAT"))="SS" ESTAT D EN^PSOORUTL(.OR) S PLACER=OR("PLACE"),STAT=OR("STAT"),COMM=OR("COMM") S PSOMSORR=1 D  K PSOMSORR Q
        .I $G(OR("FILLER"))="" D  D ERROR^PSOHLSN Q
        ..F EER=0:0 S EER=$O(MSG(EER)) Q:'EER  S:$P(MSG(EER),"|")="PV1" PSERRPV1=MSG(EER) S:$P(MSG(EER),"|")="PID" PSERRPID=MSG(EER) S:$P(MSG(EER),"|")="ORC"&($G(PSERRORC)="") PSERRORC=MSG(EER)
        .I $P(OR("FILLER"),"^",2)="R" S FILLER=$P(OR("FILLER"),"^") D EN^PSOHLSN1(FILLER,STAT,$G(OR("PHARMST")),COMM) K:$G(PSOEXFLG) PSOMSORR,PLACERXX D:$G(PSOEXFLG) EN^PSOHLSN1(FILLER,"SC","ZE","") D:$G(PSOSUSZ) SUS^PSOORUT1 K PSOSUSZ Q
        .D EN^PSOHLSN(PLACER,STAT,COMM) Q
        D KL^PSOHLSIH S RRX=1 F ZZ=0:0 S ZZ=$O(MSG(ZZ)) Q:'ZZ  S PSOSEG=$G(MSG(ZZ)),PSOTYPE=$P(PSOSEG,"|") S PSOSEG=$E(PSOSEG,5,$L(PSOSEG)) I PSOTYPE'="NTE" D @PSOTYPE
        I $G(PSRNFLAG) S PSOMO=0 D MISRN^PSOHLNE1 I $G(PSOMO) Q
        S PSRNQFLG=0 I $G(PSRNFLAG),$G(PREV) D  I $G(PSRNQFLG) S RCOMM="Duplicate Renewal Request. Order rejected by Pharmacy." D EN^ORERR(RCOMM,.MSG) D RERROR^PSOHLSN D KL^PSOHLSIH Q
        .I $P($G(^PSRX(PREV,"OR1")),"^",4) S PSRNQFLG=1 Q
        .I $O(^PS(52.41,"AQ",PREV,0)) S PSRNQFLG=1
        .I $G(XOFLAG),$G(DFN)'=$S($G(PFLAG):$P($G(^PS(52.41,+$G(PREV),0)),"^",2),1:$P($G(^PSRX(+$G(PREV),0)),"^",2)) S RCOMM="Patient mismatch on previous order." D EN^ORERR(RCOMM,.MSG) S XOFLAGZ=1 D RERROR^PSOHLSN D KL^PSOHLSIH Q
        I $G(PLACER) I $G(DFN)'=+$P($G(^OR(100,+PLACER,0)),"^",2) G MISX^PSOHLNE1
        I $G(PLACER) D NFILE
        D KL^PSOHLSIH
        Q
ESTAT   ;
        D EXP^PSOHLNE1
        Q
MSH     Q
PID     S DFN=+$P(PSOSEG,"|",3)
        Q
PV1     S LOCATION=+$P(+$P(PSOSEG,"|",3),"^")
        S:'$D(^SC(LOCATION,0)) LOCATION=""
        S INPTRX=0 I $G(LOCATION) S PSINPTR=$P($G(^SC(LOCATION,0)),"^",4) I PSINPTR Q
        I $G(LOCATION) S INPTRX=$P($G(^SC(LOCATION,0)),"^",15)
        I '$G(INPTRX) S INPTRX=$O(^DG(40.8,0))
        I '$G(DT) S DT=$$DT^XLFDT
        S PSINPTR=+$$SITE^VASITE(DT,INPTRX)
        Q
OBR     ;This segment is used to pass flagging information from CPRS.
        D OBR^PSOHLNE4
        Q
DG1     S $P(PSOICD($P(PSOSEG,"|",1)),"^")=$P($P(PSOSEG,"|",3),"^")
        Q
ORC     ;
        Q:$P(PSOSEG,"|")="DE"
        S:$P(PSOSEG,"|")="XO" XOFLAG=1 D ^PSOHLNE1 S:$G(PRIOR)="A" PRIOR="E" S:$G(PRIOR)="" PRIOR="R"
        Q
        ;
RXO     I $O(MSG(ZZ,0)) D ^PSOHLNE2 G RXOPS
        S PSORDITE=$P($P(PSOSEG,"|"),"^",4)
        S PSODDRUG=$P($P(PSOSEG,"|",10),"^",4) I $G(PSODDRUG) S:'$D(^PSDRUG(PSODDRUG,0)) PSODDRUG=""
        S PSOXQTY=$P(PSOSEG,"|",11)
        S PSOREFIL=$P(PSOSEG,"|",13)
        S PSODYSPL=$P(PSOSEG,"|",17)
RXOPS   S ONEFLAG=0,WPCT=1,LL=ZZ+1
        I $P($G(MSG(LL)),"|")="NTE" D
        .S ONEFLAG=1,WORDP=$S($P(MSG(LL),"|",2):$P(MSG(LL),"|",2),1:$P(MSG(LL),"|",3)) S:$P(MSG(LL),"|",4)'="" WPARRAY(WORDP,WPCT)=$P(MSG(LL),"|",4) S:$P(MSG(LL),"|",4)'="" WPCT=WPCT+1 F LLL=0:0 S LLL=$O(MSG(LL,LLL)) Q:'LLL  D
        ..I $G(MSG(LL,LLL))'="" S WPARRAY(WORDP,WPCT)=$G(MSG(LL,LLL)),WPCT=WPCT+1
        I ONEFLAG S LL=LL+1 I $P($G(MSG(LL)),"|")="NTE" D NTE^PSOHLNE1
        K WORDP
        Q
RXR     I $P($P(PSOSEG,"|"),"^",4) S ROUTE(RRX)=$P($P(PSOSEG,"|"),"^",4) S RRX=RRX+1
        Q
OBX     I $O(MSG(ZZ,0)) D OBXX^PSOHLNE2 G OBXNTE
        S OCOUNT=OCOUNT+1
        S OBXAR(OCOUNT,1)=$P(PSOSEG,"|",5)
OBXNTE  ;
        D OBXNTE^PSOHLNE3
        Q
ZRN     S PSODSC=1_"^"_$P(PSOSEG,"|",2)
        I $O(MSG(ZZ,0)) F T=0:0 S T=$O(MSG(ZZ,T)) Q:'T  S PSODSC(T)=MSG(ZZ,T)
        K T
        Q
        ;
ZRX     D ZRX^PSOHLNE1
        Q
        ;
ZCL     D ZCL^PSOHLNE1
        Q
ZSC     D CP^PSOHLNE1
        Q
NFILE   ;
        I $G(PSODSC) D ^PSONVNEW Q  ;adds non-va med to #55
        ;
        K DD,DO,DIC S DLAYGO="52.41",DIC="^PS(52.41,",DIC(0)="L",X=PLACER,DIC("DR")="1////"_DFN_";2////"_PSOOC_";6////"_$G(EFFECT)_";12////"_$G(PSOXQTY)_";25////"_$G(PRIOR)
        S DIC("DR")=DIC("DR")_";22////"_$G(PSORSO)_";22.1////"_$G(PREV)_";19////"_$G(ROUTING)_";17////"_$$UNESC^ORHLESC($G(SERV))_";7////"_$G(NATURE)_";13////"_$G(PSOREFIL)_";1.1////"_$G(LOCATION)_";117////"_$G(DSIG)
        D FILE^DICN K DIC,DR I Y<0 Q
        S PENDING=+Y
        S $P(^PS(52.41,PENDING,0),"^",4)=$S($G(ENTERED):+$G(ENTERED),1:""),$P(^(0),"^",5)=$S($G(PROV):+$G(PROV),1:""),$P(^(0),"^",8)=$S($G(PSORDITE):+$G(PSORDITE),1:""),$P(^(0),"^",9)=$S($G(PSODDRUG):+$G(PSODDRUG),1:""),$P(^(0),"^",15)=$G(ROUTE)
        S ^PS(52.41,PENDING,"IBQ")=$G(PSOIBY)
        I $G(PSODYSPL)'="",$E(PSODYSPL)?1A S PSODYSPL=$E(PSODYSPL,2,$L(PSODYSPL))
        S $P(^PS(52.41,PENDING,"INI"),"^")=$G(PSINPTR),$P(^(0),"^",12)=$G(PSOLOG),$P(^(0),"^",22)=$G(PSODYSPL)
        I $G(QCOUNT) S ^PS(52.41,PENDING,1,0)="^52.413^"_QCOUNT_"^"_QCOUNT
        S PSOQWX=$G(PSODDRUG) D:'$G(PSOQWX) OID^PSOHLNE1
        F PP=0:0 S PP=$O(Q1I(PP)) Q:'PP  S VAL=$S($G(PSOQWX)&($G(PSOLQ1II(PP))):Q1I(PP),$G(PSOQWX)&($G(PSOLQ1IX(PP))'="")&('$G(PSOLQ1II(PP))):PSOLQ1IX(PP),1:PSOLQ1I(PP)) S ^PS(52.41,PENDING,1,PP,0)=$$UNESC^ORHLESC(VAL)
        F EE=0:0 S EE=$O(QTARRAY(EE)) Q:'EE  S ^PS(52.41,PENDING,1,EE,1)=$$UNESC^ORHLESC(QTARRAY(EE)) S VAL=$S($G(PSOQWX)&($G(PSOLQ1II(EE))):$G(QTARRAY2(EE)),$G(PSOQWX)&($G(PSOLQ1IX(EE))'="")&('$G(PSOLQ1II(EE))):PSOLQ1IX(EE),1:$G(PSOLQ1I(EE))) D
        .S ^PS(52.41,PENDING,1,EE,2)=$$UNESC^ORHLESC(VAL) S $P(^PS(52.41,PENDING,1,EE,1),"^",8)=+$G(ROUTE(EE))
        S:$P($G(^PS(52.41,PENDING,1,1,1)),"^",3) $P(^PS(52.41,PENDING,0),"^",18)=$E($P($G(^PS(52.41,PENDING,1,1,1)),"^",3),1,7)
        D STUFF^PSOHLNE2
        D ^PSOHLPII
        S LL=0 I $O(WPARRAY(6,0)) F LLL=0:0 S LLL=$O(WPARRAY(6,LLL)) Q:'LLL  S LL=LL+1 S ^PS(52.41,PENDING,3,LL,0)=$$UNESC^ORHLESC($G(WPARRAY(6,LLL)))
        I LL S ^PS(52.41,PENDING,3,0)="^52.42^"_LL_"^"_LL
        S LL=0 I $O(WPARRAY(7,0)) F LLL=0:0 S LLL=$O(WPARRAY(7,LLL)) Q:'LLL  S LL=LL+1 S ^PS(52.41,PENDING,"INS1",LL,0)=$$UNESC^ORHLESC($G(WPARRAY(7,LLL)))
        I LL S ^PS(52.41,PENDING,"INS1",0)="^^"_LL_"^"_LL_"^"_$G(DT)_"^"
        I $P($G(^PS(50.7,+$G(PSORDITE),"INS")),"^")'="" S $P(^PS(52.41,PENDING,"INS"),"^",2)=$S($O(^PS(52.41,PENDING,"INS1",0)):1,1:0)
        I $G(OCOUNT) S ^PS(52.41,PENDING,"OBX",0)="^52.4118A^"_OCOUNT_"^"_OCOUNT F OCOUNT=1:1:OCOUNT D
        .S ^PS(52.41,PENDING,"OBX",OCOUNT,0)=$$UNESC^ORHLESC($G(OBXAR(OCOUNT,1)))
        .D USER^PSOORFI2(+$G(PROV)) S ^PS(52.41,PENDING,"OBX",OCOUNT,1)=$$UNESC^ORHLESC(USER1) K USER1
        .S PSOBCT=1 F LLL=2:1 Q:'$D(OBXAR(OCOUNT,LLL))  S ^PS(52.41,PENDING,"OBX",OCOUNT,2,PSOBCT,0)=$$UNESC^ORHLESC(OBXAR(OCOUNT,LLL)),^PS(52.41,PENDING,"OBX",OCOUNT,2,0)="^^"_PSOBCT_"^"_PSOBCT_"^"_$G(DT)_"^"
        D ^PSOHLPIS
        K DIK S DIK="^PS(52.41,",DA=PENDING D IX^DIK
        I $G(PSOOC)="RNW",$G(PREV),$D(^PSRX(+$G(PREV),0)) D EN^PSOHLSN1(PREV,"SC","ZZ","")
        S PSOMSORR=1,IPPLACER=$P($G(^PS(52.41,PENDING,0)),"^") I IPPLACER D
        .I '$G(XOFLAG) D EN^PSOHLSN(IPPLACER,"OK","IP") Q
        .D EN^PSOHLSN(IPPLACER,"XR","IP") I $G(PFLAG) D DCP^PSOHLSN Q
        .K PSOMSORR I $D(^PSRX(+$G(PREV),0)) D  D EN^PSOHLSN1(PREV,"RP","","","A")
        ..S $P(^PSRX(PREV,"STA"),"^")=15,$P(^PSRX(PREV,3),"^",5)=DT,$P(^PSRX(PREV,3),"^",10)=$P(^PSRX(PREV,3),"^")  ;;PSO*7*249
        ..D CHKCMOP^PSOUTL(PREV)
        ..D REVERSE^PSOBPSU1(PREV,,"DC",7),CAN^PSOTPCAN(PREV),CAN^PSOUTL(PREV)
        ..D CNT^PSOHLNE1
        ..D:$G(^PS(52.41,PENDING,1,1,0))=""&($P($G(^PS(52.41,PENDING,1,1,1)),"^")="")&($G(^PS(52.41,PENDING,"SIG",1,0))="")
        ...N FSIG,BSIG
        ...I '$P($G(^PSRX(PREV,"SIG")),"^",2),$P($G(^("SIG")),"^")'="" D
        ....D EN3^PSOUTLA1(PREV,70)
        ....I $G(BSIG(1))'="" S ^PS(52.41,PENDING,"SIG",1,0)=$$UNESC^ORHLESC($G(BSIG(1))) I $O(BSIG(1)) F EE=1:0 S EE=$O(BSIG(EE)) Q:'EE  S ^PS(52.41,PENDING,"SIG",EE,0)=$$UNESC^ORHLESC($G(BSIG(EE)))
        ...I $P($G(^PSRX(PREV,"SIG")),"^",2),$G(^PSRX(PREV,"SIG1",1,0))'="" D
        ....D FSIG^PSOUTLA("R",PREV,70)
        ....I $G(FSIG(1))'="" S ^PS(52.41,PENDING,"SIG",1,0)=$$UNESC^ORHLESC($G(FSIG(1))) I $O(FSIG(1)) F EE=1:0 S EE=$O(FSIG(EE)) Q:'EE  S ^PS(52.41,PENDING,"SIG",EE,0)=$$UNESC^ORHLESC($G(FSIG(EE)))
        ...F EE=0:0 S EE=$O(^PS(52.41,PENDING,"SIG",EE)) Q:'EE  S ^PS(52.41,PENDING,"SIG",0)="^52.4124A^"_EE_"^"_EE
        D CSET^PSODIAG
        Q
SPDFN   S PDFN=$P($G(MSG(OO)),"|",4) Q
KL      K PSOPLC,PSOFFL,PSOSND
        Q
FILL    ;
        S (PSOFILNM,OR("PSOFILNM"))=$P($P(MSG(OO),"|",4),"^")
        Q
