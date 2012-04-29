XQOR    ; SLC/KCM - Prepare to Unwind Options ;4/3/07  16:21
        ;;8.0;KERNEL;**48,56,437**;Jul 10, 1995;Build 23
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
        S DIC=19,DIC(0)="AEMQ" D ^DIC K DIC Q:Y<0  S X=+Y_";DIC(19,"
EN      ;Process options/protocols from top
        ;From: Anywhere  Entry: X,{DIC,XQORFLG}  Exit: none
        Q:$D(X)[0  K XQORPOP,XQORQUIT
        I '$D(XQORS) S XQORS=0 K ^TMP("XQORS",$J)
        S XQORS=XQORS+1 ;push
        I $D(XQOR("HIJACK")) S X=XQOR("HIJACK"),DIC=101 K XQOR("HIJACK")
        I X?1.N1";ORD(101,"!(X?1.N1";DIC(19,") S ^TMP("XQORS",$J,XQORS,"REF")="^"_$P(X,";",2)_+X_",",^TMP("XQORS",$J,XQORS,"VPT")=X
        E  S:$D(DIC)[0 DIC=19 S DIC(0)="N" D ^DIC S:Y>0 ^TMP("XQORS",$J,XQORS,"REF")=DIC_+Y_",",^TMP("XQORS",$J,XQORS,"VPT")=+Y_";"_$P(DIC,"^",2) K DIC G:Y<0 EX
        S XQORNEST(XQORS)=^TMP("XQORS",$J,XQORS,"VPT"),XQORNEST=XQORS
        G:'$D(@(^TMP("XQORS",$J,XQORS,"REF")_"0)")) EX S ^TMP("XQORS",$J,XQORS,"FLG")=$P(^(0),"^",4)_"^^" G:$P(^TMP("XQORS",$J,XQORS,"FLG"),"^")'?1A EX
        ; LOCAL MOD VWSD SILENTMODE ECHO SDAM EVENTS (VARIABLE XQORMUTE)
        I $L($P(@(^TMP("XQORS",$J,XQORS,"REF")_"0)"),"^",3)) W:'$D(ZTSK)&'$D(XQORMUTE) !!,$P(^(0),"^",3),! D:'$D(ZTSK)&'$D(XQORMUTE) READ^XQOR4 G EX
        ;I $L($P(@(^TMP("XQORS",$J,XQORS,"REF")_"0)"),"^",3)) W !!,$P(^(0),"^",3),! D READ^XQOR4 G EX
        ;END LOCAL MODE
        D C19^XQOR4 G:Y<0 EX
        S ^TMP("XQORS",$J,0,"FILE")=";"_$P(^TMP("XQORS",$J,XQORS,"VPT"),";",2),^TMP("XQORS",$J,XQORS,"INP")=""
        I XQORS>1,$D(^TMP("XQORS",$J,XQORS-1,"ITM")),$D(^TMP("XQORS",$J,XQORS-1,"ITM",^TMP("XQORS",$J,XQORS-1,"ITM"),"IN")) S ^TMP("XQORS",$J,XQORS,"INP")=^TMP("XQORS",$J,XQORS-1,"ITM",^TMP("XQORS",$J,XQORS-1,"ITM"),"IN")
        I XQORS>1,$D(XQORFLG("PI")) K XQORFLG("PI") S ^TMP("XQORS",$J,XQORS,"INP")=^TMP("XQORS",$J,XQORS-1,"INP")
        S XQORNOD=^TMP("XQORS",$J,XQORS,"VPT"),XQORNOD(0)=^TMP("XQORS",$J,XQORS,"INP")
        I XQORS>1,$D(^TMP("XQORS",$J,XQORS-1,"FLG")) S X=^TMP("XQORS",$J,XQORS-1,"FLG"),$P(^TMP("XQORS",$J,XQORS,"FLG"),"^",3)=$S($L($P(X,"^",5)):$P(X,"^",5),1:$P(X,"^",3))
        I ^TMP("XQORS",$J,0,"FILE")=";ORD(101,",$D(@(^TMP("XQORS",$J,XQORS,"REF")_"4)")) S:$P(^(4),"^",3)="Y" $P(^TMP("XQORS",$J,XQORS,"FLG"),"^",2)=1
        I ^TMP("XQORS",$J,0,"FILE")=";DIC(19,",$P(^TMP("XQORS",$J,XQORS,"FLG"),"^")="M" S $P(^TMP("XQORS",$J,XQORS,"FLG"),"^",2)=1
        I $D(XQORFLG) S:$D(XQORFLG("PS")) $P(^TMP("XQORS",$J,XQORS,"FLG"),"^",2)=+XQORFLG("PS") S:$D(XQORFLG("SH")) $P(^TMP("XQORS",$J,XQORS,"FLG"),"^",3)=+XQORFLG("SH") K XQORFLG
        I $D(ORITMO) S $P(^TMP("XQORS",$J,XQORS,"FLG"),"^",6)=1 K ORITMO G REDO^XQOR1
        I $P(^TMP("XQORS",$J,XQORS,"FLG"),"^")="D" N XQORDLG
        G LOOP^XQOR1
EX      K XQORNEST(XQORS),XQORFLG,XQORNOD,XQORY,^TMP("XQORS",$J,XQORS) S XQORS=XQORS-1,XQORNEST=XQORS ;pop
        I XQORS=0 K XQORNEST,XQORS,^TMP("XQORS",$J),XQORSPEW
        Q
EN1     ;Process items on option/protocol only (i.e., skip initial actions)
        ;From: Anywhere  Entry: X,DIC  Exit: none
        S ORITMO=1 G EN
        Q
XQ      ;From: Menuman  Entry: XQOR  Exit: XQOR
        S X=+XQOR_";DIC(19," I $D(^DD(19,0,"VR")),^("VR")<5.9 G EN
        G EN1
MSG(X,XQORMSG)  ;Event point for HL7 messages
        N DIC S DIC=101
        I '$D(XQORHSTK) N XQORHSTK S XQORHSTK=-1 K ^TMP("XQORHSTK",$J)
        S XQORHSTK=XQORHSTK+1
        K ^TMP("XQORHSTK",$J,XQORHSTK) M ^TMP("XQORHSTK",$J,XQORHSTK)=XQORMSG
        D EN^XQOR
        S XQORHSTK=XQORHSTK-1
        I XQORHSTK>-1 K XQORMSG M XQORMSG=^TMP("XQORHSTK",$J,XQORHSTK)
        I XQORHSTK=-1 K ^TMP("XQORHSTK",$J)
        Q
