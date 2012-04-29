ECSUM1  ;BIR/JLP,RHK-Category and Procedure Summary (cont'd) ;7 Nov 2007
        ;;2.0; EVENT CAPTURE ;**4,19,23,33,47,95**;8 May 96;Build 26
ALLU    ;
        N UCNT,ECDO,ECCO,ECNT
        S (ECD,ECMORE,ECNT,ECDO,ECCO)=0,ECPG=$G(ECPG,1),ECSCN=$G(ECSCN,"B")
        F  S ECD=$O(^ECJ("AP",ECL,ECD)) Q:'ECD  D  Q:ECOUT
        .D SET,CATS,PAGE:'ECOUT&UCNT
END     I 'ECNT W !!!,"Nothing Found."
        S ECPG=$G(ECPG,1)
        Q
SUM2    ;Prints Categories and Procedures for a DSS Unit
        N UCNT,ECDO,ECCO,ECNT
        S (ECDO,ECMORE,UCNT,ECNT,ECCO)=0,ECPG=$G(ECPG,1),ECSCN=$G(ECSCN,"B")
        I ECC="ALL" D CATS G END
        I 'ECJLP S ECC=0,ECCN="None",ECCO=999
        D PROC
        D END
        Q
SET     ;set var
        S ECDN=$S($P($G(^ECD(+ECD,0)),"^")]"":$P(^(0),"^"),1:"UNKNOWN"),UCNT=0
        S ECDN=ECDN_$S($P($G(^ECD(+ECD,0)),"^",6):" **Inactive**",1:"")
        S ECS=+$P($G(^ECD(+ECD,0)),"^",2)
        S ECSN=$S($P($G(^DIC(49,ECS,0)),"^")]"":$P(^(0),"^"),1:"UNKNOWN")
        Q
SETC    ;set cats
        I ECC=0 S ECCN="None" Q
        S ECCN=$S($P($G(^EC(726,+ECC,0)),"^")]"":$P(^(0),"^"),1:"ZZ #"_ECC_" MISSING DATA")
        S ECMORE=1
        Q
HEADER  ;
        W:$E(IOST,1,2)="C-"!(ECPG>1) @IOF
        W !!,?25,"CATEGORY AND PROCEDURE SUMMARY",?70,"Page: ",ECPG,!
        W ?27,$S(ECSCN="I":"INACTIVE",ECSCN="A":"ACTIVE",1:" ALL")_" EVENT CODE"
        W " SCREENS",!?25,"Run Date : ",ECRDT,!?25,"LOCATION:  "_ECLN
        W !,?25,"SERVICE:   ",ECSN,!?25,"DSS UNIT:  "_ECDN,! S ECPG=ECPG+1
        F I=1:1:80 W "-"
        Q
CATS    ;
        S ECC="",ECCO=0
        F  S ECC=$O(^ECJ("AP",ECL,ECD,ECC)) Q:ECC=""  D SETC,PROC Q:ECOUT
        S ECMORE=0
        Q
PROC    ;
        S ECP=""
        F  S ECP=$O(^ECJ("AP",ECL,ECD,ECC,ECP)) Q:ECP=""  D SETP Q:ECOUT
        S ECMORE=0
        Q
SETP    ;set procs
        S ECPSY=+$O(^ECJ("AP",ECL,ECD,ECC,ECP,""))
        S ECINDT=$P($G(^ECJ(ECPSY,0)),"^",2)
        I ECSCN="A",ECINDT'="" Q
        I ECSCN="I",ECINDT="" Q
        I ECD'=ECDO D HEADER S ECDO=ECD
        I ECC'=ECCO D  S ECCO=ECC I ECOUT Q
        .W !!,?3,"Category:  "_ECCN D:$Y+4>IOSL PAGE,HEADER:ECPG,MORE:$D(ECCN)
        S ECPSYN=$P($G(^ECJ(ECPSY,"PRO")),"^",2),EC4=+$P($G(^("PRO")),"^",4)
        S EC2="" I EC4 S EC2=$S($P($G(^SC(EC4,0)),"^")]"":$P(^(0),"^"),1:"NO ASSOCIATED CLINIC")
        S ECFILE=$P(ECP,";",2),ECFILE=$S($E(ECFILE)="I":81,$E(ECFILE)="E":725,1:"UNKNOWN")
        I ECFILE="UNKNOWN" S ECPN="UNKNOWN",NATN="UNKNOWN"
        I ECFILE=81 S ECPI=$$CPT^ICPTCOD(+ECP) D
        .S ECPN=$S($P(ECPI,"^",3)]"":$P(ECPI,"^",3),1:"UNKNOWN"),NATN=$S($P(ECPI,"^",2)]"":$P(ECPI,"^",2),1:"NOT LISTED") K ECPI
        I ECFILE=725 S ECPN=$S($P($G(^EC(725,+ECP,0)),"^")]"":$P(^(0),"^"),1:"UNKNOWN"),NATN=$S($P($G(^EC(725,+ECP,0)),"^",2)]"":$P(^(0),"^",2),1:"NOT LISTED")
        S ECPN=$S(ECPSYN]"":ECPSYN,1:ECPN),ECNT=ECNT+1,UCNT=UCNT+1
        W !,?3,"Procedure: ",$E(ECPN,1,30),"   (",$S(ECFILE=81:"CPT",1:"EC"),")",?52,"Nat'l No.: ",NATN
        W:EC2]"" !,?14,"(Clinic: "_EC2_")"
        I $P($G(^ECJ(+ECPSY,0)),"^",2),ECSCN="B" W ?70,"*INACTIVE*"
        D:($Y+3)>IOSL PAGE,HEADER:ECPG,MORE:$D(ECCN) Q:ECOUT
        Q
PAGE    ;
        N SS,JJ
        I $D(ECPG),$E(IOST,1,2)="C-" D
        . S SS=22-$Y F JJ=1:1:SS W !
        . S DIR(0)="E" W ! D ^DIR K DIR I 'Y S ECOUT=1
        Q
MORE    I ECMORE W !!,?3,"Category:  "_ECCN
        Q
