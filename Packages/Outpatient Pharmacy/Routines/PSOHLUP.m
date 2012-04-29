PSOHLUP ;BIR/RTR-Backfill OERR from Pharmacy ;7/20/96
        ;;7.0;OUTPATIENT PHARMACY;**5,225**;DEC 1997;Build 29
        ;
        ;Pass in patient DFN
EN(PSOEDFN)     ;
INPT    N PSOC
        ;S PSOSHH=$$OTF^OR3CONV(PSOEDFN,$S($G(PSOLOUD):0,1:1))
        Q
EN2     ;
        I '$P($G(^PS(55,PSOEDFN,0)),"^",6) D UPD S $P(^PS(55,PSOEDFN,0),"^",6)=1
        Q:'$D(^PS(55,+PSOEDFN,0))!('$G(PSOEDFN))
        Q:$P($G(^PS(55,PSOEDFN,0)),"^",6)=2
        N C,Y,DA,IFN,RXP,DFN,PAT,PSODFN,PSOPPQ,PSOPPQR,PSOYEAR,PSOEST,PSOERSTA,PSOPHSTA,X,T,PRU,PSOCV,PTFLAG,III
        ;W:$G(PSOEWRT) !!,"Please wait. Updating CPRS with patient's Outpatient Meds."
        ;F PSOCV=0:0 S PSOCV=$O(^PS(55,PSOEDFN,"P","A",PSOCV)) Q:'PSOCV  F PSOPPQR=0:0 S PSOPPQR=$O(^PS(55,PSOEDFN,"P","A",PSOCV,PSOPPQR)) Q:'PSOPPQR  D UPD
        S X1=DT,X2=-121 D C^%DTC S PSOYEAR=X
        F PSOPPQ=PSOYEAR:0 S PSOPPQ=$O(^PS(55,PSOEDFN,"P","A",PSOPPQ)) Q:'PSOPPQ  F PSOPPQR=0:0 S PSOPPQR=$O(^PS(55,PSOEDFN,"P","A",PSOPPQ,PSOPPQR)) Q:'PSOPPQR  D PAT D:$D(^PSRX(PSOPPQR,0))&('$P($G(^PSRX(PSOPPQR,"OR1")),"^",2))&('$G(PTFLAG))
        .Q:'$P($G(^PSRX(PSOPPQR,0)),"^",2)
        .S PSOEST=$S($D(^PSRX(PSOPPQR,"STA")):$P($G(^PSRX(PSOPPQR,"STA")),"^"),1:$P($G(^PSRX(PSOPPQR,0)),"^",15)) Q:PSOEST=10!(PSOEST=13)!(PSOEST=16)!(PSOEST=14)
        .D:'$P($G(^PSRX(PSOPPQR,0)),"^",19)
        ..D:'$P($G(^PSRX(PSOPPQR,"SIG")),"^",2) POP^PSOSIGNO(PSOPPQR)
        ..I $P($G(^PSRX(PSOPPQR,"OR1")),"^")']"",+$G(^PSDRUG(+$P(^PSRX(PSOPPQR,0),"^",6),2)) S $P(^PSRX(PSOPPQR,"OR1"),"^")=+$G(^PSDRUG($P(^PSRX(PSOPPQR,0),"^",6),2))
        ..I $G(^PSRX(PSOPPQR,"SIG"))']"" S ^PSRX(PSOPPQR,"SIG")=$P($G(^PSRX(PSOPPQR,0)),"^",10)_"^"_0 S $P(^PSRX(PSOPPQR,0),"^",10)=""
        ..S ^PSRX(PSOPPQR,"STA")=$P($G(^PSRX(PSOPPQR,0)),"^",15) S $P(^PSRX(PSOPPQR,0),"^",15)=""
        ..S PR=0 F  S PR=$O(^PSRX(PSOPPQR,"P",PR)) Q:'PR  D
        ...I '$P($G(^PSRX(PSOPPQR,"P",PR,0)),"^") K ^PSRX(PSOPPQR,"P",PR,0) Q
        ...S ^PSRX("ADP",$E($P(^PSRX(PSOPPQR,"P",PR,0),"^"),1,7),PSOPPQR,PR)=""
        ..S $P(^PSRX(PSOPPQR,0),"^",19)=1
        .W:$G(PSOEWRT) "." D EN^PSOHLSN1(PSOPPQR,"ZC","")
        .Q:'$P($G(^PSRX(PSOPPQR,"OR1")),"^",2)
        .S PSOEST=$P($G(^PSRX(PSOPPQR,"STA")),"^")
        .I +$P($G(^PSRX(PSOPPQR,2)),"^",6),$P($G(^(2)),"^",6)<DT S $P(^PSRX(PSOPPQR,"STA"),"^")=11 D ECAN^PSOUTL(PSOPPQR) S PSOEST=11
        .S PSOERSTA=$S(PSOEST=3:"OH",PSOEST=12:"OD",PSOEST=15:"OD",1:"SC"),PSOPHSTA=$S(PSOEST=0:"CM",PSOEST=1:"IP",PSOEST=4:"IP",PSOEST=5:"ZS",PSOEST=11:"ZE",1:"")
        .D EN^PSOHLSN1(PSOPPQR,PSOERSTA,PSOPHSTA,"")
        S $P(^PS(55,PSOEDFN,0),"^",6)=2
        ;W !,"Finished backfilling!",!
        Q
EN1(PSOEDFN,PSOEWRT)    N PSOBCK
        Q:'$G(PSOEDFN)
        S X1=DT,X2=-121 D C^%DTC S PSOYEAR=X
        I $O(^PS(55,PSOEDFN,"P","A",PSOYEAR)) D:'$D(^PS(55,PSOEDFN,0)) ADD(PSOEDFN) D EN2 G INPAT
        D:'$D(^PS(55,PSOEDFN,0))&($D(^PS(55,PSOEDFN))) ADD(PSOEDFN) S:$D(^PS(55,PSOEDFN,0)) $P(^PS(55,PSOEDFN,0),"^",6)=2
INPAT   S X="PSJUTL1" X ^%ZOSF("TEST") I $T D CONVERT^PSJUTL1(PSOEDFN,PSOEWRT)
        Q
UPD     ;Update OERR if not done yet
        N PSLOOP,PSOPPQR
        F PSLOOP=0:0 S PSLOOP=$O(^PS(55,PSOEDFN,"P","A",PSLOOP)) Q:'PSLOOP  F PSOPPQR=0:0 S PSOPPQR=$O(^PS(55,PSOEDFN,"P","A",PSLOOP,PSOPPQR)) Q:'PSOPPQR  D
        .Q:$G(^PSRX(PSOPPQR,0))=""!('$P($G(^PSRX(PSOPPQR,0)),"^",2))
        .Q:$P(^PSRX(PSOPPQR,0),"^",19)
        .D:'$P($G(^PSRX(PSOPPQR,"SIG")),"^",2) POP^PSOSIGNO(PSOPPQR)
        .I $P($G(^PSRX(PSOPPQR,"OR1")),"^")']"",+$G(^PSDRUG(+$P(^PSRX(PSOPPQR,0),"^",6),2)) S $P(^PSRX(PSOPPQR,"OR1"),"^")=+$G(^PSDRUG($P(^PSRX(PSOPPQR,0),"^",6),2))
        .I $G(^PSRX(PSOPPQR,"SIG"))']"" S ^PSRX(PSOPPQR,"SIG")=$P($G(^PSRX(PSOPPQR,0)),"^",10)_"^"_0 S $P(^PSRX(PSOPPQR,0),"^",10)=""
        .I $G(^PSRX(PSOPPQR,"STA"))']"" S ^PSRX(PSOPPQR,"STA")=$P($G(^PSRX(PSOPPQR,0)),"^",15) S $P(^PSRX(PSOPPQR,0),"^",15)=""
        .S PRU=0 F  S PRU=$O(^PSRX(PSOPPQR,"P",PRU)) Q:'PRU  D
        ..I '$P($G(^PSRX(PSOPPQR,"P",PRU,0)),"^") K ^PSRX(PSOPPQR,"P",PRU,0) Q
        ..S ^PSRX("ADP",$E($P(^PSRX(PSOPPQR,"P",PRU,0),"^"),1,7),PSOPPQR,PRU)=""
        .S $P(^PSRX(PSOPPQR,0),"^",19)=1
        Q
PAT     ;Check for correct patient
        S PTFLAG=0
        Q:PSOEDFN=$P($G(^PSRX(PSOPPQR,0)),"^",2)
        S PTFLAG=1
        K ^PS(55,PSOEDFN,"P","A",PSOPPQ,PSOPPQR)
        F III=0:0 S III=$O(^PS(55,PSOEDFN,"P",III)) Q:'III  I $G(^PS(55,PSOEDFN,"P",III,0))=PSOPPQR K ^PS(55,PSOEDFN,"P",III,0)
        Q
ADD(PATIEN)     ;Add patient to 55 (0 node)
        Q:$D(^PS(55,PATIEN,0))
        N X,Y,DA,DIK
        S ^PS(55,PATIEN,0)=PATIEN K DIK S DA=PATIEN,DIK="^PS(55,",DIK(1)=.01 D EN^DIK
        Q
