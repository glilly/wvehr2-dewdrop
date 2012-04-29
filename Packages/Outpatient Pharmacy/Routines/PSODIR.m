PSODIR  ;BHAM ISC/SAB - asks data for rx order entry ; 9/17/07 5:03pm
        ;;7.0;OUTPATIENT PHARMACY;**37,46,111,117,146,164,211,264,275**;DEC 1997;Build 8
        ;External reference PSDRUG( supported by DBIA 221
        ;External reference PS(50.7 supported by DBIA 2223
        ;External reference to VA(200 is supported by DBIA 10060
        ;----------------------------------------------------------------
        ;
PROV(PSODIR)    ;
PROVEN  ; Entry point for failed lookup
        K DIC,X,Y S:$G(PSOFDR)&($G(OR0)) DIC("B")=$P(^VA(200,$P($G(OR0),"^",5),0),"^")
        I $G(PSODIR("PROVIDER"))]"" S PSODIR("OLD VAL")=PSODIR("PROVIDER")
        S DIC="^VA(200,",DIC(0)="QEAM",PSODIR("FIELD")=0
        S DIC("W")="W ""     "",$P(^(""PS""),""^"",9)"
        S DIC("A")="PROVIDER: ",DIC("S")="I $D(^(""PS"")),$P(^(""PS""),""^""),$S('$P(^(""PS""),""^"",4):1,1:$P(^(""PS""),""^"",4)'<DT)"
        I $G(PSOTPBFG),$G(PSOFROM)="NEW" S DIC("S")=DIC("S")_",$P($G(^(""TPB"")),""^""),$P($G(^(""TPB"")),""^"",5)=0"
        S:$G(PSORX("PROVIDER NAME"))]"" DIC("B")=PSORX("PROVIDER NAME")
        D ^DIC K DIC
        I X[U,$L(X)>1 D:'$G(PSOEDIT) JUMP G PROVX
        I $D(DTOUT)!$D(DUOUT) S PSODIR("DFLG")=1 G PROVX
        I '$G(SPEED),Y=-1 G PROVEN
        Q:$G(SPEED)&(Y=-1)
        ;PSO*7*211; ADD CHECK FOR DEA# AND VA#
        I $P($G(PSODIR("CS")),"^",1)!($D(CLOZPAT)) I '$L($P($G(^VA(200,+Y,"PS")),U,2)),'$L($P($G(^VA(200,+Y,"PS")),U,3)) D  G PROVEN
        .W $C(7),!!,"Provider must have a DEA# or VA#"_$S($D(CLOZPAT):" to write prescriptions for clozapine.",1:""),!
        I $D(CLOZPAT),'$D(^XUSEC("YSCL AUTHORIZED",+Y)) D  G PROVEN
        .W $C(7),!!,"Provider must hold YSCL AUTHORIZED key to write prescriptions for clozapine.",!
        I '$G(PSODRUG("IEN")),'$G(PSORENW("DRUG IEN")) G NODRUG
        ;I '$G(SPEED),$P($G(^PSDRUG($S($G(PSODRUG("IEN")):PSODRUG("IEN"),1:PSORENW("DRUG IEN")),"CLOZ1")),"^")="PSOCLO1",$P(^VA(200,+Y,"PS"),"^",2)'?2U7N D  K Y,PSORX("PROVIDER NAME"),DIC("B") G PROVEN
        ;.W $C(7),!!,"Only providers with DEA numbers can write prescriptions for clozapine.",!
NODRUG  S PSODIR("PROVIDER")=+Y
        S (PSODIR("PROVIDER NAME"),PSORX("PROVIDER NAME"))=$P(Y,"^",2)
        I $G(PSODIR("OLD VAL"))'=+Y K PSODIR("GENERIC PROVIDER"),PSODIR("COSIGNING PROVIDER")
        I $G(PSODIR("OLD VAL"))'=$G(PSODIR("PROVIDER")),$P(Y,"^",2)="PROVIDER,OTHER"!($P(Y,"^",2)="PROVIDER,OUTSIDE") D GENERIC
        I $P(^VA(200,PSODIR("PROVIDER"),"PS"),"^",7),$P(^("PS"),"^",8) D COSIGN
        I $G(PSODIR("COSIGNING PROVIDER")),'$P(^VA(200,PSODIR("PROVIDER"),"PS"),"^",7) K PSODIR("COSIGNING PROVIDER")
PROVX   K X,Y
        Q
        ;
GENERIC ;
        K DIR,DIC,PSODIR("GENERIC PROVIDER")
        S DIR(0)="52,30"
        D DIR G:PSODIR("DFLG")!PSODIR("FIELD") GENERICX
        S PSODIR("GENERIC PROVIDER")=Y
GENERICX        K X,Y
        Q
        ;
COSIGN  ;
        K DIC
        I '$G(PSODIR("COSIGNING PROVIDER")),$P($G(RX3),"^",3) S PSODIR("COSIGNING PROVIDER")=$P(RX3,"^",3) G COSIGN1
        I $P($G(RX3),"^",3),$P($G(RX3),"^",3)'=$P(^VA(200,PSODIR("PROVIDER"),"PS"),"^",8) D
        .W !!,"Previous Co-Signing Provider: "_$P(^VA(200,$P(RX3,"^",3),0),"^")
        .S PSODIR("COSIGNING PROVIDER")=$S($P(RX3,"^",3)'=PSODIR("COSIGNING PROVIDER"):PSODIR("COSIGNING PROVIDER"),1:$P(^VA(200,PSODIR("PROVIDER"),"PS"),"^",8))
COSIGN1 S DIC(0)="QEAM",DIC="^VA(200,",DIC("B")=$S($G(PSODIR("COSIGNING PROVIDER")):$P(^VA(200,PSODIR("COSIGNING PROVIDER"),0),"^"),1:$P(^VA(200,PSODIR("PROVIDER"),"PS"),"^",8))
        S DIC("S")="I $D(^(""PS"")),$P(^(""PS""),""^""),$S('$P(^(""PS""),""^"",4):1,1:$P(^(""PS""),""^"",4)'<DT)"
        S DIC("W")="W ""     "",$P(^(""PS""),""^"",9)",DIC("S")=DIC("S")_",'$P(^(""PS""),""^"",7)"
        S DIC("A")="COSIGNING PROVIDER: " D ^DIC K DIC
        I $D(DTOUT)!$D(DUOUT) S PSODIR("DFLG")=1 G COSIGNX
        S:+Y>0 PSODIR("COSIGNING PROVIDER")=+Y G:Y<0 COSIGN
COSIGNX K X,Y
        Q
DOSE(PSODIR)    ;add dosing info
        D DOSE1^PSOORED5(.PSODIR)
EX      K PSODOSE,PSOSCH,DOSE,DOOR,SCH,VERB,NOUN,DOSEOR,ENT,PSORTE,DRUA,DIR,X,Y,DIRUT,RTE,ERTE,DD,INS1,SINS1
        Q
INS(PSODIR)     ;patient instructions
        N DA K INS1,DD,DIR,DIRUT S D=0 F  S D=$O(PSODIR("SIG",D)) Q:'D  S DD=$G(DD)+1
        I $G(DD)=1 S PSODIR("INS")=$G(PSODIR("SIG",1)) G INSD
        ;PSO*7*275 remove check for PSOINSFL just check for multi line sig
        I $G(DD)>1 D  G EX
        .K ^TMP($J) S D=0 F  S D=$O(PSODIR("SIG",D)) Q:'D  S ^TMP($J,"SIG",D,0)=PSODIR("SIG",D)
        .S DWPK=2,DWLW=80,DIC="^TMP($J,""SIG""," D EN^DIWE K PSODIR("SIG")
        .S D=0 F  S D=$O(^TMP($J,"SIG",D)) Q:'D  S PSODIR("SIG",D)=^TMP($J,"SIG",D,0)
        .D EN^PSOFSIG(.PSODIR,1) K DWLW,D,DWPK,^TMP($J)
        I $G(PSOINSFL)=0 G INSD
        I $G(PSOFDR),$G(ORD),$P($G(^PS(52.41,+$G(ORD),"EXT")),"^")'="" G INSD
        I $G(PSODIR("INS"))']"",$G(^PS(50.7,PSODRUG("OI"),"INS"))]"" S DIR("B")=^PS(50.7,PSODRUG("OI"),"INS")
INSD    S DIR(0)="52,114" S:$G(PSODIR("INS"))]"" DIR("B")=PSODIR("INS")
        D DIR G:$G(PSODIR("DFLG"))!(PSODIR("FIELD")) EX
        I X'="",X'="@" S PSODIR("INS")=Y D SIG^PSOHELP G INSD:'$D(X)
        I $G(INS1)]"" D EN^DDIOL($E(INS1,2,9999999)) S (PSODIR("SIG",1),PSODIR("SIG"))=$E(INS1,2,9999999)
        I X="@" K PSODIR("INS"),PSODIR("SIG")
        D EN^PSOFSIG(.PSODIR,1) I $O(SIG(0)) S SIGOK=1
        G EX
        Q
SINS(PSODIR)    ;other lang. patient instructions
        K SINS1,DIR
        S DIR(0)="52,114.1" S:$G(PSODIR("SINS"))]"" DIR("B")=PSODIR("SINS")
        I $G(PSODIR("SINS"))']"",$G(^PS(50.7,PSODRUG("OI"),"INS1"))]"" S DIR("B")=^PS(50.7,PSODRUG("OI"),"INS1")
        D DIR G:$G(PSODIR("DFLG")) EX
        I X'="",X'="@" S PSODIR("SINS")=Y D SSIG^PSOHELP
        I $G(SINS1)]"" D EN^DDIOL($E(SINS1,2,9999999)) S PSODIR("SINS")=$E(SINS1,2,9999999)
        I X="@" K PSODIR("SINS")
        G EX
        Q
        ;
DIR     ;
        S PSODIR("FIELD")=0
        G:$G(DIR(0))']"" DIRX
        D ^DIR K DIR,DIE,DIC,DA
        I $D(DUOUT)!($D(DTOUT))!($D(DIROUT)),$L($G(X))'>1 S PSODIR("DFLG")=1 G DIRX
        I X[U,$L(X)>1 D:'$G(PSOEDIT) JUMP
DIRX    K DIRUT,DTOUT,DUOUT,DIROUT,PSOX
        Q
        ;
JUMP    ;
        I $G(PSOEDIT)!($G(OR0)) S PSODIR("DFLG")=1 Q
        S X=$P(X,"^",2),DIC="^DD(52,",DIC(0)="QM" D ^DIC K DIC
        I Y=-1 S PSODIR("FIELD")=$G(PSODIR("FLD")) G JUMPX
        I $G(PSONEW1)=0 D JUMP^PSONEW1 G JUMPX
        I $G(PSOREF1)=0 D JUMP^PSOREF1 G JUMPX
        I $G(PSONEW3)=0 D JUMP^PSONEW3 G JUMPX
        I $G(PSORENW3)=0 D JUMP^PSORENW3 G JUMPX
JUMPX   S X="^"_X
        Q
