PSIVORA ;BIR/MLM-MAIN DRIVER FOR IV FLUIDS - OE/RR INTERFACE ;08 JAN 97 / 2:47 PM
        ;;5.0; INPATIENT MEDICATIONS ;**29,41,110,134**;16 DEC 97;Build 124
        ;
        ; Reference to ^PS(55 is supported by DBIA 2191
        ;
EN      ; Entry point called by IV Fluid protocol.
        S X=ORACTION,PSIVAC="O"_$S(X=0:"N",X=1:"E",X=2:"R",X=4:"H",X=6:"D",X="8":"S",1:"") S:X'=5&(X'=7) PSIVUP=+$$GTPCI^PSIVUTL
        S (PSGP,DFN)=+ORVP,PSJACNWP=1 D ^PSJAC I "578"[ORACTION D @ORACTION,DONE^PSIVORA1 Q
        D ENCPP^PSIVOREN Q:'PSJIVORF!('PSJORF)  D EN1,DONE^PSIVORA1
        Q
        ;
EN1     ; Take action on existing order.
        S PSJORD=$G(ORPK) I ORGY>8 D @ORGY Q
        I 'ORACTION D ^PSIVORFE Q
        I '$G(ORPK) W !,"INSUFFICIENT INFORMATION, CANNOT CONTINUE." S OREND=1 Q
        I ORPK["V",($P($G(^PS(55,DFN,"IV",+ORPK,0)),U,17)="O") D ONCALL^PSIVORV1 Q
        I ORACTION<3 S P("FRES")=$S(ORPK["V":$P($G(^PS(55,DFN,"IV",+ORPK,2)),U,9),1:$P($G(^PS(53.1,+ORPK,0)),U,27)) I P("FRES")]"" D @$S(P("FRES")="R":"ALLREN^PSIVORV1",1:"ALLED^PSIVORV1") Q
        S PSJORSTS=ORSTS,PSJORIFN=ORIFN L +@$S(PSJORD["V":"^PS(55,DFN,""IV"",+PSJORD)",1:"^PS(53.1,+PSJORD)"):1 E  D LOCKERR^PSIVORA1 Q
        D @ORACTION L -@$S(PSJORD["V":"^PS(55,DFN,""IV"",+PSJORD)",1:"^PS(53.1,+PSJORD)")
        Q
        ;
1       ; Edit an existing order.
        D EDIT^PSIVORA1
        Q
        ;
2       ; Renew
        D RENEW^PSIVORA1
        Q
        ;
3       ; Flag
        Q
        ;
4       ; Hold
        I ORSTS'=3,ORSTS'=6 W !,$C(7),"Only ACTIVE orders may be placed on HOLD." S OREND=1 Q
        S PSIVREA=$S(ORSTS=6:"H",1:"U"),ON55=PSJORD,$P(^PS(55,DFN,"IV",+ON55,0),U,10)=$S(PSIVREA="H":1,1:""),Y=$G(^PS(55,DFN,"IV",+ON55,0)),P(3)=$P(Y,U,3),P(17)=$P(Y,U,17)
        D NOW^%DTC I ORSTS=3,P(3)<% S P(17)="E" D UPSTAT^PSIVOPT S ORSTS=7 W $C(7),"  This order has expired." Q
        S XED=0,PSIVALT=2,P(17)=$S(PSIVREA="H":"H",1:"A") D UPSTAT^PSIVOPT,LOG^PSIVORAL S ORSTS=$S(PSIVREA="H":3,1:6)
        Q
        ;
5       ; Event
        N DA,DIE,DR,ON,P,PSIVACT,X
        S ON=ORPK I ON["V" S X=$G(^PS(55,+ORVP,"IV",+ON,0)),P(3)=$P(X,U,3),P(17)=$P(X,U,17)
        I ON'["V" S P(3)=$P($G(^PS(53.1,+ON,2)),U,4),P(17)=$P($G(^PS(53.1,+ON,0)),U,9)
        Q:"AR"'[P(17)  D NOW^%DTC Q:P(3)>%
        I ON["V" S DR="100///E",DIE="^PS(55,"_+ORVP_",""IV"",",DA(1)=+ORVP
        I ON'["V" S DR="28///E",DIE="^PS(53.1,"
        S PSIVACT=1,DA=+ON D ^DIE S ORSTS=7
        Q
        ;
6       ; Cancel - Delete pending or unreleased orders from Nonverified orders
        ; (53.1) and Orders (100) files.
        I ORSTS=1 W $C(7),!,"This order has already been DISCONTINUED." Q
        I ORSTS=7 W $C(7),!,"Expired orders cannot be DISCONTINUED." Q
        I PSJORD'["V",ORSTS=11 D  Q
        .S P("OLDON")=$P($G(^PS(53.1,+PSJORD,0)),U,25) I P("OLDON")  D
        ..I P("OLDON")["V",$D(^PS(55,DFN,"IV",+P("OLDON"),2)) S PSJRES=$P(^(2),U,9) S:PSJRES'="R" $P(^(2),U,6)="",$P(^(2),U,9)="" ;; D:PSJRES="R" ENBKOUT^PSJOREN(DFN,PSJORD)
        ..I P("OLDON")'["V",$D(^PS(53.1,+P("OLDON"),0)) S PSJRES=$P(^(0),U,27) S:PSJRES'="R" $P(^(0),U,26,27)="^" I PSJRES="R" ;; D ENBKOUT^PSJOREN(DFN,PSJORD)
        .K DA,DIK S DIK="^PS(53.1,",DA=+PSJORD D ^DIK S PSGP=DFN,X="P" D ENSK^PSGAXR K DA,DIK S ORIFN=PSJORIFN,ORSTS="K" Q
        ;
DC      ; DC order from Pharmacy complete function.
        I PSJORD["V",'PSJCOM N PSIVREA S ON55=PSJORD,X=$G(^PS(55,DFN,"IV",+ON55,0)),P(3)=$P(X,U,3),P(17)=$P(X,U,17),PSIVREA="D",PSIVALT=2,PSIVALCK="STOP" D D^PSIVOPT2 D HL Q
        I PSJORD["V",PSJCOM N PSIVREA S ON55=PSJORD,X=$G(^PS(55,DFN,"IV",+ON55,0)),P(3)=$P(X,U,3),P(17)=$P(X,U,17),PSIVREA="D",PSIVALT=2,PSIVALCK="STOP" D D^PSIVOPT2 Q
        N DA,DR,DIE,PSJND S DA=+PSJORD,PSJND=$G(^PS(53.1,DA,0)),P("OLDON")=$P(PSJND,U,25),DIE="^PS(53.1,",DR="28///"_$S($P(PSJND,U,27)="E":"DE",1:"D") D ^DIE
        D HL
        Q
HL      ;
        Q:'$D(P("NAT"))
        NEW PSJCD,PSJTX,PSJOTMP
        I PSJORD["P" N PSJNOO S PSJCD="OC",PSJTX="ORDER CANCELED",PSJNOO=$G(P("NAT"))
        E  S PSJCD="OD",PSJTX="ORDER DISCONTINUED"
        S PSJOTMP=$G(P("OT")) S P("OT")="F" D EN1^PSJHL2(DFN,PSJCD,PSJORD,PSJTX)
        Q
        ;
7       ; Purge
        N ND S ND=$S(ORPK["V":$P($G(^PS(55,+ORVP,"IV",+ORPK,0)),U,17)_U_$P($G(^(0)),U,3),1:$P($G(^PS(53.1,+ORPK,0)),U,9)_U_$P($G(^(2)),U,4))
        Q:"DE"'[$P(ND,U)  S X1=+$P(ND,U,2),X2=30 D C^%DTC S ND=X D NOW^%DTC Q:ND>%
        I ORPK["V",$D(^PS(55,+ORVP,"IV",+ORPK,0)) S $P(^(0),U,21)=""
        I ORPK'["V",$D(^PS(53.1,+ORPK,0)) S $P(^(0),U,21)=""
        S ORSTS="K"
        Q
        ;
8       ; Print
        K DIR S DIR(0)="E" D ^DIR K DIR I $D(DUOUT)!'($D(ORPK)) S OREND=1 Q
        S:'$G(PSIVUP) PSIVUP=+$$GTPCI^PSIVUTL S:'$D(PSIVAC) PSIVAC="OS" S (ON,ON55)=ORPK,DFN=+ORVP D @$S(ON["V":"GT55^PSIVORFB",1:"GT531^PSIVORFA("_DFN_","""_ON_""")"),ENDT^PSIVORV1
        Q
        ;
9       ; Release order (status=incomplete in 53.1, pending in 100)
        S X=ORACTION I X=4!(X=6) D @ORACTION Q
        Q:"36"[ORSTS  N ON,PSJORIFN S PSJORIFN=ORIFN,ON=ORPK L +^PS(53.1,+ON):1 E  D LOCKERR^PSIVORA1 Q
        S Y=$G(^PS(53.1,+ON,0)),P("RES")=$P(Y,U,24),P("OLDON")=$P(Y,U,25)
        N DA,DIE,DR,OREND S DR="28////P",DIE="^PS(53.1,",DA=+ON D ^DIE
        I P("OLDON")]"" K DA,DIE,DR S DA=P("OLDON") D
        .I DA["V" S DA(1)=+ORPV,DIE="^PS(55,"_DA(1)_",""IV"",",DR="114////"_+ON_"P"_";123////"_P("RES")
        .E  S DIE="^PS(53.1,",DR="105////"_ON_"P"_";107////"_P("RES") I P("RES")="E",$P($G(^PS(53.1,+P("OLDON"),0)),U,9)="D" S DR=DR_";28////DE"
        .S DA=+DA L +@(DIE_DA_")"):1 E  D LOCKERR^PSIVORA1 Q
        .D ^DIE L -@(DIE_DA_")")
        L -^PS(53.1,+ON) D DONE^PSIVORA1
        Q
        ;
10      ; Verify
        Q
