RMPRD1  ;PHX/HNB-DISPLAY LOOKUP ;10/19/1993 [ 06/28/94  3:17 PM ]<<= NOT VERIFIED >
        ;;3.0;PROSTHETICS;**38,141**;Feb 09, 1996;Build 5
EN      ;DISPLAY DATE,PATIENT,ITEM,COST FROM 660
        S Z=^RMPR(660,+Y,0)
        S RMPRIT=$P(Z,U,6)
        I RMPRIT'="" S RMPRIT=$P(^RMPR(661,RMPRIT,0),U,1),RMPRIT=$P(^PRC(441,RMPRIT,0),U,2)
        I RMPRIT="" S RMPRIT=$S($P(^RMPR(660,+Y,0),U,26)="P":"SHIPPING",$P(^RMPR(660,+Y,0),U,26)="D":"DELIVERY",1:"SHIPPING")
        S RMPRCST="$"_$J($FN($P(Z,U,16),"T",2),8)
        W ?36,$E(RMPRIT,1,23),?70,RMPRCST
        K RMPRDFN,RMPRNAM,RMPRIT,RMPRCST,Z
        Q
EN1     ;DISPLAY DATE,REFERENCE,PATIENT FROM 664
        Q:$G(RMPRQT)=1
        I $G(DIC)="^RMPR(664," S Z=^RMPR(664,+Y,0),ZZ=$P(Z,U,7)
        W:$P(Z,U,8) ?40,"Closed" W:$P(Z,U,5) ?40,"Cancelled"
        W:$G(ZZ)'="" ?51,"REF: ",$P(ZZ,"-",3)
        I $G(ZZ)="",$P(Z,U,15),$D(^RMPR(664.2,+$P(Z,U,15),0)) W ?40,$P(^(0),U)
        I $D(^RMPR(664,+Y,1,0)) D
        .S RMPRI=0
        .;F  S RMPRI=$O(^RMPR(664,+Y,1,RMPRI)) Q:$G(RMPRI)'>0
        .;S RMPRI1=$P(^RMPR(664,+Y,1,RMPRI,0),U,1)
        .F  S RMPRI=$O(^RMPR(664,+Y,1,RMPRI)) Q:$G(RMPRI)'>0  D
        ..S RMPRI1=$P(^RMPR(664,+Y,1,RMPRI,0),U,1) Q:$G(RMPRI1)'>0
        ..S RMPRIT=$P($G(^RMPR(661,RMPRI1,0)),U,1)
        ..S:RMPRIT RMPRN=$P(^PRC(441,RMPRIT,0),U,2) S:RMPRIT="" RMPRN="*MASTER ITEM DELETED*"
        ..W ?64,$E(RMPRN,1,15)
        ..I $O(^RMPR(664,+Y,1,RMPRI)) W !
        I '$D(^RMPR(664,+Y,1)),$P(^RMPR(664,+Y,0),U,12) W ?64,"PICKUP/DELIVERY",!
        K ZZ Q
EN2     ;DISPLAY NAME
        I DIC="^RMPR(664," S Z=$P(^RMPR(664,+Y,0),U,2) I +Z W ?20,$E($P(^DPT(+Z,0),U,1),1,15) G EN1
        Q
EN3     ;DISPLAY LAB ORDER
        I $P(^RMPR(664.1,+Y,0),U,13)="" D EN4 Q
        S Z=$P(^RMPR(664.1,+Y,0),U,2)
        I +Z W ?20,$E($P(^DPT(+Z,0),U,1),1,15),?40,$P(^RMPR(664.1,+Y,0),U,13),?57,$P(^(0),U,17) I $D(^RMPR(664.1,+Y,2)) D
        .F RMPRI=0:0 S RMPRI=$O(^RMPR(664.1,+Y,2,RMPRI)) Q:RMPRI'>0  I $D(^(RMPRI,0)) S ZA=$P(^(0),U,1) W ?64,$E($$ITM^RMPR31U(ZA),1,15) I $O(^RMPR(664.1,+Y,2,RMPRI)) W !
        Q
EN4     ;DISPLAY 2529-3 REQUEST
        S Z=^RMPR(664.1,+Y,0)
        I +$P(Z,U,2) W ?20,$E($P(^DPT(+$P(Z,U,2),0),U,1),1,15) S RMPRSC=$P(Z,U,11),ZA=$P(^DD(664.1,2,0),U,3) W:RMPRSC'="" ?40,$E($P($P(ZA,RMPRSC_":",2),";",1),1,15)_"-"_$$STAN^RMPR31U($P(Z,U,15)) I $D(^RMPR(664.1,+Y,2)) D
        .F RMPRI=0:0 S RMPRI=$O(^RMPR(664.1,+Y,2,RMPRI)) Q:RMPRI'>0  I $D(^(RMPRI,0)) S ZA=$P(^(0),U,1) W ?64,$E($$ITM^RMPR31U(ZA),1,15) I $O(^RMPR(664.1,+Y,2,RMPRI)) W !
        Q
EN5     ;Inquire to 1358 transaction
        I '$D(RMPR) D DIV4^RMPRSIT Q:$D(X)
        N DIC
        S RMPRQT=1
        S DIC="^RMPR(664,",DIC(0)="AEQMZ" ;,DIC("W")="D EN2^RMPRD1"
        ;S %ZIS="MQ" D ^%ZIS G:POP EXIT
        K IOP I $E(IOST,1,1)["C-" G EN6
        S DIC("S")="I $P(^(0),U,14)=RMPR(""STA"")"
        D ^DIC Q:Y'>0
        S RMPRDA=+Y
        S %ZIS="MQ" D ^%ZIS G:POP EXIT
        I $D(IO("Q")) D  G EXIT
        .S ZTSAVE("RMPRDA")="",ZTSAVE("RMPR(")=""
        .S ZTSAVE("DATE(")="",ZTSAVE("RMPRSITE")=""
        .S ZTIO=ION,ZTRTN="EN6^RMPRD1",ZTDESC="Inquire To Prosthetics 1358"
        .D ^%ZTLOAD K ZTDESC,ZTIO,ZTRTN,ZTSAVE
        ;ENTRY POINT FOR ACTUAL PRINTING OF 1358 INFO TO PRINTER OR SCREEN
        ;S DIC("S")="I $P(^(0),U,14)=RMPR(""STA"")"
        ; D ^DIC Q:Y'>0
EN6     N RPO,RPO1 K DR
        S DA=RMPRDA,DIQ="RPO",DR=".01:24",RMPRDA=DA
        D EN^DIQ1
        S DR(664.02)=".01:16"
        S RPO1=0
        F  S RPO1=$O(^RMPR(664,DA,1,RPO1)) Q:RPO1'>0  D
        .S DA(664.02)=RPO1
        .D EN^DIQ1
        ;Display
        U IO
        I $Y>1 W @IOF
        W "Patient: ",RPO(664,RMPRDA,1),?40,"Vendor:",RPO(664,RMPRDA,4)
        W !,"Request Date: ",RPO(664,RMPRDA,.01),?33,"Date Required: ",RPO(664,RMPRDA,20),?69,"Days: ",RPO(664,RMPRDA,21)
        W !,"Form: ",RPO(664,RMPRDA,15),?33,"Initiator: ",$E(RPO(664,RMPRDA,10),1,12),?60,"Sta.: ",$E(RPO(664,RMPRDA,18),1,11)
        I $G(RPO(664,RMPRDA,8))'="" D
        .W !!,"Close Out Date:",RPO(664,RMPRDA,8),?40,"Closed By:",RPO(664,RMPRDA,8.5)
        .W !,"Remarks: ",RPO(664,RMPRDA,8.1)
        I $G(RPO(664,RMPRDA,12))'="" D
        .W !!,"Shipping Entry: ",RPO(664,RMPRDA,13)
        .W ?40,"Shipping Charge: ",RPO(664,RMPRDA,12)
        I $G(RPO(664,RMPRDA,3))'="" D
        .W !!,"Canceled Date: ",RPO(664,RMPRDA,3),?40,"Canceled By: ",RPO(664,RMPRDA,3.2)
        .W !,"Cancelation Remarks: ",RPO(664,RMPRDA,3.1)
        I $G(RPO(664,RMPRDA,22))'="" D
        .W !!,"Work Order #: ",RPO(664,RMPRDA,22),?33,"Lab Tech.: ",$E(RPO(664,RMPRDA,23),1,12),?60,"Date: ",RPO(664,RMPRDA,24)
        W !!,"Obligation #:",RPO(664,RMPRDA,.5)
        W ?35,"C.P.:",RPO(664,RMPRDA,6)
        W !,"Reference: ",RPO(664,RMPRDA,7)
        W ?35,"% Discount: ",RPO(664,RMPRDA,17)
        W ?60,"PSC Category: ",RPO(664,RMPRDA,16)
        ;Item Mult. Display
        S RD1=0 F  S RD1=$O(^RMPR(664,DA,1,RD1)) Q:$G(RD1)'>0  D
        .W !!,"Item:",RPO(664.02,RD1,.01)
        .W ?34,"Qty:",RPO(664.02,RD1,3)_"  "_RPO(664.02,RD1,4)
        .W ?60,"Unit Cost :",RPO(664.02,RD1,2)
        .W !,?2,"Actual Unit Cost: ",RPO(664.02,RD1,2)
        .W ?34,"Source:",RPO(664.02,RD1,11)
        .W ?60,"Serial #:",RPO(664.02,RD1,15)
        .W !,?2,"Patient Category: ",RPO(664.02,RD1,9),?34,"Type of Transaction: ",RPO(664.02,RD1,9)
        .W !,?2,"Special Category: ",RPO(664.02,RD1,10),?34,"Appliance/Repair: ",RPO(664.02,RD1,12)
        .W !!,?2,"Item Remarks: ",RPO(664.02,RD1,7)
        ;W !!,"READY TO WRITE WORD PROCESSING FIELDS"
        S RPO1=0
        F  S RPO1=$O(RPO(664.02,RPO1)) Q:RPO1'>0  D
        .W !,?2,"Brief Description: ",RPO(664.02,RPO1,1)
        .W !,?2,"Extended Description:"
        .M RPOD=RPO(664.02,RPO1,14)
        .D EN^DDIOL(.RPOD)
        .K RPOD
        .W !!
        ;end
        N DIR
        I $Y>11&($G(IO("Q"))<1) S DIR(0)="E" D ^DIR
EXIT    ;EXIT FROM EN5/EN6
        K DA,RMPRDA,RMPRQT,RPO,IO("Q")
        D ^%ZISC
