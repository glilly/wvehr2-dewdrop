PSOHLD  ;BIR/SAB - hold unhold functionality ;07/15/96
        ;;7.0;OUTPATIENT PHARMACY;**1,16,21,24,27,32,55,82,114,130,166,148,268,281**;DEC 1997;Build 41
        ;External reference to ^DD(52-DBIA 999,  VA(200-DBIA 224, NA^ORX1-DBIA 2186,
        ; L, UL, PSOL, and PSOUL^PSSLOCK-DBIA 2789, ^%DTC-DBIA 10000, ^DIE-DBIA 10018, ^DIR-DBIA 10026,
        ; ^DIK-DBIA 10013, ^VALM1-DBIA 10016, ^XUSEC(-DBIA 10076
UHLD    I '$D(PSOPAR) D ^PSOLSET G:'$D(PSOPAR) EX
        I $G(PSOBEDT) W $C(7),$C(7) S VALMSG="Invalid Action at this time !",VALMBCK="" Q
        I $G(PSONACT) W $C(7),$C(7) S VALMSG="No Pharmacy Orderable Item !",VALMBCK="" Q
        S PSOPLCK=$$L^PSSLOCK(PSODFN,0) I '$G(PSOPLCK) D LOCK^PSOORCPY S VALMSG=$S($P($G(PSOPLCK),"^",2)'="":$P($G(PSOPLCK),"^",2)_" is working on this patient.",1:"Another person is entering orders for this patient.") K PSOPLCK S VALMBCK="" Q
        ;W !! S DIC("A")="Unhold Prescription #: ",(DIE,DIC)="^PSRX(",DIC(0)="AEMQZ",DIC("S")="I $G(^PSRX(+Y,""H""))]"""",$P(^(""STA""),""^"")'=16" D ^DIC G:"^"[$E(X) EX G:Y<0 UHLD S (DA,PPL)=+Y,DFN=$P(Y(0),"^",2)
        K PSOPLCK D PSOL^PSSLOCK(DA) I '$G(PSOMSG) S VALMSG=$S($P($G(PSOMSG),"^",2)'="":$P($G(PSOMSG),"^",2),1:"Another person is editing this order."),VALMBCK="" K PSOMSG D ULP Q
        S Y(0)=^PSRX(DA,0),STA=+$G(^("STA"))
        I STA=16 S VALMSG="Placed on HOLD by Provider!" K Y,STA D PSOUL^PSSLOCK(DA) D ULP S VALMBCK="" Q
        I STA'=3!('$D(^XUSEC("PSORPH",DUZ))) S VALMSG="Invalid Action Selection!",VALMBCK="" K Y,STA D PSOUL^PSSLOCK(DA) D ULP Q
        D FULL^VALM1 K DIR,DTOUT,DUOUT,DIRUT D NOOR I $D(DIRUT) D ULP G EX
        I DT>$P(^PSRX(DA,2),"^",6) D  D ULP G EX
        .S VALMSG="Medication Expired on "_$E($P(^PSRX(DA,2),"^",6),4,5)_"-"_$E($P(^(2),"^",6),6,7)_"-"_$E($P(^(2),"^",6),2,3) I $P(^PSRX(DA,"STA"),"^")<11 S $P(^PSRX(DA,"STA"),"^")=11
        .S ^PSRX(DA,"H")="",COMM="Medication Expired on "_$E($P(^(2),"^",6),4,5)_"-"_$E($P(^(2),"^",6),6,7)_"-"_$E($P(^(2),"^",6),2,3) D EN^PSOHLSN1(DA,"SC","ZE",COMM,"") K COMM
EN      S RXF=0 F I=0:0 S I=$O(^PSRX(DA,1,I)) Q:'I  S RXF=I,RSDT=$P(^(0),"^")
        I RXF D  I $D(Y) D ULP G EX
        .S (PSDA,DA(1))=DA,DA=RXF,DIE="^PSRX("_DA(1)_",1,"
        .S RLDT=$P(^PSRX(DA(1),1,DA,0),"^",18)
        .S DR=$S('RLDT:".01R;2;",1:"")_"3COMMENTS"
        .S PSOUNHLD=1 D ^DIE K PSOUNHLD
        .S ZD(PSDA)=$P(^PSRX(DA(1),1,DA,0),"^")
        .Q:$D(Y)  S PSORX("FILL DATE")=$P(^PSRX(DA(1),1,DA,0),"^"),DA=PSDA K DA(1)
        ;
        S ACT=1,DIE="^PSRX(",FDT=$S($P(^PSRX(DA,2),"^",2):$P(^PSRX(DA,2),"^",2),1:DT)
        S RLDT=$P(^PSRX(DA,2),"^",13),DR="",RLDTP1=$P(RLDT,".",1)
        I 'RXF&'RLDT S DR="22//^S X=FDT;11;Q;"
        I RLDT&($P(^PSRX(DA,2),"^",2)="") S DR="22//^S X=RLDTP1;11;Q;"
        S DR=DR_"100///0;101///^S X=$S(RXF:$G(ZD(PSDA)),1:$P(^PSRX(PSDA,2),""^"",2))"
        ;
        D ^DIE K FDT I $D(Y) S VALMBCK="R" D ULP G EX
        S COMM="Medication Removed from Hold by Pharmacy" D EN^PSOHLSN1(DA,"OE","",COMM,PSONOOR) K COMM,PSONOOR
        S PSORX("FILL DATE")=$S('RXF:$P(^PSRX(DA,2),"^",2),1:ZD(PSDA)) K ^PSRX("AH",$P(^PSRX(DA,"H"),"^"),DA) S ^PSRX(DA,"H")="" D ACT^PSOHLDA S (NEW1,NEW11)="^^"
        S (RXF,RXFL(DA))=0 F JJ=0:0 S JJ=$O(^PSRX(DA,1,JJ)) Q:'JJ  S (RXFL(DA),RXF)=JJ
        I $G(PSXSYS) D UNHOLD^PSOCMOPA I $G(XFLAG) D ULP G EX
        I $G(DA) D RELC I $G(PSOHRL) D ULP G EX
        I PSORX("FILL DATE")>DT,$P(PSOPAR,"^",6) D S^PSORXL,EX,ULP Q
        S PCOMH(DA)="Medication Removed from Hold by Pharmacy"
        I $G(DA) S RXRH(DA)=DA
        I $P($G(^PSRX(DA,2)),"^",15)'="" S $P(^PSRX(DA,2),"^",14)=1,RXRP(DA)=1,$P(RXRP(DA),"^",2)=$P($G(^PSRX(DA,0)),"^",18) ; MARK PRESCRIPTION AND LABEL AS BEING REPRINTED WHEN UNHOLDING A RETURNED TO SOTCK PRESCRIPTION
        ;
        ; - Submitting Rx to ECME
        N ACTION
        I $$SUBMIT^PSOBPSUT(DA,+$G(RXFL(DA))) D  I ACTION="Q"!(ACTION="^") D ULP G EX
        . N RX,RFL S RX=DA,RFL=+$G(RXFL(DA))
        . N DA S ACTION=""
        . D ECMESND^PSOBPSU1(RX,RFL,,$S(RFL:"RF",1:"OF"))
        . I $$FIND^PSOREJUT(RX,RFL) D
        . . S ACTION=$$HDLG^PSOREJU1(RX,RFL,"79,88","ED","IOQ","Q")
        ;
        I $G(PSORX("PSOL",1))']"" S PSORX("PSOL",1)=DA_"," D ULP G EX
        F PSOX1=0:0 S PSOX1=$O(PSORX("PSOL",PSOX1)) Q:'PSOX1  S PSOX2=PSOX1
        I $L(PSORX("PSOL",PSOX2))+$L(DA)<220 S PSORX("PSOL",PSOX2)=PSORX("PSOL",PSOX2)_DA_","
        E  S PSORX("PSOL",PSOX2+1)=DA_","
        ; 
        D ULP
EX      D PSOUL^PSSLOCK($P(PSOLST(ORN),"^",2)) D ^PSOBUILD
        K PSOHRL,PSOMSG,PSOPLCK,ST,PSL,PSNP,IR,NOW,DR,NEW1,NEW11,RTN,DA,PPL,RXN,RX0,RXS,DIK,RXP,FLD,ACT,DIE,DIC,DIR,DIE,X,Y,DIRUT,DUOUT,SUSPT,C,D0,LFD,I,PSDA,RFDATE,DI,DQ,%,RFN,XFLAG
        K HRX,PSHLD,PSOLIST,PSORX("FILL DATE"),STA,QTY,RFDT,PSORX0,PSRXN,RXF,JJ Q
        ;
HLD     ;
        I $G(PSOBEDT) W $C(7),$C(7) S VALMSG="Invalid Action at this time !",VALMBCK="" Q
        I $G(PSONACT) W $C(7),$C(7) S VALMSG="No Pharmacy Orderable Item !",VALMBCK="" Q
        I '$D(^XUSEC("PSORPH",DUZ)) S VALMSG="Invalid Action Selection!",VALMBCK="" Q
        S PSOPLCK=$$L^PSSLOCK(PSODFN,0) I '$G(PSOPLCK) D LOCK^PSOORCPY S VALMSG=$S($P($G(PSOPLCK),"^",2)'="":$P($G(PSOPLCK),"^",2)_" is working on this patient.",1:"Another person is entering orders for this patient."),VALMBCK="" K PSOPLCK Q
        K PSOPLCK D PSOL^PSSLOCK(DA) I '$G(PSOMSG) S VALMSG=$S($P($G(PSOMSG),"^",2)'="":$P($G(PSOMSG),"^",2),1:"Another person is editing this order."),VALMBCK="" K PSOMSG D ULP Q
        S Y(0)=^PSRX(DA,0),STA=+$G(^("STA")) I DT>$P(^PSRX(DA,2),"^",6) D  D ULP G D1
        .S VALMSG="Medication Expired on "_$E($P(^PSRX(DA,2),"^",6),4,5)_"-"_$E($P(^(2),"^",6),6,7)_"-"_$E($P(^(2),"^",6),2,3),VALMBCK="R"
        .I $P(^PSRX(DA,"STA"),"^")<11 S $P(^PSRX(DA,"STA"),"^")=11 D
        ..S COMM="Medication Expired on "_$E($P(^PSRX(DA,2),"^",6),4,5)_"-"_$E($P(^(2),"^",6),6,7)_"-"_$E($P(^(2),"^",6),2,3) D EN^PSOHLSN1(DA,"SC","ZE",COMM) K COMM
        S ST=$P("ERROR^ACTIVE^NON-VERIFIED^REFILL^HOLD^NON-VERIFIED^SUSPENDED^^^^^DONE^EXPIRED^DISCONTINUED^DELETED^DISCONTINUED^DISCONTINUED (EDIT)^PROVIDER HOLD^","^",STA+2)
        I STA,STA'>4!(STA>11) D  D ULP G D1
        .S VALMSG="Rx: "_$P(Y(0),"^")_" is currently in a status of "_ST,VALMBCK="R" K ST,Y Q
        D FULL^VALM1 D NOOR I $D(DIRUT) D ULP G D1
        D HLD^PSOCMOPA I $G(XFLAG) K XFLAG D ULP G D1
        K DIR S DIR("A")=$P(^DD(52,99,0),"^"),DIR(0)="52,99" D ^DIR S FLD(99)=Y I $D(DUOUT)!($D(DIRUT)) K DIRUT,DUOUT,DIR D ULP G D1
        I $G(FLD(99))=99 K DIR S DIR("A")=$P(^DD(52,99.1,0),"^"),DIR(0)="52,99.1" D ^DIR S FLD(99.1)=Y G AR
        E  K DIR S DIR(0)="FO^10:100",DIR("A")="HOLD COMMENTS" D ^DIR S FLD(99.1)=Y
AR      I $D(DUOUT)!($D(DTOUT)) K DIRUT,DUOUT,DIR S VALMBCK="R" D ULP G D1
        F PI=1:1 Q:$P(PPL,",",PI)=""  S DA=$P(PPL,",",PI) D H S DA=PSDA K PSDA D:$D(PSORX("PSOL")) RMP^PSOHLDA
        K PI D ^PSOBUILD
        D ULP
D1      D PSOUL^PSSLOCK($P(PSOLST(ORN),"^",2)) K PSOMSG,PSOPLCK,RFN,DIR,RSDT,FLD,DA,ACT,X,Y,DIRUT,DUOUT,DTOUT,DIROUT
        Q
        ;
H       ; - Rx HOLD update
        D HOLD^PSOHLDA
        Q
        ;
FLD     N DA K DIR S DIR("A")=$P(^DD(52,99,0),"^"),DIR(0)="52,99" D ^DIR Q:$D(DUOUT)!($D(DIRUT))  S FLD(99)=Y
        S COMM=Y(0)
        I $G(FLD(99))=99 K DIR S DIR("A")=$P(^DD(52,99.1,0),"^"),DIR(0)="52,99.1" D ^DIR Q:$D(DUOUT)!($D(DIRUT))  S (FLD(99.1),COMM)=Y Q
        E  S FLD(99.1)=""
        Q
NOOR    ;ask nature of order
        K DIR,DTOUT,DTOUT,DIRUT I $T(NA^ORX1)]""  D  Q
        .S PSONOOR=$$NA^ORX1("W",0,"B","Nature of Order",0,"WPSDIVR"_$S(+$G(^VA(200,DUZ,"PS")):"E",1:""))
        .I +PSONOOR S PSONOOR=$P(PSONOOR,"^",3) Q
        .S DIRUT=1 K PSONOOR
        S DIR("A")="Nature of Order: ",DIR("B")="WRITTEN"
        S DIR(0)="SA^W:WRITTEN;V:VERBAL;P:TELEPHONE;S:SERVICE CORRECTED;D:DUPLICATE;I:POLICY;R:SERVICE REJECTED"_$S(+$G(^VA(200,DUZ,"PS")):";E:PROVIDER ENTERED",1:"")
NOORX   D ^DIR K DIR,DTOUT,DTOUT Q:$D(DIRUT)  S PSONOOR=Y
        Q
ULP     ;
        D UL^PSSLOCK(+$G(PSODFN))
        Q
RELC    ;
        S (PSOHRL,PSOHTX)=0  F PSOHT=0:0 S PSOHT=$O(^PSRX(DA,1,PSOHT)) Q:'PSOHT  S:$D(^PSRX(DA,1,PSOHT,0)) PSOHTX=PSOHT
        I $G(PSOHTX) S PSOHRL=$S($P($G(^PSRX(DA,1,PSOHTX,0)),"^",18):1,1:0)
        I '$G(PSOHTX) S PSOHRL=$S($P($G(^PSRX(DA,2)),"^",13):1,1:0)
        K PSOHTX,PSOHT
        Q
