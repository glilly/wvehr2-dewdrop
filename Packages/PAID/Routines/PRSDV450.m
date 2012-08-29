PRSDV450        ;HISC/MGD-VIEW PAID EMPLOYEE DATA ;09/05/2003
        ;;4.0;PAID;**2,82,114,100**;Sep 21, 1995;Build 3
        ;;Per VHA Directive 2004-038, this routine should not be modified.
EN1     ;HRM entry
        S LIMIT=10,PRSTLV=7 D PTBL^PRSDVTBL G EMP
EN2     ;Fiscal entry
        S LIMIT=12,PRSTLV=7 D FTBL^PRSDVTBL
EMP     K DASHES S $P(DASHES,"-",80)="-",FIRST=""
        K DIC,^UTILITY("DIQ1",$J)
        S DIC="^PRSPC(",DIC(0)="AEMQZ",DIC("A")="Select EMPLOYEE: " D ^DIC
        K DIC I Y'>0 D KILL1,KILL2 Q
        S DA=+Y,ZERO=^PRSPC(DA,0),NAME=$P(ZERO,U,1),SSN=$P(ZERO,U,9)
        S SSN=$E(SSN,1,3)_"-"_$E(SSN,4,5)_"-"_$E(SSN,6,9),TLU=$P(ZERO,U,8)
        S STATION=$P(ZERO,U,7),Y=$P(ZERO,U,49) X ^DD(450,458,2.1) S CCORG=Y
        S DS=$P($G(^PRSPC(DA,1)),U,42),LPP=$P($G(^PRSPC(DA,"MISC4")),U,16)
CAT     S CLNGTH=$L(CCORG),TAB=(80-CLNGTH)\2,TAB=TAB-1
        W @IOF,!,NAME,?TAB,CCORG,?61,"DUTY STATION: ",STATION_DS
        W !,SSN,?71,"T&L: ",TLU,!,DASHES
        W ! F L=1:1:LIMIT W !,?20,$P(CHOICE(L),";",3),?23,$P(CHOICE(L),";",4)
SAN     W ! K DIR,DIRUT,DIROUT,DTOUT,DUOUT
        S DIR(0)="NAO^1:"_LIMIT_":0",DIR("A")="Select a number: "
        S DIR("?")="Type a number between 1 and "_LIMIT S:$D(FIRST) DIR("B")=3
        D ^DIR I ($D(DTOUT))!($D(DUOUT))!($D(DIROUT)) D KILL1 G EMP
        I X="@" W !!,*7,DIR("?")_"." G SAN
        G:X="" EMP
        I CHOICE(+Y)["NURSING" S PP=$P(^PRSPC(DA,0),U,21) I (PP'="K")&(PP'="M")&(PP'="X") W !!,*7,"This employee is not a nurse.  Pay Plan code not K, M or X.",! K PP G SAN
        I CHOICE(+Y)["SEPARATED" I $P($G(^PRSPC(DA,1)),U,33)'="Y" W !!,*7,"This is not a separated employee.  Separation Ind not equal Y.",! G SAN
        S PAGE=0,CATEGORY=$P(CHOICE(+Y),";",4),LAB=$P(CHOICE(+Y),";",5)
        S NOL=$P(CHOICE(+Y),";",6)
        F L=1:1:NOL S (VAL(L),PRNTORDR(L))=$P($T(@LAB+L^PRSDVTBL),";",3) D
        .F  Q:VAL(L)'[","  S VAL(L)=$P(VAL(L),",")_";"_$P(VAL(L),",",2,999)
        .F  Q:VAL(L)'[":1:"  S VAL(L)=$P(VAL(L),":1:")_":"_$P(VAL(L),":1:",2,999)
        .F  Q:VAL(L)'[":.01:"  S VAL(L)=$P(VAL(L),":.01:")_":"_$P(VAL(L),":.01:",2,999)
        S IOFSAV=IOF
        K %ZIS,IOP S %ZIS="MQ",%ZIS("B")="" D ^%ZIS I POP D KILL1,KILL2 Q
        S IOF=IOFSAV
        F L="CATEGORY","CCORG","CLNGTH","DA","DASHES","DATETIME","VAL(","DS","LPP","NAME","PAGE","PRNTORDR(","SSN","STATION","TAB","TLU","PRSTLV" S ZTSAVE(L)=""
        I $D(IO("Q")) S ZTIO=ION,ZTDESC="DISPLAY EMPLOYEE DATA",ZTRTN="DISPLAY^PRSDV450",ZTREQ="@",ZTSAVE("ZTREQ")="" D ^%ZTLOAD W:$D(ZTSK) !,"Request Queued!" D KILL1 K FIRST G CAT
        D:$E(IOST,1)="C" WAIT^DICD
        U IO D DISPLAY K FIRST G:PRTC=0 CAT
        I $E(IOST,1)="C" D:PRTC="" PRTC G:PRTC=0 CAT
        D:$E(IOST,1)'="C" ^%ZISC
        W @IOF K FIRST G CAT
DISPLAY S DRIEN=0 F  S DRIEN=$O(VAL(DRIEN)) Q:DRIEN=""  S DIQ(0)="EI",DIC="^PRSPC(",DR=VAL(DRIEN) D EN^DIQ1
        W:$E(IOST,1)="C" @IOF D HDR^PRSDSRS
        D ^PRSDYTD
        I CATEGORY="LABOR DISTRIBUTION" D
        . S PRTC=0
        . D LD
        . I $E(IOST,1)="C" D CHECK
        . I $E(IOST,1)'="C" D ^%ZISC
        I CATEGORY'="LABOR DISTRIBUTION" D
        . S PRIEN=0,PRTC="" F  S PRIEN=$O(PRNTORDR(PRIEN)) Q:PRIEN=""  S PRNTVALS="F FIELDN="_PRNTORDR(PRIEN)_" D WRITE^PRSDW450 Q:PRTC=0" X PRNTVALS
KILL1   K D0,DIC,DIQ,DIQ2,DIR,DIRUT,DIROUT,DR,DRIEN,VAL,DTOUT,DUOUT,FIELDN
        K IOFSAV,IOP,L,POP,PRIEN,PRNTORDR,PRNTVALS,X,Y,ZERO,ZTDESC,ZTIO,ZTRTN
        K ZTSAVE,ZTSK,%ZIS,^UTILITY("DIQ1",$J)
        D YTDEX^PRSDYTD
        Q
KILL2   K CATEGORY,CCORG,CHOICE,CLNGTH,DA,DASHES,DATETIME,DS,FIRST,LAB,LIMIT,LPP
        K NAME,NOL,PAGE,PRSTLV,PRTC,SSN,STATION,TAB,TLU,LOOP,ZTREQ,%,%I
        Q
CHECK   I $E(IOST,1)="C",$Y>(IOSL-4) D PRTC
        Q
PRTC    W ! K DIR,DIRUT,DIROUT,DTOUT,DUOUT
        S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR S PRTC=Y
        S:$D(DIRUT) PRTC=0
        Q
LD      ; Display Labor Distribution codes 
        Q:'$G(DA)
        N DESC,INTERNAL,LDCNT,LDDATA,NODEDD,PRSLD,Y
        S DIC=450,DIQ(0)="IE",DIQ="LDDATA"
        F PRSLD=756,755,755.1 D
        . S DR=PRSLD
        . D EN^DIQ1
        . S NODEDD=^DD(450,PRSLD,0)
        . S INTERNAL=$G(LDDATA(450,DA,PRSLD,"I"))
        . S DESC=$G(LDDATA(450,DA,PRSLD,"E"))
        . W !,$P(NODEDD,U,1)
        . W ?30,$S($P(NODEDD,U,5)["""$""":$J($FN(INTERNAL,",",2),14),$P(NODEDD,U,2)["NJ":$J(INTERNAL,14,2),$P(NODEDD,U,2)["D":$J(DESC,14),1:$J(INTERNAL,14))
        . I $P(NODEDD,U,2)'["D",INTERNAL'=DESC D DESC^PRSDW450
        ;
        F PRSLD=1:1:4 D
        . S DIC=450,DR=757 ; Specify LD multiple
        . S DR(450.0757)="1;2;3;4",DA(450.0757)=PRSLD ; Specify fields w/in mult
        . S DIQ(0)="IE",DIQ="LDDATA"
        . D EN^DIQ1
        . F LDCNT=1:1:4 D
        . . S NODEDD=^DD(450.0757,LDCNT,0)
        . . S INTERNAL=$G(LDDATA(450.0757,PRSLD,LDCNT,"I"))
        . . I LDCNT'=3 S DESC=$G(LDDATA(450.0757,PRSLD,LDCNT,"E"))
        . . I LDCNT=3 D
        . . . S Y=INTERNAL,SUB454="CC"
        . . . D OT^PRSDUTIL K SUB454
        . . . S DESC=Y
        . . W !,"LABOR DIST CODE-",PRSLD," ",$P(NODEDD,U,1)
        . . W ?30,$S($P(NODEDD,U,5)["""$""":$J($FN(INTERNAL,",",2),14),$P(NODEDD,U,2)["NJ":$J(INTERNAL,14,2),$P(NODEDD,U,2)["D":$J(DESC,14),1:$J(INTERNAL,14))
        . . I $P(NODEDD,U,2)'["D",INTERNAL'=DESC D DESC^PRSDW450
        . . D CHECK
        . . I PRTC W @IOF D HDR^PRSDSRS S PRTC=0
        I $E(IOST,1)="C" D PRTC
        Q
