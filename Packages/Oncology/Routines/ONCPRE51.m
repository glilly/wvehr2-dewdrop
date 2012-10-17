ONCPRE51        ;Hines OIFO/GWB - PRE-INSTALL routine for patch ONC*2.11*51 ;05/01/10
        ;;2.11;ONCOLOGY;**51**;Mar 07, 1995;Build 65
        ;
ITEM1   ;NAACCR Record Layout v12
        K ^ONCO(160.16) ;ONCOLOGY DATA EXTRACT FORMAT (160.16)
        K ^ONCO(164.45) ;AJCC STAGE GROUPING (164.45)
        K ^ONCO(165.3)  ;CLASS OF CASE (165.3)
        ;To fix Columbus corrupt #169 file
        K ^ONCO(169)    ;TYPE OF MULTIPLE TUMORS (169)
        ;
        ;Delete ZIPCODE (160.1,.03) to remove backed out changes
        S DIK="^DD(160.1,",DA=.03,DA(1)=160.1 D ^DIK
        ;
        ;Delete ZIP CODE (165,.119) to remove backed out changes
        S DIK="^DD(165,",DA=.119,DA(1)=165 D ^DIK
        ;
        ;Delete CLASS OF CASE (165.5,.04) to remove GROUP
        S DIK="^DD(165.5,",DA=.04,DA(1)=165.5 D ^DIK
        ;
        ;Delete STATE AT DX (165.5,16) to remove OUTPUT TRANSFORM
        S DIK="^DD(165.5,",DA=16,DA(1)=165.5 D ^DIK
        ;
        ;Delete DIAGNOSTIC CONFIRMATION (165.5,26) to remove GROUP
        S DIK="^DD(165.5,",DA=26,DA(1)=165.5 D ^DIK
        ;
        ;Delete LATERALITY (165.5,28) to remove GROUP
        S DIK="^DD(165.5,",DA=28,DA(1)=165.5 D ^DIK
        ;
        ;Delete RADIATION (165.5,51.2) to remove GROUP
        S DIK="^DD(165.5,",DA=51.2,DA(1)=165.5 D ^DIK
        ;
        ;Delete SURGICAL MARGINS (165.5,59) to remove GROUP
        S DIK="^DD(165.5,",DA=59,DA(1)=165.5 D ^DIK
        K DA,DIK
        ;
ITEM2   ;Change NAME (5.1,.01) values to match STATE file COUNTY (5.01,.01) values
        ;Change incorrect STATE (5.1,1) values 
        ;
        N DA,DIE,DR,UNKNOWN
        S UNKNOWN=$O(^DIC(5,"B","UNKNOWN",0))
        ;
        S DIE="^VIC(5.1,",DA=12,DR=".01///HUMBOLDT" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=69,DR=".01///DEKALB" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=96,DR=".01///BUENA VISTA" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=131,DR=".01///HUMBOLDT" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=199,DR=".01///DEBACA" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=210,DR=".01///MCKINLEY" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=268,DR=".01///SAN JUAN" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=287,DR=".01///PINAL" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=455,DR=".01///MERCER" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=611,DR=".01///BALTIMORE (CITY)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=689,DR=".01///COLONIAL HEIGHTS (CITY)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=839,DR=".01///STANLY" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=1138,DR=".01///DESOTO" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=1182,DR=".01///DEKALB" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=1323,DR=".01///DESOTO" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=2117,DR=".01///DUPAGE" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=2119,DR=".01///DEKALB" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=2246,DR=".01///ST. GENEVIEVE" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=2876,DR=".01///DEWITT" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=2949,DR=".01///ANGELINA" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3142,DR=".01///BERNALILLO" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3164,DR=".01///WESTERN (DISTRICT)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3166,DR=".01///KOROR" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3167,DR=".01///POHNPEI" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3168,DR=".01///CHUUK" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3239,DR=".01///DILLINGHAM (CA)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3241,DR=".01///BETHEL (CA)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3242,DR=".01///ALEUTIANS EAST" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3243,DR=".01///WADE HAMPTON (CA)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3245,DR=".01///YUKON-KOYUKUK (CA)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3246,DR=".01///VALDEZ-CORDOVA (CA)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3249,DR=".01///NOME (CA)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3250,DR=".01///SKAGWAY HOONAH ANGOON" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3254,DR=".01///SOUTHEAST FAIRBANKS (CA)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3256,DR=".01///WRANGELL-PETERSBURG (CA)" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3259,DR=".01///PRINCE WALES KETCHIKAN" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=436,DR="1///9" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=590,DR="1///24" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=713,DR="1///37" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=1779,DR="1///19" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=2684,DR="1///48" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=2769,DR="1///48" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3197,DR="1///6" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3218,DR=".01///SOUTHEAST FAIRBANKS (CA);1///2" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3219,DR=".01///ALEUTIANS EAST;1///2" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3260,DR=".01///OTHER;1///^S X=UNKNOWN" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=3261,DR=".01///OTHER;1///^S X=UNKNOWN" D ^DIE
        ;
        S DIE="^VIC(5.1,",DA=405,DR="1///^S X=UNKNOWN" D ^DIE
        ;
ITEM3   ;AJCC Cancer Staging 7th Edtion
        K ^ONCO(164)    ;ICDO TOPOGRAPHY (164)
        K ^ONCO(164.33) ;AJCC STAGE GROUP (164.45)
        ;Delete ACOS CODE (164.0103,2) (Duplicate of CODE (164.0103,1)
        S DIK="^DD(164.0103,",DA=2,DA(1)=164.0103 D ^DIK
        ;
ITEM8   ;Create new entry FEE BASIS FX in the FACILITY (160.19) file:
        I '$D(^ONCO(160.19,"B",6666666)) D
        .K DD,DO
        .S DIC="^ONCO(160.19,",DIC(0)="L"
        .S DIC("DR")=".02///FEE BASIS RX"
        .S X=6666666 D FILE^DICN
        ;
ITEM26  ;Create new entry ORLANDO VA MEDICAL CENTER in FACILTY (160.19) file
        I '$D(^ONCO(160.19,"B",10001023)) D
        .K DD,DO
        .S DIC="^ONCO(160.19,",DIC(0)="L"
        .S DIC("DR")=".02///ORLANDO VA MEDICAL CENTER;.03///ORLANDO;.04///FL"
        .S X=10001023 D FILE^DICN
        K DIC,X
        Q
