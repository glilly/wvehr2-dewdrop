PRSD1150        ;HISC/GWB-RECORD OF LEAVE DATA ;2/5/1998
        ;;4.0;PAID;**35,100**;Sep 21, 1995;Build 3
        ;;Per VHA Directive 2004-038, this routine should not be modified.
EMP     K DIC S DIC="^PRSPC(",DIC(0)="AEMQZ"
        S DIC("A")="Select SEPARATED EMPLOYEE: " D ^DIC K DIC
        I Y'>0 G EX
        S DA=+Y
        I $P($G(^PRSPC(DA,1)),U,33)'="Y" D  G EMP
        .W !!,*7,"This is not a separated employee.  "
        .W "The SEPARATION IND does not equal Y.",!
START   ;
        K DASHES S $P(DASHES,"-",80)="-"
        S ZERO=^PRSPC(DA,0)
        S NAME=$P(ZERO,U,1),STATION=$P(ZERO,U,7),TLU=$P(ZERO,U,8)
        S SSN=$P(ZERO,U,9),SSN=$E(SSN,1,3)_"-"_$E(SSN,4,5)_"-"_$E(SSN,6,9)
        S SAL=$P(ZERO,U,29),HR=$S(SAL>99:SAL/2087,1:SAL),HR=$J(HR,0,2)
        S Y=$P(ZERO,U,49) X ^DD(450,458,2.1) S CCORG=Y
        S DS=$P($G(^PRSPC(DA,1)),U,42),LPP=$P($G(^PRSPC(DA,"MISC4")),U,16)
        S SCD=$P(ZERO,U,31)
        S SCDYR=$E(SCD,1,3),SCDMO=+$E(SCD,4,5),SCDDY=+$E(SCD,6,7)
        S DOS=$P($G(^PRSPC(DA,1)),U,2)
        S DOS1=$$FMADD^XLFDT(DOS,1) ; add 1 day so empl.  credited for DOS
        S DOS1YR=$E(DOS1,1,3),DOS1MO=+$E(DOS1,4,5),DOS1DY=+$E(DOS1,6,7)
        ;
        ; calculate difference between DOS1 and SCD
        S TOTDY=DOS1DY-SCDDY
        S TOTMO=DOS1MO-SCDMO
        S TOTYR=DOS1YR-SCDYR
        ; if negative days then recalc. Subtract 1 from month and get days by
        ; adding the days from first and last month together.
        I TOTDY<0 D
        . S SCDDIM=$P("31^28^31^30^31^30^31^31^30^31^30^31",U,SCDMO)
        . I SCDDIM=28 S SCDDIM=SCDDIM+$$LEAPYR^PRSLIB00(SCDYR+1700)
        . S TOTDY=SCDDIM-SCDDY+DOS1DY
        . S TOTMO=TOTMO-1
        I TOTMO<0 S TOTMO=TOTMO+12,TOTYR=TOTYR-1
        ;
ROLD    S CATEGORY="RECORD OF LEAVE DATA",PAGE=0
        K ^UTILITY("DIQ1",$J) S DIC="^PRSPC("
        S DR="30;49;50",DIQ(0)="IE" D EN^DIQ1 W @IOF D HDR S PRTC=1
        F F=30,49,50 D WR G:'PRTC EX
        W !,"TOTAL SERVICE FOR LEAVE.........",TOTYR," YEARS"
        W !,"                                ",TOTMO," MONTHS"
        W !,"                                ",TOTDY," DAYS"
        K ^UTILITY("DIQ1",$J) S DIC="^PRSPC("
        S DR="462;510",DIQ(0)="IE" D EN^DIQ1
        F F=462,510 D WR G:'PRTC EX
        W !,"HOURLY RATE.....................",HR
        S END="" D PRTC
EX      K ^UTILITY("DIQ1",$J)
        N PRSTLV D KILL^XUSCLEAN W @IOF
        Q
WR      S NODEDD=^DD(450,F,0),NODEUTIL=$G(^UTILITY("DIQ1",$J,450,DA,F,"E"))
        I (NODEUTIL="")!(NODEUTIL="NA") K NODEDD,NODEUTIL Q
        S FLDNAM=$P(NODEDD,U,1)
        S INT=^UTILITY("DIQ1",$J,450,DA,F,"I")
EXT     S EXT=^UTILITY("DIQ1",$J,450,DA,F,"E")
        S IL=$L(INT)
        I $P(NODEDD,U,2)["NJ",+INT=0 K NODEDD,NODEUTIL Q
        I $P(NODEDD,U,5)["""$""" S VAL=$FN(INT,",",2) G IOSL
        I $P(NODEDD,U,2)["D" S VAL=EXT G IOSL
        I $P(NODEDD,U,2)["NJ" S VAL=$J(INT,IL,2) G IOSL
        S VAL=EXT
IOSL    K DOTS S NOD=32-$L(FLDNAM),$P(DOTS,".",NOD)="."
        I $Y>(IOSL-4) D PRTC Q:'PRTC
        W !,FLDNAM,DOTS
        D VAL Q
VAL     I $L(VAL)<48 W ?32,VAL Q
        S COLUMN=32,LGTH=0
        F LOOP=1:1 Q:LGTH=$L(VAL)!(LGTH>($L(VAL)))  W:$L($P(VAL," ",LOOP))>(80-COLUMN) ! S:$L($P(VAL," ",LOOP))>(80-COLUMN) COLUMN=32 W ?COLUMN,$P(VAL," ",LOOP) S COLUMN=COLUMN+$L($P(VAL," ",LOOP))+1,LGTH=LGTH+$L($P(VAL," ",LOOP))+1
        Q
HDR     W:$Y>0 @IOF S PAGE=PAGE+1
        S CLNGTH=$L(CCORG),TAB=(80-CLNGTH)\2,TAB=TAB-1
        W !,NAME,?TAB,CCORG,?61,"DUTY STATION: ",STATION_DS
        W !,SSN,?71,"T&L: ",TLU,!,DASHES
        S CLNGTH=$L(CATEGORY),TAB=(80-CLNGTH)\2,TAB=TAB-1
        W !,"LAST PP: ",LPP,?TAB,CATEGORY,?73,"PAGE ",PAGE
        W !,DASHES
        K CLNGTH,TAB Q
PRTC    W:$Y<22 ! K DIR,DIRUT,DIROUT,DTOUT,DUOUT
        S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR
        I $D(DIRUT) S PRTC=0 Q
        D:'$D(END) HDR Q
        Q
