PSOLBLN2        ;BHAM ISC/RTR - NEW LABEL TRAILER ;1:04 PM  18 Dec 2011
        ;;7.0;OUTPATIENT PHARMACY;**92,107,110,305,326**;DEC 1997;Build 59;WorldVistA 30-June-08
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
        Q:'+$G(RXN)!('$G(PSOTRAIL))!('+$G(DFN))
        I $G(PSOBLALL),$P(PPL,",",PI+1)'="" Q
        K ^TMP($J,"PSOMAIL"),^TMP($J,"PSONARR"),^TMP($J,"PSOSUSP") S PRCOPAY=$S('$D(PSOCPN):0,1:1)
START   ;RETURN MAIL
        S PS=$S($D(^PS(59,PSOSITE,0)):^(0),1:"") I $P(PSOSYS,"^",4),$D(^PS(59,+$P($G(PSOSYS),"^",4),0)) S PS=^PS(59,$P($G(PSOSYS),"^",4),0)
        S VAADDR1=$P(PS,"^"),VASTREET=$P(PS,"^",2),STATE=$S($D(^DIC(5,+$P(PS,"^",8),0)):$P(^(0),"^",2),1:"UNKNOWN")
        S PSZIP=$P(PS,"^",5) S PSOHZIP=$S(PSZIP["-":PSZIP,1:$E(PSZIP,1,5)_$S($E(PSZIP,6,9)]"":"-"_$E(PSZIP,6,9),1:""))
        S ^TMP($J,"PSOMAIL",$S(PRCOPAY:1,1:3))="Pharmacy Service (119)",^($S(PRCOPAY:2,1:4))=$G(VAADDR1),^($S(PRCOPAY:3,1:5))=$G(VASTREET),^($S(PRCOPAY:4,1:6))=$P(PS,"^",7)_", "_$G(STATE)_"  "_$G(PSOHZIP)
        I PRCOPAY F ZZZ=5:1:15 S ^TMP($J,"PSOMAIL",ZZZ)=""
        I 'PRCOPAY F ZZZ=7:1:17 S ^TMP($J,"PSOMAIL",ZZZ)=""
        S ^TMP($J,"PSOMAIL",$S(PRCOPAY:16,1:18))="Use the label above to mail the computer",^($S(PRCOPAY:17,1:19))="copies back to us. Apply enough postage",^($S(PRCOPAY:18,1:20))="to your envelope to ensure delivery."
NARR    ;SET TMP GLOBAL FOR NARRATIVES
        K ^UTILITY($J,"W") S (DIWL,PSNACNT)=1,DIWR=45,DIWF="",(PSSIXFL,PSSEVFL)=0 F ZZ=0:0 S ZZ=$O(^PS(59,PSOSITE,6,ZZ)) Q:'ZZ  I $D(^(ZZ,0)) S X=^(0) D ^DIWP
        F LLL=0:0 S LLL=$O(^UTILITY($J,"W",DIWL,LLL)) Q:'LLL  S ^TMP($J,"PSONARR",PSNACNT)=^UTILITY($J,"W",DIWL,LLL,0) S PSNACNT=PSNACNT+1,PSSIXFL=1
        I PSSIXFL S ^TMP($J,"PSONARR",PSNACNT)="" S PSNACNT=PSNACNT+1
        S DIWL=1,DIWR=45,DIWF="" K ^UTILITY($J,"W") F ZZ=0:0 S ZZ=$O(^PS(59,PSOSITE,7,ZZ)) Q:'ZZ  I $D(^(ZZ,0)) S X=^(0) D ^DIWP
        F LLL=0:0 S LLL=$O(^UTILITY($J,"W",DIWL,LLL)) Q:'LLL  S ^TMP($J,"PSONARR",PSNACNT)=^UTILITY($J,"W",DIWL,LLL,0) S PSNACNT=PSNACNT+1,PSSEVFL=1
        I $G(PSOCHAMP),$G(PSOTRAMT) D:PSSEVFL  S ^TMP($J,"PSONARR",PSNACNT)="REMIT $"_PSOTRAMT_" TO AGENT CASHIER." G SUSP
        .S ^TMP($J,"PSONARR",PSNACNT)="" S PSNACNT=PSNACNT+1
        I 'PRCOPAY G SUSP
        I PSSEVFL S ^TMP($J,"PSONARR",PSNACNT)="" S PSNACNT=PSNACNT+1
        S DIWL=1,DIWR=45,DIWF="" K ^UTILITY($J,"W") F ZZ=0:0 S ZZ=$O(^PS(59,PSOSITE,4,ZZ)) Q:'ZZ  I $D(^(ZZ,0)) S X=^(0) D ^DIWP
        F LLL=0:0 S LLL=$O(^UTILITY($J,"W",DIWL,LLL)) Q:'LLL  S ^TMP($J,"PSONARR",PSNACNT)=^UTILITY($J,"W",DIWL,LLL,0) S PSNACNT=PSNACNT+1
SUSP    ;SUSPENSE DOCUMENT
        S (PSSUFLG,PSSPCNT)=0 S:'$D(DFN) DFN=+$P($G(^PSRX(RX,0)),"^",2) S PSODFN=DFN,(SPPL,RXX,STA)=""
        I $G(PSODTCUT)']"" S X1=DT,X2=-120 D C^%DTC S PSODTCUT=X
        D ^PSOBUILD S (STA,RXX)="" F  S STA=$O(PSOSD(STA)) Q:STA=""  F  S RXX=$O(PSOSD(STA,RXX)) Q:RXX=""  I $P(PSOSD(STA,RXX),"^",2)=5 S SPPL=$P(PSOSD(STA,RXX),"^")_","_SPPL
        D 6^VADPT,PID^VADPT I SPPL="" S PSSUFLG=1 G PRINT
        S ^TMP($J,"PSOSUSP",1)="",^(2)=VADM(1),^(3)=$G(VAPA(1)),^(4)=$G(ADDR(2)) I $G(ADDR(3))="",$G(ADDR(4))="" S ^TMP($J,"PSOSUSP",5)="" G ADD
        I $G(ADDR(3))'="",$G(ADDR(4))="" S ^TMP($J,"PSOSUSP",5)=$G(ADDR(3)) S ^TMP($J,"PSOSUSP",6)="" G ADD
        S ^TMP($J,"PSOSUSP",5)=$G(ADDR(3)),^(6)=$G(ADDR(4)),^(7)=""
ADD     F ZZ=0:0 S ZZ=$O(^TMP($J,"PSOSUSP",ZZ)) Q:'ZZ  S PSSPCNT=ZZ
        S PSSPCNT=PSSPCNT+1 S ^TMP($J,"PSOSUSP",PSSPCNT)="   The following prescriptions will be" S PSSPCNT=PSSPCNT+1 S ^TMP($J,"PSOSUSP",PSSPCNT)="mailed to you on or after the date indicated." S PSSPCNT=PSSPCNT+1
        S ^TMP($J,"PSOSUSP",PSSPCNT)="",PSSPCNT=PSSPCNT+1,^(PSSPCNT)="Rx#                   Date",PSSPCNT=PSSPCNT+1,^(PSSPCNT)="============================================",PSSPCNT=PSSPCNT+1,^(PSSPCNT)="",PSSPCNT=PSSPCNT+1
        F XX=1:1 Q:$P(SPPL,",",XX)=""  S PSSSRX=$P(SPPL,",",XX) D
        .S SPNUM=$O(^PS(52.5,"B",PSSSRX,0)) I SPNUM S SPDATE=$P($G(^PS(52.5,SPNUM,0)),"^",2) S Y=SPDATE D DD^%DT S SPDATE=Y
        .S $P(PSOLGTH," ",(20-($L($P(^PSRX(PSSSRX,0),"^")))))="" S ^TMP($J,"PSOSUSP",PSSPCNT)=$P(^PSRX(PSSSRX,0),"^")_PSOLGTH_$G(SPDATE) S PSSPCNT=PSSPCNT+1
        .S ^TMP($J,"PSOSUSP",PSSPCNT)="  "_$$ZZ^PSOSUTL(PSSSRX) S PSSPCNT=PSSPCNT+1 K SPNUM,SPDATE,Y
PRINT   S PSOTRDFN=$P(VADM(2),"^"),PSOTRDFN=$S(PSOTRDFN]"":PSOTRDFN,1:"Unavailable") S Y=DT X ^DD("DD") S EDT=Y
        ;Begin WorldVistA Change ;PSO*7.0*208
        ;W ?54,VADM(1)_" "_$E($P(VADM(2),"^",2),5,12)_" "_EDT
        ;End WorldVistA Change
        W ! I PRCOPAY,$G(PSOBARS) S X="S",X2=PSOTRDFN,X1=$X W ?54,@PSOBAR1,PSOTRDFN,@PSOBAR0,$C(13) S $X=0
        I PRCOPAY,'$G(PSOBARS) W !!!
        I 'PRCOPAY W !
        I 'PSSUFLG D PRSUS,NPP1 G END
        S (PSNONARR,PSNOADDR,PSNOBOTH)=0 F TTT=1:1 Q:$G(PSNOBOTH)  D
        .;Begin WorldVistA Change ;PSO*7.0*208
        .;W $G(^TMP($J,"PSOMAIL",TTT)) S:'$O(^(TTT)) PSNOADDR=1
        .;W ?54,$G(^TMP($J,"PSONARR",TTT)),! S:'$O(^(TTT)) PSNONARR=1
        .;I PSNOADDR,PSNONARR S PSNOBOTH=1
        .;End WorldVistA Change
        D NPP1
END     K ^TMP($J,"PSONARR"),^TMP($J,"PSOMAIL"),^TMP($J,"PSOSUSP"),^UTILITY($J,"W")
        K DIWF,DIWL,DIWR,EDT,LLL,PRCOPAY,PS,PSNACNT,PSNOADDR,PSNOBOTH,PSNONARR,PSNOSUSP,PSNTHREE,PSOLGTH,PSOSD,PSOTRAIL,PSOTRDFN,PSSEVFL,PSSIXFL,PSSPCNT,PSSSRX,PSSUFLG,RXX,SPDATE,SPNUM,SPPL,STATE,TTT,VAADDR1,VADM,VAEL,VAPA,VASTREET,ZZ,ZZZ W @IOF
        I $P(PSOPAR,"^",31) D BLANK^PSOLBLD W @IOF
        Q
NPP1    ;
        N PSOLAN S PSOLAN=$P($G(^PS(55,DFN,"LAN")),"^",2) S:'PSOLAN PSOLAN=1
        I $G(PSOLAN)=1 D
        . W !,"The VA Notice of Privacy Practices, IB 10-163, which outlines your privacy",!
        . W "rights, is available online at http://www1.va.gov/Health/ or you may obtain",!
        . W "a copy by writing the VHA Privacy Office (19F2), 810 Vermont Avenue NW,",!
        . W "Washington, DC 20420.",!
        I $G(PSOLAN)=2 D
        . W !,"La Notificacion relacionada con las Politicas de Privacidad del Departamento",!
        . W "de Asuntos del Veterano, IB 10-163, contiene los detalles acerca de sus",!
        . W "derechos de privacidad y esta disponible electronicamente en la siguiente",!
        . W "direccion: http://www1.va.gov/Health/.  Usted tambien puede conseguir una",!
        . W "copia escribiendo a la Oficina de Privacidad del Departamento de Asuntos de",!
        . W "Salud del Veterano, (19F2), 810 Vermont Avenue NW, Washington, DC 20420.",!
        Q
        ;
PRSUS   S (PSNONARR,PSNOADDR,PSNOSUSP,PSNTHREE)=0 F TTT=1:1 Q:$G(PSNTHREE)  D
        .W $G(^TMP($J,"PSOMAIL",TTT)) S:'$O(^(TTT)) PSNOADDR=1
        .W ?54,$G(^TMP($J,"PSONARR",TTT)) S:'$O(^(TTT)) PSNONARR=1
        .W ?102,$G(^TMP($J,"PSOSUSP",TTT)),! S:'$O(^(TTT)) PSNOSUSP=1
        .I PSNOADDR,PSNONARR,PSNOSUSP S PSNTHREE=1
        Q
