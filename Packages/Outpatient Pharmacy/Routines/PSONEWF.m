PSONEWF ;BIR/RTR - Copay finish questions ;1:45 PM  20 Aug 2009
        ;;7.0;OUTPATIENT PHARMACY;**71,157,143,219,226,239,225,303**;DEC 1997;Build 56;WorldVistA 30-June-08
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
        ;External reference VADPT supported by DBIA 10061
START   ;
        ;Begin WorldVistA change; PSO*7*208
        I $G(PSOAFYN)="Y" Q  ; vfam
        ;End WorldVistA change
        N PSOPENIB,PSOSCOTH,PSOSCOTX,PSOMESFI
        S PSOPENIB=$S($G(ORD):$G(^PS(52.41,+$G(ORD),"IBQ")),1:"")
        ;set PSOSCOTH for display of Provider Copay intent, used with PSORX(SC)
        S PSOSCOTH=0 I $P(PSOPENIB,"^")=1!($P(PSOPENIB,"^",2)=1)!($P(PSOPENIB,"^",3)=1)!($P(PSOPENIB,"^",4)=1)!($P(PSOPENIB,"^",5)=1)!($P(PSOPENIB,"^",6)=1)!($P(PSOPENIB,"^",7)=1) S PSOSCOTH=1
        S PSOSCOTX=0 I $G(PSOSCOTH)!($G(PSORX("SC"))="SC")!($G(PSORX("SC"))="NSC") S PSOSCOTX=1
        ;Check for Orderable Item change to display message
        S PSOMESFI=0 I $G(OR0),$G(PSODRUG("OI")) D
        .I $G(PSODRUG("OI"))'=$P($G(OR0),"^",8) S PSOMESFI=1
        S PSONEWFF=1,PSOFLAG=1
        ;Copay exemption checks
        D SCP^PSORN52D
        K PSOANSQ D SET S PSOCPZ("DFLG")=0,PSONEW("NEWCOPAY")=0
        I (PSOSCP<50)&($P($G(^PS(53,+$G(PSONEW("PATIENT STATUS")),0)),"^",7)'=1),$G(DUZ("AG"))="V" D COPAY^PSOCPB W !
        I $G(PSOCPZ("DFLG")) K PSONEW("NEWCOPAY"),PSONEWFF,PSOSCOTH,PSOSCOTX,PSOMESFI Q
        I PSOSCA&(PSOSCP>49)!((PSOSCA!(PSOBILL=2))&($P($G(^PS(53,+$G(PSONEW("PATIENT STATUS")),0)),"^",7)=1))!(PSOSCP>49&(PSOBILL=2)) D  I $G(PSOCPZ("DFLG")) K PSOANSQ,PSONEW("NEWCOPAY"),PSONEWFF,PSOSCOTH,PSOSCOTX,PSOMESFI Q
        . I PSOSCP<50 D MESS S:PSOSCP<50 PSOANSQD("SC>50")=$G(PSOANSQD("SC"))
        . D SC^PSOMLLD2
        . I PSOSCP<50&($D(PSOANSQD("SC"))) S PSOANSQD("SC")=PSOANSQD("SC>50") K PSOANSQD("SC")
        ;IF MILL BILL, AND COPAY (*******TEST THE COPAY CHECK)
        I $$DT^PSOMLLDT D  I $G(PSOCPZ("DFLG")) K PSOANSQ,PSONEW("NEWCOPAY"),PSONEWFF,PSOSCOTH,PSOSCOTX,PSOMESFI Q
        .;New prompts Quit after first '^'
        .I $D(PSOIBQS(PSODFN,"CV")) D  D MESSOI,MESS D CV^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("CV"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("CV")),($P(PSOPENIB,"^",6)=0!($P(PSOPENIB,"^",6)=1)) S PSOANSQD("CV")=$P(PSOPENIB,"^",6)
        .I $D(PSOIBQS(PSODFN,"VEH")) D  D MESSOI,MESS D VEH^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("VEH"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("VEH")),($P(PSOPENIB,"^",2)=0!($P(PSOPENIB,"^",2)=1)) S PSOANSQD("VEH")=$P(PSOPENIB,"^",2)
        .I $D(PSOIBQS(PSODFN,"RAD")) D  D MESSOI,MESS D RAD^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("RAD"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("RAD")),($P(PSOPENIB,"^",3)=0!($P(PSOPENIB,"^",3)=1)) S PSOANSQD("RAD")=$P(PSOPENIB,"^",3)
        .I $D(PSOIBQS(PSODFN,"PGW")) D  D MESSOI,MESS D PGW^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("PGW"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("PGW")),($P(PSOPENIB,"^",4)=0!($P(PSOPENIB,"^",4)=1)) S PSOANSQD("PGW")=$P(PSOPENIB,"^",4)
        .I $D(PSOIBQS(PSODFN,"SHAD")) D  D MESSOI,MESS D SHAD^PSOMLLD2 I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("SHAD"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("SHAD")),($P(PSOPENIB,"^",7)=0!($P(PSOPENIB,"^",7)=1)) S PSOANSQD("SHAD")=$P(PSOPENIB,"^",7)
        .I $D(PSOIBQS(PSODFN,"MST")) D  D MESSOI,MESS D MST^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("MST"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("MST")),($P(PSOPENIB,"^")=0!($P(PSOPENIB,"^")=1)) S PSOANSQD("MST")=$P(PSOPENIB,"^")
        .I $D(PSOIBQS(PSODFN,"HNC")) D  D MESSOI,MESS D HNC^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("HNC"))) K PSONEW("NEWCOPAY")
        ..I '$D(PSOANSQD("HNC")),($P(PSOPENIB,"^",5)=0!($P(PSOPENIB,"^",5)=1)) S PSOANSQD("HNC")=$P(PSOPENIB,"^",5)
        K PSONEWFF,PSOSCOTH,PSOSCOTX,PSOMESFI,PSOSCA
        Q
SET     ;Set original answers that were passed from CPRS
        Q:'$G(ORD)
        Q:'$G(PSOFDR)
        I $P($G(^PS(52.41,ORD,0)),"^",16)="SC"!($P($G(^(0)),"^",16)="NSC") D
        . I PSOSCP<50 S PSOANSQ("SC")=$S($P($G(^(0)),"^",16)="SC":1,1:0),PSOANSQD("SC")=PSOANSQ("SC") S:PSOANSQ("SC")'="" PSOIBQS(PSODFN,"SC")=PSOANSQ("SC")
        . I PSOSCP>49 S PSOANSQ("SC>50")=$S($P($G(^(0)),"^",16)="SC":1,1:0),PSOANSQD("SC>50")=PSOANSQ("SC>50") S:PSOANSQ("SC>50")'="" PSOIBQS(PSODFN,"SC>50")=PSOANSQ("SC>50")
        I $G(PSOPENIB)="" G SET2
        I '$$DT^PSOMLLDT Q
        I $P(PSOPENIB,"^")=0!($P(PSOPENIB,"^")=1) S PSOANSQ("MST")=$P(PSOPENIB,"^")
        I $P(PSOPENIB,"^",2)=0!($P(PSOPENIB,"^",2)=1) S PSOANSQ("VEH")=$P(PSOPENIB,"^",2)
        I $P(PSOPENIB,"^",3)=0!($P(PSOPENIB,"^",3)=1) S PSOANSQ("RAD")=$P(PSOPENIB,"^",3)
        I $P(PSOPENIB,"^",4)=0!($P(PSOPENIB,"^",4)=1) S PSOANSQ("PGW")=$P(PSOPENIB,"^",4)
        I $P(PSOPENIB,"^",5)=0!($P(PSOPENIB,"^",5)=1) S PSOANSQ("HNC")=$P(PSOPENIB,"^",5)
        I $P(PSOPENIB,"^",6)=0!($P(PSOPENIB,"^",6)=1) S PSOANSQ("CV")=$P(PSOPENIB,"^",6)
        I $P(PSOPENIB,"^",7)=0!($P(PSOPENIB,"^",7)=1) S PSOANSQ("SHAD")=$P(PSOPENIB,"^",7)
        ;
SET2    ;for when patient status is exempt, null IBQ node was set for exempts or SC>50 - data is in ICD node
        N PSOOICD
        I $TR($G(^PS(52.41,+$G(ORD),"IBQ")),"^")="" S PSOOICD=$G(^PS(52.41,ORD,"ICD",1,0)) D SET3:PSOOICD'=""
        ;
ICD1    ;
        N PSONOCHG S PSONOCHG=0
        I ('$D(PSORXED("ICD"))) S PSONOCHG=1
        I $D(^PS(52.41,ORD,"ICD",0)) D
        . N JJ,ICD,II,FLD,RXN S RXN=ORD
        . S II=0 F  S II=$O(^PS(52.41,ORD,"ICD",II)) Q:II=""!(II'?1N.N)  D
        .. S ICD=^PS(52.41,ORD,"ICD",II,0),FLD=$P(ICD,U) S:$G(PSONEW("IDFLG")) FLD=""  D ICD
        Q
        ;
SET3    ; called from PSONEWF and PSONEWG; must have PSOOICD.  For SC>50, exempt patient status, etc.
        N JJJ
        F JJJ=2:1:9 I $P(PSOOICD,"^",JJJ)=0!($P(PSOOICD,"^",JJJ)=1) D
        . I JJJ=2 S (PSOANSQD("VEH"),PSOANSQ("VEH"))=$P(PSOOICD,"^",JJJ)
        . I JJJ=3 S (PSOANSQD("RAD"),PSOANSQ("RAD"))=$P(PSOOICD,"^",JJJ)
        . I JJJ=4 D
        .. S:PSOSCP<50 (PSOANSQD("SC"),PSOANSQ("SC"))=$P(PSOOICD,"^",JJJ)
        .. S:PSOSCP>49!($P($G(^PS(53,+$G(PSONEW("PATIENT STATUS")),0)),"^",7)=1) (PSOANSQD("SC>50"),PSOANSQ("SC>50"))=$P(PSOOICD,"^",JJJ)
        . I JJJ=5 S (PSOANSQD("PGW"),PSOANSQ("PGW"))=$P(PSOOICD,"^",JJJ)
        . I JJJ=6 S (PSOANSQD("MST"),PSOANSQ("MST"))=$P(PSOOICD,"^",JJJ)
        . I JJJ=7 S (PSOANSQD("HNC"),PSOANSQ("HNC"))=$P(PSOOICD,"^",JJJ)
        . I JJJ=8 S (PSOANSQD("CV"),PSOANSQ("CV"))=$P(PSOOICD,"^",JJJ)
        . I JJJ=9 S (PSOANSQD("SHAD"),PSOANSQ("SHAD"))=$P(PSOOICD,"^",JJJ)
        K PSOOICD
        Q
MESS    ;
        I $G(PSOSCOTX)=1&(PSOSCP<50) W:$G(PSODRUG("DEA"))'["S"&($G(PSODRUG("DEA"))'["I")&($G(PSODRUG("DEA"))'["N") !,"This Rx has been flagged by the provider as: "_$S($G(PSOSCOTH):"NO COPAY",$G(PSORX("SC"))="SC":"NO COPAY",1:"COPAY"),! S PSOSCOTX=2
        Q
MESSOI  ;
        I $G(PSOMESFI)=1 W !!,"The Pharmacy Orderable Item has changed for this order. Please review any",!,"existing SC or Environmental Indicator defaults carefully for appropriateness.",! S PSOMESFI=2
        Q
        ;
ICD     ;called from PSONEWG,PSORENW1 and used by PSONEWF
        I $G(PSOCOPY)&($D(PSORXED("ICD")))&($D(PSONEW("IDFLG"))) Q:'$D(PSORXED("ICD",II))
        I $G(PSOCOPY)&($D(PSORXED("ICD",II))) S PSONEW("ICD",II)=PSORXED("ICD",II) Q
        Q:'$G(PSOCOPY)&('$D(PSORXED("ICD",II)))&('$G(PSONOCHG))  ;don't set deleted ones
        Q:$G(PSONEW("IDFLG"))
        I $D(PSORX("ICD",II)) S PSONEW("ICD",II)=PSORX("ICD",II) Q
        S PSONEW("ICD",II)=FLD
        Q
        ;
