FHOMCBRP        ;Hines OIFO/RTK COMBINED OUTPATIENT MEALS LIST  ;6/30/03  15:45
        ;;5.5;DIETETICS;**5,15**;Jan 28, 2005;Build 2
        ;
        W @IOF,!!,"C O M B I N E D   O U T P A T I E N T   M E A L S   L I S T"
EN      ;
        W !! K DIR S DIR("A")="Print by LOCATION, COMM OFFICE, PRODUCTION FACILITY or ALL: "
        S DIR(0)="SAO^A:ALL;C:COMM OFFICE;L:LOCATION;P:PROD FACILITY" D ^DIR
        Q:$D(DIRUT)  S FHLBY=Y
        I FHLBY="L" W ! D OUTLOC^FHOMUTL Q:FHLOC=""  S FHSELOC=FHLOC,FHLOC=""
        I FHLBY="C" D  Q:FHSLCOM=""
        .W ! K DIC S DIC=119.73,DIC("A")="Select Communication Office: "
        .S DIC(0)="AEQZ" D ^DIC I $D(DUOUT) S FHSLCOM="" Q
        .I Y=-1 S FHSLCOM="" Q
        .S FHSLCOM=+Y
        I FHLBY="P" D  Q:FHSLPRO=""
        .W ! K DIC S DIC=119.71,DIC("A")="Select Production Facility: "
        .S DIC(0)="AEQZ" D ^DIC I $D(DUOUT) S FHSLPRO="" Q
        .I Y=-1 S FHSLPRO="" Q
        .S FHSLPRO=+Y
        W ! D STDATE^FHOMUTL I STDT="" Q
        W ! D ENDATE^FHOMUTL I ENDT="" Q
        S X1=STDT,X2=-1 D C^%DTC S STDT1=X,ENDT=ENDT_.99
        D DEV,EN Q
DEV     ;get device and set up queue
        W ! K %ZIS,IOP S %ZIS="Q" D ^%ZIS Q:POP
        I '$D(IO("Q")) U IO D LIST,^%ZISC,END Q
        S ZTRTN="LIST^FHOMCBRP",ZTDESC="Combined Outpatient Meals Display"
        S ZTSAVE("STDT")="",ZTSAVE("STDT1")="",ZTSAVE("ENDT")=""
        S ZTSAVE("FHLBY")="",ZTSAVE("FHSELOC")="",ZTSAVE("FHSLCOM")=""
        S ZTSAVE("FHSLPRO")="" D ^%ZTLOAD
        D ^%ZISC K %ZIS,IOP
        D END Q
LIST    ; First build data in ^TMP global
        K ^TMP($J) S NUM=0,EX="",FHPG=0
        ;Recurring Meals
        F FHXRDT=STDT1:0 S FHXRDT=$O(^FHPT("RM",FHXRDT)) Q:FHXRDT'>0!(FHXRDT>ENDT)!(EX=U)  D
        .F FHDFN=0:0 S FHDFN=$O(^FHPT("RM",FHXRDT,FHDFN)) Q:FHDFN'>0!(EX=U)  D
        ..F FHRM=0:0 S FHRM=$O(^FHPT("RM",FHXRDT,FHDFN,FHRM)) Q:FHRM'>0!(EX=U)  D
        ...S FHZN=$G(^FHPT(FHDFN,"OP",FHRM,0)),FHST=$P(FHZN,U,15) I FHST="C" Q
        ...D PATNAME^FHOMUTL
        ...S FHLOC=$P(FHZN,U,3) Q:FHLOC=""  I FHLBY="L",FHSELOC'=FHLOC Q
        ...S FHCOMM=$P($G(^FH(119.6,FHLOC,0)),U,8) I FHLBY="C",FHSLCOM'=FHCOMM Q
        ...S FHPRD=$P($G(^FH(119.73,FHCOMM,0)),U,4) I FHLBY="P",FHSLPRO'=FHPRD Q
        ...S FHPRORD=$P($G(^FH(119.6,FHLOC,0)),U,4) I FHPRORD="" S FHPRORD=99
        ...S FHPRORD=$S(FHPRORD<1:99,FHPRORD<10:"0"_FHPRORD,1:FHPRORD)
        ...S FHLOCNM=$P($G(^FH(119.6,FHLOC,0)),U,1)
        ...S FHML=$P(FHZN,U,4) Q:FHML=""  S FHML=$S(FHML="B":1,FHML="N":2,FHML="E":3)
        ...S ^TMP($J,FHXRDT_"~"_FHML,FHPRORD_"~"_FHLOCNM_"~"_FHLOC,FHPTNM_"~"_FHDFN_"~"_FHRM)="R~"_FHZN
        ...Q
        ..Q
        .Q
        ;Special Meals
        S ENDT=ENDT_.99
        F FHSMDT=STDT:0 S FHSMDT=$O(^FHPT("SM",FHSMDT)) Q:FHSMDT'>0!(FHSMDT>ENDT)!(EX=U)  D
        .S FHSMDTX=$E(FHSMDT,1,7)
        .S FHDFN=$O(^FHPT("SM",FHSMDT,"")) D PATNAME^FHOMUTL
        .S FHZN=$G(^FHPT(FHDFN,"SM",FHSMDT,0)),FHSTAT=$P(FHZN,U,2)
        .I FHSTAT="C" Q
        .S FHLOC=$P(FHZN,U,3) Q:FHLOC=""  I FHLBY="L",FHSELOC'=FHLOC Q
        .S FHCOMM=$P($G(^FH(119.6,FHLOC,0)),U,8) I FHLBY="C",FHSLCOM'=FHCOMM Q
        .S FHPRD=$P($G(^FH(119.73,FHCOMM,0)),U,4) I FHLBY="P",FHSLPRO'=FHPRD Q
        .S FHPRORD=$P($G(^FH(119.6,FHLOC,0)),U,4) I FHPRORD="" S FHPRORD=99
        .S FHPRORD=$S(FHPRORD<1:99,FHPRORD<10:"0"_FHPRORD,1:FHPRORD)
        .S FHLOCNM=$P($G(^FH(119.6,FHLOC,0)),U,1),FHML=$P(FHZN,U,9) Q:FHML=""
        .S FHML=$S(FHML="B":1,FHML="N":2,FHML="E":3)
        .S ^TMP($J,FHSMDTX_"~"_FHML,FHPRORD_"~"_FHLOCNM_"~"_FHLOC,FHPTNM_"~"_FHDFN)="S~"_FHZN
        .Q
        ;Guest Meals
        F FHGMDT=STDT:0 S FHGMDT=$O(^FHPT("GM",FHGMDT)) Q:FHGMDT'>0!(FHGMDT>ENDT)  D
        .F FHDFN=0:0 S FHDFN=$O(^FHPT("GM",FHGMDT,FHDFN)) Q:FHDFN'>0  D
        ..S FHZN=$G(^FHPT(FHDFN,"GM",FHGMDT,0)),FHST=$P(FHZN,U,9) I FHST="C" Q
        ..D PATNAME^FHOMUTL
        ..S FHLOC=$P(FHZN,U,5) Q:FHLOC=""  I FHLBY="L",FHSELOC'=FHLOC Q
        ..S FHCOMM=$P($G(^FH(119.6,FHLOC,0)),U,8) I FHLBY="C",FHSLCOM'=FHCOMM Q
        ..S FHPRD=$P($G(^FH(119.73,FHCOMM,0)),U,4) I FHLBY="P",FHSLPRO'=FHPRD Q
        ..S FHPRORD=$P($G(^FH(119.6,FHLOC,0)),U,4) I FHPRORD="" S FHPRORD=99
        ..S FHPRORD=$S(FHPRORD<1:99,FHPRORD<10:"0"_FHPRORD,1:FHPRORD)
        ..S FHLOCNM=$P($G(^FH(119.6,FHLOC,0)),U,1)
        ..S FHML=$P(FHZN,U,3) Q:FHML=""  S FHML=$S(FHML="B":1,FHML="N":2,FHML="E":3)
        ..S FHGMDTX=$E(FHGMDT,1,7)
        ..S ^TMP($J,FHGMDTX_"~"_FHML,FHPRORD_"~"_FHLOCNM_"~"_FHLOC,FHPTNM_"~"_FHDFN)="G~"_FHZN
        ..Q
        .Q
        ; Now display data from the ^TMP global
        I '$D(^TMP($J)) W !!,"NO OUTPATIENT MEALS WITHIN SELECTED PARAMETERS" Q
        S FHDTML="" F  S FHDTML=$O(^TMP($J,FHDTML)) Q:FHDTML=""!(EX=U)  D
        .I FHPG<1 D HDR
        .S FHWDT=$P(FHDTML,"~",1),FHWML=$P(FHDTML,"~",2)
        .S FHWDT=$$FMTE^XLFDT(FHWDT,"P")
        .S FHWML=$S(FHWML=1:"Breakfast",FHWML=2:"Noon",1:"Evening")
        .S FHPG=FHPG+1
        .S FHLOC="" F  S FHLOC=$O(^TMP($J,FHDTML,FHLOC)) Q:FHLOC=""!(EX=U)  D
        ..W !!,FHWDT,?14,"- ",FHWML,?28,"LOCATION: "
        ..W $P(FHLOC,"~",2),!,"Patient Name",?28,"Diet",?55,"Room-Bed"
        ..W !,"========================",?28,"========================"
        ..W ?55,"========================"
        ..S FHPTN="" F  S FHPTN=$O(^TMP($J,FHDTML,FHLOC,FHPTN)) Q:FHPTN=""!(EX=U)  D
        ...S FHNODE=$G(^TMP($J,FHDTML,FHLOC,FHPTN))
        ...W !,$E($P(FHPTN,"~",1),1,24)
        ...S FHPCE=2 S:$E(FHNODE,1)="S" FHPCE=4 S:$E(FHNODE,1)="G" FHPCE=6
        ...S FHDIET=$P(FHNODE,U,FHPCE)
        ...I FHDIET'="" W ?28,$E($P($G(^FH(111,FHDIET,0)),U,1),1,24)
        ...I $E(FHNODE,1)="R" I $P($G(^FH(119.6,$P(FHLOC,"~",3),1)),U,4)="Y" S FHDFN=$P(FHPTN,"~",2),FHRNUM=$P(FHPTN,"~",3) D DIETPAT^FHOMRR1 W ?28,$E(FHDIETP,1,24)
        ...S FHPCE=18 S:$E(FHNODE,1)="S" FHPCE=13 S:$E(FHNODE,1)="G" FHPCE=11
        ...S FHRMBD=$P(FHNODE,U,FHPCE),FHRMBNM=""
        ...I FHRMBD'="" S FHRMBNM=$E($P($G(^DG(405.4,FHRMBD,0)),U,1),1,24)
        ...W ?55,FHRMBNM
        ...I $Y>(IOSL-4) D PG I EX=U Q
        ...Q
        ..Q
        .Q
        Q
END     ;
        K DIR,ENDT,STDT,FHGMDT,FHGMDTX,FHRM,FHXRDT,FHSMDT,FHSMDTX,FHML,FHCL
        K FHCH,FHDIET,FHLOC,FHPTN,FHSELOC,FHSLCOM,FHNODE,FHZN,FHSLPRO,FHPRD
        K FHDIETP,FHPCE,FHPG
        Q
PG      ;
        I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
        D HDR Q
HDR     ;
        W:$Y @IOF
        W !,"C O M B I N E D   O U T P A T I E N T   M E A L S   L I S T",!!
        Q
