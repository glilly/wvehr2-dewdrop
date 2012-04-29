FBNHEAUT        ;AISC/DMK,GRR-ENTER/EDIT AUTHORIZATION ;08/07/02
        ;;3.5;FEE BASIS;**43,103**;JAN 30, 1995;Build 19
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        D SITEP^FBAAUTL Q:FBPOP  S FBAADDYS=+$P(FBSITE(0),"^",13),FBAAASKV=$P(FBSITE(1),"^"),FBPROG=$S($P(FBSITE(1),"^",6)="":"I 1",1:"I $P(^(0),U,3)=7") W !!
        ;
        S PRCS("TYPE")="FB",PRCS("A")="Select Obligation Number: " K PRCS("X") D EN1^PRCS58 G:Y<0 NOGOOD^FBNHEAU1 S FBOBN=$P(Y,"^",2) K PRCS("A")
        ;
        W !! S DIC="^DPT(",DIC(0)="QEAZM" D ^DIC G END:Y<0 S DFN=+Y
        I $P($G(^DPT(DFN,.361)),"^")="" W !!,"ELIGIBILITY HAS NOT BEEN DETERMINED NOR PENDING, CANNOT ENTER AN AUTHORIZATION." G FBNHEAUT
        I $P($G(^DPT(DFN,.32)),"^",4)=2 W !!,"VETERAN HAS A DISHONORABLE DISCHARGE, " S X=$P($G(^(.321)),"^") W $S(X="Y":"ONLY ELIGIBLE FOR AGENT ORANGE.",1:"NOT ELIGIBLE FOR BENEFITS.")
        I "N"[$E(X) W ! S DIR("A")="Do you want to continue",DIR(0)="Y",DIR("B")="No" D ^DIR K DIR G FBNHEAUT:$S($D(DIRUT):1,'Y:1,1:0)
        S DA=DFN I '$D(^FBAAA(DFN,0)) K DD,DO S (X,DINUM)=DFN,DIC="^FBAAA(",DIC(0)="LM",DLAYGO=161 D FILE^DICN K DIC,DLAYGO G:Y<0 END
        S:'$D(^FBAAA(DFN,1,0)) ^(0)="^161.01D^^"
        D ^FBAADEM ;G FBNHEAUT:FBAAOUT
        ;
GETVEN  S FBPROG=7 D DATES^FBAAUTL2 G:FBBEGDT="" FBNHEAUT
        D GETVEN^FBAAUTL1 G END:X="^"!(X=""),GETVEN:IFN="" S FBVEN=IFN,FBPAYDT=FBBEGDT,X=+FBBEGDT D DAYS^FBAAUTL1 S FBDAYS=$S(X>(FBENDDT-FBBEGDT):(FBENDDT-FBBEGDT),1:X)
        D GETRAT^FBNHEAU2 G:FBERR GETVEN
        ;CREATE AN ENTRY IN FILE 161
        K DD,DO S DLAYGO=161,DA(1)=DFN,(DIE,DIC)="^FBAAA("_DA(1)_",1,",DIC(0)="LQ",X=FBBEGDT D FILE^DICN K DLAYGO S DA=+Y,FBAAADA=DA
        S DIE=DIC,FBPSADF=$S($D(FBSITE(1)):$P(^DIC(4,$P(FBSITE(1),"^",3),0),"^",1),1:"")
        ; fb*3.5*103  added REFERRING PROVIDER field (161.01,104) to DR string
        S DR=".02////^S X=FBENDDT;.03////^S X=7;S FBTYPE=7;100////^S X=DUZ;1////^S X=""YES"";.04////^S X=FBVEN;.095////1;101T;104;.065;.07;.021;.097;.08;S:X="""" Y="""";.085;S:X="""" Y="""";.086" D ^DIE
        I $D(DTOUT)!('$D(Y)=0) S DIC="^FBAAA("_DFN_",1," G DEL
        ; fb*3.5*103  assignment of REFERRING PROVIDER (161.01,104) for recording at 162.4,15 via the FBNH ENTER 7078 input template
        S FBRP=$$GET1^DIQ(161.01,FBAAADA_","_DFN,104,"I")
        S FBVEN=FBVEN_";FBAAV("
        ;
        S X=FBPAYDT D DAYS^FBAAUTL1 S FBATODT=$S($E(FBPAYDT,1,5)_"00"+X>FBENDDT:FBENDDT-1,1:$E(FBPAYDT,1,5)_"00"+X)
        D EST^FBNHEAU2
        I $G(FBDEFP)'>0 W !,*7,"Unable to determine estimated dollar amount, based on authorization",!,"dates and current vendor contracts.",! S DA=FBAAADA,DA(1)=DFN,DIC="^FBAAA("_DFN_",1," G DEL
        ;CHECK 1358 and get next point number. create entry in 162.4
        S X=FBOBN K PRCS("A") S PRCS("TYPE")="FB" D EN1^PRCSUT31 I Y<0 S DIC="^FBAAA("_DFN_",1," D PROB^FBNHEAU1 G DEL
        S FB7078=$P(FBOBN,"-",2)_"."_Y,FBSEQ=Y,DIC="^FB7078(",DIC(0)="LQ",DLAYGO=162.4,X=""""_FB7078_"""" D ^DIC K DLAYGO I Y<0 S DIC="^FBAAA("_DFN_",1," D PROB2^FBNHEAU1 G DEL
        S (DA,FBAA78)=+Y
        S DIE=DIC,DR="[FBNH ENTER 7078]" D ^DIE
        I $O(^FBAAA(DFN,1,FBAAADA,2,0))>0 S ^FB7078(FBAA78,1,0)=^FBAAA(DFN,1,FBAAADA,2,0) F Z=0:0 S Z=$O(^FBAAA(DFN,1,FBAAADA,2,Z)) Q:Z'>0  S ^FB7078(FBAA78,1,Z,0)=^FBAAA(DFN,1,FBAAADA,2,Z,0)
        S $P(^FBAAA(DFN,1,FBAAADA,0),"^",9)=FBAA78_";FB7078(",^FBAAA("AG",FBAA78_";FB7078(",DFN,FBAAADA)=""
        ;call to create entries in file 161.23, time sensitive file
        ;that will store patient rates
        S FBERR=0 D FILE^FBNHEAU2 I FBERR W !,"Unable to create entry in Authorization Rate file (161.23).  Contact IRM.",! G ADM
        ;call to create entry in ifcap 424.
        S FBMM=$E(FBBEGDT,4,5)
        S PRCS("TYPE")="FB" K PRCS("A") S FBNAME=$$NAME^FBCHREQ2(DFN),FBSSN=$$SSN^FBAAUTL(DFN) D NOW^%DTC S FBPOSDT=%,X=FBOBN_"^"_FBPOSDT_"^"_FBDEFP_"^^"_FBSEQ_"^"_FBNAME_"  ("_FBSSN_")"_"^"_DFN_";"_FBAA78_";"_$P(FBOBN,"-",2)_";"_FBMM D EN2^PRCS58
        I +Y=0 W !!,"Error trying to Post to 1358, DID NOT POST. Error was:",!,Y,!?7,"Adjust the 1358 for $",$FN(FBDEFP,",",2)," then use the",!?7,"Post Commitments for Obligation option!",!,*7 G ADM
        W !!,$J(FBDEFP,7,2),"  Posted to 1358"
        ;
        ;
CHEKP78 S FBNUM=$P(FBSITE(1),"^",5),FBO=$P(FBSITE(1),"^",7),FBT=$P(FBSITE(1),"^",8) D FBO^FBCHP78 G END:$D(DIRUT) S IOP="Q",FB7078=FBAA78 W !
        D IFCAP^FBAAUTL2
        I '$D(FBERR(1)) S VAR="FB7078^FBNUM^FBO^FBT^FB(""SITE"")",VAL=FB7078_"^"_FBNUM_"^"_FBO_"^"_FBT_"^"_FB("SITE"),PGM="START^FBCHP78",%ZIS("B")="" W ! D ZIS^FBAAUTL
        ;
ADM     S DIR(0)="Y",DIR("A")="Do you want to Admit Patient to CNH now",DIR("B")="YES" D ^DIR K DIR I Y S FBVEN=+FBVEN,FTP=FBAAADA,FBAABDT=FBBEGDT,FBAAEDT=FBENDDT,FBEND=1,FBRCHK=1 D RD2^FBNHEA
        ;
END     D END^FBNHEAU1
        Q
        ;
DEL     S DIK=DIC D ^DIK K DIK,DIC D END^FBNHEAU1 G FBNHEAUT
