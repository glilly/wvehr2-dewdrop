PPPST09 ;ALB/JFP - PPP, SET TRIGGER IN FOREIGN FILE;01MAR94
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; This routine re set the SET/KILL logic for the cross reference
 ; in file 2, field .09 (SSN).  This code has been approved by the
 ; SAC.
 ;
EN ; -- Main entry point
 D DPT
 QUIT
 ;
REINDX ; -- Re-index new cross reference
 S DIK="^DD("_DA(2)_","_DA(1)_",1," D IX1^DIK
 ;
 W !,?3,"- Cross-reference added to field ",DA(1)," (",$P(^DD(DA(2),DA(1),0),"^",1),") of file ",DA(2)
 ;
 QUIT
 ;
DPT ; Changes call in SET/KILL statement of cross reference from A1AY to PPP
 ;
 N DA,DIE,DR,PPPFND
 ;
 S DA=0,PPPFND=0
 F  S DA=$O(^DD(2,.09,1,DA)) Q:DA<1  D
 .I $G(^(DA,0))="2^AD^MUMPS" D
 ..S PPPFND=1
 ..W !!,">>> Changing Set  statement in AD Xref of ^DPT, field SSN to call PPPFMX"
 ..S DIE="^DD(2,.09,1,",DA(1)=1
 ..S DR="1///S PPP=X,X=""PPPFMX"" X ^%ZOSF(""TEST"") D:$T SNSSN^PPPFMX S X=PPP K PPP"
 ..D ^DIE
 ..W "...Done"
 ..;
 ..W !!,">>> Changing Kill statement in AD Xref of ^DPT, field SSN to call PPPFMX"
 ..S DIE="^DD(2,.09,1,",DA(1)=1
 ..S DR="2///S PPP=X,X=""PPPFMX"" X ^%ZOSF(""TEST"") D:$T KNSSN^PPPFMX S X=PPP K PPP"
 ..D ^DIE
 ..W "...Done"
 I 'PPPFND D
 .W !!,"Error... AD Xref of ^DPT, field SSN is required"
 .W !,"Call ISC SUPPORT for assistance"
 Q
 ;
