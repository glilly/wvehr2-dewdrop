PSOPRFSS        ;BHAM ISC/SAB - PRINTS A PROFILE FROM SUSPENSE ; 11/18/92 19:38
        ;;7.0;OUTPATIENT PHARMACY;**19,300**;DEC 1997;Build 4
        ;PHARMACIST IN REVEIWING RX'S WHEN ADDING A 'NEW' RX
Q       D CUTDATE^PSOFUNC
QOLD    D PLBL^PSORXL
        Q
        ;
DQ      D START Q
        ;
START   D:('$D(PSOBMST)) EN1P^PSOBSET K Z I '$D(PSODTCUT) D CUTDATE^PSOFUNC
        S:'$D(Z) Z=1 S:'$D(NEW1) (NEW1,NEW11)="^" S %DT="",X="T" D ^%DT S DT=Y S X1=DT,X2=-365 D C^%DTC S EXPS=X S X1=DT,X2=-182 D C^%DTC S EXP=X
        K ^TMP($J,"PRF") S LINE="" F I=1:1:110 S LINE=LINE_"-"
        F RXX=0:0 S RXX=$O(^PS(55,DFN,"P",RXX)) Q:'RXX  S RXNN=+^(RXX,0) I $D(^PSRX(RXNN,0)),$P($G(^("STA")),"^")'=13 S RXPX=^PSRX(RXNN,0),$P(RXPX,"^",15)=$P($G(^("STA")),"^"),RXPX2=^(2) D CHK
        D HD I '$D(^TMP($J,"PRF")) W !!?Z+15,"****** NO RX DATA ******",! G PPP
        ;
SD      F SD="A","C","S" W:SD="S" !,?Z+1,"SUPPLIES",$E(LINE,1,89) I $D(^TMP($J,"PRF",SD)) S DRNME="" D DRNME
PPP     D PEND^PSOPRF
        W !!,"NAME: "_$P(^DPT(DFN,0),"^"),!,"ID#: "_VA("PID"),!
        W:IOF]"" @IOF K ^TMP($J,"PRF"),A,B,DRNME,DRP,EXP,EXPS,I,II,ISSD,J,LINE,LN,MESS,MJK,NEW1,NEW11,PHYS,POP,QTY,TTTT,RFL,RFS,RXF,RXNN,RXPX,RXPX2,RXPNO,RXX,SD,SIG,STA,X,X1,X2,Y,Z
        Q
        ;
DRNME   S DRNME=$O(^TMP($J,"PRF",SD,DRNME)) Q:DRNME=""  D ISSD G DRNME
        ;
ISSD    F ISSD=0:0 S ISSD=$O(^TMP($J,"PRF",SD,DRNME,ISSD)) Q:'ISSD  S RXPNO="" D RXPNO
        Q
        ;
RXPNO   S RXPNO=$O(^TMP($J,"PRF",SD,DRNME,ISSD,RXPNO)) Q:RXPNO=""  S RXNN=^(RXPNO) I $D(^PSRX(RXNN,0)) S RXPX=^(0),RXPX2=^(2) D PRT G RXPNO
        W "END***************"
        ;
CHK     Q:PSODTCUT>$P(RXPX2,"^",6)
        I $P(^PSRX(RXNN,"STA"),"^")=12 S II=RXNN D LAST^PSORFL Q:PSODTCUT>RFDATE
        I $P(RXPX,"^",3)=7!($P(RXPX,"^",3)=8)&('PSOPRPAS) Q
        S J="^"_RXNN_"^" Q:(NEW1[J)!(NEW11[J)  Q:$P(RXPX,"^",13)<EXPS  S RXPNO=$P(RXPX,"^"),ISSD=$P(RXPX,"^",13)
        Q:'$D(^PSDRUG($P(RXPX,"^",6),0))  S DRP=^(0),SD=$S($P(DRP,"^",3)["S":"S",$P(RXPX,"^",15)=12:"C",1:"A"),DRNME=$P(DRP,"^"),^TMP($J,"PRF",SD,DRNME,ISSD,RXPNO)=RXNN
        Q
        ;
PRT     S RFS=$P(RXPX,"^",9),QTY=$P(RXPX,"^",7)
        S PHYS=$S($D(^VA(200,$P(RXPX,"^",4),0)):$P(^(0),"^"),1:"UNKNOWN"),II=RXNN D LAST^PSORFL S RXF=0 F MJK=0:0 S MJK=$O(^PSRX(RXNN,1,MJK)) Q:'MJK  S RXF=RXF+1
        S STA=$S($P(^PSRX(RXNN,"STA"),"^")=14:"DC",$P(^PSRX(RXNN,"STA"),"^")=15:"DE",$P(^PSRX(RXNN,"STA"),"^")=16:"PH",1:$E("ANRHPS     ECD",(1+$P(^PSRX(RXNN,"STA"),"^")))),STA=$S(DT>$P(RXPX2,"^",6):"E",1:STA)
        W !,?Z+1,RXPNO,?Z+15,DRNME,?Z+55,$E(ISSD,4,5),"/",$E(ISSD,6,7)," ",$E(RFL,1,5)," ",?Z+67,$J(RFS,2)," ",$J(RXF,2)," ",?Z+73,$J(QTY,12)," ",?Z+86,STA," ",?Z+88,$E(PHYS,1,20)
        D SIG^PSOPRF F TTTT=0:0 S TTTT=$O(FSIG(TTTT)) Q:'TTTT  W !,?Z+19,FSIG(TTTT)
        Q
        ;
HD      D PID^VADPT
        W !,?Z+17,"PRESCRIPTION PROFILE AS OF ",$E(DT,4,5),"/",$E(DT,6,7),"/",($E(DT,1,3)+1700)
        W !!,?Z+20,"NAME: ",$P(^DPT(DFN,0),"^"),!,?Z+20,"ID# : "_VA("PID")
        I $D(^PS(55,DFN,1)) S MESS=^(1),LN=$L(MESS),A=0 W ! F B=1:1 Q:$P(MESS," ",B,99)=""  W:$X>(Z+63) ! W ?Z+31,$P(MESS," ",B)," "
        W !!?Z+20,"PHARMACIST: ___________________________  DATE: ____________"
        W !!?Z+52,"   DATES   ",?Z+67,"REFS ",?Z+86,"S"
        W !?Z+1,"RX #     ",?Z+15,"DRUG/STRENGTH/SIG",?Z+55,"ISSD  LAST ",?Z+67,"AL AC",?Z+77,"QTY",?Z+86,"T",?Z+93,"PROVIDER"
        W !?Z+1,$E(LINE,1,12),?Z+15,$E(LINE,1,35),?Z+55,"----- -----",?Z+67,"-- --",?Z+73,"------------",?Z+86,"-",?Z+88,$E(LINE,1,20)
