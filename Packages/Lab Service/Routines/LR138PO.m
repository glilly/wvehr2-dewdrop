LR138PO ;DALISC/FHS - LR*5.2*138 POST INSTALL ROUTINE KIDS INSTALL
        ;;5.2;LAB SERVICE;**138**;Sep 27, 1994;Build 14
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
EN      ;Builds Laboratory OOS Locations for each LMIP valid WKLD Divison
        ;
        W !!,$$CJ^XLFSTR("Starting Post Install Process",80),!!
        L +^LAM(0):2 I $T S:$D(^LAM(0))#2 $P(^(0),U,3)=99999 L -^LAM(0)
        L +^LRO(69,"AA"):1 I '$T D  G END
        . W !?5,"Cant lock ^LRO(69,AA) GLOBAL  POST INSTALL ABORTED",!
        S X=$$ADD^XPDMENU("LR LIM/WKLD MENU","LR WKLD LOCATION")
        W !!,"Option [LR WKLD LOCATIONS] was ",$S(X:"Added",1:"NOT ADDED")," to [LR LIM/WKLD] MENU ",!!
        S X=$$ADD^XPDMENU("LR LIM/WKLD MENU","LR WKLD ACC AREA LOCATION")
        W !!,"Option [LR WKLD ACC AREA LOCATIONS] was ",$S(X:"Added",1:"NOT ADDED")," to [LR LIM/WKLD] MENU ",!!
LOC     ;
        S LRPKG=$O(^DIC(9.4,"B","LR",0))
        I 'LRPKG S LRPKG=$O(^DIC(9.4,"B","LAB SERVICE",0))
        I 'LRPKG D  G END
        .W !!,$$CJ^XLFSTR("Not able to find 'LAB SERVICE' in your Package (#9.4) file.",80),!,$$CJ^XLFSTR("Contact your IRM Service !!",80),!!,$C(7) H 5 S XPDQUIT=2
        . W !,$$CJ^XLFSTR("POST INSTALL ABORTED",80)
        W !!,$$CJ^XLFSTR("Creating Laboratory OOS Workload Locations",80),!!
SET     S LROK=""
        S LRVN=$O(^LRO(67.9,0)) I LRVN S LRDIVN=LRVN D LK I $G(LROK)>0 S ^LAB(69.9,1,.8)=LROK
        I $G(LROK)>0 S LRVN1=0 F  S LRVN1=$O(^LRO(67.9,LRVN,1,LRVN1)) Q:LRVN1<1  S LRDIVN=LRVN1 D LK
        S LRDIVN=+$$SITE^VASITE I LRDIVN D LK I $G(LROK)>0,'$G(^LAB(69.9,1,.8)) S ^(.8)=LROK
        I $G(^LAB(69.9,1,.8)) W !,$$CJ^XLFSTR("Database Upgrade Completed Successfully",80),!! D  G MSG
        . K DA,DIC,DIE S DA=+$G(^LAB(69.9,1,.8)),DIC="^SC(",DR="0:999999"
        . W !!,$$CJ^XLFSTR("DEFAULT LAB OOS LOCATION IS",80),!! D EN^DIQ W !
        W !! F I=1:1:2 D EQUALS^LRX W $C(7)
        W !,$$CJ^XLFSTR(" Database Upgrade was INCOMPLETE ",80)
        W !! F I=1:1:2 D EQUALS^LRX W $C(7)
        W !
MSG     S $P(^LAB(69.9,1,"VSIT"),U)=2
        W !,$$CJ^XLFSTR("PCE/VSIT ON (#615) field in LABORATORY SITE (#69.9) file",80)
        W !,$$CJ^XLFSTR("has been set to BOTH PCE/VSIT AND STOP CODES",80),!!
END     ;
        L -^LRO(69,"AA")
        Q:$G(LRDBUG)
        K DA,DATA,DIE,DIK,DIC,DR,LRDIV,LRDIVN,LRNAME,LROK,LRPKG,LRSCODE,LRVN
        K LRVN1,X
        Q
LK      ;
        Q:$G(LRSDCX)
        S LRDIV=$S($G(^DIC(4,LRDIVN,99)):$P(^(99),U),1:LRDIVN)
        S LRSCODE=108,LRNAME="LAB DIV "_LRDIV_" OOS ID "_LRSCODE
        D LOADB^LRCAPPH2
        Q
