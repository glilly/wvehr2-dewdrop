PSOHLSN3        ;BIR/SJA - Send order info to OERR from file 52 ;10/05/06
        ;;7.0;OUTPATIENT PHARMACY;**225**;DEC 1997;Build 29
        ;
ORC     ; Called from PSOHLSN1 due to it's routine size.
        S LIMIT=15 X NULLFLDS
        S FIELD(0)="ORC"
        S FIELD(1)=$G(STAT)
        I $G(STAT)'="SN",$G(STAT)'="ZC" S FIELD(2)=$P($G(^PSRX(PSRXIEN,"OR1")),"^",2)
        S:FIELD(2)'="" FIELD(2)=FIELD(2)_$S($G(PLACERXX):";"_PLACERXX,1:"")_"^OR"
        S FIELD(3)=PSRXIEN_"^PS"
        S FIELD(5)=$G(PSSTAT)
        I $G(STAT)="RO",$G(PSOROPCH)'="PATCH" S FIELD(5)="CM"
        I $G(FIELD(5))="" I $G(STAT)="OR"!($G(STAT)="OE") S FIELD(5)="CM"
        S X=$P($G(^PSRX(PSRXIEN,2)),"^") I X S FIELD(9)=$$FMTHL7^XLFDT(X)
        S EDUZ=$P($G(^PSRX(PSRXIEN,0)),"^",16) I EDUZ S FIELD(10)=EDUZ_"^"_$P($G(^VA(200,EDUZ,0)),"^")
        I $G(PSOCANRC),$G(PSOCANRN)'="" I $G(STAT)="OD"!($G(STAT)="OC") S FIELD(12)=$G(PSOCANRC)_"^"_$G(PSOCANRN)
        I '$G(FIELD(12)) S FIELD(12)=$P($G(^PSRX(PSRXIEN,0)),"^",4)_"^"_$P($G(^VA(200,+$P($G(^PSRX(PSRXIEN,0)),"^",4),0)),"^")
        S PSOHISSD="",X=$P($G(^PSRX(PSRXIEN,0)),"^",13) I X S PSOHISSD=$$FMTHL7^XLFDT(X)
        S FIELD(15)=$G(PSOHISSD) K X
        D SEG^PSOHLSN1
        I $G(COMM)'=""!($G(PSNOO)'="") D
        .I $G(PSNOO)'="" D NOO^PSOHLSN1
        .I $L($G(COMM))+($L(MSG(COUNT)))+($L($G(PSNOOTX)))+($S($G(PSNOO)'="":11,1:5))<245 S MSG(COUNT)=MSG(COUNT)_"|"_$G(PSNOO)_"^"_$G(PSNOOTX)_"^"_$S($G(PSNOO)'="":"99ORN",1:"")_"^^"_$G(COMM)_"^" Q
        .S MSG(COUNT,1)="|"_$G(PSNOO)_"^"_$G(PSNOOTX)_"^"_$S($G(PSNOO)'="":"99ORN",1:"")_"^^"_$G(COMM)_"^"
        Q
