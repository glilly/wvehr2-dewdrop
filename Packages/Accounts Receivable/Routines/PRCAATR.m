PRCAATR ;WASH-ISC@ALTOONA,PA/RGY-VIEW TRANSACTION FOR BILLS ;2/14/96  2:46 PM
V ;;4.5;Accounts Receivable;**36,104,172,138**;Mar 20, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
EN1(BILL) ;ENTRY POINT FROM PRCAAPR
 NEW X,COUNT,OUT,TRAN,SEL,PRCAATRX,PRCAIO,PRCAIOS,D0,PRCAQUE,POP,PRCAPRT,Y,ZTSK
 I '$D(BILL) G Q
 I BILL'?1N.N!'$D(^PRCA(430,+BILL,0)) G Q
 S PRCAPRT=1,PRCAIO=IO(0),PRCAIO(0)=IO(0),COUNT=0 K ^TMP("PRCAATR",$J)
 D HDR,DIS,^%ZISC
Q K ^TMP("PRCAATR",$J),IO("Q") Q
HDR ;Header
 D HDR^PRCAAPR1
 I $P($G(^PRCA(430,BILL,13)),"^") W !,"MEDICARE CONTRACTUAL ADJUSTMENT: ",$J($P($G(^PRCA(430,BILL,13)),"^"),0,2)
 I $P($G(^PRCA(430,BILL,13)),"^",2) W !,"UNREIMBURSED MEDICARE EXPENSE: ",$J($P($G(^PRCA(430,BILL,13)),"^",2),0,2)
 W !,"Bill #: ",$P(^PRCA(430,BILL,0),"^") D:$P(^(0),"^",9)'=+DEBT DEB W !!,"#",?8,"Tr #",?17,"Type",?52,"Date",?68,"Amount"
 S X="",$P(X,"-",IOM)="" W !,X
 Q
DIS ;Display transactions
 W !,?17,"Original Amount",?52,$$SLH^RCFN01($P(^PRCA(430,BILL,0),"^",10)),?65,$J($P(^(0),"^",3),9,2)
 I '$O(^PRCA(433,"C",BILL,0)) D
 . S X="",$P(X,"*",20)="" W !!,X,"  NO TRANSACTION INFORMATION AVAILABLE  ",X
RD . R !!,"Press return to continue: ",X:DTIME S:'$T DTOUT=1 S OUT=1
 . I X["?" W !!,"Press the return key to return to menu." G RD
 . Q
 F TRAN=0:0 S TRAN=$O(^PRCA(433,"C",BILL,TRAN)) Q:'TRAN!$D(OUT)  D TLN
 S X=$G(^PRCA(430,BILL,7))
 I '$D(OUT) W !?65,"------",!,?64,"$",$J($P(X,"^")+$P(X,"^",2)+$P(X,"^",3)+$P(X,"^",4)+$P(X,"^",5),9,2) D READ
 Q
TLN ;Display a transaction
 N YR
 I $Y+5>IOSL,COUNT D READ G:$D(DTOUT)!$D(OUT) Q1 D HDR
 S COUNT=COUNT+1,X=$G(^PRCA(433,TRAN,1)),^TMP("PRCAATR",$J,COUNT)=TRAN
 W !,COUNT,$S($P(^PRCA(433,TRAN,0),"^",4)=1!$P(^(0),"^",10):"(I)",1:""),?8,TRAN,?17
 W $S($P($G(^PRCA(430.3,+$P(X,"^",2),0)),"^",3)=17:$P($G(^PRCA(433,TRAN,5)),"^",2),1:$P($G(^(0)),"^"))
 ;  show decrease adjustments as negative (patch 4.5*172)
 I $P(X,"^",2)=35 S:$P(X,"^",5)>0 $P(X,"^",5)=-$P(X,"^",5)
 W ?52,$S(+X:$$SLH^RCFN01(+X),1:""),?65,$J($P(X,"^",5),9,2)
Q1 Q
READ ;Read a trans number
 I IO'=IO(0) G Q2
ASK W !!,"Select 1-",COUNT,$S(PRCAPRT:" or 'P' to Print",1:" to print") W:TRAN " or return to continue" R ": ",X:DTIME I X["^"!'$T S:'$T DTOUT=1 S OUT=1 G Q2
 I PRCAPRT,X="P" S %ZIS="MQ" D ^%ZIS D  S PRCAPRT=0,PRCAIO=IO,PRCAIO(0)=IO(0) G:'POP ASK K POP S OUT=1 G Q2
 . I $D(IO("S")) S PRCAIOS=ION D ^%ZISC
 . Q
 I X["?" W !!,"To see detailed information for a transaction number, enter the corresponding '#'",!,"next to the transaction.  (Ex: 1 or 1,3)" G ASK
 I X="" S:TRAN="" OUT=1 G Q2
 S SEL=X
 F X=1:1:$L(SEL,",") S Y=$P(SEL,",",X) I Y'?1N.N!'$D(^TMP("PRCAATR",$J,+Y)) W *7," ??" G READ
 F PRCAATRX=1:1:$L(SEL,",") S Y=$P(SEL,",",PRCAATRX) D VT Q:$D(OUT)
 S OUT=1
Q2 Q
VT ;View a transaction
 N IOP,%ZIS,ZTRTN,ZTDESC,ZTSAVE,ZTDTH
 S D0=$G(^TMP("PRCAATR",$J,+Y)) G:'D0 Q3
 I $D(IO("Q")) S ZTSAVE("D0")="",ZTSAVE("PRCAIO")=IO,ZTSAVE("PRCAIO(0)")=IO(0),ZTRTN="DQ^PRCAATR",ZTDESC="AR TRANS PROFILE",ZTDTH=$H D ^%ZTLOAD W !,"*** Trans # ",D0," REQUEST QUEUED ***" G Q3
 I IO'=IO(0) W !,"OK, Printing Transaction # ",D0," ..."
 I $D(PRCAIOS) S IOP=PRCAIOS D ^%ZIS
 U IO D DQ U IO(0)
Q3 Q
DQ ;
 W @IOF S X="",$P(X,"=",30)="" W !,X," TRANSACTION PROFILE ",X,!!
 K DXS D ^PRCATR3 K DXS S X=D0 D ENF^IBOLK
RD1 I $E(IOST)="C" R !!,"PRESS <RETURN> TO CONTINUE: ",X:DTIME S:'$T DTOUT=1,OUT=1 I X["?" W !!,"Press return to view next transaction or to continue" G RD1
 Q
DEB ;View debtor
 NEW PRCA
 S PRCA=$P(^PRCA(430,BILL,0),"^",9) I PRCA S PRCA=$P(^RCD(340,PRCA,0),"^") W "   ",$P($G(@("^"_$P(PRCA,";",2)_+PRCA_",0)")),"^")
 Q
