PSBRPC2 ;BIRMINGHAM/EFC-BCMA RPC BROKER CALLS ;9:31 AM  28 Mar 2010
        ;;3.0;BAR CODE MED ADMIN;**6,3,16,32,WVEHR1**;WorldVistA 30-Jan-08;Build 15
        ;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
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
        ; Reference/IA
        ; File 50/221
        ; File 52.6/436
        ; File 52.7/437
        ; File 200/10060
GETOHIST(RESULTS,DFN,PSBORD)    ;
        S RESULTS=$NAME(^TMP("PSB",$J)),PSB=0 K ^TMP("PSB",$J)
        S ^TMP("PSB",$J,0)=1,^TMP("PSB",$J,1)="-1^No History On File"
        D NOW^%DTC S PSBNOW=$P(%,".",1),PSBNOWZ=%
        D EN^PSBPOIV(DFN,PSBORD)
        S PSBUID=DFN_"V"_99999 F  S PSBUID=$O(^TMP("PSBAR",$J,PSBUID),-1) Q:PSBUID=""  D
        .S PSBUIDS=^TMP("PSBAR",$J,PSBUID)
        .I ((PSBOSTS="D")!(PSBOSTS="E")),$P(PSBUIDS,U,2)'="I",$P(PSBUIDS,U,2)'="S" Q   ; only want the infusing bag on a dc'ed order
        .I (PSBOSTS="A"),(PSBOSP<PSBNOWZ),$P(PSBUIDS,U,2)'="I",$P(PSBUIDS,U,2)'="S" S PSBOSTS="E" Q  ; only want the infusing bag on an expired order
        .I $P(PSBUIDS,U,2)'="" D  Q  ; get orders from med log (53.79)
        ..S PSBMLOR=$P(PSBUIDS,U,4),PSBIEN=$O(^PSB(53.79,"AUID",DFN,PSBMLOR,PSBUID,""))
        ..S PSBLADT=$P(^PSB(53.79,PSBIEN,0),U,6)
        ..S PSBLASTS=$P(^PSB(53.79,PSBIEN,0),U,9)
        ..I PSBLASTS="M",$P(PSBUIDS,U,8)'="" Q
        ..S PSBINJS=$P(^PSB(53.79,PSBIEN,.1),U,6)
        ..S PSB=PSB+1,^TMP("PSB",$J,PSB)=PSBORD_U_PSBUID_U_PSBIEN_U_PSBLADT_U_PSBLASTS_U_PSBINJS
        ..F PSBL=1:1 Q:'$D(^PSB(53.79,PSBIEN,.6,PSBL,0))  S PSB=PSB+1,^TMP("PSB",$J,PSB)="ADD^"_^PSB(53.79,PSBIEN,.6,PSBL,0)
        ..F PSBL=1:1 Q:'$D(^PSB(53.79,PSBIEN,.7,PSBL,0))  S PSB=PSB+1,^TMP("PSB",$J,PSB)="SOL^"_^PSB(53.79,PSBIEN,.7,PSBL,0)
        ..S PSB=PSB+1,^TMP("PSB",$J,PSB)="END"
        .I $P(PSBUIDS,U,1)="I" Q  ; IV parameters say bag is invalid
        .I $P(PSBUIDS,U,8)'="",$P(PSBUIDS,U,2)'="I",$P(PSBUIDS,U,2)'="S" Q  ; label has been reprinted/distroyed etc. - bag is not infusing or stopped
        .S PSB=PSB+1,^TMP("PSB",$J,PSB)=$P(PSBUIDS,U,5)_U_PSBUID_U_U_PSBNOW_U_"A"
        .S PSBUIDP=$P(PSBUIDS,U,10,999)
        .F Y=3:1 S PSBMEDTY=$P(PSBUIDP,U,Y) Q:PSBMEDTY=""  D
        ..D CLEAN^PSBVT,PSJ1^PSBVT(DFN,$P(PSBUIDS,U,5))
        ..I $P(PSBMEDTY,";",1)="ADD" F Z=1:1 S PSBAD=$G(PSBADA(Z)) Q:PSBAD=""  I $P(PSBADA(Z),U,2)=$P(PSBMEDTY,";",2) S PSB=PSB+1,^TMP("PSB",$J,PSB)=PSBADA(Z) Q
        ..I $P(PSBMEDTY,";",1)="SOL" F Z=1:1 S PSBSOL=$G(PSBSOLA(Z)) Q:PSBSOL=""  I $P(PSBSOLA(Z),U,2)=$P(PSBMEDTY,";",2) S PSB=PSB+1,^TMP("PSB",$J,PSB)=PSBSOLA(Z) Q
        .D CLEAN^PSBVT,PSJ1^PSBVT(DFN,PSBORD)
        .S PSB=PSB+1,^TMP("PSB",$J,PSB)="END"
        F II=1:1 S I=$P(PSBONXS,U,II) Q:I=""  D  ; get ward stocks
        .S PSBUID="" F  S PSBUID=$O(^PSB(53.79,"AUID",DFN,I,PSBUID)) Q:PSBUID=""  D
        ..I PSBUID'["WS" Q  ; not a ward stock
        ..S PSBIEN=$O(^PSB(53.79,"AUID",DFN,I,PSBUID,""))
        ..S PSBLADT=$P(^PSB(53.79,PSBIEN,0),U,6)
        ..S PSBLASTS=$P(^PSB(53.79,PSBIEN,0),U,9)
        ..I PSBOSTS="D",PSBLASTS'="I",PSBLASTS'="S" Q  ; want "not completed" on DC'ed orders
        ..I (PSBOSTS="A"),(PSBOSP<PSBNOWZ),PSBLASTS'="I",PSBLASTS'="S" Q
        ..S PSBINJS=$P(^PSB(53.79,PSBIEN,.1),U,6)
        ..S PSB=PSB+1,^TMP("PSB",$J,PSB)=PSBORD_U_PSBUID_U_PSBIEN_U_PSBLADT_U_PSBLASTS_U_PSBINJS
        ..F PSBL=1:1 Q:'$D(^PSB(53.79,PSBIEN,.6,PSBL,0))  S PSB=PSB+1,^TMP("PSB",$J,PSB)="ADD^"_^PSB(53.79,PSBIEN,.6,PSBL,0)
        ..F PSBL=1:1 Q:'$D(^PSB(53.79,PSBIEN,.7,PSBL,0))  S PSB=PSB+1,^TMP("PSB",$J,PSB)="SOL^"_^PSB(53.79,PSBIEN,.7,PSBL,0)
        ..S PSB=PSB+1,^TMP("PSB",$J,PSB)="END"
        S ^TMP("PSB",$J,0)=PSB
        K ^TMP("PSBAR",$J)
        Q
        ;
BAGDTL(RESULTS,PSBUID,PSBORD)   ; bag detail
        I $G(DFN)="" S DFN=+PSBUID
        S (PSBIEN,X)="" F  S X=$O(^PSB(53.79,"AUID",DFN,X)) Q:X=""  S:$D(^PSB(53.79,"AUID",DFN,X,PSBUID)) PSBIEN=$O(^PSB(53.79,"AUID",DFN,X,PSBUID,"")) Q:PSBIEN]""
        I PSBIEN'>0 S RESULTS(0)=1,RESULTS(1)="-1^No History On File" Q
        M PSBMLA=^PSB(53.79,PSBIEN)
        S X=$P(^PSB(53.79,PSBIEN,0),U,9)
        S PSBLAC=$S(X="I":"INFUSING",X="G":"GIVEN",X="C":"COMPLETE",X="H":"HELD",X="R":"REFUSED",X="RM":"REMOVED",X="S":"STOPPED",X="M":"MISSING",1:"NO ACTION")
        ; comments
        S PSBX="0" F  S PSBX=$O(PSBMLA(.3,PSBX)) Q:PSBX=""  S PSBTMP(10000000-$P(PSBMLA(.3,PSBX,0),U,3),"C")=$P(PSBMLA(.3,PSBX,0),U,3)_U_$$INITIAL($P(PSBMLA(.3,PSBX,0),U,2))_U_U_$P(PSBMLA(.3,PSBX,0),U,1)
        ; audit
        S PSBGA="" I $D(PSBMLA(.9,0)) D
        .S PSBX="0" F  S PSBX=$O(PSBMLA(.9,PSBX)) Q:PSBX=""  I ((PSBMLA(.9,PSBX,0)["ACTION STATUS")!(PSBMLA(.9,PSBX,0)["ADMINISTRATION STATUS")) D  Q
        ..S PSBDATE=$P(PSBMLA(0),U,4) I (PSBX-2)>0 D DT^DILF("ENPST",$P(PSBMLA(.9,PSBX-2,0),"'",2),.PSBDATE)
        ..S PSBTMP(10000000-PSBDATE,"B")=PSBDATE_U_$$INITIAL($P(PSBMLA(0),U,5))_U_$P(PSBMLA(.9,PSBX,0),"'",2)
        ..S PSBGA=1
        .S PSBX="0" F  S PSBX=$O(PSBMLA(.9,PSBX)) Q:PSBX=""  I ((PSBMLA(.9,PSBX,0)["ACTION STATUS")!(PSBMLA(.9,PSBX,0)["ADMINISTRATION STATUS"))  D
        ..S PSBTMP(10000000-$P(PSBMLA(.9,PSBX,0),U,1),"B")=$P(PSBMLA(.9,PSBX,0),U,1)_U_$$INITIAL($P(PSBMLA(.9,PSBX,0),U,2))_U_$P($P(PSBMLA(.9,PSBX,0),U,3),"'",2)
        ..S PSBGA=1
        I PSBGA'=1 S PSBTMP(10000000-$P(PSBMLA(0),U,6),"A")=$P(PSBMLA(0),U,6)_U_$$INITIAL($P(PSBMLA(0),U,7))_U_PSBLAC
        S PSBQRY="PSBTMP",PSBCNT=1 F  S PSBQRY=$Q(@PSBQRY) Q:PSBQRY=""  D  ; does comment go with action
        .;Begin WorldVistA change ;03/28/2010 ;NO HOME 1.0
        .;S PSBPQRY=$Q(@PSBQRY,-1)
        .S PSBPQRY=$$Q^VWUTIL($NA(@PSBQRY),-1)
        .;End WorldVistA change
        .I PSBPQRY="" S RESULTS(PSBCNT)=@PSBQRY,PSBCNT=PSBCNT+1 Q  ; no previous action
        .I $QS(PSBPQRY,2)="C"  S RESULTS(PSBCNT)=@PSBQRY,PSBCNT=PSBCNT+1 Q  ; previous line is a comment
        .;Begin WorldVistA change ;03/28/2010
        .;I $QS(PSBQRY,2)="C",$E($P(@$Q(@PSBQRY,-1),U,1),1,12)=$E($P(@PSBQRY,U,1),1,12),$P(@$Q(@PSBQRY,-1),U,2)=$P(@PSBQRY,U,2) S X=$P(@PSBQRY,U,4),$P(RESULTS(PSBCNT-1),U,4)=X Q
        .I $QS(PSBQRY,2)="C",$E($P(@($$Q^VWUTIL($NA(@PSBQRY),-1)),U,1),1,12)=$E($P(@PSBQRY,U,1),1,12),$P(@($$Q^VWUTIL($NA(@PSBQRY),-1)),U,2)=$P(@PSBQRY,U,2) S X=$P(@PSBQRY,U,4),$P(RESULTS(PSBCNT-1),U,4)=X Q
        .;End WorldVistA change
        .S RESULTS(PSBCNT)=@PSBQRY,PSBCNT=PSBCNT+1
        S RESULTS(0)=PSBCNT-1
        K PSBMLA,PSBIEN,PSBTMP,PSBQRY
        Q
        ;
INITIAL(PSBDUZ) ;
        Q $$GET1^DIQ(200,PSBDUZ,"INITIAL")
SCANMED(RESULTS,PSBDIEN,PSBTAB) ; Lookup Medication
        ;
        ; RPC: PSB SCANMED
        ;
        ; Description:
        ; Does a lookup on file 50 returns -1 on invalid lookup or
        ; IEN^DrugName on success
        ;
        D NOW^%DTC S PSBDT=%
        S PSBCNT=0
        I $L(PSBDIEN)>40 S PSBDIEN=$E(PSBDIEN,1,40)
        S RESULTS(PSBCNT)=1
        S PSBCNT=PSBCNT+1,RESULTS(PSBCNT)="-1^Invalid Medication Lookup"
        I $$GET^XPAR("DIV","PSB ROBOT RX"),PSBDIEN?1"3"15N!(PSBDIEN?1"3"17N),123[$E(PSBDIEN,12) S PSBDIEN=$E(PSBDIEN,2,11)
        I PSBTAB="UDTAB" D  Q
        .S X=$$FIND1^DIC(50,"","AX",PSBDIEN,"B^C")
        .I X<1 Q
        .E  S RESULTS(PSBCNT)="DD"_U_X_U_$$GET1^DIQ(50,X_",",.01)
        ;
        ; IV/IVPB ward stock scan
        ;
        S PSBDIEN=$$FIND1^DIC(50,"","AX",PSBDIEN,"B^C") I PSBDIEN<1 Q
        S PSBOIT=$$GET1^DIQ(50,PSBDIEN,"PHARMACY ORDERABLE ITEM","I")
        I $D(^PSDRUG("A527",PSBDIEN)) S X="" F  S X=$O(^PSDRUG("A527",PSBDIEN,X)) Q:X=""  D
        .S PSBINACT=$$GET1^DIQ(52.7,X,8,"I") I PSBINACT]"",PSBINACT'>PSBDT Q
        .S RESULTS(PSBCNT)="SOL"_U_X_U_$$GET1^DIQ(50,PSBDIEN_",",.01),PSBCNT=PSBCNT+1,RESULTS(0)=PSBCNT-1
        I $D(^PSDRUG("A526",PSBDIEN)) S X="" F  S X=$O(^PSDRUG("A526",PSBDIEN,X)) Q:X=""  D
        .S PSBINACT=$$GET1^DIQ(52.6,X,12,"I") I PSBINACT]"",PSBINACT'>PSBDT Q
        .S RESULTS(PSBCNT)="ADD"_U_X_U_$$GET1^DIQ(50,PSBDIEN_",",.01),PSBCNT=PSBCNT+1,RESULTS(0)=PSBCNT-1
        ;
        I PSBTAB="PBTAB",$$FIND1^DIC(50,"","AX",PSBDIEN,"B^C")'<1 S X=$$FIND1^DIC(50,"","AX",PSBDIEN,"B^C"),RESULTS(PSBCNT)="DD"_U_X_U_$$GET1^DIQ(50,X_",",.01),PSBCNT=PSBCNT+1,RESULTS(0)=PSBCNT-1
        Q
        ;
