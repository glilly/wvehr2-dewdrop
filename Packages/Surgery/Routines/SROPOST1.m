SROPOST1        ;B'HAM ISC/ADM - MOVE SPECIALTIES INTO LOCAL FILE ;  23-APR-92  15:15
        ;;3.0; Surgery ;**5,6**;24 Jun 93;Build 13
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
        Q:'$D(^SRO(137.45,0))!($O(^SRO(137.45,0)))  W !!,"Setting up Local Surgical Specialty file... "
        F I=50:1:62,500,501,502 S SRCODE(I)=I
        S SRSS=0 F  S SRSS=$O(^DIC(45.3,SRSS)) Q:'SRSS  S SRPTF=$P(^DIC(45.3,SRSS,0),"^") D FILE
        S SRLOCAL=0 F  S SRLOCAL=$O(^SRO(137.45,SRLOCAL)) Q:'SRLOCAL  D:SRL(SRLOCAL)'="" POINT D:SRL(SRLOCAL)="" SEL
        W !!,"Set-up of Local Specialty file completed."
END     K DA,DIC,DINUM,DR,I,SRCODE,SRL,SRLOCAL,SRPTF,SRSS,X
        Q
FILE    ;
        I '$D(SRCODE(SRPTF)) S SRPTF=""
        S X=$P(^DIC(45.3,SRSS,0),"^",2) K DIC S DIC="^SRO(137.45,",DIC(0)="L",DINUM=SRSS,DLAYGO=137.45 D FILE^DICN K DIC,DLAYGO Q:'+Y  S SRL(+Y)=SRPTF
        Q
POINT   ;
        K DIC S X=SRL(SRLOCAL),DIC=45.3,DIC(0)="" D ^DIC K DIC I Y<0 S SRL(SRLOCAL)="" Q
        K DD,DO,DA,DR S DA=SRLOCAL,DR="1///"_SRL(SRLOCAL),DIE=137.45 D ^DIE K DIE
        Q
SEL     W !!,"Point Local Surgical Specialty ",$P(^SRO(137.45,SRLOCAL,0),"^"),!," to what National Surgical Specialty ?",!
        W "(Note!! If no entry is made it will be pointed automatically",!,"to the National Surgical Specialty ",$P(^DIC(45.3,1,0),"^",2),".)"
        K DD,DO,DA,DINUM S DA=SRLOCAL,DIE=137.45,DR="1T//"_$E($P(^DIC(45.3,1,0),"^",2),1,30) D ^DIE K DIE
        I '$P(^SRO(137.45,SRLOCAL,0),"^",2) K DD,DO,DA,DINUM S DA=SRLOCAL,DIE=137.45,DR="1////1" D ^DIE K DIE
        Q
AMM     ; Logic for SR*3*6 if Surgery v3 is already installed
        D WAIT^DICD K ^SRF("AMM") S SRTN=0
        ; F  S SRTN=$O(^SRF(SRTN)) Q:SRTN'>0  I $D(^SRF(SRTN,0)),$P($G(^S,5) D SET11
        F  S SRTN=$O(^SRF(SRTN)) Q:SRTN'>0  I $D(^SRF(SRTN,0)),$P($G(^SRF(SRTN,0)),"^",5) D SET11
        W !!,"Process is finished." K DA,DIK,SRSTART,SRTN
        Q
SET11   ; Convert SCHEDULE START TIME to numeric form and re-index AMM
        ; This code is pretty compromised and needs to be re-factored.
        ; S SRSTART=$P(^SRF(SRTN,31),"^",4) Q:SRSTART=""  I SRSTART'=+SRSRTN,31),"^",4)=+SRSTART
        S SRSTART=$P(^SRF(SRTN,31),"^",4) Q:SRSTART=""  I SRSTART'=+SRSTART,$P(^SRF(SRTN,31),"^",4)=+SRSTART
        Q:$P(^SRF(SRTN,0),"^",2)=""
        K DA,DIK S DIK="^SRF(",DIK(1)="11^AMM",DA=SRTN D EN1^DIK
        Q
