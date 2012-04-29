PPPVPPIN ;ALB/JFP - Pre-init code for PPP ; 01 MAR 94
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; This routine removes old cross refernnces
EN ;
 D DELX
 W !!,">>> The PPP cross reference will be added in a partial init of the"
 W !,"    VAQ - TRANSACTION file on field .02 (Current Status)."
 W !!,"Done",!
 Q
 ;
DELX ; -- Deletes A1AY and A1AY2 cross reference
 N DA,DIK
 W !!,">>> Removing 'A1AY' cross reference from VAQ TRANSACTION file."
 S DA=0
 F  S DA=$O(^DD(394.61,50,1,DA)) Q:DA<1  D
 .; -- naked set at DELX+4
 .I $G(^(DA,0))="394.61^A1AY^MUMPS" D
 ..S DIK="^DD(394.61,50,1,",DA(1)=50,DA(2)=394.61 D ^DIK
 ..W "... Done"
 ;
 W !!,">>> Removing 'A1AY2' cross reference from VAQ TRANSACTION file."
 S DA=0
 F  S DA=$O(^DD(394.618,.01,1,DA)) Q:DA<1  D
 .; -- naked set at DELX+11
 .I $G(^(DA,0))="394.618^A1AY2^MUMPS" D
 ..S DIK="^DD(394.618,.01,1,",DA(1)=.01,DA(2)=394.618 D ^DIK
 ..W "... Done"
 ;
 QUIT
 ;
