PRSDV459        ;HISC/MGD-VIEW PAID PAYRUN DATA ;09/09/04
        ;;4.0;PAID;**78,83,82,86,73,97,100**;Sep 21, 1995;Build 3
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        K CHOICE F LOOP=1:1:5 S CHOICE(LOOP)=$T(TABLE+LOOP)
PP      ;select pay period
        K DIC S DIC="^PRST(459,",DIC(0)="AEMQZ" D ^DIC I Y'>0 D KILL1,KILL2 Q
        S PP=+Y,PPNAME=$P(^PRST(459,PP,0),U,1)
EMP     K DASHES S $P(DASHES,"-",80)="-"
        K DIC,^UTILITY("DIQ1",$J) S DIC="^PRST(459,"_PP_",""P"",",DIC(0)="AEMQZ" D ^DIC K DIC G:Y'>0 PP
        S EMP=+Y,ZERO=^PRST(459,PP,"P",EMP,0),NAME=$P(^PRSPC(EMP,0),U,1)
        S SSN=$P(ZERO,U,2),SSN=$E(SSN,1,3)_"-"_$E(SSN,4,5)_"-"_$E(SSN,6,9)
        S TLU=$P(ZERO,U,13),STATION=$P(^PRSPC(EMP,0),U,7)
        S Y=$P(^PRSPC(EMP,0),U,49) X ^DD(450,458,2.1) S CCORG=Y
        S DS=$P($G(^PRSPC(EMP,1)),U,42)
CAT     S CLNGTH=$L(CCORG),TAB=(80-CLNGTH)\2,TAB=TAB-1
        W @IOF,!,NAME,?TAB,CCORG,?61,"DUTY STATION: ",STATION_DS
        W !,SSN,?71,"T&L: ",TLU,!,DASHES,!,"PAY PERIOD: ",PPNAME
        W !! F LOOP=1:1:5 W !,?20,$P(CHOICE(LOOP),";",3),?23,$P(CHOICE(LOOP),";",4)
SAN     W ! K DIR,DIRUT,DIROUT,DTOUT,DUOUT
        S DIR(0)="NAO^1:5:0",DIR("A")="Select a number: "
        S DIR("?")="Type a number between 1 and 5"
        D ^DIR I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) D KILL1 G EMP
        I X="@" W !!,*7,DIR("?")_"." G SAN
        G:X="" EMP
        N L,LAB,NOL
        S CATEGORY=$P(CHOICE(+Y),";",4),LAB=$P(CHOICE(+Y),";",5)
        S NOL=$P(CHOICE(+Y),";",6),PAGE=0
        F L=1:1:NOL S (DRSUB(L),PRNTORDR(L))=$P($T(@LAB+L^PRSDV459),";",3) D
        . F  Q:DRSUB(L)'[","  D
        . . S DRSUB(L)=$P(DRSUB(L),",")_";"_$P(DRSUB(L),",",2,999)
        . F  Q:DRSUB(L)'[":1:"  D
        . . S DRSUB(L)=$P(DRSUB(L),":1:")_":"_$P(DRSUB(L),":1:",2,999)
        . F  Q:DRSUB(L)'[":.01:"  D
        . . S DRSUB(L)=$P(DRSUB(L),":.01:")_":"_$P(DRSUB(L),":.01:",2,999)
        S IOFSAV=IOF
        K %ZIS,IOP S %ZIS="MQ",%ZIS("B")="" D ^%ZIS I POP D KILL1,KILL2 Q
        S IOF=IOFSAV
        F LOOP="CATEGORY","CCORG","CLNGTH","DASHES","DS","EMP","DRSUB(","NAME","PAGE","PP","PPNAME","PRNTORDR(","SSN","STATION","TAB","TLU" S ZTSAVE(LOOP)=""
        I $D(IO("Q")) S ZTIO=ION,ZTDESC="DISPLAY PAYRUN DATA",ZTRTN="DISPLAY^PRSDV459",ZTREQ="@",ZTSAVE("ZTREQ")="" D ^%ZTLOAD W:$D(ZTSK) !,"Request Queued!" D KILL1 G CAT
        D:$E(IOST,1)="C" WAIT^DICD
        U IO D DISPLAY G:PRTC=0 CAT
        I $E(IOST,1)="C" D:PRTC="" PRTC G:PRTC=0 CAT
        D:$E(IOST,1)'="C" ^%ZISC
        W @IOF G CAT
DISPLAY ;display payrun data
        N DRIEN
        S DRIEN=0
        F  S DRIEN=$O(DRSUB(DRIEN)) Q:DRIEN=""  D
        . S DIQ(0)="EIN",DIC=459,DR=1,DR(459.01)=DRSUB(DRIEN),DA(459.01)=EMP,DA=PP
        . D EN^DIQ1
        W:$E(IOST,1)="C" @IOF D HEADER S FIELDN=0
        I CATEGORY="LABOR DISTRIBUTION" D
        . S PRTC=0
        . D LD
        . I $E(IOST,1)="C" D CHECK
        . I $E(IOST,1)'="C" D ^%ZISC
        I CATEGORY'="LABOR DISTRIBUTION" D
        . S PRTC="",DRIEN=0
        . F  S DRIEN=$O(PRNTORDR(DRIEN)) Q:DRIEN=""  D
        . . S PRNTVALS="F FIELDN="_PRNTORDR(DRIEN)_" D WRITE^PRSDV459 Q:PRTC=0"
        . . X PRNTVALS
KILL1   ;kill most variables and close the device
        K D0,DIC,DIQ,DIQ2,DIR,DIRUT,DIROUT,DR,DRSUB,DTOUT,DUOUT,FIELDN,IOFSAV,IOP,LOOP,POP,PRNTORDR,PRNTVALS,X,Y,ZERO,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK,%ZIS,^UTILITY("DIQ1",$J)
        Q
KILL2   ;kill the remaining variables
        K CATEGORY,CCORG,CHOICE,CLNGTH,DA,DS,DASHES,EMP,NAME,PAGE,PP,PPNAME,PRTC,SSN,STATION,TAB,TLU,ZTREQ Q
WRITE   ;write the data
        S NODEDD=^DD(459.01,FIELDN,0),DESC=$G(^UTILITY("DIQ1",$J,459.01,EMP,FIELDN,"E"))
        I (DESC="")!(DESC="NA") K NODEDD,DESC Q
        S INTERNAL=^UTILITY("DIQ1",$J,459.01,EMP,FIELDN,"I")
        I $P(NODEDD,U,2)["NJ",+INTERNAL=0 K NODEDD,DESC Q
        I PRTC=1 D HEADER S PRTC=""
        W !,$P(NODEDD,U,1)
        W ?30,$S($P(NODEDD,U,5)["""$""":$J($FN(INTERNAL,",",2),14),$P(NODEDD,U,2)["NJ":$J(INTERNAL,14,2),$P(NODEDD,U,2)["D":$J(DESC,14),1:$J(INTERNAL,14))
        I $P(NODEDD,U,2)'["D",INTERNAL'=DESC D DESC
        K DESC,INTERNAL,NODEDD
        D CHECK
        Q
CHECK   I $E(IOST,1)="C",$Y>(IOSL-4) D PRTC
        Q
PRTC    ;press return to continue
        W ! K DIR,DIRUT,DIROUT,DTOUT,DUOUT S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR S PRTC=Y S:$D(DIRUT) PRTC=0
        Q
HEADER  ;print header
        W:$Y>0 @IOF S PAGE=PAGE+1
        S CLNGTH=$L(CCORG),TAB=(80-CLNGTH)\2,TAB=TAB-1
        W !,NAME,?TAB,CCORG,?61,"DUTY STATION: ",STATION_DS
        W !,SSN,?71,"T&L: ",TLU,!,DASHES
        S CLNGTH=$L(CATEGORY),TAB=(80-CLNGTH)\2,TAB=TAB-1
        W !,"PAY PERIOD: ",PPNAME,?TAB,CATEGORY,?73,"PAGE ",PAGE
        W !,DASHES
        K CLNGTH,TAB
        Q
LD      ; Display Labor Distribution codes
        Q:'$G(DA)
        N PRSLD,LDCNT,LDDATA,Y
        F PRSLD=1:1:4 D
        . S DIC=459,DR=1,DA=PP ; Specify Pay Period
        . S DR(459.01)=173,DA(459.01)=EMP ; Specify Employee
        . S DR(459.1173)="1;2;3;4",DA(459.1173)=PRSLD ; Specify LD multiple
        . S DIQ(0)="IE",DIQ="LDDATA"
        . D EN^DIQ1
        . F LDCNT=1:1:4 D
        . . S NODEDD=^DD(459.1173,LDCNT,0)
        . . S INTERNAL=$G(LDDATA(459.1173,PRSLD,LDCNT,"I"))
        . . I LDCNT'=3 S DESC=$G(LDDATA(459.1173,PRSLD,LDCNT,"E"))
        . . I LDCNT=3 D
        . . . S Y=INTERNAL,SUB454="CC"
        . . . D OT^PRSDUTIL K SUB454
        . . . S DESC=Y
        . . W !,"LABOR DIST CODE-",PRSLD," ",$P(NODEDD,U,1)
        . . W ?30,$S($P(NODEDD,U,5)["""$""":$J($FN(INTERNAL,",",2),14),$P(NODEDD,U,2)["NJ":$J(INTERNAL,14,2),$P(NODEDD,U,2)["D":$J(DESC,14),1:$J(INTERNAL,14))
        . . I $P(NODEDD,U,2)'["D",INTERNAL'=DESC D DESC^PRSDW450
        Q
        ;
DESC    ;write description
        I $L(DESC)<33 W ?47,DESC Q
        S COLUMN=47,LGTH=0
        F LOOP1=1:1 Q:LGTH=$L(DESC)!(LGTH>($L(DESC)))  W:$L($P(DESC," ",LOOP1))>(80-COLUMN) ! S:$L($P(DESC," ",LOOP1))>(80-COLUMN) COLUMN=47 W ?COLUMN,$P(DESC," ",LOOP1) S COLUMN=COLUMN+$L($P(DESC," ",LOOP1))+1,LGTH=LGTH+$L($P(DESC," ",LOOP1))+1
        K COLUMN,LGTH,LOOP1 Q
TABLE   ;set subfile dr variable
        ;;1;GENERAL INFORMATION;P1;1
        ;;2;EARNINGS;P2;2
        ;;3;DEDUCTIONS;P3;4
        ;;4;LEAVE;P4;1
        ;;5;LABOR DISTRIBUTION;
        ;
P1      ;;1;GENERAL INFORMATION;P1;1
        ;;2,3,4,5,6,11,13,110,122,123,112,118,111,7,8,9,10,115,116,117,171,160
P2      ;;2;EARNINGS;P2;2
        ;;81,82,83,73,85,124,149,86,87,94,95,101,90,91,97,99,100,88,89,92
        ;;93,98,96,102,103,104,104.1,172,105,109,113,114,108,106,107,74
P3      ;;3;DEDUCTIONS;P3;4
        ;;20,21,22,23,24,27,28,29,25,26,39,40,56,57,60,63,66,59,62,65,58,61
        ;;64,33,34,35,30,31,32,36,37,41:1:48,55,53,54,67.1,67,68.1,68,68.3
        ;;68.2,68.5,68.4,69,70,71,72,38,84,49,50,51,52,150,151,178,179
        ;;152,153,180,181,167,168,175,174,177,176,159
P4      ;;4;LEAVE;P4;1
        ;;75,76,77,78,79,80,80.1,80.2,106,107,154,155,156,157,158
P5      ;;5;LABOR DISTRIBUTION;
