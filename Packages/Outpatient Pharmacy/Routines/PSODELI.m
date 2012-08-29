PSODELI ;IHS/DSD/JCM - DELETE ENTRIES IN APSP INTERVENTION FILE ; 03/28/93 21:15
 ;;7.0;OUTPATIENT PHARMACY;**10,268**;DEC 1997;Build 9
 ;
 ; This routine is called by the option that delete entries in
 ; the APSP INTERVENTION file.
 ; These options are locked with the PSZMGR key.
 ; 
 ; External Calls : ^DIE,^DIC,^DIR
 ;-----------------------------------------------------------------
START ;
 K DIC,DR,DIE,DA
 D INTERV ; Sets up DIC and DIE calls for files
END D EOJ ; Cleans up variables
 Q
 ;------------------------------------------------------------------
INTERV ; Deletes entries from APSP INTERVENTION file
 W !,"You may only delete entries entered on the current day.",!
 S PSODELI("QFLG")=0,APSP("LOG DEL FLG")="INTERV"
 F PSODELI=0:0 S DIC(0)="QEAM",(PSODELI("DIC"),DIC)="^APSPQA(32.4,",DIC("S")="I DT=$P(^(0),U,1)" Q:PSODELI("QFLG")  D DEL
 Q
DEL ; Does actual lookup and deletion of entries
 K PSODELI("DA")
 D ^DIC K DIC,DA,DR
 I Y=-1 S PSODELI("QFLG")=1 G DELX
 S PSODELI("DA")=+Y
 S DIR(0)="Y",Y=0,DIR("A")="SURE YOU WANT TO DELETE THE ENTIRE ENTRY"
 D ^DIR K DIR
 G:$D(DIRUT)!('Y) DELX
 S DIE=PSODELI("DIC"),DA=PSODELI("DA"),DR=".01///@",DIDEL=9009032.4
 L +^APSPQA(32.4,PSODELI("DA")):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3)
 D ^DIE K DIE,DA,DR
 L -^APSPQA(32.4,PSODELI("DA"))
DELX ; Exit point from DEL
 K DIC,DIR,DA,X,Y,PSODELI("DIC")
 Q
EOJ ; Clean up variables
 K PSODELI,APSP("LOG DEL FLG"),X,Y,DIRUT,DTOUT,DUOUT
 K DIC,DIK,DA,DR,DIDEL
 Q
