ONCCS2  ;Hines OIFO/GWB - Collaborative Staging v2 Stuffing ;06/23/10
        ;;2.11;ONCOLOGY;**51**;Mar 07, 1995;Build 65
        ;
        S SCHEMA="Unable to compute schema"
        Q:$G(TOP)=""
        N DISCRIM,HIST,MO,SCHNAME,SITE
        S MO=$$HIST^ONCFUNC(D0)
        S SITE=$TR($$GET1^DIQ(164,TOP,1,"I"),".","")
        S HIST=$E(MO,1,4)
        S DISCRIM=$$GET1^DIQ(165.5,D0,240)
        S SCHEMA=+$$SCHEMA^ONCSAPIS(.ONCSAPI,SITE,HIST,DISCRIM)
        Q:SCHEMA<0
        S SCHEMA=SCHNAME
        ;
        I $G(SCHEMA)="AdnexaUterineOther" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EVAL
        ;
        I $G(SCHEMA)="AdrenalGland" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,5)="" 1
        .D 4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="AmpullaVater" D  Q
        .D 4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Anus" D  Q
        .D 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Appendix" D  Q
        .D 5,6,8,9,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="BileDuctsDistal" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,15,16,17,18,19,20,21,22,23,24
        ;
        I $G(SCHEMA)="BileDuctsIntraHepat" D  Q
        .D 4,5,6,7,8,9,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="BileDuctsPerihilar" D  Q
        .D 1,2,3,4,5,6,7,8,9,15,16,17,18,19,20,21,22,23,24
        ;
        I $G(SCHEMA)="BiliaryOther" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Bladder" D  Q
        .D 4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Bone" D  Q
        .D 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Brain" D  Q
        .D 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EVAL,LN
        ;
        I $G(SCHEMA)="Breast" D  Q
        .D 25
        ;
        I $G(SCHEMA)="BuccalMucosa" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="CarcinoidAppendix" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,5)="" 1
        .D 3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Cervix" D  Q
        .D 10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="CNSOther" D  Q
        .D 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EVAL,LN
        ;
        I $G(SCHEMA)="Colon" D  Q
        .D 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Conjunctiva" D  Q
        .D 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D:$P($G(^ONCO(165.5,D0,"CS1")),U,10)="" TS
        ;
        I $G(SCHEMA)="CorpusAdenosarcoma" D  Q
        .D 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="CorpusCarcinoma" D  Q
        .D 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="CorpusSarcoma" D  Q
        .D 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="CysticDuct" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
        ;
        I $G(SCHEMA)="DigestiveOther" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EVAL
        ;
        I $G(SCHEMA)="EndocrineOther" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,5)="" 1
        .D 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EVAL
        ;
        I $G(SCHEMA)="EpiglottisAnterior" D  Q
        .D 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Esophagus" D  Q
        .D 6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="EsophagusGEJunction" D  Q
        .D 2,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
        ;
        I $G(SCHEMA)="EyeOther" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EVAL
        ;
        I $G(SCHEMA)="FallopianTube" D  Q
        .D 8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="FloorMouth" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Gallbladder" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GenitalFemaleOther" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EVAL
        ;
        I $G(SCHEMA)="GenitalMaleOther" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EVAL
        ;
        I $G(SCHEMA)="GISTAppendix" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,5)="" 1
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 3,4,5,6,7,8,9,10,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GISTColon" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,5)="" 1
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 3,4,5,6,7,8,9,10,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GISTEsophagus" D  Q
        .D 1,2,3,4,5,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GISTPeritoneum" D  Q
        .D 1,2,3,4,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GISTRectum" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,5)="" 1
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 3,4,5,6,7,8,9,10,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GISTSmallIntestine" D  Q
        .D 1,2,3,4,5,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GISTStomach" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,5)="" 1
        .D 2,3,4,5,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GumLower" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GumOther" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="GumUpper" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="HeartMediastinum" D  Q
        .D 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="HemeRetic" D  Q
        .D 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D TS,EVAL,LN,METS
        ;
        I $G(SCHEMA)="Hypopharynx" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="IllDefinedOther" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EXT,EVAL,LN,METS
        ;
        I $G(SCHEMA)="IntracranialGland" D  Q
        .D 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D EVAL
        ;
        I $G(SCHEMA)="KaposiSarcoma" D  Q
        .D 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D TS,EVAL
        ;
        I $G(SCHEMA)="KidneyParenchyma" D  Q
        .D 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="KidneyRenalPelvis" D  Q
        .D 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="LacrimalGland" D  Q
        .D 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
        ;
        I $G(SCHEMA)="LacrimalSac" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
        ;
        I $G(SCHEMA)="LarynxGlottic" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="LarynxOther" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="LarynxSubglottic" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="LarynxSupraglottic" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="LipLower" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="LipOther" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="LipUpper" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Liver" D  Q
        .D 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Lung" D  Q
        .D 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="Lymphoma" D  Q
        .D 6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        .D TS,EVAL1,LN,METS
        ;
        I $G(SCHEMA)="LymphomaOcularAdnexa" D  Q
        .D 14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="MelanomaBuccalMucosa" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="MelanomaChoroid" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,5)="" 1
        .D 15,16,17,18,19,20,21,22,23,24,25
        .D:$P($G(^ONCO(165.5,D0,"CS1")),U,10)="" TS
        ;
        I $G(SCHEMA)="MelanomaCiliaryBody" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,5)="" 1
        .D 15,16,17,18,19,20,21,22,23,24
        .D:$P($G(^ONCO(165.5,D0,"CS1")),U,10)="" TS
        ;
        I $G(SCHEMA)="MelanomaConjunctiva" D  Q
        .D 4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="MelanomaEpiglottisAnterior" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="MelanomaEyeOther" D  Q
        .D 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="MelanomaFloorMouth" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="MelanomaGumLower" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="MelanomaGumOther" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="MelanomaGumUpper" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        I $G(SCHEMA)="MelanomaHypopharynx" D  Q
        .D:$P($G(^ONCO(165.5,D0,"CS")),U,6)="" 2
        .D 12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ;
        D ^ONCCS3
        Q
        ;
1       ;SSF1 = 988
        S $P(^ONCO(165.5,D0,"CS"),U,5)=988
        Q
        ;
2       ;SSF2 = 988
        S $P(^ONCO(165.5,D0,"CS"),U,6)=988
        Q
        ;
3       ;SSF3 = 988
        S $P(^ONCO(165.5,D0,"CS"),U,7)=988
        Q
        ;
4       ;SSF4 = 988
        S $P(^ONCO(165.5,D0,"CS"),U,8)=988
        Q
        ;
5       ;SSF5 = 988
        S $P(^ONCO(165.5,D0,"CS"),U,9)=988
        Q
        ;
6       ;SSF6 = 988
        S $P(^ONCO(165.5,D0,"CS"),U,10)=988
        Q
        ;
7       ;SSF7 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,1)=988
        Q
        ;
8       ;SSF8 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,2)=988
        Q
        ;
9       ;SSF9 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,3)=988
        Q
        ;
10      ;SSF10 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,4)=988
        Q
        ;
11      ;SSF11 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,5)=988
        Q
        ;
12      ;SSF12 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,6)=988
        Q
        ;
13      ;SSF13 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,7)=988
        Q
        ;
14      ;SSF14 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,8)=988
        Q
        ;
15      ;SSF15 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,9)=988
        Q
        ;
16      ;SSF16 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,10)=988
        Q
        ;
17      ;SSF17 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,11)=988
        Q
        ;
18      ;SSF18 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,12)=988
        Q
        ;
19      ;SSF19 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,13)=988
        Q
        ;
20      ;SSF20 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,14)=988
        Q
        ;
21      ;SSF21 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,15)=988
        Q
        ;
22      ;SSF22 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,16)=988
        Q
        ;
23      ;SSF23 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,17)=988
        Q
        ;
24      ;SSF24 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,18)=988
        Q
        ;
25      ;SSF25 = 988
        S $P(^ONCO(165.5,D0,"CS2"),U,19)=988
        Q
        ;
TS      ;TUMOR SIZE (CS) = 988
        S $P(^ONCO(165.5,D0,"CS1"),U,10)=988
        Q
        ;
EXT     ;EXTENSION (CS) = 988
        S $P(^ONCO(165.5,D0,"CS"),U,11)=988
        Q
        ;
EVAL    ;TUMOR SIZE/EXT EVAL (CS) = 9
        ;LYMPH NODES EVAL (CS) = 9
        ;METS EVAL (CS) = 9
        S $P(^ONCO(165.5,D0,"CS"),U,1)=9
        S $P(^ONCO(165.5,D0,"CS"),U,2)=9
        S $P(^ONCO(165.5,D0,"CS"),U,4)=9
        Q
        ;
EVAL1   ;LYMPH NODES EVAL (CS) = 9
        ;METS EVAL (CS) = 9
        S $P(^ONCO(165.5,D0,"CS"),U,2)=9
        S $P(^ONCO(165.5,D0,"CS"),U,4)=9
        Q
        ;
EVAL2   ;LYMPH NODES EVAL (CS) = 9
        S $P(^ONCO(165.5,D0,"CS"),U,2)=9
        Q
        ;
LN      ;LYMPH NODES (CS) = 988
        ;REGIONAL LYMPH NODES EXAMINED = 99
        ;REGIONAL LYMPH NODES POSITIVE = 99
        S $P(^ONCO(165.5,D0,"CS"),U,12)=988
        S $P(^ONCO(165.5,D0,2),U,12)=99
        S $P(^ONCO(165.5,D0,2),U,13)=99
        Q
        ;
METS    ;METS AT DX (CS) = 98
        S $P(^ONCO(165.5,D0,"CS"),U,3)=98
        Q
        ;
CLEANUP ;Cleanup
        K D0,ONCSAPI,SCHEMA,TOP
