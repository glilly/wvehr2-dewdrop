VEPERCPT ;RED/DAOU ; 8/1/05 7:30pm
 ;;1.0;Code to clean out CPT codes;;;Build 1
 ;REMOVE COPYRIGHTED CPT FILES' DATA
 W !,"Removing CPT code data now",!
 K ^ICPT S ^ICPT(0)="CPT^81I"
 K ^DIC(81.1) S ^DIC(81.1,0)="CPT CATEGORY^81.1",^(0,"GL")="^DIC(81.1,"
 K ^DIC(81.3) S ^DIC(81.3,0)="CPT MODIFIER^81.3I",^(0,"GL")="^DIC(81.3,"
 S %=$P(^DD(757.02,1,0),U,2) I %'="RF" W !,"757.02,1 has changed" Q
 S $P(^DD(757.02,1,0),U,2)="F"
 S %=$P(^DD(757.02,2,0),U,2) I %'="RP757.03'" W !,"757.02,2 has changed" Q
 S $P(^DD(757.02,2,0),U,2)="P757.03'"
 S DA=0,DIE=757.02,DR="1///@;2///@"
 F  S DA=$O(^LEX(757.02,DA)) Q:DA'>0  D
 . S %=$P($G(^LEX(757.02,DA,0)),U,3)
 . I %=3!(%=4) D ^DIE
 . Q
 S $P(^DD(757.02,1,0),U,2)="RF"
 S $P(^DD(757.02,2,0),U,2)="RP757.03'"
 W !,"CPT Codes removed",!
 Q
