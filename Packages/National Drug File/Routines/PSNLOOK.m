PSNLOOK ;BIR/WRT-Look up into drug file ; 06/19/03 15:00
        ;;4.0; NATIONAL DRUG FILE;**2,3,5,11,22,27,62,70,169**; 30 Oct 98;Build 8
        ;
        ; Reference to ^PSDRUG supported by DBIA# 2192
        ; Reference to ^PS(50.606 supported by DBIA# 2174
        ;
        ;USE PSNLK*
BEGIN   ;
        D ASK
        N PSNLKDA,PSNLKIND,PSNLKCL,PSNLKNOD,PSNLKVPN,PSNLKID,PSNLKVDU,PSNLKTR,PSNLKDAV,PSNLKGK,PSNLKPMI,PSNLKQQ,DIC,X,Y,DLAYGO,DTOUT,DUOUT,DIR,DIRUT,DIROUT,%DT
        N PSNLKMAP,PSNLKENG,PSNLKDF,PSNLKSTR,PSNLKUN,PSNLKFRM,PSNLKUNT,PSNLKNFN,PSNLKBB,PSNLKAND,PSNLKGR,PSNLKIST,PSNLKIUT,PSNLKSEV,PSNLKCSF,PSNLKSP,PSNLKNND,PSNLKCC,PSNLKSCL,PSNLKZ,PSNLKRE,PSNLKWRT,PSNZZFS
        N PSNLKL1,PSNLKL2,PSNLKIUN,PSNZZFSA
SELD    ;Select Drug
        K PSNLKDA,PSNLKIND,PSNLKCL,PSNLKNOD,PSNLKVPN,PSNLKID,PSNLKVDU,PSNLKTR,PSNLKDAV,PSNLKGK,PSNLKPMI,PSNLKQQ,DIC,X,Y,DLAYGO,DTOUT,DUOUT,DIR,DIRUT,DIROUT,%DT
        K PSNLKMAP,PSNLKENG,PSNLKDF,PSNLKSTR,PSNLKUN,PSNLKFRM,PSNLKUNT,PSNLKNFN,PSNLKBB,PSNLKAND,PSNLKGR,PSNLKIST,PSNLKIUT,PSNLKSEV,PSNLKCSF,PSNLKSP,PSNLKNND,PSNLKCC,PSNLKSCL,PSNLKZ,PSNLKRE,PSNLKWRT,PSNZZFS
        K PSNLKL1,PSNLKL2,PSNLKIUN,PSNZZFSA
        W ! K DIC S DIC=50,DIC(0)="QEAM" D ^DIC I Y<0!($D(DTOUT))!($D(DUOUT)) Q
        S PSNLKDA=+Y K Y
        S PSNLKIND=$P($G(^PSDRUG(PSNLKDA,"I")),"^") I PSNLKIND,PSNLKIND<DT  S Y=PSNLKIND D DD^%DT W !!,"This drug has an Inactive date of "_$G(Y),! D MESS G SELD
        D DSPLY
        D HG
        G SELD
        ;
ASK     W !!,"This option will allow you to look up entries in your local DRUG file. It will",!,"display National Drug File software match information.",!
        Q
DSPLY   W @IOF W !?14,"DRUG Generic Name:  ",$P($G(^PSDRUG(PSNLKDA,0)),"^") I $D(^PSDRUG(PSNLKDA,"ND")) S PSNLKCL=$P(^("ND"),"^",6)
        I $D(^PSDRUG(PSNLKDA,"ND")),$P(^PSDRUG(PSNLKDA,"ND"),"^",2)]"" S PSNLKNOD=^PSDRUG(PSNLKDA,"ND") D DSPLY1,DSPLY2,PRODF,DSP,ING,SV,DSP1,RESTN Q
        W !?8,"*** NO NATIONAL DRUG FILE INFORMATION ***",!
        Q
DSPLY1  W !?5,"VA Product Name: ",$P(PSNLKNOD,"^",2)
        W !?5,"VA Generic Name: ",$P($G(^PSNDF(50.6,$P(PSNLKNOD,"^"),0)),"^")
        Q
DSPLY2  ;
        S (PSNLKVPN,PSNLKID,PSNLKVDU,PSNLKTR)=""
        K X S PSNLKDAV=$P(PSNLKNOD,"^"),PSNLKGK=$P(PSNLKNOD,"^",3),X=$$PROD2^PSNAPIS(PSNLKDAV,PSNLKGK) I $P(X,"^")]"" S PSNLKVPN=$P(X,"^"),PSNLKID=$P(X,"^",2),PSNLKTR=$P(X,"^",3),PSNLKVDU=$P(X,"^",4)
        K PSNLKPMI I X]"" S PSNLKQQ=$P(^PSNDF(50.68,PSNLKGK,1),"^",5) D GCN
        K X
        Q
GCN     I PSNLKQQ']"" S PSNLKPMI="None" Q
        ;
GCN1    ;
        I $D(^PS(50.623,"B",PSNLKQQ)) S PSNLKMAP=$O(^PS(50.623,"B",PSNLKQQ,0)),PSNLKENG=$P(^PS(50.623,PSNLKMAP,0),"^",2),PSNLKPMI=$P(^PS(50.621,+PSNLKENG,0),"^") Q
        S PSNLKPMI="None"
        Q
DSPLY3  W ?50,"Transmit To CMOP: "
        I PSNLKTR=1 W "YES"
        I PSNLKTR=0 W "NO"
        Q
PRODF   ;
        S X=$$PROD0^PSNAPIS(PSNLKDAV,PSNLKGK)
        S PSNLKDF=+$P(X,"^",2),PSNLKSTR=$P(X,"^",3),PSNLKUN=+$P(X,"^",4),PSNLKFRM=$S($G(PSNLKDF):$P($G(^PS(50.606,PSNLKDF,0)),"^"),1:""),PSNLKUNT=$S($G(PSNLKUN):$P($G(^PS(50.607,PSNLKUN,0)),"^"),1:""),PSNLKNFN=$P(^PSNDF(50.68,PSNLKGK,0),"^",6)
        K X
        Q
ING     F PSNLKBB=0:0 S PSNLKBB=$O(^PSNDF(50.68,PSNLKGK,2,PSNLKBB)) Q:'PSNLKBB  D
        .I $D(^PSNDF(50.68,PSNLKGK,2,PSNLKBB,0)) S PSNLKAND=$G(^PSNDF(50.68,PSNLKGK,2,PSNLKBB,0)),PSNLKGR=$P(^PS(50.416,$P(PSNLKAND,"^",1),0),"^"),PSNLKIST=$P(PSNLKAND,"^",2),PSNLKIUT=$P(PSNLKAND,"^",3) K PSNLKIUN D ING1,IN2
        Q
IN2     W ?3,PSNLKGR,?50,"Str: ",PSNLKIST W:PSNLKIUT ?65,"Unt: ",$G(PSNLKIUN) W !
        Q
ING1    S:$P(^PS(50.416,$P(PSNLKAND,"^"),0),"^",2) PSNLKGR=$P($G(^PS(50.416,$P(^PS(50.416,$P(PSNLKAND,"^"),0),"^",2),0)),"^") I PSNLKIUT S PSNLKIUN=$P(^PS(50.607,PSNLKIUT,0),"^")
        Q
SC      I $O(^PSNDF(50.68,PSNLKGK,4,0)) W !,"Secondary Class(es): ",! F PSNLKCC=0:0 S PSNLKCC=$O(^PSNDF(50.68,PSNLKGK,4,PSNLKCC)) Q:'PSNLKCC  S PSNLKZ=$P($G(^PSNDF(50.68,PSNLKGK,4,PSNLKCC,0)),"^") I PSNLKZ D
        .S PSNLKSCL=$P($G(^PS(50.605,PSNLKZ,0)),"^") D SC1
        Q
SC1     W "   ",PSNLKSCL
        Q
SV      S PSNLKSEV=$G(^PSNDF(50.68,PSNLKGK,7)) I PSNLKSEV]"" S PSNLKCSF=$P(PSNLKSEV,"^"),PSNLKSP=$P(PSNLKSEV,"^",2) S:PSNLKSP="M" PSNLKSP="Multi" S:PSNLKSP="S" PSNLKSP="Single" D SV1
        Q
SV1     S PSNZZFSA=PSNLKGK_"," S PSNZZFS=$$GET1^DIQ(50.68,PSNZZFSA,19) I $G(PSNZZFS)="" S PSNZZFS="None"
        S PSNLKNND=$P(^PSNDF(50.68,PSNLKGK,7),"^",3)
        Q
DSP     W !,"Dosage Form: ",PSNLKFRM_$S('$G(PSNLKDF):"",$P($G(^PS(50.606,PSNLKDF,1)),"^")=1:"  (Exclude from Dosing Cks)",1:"")
        S PSNLKL1=$L(PSNLKSTR),PSNLKL2=$S($G(PSNLKUN):$L(PSNLKUNT),1:0)
        I (PSNLKL1+PSNLKL2)<62 W !,"Strength: ",PSNLKSTR W:$G(PSNLKUN) " Units: "_PSNLKUNT G PSDZZ
        W !,"Strength: ",PSNLKSTR
        I $G(PSNLKUN) D
        .W !,"Units: " I PSNLKL2<72 W PSNLKUNT Q
        .W !,PSNLKUNT
PSDZZ   ;
        W !,"National Formulary Name: ",PSNLKNFN,!,"VA Print Name: ",PSNLKVPN,!,"VA Product Identifier: ",PSNLKID D DSPLY3 W !,"VA Dispense Unit: ",PSNLKVDU I $D(PSNLKPMI) W !,"PMIS: ",PSNLKPMI
        W !,"Active Ingredients: ",!
        Q
DSP1    D HG W "Primary Drug Class: ",$P(^PS(50.605,PSNLKCL,0),"^") D SC W !,"CS Federal Schedule: ",$G(PSNLKCSF)_"  "_$G(PSNZZFS),!,"Single/Multi Source Product: ",$G(PSNLKSP)
        I $G(PSNLKNND)]"" W !,"Inactivation Date: " S Y=PSNLKNND D DD^%DT W Y K Y
        W !,"Max Single Dose: ",$P(PSNLKSEV,"^",4),?45,"Min Single Dose: ",$P(PSNLKSEV,"^",5)
        W !,"Max Daily Dose: ",$P(PSNLKSEV,"^",6),?45,"Min Daily Dose: ",$P(PSNLKSEV,"^",7),!,"Max Cumulative Dose: ",$P(PSNLKSEV,"^",8)
        W !,"National Formulary Indicator: " I $D(^PSNDF(50.68,PSNLKGK,5)) W:$P(^PSNDF(50.68,PSNLKGK,5),"^")=0 "No" W:$P(^PSNDF(50.68,PSNLKGK,5),"^")=1 "Yes"
        W !
        I $G(^PSNDF(50.68,PSNLKGK,8)) W !,"Exclude Drg-Drg Interaction Ck: Yes (No check for Drug-Drug Interactions)"
        D OVER
        W !
        Q
RESTN   I $O(^PSNDF(50.68,PSNLKGK,6,0)) W !,"Restriction: " F PSNLKRE=0:0 S PSNLKRE=$O(^PSNDF(50.68,PSNLKGK,6,PSNLKRE)) Q:'PSNLKRE  S PSNLKWRT=$G(^PSNDF(50.68,PSNLKGK,6,PSNLKRE,0)) W !,PSNLKWRT
        Q
HG      ;
        W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR
        W @IOF
        Q
MESS    ;
        W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR
        Q
        ;
OVER    ;
        W !,"Override DF Exclude from Dosage Checks: "_$S($P($G(^PSNDF(50.68,PSNLKGK,9)),"^")=1:"Yes",$P($G(^PSNDF(50.68,PSNLKGK,9)),"^")=0:"No",1:"") I $P($G(^PSNDF(50.68,PSNLKGK,9)),"^")=1 D
        .I '$G(PSNLKDF) Q
        .I '$D(^PS(50.606,PSNLKDF,0)) Q
        .I $P($G(^PS(50.606,PSNLKDF,1)),"^")=1 W " (Dosage Checks shall be performed)" Q
        .I $P($G(^PS(50.606,PSNLKDF,1)),"^")=0 W " (No Dosage Checks performed)"
        Q
