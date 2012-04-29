PSDPAT2 ;B'ham ISC/JPW - Print Patient/Drug Report (summary) ; 1 Feb 94
 ;;3.0; CONTROLLED SUBSTANCES ;;13 Feb 97
 D NOW^%DTC S Y=+$E(%,1,12) X ^DD("DD") S RPDT=Y
 S (PG,PSDOUT)=0,$P(LN,"-",80)=""
 I '$D(^TMP("PSDPATL",$J)) D HDR W !!,?45,"****  NO DISPENSING SUMMARY  ****" Q
PRINT ;prints data for dispensing
 D HDR Q:PSDOUT
 S LOOP="" F  S LOOP=$O(^TMP("PSDPATL",$J,LOOP)) Q:LOOP=""!(PSDOUT)  D:$Y+4>IOSL HDR Q:PSDOUT  D  Q:PSDOUT
 .W !,LOOP,?55,$J(+$P(^TMP("PSDPATL",$J,LOOP),"^",3),6),?70,$J(+$P(^(LOOP),"^",2),6),!
DONE I SUM,$E(IOST)'="C" W @IOF
 Q
HDR ;lists header information
 I $E(IOST,1,2)="C-",PG W ! K DA,DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSDOUT=1 Q
 W:$Y @IOF S PG=PG+1 W !,?22,"ACTIVITY",?70,"PG "_PG,!,?29,"** SUMMARY **",!,?27,"Date: ",$P(PSDATE,"^")," to ",$P(PSDATE,"^",2),!!,"NAOU: ",NAOUN,!!
 W "DRUG",?55,"QUANTITY USED",?70,"BALANCE",!,LN,!
 Q
