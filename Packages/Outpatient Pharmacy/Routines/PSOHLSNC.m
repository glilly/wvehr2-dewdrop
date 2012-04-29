PSOHLSNC        ;BIR/RTR - Send CHCS message to CPRS ;07/03/02
        ;;7.0;OUTPATIENT PHARMACY;**111,157,143,225**;DEC 1997;Build 29
        ;External reference to ^PS(50.7 supported by DBIA 2223
        ;External reference to ^PS(51.2 supported by DBIA 2226
        ;External reference to ^PSDRUG( supported by DBIA 221
        ;External reference to ^PS(50.607 supported by DBIA 2221
        ;External reference to ^PS(50.606 supported by DBIA 2174
        ;External reference to EN^PSSUTIL1 supported by DBIA 3179
        ;
        ;PSOPND=Internal number from 52.41
        ;PSOPNDST=Order Control Code Status
        ;PSOPNDPT=Pharmacy Status
        ;
EN(PSOPND,PSOPNDST,PSOPNDPT)    ;
        N MSG,PSOHLIP,PSOHLIPX,PSOHLIPC,PSOHLTTL,PSOHUTL,PSOHND,PSOHNDD,PSOHNDU,PSONFLD,PSOXFLD,PSOLIMIT,PSONJJ,PSOHJJ,PSOHCT,PSOSEGMT,PSOHENT,PSOHPRO,PSOHIM,PSOHPC,PSOHPCTX,PSOHRT,PSOHRTE,PSOHRTEN,PSOHRTX,Y,DA,DIQ,DR
        I $G(PSOPND)=""!($G(PSOPNDST)="") Q
        I '$D(^PS(52.41,+$G(PSOPND),0)) Q
        S PSONFLD="F PSONJJ=0:1:PSOLIMIT S PSOXFLD(PSONJJ)="""""
        S PSOHCT=1
        D INIT^PSOHLSN
        D PID,PV1,ORC,RXO,RXE,RXR,ZRX,DG1,ZCL
        D MSG^XQOR("PS EVSEND OR",.MSG)
        Q
PID     ;Build PID segment
        S PSOLIMIT=5 X PSONFLD
        ;What about this ICN number?
        S PSOXFLD(0)="PID"
        S PSOXFLD(3)=$P($G(^PS(52.41,PSOPND,0)),"^",2)
        D SEG
        Q
PV1     ;Build PV1 segment
        S PSOLIMIT=19 X PSONFLD
        S PSOXFLD(0)="PV1"
        S PSOXFLD(2)="O"
        I $P($G(^PS(52.41,PSOPND,0)),"^",13) S PSOXFLD(3)=$P(^(0),"^",13)
        D SEG
        Q
DG1     ;Build DG1 segment
        ;future use; chcs does not send ICD-9 codes.
        Q:'$D(^PS(52.41,PSOPND,"ICD"))
        S PSOLIMIT=4 X PSONFLD
        S PSOXFLD(0)="DG1"
        N LP,VDG,FLAG,DXDESC,DG
        S FLAG="",PSOXFLD(4)="",PSOXFLD(2)=""
        F LP=1:1:8 Q:'$D(^PS(52.41,PSOPND,"ICD",LP,0))  D
        . S VDG="",VDG=^PS(52.41,PSOPND,"ICD",LP,0) Q:$P(VDG,U,1)=""
        . S (DG,DXDESC)=""
        . S DXDESC=$$GET1^DIQ(80,$P(VDG,U,1)_",",10),PSOXFLD(1)=LP
        . S PSOXFLD(3)=$P(VDG,U,1)_U_DXDESC_U_"80"_U_$$GET1^DIQ(80,$P(VDG,U,1)_",",.01)_U_DXDESC_U_"ICD9"
        . D SEG
        Q
ORC     ;Build ORC segment
        S PSOLIMIT=15 X PSONFLD
        S PSOXFLD(0)="ORC"
        S PSOXFLD(1)=$G(PSOPNDST)
        S PSOXFLD(3)=PSOPND_"S^PS"
        S PSOXFLD(5)=$G(PSOPNDPT)
        S X=$P($G(^PS(52.41,PSOPND,0)),"^",6) I X S PSOXFLD(9)=$$FMTHL7^XLFDT(X)
        S PSOHENT=$P($G(^PS(52.41,PSOPND,0)),"^",4) I PSOHENT K ^UTILITY("DIQ1",$J) S DIC=200,DR=.01,DA=PSOHENT,DIQ(0)="E" D EN^DIQ1 S PSOXFLD(10)=PSOHENT_"^"_$P($G(^UTILITY("DIQ1",$J,200,PSOHENT,.01,"E")),"^")
        S PSOHPRO=$P($G(^PS(52.41,PSOPND,0)),"^",5) I PSOHPRO K ^UTILITY("DIQ1",$J) S DIC=200,DR=.01,DA=PSOHPRO,DIQ(0)="E" D EN^DIQ1 S PSOXFLD(12)=PSOHPRO_"^"_$P($G(^UTILITY("DIQ1",$J,200,PSOHPRO,.01,"E")),"^")
        K ^UTILITY("DIQ1",$J)
        S X=$P($G(^PS(52.41,PSOPND,0)),"^",12) I X S PSOXFLD(15)=$$FMTHL7^XLFDT(X)
        D SEG
        Q
RXO     ;Build RXO segment
        S PSOLIMIT=1 X PSONFLD
        S PSOXFLD(0)="RXO"
        S PSOHITM=$P($G(^PS(52.41,PSOPND,0)),"^",8)
        S PSOXFLD(1)=$S($G(PSOHITM):"^^^"_PSOHITM_"^"_$P($G(^PS(50.7,+$G(PSOHITM),0)),"^")_" "_$P($G(^PS(50.606,+$P($G(^(0)),"^",2),0)),"^")_"^99PSP",1:"^^^^^")
        D SEG
        Q
RXE     ;Build RXE segment
        K PSOXFLD S PSOLIMIT=26 X PSONFLD
        S PSOXFLD(0)="RXE"
        ;No Quantity Timing, since the Sig is entered as free text
        S PSOHNDD=$P($G(^PS(52.41,PSOPND,0)),"^",9)
        S PSOHND="" I PSOHNDD S PSOHND=$G(^PSDRUG(PSOHNDD,"ND"))
        S PSOXFLD(2)=$S($P(PSOHND,"^")&($P(PSOHND,"^",3)):$P(PSOHND,"^")_"."_$P(PSOHND,"^",3)_"^"_$P(PSOHND,"^",2)_"^"_"99NDF",1:"^^")_"^"_$G(PSOHNDD)_"^"_$S($G(PSOHNDD):$P($G(^PSDRUG(PSOHNDD,0)),"^"),1:"")_"^"_"99PSD"
        I $P(PSOHND,"^"),$P(PSOHND,"^",3) D
        .I $T(^PSNAPIS)]"" S PSOHNDU=$$DFSU^PSNAPIS($P(PSOHND,"^"),$P(PSOHND,"^",3)) S PSOXFLD(5)="^^^"_$P($G(PSOHNDU),"^",5)_"^"_$P($G(PSOHNDU),"^",6)_"^"_"99PSU"
        I $G(PSOHITM) S PSOXFLD(6)="^^^"_$P($G(^PS(50.7,$G(PSOHITM),0)),"^",2)_"^"_$P($G(^PS(50.606,+$P($G(^PS(50.7,$G(PSOHITM),0)),"^",2),0)),"^")_"^"_"99PSF"
        S PSOXFLD(10)=$P(^PS(52.41,PSOPND,0),"^",10)
        S PSOXFLD(12)=$P(^PS(52.41,PSOPND,0),"^",11)
        S PSOXFLD(22)=$P(^PS(52.41,PSOPND,0),"^",22)
        I $G(PSOHNDD) S PSOHUTL=$$EN^PSSUTIL1(PSOHNDD) S PSOXFLD(25)=$S($E($P(PSOHUTL,"|"),1)=".":"0",1:"")_$P(PSOHUTL,"|"),PSOXFLD(26)=$P(PSOHUTL,"|",2)
        ;Create RXE segment, can possibly go over 245 in length
        S PSOHCT=PSOHCT+1
        S (PSOHLIPX,PSOHLIPC,PSOHLTTL)=0,PSOHLIP="" F  S PSOHLIP=$O(PSOXFLD(PSOHLIP)) Q:PSOHLIP=""  D
        .I PSOHLIP S PSOXFLD(PSOHLIP)="|"_PSOXFLD(PSOHLIP)
        .I PSOHLTTL+$L(PSOXFLD(PSOHLIP))<246 D  S PSOHLTTL=PSOHLTTL+$L(PSOXFLD(PSOHLIP)) Q
        ..I 'PSOHLIPX S MSG(PSOHCT)=$G(MSG(PSOHCT))_PSOXFLD(PSOHLIP) Q
        ..S MSG(PSOHCT,PSOHLIPX)=$G(MSG(PSOHCT,PSOHLIPX))_PSOXFLD(PSOHLIP)
        .S PSOHLICP=245-PSOHLTTL
        .I 'PSOHLIPX D  S PSOHLTTL=$L(MSG(PSOHCT,PSOHLIPX)) Q
        ..S MSG(PSOHCT)=$G(MSG(PSOHCT))_$E(PSOXFLD(PSOHLIP),1,PSOHLICP)
        ..S PSOHLIPX=1,MSG(PSOHCT,PSOHLIPX)=$E(PSOXFLD(PSOHLIP),(PSOHLICP+1),999)
        .S MSG(PSOHCT,PSOHLIPX)=$G(MSG(PSOHCT,PSOHLIPX))_$E(PSOXFLD(PSOHLIP),1,PSOHLICP)
        .S PSOHLIPX=PSOHLIPX+1,MSG(PSOHCT,PSOHLIPX)=$E(PSOXFLD(PSOHLIP),(PSOHLICP+1),999)
        .S PSOHLTTL=$L(MSG(PSOHCT,PSOHLIPX))
        ;Set NTE segments
        S PSOHPCT=0,PSOHCT=PSOHCT+1 I $O(^PS(52.41,PSOPND,3,0)) F PSOHPC=0:0 S PSOHPC=$O(^PS(52.41,PSOPND,3,PSOHPC)) Q:'PSOHPC  D
        .I $G(^PS(52.41,PSOPND,3,PSOHPC,0))="" Q
        .I 'PSOHPCT S MSG(PSOHCT)="NTE|6||"_$G(^PS(52.41,PSOPND,3,PSOHPC,0)) S PSOHPCT=1 Q
        .S MSG(PSOHCT,PSOHPCT)=$G(^PS(52.41,PSOPND,3,PSOHPC,0)),PSOHPCT=PSOHPCT+1
        I 'PSOHPCT S PSOHCT=PSOHCT-1
        S PSOHCT=PSOHCT+1,PSOHPCT=0 I $O(^PS(52.41,PSOPND,"SIG",0)) F PSOHPC=0:0 S PSOHPC=$O(^PS(52.41,PSOPND,"SIG",PSOHPC)) Q:'PSOHPC  D
        .I $G(^PS(52.41,PSOPND,"SIG",PSOHPC,0))="" Q
        .I 'PSOHPCT S MSG(PSOHCT)="NTE|21||"_$G(^PS(52.41,PSOPND,"SIG",PSOHPC,0)) S PSOHPCT=1 Q
        .S MSG(PSOHCT,PSOHPCT)=$G(^PS(52.41,PSOPND,"SIG",PSOHPC,0)),PSOHPCT=PSOHPCT+1
        I 'PSOHPCT S MSG(PSOHCT)="NTE|21||"_"No SIG available"
        Q
RXR     ;Build RXR segment
        S PSOHRTX="" F PSOHRT=0:0 S PSOHRT=$O(^PS(52.41,PSOPND,1,PSOHRT)) Q:'PSOHRT  D
        .S PSOHRTX=1
        .S PSOLIMIT=1 X PSONFLD
        .S PSOXFLD(0)="RXR"
        .S PSOHRTEN=""
        .S PSOHRTE=$P($G(^PS(52.41,PSOPND,1,PSOHRT,1)),"^",8) I PSOHRTE,$D(^PS(51.2,PSOHRTE,0)) S PSOHRTEN=$P($G(^(0)),"^")
        .S PSOXFLD(1)="^^^"_$G(PSOHRTE)_"^"_$G(PSOHRTEN)_"^"_"99PSR"
        .D SEG
        I '$G(PSOHRTX) S PSOLIMIT=1 X PSONFLD S PSOXFLD(0)="RXR",PSOXFLD(1)="^^^^^99PSR" D SEG
        Q
ZRX     ;Build ZRX segment
        S PSOLIMIT=6 X PSONFLD
        S PSOXFLD(0)="ZRX"
        S PSOXFLD(3)="N"
        S PSOXFLD(4)=$P($G(^PS(52.41,PSOPND,0)),"^",17)
        D SEG
        Q
ZCL     ;Build ZCL segment
        N I,JJJ,INODE,EI
        S PSOXFLD(0)="ZCL",PSOLIMIT=3 X PSONFLD
        I $D(^PS(52.41,PSOPND,"ICD")) D
        .F I=1:1:8 D
        ..Q:'$D(^PS(52.41,PSOPND,"ICD",I,0))
        ..S INODE="",INODE=^PS(52.41,PSOPND,"ICD",I,0)
        ..F JJJ=2:1:9 S EI=$P(INODE,U,JJJ) D
        ...S PSOXFLD(1)=I,PSOXFLD(2)=JJJ-1,PSOXFLD(3)=EI
        ...;I JJJ=4 S EI=$S(EI=1:"SC",EI=0:"NSC",1:"") S PSOXFLD(3)=EI
        ...D SEG
        E  D  ;if no ICD node, send one ZCL segment
        .S PSOXFLD(0)="ZCL",PSOXFLD(1)=1,PSOXFLD(2)=3
        .S PSOXFLD(3)=$S($P(^PS(52.41,PSOPND,0),"^",16)="SC":1,$P(^(0),"^",16)="NSC":0,1:"")
        .D SEG
        .Q:'$D(^PS(52.41,PSOPND,"IBQ"))
        .S EI=^PS(52.41,PSOPND,"IBQ")
        .F I=2,3,4,1,5,6,7 S PSOXFLD(3)=$P(EI,U,I) D
        .. S PSOXFLD(2)=$S(I=2:1,I=3:2,I=4:4,I=1:5,I=5:6,I=6:7,I=7:8,1:"") D SEG
        Q
ZSC     ;Build ZSC segment
        S PSOLIMIT=6 X PSONFLD
        S PSOXFLD(0)="ZSC"
        S PSOXFLD(1)=$S($P(^PS(52.41,PSOPND,0),"^",16)="SC":1,$P(^(0),"^",16)="NSC":0,1:"")
        S PSOXFLD(2)=$P($G(^PS(52.41,PSOPND,"IBQ")),"^"),PSOXFLD(3)=$P($G(^("IBQ")),"^",2),PSOXFLD(4)=$P($G(^("IBQ")),"^",3),PSOXFLD(5)=$P($G(^("IBQ")),"^",4),PSOXFLD(6)=$P($G(^("IBQ")),"^",5),PSOXFLD(7)=$P($G(^("IBQ")),"^",6)
        D SEG
        Q
SEG     ;
        S PSOSEGMT="" F PSOHJJ=0:1:PSOLIMIT S PSOSEGMT=$S(PSOSEGMT="":PSOXFLD(PSOHJJ),1:PSOSEGMT_"|"_PSOXFLD(PSOHJJ))
        S PSOHCT=PSOHCT+1,MSG(PSOHCT)=PSOSEGMT
        Q
