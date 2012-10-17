ONCSUBS ;Hines OIFO/GWB - CS SCHEMA DISCRIMINATOR (165.5,240) ;11/03/10
        ;;2.11;ONCOLOGY;**51,52**;Mar 07, 1995;Build 13
        ;
        ;Called from [ONCO ABSTRACT-I] INPUT TEMPLATE
        ;CS SCHEMA DISCRIMINATOR (165.5,240) prompt/no prompt logic
        N DTDX,HT,TX
        S DTDX=$P($G(^ONCO(165.5,D0,0)),U,16)
        I DTDX<3040000 S Y="@623" Q
        S TX=$P($G(^ONCO(165.5,D0,2)),U,1)
        Q:TX=""
        S HT=$$HIST^ONCFUNC(D0)
        I '$D(^ONCO(164,TX,15)) S Y="@623" Q
        I TX=67694,'$$MELANOMA^ONCOU55(D0) S Y="@623" Q
        I (TX=16161)!(TX=16162) D
        .I ($E(HT,1,4)=8153)!($E(HT,1,4)=8240)!($E(HT,1,4)=8241)!($E(HT,1,4)=8242)!($E(HT,1,4)=8246)!($E(HT,1,4)=8249)!($E(HT,1,4)=8935)!($E(HT,1,4)=8936) S Y="@623" Q
        I (TX=67481)!(TX=67482)!(TX=67488) D
        .I ($E(HT,1,4)=8935)!($E(HT,1,4)=8936) S Y="@623" Q
        Q
        ;
IN      ;CS SCHEMA DISCRIMINATOR (165.5,240) INPUT TRANSFORM
        N DTDX,HT,SD,TX,XD0
        S DTDX=$P($G(^ONCO(165.5,D0,0)),U,16)
        S TX=$P($G(^ONCO(165.5,D0,2)),U,1) Q:TX=""
        S HT=$$HIST^ONCFUNC(D0)
        S SD=$P($G(^ONCO(165.5,D0,"CS3")),U,1)
        I X'?3N K X Q
        I '$D(^ONCO(164,TX,14,"B",X)) W !!?5,"Invalid code for this PRIMARY SITE",! K X Q
        S XD0=$O(^ONCO(164,TX,14,"B",X,0))
        S X=^ONCO(164,TX,14,XD0,0)
        I DTDX>3091231,X=100 W "  OBSOLETE code" K X Q
        I SD'=X D
        .W !
        .W !?3,"You have changed the CS SCHEMA DISCRIMINATOR.  This change may"
        .W !?3,"affect the validity of the COLLABORATIVE STAGING data."
        .W !?3,"Therefore, the CS fields have been initialized and need to"
        .W !?3,"be re-entered."
        .W !
        .F PIECE=1:1:12 S $P(^ONCO(165.5,D0,"CS"),U,PIECE)=""
        .F PIECE=1:1:19 S $P(^ONCO(165.5,D0,"CS1"),U,PIECE)=""
        .F PIECE=1:1:18 S $P(^ONCO(165.5,D0,"CS2"),U,PIECE)=""
        K PIECE
        Q
        ;
HELP    ;CS SCHEMA DISCRIMINATOR (165.5,240) XECUTABLE 'HELP'
        N HIEN,TX
        S TX=$P($G(^ONCO(165.5,D0,2)),U,1)
        Q:TX=""
        I $D(^ONCO(164,TX,15)) D  W ! Q
        .S HIEN=0 F  S HIEN=$O(^ONCO(164,TX,15,HIEN)) Q:HIEN'>0  W !?1,^ONCO(164,TX,15,HIEN,0)
        Q
        ;
CLEANUP ;Cleanup
        K D0,Y
