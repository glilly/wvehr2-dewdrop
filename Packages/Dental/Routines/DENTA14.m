DENTA14 ;ISC2/SAW,HAG-TREATMENT DATA REPORT - INDIVIDUAL SITTINGS ;3/29/88
        ;;1.2;DENTAL;**16,19**;JAN 26, 1989;Build 15
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
        ;  3080129 - RCR - The Variable, DENTSD is an input
        ;  DENTSD -  This is a Variable that is established before this routine is called.
        ;VERSION 1.2
        S DENTC=0,DENTSD=DENTSD-.0001,%ZIS="MQ" K IO("Q") D ^%ZIS G EXIT1:IO=""
        I $D(IO("Q")) S ZTRTN="QUE^DENTA14",ZTSAVE("DENT*")="",ZTSAVE("H1")="",ZTSAVE("H2")="",ZTSAVE("U")="",ZTSAVE("Z5")="" D ^%ZTLOAD K ZTSK,ZTRTN,ZTSAVE G EXIT1
QUE     U IO D RPT G NONE:'DENTC D:Z5'=U HOLD S:Z5=U DENTF1=1 G EXIT
RPT     F I=0:1 S DENTSD=$O(^DENT(221,"A1",DENTSTA,DENTSD)) Q:DENTSD>DENTED!(DENTSD="")  D:'I HDR^DENTA16 S DENT="" F J=0:0 S DENT=$O(^DENT(221,"A1",DENTSTA,DENTSD,DENT)) Q:DENT=""  I $D(^DENT(221,DENT,0)) S X=^(0) D HDR1 Q:Z5=U  D P1 Q:Z5=U
        Q
        ;  P1 I $D(DENTREL) Q:'$D(^DENT(221,DENT,1))  S Y(1)=$P(^(.1),"^",2) I 'Y(1)!<DENTSD1!Y(1)>DENTED Q
        ; The expression on the comment above is wrong.  I suspect that the meaning is that Y(1) needs to be
        ;   at, or between DENTSD1 and DENTED.  This test below will filter out the outer extremes.
        ;
P1      I $D(DENTREL) Q:'$D(^DENT(221,DENT,1))  S Y(1)=$P(^(.1),"^",2) I Y(1)<DENTSD1!(Y(1)>DENTED) Q
        S DENTC=DENTC+1 D CHK^DENTA15 Q:DENTF
        I $P(X,U,27) S K=$S($P(X,U,27)=1:35,1:37) W ?46,$E($P(^DIC(220.3,K,0),U,1),1,30),?79,1,! D:IOSL-($Y#IOSL)<4 HOLD1 Q
        I $P(X,U,44) W ?46,$E($P(^DIC(220.3,36,0),U,1),1,30),?79,1,! W:$P(X,U,45) ?46,$E($P(^DIC(220.3,38,0),U,1),1,30),?79,$P(X,U,45),! D:IOSL-($Y#IOSL)<4 HOLD1 Q
        I $P(X,U,41) W ?46,$E($P(^DIC(220.3,$P(X,U,41),0),U,1),1,30),?79,1,! D:IOSL-($Y#IOSL)<4 HOLD1 Q:Z5=U
        I $P(X,U,8)  W ?46,"ADMINISTRATIVE PROCEDURE",?79,1,!                D:IOSL-($Y#IOSL)<4 HOLD1 Q:Z5=U
        I $P(X,U,7)'="" S X(2)=$S($P(X,U,7)="S":"4",1:"5") W ?46,$E($P(^DIC(220.3,X(2),0),U,1),1,30),?79,1,! D:IOSL-($Y#IOSL)<4 HOLD1 Q:Z5=U
        F K=9,11:1:18,20,22:1:26,28:1:38,42:1:43 I $P(X,U,K) D W Q:Z5=U
        Q
W       W ?46,$E($P(^DIC(220.3,+$P($T(S),";",K),0),U,1),1,30),?77,$J($P(X,U,K),3),! D:IOSL-($Y#IOSL)<4 HOLD1 Q:Z5=U
        S X(2)=$P($T(S),";",K),X(3)=$P(X,U,K),X(3)=0_X(3),X(3)=$E(X(3),($L(X(3))-1),$L(X(3)))
        Q
HDR1    I IOSL-($Y#IOSL)<4 D HOLD Q:Z5=U  D HDR^DENTA16
        S Y=$P(X,U,1) X ^DD("DD") S Y=$$DATE(Y) W !,Y,?19,$P(X,U,10),?25,$P(X,U,2),?36,$J($P(X,U,19),2),?41 W:$P(X,U,19)<9 $J($P(X,U,6),2) Q
HOLD    Q:$D(ZTSK)!(IO'=IO(0))!(Z5=U)  S Z5="" R !,"Press return to continue, uparrow (^) to exit: ",Z5:DTIME Q
HOLD1   D HOLD D:Z5'=U HDR^DENTA16 Q
NONE    S DENTF1=1 W !,"There is no treatment data for the time frame you specified",*7 G EXIT1
EXIT    G EXIT1:Z5=U I $D(DENTF1) W @IOF,*7 D ERR^DENTA16 S H="" F I=1:1 Q:Z5=U  S H=$O(^UTILITY($J,"DENTERR",H)) Q:H=""  F J=1:1:5 D:$Y#(IOSL-2)=0 HOLD Q:Z5=U  W:$D(^UTILITY($J,"DENTERR",H,J)) !,^(J)
        D:'$D(DENTF1) COMP^DENTA16 D:$D(DENTF1)&(Z5'=U) HOLD
EXIT1   X ^%ZIS("C") K DENT,DENTCAT,DENTC,DENTDAT,DENTED,DENTF,DENTSD,H,H1,H2,H3,I,J,K,X D:$D(ZTSK) EXIT1^DENTA1 Q
S       ;;;04;05;;;;08;;09;15;16;33;10;20;21;22;;23;;11;12;13;14;17;;24;25;26;27;28;29;30;31;18;19;32;;;;34;06
DATE(Y) ;
        N HOLD,TIME,XDAT
        S XDAT=$P(Y,"@",1),TIME=$P(Y,"@",2)
        I TIME="" S HOLD=XDAT
        E  S HOLD=XDAT_"@"_$E(TIME,1,5)
        Q HOLD
