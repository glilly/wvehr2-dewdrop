ONCCSV2 ;Hines OIFO/GWB - Collaborative Staging v2 Conversion ;06/23/10
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
        ;HemeRetic (M-9731-9992)
        S QUIT="YES"
        I ((HST14>9730)&(HST14<9993)) D  I $G(QUIT)="YES" Q
        .I ((HST14=9731)!(HST14=9732)!(HST14=9733)!(HST14=9734)!(HST14=9820)!(HST14=9826)!(HST14=9832)!(HST14=9833)!(HST14=9834)!(HST14=9835)!(HST14=9836))&((PS=67441)!(PS=67690)!(PS=67695)!(PS=67696)) S QUIT="NO" Q
        .I ((HST14=9823)!(HST14=9827)!(HST14=9837))&((PS'=67420)&(PS'=67421)&(PS'=67424)) S QUIT="NO" Q
        .S:TS=888 $P(^ONCO(165.5,IEN,"CS1"),U,10)=988
        .S:LN=888 $P(^ONCO(165.5,IEN,"CS"),U,12)=988
        .S:METS=88 $P(^ONCO(165.5,IEN,"CS"),U,3)=98
        .D 1,2,3,4,5,6
        ;
        ;KaposiSarcoma (M-9140) 
        I HST14=9140 D  Q
        .S:TS=888 $P(^ONCO(165.5,IEN,"CS1"),U,10)=988
        .S:METS=88 $P(^ONCO(165.5,IEN,"CS"),U,3)=98
        .D 2,3,4,5,6
        ;
        ;LymphomaOcularAdnexa C44.1, C69.0, C69.5-C69.6
        ;(M-9590-9699, 9702-9738, 9811-9818, 9820-9837)
        I ((PS=67441)!(PS=67690)!(PS=67695)!(PS=67696))&((HST14>9589)&(HST14<9700))!((HST14>9701)&(HST14<9739))!((HST14>9810)&(HST14<9819))!((HST14>9819)&(HST14<9838)) D  Q
        .S:TS=888 $P(^ONCO(165.5,IEN,"CS1"),U,10)=988
        .S:LN=888 $P(^ONCO(165.5,IEN,"CS"),U,12)=988
        .S:METS=88 $P(^ONCO(165.5,IEN,"CS"),U,3)=98
        .S:SSF1=888 $P(^ONCO(165.5,IEN,"CS"),U,5)=999
        .S:SSF2=888 $P(^ONCO(165.5,IEN,"CS"),U,6)=999
        .S:SSF3=888 $P(^ONCO(165.5,IEN,"CS"),U,7)=999
        .D 4,5,6
        ;
        ;Lymphoma
        ;(M-9590-9699, 9702-9729, 9735, 9737, 9738, 9811-9818)
        ;(M-9823, 9827, 9837 EXCEPT C42.0, C42.1, C42.4) 
        S QUIT="YES"
        I ((HST14>9589)&(HST14<9700))!((HST14>9701)&(HST14<9730))!(HST14=9735)!(HST14=9737)!(HST14=9738)!((HST14>9810)&(HST14<9819))!(HST14=9823)!(HST14=9827)!(HST14=9837) D  I $G(QUIT)="YES" Q
        .I ((HST14=9823)!(HST14=9827)!(HST14=9837))&((PS=67420)!(PS=67421)!(PS=67424)) S QUIT="NO" Q
        .S:LN=888 $P(^ONCO(165.5,IEN,"CS"),U,12)=988
        .S:METS=88 $P(^ONCO(165.5,IEN,"CS"),U,3)=98
        .S:SSF1=888 $P(^ONCO(165.5,IEN,"CS"),U,5)=999
        .S:SSF2=888 $P(^ONCO(165.5,IEN,"CS"),U,6)=999
        .S:SSF3=888 $P(^ONCO(165.5,IEN,"CS"),U,7)=999
        .D 4,5,6
        ;
        ;MelanomaBuccalMucosa C06.0-C06.1
        ;MelanomaEpiglottisAnterior C10.1
        ;MelanomaFloorMouth C04.0-C04.1, C04.8-C04.9
        ;MelanomaGumLower C03.1, C06.2
        ;MelanomaGumOther C03.9
        ;MelanomaGumUpper C03.0
        ;MelanomaHypopharynx C12.9, C13.0-C13.2, C13.8-C13.9
        ;MelanomaLarynxGlottic C32.0
        ;MelanomaLarynxOther C32.3, C32.8-C32.9
        ;MelanomaLarynxSubglottic C32.2
        ;MelanomaLarynxSupraglottic C32.1
        ;MelanomaLipLower C00.1, C00.4, C00.6
        ;MelanomaLipOther C00.2, C00.5, C00.8-C00.9
        ;MelanomaLipUpper C00.0, C00.3
        ;MelanomaMouthOther C05.8-C05.9, C06.8-C06.9
        ;MelanomaNasalCavity C30.0
        ;MelanomaNasopharynx C11.0-C11.3, C11.8-C11.9
        ;MelanomaOropharynx C09.0-C09.1, C09.8-C09.9, C10.0, C10.2-C10.4, C10.8-C10.9
        ;MelanomaPalateHard C05.0
        ;MelanomaPalateSoft C05.1-C05.2
        ;MelanomaPharynxOther C14.0, C14.2-C14.8
        ;MelanomaSinusEthmoid C31.1
        ;MelanomaSinusMaxillary C31.0
        ;MelanomaSinusOther C31.2-C31.3, C31.8-C31.9
        ;MelanomaTongueAnterior C02.0-C02.3, C02.8-C02.9
        ;MelanomaTongueBase C01.9, C02.4
        S S34=$E(PS,3,4)
        I $$MELANOMA^ONCOU55(IEN),(S34="00")!(S34="01")!(S34="02")!(S34="03")!(S34="04")!(S34="05")!(S34="06")!(S34="09")!(S34=10)!(S34=11)!(S34=12)!(S34=13)!(S34=14)!(S34=31)!(S34=32)!(PS=67300) D  Q
        .I (PS=67060)!(PS=67061) D
        ..S:EXT=200 $P(^ONCO(165.5,IEN,"CS"),U,11)=610
        ..S:EXT=670 $P(^ONCO(165.5,IEN,"CS"),U,11)=700
        ..S:EXT=730 $P(^ONCO(165.5,IEN,"CS"),U,11)=790
        .;
        .I PS=67101 D
        ..S:EXT=360 $P(^ONCO(165.5,IEN,"CS"),U,11)=365
        .;
        .I $E(PS,3,4)="04" D
        ..S:EXT=640 $P(^ONCO(165.5,IEN,"CS"),U,11)=740
        ..S:EXT=770 $P(^ONCO(165.5,IEN,"CS"),U,11)=700
        .;
        .I (PS=67031)!(PS=67062)!(PS=67039)!(PS=67030) D
        ..S:EXT=790 $P(^ONCO(165.5,IEN,"CS"),U,11)=800
        .;
        .I (PS=67129)!($E(PS,3,4)=13) D  Q
        ..S:EXT=150 $P(^ONCO(165.5,IEN,"CS"),U,11)=420
        ..S:EXT=510 $P(^ONCO(165.5,IEN,"CS"),U,11)=450
        ..S:EXT=660 $P(^ONCO(165.5,IEN,"CS"),U,11)=635
        .;
        .I PS=67321 D
        ..S:EXT=650 $P(^ONCO(165.5,IEN,"CS"),U,11)=605
        ..S:EXT=660 $P(^ONCO(165.5,IEN,"CS"),U,11)=605
        ..S:EXT=680 $P(^ONCO(165.5,IEN,"CS"),U,11)=530
        .;
        .I $E(PS,3,4)="00" D
        ..S:EXT=200 $P(^ONCO(165.5,IEN,"CS"),U,11)=520
        .;
        .I (PS=67058)!(PS=67059)!(PS=67068)!(PS=67069) D
        ..S:EXT=200 $P(^ONCO(165.5,IEN,"CS"),U,11)=510
        ..S:EXT=720 $P(^ONCO(165.5,IEN,"CS"),U,11)=750
        .;
        .I PS=67300 D
        ..S:EXT=650 $P(^ONCO(165.5,IEN,"CS"),U,11)=750
        .;
        .I $E(PS,3,4)=11 D
        ..S:EXT=750 $P(^ONCO(165.5,IEN,"CS"),U,11)=790
        .;
        .I ($E(PS,3,4)="09")!(PS=67100)!(PS=67102)!(PS=67103)!(PS=67104)!(PS=67108)!(PS=67109) D
        ..S:EXT=720 $P(^ONCO(165.5,IEN,"CS"),U,11)=690
        ..S:EXT=760 $P(^ONCO(165.5,IEN,"CS"),U,11)=690
        .;
        .I PS=67050 D
        ..S:EXT=760 $P(^ONCO(165.5,IEN,"CS"),U,11)=730
        .;
        .I (PS=67051)!(PS=67052) D
        ..S:EXT=770 $P(^ONCO(165.5,IEN,"CS"),U,11)=675
        ..S:EXT=780 $P(^ONCO(165.5,IEN,"CS"),U,11)=680
        .;
        .I PS=67311 D
        ..S:EXT=240 $P(^ONCO(165.5,IEN,"CS"),U,11)=270
        ..S:EXT=300 $P(^ONCO(165.5,IEN,"CS"),U,11)=170
        ..S:EXT=620 $P(^ONCO(165.5,IEN,"CS"),U,11)=750
        ..S:EXT=630 $P(^ONCO(165.5,IEN,"CS"),U,11)=750
        .;
        .I (PS=67020)!(PS=67021)!(PS=67022)!(PS=67023)!(PS=67028)!(PS=67029) D
        ..S:EXT=740 $P(^ONCO(165.5,IEN,"CS"),U,11)=770
        .D SSF12
        ;
        ;MelanomaChoroid C69.3
        ;MelanomaCiliaryBody C69.4
        ;MelanomaIris C69.4
        I $$MELANOMA^ONCOU55(IEN),((PS=67693)!(PS=67694)) D  Q
        .S:(TS>980)&(TS<990) $P(^ONCO(165.5,IEN,"CS1"),U,10)=980
        .S:(SSF1>980)&(SSF1<990) $P(^ONCO(165.5,IEN,"CS"),U,5)=980
        .S:SSF1=990 $P(^ONCO(165.5,IEN,"CS"),U,5)=999
        .D 2,3,4,5,6
        ;
        ;MelanomaConjunctiva C69.0
        I $$MELANOMA^ONCOU55(IEN),PS=67690 D  Q
        .S:EXT=150 $P(^ONCO(165.5,IEN,"CS"),U,11)=330
        .S:(SSF1>980)&(SSF1<990) $P(^ONCO(165.5,IEN,"CS"),U,5)=980
        .S:SSF1=990 $P(^ONCO(165.5,IEN,"CS"),U,5)=999
        .D 2,3,4,5,6
        S:$P($G(^ONCO(165.5,IEN,"CS")),U,5)="" $P(^ONCO(165.5,IEN,"CS"),U,5)=988
        ;
        ;MelanomaEyeOther C69.1, C69.2, C69.5, C69.8-C69.9
        I $$MELANOMA^ONCOU55(IEN),((PS=67691)!(PS=67692)!(PS=67695)!(PS=67698)!(PS=67699)) D  Q
        .D 1,2,3,4,5,6
        ;
        ;MelanomaSkin C44.0-C44.9, C51.0-C51.2, C51.8-C51.9, C60.0-C60.2, C60.8-C60.9, C63.2
        I $$MELANOMA^ONCOU55(IEN),($E(PS,3,4)=44)!($E(PS,3,4)=51)!($E(PS,3,4)=60)!(PS=67632) D  Q
        .S:METS=40 $P(^ONCO(165.5,IEN,"CS"),U,3)=60
        .S:(SSF1>980)&(SSF1<990) $P(^ONCO(165.5,IEN,"CS"),U,5)=980
        .S:SSF1=990 $P(^ONCO(165.5,IEN,"CS"),U,5)=999
        .D 5,6
        ;
        ;MerkelCellPenis C60.0-C60.2, C60.8-C60.9 (M-8247)
        ;MerkelCellScrotum C63.2 (M-8247)
        ;MerkelCellSkin C44.0, C44.2-C44.9 (M-8247) 
        ;MerkelCellVulva C51.0-C51.2, C51.8-C51.9 (M-8247)
        I HST14=8247,($E(PS,3,4)=60)!(PS=67632)!(PS=67440)!(PS=67442)!(PS=67443)!(PS=67444)!(PS=67445)!(PS=67446)!(PS=67447)!(PS=67448)!(PS=67449)!($E(PS,3,4)=51) D  Q
        .D 1,2,3,4,5,6
        ;
        ;MycosisFungoides 
        ;C44.0-C44.9, C51.0-C51.2, C51.8-C51.9, C60.0-C60.2, C60.8-C60.9, C63.2
        ;(M-9700-9701)
        I (HST14=9700)!(HST14=9701),($E(PS,3,4)=44)!($E(PS,3,4)=51)!($E(PS,3,4)=60)!(PS=67632) D  Q
        .D 2,3,4,5,6
        ;
        ;Retinoblastoma C69.0-C69.6, C69.8-C69.9 (M-9510-9514) 
        I (HST14=9510)!(HST14=9511)!(HST14=9512)!(HST14=9513)!(HST14=9514),$E(PS,3,4)=69 D  Q
        .S:METS=40 $P(^ONCO(165.5,IEN,"CS"),U,3)=80
        .S:METS=55 $P(^ONCO(165.5,IEN,"CS"),U,3)=80
        .S:SSF1="000" $P(^ONCO(165.5,IEN,"CS"),U,5)=970
        .S:SSF1="030" $P(^ONCO(165.5,IEN,"CS"),U,5)=300
        .S:SSF1="041" $P(^ONCO(165.5,IEN,"CS"),U,5)=410
        .S:SSF1="043" $P(^ONCO(165.5,IEN,"CS"),U,5)=430
        .S:SSF1="044" $P(^ONCO(165.5,IEN,"CS"),U,5)=440
        .S:SSF1="046" $P(^ONCO(165.5,IEN,"CS"),U,5)=460
        .S:SSF1="047" $P(^ONCO(165.5,IEN,"CS"),U,5)=470
        .S:SSF1="048" $P(^ONCO(165.5,IEN,"CS"),U,5)=440
        .S:SSF1="049" $P(^ONCO(165.5,IEN,"CS"),U,5)=490
        .S:SSF1="054" $P(^ONCO(165.5,IEN,"CS"),U,5)=540
        .S:SSF1="056" $P(^ONCO(165.5,IEN,"CS"),U,5)=560
        .S:SSF1="057" $P(^ONCO(165.5,IEN,"CS"),U,5)=570
        .S:SSF1="059" $P(^ONCO(165.5,IEN,"CS"),U,5)=590
        .S:SSF1="072" $P(^ONCO(165.5,IEN,"CS"),U,5)=765
        .S:SSF1="095" $P(^ONCO(165.5,IEN,"CS"),U,5)=950
        .S:SSF1="096" $P(^ONCO(165.5,IEN,"CS"),U,5)=960
        .D 2,3,4,5,6
        ;
        D ^ONCCSV2A
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
