SROPOST0 ;B'HAM ISC/MAM,ADM  - POST INITS (CONT) ; 20 MAR 1992  12:00 pm
 ;;3.0; Surgery ;**2,20,24**;24 Jun 93
 I 'SRVER!'$D(^SRO(132.9)) D NEWSP Q
 W !!,"The post initialization process will now loop through the Surgery file to",!,"perform the following tasks:",!,"(1) Update the Anesthetist Category field"
 W !,"(2) Convert existing attending codes to correspond with the new set of codes",!,"(3) Clean up dangling 'LOCK' nodes",!,"(4) Update existing outcome to match new format"
 W !,"(5) Update surgery position entries to the new multiple format"
 W !!,"(A dot will be printed for every 100 cases processed) "
 S (CNT,SRTN)=0 F  S SRTN=$O(^SRF(SRTN)) Q:'SRTN  S CNT=CNT+1 W:'(CNT#100) "." K:'$D(^SRF(SRTN,0)) ^SRF(SRTN) I $D(^SRF(SRTN,0)) D ANUP,CODE,LOCK,POS,OUT,B
DEL W !!,"Deleting the ATTENDING CODE file (132.9)..."
 S DIU="^SRO(132.9,",DIU(0)="" D EN^DIU2 K ^SRO(132.9)
 W !!,"Now cleaning up dangling 'AL' and 'AUD' cross references." D CLEAN
 S X1=DT,X2="-30" D C^%DTC S SRSDATE=X-.0001 F  S SRSDATE=$O(^SRF("AC",SRSDATE)) Q:'SRSDATE  S SRTN=0 F  S SRTN=$O(^SRF("AC",SRSDATE,SRTN)) Q:'SRTN  D AR
 W !!,"Deleting 'WL' cross reference..." K ^SRO(133.8,"WL")
 W !!,"Re-indexing the SURGERY WAITING LIST file..."
 S DIK="^SRO(133.8," D IXALL^DIK
NEWSP W !!,"This portion of the post initialization routine will update the SURGICAL",!,"SPECIALTY file (45.3) if necessary."
 F SHEMP=500:1:502 S CURLEY=$O(^DIC(45.3,"B",SHEMP,0)) I 'CURLEY D SP
 K CNT,CODE,CURLEY,DA,DIC,DIE,DIK,DR,MM,MMM,SHEMP,SRSP,SRTN,X,Y
 Q
CODE S CODE=$P($G(^SRF(SRTN,.1)),"^",16) I CODE="" Q
 S Y=$P(^SRO(132.9,CODE,0),"^",2),CODE=$S(Y=0:0,Y=1:1,Y=2:2,1:3)
 K DR,DIE,DA S DR=".165////"_CODE,DA=SRTN,DIE=130 D ^DIE
 Q
ANUP ; set ANESTHETIST CATEGORY
 I $P($G(^SRF(SRTN,.3)),"^")="" Q
 K DIK S DA=SRTN,DIK="^SRF(",DIK(1)=".31^ANES" D EN1^DIK K DIK,DA
 Q
SP ; set specialty
 S SRSP=$S(SHEMP=500:"CARDIAC SURGERY",SHEMP=501:"TRANSPLANTATION",1:"ANESTHESIOLOGY")
 K DIE,DD,DIC,D0,DA S X=SHEMP,DIC="^DIC(45.3,",DIC(0)="L",DLAYGO=45.3 D FILE^DICN K DR,DLAYGO S DA=+Y,DIE=45.3,DR="1///"_SRSP W !!,"Adding "_SHEMP_" "_SRSP_" to the SURGICAL SPECIALTY file (45.3)..." D ^DIE K DR
 Q
POS ; update surgery position entries to multiple format
 I $P($G(^SRF(SRTN,.5)),"^",3)="" Q
 S ^SRF(SRTN,42,0)="^130.065P^1^1",^SRF(SRTN,42,1,0)=$P(^SRF(SRTN,.5),"^",3),$P(^SRF(SRTN,.5),"^",3)=""
 Q
OUT I $O(^SRF(SRTN,10,0)) S X=0 F  S X=$O(^SRF(SRTN,10,X)) Q:'X  S Y=$P(^SRF(SRTN,10,X,0),"^",6) D REPLACE S $P(^SRF(SRTN,10,X,0),"^",6)=MM
 I $O(^SRF(SRTN,16,0)) S X=0 F  S X=$O(^SRF(SRTN,16,X)) Q:'X  S Y=$P(^SRF(SRTN,16,X,0),"^",6) D REPLACE S $P(^SRF(SRTN,16,X,0),"^",6)=MM
 I $O(^SRF(SRTN,36,0)) S X=0 F  S X=$O(^SRF(SRTN,36,X)) Q:'X  S Y=$P(^SRF(SRTN,36,X,0),"^",2) D REPLACE S $P(^SRF(SRTN,36,X,0),"^",2)=MM
 Q
REPLACE S MM=$S(Y="N":"I",Y="E":"I",Y="P":"I",1:Y)
 Q
CLEAN ; clean up dangling 'AL' & 'AUD' x-refs
 S SRTN=0 F  S SRTN=$O(^SRF("AUD",SRTN)) Q:'SRTN  I '$D(^SRF(SRTN,0)) K ^SRF("AUD",SRTN)
 S SRTN=0 F  S SRTN=$O(^SRF("AL",SRTN)) Q:'SRTN  I '$D(^SRF(SRTN,0)) K ^SRF("AL",SRTN)
 Q
LOCK ; clean up dangling 'LOCK' nodes
 I $D(^SRF(SRTN,"LOCK")),'$D(^SRF(SRTN,0)) K ^SRF(SRTN,"LOCK")
 Q
AR ; create 'AR' x-ref
 S REQ=$P($G(^SRF(SRTN,"REQ")),"^") I 'REQ Q
 S SCH=$P($G(^SRF(SRTN,31)),"^",4) I SCH Q
 I $P($G(^SRF(SRTN,31)),"^",8)'=""!($P($G(^SRF(SRTN,30)),"^")'="") Q
 S DFN=$P(^SRF(SRTN,0),"^"),^SRF("AR",$E(SRSDATE,1,7),DFN,SRTN)=""
 Q
B ; delete B x-ref on anesthesia agent
 I $D(^SRF(SRTN,6)) S TECH=0 F  S TECH=$O(^SRF(SRTN,6,TECH)) Q:'TECH  K ^SRF(SRTN,6,TECH,1,"B")
 Q
P24 ; entry for update of surgery position for SR*3*24
 W !!,"This process will update surgery position entries to the multiple format.       "
 S (CNT,SRTN)=0 F  S SRTN=$O(^SRF(SRTN)) Q:'SRTN  S CNT=CNT+1 W:'(CNT#100) "." I '$O(^SRF(SRTN,42,0)) D POS
 K CNT,SRTN W !!,"Finished."
 Q
