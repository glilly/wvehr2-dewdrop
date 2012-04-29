ONCPST48        ;Hines OIFO/GWB - POST-INSTALL ROUTINE FOR PATCH ONC*2.11*48
        ;;2.11;ONCOLOGY;**48**;Mar 07, 1995;Build 13
        ;
ITEM2   ;COLLABORATIVE STAGING VERSION 01.04.01
        ;Conversions for CS V01.04.01
        W !!," Performing data conversions needed for CS V01.04.01"
        S XDT=3040000 F  S XDT=$O(^ONCO(165.5,"ADX",XDT)) Q:XDT=""  S IEN=0 F  S IEN=$O(^ONCO(165.5,"ADX",XDT,IEN)) Q:IEN=""  D
        .I $P($G(^ONCO(165.5,IEN,"CS1")),U,11)'="",$P($G(^ONCO(165.5,IEN,"CS1")),U,12)="" S $P(^ONCO(165.5,IEN,"CS1"),U,12)=$P($G(^ONCO(165.5,IEN,"CS1")),U,11)
        .S MO=$$HIST^ONCFUNC(IEN)
        .I ($E(MO,1,4)=9140) Q
        .I ($E(MO,1,4)>9589)&($E(MO,1,4)<9700) Q
        .I ($E(MO,1,4)>9701)&($E(MO,1,4)<9990) Q
        .S TOP=$P($G(^ONCO(165.5,IEN,2)),U,1)
        .;[Hypopharynx]
        .I ($E(TOP,3,4)=12)!($E(TOP,3,4)=13) D  Q
        ..S CSEXT=$P($G(^ONCO(165.5,IEN,"CS")),U,11)
        ..I CSEXT=51 S $P(^ONCO(165.5,IEN,"CS"),U,11)=45 W "."
        .;[Breast]
        .I ($E(TOP,3,4)=50) D  Q
        ..S CSLN=$P($G(^ONCO(165.5,IEN,"CS")),U,12)
        ..S CSRNE=$P($G(^ONCO(165.5,IEN,"CS")),U,2)
        ..S SSF3=$P($G(^ONCO(165.5,IEN,"CS")),U,7)
        ..S SSF3=+SSF3
        ..I CSLN=28,(SSF3>3)&(SSF3<10),(CSRNE=2)!(CSRNE=3)!(CSRNE=6)!(CSRNE=8)!(CSRNE="") S $P(^ONCO(165.5,IEN,"CS"),U,12)=30 W "."
        ..I CSLN=50,(SSF3>3)&(SSF3<90),(CSRNE=2)!(CSRNE=3)!(CSRNE=6)!(CSRNE=8)!(CSRNE="") S $P(^ONCO(165.5,IEN,"CS"),U,12)=52 W "."
        .;[Fallopian Tube]
        .I ($E(TOP,3,5)=570) D  Q
        ..S CSEXT=$P($G(^ONCO(165.5,IEN,"CS")),U,11)
        ..I CSEXT=70 S $P(^ONCO(165.5,IEN,"CS"),U,11)=68 W "."
        ..I CSEXT=71 S $P(^ONCO(165.5,IEN,"CS"),U,11)=66 W "."
        ;
ITEM6   ;LATERALITY (165.5,28) for LYMPH NODES, HEAD & NECK (C77.0)
        ;LYMPH NODES, HEAD & NECK (164,67770)
        ;PAIRED ORGAN (164,.07)
        S $P(^ONCO(164,67770,0),U,7)=""
        ;
ITEM8   ;[Timeliness Report]
        S DIK="^ONCO(165.5,",DIK(1)=155 D ENALL^DIK
