PSAUDP  ;BIR/LTL,JMB-Nightly Background Job - CONT'D ;7/23/97
        ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**6,3,12,14,25,64,66**; 10/24/97;Build 2
        ;
        ;Reference to ^PS(57.6 are covered by IA #772
PICKLST ;ask for parameters PSA*3*25
        I '$D(^PSD(58.812,1,"T","B","UNIT DOSE"))!('$D(^PSD(58.812,1,"T"))) D
        .S ^PSD(58.812,1,"T",0)="^58.8123A^1^1"
        .S X="T-2W" D ^%DT S ^PSD(58.812,1,"T",1,0)="UNIT DOSE^"_Y_"^",X="T-1W" D ^%DT S $P(^PSD(58.812,1,"T",1,0),"^",3)=Y K X,Y
        .S ^PSD(58.812,1,"T","B","UNIT DOSE",1)=""
        S XX=$O(^PSD(58.812,1,"T","B","UNIT DOSE",0)) Q:XX'>0  S JOBIEN=XX D NOW^%DTC S STRTDATE=%,PARDATA=$G(^PSD(58.812,1,"T",JOBIEN,0))
        S PSABGN=$P(PARDATA,"^",2),PSAEND=$P(PARDATA,"^",3)
        S X="T-7" D ^%DT I Y'=PSAEND G DONE
        S $P(^PSD(58.812,1,"T",JOBIEN,0),"^",2)=PSAEND,X1=PSAEND,X2=7 D C^%DTC S $P(^PSD(58.812,1,"T",JOBIEN,0),"^",3)=X ;Reset date parameters
        ;Go back two weeks, gather 1 weeks worth of data
        S PSAD0=PSABGN-.000001
        S PSAEND=PSAEND_".2359"
DATE    ;Loop through dates
        S PSAD0=$O(^PS(57.6,PSAD0)) G DONE:PSAD0'>0 G DONE:PSAD0>PSAEND K PSAD1
WRD     S PSAD1=$S('$D(PSAD1):$O(^PS(57.6,PSAD0,1,0)),1:$O(^PS(57.6,PSAD0,1,PSAD1))) G DATE:PSAD1'>0 K PSAD2
PVDR    ;Loop through providers
        S PSAD2=$S('$D(PSAD2):$O(^PS(57.6,PSAD0,1,PSAD1,1,0)),1:$O(^PS(57.6,PSAD0,1,PSAD1,1,PSAD2))) G WRD:PSAD2'>0 K PSAD3
DRG     S PSAD3=$S('$D(PSAD3):$O(^PS(57.6,PSAD0,1,PSAD1,1,PSAD2,1,0)),1:$O(^PS(57.6,PSAD0,1,PSAD1,1,PSAD2,1,PSAD3))) G PVDR:PSAD3'>0 S DATA=$G(^PS(57.6,PSAD0,1,PSAD1,1,PSAD2,1,PSAD3,0))
        S PSAIP=PSAD1,PSA50=PSAD3,PSADT=PSAD0 K PSALOC
LOC     S PSALOC=$S('$D(PSALOC):$O(^PSD(58.8,"AB",PSAD1,0)),1:$O(^PSD(58.8,"AB",PSAD1,PSALOC))) G DRG:PSALOC'>0 I $D(^PSD(58.8,PSALOC,"I")),$P($G(^PSD(58.8,PSALOC,"I")),"^")'>DT G LOC
        S PSAQTY=$P($G(DATA),"^",2)-$P($G(DATA),"^",4)
        I $D(^PSD(58.8,PSALOC,1,PSA50)) D PROCESS
        G LOC
        ;
        Q
DONE    ;
END     K DA,DATA,DIC,DIE,DR,PSA50,PSAD0,PSAD1,PSAD2,PSAD3,PSADT,PSAIP,PSALOC,PSANUM,PSAQTY,X,Y,PSABGN,PSAEND,PARDATA,JOBIEN,X
        Q
PROCESS ;Stuff last UD dispensing fld with DT
        F  L +^PSD(58.8,PSALOC,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  Q
        S DIE="^PSD(58.8,",DA=PSALOC,DR="27////"_PSADT D ^DIE K DIE,DA,DR
        ;Subtract dispensing from balance
        S PSABAL=$P($G(^PSD(58.8,PSALOC,1,PSA50,0)),"^",4)
        S $P(^PSD(58.8,PSALOC,1,PSA50,0),"^",4)=PSABAL-$G(PSAQTY)
        ;If no monthly activity node, add node with beginning balance.
        I '$D(^PSD(58.8,PSALOC,1,PSA50,5,+$E(PSADT,1,5)*100,0)) D
        .S DIC="^PSD(58.8,PSALOC,1,PSA50,5,",DIC(0)="L",DIC("P")=$P(^DD(58.8001,20,0),U,2),(X,DINUM)=$E(PSADT,1,5)*100,DA(2)=PSALOC,DA(1)=PSA50
        .S DIC("DR")="1////^S X=$G(PSABAL)",DLAYGO=58.8 D ^DIC K DIC,DLAYGO
        .;Add current month's node and stuff beginning & ending balance.
        .S DIC="^PSD(58.8,PSALOC,1,PSA50,5,",DIC(0)="L",(X,DINUM)=$E(PSADT-100-(+$E(PSADT,4,5)=1*8800),1,5)*100,DA(2)=PSALOC,DA(1)=PSA50,DLAYGO=58.8 D ^DIC K DIC,DLAYGO S DA=+Y
        .S DIE="^PSD(58.8,PSALOC,1,PSA50,5,",DA(2)=PSALOC,DA(1)=PSA50,DR="3////^S X=$G(PSABAL)" D ^DIE K DIE
        ;Stuff total dispensed
        S DIE="^PSD(58.8,PSALOC,1,PSA50,5,",DA(2)=PSALOC,DA(1)=PSA50,DA=$E(PSADT,1,5)*100,DR="9////^S X=$P($G(^(0)),U,6)+PSAQTY" D ^DIE K DIE,DA
        ;Get next transaction node number
        F  L +^PSD(58.81,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  Q  ;; << *66 RJS
FIND    S PSANUM=$P(^PSD(58.81,0),"^",3)+1 I $D(^PSD(58.81,PSANUM)) S $P(^PSD(58.81,0),"^",3)=$P(^PSD(58.81,0),"^",3)+1 G FIND
        ;Add next transaction node with data.
        S DIC="^PSD(58.81,",DIC(0)="L",DLAYGO=58.81,(DINUM,X)=PSANUM D ^DIC K DIC,DLAYGO
        S DIE="^PSD(58.81,",DA=PSANUM
        S DR="1////2;2////^S X=PSALOC;3////^S X=PSADT;4////^S X=PSA50;5////^S X=PSAQTY;9////^S X=$G(PSABAL)" D ^DIE K DIE,DA
        L -^PSD(58.81,0)  ;; >> *66 RJS
        ;Add activity node
        S DIC="^PSD(58.8,PSALOC,1,PSA50,4,",DIC(0)="L",(X,DINUM)=PSANUM,DIC("P")=$P(^DD(58.8001,19,0),"^",2),DA(2)=PSALOC,DA(1)=PSA50,DLAYGO=58.8 D ^DIC K DA,DIC,DLAYGO
        L -^PSD(58.8,PSALOC,0)
        Q
