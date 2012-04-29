PRCPCSOU ;WISC/RFJ-surgery order supplies utilities                 ;01 Sep 93
 ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q
 ;
 ;
SHOWORD(PATIENT,SURGERY) ;  show orders placed for patient da and surgery da
 N %,DA,DATA,DATE,PRCPFLAG,PRCPFREL,SCREEN,Y
 W !!,"ORDERS WHICH HAVE BEEN PLACED FOR OPERATION:"
 I '$D(^PRCP(445.3,"ASR",PATIENT,SURGERY)) W !?2,"<< NONE >>" Q
 S (DA,SCREEN)=0 F  S DA=$O(^PRCP(445.3,"ASR",PATIENT,SURGERY,DA)) Q:'DA!($G(PRCPFLAG))  D
 .   I SCREEN>(IOSL-5) D P^PRCPUREP Q:$G(PRCPFLAG)  S SCREEN=0
 .   S DATA=$G(^PRCP(445.3,DA,0)) I DATA="" Q
 .   S Y=$P(DATA,"^",4) D DD^%DT S DATE=Y,SCREEN=SCREEN+1
 .   W !,"Order # ",$P(DATA,"^"),?15,"Date: ",DATE,?35,"By: ",$E($$USER^PRCPUREP($P(DATA,"^",5)),1,18),?54,"Status: ",$$STATUS^PRCPOPU(DA)
 .   I $P(DATA,"^",6)'="" S PRCPFREL=1
 I $G(PRCPFREL) W !,"** TO DELETE ORDERS WHICH HAVE BEEN RELEASED FOR PROCESSING, PLEASE PHONE SPD **"
 Q
 ;
 ;
SHOWCC(OPERATE,ORDERDA)      ;  show case carts linked to operation da, order da
 N %,DA,DATA,PRCPFLAG,SCREEN
 W !!,"Case Carts to Order for Operation: ",OPERATE,"  ",$P($$ICPT^PRCPCUT1(+OPERATE),"^",2)
 I '$D(^PRCP(445.7,"AOP",OPERATE)) W !?5,"<< NONE SPECIFIED >>" Q
 S (DA,SCREEN)=0 F  S DA=$O(^PRCP(445.7,"AOP",OPERATE,DA)) Q:'DA!($G(PRCPFLAG))  D
 .   I SCREEN>(IOSL-5) D P^PRCPUREP Q:$G(PRCPFLAG)  S SCREEN=0
 .   S DATA=$G(^PRCP(445.7,DA,0)) I DATA="" Q
 .   S SCREEN=SCREEN+1
 .   W !?5,$E($$DESCR^PRCPUX1($P(DATA,"^",2),DA),1,30),?32,"#",DA,?42
 .   S %=$G(^PRCP(445.3,ORDERDA,1,DA,0))
 .   I %="" W "*** NOT ORDERED ***" Q
 .   W "QTY ORDERED: ",$P(%,"^",2)
 Q
