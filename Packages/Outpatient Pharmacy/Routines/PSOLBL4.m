PSOLBL4 ;BIR/RTR-Set up routine for HL7 interface ; 10/9/08 11:37am
        ;;7.0;OUTPATIENT PHARMACY;**26,70,156,244,233,246,319**;DEC 1997;Build 1
        ;External reference to ^PSDRUG supported by DBIA 221
        ;
        ;*244 - ignore RX's with a status > 11
        ;*246 - send marked drugs & print label (option 4) now working
        ;
        N DIC,AP,X,Y,DPRT,QPRT
        I $G(ZTIO)]"" D
        .Q:'$O(^PS(59,PSOSITE,"P",0))
        .S DIC=3.5,DIC(0)="",X=ZTIO D ^DIC K DIC,X Q:Y=-1
        .S DPRT=+Y
        .F AP=0:0 S AP=$O(^PS(59,PSOSITE,"P",AP)) Q:'AP  I +$P(^PS(59,PSOSITE,"P",AP,0),"^")=DPRT S QPRT=1
        .I '$G(QPRT) S $P(PSOPAR,"^",30)=0
        Q:'$P($G(PSOPAR),"^",30)                ;HL7 interface turned off
        Q:$G(PSOEXREP)
HL      N PSODTM,HHHH,PSOQUE,HLFLAG,HLFOUR,HLINGF,HLINRX,HLINRX0,II,HLNEXT,HLRR,HLRX,HLRXY,LL,PPLHL,PSHALP,HDFN,HLDFN,HNEWDFN,HLDAI,HLOSITE,HLJUST,HLRXYZ,PSOLLN,PSOLLL,PSFLG,HDFN1,NOTMD
        S HLOSITE=$P($G(PSOPAR),"^",30)
        K ^UTILITY($J,"PSOHL"),^UTILITY($J,"PSOHLL"),HLRXY
        S PPLHL=PPL
        S HLFLAG=0 F II=1:1 S HLRX=$P(PPLHL,",",II) D  Q:$G(HLFLAG)
        .S HLNEXT=$P(PPLHL,",",(II+1)) I HLNEXT=""!(HLNEXT=",") S HLFLAG=1
        .Q:'$G(HLRX)
        .Q:'$D(^PSRX(HLRX,0))
        .Q:$P($G(^PSRX(HLRX,"STA")),"^")=4
        .Q:$G(RXRP(HLRX,"RP"))
        .I $P($G(^PSRX(HLRX,"STA")),"^")>11!('$P(^PSRX(HLRX,0),"^",2)) Q
        .I $G(PSODBQ) S HLRR=$O(^PS(52.5,"B",HLRX,0)) Q:'HLRR  I $G(^PS(52.5,+HLRR,"P"))=1 Q
        .;   marked drug options 3 & 4
        .I (HLOSITE=3)!(HLOSITE=4) S NOTMD=0 D  Q:NOTMD     ;quit, not marked
        ..S HLJUST=+$P($G(^PSRX(HLRX,0)),"^",6)
        ..S:'$P($G(^PSDRUG(HLJUST,6)),"^") NOTMD=1
        .S HLRXY(II,HLRX)=""                                ;Valid Rx for HL7
        .S:HLOSITE=3 HLRXYZ(HLRX)=""
        ;
        I $G(HLOSITE)=3,$D(HLRXY) D                 ;rebuild PPL print string
        .K PPL F II=1:1 S HLRX=$P(PPLHL,",",II) Q:'HLRX  D
        ..Q:$D(HLRXYZ(HLRX))
        ..S PPL=$G(PPL)_HLRX_","
        ;
SOMDQ   S (II,PSOQUE)=0 F  S II=$O(HLRXY(II)) Q:'II  S ^UTILITY($J,"PSOHLL",II)=$O(HLRXY(II,0)),PSOQUE=II
        I PSOQUE=0 G ENDHL                ;Nothing set, bypass Call to Queue
        F II=0:0 S II=$O(^UTILITY($J,"PSOHLL",II)) Q:'II  S HLINRX=^(II),HLINRX0=$G(^PSRX(HLINRX,0)) D
        .S ^UTILITY($J,"PSOHLL",II)=HLINRX_"^"_+$P(HLINRX0,"^",6)_"^"_$S($G(RXPR(HLINRX)):"P",1:"F")
        .I '$G(RXPR(HLINRX)) S HLFOUR=0 F HHHH=0:0 S HHHH=$O(^PSRX(HLINRX,1,HHHH)) Q:'HHHH  I +^(HHHH,0) S HLFOUR=HHHH
        .I '$G(RXPR(HLINRX)),$G(RXFL(HLINRX))'="" S HLFOUR=$S($G(RXFL(HLINRX))=0:0,$D(^PSRX(HLINRX,1,+$G(RXFL(HLINRX)),0)):+$G(RXFL(HLINRX)),1:$G(HLFOUR))
        .S ^UTILITY($J,"PSOHLL",II)=^UTILITY($J,"PSOHLL",II)_"^"_$S($G(RXPR(HLINRX)):RXPR(HLINRX),1:HLFOUR)_"^"_$S($P($G(^PSRX(HLINRX,3)),"^",6)&('$G(RXPR(HLINRX)))&('$G(RXFL(HLINRX))):1,1:0) D ACLOG
        .S HLINGF=0 I $P(^UTILITY($J,"PSOHLL",II),"^",5),$O(^PSRX(HLINRX,"DAI",0)) S HLINGF=1 D
        ..F LL=0:0 S LL=$O(^PSRX(HLINRX,"DAI",LL)) Q:'LL  S ^UTILITY($J,"PSOHLL",II,HLINGF)=$G(^PSRX(HLINRX,"DAI",LL,0)),HLINGF=HLINGF+1
        .S $P(^UTILITY($J,"PSOHLL",II),"^",6)=$S($G(HLINGF):1,1:0)
        .I $D(^PSRX(HLINRX,"DRI")),'$G(RXPR(HLINRX)),'$G(RXFL(HLINRX)) S ^UTILITY($J,"PSOHLL",II,"DRI")=^PSRX(HLINRX,"DRI"),$P(^UTILITY($J,"PSOHLL",II),"^",7)=1
        .E  S $P(^UTILITY($J,"PSOHLL",II),"^",7)=0
        .S $P(^UTILITY($J,"PSOHLL",II),"^",8)=0 D RPT Q:'$G(^PSRX(HLINRX,"IB"))
        .I $P(^PSRX(HLINRX,"STA"),"^")>0,$P(^("STA"),"^")'=2,'$G(PSODBQ) Q
        .S $P(^UTILITY($J,"PSOHLL",II),"^",8)=1
        ;
AAA     D STRT^PSOHLSG5
        S (HDFN,HDFN1)=$O(^UTILITY($J,"PSOHLL",0)),HDFN=$P(^PSRX($P(^(HDFN),"^"),0),"^",2),PSOLLL=$P(^UTILITY($J,"PSOHLL",HDFN1),"^",12)
        F HLDFN=0:0 S HLDFN=$O(^UTILITY($J,"PSOHLL",HLDFN)) Q:'HLDFN  D  S ^UTILITY($J,"PSOHL",HLDFN)=^UTILITY($J,"PSOHLL",HLDFN) D OTHER
        .S PSFLG=0,PSOLLN=$P(^UTILITY($J,"PSOHLL",HLDFN),"^",12),HNEWDFN=$P(^PSRX($P(^UTILITY($J,"PSOHLL",HLDFN),"^"),0),"^",2) D
        ..I HDFN'=HNEWDFN S HDFN=HNEWDFN,PSFLG=1
        ..I PSOLLL'=PSOLLN S PSOLLL=PSOLLN,PSFLG=1
        ..I PSFLG=1 D SETZ
        I '$D(^UTILITY($J,"PSOHL")) G ENDHL
CALL    D SETZ
ENDHL   K ^UTILITY($J,"PSOHL"),^UTILITY($J,"PSOHLL"),HLRXY
        Q
OTHER   I $G(^UTILITY($J,"PSOHLL",HLDFN,"DRI"))'="" S ^UTILITY($J,"PSOHL",HLDFN,"DRI")=^UTILITY($J,"PSOHLL",HLDFN,"DRI")
        F HLDAI=0:0 S HLDAI=$O(^UTILITY($J,"PSOHLL",HLDFN,HLDAI)) Q:'HLDAI  S ^UTILITY($J,"PSOHL",HLDFN,HLDAI)=^UTILITY($J,"PSOHLL",HLDFN,HLDAI)
        Q
ACLOG   ;Activity log (sending to Hl7 interface)
        N DTTM,HCOM,HCNT,HJJ
        D NOW^%DTC S DTTM=%,HCOM="Prescription"_$S($G(RXPR(HLINRX)):" (Partial)",1:"")_$S($G(PSOSUREP)!($G(RXRP(HLINRX))):" (Reprint)",1:"")_" sent to external interface."
        S HCNT=0 F HJJ=0:0 S HJJ=$O(^PSRX(HLINRX,"A",HJJ)) Q:'HJJ  S HCNT=HJJ
        S HCNT=HCNT+1,^PSRX(HLINRX,"A",0)="^52.3DA^"_HCNT_"^"_HCNT S ^PSRX(HLINRX,"A",HCNT,0)=DTTM_"^X^"_$G(PDUZ)_"^"_$S($G(RXPR(HLINRX)):6,$G(HLFOUR)<6:$G(HLFOUR),1:(HLFOUR+1))_"^"_HCOM
        Q
SUS(HSREX,HSFL,HSFILL,HSRP)     ;
        N DA,DIK,DTTM,HSCOM,HSCNT,HSJJ,HSLDUZ,PSHLCPRS
        I $P($G(^PSRX(HSREX,"STA")),"^")=5 S $P(^PSRX(HSREX,"STA"),"^")=0 S PSHLCPRS="Removed from Suspense, External Interface." D EN^PSOHLSN1(HSREX,"SC","ZU",PSHLCPRS)
        S DA=$O(^PS(52.5,"B",HSREX,0)) I DA K DIK S DIK="^PS(52.5," D ^DIK
        I $G(HSFL)="P" S HSLDUZ=+$P($G(^PSRX(HSREX,"P",HSFILL,0)),"^",7)
        E  S HSLDUZ=$S('HSFILL:+$P($G(^PSRX(HSREX,0)),"^",16),1:+$P($G(^PSRX(HSREX,1,HSFILL,0)),"^",7))
        D NOW^%DTC S DTTM=%,HSCOM="Removed from Suspense"_$S($G(HSFL)="P":" (Partial)",1:"")_$S($G(HSRP):" (Reprint)",1:"")_" (External Interface)"
        S HSCNT=0 F HSJJ=0:0 S HSJJ=$O(^PSRX(HSREX,"A",HSJJ)) Q:'HSJJ  S HSCNT=HSJJ
        S HSCNT=HSCNT+1,^PSRX(HSREX,"A",0)="^52.3DA^"_HSCNT_"^"_HSCNT S ^PSRX(HSREX,"A",HSCNT,0)=DTTM_"^X^"_$G(HSLDUZ)_"^"_$S($G(HSFL)="P":6,$G(HSFILL)<6:$G(HSFILL),1:(HSFILL+1))_"^"_$G(HSCOM)
        Q
LAB(HLREX,HLFL,HLFILL,HLREPT)   ;
        N HLDUZ,NOW,DA,HCT,HFF
        D NOW^%DTC S NOW=% S HCT=0 F HFF=0:0 S HFF=$O(^PSRX(HLREX,"L",HFF)) Q:'HFF  S HCT=HFF
        I HLFL="F" S HLDUZ=$S('HLFILL:+$P($G(^PSRX(HLREX,0)),"^",16),1:+$P($G(^PSRX(HLREX,1,HLFILL,0)),"^",7))
        I HLFL="P" S HLDUZ=+$P($G(^PSRX(HLREX,"P",HLFILL,0)),"^",7)
        S HCT=HCT+1,^PSRX(HLREX,"L",0)="^52.032DA^"_HCT_"^"_HCT
        S ^PSRX(HLREX,"L",HCT,0)=NOW_"^"_$S($G(HLFL)="F":HLFILL,1:(99-HLFILL))_"^"_"From Rx number "_$P(^PSRX(HLREX,0),"^")_$S($G(HLFL)="P":" (Partial)",1:"")_$S($G(HLREPT):" (Reprint)",1:"")_" (External Interface)"_"^"_$G(HLDUZ)
        N PSOBADR,PSOTEMP
        S PSOBADR=$$CHKRX^PSOBAI(HLREX)
        I $G(PSOBADR) S PSOTEMP=$P(PSOBADR,"^",2),PSOBADR=$P(PSOBADR,"^")
        I $G(PSOBADR),'$G(PSOTEMP) D
        .S HCT=HCT+1,^PSRX(HLREX,"L",0)="^52.032DA^"_HCT_"^"_HCT
        .S ^PSRX(HLREX,"L",HCT,0)=NOW_"^"_$S($G(HLFL)="F":HLFILL,1:(99-HLFILL))_"^"_"ROUTING="_$G(MW)_" (BAD ADDRESS)"_"^"_$G(HLDUZ)
        Q
RPT     ;
        S $P(^UTILITY($J,"PSOHLL",II),"^",9)=$S($G(PSOSUREP)!($G(RXRP(HLINRX))):1,1:0)
        S $P(^UTILITY($J,"PSOHLL",II),"^",10)=+$G(PDUZ)
        Q
SETZ    ;
        D NOW^%DTC S PSODTM=%
        S ZTRTN=$S($$GET1^DIQ(59,PSOSITE_",",105,"I")=2.4:"INIT^PSOHLDS",1:"INIT^PSOHLSG")
        S ZTIO="",ZTDTH=$H,ZTSAVE("^UTILITY($J,""PSOHL"",")="",ZTSAVE("PSOPAR")="",ZTSAVE("PSOSITE")="",ZTSAVE("PSODTM")="",ZTSAVE("PSOLAP")=""
        S ZTSAVE("RXRP(")="",ZTSAVE("RXPR(")="",ZTSAVE("RXFL(")="",ZTSAVE("RXRS(")=""
        S ZTDESC=$S($$GET1^DIQ(59,PSOSITE_",",105,"I")=2.4:"Outpatient Automation External Interface",1:"GENERIC INTERFACE LABEL INFORMATION")
        D ^%ZTLOAD
        K ^UTILITY($J,"PSOHL")
        Q
