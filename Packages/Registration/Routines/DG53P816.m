DG53P816        ;ALB/MJB - FY10 TREATING SPECIALTIES ; 3/12/07 7:21am
        ;;5.3;Registration;**816**;Aug 13, 1993;Build 2
        ;
        Q
        ;
EDIT    ;Edit treating specialties
        ;
        N DS,DIE,DR,DGI,DA,DGERR,DIC,DGSPEC
        S DIE="^DIC(42.4,"
        S DIC(0)="X"
        F DGI=1:1 S DGSPEC=$P($T(ETRSP+DGI),";;",2) Q:DGSPEC="QUIT"  D
        . S DGERR=0
        . S DA=$P(DGSPEC,U)
        . S DR=".01///"_$P(DGSPEC,U,2)_";1///"_$P(DGSPEC,U,3)_";3///"_$P(DGSPEC,U,4)_";4///"_$P(DGSPEC,U,5)_";5///"_$P(DGSPEC,U,6)_";6///"_$P(DGSPEC,U,7)
        . D ^DIE
        . D BMES^XPDUTL("  ")
        . D BMES^XPDUTL("  ")
        . D BMES^XPDUTL(">>>"_$P(DGSPEC,U)_" code updated to "_$P(DGSPEC,U,2)_" in the Specialty file.>>>")
        Q
ETRSP   ;;PTF CODE^SPECIALTY^PRINT NAME^SERVICE^ASK PSYCH^BILLING BEDSECTION^CDR/MPCR
        ;;18^NEUROLOGY OBSERVATION^^NEUROLOGY^NO^NEUROLOGY^1151^^
        ;;QUIT
        Q
