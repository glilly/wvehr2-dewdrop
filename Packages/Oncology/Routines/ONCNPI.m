ONCNPI  ;Hines OIFO/GWB - National Provider Identifier; 02/16/07
        ;;2.11;ONCOLOGY;**48**;Mar 07, 1995;Build 13
        ;
FNPI    ;Check for facility NPI (National Provider Identifier)
        I FACPNT="" G FEXIT
        S DATEDX=$$GET1^DIQ(165.5,D0,3,"I")
        I (DATEDX<3070000)&(DATEDX'="") G FEXIT
        S FAC=$P($G(^ONCO(160.19,FACPNT,0)),U,1)
        I (FAC="00000000")!(FAC=9999999) G FEXIT
        S NPI=$P($G(^ONCO(160.19,FACPNT,0)),U,6)
        I NPI="" D ADDFNPI
FEXIT   K NPI,FACIEN,FAC,FACPNT
        Q
        ;
ADDFNPI ;Enter facility NPI value
        W !
        W !,"  This facility needs to be associated with"
        W !,"  an NPI (National Provider Identifer) code."
        W !!
FNPIR   R "  NPI: ",NPI:60
        I (NPI="")!(NPI=U) W ! Q
        I NPI'?10N W !!,"The NPI number must be 10 digits.",!! G FNPIR
        I $D(^ONCO(160.19,"F",NPI)) D  G FNPIR
        .S FACIEN=$O(^ONCO(160.19,"F",NPI,0))
        .S FAC=$P(^ONCO(160.19,FACIEN,0),U,2)
        .W !!,"  This NPI number is already being used by ",FAC,".",!!
        S $P(^ONCO(160.19,FACPNT,0),U,6)=NPI
        S ^ONCO(160.19,"F",NPI,FACPNT)=""
        W !
        Q
        ;
FNPIIT  ;NPI (160.19,101) INPUT TRANSFORM
        I $D(^ONCO(160.19,"F",X)) D
        .S FACIEN=$O(^ONCO(160.19,"F",X,0))
        .I FACIEN'=DA D  K X
        ..S FAC=$P(^ONCO(160.19,FACIEN,0),U,2)
        ..W !!,"  This NPI code is already being used by ",FAC,".",!
        K FACIEN,FAC
        Q
        ;
PNPI    ;Check for physician NPI (National Provider Identifier)
        I PHYPNT="" G PEXIT
        S DATEDX=$$GET1^DIQ(165.5,D0,3,"I")
        I (DATEDX<3070000)&(DATEDX'="") G PEXIT
        S PHY=$P($G(^ONCO(165,PHYPNT,0)),U,1)
        I (PHY="00000000")!(PHY=88888888)!(PHY=99999999) G PEXIT
        S NPI=$P($G(^ONCO(165,PHYPNT,0)),U,5)
        I NPI="" D ADDPNPI
PEXIT   K NPI,FACIEN,FAC,FACPNT
        Q
        ;
ADDPNPI ;Enter physician NPI value
        W !
        W !,"  This physician needs to be associated with"
        W !,"  an NPI (National Provider Identifer) code."
        W !!
PNPIR   R "  NPI: ",NPI:60
        I (NPI="")!(NPI=U) W ! Q
        I NPI'?10N W !!,"The NPI number must be 10 digits.",!! G PNPIR
        I $D(^ONCO(165,"F",NPI)) D  G PNPIR
        .S PHYIEN=$O(^ONCO(165,"F",NPI,0))
        .S PHY=$P(^ONCO(165,PHYIEN,0),U,1)
        .W !!,"  This NPI number is already being used by ",PHY,".",!!
        S $P(^ONCO(165,PHYPNT,0),U,5)=NPI
        S ^ONCO(165,"F",NPI,PHYPNT)=""
        W !
        Q
        ;
PNPIIT  ;NPI (165,101) INPUT TRANSFORM
        I $D(^ONCO(165,"F",X)) D
        .S PHYIEN=$O(^ONCO(165,"F",X,0))
        .I PHYIEN'=DA D  K X
        ..S PHY=$P(^ONCO(165,PHYIEN,0),U,1)
        ..W !!,"  This NPI code is already being used by ",PHY,".",!
        K PHYIEN,PHY
        Q
