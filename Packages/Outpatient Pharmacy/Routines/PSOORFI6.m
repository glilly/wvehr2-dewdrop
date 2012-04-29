PSOORFI6        ;BIR/SJA-finish cprs orders cont. ;9:47 AM  10 Aug 2009
        ;;7.0;OUTPATIENT PHARMACY;**225;208**;Build 54;Build 29;WorldVistA 30-June-08
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        ;External reference to ^PSDRUG supported by DBIA 221
        ;External references PSOL, and PSOUL^PSSLOCK supported by DBIA 2789
        ;External reference to ^DPT supported by DBIA 10035
        ;
DC      N ACTION,LST,PSI,PSODFLG,PSONOORS,PSOOPT
        N VALMCNT W ! K DIR,DUOUT,DIROUT,DTOUT,PSOELSE
        ;Begin WorldVistA change; PSO*7*208; 08/10/2009
        I $G(PSOAFYN)'="Y",'$G(PSOERR("DEAD")) S PSOELSE=1 D PDATA Q:$D(DUOUT)!$D(DTOUT)  D  Q:$D(DIRUT)
        .D NOOR^PSOCAN4 Q:$D(DIRUT)
        .S DIR("A")="Comments",DIR(0)="F^10:75",DIR("B")="Per Pharmacy Request" D ^DIR K DIR
        I $G(PSOAFYN)="Y" N VALMCNT K DIR,DUOUT,DIROUT,DTOUT,PSOELSE I '$G(PSOERR("DEAD")) S PSOELSE=1 D  Q:$D(DIRUT)  ;vfah
        .D NOOR^PSOCAN4 Q:$D(DIRUT)  ;vfah
        .S Y="Rx AutoFinish" ;vfah
        I $G(PSOAFYN)'="Y" S PSOELSE="1"
        ;End WorldVistA change
        I '$G(PSOELSE) K PSOELSE S PSONOOR="A" D DE^PSOORFI2 I '$G(ACTION)!('$D(PSODFLG)) S VALMBCK="R" Q
        K PSOELSE I $D(DIRUT) K DIRUT,DUOUT,DTOUT,Y Q
        S ACOM=Y
        S INCOM=ACOM,PSONOORS=PSONOOR D DE^PSOORFI2
        I '$G(ACTION)!('$D(PSODFLG)) Q
        S PSONOOR=PSONOORS D RTEST D SPEED D ULP^PSOCAN
        K PSOCAN,ACOM,INCOM,ACTION,LINE,PSONOOR,PSOSDXY,PSONOORS,PSOOPT,RXCNT,REA,RX,PSODA,DRG
        S Y=-1
        Q
PSPEED  S (YY,PSODA)=$P(PSOSD(STA,DRG),"^"),RX=$P($G(^PSRX(PSODA,0)),"^") D SPEED1 Q:PSPOP!($D(PSINV(RX)))
        Q:$G(SPEED)&(REA="R")
SHOW    S DRG=+$P(^PSRX(PSODA,0),"^",6),DRG=$S($D(^PSDRUG(DRG,0)):$P(^(0),"^"),1:"")
        S LC=0 W !,$P(^PSRX(PSODA,0),"^"),"  ",DRG,?52,$S($D(^DPT(+$P(^PSRX(PSODA,0),"^",2),0)):$P(^(0),"^"),1:"PATIENT UNKNOWN")
        I REA="C" W !?25,"Rx to be Discontinued",! Q
        W !?21,"*** Rx to be Reinstated ***",!
        Q
SPEED1  S PSPOP=0 I $G(PSODIV),+$P($G(^PSRX(PSODA,2)),"^",9)'=$G(PSOSITE) D:'$G(SPEED) DIV^PSOCAN
        K STAT S STAT=+$P(^PSRX(PSODA,"STA"),"^"),REA=$E("C00CCCCCCCCCR000C",STAT+1)
        Q:$G(SPEED)&(REA="R")
        I REA="R",$P($G(^PSRX(PSODA,"PKI")),"^") S PKI=1 S PSINV(RX)="" Q
        I REA=0!(PSPOP)!($P(^PSRX(+YY,"STA"),"^")>12),$P(^("STA"),"^")<16 S PSINV(RX)="" Q
        S:REA'=0&('PSPOP) PSCAN(RX)=PSODA_"^"_REA,RXCNT=$G(RXCNT)+1
        Q
SPEED   N PKI K PSINV,PSCAN S PSODA=IN I $D(^PSRX(PSODA,0)) S YY=PSODA,RX=$P(^(0),"^") S:PSODA<0 PSINV(RX)="" D:PSODA>0 SPEED1
        G:'$D(PSCAN) INVALD S II="",RXCNT=0 F  S II=$O(PSCAN(II)) Q:II=""  S PSODA=+PSCAN(II),REA=$P(PSCAN(II),"^",2),RXCNT=RXCNT+1 D SHOW
        ;
ASK     G:'$D(PSCAN) INVALD W ! S DIR("A")="OK to "_$S($G(RXCNT)>1:"Change Status",REA="C":"Discontinue the active order",1:"Reinstate"),DIR(0)="Y",DIR("B")="N"
        D ^DIR K DIR I $D(DIRUT) S:$O(PSOSDX(0)) PSOSDXY=1 Q
        I 'Y S:$O(PSOSDX(0)) PSOSDXY=1 K PSCAN D INVALD Q
        S RX="" F  S RX=$O(PSCAN(RX)) Q:RX=""  D PSOL^PSSLOCK(+PSCAN(RX)) I $G(PSOMSG) D ACT D PSOUL^PSSLOCK(+PSCAN(RX))
        D INVALD
        Q
ACT     S DA=+PSCAN(RX),REA=$P(PSCAN(RX),"^",2),II=RX,PSODFN=$P(^PSRX(DA,0),"^",2) I REA="R" D REINS^PSOCAN2 Q
        S PSOOPT=-1 D CAN^PSOCAN
        Q
INVALD  K PSCAN Q:'$D(PSINV)  W !! F I=1:1:80 W "="
        W $C(7),!!,"The Following Rx Number(s) Are Invalid Choices, Expired, "_$S($G(PKI):"Digitally Signed",1:""),!,"Discontinued by Provider, or Marked As Deleted:" S II="" F  S II=$O(PSINV(II)) Q:II=""  W !?10,II
        K PSINV I $G(PSOERR)!($G(SPEED)) K DIR,DUOUT,DTOUT,DIRUT S DIR(0)="E",DIR("A")="Press Return to Continue"
        D ^DIR K DIR,DTOUT,DIRUT,DUOUT
KILL    D KILL^PSOCAN2
        K PSOMSG,PSOPLCK,PSOWUN,PSOULRX
        Q
RTEST   ;
        Q:'$G(LINE)
        N PCIN,PCINFLAG,PCINX
        S PCINFLAG=0 F PCIN=1:1 S PCINX=$P(LINE,",",PCIN) Q:$P(LINE,",",PCIN)']""  D
        .Q:'$G(PCINX)
        .Q:'$G(PSOCAN(PCINX))
        .I $P($G(^PSRX(+$G(PSOCAN(PCINX)),"STA")),"^")'=12,'$G(PCINFLAG) S PSOCANRD=+$P($G(^PSRX($G(PSOCAN(PCINX)),0)),"^",4) S PCINFLAG=1
        I '$G(PCINFLAG) S PSOCANRZ=1
        Q
RTESTA  ;
        N PFIN,PFINZ,PFINFLAG
        S PFINFLAG=0 S PFIN="" F  S PFIN=$O(PSOSD(PFIN)) Q:PFIN=""  S PFINZ="" F  S PFINZ=$O(PSOSD(PFIN,PFINZ)) Q:PFINZ=""  D
        .I $G(PFIN)'="PENDING" I $P($G(^PSRX(+$P($G(PSOSD(PFIN,PFINZ)),"^"),"STA")),"^")'=12,'$G(PFINFLAG) S PSOCANRD=+$P($G(^(0)),"^",4),PFINFLAG=1
        I '$G(PFINFLAG) S PSOCANRZ=1
        Q
PDATA   Q:$P(^PS(52.41,ORD,0),"^",3)'="RNW"!('$P(^PS(52.41,ORD,0),"^",21))
        S PSI=0,IN=0 F  S PSI=$O(PSOLST(PSI)) Q:'PSI!(IN)  I $P(PSOLST(PSI),"^",2)=$P(^PS(52.41,ORD,0),"^",21) S LINE=PSI,(PSOCAN(PSI),IN)=$P(PSOLST(PSI),"^",2)
        Q:'$G(LINE)
        S:(+$G(^PSRX($P(^PS(52.41,ORD,0),"^",21),"STA"))<9) PSODFLG=1 Q:'$G(PSODFLG)
        D ASKDC S ACTION=Y
        Q
ASKDC   W ! K DIR,DUOUT,DIRUT,DTOUT
        S DIR("A")="There is an active Rx for this pending order, Discontinue both (Y/N)",DIR("B")="NO",DIR(0)="Y"
        S DIR("?",1)="Y - Discontinue both pending and active Rx",DIR("?",2)="N - Discontinue pending order only"
        S DIR("?")="'^' - Quit (no action taken)" D ^DIR K DIR Q
