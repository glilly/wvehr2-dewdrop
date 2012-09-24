ONCATF1 ;Hines OIFO/RTK - Treatment AT THIS FACILITY stuffing (cont.); 06/23/10
        ;;2.11;ONCOLOGY;**19,22,25,36,37,41,42,51**;Mar 07, 1995;Build 65
        ;
RAD     ;Radiation @fac
        N COC
        S RAUP=1 D RFNR^ONCATF1
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,12)=$P($G(^ONCO(165.5,D0,3)),U,6)
        Q
        ;
RADDT   ;Radiation @fac date
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,13)=$P($G(^ONCO(165.5,D0,3)),U,4)
        Q
        ;
DSPRAD  ;Display Radiation @fac fields
        N COC
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@411" Q
        .S NTX=1 W ! D RADATF^ONCNTX1 K NTX
        .I $G(DRATF)=1 K DRATF,TXNUL Q
        I $G(DRATF)=1 K DRATF,TXNUL S Y="@411" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D RADATF^ONCNTX1 K NTX,TXNO S Y="@411" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D RADATF^ONCUTX1 K NTX,TXUNK S Y="@411" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@411" Q
        N DI,DIC,DA,DR,DIQ,ONC
        S DIC="^ONCO(165.5,",DA=D0,DIQ="ONC(",DIQ(0)="E",DR="51.4;51.5"
        D EN^DIQ1
        W !!,$P(^DD(165.5,51.4,0),U,1),"............: "_$E(ONC(165.5,DA,51.4,"E"),1,47)
        W !,$P(^DD(165.5,51.5,0),U,1),".......: "_ONC(165.5,DA,51.5,"E")
        K TXNO,TXUNK,TXNUL S Y="@411" Q
        ;
CHEM    ;Chemotherapy @fac
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,14)=$P($G(^ONCO(165.5,D0,3)),U,13)
        Q
        ;
CHEMDT  ;Chemotherapy @fac date
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,15)=$P($G(^ONCO(165.5,D0,3)),U,11)
        Q
        ;
DSPCHEM ;Display Chemotherapy @fac fields
        N COC
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@415" Q
        .S NTX=1 W ! D CHEMATF^ONCNTX1 K NTX
        .I $G(DCATF)=1 K DCATF,TXNUL Q
        I $G(DCATF)=1 K DCATF,TXNUL S Y="@415" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D CHEMATF^ONCNTX1 K NTX,TXNO S Y="@415" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D CHEMATF^ONCUTX1 K NTX,TXUNK S Y="@415" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@415" Q
        K DIQ,ONC
        S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E",DR="53.3;53.4"
        D EN^DIQ1
        W !!,$P(^DD(165.5,53.3,0),U,1),"........: "_$E(ONC(165.5,DA,53.3,"E"),1,47)
        W !,$P(^DD(165.5,53.4,0),U,1),"...: "_ONC(165.5,DA,53.4,"E")
        K TXNO,TXUNK,TXNUL S Y="@415" Q
        ;
HT      ;Hormone therapy @fac
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,16)=$P($G(^ONCO(165.5,D0,3)),U,16)
        Q
        ;
HTDT    ;Hormone therapy @fac date
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,17)=$P($G(^ONCO(165.5,D0,3)),U,14)
        Q
        ;
DSPHT   ;Display Hormone Therapy @fac fields
        N COC
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@418" Q
        .S NTX=1 W ! D HTATF^ONCNTX1 K NTX
        .I $G(DHATF)=1 K DHATF,TXNUL Q
        I $G(DHATF)=1 K DHATF,TXNUL S Y="@418" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D HTATF^ONCNTX1 K NTX,TXNO S Y="@418" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D HTATF^ONCUTX1 K NTX,TXUNK S Y="@418" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@418" Q
        K DIQ,ONC
        S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E",DR="54.3;54.4"
        D EN^DIQ1
        W !!,$P(^DD(165.5,54.3,0),U,1),".....: "_$E(ONC(165.5,DA,54.3,"E"),1,47)
        W !,$P(^DD(165.5,54.4,0),U,1),": "_ONC(165.5,DA,54.4,"E")
        K TXNO,TXUNK,TXNUL S Y="@418"
        Q
        ;
IMM     ;Immunotherapy @fac
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,18)=$P($G(^ONCO(165.5,D0,3)),U,19)
        Q
        ;
IMMDT   ;Immunotherapy @fac date
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,19)=$P($G(^ONCO(165.5,D0,3)),U,17)
        Q
        ;
DSPIMM  ;Display Immunotherapy @fac fields
        N COC
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@421" Q
        .S NTX=1 W ! D IMMATF^ONCNTX1 K NTX
        .I $G(DIATF)=1 K DIATF,TXNUL Q
        I $G(DIATF)=1 K DIATF,TXNUL S Y="@421" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D IMMATF^ONCNTX1 K NTX,TXNO S Y="@421" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D IMMATF^ONCUTX1 K NTX,TXUNK S Y="@421" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@421" Q
        K DIQ,ONC
        S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E",DR="55.3;55.4"
        D EN^DIQ1
        W !!,$P(^DD(165.5,55.3,0),U,1),".......: "_ONC(165.5,DA,55.3,"E")
        W !,$P(^DD(165.5,55.4,0),U,1),"..: "_ONC(165.5,DA,55.4,"E")
        K TXNO,TXUNK,TXNUL S Y="@421" Q
        ;
OTH     ;Other therapy @fac
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,20)=$P($G(^ONCO(165.5,D0,3)),U,25)
        Q
        ;
OTHDT   ;Other therapy @fac date
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,21)=$P($G(^ONCO(165.5,D0,3)),U,23)
        Q
        ;
DSPOTH  ;Display Other Treatment @fac fields
        N COC
        D CHKCOC I (COC="00")!(COC=30)!(COC=31)!(COC=32)!(COC=33)!(COC=40)!(COC=41) D  K TXNO,TXUNK,TXNUL S Y="@424" Q
        .S NTX=1 W ! D OTHATF^ONCNTX1 K NTX
        .I $G(DOATF)=1 K DOATF,TXNUL Q
        I $G(DOATF)=1 K DOATF,TXNUL S Y="@424" Q
        I COC'=37 D  Q
        .I $G(TXNO)=1 S NTX=1 W ! D OTHATF^ONCNTX1 K NTX,TXNO S Y="@424" Q
        .I $G(TXUNK)=1 S NTX=1 W ! D OTHATF^ONCUTX1 K NTX,TXUNK S Y="@424" Q
        .I $G(TXNUL)=1 K TXNUL S Y="@424" Q
        K DIQ,ONC
        S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E",DR="57.3;57.4"
        D EN^DIQ1
        W !!,$P(^DD(165.5,57.3,0),U,1),".....: "_$E(ONC(165.5,DA,57.3,"E"),1,47)
        W !,$P(^DD(165.5,57.4,0),U,1),": "_ONC(165.5,DA,57.4,"E")
        K TXNO,TXUNK,TXNUL S Y="@424" Q
        ;
PP      ;Palliative Procedure @fac
        N COC
        D CHKCOC I COC'=37 Q
        S $P(^ONCO(165.5,D0,3.1),U,27)=$P($G(^ONCO(165.5,D0,3.1)),U,26)
        Q
        ;
CHKCOC  ;CLASS OF CASE
        S COC=$E($$GET1^DIQ(165.5,DA,.04),1,2)
        Q
        ;
RFNS    ;If SURGERY OF PRIMARY (F) (165.5,58.6) and SURGERY OF PRIMARY @FAC (F)
        ;(165.5,58.7) are anything but 00 or 99, set REASON NO SURGERY OF
        ;PRIMARY (165.5,58) to 0 (Surgery performed)
        N FLAG1,FLAG2,SGRP,SPS,SPSATF,TPX
        S (FLAG1,FLAG2)=1
        S SPS=$P($G(^ONCO(165.5,D0,3.1)),U,29) I SPS="" S FLAG1=0
        S SPSATF=$P($G(^ONCO(165.5,D0,3.1)),U,30) I SPSATF="" S FLAG2=0
        S TPX=$P($G(^ONCO(165.5,D0,2)),U,1) I TPX="" W !!,"PRIMARY SITE is not defined" H 3 S Y="@0" Q
        S SGRP=$P($G(^ONCO(164,TPX,0)),U,16)
        I SPS'="" I (SPS=1)!(SPS="00")!($G(^ONCO(164,SGRP,"SPS",SPS,0))[99) S FLAG1=0
        I SPSATF'="" I (SPSATF=1)!(SPSATF="00")!($G(^ONCO(164,SGRP,"SPS",SPSATF,0))[99) S FLAG2=0
        I FLAG1=0,FLAG2=0 Q
        S $P(^ONCO(165.5,D0,3),U,26)=0
        I $G(SUUP)=1 K SUUP Q
        W !,$P($G(^DD(165.5,58,0)),U,1)_"...: Surgery performed"
        S Y="@431" Q
        ;
RFNR    ;If RADIATION, set REASON FOR NO RADIATION = 0 (Radiation administered)
        N RDTX,RDTXATF
        S RDTX=$P($G(^ONCO(165.5,D0,3)),U,6)
        S RDTXATF=$P($G(^ONCO(165.5,D0,3.1)),U,12)
        I ((RDTX="")!(RDTX=0)!(RDTX=9))&((RDTXATF="")!(RDTXATF=0)!(RDTXATF=9)) Q
        S $P(^ONCO(165.5,D0,3),U,35)=0
        I $G(RAUP)=1 K RAUP Q
        W !,$P($G(^DD(165.5,75,0)),U,1)_"........: Radiation administered"
        S Y="@412" Q
        Q
        ;
CLEANUP ;Cleanup
        K D0,Y
