PSOAFSET        ;VFA/HMS autofinish site parameter set up ;1/30/07  19:41
        ;;7.0;OUTPATIENT PHARMACY;**208**;DEC 1997;Build 54
        ; Copyright (C) 2007 WorldVistA
        ;
        ; This program is free software; you can redistribute it and/or modify
        ; it under the terms of the GNU General Public License as published by
        ; the Free Software Foundation; either version 2 of the License, or
        ; (at your option) any later version.
        ;
        ; This program is distributed in the hope that it will be useful,
        ; but WITHOUT ANY WARRANTY; without even the implied warranty of
        ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ; GNU General Public License for more details.
        ;
        ; You should have received a copy of the GNU General Public License
        ; along with this program; if not, write to the Free Software
        ; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
        ;'Modified' MAS Patient Look-up Check Cross-References June 1987
VERS    ;
        ;Is taken from PSOLSET ;vfah
        ;Reference to ^PS(59.7 supported by DBIA 694
        ;Reference to ^PSX(550 supported by DBIA 2230
        ;Reference to ^%ZIS supported by DBIA 3435
        ;
        ;Called by PSOORFIN if using AutoFinish,Rx
        S PSOBAR1="",PSOBARS=0 ;make sure we have one
        S PSOCNT=0 F I=0:0 S I=$O(^PS(59,I)) Q:'I  S PSOCNT=PSOCNT+1,Y=I
        S PSOPAR=$G(^PS(59,PSOSITE,1)),PSOPAR7=$G(^PS(59,PSOSITE,"IB")),PSOSYS=$G(^PS(59.7,1,40.1)) D CUTDATE^PSOFUNC ;HMS From DIV3
        S PSOPINST=$P($G(^PS(59,PSOSITE,"INI")),"^")
        S (SITE,DA)=$P(^XMB(1,1,"XUS"),"^",17),DIC="4",DIQ(0)="IE",DR=".01;99",DIQ="PSXUTIL" D EN^DIQ1 S S3=$G(PSXUTIL(4,SITE,99,"I")),S2=$G(PSXUTIL(4,SITE,.01,"E")) K DA,DIC,DIQ(0),DR
        S PSXSYS=+$O(^PSX(550,"C",""))_"^"_$G(S3)_"^"_$G(S2),PSOINST=S3
        K S3,S2,S1,PSXUTIL
        I $G(PSXSYS) D
        .K:($P($G(^PSX(550,+PSXSYS,0)),"^",2)'="A") PSXSYS
        .S Y=$$VERSION^XPDUTL("PSO") I Y>6.0 S PSXVER=1
        E  K PSXSYS
        S PSODIV=$S(($P(PSOSYS,"^",2))&('$P(PSOSYS,"^",3)):0,1:1)
        ;
        ;I $D(DUZ),$D(^VA(200,+DUZ,0)) S PSOCLC=DUZ
        I $D(DUZ) S DIC="^VA(200,",DIC(0)="NQEZ",X=DUZ
        D ^DIC K DIC
        I +Y S PSOCLC=DUZ
        ;
PLBL    Q  ;HMS No printer selection PSOAFSET ends here
LBL     S %ZIS="MNQ",%ZIS("A")="Select LABEL PRINTER: " S:$G(PSOCLBL)&($D(PSOLAP))!($G(SUSPT)) %ZIS("B")=$S($G(SUSPT):PSLION,1:PSOLAP)
        D ^%ZIS K %ZIS,IO("Q"),IOP G:POP EXIT S @$S($G(SUSPT):"PSLION",1:"PSOLAP")=ION,PSOPIOST=$G(IOST(0))
        N PSOIOS S PSOIOS=IOS D DEVBAR^PSOBMST
        S PSOBARS=PSOBAR1]""&(PSOBAR0]"")&$P(PSOPAR,"^",19),PSOIOS=IOS D ^%ZISC
LASK    I $G(PSOPIOST),$D(^%ZIS(2,PSOPIOST,55,"B","LL")) G EXIT
        K DIR S DIR("A")="OK to assume label alignment is correct",DIR("B")="YES",DIR(0)="Y",DIR("?")="Enter Y if labels are aligned, N if they need to be aligned." D ^DIR G:Y!($D(DIRUT)) EXIT
P2      S IOP=$G(PSOLAP) D ^%ZIS K IOP I POP W $C(7),!?5,"Printer is busy.",! G LASK
        U IO(0) W !,"Align labels so that a perforation is at the top of the",!,"print head and the left side is at column zero."
        W ! K DIR,DIRUT,DUOUT,DTOUT S DIR(0)="E" D ^DIR K DIR,DTOUT,DUOUT Q:$D(DIRUT)  D ^PSOLBLT D ^%ZISC
        K DIRUT,DIR S DIR("A")="Is this correct",DIR("B")="YES",DIR(0)="Y",DIR("?")="Enter Y if labels are aligned correctly, N if they need to be aligned." D ^DIR G:Y!($D(DIRUT)) EXIT
        G P2
LEAVE   S XQUIT="" G FINAL
Q       W !?10,$C(7),"Default printer for labels must be entered." G LBL
        ;
EXIT    D ^%ZISC Q:$G(PSOCLBL)
        D:'$G(PSOBFLAG) GROUP K I,IOP,X,Y,%ZIS,DIC,J,DIR,X,Y,DTOUT,DIROUT,DIRUT,DUOUT Q
        ;
FINAL   ;exit action from main menu - kill and quit
        K SITE,PSOCP,PSNP,PSL,PRCA,PSLION,PSOPINST
        K GROUPCNT,DISGROUP,PSOCAP,PSOINST,PSOION,PSONULBL,PSOSITE7,PFIO,PSOIOS,X,Y,PSOSYS,PSODIV,PSOPAR,PSOPAR7,PSOLAP,PSOPROP,PSOCLC,PSOCNT
        K PSODTCUT,PSOSITE,PSOPRPAS,PSOBAR1,PSOBAR0,PSOBARS,SIG,DIR,DIRUT,DTOUT,DIROUT,DUOUT,I,%ZIS,DIC,J,PSOREL
        Q
GROUP   ;display group
        S GROUPCNT=0,AGROUP="" I $D(^PS(59.3,0)) F  S AGROUP=$O(^PS(59.3,"B",AGROUP)) Q:AGROUP=""  D
        .S GROUPCNT=GROUPCNT+1 I GROUPCNT=1 S AGROUP1=AGROUP
        S:GROUPCNT=1 GRPNME=AGROUP1,II="" G:GROUPCNT>1 GROUP1
        Q:'$D(GRPNME)  F  S II=$O(^PS(59.3,"B",GRPNME,II)) Q:II=""  S DISGROUP=II
        K AGROUP,AGROUP1,GRPNME,II
        Q
GROUP1  W ! S DIC("A")="Bingo Board Display: ",DIC=59.3,DIC(0)="AEMQZ",DIR(0)="Y",DIR("?")="Enter 'Y' to select Bingo Board Display or 'N' to EXIT"
        S:$P($G(^PS(59,PSOSITE,1)),"^",20) DIC("B")=$P($G(^PS(59,PSOSITE,1)),"^",20)
        D ^DIC K DIC Q:$D(DTOUT)!($D(DUOUT))
        I +Y<0 W $C(7) S DIR("A",1)="A 'BINGO BOARD DISPLAY' should be selected!",DIR("A")="Do you want to try again",DIR("B")="YES",DIR("?")="A display group must be defined in order to run Bingo Board." D ^DIR Q:"Y"'[$E(X)  G GROUP
        S DISGROUP=+Y
        K DIR,DIC,AGROUP,AGROUP1,GRPNME,II
        Q
