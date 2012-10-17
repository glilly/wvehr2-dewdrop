PSON52  ;BIR/DSD - files new entries in prescription file ;1:42 PM  20 Aug 2009
        ;;7.0;OUTPATIENT PHARMACY;**1,16,23,27,32,46,71,111,124,117,131,139,157,143,219,148,239,201,268,260,225,303**;DEC 1997;Build 58;WorldVistA 30-June-08
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
        ;External reference ^PS(55 supported by DBIA 2228
        ;External reference to PSOUL^PSSLOCK supported by DBIA 2789
        ;External reference to ^XUSEC supported by DBIA 10076
        ;External reference SWSTAT^IBBAPI supported by DBIA 4663
        ;External reference SAVNDC^PSSNDCUT supported by DBIA 4707
EN(PSOX)        ;Entry Point
START   ;
        D:$D(XRTL) T0^%ZOSV ; Start RT Monitor
        D INIT G:PSON52("QFLG") END D NFILE Q:$G(PSONEW("DFLG"))  D PS55,DIK
        S:$D(XRT0) XRTN=$T(+0) D:$D(XRT0) T1^%ZOSV ; Stop RT Monitor
        D FINISH
        I $P(^PSRX(PSOX("IRXN"),0),"^",11)="W",$G(^("IB")) S ^PSRX("ACP",$P(^PSRX(PSOX("IRXN"),0),"^",2),$P(^(2),"^",2),0,PSOX("IRXN"))=""
END     D EOJ
        Q
INIT    ;
        K X,%DT S:$G(PSOID) PSOX("ISSUE DATE")=PSOID
        S PSOX("CS")=0
        F DEA=1:1 Q:$E(PSODRUG("DEA"),DEA)=""  I $E(+PSODRUG("DEA"),DEA)>1,$E(+PSODRUG("DEA"),DEA)<6 S $P(PSOX("CS"),"^")=1 S:$E(+PSODRUG("DEA"),DEA)=2 $P(PSOX("CS"),"^",2)=1
        S PSON52("QFLG")=0,X1=PSOX("ISSUE DATE"),X2=PSOX("DAYS SUPPLY")*(PSOX("# OF REFILLS")+1)\1
        I $D(CLOZPAT) S X2=$S(X2=14:14,X2=7:7,1:X2) G DT
        S X2=$S(PSOX("DAYS SUPPLY")=X2:X2,+$G(PSOX("CS")):184,+$G(DEA("CS")):184,1:366)
        I X2<30 D
        . N % S %=$P($G(PSORX("PATIENT STATUS")),"^"),X2=30
        . S:%?.N %=$P($G(^PS(53,+%,0)),"^") I %["AUTH ABS" S X2=5
DT      D C^%DTC S PSOX("STOP DATE")=$P(X,".") K X
        I PSOX("# OF REFILLS")>0 S X1=PSOX("FILL DATE"),X2=$S((PSOX("DAYS SUPPLY")-10\1)<1:1,1:PSOX("DAYS SUPPLY")-10\1) D C^%DTC S PSOX("NEXT POSSIBLE REFILL")=$P(X,".") K X
        S PSOX("TYPE OF RX")=0,PSOX("DISPENSED DATE")=PSOX("FILL DATE") D NOW^%DTC S PSOX("LOGIN DATE")=$S($P($G(OR0),"^",12):$P($G(OR0),"^",12),1:%) K %,X
        S PSOX("STATUS")=$S($G(PSOX("STATUS"))]"":PSOX("STATUS"),$D(PSORX("VERIFY")):1,1:0)
        S PSOX("COPIES")=$S($G(PSOX("COPIES"))]"":PSOX("COPIES"),1:1)
        I $G(PSORX("PHARM"))]"" S PSOX("PHARMACIST")=PSORX("PHARM") K PSORX("PHARM")
INITX   Q
        ;
NFILE   I $G(OR0) D  Q:$G(PSONEW("DFLG"))
        .D NOOR^PSONEW Q:$G(PSONEW("DFLG"))
        .I $G(PSOSIGFL)!($G(PSODRUG("OI"))'=$P(OR0,"^",8)) S PSONEW("CLERK CODE")=DUZ,PSONEW("REMARKS")=$G(PSONEW("REMARKS"))_" CPRS Order #"_$P(OR0,"^")_" Edited."
        S DIC="^PSRX(",DLAYGO=52,DIC(0)="L",X=PSOX("RX #") K DD,DO D FILE^DICN S PSOX("IRXN")=+Y K DLAYGO,X,Y,DIC,DD,DO D:+$G(DGI) TECH^PSODGDGI
        F PSOX1=0:1 S PSON52=$P($T(DD+PSOX1),";;",2,4) Q:PSON52=""  K PSOY S PSOY=$P(PSON52,";;") I $G(@PSOY)]"" S $P(PSON52(PSOX("IRXN"),$P(PSON52,";;",2)),"^",$P(PSON52,";;",3))=@PSOY
        F I=1:1:PSOX("ENT") S ^PSRX(PSOX("IRXN"),6,I,0)=PSOX("DOSE",I)_"^"_$G(PSOX("DOSE ORDERED",I))_"^"_$G(PSOX("UNITS",I))_"^"_$G(PSOX("NOUN",I))_"^" D
        .S ^PSRX(PSOX("IRXN"),6,I,0)=^PSRX(PSOX("IRXN"),6,I,0)_$G(PSOX("DURATION",I))_"^"_$G(PSOX("CONJUNCTION",I))_"^"_$G(PSOX("ROUTE",I))_"^"_$G(PSOX("SCHEDULE",I))_"^"_$G(PSOX("VERB",I))
        .I $G(PSOX("ODOSE",I))]"" S ^PSRX(PSOX("IRXN"),6,I,1)=PSOX("ODOSE",I)
        S ^PSRX(PSOX("IRXN"),6,0)="^52.0113^"_PSOX("ENT")_"^"_PSOX("ENT")
        K PSOX1,PSOY
        S PSOX1="" F  S PSOX1=$O(PSON52(PSOX("IRXN"),PSOX1)) Q:PSOX1=""  S ^PSRX(PSOX("IRXN"),PSOX1)=$G(PSON52(PSOX("IRXN"),PSOX1))
        I $O(PSOX("SIG",0)) D
        .S D=0 F  S D=$O(PSOX("SIG",D)) Q:'D  S ^PSRX(PSOX("IRXN"),"INS1",D,0)=PSOX("SIG",D),TP=$G(TP)+1
        .S ^PSRX(PSOX("IRXN"),"INS1",0)="^52.0115^"_TP_"^"_TP_"^"_DT_"^^" K TP,D
        I $G(PSOX("SINS"))]"" S ^PSRX(PSOX("IRXN"),"INSS")=PSOX("SINS")
        I $G(SIGOK) D
        .S $P(^PSRX(PSOX("IRXN"),"SIG"),"^",2)=1,^PSRX(PSOX("IRXN"),"SIG1",0)="^52.04A^^"
        .S D=0 F  S D=$O(SIG(D)) Q:'D  S ^PSRX(PSOX("IRXN"),"SIG1",D,0)=SIG(D),$P(^PSRX(PSOX("IRXN"),"SIG1",0),"^",3)=+$P(^PSRX(PSOX("IRXN"),"SIG1",0),"^",3)+1,$P(^(0),"^",4)=+$P(^(0),"^",4)+1 Q:'$O(SIG(D))
        .K SIG
        I $D(PSOINSFL) S ^PSRX(PSOX("IRXN"),"A",0)="^52.3DA^1^1",^PSRX(PSOX("IRXN"),"A",1,0)=DT_"^G^^0^Patient Instructions "_$S(PSOINSFL=1:"",1:"Not ")_"Sent By Provider."
        I $G(OR0) S:$P(OR0,"^",24) ^PSRX(PSOX("IRXN"),"PKI")=1
        K PSOX1,PSOFINFL,HLDSIG,D,PSOINSFL,D
        D:$G(^TMP("PSODAI",$J,0))
        .S $P(^PSRX(PSOX("IRXN"),3),"^",6)=1
        .I $O(^TMP("PSODAI",$J,0)) S DAI=0 F  S DAI=$O(^TMP("PSODAI",$J,DAI)) Q:'DAI  D
        ..S:'$D(^PSRX(PSOX("IRXN"),"DAI",0)) ^PSRX(PSOX("IRXN"),"DAI",0)="^52.03^^" S ^PSRX(PSOX("IRXN"),"DAI",DAI,0)=^TMP("PSODAI",$J,DAI,0)
        ..S $P(^PSRX(PSOX("IRXN"),"DAI",0),"^",3)=+$P(^PSRX(PSOX("IRXN"),"DAI",0),"^",3)+1,$P(^(0),"^",4)=+$P(^(0),"^",4)+1
        .K ^TMP("PSODAI",$J),DAI
        I $G(PSOX("CHCS NUMBER"))'="" S $P(^PSRX(PSOX("IRXN"),"EXT"),"^")=$G(PSOX("CHCS NUMBER"))
        I $G(PSOX("EXTERNAL SYSTEM"))'="" S $P(^PSRX(PSOX("IRXN"),"EXT"),"^",2)=$G(PSOX("EXTERNAL SYSTEM"))
        I $G(PSOX("NEWCOPAY")) S ^PSRX(PSOX("IRXN"),"IB")=$G(PSOX("NEWCOPAY"))
        ;Next line, set SC question based on Copay status?
IBQ     ;I $G(PSOBILL)=2 S ^PSRX(PSOX("IRXN"),"IBQ")=$S($G(PSOX("NEWCOPAY")):0,1:1)
        ;Begin WorldVistA change; PSO*7*208
        I $G(PSOAFYN)="Y" S PSOSCP="" ;vfah
        ;End WorldVistA change
        N PSOSCFLD S PSOSCFLD=$S(PSOSCP'="":$G(PSOANSQ("SC")),1:"")_"^"_$G(PSOANSQ("MST"))_"^"_$G(PSOANSQ("VEH"))_"^"_$G(PSOANSQ("RAD"))_"^"_$G(PSOANSQ("PGW"))_"^"_$G(PSOANSQ("HNC"))_"^"_$G(PSOANSQ("CV"))_"^"_$G(PSOANSQ("SHAD"))
        I PSOSCP<50&($TR(PSOSCFLD,"^")'="")&($P($G(^PS(53,+$G(PSONEW("PATIENT STATUS")),0)),"^",7)'=1) D
        . S ^PSRX(PSOX("IRXN"),"IBQ")=PSOSCFLD K PSOSCFLD  ;don't set if SC % is null or 0, just set it in ICD node
        D ICD^PSODIAG
        D:$$SWSTAT^IBBAPI() GACT^PSOPFSU0(PSOX("IRXN"),0)
        K PSOANSQ,PSOANSQD,PSOX("NEWCOPAY")
        L -^PSRX("B",PSOX("IRXN"))
        Q
        ;
PS55    ;
        L +^PS(55,PSODFN,"P"):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3)
        S:'$D(^PS(55,PSODFN,"P",0)) ^(0)="^55.03PA^^"
        F PSOX1=$P(^PS(55,PSODFN,"P",0),"^",3):1 Q:'$D(^PS(55,PSODFN,"P",PSOX1))
        S PSOX("55 IEN")=PSOX1
        S ^PS(55,PSODFN,"P",PSOX1,0)=PSOX("IRXN"),$P(^PS(55,PSODFN,"P",0),"^",3,4)=PSOX1_"^"_($P(^PS(55,PSODFN,"P",0),"^",4)+1)
        S ^PS(55,PSODFN,"P","A",PSONEW("STOP DATE"),PSOX("IRXN"))=""
PS55X   L -^PS(55,PSODFN,"P")
        K PSOX1
        Q
DIK     ;
        I $D(^XUSEC("PSORPH",DUZ)) S DA=PSOX("IRXN"),DIE=52,DR="41////"_PSOCOU_";S:'X Y=""@1"";42////"_PSOCOUU_";@1" D ^DIE K DIE,DR
        K DIK,DA S DIK="^PSRX(",DA=PSOX("IRXN") D IX1^DIK K DIK
        S DA=PSOX("IRXN") D ORC^PSORN52C
        Q
FINISH  ;
ANQ     I $G(ANQDATA)]"" D NOW^%DTC G:$D(^PS(52.52,"B",%)) ANQ D
        .K DD,DO S DIC="^PS(52.52,",DIC(0)="L",DLAYGO=52.52,X=% D FILE^DICN K DIC,DLAYGO,DD,DO
        .S ^PS(52.52,+Y,0)=$P(Y,"^",2)_"^"_PSOX("IRXN")_"^"_ANQDATA,^PS(52.52,"A",PSOX("IRXN"),+Y)="" K ANQDATA,X,Y,%,ANQREM
        G:PSOX("STATUS")=4 FINISHP
        I $D(PSORX("VERIFY")) D  G FINISHX
        .K DIC,DLAYGO,DINUM,DIADD,X,DD,DO S DIC="^PS(52.4,",DLAYGO=52.4,DINUM=PSOX("IRXN"),DIC(0)="ML",X=PSOX("IRXN")
        .D FILE^DICN K DD,DO,DIC,DLAYGO,DINUM S ^PS(52.4,PSOX("IRXN"),0)=PSOX("IRXN")_"^"_PSODFN_"^"_DUZ_"^"_"^"_$E(PSOX("LOGIN DATE"),1,7)_"^"_PSOX("IRXN")_"^"_PSOX("STOP DATE")
        .K DIK,DA S DIK="^PS(52.4,",DA=PSOX("IRXN") D IX^DIK K DIK,DA
        ;
        I PSOX("FILL DATE")>DT,$P(PSOPAR,"^",6) S DA=PSOX("IRXN"),RXFL(PSOX("IRXN"))=0 D SUS^PSORXL K DA G FINISHX
        ;
        ; - Calling ECME for claims generation and transmission / REJECT handling
        N ACTION,PSOERX
        S PSOERX=PSOX("IRXN")
        I $$SUBMIT^PSOBPSUT(PSOERX,0) D  I ACTION="Q"!(ACTION="^") Q
        . S ACTION="" D ECMESND^PSOBPSU1(PSOERX,0,PSOX("FILL DATE"),"OF")
        . I $$FIND^PSOREJUT(PSOERX,0) D
        . . S ACTION=$$HDLG^PSOREJU1(PSOERX,0,"79,88","OF","IOQ","Q")
        . I $$STATUS^PSOBPSUT(PSOERX,0)="E PAYABLE" D
        . . D SAVNDC^PSSNDCUT(+$$GET1^DIQ(52,PSOERX,6,"I"),$G(PSOSITE),$$GETNDC^PSONDCUT(PSOERX,0))
        ;
FINISHP ;
        I $G(PSORX("PSOL",1))']"" S PSORX("PSOL",1)=PSOX("IRXN")_",",RXFL(PSOX("IRXN"))=0 G FINISHX
        F PSOX1=0:0 S PSOX1=$O(PSORX("PSOL",PSOX1)) Q:'PSOX1  S PSOX2=PSOX1
        I $L(PSORX("PSOL",PSOX2))+$L(PSOX("IRXN"))<220 S PSORX("PSOL",PSOX2)=PSORX("PSOL",PSOX2)_PSOX("IRXN")_","
        E  S PSORX("PSOL",PSOX2+1)=PSOX("IRXN")_","
        S RXFL(PSOX("IRXN"))=0
FINISHX ;call to build Rx array for bingo board
        I $G(PSORX("MAIL/WINDOW"))["W" S BINGCRT=1,BINGRTE="W",BBFLG=1 D BBRX^PSORN52C
        K PSOX1,PSOX2
        Q
EOJ     ;
        ;B xref locked in routine PSONRXN
        L -^PSRX("B",PSOX("IRXN")) K OTHDOS,DA,PSON52,PSOPRC,RTE,SCH,PSOX("INS"),PSONEW("INS"),PSORXED("INS"),PSONEW("ENT"),PSORXED("ENT"),OLENT
        D PSOUL^PSSLOCK(PSOX("IRXN"))
        Q
        ;
        ;;PSOX("SIG");;SIG;;1
DD      ;;PSOX("RX #");;0;;1
        ;;PSOX("ISSUE DATE");;0;;13
        ;;PSODFN;;0;;2
        ;;PSOX("PATIENT STATUS");;0;;3
        ;;PSOX("PROVIDER");;0;;4
        ;;PSOX("CLINIC");;0;;5
        ;;PSODRUG("IEN");;0;;6
        ;;PSODRUG("TRADE NAME");;TN;;1
        ;;PSOX("QTY");;0;;7
        ;;PSOX("DAYS SUPPLY");;0;;8
        ;;PSOX("# OF REFILLS");;0;;9
        ;;PSOX("COPIES");;0;;18
        ;;PSOX("MAIL/WINDOW");;0;;11
        ;;PSOX("REMARKS");;3;;7
        ;;PSOX("CLERK CODE");;0;;16
        ;;PSODRUG("COST");;0;;17
        ;;PSOSITE;;2;;9
        ;;PSOX("LOGIN DATE");;2;;1
        ;;PSOX("FILL DATE");;2;;2
        ;;PSOX("PHARMACIST");;2;;3
        ;;PSOX("LOT #");;2;;4
        ;;PSOX("DISPENSED DATE");;2;;5
        ;;PSOX("STOP DATE");;2;;6
        ;;PSODRUG("NDC");;2;;7
        ;;PSODRUG("DAW");;EPH;;1
        ;;PSODRUG("MANUFACTURER");;2;;8
        ;;PSOX("EXPIRATION DATE");;2;;11
        ;;PSOX("GENERIC PROVIDER");;2;;12
        ;;PSOX("RELEASED DATE/TIME");;2;;13
        ;;PSOX("METHOD OF PICK-UP");;MP;;1
        ;;PSOX("STATUS");;STA;;1
        ;;PSOX("LAST DISPENSED DATE");;3;;1
        ;;PSOX("NEXT POSSIBLE REFILL");;3;;2
        ;;PSOX("COSIGNING PROVIDER");;3;;3
        ;;PSOX("TYPE OF RX");;TYPE;;1
        ;;PSOX("SAND");;SAND;;1
        ;;PSOX("POE");;POE;;1
        ;;PSOX("INS");;INS;;1
