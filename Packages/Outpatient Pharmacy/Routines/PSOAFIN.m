PSOAFIN ;VFA/HMS autofinish rx's from cprs ;6:57 AM  18 May 2011
        ;;7.0;OUTPATIENT PHARMACY;**208,250003**;DEC 1997;Build 54
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
        ;
        ; Please note this routine is the gateway to modified routines that autofinish pending rxs entered by a provider.  The modified routines allow rxs to be finished automatically & properly update File#100 and File#52.
        ; The routines do not autocheck orders, check for duplicates, concatenate comments to sigs etc. All of the pharmacist checks will be done by the dispensing pharmacist.
        ; $G(PSOAFYN) is tested at beginning of line to determine if the original code will run or if code modified to do AutoFinish,Rx will run
EN      I '$D(^PS(52.41,"B",+ORDERID)) Q  ;Check for pending order
        N ZTRTN,ZTDESC,ZTDTH,ZTSAVE,ZTSK,ZTIO
        S ZTRTN="EN1^PSOAFIN",ZTDESC="Autofinish,Rx",ZTDTH=$H,ZTDTH=$S(($P(ZTDTH,",",2)+10)\86400:(1+ZTDTH)_","_((($P(ZTDTH,",",2)+10)#86400)/100000),1:(+ZTDTH)_","_($P(ZTDTH,",",2)+10))
        S ZTSAVE("ORL")="",ZTSAVE("ORVP")="",ZTSAVE("VALMWD")=""
        S ZTSAVE("ORL")="",ZTSAVE("ORDERID")=""
        S ZTIO="NULL" ;WVEHR - 250003
        D ^%ZTLOAD
        Q  ;Quits back to ORWDX
        ;
EN1     ;Autofinish Task Begins Here
        ;D ^%ZTER ; For testing *ONLY*
        ;S IOP="NULL" D ^%ZIS U IO
        S PSOSITE=$G(^SC(+ORL,"AFRXSITE")) ;+ORL is hospital location from ORWDX
        Q:PSOSITE=""  ;Quits with no autofinish if File#44 does not point to File#59
        I $P($G(^PS(59,PSOSITE,"RXFIN")),"^",1)'="Y" Q  ;Quits if Autofinish not turned on in File#59 Field#459001
        ;Check patient eligibility
        S VFAELD="Y"
        I $D(^PS(59,PSOSITE,"RXFINEL",1)) S VFAELD="N",DFN=+ORVP D ELIG^VADPT D
        .S VFAEL=0
        .F L=1:1 S VFAEL=$O(^PS(59,PSOSITE,"RXFINEL",VFAEL)) Q:VFAEL=""!(VFAEL="B")!(VFAELD="Y")  D
        ..S VFAELL=$P(^PS(59,PSOSITE,"RXFINEL",VFAEL,0),"^",1)
        ..I VFAELL=+VAEL(1) S VFAELD="Y"
        Q:VFAELD="N"
        ;Check Date Verify Code Last Changed and check Verify Code never expires.
        S PSOAFYN="Y" ;Sets flag if Autofinish,Rx is turned on & is used throughout the routines
        S DIC="^VA(200,",DIC(0)="QEZ",X="AUTOFINISH,RX"
        D ^DIC K DIC
        Q:+Y=-1  ;Quits if AUTOFINISH,RX not a user
        S DA=+Y
        D DUZ^XUP(DA) ;Sets DUZ for AUTOFINISH,RX
        K PSOAFDON ;Makes sure flag for quitting patient loop through File#52.41 is null
        S PSOAFDFN=+ORVP ;From ORWDX CPRS Call is DFN of patient auto finishing rxs for
        S PSOAFPAT=$P($G(^PS(55,PSOAFDFN,"PS")),"^") ;Sets patient status if it exists
        I $G(PSOAFPAT)="" D
        .I $P($G(^PS(59,PSOSITE,"RXFIN")),"^",2)'="" D
        ..S ^PS(55,PSOAFDFN,"PS")=$P(^PS(59,PSOSITE,"RXFIN"),"^",2)
        ..S PSOAFPAT=$P(^PS(59,PSOSITE,"RXFIN"),"^",2)
        I $G(PSOAFPAT)="" D NOPATS ;Prints message if no patient status
        S PSORX("PATIENT STATUS")=PSOAFPAT ;HMS 2007_03_11
        S PSOAFPNM=$P(^DPT(PSOAFDFN,0),"^",1)
        S (PSODFN,PAT)=PSOAFDFN,PSOFINY=PSOAFDFN_"^"_PSOAFPNM
        D ^PSOORFIN ;Begins execution of Rx Finishing routines
        K PSOAFDFN,PSOAFYN,PSOAFDON,PSOAFDUZ,PSOAFPAT,PAT,PSODFN,PSOFINY,PSOSITE
        Q  ;Autofinish Task Quits Here
        ;
        ;
        ;
NOPATS  ;Quit message prints instead of prescription if no patient status
        ;Checks for nw orders in File#52.41
        ;I $G(REA)'="" Q  ;Quits if not signing a new rx
        S PSOAFORB=+ORDERID-1,PSOAFORB=$O(^PS(52.41,"B",PSOAFORB)),PSOAFOB1="",PSOAFOB1=$O(^PS(52.41,"B",PSOAFORB,PSOAFOB1)),PSOAFRXS=$P(^PS(52.41,PSOAFOB1,0),"^",3)
        I PSOAFRXS'="NW" K PSOAFORB,PSOAFOB1,PSOAFRXS Q  ;Quits if no new pending rxs in File#52.41
        K PSOAFORB,PSOAFOB1,PSOAFRXS
        I $G(PSOAFYN)="Y" S PSOLAP=$G(^SC(+ORL,"AFRXCLINPRNT")) ;vfah sets printer as defined in File#44
        I $G(PSOAFYN)="Y" I PSOLAP="" S DIRUT="^" G:$D(DIRUT)!($D(DUOUT)) EX ;vfah If DIRUT set to "^" will bypass label printing, queueing etc if no printer defined in File#44
        I $G(PSOAFYN)="Y" S PSOLAP=$P(^%ZIS(1,PSOLAP,0),"^",1) ;vhah sets PSOLAP to literal of printer name
        S PSOAFPNM=$P(^DPT(PSOAFDFN,0),"^",1)
        S PSOAFPNM=$P(^DPT(PSOAFDFN,0),"^",1)
QLBL    ;Queues no patient status notice
        D ^%ZISC
        S ZTRTN="PLBL^PSOAFIN",ZTIO=$G(PSOLAP),ZTDESC="Autofinish,Rx No Patient Status Message",ZTDTH=$H ;Sets Taskman variables
        Q:PSOLAP=""
        S ZTSAVE("*")=""
        D ^%ZTLOAD
        H 1
        D ^%ZISC
        K PSOAFDFN,PSOAFPNM
        Q
        ;
PLBL    ;Prints no patient status notice
        W !,"CAN NOT AUTO-FINISH or MANUALLY FINISH RX(S)"
        W !!,"FOR PATIENT:  ",PSOAFPNM_"  "_$E($P($G(^DPT(PSOAFDFN,0)),"^",9),4,5)_"-"_$E($P($G(^DPT(PSOAFDFN,0)),"^",9),6,9)
        W !!,"THERE IS NO PATIENT STATUS SET FOR THIS PATIENT."
        W !!,"PLEASE ENTER A PATIENT STATUS FOR THIS PATIENT"
        W !,"AND THEN SIGN RXS IN CPRS TO AUTOFINISH RXS"
        W !!,"THANK YOU"
        W !,"AUTOFINISH,RX"
        W !,$$FMTE^XLFDT($$NOW^XLFDT())
        D ^%ZISC
EX      K PSOAFDFN,PSOAFYN,PSOAFDON,PSOAFDUZ,PSOAFPNM,PSOAFPAT,PAT,PSODFN,PSOFINY,PSOSITE
        Q
        ;
DISPD   ;Selects dispense drug if not selected in CPRS
        S PSI=0
        F PSI=0:0 S PSI=$O(^PSDRUG("ASP",PSODRUG("OI"),PSI)) Q:'PSI  I $S('$D(^PSDRUG(PSI,"I")):1,'^("I"):1,DT'>^("I"):1,1:0),$S($P($G(^PSDRUG(PSI,2)),"^",3)'["O":0,1:1) D  Q:PSI>0
        .S $P(OR0,"^",9)=PSI,$P(^PS(52.41,ORD,0),"^",9)=PSI
        S VFASDD="Y"
        Q
