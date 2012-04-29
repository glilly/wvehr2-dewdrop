PSBOMH1 ;BIRMINGHAM/EFC-MAH ;9:22 AM  28 Mar 2010
        ;;3.0;BAR CODE MED ADMIN;**6,3,9,11,26,38,VWEHR1**;WorldVistA 30-Jan-08;Build 13
        ;Per VHA Directive 2004-038, this routine should not be modified.
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
        ; ^DILF/2054
        ; File 200/10060
        ;
EN      ;
        ; Load administrations
        S (PSBORD,PSBIEN,PSBR1,PSBADIEN,PSBABR)="",PSBDT=PSBSTRT
        K PSBTSA
        F  S PSBDT=$O(^PSB(53.79,"AADT",DFN,PSBDT)) Q:'PSBDT!(PSBDT>PSBSTOP)  D
        .F  S PSBIEN=$O(^PSB(53.79,"AADT",DFN,PSBDT,PSBIEN)) Q:'PSBIEN  Q:'$D(^PSB(53.79,PSBIEN))  L +^PSB(53.79,PSBIEN):3 I $P(^PSB(53.79,PSBIEN,0),U,9)]"" D  L -^PSB(53.79,PSBIEN)
        ..Q:'$P($G(^PSB(53.79,PSBIEN,0)),U,6)  ; Bad IEN -no evnt dt
        ..Q:$P(^PSB(53.79,PSBIEN,0),U,9)="N"  ;NGiven
        ..S PSBORD=$P($G(^PSB(53.79,PSBIEN,.1)),U,1)
        ..; Continuous
        ..D:$P($G(^PSB(53.79,PSBIEN,.1)),U,2)="C"
        ...S X=PSBDT D H^%DTC S PSBWEEK=PSBAR(%H) D CLEAN^PSBVT,PSJ1^PSBVT($P(^PSB(53.79,PSBIEN,0),U,1),$P(^PSB(53.79,PSBIEN,.1),U,1))
        ...I $P(^PSB(53.79,PSBIEN,0),U,6)'=PSBDT,'$$IVPTAB^PSBVDLU3(PSBOTYP,PSBIVT,PSBISYR,PSBCHEMT,PSBIVPSH) D  D CLEAN^PSBVT Q  ;chck IV audit
        ....S PSBSIEN=PSBIEN
        ....I $P(^PSB(53.79,PSBIEN,0),"^",10)]"" D BAGDTL^PSBRPC2(.PSBAUD,$P(^PSB(53.79,PSBIEN,0),U,10),$P(^PSB(53.79,PSBIEN,.1),U,1))
        ....S PSBIEN=PSBSIEN K PSBSIEN
        ....S X=0 F  S X=$O(PSBAUD(X)) Q:X=""  I $P(PSBAUD(X),U,3)="" K PSBAUD(X)
        ....S X=0 F  S X=$O(PSBAUD(X)) Q:X=""  Q:$P(PSBAUD(X),U,1)=PSBDT
        ....I X="" K PSBAUD Q
        ....I '$D(PSBAUD(X)) K PSBAUD Q
        ....S PSBS=$P(PSBAUD(X),U,3)
        ....I PSBS="GIVEN",$P($G(PSBAUD(X-1)),U,3)="NOT GIVEN" Q
        ....I PSBS="NOT GIVEN" Q
        ....S PSBS=$S(PSBS="INFUSING":"I",PSBS="GIVEN":"G",PSBS="COMPLETED":"C",PSBS="HELD":"H",PSBS="REFUSED":"R",PSBS="REMOVED":"RM",PSBS="STOPPED":"S",PSBS["MISSING":"M",1:"NOACTION")
        ....D PSBSTIV^PSBOMH2
        ....S X=PSBDT_U_$P(PSBAUD(X),U,2)_U_PSBS_U_PSBIEN
        ....S Y=$O(^TMP("PSB",$J,PSBWEEK,PSBORD,PSBDT\1,""),-1)+1
        ....S ^TMP("PSB",$J,PSBWEEK,PSBORD,PSBDT\1,Y)=X
        ....S ^TMP("PSB",$J,PSBWEEK,PSBORD,PSBDT\1,0)=Y
        ....D PSBOUT($P((X),"^",1),$P((X),"^",2))
        ....K PSBAUD
        ...S PSBINIT=$$GET1^DIQ(53.79,PSBIEN_",","ACTION BY:INITIAL")
        ...S PSBNAME=$$GET1^DIQ(53.79,PSBIEN_",","ACTION BY:NAME")
        ...I PSBINIT="" S PSBINIT=99
        ...;get instrc info - audt log
        ...I $D(^PSB(53.79,PSBIEN,.9,$P(PSBDT,"."))) D
        ....D INSTR^PSBOMH
        ....S ^TMP("PSB",$J,"LEGEND",PSBINIT,PSBNAME)=""
        ...I PSBINIT[99 S PSBINIT=""
        ...I $P(^PSB(53.79,PSBIEN,0),U,9)="G",PSBDT=$P(^PSB(53.79,PSBIEN,0),U,6)  D PSBCK1^PSBOMH2("A")
        ...I $P(^PSB(53.79,PSBIEN,0),U,9)'="G",PSBDT=$P(^PSB(53.79,PSBIEN,0),U,6)  D PSBCK1^PSBOMH2("B")
        ...I PSBDT'=$P(^PSB(53.79,PSBIEN,0),U,6),$P(^PSB(53.79,PSBIEN,0),U,9)="RM" D
        ....D DDAUD
        ....S I="" F  S I=$O(PSBTAR(I),-1) Q:I=""  I $P(PSBTAR(I),U,1)=PSBDT D
        .....S PSBS=$P(PSBTAR(I),U,3)
        .....I PSBS="GIVEN",$P($G(PSBTAR(I-1)),U,3)="NOT GIVEN" Q  ; canceled - not given
        .....I PSBS="NOT GIVEN" Q
        .....S PSBS=$S(PSBS="INFUSING":"I",PSBS="GIVEN":"G",PSBS="COMPLETED":"C",PSBS="HELD":"H",PSBS="REFUSED":"R",PSBS="REMOVED":"RM",PSBS="STOPPED":"S",PSBS["MISSING":"M",1:"NO ACTION")
        .....D PSBCTAR^PSBOMH2
        .....S X=$P(PSBTAR(I),U,1,2)_U_PSBS_U_PSBIEN
        ...S Y=$O(^TMP("PSB",$J,PSBWEEK,PSBORD,PSBDT\1,""),-1)+1
        ...S ^TMP("PSB",$J,PSBWEEK,PSBORD,PSBDT\1,Y)=X
        ...S ^TMP("PSB",$J,PSBWEEK,PSBORD,PSBDT\1,0)=Y
        ...D PSBOUT($P((X),"^",1),$P((X),"^",2))
        ...Q
        ..; 1-Time On Call or PRN
        ..D:$P($G(^PSB(53.79,PSBIEN,.1)),U,2)'="C"
        ...I PSBDT'=$$GET1^DIQ(53.79,PSBIEN_",",.06,"I") Q
        ...S PSBINIT=$$GET1^DIQ(53.79,PSBIEN_",","ACTION BY:INITIAL")
        ...S PSBNAME=$$GET1^DIQ(53.79,PSBIEN_",","ACTION BY:NAME")
        ...I PSBINIT="" S PSBINIT=99
        ...S (PSBXA,PSBM)=1,(PSBZ,PSBT,PSBFLG)=""
        ...I $$GET1^DIQ(53.79,PSBIEN_",",.09)="REMOVED"  D
        ....F I=1:1 S PSBXA=$O(^PSB(53.79,PSBIEN,.9,PSBXA)) Q:PSBXA=""  I PSBXA?1.3N  S PSBZ=PSBZ+1,PSBT(PSBZ)=^PSB(53.79,PSBIEN,.9,PSBXA,0)
        ....F S=1:1 Q:PSBM<1  S PSBM=PSBZ-S  I (PSBM>0) I (PSBT(PSBM)["GIVEN")  S PSBFLG="1" S PRELINE1=$P(PSBT(PSBM),"'",2)_" "_$$GET1^DIQ(53.79,PSBIEN_",",.04)_" "_$E($P(PSBT(PSBM),"'",4),1,3) Q
        ...I $D(^PSB(53.79,PSBIEN,.9,$P(PSBDT,"."))) D
        ....D INSTR^PSBOMH
        ....S ^TMP("PSB",$J,"LEGEND",PSBINIT,PSBNAME)=""
        ...I '$D(^PSB(53.79,PSBIEN,.9,$P(PSBDT,".")))  D PSBOUT(PSBDT,PSBINIT)
        ...S PSBLINE1=$$GET1^DIQ(53.79,PSBIEN_",",.09)_" "_$$GET1^DIQ(53.79,PSBIEN_",",.06)_" "_PSBINIT_"            "_$$GET1^DIQ(53.79,PSBIEN_",",.21),PSBLINE2=""
        ...I PSBINIT[99 S PSBINIT=""
        ...D:$P($G(^PSB(53.79,PSBIEN,.1)),U,2)="P"
        ....I $P($G(^PSB(53.79,PSBIEN,.2)),U,2)="" S PSBLINE2="  Results: <No PRN Results On File>"
        ....E  D
        .....S PSBINIT=$$GET1^DIQ(53.79,PSBIEN_",","PRN EFFECTIVENESS ENTERED BY:INITIAL")
        .....S PSBNAME=$$GET1^DIQ(53.79,PSBIEN_",","PRN EFFECTIVENESS ENTERED BY:NAME")
        .....I PSBINIT="" S PSBINIT=99
        .....I $D(^PSB(53.79,PSBIEN,.9,$P(PSBDT,"."))) D
        ......S PSBINIT=PSBINIT_"*",PSBNAME=PSBNAME_"/"_$P(^PSB(53.79,PSBIEN,.9,$P(PSBDT,"."),0),U,3)_"  "_$$GET1^DIQ(53.79,PSBIEN_",",.24)
        ......S ^TMP("PSB",$J,"LEGEND",PSBINIT,PSBNAME)=""
        .....I '$D(^PSB(53.79,PSBIEN,.9,$P(PSBDT,".")))  D
        ......D:$D(^PSB(53.79,PSBIEN,.9,0))
        .......S (PSBXA2,PSBFG)=0,PSBEFFDT=$P(^PSB(53.79,PSBIEN,.2),U,4) F  S PSBXA2=$O(^PSB(53.79,PSBIEN,.9,PSBXA2)) Q:+PSBXA2'>0  D  Q:PSBFG=1
        ........D:($P(^PSB(53.79,PSBIEN,.9,PSBXA2,0),U)=PSBEFFDT)&($P(^PSB(53.79,PSBIEN,.9,PSBXA2,0),U,3)["Instruct")&($P(^PSB(53.79,PSBIEN,.2),U,3)=$P(^PSB(53.79,PSBIEN,.9,PSBXA2,0),U,2))
        .........S PSBINIT=PSBINIT_"*",PSBNAME=PSBNAME_"/"_$P(^PSB(53.79,PSBIEN,.9,PSBXA2,0),U,3)_"  "_$$GET1^DIQ(53.79,PSBIEN_",",.24)
        .........S ^TMP("PSB",$J,"LEGEND",PSBINIT,PSBNAME)="",PSBFG=1
        .....S PSBLINE2="  Results: "_$$GET1^DIQ(53.79,PSBIEN_",",.22)
        .....S PSBRTXTW="     Entered By "_PSBINIT_" on "_$$GET1^DIQ(53.79,PSBIEN_",",.24)
        .....I PSBINIT[99 S PSBINIT=""
        ...S X=PSBDT D H^%DTC F PSBWEEK=PSBAR(%H):-7 Q:$D(^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",0))!('$D(PSBAR(PSBWEEK)))
        ...S X=$O(^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",""),-1)+1
        ...I PSBFLG="1" S ^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",X)=PRELINE1
        ...S ^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",X+1)=PSBLINE1
        ...I $G(PSBLINE2)]"" D
        ....I $L(PSBLINE2)<90 S ^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",X+2)=PSBLINE2 S:$$GET1^DIQ(53.79,PSBIEN_",",.24)'="" ^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",X+3)="      "_PSBRTXTW
        ....I $L(PSBLINE2)>90 D
        .....S ^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",X+2)=$E(PSBLINE2,1,90)
        .....S ^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",X+3)="           "_$E(PSBLINE2,91,161)
        .....I $L(PSBLINE2)'>161 S ^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",X+4)="      "_PSBRTXTW
        .....I $L(PSBLINE2)>161 S ^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",X+4)="     "_$E(PSBLINE2,162,200),^TMP("PSB",$J,PSBWEEK,PSBORD,"AT",X+5)="     "_PSBRTXTW
        Q
        ;
DDAUD   ;  audits for dispen drugs
        ;
        M PSBMLA=^PSB(53.79,PSBIEN)
        S PSBGA="" I $D(PSBMLA(.9,0)) D
        .F PSBX=1:1 Q:'$D(PSBMLA(.9,PSBX))  I ((PSBMLA(.9,PSBX,0)["ACTION STATUS")!(PSBMLA(.9,PSBX,0)["ADMINISTRATION STATUS")) D  Q
        ..I $D(PSBMLA(.9,PSBX-2,0)) D DT^DILF("ENPST",$P(PSBMLA(.9,PSBX-2,0),"'",2),.PSBDATE)
        ..I '$D(PSBMLA(.9,PSBX-2,0)) S PSBDATE=$P(^PSB(53.79,PSBIEN,0),U,6)
        ..S PSBTMP(10000000-PSBDATE,"B")=PSBDATE_U_$$INITIAL^PSBRPC2($P(PSBMLA(0),U,5))_U_$P(PSBMLA(.9,PSBX,0),"'",2)
        ..S PSBGA=1
        .F PSBX=1:1 Q:'$D(PSBMLA(.9,PSBX))  I ((PSBMLA(.9,PSBX,0)["ACTION STATUS")!(PSBMLA(.9,PSBX,0)["ADMINISTRATION STATUS")) D
        ..S PSBTMP(10000000-$P(PSBMLA(.9,PSBX,0),U,1),"B")=$P(PSBMLA(.9,PSBX,0),U,1)_U_$$INITIAL^PSBRPC2($P(PSBMLA(.9,PSBX,0),U,2))_U_$P($P(PSBMLA(.9,PSBX,0),U,3),"'",2)
        ..S PSBGA=1
        I PSBGA'=1 S PSBTMP(10000000-$P(PSBMLA(0),U,6),"A")=$P(PSBMLA(0),U,6)_U_$$INITIAL^PSBRPC2($P(PSBMLA(0),U,7))
        S PSBQRY="PSBTMP",PSBCNT=1 F  S PSBQRY=$Q(@PSBQRY) Q:PSBQRY=""  D  ; does comment go with action
        .;
        .;WV/EHR REVERSE $Q REPLACEMENT; SO 01/12/08 ;VWEHR1
        .;
        .;S PSBPQRY=$Q(@PSBQRY,-1)
        .S PSBPQRY=$$Q^VWUTIL($NA(@PSBQRY),-1)
        .;
        .;END CHANGE
        .;
        .I PSBPQRY="" S PSBTAR(PSBCNT)=@PSBQRY,PSBCNT=PSBCNT+1 Q  ; no prev action
        .I $QS(PSBPQRY,2)="C"  S PSBTAR(PSBCNT)=@PSBQRY,PSBCNT=PSBCNT+1 Q  ; prev line = comment
        .;Begin WorldVistA change ;03/28/2010 ;NO HOME 1.0
        .;I $QS(PSBQRY,2)="C",$E($P(@$Q(@PSBQRY,-1),U,1),1,12)=$E($P(@PSBQRY,U,1),1,12),$P(@$Q(@PSBQRY,-1),U,2)=$P(@PSBQRY,U,2) D  Q
        .I $QS(PSBQRY,2)="C",$E($P(@($$Q^VWUTIL($NA(@PSBQRY),-1)),U,1),1,12)=$E($P(@PSBQRY,U,1),1,12),$P(@($$Q^VWUTIL($NA(@PSBQRY),-1)),U,2)=$P(@PSBQRY,U,2) D  Q
        ..;End WorldVistA change
        ..S X=$P(@PSBQRY,U,4) S:X[":" X=$P(X,":",2) S $P(PSBTAR(PSBCNT-1),U,4)=X Q
        .S PSBTAR(PSBCNT)=@PSBQRY,PSBCNT=PSBCNT+1
        Q
        ;
PSBOUT(PSBTET,PSBOT1)   ;
        I '$D(^PSB(53.79,PSBIEN,.9,0))  D PSBENT^PSBOMH2(PSBOT1)
        S PSBIDA="" I $P(^PSB(53.79,PSBIEN,0),U,6)=PSBTET S PSBIDA=$P(^PSB(53.79,PSBIEN,0),U,7),PSBOT1=$P(^VA(200,PSBIDA,0),"^",2),PSBNAME=$P(^VA(200,PSBIDA,0),"^",1)
        S PSBXA1=0
        F  S PSBXA1=$O(^PSB(53.79,PSBIEN,.9,PSBXA1)) Q:+PSBXA1'>0  I PSBXA1'=0  D  Q:$G(PSBOT1)["*"
        .I $L(PSBXA1)<4  D
        ..I $P(^PSB(53.79,PSBIEN,.9,PSBXA1,0),"^",1)=PSBTET  D
        ...S:$G(PSBIDA)="" PSBIDA=$P(^PSB(53.79,PSBIEN,.9,PSBXA1,0),"^",2),PSBOT1=$P(^VA(200,PSBIDA,0),"^",2),PSBNAME=$P(^VA(200,PSBIDA,0),"^",1)
        ...I (PSBIDA=$P(^PSB(53.79,PSBIEN,.9,PSBXA1,0),"^",2)),$P(^PSB(53.79,PSBIEN,.9,PSBXA1,0),"^",3)["Instruct"  D
        ....S INSDD=$P(^PSB(53.79,PSBIEN,.9,PSBXA1,0),"^",1),Y=INSDD D DD^%DT S INSDD=Y
        ....S PSBOT1=PSBOT1_"*",PSBNAME=PSBNAME_"/"_$P(^PSB(53.79,PSBIEN,.9,PSBXA1,0),U,3)_" "_INSDD
        I $G(PSBIDA)="",$P(^PSB(53.79,PSBIEN,0),U,4)=PSBTET D
        .S PSBIDA=$P(^PSB(53.79,PSBIEN,0),U,5),PSBOT1=$P(^VA(200,PSBIDA,0),"^",2),PSBNAME=$P(^VA(200,PSBIDA,0),"^",1)
        I $G(PSBNAME)="" D
        . S PSBIDA=$P(^PSB(53.79,PSBIEN,0),U,5),PSBOT1=$P(^VA(200,PSBIDA,0),"^",2),PSBNAME=$P(^VA(200,PSBIDA,0),"^",1)
        S ^TMP("PSB",$J,"LEGEND",$S($G(PSBOT1)="":99,1:PSBOT1),PSBNAME)=""
        Q
        ;
