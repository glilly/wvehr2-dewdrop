PSOOREDT        ;BIR/SAB - edit orders from backdoor ;11:18 AM  2 Aug 2011
        ;;7.0;OUTPATIENT PHARMACY;**4,20,27,37,57,46,78,102,104,119,143,148,260,281,304,289,208;**;Build 60;Build 107;WorldVistA 30-Jan-08
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        ;External reference to ^PSDRUG supported by DBIA 221
        ;External reference to PSSLOCK supported by DBIA 2789
        ;External reference to ^VA(200 supported by DBIA 10060
SEL     K PSOISLKD,PSOLOKED S PSOPLCK=$$L^PSSLOCK(PSODFN,0) I '$G(PSOPLCK) D LOCK^PSOORCPY D SVAL K PSOPLCK S VALMBCK="" Q
        K PSOPLCK D PSOL^PSSLOCK($P(PSOLST(ORN),"^",2)) I '$G(PSOMSG) D UL^PSSLOCK(+$G(PSODFN)) D SVALO K PSOMSG S VALMBCK="" Q
        K PSOMSG S PSOLOKED=1
        K PSORX("DFLG"),DIR,DUOUT,DIRUT S DIR("A")="Select fields by number"
        S DIR(0)="LO^1:"_$S($$STATUS^PSOBPSUT($P(PSOLST(ORN),"^",2))'="":21,$G(REF):20,1:19)
        D ^DIR I $D(DIRUT) K DIR,DIRUT,DTOUT S VALMBCK="" D UL K PSOLOKED Q
EDTSEL  N VALMCNT K PSOISLKD,PSORX("DFLG"),PSOOIFLG,PSOMRFLG,DIR,DIRUT,DTOUT,DTOUT,ZONE S (PSOEDIT,PSORXED)=1 I +Y S FST=Y D HLDHDR^PSOLMUTL D  G EX ;PSO LM SELECT MENU protocol
        .I '$G(PSOLOKED) S PSOPLCK=$$L^PSSLOCK(PSODFN,0) I '$G(PSOPLCK) D LOCK^PSOORCPY D SVAL K PSOPLCK S VALMBCK="",(PSOISLKD,PSODE)=1 Q
        .I '$G(PSOLOKED) K PSOPLCK D PSOL^PSSLOCK($P(PSOLST(ORN),"^",2)) I '$G(PSOMSG) D UL^PSSLOCK(+$G(PSODFN)) D SVALO K PSOMSG S VALMBCK="",(PSOISLKD,PSODE)=1 Q
        .K PSOMSG,PSOPLCK S (NEWEDT,PSOLOKED)=1 D EDT
        E  S VALMBCK="",PSODE=1
EX      I $G(PSOISLKD) D UL K PSOISLKD G EX2
        I '$G(PSOSIGFL),'$G(PSORXED("DFLG")) D UPDATE^PSOORED6 D LOG^PSORXED,POST^PSORXED G EX1
        I $G(PSOSIGFL)=1 D  Q:$G(PSORX("FN"))
        .N PSOTMP
        .S PSOTMP=$G(PSOFROM),PSOFROM="NEW"
        .S VALMSG="This change will create a new prescription!",NCPDPFLG=1
        .D EN^PSOORED1(.PSORXED)
        .I $G(PSORX("FN")) D  Q
        ..D ^PSOBUILD
        ..K QUIT,PSORX("DFLG"),FST,FLD,IEN,FLN,INCOM,PSOI,PSODRUG,PSOEDIT
        ..K PSORENW,PSOSIGFL,PSOOIFLG,PSOMRFLG,PSODIR,CHK,PSORX("SIG"),PSODE
        ..K PSOTRN,PSORX("EDIT"),PSORXED("FLD"),NEWEDT
        ..D EOJ^PSONEW
        ..D UL K PSOLOKED S VALMBCK="Q"
        .S PSOFROM=PSOTMP I PSOFROM="" K PSOFROM
        ;
EX1     I '$G(PSODE)!('$G(ZONE)) I $G(PSORENW("OIRXN")) D EN^PSOHLSN1(PSORENW("OIRXN"),"XX","","Order edited")
QUIT    D UL K PSOLOKED D ^PSOBUILD,ACT^PSOORNE2 D:+^PSRX($P(PSOLST(ORN),"^",2),"STA")=5 EN^PSOCMOPC($P(PSOLST(ORN),"^",2))
        K:'$O(^PSRX($P(PSOLST(ORN),"^",2),1,0)) REF
EX2     S VALMBCK=$S($G(PSORX("FN")):"Q",$G(ZONE):"Q",1:"R") K PSORXED,FST,FLD,IEN,FLN,INCOM,PSOI,PSODRUG,PSOEDIT,PSORENW,PSOSIGFL,PSODIR,CHK,PSORX("SIG"),PSODE,PSOTRN,PSORX("DFLG"),RFED,ZONE,PSORX("EDIT"),PSOOIFLG,PSOMRFLG,SIG,QUIT
        K NEWEDT I $G(VALMBCK)="R" W ! D CLEAN^PSOVER1 H 2
        Q
        ;
EDT     ; Rx Edit (Backdoor)
        K NCPDPFLG
        I '$D(PSODRUG) NEW PSOY S PSOY=$P(RX0,U,6),PSOY(0)=^PSDRUG(PSOY,0) D SET^PSODRG
        S I=0 F  S I=$O(^PSRX($P(PSOLST(ORN),"^",2),1,I)) Q:'I  S PSORXED("RX1")=^PSRX($P(PSOLST(ORN),"^",2),1,I,0)
        S (RX0,PSORXED("RX0"))=^PSRX($P(PSOLST(ORN),"^",2),0),PSORXED("RX2")=$G(^(2)),PSORXED("RX3")=$G(^(3)),PSOSIG=$P(^("SIG"),"^")
        F FLD=1:1:$L(FST,",") Q:$P(FST,",",FLD)']""!($G(PSORXED("DFLG")))!($G(PSORX("DFLG")))  S FLN=+$P(FST,",",FLD) D
        .S PSORXED("DFLG")=0,(DA,PSORXED("IRXN"),PSORENW("OIRXN"))=$P(PSOLST(ORN),"^",2),RX0=^PSRX(PSORXED("IRXN"),0) S:$G(PSOSIG)="" PSOSIG=$P(^("SIG"),"^")
        .I '$G(PSOSIGFL) D
        ..S PSOI=+^PSRX(DA,"OR1"),PSODAYS=$P(RX0,"^",8),PSORXST=+$P($G(^PS(53,$P(RX0,"^",3),0)),"^",7)
        ..I 'PSOI S PSOI=+^PSDRUG($P(RX0,"^",6),2),$P(^PSRX(DA,"OR1"),"^")=PSOI
        ..S:'$G(PSODRUG("IEN")) PSODRUG("IEN")=$P(RX0,"^",6),PSODRUG("NAME")=$P(^PSDRUG($P(RX0,"^",6),0),"^")
        ..S PSODRUG("OI")=PSOI
        .S PSORX("PROVIDER")=$P(RX0,"^",4),PSORX("PROVIDER NAME")=$P(^VA(200,$P(RX0,"^",4),0),"^"),PSOTRN=$G(^PSRX(DA,"TN"))
        .D:'$G(CHK) POP^PSOSIGNO(DA),CHK Q:$G(PSORXED("DFLG"))
        .S FDR="39.2^"_$S($P(PSOPAR,"^",3):"6",1:"")_";6.5^113^114^3^1^22R^24^8^7^9^4^11;"_$S($P(RX0,"^",11)="W"&($P(PSOPAR,"^",12)):"35;",1:"")_"^10.6^5^20^23^12^PSOCOU^RF^81"
        .I $G(ST)=11!($G(ST)=12)!($G(ST)=14)!($G(ST)=15) D NDCDAWDE^PSOORED7(ST,FLN,$G(RXN)) Q
        .I FLN=20,'$G(REF) S VALMSG="There is no Refill Data to be edited." Q
        .S DR=$P(FDR,"^",FLN) I DR="RF" D REF^PSOORED2 Q
        .I DR="PSOCOU" D PSOCOU^PSOORED6 Q
        .I FLN=2,'$P(PSOPAR,"^",3),$$RXRLDT^PSOBPSUT(RXN,0),$$STATUS^PSOBPSUT(RXN,0)'="" D  Q
        ..N NDC D NDC^PSODRG(RXN,0,,.NDC) I $G(NDC)="^"!($G(NDC)="") Q
        ..S (PSODRUG("NDC"),PSORXED("FLD",27))=NDC
        .I FLN'>2,'$P(PSOPAR,"^",3) S VALMSG="Check site parameters, Drug data is not editable." Q
        .I FLN=3 D EDTDOSE^PSOORED2,FULL^VALM1,POST^PSODRG S:$G(PSORX("DFLG")) PSOISLKD=1,PSORX("FN")=1 Q
        .I FLN=4 D INS^PSOORED1 Q
        .I FLN=1 D PSOI^PSOORED6 N PSOX S PSORXED=1,PSOX("IRXN")=$S($D(DA):DA,$D(PSORXED("IRXN")):PSORXED("IRXN"),$D(PSORENW("OIRXN")):PSORENW("OIRXN")) D:'$G(PSORXED("DFLG")) EN^PSODIAG Q
        .I FLN=2 D DRG^PSOORED6 N PSOX S PSORXED=1,PSOX("IRXN")=PSORXED("IRXN") D:'$G(PSORXED("DFLG")) EN^PSODIAG S:$O(^PSRX(PSORXED("IRXN"),1,0)) REF=1 Q
        .I FLN=12 D PROV Q
        .I FLN=6 D ISDT^PSOORED2 Q
        .I FLN=7 D FLDT^PSOORED2 Q
        .I FLN=21,$$STATUS^PSOBPSUT(RXN,0)="" S VALMSG="Invalid selection!" Q
        .I FLN=21 D  Q
        ..N DAW D EDTDAW^PSODAWUT(RXN,0,.DAW) I $G(DAW)="^" Q
        ..S (PSODRUG("DAW"),PSORXED("FLD",81))=DAW
        .I FLN=9!(FLN=10)!(FLN=11) D NOCHG^PSOORED7 Q
        .S DR=+DR
        .K DIR,DIRUT,DIROUT ;S DIE=52 D ^DIE I $D(Y) S PSORXED("DFLG")=1
        .K DIC,DIQ S DIC=52,DA=PSORXED("IRXN"),DIQ="PSORXED" D EN^DIQ1 K DIC,DIQ
        .S DIR("B")=$S($G(PSORXED("FLD",DR))]"":PSORXED("FLD",DR),1:PSORXED(52,DA,DR)),DIR(0)="52,"_DR D ^DIR
        .I DR=24!(DR=12) S PSORXED("FLD",DR)=X
        .I $D(DIRUT) K DIR,DIRUT,DUOUT,DTOUT,PSORXED(52,DA,DR),PSORXED("FLD",DR) Q
        .I DR'=5,X="@" W !,"Data Required!",! K DIC,DIQ,DR,DA,DIR,DIRUT,PSORXED(52,DA,DR),X,Y Q
        .I DR=5,X'="@" S Y=+Y
        .I DR=3!(DR=20)!(DR=23) S Y=+Y
        .S PSORXED("FLD",DR)=$S(X="@":X,1:Y) K DIR,DIRUT,DIROUT,X,Y,PSORXED(52,DA,DR)
        .I DR=11,PSORXED("FLD",DR)="W",$P(PSOPAR,"^",12) D
        ..D FIELD^DID(52,DR,"","LABEL","ZZ") S PSORXED(ZZ("LABEL"))=PSORXED("FLD",DR) K ZZ
        ..S DR=35,DIQ="PSORXED" D EN^DIQ1 K DIC,DIQ,DIRUT,DUOUT,DTOUT
        ..S:$G(PSORXED(52,DA,DR))]"" DIR("B")=PSORXED(52,DA,DR)
        ..S DIR(0)="52,"_(DR) D ^DIR I $D(DIRUT),X'="@" K DIR,DIRUT Q
        ..S PSORXED("FLD",DR)=X K DIR,DIRUT,DIROUT,X,Y,PSORXED(52,DA,DR)
        .I $G(PSORXED("FLD",DR))]"" D FIELD^DID(52,DR,"","LABEL","ZZ") S PSORXED(ZZ("LABEL"))=PSORXED("FLD",DR) K ZZ
        Q:$G(PSOSIGFL)
        S (RX1,I,RFD,RFDT)=0 F  S I=$O(^PSRX(PSORXED("IRXN"),1,I)) Q:'I  S RFD=I,RFDT=$P(^PSRX(PSORXED("IRXN"),1,I,0),"^"),RX1(I)=$G(RX1(I))+1
        Q
CHK     S CHK=1 I $G(^PSDRUG($P(PSORXED("RX0"),"^",6),"I"))]"",^("I")<DT S VALMSG="This drug has been inactivated. ",PSORXED("DFLG")=1 Q
        K PSPOP I $G(PSODIV),$P(PSORXED("RX2"),"^",9)'=PSOSITE S PSPRXN=PSORXED("IRXN") D  Q:PSORXED("DFLG")
        .I '$P(PSOSYS,"^",2) S VALMSG="RX# "_$P(^PSRX(PSPRXN,0),"^")_" is not a valid choice. (Different Division)" S PSORXED("DFLG")=1 Q
        .I $P(PSOSYS,"^",3) K DIR,DUOUT,DTOUT D  K DIR,DUOUT,DTOUT Q
        ..W $C(7) S DIR("A",1)="",DIR("A",2)="RX# "_$P(^PSRX(PSPRXN,0),"^")_" is from another division.",DIR("A")="Continue: (Y/N)",DIR(0)="Y",DIR("?",1)="'Y' FOR YES",DIR("?")="'N' FOR NO"
        ..S DIR("B")="N" D ^DIR I 'Y!($D(DIRUT)) S PSORXED("DFLG")=1 W !
        ; Begin WV EHR Change ;PSO*7.0*208
        S DIC="^VA(200,",DIC(0)="QEZ",X="AUTOFINISH,RX"
        D ^DIC K DIC
        S PSOZAF=+Y
        I $P($G(^PSRX(PSORXED("IRXN"),"OR1")),"^",5)=$G(PSOZAF) S PSORXED("DFLG")=1 S VALMSG="EDIT option is not available for Autofinshed Rxs" K PSOZAF Q
        ; End WV EHR change ;PSO*7.0*208
        ;
        I $P(^PSRX(PSORXED("IRXN"),"STA"),"^")=16 S PSORXED("DFLG")=1 S VALMSG="Prescriptions on Provider Hold cannot be edited." Q
CHKX    K PSPOP,DIR,DTOUT,DUOUT,Y,X Q
        Q
PROV    ;select provider
        S PSORXED("PROVIDER")=$P(RX0,"^",4),PSORXED("PROVIDER NAME")=$P(^VA(200,$P(RX0,"^",4),0),"^")
        D PROV^PSODIR(.PSORXED) I PSORXED("PROVIDER")'=$P(RX0,"^",4) D
        .K DIR,DIRUT W ! S DIR(0)="Y",DIR("A",1)="You have changed the name of the provider entered for this Rx."
        .S DIR("A",2)="This edit will cause the provider's name to be update for all fills.",DIR("A")="Do you want to continue" D ^DIR
        .I 'Y!$D(DIRUT) K PSORX("PROVIDER"),PSORX("PROVIDER NAME"),PSORX("COSIGNING PROVIDER") Q
        .S PSORXED("FLD",4)=PSORXED("PROVIDER") K DIR,DIRUT,DUOUT
        .S PSORXED("FLD",109)=$G(PSORXED("COSIGNING PROVIDER"))
        Q
UDPROV  ;update provider
        S $P(^PSRX(PSORXED("IRXN"),0),"^",4)=PSORXED("PROVIDER"),$P(^(3),"^",3)=$G(PSORX("COSIGNING PROVIDER"))
        F XTY="1","P" F I=0:0 S I=$O(^PSRX(PSORXED("IRXN"),XTY,I)) Q:'I  S $P(^PSRX(PSORXED("IRXN"),XTY,I,0),"^",17)=PSORXED("PROVIDER") S:XTY RFED=I
        K XTY,I
        Q
SIG     ;edit medication instructions (SIG)
        S PSOFDR=+$P(^PSRX(PSORXED("IRXN"),"SIG"),"^",2) I PSOFDR D
        .F I=0:0 S I=$O(^PSRX(PSORXED("IRXN"),"SIG1",I)) Q:'I  S SIG(I)=^PSRX(PSORXED("IRXN"),"SIG1",I,0)
        E  S PSORX("SIG")=$P(^PSRX(PSORXED("IRXN"),"SIG"),"^")
        D SIG^PSODIR1(.PSORX) D:$G(PSORX("SIG"))]"" EN1^PSOSIGNO(PSORXED("IRXN"),PSORX("SIG"))
        I '$G(PSOSIGFL),$G(PSORX("SIG"))]"" S ^PSRX(PSORXED("IRXN"),"SIG")=PSORX("SIG") K ^PSRX(PSORXED("IRXN"),"SIG1") Q
        S PSOMRFLG=1
        Q
UL      ;
        I '$G(PSOLOKED) Q
        D UL^PSSLOCK(PSODFN)
        D PSOUL^PSSLOCK($P(PSOLST(ORN),"^",2))
        Q
SVAL    ;Set message for patient lock
        S VALMSG=$S($P($G(PSOPLCK),"^",2)'="":$P($G(PSOPLCK),"^",2)_" is working on this patient.",1:"Another person is entering orders for this patient.")
        Q
SVALO   ;Set message for order lock
        S VALMSG=$S($P($G(PSOMSG),"^",2)'="":$P($G(PSOMSG),"^",2),1:"Another person is editing this order.")
        Q
        ;
