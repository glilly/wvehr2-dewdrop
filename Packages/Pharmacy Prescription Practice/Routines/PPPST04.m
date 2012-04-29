PPPST04 ;ALB/JFP/DAD - post inits for prescription practices;01MAR94
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**2**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
PARMEDT ; Set up the parameter file
 ;
 N DIK,DA,DIC,X,Y,DIE,DR,DUOUT,DTOUT,SITE
 N DLAYGO,DIDEL
 ;
 W !!,">>> Setting Up PPP Parameter File..."
 S (DLAYGO,DIDEL)=1020.1
 S SITE=$$SITE^VASITE,SITE=$S($P(SITE,"^",1)'=-1:$P(SITE,"^",3),1:0)
 S DA=1,DIK="^PPP(1020.1," D ^DIK:$D(^PPP(1020.1,1,0))
 ;
 W !
 S DIC(0)="L",DIC=1020.1,X=1,DIC("DR")="4///[""VAH"",""PPS""]"
 D ^DIC
 I +Y>0 D
 .S DIE=1020.1,DA=+Y,DR="1//7;9//7;2//30;6//YES;7//NO;8//"_SITE_";10//30;11//365;12;13"
 .D ^DIE
 E  W !,*7,"Error Initializing PARAMETER File."
 Q
 ;
DOMXREF ; Build the domain cross-reference
 ;
 N DOMAIN,IFN,STATION,DIC,X,Y,DINUM,DD,DO
 ;
 W !!,">>> Setting Up Station Vs. Domain Cross-Reference..."
 W !!,"This routine will DELETE your existing PPP DOMAIN XREF file"
 W !,"(if it exists) and then create it using your current DOMAIN file.",!
 ;S DIR(0)="Y"
 ;S DIR("A")="Do you wish to continue"
 ;S DIR("B")="YES"
 ;D ^DIR K DIR
 S Y=1
 I Y D
 .W !,">>> Loading PPP Domain Cross-reference..."
 .S DOMAIN=""
 .S DIC="^PPP(1020.8,",DIC(0)=""
 .K ^PPP(1020.8)
 .S ^PPP(1020.8,0)="PPP DOMAIN XREF^1020.8P^^"
 .F  S DOMAIN=$O(^DIC(4.2,"B",DOMAIN)) Q:DOMAIN=""  D
 ..S IFN=$O(^DIC(4.2,"B",DOMAIN,0)) Q:'IFN
 ..I '$P($G(^DIC(4.2,IFN,0)),"^",13) W !!,"Station Number missing for "_DOMAIN,! Q
 ..S STATION=$O(^DIC(4,"D",$P($G(^DIC(4.2,IFN,0)),"^",13),0)) ;Q:'STATION
 ..W !,"Filing Station ",STATION," as ",DOMAIN,"..."
 ..I '$D(^DIC(4,+STATION,0)) W !,"...(Station # not in INSTITUTION file)" Q
 ..S X=STATION,DINUM=X
 ..S DIC("DR")=".02///"_DOMAIN
 ..K DD,DO D FILE^DICN
 ..I +Y>0 W "Filed"
 ..E  W "...(Error)"
 Q
