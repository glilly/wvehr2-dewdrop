ONCUTX  ;Hines OIFO/GWB - Unknown treatment stuffing ;06/23/10
        ;;2.11;ONCOLOGY;**13,15,16,19,22,27,33,36,41,42,43,44,46,51**;Mar 07, 1995;Build 65
        ;
NCDS    ;SURGICAL DX/STAGING PROC (165.5,58.1)
        S $P(^ONCO(165.5,D0,3),U,31)=9999999
        W !,"SURGICAL DX/STAGING PROC DATE: 99/99/9999" D NCDSDT^ONCATF
        Q
        ;
SURR    ;SURGERY OF PRIMARY (R) (165.5,58.2)
        N SA,SCG,TOP
        S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" Q
        S SCG=$P($G(^ONCO(164,TOP,0)),U,16) I SCG="" Q
        S:$E(SCG,3,4)=77 SCG=67422
        S SA=$O(^ONCO(164,SCG,"SUA","C",9,0))
        S $P(^ONCO(165.5,D0,3),U,34)=SA
        N DIC,DIQ,DR K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR=74 D EN^DIQ1
        W !,"SURGICAL APPROACH...........(R): "_ONC(165.5,DA,74,"E")
        Q
        ;
SUR     ;SURGERY OF PRIMARY (F) (165.5,58.6)
        N SCG,TOP,TSDT,TXDT
        S TXDT=$P(^ONCO(165.5,DA,3),U,1)_"S1"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        S $P(^ONCO(165.5,DA,3),U,1)=9999999 D SPSDT^ONCATF
        S ^ONCO(165.5,"ATX",DA,"9999999S1")=""
        S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" Q
        S SCG=$P($G(^ONCO(164,TOP,0)),U,16) I SCG="" Q
        ;S:DATEDX>3091231 $P(^ONCO(165.5,D0,2.3),U,4)=9
        S $P(^ONCO(165.5,D0,3),U,28)=9
        S $P(^ONCO(165.5,DA,"THY1"),U,36)=9999999
        S $P(^ONCO(165.5,D0,3.1),U,28)=9
        N DIC,DIQ,DR K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR="50;74;59;23;138;435;14;234" D EN^DIQ1
        W !,"MOST DEFINITIVE SURG DATE......: "_ONC(165.5,DA,50,"E")
        ;W:DATEDX>3091231 !,"APPROACH.......................: "_$E(ONC(165.5,DA,234,"E"),1,40)
        W !,"SURGICAL MARGINS...............: "_$E(ONC(165.5,DA,59,"E"),1,40)
        W !,"DATE OF SURGICAL DISCHARGE.....: "_ONC(165.5,DA,435,"E")
        W !,"READMISSION W/I 30 DAYS/SURG...: "_ONC(165.5,DA,14,"E")
        Q
        ;
NODER   ;SCOPE OF LN SURGERY (R) (165.5,138)
        S $P(^ONCO(165.5,D0,3),U,42)=99 D NUMND^ONCATF
        N DR S DR=140 D DIQ1^ONCNTX
        W !,"NUMBER OF LN REMOVED........(R): "_ONC(165.5,DA,140,"E")
        Q
        ;
NODE    ;SCOPE OF LN SURGERY (F) (165.5,138.4)
        N TXDT
        S TXDT=$P($G(^ONCO(165.5,DA,3.1)),U,22)_"S2"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        S $P(^ONCO(165.5,D0,3.1),U,22)="0000000" D SCPDT^ONCATF
        S ^ONCO(165.5,"ATX",DA,"0000000S2")=""
        N DR S DR=138.2 D DIQ1^ONCNTX
        W !,"SCOPE OF LN SURGERY DATE.......: "_ONC(165.5,DA,138.2,"E")
        Q
        ;
SOSN    ;SURG PROC/OTHER SITE DATE (165.5,139.2)
        N TXDT
        S TXDT=$P($G(^ONCO(165.5,DA,3.1)),U,24)_"S3"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        S $P(^ONCO(165.5,D0,3.1),U,24)=9999999 D SOSNDT^ONCATF
        S ^ONCO(165.5,"ATX",DA,"9999999S3")=""
        N DR S DR="139.2" D DIQ1^ONCNTX
        W !,"SURGICAL PROC/OTHER SITE DATE..: "_ONC(165.5,DA,139.2,"E")
        Q
        ;
RAD     ;Radiation
        N RFNR,TXDT
        S RFNR=$P($G(^ONCO(165.5,DA,3)),U,35)
        I RFNR=8 D ^ONCRFNR G RAD1
        S TXDT=$P(^ONCO(165.5,DA,3),U,4)_"R"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        S $P(^ONCO(165.5,DA,3),U,4)=9999999 D RADDT^ONCATF1
        S ^ONCO(165.5,"ATX",DA,"9999999R")=""
RAD1    S $P(^ONCO(165.5,DA,3),U,22)=9
        S $P(^ONCO(165.5,DA,3),U,21)=42
        S $P(^ONCO(165.5,DA,"BLA2"),U,18)=19
        S $P(^ONCO(165.5,DA,"THY1"),U,43)=99999
        S $P(^ONCO(165.5,DA,24),U,9)=19
        S $P(^ONCO(165.5,DA,"THY1"),U,44)=99999
        S $P(^ONCO(165.5,DA,3),U,20)=999
        S $P(^ONCO(165.5,DA,"BLA2"),U,16)=9999999
        N DIC,DIQ K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        N DR S DR="51;126;125;363;442;363.1;443;56;361" D EN^DIQ1
        W !,"DATE RADIATION STARTED.........: ",ONC(165.5,DA,51,"E")
        W !,"LOCATION OF RADIATION..........: ",ONC(165.5,DA,126,"E")
        W !,"RADIATION TREATMENT VOLUME.....: ",ONC(165.5,DA,125,"E")
        W !,"REGIONAL TREATMENT MODALITY....: ",ONC(165.5,DA,363,"E")
        W !,"REGIONAL DOSE:cGy..............: ",ONC(165.5,DA,442,"E")
        W !,"BOOST TREATMENT MODALITY.......: ",ONC(165.5,DA,363.1,"E")
        W !,"BOOST DOSE:cGy.................: ",ONC(165.5,DA,443,"E")
        W !,"NUMBER OF TREATMENTS...........: ",ONC(165.5,DA,56,"E")
        W !,"DATE RADIATION ENDED...........: ",ONC(165.5,DA,361,"E")
        K ONC,TXDT Q
        ;
CHE     ;Chemotherapy
        N TXDT
        S TXDT=$P(^ONCO(165.5,DA,3),U,11)_"C"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        I X=88 D
        .S $P(^ONCO(165.5,DA,3),U,11)=8888888 D CHEMDT^ONCATF1
        .S ^ONCO(165.5,"ATX",DA,"8888888C")=""
        I X=99 D
        .S $P(^ONCO(165.5,DA,3),U,11)=9999999 D CHEMDT^ONCATF1
        .S ^ONCO(165.5,"ATX",DA,"9999999C")=""
        N DIC,DIQ,DR K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR=53
        D EN^DIQ1
        W !,"CHEMOTHERAPY DATE..............: "_ONC(165.5,DA,53,"E")
        K ONC Q
        ;
HOR     ;Hormone therapy
        N TXDT
        S TXDT=$P(^ONCO(165.5,DA,3),U,14)_"H"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        I X=88 D
        .S $P(^ONCO(165.5,DA,3),U,14)=8888888 D HTDT^ONCATF1
        .S ^ONCO(165.5,"ATX",DA,"8888888H")=""
        I X=99 D
        .S $P(^ONCO(165.5,DA,3),U,14)=9999999 D HTDT^ONCATF1
        .S ^ONCO(165.5,"ATX",DA,"9999999H")=""
        N DIC,DIQ,DR K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR=54 D EN^DIQ1
        W !,"HORMONE THERAPY DATE:..........: "_ONC(165.5,DA,54,"E")
        K ONC Q
        ;
IMM     ;Immunotherapy
        N TXDT
        S TXDT=$P(^ONCO(165.5,DA,3),U,17)_"B"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        I X=88 D
        .S $P(^ONCO(165.5,DA,3),U,17)=8888888 D IMMDT^ONCATF1
        .S ^ONCO(165.5,"ATX",DA,"8888888B")=""
        I X=99 D
        .S $P(^ONCO(165.5,DA,3),U,17)=9999999 D IMMDT^ONCATF1
        .S ^ONCO(165.5,"ATX",DA,"9999999B")=""
        N DIC,DIQ,DR K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR=55 D EN^DIQ1
        W !,"IMMUNOTHERAPY DATE:............: "_ONC(165.5,DA,55,"E")
        K ONC Q
        ;
HTEP    ;HEMA TRANS/ENDOCRINE PROC (165.5,153)
        N TXDT
        S TXDT=$P(^ONCO(165.5,DA,3.1),U,35)_"E"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        I HE=88 D
        .S $P(^ONCO(165.5,DA,3.1),U,35)=8888888
        .S ^ONCO(165.5,"ATX",DA,"8888888E")=""
        I HE=99 D
        .S $P(^ONCO(165.5,DA,3.1),U,35)=9999999
        .S ^ONCO(165.5,"ATX",DA,"9999999E")=""
        N DIC,DIQ,DR,X K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR=153.1 D EN^DIQ1
        W !,"HEMA TRANS/ENDOCRINE PROC DATE.: "_ONC(165.5,DA,153.1,"E")
        K ONC Q
        ;
OTH     ;Other treatment
        N TXDT
        S TXDT=$P(^ONCO(165.5,DA,3),U,23)_"O"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        S $P(^ONCO(165.5,DA,3),U,23)=9999999 D OTHDT^ONCATF1
        S ^ONCO(165.5,"ATX",DA,"9999999O")=""
        N DIC,DIQ,DR,X K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR="57" D EN^DIQ1
        W !,"OTHER TREATMENT DATE:..........: "_ONC(165.5,DA,57,"E")
        K ONC Q
        ;
PRO     ;Protocol
        S $P(^ONCO(165.5,DA,"STS2"),U,31)=99
        S $P(^ONCO(165.5,DA,3.1),U,4)=9999
        N DIC,DIQ,DR K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR="133;560" D EN^DIQ1
        W !,"PROTOCOL PARTICIPATION.........: "_ONC(165.5,DA,560,"E")
        W !,"YEAR PUT ON PROTOCOL...........: "_ONC(165.5,DA,133,"E")
        K ONC Q
        ;
EXIT    ;Exit
        W ! S Y="@113"
        Q
        ;
CLEANUP ;Cleanup
        K D0,DA,DATEDX,HE,Y
