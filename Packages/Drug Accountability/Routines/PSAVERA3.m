PSAVERA3 ;BHM/DB - RECORD TRANSACTION & UPDATE DRUG FILE;31JAN00
 ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**21,42**; 10/24/97
 ;
 ;References to ^PSDRUG( are covered by IA #2095
 ;References to ^DIC(51.5 are covered by IA #1931
 ;
OU S DIC(0)="QAEMZ",DIC="^DIC(51.5,",DIC("A")="Select New Order Unit: "
 D ^DIC G Q:+Y'>0 S PSAOU=+Y
 I $G(PSAOU)=$G(PSAAOU) W !,"No change." G Q
 S DIR("B")=$S($P($G(^PSDRUG(PSADRG,660)),"^",5)'="":$P($G(^PSDRUG(PSADRG,660)),"^",5),1:"Blank")
 S DIR(0)="NO^::2",DIR("A")="DISPENSE UNITS PER ORDER UNIT"
 S DIR("?")="Enter the number of dispense units contained in one order unit",DIR("??")="^D DUOUHELP^PSAPROC3"
 D ^DIR K DIR I $G(DTOUT)!($G(DUOUT)) S PSAOUT=1 G Q
 S PSANDUOU=+Y
 S $P(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,2),"^")=+Y S:+Y PSASET=1
 ;
DRG K PSASUB S X1=0 F  S X1=$O(^PSDRUG(PSADRG,1,X1)) Q:X1'>0  S DATA=$G(^PSDRUG(PSADRG,1,X1,0)) I $P(DATA,"^",1)=PSANDC S PSASUB=X1
 W !,"Old Dispense Units Per Order Unit: "_$P($G(^PSDRUG(PSADRG,660)),"^",5),?45,"Price Per Disp. Unit: "_$J($P($G(^PSDRUG(PSADRG,660)),"^",6),8,2)
 W !,"New Dispense Units Per Order Unit: "_PSANDUOU
 I PSANDUOU=$P($G(^PSDRUG(PSADRG,660)),"^",5) W ?45," unchanged " G UPDATE
 W ?64,$J((PSAPRICE/PSANDUOU),8,2)
UPDATE ;update file
 I $G(PSANDC)'="",$L(PSANDC)'=11 D
 .I $G(PSANDC)'="" S X=11,X1=$L(PSANDC) F X=1:1:(11-X1) S PSANDC="0"_PSANDC ;*42 11 digit NDC
 .S NDC0=1 F X=1:1:$L(PSANDC) I $E(PSANDC,X)'=0&($E(PSANDC,X)'="-") K NDC0
 .I $G(NDC0)=1 S PSANDC=""
 D PSANDC1^PSAHELP S PSADASH=PSANDCX K PSANDCX
 I $P($G(^PSDRUG(PSADRG,2)),"^",4)'=$G(PSADASH) S DIE="^PSDRUG(",DA=PSADRG,DR="31////^S X=PSADASH" D ^DIE
 S PSANPDU=PSAPRICE/PSANDUOU
 W !,"Updating Drug File's Synonym data"
 I $G(PSASUB)=""!('$D(^PSDRUG(PSADRG,1))) S DA(1)=PSADRG,DIC="^PSDRUG("_DA(1)_",1,",DIC(0)="L",X=PSANDC,DLAYGO=50 D ^DIC S PSASUB=+Y
 S DA(1)=PSADRG,DIE="^PSDRUG("_DA(1)_",1,",DA=PSASUB,DR="401////^S X=PSAOU;403////^S X=PSANDUOU;404////^S X=PSANPDU" D ^DIE
 W !,"Updating Drug File's Dispense Units Per Order Unit & Price Per Dispense Unit"
 K DR,DIE
 S DIE="^PSDRUG("_DA(1),DR="12///^S X=PSAOU;13////^S X=PSAPRICE;Q;15////^S X=PSANDUOU" D ^DIE
 S PSADJFLD="O",PSADJ=PSAOU,PSAREA="" D RECORD^PSAVER2
 W !,"making adjustment in DRUG ACCOUNTABILITY ORDER file"
 W !,"TAKING A BREAK !?"
 Q
Q Q
