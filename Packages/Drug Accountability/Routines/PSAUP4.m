PSAUP4  ;BIR/JMB-Upload and Process Prime Vendor Invoice Data - CONT'D ;9/19/97
        ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**3,12,20,21,67**; 10/24/97;Build 15
        ;This routine prints invoices from the ^XTMP global on the screen or
        ;to a printer.
        ;
        ;References to ^PSDRUG( are covered by IA #2095
        ;References to ^DIC(51.5( are covered by IA #1931
        ;
        W !!,"Enter the device which will be used to print",!,"the invoices with all items, errors, and adjustments.",!
        S %ZIS="Q" D ^%ZIS I POP S PSAOUT=1 Q
        I $D(IO("Q")) S ZTDESC="Drug Acct. - Prime Vendor Invoice Upload Report",ZTRTN="DQ^PSAUP4" D ^%ZTLOAD Q
        ;
DQ      ;queue starts here
        S IOM=80
        D NOW^%DTC S Y=% D DD^%DT S PSARUN=$E(Y,1,18),$P(PSASLN,"-",80)="",$P(PSADLN,"=",80)="",(PSADJDRG,PSADJSUP,PSAOUT)=0,PSAFPG=1
        U IO
        S PSACTRL=0 F  S PSACTRL=$O(^XTMP("PSAPV",PSACTRL)) Q:PSACTRL=""!(PSAOUT)  D START
        W @IOF D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" K IO("Q")
        ;
EXIT    ;Kills printing variables only
        K %,%ZIS,DIR,DIRUT,PSAAECST,PSABY,PSACS,PSACTRL,PSADATA,PSADATE,PSADEC,PSADRG,PSADJDRG,PSADJORD,PSADJQTY,PSADJSUP,PSADLN,PSADS,PSAECOST,PSAEND,PSAFPG,PSAICOST,PSAIECST
        K PSAIN,PSALINE,PSANDC,PSAODT,PSAODUZ,PSAOREA,PSAOUT,PSAPAGE,PSAPHARM,PSAQDT,PSAQDUZ,PSAQREA,PSAMV,PSARUN,PSAS,PSASLN,PSASS,PSAST,PSASTA,PSATOT,Y,ZTDESC,ZTRTN,ZTSK
        Q
        ;
START   S PSAPAGE=1,PSAEND=0 D HEADER S PSAIN=$G(^XTMP("PSAPV",PSACTRL,"IN"))
        S (PSADJDRG,PSADJSUP,PSAIECST,PSAAECST)=0,PSAPHARM=$P(PSAIN,"^",7),PSAMV=$P(PSAIN,"^",12)
        W !,"PRIME VENDOR : ",$S($P($G(^XTMP("PSAPV",PSACTRL,"DS")),"^")'="":$P($G(^("DS")),"^"),1:"UNKNOWN")
        W !!,"ORDER#  : "_$P(PSAIN,"^",4),?40,"ORDER DATE  : "_$$DATE($P(PSAIN,"^",3))
        W !,"INVOICE#: "_$P(PSAIN,"^",2),?40,"INVOICE DATE: "_$$DATE(+PSAIN)
        S PSASTA=$P(PSAIN,"^",8)
        W !,"STATUS  : "_$S(PSASTA="":"UPLOADED WITH ERRORS",PSASTA="OK":"UPLOADED WITHOUT ERRORS",PSASTA="P":"PROCESSED",1:"UNKNOWN")_$S($P(PSAIN,"^",13)="SUP":" (SUPPLY INVOICE)",1:"")
        I $Y+8>IOSL D:$E(IOST,1,2)="C-" SCREEN Q:PSAOUT  D HEADER
        I $E(IOST,1,2)="C-" D LINE Q
        W !!,"DELIVERY DATE REQUESTED: ",$$DATE($P(PSAIN,"^",5))
        W !,"DATE RECEIVED          : "_$S(+$P(PSAIN,"^",11)&($$DATE(+$P(PSAIN,"^",11))):" ("_$$DATE($P(PSAIN,"^",6))_")",1:$$DATE($P(PSAIN,"^",6)))
        I $Y+8>IOSL D:$E(IOST,1,2)="C-" SCREEN Q:$G(PSAOUT)  D HEADER
        ;
BUYSHIP W !!,"BUYER INFORMATION:",?40,"SHIPPING INFORMATION:"
        S PSABY=$G(^XTMP("PSAPV",PSACTRL,"BY"))
        S PSAST=$G(^XTMP("PSAPV",PSACTRL,"ST"))
        W !?2,$P(PSABY,"^"),?42,$P(PSAST,"^")
        I $P(PSABY,"^",2)'=""!($P(PSAST,"^",2)'="") W ! W:$P(PSABY,"^",2)'="" ?2,$P(PSABY,"^",2) W:$P(PSAST,"^",2)'="" ?42,$P(PSAST,"^",2)
        I $P(PSABY,"^",3)'=""!($P(PSAST,"^",3)'="") W ! W:$P(PSABY,"^",3)'="" ?2,$P(PSABY,"^",3) W:$P(PSAST,"^",3)'="" ?42,$P(PSAST,"^",3)
        W !?2,$P(PSABY,"^",4)_" "_$P(PSABY,"^",5)_"  ",$P(PSABY,"^",6)
        W ?42,$P(PSAST,"^",4)_" "_$P(PSAST,"^",5)_"  ",$P(PSAST,"^",6)
        I $Y+8>IOSL D:$E(IOST,1,2)="C-" SCREEN Q:PSAOUT  D HEADER
        ;
DISTRIB W !!,"DISTRIBUTOR INFORMATION:"
        S PSADS=$G(^XTMP("PSAPV",PSACTRL,"DS"))
        W !?2,$P(PSADS,"^")
        W:$P(PSADS,"^",2)'="" !?2,$P(PSADS,"^",2)
        W:$P(PSADS,"^",3)'="" !?2,$P(PSADS,"^",3)
        W !?2,$P(PSADS,"^",4)_" "_$P(PSADS,"^",5)_"  ",$P(PSADS,"^",6)
        I $Y+8>IOSL D:$E(IOST,1,2)="C-" SCREEN Q:PSAOUT  D HEADER
        D LINE
        Q
        ;
DATE(PSADATE)           ;convert date
        S %=$E(PSADATE,4,5)_"/"_$E(PSADATE,6,7)_"/"_$E(PSADATE,2,3)
        I $TR(%,"/")="" S %="UNKNOWN"
        Q %
        ;
LINE    ;print line items
        D LINEHDR
        S (PSAICOST,PSALINE,PSATOT)=0 F  S PSALINE=$O(^XTMP("PSAPV",PSACTRL,"IT",PSALINE)) Q:'PSALINE!(PSAOUT)  S PSADATA=^(PSALINE),PSADRG=0 D  Q:PSAOUT
        .I $Y+5>IOSL D:$E(IOST,1,2)="C-" SCREEN Q:PSAOUT  D HEADER,LINEHDR
        .K PSADJQTY,PSAQDUZ,PSAQDT,PSAQREA,PSADJORD,PSAODUZ,PSAODT,PSAOREA
        .W !,PSALINE
DRUG    .;Drug
        .I +$P(PSADATA,"^",15) S PSADRG=+$P(PSADATA,"^",15) W ?8,"*"_$P($G(^PSDRUG(+$P(PSADATA,"^",15),0)),"^")_$S(+$P(PSADATA,"^",6)&($P($G(^PSDRUG(+$P(PSADATA,"^",6),0)),"^")'=""):" ("_$P(^PSDRUG(+$P(PSADATA,"^",6),0),"^")_")",1:"") S PSADJDRG=1
        .I PSADRG,$D(^PSDRUG(PSADRG,"I")) W !,?5,"** INACTIVE IN DRUG FILE **"
        .I '+$P(PSADATA,"^",15) D
        ..I +$P(PSADATA,"^",6),$P($G(^PSDRUG(+$P(PSADATA,"^",6),0)),"^")'="" W ?9,$P(^PSDRUG(+$P(PSADATA,"^",6),0),"^") S PSADRG=+$P(PSADATA,"^",6) Q
        ..I $P($G(^XTMP("PSAPV",PSACTRL,"IT",PSALINE,"SUP")),"^",3)'="" W ?7,"**"_$P(^XTMP("PSAPV",PSACTRL,"IT",PSALINE,"SUP"),"^",3)  S PSADJSUP=1,PSADRG=0 Q
        ..W ?9,"DRUG UNKNOWN"
        .I $P(PSADATA,"^",19)="CS" W " (CONTROLLED SUBS)" I $P($G(^PSD(58.8,+$P(PSAIN,"^",12),1,PSADRG,0)),"^",14),$P($G(^(0)),"^",14)'>DT  W !?5,"*** INACTIVE IN MASTER VAULT"
        .E  I PSADRG,$P($G(^PSD(58.8,+$P(PSAIN,"^",7),1,PSADRG,0)),"^",14),$P($G(^(0)),"^",14)'>DT W !?5,"*** INACTIVE IN PHARMACY LOCATION"
        .;UPC
        .I $P($P(PSADATA,"^",26),"~")'="" W !?9,"UPC: "_$P($P(PSADATA,"^",26),"~")
        .;NDC
        .S PSANDC=$P($P(PSADATA,"^",4),"~")
        .I $E(PSANDC)'="S" D
        ..W !?9 D PSANDC1^PSAHELP S PSANDC=PSANDCX
        ..I PSANDC'="" W PSANDC Q
        ..W "NDC UNKNOWN"
        .;
        .;VSN
        .W ?25,$S($P($P(PSADATA,"^",5),"~")'="":$E($P($P(PSADATA,"^",5),"~"),1,14),1:"VSN UNKNOWN")
        .;
        .;QTY
        .;No Adjusted Qty
        .S PSAIECST=PSAIECST+($P(PSADATA,"^")*$P(PSADATA,"^",3))
        .I $P(PSADATA,"^",8)="" W ?40,$J($P(PSADATA,"^"),6) S PSAECOST=$P(PSADATA,"^")*$P(PSADATA,"^",3),PSAAECST=PSAAECST+PSAECOST
        .;Adj. Qty (P)
        .I $P(PSADATA,"^",8)'="" D
        ..S PSADJQTY=$P(PSADATA,"^",8),PSAQDUZ=$P(PSADATA,"^",9),PSAQDT=$P(PSADATA,"^",10),PSAQREA=$P(PSADATA,"^",11)
        ..S PSAECOST=PSADJQTY*$P(PSADATA,"^",3),PSAAECST=PSAAECST+PSAECOST
        ..W ?40,$J($P(PSADATA,"^",8),6)_"("_$P(PSADATA,"^")_")"
        .;
OU      .;Order Unit
        .I '+$P(PSADATA,"^",12) D
        ..I +$P($P(PSADATA,"^",2),"~",2),$P($G(^DIC(51.5,+$P($P(PSADATA,"^",2),"~",2),0)),"^")'="" W ?53,$P($G(^DIC(51.5,+$P($P(PSADATA,"^",2),"~",2),0)),"^") Q
        ..I $P($G(PSADATA),"^",2)'="",$P($G(PSADATA),"^",2)'["~",'$D(^DIC(51.5,"B",$P(PSADATA,"^",2))) W ?48," ?-> "_$P(PSADATA,"^",2)
        ..I $P($P(PSADATA,"^",2),"~")="" D ^PSAHELP
        .;Adj. OU (P)
        .I +$P(PSADATA,"^",12) S PSADJORD=$P(PSADATA,"^",12),PSAODUZ=$P(PSADATA,"^",13),PSAODT=$P(PSADATA,"^",14) W ?53,$P($G(^DIC(51.5,+$P(PSADATA,"^",12),0)),"^")_"("_$P($P(PSADATA,"^",2),"~")_")"
        .;Unit price
        .S PSADEC=$S($L($P($P(PSADATA,"^",3),".",2))>1:$L($P($P(PSADATA,"^",3),".",2)),1:2)
        .W ?59,$J($P(PSADATA,"^",3),7,PSADEC)
        .;Extended cost
        .W ?67,$J(PSAECOST,12,2)
        .I $Y+9>IOSL,+$P(PSADATA,"^",21),+$P(PSADATA,"^",27) D:$E(IOST,1,2)="C-" SCREEN Q:PSAOUT  D HEADER,LINEHDR
        .I $G(PSADRG) D HAVEDRG
        .I '$G(PSADRG) W !?9,"STOCK LEVEL  : ",!?9,"REORDER LEVEL: "_$P(PSADATA,"^",21),!?9,"DISPENSE UNITS/ORDER UNIT: " D DISP^PSAP67
        .;
        .;Print Adj Qty
        .I $G(PSADJQTY)'="" D
        ..I $Y+5>IOSL D:$E(IOST,1,2)="C-" SCREEN Q:PSAOUT  D HEADER,LINEHDR
        ..W !!?9,"ADJUSTED QUANTITY: "_PSADJQTY,!?9,$$DATE(PSAQDT)_" "_$P($G(^VA(200,+PSAQDUZ,0)),"^"),!?11,PSAQREA
        .;Print Adj OU
        .I +$G(PSADJORD) D
        ..I $Y+5>IOSL D:$E(IOST,1,2)="C-" SCREEN Q:PSAOUT  D HEADER,LINEHDR
        ..W !!,?9,"ADJUSTED ORDER UNIT: "_$P($G(^DIC(51.5,+PSADJORD,0)),"^")
        ..W !?9,$$DATE(PSAODT)_" "_$P($G(^VA(200,+PSAODUZ,0)),"^")_" - "_$P($G(^DIC(51.5,PSADJORD,0)),"^")
        .W !
        Q:PSAOUT
        I $Y+6>IOSL D:$E(IOST,1,2)="C-" SCREEN Q:PSAOUT  D HEADER
        W !,PSASLN
        W:$G(PSAAECST)'=$G(PSAIECST) !?48,"TOTAL ADUSTED COST",?67,$J(PSAAECST,12,2),!
        W !?48,"TOTAL INVOICED COST",?67,$J(PSAIECST,12,2)
        S PSAEND=1
        I $Y+5>IOSL D:$E(IOST,1,2)="C-" SCREEN Q:PSAOUT  D HEADER
        I PSADJDRG,$E(IOST)'="C" W !!,"* THE DRUG WAS MATCHED TO THE DRUG FILE."
        I PSADJSUP,$E(IOST)'="C" W !!,"* THE ITEM IS A SUPPLY ITEM."
        D:$E(IOST,1,2)="C-" SCREEN
        Q
        ;
LINEHDR ;item header
        W !?50,"ORDER",?62,"COST/",?71,"EXTENDED"
        W !,"LINE#",?9,"NDC",?25,"VSN",?43,"QTY",?51,"UNIT",?62,"UNIT",?75,"COST",!,PSADLN,!
        Q
        ;
HEADER  ;Page header
        I PSAFPG&($E(IOST,1,2)="C-") W @IOF G HDR1
        S PSAFPG=0
        W:'PSAFPG @IOF
HDR1    W !?20,"DRUG ACCOUNTABILITY/INVENTORY INTERFACE"
        W !?26,"PRIME VENDOR UPLOAD REPORT",!
        W:PSAPAGE'=1 !,"ORDER#: "_$P(PSAIN,"^",4)_"  INVOICE#: "_$P(PSAIN,"^",2)
        I $E(IOST,1,2)="C-" W ?(74-$L(PSAPAGE)),"PAGE "_PSAPAGE,!,PSADLN
        I $E(IOST)'="C" W !,"RUN: "_PSARUN,?(74-$L(PSAPAGE)),"PAGE "_PSAPAGE,!,PSADLN
        S PSAPAGE=PSAPAGE+1
        Q
SCREEN  ;Hold on screen
        S PSAS=20-$Y I PSAS F PSASS=1:1:PSAS W !
        I PSADJDRG,PSAEND W !," * THE DRUG WAS MATCHED TO THE DRUG FILE."
        I PSADJSUP,PSAEND W !,"** THE ITEM IS A SUPPLY ITEM."
        S DIR(0)="E" D ^DIR K DIR I $G(DIRUT) S PSAOUT=1
        Q
        ;
HAVEDRG ;Display data if drug is found.
        ;DAVE B (PSA*3*20) 7SEP99 ADDED $G TO NEXT LINE
        S PSACS=$S($P($G(^PSDRUG(PSADRG,2)),"^",3)["N":1,1:0)
        I PSACS D
        .I PSAMV,+$P($G(^PSD(58.8,PSAMV,0)),"^",14) D  Q
        ..W !?9,"STOCK LEVEL  : "_$S(+$P(PSADATA,"^",27):+$P(PSADATA,"^",27),1:+$P($G(^PSD(58.8,PSAMV,1,PSADRG,0)),"^",3))
        ..W !?9,"REORDER LEVEL: "_$S(+$P(PSADATA,"^",21):+$P(PSADATA,"^",21),1:+$P($G(^PSD(58.8,PSAMV,1,PSADRG,0)),"^",5))
        .I 'PSAMV W !?9,"STOCK LEVEL  : "_$P(PSADATA,"^",27),!?9,"REORDER LEVEL: "_$P(PSADATA,"^",21)
        I 'PSACS D
        .I PSAPHARM,+$P($G(^PSD(58.8,PSAPHARM,0)),"^",14) D
        ..W !?9,"STOCK LEVEL  : "_$S(+$P(PSADATA,"^",27):+$P(PSADATA,"^",27),1:+$P($G(^PSD(58.8,PSAPHARM,1,PSADRG,0)),"^",3))
        ..W !?9,"REORDER LEVEL: "_$S(+$P(PSADATA,"^",21):+$P(PSADATA,"^",21),1:+$P($G(^PSD(58.8,PSAPHARM,1,PSADRG,0)),"^",5))
        .I 'PSAPHARM W !?9,"STOCK LEVEL  : "_$P(PSADATA,"^",27),!?9,"REORDER LEVEL: "_$P(PSADATA,"^",21)
        W !?9,"DISPENSE UNITS/ORDER UNIT: "
        W $S(+$P(PSADATA,"^",20):+$P(PSADATA,"^",20),+$P($G(^PSDRUG(PSADRG,1,+$P(PSADATA,"^",7),0)),"^",7):+$P($G(^PSDRUG(PSADRG,1,+$P(PSADATA,"^",7),0)),"^",7),1:"")
        D DISP^PSAP67
        Q
