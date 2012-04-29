PSDACT1 ;BIR/JPW,BJW-Print Daily Activity Log (cont'd) ; 17 Jun 98
        ;;3.0; CONTROLLED SUBSTANCES ;**10,14,30,65**;13 Feb 97;Build 5
        ;Reference to ^PRC(442 supported by IA #682
        ;Reference to ^PRCS(410 supported by IA #198
        ;Reference to ^PSDRUG( supported by IA #221
        ;Reference to ^PSRX( supported by IA #986
        ;Reference to ^DD(58.81 supported by IA #10154
        ;Reference to PSD(58.8 supported by DBIA # 2711
        ;Reference to PSD(58.81 supported by DBIA # 2808
        ;References to PSD(58.84 supported by IA # 3485
        ;modified for nois:tua-0498-32173,new code added to t6
        ;op v.7 chg the status loc in file 52
START   ;entry for compile
        K ^TMP("PSDACT",$J)
        I $D(ALL) F PSDR=0:0 S PSDR=$O(^PSD(58.8,+PSDS,1,PSDR)) Q:'PSDR  I $D(^PSD(58.8,+PSDS,1,PSDR,0)) S PSDRG(+PSDR)=""
        F PSD=PSDSD:0 S PSD=$O(^PSD(58.81,"ACT",PSD)) Q:'PSD!(PSD>PSDED)  F PSDR=0:0 S PSDR=$O(^PSD(58.81,"ACT",PSD,PSDS,PSDR)) Q:'PSDR  D
        .Q:'$D(PSDRG(PSDR))
        .F TYP=0:0 S TYP=$O(^PSD(58.81,"ACT",PSD,PSDS,PSDR,TYP)) Q:'TYP!(TYP=12)  F PSDA=0:0 S PSDA=$O(^PSD(58.81,"ACT",PSD,PSDS,PSDR,TYP,PSDA)) Q:'PSDA  D SET
        G:$D(ZTQUEUED) PRTQUE G PRINT^PSDACT2
END     ;
        D KVAR^VADPT
        K %,%DT,%H,%I,%ZIS,ACT,ALL,BFWD,C,DA,DATE,DIC,DIR,DIROUT,DIRUT,DTOUT,DUOUT,LN,MFG,NAOU,NODE,NQTY,NUM
        K PAT,PG,PHARM,POP,PSD,PSDA,PSDATE,PSDED,PSDEV,PSDIO,PSDOUT,PSDPN,PSDR,PSDRG,PSDRGN,PSDS,PSDSD,PSDSN,PSDUZ,PSDUZN,RX,TEXT,TYP,QTY,TYPE,X,Y,VA("BID"),VA("PID")
        K ^TMP("PSDACT",$J),ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
        D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
        Q
SET     ;sets data
        ;Dave B (PSD*3*14) Disregard if type is 15.
        Q:'$D(^PSD(58.81,PSDA,0))  Q:TYP=5  Q:TYP=15  S NODE=^(0),QTY=$P(NODE,"^",6),BFWD=$P(NODE,"^",10)
        S PSDRGN=$S($P($G(^PSDRUG(PSDR,0)),"^")]"":$P(^(0),"^"),1:"ZZ/"_PSDR_" NAME MISSING")
        S PSDUZ=$S(TYP=3:+$P($G(^PSD(58.81,PSDA,1)),"^",14),TYP=4:+$P($G(^PSD(58.81,PSDA,1)),"^",14),TYP=13:+$P($G(^PSD(58.81,PSDA,5)),"^",2),TYP=14:+$P($G(^PSD(58.81,PSDA,4)),"^",2),1:+$P(NODE,"^",7))
        S:TYP=2 PSDUZ=$S(+$P($G(^PSD(58.81,PSDA,1)),"^"):+$P($G(^(1)),"^"),1:+$P(NODE,"^",7))
        S PSDUZN=$P($G(^VA(200,+PSDUZ,0)),"^"),PSDUZN=$S(PSDUZN]"":$E($P(PSDUZN,",",2))_$E(PSDUZN),1:"**")
        I TYP=1 D T1 G TMP
        I TYP=2 D T2 G TMP
        I TYP=3 Q:'$D(^PSD(58.81,PSDA,3))  D T3 G TMP
        Q:TYP=4
        I TYP=6 Q:'$D(^PSD(58.81,PSDA,6))  D T6 G TMP
        I TYP=7 D T7 G TMP
        I TYP=9 D T9 G TMP
        I TYP=11 D T11 G TMP
        I TYP=13 Q:'$D(^PSD(58.81,PSDA,5))  D T13 G TMP
        I TYP=14 Q:'$D(^PSD(58.81,PSDA,4))  D T14 G TMP
        I TYP=16 D T16 G TMP
        I TYP>18 D TOTH
TMP     ;
        S PSDUZN=$P($G(^VA(200,+PSDUZ,0)),"^"),PSDUZN=$S(PSDUZN]"":$E($P(PSDUZN,",",2))_$E(PSDUZN),1:"**")
        ;PSD*3*30 (Dave B - Identify person with more than just **)
        I $G(PSDUZN)="**" S PSDUZ=$P($G(^PSD(58.81,PSDA,0)),"^",7),PSDUZN=$P($G(^VA(200,+PSDUZ,0)),"^"),PSDUZN=$S(PSDUZN]"":$E($P(PSDUZN,",",2))_$E(PSDUZN),1:"**")
        S ^TMP("PSDACT",$J,PSDRGN,PSD,TYP,PSDA)=BFWD_"^"_NUM_"^"_TEXT_"^"_QTY_"^"_PSDUZN I $D(PSDRTS) S ^TMP("PSDACT",$J,PSDRGN,PSD,TYP,PSDA)=^TMP("PSDACT",$J,PSDRGN,PSD,TYP,PSDA)_"^1"
        K PSDRTS Q
T1      S NUM="***",TEXT="RECEIPT INTO PHARMACY"
        I $P($G(^PSD(58.81,PSDA,8)),"^")]"" S NUM=$P($G(^PSD(58.81,PSDA,8)),"^") Q
        I +$P(NODE,"^",9) S NUM=+$P(NODE,"^",9),NUM=$P($G(^PRC(442,NUM,0)),"^") Q
        I +$P(NODE,"^",8) S NUM=+$P(NODE,"^",8),NUM=$P($G(^PRCS(410,NUM,0)),"^") Q
        Q
T2      S QTY=-QTY,NUM="DISP",NAOU=+$P(NODE,"^",18) S:NAOU NAOU=$P($G(^PSD(58.8,+NAOU,0)),"^") S TEXT=$S(NAOU]"":NAOU,1:"DISPENSED FROM PHARMACY")
        I +$P(NODE,"^",17) S NUM="GS # "_$P(NODE,"^",17)
        Q
T3      S NUM="GS # ",TEXT="RETURNED TO STOCK"
        I +$P(NODE,"^",17) S NUM=NUM_$P(NODE,"^",17)
        ;PSD*3*30 (Dave B - more precise infor on RTS)
        I $G(NUM)="GS # " D
        .S RX=$P($G(^PSD(58.81,PSDA,6)),"^"),RXNUM=$P($G(^PSD(58.81,PSDA,6)),"^",5)
        .S PAT=$P($G(^PSRX(RX,0)),"^",2) I PAT S DFN=PAT D PID^VADPT6 S Y=PAT,C=$P(^DD(58.81,73,0),"^",2) D Y^DIQ S TEXT=Y_"("_VA("BID")_")" K DFN,VA("BID"),VA("PID")
        .S NUM="RX # "_$G(RXNUM)_" ("_$S($P($G(^PSD(58.81,PSDA,6)),U,2):"R"_$P($G(^(6)),U,2),$P($G(^(6)),U,4):"P"_$P($G(^(6)),U,4),1:"O")_")"
        .S QTY=$P(^PSD(58.81,PSDA,3),"^",2),BFWD=$P(^PSD(58.81,PSDA,0),"^",10),PSDRTS=1 Q
        I $G(PSDRTS)=1 Q
        S QTY=$P(^PSD(58.81,PSDA,3),"^",2),BFWD=$P(^(3),"^",7)
        Q
T6      S QTY=-QTY,NUM="RX # ",TEXT="OUTPATIENT RX" N RXNUM
        S RX=+$P(^PSD(58.81,PSDA,6),"^"),RXNUM=$S($P(^(6),"^",5)]"":$P(^(6),"^",5),$P($G(^PSRX(RX,0)),"^")]"":$P(^(0),"^"),1:"UNKNOWN"),NUM=NUM_RXNUM
        S NUM=NUM_" ("_$S($P($G(^PSD(58.81,PSDA,6)),U,2):"R"_$P($G(^(6)),U,2),$P($G(^(6)),U,4):"P"_$P($G(^(6)),U,4),1:"O")_")"
        S PAT=+$P($G(^PSRX(RX,0)),"^",2)
        S PSDRXIN=RX D VER^PSDOPT
        ;W !,TEXT,"  ",RXNUM
        S TEXT=$S('$O(^PSRX("B",RXNUM,0)):"RX DELETED",$G(PSDSTA)=13:"RX DELETED",1:"UNKNOWN")
        ;W !,TEXT
        K PSDSTA,PSOVR,PSDRXIN
        I PAT S DFN=PAT D PID^VADPT6 D
        .K C S Y=PAT,C=$P(^DD(58.81,73,0),"^",2) D Y^DIQ S TEXT=Y_" ("_VA("BID")_")" K DFN,VA("BID"),VA("PID")
        Q
T7      S NUM="GS # ",TEXT="CANCEL UNVERIFIED ORDER",QTY=0
        I +$P(NODE,"^",17) S NUM=NUM_$P(NODE,"^",17)
        Q
T9      S NUM="ADJ",TEXT=$S($D(^PSD(58.81,+PSDA,9)):$P(NODE,"^",16),1:"ADJUSTMENT")
        I $P(NODE,"^",16)]"" S TEXT=$P(NODE,"^",16)
        I $D(^PSD(58.81,PSDA,3)) S NUM="DEST # "_$P(^(3),"^",8),TEXT="HOLDING FOR DESTRUCTION"
        Q
T11     S NUM="***",TEXT="INITIALIZE BALANCE AT SETUP"
        Q
T13     S NUM="GS # ",TEXT="CANCEL VERIFIED ORDER"
        I +$P(NODE,"^",17) S NUM=NUM_$P(NODE,"^",17)
        S QTY=$P(^PSD(58.81,PSDA,5),"^",3),BFWD=$P(^(5),"^",5)
        Q
T14     S NUM="GS # ",TEXT="EDIT VERIFIED ORDER"
        I +$P(NODE,"^",17) S NUM=NUM_$P(NODE,"^",17)
        S:$D(^PSD(58.81,PSDA,8)) TEXT="EDIT VERIFIED INVOICE",NUM=$P(^PSD(58.81,PSDA,8),"^",1) ; <*65-RJS>
        S QTY=$P(^PSD(58.81,PSDA,4),"^",4),BFWD=$P(^(4),"^",7)
        Q
T16     S NUM="TRV",TEXT="TRANSFER TO VAULT"
        Q
TOTH    ;Type = 19,20,21,22
        S NUM="INV",TEXT=$G(^PSD(58.84,+TYP,0)),QTY=""
        Q
PRTQUE  ;queues print after compile
        K ZTSAVE,ZTIO S ZTIO=PSDIO,ZTRTN="PRINT^PSDACT2",ZTDESC="CS PHARM Print Daily Activity Log",ZTDTH=$H,ZTSAVE("^TMP(""PSDACT"",$J,")="",ZTSAVE("PSDSN")="",ZTSAVE("PSDATE")=""
        D ^%ZTLOAD K ZTSK G END
