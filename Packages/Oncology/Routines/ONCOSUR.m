ONCOSUR ;Hines OIFO/GWB - Surgery INPUT/OUTPUT TRANSFORMS/HELP ;06/23/10
        ;;2.11;ONCOLOGY;**15,18,19,22,36,37,38,39,41,46,51**;Mar 07, 1995;Build 65
        ;
        ;SURGICAL APPROACH (165.5,74)
SAIT    ;INPUT
        S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" K X Q
        I SCDXDT<2980000 D  I $D(X) S V=1 D NT^ONCODSR
        .K DIC S DIC="^ONCO(160.6," D ^DIC
        .I Y=-1 K X Q
        .S X=$P(Y,U,1) W "  ",$P(^ONCO(160.6,X,0),U,2)
        I SCDXDT>2971231 D
        .S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W "  No TOPOGRAPHY!" K X Q
        .S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" K X Q
        .;ROADS D-cxliii
        .I ($E(TOP,3,4)=76)!($E(TOP,3,4)=77)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141
        .S FOUND=0
        .F XSA=0:0 S XSA=$O(^ONCO(164,ICD,"SUA",XSA)) Q:XSA'>0!(FOUND=1)  D
        ..I $P(^ONCO(164,ICD,"SUA",XSA,0),U,2)=X S X=XSA,FOUND=1 Q
        .I FOUND=0 K X Q
        .W "  ",$P(^ONCO(164,ICD,"SUA",X,0),U,1)
        I $D(X) S V=1 D NT^ONCODSR
        K SCDXDT,FOUND,ICD,TOP,XSA Q
        ;
SAOT    ;OUTPUT
        S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" Q
        I SCDXDT<2980000 D
        .S:Y'="" Y=$P($G(^ONCO(160.6,Y,0)),U,2)
        I SCDXDT>2971231 D
        .Q:Y=""
        .S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" S Y="" Q
        .S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" S Y="" Q
        .;ROADS D-cxliii
        .I ($E(TOP,3,4)=76)!($E(TOP,3,4)=77)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141
        .S Y=$P($G(^ONCO(164,ICD,"SUA",Y,0)),U,1)
        K SCDXDT,ICD,TOP Q
        ;
SAHP    ;HELP
        S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" Q
        I SCDXDT<2980000 D
        .W !?3,"Select from the following list:"
        .F XSA=0:0 S XSA=$O(^ONCO(160.6,XSA)) Q:XSA'>0  W !?6,$P($G(^ONCO(160.6,XSA,0)),U,1),?12,$P($G(^ONCO(160.6,XSA,0)),U,2)
        I SCDXDT>2971231 D
        .S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W !,"No TOPOGRAPHY!" Q
        .S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" W !,"No ICD Codes!" Q
        .;ROADS D-cxliii
        .I ($E(TOP,3,4)=76)!($E(TOP,3,4)=77)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141
        .W !?3,"Select from the following list:",!
        .F XSA=0:0 S XSA=$O(^ONCO(164,ICD,"SUA",XSA)) Q:XSA'>0  W !?6,$P($G(^ONCO(164,ICD,"SUA",XSA,0)),U,2),?12,$P($G(^ONCO(164,ICD,"SUA",XSA,0)),U,1)
        K SCDXDT,ICD,TOP,XSA Q
        ;
        ;SURGERY OF PRIMARY (R) (165.5,58.2)
        ;SURGERY OF PRIMARY (F) (165.5,58.6)
        ;
SPSIT   ;INPUT TRANSFORM
        S NTXDD=$G(NTXDD) I NTXDD="" Q
        S TOP=$P($G(^ONCO(165.5,D0,2)),U,1)
        I TOP="" W "  No PRIMARY SITE" K X Q
        S ICD=""
        S SR=+X
        I $L(X)>2!(X'?1.N) K X Q
        S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" K X Q
        I (TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424)!($E(TOP,3,4)=76)!(TOP=67809),($G(FIELD)=58.6)!($G(FIELD)=58.7) G FORDS1
        I SCDXDT<2980000,($G(FIELD)=58.2)!($G(FIELD)=50.2)!($G(FIELD)=58.6)!($G(FIELD)=58.7)!($G(FIELD)=.04) D CDSIT^ONCODSR Q:('$D(X))!($G(FIELD)=.04)  I NTXDD=1 S V="00" D NT^ONCODSR K SCDXDT Q
FORDS1  D
        .I X="00" S X=0
        .S HST14=$E($$GET1^DIQ(165.5,D0,22.1),1,4)
        .I $$HEMATO^ONCFUNC(D0) S ICD=67420
        .I ICD'=67420 S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" S Y="" Q
        .;ROADS D-cxliii
        .I ($G(FIELD)=58.2)!($G(FIELD)=50.2),($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141
        .I ($G(FIELD)=58.2)!($G(FIELD)=50.2),TOP=67422 S ICD=67770
        .S FOUND=0
        .F XSP=0:0 S XSP=$O(^ONCO(164,ICD,"SPS",XSP)) Q:XSP'>0!(FOUND=1)  D
        ..I ($G(FIELD)=58.6)!($G(FIELD)=58.7),$P(^ONCO(164,ICD,"SPS",XSP,0),U,1)["ROADS" Q
        ..I $P(^ONCO(164,ICD,"SPS",XSP,0),U,2)=X S X=XSP,FOUND=1 Q
        .I FOUND=0 K X Q
        .W "  ",$P(^ONCO(164,ICD,"SPS",X,0),U,1)
        Q:$G(FIELD)=.04
        I $D(X),NTXDD=1 S V=1 D NT^ONCODSR Q
        K FOUND,HST14,ICD,SCDXDT,TOP,XSP
        Q
        ;
SPSOT   ;OUTPUT TRANSFORM
        S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" S Y="" Q
        S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" Q
        S ICD=""
        I (TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424)!($E(TOP,3,4)=76)!(TOP=67809),($G(FIELD)=58.6)!($G(FIELD)=58.7) G FORDS2
        I SCDXDT<2980000,($G(FIELD)=58.2)!($G(FIELD)=50.2)!($G(FIELD)=58.6)!($G(FIELD)=58.7)!($G(FIELD)=.04) D CDSOT^ONCODSR Q
FORDS2  D
        .Q:Y=""
        .S HST14=$E($$GET1^DIQ(165.5,D0,22.1),1,4)
        .I $$HEMATO^ONCFUNC(D0) S ICD=67420
        .I ICD'=67420 S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" S Y="" Q
        .;ROADS D-cxliii
        .I ($G(FIELD)=58.2)!($G(FIELD)=50.2),($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141
        .I ($G(FIELD)=58.2)!($G(FIELD)=50.2),TOP=67422 S ICD=67770
        .S Y=$S($P($G(^ONCO(164,ICD,"SPS",Y,0)),U,2)=0:"0",1:"")_$P($G(^ONCO(164,ICD,"SPS",Y,0)),U,2)_" "_$P($G(^ONCO(164,ICD,"SPS",Y,0)),U,1)
        K HST14,ICD,SCDXDT,TOP
        Q
        ;
SPSHP   ;HELP
        N SYSDIS
        S SYSDIS=""
        S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W !,"No PRIMARY SITE" Q
        S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" Q
        I (TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424)!($E(TOP,3,4)=76)!(TOP=67809),($G(FIELD)=58.6)!($G(FIELD)=58.7) G FORDS3
        I SCDXDT<2980000,($G(FIELD)=58.2)!($G(FIELD)=50.2)!($G(FIELD)=58.6)!($G(FIELD)=58.7)!($G(FIELD)=.04) D HP1^ONCODSR Q
FORDS3  D
        .S (EX,CTR)=0
        .S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W !,"No TOPOGRAPHY!" Q
        .S HST14=$E($$GET1^DIQ(165.5,D0,22.1),1,4)
        .I $$HEMATO^ONCFUNC(D0) S ICD=67420,SYSDIS=1
        .I SYSDIS="" S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" W !,"No ICD Codes!" Q
        .;ROADS D-cxliii
        .I ($G(FIELD)=58.2)!($G(FIELD)=50.2),($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141
        .I ($G(FIELD)=58.2)!($G(FIELD)=50.2),TOP=67422 S ICD=67770
        .I $G(SYSDIS)=1 W !?3,"SURGICAL PROCEDURE codes for systemic disease: ",!
        .E  W !?3,"SURGICAL PROCEDURE codes for site ",$P($G(^ONCO(164,TOP,0)),U,2)," ",$P($G(^ONCO(164,TOP,0)),U,1),": ",!
        .S XSP="" F  S XSP=$O(^ONCO(164,ICD,"SPS","C",XSP)) Q:XSP=""  S SPSIEN=$O(^ONCO(164,ICD,"SPS","C",XSP,0)) D  Q:EX=U
        ..S CTR=CTR+1 I CTR#20=0 D P Q:EX=U
        ..I $P($G(^ONCO(164,ICD,"SPS",SPSIEN,0)),U,2)=0 W !?6,"00",?12,$P($G(^ONCO(164,ICD,"SPS",SPSIEN,0)),U,1) Q
        ..I ($G(FIELD)=58.6)!($G(FIELD)=58.7),$P($G(^ONCO(164,ICD,"SPS",SPSIEN,0)),U,1)["ROADS" Q
        ..W !?6,$P($G(^ONCO(164,ICD,"SPS",SPSIEN,0)),U,2),?12,$P($G(^ONCO(164,ICD,"SPS",SPSIEN,0)),U,1)
        W !
        K CTR,EX,HST14,ICD,SCDXDT,SPSIEN,TOP,XSP
        Q
        ;
P       D  Q:EX=U  W !
        .W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
        Q
        ;
SMIT    ;SURGICAL MARGINS (165.5,59) INPUT
        S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" K X Q
        I SCDXDT<2980000 D  I $D(X) S V=8 D NT^ONCODSR Q
        .I X>2,X<8 K X Q
        .W "  ",$S(X=0:"No residual tumor",X=1:"Microscopic residual tumor",X=2:"Macroscopic residual tumor",X=8:"Not applicable",X=9:"Unknown",1:"")
        I SCDXDT>2971231 D
        .S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W "  No TOPOGRAPHY!" K X Q
        .S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" K X Q
        .S FOUND=0
        .F XSM=0:0 S XSM=$O(^ONCO(164,ICD,"SM5",XSM)) Q:XSM'>0!(FOUND=1)  D
        ..I $P(^ONCO(164,ICD,"SM5",XSM,0),U,2)=X S X=XSM,FOUND=1 Q
        .I FOUND=0 K X Q
        .W "  ",$P(^ONCO(164,ICD,"SM5",X,0),U,1)
        I $D(X) S V=6 D NT^ONCODSR
        K SCDXDT,FOUND,ICD,TOP,XSM Q
        ;
SMOT    ;OUTPUT
        S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" Q
        I SCDXDT<2980000 D
        .S Y=$S(Y=0:"0 No residual tumor",Y=1:"1 Microscopic residual tumor",Y=2:"2 Macroscopic residual tumor",Y=8:"8 Not applicable",Y=9:"9 Unknown",1:"")
        I SCDXDT>2971231 D
        .Q:Y=""
        .S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" S Y="" Q
        .S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" S Y="" Q
        .S Y=$P($G(^ONCO(164,ICD,"SM5",Y,0)),U,2)_" "_$P($G(^ONCO(164,ICD,"SM5",Y,0)),U,1)
        K SCDXDT,ICD,TOP Q
        ;
SMHP    ;HELP
        S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" Q
        I SCDXDT<2980000 D
        .W !?3,"Select from the following list:"
        .W !?6,"0",?12,"No residual tumor"
        .W !?6,"1",?12,"Microscopic residual tumor"
        .W !?6,"2",?12,"Macroscopic residual tumor"
        .W !?6,"8",?12,"Not applicable"
        .W !?6,"9",?12,"Unknown"
        I SCDXDT>2971231 D
        .S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W !,"No TOPOGRAPHY!" Q
        .S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" W !,"No ICD Codes!" Q
        .W !?3,"Select from the following list:",!
        .F XSM=0:0 S XSM=$O(^ONCO(164,ICD,"SM5",XSM)) Q:XSM'>0  W !?6,$P($G(^ONCO(164,ICD,"SM5",XSM,0)),U,2),?12,$P($G(^ONCO(164,ICD,"SM5",XSM,0)),U,1)
        K SCDXDT,ICD,TOP,XSM Q
        ;
CLEANUP ;Cleanup
        K D0,FIELD,NTXDD,SR,V,Y
