PSAPROC4        ;BIR/JMB-Process Uploaded Prime Vendor Invoice Data - CONT'D ;7/23/97
        ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**3,21,63**; 10/24/97;Build 10
        ;References to ^PSDRUG( are covered by IA #2095
        ;References to ^DIC(51.5 are covered by IA #1931
        ;This routine allows the user to edit invoices with errors or missing
        ;data.
        ;
MANYNDCS        ;List drug synonym data & ask user which on to use
        K PSADIFF,PSASAME S (PSACNT,PSAFND,PSAIEN50)=0,PSANDC=$P($P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",4),"~")
        F  S PSAIEN50=$O(^PSDRUG("C",PSANDC,PSAIEN50)) Q:'PSAIEN50  S PSASYN=0 D
        .F  S PSASYN=$O(^PSDRUG("C",PSANDC,PSAIEN50,PSASYN)) Q:'PSASYN  D
        ..Q:'$D(^PSDRUG(PSAIEN50,1,PSASYN,0))
        ..;DAVE B (PSA*3*3)
        ..Q:$D(^PSDRUG(PSAIEN50,"I"))
        ..I $P(^PSDRUG(PSAIEN50,1,PSASYN,0),"^",4)=PSAVSN S PSAFND=PSAFND+1,PSASAME(PSAFND)=PSAIEN50_"^"_PSASYN
        ..I $P(^PSDRUG(PSAIEN50,1,PSASYN,0),"^",4)'=PSAVSN S PSACNT=PSACNT+1,PSADIFF(PSACNT)=PSAIEN50_"^"_PSASYN
        G:PSAFND SAME G:PSACNT DIFF
        Q
        ;
SAME    ;If more than one drug with same VSN, assign to correct drug.
        W !,"There is more than one item in the DRUG file",!,"with the same NDC and Vendor Stock Number.",!
        S (PSACNT,PSAMENU)=0 F  S PSACNT=$O(PSASAME(PSACNT)) Q:'PSACNT  D
        .S PSAIEN50=$P(PSASAME(PSACNT),"^"),PSASYN=$P(PSASAME(PSACNT),"^",2),PSANODE=^PSDRUG(PSAIEN50,1,PSASYN,0) S PSAMENU=PSAMENU+1
        .Q:'$D(^PSDRUG(PSAIEN50,1,PSASYN,0))
        .D LIST Q:PSAOUT
        D CHOOSE Q:PSAOUT!(Y="")
        I PSAPICK=PSAMENU D ASKDRUG^PSANDF G KILL
        I PSAPICK<PSAMENU D
        .S $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",4)=PSANDC,$P(^(PSALINE),"^",7)=$P(PSASAME(PSAPICK),"^",2),$P(^(PSALINE),"^",5)=$P($P(^(PSALINE),"^",5),"~"),PSANEXT=1,PSADATA=^(PSALINE)
        .I $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",15)'=$P(PSASAME(PSAPICK),"^") D
        ..S $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",15)=$P(PSASAME(PSAPICK),"^"),$P(^(PSALINE),"^",16)=DUZ,$P(^(PSALINE),"^",17)=DT,PSANEXT=1,PSADATA=^(PSALINE)
        ..I $P(^XTMP("PSAPV",PSACTRL,"IN"),"^",13)="SUP" S $P(^("IN"),"^",13)="",PSAIN=^XTMP("PSAPV",PSACTRL,"IN")
        ..D HDR^PSAPROC6,EDIT1^PSAUTL1
        G KILL
        ;
DIFF    ;If more than one drug with different VSN, assign to correct drug.
        W !,"There is more than one item in the DRUG file with the same NDC.",!
        S (PSACNT,PSAMENU)=0 F  S PSACNT=$O(PSADIFF(PSACNT)) Q:'PSACNT  D
        .S PSAIEN50=$P(PSADIFF(PSACNT),"^"),PSASYN=$P(PSADIFF(PSACNT),"^",2),PSANODE=^PSDRUG(PSAIEN50,1,PSASYN,0),PSAMENU=PSAMENU+1
        .Q:'$D(^PSDRUG(PSAIEN50,1,PSASYN,0))
        .D LIST Q:PSAOUT
        D CHOOSE Q:PSAOUT!(Y="")
        I PSAPICK=PSAMENU D ASKDRUG^PSANDF G KILL
        I PSAPICK<PSAMENU D
        .S $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",4)=PSANDC,$P(^(PSALINE),"^",7)=$P(PSADIFF(PSAPICK),"^",2),PSANEXT=1,PSADATA=^(PSALINE)
        .I $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",15)'=$P(PSADIFF(PSAPICK),"^") D
        ..S $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",15)=$P(PSADIFF(PSAPICK),"^"),$P(^(PSALINE),"^",16)=DUZ,$P(^(PSALINE),"^",17)=DT,PSANEXT=1,PSADATA=^(PSALINE)
        ..I $P(^XTMP("PSAPV",PSACTRL,"IN"),"^",13)="SUP" S $P(^("IN"),"^",13)="",PSAIN=^XTMP("PSAPV",PSACTRL,"IN")
        ..D HDR^PSAPROC6,EDIT1^PSAUTL1
KILL    K PSASAME,PSAFND
        Q
        ;
LIST    Q:PSANODE=""!($P($G(^PSDRUG(PSAIEN50,0)),"^")="")
        ;3*63 RJS
        N PSAPPOU,PSADUOU,PSAPPDU,PSAVEND,PSAOU,PSACPPDU,X,PSANDC,PSADU,PSASYNM,PSAVSN
        S X=PSANODE
        S PSASYNM=$P(X,U,1),PSANDC=$P(X,U,2),PSAVSN=$P(X,U,4),PSAOU=+$P(X,U,5),PSAPPOU=$P(X,U,6)
        S PSADUOU=$P(X,U,7),PSAPPDU=$P(X,U,8),PSAVEND=$P(X,U,9)
        S PSADU=$$GET1^DIQ(50,PSAIEN50,14.5),PSAOU=$P($G(^DIC(51.5,PSAOU,0)),"^")
        S PSACPPDU=$S('PSADUOU:"BLANK",1:(PSAPPOU*1000/PSADUOU\1/1000)) ;recalculate PPDU, file doesn't reset PPDU
        W !?1,PSAMENU_".",?4,$P($G(^PSDRUG(PSAIEN50,0)),"^") I $D(^PSDRUG(PSAIEN50,"I")) W ?60,"(INACTIVE)"
        I PSANDC="",PSAVSN="" W !,?19,"SYN #",PSASYN,": ",PSASYNM,! Q
        W !,?4,"NDC: ",PSANDC,?25,"Order Unit: ",PSAOU,?46,"Price Per Order Unit: $",$FN(PSAPPOU,",",2)
        W !,?4,"VSN: ",PSAVSN,?19,"SYN #",PSASYN,": ",PSASYNM,?42,"Dose Unit Per Order Unit: ",PSADUOU
        W !,?4,"Vendor: ",PSAVEND,?47,"Price Per Dose Unit: ",$FN(PSACPPDU,","),!
        ;3*63 end
        Q
        ;
CHOOSE  S PSAMENU=PSAMENU+1
        W !?1,PSAMENU,".",?4,"Select another drug."
        W ! S DIR(0)="N^1:"_PSAMENU,DIR("A")="Select the invoiced drug",DIR("?")="Select the drug from the list for which you were invoiced.",DIR("??")="^D NDCHELP^PSAPROC4"
        D ^DIR K DIR I $G(DTOUT)!($G(DUOUT)) S PSAOUT=1 Q
        S PSAPICK=+Y
        Q
        ;
MANYVSNS        ;List drug synonym data & ask user which on to use
        K PSADIFF,PSASAME S (PSACNT,PSAFND,PSAIEN50)=0,PSAVSN=$P($P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",5),"~")
        F  S PSAIEN50=$O(^PSDRUG("AVSN",PSAVSN,PSAIEN50)) Q:'PSAIEN50  S PSASYN=0 D
        .F  S PSASYN=$O(^PSDRUG("AVSN",PSAVSN,PSAIEN50,PSASYN)) Q:'PSASYN  D
        ..Q:'$D(^PSDRUG(PSAIEN50,1,PSASYN,0))
        ..;DAVE B (PSA*3*3)
        ..Q:$D(^PSDRUG(PSAIEN50,"I"))
        ..I $P(^PSDRUG(PSAIEN50,1,PSASYN,0),"^")=PSANDC S PSAFND=PSAFND+1,PSASAME(PSAFND)=PSAIEN50_"^"_PSASYN
        ..I $P(^PSDRUG(PSAIEN50,1,PSASYN,0),"^")'=PSANDC S PSACNT=PSACNT+1,PSADIFF(PSACNT)=PSAIEN50_"^"_PSASYN
        G:PSAFND SAMEV G:PSACNT DIFFV
        Q
        ;
SAMEV   ;If more than one drug with same NDC, assign to correct drug.
        W !,"There is more than one item in the DRUG file",!,"with the same NDC and Vendor Stock Number.",!
        S (PSACNT,PSAMENU)=0 F  S PSACNT=$O(PSASAME(PSACNT)) Q:'PSACNT  D
        .S PSAIEN50=$P(PSASAME(PSACNT),"^"),PSASYN=$P(PSASAME(PSACNT),"^",2),PSANODE=^PSDRUG(PSAIEN50,1,PSASYN,0),PSAMENU=PSAMENU+1
        .Q:'$D(^PSDRUG(PSAIEN50,1,PSASYN,0))
        .D LIST Q:PSAOUT
        D CHOOSE Q:PSAOUT!(Y="")
        I PSAPICK=PSAMENU D ASKDRUG^PSANDF G KILL
        I PSAPICK<PSAMENU D
        .S $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",5)=PSAVSN,$P(^(PSALINE),"^",7)=$P(PSASAME(PSAPICK),"^",2),PSANEXT=1,PSADATA=^(PSALINE)
        .I $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",15)'=$P(PSASAME(PSAPICK),"^") D
        ..S $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",15)=$P(PSASAME(PSAPICK),"^"),$P(^(PSALINE),"^",16)=DUZ,$P(^(PSALINE),"^",17)=DT,PSANEXT=1,PSADATA=^(PSALINE)
        ..I $P(^XTMP("PSAPV",PSACTRL,"IN"),"^",13)="SUP" S $P(^("IN"),"^",13)="",PSAIN=^XTMP("PSAPV",PSACTRL,"IN")
        ..D HDR^PSAPROC6,EDIT1^PSAUTL1
        G KILL
        ;
DIFFV   ;If more than one drug with different VSN, assign to correct drug.
        W !,"There is more than one item in the DRUG file with the same VSN.",!
        S (PSACNT,PSAMENU)=0 F  S PSACNT=$O(PSADIFF(PSACNT)) Q:'PSACNT  D
        .S PSAIEN50=$P(PSADIFF(PSACNT),"^"),PSASYN=$P(PSADIFF(PSACNT),"^",2),PSANODE=$G(^PSDRUG(PSAIEN50,1,PSASYN,0)),PSAMENU=PSAMENU+1
        .Q:'$D(^PSDRUG(PSAIEN50,1,PSASYN,0))
        .D LIST Q:PSAOUT
        D CHOOSE Q:PSAOUT!(Y="")
        I PSAPICK=PSAMENU D ASKDRUG^PSANDF G KILL
        I PSAPICK<PSAMENU D
        .S $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",5)=PSAVSN,$P(^(PSALINE),"^",7)=$P(PSADIFF(PSAPICK),"^",2),PSANEXT=1
        .I $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",15)'=$P(PSADIFF(PSAPICK),"^") D
        ..S $P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",15)=$P(PSADIFF(PSAPICK),"^"),$P(^(PSALINE),"^",16)=DUZ,$P(^(PSALINE),"^",17)=DT,PSADATA=^(PSALINE)
        ..S PSANDC=$P($G(^PSDRUG(+$P(PSADIFF(PSAPICK),"^"),1,+$P(PSADIFF(PSAPICK),"^",2),0)),"^"),$P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE),"^",4)=PSANDC
        ..I $P(^XTMP("PSAPV",PSACTRL,"IN"),"^",13)="SUP" S $P(^("IN"),"^",13)="",PSAIN=^XTMP("PSAPV",PSACTRL,"IN")
        ..D HDR^PSAPROC6,EDIT1^PSAUTL1
        G KILL
        ;
NDCHELP ;Extended help for selecting invoiced drug
        W !?5,"Enter the number to the left of the invoiced drug. If you select a drug",!?5,"from the list, the invoiced drug will be matched to that drug. If you"
        W !?5,"choose to select another drug, you can select the invoiced drug from the",!?5,"DRUG file or flag this item as a supply item."
        Q
