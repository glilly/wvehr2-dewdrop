ONCNTX1 ;Hines OIFO/GWB - No treatment stuffing ;09/09/10
        ;;2.11;ONCOLOGY;**15,16,19,22,25,26,27,32,36,37,38,39,41,42,45,46,51**;Mar 07, 1995;Build 65
        ;
NCDSATF ;SURG DX/STAGING PROC @FAC (165.5,58.4)
        S $P(^ONCO(165.5,DA,3.1),U,5)="00"
        S $P(^ONCO(165.5,D0,3.1),U,6)="0000000"
        S DR="58.4;58.5" D DIQ1^ONCNTX
        W:$D(NTX) !,"SURG DX/STAGING PROC @FAC.....: "_ONC(165.5,DA,58.4,"E")
        W !,"SURG DX/STAGING PROC @FAC DATE: ",ONC(165.5,DA,58.5,"E")
        Q
        ;
SURATFR ;SURGERY OF PRIMARY @FAC (R) (165.5,50.2)
        S $P(^ONCO(165.5,DA,3.1),U,7)=$S(DATEDX>2971231:1,1:"00")
        S DR=50.2 D DIQ1^ONCNTX
        W:$D(NTX) !,"SURGERY OF PRIMARY @FAC.....(R): ",ONC(165.5,DA,50.2,"E")
        K ONC
        Q
        ;
SURATF  ;SURGERY OF PRIMARY @FAC (F) (165.5,58.7)
        N TOPX
        S TOPX=$P($G(^ONCO(165.5,DA,2)),U,1)
        I (TOPX=67420)!(TOPX=67421)!(TOPX=67423)!(TOPX=67424)!($E(TOPX,3,4)=76)!(TOPX=67809) D  G SUR1
        .S $P(^ONCO(165.5,DA,3.1),U,30)=1
        S $P(^ONCO(165.5,DA,3.1),U,30)=$S(DATEDX>2971231:1,1:"00")
SUR1    S $P(^ONCO(165.5,DA,3.1),U,8)="0000000"
        S $P(^ONCO(165.5,DA,2.3),U,4)=0
        S DR="58.7;50.3;234" D DIQ1^ONCNTX
        W:$D(NTX) !,"SURGERY OF PRIMARY @FAC.....(F): ",ONC(165.5,DA,58.7,"E")
        W !,"APPROACH.......................: ",ONC(165.5,DA,234,"E")
        W !,"MOST DEFINITIVE SURG @FAC DATE.: ",ONC(165.5,DA,50.3,"E")
        K ONC,TXDT Q
        ;
NODATFR ;SCOPE OF LN SURGERY @FAC (R) (165.5,138.1)
        S $P(^ONCO(165.5,DA,3.1),U,9)=1
        S $P(^ONCO(165.5,DA,3.1),U,11)="00"
        S DR="138.1;140.1" D DIQ1^ONCNTX
        W:$D(NTX) !,"SCOPE OF LN SURGERY @FAC....(R): ",ONC(165.5,DA,138.1,"E")
        W !,"NUMBER OF LN REMOVED @FAC...(R): ",ONC(165.5,DA,140.1,"E")
        Q
        ;
NODEATF ;SCOPE OF LN SURGERY @FAC (F) (165.5,138.5)
        S $P(^ONCO(165.5,DA,3.1),U,32)=0
        S $P(^ONCO(165.5,D0,3.1),U,23)="0000000"
        S DR="138.5;138.3" D DIQ1^ONCNTX
        W:$D(NTX) !,"SCOPE OF LN SURGERY @FAC....(F): ",ONC(165.5,DA,138.5,"E")
        W !,"SCOPE OF LN SURGERY @FAC DATE..: ",ONC(165.5,DA,138.3,"E")
        Q
        ;
SPOATFR ;SURG PROC/OTHER SITE @FAC (R) (165.5,139.1)
        S $P(^ONCO(165.5,DA,3.1),U,10)=1
        S DR=139.1 D DIQ1^ONCNTX
        W:$D(NTX) !,"SURG PROC/OTHER SITE @FAC...(R): ",ONC(165.5,DA,139.1,"E")
        Q
        ;
SOSATFR ;SURG PROC/OTHER SITE @FAC (R) (165.5,139.1)
        S $P(^ONCO(165.5,DA,3.1),U,10)=1
        S DR=139.1 D DIQ1^ONCNTX
        W:$D(NTX) !,"SURG PROC/OTHER SITE @FAC...(R): ",ONC(165.5,DA,139.1,"E")
        Q
        ;
SOSNATF ;SURG PROC/OTHER SITE @FAC (F) (165.5,139.5)
        S $P(^ONCO(165.5,DA,3.1),U,34)=0
        S $P(^ONCO(165.5,D0,3.1),U,25)="0000000"
        S DR="139.5;139.3" D DIQ1^ONCNTX
        W:$D(NTX) !,"SURG PROC/OTHER SITE @FAC...(F): ",ONC(165.5,DA,139.5,"E")
        W !,"SURG PROC/OTHER SITE @FAC DATE.: ",ONC(165.5,DA,139.3,"E")
        Q
        ;
RADATF  ;RADIATION @FAC (165.5,51.4)
        N RFNR
        S $P(^ONCO(165.5,DA,3.1),U,12)=0
        S RFNR=$P($G(^ONCO(165.5,DA,3)),U,35)
        I RFNR'=8 D
        .S $P(^ONCO(165.5,DA,3.1),U,13)="0000000"
        I RFNR=8 D
        .S $P(^ONCO(165.5,DA,3.1),U,13)=8888888
        S DR="51.4;51.5" D DIQ1^ONCNTX
        W:$D(NTX) !,"RADIATION @FAC.................: "_ONC(165.5,DA,51.4,"E")
        W !,"RADIATION @FAC DATE............: ",ONC(165.5,DA,51.5,"E")
        Q
        ;
RSSQ    ;RADIATION/SURGERY SEQUENCE (165.5,51.3)
        S $P(^ONCO(165.5,DA,3),U,7)=0
        W !,"RADIATION/SURGERY SEQUENCE.....: No rad and/or surg"
        Q
        ;
CHEMATF ;CHEMOTHERAPY @FAC (165.5,53.3)
        S $P(^ONCO(165.5,DA,3.1),U,14)="00"
        I $D(NTX) D
        .N DIE,DL,DP,DQ,DR
        .I COC=38 D
        ..W !,"CHEMOTHERAPY @FAC.............: None"
        .E  S DIE="^ONCO(165.5,",DR=53.3 D ^DIE
CMATFDT S $P(^ONCO(165.5,DA,3.1),U,15)="0000000"
        S DR=53.4 D DIQ1^ONCNTX
        W !,"CHEMOTHERAPY @FAC DATE........: ",ONC(165.5,DA,53.4,"E")
        W !
        Q
        ;
HTATF   ;HORMONE THERAPY @FAC (165.5,54.3)
        S $P(^ONCO(165.5,DA,3.1),U,16)="00"
        I $D(NTX) D
        .N DIE,DR,DP,DL,DQ
        .I COC=38 D
        ..W !,"HORMONE THERAPY @FAC..........: None"
        .E  S DIE="^ONCO(165.5,",DR=54.3 D ^DIE
HTATFDT S $P(^ONCO(165.5,DA,3.1),U,17)="0000000"
        S DR=54.4 D DIQ1^ONCNTX
        W !,"HORMONE THERAPY @FAC DATE.....: ",ONC(165.5,DA,54.4,"E")
        W !
        Q
        ;
IMMATF  ;IMMUNOTHERAPY @FAC (165.5,55.3)
        S $P(^ONCO(165.5,DA,3.1),U,18)="00"
        I $D(NTX) D
        .N DIE,DR,DP,DL,DQ
        .I COC=38 D
        ..W !,"IMMUNOTHERAPY @FAC............: None"
        .E  S DIE="^ONCO(165.5,",DR=55.3 D ^DIE
IMATFDT S $P(^ONCO(165.5,DA,3.1),U,19)="0000000"
        S DR=55.4 D DIQ1^ONCNTX
        W !,"IMMUNOTHERAPY @FAC DATE.......: ",ONC(165.5,DA,55.4,"E")
        W !
        Q
        ;
OTHATF  ;OTHER TREATMENT @FAC (165.5,57.3)
        I $G(X)'=7 S $P(^ONCO(165.5,DA,3.1),U,20)=0
        S $P(^ONCO(165.5,DA,3.1),U,21)="0000000"
        S DR="57.3;57.4" D DIQ1^ONCNTX
        W:$D(NTX) !,"OTHER TREATMENT @FAC..........: "_ONC(165.5,DA,57.3,"E")
        W !,"OTHER TREATMENT @FAC DATE.....: ",ONC(165.5,DA,57.4,"E")
        Q
        ;
HOR     ;HORMONE THERAPY (165.5,54.2)
        I $D(NTX) D
        .N DIE,DR,DP,DL,DQ
        .I COC=38 D
        ..W !,"HORMONE THERAPY...............: None"
        .E  S DIE="^ONCO(165.5,",DR=54.2 D ^DIE
        S TXDT=$P(^ONCO(165.5,DA,3),U,14)_"H"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        S $P(^ONCO(165.5,DA,3),U,14)="0000000" D HTDT^ONCATF1
        S ^ONCO(165.5,"ATX",DA,"0000000H")=""
        N DI,DIC,DIQ K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR=54 D EN^DIQ1
        W !,"HORMONE THERAPY DATE..........: ",ONC(165.5,DA,54,"E")
        K ONC Q
        ;
IMM     ;IMMUNOTHERAPY (165.5,55.2)
        I $D(NTX) D
        .N DIE,DR,DP,DL,DQ
        .I COC=38 D
        ..W !,"IMMUNOTHERAPY.................: None"
        .E  S DIE="^ONCO(165.5,",DR=55.2 D ^DIE
        S TXDT=$P(^ONCO(165.5,DA,3),U,17)_"B"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        S $P(^ONCO(165.5,DA,3),U,17)="0000000" D IMMDT^ONCATF1
        S ^ONCO(165.5,"ATX",DA,"0000000B")=""
        N DI,DIC,DIQ,X K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR=55 D EN^DIQ1
        W !,"IMMUNOTHERAPY DATE:...........: ",ONC(165.5,DA,55,"E")
        K ONC Q
        ;
HTEP    ;HEMA TRANS/ENDOCRINE PROC (165.5,153)
        I $D(NTX) D
        .N DIE,DR,DP,DL,DQ
        .I COC=38 D
        ..W !,"HEMA TRANS/ENDOCRINE PROC.....: No transplant proc/endocrine tx"
        .E  S DIE="^ONCO(165.5,",DR=153 D ^DIE
        S TXDT=$P(^ONCO(165.5,DA,3.1),U,35)_"E"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        S $P(^ONCO(165.5,DA,3.1),U,35)="0000000"
        S ^ONCO(165.5,"ATX",DA,"0000000E")=""
        N DI,DIC,DIQ,X K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR=153.1 D EN^DIQ1
        W !,"HEMA TRANS/ENDOCRINE PROC DATE: ",ONC(165.5,DA,153.1,"E")
        K ONC W ! Q
        ;
SSS     ;SYSTEMIC/SURGERY SEQUENCE (165.5,15)
        S $P(^ONCO(165.5,DA,3.1),U,39)=0
        W !,"SYSTEMIC/SURGERY SEQUENCE.....: No systemic and/or surgery"
        W !
        Q
        ;
OTH     ;OTHER TREATMENT (165.5,57.2)
        S TXDT=$P(^ONCO(165.5,DA,3),U,23)_"O"
        K ^ONCO(165.5,"ATX",DA,TXDT)
        S $P(^ONCO(165.5,DA,3),U,23)="0000000" D OTHDT^ONCATF1
        S ^ONCO(165.5,"ATX",DA,"0000000O")=""
        N DI,DIC,DIQ,X K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR="57.2;57" D EN^DIQ1
        W:$D(NTX) !,"OTHER TREATMENT...............: ",ONC(165.5,DA,57.2,"E")
        W !,"OTHER TREATMENT DATE:.........: ",ONC(165.5,DA,57,"E")
        K ONC Q
        ;
PRO     ;PROTOCOL PARTICIPATION (165.5,560)
        S $P(^ONCO(165.5,DA,"STS2"),U,31)="00"
        S $P(^ONCO(165.5,DA,3.1),U,4)="0000"
        N DI,DIC,DIQ K ONC S DIC="^ONCO(165.5,",DA=DA,DIQ="ONC(",DIQ(0)="E"
        S DR="133;560" D EN^DIQ1
        W !,"PROTOCOL PARTICIPATION........: ",ONC(165.5,DA,560,"E")
        W !,"YEAR PUT ON PROTOCOL..........: ",ONC(165.5,DA,133,"E")
        K ONC Q
        ;
RR      ;RECONSTRUCTION/RESTORATION (165.5,23)
        N LAST,NUM,RR,RTK
        F RTK=0:0 S RTK=$O(^ONCO(164,RTK)) Q:RTK'>0  D
        .I '$D(^ONCO(164,RTK,"RR5",0)) Q
        .W !,RTK
        .S NUM=$O(^ONCO(164,RTK,"RR5",0))
        .W !?3,"FIRST:",?11,NUM,?14,$G(^ONCO(164,RTK,"RR5",NUM,0))
        .F RR=0:0 S RR=$O(^ONCO(164,RTK,"RR5",RR)) Q:RR="B"  S LAST=RR
        .W !?3,"LAST :",?11,LAST,?14,$G(^ONCO(164,RTK,"RR5",LAST,0))
        Q
        ;
RRDEFIT ;RECONSTRUCTION/RESTORATION default (165.5,23)
        I X="No reconstruction/restoration" S X=0 Q
        I X="NA"!(X["Unknown; not stated") S X=9 Q
        Q
        ;
RFNSHLP ;REASON NO SURGERY OF PRIMARY (165.5,58) help
        W !,"   Record the reason that no surgery was perforned on the primary site."
        Q
        ;
RFNRHLP ;REASON FOR NO RADIATION (165.5,75) help
        W !,"   Records the reason that no regional radiation"
        W !,"   therapy was administered to the primary site."
        W !
        W !,"   For further information see FORDS page 168."
        Q
        ;
EXIT    W ! S Y="@424"
        Q
        ;
CLEANUP ;Cleanup
        K COC,D0,DA,DATEDX,NTX,Y
