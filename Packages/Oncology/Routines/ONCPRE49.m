ONCPRE49        ;Hines OIFO/GWB - PRE-INSTALL routine for patch ONC*2.11*49
        ;;2.11;ONCOLOGY;**49**;Mar 07, 1995;Build 38
        ;
        ;Delete LETTER TYPE (#160.06,6) to remove SCREEN
        S DIK="^DD(160.06,",DA=6,DA(1)=160.06 D ^DIK
        K DA,DIK
        ;
ITEM9   ;OTHER STAGING FOR ONCOLOGY (#164.3)
        K ^ONCO(164.3)
        ;
ITEM11  ;CHEMOTHERAPEUTIC DRUGS (#164.18)
        K ^ONCO(164.18)
        ;
        ;KILL ID node to remove NSC NUMBER (#164.18,1) IDENTIFIER
        ;Supported by IA #5378
        K ^DD(164.18,0,"ID",1)
        ;
        ;Delete NSC NUMBER (#164.18,1) to remove "C" cross-reference
        S DIK="^DD(164.18,",DA=1,DA(1)=164.18 D ^DIK
        K DA,DIK
        ;
        ;Delete CHEMOTHERAPEUTIC AGENT #1-3 (#165.5,1423-1423.2) to remove
        ;OUTPUT TRANSFORMs
        S DIK="^DD(165.5,",DA=1423,DA(1)=165.5 D ^DIK
        S DIK="^DD(165.5,",DA=1423.1,DA(1)=165.5 D ^DIK
        S DIK="^DD(165.5,",DA=1423.2,DA(1)=165.5 D ^DIK
        K DA,DIK
        ;
ITEM13  ;ADDITIONAL SERVICE INDICATORS
        ;Kill PERSIAN GULF SERVICE (#160,51) to remove extraneous 9.1 node
        S DIK="^DD(160,",DA=51,DA(1)=160 D ^DIK
        K DA,DIK
        ;
ITEM19  ;ONCOLOGY DATA EXTRACT FORMAT (#160.16)
        K ^ONCO(160.16)
        Q
