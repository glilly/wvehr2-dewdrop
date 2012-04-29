PSOLBLN ;BIR/RTR-NEW PRINTS LABEL ; 3/11/07 1:56pm
        ;;7.0;OUTPATIENT PHARMACY;**16,36,71,107,110,117,135,233,208**;DEC 1997;Build 54
        ; Modified from FOIA VistA
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
        ;External reference to ^PSDRUG supported by DBIA 221
        ;External reference to ^VA(200 supported by DBIA 224
        K PSOSTLK,ZTKDRUG I $L($T(PSOSTALK^PSOTALK1)) D PSOSTALK^PSOTALK1 S PSOSTLK=1 ; PRINT SCRIPTALK LABEL IF APPLICABLE
        I $G(IOS),$G(PSOBARS) I $G(PSOBAR0)=""!($G(PSOBAR1)="") S PSOIOS=IOS D DEVBAR^PSOBMST
        I $G(DFN) D ADD^VADPT
        S ADDR(33)=$G(VAPA(4))_", "_$P($G(VAPA(5)),"^",2)_"  "_$S($G(VAPA(11))]"":$P($G(VAPA(11)),"^",2),1:$G(VAPA(6))),ADDR(22)=""
        S:$G(VAPA(2))]"" ADDR(22)=$G(VAPA(2))_" "_$G(VAPA(3)),ADDR(22)=$E(ADDR(22),1,46) S:ADDR(22)="" ADDR(22)=ADDR(33),ADDR(33)=""
        S ADDR(4)=$S(ADDR(33)="":ADDR(22),1:ADDR(33)) I $G(VAPA(2))="",$G(VAPA(3))="" S ADDR(2)=ADDR(4),ADDR(3)="",ADDR(4)="" G ST
        I $G(VAPA(2))'="",$G(VAPA(3))="" S ADDR(2)=VAPA(2),ADDR(3)=ADDR(4),ADDR(4)="" G ST
        I $G(VAPA(2))="",$G(VAPA(3))'="" S ADDR(2)=VAPA(3),ADDR(3)=ADDR(4),ADDR(4)="" G ST
        S ADDR(2)=$G(VAPA(2)),ADDR(3)=$G(VAPA(3))
ST      I $P($G(^PSRX(RX,3)),"^",3) S PSOPROV=+$P(^(0),"^",4) S PSOPROV=$S($G(RXP):+$P($G(RXP),"^",17),$G(RXF):+$P($G(^PSRX(RX,1,RXF,0)),"^",17),1:PSOPROV) S:'$G(PSOPROV) PSOPROV=+$P(^PSRX(RX,0),"^",4) D
        .I +$P($G(^VA(200,PSOPROV,"PS")),"^",7) S:'$P($G(PHYS),"/",2) PHYS=$G(PHYS)_"/"_+$P($G(^PSRX(RX,3)),"^",3)
        S COPIES=COPIES-1,$P(ULN,"_",34)="",PSOTRAIL=1 I $G(SIDE) D REP^PSOLBL2 G REP
        S (Y,X1)=EXPDT X ^DD("DD") S EXPDT=Y,Y=$P(^PSRX(RX,0),"^",13) X ^DD("DD") S ISD=Y,X2=DT D ^%DTC S DIFF=X
        S Y=DATE X ^DD("DD") S DATE=Y D NOW^%DTC S Y=% X ^DD("DD") S NOW=Y
        S TECH="("_$S($P($G(^PSRX(+$G(RX),"OR1")),"^",5):$P($G(^PSRX(+$G(RX),"OR1")),"^",5),1:$P(RXY,"^",16))_"/"_$S($G(VRPH)&($P(PSOPAR,"^",32)):VRPH,1:" ")_")"
        S PSZIP=$P(PS,"^",5) S PSOHZIP=$S(PSZIP["-":PSZIP,1:$E(PSZIP,1,5)_$S($E(PSZIP,6,9)]"":"-"_$E(PSZIP,6,9),1:""))
        ;
        I $G(PSOAFYN)="Y" G PSOAFPL1 ;vfah
        ;
L1      W ?3,"VAMC ",$P(PS,"^",7),", ",STATE,"  ",$G(PSOHZIP),?54,"VAMC ",$P(PS,"^",7),", ",STATE,"  ",$G(PSOHZIP),?102 W $S($D(REPRINT)&($G(PSOBLALL)):"(GROUP REPRINT)",$D(REPRINT):"(REPRINT)",1:"") W:$G(RXP) "(PARTIAL)"
        W !?3,$P(PS2,"^",2),"  ",$P(PS,"^",3),"-",$P(PS,"^",4),"   ",TECH,?54,$P(PS2,"^",2),"  ",$P(PS,"^",3),"-",$P(PS,"^",4),"   ",TECH,?102,$P(PS2,"^",2)," ",TECH," ",NOW
        W !,"Rx# ",RXN,"  ",DATE,"  Fill ",RXF+1," of ",1+$P(RXY,"^",9),?54,"Rx# ",RXN,"  ",DATE,"  Fill ",RXF+1," of ",1+$P(RXY,"^",9),?102,"Rx# ",RXN,"  ",DATE,"  Fill ",RXF+1," of ",1+$P(RXY,"^",9)
        W !,PNM,"  ",$G(SSNPN),?54,PNM,"  ",$G(SSNPN),?102,PNM,"  ",$G(SSNPN)
        F DR=1:1 Q:$G(SGY(DR))=""  D:DR=4!(DR=7)!(DR=10)!(DR=13)  W !,$G(SGY(DR)),?54,$G(SGY(DR)),?102,$S($G(OSGY(DR))]"":OSGY(DR),1:$G(SGY(DR)))
        .F GG=1:1:27 W !
        I DR>4 S KK=$S(DR=5!(DR=8)!(DR=11):2,(DR=6)!(DR=9)!(DR=12):1,1:0) I KK F HH=1:1:KK W !
        I DR=2 W !!
        I DR=3 W !
        W !,$G(PHYS),?54,$G(PHYS),?102,$G(PHYS)
        S PSMF=$S($G(NURSE):"Mfg______Exp______",1:""),PSDU=$P($G(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),660)),"^",8),PSDU=$S(PSDU="":"      "_PSMF,1:PSDU_" "_PSMF)
        W !,"Qty: "_$G(QTY),"  ",$G(PSDU),?54,"Qty: "_$G(QTY),"  ",$G(PSDU),?102,"Qty: "_$G(QTY),"  ",$G(PSDU)
        S ZTKDRUG="XXXXXX   SCRIPTALK RX   XXXXXX"
        I '$G(PSOSTLK) K PSDU,PSMF W !,DRUG,?54,DRUG,?102,DRUG
        I $G(PSOSTLK) K PSDU,PSMF W !,$S($G(PSOSTALK):ZTKDRUG,1:DRUG),?54,DRUG,?102,DRUG
        I $P(RXY,"^",9)-RXF'>0 D ^PSOLBLN1 G L13
        G:DIFF<30 L11
        W !?54,$P(RXY,"^",9)-RXF," Refills remain prior to ",EXPDT,?102,"Mfg "_$G(MFG)_" Lot# "_$G(LOT) G L12
L11     W !?54,"Last fill prior to ",$G(EXPDT),?102,"Mfg "_$G(MFG)_" Lot# "_$G(LOT)
L12     W !,$P(PS,"^",2),?54,$S($L($G(COPAYVAR)):$G(COPAYVAR)_"     ",1:""),"Days Supply: ",$G(DAYS),?102,"Tech__________RPh_________",!,$P(PS,"^",7),", ",STATE,"  ",$G(PSOHZIP)
        ;send a CR for OPTIFIL (P-MT661BC)
        I $G(PSOBARS),$P(PSOPAR,"^",19)'=1 S X="S",X2=PSOINST_"-"_RX S X1=$X W ?54,@PSOBAR1,X2,@PSOBAR0,$C(13) S $X=0 W:IOST["P-MT661BC" !
        E  W !!!
        W !,"FORWARDING SERVICE REQUESTED" W:"C"[$E(MW) !,?21,"CERTIFIED MAIL" W !?54,$G(VAPA(1))
        W !,$S($G(PS55)=2:"***DO NOT MAIL***",1:"***CRITICAL MEDICAL SHIPMENT***"),?54,$G(ADDR(2)),?102,"Routing: "_$S("W"[$E(MW):MW,1:MW_" MAIL")
        W !?54,$G(ADDR(3)),?102,"Days supply: ",$G(DAYS)," Cap: ",$S(PSCAP:"**NON-SFTY**",1:"SAFETY")
        W !?54,$G(ADDR(4)),?102,"Isd: ",ISD," Exp: ",EXPDT
        W !,PNM,?54,"*Indicate address change on back of this form",?102,"Last Fill: ",$G(PSOLASTF)
        W !,$S($D(PSMP(1)):PSMP(1),1:$G(VAPA(1))),?54,"[ ] Permanent",?102,"Pat. Stat ",PATST," Clinic: ",PSCLN
        W !,$S($D(PSMP(2)):PSMP(2),$D(PSMP(1)):"",1:$G(ADDR(2))),?54,"[ ] Temporary until ",$S($P($G(VAPA(10)),"^",2)]"":$P($G(VAPA(10)),"^",2),1:"__/__/__"),?102,$S($G(WARN)'="":"DRUG WARNING "_$G(WARN),1:"")
        W !,$S($D(PSMP(3)):PSMP(3),$D(PSMP(1)):"",1:$G(ADDR(3))),!,$S($D(PSMP(4)):PSMP(4),$D(PSMP(1)):"",1:$G(ADDR(4))),?54,"Signature",ULN
        I $G(PSOBARS) S X="S",X2=PSOINST_"-"_RX S X1=$X W ?102,@PSOBAR1,X2,@PSOBAR0,$C(13) S $X=0
L13     I $G(WARN)'="",'$G(PSOBLALL) I '$G(PSDFNFLG),'$G(PSOLAPPL) D WARN^PSOLBL2
        W @IOF
        ;
PSOAFPL1        I $G(PSOAFYN)="Y" D PSOAFP ;vfah
        ;
REP     I COPIES>0 S SIDE=1 G ST
        D NOW^%DTC S NOW=% K %,%H,%I I $G(RXF)="" S RXF=0 F I=0:0 S I=$O(^PSRX(RX,1,I)) Q:'I  S RXF=I
        S IR=0 F FDA=0:0 S FDA=$O(^PSRX(RX,"L",FDA)) Q:'FDA  S IR=FDA
        S IR=IR+1,^PSRX(RX,"L",0)="^52.032DA^"_IR_"^"_IR
        S ^PSRX(RX,"L",IR,0)=NOW_"^"_$S($G(RXP):99-RXPI,1:RXF)_"^"_$S($G(PCOMX)]"":$G(PCOMX),$G(PCOMH(RX))]"":PCOMH(RX),1:"From RX number "_$P(^PSRX(RX,0),"^"))_$S($G(RXP):" (Partial)",1:"")_$S($D(REPRINT):" (Reprint)",1:"")_"^"_PDUZ
        N PSOBADR,PSOTEMP
        S PSOBADR=$$CHKRX^PSOBAI(RX)
        I $G(PSOBADR) S PSOTEMP=$P(PSOBADR,"^",2),PSOBADR=$P(PSOBADR,"^")
        I $G(PSOBADR),'$G(PSOTEMP) D
        .S IR=IR+1,^PSRX(RX,"L",0)="^52.032DA^"_IR_"^"_IR
        .S ^PSRX(RX,"L",IR,0)=NOW_"^"_$S($G(RXP):99-RXPI,1:RXF)_"^"_"ROUTING="_$G(MW)_" (BAD ADDRESS)"_"^"_PDUZ
        S ^PSRX(RX,"TYPE")=0 K RXF,IR,FDA,NOW,I,PCOMH(RX)
PSOAFPL2        I $G(PSOAFYN)="Y" G PSOAFPL3 ;vfah
        I $G(WARN)'="" I $G(PSDFNFLG)!($G(PSOLAPPL)) D ALLWARN^PSOLBLN1
        I $G(WARN)="" I $G(PSDFNFLG)!($G(PSOLAPPL)) D ALL^PSOLBLS
        I $G(PSOBLALL) D:$G(WARN)="" ALL^PSOLBLS D:$G(WARN)'="" ALLWARN^PSOLBLN1
        I '$D(PSSPND),$P(PSOPAR,"^",18) I $G(PSDFNFLG)!($G(PSOLAPPL))!($G(PSOBLALL)) D CHCK2^PSOTRLBL
PSOAFPL3        ;vfah
        D:$G(PSOBLALL) TRAIL^PSOLBL2
END     ;
        I $D(RXFLX(RX)) S RXFL(RX)=$G(RXFLX(RX)) K RXFLX
        ;
        I '$D(REPRINT)&($G(PSOAFYN)="Y") D ^PSODISP ;vfah auto-release
        ;
        D KILL^PSOLBL2 Q
        ;
        Q  ;vfah
        ;
PSOAFP  ;Patient prescription print starts here;vfah
        S PSOAFPRV=$P($G(^PSRX(RX,0)),"^",4)
        S PSDU=$P($G(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),660)),"^",8) ;vfah sets dispense units
        I $G(VFASDD)="Y" S $P(^PSRX(RX,"RXFIN"),"^",1)="Y" ;Sets complex order flag in File#52
        K VFASDD
        ;
AFFAX   ;
        I $G(REPRINT)'=1 D
        .S LZ=0,STOP=0 F  S LZ=$O(^PSRX(RX,"PRC",LZ)) Q:'LZ!(STOP=1)  S LZZ=$P(^PSRX(RX,"PRC",LZ,0),"FAX: ",2) S LZZ=+LZZ I LZZ'=0 D
        ..I $D(^DIZ(22900)) D
        ...S DIC="^DIZ(22900,",DIC(0)="MOZ",X=LZZ
        ...D ^DIC K DIC
        ...I +Y'=-1 D
        ....S PSOAFFXP=X
        ....S PSOAFFXL=$P(Y,"^",2)
        ....S ^PSRX(RX,"PRC",LZ,0)=$TR(^PSRX(RX,"PRC",LZ,0),":","+")
        ....S STOP=1
        ...I +Y=-1 D
        ....S ^PSRX(RX,"PRC",LZ,0)=$TR(^PSRX(RX,"PRC",LZ,0),":","-")
        K STOP,LZ,LZZ
        I $G(REPRINT)=1 S PSOAFFXP=$G(PSOAFFXR)
        I $G(PSOAFFXP)>1 G AFPTL
        ;
AFPTS   I PSOLAP["STAR" D PRNT^PSOAFPTS
        I PSOLAP["STAR" G AFKILL
        I PSOLAP["STRL" D PRNT^PSOAFPT1
        I PSOLAP["STRL" G AFKILL
        ;
AFPTL   D BEGLP^PSOAFPTL
        ;
AFKILL  K PSOAFPRV
        I $G(REPRINT)'=1 D ^%ZISC
