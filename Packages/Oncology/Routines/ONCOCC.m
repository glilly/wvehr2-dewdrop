ONCOCC  ;HINES OIFO/GWB - CLASS OF CASE stuffing and @FAC defaults ;06/23/10
        ;;2.11;ONCOLOGY;**5,13,16,19,20,22,24,26,30,33,36,37,39,47,50,51**;Mar 07, 1995;Build 65
        ;
        ;CLASS OF CASE (165.5,.04) = 38 (Dx by autopsy at reporting facility)
        N COC,NTX,PAUSE
        S COC=$E($$GET1^DIQ(165.5,DA,.04,"E"),1,2)
        I COC=38 D  S Y=$S(PAUSE[U:"",ONCOANS="A":"@7",1:"@0")
        .W !?5,"CLASS OF CASE = 38 (Dx by autopsy at reporting facility)"
        .W !!?5,"All treatment fields will be stuffed with the appropriate"
        .W !?5,"value indicating no treatment.",!
        .D PAUSE I PAUSE[U Q
        .S NTX="" D NTX^ONCNTX
        .D HDR^ONCNTX
        .S $P(^ONCO(165.5,DA,3.1),U,26)=0
        .S $P(^ONCO(165.5,DA,3.1),U,27)=0
        .S $P(^ONCO(165.5,DA,"BLA2"),U,1)=0
        .S $P(^ONCO(165.5,DA,"STS"),U,31)="00"
        .S $P(^ONCO(165.5,DA,3.1),U,4)="0000"
        .W !,"PALLIATIVE CARE................: No palliative care"
        .W !,"PALLIATIVE CARE @FAC...........: No palliative care"
        .W !
        .W !,"PROTOCOL ELIGIBILITY STATUS....: Not available"
        .W !,"PROTOCOL PARTICIPATION.........: Not on/NA"
        .W !,"YEAR PUT ON PROTOCOL...........: 0000"
        .W !
        .D PAUSE
        Q
        ;
PAUSE   ;Enter RETURN to coninue" prompt
        W ! R "Enter RETURN to continue or '^' to exit: ",PAUSE:30
        I PAUSE="" Q
        I PAUSE=U Q
        G PAUSE
        ;
DNTDEL  ;Delete DATE OF NO TREATMENT (165.5,124)
        N TXDT
        I $P($G(^ONCO(165.5,DA,2.1)),U,11)'="" D
        .S TXDT=$P(^ONCO(165.5,DA,2.1),U,11)_"N"
        .S $P(^ONCO(165.5,DA,2.1),U,11)=""
        .K ^ONCO(165.5,"ATX",DA,TXDT)
        Q
        ;
SATFDFR ;SURGERY OF PRIMARY @FAC (R) (165.5,50.2) default
        N SGRP,SPS,TPG
        S SPS=$P($G(^ONCO(165.5,D0,3)),U,38)
        D SGROUP I TPG="" Q
        I (SPS="00")!(SPS=1)!($G(^ONCO(164,SGRP,"SPS",SPS,0))["Unknown") S Y="@427" Q
        S SPSDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .S SPSDF=$P($G(^ONCO(164,SGRP,"SPS",SPS,0)),U,1)
        .S:$P($G(^ONCO(165.5,D0,0)),U,16)<2980000 SPSDF=""
        Q
        ;
SATFDEF ;SURGERY OF PRIMARY @FAC (F) (165.5,58.7) default
        N SGRP,SPS,TPG
        S SPS=$P($G(^ONCO(165.5,D0,3.1)),U,29)
        I SPS="" Q
        D SGROUP I TPG="" Q
        I (SPS="00")!(SPS=1)!($G(^ONCO(164,SGRP,"SPS",SPS,0))["Unknown") S Y="@43" Q
        S (SPSDF,SPSDTDF)="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .S SPSDF=$P($G(^ONCO(164,SGRP,"SPS",SPS,0)),U,1)
        .S SPSDTDF=$$GET1^DIQ(165.5,D0,50,"E")
        .S:$P($G(^ONCO(165.5,D0,0)),U,16)<2980000 (SPSDF,SPSDTDF)=""
        Q
        ;
RATFDEF ;RADIATION @FACILITY (165.5,51.4) default
        N RD,XX,YY
        S RD=$P($G(^ONCO(165.5,D0,3)),U,6)
        S RADDF="",RADDTDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .I RD'="" D
        ..S XX=$F(^DD(165.5,51.2,0),RD_":")
        ..S YY=$F(^DD(165.5,51.2,0),";",XX)
        ..S RADDF=$E(^DD(165.5,51.2,0),XX,YY-2)
        .S RADDTDF=$P($G(^ONCO(165.5,D0,3)),U,4)
        Q
        ;
CATFDEF ;CHEMOTHERAPY @FAC (165.5,53.3) default
        N CH
        S CH=$P($G(^ONCO(165.5,D0,3)),U,13)
        S CHEMDF="",CHMDTDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .I CH'="" D
        ..S XX=$F(^DD(165.5,53.2,0),CH_":")
        ..S YY=$F(^DD(165.5,53.2,0),";",XX)
        ..S CHEMDF=$E(^DD(165.5,53.2,0),XX,YY-2)
        .S CHMDTDF=$P($G(^ONCO(165.5,D0,3)),U,11)
        Q
        ;
HATFDEF ;HORMONE THERAPY @FAC (165.5,54.3) default
        N HT
        S HT=$P($G(^ONCO(165.5,D0,3)),U,16)
        S HTDF="",HTDTDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .I HT'="" D
        ..S XX=$F(^DD(165.5,54.2,0),HT_":")
        ..S YY=$F(^DD(165.5,54.2,0),";",XX)
        ..S HTDF=$E(^DD(165.5,54.2,0),XX,YY-2)
        .S HTDTDF=$P($G(^ONCO(165.5,D0,3)),U,14)
        Q
        ;
IATFDEF ;IMMUNOTHERAPY @FAC (165.5,55.3) default
        N IMM
        S IMM=$P($G(^ONCO(165.5,D0,3)),U,19)
        S IMMDF="",IMMDTDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .I IMM'="" D
        ..S XX=$F(^DD(165.5,55.2,0),IMM_":")
        ..S YY=$F(^DD(165.5,55.2,0),";",XX)
        ..S IMMDF=$E(^DD(165.5,55.2,0),XX,YY-2)
        .S IMMDTDF=$P($G(^ONCO(165.5,D0,3)),U,17)
        Q
        ;
OATFDEF ;OTHER TREATMENT @FAC (165.5,57.3) default
        N OTH
        S OTH=$P($G(^ONCO(165.5,D0,3)),U,25)
        S OTHDF="",OTHDTDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .I OTH'="" D
        ..S XX=$F(^DD(165.5,57.2,0),OTH_":")
        ..S YY=$F(^DD(165.5,57.2,0),";",XX)
        ..S OTHDF=$E(^DD(165.5,57.2,0),XX,YY-2)
        .S OTHDTDF=$P($G(^ONCO(165.5,D0,3)),U,23)
        Q
        ;
PATFDEF ;PALLIATIVE PROCEDURE @FAC (165.5,13) default
        N COC,PP
        S COC=$E($$GET1^DIQ(165.5,DA,.04,"E"),1,2)
        S PP=$P($G(^ONCO(165.5,D0,3.1)),U,26)
        S PPDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .I PP'="" D
        ..S XX=$F(^DD(165.5,12,0),PP_":")
        ..S YY=$F(^DD(165.5,12,0),";",XX)
        ..S PPDF=$E(^DD(165.5,12,0),XX,YY-2)
        Q
        ;
SCOPER  ;SCOPE OF LN SURGERY @FAC (R) (165.5,138.1) default
        N SGRP,SCOPE,TPG
        S SCOPE=$P($G(^ONCO(165.5,D0,3)),U,40) I SCOPE="" Q
        D SGROUP I TPG="" Q
        S SCPDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .S SCPDF=$P($G(^ONCO(164,SGRP,"SC5",SCOPE,0)),U,1)
        Q
        ;
SCOPE   ;SCOPE OF LN SURGERY @FAC (F) (165.5,138.5) default
        ;SCOPE OF LN SURGERY @FAC DATE (165.5,138.3) default
        N SCOPE
        S SCOPE=$P($G(^ONCO(165.5,D0,3.1)),U,31) I SCOPE="" Q
        S (SCPDF,SCPDTDF)="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .I SCOPE'="" D
        ..S XX=$F(^DD(165.5,138.5,0),SCOPE_":")
        ..S YY=$F(^DD(165.5,138.5,0),";",XX)
        ..S SCPDF=$E(^DD(165.5,138.5,0),XX,YY-2)
        .S SCPDTDF=$P($G(^ONCO(165.5,D0,3.1)),U,22)
        Q
        ;
NUMN    ;NUMBER OF LN REMOVED @FAC (R) (165.5,140.1) default
        N NODES
        S NODES=$P($G(^ONCO(165.5,D0,3)),U,42)
        S NUMDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .S NUMDF=NODES
        .I NUMDF="00" S NUMDF=NUMDF_"  No nodes removed"
        .I NUMDF="90" S NUMDF=NUMDF_"  90 or more nodes removed"
        .I NUMDF="95" S NUMDF=NUMDF_"  No nodes removed, aspiration performed"
        .I NUMDF="96" S NUMDF=NUMDF_"  Node removal as a sampling, number unknown"
        .I NUMDF="97" S NUMDF=NUMDF_"  Node removal as dissection, number unknown"
        .I NUMDF="98" S NUMDF=NUMDF_"  Nodes surgically removed, number unknown"
        .I NUMDF="99" S NUMDF=NUMDF_"  Unknown, not stated, death cert ONLY"
        Q
        ;
SOSNR   ;SURG PROC/OTHER SITE @FAC (R) (165.5,139.1) default
        N SGRP,SOSN,TPG
        S SOSN=$P($G(^ONCO(165.5,D0,3)),U,41) I SOSN="" Q
        D SGROUP I TPG="" Q
        S SOSNDF="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .S SOSNDF=$P($G(^ONCO(164,SGRP,"SO5",SOSN,0)),U,1)
        Q
        ;
SOSN    ;SURG PROC/OTHER SITE @FAC (F) (165.5,139.5) default
        N SOSN
        S SOSN=$P($G(^ONCO(165.5,D0,3.1)),U,33) I SOSN="" Q
        S (SOSNDF,SOSNDTDF)="" I (COC=10)!(COC=11)!(COC=12)!(COC=13)!(COC=14)!(COC=20)!(COC=21)!(COC=22) D  Q
        .I SOSN'="" D
        ..S XX=$F(^DD(165.5,139.5,0),SOSN_":")
        ..S YY=$F(^DD(165.5,139.5,0),";",XX)
        ..S SOSNDF=$E(^DD(165.5,139.5,0),XX,YY-2)
        .S SOSNDTDF=$P($G(^ONCO(165.5,D0,3.1)),U,24)
        Q
        ;
SGROUP  S TPG=$P($G(^ONCO(165.5,D0,2)),U,1) I TPG="" Q
        S SGRP=$P($G(^ONCO(164,TPG,0)),U,16)
        Q
        ;
CLEANUP ;Cleanup
        K CHEMDF,CHMDTDF,D0,DA,HTDF,HTDTDF,IMMDF,IMMDTDF,NUMDF,OTHDF,OTHDTDF
        K PPDF,RADDF,RADDTDF,SCPDF,SCPDTDF,SOSNDF,SOSNDTDF,SPSDF,SPSDTDF,Y
