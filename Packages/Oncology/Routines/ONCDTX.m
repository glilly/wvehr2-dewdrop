ONCDTX  ;Hines OIFO/GWB - Delete treatment data ;06/23/10
        ;;2.11;ONCOLOGY;**13,15,19,22,25,27,36,42,44,45,51**;Mar 07, 1995;Build 65
        ;
DEL     ;Delete all First Course of Treatment data
        I '$D(DATEDX) Q
        ;
        ;DATE FIRST SURGICAL PROCEDURE (165.5,170)
        N TXDT
        S TXDT=$P(^ONCO(165.5,DA,3.1),U,38)_"S0"
        S $P(^ONCO(165.5,DA,3.1),U,38)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        ;
        S $P(^ONCO(165.5,DA,3),U,38)="" D SURR
        S $P(^ONCO(165.5,DA,3.1),U,29)="" D SUR
        S $P(^ONCO(165.5,DA,3),U,40)="" D SCOPER
        S $P(^ONCO(165.5,DA,3.1),U,31)="" D SCOPE
        S $P(^ONCO(165.5,DA,3),U,41)="" D SOSNR
        S $P(^ONCO(165.5,DA,3.1),U,33)="" D SOSN
        S $P(^ONCO(165.5,DA,3),U,33)=""
        S $P(^ONCO(165.5,DA,3),U,6)="" D RAD
        S $P(^ONCO(165.5,DA,3),U,35)=""
        S $P(^ONCO(165.5,DA,3),U,13)="" D CHE
        S $P(^ONCO(165.5,DA,3),U,16)="" D HOR
        S $P(^ONCO(165.5,DA,3),U,19)="" D IMM
        S $P(^ONCO(165.5,DA,3.1),U,36)="" D HTEP
        S $P(^ONCO(165.5,DA,3.1),U,39)=""
        S $P(^ONCO(165.5,DA,3),U,25)="" D OTH
        S $P(^ONCO(165.5,DA,7),U,19)=""
        D DELATF^ONCDTX1
        K NTDEL
        Q
        ;
SURR    ;SURGERY OF PRIMARY (R) (165.5,58.2)
        Q:$P(^ONCO(165.5,DA,3),U,38)'=""
        S $P(^ONCO(165.5,DA,3),U,34)=""
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  SURGERY OF PRIMARY (R)"
        W !,"  SURGICAL APPROACH (R)"
        N COC,DSATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DSATF=1,$P(^ONCO(165.5,D0,3.1),U,7)=""
        D SPSATFR^ONCDTX1
        Q
        ;
SUR     ;SURGERY OF PRIMARY (F) (165.5,58.6)
        Q:$P(^ONCO(165.5,DA,3.1),U,29)'=""
        S TXDT=$P(^ONCO(165.5,DA,3),U,1)_"S1"
        S $P(^ONCO(165.5,DA,3),U,1)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        K TXDT
        S $P(^ONCO(165.5,DA,2.3),U,4)=""
        S $P(^ONCO(165.5,DA,3),U,28)=""
        S $P(^ONCO(165.5,DA,"THY1"),U,36)=""
        S $P(^ONCO(165.5,DA,3.1),U,28)=""
        S $P(^ONCO(165.5,DA,3),U,26)=""
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  SURGERY OF PRIMARY (F)"
        W !,"  MOST DEFINITIVE SURG DATE"
        W !,"  APPROACH"
        W !,"  SURGICAL MARGINS"
        W !,"  DATE OF SURGICAL DISCHARGE"
        W !,"  READMISSION W/I 30 DAYS/SURG"
        W !,"  REASON NO SURGERY OF PRIMARY"
        N COC,DSATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DSATF=1,$P(^ONCO(165.5,D0,3.1),U,30)=""
        D SPSATF^ONCDTX1
        Q
        ;
SCOPER  ;SCOPE OF LN SURGERY (R) (165.5,138)
        Q:$P(^ONCO(165.5,DA,3),U,40)'=""
        S $P(^ONCO(165.5,DA,3),U,42)=""
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  SCOPE OF LN SURGERY (R)"
        W !,"  NUMBER OF LN REMOVED (R)"
        N COC,DSCATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DSCATF=1,$P(^ONCO(165.5,D0,3.1),U,9)=""
        D SCPATFR^ONCDTX1
        Q
        ;
SCOPE   ;SCOPE OF LN SURGERY (F) (165.5,138.4)
        Q:$P(^ONCO(165.5,DA,3.1),U,31)'=""
        S TXDT=$P($G(^ONCO(165.5,DA,3.1)),U,22)_"S2"
        S $P(^ONCO(165.5,DA,3.1),U,22)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        K TXDT
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  SCOPE OF LN SURGERY (F)"
        W !,"  SCOPE OF LN SURGERY DATE"
        N COC,DSCATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DSCATF=1,$P(^ONCO(165.5,D0,3.1),U,32)=""
        D SCPATF^ONCDTX1
        Q
        ;
SOSNR   ;SURG PROC/OTHER SITE (R) (165.5,139)
        Q:$P(^ONCO(165.5,DA,3),U,41)'=""
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  SURG PROC/OTHER SITE (R)"
        N COC,DSOATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DSOATF=1,$P(^ONCO(165.5,D0,3.1),U,10)=""
        D SOSATFR^ONCDTX1
        Q
        ;
SOSN    ;SURG PROC/OTHER SITE (F) (165.5,139.4)
        Q:$P(^ONCO(165.5,DA,3.1),U,33)'=""
        S TXDT=$P($G(^ONCO(165.5,DA,3.1)),U,24)_"S3"
        S $P(^ONCO(165.5,DA,3.1),U,24)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        K TXDT
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  SURG PROC/OTHER SITE (F)"
        W !,"  SURG PROC/OTHER SITE DATE"
        N COC,DSOATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DSOATF=1,$P(^ONCO(165.5,D0,3.1),U,34)=""
        D SOSNATF^ONCDTX1
        Q
        ;
RAD     ;RADIATON (165.5,51.2)
        Q:$P(^ONCO(165.5,DA,3),U,6)'=""
        S TXDT=$P(^ONCO(165.5,DA,3),U,4)_"R"
        S $P(^ONCO(165.5,DA,3),U,4)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        K TXDT
        S $P(^ONCO(165.5,DA,3),U,22)=""
        S $P(^ONCO(165.5,DA,3),U,21)=""
        S $P(^ONCO(165.5,DA,"BLA2"),U,18)=""
        S $P(^ONCO(165.5,DA,"THY1"),U,43)=""
        S $P(^ONCO(165.5,DA,24),U,9)=""
        S $P(^ONCO(165.5,DA,"THY1"),U,44)=""
        S $P(^ONCO(165.5,DA,3),U,20)=""
        S $P(^ONCO(165.5,DA,3),U,7)=""
        S $P(^ONCO(165.5,DA,"BLA2"),U,16)=""
        S $P(^ONCO(165.5,DA,3),U,35)=""
        K ^ONCO(165.5,DA,15)
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  RADIATION"
        W !,"  DATE RADIATION STARTED"
        W !,"  LOCATION OF RADIATION TX"
        W !,"  RADIATION TREATMENT VOLUME"
        W !,"  REGIONAL TREATMENT MODALITY"
        W !,"  REGIONAL DOSE:cGy"
        W !,"  BOOST TREATMENT MODALITY"
        W !,"  BOOST DOSE:cGy"
        W !,"  NUMBER OF TXS TO THIS VOLUME"
        W !,"  RADIATION/SURGERY SEQUENCE"
        W !,"  DATE RADIATION ENDED"
        W !,"  REASON FOR NO RADIATION"
        W !,"  RX TEXT-RADIATION"
        N COC,DRATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DRATF=1,$P(^ONCO(165.5,D0,3.1),U,12)=""
        D RADATF^ONCDTX1
        Q
        ;
CHE     ;CHEMOTHERAPY (165.5,53.2)
        Q:$P(^ONCO(165.5,DA,3),U,13)'=""
        S TXDT=$P(^ONCO(165.5,DA,3),U,11)_"C"
        S $P(^ONCO(165.5,DA,3),U,11)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        K TXDT
        K ^ONCO(165.5,DA,17)
        S $P(^ONCO(165.5,DA,3),U,36)=""
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  CHEMOTHERAPY"
        W !,"  CHEMOTHERAPY DATE"
        W !,"  RX TEXT-CHEMO"
        N COC,DCATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DCATF=1,$P(^ONCO(165.5,D0,3.1),U,14)=""
        D CHEMATF^ONCDTX1
        Q
        ;
HOR     ;HORMONE THERAPY (165.5,54.2)
        Q:$P(^ONCO(165.5,DA,3),U,16)'=""
        S TXDT=$P(^ONCO(165.5,DA,3),U,14)_"H"
        S $P(^ONCO(165.5,DA,3),U,14)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        K TXDT
        K ^ONCO(165.5,DA,18)
        S $P(^ONCO(165.5,DA,3),U,37)=""
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  HORMONE THERAPY"
        W !,"  HORMONE THERAPY DATE"
        W !,"  RX TEXT-HORMONE"
        N COC,DHATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DHATF=1,$P(^ONCO(165.5,D0,3.1),U,16)=""
        D HORATF^ONCDTX1
        Q
        ;
IMM     ;IMMUNOTHERAPY (165.5,55.2)
        Q:$P(^ONCO(165.5,DA,3),U,19)'=""
        S TXDT=$P(^ONCO(165.5,DA,3),U,17)_"B"
        S $P(^ONCO(165.5,DA,3),U,17)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        K TXDT
        K ^ONCO(165.5,DA,20)
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  IMMUNOTHERAPY"
        W !,"  IMMUNOTHERAPY DATE"
        W !,"  RX TEXT-BRM"
        N COC,DIATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DIATF=1,$P(^ONCO(165.5,D0,3.1),U,18)=""
        D IMMATF^ONCDTX1
        Q
        ;
HTEP    ;HEMA TRANS/ENDOCRINE PROC (165.5,53)
        Q:$P(^ONCO(165.5,DA,3.1),U,36)'=""
        S TXDT=$P(^ONCO(165.5,DA,3.1),U,35)_"E"
        S $P(^ONCO(165.5,DA,3.1),U,35)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        K TXDT
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  HEMA TRANS/ENDOCRINE PROC"
        W !,"  HEMA TRANS/ENDOCRINE PROC DATE"
        Q
        ;
OTH     ;OTHER TREATMENT (165.5,57.2)
        Q:$P(^ONCO(165.5,DA,3),U,25)'=""
        S TXDT=$P(^ONCO(165.5,DA,3),U,23)_"O"
        S $P(^ONCO(165.5,DA,3),U,23)=""
        K ^ONCO(165.5,"ATX",DA,TXDT)
        K TXDT
        K ^ONCO(165.5,DA,21)
        I $D(NTDEL) Q
        W !!,"Deleting data from the following fields...",!
        W !,"  OTHER TREATMENT"
        W !,"  OTHER TREATMENT START DATE"
        W !,"  RX TEXT-OTHER"
        N COC,DOATF
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        S DOATF=1,$P(^ONCO(165.5,D0,3.1),U,20)=""
        D OTHATF^ONCDTX1
        Q
        ;
PP      ;PALLIATIVE CARE (165.5,12)
        Q:$P(^ONCO(165.5,DA,3.1),U,26)'=""
        N COC
        D CHKCOC^ONCATF
        I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) Q
        W !!,"Deleting data from the following fields...",!
        S $P(^ONCO(165.5,DA,3.1),U,27)=""
        W !,"  PALLIATIVE CARE @FAC",!
        Q
        ;
NCDS    ;SURGICAL DX/STAGING PROC (165.5,58.1)
        Q:$P(^ONCO(165.5,DA,3),U,27)'=""
        S $P(^ONCO(165.5,DA,3),U,31)=""
        W !!,"Deleting data from the following fields...",!
        W !," SURGICAL DX/STAGING PROC"
        W !," SURGICAL DX/STAGING PROC DATE"
        N COC,DNCATF
        D CHKCOC^ONCATF
        I (COC=20)!(COC=21)!(COC=22)!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=36)!(COC=37) Q
        S DNCATF=1,$P(^ONCO(165.5,D0,3.1),U,5)=""
        D NCDSATF^ONCDTX1
        Q
        ;
SCT     ;SUBSEQUENT COURSE OF TREATMENT (165.5,60)
        Q:$P(^ONCO(165.5,DA(1),4,DA,0),U,4)'=""
        S $P(^ONCO(165.5,DA(1),4,DA,0),U,11)=""
        W !!,"Deleting data from the following fields...",!
        W !,"  SURGERY OF PRIMARY SITE"
        W !,"  SURGERY OF PRIMARY SITE DATE",!
        Q
        ;
CLEANUP ;Cleanup
        K D0,DA,DATEDX
