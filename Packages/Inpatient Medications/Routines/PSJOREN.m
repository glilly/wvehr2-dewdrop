PSJOREN ;BIR/CML3-INTERFACE FOR INPATIENT PHARMACY AND OE/RR ;07 AUG 97 / 3:21 PM
        ;;5.0; INPATIENT MEDICATIONS ;**109,127,134**;16 DEC 97;Build 124
        ;
        ;Reference to ^ORD(100.98 supported by DBIA 873
        ;Reference to ^PS(51.2 supported by DBIA 2178
        ;Reference to ^PS(55 supported by DBIA 2191
        ;
ENTRY   ;
        K PSGOEE,PSGOES
        I '$D(^DPT(+ORVP,.1)) W !!,"THIS PATIENT HAS NOT BEEN ADMITTED.",!,"(Any non-IV orders entered will be discontinued by the pharmacist...)"
        ;
GO      ; get orders
        S PSGOEORF=1,PSGOEAV=0,PSJORTOU=$O(^ORD(100.98,"B","INPATIENT MEDICATIONS",0)),PSGOEDMR=$O(^PS(51.2,"B","ORAL",0)),PSGOEPR=PSJORPV
        F  S PSGOEOS="U" D ^PSGOE7 Q:Y<0  D:X?1"S."1.E ^PSGOES I X'?1."S."1.E D ^PSGOE6 K PSGOEE D:$D(Y) ^PSGOETO
        ;
DONE    ;
        ;
OUT     ;
        Q  ;
PS      ;
        W $C(7),!!,"The selected PROVIDER is NOT qualified to write MEDICATION orders.  You must",!,"select a valid provider to be able to continue with Inpatient Medications."
        K DIC S DIC="^VA(200,",DIC(0)="AEMQZ",DIC("A")="Select PHARMACY PROVIDER: ",DIC("S")="S PSG=$G(^(""PS"")) I PSG,$S('$P(PSG,""^"",4):1,1:DT<$P(PSG,""^"",4))" F  W ! D ^DIC Q:$D(DUOUT)!$D(DTOUT)!(Y>0)  W $C(7),"  (Required.)"
        K DIC S:Y'>0 PSJORPF=11 S:Y>0 PSJORPV=+Y,PSJORPVN=Y(0,0) Q
        Q
ENBKOUT(DFN,ON) ; Undo Renew.
        Q:'$G(ON)
        N PSJOLD,PSJRES,PSJOC,PSJOC2,PSIVACT,PSIVALT,PSIVREA,ON55,PSGAL,DA,PSIVAL,PSJUNDC
        S PSJOC=PSOC,PSJOC2=PSJHLMTN,PSIVAL=24000
        S X=$G(^PS(53.1,+ON,0)) Q:'X
        S PSJRES=$P(X,U,24),(X,PSJOLD)=$P(X,U,25)
        I PSJOLD["V" D
        .I $D(^PS(55,DFN,"IV",+PSJOLD,2)) D
        ..N PSJOSTOP,PSJNOW,PSJSTAT S PSJNOW=$$DATE^PSJUTL2(),PSJOSTOP=$P($G(^PS(55,DFN,"IV",+PSJOLD,0)),"^",3),PSJSTAT=$P(^(0),"^",17)
        ..S $P(^PS(55,DFN,"IV",+PSJOLD,2),U,6)="",$P(^(2),U,9)="",$P(^(0),U,17)=$S(PSJNOW>PSJOSTOP:"E",PSJSTAT="R":"A",1:PSJSTAT)
        ..S PSIVACT=1,PSIVALT=$S(PSOC="CR":2,1:1),PSJUNDC=1,PSIVAL=$P($G(^PS(53.3,+PSIVAL,0)),U),PSIVREA="PNRD",ON55=PSJOLD
        .D LOG^PSIVORAL
        I PSJOLD["U" D
        .I $D(^PS(55,DFN,5,+PSJOLD,0)) N PSJSTAT S PSJSTAT=$P(^(0),"^",9) D
        ..N PSJOSTOP,PSJNOW S PSJNOW=$$DATE^PSJUTL2(),PSJOSTOP=$P($G(^PS(55,DFN,5,+PSJOLD,2)),"^",4)
        ..S $P(^PS(55,DFN,5,+PSJOLD,0),U,26,27)=U,PSGAL("C")=24000,DA=+PSJOLD,DA(1)=DFN S $P(^(0),U,9)=$S(PSJNOW>PSJOSTOP:"E",PSJSTAT="R":"A",1:PSJSTAT)
        .D ^PSGAL5
        S PSOC="SC",PSJHLMTN="ORM" D EN1^PSJHL2(DFN,PSOC,PSJOLD) S PSOC=PSJOC,PSJHLMTN=PSJOC2
        Q
        ;
ENUDTX(DFN,ON,RES)      ; Set up ORTX( Array for UD orders.
        K ORTX N DO,MRN,ND0,NDP1,ND2,PD,ST,SCH
        S Y=2 I ON["A"!(ON["O") S ND0=$G(^PS(55,DFN,5,+ON,0)),NDP1=$G(^(.1)),ND2=$G(^(2)),Y=2 F X=0:0 S X=$O(^PS(55,DFN,5,+ON,12,X)) Q:'X  S Y=Y+1,ORTX(Y)=$G(^(X,0))
        E  S ND0=$G(^PS(53.1,+ON,0)),NDP1=$G(^(.1)),ND2=$G(^(2)),Y=2 F X=0:0 S X=$O(^PS(53.1,+ON,12,X)) Q:'X  S Y=Y+1,ORTX(Y)=$G(^(X,0))
        S ORTX(1)=$S($G(RES)="NR":"RENEWAL -",$G(RES)="OR":"RENEWED -",1:"")_$P($G(^PS(50.3,+NDP1,0)),U)
        S ORTX(2)=" Give: "_$S($P(NDP1,U,2)]"":$P(NDP1,U,2)_" ",1:"")_$P($G(^PS(51.2,+$P(ND0,U,3),0)),U,3)_" "_$P(ND2,U)_$S($P(ND2,U)["PRN":"",$P(ND0,U,7)="P":" PRN",1:"")
        I $G(DFN),$G(ON) S:ON["U" ^PS(55,"AUE",DFN,+ON)=""
        Q
