PSOHLSN ;BIR/RTR-Send order information to OERR from file 52.41 ;10/10/94
        ;;7.0;OUTPATIENT PHARMACY;**1,7,15,24,27,30,55,46,98,88,121,292**;DEC 1997;Build 1
        ;Externel reference EN^ORERR supported by DBIA 2187
        ;
        ; PS EVSEND OR PROTOCOL MUST BE OUR DRIVER RTN, (52 OR 52.41 INDICATOR
        ; IS SENT THERE, THEN IT ROUTES, (NO NEED TO SEND FILE NUMBER HERE)
EN(PLACER,STAT,COMM,PSNOO)      ;
        N DA,FIELD,J,JJ,MSG,LIMIT,NULLFLDS,PSIEN,PSOHINST,PSZERO,SEGMENT,NAME,DFN,COUNT,GG,CC,CT,MM,PVAR,PVAR1,PLIM,SEG1,SUBCOUNT,PSOPSTRT,PSOPSTOP,PSODFN,EDUZ,PSNOOTX,PSOHSTAT,PSOPSIEN
        S (PSIEN,PSOPSIEN)=$O(^PS(52.41,"B",PLACER,0))
        S COUNT=0
        ;I '$G(PSIEN) W !!,?5,"PROBLEM WITH ENTRY IN PENDING FILE!",! Q
        I '$G(PSIEN) Q
        I $G(STAT)="OC"!($G(STAT)="OD")!($G(STAT)="CR")!($G(STAT)="DR") D
        .D CHKOLDRX
        .I $D(^PS(52.41,PSIEN,0)) K ^PS(52.41,"AD",$P(^PS(52.41,PSIEN,0),"^",12),+$P($G(^("INI")),"^"),PSIEN),^PS(52.41,"ACL",+$P(^PS(52.41,PSIEN,0),"^",13),+$P(^(0),"^",12),PSIEN),^PS(52.41,"AQ",+$P($G(^PS(52.41,PSIEN,0)),"^",21),PSIEN)
        S PSZERO=$G(^PS(52.41,PSIEN,0)),PSOHSTAT=$G(STAT)
        S NULLFLDS="F JJ=0:1:LIMIT S FIELD(JJ)="""""
        D INIT
        I $G(STAT)="Z@" S COUNT=1 D PID,PV1,ORC,SEND Q
        S COUNT=1 D PID,PV1,ORC,RXE,ZRX,SEND,REN Q
INIT    K ^UTILITY("DIQ1",$J),DIQ S DA=$P($$SITE^VASITE(),"^") I $G(DA) S DIC=4,DIQ(0)="I",DR="99" D EN^DIQ1 S PSOHINST=$G(^UTILITY("DIQ1",$J,4,DA,99,"I")) K ^UTILITY("DIQ1",$J),DA,DR,DIQ,DIC
        S MSG(1)="MSH|^~\&|PHARMACY|"_$G(PSOHINST)_"|||||"_$S($G(PSOMSORR):"ORR",1:"ORM")
        Q
PID     S LIMIT=5 X NULLFLDS
        S FIELD(0)="PID"
        S DFN=+$P(PSZERO,"^",2) D DEM^VADPT S NAME=$G(VADM(1)) K VADM
        S FIELD(3)=DFN
        S FIELD(5)=NAME
        D SEG Q
PV1     S LIMIT=19 X NULLFLDS
        S FIELD(0)="PV1"
        S FIELD(2)="O"
        S:$P($G(^PS(52.41,PSIEN,0)),"^",13) FIELD(3)=$P(^(0),"^",13)
        D SEG Q
ORC     S LIMIT=15 X NULLFLDS
        S FIELD(0)="ORC"
        S FIELD(1)=STAT
        S FIELD(2)=PLACER_$S($G(PLACERXX):";"_PLACERXX,1:"")_"^OR"
        S FIELD(3)=PSIEN_"S"_"^PS"
        I $G(FIELD(5))="" I $G(STAT)="OR"!($G(STAT)="OE") S FIELD(5)="IP"
        S:$G(COMM)="IP" FIELD(5)="IP"
        I $G(STAT)="SC" S FIELD(5)=$S($G(COMM)="IP":"IP",$G(COMM)="HD":"HD",$G(COMM)="DC":"DC",1:"")
        I $G(PSORPV),$G(STAT)="OC" S FIELD(5)="RP"
        ;S (PSOPSTRT,PSOPSTOP)="" S X=$P($G(^PS(52.41,PSIEN,0)),"^",6) I X S PSOPSTRT=$$FMTHL7^XLFDT(X)
        ;I $G(STAT)="CR"!($G(STAT)="OC") D:'$G(DT)  S X=DT S PSOPSTOP=$$FMTHL7^XLFDT(X)
        ;.S DT=$$DT^XLFDT
        ;K X S FIELD(7)="^^^"_$G(PSOPSTRT)_"^"_$G(PSOPSTOP)
        S EDUZ=$P($G(^PS(52.41,PSIEN,0)),"^",4) I EDUZ D USER^PSOORFI2(EDUZ) S FIELD(10)=EDUZ_"^"_USER1 K USER1
        I $G(PSOCANRC),$G(PSOCANRN)'="" I $G(STAT)="OC"!($G(STAT)="OD") S FIELD(12)=$G(PSOCANRC)_"^"_$G(PSOCANRN)
        I '$G(FIELD(12)) D USER^PSOORFI2($P(^PS(52.41,PSIEN,0),"^",5))
        I '$G(FIELD(12)) S FIELD(12)=$P(^PS(52.41,PSIEN,0),"^",5)_"^"_USER1 K USER1
        S FIELD(15)=$G(PSOPSTRT)
        D SEG
        I $G(COMM)'=""!($G(PSNOO)'="") D
        .I $G(PSNOO)="" I $G(COMM)="IP"!($G(COMM)="HD")!($G(COMM)="DC") Q
        .I $G(PSNOO)'="" D NOO^PSOHLSN1
        .I '$D(COMM) S COMM=""
        .I $L($G(COMM))+($L(MSG(COUNT)))+($L($G(PSNOOTX)))+($S($G(PSNOO)'="":11,1:5))<245 S MSG(COUNT)=MSG(COUNT)_"|"_$G(PSNOO)_"^"_$G(PSNOOTX)_"^"_$S($G(PSNOO)'="":"99ORN",1:"")_"^^"_$S(COMM="IP"!(COMM="DC")!(COMM="HD"):"",1:$G(COMM))_"^" Q
        .S MSG(COUNT,1)="|"_$G(PSNOO)_"^"_$G(PSNOOTX)_"^"_$S($G(PSNOO)'="":"99ORN",1:"")_"^^"_$S(COMM="IP"!(COMM="DC")!(COMM="HD"):"",1:$G(COMM))_"^" Q
        Q
RXE     S LIMIT=1 X NULLFLDS
        S FIELD(0)="RXE"
        S (PSOPSTRT,PSOPSTOP)="" S X=$P($G(^PS(52.41,PSIEN,0)),"^",6) I X S PSOPSTRT=$$FMTHL7^XLFDT(X)
        I $G(STAT)="CR"!($G(STAT)="OC") D:'$G(DT)  S X=DT S PSOPSTOP=$$FMTHL7^XLFDT(X)
        .S DT=$$DT^XLFDT
        K X S FIELD(1)="^^^"_$G(PSOPSTRT)_"^"_$G(PSOPSTOP)
        D SEG Q
        ;
ZRX     ;
        ;Only send if DC is from an external system
        I $G(STAT)'="OC",$G(STAT)'="OD" Q
        I '$G(PSOHUIOR)!('$G(PSOCANRC)) Q
        I $P($G(^PS(52.41,PSIEN,"EXT")),"^")="" Q
        S LIMIT=5 X NULLFLDS
        S FIELD(0)="ZRX"
        S FIELD(5)=PSOCANRC_"^"_$P($G(^VA(200,PSOCANRC,0)),"^")_"^"_"99NP"
        D SEG
        Q
        ;
SEG     S SEGMENT="" F J=0:1:LIMIT S SEGMENT=$S(SEGMENT="":FIELD(J),1:SEGMENT_"|"_FIELD(J))
        S COUNT=COUNT+1,MSG(COUNT)=SEGMENT
        Q
SEND    D MSG^XQOR("PS EVSEND OR",.MSG)
        Q
        ;
SEGPAR  ;Parse out fields for sending segments to OERR that can be >245
        K PSOFIELD
        S COUNT=COUNT+1,CT=1,(PVAR,PVAR1)=""
        F MM=0:1:LIMIT S FIELD(MM)=$S(FIELD(MM)="":"|",1:FIELD(MM)_"|")
        I $L(FIELD(LIMIT))>1 S FIELD(LIMIT)=$E(FIELD(LIMIT),1,($L(FIELD(LIMIT))-1))
        F MM=0:1:LIMIT S SEG1=FIELD(MM) F CC=1:1:$L(SEG1) D  I $L(PVAR)=245 S PSOFIELD(CT)=PVAR,CT=CT+1,PVAR=""
        .S PVAR1=$E(SEG1,CC)
        .S PLIM=PVAR
        .S PVAR=$S(PVAR="":PVAR1,1:PVAR_PVAR1)
        I $G(PVAR)'="" S PSOFIELD(CT)=PVAR
        S MSG(COUNT)=PSOFIELD(1),SUBCOUNT=1 F GG=2:1 Q:'$D(PSOFIELD(GG))  S MSG(COUNT,SUBCOUNT)=PSOFIELD(GG),SUBCOUNT=SUBCOUNT+1
        K PSOFIELD
        Q
ERROR   ;Builds error message from PSOHLNEW, usually means we can't find order
        D EN^ORERR(COMM,.MSG)
        N MSG,PSOHINST
        S PSOMSORR=1 D INIT
        S MSG(2)=$G(PSERRPID)
        S MSG(3)=$G(PSERRPV1)
        S MSG(4)="ORC|"_$S($G(STAT)'="":$G(STAT),1:"DE")_"|"_PLACER_$S($G(PLACERXX):";"_PLACERXX,1:"")_"^OR"_"|"_$S($P($G(PSERRORC),"|",4)'="":$P(PSERRORC,"|",4),1:"")
        F EER=11,13 I $P($G(PSERRORC),"|",EER)'="" S $P(MSG(4),"|",EER)=$P($G(PSERRORC),"|",EER)
        I $G(COMM)'="" S $P(MSG(4),"|",17)="^^^^"_$G(COMM)
        D SEND K PSOMSORR Q
        ;
RERROR  ;
        F EER=0:0 S EER=$O(MSG(EER)) Q:'EER  S:$P(MSG(EER),"|")="PV1" PSERRPV1=MSG(EER) S:$P(MSG(EER),"|")="PID" PSERRPID=MSG(EER) S:$P(MSG(EER),"|")="ORC"&($G(PSERRORC)="") PSERRORC=MSG(EER)
        N MSG
        S PSOMSORR=1 D INIT
        S MSG(2)=$G(PSERRPID),MSG(3)=$G(PSERRPV1)
        S MSG(4)="ORC|"_$S($G(XOFLAGZ):"UX",1:"UA")_"|"_$G(PLACER)_$S($G(PLACERXX):";"_PLACERXX,1:"")_"^OR"_"|"_$S($P($G(PSERRORC),"|",4)'="":$P(PSERRORC,"|",4),1:"")
        F EER=11,13 I $P($G(PSERRORC),"|",EER)'="" S $P(MSG(4),"|",EER)=$P($G(PSERRORC),"|",EER)
        S $P(MSG(4),"|",17)="D^Duplicate^99ORN^^"_$S($G(XOFLAGZ):"Patient mismatch on previous order.",$G(NWFLAG):"Patient Mismatch on new CPRS order",$G(PSOXRP):"Patient mismatch on Renewal.",1:"Duplicate Renewal Request. Order rejected by Pharmacy.")
        I $G(PSOCVI) S $P(MSG(4),"|",17)="D^Duplicate^99ORN^^Order mismatch on Renewal."
        D SEND K PSOMSORR Q
        ;
DCP     ;
        K ^PS(52.41,"AOR",+$G(DFN),+$P($G(^PS(52.41,+$G(PREV),"INI")),"^"),+$G(PREV)) S $P(^PS(52.41,+$G(PREV),0),"^",3)="DE"
        S PSORPV=1 N PSOMSORR
        D EN^PSOHLSN(+$P($G(^PS(52.41,+$G(PREV),0)),"^"),"OC","","A")
        K PSORPV
        Q
REN     ;Update previous Rx on Cancel/Discontinue
        N RPREV,RENOC,RENOCP,RENSTA,PSOMSORR
        I $G(PSOHSTAT)'="OC",$G(PSOHSTAT)'="CR",$G(PSOHSTAT)'="DR",$G(PSOHSTAT)'="OD" Q
        Q:'$D(^PS(52.41,+$G(PSOPSIEN),0))
        S RPREV=$P($G(^PS(52.41,+$G(PSOPSIEN),0)),"^",21) Q:'$G(RPREV)!('$D(^PSRX(+$G(RPREV),0)))
        S RENSTA=$P($G(^PSRX(+$G(RPREV),"STA")),"^") Q:$G(RENSTA)=""
        S RENOC="SC",RENOCP=$S(RENSTA=0:"CM",(RENSTA=1!(RENSTA=4)):"IP",(RENSTA=3!(RENSTA=16)):"HD",RENSTA=5:"ZS",RENSTA=11:"ZE",RENSTA=15:"RP",1:"DC")
        D EN^PSOHLSN1(RPREV,RENOC,RENOCP,"","")
        Q
        ;
DELP    ;Delete refill requests
        I $G(PSODEATH) Q
        N DA,PENDDA
        S PENDDA=$P($G(^PSRX(+$G(PSRXIEN),"OR1")),"^",2) I 'PENDDA Q
        S DA=$O(^PS(52.41,"B",PENDDA,0)) I '$G(DA) Q
        I $P($G(^PS(52.41,DA,0)),"^",3)="RF" S DIK="^PS(52.41," D ^DIK K DIK
        Q
SEGPARX ;
        N PSOFIELD
        S COUNT=COUNT+1,CT=1,(PVAR,PVAR1)=""
        F MM=0:1:LIMIT I MM'=1 S FIELD(MM)=$S(FIELD(MM)="":"|",1:FIELD(MM)_"|")
        F MM=0:0 S MM=$O(FIELD(1,MM)) I '$O(FIELD(1,MM)) S FIELD(1,MM)=$S(FIELD(1,MM)="":"|",1:FIELD(1,MM)_"|") Q
        I $L(FIELD(LIMIT))>1 S FIELD(LIMIT)=$E(FIELD(LIMIT),1,($L(FIELD(LIMIT))-1))
        F MM=0:1:LIMIT S SEG1=FIELD(MM) D:MM=1 SEGXX I MM'=1 F CC=1:1:$L(SEG1) D  I $L(PVAR)=245 S PSOFIELD(CT)=PVAR,CT=CT+1,PVAR=""
        .S PVAR1=$E(SEG1,CC)
        .S PLIM=PVAR
        .S PVAR=$S(PVAR="":PVAR1,1:PVAR_PVAR1)
        I $G(PVAR)'="" S PSOFIELD(CT)=PVAR
        S MSG(COUNT)=PSOFIELD(1),SUBCOUNT=1 F GG=2:1 Q:'$D(PSOFIELD(GG))  S MSG(COUNT,SUBCOUNT)=PSOFIELD(GG),SUBCOUNT=SUBCOUNT+1
        Q
SEGXX   ;
        N MMZ F MMZ=0:0 S MMZ=$O(FIELD(MM,MMZ)) Q:'MMZ  S SEG1=FIELD(MM,MMZ) F CC=1:1:$L(SEG1) D  I $L(PVAR)=245 S PSOFIELD(CT)=PVAR,CT=CT+1,PVAR=""
        .S PVAR1=$E(SEG1,CC)
        .S PLIM=PVAR
        .S PVAR=$S(PVAR="":PVAR1,1:PVAR_PVAR1)
        Q
CHKOLDRX        ; when dc a pending renewal - if prior Rx is expired, set piece 19 to 1 so will update CPRS from 'renewed' to 'expired' in PSOHLSN1
        N PSOOLD
        S PSOOLD=$P($G(^PS(52.41,PSIEN,0)),"^",21)
        I PSOOLD'="",$P($G(^PSRX(PSOOLD,"STA")),"^")=11 S $P(^PSRX(PSOOLD,0),"^",19)=1
        Q
