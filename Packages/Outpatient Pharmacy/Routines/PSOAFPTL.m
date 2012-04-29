PSOAFPTL        ;VFA/HMS autofinish print for laser printer ; 3/6/07 9:25pm
        ;;7.0;OUTPATIENT PHARMACY;**208**;DEC 1997;Build 54
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
BEGLP   ;
        U IO ;hms fax stuff
        ;
        F DR=1:1 Q:$G(SGY(DR))=""  S SN=19+DR D
        .S AFSIG(SN)=$G(SGY(DR))
        S SIGL=DR-1
        ;
        ;CHECK FOR ES
        S AFESFLAG=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",3)
        S AFORD=$P(^PSRX(RX,"OR1"),"^",2)
        I $G(AFESFLAG)="Y" D
        .S AFES=$P($G(^OR(100,AFORD,8,1,0)),"^",4)
        .I $G(AFES)=1 S AFESYN="Y"
        .I $G(AFESYN)="Y" S AFESIGN=$P($G(^OR(100,AFORD,8,1,0)),"^",5)
        ;
        ;CHECK FOR SCHEDULE II WET SIGNATUIRE
        S AFWET2=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",6)
        S AFDEA=$P(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),0),"^",3)
        ;
        I $G(AFWET2)="Y"&($G(AFDEA)["2") S AFESFLAG="" ;Turns off ES for Sch IIs if wet sig for IIs set in File#59
        I $G(AFWET2)="Y"&($G(AFDEA)["2") S AFESYN=""
        ;
        ;Get Synonym
        S AFS=0,DONE="N",AFSYN="" F L=1:1 S AFS=$O(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),1,AFS)) Q:AFS=""!(DONE="Y")  D
        .I $P(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),1,AFS,0),"^",3)="0" D
        ..S AFSYN=$P($G(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),1,AFS,0)),"^",1),DONE="Y"
        K DONE
        ;
FAX     ;
        K AFFAX
        S FAXNUM=$G(PSOAFFXP) ;PSOAFFXP from PSOLBLN
        S FAXLCNUM=$G(PSOAFFXL)_"@"_FAXNUM
        S FAXSER=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",10)
        I $G(FAXNUM)'=""&(FAXSER'="") D
        . S AFFAX="Y"
        I IO["AFFAX"!($G(AFFAX)="Y") D
        .D NOW^%DTC
        .S FAXDATE=$P(%,".",1)_"Z"_$P(%,".",2)
        .S FAXJOB=RX_"Z"_DFN_"Z"_FAXDATE
        .D OPEN^%ZISH("HFSFAX",FAXSER,FAXJOB_"+"_FAXLCNUM_".TXT","A")
        .S AFFAX="Y"
        .U IO
        ;
        ;Checks to see if 1st 3 lines should print
        S PSOAFPFT=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",9)
        ;
EN1     S OFF=$P(PS,"^",1)
        W $S(PSOAFPFT="N":"",1:OFF)
        ;
        S OFFAD=$P(PS,"^",7)_","_STATE_"  "_$G(PSOHZIP)
        W !
        W $S(PSOAFPFT="N":"",1:OFFAD)
        ;
        S OFFTEL=$P(PS,"^",3)_"-"_$P(PS,"^",4)
        W !
        W $S(PSOAFPFT="N":"",1:OFFTEL)
        ;
        S OFFFREE=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",4)
        W !,OFFFREE
        ;
        W !,"---------------------------------------------------------------",!
        ;
        W !,"Rx for: "
        ;
        D 6^VADPT,PID^VADPT
        S PSOAFPTI=$S(DUZ("AG")="V":$E($G(VA("PID")),5,12),1:$G(VA("PID")))
        S AFPNAM=PNM_" "_$G(PSOAFPTI)
        W AFPNAM
        ;
        S AFPADD1=$G(VAPA(1))
        W !,"        ",AFPADD1
        ;
        S AFPADD2=$G(ADDR(2))
        W !,"        ",AFPADD2
        ;
        S AFPADD3=$G(ADDR(3))
        W !,"        ",AFPADD3
        ;
        S AFPADD4=$G(ADDR(4))
        W !,"        ",AFPADD4
        ;
        W !,"---------------------------------------------------------------",!
        S AFDRUG=DRUG
        W !,AFDRUG
        ;
        S SYNFLAG=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",5)
        I SYNFLAG="Y"&(AFSYN'="") D
        .W !,"Also known as: "
        .W AFSYN
        ;
        I $P($G(^PSRX(RX,"RXFIN")),"^",1)="Y" S VFASDD="Y"
        I $G(VFASDD)="Y" D
        .W !,"Pharmacy may choose strength(s) of drug to meet requirements of directions"
        ;
        ;
SIG     S SN=19
        W !
        F L=1:1:SIGL S SN=SN+1 W !,AFSIG(SN)
        W !
        ;
        W !,"   Dispense: "
        S AFDISP=$G(QTY)_" "_$G(PSDU)
        W AFDISP
        ;
        I $G(VFASDD)="Y" W "     Pharmacy to adjust qty for # of days"
        ;
        W !,"Days Supply: "
        S VFADAYS=$G(DAYS)
        W VFADAYS
        ;
        W !,"  Refill(s): "
        S AFRF=$P(RXY,"^",9)
        W AFRF
        ;
        W !," Issue Date: "
        W DATE
        ;
        ;Print Diagnosis
        I $P($G(^PS(59,PSOSITE,"RXFIN")),"^",8)="Y" D
DIAG    .W !,"  Diagnosis:"
        .S AFICD9="None",AFICD="Not Available"
        .I $D(^OR(100,AFORD,5.1,0)) D
        ..S AFORL=0
        ..F L=1:1 S AFORL=$O(^OR(100,AFORD,5.1,AFORL)) Q:AFORL="B"!(AFORL=0)!(AFORL="")  D
        ...S AFORIN=$P($G(^OR(100,AFORD,5.1,AFORL,0)),"^",1)
        ...I AFORIN>"" D
        ....S AFICD9=$P($G(^ICD9(AFORIN,0)),"^",1)
        ....S AFICD=$P($G(^ICD9(AFORIN,0)),"^",3)
        ....W ?13,AFICD9,?23,AFICD
        .I AFICD9="None" W ?13,AFICD9,?23,AFICD
        ;
        ;Prints DOB
        I $P($G(^PS(59,PSOSITE,"RXFIN")),"^",7)="Y" D
        .S PSOAFDOB=$P($G(VADM(3)),"^",2)
        .W !,"        DOB: "_PSOAFDOB,!
        ;
        ;Prints Provider Comments
        ;W "MD Comments:"
        K ^UTILITY($J,"W") S PSNACNT=1,DIWL=0,DIWR=48,DIWF="",(PSSIXFL,PSSEVFL)=0 F ZZ=0:0 S ZZ=$O(^PSRX(RX,"PRC",ZZ)) Q:'ZZ  I $D(^(ZZ,0)) S X=^(0) D ^DIWP
        ;D ^DIWW
        I $D(^UTILITY($J,"W")) D
        .W "MD Comments:"
        .F ZZ=0:0 S ZZ=$O(^UTILITY($J,"W",DIWL,ZZ)) Q:'ZZ  I $D(^(ZZ,0)) W ?13,^(0),!
        K ^UTILITY($J,"W")
        ;
SIGN    ;Prints DEA if it exists-if no DEA# prints VA# if it exists
        I $G(AFESFLAG)="Y" D
        .I $G(AFESYN)="Y" D
        ..S AFDEA=$$GET1^DIQ(200,AFESIGN,53.2,"I")
        ..I AFDEA="" D
        ...S AFDEA=$$GET1^DIQ(200,AFESIGN,53.3,"I")
        ..S AFESIGNN=$$GET1^DIQ(200,AFESIGN,.01,"I")
        ..S AFSIGN=$G(AFESIGNN)_"  "_AFDEA
        ;
SIGN1   I $G(AFESFLAG)'="Y" D
        .W !!!,"Signature:_________________________________________________"
        .;vfah prints DEA if it exists-if no DEA# prints VA# if it exists
        .S AFDEA=$$GET1^DIQ(200,PSOAFPRV,53.2,"I")
        .I AFDEA="" D
        ..S AFDEA=$$GET1^DIQ(200,PSOAFPRV,53.3,"I")
        .S AFSIGN="           "_$G(PHYS)_"  "_AFDEA
        ;
SIGNP   I $G(AFESYN)="Y" S AFSIGN="Signed: /ES/"_AFSIGN
        W !,AFSIGN
        ;
        K AFESYN,AFESIGN,AFESIGNN
        ;
        W !!,"Must write BRAND NECESSARY to dispense brand drug"
        ;
        S AFPTIM=$S($D(REPRINT):"Re-Printed on: ",1:"Printed on: ")
        W !!,AFPTIM
        ;
        D NOW^%DTC S Y=% X ^DD("DD")
        S AFPRNDT=Y_"  ("_RX_")"
        W AFPRNDT
        ;
        I IO["AFFAX"!($G(AFFAX)="Y") D
        .S FAXFROM=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",11)
        .W !!,"Faxed from: ",FAXFROM," ON ",Y
        ;
        I $D(REPRINT)&($G(PSOCKHN)'=",") W @IOF
        ;
        K VFASDD
        ;
        I IO["AFFAX"!($G(AFFAX)="Y") D CLOSE^%ZISH("HFSFAX") ;HMS CLOSE HFS FILE
        ;
        I $G(REPRINT)'=1 D
        .I IO["AFFAX"!($G(AFFAX)="Y") D
        ..S PSOLAP=$G(^SC(+ORL,"AFRXCLINPRNT"))
        ..S PSOLAP=$P(^%ZIS(1,PSOLAP,0),"^",1)
        ..S IOP=PSOLAP D ^%ZIS
        ..U IO
        ;
ACT     ;Set activity log if faxed
        I IO["AFFAX"!($G(AFFAX)="Y") D
        .S (X,PCOM,PCOMX)="Faxed to: "_PSOAFFXP_" on "_Y
        .I '$D(PSOCLC) S PSOCLC=DUZ
ACT1    .S RXF=0 F J=0:0 S J=$O(^PSRX(RX,1,J)) Q:'J  S RXF=J S:J>5 RXF=J+1
        .S IR=0 F J=0:0 S J=$O(^PSRX(RX,"A",J)) Q:'J  S IR=J
        .S PSOAFPTZ=$S($D(REPRINT):"W",1:"AFFAX")
        .S IR=IR+1,^PSRX(RX,"A",0)="^52.3DA^"_IR_"^"_IR
        .D NOW^%DTC S ^PSRX(RX,"A",IR,0)=%_"^"_PSOAFPTZ_"^"_DUZ_"^"_RXF_"^"_PCOM K PC,IR,PS,PCOM,XX,%,%H,%I,RXF
        ;
        K PSOAFFXP,PSOAFFXL
        ;
        Q
