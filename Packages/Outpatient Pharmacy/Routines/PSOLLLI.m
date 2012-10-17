PSOLLLI ;BIR/JLC - LASER LABELS INITIALIZATION ; 11/20/08 12:17pm
        ;;7.0;OUTPATIENT PHARMACY;**120,157,189,161,244,200,206,225,303,266**;DEC 1997;Build 4
        ;
        ;DBIAs PSDRUG-221, PS(55-2228, SC-10040, IBARX-125, PSXSRP-2201, %ZIS-3435, DPT-3097, ^TMP($J,"PSNPPIO"-3794
        ;External reference to DRUG^PSSWRNA supported by DBIA 4449
        ;
        ;*244 remove test for partial fill when testing status > 11
        ;
DQ      N PSOBIO S (I,PSOIO)=0 F  S I=$O(^%ZIS(2,IOST(0),55,I)) Q:'I  S X0=$G(^(I,0)) I X0]"" S PSOIO($P(X0,"^"))=^(1),PSOIO=1
DQ1     I '$D(PPL) G HLEX
        I $P($G(PSOPAR),"^",30)=2,'$G(PSOEXREP) G HLEX
        K RXFLX S PSOCKHN=","_$G(PPL),PSRESOLV=+PPL D CHECK
        S PSOINT=1 F PI=1:1 S RX=$P(PPL,",",PI) Q:RX=""  D
        . S RXY=$G(^PSRX(RX,0)) Q:RXY=""  I PSOPDFN'=$P(RXY,"^",2),'PSOINT D TRAIL^PSOLLL1 S PSOPDFN=$P(RXY,"^",2)
        . K RXP,REPRINT D C
        I 'PSOINT D TRAIL^PSOLLL1
HLEX    K RXPI,PSORX,RXP,PSOIOS,PSOLAPPL,XXX,COPAYVAR,TECH,PHYS,MFG,NURSE,STATE,SIDE,COPIES,EXDT,ISD,PSOINST,RXN,RXY,VADT,DEA,WARN,FDT,QTY,PATST,PDA,PS,PS1,RXP,REPRINT
        K SGY,OSGY,PS2,PSL,PSNP,INRX,RR,XTYPE,SSNP,SSNPN,PNM,ADDR,PSODBQ,PSOLASTF,PSRESOLV,PSOEXREP,PSOSXQ
        K DATE,DR,DRUG,LINE,MW,PRTFL,VRPH,EXPDT,X2,DIFF,DAYS,PSZIP,PSOHZIP,PS55,PS55X
        K ^TMP($J,"PSNPMI"),^TMP($J,"PSOCP",+$G(PSOCPN)),PSOCPN,PSOLBLDR,PSOLBLPS,PSOLBLCP,RXPR,RXRP,RXRS,PSOCKHN,RXFLX,PSOLAPPL,PSOPDFN,PSDFNFLG,PSOZERO,NEXTRX,PSOBLALL,STA
        I '$G(PSOSUREP),'$G(PSOSUSPR) S ZTREQ="@"
        Q
C       N PSOBIO S (I,PSOIO)=0 F  S I=$O(^%ZIS(2,IOST(0),55,I)) Q:'I  S X0=$G(^(I,0)) I X0]"" S PSOIO($P(X0,"^"))=^(1),PSOIO=1
        U IO Q:'$D(^PSRX(RX,0))  S RXY=^(0),RX2=^(2),RXSTA=^("STA") K SGY,OSGY
        S (SIGM,PFM,PMIM,L2,L3,L4,L5,FILLCONT,BOTTLBL)=0
        K SIGF,PFF,PMIF S (SIGF,PFF,PMIF)=0 F I="DR","T" S (SIGF(I),PFF(I))=1
        F I="A","B","I" S PMIF(I)=1
        D NOW^%DTC S Y=$P(%,"."),PSOFNOW=% X ^DD("DD") S PSONOW=Y,Y=PSOFNOW X ^DD("DD") S PSONOWT=Y
        S:$G(PSOBLALL) PSOBLRX=RX S:$D(RXRP(RX)) REPRINT=1 S:$D(RXPR(RX)) RXP=RXPR(RX)
        I $G(PSOSUREP)!($G(PSOEXREP)) S REPRINT=1 I '$G(RXRP(RX)) S RXRP(RX)=1
        S A=$P(RXSTA,"^") I A>11 D AL^PSOLBL("QT") K RXP,REPRINT Q      ;*244
        I A=3 D AL^PSOLBL("QT") K RXP,REPRINT Q
        I $G(RXPR(RX)),'$D(^PSRX(RX,"P",RXP,0)) K RXP,REPRINT Q
        I $P($G(RXFL(RX)),"^"),'$D(^PSRX(RX,1,$P($G(RXFL(RX)),"^"),0)) K RXP,REPRINT Q
        I $G(PSODBQ)!($G(RXRS(RX))) S RR=$O(^PS(52.5,"B",RX,0)) Q:'RR  I $G(^PS(52.5,RR,"P"))=1 K RXP,REPRINT Q
        I $G(RXRS(RX))!($G(PSOPULL)) S PSOSXQ=0 N DR,DA,DIE D  I $G(PSOSXQ) K RXP,REPRINT Q
        . S DA=$O(^PS(52.5,"B",RX,0)) Q:'DA
        . S A=$P($G(^PS(52.5,DA,0)),"^",7) I A="" Q
        . I A="Q" S DIE="^PS(52.5,",DR="3////P" D ^DIE Q
        . K RXRS(RX) S PSOSXQ=1
        I $G(PSRESOLV)=RX D ENLBL^PSOBSET K PSRESOLV
        I $P(RXSTA,"^")'=4 D
        . I $G(PSOSUSPR) D AREC^PSOSUTL
        . I $G(PSOPULL)!($G(RXRS(RX))) D AREC1^PSOSUTL
        . I $G(PSOSUREP) D AREC^PSOSUSRP
        . I $G(PSXREP) D AREC^PSXSRP
        S RXY=^PSRX(RX,0),RX2=^(2),RXSTA=^("STA")
        K ^UTILITY("DIQ1",$J) S DA=$P($$SITE^VASITE(),"^")
        I $G(DA) S DIC=4,DIQ(0)="I",DR="99" D EN^DIQ1 S PSOINST=$G(^UTILITY("DIQ1",$J,4,DA,99,"I")) K ^UTILITY("DIQ1",$J),DA,DR,DIC
        S RXN=$P(RXY,"^"),DFN=+$P(RXY,"^",2),PSOLBLPS=+$P(RXY,"^",3),PSOLBLDR=+$P(RXY,"^",6)
        S ISD=$P(RXY,"^",13),RXF=0,SIG=$P($G(^PSRX(RX,"SIG")),"^"),ISD=$E(ISD,4,5)_"/"_$E(ISD,6,7)_"/"_($E(ISD,1,3)+1700),ZY=0,$P(LINE,"_",28)="_"
        S NURSE=$S($P($G(^DPT(DFN,"NHC")),"^")="Y":1,$P($G(^PS(55,DFN,40)),"^"):1,1:0)
        S FDT=$P(RX2,"^",2),PS=$S($D(^PS(59,PSOSITE,0)):^(0),1:""),PS1=$S($D(^(1)):^(1),1:""),PSOSITE7=$P(^("IB"),"^")
        S PS2=$P(PS,"^")_"^"_$P(PS,"^",6)
        S EXPDT=$P(RX2,"^",6),EXDT=$S('EXPDT:"",1:$E(EXPDT,4,5)_"/"_$E(EXPDT,6,7)_"/"_($E(EXPDT,1,3)+1700))
        S COPIES=$S($P($G(RXRP(RX)),"^",2):$P($G(RXRP(RX)),"^",2),$P(RXY,"^",18)]"":$P(RXY,"^",18),1:1)
        K PSOCKHNX S PSOCKHL=$L(RX),PSOCKHN=$E($G(PSOCKHN),(PSOCKHL+2),999) D  K PSOCKHNX,PSOCKHL,PSOCKHA
        .S PSOCKHA=","_RX_","
        .I PSOCKHN'[PSOCKHA Q
        .S PSOCKHA=$E(PSOCKHA,1,($L(PSOCKHA)-1))
        .S PSOCKHNX=$L(PSOCKHN,PSOCKHA)-1
        .I +$G(PSOCKHNX)>0 D DOUB
        I $O(^PSRX(RX,1,0)),$G(RXFL(RX))'=0 S $P(^PSRX(RX,3),"^",6)="" K ^PSRX(RX,"DAI"),^PSRX(RX,"DRI")
        I '$G(RXP),'$O(^PSRX(RX,1,0)) S RXFL(RX)=0
        I '$G(RXP) D OSET I '$O(^PSRX(RX,1,0))!($G(RXFL(RX))=0) G ORIG
        I $O(^PSRX(RX,1,0)),'$G(RXP) D  G STA
        . I '$G(RXFL(RX)) S XTYPE=1 D REF
        I $G(RXP) S XTYPE="P" D REF G STA
ORIG    S TECH=$P($G(^VA(200,+$P(RXY,"^",16),0)),"^"),PHYS=$S($D(^VA(200,+$P(RXY,"^",4),0)):$P(^(0),"^"),1:"UKN")
        S DAYS=$P(RXY,"^",8),QTY=$P(RXY,"^",7)
        D 6^VADPT,PID^VADPT6 S SSNPN=$G(VA("BID"))
STA     S STATE=$S($D(^DIC(5,+$P(PS,"^",8),0)):$P(^(0),"^",2),1:"UKN")
        S DRUG=$$ZZ^PSOSUTL(RX),DEA=$P($G(^PSDRUG(+$P(RXY,"^",6),0)),"^",3),WARN=$P($G(^(0)),"^",8)
        S WARN=$$DRUG^PSSWRNA(+$P(RXY,"^",6),+$P(RXY,"^",2))
        S SIDE=$S($P($G(RXRP(RX)),"^",3):1,1:0)
        I $G(^PSRX(RX,"P",+$G(RXP),0))]"" S RXPI=RXP D
        .S RXP=^PSRX(RX,"P",RXP,0)
        .S RXY=$P(RXP,"^")_"^"_$P(RXY,"^",2,6)_"^"_$P(RXP,"^",4)_"^"_$P(RXP,"^",10)_"^"_$P(RXY,"^",9)_"^"_$P($G(^PSRX(RX,"SIG")),"^",2)_"^"_$P(RXP,"^",2)_"^"_$P(RXY,"^",12,14)_"^"_$P(^PSRX(RX,"STA"),"^")_"^"_$P(RXP,"^",7)_"^"_$P(RXY,"^",17,99)
        .S FDT=$P(RXP,"^")
        S MW=$P(RXY,"^",11) I $G(RXFL(RX))'=0 D:$G(RXFL(RX))  I '$G(RXFL(RX)) F I=0:0 S I=$O(^PSRX(RX,1,I)) Q:'I  S RXF=RXF+1 S:'$G(RXP) MW=$P(^PSRX(RX,1,I,0),"^",2) I +^PSRX(RX,1,I,0)'<FDT S FDT=+^(0)
        .I $G(RXFL(RX)),'$D(^PSRX(RX,1,RXFL(RX),0)) K RXFL(RX) Q
        .;PSO*7*266
        .S RXF=RXFL(RX) S:'$G(RXP) MW=$P($G(^PSRX(RX,1,RXF,0)),"^",2) F I=0:0 S I=$O(^PSRX(RX,1,I)) Q:'I  I +^PSRX(RX,1,I,0)'<FDT S FDT=+^(0)
        I MW="W",$G(^PSRX(RX,"MP"))]"" D
        .S PSMP=^PSRX(RX,"MP"),PSJ=0 F PSI=1:1:$L(PSMP) S PSMP(PSI)="",PSJ=PSJ+1 F PSJ=PSJ:1 S PSMP(PSI)=PSMP(PSI)_$P(PSMP," ",PSJ)_" " Q:($L(PSMP(PSI))+$L($P(PSMP," ",PSJ+1))>30)
        .K PSMP(PSI)
        ;New mail codes for CMOP
        S MAILCOM=""
        S X=$G(^PS(55,DFN,0)),PSCAP=$P(X,"^",2),PS55=$P(X,"^",3),PS55X=$P(X,"^",5)
        I PS55X]"",PS55>1,PS55X<DT S PS55=0
        S:MW="M" MW=$S((PS55=1!(PS55=4)):"R",1:MW)
        S MAILCOM=$P($G(^PS(59,PSOSITE,9)),"^")
        S MW=$S(MW="M":"REGULAR",MW="R":"CERTIFIED",1:"WINDOW")
        I $G(PSMP(1))="",$G(PS55)=2 S PSMP(1)=$G(SSNPN)
        S DATE=$E(FDT,1,7),REF=$P(RXY,"^",9)-RXF S:'$G(RXP) $P(^PSRX(RX,3),"^")=FDT S:REF<1 REF=0 D ^PSOLBL2 S II=RX D ^PSORFL,RFLDT^PSORFL
        S (X,PSOFLAST)=$G(PSOLASTF) I X?1N.E D ^%DT X ^DD("DD") S PSOFLAST=Y
        S PATST=$G(^PS(53,+$P(RXY,"^",3),0)) S PRTFL=1 I REF=0 S:('$P(PATST,"^",5))!(DEA["W")!(DEA[1)!(DEA[2) PRTFL=0
        S VRPH=$P(RX2,"^",10),PSCLN=+$P(RXY,"^",5),PSCLN=$G(^SC(PSCLN,0)),PSCLN=$S($P(PSCLN,"^",2)'="":$P(PSCLN,"^",2),1:$E($P(PSCLN,"^"),1,7)) I PSCLN="" S PSCLN="UNKNOWN"
        S PATST=$P(PATST,"^",2),X1=DT,X2=$P(RXY,"^",8)-10 D C^%DTC:REF I $D(^PSRX(RX,2)),$P(^(2),"^",6),REF,X'<$P(^(2),"^",6) S REF=0,VRPH=$P(^(2),"^",10)
        I $G(PSOCHAMP),$G(PSOTRAMT) S COPAYVAR="CHAMPUS" G LBL
        I $G(RXP) S COPAYVAR="" G LBL
        I $P($G(^PS(53,+$G(PSOLBLPS),0)),"^",7) D SNO G LBL
        I DEA["I"!(DEA["S")!(DEA["N") D SNO G LBL
        I $P(^PSRX(RX,"STA"),"^")>0,$P(^("STA"),"^")'=2,'$G(PSODBQ) D SNO G LBL
        I $G(PSOLBLCP)="" D IBCP
        N PSOQI S PSOQI=$G(^PSRX(RX,"IBQ"))
        I $G(PSOLBLCP)=0 D SNO G LBL
        I $G(PSOLBLCP)=1 I $P(PSOQI,"^",2)!($P(PSOQI,"^",3))!($P(PSOQI,"^",4))!($P(PSOQI,"^",5))!($P(PSOQI,"^",6))!($P(PSOQI,"^",7))!($P(PSOQI,"^",8)) D SNO G LBL
        I $G(PSOLBLCP)=2 I $P(PSOQI,"^")!($P(PSOQI,"^",2))!($P(PSOQI,"^",3))!($P(PSOQI,"^",4))!($P(PSOQI,"^",5))!($P(PSOQI,"^",6))!($P(PSOQI,"^",7))!($P(PSOQI,"^",8)) D SNO G LBL
        I $G(PSOLBLCP)=2,'$P($G(^PSRX(RX,"IB")),"^") D SNO G LBL
        S PSOCPN=$P(RXY,"^",2),INRX=$P(RXY,"^")
        I $G(^TMP($J,"PSOCP",PSOCPN))="" S ^(PSOCPN)=PSOCPN
        S ^TMP($J,"PSOCP",PSOCPN,INRX)=INRX_"^"_$$ZZ^PSOSUTL(RX)_"^"_+$G(DAYS),COPAYVAR="COPAY" K ZDRUG
LBL     I $G(PSOIO("LLI"))]"" X PSOIO("LLI")
        I $P(RXSTA,"^")=4 D ^PSOLLL8 Q  ;for a critical interaction entered by a tech - don't allow a label to be printed
        I $D(^PSRX(RX,"DRI")),'$G(RXF),'$G(RXP) D ^PSOLLL8
        I $P($G(^PSRX(RX,3)),"^",6),'$G(RXF),'$G(RXP) D ^PSOLLL9
        S PSOINT=0 G ^PSOLLL1
REF     F XXX=0:0 S XXX=$O(^PSRX(RX,XTYPE,XXX)) Q:+XXX'>0  D
        .S TECH=$S($D(^VA(200,+$P(^PSRX(RX,XTYPE,XXX,0),"^",7),0)):$P(^(0),"^"),1:"UNKNOWN")
        .S QTY=$P(^PSRX(RX,XTYPE,XXX,0),"^",4),PHYS=$S($D(^VA(200,+$P(^PSRX(RX,XTYPE,XXX,0),"^",17),0)):$P(^(0),"^"),$D(^VA(200,+$P(^PSRX(RX,0),"^",4),0)):$P(^(0),"^"),1:"UNKNOWN") D 6^VADPT,PID^VADPT6 S SSNPN=$G(VA("BID"))
        .S DAYS=$P(^PSRX(RX,XTYPE,XXX,0),"^",10)
        Q
CHECK   S PSDFNFLG=0,PSOZERO=$P(PPL,","),PSOPDFN=$P(^PSRX(PSOZERO,0),"^",2)
        Q
OSET    ;
        N A
        I $G(RXFL(RX))']""!($G(RXFL(RX))=0) D  Q
        .S A=^PSRX(RX,0)
        .S TECH=$P($G(^VA(200,+$P(A,"^",16),0)),"^"),QTY=$P(A,"^",7),PHYS=$S($D(^VA(200,+$P(A,"^",4),0)):$P(^(0),"^"),1:"UKN") D 6^VADPT,PID^VADPT6 S SSNPN=$G(VA("BID"))
        .S DAYS=$P(A,"^",8)
        I '$D(^PSRX(RX,1,RXFL(RX),0)) K RXFL(RX) Q
        S A=^PSRX(RX,1,RXFL(RX),0)
        S TECH=$S($D(^VA(200,+$P(A,"^",7),0)):$P(^(0),"^"),1:"UNKNOWN")
        S QTY=$P(A,"^",4),PHYS=$S($D(^VA(200,+$P(A,"^",17),0)):$P(^(0),"^"),$D(^VA(200,+$P(^PSRX(RX,0),"^",4),0)):$P(^(0),"^"),1:"UNKNOWN") D 6^VADPT,PID^VADPT6 S SSNPN=$G(VA("BID"))
        S DAYS=$P(A,"^",10)
        Q
DOUB    ;
        Q:'$D(RXFL(RX))
        I +$G(RXFL(RX))-PSOCKHNX<0 Q
        S RXFLX(RX)=$G(RXFL(RX))
        S RXFL(RX)=$G(RXFL(RX))-PSOCKHNX
        Q
IBCP    ;
        N X,Y,PSOJJ,PSOLL
        S PSOLBLCP=""
        S X=$P($G(^PS(59,+$G(PSOSITE),"IB")),"^")_"^"_$G(DFN) D XTYPE^IBARX
        S PSOJJ="" F  S PSOJJ=$O(Y(PSOJJ)) Q:'PSOJJ  S PSOLL="" F  S PSOLL=$O(Y(PSOJJ,PSOLL)) Q:PSOLL=""  S:PSOLL>0 PSOLBLCP=PSOLL
        I '$G(PSOLBLCP) S PSOLBLCP=0
        Q
SNO     ;
        S COPAYVAR="NO COPAY"
        Q
