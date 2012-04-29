PSJLIACT        ;BIR/MV-IV ACTION ;28 Jul 98 / 8:50 AM
        ;;5.0; INPATIENT MEDICATIONS ;**15,47,62,58,82,97,80,110,111,134**;16 DEC 97;Build 124
        ;
        ; Reference to ^PS(55 is supported by DBIA 2191.
        ; Reference to MAIN^TIUEDIT is supported by DBIA 2410.
        ;
DC      ; Discontinue order
        D HOLDHDR^PSJOE
        S PSJCOM=+$S(PSJORD["V":$P($G(^PS(55,DFN,"IV",+PSJORD,.2)),"^",8),1:$P($G(^PS(53.1,+PSJORD,.2)),"^",8))
        I PSJCOM W !!,"This order is part of a complex order. If you discontinue this order the",!,"following orders will be discontinued too (unless the stop date has already",!,"been reached)." D CMPLX^PSJCOM1(PSGP,PSJCOM,PSJORD)
        I PSJCOM F  W !!,"Do you want to discontinue this order" S %=1 D YN^DICN Q:%  D ENCOM^PSGOEM
        I PSJCOM,%'=1 S VALMBK="" Q
        I PSJORD["V" D DC^PSIVORA,EN^PSJLIORD(DFN,ON) Q
        D:PSJORD["P" DISCONT^PSIVORC
        S VALMBCK="Q"
        Q
ACEDIT  ; Display LM screen and AC and EDit actions
        D EN^PSJLIVMD
        S VALMBCK=$S($G(PSIVACEP):"Q",1:"R")
        Q
AEEXIT  ; Call for EXIT CODE in PSJ LM IV AC/EDIT
        D:ON["V" GT55^PSIVORFB
        I ON["P" D GT531^PSIVORFA(DFN,ON) D:P("OT")'="I" GTDATA^PSJLIFN
        D EN^PSJLIVMD
        K PSIVENO
        Q
EDIT    ; Edit order
        K PSIVFN1 NEW PSIVNBD
        I $D(PSGACT),PSGACT'["E" W !,"This order may not be edited." D PAUSE^VALM1 Q
        D EDIT1
        Q:$D(PSIVNBD)!($G(PSIVCOPY)&'$G(PSIVENO))
        D EN^PSJLIVMD
        S VALMBCK=$S($G(PSIVFN1):"Q",1:"R")
        Q
EDIT1   ;
        ;Ensure P() is defined
        I $D(P)<10 S XQORQUIT=1,P("PON")="",PSIVNBD=1 D  Q
        .W !,"WARNING: An error has occurred. Changes will not be saved"
        .D PAUSE^VALM1
        .S VALMBCK="Q"
        I "ANP"'[P(17) W !,"You cannot edit an inactive order" D PAUSE^VALM1 Q
        S:$G(ON55)="" ON55=$G(PSJORD)
        D HOLDHDR^PSJOE
        ;* Edit a new back door order
        I ($G(ON55)["V"&($G(P("21FLG"))="")) D  Q
        . D GSTRING^PSIVORE1,GTFLDS^PSIVORFE
        . I $G(ON55)["V",'$G(DONE) D OK^PSIVORE
        . S VALMBCK="Q",PSIVNBD=1
        ;* Edit an active order
        I $G(ON55)["V" NEW PSJEDIT1 D E^PSIVOPT1 D  Q
        . I $G(PSJIVBD) K PSJIVBD D EN^PSJLIORD(DFN,ON)
        I $G(ON55)["P" D EDIT^PSIVORC ;Edit incomplete order.
        K P("OVRIDE")
        Q
ACCEPT  ; Accept order
        D HOLDHDR^PSJOE
        ;Accept IV from back door.
        I $G(PSJIVBD) K PSJIVBD D OK^PSIVORE S VALMBCK="Q" Q
        I ON["V" D ACCEPT^PSIVOPT1 Q
        S PSIVFN1=1
        D COMPLTE^PSIVORC1
        S VALMBCK="Q"
        Q
R       ; Renewal
        S PSJREN=1
        D HOLDHDR^PSJOE
        NEW PSIVAC S PSIVAC="PR" K PSGFDX
        D R^PSIVOPT
        D EN^PSJLIORD(DFN,ON)
        K PSJREN
        Q
H       ; Hold
        NEW TEX S TEX="Active order ***"
        D HOLDHDR^PSJOE
        D H^PSIVOPT(DFN,ON,P(17),P(3))
        D:P(17)="A" PAUSE^VALM1
        D EN^PSJLIORD(DFN,ON)
        Q
L       ; Activity Log
        NEW PSIVLAB,PSIVLOG,PSJHIS S (PSIVLAB,PSIVLOG)=1
        D EN^PSIVVW1
        D EN^PSJLIVMD
        S VALMBCK="R"
        Q
O       ; On Call
        NEW TEX S TEX="Active order ***"
        D HOLDHDR^PSJOE
        D O^PSIVOPT(DFN,ON,P(17),P(3))
        D:P(17)="A" PAUSE^VALM1
        D EN^PSJLIORD(DFN,ON)
        Q
VF      ; Make the order active
        NEW PSIVCHG S PSIVCHG=0
        I ON["V" S ON55=ON D VF1("V","ORDER VERIFIED BY ",1) Q
        D ACTIVE^PSIVORC2
        Q
VF1(PSIVREA,PSIVAL,PSIVLOG)     ;
        ;Update 4 node and set activity log.
        ;PSIVREA: the reason use by LOG^PSIVORAL
        ;PSIVAL : the description reason
        ;PSIVLOG: Log an activity if = 1
        I '+$G(OD)!($L($G(OD))>16) K OD
        D:+PSJSYSU=3 ^PSIVORE1
        NEW DIE,DA,DR,PSJX,XX,PSIVACT,PSJRQND
        S PSIVACT=1
        S PSJX=$G(^PS(55,DFN,"IV",+ON55,4)),XX=""
        I $P(PSJX,U)="" S XX=";143////0"
        I $P(PSJX,U,4)="" S XX=XX_U_";142////0"
        D NOW^%DTC
        S DIE="^PS(55,"_DFN_",""IV"",",DA=+ON55,DA(1)=DFN
        I +PSJSYSU=3 S DR="140////"_DUZ_";141////"_$E(%,1,12)_";142////1"_$P(XX,U)
        I +PSJSYSU=1 S DR="16////"_DUZ_";17////"_$E(%,1,12)_";143////1"_$P(XX,U,2)
        I $G(P("PRY"))="D" S DR=DR_";.22////"_+P("IVRM")
        D ^DIE
        ; If pending IV renew is edited during finish, go back and DE the original active order left in RENEWED status
        S PREREN=$S(ON55["V":$G(@(DIE_"+ON55,2)")),1:""),PREREN=$P(PREREN,"^",5) I PREREN D  K PREREN
        . I PREREN["P" S PREREN=$G(@("^PS(53.1,+PREREN,0)")),PREREN=$P(PREREN,"^",25)
        . I PREREN["V" N PRERENOD S PRERENOD=$G(@("^PS(55,DFN,""IV"",+PREREN,0)")) I $P(PRERENOD,"^",17)="R",($G(P("RES"))="E") D
        ..  S DIE="^PS(55,"_DFN_",""IV"",",DA=+PREREN,DA(1)=DFN
        ..  S DR="100////D;.03////"_PSGDT S ORIGSTOP=$P($G(@("^PS(55,DFN,""IV"",+PREREN,2)")),"^",3) I ORIGSTOP S DR=DR_";116////"_ORIGSTOP
        ..  D ^DIE D EN1^PSJHL2(DFN,"SC",PREREN)
        K DR,DIE,DA
        I (+PSJSYSU=3)&($G(P("PRY"))="D") D
        .N DIR W ! S DIR(0)="S^Y:Yes;N:No",DIR("A")="Do you want to enter a Progress Note",DIR("B")="No" D ^DIR
        .Q:Y="N"
        .D MAIN^TIUEDIT(3,.TIUDA,DFN,"","","","",1)
        Q:'$G(PSIVLOG)
        I $G(P("PACT"))]"",+$P(P("PACT"),U,2),+$P(P("PACT"),U,3) D
        . NEW DIC,DA,X,Y,XX,DO D NAME^PSJBCMA1($P(P("PACT"),U,2),.XX)
        . S DIC(0)="L",DA(1)=DFN,DA(2)=+ON55,X=1
        . S DIC="^PS(55,"_DA(1)_",""IV"","_DA(2)_",""A"","
        . S DIC("DR")=".02////F;.03////"_XX_";.04////"_$P($G(^PS(53.3,+$P(P("PACT"),U,3),0)),U)_";.05////"_$P(P("PACT"),U)_";.06////"_$P(P("PACT"),U,2)
        . D FILE^DICN
        NEW PSIVALCK
        S PSIVREA="V",PSIVALT=""
        S PSIVAL=PSIVAL_$S(+PSJSYSU=3:"PHARMACIST",1:"NURSE")
        D LOG^PSIVORAL K PSIVAL,PSIVREA,PSIVLN
        I $G(PSJORD)["P" S PSIVREA="V",PSIVALT="",PSGRDTX=$G(^PS(53.1,+PSJORD,2.5)) D
        . I $G(PSGRDTX) S PSIVAL="Requested Start Date: "_$$ENDTC^PSGMI($$DATE2^PSJUTL2($P(PSGRDTX,U))) D LOG^PSIVORAL
        . I $P(PSGRDTX,U,3) S PSIVREA="V",PSIVALT="" S PSIVAL="Requested Stop Date: "_$$ENDTC^PSGMI($$DATE2^PSJUTL2($P(PSGRDTX,U,3))) D LOG^PSIVORAL
        N DUR I $G(PSJORD) S DUR=$$GETDUR^PSJLIVMD(DFN,+PSJORD,$S(PSJORD["P":"P",1:"IV"),1) I DUR]""  D
        . K DR S DIE="^PS(55,"_DFN_",""IV"",",DA=+ON55,DA(1)=DFN
        . S DR=$S($G(IVLIMIT):"152////"_DUR,1:"151////"_DUR) K IVLIMIT
        . D ^DIE
        D EN1^PSJHL2(DFN,"SC",ON55)
        D:+PSJSYSU=1 EN1^PSJHL2(DFN,"ZV",ON55)
        D GT55^PSIVORFB S OLDON=$P($G(^PS(55,DFN,"IV",+ON55,2)),"^",5),P("OLDON")=OLDON
        N PSJPRIO,PSJSCH,NODE0,NODEP2 S NODE0=$G(^PS(55,DFN,"IV",+ON55,0)),NODEP2=$G(^PS(55,DFN,"IV",+ON55,.2))
        S PSJPRIO=$P(NODEP2,"^",4),PSJSCH=$P(NODE0,"^",9)
        I (",S,A,")[(","_$G(PSJPRIO)_",")!($G(PSJSCH)="NOW")!($G(PSJSCH)["STAT") D NOTIFY^PSJHL4(ON55,DFN,$G(PSJPRIO),$G(PSJSCH))
        Q
