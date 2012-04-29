PSODRDU2 ;BHAM ISC/SAB - dup drug/class display for outpatient orders ;9/23/97 8:40am
 ;;7.0;OUTPATIENT PHARMACY;**132**;DEC 1997
 ;External reference ^PS(50.7 - 2223
 ;External reference ^PS(50.606 - 2174
 ;External reference ^PSDRUG( - 221
 ;External reference to ^PS(55 - 2228
EN(DFN,RXNUM) ;dfn=patient's ifn, rxnum=internal order # for rx, pending or non-va med
 D:$P($G(^PS(55,DFN,0)),"^",6)'=2 EN^PSOHLUP(DFN) Q:RXNUM=""
 S $P(PSONULN,"-",79)="-"
 K INST,SD,IFN S FL=$P(RXNUM,";"),IFN=+FL G:RXNUM["P" PEN G:RXNUM["N" NVA
 Q:'$D(^PSRX(IFN,0))
 S RX0=^PSRX(IFN,0),RX2=^(2),RX3=^(3),STA=+$G(^("STA")),TRM=0,LSTFD=$P(RX2,"^",2),DNM=$P(^PSDRUG($P(RX0,"^",6),0),"^")
 W !,PSONULN S RXREC=IFN
 S DUPRX0=^PSRX(RXREC,0),RFLS=$P(DUPRX0,"^",9),ISSD=$P(^PSRX(RXREC,0),"^",13),RX0=DUPRX0,RX2=^PSRX(RXREC,2),$P(RX0,"^",15)=+$G(^PSRX(RXREC,"STA"))
 W !,$J("Rx #: ",24)_$P(RX0,"^"),?39,DNM
 W !,$J("Status: ",24) S J=RXREC D STAT^PSOFUNC W ST K RX0,RX2 W ?40,$J("Issued: ",24),$E(ISSD,4,5)_"/"_$E(ISSD,6,7)_"/"_$E(ISSD,2,3)
 K FSIG,BSIG I $P($G(^PSRX(RXREC,"SIG")),"^",2) D FSIG^PSOUTLA("R",RXREC,54) F PSREV=1:1 Q:'$D(FSIG(PSREV))  S BSIG(PSREV)=FSIG(PSREV)
 K FSIG,PSREV I '$P($G(^PSRX(RXREC,"SIG")),"^",2) D EN2^PSOUTLA1(RXREC,54)
 W !,$J("SIG: ",24) W $G(BSIG(1))
 I $O(BSIG(1)) F PSREV=1:0 S PSREV=$O(BSIG(PSREV)) Q:'PSREV  W !?24,$G(BSIG(PSREV))
 K BSIG,PSREV
 W !,$J("QTY: ",24)_$P(DUPRX0,"^",7),?40,$J("# of refills: ",24)_RFLS S PHYS=$S($D(^VA(200,+$P(DUPRX0,"^",4),0)):$P(^(0),"^"),1:"UNKNOWN")
 W !,$J("Provider: ",24)_PHYS,?40,$J("Refills remaining: ",24),RFLS-$S($D(^PSRX(RXREC,1,0)):$P(^(0),"^",4),1:0)
 S LSTFL=+^PSRX(RXREC,3) W !?40,$J("Last filled on: ",24)_$E(LSTFL,4,5)_"/"_$E(LSTFL,6,7)_"/"_$E(LSTFL,2,3),!?40,$J("Days Supply: ",24)_$P(DUPRX0,"^",8)
 W !,PSONULN,!
 K DNM,RX3,LSTFL,PSONULN,ISSD,J,LSTFD,PHYS,ST,STA,TRM,DUPRX0,FL,FSIG,I,IFN,RFLS,RXREC,X,Y Q
 ;
PEN Q:'$D(^PS(52.41,IFN,0))
 W !,PSONULN,! S RXREC=IFN
 S DUPRX0=^PS(52.41,RXREC,0),RFLS=$P(DUPRX0,"^",11),ISSD=$P(DUPRX0,"^",6)
 W !,"Pending Order: "_$P(DUPRX0,"^"),!,"Orderable Item: "_$P(^PS(50.7,$P(DUPRX0,"^",8),0),"^")_" "_$P(^PS(50.606,$P(^(0),"^",2),0),"^")
 W !,"Drug: "_$S($P(DUPRX0,"^",9):$P(^PSDRUG($P(DUPRX0,"^",9),0),"^"),1:"No Dispense Drug Selected")
 W !,"Provider Comments: " S TY=2 D INST
 D FSIG^PSOUTLA("P",RXREC,IOM-6)
 W !,"SIG: " F I=0:0 S I=$O(FSIG(I)) Q:'I  W FSIG(I),!?5
 W !,"Routing: "_$S($P(DUPRX0,"^",17)="W":"WINDOW",1:"MAIL"),?30,"Quantity: "_$P(DUPRX0,"^",10),!,"# of Refills: "_$P(DUPRX0,"^",11)
 W ?30,"Patient Status: SC",!,"Patient Location: "_$S($P(DUPRX0,"^",13):$P($G(^SC($P(DUPRX0,"^",13),0)),"^"),1:""),!,"Med Route: "_$P($G(^PS(51.2,+$P(DUPRX0,"^",15),0)),"^"),?30,"Provider: "_$P(^VA(200,$P(DUPRX0,"^",5),0),"^")
 S Y=$P(DUPRX0,"^",6) X ^DD("DD") W !,"Issue Date: "_Y
 W !,"Instructions: " S TY=3 D INST
 W !,PSONULN,!
 K DNM,RX3,LSTFL,PSONULN,ISSD,J,LSTFD,PHYS,ST,STA,TRM,DUPRX0,FL,FSIG,I,IFN,RFLS,RXREC,X,Y Q
 ;
INST ;displays instruction and/or comments
 S INST=0 F  S INST=$O(^PS(52.41,IFN,TY,INST)) Q:'INST  S MIG=^PS(52.41,IFN,TY,INST,0) D
 .F SG=1:1:$L(MIG," ") W:$X+$L($P(MIG," ",SG)_" ")>IOM @$S(TY=3:"!?14",1:"!?19") W $P(MIG," ",SG)_" "
 K INST,TY,MIG,SG
 Q
NVA ;displays non-va meds
 Q:'$G(^PS(55,DFN,"NVA",IFN,0))
 W !,PSONULN S DUPRX0=^PS(55,DFN,"NVA",IFN,0)
 W !,"Non-VA Med: "_$P(^PS(50.7,$P(DUPRX0,"^"),0),"^")_" "_$P(^PS(50.606,$P(^(0),"^",2),0),"^")
 W !,"Drug: "_$S($P(DUPRX0,"^",2):$P(^PSDRUG($P(DUPRX0,"^",2),0),"^"),1:"No Dispense Drug Selected")
 W !,"Status: "_$S($P(DUPRX0,"^",7):"Discontinued ("_$$FMTE^XLFDT($P($P(DUPRX0,"^",7),"."))_")",1:"Active")
 W !,"Dosage: "_$P(DUPRX0,"^",3)
 W !,"Schedule: "_$P(DUPRX0,"^",5),!,"Route: "_$P(DUPRX0,"^",4)
 W !,"Start Date: "_$$FMTE^XLFDT($P(DUPRX0,"^",9)),?40,"CPRS Oder #: "_$P(DUPRX0,"^",8)
 W !,"Documented By: "_$P(^VA(200,$P(DUPRX0,"^",11),0),"^")_" on "_$$FMTE^XLFDT($P(DUPRX0,"^",10))
 S RMLEN=$S($G(IOM):(IOM-5),1:70)
 F I=0:0 S I=$O(^PS(55,DFN,"NVA",IFN,"OCK",I)) Q:'I  D  I $O(^PS(55,DFN,"NVA",IFN,"OCK",I)) S DIR(0)="E",DIR("A")="   Press Enter to Continue" D ^DIR K DIR
 .S ORD=$P(^PS(55,DFN,"NVA",IFN,"OCK",I,0),"^"),ORP=$P(^(0),"^",2)
 .W !,"Order Check #"_I_": "
 .K OCK,LEN I $L(ORD)>RMLEN S (LEN,IEN)=1 D
 ..F SG=1:1:$L(ORD) S:$L($G(OCK(IEN))_" "_$P(ORD," ",SG))>RMLEN&($P(ORD," ",SG)]"") IEN=IEN+1 S:$P(ORD," ",SG)'="" OCK(IEN)=$G(OCK(IEN))_" "_$P(ORD," ",SG)
 ..F II=0:0 S II=$O(OCK(II)) Q:'II  W !?5,OCK(II)
 .W:'$G(LEN) ORD K LEN,SG,IEN,II,OCK,ORD
 .W !,"Overriding Provider: "_$S($G(ORP):$P(^VA(200,ORP,0),"^"),1:"")
 .K ORP,OCK,REA W !,"Reason:" F SS=0:0 S SS=$O(^PS(55,DFN,"NVA",IFN,"OCK",I,"OVR",SS)) Q:'SS  S REA(SS)=^PS(55,DFN,"NVA",IFN,"OCK",I,"OVR",SS,0)
 .S IEN=1 F II=0:0 S II=$O(REA(II)) Q:'II  D
 ..F SG=1:1:$L(REA(II)) S:$L($G(OCK(IEN))_" "_$P(REA(II)," ",SG))>RMLEN&($P(REA(II)," ",SG)]"") IEN=IEN+1 S:$P(REA(II)," ",SG)'="" OCK(IEN)=$G(OCK(IEN))_" "_$P(REA(II)," ",SG)
 ..K REA,IEN,SG F II=0:0 S II=$O(OCK(II)) Q:'II  W OCK(II) I $O(OCK(II)) W !?5
 K OCK W !,"Statement/Explanation/Comments:" F SS=0:0 S SS=$O(^PS(55,DFN,"NVA",IFN,"DSC",SS)) Q:'SS  S DSC(SS)=^PS(55,DFN,"NVA",IFN,"DSC",SS,0)
 S IEN=1 F II=0:0 S II=$O(DSC(II)) Q:'II  D
 .F SG=1:1:$L(DSC(II)) S:$L($G(OCK(IEN))_" "_$P(DSC(II)," ",SG))>RMLEN&($P(DSC(II)," ",SG)]"") IEN=IEN+1 S:$P(DSC(II)," ",SG)'="" OCK(IEN)=$G(OCK(IEN))_" "_$P(DSC(II)," ",SG)
 K IEN,DSC,SG F II=0:0 S II=$O(OCK(II)) Q:'II  W !?5,OCK(II)
 W !,PSONULN,!
        K RMLEN
