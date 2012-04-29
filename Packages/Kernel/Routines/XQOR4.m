XQOR4   ; SLC/KCM - Process "^^" jump ;1/23/07  15:36
        ;;8.0;KERNEL;**56,62,437**;Jul 10, 1995;Build 23
        ; Modified from FOIA VISTA,
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
DJMP    ;From: STAK^XQOR1
        Q:'$D(^TMP("XQORS",$J,XQORS,"ITM",^TMP("XQORS",$J,XQORS,"ITM"),"IN"))
        I $D(VALMCC) N XQORLMGR S XQORLMGR="" D FULL^VALM1 ; List Mgr Running?
        S X=^TMP("XQORS",$J,XQORS,"ITM",^TMP("XQORS",$J,XQORS,"ITM"),"IN")
        I '$L($P(X,"^",3)) W !!,"For entry ""^^",$P(X,"^",4),""" -"
        S X=$P(X,"^",4,99) D EAT^XQORM1 ;Q:$E(X,1,2)'="^^"
        S X=$P(X,"=",1),D="K.ORWARD",DIC="^ORD(101,",DIC(0)="SE" D IX^DIC K DIC,D
        I Y<0!('$D(^ORD(101,+Y,0))) W:(X'["^")&(X'["?") !!,">>>  ",X," not found or selected.  No action taken." D:(X'["^")&(X'["?") READ S X="" G DJMPX
        S ORNSV=+Y
        K X F I=1:1:XQORS I $P(^TMP("XQORS",$J,XQORS,"VPT"),";",2)="ORD(101,",$D(^ORD(101,+^TMP("XQORS",$J,XQORS,"VPT"),21)) D DJMP1
        S X="" F I=0:0 S X=$O(X(X)) Q:X=""  N @X
        S X=ORNSV_";ORD(101," K ORNSV
        D EN^XQOR
DJMPX   I $D(XQORLMGR) S VALMBCK="R"                       ; Refresh List Mgr
        Q
DJMP1   F J=0:0 S J=$O(^ORD(101,+^TMP("XQORS",$J,XQORS,"VPT"),21,J)) Q:J'>0  I $D(^ORD(101,+^TMP("XQORS",$J,XQORS,"VPT"),21,J,0)) S X=^(0) I X?1A.ANP!(X?1"%".ANP) S X(X)=""
        Q
SHDR    ;Display sub-header
        Q:'$D(@(^TMP("XQORS",$J,XQORS,"REF")_"0)"))  S X=$P(^(0),"^",2) W:X'?1." " !!?(36-($L(X)\2)),"--- "_X_" ---"
        Q
        ;VWSD LOCAL MOD STARTED HERE, XQ SILENT MODE . VARIABLE XQORMUTE
READ    I '$D(XQORMUTE) W !,"Press RETURN to continue: " R X:$S($D(DTIME):DTIME,1:300)
        ;READ W !,"Press RETURN to continue: " R X:$S($D(DTIME):DTIME,1:300)
        ;END LOCAL MOD
        Q
C19     N X0 S X0=@(^TMP("XQORS",$J,XQORS,"REF")_"0)"),X=$P(X0,"^",6) I $L(X),'$D(^XUSEC(X,DUZ)) W !!,"This option "_$P(X0,"^")_" is locked.",! D READ S Y=-1 Q
        S ORNSV=$P(X0,"^",9),X="NOW",%DT="T" D ^%DT S X=$P(Y,".",2) I X>$P(ORNSV,"-"),X<$P(ORNSV,"-",2) W !!,"Not Available: ",ORNSV,! K ORNSV D READ S Y=-1 Q
        K ORNSV I "QMOXALDT"'[$P(^TMP("XQORS",$J,XQORS,"FLG"),"^") W !!,"This option type not supported by 'unwinder' routines.",! D READ S Y=-1 Q
        S Y=1 Q
