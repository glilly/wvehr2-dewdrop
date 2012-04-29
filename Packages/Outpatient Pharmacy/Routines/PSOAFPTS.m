PSOAFPTS        ;VFA/HMS autofinish print for star printer ;3/13/07  19:26
        ;;7.0;OUTPATIENT PHARMACY;**208**;DEC 1997;Build 54
        ; Copyright (C) GNU GPL 2007 WorldVistA
        ;
PRNT    ;PAGEMODE for Star Micronics
        ;
        U IO ;vfah fax
        ;
        F DR=1:1 Q:$G(SGY(DR))=""  S SN=19+DR D
        .S AFSIG(SN)=$G(SGY(DR))
        S SIGL=DR-1
        ;
        S AFESFLAG=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",3)
        S AFORD=$P(^PSRX(RX,"OR1"),"^",2)
        I $G(AFESFLAG)="Y" D
        .S AFES=$P($G(^OR(100,AFORD,8,1,0)),"^",4)
        .I $G(AFES)=1 S AFESYN="Y"
        .I $G(AFESYN)="Y" S AFESIGN=$P($G(^OR(100,AFORD,8,1,0)),"^",5)
        ;
        S AFWET2=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",6)
        S AFDEA=$P(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),0),"^",3)
        ;
        I $G(AFWET2)="Y"&($G(AFDEA)["2") S AFESFLAG="" ;Turns off ES for Sch IIs if wet sig for IIs set in File#59
        I $G(AFWET2)="Y"&($G(AFDEA)["2") S AFESYN=""
        ;
        S AFS=0,DONE="N",AFSYN="" F L=1:1 S AFS=$O(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),1,AFS)) Q:AFS=""!(DONE="Y")  D
        .I $P(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),1,AFS,0),"^",3)="0" D
        ..S AFSYN=$P($G(^PSDRUG($P($G(^PSRX(RX,0)),"^",6),1,AFS,0)),"^",1),DONE="Y"
        K DONE
        ;
DIAG    ;
        S AFICD9(1)="None",AFICD(1)="Not Available",L=2
        I $D(^OR(100,AFORD,5.1,0)) D
        .S AFORL=0
        .F L=1:1 S AFORL=$O(^OR(100,AFORD,5.1,AFORL)) Q:AFORL="B"!(AFORL=0)!(AFORL="")  D
        ..S AFORIN=$P($G(^OR(100,AFORD,5.1,AFORL,0)),"^",1)
        ..I AFORIN>"" D
        ...S AFICD9(L)=$P($G(^ICD9(AFORIN,0)),"^",1)
        ...S AFICD(L)=$P($G(^ICD9(AFORIN,0)),"^",3)
        S AFICDN=L-1
        ;
PRC     ;
        K ^UTILITY($J,"W") S PSNACNT=1,DIWL=0,DIWR=70,DIWF="",(PSSIXFL,PSSEVFL)=0 F ZZ=0:0 S ZZ=$O(^PSRX(RX,"PRC",ZZ)) Q:'ZZ  I $D(^(ZZ,0)) S X=^(0) D ^DIWP
        F ZZ=0:0 S ZZ=$O(^UTILITY($J,"W",DIWL,ZZ)) Q:'ZZ  I $D(^(ZZ,0)) S PSOAFZZ=ZZ
        ;
        W $C(27),"C",$C(10),$C(0) ;Clear format
        ;
        W $C(27),"L00;0110,0030,0920,0030,0,6",$C(10),$C(0) ;T
        W $C(27),"L01;0025,0100,0025,0230,1,6",$C(10),$C(0) ;L
        W $C(27),"L02;1000,0100,1000,0238,1,6",$C(10),$C(0) ;R
        W $C(27),"L03;0025,0230,1000,0230,0,6",$C(10),$C(0) ;B
        W $C(27),"L10;0920,0030,0920,0100,1,6",$C(10),$C(0) ;R
        W $C(27),"L11;0920,0100,1000,0100,0,6",$C(10),$C(0) ;B
        W $C(27),"L12;0110,0030,0110,0102,1,6",$C(10),$C(0) ;R
        W $C(27),"L13;0025,0100,0112,0100,0,6",$C(10),$C(0) ;B
        ;
        W $C(27),"L05;0025,0470,1000,0470,0,2",$C(10),$C(0) ;Div Line
        ;
        W $C(27),"PC00;0210,0055,1,1,4,00,00",$C(10),$C(0) ;Dr
        W $C(27),"PC01;0025,0100,1,1,2,00,00",$C(10),$C(0) ;Dr
        W $C(27),"PC02;0025,0145,1,1,2,00,00",$C(10),$C(0) ;Dr Phone
        W $C(27),"PC70;0025,0190,1,1,2,00,00",$C(10),$C(0) ;Free line
        ;
        W $C(27),"PC03;0025,0285,1,1,1,00,03",$C(10),$C(0) ;Rx For
        W $C(27),"PC04;0130,0280,1,1,2,00,00",$C(10),$C(0) ;Pat Name
        W $C(27),"PC05;0130,0320,1,1,2,00,00",$C(10),$C(0) ;Pat Str1
        W $C(27),"PC06;0130,0360,1,1,2,00,00",$C(10),$C(0) ;Pat Str2
        W $C(27),"PC07;0130,0400,1,1,2,00,00",$C(10),$C(0) ;Pat Str3
        W $C(27),"PC08;0130,0440,1,1,2,00,00",$C(10),$C(0) ;Pat City
        ;
        S DHL=4
        S:$L(DRUG)>33 DHL=2 ;Reduce size for L>33
        W $C(27),"PC09;0025,0500,1,1,"_DHL_",00,00",$C(10),$C(0) ;Drug
        ;
        W $C(27),"PC72;0025,0558,1,1,1,00,03",$C(10),$C(0) ;AKA Notice
        W $C(27),"PC71;0225,0550,1,1,2,00,00",$C(10),$C(0) ;Drug Syn
        ;
        W $C(27),"PC10;0025,0590,1,1,1,00,03",$C(10),$C(0) ;SDD Disclaimer
        ;
        S SL=19,VP=590
        F L=1:1:SIGL D
        .S SL=SL+1,VP=VP+40
        .D SVP
        .W $C(27),"PC"_SL_";0025,"_VP_",1,1,2,00,00",$C(10),$C(0)
        ;
        S VP=VP+60 D SVP
        W $C(27),"PC50;0085,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Disp:
        W $C(27),"PC51;0300,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Disp Num
        ;
        ;S VP=VP+40 D SVP
        W $C(27),"PC52;0450,"_VP_",1,1,1,00,03",$C(10),$C(0) ;Disp Disclaimer
        ;
        S VP=VP+40 D SVP
        W $C(27),"PC53;0025,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Days
        W $C(27),"PC54;0300,"_VP_",1,1,2,00,00",$C(10),$C(0) ; Supply
        ;
        S VP=VP+40 D SVP
        W $C(27),"PC55;0065,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Refill
        W $C(27),"PC56;0300,"_VP_",1,1,2,00,00",$C(10),$C(0)
        ;
        S VP=VP+40 D SVP
        W $C(27),"PC57;0045,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Issue
        W $C(27),"PC58;0300,"_VP_",1,1,2,00,00",$C(10),$C(0) ; Date #
        ;
        ;Diag Line Logo
        S VP=VP+40 D SVP
        W $C(27),"PC79;0065,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Diag
        ;
        S SL=79,VP=VP-40 ;Diag lines
        F L=1:1:AFICDN D
        .S SL=SL+1,VP=VP+40
        .D SVP
        .W $C(27),"PC"_SL_";0300,"_VP_",1,1,2,00,00",$C(10),$C(0)
        .S SL=SL+1
        .W $C(27),"PC"_SL_";0475,"_VP_",1,1,2,00,00",$C(10),$C(0)
        ;
        ;DOB Line
        S SL=SL+1,VP=VP+40 D SVP
        W $C(27),"PC"_SL_";0065,"_VP_",1,1,2,00,00",$C(10),$C(0) ;DOB:
        S SL=SL+1
        W $C(27),"PC"_SL_";0300,"_VP_",1,1,2,00,00",$C(10),$C(0) ;DOB
        ;
        ;Comment Line Logo
        I $G(PSOAFZZ)>0 D
        .S SL=SL+1,VP=VP+40 D SVP
        .W $C(27),"PC"_SL_";0008,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Comment Logo
        ;
        I $G(PSOAFZZ)>0 D
        .S VP=VP-40 ;Comment lines
        .F L=1:1:PSOAFZZ D
        ..S SL=SL+1,VP=VP+$S(L=1:48,1:25)
        ..D SVP
        ..W $C(27),"PC"_SL_";0300,"_VP_",1,1,1,00,00",$C(10),$C(0)
        ;
        ;Signature lines start here
        I $G(AFESYN)="Y" S VP=VP+130 D SVP G SIGNL
        S VP=VP+130 D SVP
        W $C(27),"PC59;0025,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Sig:
        ;
        S VP=VP+30 D SVP
        W $C(27),"L04;0230,"_VP_",1000,"_VP_",0,2",$C(10),$C(0) ;Line
        ;
SIGNL   S VP=VP+10 D SVP
        I $G(AFESYN)="Y" G SIGNL1
        W $C(27),"PC60;0240,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Prov Name
SIGNL1  W $C(27),"PC60;0025,"_VP_",1,1,2,00,00",$C(10),$C(0) ;ES Prov Name
        ;
        S VP=VP+110 D SVP
        W $C(27),"PC61;0025,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Trail
        ;
        S VP=VP+90 D SVP
        W $C(27),"PC62;0025,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Printed On:
        W $C(27),"PC63;0320,"_VP_",1,1,2,00,00",$C(10),$C(0) ;Printed On D/T
        ;
        ;Testing form length on Star
        S PA=$S(VP>1501:1900,1:1500)
        W $C(27),"D"_PA_"",$C(10),$C(0) ;Set print area
        ;
        W $C(27),"B",$C(10),$C(0) ;Enable cutter
        ;
        S OFF=$P(PS,"^",1)
        S VFAX=OFF,VFAM=20
        D CENTER
        S OFF=VFAX
        W $C(27),"RC00;"_OFF_"",$C(10),$C(0)
        ;
        S OFFAD=$P(PS,"^",7)_","_STATE_"  "_$G(PSOHZIP)
        S VFAX=OFFAD,VFAM=49
        D CENTER
        S OFFAD=VFAX
        W $C(27),"RC01;"_OFFAD_"",$C(10),$C(0)
        ;
        S OFFTEL=$P(PS,"^",3)_"-"_$P(PS,"^",4)
        S VFAX=OFFTEL,VFAM=49
        D CENTER
        S OFFTEL=VFAX
        W $C(27),"RC02;"_OFFTEL_"",$C(10),$C(0)
        ;
        S OFFFREE=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",4)
        S VFAX=OFFFREE,VFAM=49
        D CENTER
        S OFFFREE=VFAX
        W $C(27),"RC70;"_OFFFREE_"",$C(10),$C(0)
        ;
        W $C(27),"RC03;Rx for:",$C(10),$C(0)
        ;
        D 6^VADPT,PID^VADPT
        S PSOAFPTI=$S(DUZ("AG")="V":$E($G(VA("PID")),5,12),1:$G(VA("PID")))
        S AFPNAM=PNM_" "_$G(PSOAFPTI)
        W $C(27),"RC04;"_AFPNAM_"",$C(10),$C(0)
        ;
        S AFPADD1=$G(VAPA(1))
        W $C(27),"RC05;"_AFPADD1_"",$C(10),$C(0)
        ;
        S AFPADD2=$G(ADDR(2))
        W $C(27),"RC06;"_AFPADD2_"",$C(10),$C(0)
        ;
        S AFPADD3=$G(ADDR(3))
        W $C(27),"RC07;"_AFPADD3_"",$C(10),$C(0)
        ;
        S AFPADD4=$G(ADDR(4))
        W $C(27),"RC08;"_AFPADD4_"",$C(10),$C(0)
        ;
        S AFDRUG=DRUG
        W $C(27),"RC09;"_AFDRUG_"",$C(10),$C(0)
        ;
        S SYNFLAG=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",5)
        I SYNFLAG="Y"&(AFSYN'="") D
        .W $C(27),"RC72;Also known as:",$C(10),$C(0) ;L-72
        .W $C(27),"RC71;"_AFSYN_"",$C(10),$C(0) ;L-71
        ;
        I $P($G(^PSRX(RX,"RXFIN")),"^",1)="Y" S VFASDD="Y"
        I $G(VFASDD)="Y" D
        .W $C(27),"RC10;Pharmacy may choose strength(s) of drug to meet requirements of directions",$C(10),$C(0)
        ;
        ;
SIG     S SN=19
        F L=1:1:SIGL S SN=SN+1 W $C(27),"RC"_SN_";"_AFSIG(SN)_"",$C(10),$C(0)
        ;
        W $C(27),"RC50;Dispense:",$C(10),$C(0)
        S AFDISP=$G(QTY)_" "_$G(PSDU)
        W $C(27),"RC51;"_AFDISP_"",$C(10),$C(0)
        ;
        I $G(VFASDD)="Y" W $C(27),"RC52;Pharmacy to adjust qty for # of days",$C(10),$C(0)
        ;
        W $C(27),"RC53;Days Supply:",$C(10),$C(0)
        S VFADAYS=$G(DAYS)
        W $C(27),"RC54;"_VFADAYS_"",$C(10),$C(0)
        ;
        W $C(27),"RC55;Refill(s):",$C(10),$C(0)
        S AFRF=$P(RXY,"^",9)
        W $C(27),"RC56;"_AFRF_"",$C(10),$C(0)
        ;
        W $C(27),"RC57;Issue Date:",$C(10),$C(0)
        W $C(27),"RC58;"_DATE_"",$C(10),$C(0)
        ;
DIA     S PSOAFDOB=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",8)
        I PSOAFDOB="Y" D
        .W $C(27),"RC79;Diagnosis:",$C(10),$C(0)
        .S SN=79
        .F L=1:1:AFICDN S SN=SN+1 D
        ..W $C(27),"RC"_SN_";"_AFICD9(L)_"",$C(10),$C(0)
        ..S SN=SN+1
        ..W $C(27),"RC"_SN_";"_AFICD(L)_"",$C(10),$C(0)
        I PSOAFDOB="" S SN=80+AFICDN
        ;
DOB     ;DOB
        S PSOAFDIG=$P($G(^PS(59,PSOSITE,"RXFIN")),"^",7)
        I PSOAFDIG="Y" D
        .S PSOAFDOB=$P($G(VADM(3)),"^",2),PSOAFDOL="      DOB:"
        .S SN=SN+1
        .W $C(27),"RC"_SN_";      DOB:",$C(10),$C(0)
        .S SN=SN+1
        .W $C(27),"RC"_SN_";"_PSOAFDOB_"",$C(10),$C(0)
        I PSOAFDIG="" S SN=SN+2
        ;
COM     ;
        I $D(^UTILITY($J,"W")) D
        .S SN=SN+1
        .W $C(27),"RC"_SN_"; MD Comments:",$C(10),$C(0)
        .F ZZ=0:0:PSOAFZZ S ZZ=$O(^UTILITY($J,"W",DIWL,ZZ)) Q:'ZZ  I $D(^(ZZ,0)) S PSOAFCOM=^(0),SN=SN+1 W $C(27),"RC"_SN_";"_PSOAFCOM_"",$C(10),$C(0)
        K PSOZAFZZ,^UTILITY($J,"W")
        ;
        ;Signature Block
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
        .W $C(27),"RC59;Signature:",$C(10),$C(0)  ;SCD
        .;vfah prints DEA if it exists-if no DEA# prints VA# if it exists
        .S AFDEA=$$GET1^DIQ(200,PSOAFPRV,53.2,"I")
        .I AFDEA="" D
        ..S AFDEA=$$GET1^DIQ(200,PSOAFPRV,53.3,"I")
        .S AFSIGN="           "_$G(PHYS)_"  "_AFDEA
        ;
SIGNP   I $G(AFESYN)="Y" S AFSIGN="Signed: /ES/"_AFSIGN
        W $C(27),"RC60;"_AFSIGN_"",$C(10),$C(0) ;SCD
        ;
        K AFESYN,AFESIGN,AFESIGNN
        ;
        W $C(27),"RC61;Must write BRAND NECESSARY to dispense brand drug",$C(10),$C(0) ;SCD
        ;
        S AFPTIM=$S($D(REPRINT):"Re-Printed on:",1:"Printed on:")
        W $C(27),"RC62;"_AFPTIM_"",$C(10),$C(0) ;SCD
        D NOW^%DTC S Y=% X ^DD("DD")
        S AFPRNDT=Y_"  ("_RX_")"
        W $C(27),"RC63;"_AFPRNDT_"",$C(10),$C(0) ;SCD
        ;
WRITE   W $C(27),"I",$C(10),$C(0) ;Print label
        ;
        K VFASDD
        Q
        ;
SVP     S VP=$S($L(VP)=1:"000"_VP,$L(VP)=2:"00"_VP,$L(VP)=3:"0"_VP,1:VP)
        Q
        ;
CENTER  ;Center header
        S VFAS=(VFAM-$L(VFAX))\2
        F L=1:1:VFAS S VFAX=" "_VFAX
