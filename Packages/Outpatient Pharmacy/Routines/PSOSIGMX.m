PSOSIGMX        ;BIR/RTR-Utility routine to calculate Max Refills for CPRS ; 7/25/07 11:17am
        ;;7.0;OUTPATIENT PHARMACY;**46,78,108,131,222,206**;DEC 1997;Build 39
        ;External reference to PS(55 supported by DBIA 2228
        ;External reference to PSDRUG( supported by DBIA 221
        ;External reference to YSCL(603.01 supported by DBIA 2697
        ;External reference to PS(50.7 supported by DBIA 2223
        ;
        ;PSOQX("PATIENT")=patient DFN
        ;PSOQX("DAYS SUPPLY")=Days Supply ->Optional ??
        ;PSOQX("DRUG")=File 50 ien ->Optional
        ;PSOQX("ITEM")=File 50.7 ien -> we may not use this
        ;PSOQX("DISCHARGE")=1 if the order is for a Discharge
        ;
        ;PSOQX("MAX")=Returned max refills allowed
        ;
EN      ;
        S PSOQX("MAX")=11
        N DFN,VAROOT,PSOWRF,PSOMXAUT,PSOMXAUX,PSOCDEA,PSOCSX,PSOMXRX,PSOMX1,PSODYX,PSODYX1,PSOMXPAT,PSOMXSTA
        S PSOMXAUT=0
        S PSOMXAUX=+$P($G(^PS(55,+$G(PSOQX("PATIENT")),"PS")),"^")
        I PSOMXAUX,$P($G(^PS(53,+$G(PSOMXAUX),0)),"^")["AUTH ABS" S VAROOT="PSOWRF",DFN=$G(PSOQX("PATIENT")) D IN5^VADPT I '$G(PSOWRF(5)) S PSOMXAUT=1
        S PSOMXSTA=$S($G(PSOQX("DISCHARGE")):0,$G(PSOMXAUT):0,1:+$P($G(^PS(55,+$G(PSOQX("PATIENT")),"PS")),"^")) I PSOMXSTA S PSOMXRX=$P($G(^PS(53,PSOMXSTA,0)),"^",4)
        I 'PSOMXSTA S PSOMXRX=11
        K PSOCDEA S PSOCSX=0
        S PSONODD=0 I '$G(PSOQX("DRUG")),$G(PSOQX("ITEM")) D  S PSONODD=1
        . N A,B,PSOCDEA,DEA,PSOAPP,PSOINA,%,%H,%I,X,PSOFIRST
        . S DEA=99,(A,PSOFIRST)=""
        . F  S A=$O(^PS(50.7,"A50",PSOQX("ITEM"),A)) Q:'A  D
        .. S PSOCDEA=$P($G(^PSDRUG(A,0)),"^",3),PSOAPP=$P($G(^(2)),"^",3),PSOINA=$G(^("I"))
        .. I PSOAPP'["O" Q
        .. D NOW^%DTC I PSOINA]"",PSOINA'>% Q
        .. I PSOFIRST="" S PSOFIRST=A
        .. I PSOCDEA?1N.E,PSOCDEA<DEA S DEA=PSOCDEA,PSOQX("DRUG")=A
        . I $G(PSOQX("DRUG"))="" S PSOQX("DRUG")=PSOFIRST
        I $G(PSOQX("DRUG")) D
        .S PSOCDEA=$P($G(^PSDRUG(PSOQX("DRUG"),0)),"^",3)
        .I PSOCDEA["2"!(PSOCDEA["3")!(PSOCDEA["4")!(PSOCDEA["5") S PSOCSX=1
        I PSOCSX D
        .S PSOQX("MAX")=$S((PSOCDEA[1)!(PSOCDEA[2):0,1:5),PSOMX1=$S($G(PSOMXRX)>PSOQX("MAX"):PSOQX("MAX"),1:$G(PSOMXRX)),PSOQX("MAX")=$S(PSOMX1=5:PSOQX("MAX"),1:PSOMX1)
        .S PSOQX("MAX")=$S('PSOQX("MAX"):0,$G(PSOQX("DAYS SUPPLY"))=90:1,1:PSOQX("MAX")),PSODYX=$G(PSOQX("DAYS SUPPLY")),PSODYX1=$S(PSODYX<60:5,PSODYX'<60&(PSODYX'>89):2,PSODYX=90:1,1:0) S PSOQX("MAX")=$S(PSOQX("MAX")'>PSODYX1:PSOQX("MAX"),1:PSODYX1)
        I 'PSOCSX!('$G(PSOQX("DRUG"))) D
        .S PSOQX("MAX")=11,PSOMX1=$S($G(PSOMXRX)>PSOQX("MAX"):PSOQX("MAX"),1:$G(PSOMXRX)),PSOQX("MAX")=$S(PSOMX1=11:PSOQX("MAX"),1:PSOMX1)
        .S PSODYX=$G(PSOQX("DAYS SUPPLY")),PSODYX1=$S(PSODYX<60:11,PSODYX'<60&(PSODYX'>89):5,PSODYX=90:3,1:0) S PSOQX("MAX")=$S(PSOQX("MAX")'>PSODYX1:PSOQX("MAX"),1:PSODYX1)
        I $P($G(^PSDRUG(+$G(PSOQX("DRUG")),"CLOZ1")),"^")="PSOCLO1" D  Q
        .S PSOMXPAT=$O(^YSCL(603.01,"C",+$G(PSOQX("PATIENT")),0)) I 'PSOMXPAT S PSOQX("MAX")=0 Q
        .S PSOMXPAT=$P($G(^YSCL(603.01,PSOMXPAT,0)),"^",3)
        .I $D(PSOQX("DAYS SUPPLY")) S PSOQX("MAX")=$S(PSOMXPAT="M"&($G(PSOQX("DAYS SUPPLY"))<8):3,PSOMXPAT="M"&($G(PSOQX("DAYS SUPPLY"))<15):1,PSOMXPAT="B"&($G(PSOQX("DAYS SUPPLY"))<8):1,1:0) Q
        .S PSOQX("MAX")=$S(PSOMXPAT="M":3,PSOMXPAT="B":1,1:0)
        I $G(PSOQX("DRUG")) I PSOCDEA["A"&(PSOCDEA'["B")!(PSOCDEA["F")!(PSOCDEA[1)!(PSOCDEA[2) S PSOQX("MAX")=0
        I PSONODD S PSOQX("DRUG")=0
        Q
