ONCPST49        ;Hines OIFO/GWB - POST-INSTALL ROUTINE FOR PATCH ONC*2.11*49 ;01/07/09
        ;;2.11;ONCOLOGY;**49**;Mar 07, 1995;Build 38
        ;
        S DIK="^ONCO(164.52," D IXALL^DIK
        K DIK
        ;
        S IEN=$O(^ONCO(160.19,"B",6999014,0))
        I IEN="" K IEN G ITEM23
        S NAME=$P(^ONCO(160.19,IEN,0),U,2)
        I NAME="" S DIK="^ONCO(160.19,",DA=IEN D ^DIK
        K DA,DIK,NAME
        ;
ITEM23  ;Change FIN (160.19,.01) for WEST PALM BEACH VA MEDICAL CENTER from
        ;6390003 to 10000011 
        S DIC="^ONCO(160.19,",X=6390003 D ^DIC
        I Y'=-1 S DIE="^ONCO(160.19,",DA=+Y,DR=".01///10000011" D ^DIE
        ;
        ;Change STATE (160.19,.04) for NEW YORK VA MEDICAL CENTER from IL to NY
        S DIC="^ONCO(160.19,",X=10000000 D ^DIC
        I Y'=-1 S DIE="^ONCO(160.19,",DA=+Y,DR=".04///NY" D ^DIE
        K DA,DIC,DIE,DR,X,Y
        Q
