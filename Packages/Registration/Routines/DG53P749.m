DG53P749        ;ALB/MJB-UPDATE FOR FILE 11 ;5/10/07
        ;;5.3;Registration;**749**;Aug 13, 1993;Build 10
        N DA,DIE,D
        S DA=$O(^DIC(11,"B","WIDOW/WIDOWER",0))
        S DIE=11,DR=".01////WIDOWED"
        I DA'=4 Q
        D ^DIE
        Q
