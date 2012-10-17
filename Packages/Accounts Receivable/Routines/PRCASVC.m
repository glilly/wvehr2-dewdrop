PRCASVC ;SF-ISC/YJK-ACCEPT, AMMEND AND CANCEL AR BILL ;9/6/95  2:09 PM
V       ;;4.5;Accounts Receivable;**1,21,48,90,136,138,249,274**;Mar 20, 1995;Build 5
        ;;Per VHA Directive 2004-038, this routine should not be modified.
REL     ;Accept bill into AR
        N X,Y
        D ^PRCASVC6 G:$D(PRCAERR) Q3 S PRCADEBT=$O(^RCD(340,"B",PRCASV("DEBTOR"),0)) I 'PRCADEBT K DD,DO S DIC="^RCD(340,",DIC(0)="QL",X=PRCASV("DEBTOR"),DLAYGO=340 D FILE^DICN K DIC,DLAYGO,DO Q:Y<0  S PRCADEBT=+Y
        D FY S PRCAT=$P(^PRCA(430.2,PRCASV("CAT"),0),"^",6) F Y="IDNO^4","GPNO^6","GPNM^5","INPA^1" S:$D(PRCASV($P(Y,"^"))) $P(^PRCA(430,PRCASV("ARREC"),202),"^",$P(Y,"^",2))=PRCASV($P(Y,"^"))
        S DIE="^PRCA(430,",DR="[PRCASV REL]",DA=PRCASV("ARREC") D ^DIE
Q3      K PRCAT,PRCAORA,PRCADEBT,DIE,DR,%
        ;  set the fund for the bill (set in routine rcxfmsuf)
        S:'$G(DA) DA=PRCASV("ARREC") S %=$$GETFUNDB^RCXFMSUF(DA)
        I "^27^28^"[("^"_PRCASV("CAT")_"^") D
        .N P
        .F P=6,8,10,15 S $P(^PRCA(430,DA,11),"^",P)=$S(P=6:1000,P=8:$G(PRCASV("SITE")),P=10:9,1:$P($G(PRCASV("FY")),"^"))
        .S $P(^PRCA(430,DA,11),"^",18,999)=""
        I PRCASV("CAT")=27 S $P(^PRCA(430,+PRCASV("ARREC"),0),"^",5)=$O(^PRCA(430.6,"B","CHMPV",0))
        I PRCASV("CAT")=29 S $P(^PRCA(430,DA,11),"^",18,999)=""
        ;
        ; prca*4.5*274 - for TRICARE claims, set the station# (field# 257) from the PRCASV("SITE") value
        I "^30^31^32^"[("^"_PRCASV("CAT")_"^") D
        .N RCCARE,P
        .S:'$G(PRCASV("SITE")) PRCASV("SITE")=$P($$SITE^VASITE,"^",3)
        .F P=8,9,10,15 S $P(^PRCA(430,DA,11),"^",P)=$S(P=8:$G(PRCASV("SITE")),P=9:1,P=10:"02",1:$P($G(PRCASV("FY")),"^"))
        .S $P(^PRCA(430,DA,11),"^",18)=""
        .S RCCARE=$$TYP^IBRFN(DA),RCCARE(1)=$S(RCCARE="I":8028,RCCARE="O":8029,1:8030),$P(^PRCA(430,DA,11),"^",6)=RCCARE(1)
        ;
        I $G(PRCASV("MEDCA"))!$G(PRCASV("MEDURE")) D MEDICARE
        K DA
        Q
        ;
        ;
FY      K:$D(^PRCA(430,PRCASV("ARREC"),2)) ^(2) S PRCAK1=1,PRCAORA=0,^PRCA(430,PRCASV("ARREC"),2,0)="^430.01IA^^"
        F J=1:1 S X=$P(PRCASV("FY"),U,PRCAK1),PRCAMT=+$P(PRCASV("FY"),U,PRCAK1+1) D FY1 S PRCAK1=PRCAK1+2 Q:$P(PRCASV("FY"),U,PRCAK1)=""
EXITFY  K PRCAK1,J,PRCAMT Q
FY1     S DA(1)=PRCASV("ARREC"),DIC="^PRCA(430,"_DA(1)_",2,",DIC(0)="QL",DLAYGO=430 D ^DIC K DIC,DLAYGO Q:Y<0  S DA=+Y
        S PRCAORA=PRCAORA+PRCAMT,$P(^PRCA(430,PRCASV("ARREC"),0),"^",3)=PRCAORA,$P(^(7),"^")=PRCAORA,$P(^(2,DA,0),U,2)=PRCAMT,$P(^(0),"^",8)=PRCAMT
        K DA Q
        ;
MEDICARE        ;Setup Medicare Supplemental amounts
        N DR,DIE
        I $G(PRCASV("MEDCA")) S DIE="^PRCA(430,",DR="131////"_PRCASV("MEDCA") D ^DIE
        I $G(PRCASV("MEDURE")) S DIE="^PRCA(430,",DR="132////"_PRCASV("MEDURE") D ^DIE
        K PRCASV("MEDCA"),PRCASV("MEDURE")
        Q  ;MEDICARE
        ;
