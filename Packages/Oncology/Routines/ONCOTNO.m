ONCOTNO ;Hines OIFO/GWB - TNM output formatting ;06/23/10
        ;;2.11;ONCOLOGY;**1,6,7,11,15,27,32,35,47,49,50,51**;Mar 07, 1995;Build 65
        ;
SGOUT(IEN)      ;AJCC stage formatted for display
        N G,SG,XX,XXX
        S XX=$G(^ONCO(165.5,D0,2))
        I STGIND="C" D
        .S XXX=$G(^ONCO(165.5,D0,2))
        .S SG=$P(XXX,U,20)
        I STGIND="P" D
        .S XXX=$G(^ONCO(165.5,D0,2.1))
        .S SG=$P(XXX,U,4)
        I STGIND="O" D
        .S XXX=$G(^ONCO(165.5,D0,2.1))
        .S SG=$P(XXX,U,9)
        I STGIND="R" D
        .S XXX=$G(^ONCO(165.5,D0,23,DA,0))
        .S SG=$P(XXX,U,9)
        N ONCOZ,XSG
        S ONCOZ=$E(SG)
        S XSG=$S(ONCOZ=1:"I",ONCOZ=2:"II",ONCOZ=3:"III",ONCOZ=4:"IV",ONCOZ=8:8,ONCOZ=9:9,1:ONCOZ)
        S XSG=XSG_$E(SG,2,$L(SG))
        S SG=XSG_" ("_$$TNMOUT(IEN)_")"
        ;
        ;Bone and Soft Tissue Sarcoma Histopathologic Grade "G" suffix
        I ($G(SP)=67400)!($G(SP)=67490) D
        .S G=$P(^ONCO(165.5,D0,2),U,5)
        .S:($G(G)=9)!($G(G)="") G="X"
        .S SG=XSG_" ("_$$TNMOUT(IEN)_" G"_G_")"
        ;
        ;Gastrointestinal Stromal Tumor MITOTIC RATE (165.5,239)
        I ($E($$HIST^ONCFUNC(D0),1,4)=8935)!($E($$HIST^ONCFUNC(D0),1,4)=8936) N MR D
        .S MR=$$GET1^DIQ(165.5,D0,239)
        .S SG=XSG_" ("_$$TNMOUT(IEN)_")"_" "_MR
        Q SG
        ;
TNMOUT(IEN)     ;TNM coding formatted for display
        N CM,COC,G,GS,II,ONCOM,ONCON,ONCOT,ONCOTNM,PSA,TOP,XXX
        S ONCOTNM=""
        S ONCOED=$$TNMED^ONCOU55(IEN)
        S TOP=$P($G(^ONCO(165.5,IEN,2)),U,1)
        I STGIND="C" D
        .S XXX(2)=$G(^ONCO(165.5,IEN,2))
        .S XXX(3)=$G(^ONCO(165.5,IEN,3))
        .S ONCOT=$P(XXX(2),U,25)
        .S ONCON=$P(XXX(2),U,26)
        .S ONCOM=$P(XXX(2),U,27)
        I STGIND="P" D
        .S XXX(2)=$G(^ONCO(165.5,IEN,2.1))
        .S XXX(3)=$G(^ONCO(165.5,IEN,3))
        .S ONCOT=$P(XXX(2),U,1)
        .S ONCON=$P(XXX(2),U,2)
        .S ONCOM=$P(XXX(2),U,3)
        .S CM=$P($G(^ONCO(165.5,IEN,2)),U,27)
        .I $G(CMPFLG)'="COMPUTING TNM" K CMPFLG Q
        .I (ONCOT'="X")!(ONCON'="X"),$E(ONCOM,1)'=1,CM'="X" S ONCOM=CM
        I STGIND="O" D
        .S XXX(2)=$G(^ONCO(165.5,IEN,2.1))
        .S XXX(3)=$G(^ONCO(165.5,IEN,3))
        .S ONCOT=$P(XXX(2),U,6)
        .S ONCON=$P(XXX(2),U,7)
        .S ONCOM=$P(XXX(2),U,8)
        I STGIND="R" D
        .S XXX(2)=$G(^ONCO(165.5,IEN,23,DA,0))
        .S XXX(3)=$G(^ONCO(165.5,IEN,3))
        .S ONCOT=$P(XXX(2),U,6)
        .S ONCON=$P(XXX(2),U,7)
        .S ONCOM=$P(XXX(2),U,8)
        I ONCOT'="" D
        .S ONCOTNM="T"_ONCOT
        .N ONCOMULT S ONCOMULT=$P($G(^ONCO(165.5,D0,2)),U,31) ;multiple tumors
        .I ONCOMULT S ONCOTNM=ONCOTNM_"m" S:ONCOMULT>1 ONCOTNM=ONCOTNM_ONCOMULT
        .N ONCOMT S ONCOMT=""
        .I STGIND="C" D
        ..S:$P($G(^ONCO(165.5,D0,0)),U,16)<2980000 ONCOMT=$P($G(^ONCO(165.5,D0,7)),U,16)
        .I STGIND="P" D
        ..S ONCOMT=$P($G(^ONCO(165.5,D0,7)),U,17)
        .S COC=$E($$GET1^DIQ(165.5,D0,.04),1,2)
        .I COC=38 S ONCOTNM="a"_ONCOTNM ;a Prefix
        .I ONCOMT="Y" S ONCOTNM="y"_ONCOTNM ;Multimodality therapy
        .I TOP=67692,$P(XXX(2),U,32) S ONCOTNM=ONCOTNM_"f" ;Family History
        .I TOP=67692,$P(XXX(3),U,30) S ONCOTNM=ONCOTNM_"d" ;Diffuse Retinal Involvement
        S:(ONCOTNM'="")&(ONCON'="") ONCOTNM=ONCOTNM_" "
        S:ONCON'="" ONCOTNM=ONCOTNM_"N"_ONCON
        S:(ONCOTNM'="")&(ONCOM'="") ONCOTNM=ONCOTNM_" "
        S:ONCOM'="" ONCOTNM=ONCOTNM_"M"_ONCOM
        ;I TOP=67619 S G=$P(^ONCO(165.5,D0,2),U,5),ONCOTNM=ONCOTNM_" G"_G
        I TOP=67619 D
        .I ONCOED<7 S G=$P(^ONCO(165.5,D0,2),U,5),ONCOTNM=ONCOTNM_" G"_G Q
        .S PSA=+$$GET1^DIQ(165.5,D0,684)
        .I (PSA=999.7)!(PSA=999.8)!(PSA=999.9) S PSA=""
        .S GS=+$$GET1^DIQ(165.5,D0,623,"I")
        .I GS=99 S GS=""
        .S ONCOTNM=ONCOTNM_" PSA"_PSA_" GS"_GS
        I $$GTT^ONCOU55(D0) D  K RF
        .S:$G(STGIND)="C" RF=$$GET1^DIQ(165.5,D0,134,"I")
        .S:$G(STGIND)="P" RF=$$GET1^DIQ(165.5,D0,135,"I")
        .S:$G(STGIND)="O" RF=$$GET1^DIQ(165.5,D0,134,"I")
        .S RF=$S(RF=0:"0RF",(RF=1)!(RF=2):"1RF",RF=3:"2RF",RF="U":"Unknown",RF="L":"Low risk",RF="H":"High risk",1:RF)
        .S ONCOTNM=ONCOTNM_" "_RF
        I $$T^ONCOU55(D0) D  K STM
        .S STM=$P($G(^ONCO(165.5,D0,24)),U,8)
        .S ONCOTNM=ONCOTNM_" "_STM
        Q ONCOTNM
        ;
CLEANUP ;Cleanup
        K D0,DA,ONCOED,SP,STGIND
