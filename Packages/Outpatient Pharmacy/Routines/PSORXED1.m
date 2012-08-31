PSORXED1        ;BHAM ISC/SAB - Edit prescription utility #2 ; 02/18/98  3:16 PM
        ;;7.0;OUTPATIENT PHARMACY;**2,16,21,289**;DEC 1997;Build 107
        ;show edits on last refill
        F ZDL=0:0 S ZDL=$O(^PSRX(DA,1,ZDL)) Q:'ZDL  S:$P($G(^PSRX(DA,1,ZDL,0)),"^") ZD(DA)=$P($G(^PSRX(DA,1,ZDL,0)),"^")
        G:'$O(^PSRX(DA,1,0))!($G(^PSRX(DA,1,RFED,0))']"") SUS S (PSRX1,RX1)=PSORXED("RX1"),QTY=$P(RX1,"^",4),QTY=QTY-$P(^PSRX(DA,1,RFED,0),"^",4)
        S COM1="" F I=1:1:6,9:1:11,17 I $P(PSRX1,"^",I)'=$P(^PSRX(DA,1,RFED,0),"^",I) D
        .S PSI=$S(I=1:.01,I=4:1,I=5:4,I=6:5,I=9:8,I=10:1.1,I=11:1.2,I=17:15,1:I),COM1=COM1_$P(^DD(52.1,PSI,0),"^")_" ("_$P(PSRX1,"^",I)_"),"
        ;
        N PSOTRIC,PSOECMES,PSOERFL S (PSOTRIC,PSOERFL,PSOECMES)="",PSOERFL=$$LSTRFL^PSOBPSU1(DA),PSOECMES=$$FIND^PSOREJUT(DA,PSOERFL)
        S PSOTRIC="",PSOTRIC=$$TRIC^PSOREJP1(DA,PSOERFL,.PSOTRIC)
        I COM1=""&('$G(PSOTRIC)) K COM1 G SUS
        I COM1=""&($G(PSOTRIC)) G:'PSOECMES SKPTRIC I PSOECMES K COM1 G SUS
        ;
        S K=1,D1=0 F Z=0:0 S Z=$O(^PSRX(DA,"A",Z)) Q:'Z  S D1=Z,K=K+1
        S D1=D1+1 S:'($D(^PSRX(DA,"A",0))#2) ^(0)="^52.3DA^^^" S ^(0)=$P(^(0),"^",1,2)_"^"_D1_"^"_K
        S ^PSRX(DA,"A",D1,0)=DT_"^E^"_DUZ_"^"_$S(RFED'<0&(RFED<6):RFED,1:(RFED+1))_"^"_COM1
SKPTRIC ;
        I QTY,$P(^PSRX(DA,1,RFED,0),"^",18) S ^PSDRUG($P(^PSRX(DA,0),"^",6),660.1)=$S($D(^PSDRUG(+$P(^PSRX(DA,0),"^",6),660.1)):^(660.1)+QTY,1:QTY)
        G:RFD'=RFED EX
        D FILL^PSORXED S PSOEDITL=$S($G(PSOEDITF)'=$G(RFED):1,$G(PSOEDITF)=$G(RFED)&('$G(PSOEDITR)):0,1:2)
        I $G(PSOTRIC)&(PSOECMES) S PSOEDITL=0 G SUS
        I $G(PSOEDITL)=2,'$G(RXRP(DA)),$P($G(^PSRX(DA,"STA")),"^")'=5,'$G(PSOSIGFL) D ASKL^PSORXED
        G:+$P(^PSRX(DA,"STA"),"^")!($G(PSOEDITL)=1&('$G(PSOTRIC))) SUS I $G(PSORX("PSOL",1))']"" S PSORX("PSOL",1)=PSORXED("IRXN")_"," S RXFL(DA)=RFED D SETRP^PSORXED G SUS
        F PSOX1=0:0 S PSOX1=$O(PSORX("PSOL",PSOX1)) Q:'PSOX1  S PSOX2=PSOX1
        I $L(PSORX("PSOL",PSOX2))+$L(PSORXED("IRXN"))<220 D  G ELSE
        .I PSORX("PSOL",PSOX2)'[PSORXED("IRXN")_"," S PSORX("PSOL",PSOX2)=PSORX("PSOL",PSOX2)_PSORXED("IRXN")_"," D SETRP^PSORXED
        E  I PSORX("PSOL",PSOX2)'[PSORXED("IRXN")_"," S PSORX("PSOL",PSOX2+1)=PSORXED("IRXN")_"," D SETRP^PSORXED
ELSE    S RXFL(DA)=RFED
        K COM1
SUS     ;update suspense file
        K PSOEDITF,PSOEDITR,PSOEDITL
        S RXS=$O(^PS(52.5,"B",DA,0)) I RXS,$G(^PS(52.5,RXS,"P"))=1 S ZD=$P(^PSRX(DA,3),"^") Q
        G:'RXS EX
        N PSOSITE I RFDT,$G(^PSRX(DA,1,RFED,0))]"",RFDT'=+$G(^PSRX(DA,1,RFED,0))!($P(PSORXED("RX1"),"^",9)'=$P(^(0),"^",9)) S SD=$P(^PSRX(DA,1,RFED,0),"^"),PSOSITE=$P(^(0),"^",9) D SUP Q
        I 'RFED,$P(PSORXED("RX2"),"^",2)'=$P(^PSRX(DA,2),"^",2)!($P(PSORXED("RX2"),"^",9)'=$P(^(2),"^",9)) S SD=$P(^PSRX(DA,2),"^",2),PSOSITE=$P(^(2),"^",9) D SUP
EX      K COM1,DIK,K,PSORXED("RX1"),RX1,RXS,SD,IR,FDA,RXN,RFDT,COPIES,J,PSPOP,COM,RX0,RX2,D1,IOP,%,%Y,D0,DA,D1
        K DIC,DIE,DIG,DQ,DR,DRUG,I,II,N,PHYS,PS,QTY,RFDATE,RFL,RFL1,RXF,SIG,ST,ST0,Z,Z0,Z1,X,Y,ZDL
        Q
SUP     I $P($G(^PS(52.5,RXS,0)),"^",7)="Q" D SUS^PSOCMOPB Q
        S RXN=DA,RX0=^PSRX(DA,0),DA=RXS,DIK="^PS(52.5," D ^DIK S DA=RXN
        S DIC="^PS(52.5,",DIC(0)="L",X=RXN,DLAYGO=52.5
        S DIC("DR")=".02///"_SD_";.03////"_$P(^PSRX(DA,0),"^",2)_";.04///M;.05///0;.06////"_PSOSITE_";2///0" K DD,DO D FILE^DICN I +$G(Y),$G(RFED)'="" S $P(^PS(52.5,+Y,0),"^",13)=$G(RFED)
        S IR=0,DA=RXN F FDA=0:0 S FDA=$O(^PSRX(DA,"A",FDA)) Q:'FDA  S IR=FDA
        S IR=IR+1,^PSRX(DA,"A",0)="^52.3DA^"_IR_"^"_IR
        D NOW^%DTC S ^PSRX(DA,"A",IR,0)=%_"^E^"_DUZ_"^"_$S(RFED'<0&(RFED<6):RFED,1:(RFED+1))_"^RX Placed on Suspense until "_$E(SD,4,5)_"-"_$E(SD,6,7)_"-"_$E(SD,2,3)
        W !,"RX# "_$P(RX0,"^")_" has been Suspended until "_$E(SD,4,5)_"-"_$E(SD,6,7)_"-"_$E(SD,2,3)_".",!
        Q
        ;
DIE     W !,"Now Editing Rx # ",$P(PSORXED("RX0"),"^") K DIE,DA,DIC,DR S DIE="^PSRX(",DA=PSORXED("IRXN")
        S DR="1;22R;3;Q;4;5"_$S($P(PSOPAR,"^",3):";6",1:"")_";6.5:8;Q;17;9:10;10.6;11;"_$S($P(PSOPAR,"^",12):"35;",1:"")_"12;20" S:RFD DR=DR_";52" S DR=DR_";23;24",DR(2,52.1)=".01:5;8;15"
        D ^DIE K DIE,DR,DA,X,Y L -^PSRX(PSORXED("IRXN")) I RFD,$G(^PSRX(PSORXED("IRXN"),1,RFD,0))]"" D
        .S:$P(PSORXED("RX1"),"^",17)'=$P(^PSRX(PSORXED("IRXN"),1,RFD,0),"^",17) PSONEW("PROVIDER NAME")=$P(^VA(200,$P(^PSRX(PSORXED("IRXN"),1,RFD,0),"^",17),0),"^")
        D EN1^PSONEW2(.PSORXED) I PSORXED("DFLG") S PSORXED("QFLG")=1 G DIEX
        G:'PSORXED("QFLG") DIE S PSORXED("QFLG")=0
DIEX    Q
