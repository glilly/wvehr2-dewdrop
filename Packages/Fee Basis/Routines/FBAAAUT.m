FBAAAUT ;AISC/DMK - ENTER/EDIT AUTHORIZATION ;3/11/1999
        ;;3.5;FEE BASIS;**13,95,103**;JAN 30, 1995;Build 19
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        D SITEP^FBAAUTL G Q:FBPOP S FBAADDYS=+$P(FBSITE(0),"^",13),FBAAASKV=$P(FBSITE(1),"^",1),FBPROG=$S($P(FBSITE(1),"^",6)="":"I 1",1:"I $P(^(0),U,3)=2")
        W ! S DIC="^DPT(",DIC(0)="QEAZM" D ^DIC G Q:Y<0 S DFN=+Y
        I $P($G(^DPT(DFN,.361)),"^")="" W !!,"ELIGIBILITY HAS NOT BEEN DETERMINED NOR PENDING, CANNOT ENTER AN AUTHORIZATION." G FBAAAUT
CONT    I $P($G(^DPT(DFN,.32)),"^",4)=2 W !!?4,"VETERAN HAS A DISHONORABLE DISCHARGE, " S X=$P($G(^(.321)),"^") W $S(X="Y":"ONLY ELIGIBLE FOR AGENT ORANGE EXAM.",1:"NOT ELIGIBLE FOR BENEFITS.")
        W ! S DIR("A")="Do you want to continue",DIR(0)="Y",DIR("B")="Yes" D ^DIR K DIR G FBAAAUT:$S($D(DIRUT):1,'Y:1,1:0)
1       S DA=DFN I '$D(^FBAAA(DA,0)) L +^FBAAA(DA) K DD,DO S (X,DINUM)=DA,DIC="^FBAAA(",DIC(0)="LM",DLAYGO=161 D FILE^DICN L -^FBAAA(DFN) K DIC G:Y<0 Q
        S:'$D(^FBAAA(DFN,1,0)) ^(0)="^161.01D^^"
        D ^FBAADEM K DIRUT,DIROUT,DTOUT,DUOUT
2       W ! S (HID,NID,FBAAP79,FBANEW)="",DA=DFN,DIE="^FBAAA(",DIE("NO^")="",DR="[FBAA AUTHORIZATION]" D ^DIE I $D(FBD1) S FBANEW=$G(^FBAAA(DFN,1,FBD1,0))
        D:'$D(Y)&(HID'="")&(HID'=NID) TRIG K HID,NID,NIDR,TIME G FBAAAUT:FBANEW']"" S X=FBANEW,K=FBD1,J=DT
        I FBAAP79="Y" S $P(^FBAAA(DFN,1,FBD1,1),"^",2)="",FBDFN=DFN D CHEKP79 S DFN=FBDFN
        I $D(FBAOLD),FBAOLD'=FBANEW,$D(FBAALT),FBAALT="Y" S FBTTYPE="A",FBMST=$S($P(FBANEW,"^",13)=1:"Y",1:""),FBFDC=$S($P(FBAOLD,"^")'=$P(FBANEW,"^"):1,1:"") D MORE
        I '$D(^FBAAC(DFN,0)) K DD,DO S (X,DINUM)=DFN,DIC(0)="L",DLAYGO=162,DIC="^FBAAC(" D FILE^DICN K DIC,DLAYGO
        G FBAAAUT
TRIG    ;Add an entry in Fee Basis ID Card Audit file
        I '$D(^FBAA(161.83,DFN)) K DD,DO S (X,DINUM)=DFN,DIC="^FBAA(161.83,",DIC(0)="L",DLAYGO=161.83 D FILE^DICN Q:Y<0
        S:'$D(^FBAA(161.83,DFN,1,0)) ^(0)="^161.831DA^^"
        S %DT="XT",X="NOW" D ^%DT K %DT S TIME=Y
        L +^FBAA(161.83,DFN) S DIC="^FBAA(161.83,"_DFN_",1,",DIC(0)="LM",DINUM=9999999.9999-TIME,X=TIME,DIC("DR")="1////^S X=HID;2////^S X=NIDR;3////^S X=DUZ",DA(1)=DFN K DD,DO D FILE^DICN I Y<0 L -^FBAA(161.83,DFN) Q
        K DIE,DIC,DA,DLAYGO L -^FBAA(161.83,DFN)
        Q
ENT     ;ENTRY POINT FROM ^FBAAPM TO CREATE MRA TRANSACTION
MORE    ;
        S DIC="^FBAA(161.26,",DIC(0)="L",DLAYGO=161.26,X=DFN
        S DIC("DR")="1///^S X=""P"";2///^S X=FBD1;3///^S X=FBTTYPE;5////^S X=FBFDC;6////^S X=FBMST"
        K DD,DO D FILE^DICN K DIC,DLAYGO S DA=+Y
        Q
        ;
CHEKP79 W ! S DIR("A")="Want to Print 7079 for this patient now",DIR(0)="Y",DIR("B")="No" D ^DIR K DIR I Y S FBK=FBD1 D EN1^FBAAS79
        Q
Q       K DA,DAT,DFN,DR,F,FBAASKV,FBAADDYS,FBAALT,FBAAP79,FBAATT,FBANEW,FBAOLD,FBCOUNTY,FBDX,FBI,FBRR,FBSITE,FBTYPE,FBXX,I,J,K,PI,S,T,Z,ZZ,FBAAASKV,FBPROG,DIC,DIE,FBAAX,X,Y,PTYPE,FBPRG,FBAAOUT,FBDFN
        K FBAUT,FBD1,FBPOP
        Q
        ;
        ; PROVIDER LOOKUP
        ;
        ; This function checks the inputed File 200 entry to ensure that it has been assigned the Security Key PROVIDER.
        ; 
        ; Referenced: AUTHORIZATION Sub-File (#161.01) OF FEE BASIS PATIENT File (#161) - REFERRING PROVIDER Field (#104)
        ; Referenced: FEE NOTIFICATION/REQUEST File (#162.2) - REFERRING PROVIDER Field (#17)
        ; Referenced: VA FORM 10-7078 File (#162.4) - REFERRING PROVIDER Field (#15)
        ; 
        ;  Input - FB200IEN - Internal IEN of file 200 entry
        ; Output - 0 Blank Input or entry without PROVIDER Security Key
        ;        - 1 Entry PROVIDER Security Key assigned
        ;
PROVIDER(FB200IEN)      N Y
        ;
        Q:$G(FB200IEN)="" 0
        ;
        ;Test for PROVIDER Security Key
        I $D(^XUSEC("PROVIDER",FB200IEN)) Q 1
        ;
        ;Entry did not have PROVIDER Security Key
        Q 0
