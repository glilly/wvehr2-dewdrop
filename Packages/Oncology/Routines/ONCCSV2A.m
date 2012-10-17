ONCCSV2A        ;Hines OIFO/GWB - Collaborative Staging v2 Conversion ;06/23/10
        ;;2.11;ONCOLOGY;**51**;Mar 07, 1995;Build 65
        ;
        N EXT,LN,METS,SD,TS,HST,HST14,QUIT,S34,PS
        N SSF1,SSF2,SSF3,SSF4,SSF5,SSF6
        S PS=$P($G(^ONCO(165.5,IEN,2)),U,1)
        S HST=$$HIST^ONCFUNC(IEN)
        S HST14=$E(HST,1,4)
        S TS=$P($G(^ONCO(165.5,IEN,"CS1")),U,10)
        S EXT=$P($G(^ONCO(165.5,IEN,"CS")),U,11)
        S LN=$P($G(^ONCO(165.5,IEN,"CS")),U,12)
        S METS=$P($G(^ONCO(165.5,IEN,"CS")),U,3)
        S SSF1=$P($G(^ONCO(165.5,IEN,"CS")),U,5)
        S SSF2=$P($G(^ONCO(165.5,IEN,"CS")),U,6)
        S SSF3=$P($G(^ONCO(165.5,IEN,"CS")),U,7)
        S SSF4=$P($G(^ONCO(165.5,IEN,"CS")),U,8)
        S SSF5=$P($G(^ONCO(165.5,IEN,"CS")),U,9)
        S SSF6=$P($G(^ONCO(165.5,IEN,"CS")),U,10)
        S SD=$P($G(^ONCO(165.5,IEN,"CS3")),U,1)
        ;
        ;AdrenalGland C74.0-C74.1, C74.9
        I $E(PS,3,4)=74 D  Q
        .D 2,3,4,5,6
        ;
        ;Appendix C18.1
        ;CarcinoidAppendix C18.1 (M-8153, 8240-8242, 8246, 8249) 
        ;GISTAppendix C18.1 (M-8935-8936) 
        I (PS=67181) D  Q
        .D
        ..I (HST14=8153)!((HST14>8239)&(HST14<8243))!(HST14=8246)!(HST14=8249) Q
        ..I (HST14=8935)!(HST14=8936) Q
        ..S:SSF1="080" $P(^ONCO(165.5,IEN,"CS"),U,5)=997
        .D 2,3,4,5,6
        ;
        ;BileDuctsIntraHepat C22.0, C22.1
        ;Liver C22.0, C22.1
        I (PS=67220)!(PS=67221) D  Q
        .I (PS=67220)&((HST14>7999)&(HST14<8158)!(HST14>8161)&(HST14<8176)!(HST14>8189)&(HST14<9137)!(HST14>9140)&(HST14<9583)!(HST14=9700)!(HST14=9701)) D
        ..S:EXT=200 $P(^ONCO(165.5,IEN,"CS"),U,11)=350
        ..S:EXT=300 $P(^ONCO(165.5,IEN,"CS"),U,11)=390
        ..S:EXT=500 $P(^ONCO(165.5,IEN,"CS"),U,11)=170
        ..S:EXT=510 $P(^ONCO(165.5,IEN,"CS"),U,11)=150
        ..S:EXT=520 $P(^ONCO(165.5,IEN,"CS"),U,11)=370
        ..S:EXT=530 $P(^ONCO(165.5,IEN,"CS"),U,11)=250
        ..S:EXT=540 $P(^ONCO(165.5,IEN,"CS"),U,11)=250
        ..S:EXT=550 $P(^ONCO(165.5,IEN,"CS"),U,11)=380
        ..S:EXT=560 $P(^ONCO(165.5,IEN,"CS"),U,11)=420
        ..S:EXT=580 $P(^ONCO(165.5,IEN,"CS"),U,11)=645
        ..S:EXT=650 $P(^ONCO(165.5,IEN,"CS"),U,11)=440
        ..S:EXT=670 $P(^ONCO(165.5,IEN,"CS"),U,11)=635
        ..S:EXT=760 $P(^ONCO(165.5,IEN,"CS"),U,11)=770
        .I (PS=67221)&((HST14=8170)!(HST14=8171)!(HST14=8171)!(HST14=8172)!(HST14=8173)!(HST14=8174)!(HST14=8175)) D
        ..S:EXT=200 $P(^ONCO(165.5,IEN,"CS"),U,11)=350
        ..S:EXT=300 $P(^ONCO(165.5,IEN,"CS"),U,11)=390
        ..S:EXT=500 $P(^ONCO(165.5,IEN,"CS"),U,11)=170
        ..S:EXT=510 $P(^ONCO(165.5,IEN,"CS"),U,11)=150
        ..S:EXT=520 $P(^ONCO(165.5,IEN,"CS"),U,11)=370
        ..S:EXT=530 $P(^ONCO(165.5,IEN,"CS"),U,11)=250
        ..S:EXT=540 $P(^ONCO(165.5,IEN,"CS"),U,11)=250
        ..S:EXT=550 $P(^ONCO(165.5,IEN,"CS"),U,11)=380
        ..S:EXT=560 $P(^ONCO(165.5,IEN,"CS"),U,11)=420
        ..S:EXT=580 $P(^ONCO(165.5,IEN,"CS"),U,11)=645
        ..S:EXT=650 $P(^ONCO(165.5,IEN,"CS"),U,11)=440
        ..S:EXT=670 $P(^ONCO(165.5,IEN,"CS"),U,11)=635
        ..S:EXT=760 $P(^ONCO(165.5,IEN,"CS"),U,11)=770
        .D 3,4,5,6
        ;
        ;Bladder C67.0-C67.9
        I $E(PS,3,4)=67 D  Q
        .S:EXT=200 $P(^ONCO(165.5,IEN,"CS"),U,11)=240
        .S:EXT=400 $P(^ONCO(165.5,IEN,"CS"),U,11)=430
        .S:EXT=450 $P(^ONCO(165.5,IEN,"CS"),U,11)=810
        .D 1,2,3,4,5,6
        ;
        ;Bone C40.0-C40.3, C40.8-C40.9, C41.0-C41.4, C41.8-C41.9
        I ($E(PS,3,4)=40)!($E(PS,3,4)=41) D  Q
        .S:METS=55 $P(^ONCO(165.5,IEN,"CS"),U,3)=60
        .D 1,2,3,4,5,6
        ;
        ;Brain C70.0, C71.0-C71.9
        I (PS=67700)!($E(PS,3,4)=71) D  Q
        .S:LN=888 $P(^ONCO(165.5,IEN,"CS"),U,12)=988
        .D 2,3,4,5,6
        ;
        ;Breast C50.0-C50.6, C50.8-C50.9
        I $E(PS,3,4)=50 D  Q
        .S:EXT=720 $P(^ONCO(165.5,IEN,"CS"),U,11)=710
        .S:SSF4=888 $P(^ONCO(165.5,IEN,"CS"),U,8)=987
        .S:SSF5=888 $P(^ONCO(165.5,IEN,"CS"),U,9)=987
        .S:SSF6=888 $P(^ONCO(165.5,IEN,"CS"),U,10)=987
        ;
        ;BuccalMucosa C06.0-C06.1
        I (PS=67060)!(PS=67061) D  Q
        .S:EXT=650 $P(^ONCO(165.5,IEN,"CS"),U,11)=550
        .S:EXT=670 $P(^ONCO(165.5,IEN,"CS"),U,11)=740
        .S:EXT=730 $P(^ONCO(165.5,IEN,"CS"),U,11)=805
        .D SSF12
        ;
        ;CNSOther C70.1, C70.9, C72.0-C72.5, C72.8-C72.9
        I (PS=67701)!(PS=67709)!($E(PS,3,4)=72) D  Q
        .D 2,3,4,5,6
        ;
        ;Colon C18.0, C18.2-C18.9
        ;GISTColon C18.0, C18.2-C18.9 (M-8935-8936) 
        ;NETColon C18.0, C18.2-C18.9 (M-8153, 8240-8242, 8246, 8249) 
        I (PS=67180)!(PS=67182)!(PS=67183)!(PS=67184)!(PS=67185)!(PS=67186)!(PS=67187)!(PS=67188)!(PS=67189) D  Q
        .D
        ..I (HST14=8935)!(HST14=8936) Q
        ..I (HST14=8153)!((HST14>8239)&(HST14<8243))!(HST14=8246)!(HST14=8249) Q
        ..S:SSF1="080" $P(^ONCO(165.5,IEN,"CS"),U,5)=997
        .D 2,3,4,5,6
        ;
        ;Conjunctiva C69.0
        I PS=67690 D  Q
        .S:(TS>980)&(TS<990) $P(^ONCO(165.5,IEN,"CS1"),U,10)=980
        .S:EXT=700 $P(^ONCO(165.5,IEN,"CS"),U,11)=730
        .D 1,2,3,4,5,6
        ;
        ;CorpusAdenosarcoma C54.0-C54.3, C54.8-C54.9, C55.9
        ;(M-8933) 
        I (($E(PS,3,4)=54)!(PS=67559))&(HST14=8933) D  Q
        .S:EXT=700 $P(^ONCO(165.5,IEN,"CS"),U,11)=710
        .D 1,2,3,4,5,6
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,6)="" $P(^ONCO(165.5,IEN,"CS"),U,6)=988
        ;
        ;CorpusCarcinoma C54.0-C54.3, C54.8-C54.9, C55.9
        ;(M-8000-8790,8980-8981,9700-9701) 
        I (($E(PS,3,4)=54)!(PS=67559))&((HST14>7999)&(HST14<8791)!(HST14=8980)!(HST14=8981)!(HST14=9700)!(HST14=9701)) D  Q
        .S:EXT=620 $P(^ONCO(165.5,IEN,"CS"),U,11)=645
        .S:EXT=700 $P(^ONCO(165.5,IEN,"CS"),U,11)=710
        .D 1,2,3,4,5,6
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,6)="" $P(^ONCO(165.5,IEN,"CS"),U,6)=988
        ;
        ;CorpusSarcoma C54.0-C54.3, C54.8-C54.9, C55.9
        ;(M-8800-8932,8934-8974,8982-9136,9141-9582)
        I (($E(PS,3,4)=54)!(PS=67559))&((HST14>8799)&(HST14<8933)!(HST14>8933)&(HST14<8975)!(HST14>8981)&(HST14<9137)!(HST14>9140)&(HST14<9583)) D  Q
        .S:EXT=700 $P(^ONCO(165.5,IEN,"CS"),U,11)=710
        .D 1,2,3,4,5,6
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,6)="" $P(^ONCO(165.5,IEN,"CS"),U,6)=988
        ;
        ;EndocrineOther C37.9, C75.0, C75.4-C75.5, C75.8-C75.9
        I (PS=67379)!(PS=67750)!(PS=67754)!(PS=67755)!(PS=67758)!(PS=67759) D  Q
        .D 2,3,4,5,6
        ;
        ;EpiglottisAnterior C10.1
        I PS=67101 D  Q
        .S:EXT=200 $P(^ONCO(165.5,IEN,"CS"),U,11)=305
        .D SSF12
        ;
        ;Esophagus C15.0-C15.5, C15.8-C15.9
        ;GISTEsophagus  C15.0-C15.5, C15.8-C15.9 (M-8935-8936) 
        I $E(PS,3,4)=15 D  Q
        .D 1,2,3,4,5,6
        ;
        ;EsophagusGEJunction C16.0, C16.1, C16.2
        ;GISTStomach C16.0-C16.6, C16.8-C16.9 (M-8935-8936)
        ;NETStomach C16.0-C16.6, C16.8-C16.9 (M-8153, 8240-8242, 8246, 8249) 
        ;Stomach C16.1-C16.6, C16.8-C16.9
        I $E(PS,3,4)=16 D  Q
        .D 1,2,3,4,5,6
        ;
        ;EyeOther C69.1-C69.4, C69.8-C69.9
        I $E(PS,3,4)=69 D  Q
        .D 1,2,3,4,5,6
        ;
        ;FallopianTube C57.0
        I PS=67570 D  Q
        .S:EXT=700 $P(^ONCO(165.5,IEN,"CS"),U,11)=680
        .S:EXT=710 $P(^ONCO(165.5,IEN,"CS"),U,11)=660
        .D 1,2,3,4,5,6
        ;
        ;FloorMouth C04.0-C04.1, C04.8-C04.9
        I $E(PS,3,4)="04" D  Q
        .S:EXT=640 $P(^ONCO(165.5,IEN,"CS"),U,11)=550
        .D SSF12
        ;
        ;Gallbladder C23.9
        I PS=67239 D  Q
        .D 1,2,3,4,5,6
        ;
        ;GenitalFemaleOther C57.7-C57.9
        I (PS=67577)!(PS=67578)!(PS=67579) D  Q
        .D 1,2,3,4,5,6
        ;
        ;GenitalMaleOther C63.0-C63.1, C63.7-C63.9
        I (PS=67630)!(PS=67631)!(PS=67637)!(PS=67639) D  Q
        .D 1,2,3,4,5,6
        ;
        ;GISTPeritoneum C48.0-C48.2, C48.8 (M-8935-8936) 
        ;Peritoneum C48.1-C48.2, C48.8
        ;PeritoneumFemaleGen C48.0-C48.2, C48.8
        I $E(PS,3,4)=48 D  Q
        .D 1,2,3,4,5,6
        ;
        ;GISTRectum C19.9, C20.9 (M-8935-8936)
        ;NETRectum C19.9, C20.9 (M-8153, 8240-8242, 8246, 8249)
        ;Rectum C19.9, C20.9
        I (PS=67199)!(PS=67209) D  Q
        .D
        ..I (HST14=8935)!(HST14=8936) Q
        ..I (HST14=8153)!((HST14>8239)&(HST14<8243))!(HST14=8246)!(HST14=8249) Q
        ..S:SSF1="080" $P(^ONCO(165.5,IEN,"CS"),U,5)=997
        .D 2,3,4,5,6
        ;
        ;GISTSmallIntestine C17.0-C17.3, C17.8-C17.9 (M-8935-8936)
        ;NETSmallIntestine C17.0-C17.3, C17.8-C17.9 (M-8153, 8240-8242, 8246,
        ;8249)
        ;SmallIntestine C17.0-C17.3, C17.8-C17.9
        I $E(PS,3,4)=17 D  Q
        .D 1,2,3,4,5,6
        ;
        ;GumLower C03.1, C06.2
        ;GumOther C03.9
        ;GumUpper C03.0
        I (PS=67031)!(PS=67062)!(PS=67039)!(PS=67030) D  Q
        .S:EXT=790 $P(^ONCO(165.5,IEN,"CS"),U,11)=805
        .D SSF12
        ;
        ;HeartMediastinum C38.0-C38.3, C38.8
        I (PS=67380)!(PS=67381)!(PS=67382)!(PS=67383)!(PS=67388) D  Q
        .D 1,2,3,4,5,6
        ;
        ;Hypopharynx C12.9, C13.0-C13.2, C13.8-C13.9
        I (PS=67129)!($E(PS,3,4)=13) D  Q
        .S:EXT=150 $P(^ONCO(165.5,IEN,"CS"),U,11)=420
        .S:EXT=510 $P(^ONCO(165.5,IEN,"CS"),U,11)=450
        .S:EXT=610 $P(^ONCO(165.5,IEN,"CS"),U,11)=560
        .S:EXT=660 $P(^ONCO(165.5,IEN,"CS"),U,11)=635
        .D SSF12
        ;
        ;IllDefinedOther
        ;C42.0-C42.4, C76.0-C76.5, C76.7-C76.8, C77.0-C77.5, C77.8-C77.9, C80.9
        I ($E(PS,3,4)=42)!($E(PS,3,4)=76)!($E(PS,3,4)=77)!(PS=67809) D  Q
        .S:EXT=888 $P(^ONCO(165.5,IEN,"CS"),U,11)=988
        .S:LN=888 $P(^ONCO(165.5,IEN,"CS"),U,12)=988
        .S:METS=88 $P(^ONCO(165.5,IEN,"CS"),U,3)=98
        .D 1,2,3,4,5,6
        ;
        ;IntracranialGland C75.1, C75.2, C75.3
        I (PS=67751)!(PS=67752)!(PS=67753) D  Q
        .D 2,3,4,5,6
        ;
        ;KidneyParenchyma C64.9
        I PS=67649 D  Q
        .S:EXT=390 $P(^ONCO(165.5,IEN,"CS"),U,11)=625
        .D 1,2,3,4,5,6
        ;
        ;KidneyRenalPelvis C65.9, C66.9
        I (PS=67659)!(PS=67669) D  Q
        .S:EXT=750 $P(^ONCO(165.5,IEN,"CS"),U,11)=690
        .D 1,2,3,4,5,6
        ;
        ;LacrimalGland C69.5
        ;LacrimalSac C69.5
        I PS=67695 D  Q
        .D 1,2,3,4,5,6
        ;
        ;LarynxGlottic C32.0
        ;LarynxOther C32.3, C32.8-C32.9
        ;LarynxSubglottic C32.2
        ;LarynxSupraglottic C32.1
        I $E(PS,3,4)=32 D  Q
        .I PS=67320 S:EXT=100 $P(^ONCO(165.5,IEN,"CS"),U,11)=130
        .I PS=67322 S:EXT=730 $P(^ONCO(165.5,IEN,"CS"),U,11)=800
        .I PS=67321 S:EXT=670 $P(^ONCO(165.5,IEN,"CS"),U,11)=690
        .D SSF12
        ;
        ;LipLower C00.1, C00.4, C00.6
        ;LipOther C00.2, C00.5, C00.8-C00.9
        ;LipUpper C00.0, C00.3
        ;MiddleEar C30.1
        I ($E(PS,3,4)="00")!(PS=67301) D  Q
        .D SSF12
        ;
        ;Lung C34.0-C34.3, C34.8-C34.9
        I $E(PS,3,4)=34 D  Q
        .S:METS=10 $P(^ONCO(165.5,IEN,"CS"),U,3)=30
        .S:METS=39 $P(^ONCO(165.5,IEN,"CS"),U,3)=23
        .D 1,2,3,4,5,6
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,5)="" $P(^ONCO(165.5,IEN,"CS"),U,5)=988
        ;
        ;MouthOther C05.8-C05.9, C06.8-C06.9
        I (PS=67058)!(PS=67059)!(PS=67068)!(PS=67069) D  Q
        .S:EXT=720 $P(^ONCO(165.5,IEN,"CS"),U,11)=800
        .D SSF12
        ;
        ;NasalCavity C30.0
        I PS=67300 D  Q
        .S:EXT=710 $P(^ONCO(165.5,IEN,"CS"),U,11)=760
        .D SSF12
        ;
        ;Nasopharynx C11.0-C11.3, C11.8-C11.9
        I $E(PS,3,4)=11 D  Q
        .S:EXT=750 $P(^ONCO(165.5,IEN,"CS"),U,11)=710
        .D SSF12
        ;
        ;Orbit C69.6
        I PS=67696 D  Q
        .D 1,2,3,4,5,6
        ;
        ;Oropharynx C09.0-C09.1, C09.8-C09.9, C10.0, C10.2-C10.4, C10.8-C10.9
        I ($E(PS,3,4)="09")!(PS=67100)!(PS=67102)!(PS=67103)!(PS=67104)!(PS=67108)!(PS=67109) D  Q
        .S:EXT=410 $P(^ONCO(165.5,IEN,"CS"),U,11)=630
        .S:EXT=620 $P(^ONCO(165.5,IEN,"CS"),U,11)=710
        .S:EXT=760 $P(^ONCO(165.5,IEN,"CS"),U,11)=750
        .D SSF12
        ;
        ;Ovary C56.9
        I PS=67569 D  Q
        .D 2,3,4,5,6
        ;
        ;PalateHard C05.0
        ;PalateSoft C05.1-C05.2
        I (PS=67050)!(PS=67051)!(PS=67052) D  Q
        .I PS=67050 D
        ..S:EXT=760 $P(^ONCO(165.5,IEN,"CS"),U,11)=790
        .I (PS=67051)!(PS=67052) D
        ..S:EXT=770 $P(^ONCO(165.5,IEN,"CS"),U,11)=670
        .D SSF12
        ;
        ;ParotidGland C07.9
        I PS=67079 D  Q
        .S:EXT=720 $P(^ONCO(165.5,IEN,"CS"),U,11)=405
        .D SSF12
        ;
        ;PharyngealTonsil C11.1
        I PS=67111 D  Q
        .S:EXT=570 $P(^ONCO(165.5,IEN,"CS"),U,11)=610
        .D SSF12
        ;
        ;PharynxOther C14.0, C14.2, C14.8
        I (PS=67140)!(PS=67142)!(PS=67148) D  Q
        .D SSF12
        ;
        ;Placenta C58.9
        I PS=67589 D  Q
        .S:LN=888 $P(^ONCO(165.5,IEN,"CS"),U,12)=988
        .D 2,3,4,5,6
        ;
        ;Pleura C38.4
        I PS=67384 D  Q
        .S:EXT=100 $P(^ONCO(165.5,IEN,"CS"),U,11)=160
        .D 2,3,4,5,6
        ;
        ;Prostate C61.9
        I PS=67619 D  Q
        .S:METS=45 $P(^ONCO(165.5,IEN,"CS"),U,3)=60
        .S:SSF1="000" $P(^ONCO(165.5,IEN,"CS"),U,5)=998
        .S:(SSF1>980)&(SSF1<990) $P(^ONCO(165.5,IEN,"CS"),U,5)=980
        .S:SSF2="000" $P(^ONCO(165.5,IEN,"CS"),U,6)=998
        .S:SSF2="080" $P(^ONCO(165.5,IEN,"CS"),U,6)=997
        .S:SSF3="020" $P(^ONCO(165.5,IEN,"CS"),U,7)=200
        .S:SSF3="021" $P(^ONCO(165.5,IEN,"CS"),U,7)=210
        .S:SSF3="022" $P(^ONCO(165.5,IEN,"CS"),U,7)=220
        .S:SSF3="023" $P(^ONCO(165.5,IEN,"CS"),U,7)=230
        .S:SSF3="030" $P(^ONCO(165.5,IEN,"CS"),U,7)=300
        .S:SSF3="032" $P(^ONCO(165.5,IEN,"CS"),U,7)=320
        .S:SSF3="040" $P(^ONCO(165.5,IEN,"CS"),U,7)=400
        .S:SSF3="041" $P(^ONCO(165.5,IEN,"CS"),U,7)=410
        .S:SSF3="042" $P(^ONCO(165.5,IEN,"CS"),U,7)=420
        .S:SSF3="043" $P(^ONCO(165.5,IEN,"CS"),U,7)=430
        .S:SSF3="045" $P(^ONCO(165.5,IEN,"CS"),U,7)=485
        .S:SSF3="048" $P(^ONCO(165.5,IEN,"CS"),U,7)=480
        .S:SSF3="050" $P(^ONCO(165.5,IEN,"CS"),U,7)=500
        .S:SSF3="052" $P(^ONCO(165.5,IEN,"CS"),U,7)=520
        .S:SSF3="060" $P(^ONCO(165.5,IEN,"CS"),U,7)=600
        .S:SSF3="070" $P(^ONCO(165.5,IEN,"CS"),U,7)=700
        .S:SSF3="095" $P(^ONCO(165.5,IEN,"CS"),U,7)=950
        .S:SSF3="096" $P(^ONCO(165.5,IEN,"CS"),U,7)=960
        .S:SSF3="097" $P(^ONCO(165.5,IEN,"CS"),U,7)=970
        .S:SSF3="098" $P(^ONCO(165.5,IEN,"CS"),U,7)=980
        .S:SSF3="099" $P(^ONCO(165.5,IEN,"CS"),U,7)=990
        ;
        ;SalivaryGlandOther C08.1, C08.8-C08.9
        ;SubmandibularGland C08.0
        I $E(PS,3,4)="08" D  Q
        .S:EXT=720 $P(^ONCO(165.5,IEN,"CS"),U,11)=405
        .D SSF12
        ;
        ;SinusEthmoid C31.1
        ;SinusMaxillary C31.0
        ;SinusOther C31.2-C31.3, C31.8-C31.9
        I $E(PS,3,4)=31 D  Q
        .I PS=67311 D
        ..S:EXT=140 $P(^ONCO(165.5,IEN,"CS"),U,11)=320
        ..S:EXT=240 $P(^ONCO(165.5,IEN,"CS"),U,11)=340
        .I PS=67310 D
        ..S:EXT=650 $P(^ONCO(165.5,IEN,"CS"),U,11)=600
        .D SSF12
        ;
        ;Skin C44.0, C44.2-C44.9
        ;SkinEyelid C44.1
        I $E(PS,3,4)=44 D  Q
        .I PS=67441 D
        ..S:EXT=500 $P(^ONCO(165.5,IEN,"CS"),U,11)=150
        ..S:EXT=700 $P(^ONCO(165.5,IEN,"CS"),U,11)=620
        .D 1,2,3,4,5,6
        ;
        ;Testis C62.0-C62.1, C62.9
        I $E(PS,3,4)=62 D  Q
        .S:METS=45 $P(^ONCO(165.5,IEN,"CS"),U,3)=60
        .S:SSF5="001" $P(^ONCO(165.5,IEN,"CS"),U,9)="010"
        .S:SSF5="002" $P(^ONCO(165.5,IEN,"CS"),U,9)="020"
        .S:SSF5="003" $P(^ONCO(165.5,IEN,"CS"),U,9)="030"
        .S:SSF6=888 $P(^ONCO(165.5,IEN,"CS"),U,10)=988
        ;
        ;Thyroid C73.9
        I PS=67739 D  Q
        .S:EXT=720 $P(^ONCO(165.5,IEN,"CS"),U,11)=550
        .S:LN=140 $P(^ONCO(165.5,IEN,"CS"),U,12)=150
        .D 2,3,4,5,6
        ;
        ;TongueAnterior C02.0-C02.3, C02.8-C02.9
        ;TongueBase C01.9, C02.4
        I ($E(PS,3,4)="02")!(PS=67019) D  Q
        .I (PS=67019)!(PS=67024) D
        ..S:EXT=820 $P(^ONCO(165.5,IEN,"CS"),U,11)=805
        .D SSF12
        ;
        ;AdnexaUterineOther C57.1-C57.4
        ;AmpullaVater C24.1
        ;NETAmpulla C24.1 (M-8153, 8240-8242, 8246, 8249)
        ;Anus C21.0-C21.2, C21.8
        ;BileDuctsDistal C24.0
        ;BileDuctsPerihilar C24.0
        ;BiliaryOther C24.8-C24.9
        ;CysticDuct" C24.0
        ;Cervix C53.0-C53.1, C53.8-C53.9
        ;DigestiveOther C26.0, C26.8-C26.9
        ;PancreasBodyTail C25.1-C25.2
        ;PancreasHead C25.0
        ;PancreasOther C25.3-C25.4, C25.7-C25.9
        ;Penis C60.0-C60.2, C60.8-C60.9
        ;RespiratoryOther C39.0, C39.8-C39.9
        ;Retroperitoneum C48.0
        ;Scrotum C63.2
        ;SoftTissue C47.0-C47.6, C47.8-C47.9, C49.0-C49.6, C49.8-C49.9
        ;Trachea C33.9
        ;Urethra C68.0
        ;UrinaryOther C68.1, C68.8-C68.9
        ;Vagina C52.9
        ;Vulva C51.0-C51.2, C51.8-C51.9
        S S34=$E(PS,3,4)
        I (S34=26)!(S34=53)!(PS=67248)!(PS=67249)!(PS=67240)!(S34=21)!(PS=67241)!(PS=67571)!(PS=6752)!(PS=67573)!(PS=67574)!(S34=25)!(S34=60)!(S34=39)!(PS=67480)!(PS=67632)!(S34=47)!(S34=49)!(PS=67339)!(S34=68)!(PS=67529)!(S34=51) D  Q
        .D 1,2,3,4,5,6
        ;
        Q
        ;
1       ;SSF1 = 888 to 988
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,5)=888 $P(^ONCO(165.5,IEN,"CS"),U,5)=988
        Q
        ;
2       ;SSF2 = 888 to 988
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,6)=888 $P(^ONCO(165.5,IEN,"CS"),U,6)=988
        Q
        ;
3       ;SSF3 = 888 to 988
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,7)=888 $P(^ONCO(165.5,IEN,"CS"),U,7)=988
        Q
        ;
4       ;SSF4 = 888 to 988
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,8)=888 $P(^ONCO(165.5,IEN,"CS"),U,8)=988
        Q
        ;
5       ;SSF5 = 888 to 988
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,9)=888 $P(^ONCO(165.5,IEN,"CS"),U,9)=988
        Q
        ;
6       ;SSF6 = 888 to 988
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,10)=888 $P(^ONCO(165.5,IEN,"CS"),U,10)=988
        Q
        ;
SSF12   ;SSF1 989 to 980
        ;SSF1 981-988 to 980
        ;SSF2 888 to 987
        S:(SSF1>980)&(SSF1<990) $P(^ONCO(165.5,IEN,"CS"),U,5)=980
        S:SSF2=888 $P(^ONCO(165.5,IEN,"CS"),U,6)=987
        Q
        ;
CLEANUP ;Cleanup
        K IEN
