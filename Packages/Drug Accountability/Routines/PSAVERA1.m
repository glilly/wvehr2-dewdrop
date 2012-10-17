PSAVERA1        ;BHM/DB - Edit previously verified invoices;16NOV99
        ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**21,61,63,70**; 10/24/97;Build 12
        ;References to ^DIC(51.5 are covered by IA #1931
        ;References to ^PSDRUG( are covered by IA #2095
        ;
        S $P(PSASLN,"=",79)="" K PSALINE
DISPLN  S PSALINE=$S('$D(PSALINE):$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,0)),1:$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE))) G Q:PSALINE'>0 S CNT=$G(CNT)+1
        S PSADATA=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,0))
        S PSATEMP=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,2))
        S PSAVSN=$P(PSADATA,"^",12),PSAOUT=0,PSADRUGN=""
DRUG    S PSADJ=+$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,"B","D",0))
        I $G(PSADJ) D
        .S PSANODE=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,PSADJ,0))
        .S PSADJD=$S($P(PSANODE,"^",6)'="":$P(PSANODE,"^",6),1:$P(PSANODE,"^",2))
        .S PSASUP=$S(PSADJD'?1.N:1,1:0)
        .S PSADRG=$S(PSADJ&('PSASUP):$G(PSADJD),PSADJ&(PSASUP):0,1:+$P(PSADATA,"^",2))
        .I $G(PSADJD),$L(PSADJD)=$L(+PSADJD),$P($G(^PSDRUG(+PSADJD,0)),"^")'="" S (PSADRG,PSA50IEN)=+PSADJD Q
        .I $G(PSADJD),$L(PSADJD)=$L(+PSADJD),$P($G(^PSDRUG(+PSADJD,0)),"^")="" S (PSADJ,PSADRG)=0 Q
        .S PSADJSUP=1,(PSADRG,PSA50IEN)=PSADJD
        I '$G(PSADJ) D
        .S (PSA50IEN,PSADRG)=$S(+$P(PSADATA,"^",2)&($P($G(^PSDRUG(+$P(PSADATA,"^",2),0)),"^")'=""):+$P(PSADATA,"^",2),1:0)
        I $G(PSASUP) S PSADRUGN=PSADRG_" - SUP/ITM"  ;;<- PSA*3*70 RJS
        S:'$G(PSADRUGN) PSADRUGN=$S($P($G(^PSDRUG(PSADRG,0)),"^")'="":$P($G(^PSDRUG(PSADRG,0)),"^"),1:"Unknown Drug Name/Supply Item")
QTY     ;Quantity
        ;No Adj. Qty
        S PSADJQ="",PSADJ=+$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,"B","Q",0))
        I $G(PSADJ) S PSANODE=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,PSADJ,0)),PSADJQ=$S($P(PSANODE,"^",6)'="":+$P(PSANODE,"^",6),1:$P(PSANODE,"^",2))
        ;Adj. Qty
        I $G(PSADJQ) S PSAQTY=PSADJQ
        I '$G(PSADJQ) S PSAQTY=$P(PSADATA,"^",3)
UPC     S:$P(PSADATA,"^",13) PSAUPC=$P(PSADATA,"^",13)
OU      ;W !,"Order Unit  : "
        S PSAOU=$S(+$P(PSADATA,"^",4)&($P($G(^DIC(51.5,+$P(PSADATA,"^",4),0)),"^")'=""):+$P(PSADATA,"^",4),1:"")
        S PSATEMP=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,2))
        I +$P(PSATEMP,"^",3),PSADRG,+$P($G(^PSDRUG(PSADRG,1,+$P(PSATEMP,"^",3),0)),"^",5) S PSAOU=+$P(^PSDRUG(PSADRG,1,+$P(PSATEMP,"^",3),0),"^",5)
        S PSADJO="",PSADJ=+$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,"B","O",0))
        I $G(PSADJ) S PSANODE=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,PSADJ,0)),PSADJO=$S($P(PSANODE,"^",6)'="":$P(PSANODE,"^",6),1:$P(PSANODE,"^",2))
        ;Adj. Order Unit
        I PSADJO'="" S PSAOU=+PSADJO
        I PSADJO="" ;W $S(+PSAOU:$P($G(^DIC(51.5,+PSAOU,0)),"^"),1:"Blank")
        ;
NDC     S PSANDC=$P(PSADATA,"^",11)
        ;I $E(PSANDC)'="S" W ?38,"NDC: "_$S(PSANDC'="":$E(PSANDC,1,6)_"-"_$E(PSANDC,7,10)_"-"_$E(PSANDC,11,12),1:"Blank")
        ;
PRICE   ;W !,"Unit Price  : $"
        S PSADJP=0,PSADJ=+$O(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,"B","P",0))
        I $G(PSADJ) S PSANODE=$G(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,1,PSADJ,0)),PSADJP=$S(+$P(PSANODE,"^",6):+$P(PSANODE,"^",6),1:+$P(PSANODE,"^",2))
        ;Adj. Unit Price
        I $G(PSADJP) D
        .I $L($P(PSADJP,".",2))<2 S PSADJP=$P(PSADJP,".")_"."_$P(PSADJP,".",2)_$E("00",1,(2-$L($P(PSADJP,".",2))))
        .;W $FN(PSADJP,",")_" ($"_$S(+$P(PSADATA,"^",5):$FN($P(PSADATA,"^",5),","),$P(PSADATA,"^",5)=0:"0.00",1:"")_")"
        .S PSAPRICE=PSADJP
        I '$G(PSADJP) D
        .S PSAPRICE=+$P(PSADATA,"^",5)
        .;I $G(PSAPRICE)!(PSAPRICE=0) W $S($G(PSAPRICE):PSAPRICE,1:"0.00") Q
        .;W "Blank"
        ;
VSN     ;W ?38,"VSN: "_$S(PSAVSN'="":PSAVSN,1:"Blank"),!
VDU     S PSADUOU=+$P(PSATEMP,"^"),PSAREORD=+$P(PSATEMP,"^",2),PSASUB=+$P(PSATEMP,"^",3),PSASTOCK=+$P(PSATEMP,"^",4)
        S INVARRAY(PSAORD,PSAINV,PSALINE)=$G(PSADRG)_"~"_$G(PSADRUGN)_"^"_$G(PSAQTY)_"^"_$G(PSALOC)_"^"_$G(PSAOU)_"^"_$G(PSANDC)_"^"_$G(PSAPRICE)_"^"_$G(PSAVSN)_"^"_$G(PSAUPC),PSASUP=0
        ;
        I '+$P($G(^PSD(58.8,+PSALOC,0)),"^",14) G DISPLN
        ;
STOCK   S PSASTOCK=$S(+PSASTOCK:+PSASTOCK,+$P($G(^PSD(58.8,+PSALOC,1,+PSADRG,0)),"^",3):+$P($G(^PSD(58.8,+PSALOC,1,+PSADRG,0)),"^",3),1:"Blank")
REORDER S PSAREORD=$S(+PSAREORD:+PSAREORD,+$P($G(^PSD(58.8,+PSALOC,1,+PSADRG,0)),"^",5):+$P($G(^PSD(58.8,+PSALOC,1,+PSADRG,0)),"^",5),1:"Blank")
        S INVARRAY(PSAORD,PSAINV,PSALINE)=$G(INVARRAY(PSAORD,PSAINV,PSALINE))_"^"_$G(PSASTOCK)_"^"_$G(PSAREORD)
        G DISPLN
ASK     R !!,"Enter an '^' to abort, <RET> to continue, or a corresponding line item number: ",AN:DTIME I AN="" G DISPLN
        I AN["^" G Q
        I AN<0!(AN>CNT) W !,"Enter a number between 1 and ",CNT G ASK
        S (PSALINE,PSALINEN)=AN
PROCSS  I '$D(^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,0)) W !,"Invalid line number." G ASK
        S PSADATA=^PSD(58.811,PSAIEN,1,PSAIEN1,1,PSALINE,0),PSASUP=0
        S PSANDC=$P(PSADATA,"^",11),PSAVSN=$P(PSADATA,"^",12),PSALOC=$S($P(PSADATA,"^",10):+$P(PSAIN,"^",12),1:+$P(PSAIN,"^",5))
VIEW    S PSALINEN=" " D VERDISP^PSAUTL4 W !,PSASLN,!
        W "1. Drug",!,"2. Order Unit",! S PSACHO=2
        S DIR(0)="LO^1:"_PSACHO,DIR("A")="Edit fields",DIR("?")="Enter the number(s) of the data to be edited" S DIR("??")="^D DDQOR^PSAVER3"
        D ^DIR K DIR I $G(DTOUT)!($G(DUOUT)) S PSAOUT=1 Q
        Q:Y=""  S PSAFLDS=Y,PSASET=0 ;D VERDISP^PSAUTL4 W PSASLN
FIELDS  F PSAPCF=1:1 S PSAFLD=$P(PSAFLDS,",",PSAPCF) Q:'PSAFLD!(PSAOUT)  D
        .I PSAFLD=1 D ASKDRUG^PSAVERA2 Q
        .I PSAFLD=2 D OU^PSAVER2 Q
Q       Q
        ;
UPDATE  ; *63 RJS CODE REMOVED FROM PSAVERA AND CALLED BY PSAVERA
        ;File data in 58.8
        ;PSALOC= Either PSALOC or PSALOCB
        S PSADRG=PSABFR
        F  L +^PSD(58.8,PSALOC,1,PSADRG,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  Q
        S PSADUREC=PSAQTY*$G(PSAODUOU),PSABAL=$P($G(^PSD(58.8,PSALOC,1,PSADRG,0)),"^",4),$P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",4)=PSABAL-$G(PSABFR("Q"))
        L -^PSD(58.8,PSALOC,1,PSADRG,0)
        S PSADRG=PSAAFTER,PSAABAL=PSABAL,PSADUREC=PSAQTY*$G(PSADUOU)
        D NOW^%DTC S PSADT=+$E(%,1,14)
        I '$D(^PSD(58.8,PSALOC,1,PSADRG,0)) D
        .S:'$D(^PSD(58.8,PSALOC,1,0)) DIC("P")=$P(^DD(58.8,10,0),"^",2)
        .S DA(1)=PSALOC,DIC="^PSD(58.8,"_DA(1)_",1,",(DA,DINUM,X)=PSADRG,DIC(0)="L",DLAYGO=58.8 ;*53
        .F  L +^PSD(58.8,PSALOC,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  Q
        .D FILE^DICN L -^PSD(58.8,PSALOC,0) K DIC,DA,DLAYGO
        F  L +^PSD(58.8,PSALOC,1,PSADRG,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  Q
        S PSABAL=$P($G(^PSD(58.8,PSALOC,1,PSADRG,0)),"^",4)
        I $P($G(^PSD(58.8,PSALOC,1,PSADRG,0)),"^",1)'=PSADRG S $P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",1)=PSADRG
        S $P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",4)=PSADUREC+PSABAL
        I +$P($G(^PSD(58.8,PSALOC,0)),"^",14) D
        .I PSASTOCK'=$P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",3) S $P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",3)=PSASTOCK
        .I PSAREORD'=$P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",5) S $P(^PSD(58.8,PSALOC,1,PSADRG,0),"^",5)=PSAREORD
        S:'$D(^PSD(58.8,PSALOC,1,PSADRG,5,0)) DIC("P")=$P(^DD(58.8001,20,0),"^",2)
        I '$D(^PSD(58.8,PSALOC,1,PSADRG,5,$E(DT,1,5)*100,0)) D
        .S DIC="^PSD(58.8,"_PSALOC_",1,"_PSADRG_",5,",DIC(0)="L",DIC("DR")="1////^S X=$G(PSABAL)",(X,DINUM)=$E(DT,1,5)*100,DA(2)=PSALOC,DA(1)=PSADRG,DLAYGO=58.8 D ^DIC K DIC
        .S X="T-1M" D ^%DT S DIC="^PSD(58.8,"_PSALOC_",1,"_PSADRG_",5,",DIC(0)="L",(X,DINUM)=$E(Y,1,5)*100 D ^DIC K DIC,DLAYGO S DA=+Y
        .S DA(2)=PSALOC,DA(1)=PSADRG,DIE="^PSD(58.8,"_DA(2)_",1,"_DA(1)_",5,",DR="3////^S X=$G(PSABAL)" D ^DIE K DIE
        S DA(2)=PSALOC,DA(1)=PSADRG,DIE="^PSD(58.8,"_DA(2)_",1,"_DA(1)_",5,",DA=$E(DT,1,5)*100,DR="5////^S X="_($P($G(^(0)),"^",3)+PSADUREC) D ^DIE K DIE
        L -^PSD(58.8,PSALOC,1,PSADRG,0)
        W !,"updating pharmacy location file."
FILE581 ;Update transaction file ;;*63
        S PSAVDUZ=DUZ,PSAREA="EDIT VERIFIED INVOICE"
        I '$G(PSABFR(581)) D NEW581 Q
        I PSADRG'=PSABFR S PSANQTY=0,PSAAQTY=$G(PSABFR("Q"))*-1
        I PSADRG=PSABFR S PSANQTY=PSADUREC D
        .S PSAAQTY=PSADUREC-$G(PSABFR("Q"))
FIND    S PSAT=$P(^PSD(58.81,0),"^",3)+1 I $D(^PSD(58.81,PSAT)) S $P(^PSD(58.81,0),"^",3)=$P(^PSD(58.81,0),"^",3)+1 G FIND
        S DIC="^PSD(58.81,",DIC(0)="L",DLAYGO=58.81,(DINUM,X)=PSAT D ^DIC K DIC,DINUM,DLAYGO L -^PSD(58.81,0)
        S DIE="^PSD(58.81,",DA=PSAT
        I PSAAFTER'=PSABFR S PSADRG=PSABFR
        S DR="1////14;2////^S X=PSALOC;3////^S X=PSADT;4////^S X=PSADRG;48////^S X=PSADT;49////^S X=PSAVDUZ;50////^S X=PSANQTY;51////^S X=PSAAQTY;53////^S X=PSAREA;54////^S X=PSAABAL;71////^S X=PSAINV;106////^S X=PSAORD"
        F  L +^PSD(58.81,DA,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  Q
        D ^DIE L -^PSD(58.81,DA,0) K DIE
        I PSAAFTER'=PSABFR S PSADRG=PSAAFTER D NEW581
        Q
        ;
NEW581  S PSAT=$P(^PSD(58.81,0),"^",3)+1 I $D(^PSD(58.81,PSAT)) S $P(^PSD(58.81,0),"^",3)=$P(^PSD(58.81,0),"^",3)+1 G NEW581
        S DIC="^PSD(58.81,",DIC(0)="L",DLAYGO=58.81,(DINUM,X)=PSAT D ^DIC K DIC,DINUM,DLAYGO L -^PSD(58.81,0)
        S PSADUREC=PSAQTY*$G(PSADUOU)
        S DIE="^PSD(58.81,",DA=PSAT,DR="1////1;2////^S X=PSALOC;3////^S X=PSADT;4////^S X=PSADRG;5////^S X=PSADUREC;6////^S X=PSAVDUZ;9////^S X=PSABAL;71////^S X=PSAINV;106////^S X=PSAORD"
        I $G(PSACS)>0 S DR=DR_";100////^S X=PSACS"
        F  L +^PSD(58.81,DA,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  Q
        D ^DIE L -^PSD(58.81,DA,0) K DIE W !,"updating transaction file." Q
        Q
