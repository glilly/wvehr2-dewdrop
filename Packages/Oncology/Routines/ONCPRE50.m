ONCPRE50        ;Hines OIFO/GWB - PRE-INSTALL routine for patch ONC*2.11*50
        ;;2.11;ONCOLOGY;**50**;Mar 07, 1995;Build 29
        ;
ITEM8   ;ADDITIONAL SERVICE INDICATORS
        ;Kill AGENT ORANGE EXPOSURE (160,48) and
        ;IONIZING RADIATION EXPOSURE (160,50) to remove extraneous 9.1 nodes
        S DIK="^DD(160,",DA=48,DA(1)=160 D ^DIK
        S DIK="^DD(160,",DA=50,DA(1)=160 D ^DIK
        K DA,DIK
        ;
ITEM16  ;ONCOLOGY DATA EXTRACT FORMAT (#160.16)
        K ^ONCO(160.16)
        K ^ONCO(160.17)
        ;
        ;Delete MIDDLE NAME (160,.015) to remove extranious 9.2 and 9.3 nodes
        S DIK="^DD(160,",DA=.015,DA(1)=160 D ^DIK
