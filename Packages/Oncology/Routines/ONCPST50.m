ONCPST50        ;Hines OIFO/GWB - POST-INSTALL ROUTINE FOR PATCH ONC*2.11*50 ;03/27/09
        ;;2.11;ONCOLOGY;**50**;Mar 07, 1995;Build 29
        ;
ITEM6   ;Change FIN (160.19,.01) for NEW YORK VA MEDICAL CENTER from 10000000
        ;to 10000033 
        S DIC="^ONCO(160.19,",X=10000000 D ^DIC
        I Y'=-1 S DIE="^ONCO(160.19,",DA=+Y,DR=".01///10000033" D ^DIE
        ;
        ;Change NAME (160.19,.02) for NEW YORK VA MEDICAL CENTER to ZZNEW YORK
        ;VA MEDICAL CENTER 
        S DIC="^ONCO(160.19,",X=6213585 D ^DIC
        I Y'=-1 S DIE="^ONCO(160.19,",DA=+Y,DR=".02///ZZNEW YORK VA MEDICAL CENTER" D ^DIE
        K DA,DIC,DIE,DR,Y
        ;
ITEM7   ;Change SEER COUNTY CODE (5.1,2) for MIAMI-DADE from 025 (or null) to
        ;086
        ;Change NAME (5.1,.01) values to match PATIENT file COUNTY (2,.117)
        ;values
        S DIE="^VIC(5.1,",DA=1129,DR="2///086" D ^DIE
        S DIE="^VIC(5.1,",DA=1090,DR=".01///ST. JOHNS;2///109" D ^DIE
        S DIE="^VIC(5.1,",DA=1695,DR=".01///ST. CLAIR;2///147" D ^DIE
        S DIE="^VIC(5.1,",DA=1628,DR=".01///ST. JOSEPH;2///141" D ^DIE
        S DIE="^VIC(5.1,",DA=2223,DR=".01///ST. CHARLES;2///183" D ^DIE
        S DIE="^VIC(5.1,",DA=2173,DR=".01///ST. CLAIR;2///163" D ^DIE
        S DIE="^VIC(5.1,",DA=1808,DR=".01///ST. CROIX;2///109" D ^DIE
        S DIE="^VIC(5.1,",DA=1811,DR=".01///ST. CROIX" D ^DIE
        S DIE="^VIC(5.1,",DA=2219,DR=".01///ST. FRANCOIS;2///187" D ^DIE
        S DIE="^VIC(5.1,",DA=2216,DR=".01///ST. LOUIS;2///189" D ^DIE
        S DIE="^VIC(5.1,",DA=2222,DR=".01///ST. LOUIS (CITY);2///510" D ^DIE
        S DIE="^VIC(5.1,",DA=374,DR=".01///ST. THOMAS;2///030" D ^DIE
        ;
        ;Add ST. CROIX, ST. JOHN and ST. GENEVIEVE counties
        F IEN=0:0 S IEN=$O(^VIC(5.1,"B","ST. CROIX",IEN)) Q:IEN'>0  D
        .S STCROIX($P(^VIC(5.1,IEN,0),U,2))=""
        I '$D(STCROIX(78)) D
        .K DD,DO
        .S DIC="^VIC(5.1,"
        .S DIC(0)="L"
        .S DIC("DR")="1///78;2///010",X="ST. CROIX" D FILE^DICN
        K STCROIX
        ;
        I '$D(^VIC(5.1,"B","ST. JOHN")) D
        .K DD,DO
        .S DIC="^VIC(5.1,"
        .S DIC(0)="L"
        .S DIC("DR")="1///78;2///020",X="ST. JOHN" D FILE^DICN
        ;
        I '$D(^VIC(5.1,"B","ST. GENEVIEVE")) D
        .K DD,DO
        .S DIC="^VIC(5.1,"
        .S DIC(0)="L"
        .S DIC("DR")="1///29;2///186",X="ST. GENEVIEVE" D FILE^DICN
        ;
        ;Convert COUNTY AT DX (165.5,10) pointer values of 2553 to 187
        F IEN=0:0 S IEN=$O(^ONCO(165.5,IEN)) Q:IEN'>0  D
        .S CNTDX=$P($G(^ONCO(165.5,IEN,1)),U,3)
        .I CNTDX=2553 S $P(^ONCO(165.5,IEN,1),U,3)=187
        ;
        ;Delete COUNTY (5.1) entry 2553 (SAINT BERNARD)
        S DIK="^VIC(5.1,",DA=2553 D ^DIK
        ;
        ;Convert COUNTY AT DX (165.5,10) pointer values of 2280 to 2216
        F IEN=0:0 S IEN=$O(^ONCO(165.5,IEN)) Q:IEN'>0  D
        .S CNTDX=$P($G(^ONCO(165.5,IEN,1)),U,3)
        .I CNTDX=2280 S $P(^ONCO(165.5,IEN,1),U,3)=2216
        ;
        ;Delete COUNTY (5.1) entry 2280 (SAINT LOUIS)
        S DIK="^VIC(5.1,",DA=2280 D ^DIK
        ;
        ;Convert COUNTY (5.11,2) pointer values of 2280 to 2216
        ;Convert COUNTY (5.11,2) pointer values of 2553 to 187
        S $P(^VIC(5.11,66001,0),U,3)=2216
        S $P(^VIC(5.11,71034,0),U,3)=187
        K CNTDX,DA,DIC,DIE,DIK,DR,IEN,X
        ;
ITEM24  ;Re-stage 2003+ cases
        D ^ONCRESTG
