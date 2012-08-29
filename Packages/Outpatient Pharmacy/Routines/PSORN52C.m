PSORN52C        ;BIR/SAB-files renewal entries con't ;08/09/93
        ;;7.0;OUTPATIENT PHARMACY;**1,7,11,27,46,75,87,100,111,124,117,131,146,148,200,225**;DEC 1997;Build 29
        ;External references PSOL and PSOUL^PSSLOCK supported by DBIA 2789
        S DIC="^PSRX(",DLAYGO=52,DIC(0)="L",X=PSOX("NRX #") K DD,DO
        D FILE^DICN S PSOX("IRXN")=+Y K DLAYGO,X,Y,DIC,DD,DO
        D:+$G(DGI) TECH^PSODGDGI ; L +^PSRX(PSOX("IRXN")):0
        D:$G(^TMP("PSODAI",$J,0))
        .S $P(^PSRX(PSOX("IRXN"),3),"^",6)=1
        .I $O(^TMP("PSODAI",$J,0)) S DAI=0 F  S DAI=$O(^TMP("PSODAI",$J,DAI)) Q:'DAI  D
        ..S:'$D(^PSRX(PSOX("IRXN"),"DAI",0)) ^PSRX(PSOX("IRXN"),"DAI",0)="^52.03^^" S ^PSRX(PSOX("IRXN"),"DAI",DAI,0)=^TMP("PSODAI",$J,DAI,0)
        ..S $P(^PSRX(PSOX("IRXN"),"DAI",0),"^",3)=+$P(^PSRX(PSOX("IRXN"),"DAI",0),"^",3)+1,$P(^(0),"^",4)=+$P(^(0),"^",4)+1
        .K ^TMP("PSODAI",$J),DAI
        S PSORN52(PSOX("IRXN"),0)=PSOX("NRX0"),PSORN52(PSOX("IRXN"),2)=PSOX("NRX2"),PSORN52(PSOX("IRXN"),3)=PSOX("NRX3")
        S PSORN52(PSOX("IRXN"),"EPH")=PSOX("EPH")
        S:'$G(PSOX("ENT")) PSORN52(PSOX("IRXN"),"SIG")=PSOX("SIG")
        S PSORN52(PSOX("IRXN"),"STA")=PSOX("STA")
        S:$G(PSOX("TN"))]"" PSORN52(PSOX("IRXN"),"TN")=PSOX("TN")
        I $G(PSOX("METHOD OF PICK-UP"))]"",PSOX("FILL DATE")'>DT S PSORN52(PSOX("IRXN"),"MP")=PSOX("METHOD OF PICK-UP")
        S PSORN52(PSOX("IRXN"),"TYPE")=0
        S PSOX1="" F  S PSOX1=$O(PSORN52(PSOX("IRXN"),PSOX1)) Q:PSOX1=""  S ^PSRX(PSOX("IRXN"),PSOX1)=$G(PSORN52(PSOX("IRXN"),PSOX1))
        I $O(SIG(0)) D  G ENT
        .S II=0 F I=0:0 S I=$O(SIG(I)) Q:'I  S ^PSRX(PSOX("IRXN"),"SIG1",I,0)=SIG(I),II=II+1
        .S ^PSRX(PSOX("IRXN"),"SIG1",0)="^52.04A^"_II_"^"_II,$P(^PSRX(PSOX("IRXN"),"SIG"),"^",2)=1 K I,II
        .S $P(^PSRX(PSOX("IRXN"),"SIG"),"^",2)=1
ENT     S ^PSRX(PSOX("IRXN"),"POE")=1,^PSRX(PSOX("IRXN"),"INS")=$G(PSOX("INS"))
        I $G(OR0) S:$P(OR0,"^",24) ^PSRX(PSOX("IRXN"),"PKI")=1
        I $G(PSOX("SIG",1))]"",'$O(PSOX("SIG",1)) S ^PSRX(PSOX("IRXN"),"INS1",1,0)=PSOX("SIG",1),^PSRX(PSOX("IRXN"),"INS1",0)="^52.0115^1^1^"_DT_"^^"
        I $O(^PSRX(PSOX("OIRXN"),"INS1",0)) D
        .F D=0:0 S D=$O(^PSRX(PSOX("OIRXN"),"INS1",D)) Q:'D  S ^PSRX(PSOX("IRXN"),"INS1",D,0)=^PSRX(PSOX("OIRXN"),"INS1",D,0)
        .S ^PSRX(PSOX("IRXN"),"INS1",0)=^PSRX(PSOX("OIRXN"),"INS1",0)
TNT     F I=1:1:PSOX("ENT") S ^PSRX(PSOX("IRXN"),6,I,0)=PSOX("DOSE",I)_"^"_$G(PSOX("DOSE ORDERED",I))_"^"_$G(PSOX("UNITS",I))_"^"_$G(PSOX("NOUN",I))_"^" D
        .S ^PSRX(PSOX("IRXN"),6,I,0)=^PSRX(PSOX("IRXN"),6,I,0)_$G(PSOX("DURATION",I))_"^"_$G(PSOX("CONJUNCTION",I))_"^"_$G(PSOX("ROUTE",I))_"^"_$G(PSOX("SCHEDULE",I))_"^"_$G(PSOX("VERB",I))
        .I $G(PSOX("ODOSE",I))]"" S ^PSRX(PSOX("IRXN"),6,I,1)=PSOX("ODOSE",I)
        S:$G(PSOX("ENT")) ^PSRX(PSOX("IRXN"),6,0)="^52.0113^"_PSOX("ENT")_"^"_PSOX("ENT")
        Q
ORC     ;
        D MARK^PSOTPCAN
        K PSORDEDT,GG,PSOHD,PSOID,PTST,PTDY,PTRF,RFCNT,RN,SEG1,SIG,SIGOK,DIC
        K ST0,STA,STP,STR,JJ,LSI,MM,ORDG,ORIG,PHARMST,PSCAN,PSCNT,PSOI,GMRAL,DIC,DIE,HDR,IEN,NAME D KVA^VADPT
        I $G(PSOFDR) D 
        .I $G(PKI1)=1,$G(PKIR)]"" D ACT^PSOPKIV1(PSOX("IRXN"))
        .S $P(^PSRX(PSOX("IRXN"),"OR1"),"^",2)=$P(OR0,"^"),^PSRX("APL",$P(OR0,"^"),PSOX("IRXN"))=""
        .I $P($G(^PS(52.41,+$G(ORD),"EXT")),"^")="" I $G(PSOSIGFL)!($G(PSODRUG("OI"))'=$P(OR0,"^",8)) K:'$G(PSOPRC) PRC K PHI
        .I $O(PRC(0)) S T=0 F  S T=$O(PRC(T)) Q:'T  S ^PSRX(PSOX("IRXN"),"PRC",T,0)=PRC(T),^PSRX(PSOX("IRXN"),"PRC",0)="^^"_T_"^"_T_"^"_DT_"^"
        .I $O(PHI(0)) S T=0 F  S T=$O(PHI(T)) Q:'T  S ^PSRX(PSOX("IRXN"),"PI",T,0)=PHI(T),^PSRX(PSOX("IRXN"),"PI",0)="^^"_T_"^"_T_"^"_DT_"^"
        .I $G(PSOSIGFL)!($G(PSODRUG("OI"))'=$P(OR0,"^",8)) D  S PSOI=1 Q
        ..S POERR("PLACER")=$P(^PS(52.41,ORD,0),"^"),PSORDEDT=ORD
        ..K ^PS(52.41,"AOR",PSODFN,+$P($G(^PS(52.41,ORD,"INI")),"^"),ORD)
        ..S DA=ORD,DIK="^PS(52.41," D ^DIK
        ..S $P(^PSRX(PSOX("IRXN"),"OR1"),"^")=$G(PSODRUG("OI"))
        .E  S $P(^PSRX(PSOX("IRXN"),"OR1"),"^")=$P(OR0,"^",8)
        .D PSOUL^PSSLOCK(ORD_"S") S DIK="^PS(52.41,",DA=ORD D ^DIK K DIK,DA
        I $G(PSOX("OIRXN")),'$G(COPY) S $P(^PSRX(PSOX("IRXN"),"OR1"),"^",3)=PSOX("OIRXN"),$P(^PSRX(PSOX("OIRXN"),"OR1"),"^",4)=PSOX("IRXN"),^PSRX("AQ",PSOX("IRXN"),PSOX("OIRXN"))="" K PRC
        I $O(PRC(0)) S T=0 F  S T=$O(PRC(T)) Q:'T  S ^PSRX(PSOX("IRXN"),"PRC",T,0)=PRC(T),^PSRX(PSOX("IRXN"),"PRC",0)="^^"_T_"^"_T_"^"_DT_"^"
        I $O(PHI(0)) S T=0 F  S T=$O(PHI(T)) Q:'T  S ^PSRX(PSOX("IRXN"),"PI",T,0)=PHI(T),^PSRX(PSOX("IRXN"),"PI",0)="^^"_T_"^"_T_"^"_DT_"^"
        S $P(^PSRX(PSOX("IRXN"),"OR1"),"^",5)=DUZ
        S $P(^PSRX(PSOX("IRXN"),"OR1"),"^",8)=$$NOW^XLFDT D
        . N DA,DIK S DA=PSOX("IRXN"),DIK="^PSRX(",DIK(1)=38.3 D EN1^DIK K DIK,DA
        S PHARMST="",$P(^PSRX(PSOX("IRXN"),"OR1"),"^")=$G(PSODRUG("OI"))
        S RXN=PSOX("IRXN") D SAVE
        S STAT=$S($G(OR0)]""&('$G(PSOI)):"SC",$G(PSOI):"RO",1:"SN") S PHARMST=$S('$G(PSORX("VERIFY")):"CM",1:"IP") ;D EN^PSOHLSN1(RXN,STAT,PHARMST,"",PSONOOR)
        S ^TMP("PSORXN",$J,RXN)=STAT_"^"_PHARMST_"^"_PSONOOR D PSOL^PSSLOCK(RXN)
        D RESTORE K PSORDEDT,PHI,PRC,STAT,COMM,PSOI,OR2,OR1,PHARMST,RXN,DRG,STA,ACT,OCXR,OCXD1,OCXDT,OCXI
        Q
BBRX    ;build bingo board Rx array; called by PSON52,PSOR52,PSORN52
        I $G(BBRX(1))']"" S BBRX(1)=PSOX("IRXN")_"," Q
        F PSOX1=0:0 S PSOX1=$O(BBRX(PSOX1)) Q:'PSOX1  S PSOX2=PSOX1
        I $L(BBRX(PSOX2))+$L(PSOX("IRXN"))<220 S BBRX(PSOX2)=BBRX(PSOX2)_PSOX("IRXN")_","
        E  S BBRX(PSOX2+1)=PSOX("IRXN")_","
        Q
SAVE    ;this module will be used to save PSO arrays
        K ^TMP("PSOLST",$J) F I=0:0 S I=$O(PSOLST(I)) Q:'I  S ^TMP("PSOLST",$J,I,0)=PSOLST(I)
        K ^TMP("PSOSD",$J) S (STA,DRG)="" F  S STA=$O(PSOSD(STA)) Q:STA=""  F  S DRG=$O(PSOSD(STA,DRG)) Q:DRG=""  S ^TMP("PSOSD",$J,STA,DRG)=PSOSD(STA,DRG)
        I $G(PSOSD) S ^TMP("PSOSD",$J,0)=PSOSD
        I $G(PSODRUG("NAME"))]"" K ^TMP("PSODRUG",$J) S STA=""  F  S STA=$O(PSODRUG(STA)) Q:STA=""  S ^TMP("PSODRUG",$J,STA)=PSODRUG(STA)
        I $G(PSOX("# OF REFILLS"))]"" K ^TMP("PSOX",$J),^TMP("PSORENW",$J),^TMP("PSONEW",$J),^TMP("PSORXED",$J) D
        .S STA="" F  S STA=$O(PSOX(STA)) Q:STA=""  S ^TMP("PSOX",$J,STA)=$G(PSOX(STA)) D
        ..I STA="OLD LAST RX#",$O(PSOX(STA,"")) K ^TMP("PSOX",$J,STA) S ^TMP("PSOX",$J,STA,$O(PSOX(STA,"")))=PSOX(STA,$O(PSOX(STA,""))) D  Q
        ...I $O(PSONEW(STA,"")) S ^TMP("PSONEW",$J,STA,$O(PSONEW(STA,"")))=PSONEW(STA,$O(PSONEW(STA,"")))
        ...I $O(PSORENW(STA,"")) S ^TMP("PSORENW",$J,STA,$O(PSORENW(STA,"")))=PSORENW(STA,$O(PSORENW(STA,"")))
        ...I $O(PSORXED(STA,"")) S ^TMP("PSORXED",$J,STA,$O(PSORXED(STA,"")))=PSORXED(STA,$O(PSORXED(STA,"")))
        ..F ACT="PSORENW","PSONEW","PSORXED" I $G(@(ACT_"("""_STA_""")"))]"" S ^TMP(ACT,$J,STA)=@(ACT_"("""_STA_""")")
        K PSOPTPST,PSOSD,PSONEW,PSOLST,PSORENW,PSORXED,PSODRUG
        Q
RESTORE ;this module restore saved arrays
        S STA=0 F  S STA=$O(^TMP("PSOLST",$J,STA)) Q:'STA  S PSOLST(STA)=^TMP("PSOLST",$J,STA,0)
        I $G(^TMP("PSOSD",$J,0)) S PSOSD=$G(^TMP("PSOSD",$J,0))
        S (STA,DRG)="" F  S STA=$O(^TMP("PSOSD",$J,STA)) Q:STA=""  F  S DRG=$O(^TMP("PSOSD",$J,STA,DRG)) Q:DRG=""  S PSOSD(STA,DRG)=^TMP("PSOSD",$J,STA,DRG)
        S STA="" F  S STA=$O(^TMP("PSODRUG",$J,STA)) Q:STA=""  S PSODRUG(STA)=^TMP("PSODRUG",$J,STA)
        S STA="" F ACT="PSOX","PSORENW","PSONEW","PSORXED" D:$O(^TMP(ACT,$J,STA))]""
        .F  S STA=$O(^TMP(ACT,$J,STA)) Q:STA=""  I STA'="OLD LAST RX#" S @(ACT_"("""_STA_""")")=^TMP(ACT,$J,STA)
        I $O(^TMP("PSOX",$J,"OLD LAST RX#","")) S PSOX("OLD LAST RX#",$O(^TMP("PSOX",$J,"OLD LAST RX#","")))=^TMP("PSOX",$J,"OLD LAST RX#",$O(^TMP("PSOX",$J,"OLD LAST RX#","")))
        I $O(^TMP("PSONEW",$J,"OLD LAST RX#","")) S PSONEW("OLD LAST RX#",$O(^TMP("PSONEW",$J,"OLD LAST RX#","")))=^TMP("PSONEW",$J,"OLD LAST RX#",$O(^TMP("PSONEW",$J,"OLD LAST RX#","")))
        I $O(^TMP("PSORENW",$J,"OLD LAST RX#","")) S PSORENW("OLD LAST RX#",$O(^TMP("PSORENW",$J,"OLD LAST RX#","")))=^TMP("PSORENW",$J,"OLD LAST RX#",$O(^TMP("PSORENW",$J,"OLD LAST RX#","")))
        I $O(^TMP("PSORXED",$J,"OLD LAST RX#","")) S PSORXED("OLD LAST RX#",$O(^TMP("PSORXED",$J,"OLD LAST RX#","")))=^TMP("PSORXED",$J,"OLD LAST RX#",$O(^TMP("PSORXED",$J,"OLD LAST RX#","")))
        K ^TMP("PSOSD",$J),^TMP("PSODRUG",$J),^TMP("PSOX",$J),^TMP("PSORENW",$J),^TMP("PSONEW",$J),^TMP("PSORXED",$J),^TMP("PSOLST",$J)
        Q
