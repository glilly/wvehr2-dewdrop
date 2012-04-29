XTPMSTA2        ;OAK/BP - PRINT PATCH STATISTICS BY COMPLIANCE DATE;
        ;;7.3;TOOLKIT;**98,100,106**; Apr 25, 1995;Build 1
        ;
        S IOP="HOME" D ^%ZIS K IOP
EN      W @IOF,"Patch Monitor Statistics By Compliance Date",!!!
        ;
DATE    W ! S %DT="AEP"
        S %DT("A")="Enter BEGINNING Compliance date: " D ^%DT G:Y<0 EXIT S XTBBDT=Y X ^DD("DD") S XTBBDT1=Y
        S %DT="AE",%DT("A")="     and ENDING Compliance date: " D ^%DT G:Y<0 EXIT S XTBEDT=Y X ^DD("DD") S XTBEDT1=Y
        I XTBEDT<XTBBDT W !!,$C(7),"Starting date is later than ending date.",!! H 2 G DATE
        W !!,"Do you want to see the patch data" S %=2 D YN^DICN S XTBVIEW=%
        ;
DEV     W !! S %ZIS="AEQ" D ^%ZIS G:POP EXIT
        I $D(IO("Q")) S ZTIO=ION,ZTRTN="SORT^XTPMSTA2",ZTSAVE("XTB*")="",ZTDESC="Patch Monitor Statistics By Compliance Date" D ^%ZTLOAD D HOME^%ZIS
        I $D(ZTSK) W !,"Queued as task #",ZTSK H 2 G EXIT
        ;
        ; sort patches by compliance date
SORT    U IO K ^TMP($J)
        F XTBCPLDT=(XTBBDT-.0001):0 S XTBCPLDT=$O(^XPD(9.9,"D",XTBCPLDT)) Q:XTBCPLDT=""!(XTBCPLDT>XTBEDT)  DO
        .F XTBDA=0:0 S XTBDA=$O(^XPD(9.9,"D",XTBCPLDT,XTBDA)) Q:XTBDA=""  DO
        ..S XTBDTA=$G(^XPD(9.9,XTBDA,0)) Q:XTBDTA=""
        ..S XTBPTNAM=$P(XTBDTA,U,1),XTBNMSP=$P($P(XTBDTA,U,4)," - ",1) Q:XTBNMSP=""  ;parent package missing in file
        ..S XTBRELDT=$P(XTBDTA,U,2),XTBPRIOR=$P(XTBDTA,U,3)
        ..S ^TMP($J,XTBCPLDT,XTBPTNAM,XTBDA)=XTBRELDT_U_XTBPRIOR
PRINT   ;
        S Y=DT X ^DD("DD") S XTBCURDT=Y
        K XTBLINE S $P(XTBLINE,"-",(IOM-2))="-"
        S PG=0 D HDR ; first header
        S XTBPTNAM="",(XTBTPTCH,XTBTLATE)=0
        F XTBCPLDT=0:0 S XTBCPLDT=$O(^TMP($J,XTBCPLDT)) Q:XTBCPLDT=""  F  S XTBPTNAM=$O(^TMP($J,XTBCPLDT,XTBPTNAM)) Q:XTBPTNAM=""  DO  Q:$D(XTBOUT)
        .F XTBDA=0:0 S XTBDA=$O(^TMP($J,XTBCPLDT,XTBPTNAM,XTBDA)) Q:XTBDA=""  DO  Q:$D(XTBOUT)
        ..S XTBTPTCH=XTBTPTCH+1
        ..S XTBDTA=^TMP($J,XTBCPLDT,XTBPTNAM,XTBDA)
        ..S XTBRELDT=$P(XTBDTA,U),XTBPRIOR=$P(XTBDTA,U,2)
        ..S XTBRCVDT=$P($G(^XPD(9.9,XTBDA,0)),U,2)
        ..S XTBPTYPE=$P($G(^XPD(9.9,XTBDA,0)),U,10)
        ..I +XTBPTYPE=0 S D0=XTBDA D ^XTPMKPCF S XTBINSDT=X K D0
        ..I +XTBPTYPE=1 S XTBINSDT=$P($G(^XPD(9.9,XTBDA,0)),U,11)
        ..I XTBINSDT]"" S X1=XTBINSDT,X2=XTBCPLDT D ^%DTC S XTBDAYLT=X
        ..I XTBINSDT="" S X1=DT,X2=XTBCPLDT D ^%DTC S XTBDAYLT=X
        ..S Y=XTBINSDT X ^DD("DD") I Y'="" S XTBINSDT=$P(Y,",",1)_","_$E($P(Y,",",2),2,5) ;set date format "MON DD,YYYY"
        ..S Y=XTBCPLDT X ^DD("DD") S XTBCPLDX=Y
        ..S Y=XTBRELDT X ^DD("DD") S XTBRELDT=Y
        ..S XTBPRIOR=$S(XTBPRIOR="m":"Mandatory",XTBPRIOR="e":"Emergency",1:"Unknown")
        ..I XTBVIEW=1 W XTBCPLDX,?14,XTBPTNAM,?27,XTBRELDT,?41,XTBINSDT,?55,XTBPRIOR
        ..I XTBVIEW=1,XTBDAYLT>0 W ?67,$J(XTBDAYLT,3,0)_$S(XTBDAYLT>1:" days",1:" day")
        ..I XTBDAYLT>0 S XTBTLATE=XTBTLATE+1
        ..I XTBVIEW=1 W ! I $Y>(IOSL-6),IOST?1"C-".E D PAUSE Q:$D(XTBOUT)
        ..I XTBVIEW=1 I $Y>(IOSL-6) D HDR
        G:$D(XTBOUT) EXIT
        I $Y>(IOSL-6),IOST?1"C-".E D HDR
        W !!?6,"Totals patches received for date range: ",XTBTPTCH,!
        W "Total patches installed past compliance date: ",XTBTLATE,!!
        S XTBDIVOK=0 I XTBTPTCH>0 S XTBDIVOK=1
        W ?25,"Delinquent patch % : ",$S(XTBDIVOK=1:$J((XTBTLATE/XTBTPTCH*100),6,2),1:100)_" %",!
        W ?25,"      Compliance % : ",$S(XTBDIVOK=1:$J(100-(XTBTLATE/XTBTPTCH*100),6,2),1:100)," %",!
        I IOST?1"C-".E K XTBANS W !!,"Press ENTER to end " R XTBANS:DTIME
        ;
EXIT    I IOST?1"C-".E W @IOF,!
        D ^%ZISC
        K %,%DT,%ZIS,XTBNMSP,XTBANS,XTBBDT,XTBBDT1,XTBCPLDT,XTBCPLDX,XTBDA,XTBEDT,XTBEDT1,XTBDAYLT
        K XTBINSDT,XTBLINE,XTBNMSP,XTBOLDNM,XTBNMSP,XTBPTNAM,XTBPTYPE,XTBDTA,XTBGPDA
        K XTBRCVDT,XTBTLATE,XTBTPTCH,D0,DIC,PG,POP,X,X1,X2,Y,ZTDESC,ZTIO,ZTRTN,ZTSAVE,%T,%Y
        K ^TMP($J),XTBOUT,XTBPGF,XTBOLGRP,ZTSK,XTBRELDT,XTBPRIOR,XTBCURDT,XTBDIVOK,XTBVIEW
        Q
        ;
HDR     S PG=PG+1 I IOST?1"P-".E,PG>1 W @IOF
        I IOST?1"C-".E W @IOF
        W XTBCURDT S X="Patch Statistical Report for "_^DD("SITE")
        W ?(IOM-$L(X)\2),X,?(IOM-12),"Page: ",PG,!,?31,"By Compliance Date",!
        S X="Date range: "_XTBBDT1_" to "_XTBEDT1 W ?(IOM-$L(X)\2),X,!
        W !,"Compliance",?14,"Patch",?27,"Release",?41,"Install",?67,"# Days",!
        W "Date",?14,"Number",?27,"Date",?41,"Date",?55,"Priority",?67,"Delinquent",!,XTBLINE,!
        Q
        ;
PAUSE   Q:IOST'?1"C-".E
        K XTBANS,XTBOUT W !!,"Press ENTER to continue or '^' to end " R XTBANS:DTIME
        I XTBANS[U!('$T) S (XTBNMSP,XTBPTNAM,XTBCPLDT,XTBDA)="99999999",XTBOUT=1
        Q
