PSONEW  ;BIR/SAB-new rx order main driver ;10:44 AM  3 Aug 2009
        ;;7.0;OUTPATIENT PHARMACY;**11,27,32,46,94,130,268,225,208**;DEC 1997;Build 64;WorldVistA 30-June-08
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
        ;External references L and UL^PSSLOCK supported by DBIA 2789
        ;External reference to ^VA(200 supported by DBIA 224
        ;External reference to ^XUSEC supported by DBIA 10076
        ;External reference to ^ORX1 supported by DBIA 2186
        ;External reference to ^ORX2 supported by DBIA 867
        ;External reference to ^TIUEDIT supported by DBIA 2410
        ;---------------------------------------------------------------
OERR    ;backdoor new rx for v7
        K PSOREEDT,COPY,SPEED,PSOEDIT,DUR,DRET
        S PSOPLCK=$$L^PSSLOCK(PSODFN,0) I '$G(PSOPLCK) D LOCK^PSOORCPY S VALMSG=$S($P($G(PSOPLCK),"^",2)'="":$P($G(PSOPLCK),"^",2)_" is working on this patient.",1:"Another person is entering orders for this patient.") K PSOPLCK S VALMBCK="" Q
        K PSOPLCK S X=PSODFN_";DPT(" D LK^ORX2 I 'Y S VALMSG="Another person is entering orders for this patient.",VALMBCK="" D UL^PSSLOCK(PSODFN) Q
AGAIN   N VALMCNT K PSODRUG,PSOCOU,PSOCOUU,PSONOOR,PSORX("FN") W ! D HLDHDR^PSOLMUTL S (PSONEW("QFLG"),PSONEW("DFLG"))=0,PSOFROM="NEW",PSONOEDT=1
        K ORD D FULL^VALM1,^PSONEW1 ; Continue order entry
        I PSONEW("QFLG") G END
        I PSONEW("DFLG") W !,$C(7),"RX DELETED",! S:$G(POERR) POERR("DFLG")=1,VALMBCK="Q" G END
        D:$P($G(PSOPAR),"^",7)=1 AUTO^PSONRXN I $P($G(PSOPAR),"^",7)'=1 S PSOX=PSONEW("RX #") D CHECK^PSONRXN
        I PSONEW("DFLG")!PSONEW("QFLG") D DEL S:$G(POERR) POERR("DFLG")=1,VALMBCK="R" G END
        D NOOR I PSONEW("DFLG") D DEL G END
        D ^PSONEW2 I PSONEW("DFLG") D DEL S:$G(POERR) POERR("DFLG")=1,VALMBCK="R" G END ; Asks if correct
        G:$G(PSORX("FN")) END
        D EN^PSON52(.PSONEW) ; Files entry in File 52
        D NPSOSD^PSOUTIL(.PSONEW) ; Adds newly added rx to PSOSD array
        S VALMBCK="R"
END     D EOJ ; Clean up
        I '$G(PSORX("FN")) W ! K DIR,DIRUT,DUOUT,DTOUT S DIR(0)="Y",DIR("B")="YES",DIR("A")="Another New Order for "_PSORX("NAME") D ^DIR K DIR,DIRUT,DUOUT,DTOUT I Y K PSONEW,PSDRUG,ORD G AGAIN
        D ^PSOBUILD,BLD^PSOORUT1 S X=PSODFN_";DPT(" D ULK^ORX2 D UL^PSSLOCK(PSODFN)
        D RV^PSOORFL
        S VALMBCK="R" K PSORX("FN") Q
        ;----------------------------------------------------------------
DEL     ;
        W !,$C(7),"RX DELETED",!
        I $P($G(PSOPAR),"^",7)=1 D
        . S DIE="^PS(59,",DA=PSOSITE,PSOY=$O(PSONEW("OLD LAST RX#",""))
        . S PSOX=PSONEW("OLD LAST RX#",PSOY)
        . L +^PS(59,+PSOSITE,PSOY):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3)
        . S DR=$S(PSOY=8:"2003////"_PSOX,PSOY=3:"1002.1////"_PSOX,1:"2003////"_PSOX)
        . D:PSOX<$P(^PS(59,+PSOSITE,PSOY),"^",3) ^DIE K DIE,X,Y
        . L -^PS(59,+PSOSITE,PSOY)
        . K PSOX,PSOY Q
EOJ     ;
        I $D(PSONEW("RX #")) L -^PSRX("B",PSONEW("RX #")) ; +Lock set in PSONRXN
        K PSONOEDT,PSONEW,PSODRUG,ANQDATA,LSI,C,MAX,MIN,NDF,REF,SIG,SER,PSOFLAG,PSOHI,PSOLO,PSONOOR,PSOCOUU,PSOCOU,PSORX("EDIT")
        D CLEAN^PSOVER1
        K ^TMP("PSORXDC",$J),RORD,ACOM,ACNT,CRIT,DEF,F1,GG,I1,IEN,INDT,LAST,MSG,NIEN,STA,DUR,DRET,PSOPRC
        S RXN=$O(^TMP("PSORXN",$J,0)) I RXN D
        .S RXN1=^TMP("PSORXN",$J,RXN) D EN^PSOHLSN1(RXN,$P(RXN1,"^"),$P(RXN1,"^",2),"",$P(RXN1,"^",3))
        .I $P(^PSRX(RXN,"STA"),"^")=5 D EN^PSOHLSN1(RXN,"SC","ZS","")
        K RXN,RXN1,^TMP("PSORXN",$J)
        I $G(PSONOTE) D FULL^VALM1,MAIN^TIUEDIT(3,.TIUDA,PSODFN,"","","","",1)
        K PSONOTE
        Q
NOOR    ;asks nature of order
        N PSONOODF
        S PSONOODF=0
        I $G(OR0) D  G NOORX ;front door
        .S PSOI=$S($G(PSOSIGFL):1,$G(PSODRUG("OI"))'=$P(OR0,"^",8):1,1:0) I 'PSOI S PSONOOR="" D:$D(^XUSEC("PSORPH",DUZ)) COUN Q  ;NoO $P(OR0,"^",7)
        .S PSONOODF=1
        .D DIR I $D(DIRUT) S PSONEW("DFLG")=1 Q
        .S PSONOOR=Y D:$D(^XUSEC("PSORPH",DUZ)) COUN K DIR,DTOUT,DTOUT,DIRUT
        ;backdoor order
        D DIR I $D(DIRUT) S PSONEW("DFLG")=1 Q
        S PSONOOR=Y K DIK,DA,DIE,DR,PSOI,DIR,DUOUT,DTOUT,DIRUT
        G:'$D(^XUSEC("PSORPH",DUZ)) NOORX
COUN    ;patient counseling
        G:$G(PSORX("EDIT"))&('$G(PSOSIGFL)) NOORX K DIR,DUOUT,DTOUT,DIRUT
        ;Begin WorldVistA change; PSO*7*208 ;08/02/2009
        I $G(PSOAFYN)'="Y" S DIR("B")="NO",DIR(0)="52,41" D ^DIR S PSOCOU=$S(Y:Y,1:0)
        I $G(PSOAFYN)="Y" S PSOCOU=0 ;vfam No Patient Counseling by AutoFinih
        ;End WorldVistA change
        I $D(DIRUT)!('PSOCOU) S PSOCOUU=0 D:'$G(SPEED) PRONTE Q
        K:'$G(PSOCOU) PSOCOUU K DIR,DUOUT,DTOUT,DIRUT I Y S DIR(0)="52,42",DIR("B")="NO" D ^DIR S PSOCOUU=$S(Y:Y,1:0)
PRONTE  K PSONOTE,DIR,DIRUT,DUOUT
        I $T(MAIN^TIUEDIT)]"",'$G(SPEED) D  K DIR,DIRUT,DUOUT
        .;Begin WorldVistA change;  PSO*7*208 ;08/02/2009
        .I $G(PSOAFYN)'="Y" S DIR(0)="Y",DIR("B")="No",DIR("A")="Do you want to enter a Progress Note",DIR("A",1)="" D ^DIR K DIR
        .I $G(PSOAFYN)="Y" S Y="0" ;vfam No Progress Notes in AutoFinish
        .;End WorldVistA change
        .S PSONOTE=+Y Q  ;I 'Y!($D(DIRUT)) Q
NOORX   K X,Y,DIR,DUOUT,DTOUT,DIRUT
        Q
DIR     ;ask nature of order
        K DIR,DTOUT,DTOUT,DIRUT I $T(NA^ORX1)]""  D  Q
        .S PSONOOR=$$NA^ORX1($S($G(PSONOODF)!($G(PSONOBCK)):"S",1:"W"),0,"B","Nature of Order",0,"WPSDIVR"_$S(+$G(^VA(200,DUZ,"PS")):"E",1:""))
        .I +PSONOOR S (Y,PSONOOR)=$P(PSONOOR,"^",3) Q
        .S DIRUT=1 K PSONOOR
        I $D(PSONOOR) S DF=PSONOOR,PSONODF=$S(DF="E":"PROVIDER ENTERED",DF="V":"VERBAL",DF="P":"TELEPHONE",DF="D":"DUPLICATE",DF="S":"SERVICE CORRECTED",DF="I":"POLICY",DF="R":"SERVICE REJECTED",1:"WRITTEN")
        K DIR,DTOUT,DTOUT,DIRUT S DIR("A")="Nature of Order: ",DIR("B")=$S($D(PSONOOR):PSONODF,1:"WRITTEN")
        S DIR(0)="SA^W:WRITTEN;V:VERBAL;P:TELEPHONE;S:SERVICE CORRECTED;D:DUPLICATE;I:POLICY;R:SERVICE REJECTED"_$S(+$G(^VA(200,DUZ,"PS")):";E:PROVIDER ENTERED",1:"")
        D ^DIR K DF,PSONODF Q:$D(DIRUT)  S PSONOOR=Y
DIRX    Q
        ;
NOORE(PSONEW)   ;entry point for renew
        D NOOR I $D(DIRUT) S PSONEW("DFLG")=1 Q
        S PSONEW("NOO")=PSONOOR
        Q
