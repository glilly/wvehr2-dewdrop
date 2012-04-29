PXXDPT  ;ISL/DLT - Synchronize Patient File (2) and IHS Patient File (#9000001) ;6:04 AM  25 Apr 2010
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**1**;Aug 12, 1996;Build 13
        ;;1.0;PCE Patient/IHS Subset;;Nov 01, 1994
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
        ;
SETSSN  ; Entry Point from PX09 cross-reference on File 2, field .09
        ;to define patient entry in 9000001.
        D CHECK Q:'$T
EN      Q:PX=""  N DFN,PXXLOC S DFN=+DA N DA,X
        I '$D(^AUPNPAT(DFN,0)) L +^AUPNPAT(0) S $P(^AUPNPAT(0),U,3)=DFN,$P(^AUPNPAT(0),U,4)=$P(^AUPNPAT(0),U,4)+1 L -^AUPNPAT(0)
        S $P(^AUPNPAT(DFN,0),U,1)=DFN
        I '$D(^AUPNPAT(DFN,41,0)) S ^AUPNPAT(DFN,41,0)="^9000001.41P^^"
        S PXXLOC=$P($G(^PX(815,1,"PXPT")),"^",1) Q:'+PXXLOC
        I '$D(^AUPNPAT(DFN,41,PXXLOC,0)) L +^AUPNPAT(DFN,41,0) S $P(^AUPNPAT(DFN,41,0),U,3)=PXXLOC,$P(^AUPNPAT(DFN,41,0),U,4)=$P(^AUPNPAT(DFN,41,0),U,4)+1 L -^AUPNPAT(DFN,41,0)
        S ^AUPNPAT(DFN,41,PXXLOC,0)=PXXLOC_U_PX
        S (DA,X)=DFN X ^DD(9000001,.01,1,1,1) ;code is S ^AUPNPAT("B",$E(X,1,30),DA)=""
        S X=PX,DA(1)=DFN,DA=PXXLOC X ^DD(9000001.41,.02,1,1,1) ;code is S ^AUPNPAT("D",$E(X,1,30),DA(1),DA)=""
        Q
        ;
KILLSSN ;Entry point from PX09 cross-reference on File 2, field .09 to kill SSN
        ;information from 9000001.
        D CHECK Q:'$T
        N DFN S DFN=+DA N DA,X
        S X=PX,DA(1)=DFN,DA=$P($G(^PX(815,1,"PXPT")),"^",1) Q:'+DA  X ^DD(9000001.41,.02,1,1,2)
        Q
        ;
CHECK   ;Check for appropriate variables and globals defined before proceeding
        ;Begin WorldVista Change ;04/24/2010 ;NO HOME 1.0
        ;was I $D(^AUPNPAT),$G(DA),$D(^DPT(DA))
        I $D(^AUPNPAT),$G(DA),$D(^DPT(DA)),$P($G(^DG(43,1,"VW"),0),U)
        ; (Field #250000) VW AUTOFILL HRN WITH SSN [1S] ^
        ;End WorldVista Change
        Q
LOAD    ;Logic to use during install to initially load ^AUPNPAT(
        S PXFG=0
        S DA=+$P($G(^PX(815,1,"PXPT")),"^",2)
        F  S DA=$O(^DPT(DA)) Q:'DA  Q:PXFG=1  S PX=$P($G(^DPT(DA,0)),"^",9) D SETSSN D
        .S $P(^PX(815,1,"PXPT"),"^",2)=DA
        .I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1,PXFG=1
        I PXFG'=1 S $P(^PX(815,1,"PXPT"),"^",2)=0
        K DR,DIE,DA,PXDA,PXFG
        Q
