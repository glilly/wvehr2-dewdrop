BPSOSS8 ;BHAM ISC/FCS/DRS/FLS - Edit Basic ECME Parameters ;06/01/2004
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 Q
EN ;EP - Option BPS SETUP BASIC PARAMS
 N DIE,DA,DR,DIDEL,DTOUT
 W !!,"Edit Pharmacy ECME configuration",!
 ;
 ; If the BPS Setup record is not created, create it.
 ; Quit if there is an error.
 I $D(^BPS(9002313.99,1,0)) S DA=1
 E  S DA=$$INIT()
 ;
 ; Check for errors
 I DA'=1!'$D(^BPS(9002313.99,1,0)) D  Q
 . W !!,"BPS Setup not defined and can not be created.  Quitting."
 ;
 ; Prompts and input
 S DIE=9002313.99
 S DR="3.01R~ECME timeout? (0 to 30 seconds) //10"
 D ^DIE
 Q
 ;
 ; INIT - Create record 1 in the BPS SETUP file
INIT() ;
 ; Set up .01 node and call UPDATE
 N FN,IEN,FDA,MSG
 S FN=9002313.99,IEN(1)=1
 S FDA(FN,"+1,",.01)="MAIN SETUP ENTRY"
 S FDA(FN,"+1,",3.01)=10
 D UPDATE^DIE("","FDA","IEN","MSG")
 Q +$G(IEN(1))
