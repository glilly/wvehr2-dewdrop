PSOHLNE2        ;BIR/RTR-Parsing out more OERR segments ;1/20/95
        ;;7.0;OUTPATIENT PHARMACY;**1,7,59,46,225**;DEC 1997;Build 29
        ;External reference to DG(40.8 supported by DBIA 728
        ;External reference to PS(50.606 supported by DBIA 2174
        ;External reference to PS(50.7 supported by DBIA 2223
        ;External reference to PSDRUG( supported by DBIA 221
        ;External reference to PS(55 supported by DBIA 2228
        ;External reference to SC( supported by DBIA 2675
        ;
EN      ;RXO segment on new orders with multiple subscripts
        S (POVAR,POVAR1)="",(NNN,NNNN)=0,PSOIII=1,MSG(ZZ,0)=$E(MSG(ZZ),5,$L(MSG(ZZ)))
        S AAA="" F  S AAA=$O(MSG(ZZ,AAA)) Q:AAA=""  S NNN=0 F OOO=1:1:$L(MSG(ZZ,AAA)) S NNN=NNN+1 D  D:$G(POVAR1)="|" PARSE
        .I $E(MSG(ZZ,AAA),OOO)="|" S NNNN=NNNN+1
        .S POVAR1=$E(MSG(ZZ,AAA),OOO)
        .S POLIM=POVAR
        .S POVAR=$S(POVAR="":POVAR1,1:POVAR_POVAR1)
        I $G(POVAR)'="" I NNNN=13!(NNNN=12) S PSOREFIL=POVAR
        K MSG(ZZ,0)
        Q
PARSE   ;
        I NNNN=1 S PSORDITE=$P(POLIM,"^",4) G SET
        I NNNN=10 S PSODDRUG=$P(POLIM,"^",4) I $G(PSODDRUG),('$D(^PSDRUG(PSODDRUG,0))) S PSODDRUG="" G SET
        I NNNN=10 G SET
        I NNNN=11 S PSOXQTY=POLIM G SET
        I NNNN=13 S PSOREFIL=POLIM G SET
        I NNNN=17 S PSODYSPL=POLIM
SET     S (POVAR,POLIM)="" Q
        ;
OBXX    ;Parse out OBX segments
        S OCOUNT=OCOUNT+1
        S (POVAR,POVAR)="",(NNCK,NNN,NNNN)=0,PSOIII=1,MSG(ZZ,0)=$E(MSG(ZZ),5,$L(MSG(ZZ)))
        S AAA="" F  S AAA=$O(MSG(ZZ,AAA)) Q:AAA=""  S NNN=0 F OOO=1:1:$L(MSG(ZZ,AAA)) S NNN=NNN+1 D  D:$G(POVAR1)="&"&(NNNN=4) OPARSE D:$G(POVAR1)="|" OPARSE
        .I $E(MSG(ZZ,AAA),OOO)="|" S NNNN=NNNN+1
        .S POVAR1=$E(MSG(ZZ,AAA),OOO)
        .S POLIM=POVAR
        .S POVAR=$S(POVAR="":POVAR1,1:POVAR_POVAR1)
        I $G(POVAR)'="" I NNNN=4!(NNNN=5) S NNCK=NNCK+1 S OBXAR(OCOUNT,NNCK)=POVAR
        K MSG(ZZ,0)
        F OOO=2:1 Q:'$D(OBXAR(OCOUNT,OOO))  S OBXAR(OCOUNT,1)=OBXAR(OCOUNT,1)_"&"_OBXAR(OCOUNT,OOO) K OBXAR(OCOUNT,OOO)
        Q
OPARSE  ;
        I NNNN=4,$G(POVAR1)="&" S NNCK=NNCK+1,OBXAR(OCOUNT,NNCK)=$G(POLIM) G OSET
        I NNNN=5 S NNCK=NNCK+1 S OBXAR(OCOUNT,NNCK)=$G(POLIM)
OSET    S (POVAR,POLIM)="" Q
        ;
PURGE   ;Purge order initiated by CPRS
        N DA,PREER,PRG,PPG,PND,PRGFLAG,PURGCOMM,PEER,PURGPV1,PURGPID,PURGORC,PURGRX,PURGPLC,PRGSTAT,PSCC,PSARC,PSCA,PSACOUNT,PURGEXRX,PLAST,PURGLTH,PURGNODE
        S PSOMSORR=1
        S PRGFLAG=0
        ;S PURGRX=$O(^PSRX("APL",OR("PLACE"),0)) I PURGRX G PRX
        I $G(PSOFILNM),$G(PSOFILNM)'["S" S PURGRX=PSOFILNM G PRX
        S PND=+$G(PSOFILNM) I PND D  G PDNO
        .I '$D(^PS(52.41,PND,0)) Q
        .I $G(PDFN),$G(PDFN)'=$P($G(^PS(52.41,PND,0)),"^",2) S PURGCOMM="Patient does not match" D PDERR Q
        .S PRGSTAT=$P($G(^PS(52.41,PND,0)),"^",3) I PRGSTAT="NW"!(PRGSTAT="RNW")!(PRGSTAT="HD") S PRGFLAG=1 Q
        .K DIK S DA=PND,DIK="^PS(52.41," D ^DIK K DIK Q
        S PURGCOMM="Order was not located by Pharmacy."
        D PDERR G PDNO
PDERR   D EN^ORERR(PURGCOMM,.MSG)
        Q
PDNO    F PEER=0:0 S PEER=$O(MSG(PEER)) Q:'PEER  S:$P(MSG(PEER),"|")="PV1" PURGPV1=MSG(PEER) S:$P(MSG(PEER),"|")="PID" PURGPID=MSG(PEER) S:$P(MSG(PEER),"|")="ORC"&($G(PURGORC)="") PURGORC=MSG(PEER)
        N MSG,PSOHINST D INIT^PSOHLSN S MSG(2)=$G(PURGPID),MSG(3)=$G(PURGPV1),MSG(4)="ORC|"_$S($G(PRGFLAG):"ZU",1:"ZR")_"|"_$G(OR("PLACE"))_$S($G(PLACERXX):";"_PLACERXX,1:"")_"^OR"_"|"_$S($P($G(PURGORC),"|",4)'="":$P(PURGORC,"|",4),1:"")
        F PREER=11,13 I $P($G(PURGORC),"|",PREER)'="" S $P(MSG(4),"|",PREER)=$P($G(PURGORC),"|",PREER)
        S $P(MSG(4),"|",17)="^^^^"_$S($G(PRGFLAG):"Unable to Purge order.",1:"OK to Purge order.")_"^"
        D SEND^PSOHLSN
PURGEX  K PSOMSORR Q
PRX     ;Purge from PSRX here
        I '$D(^PSRX(PURGRX,0)) G PDNO
        I $G(PDFN),$G(PDFN)'=$P($G(^PSRX(PURGRX,0)),"^",2) S PURGCOMM="Patient does not match" D PDERR G PDNO
        I '$P($G(^PSRX(PURGRX,"ARC")),"^") S PRGFLAG=1 G PDNO
        ;purge from PSRX
        S PURGEXRX=$P(^PSRX(PURGRX,0),"^")
        S PSOSUSPA=1 K DIK S DA=PURGRX,PSCC=$P($G(^PSRX(PURGRX,0)),"^",2),DIK="^PSRX(" D ^DIK K DIK,PSOSUSPA
        I $D(^PS(55,+$G(PSCC),0)) S DA(1)=PSCC,DIK="^PS(55,"_DA(1)_",""P""," F PSCA=0:0 S PSCA=$O(^PS(55,+$G(PSCC),"P",PSCA)) Q:'PSCA  I ^PS(55,+$G(PSCC),"P",PSCA,0)=PURGRX S DA=PSCA D ^DIK K DA,DIK
        I $D(^PS(52.4,PURGRX,0)) S DA=PURGRX,DIK="^PS(52.4," D ^DIK K DA,DIK
        S DA=$O(^PS(52.5,"B",PURGRX,"")) I DA S DIK="^PS(52.5," D ^DIK K DIK,DA
        I '$G(DT) S DT=$$DT^XLFDT
        I '$G(PSCC) G PUQUIT
        I '$D(^PS(55,PSCC,"ARC",DT)) S DA=PSCC,DIE=55,DR="101///"_DT,DR(2,55.13)="1///"_$G(PURGEXRX) D ^DIE K DIE G PUQUIT
        S PLAST=0 F PSARC=0:0 S PSARC=$O(^PS(55,PSCC,"ARC",DT,1,PSARC)) Q:'PSARC  S PLAST=PSARC
        I $G(PLAST),$D(^PS(55,PSCC,"ARC",DT,1,PLAST,0)) S PURGNODE=^PS(55,PSCC,"ARC",DT,1,PLAST,0) S PURGLTH=$L(PURGNODE) I $G(PURGLTH),PURGLTH<220 S ^PS(55,PSCC,"ARC",DT,1,PLAST,0)=PURGNODE_$S($E(PURGNODE,PURGLTH)'="*":"*",1:"")_PURGEXRX G PUQUIT
        S DA=PSCC,DIE=55,DR="101///"_DT,DR(2,55.13)="1///"_$G(PURGEXRX) D ^DIE K DIE
PUQUIT  G PDNO
        ;
REF     ;Refill request from CPRS
        N PSORXFL,PSORFX,REFXXX,REFCOM,REFCOMXX,REFEER,REFPV1,REFPID,REFORC,RREER,RFLOOP,REFSEG,RFTYPE,REFILLER,REFVR
        ;S PSOMSORR=1
        ;S PSORXFL=$O(^PSRX("APL",OR("PLACE"),0)) I PSORXFL G REFRX
        I $G(PSOFILNM),$G(PSOFILNM)'["S" S PSORXFL=PSOFILNM G REFRX
        I $G(PSOFILNM) S PSORFX=+$G(PSOFILNM) D  S REFXXX=1 G REFSND
        .I '$D(^PS(52.41,PSORFX,0)) S (REFCOMXX,REFCOM)="Order was not located by Pharmacy." D REFERR Q
        .I $G(PDFN),$G(PDFN)'=$P($G(^PS(52.41,PSORFX,0)),"^",2) S (REFCOMXX,REFCOM)="Patient does not match." D REFERR Q
        .I $P($G(^PS(52.41,PSORFX,0)),"^",3)="RF" S REFCOM="Refill has already been requested." Q
        .S REFCOM="Refill request not allowed on Pending order."
        S (REFCOMXX,REFCOM)="Order was not located by Pharmacy." D REFERR S REFXXX=1 G REFSND
REFERR  D EN^ORERR(REFCOMXX,.MSG)
        Q
REFSND  ;REBUILD AND SEND MESSAGE  REFXXX IS VARIABL, REFCOM IS COMMENT
        ;F REFEER=0:0 S REFEER=$O(MSG(REFEER)) Q:'REFEER  S:$P(MSG(REFEER),"|")="PV1" REFPV1=MSG(REFEER) S:$P(MSG(REFEER),"|")="PID" REFPID=MSG(REFEER) S:$P(MSG(REFEER),"|")="ORC"&($G(REFORC)="") REFORC=MSG(REFEER)
        ;N MSG,PSOHINST D INIT^PSOHLSN S MSG(2)=$G(REFPID),MSG(3)=$G(REFPV1),MSG(4)="ORC|"_$S($G(REFXXX):"UF",1:"FL")_"|"_$G(OR("PLACE"))_$S($G(PLACERXX):";"_PLACERXX,1:"")_"^OR"_"|"_$S($P($G(REFORC),"|",4)'="":$P(REFORC,"|",4),1:"")
        ;use commented out code if response message is ever required
        ;F RREER=11,13 I $P($G(REFORC),"|",RREER)'="" S $P(MSG(4),"|",RREER)=$P($G(REFORC),"|",RREER)
        ;S $P(MSG(4),"|",17)="^^^^"_$S($G(REFXXX):$G(REFCOM),1:"Refill request sent to Pharmacy.")_"^"
        ;D SEND^PSOHLSN
REFSNDX ;K PSOMSORR
        Q
REFRX   ;
        I $O(^PS(52.41,"ARF",PSORXFL,0)) S REFXXX=1,REFCOM="Refill request already exists." G REFSND
        I '$D(^PSRX(PSORXFL,0)) S (REFCOMXX,REFCOM)="Order was not located by Pharmacy." D REFERR S REFXXX=1 G REFSND
        I $G(PDFN),$G(PDFN)'=$P($G(^PSRX(PSORXFL,0)),"^",2) S (REFCOMXX,REFCOM)="Patient does not match." D REFERR S REFXXX=1 G REFSND
        ;S REFVR=$$REFILL^PSOREF(OR("PLACE")) I $P($G(REFVR),"^")'=1 S REFXXX=1,REFCOM=$P($G(REFVR),"^",2) G REFSND
        F RFLOOP=0:0 S RFLOOP=$O(MSG(RFLOOP)) Q:'RFLOOP  S REFSEG=$G(MSG(RFLOOP)),RFTYPE=$P(REFSEG,"|")_"Z" S REFSEG=$E(REFSEG,5,$L(REFSEG)) I RFTYPE="PIDZ"!(RFTYPE="PV1Z")!(RFTYPE="ORCZ")!(RFTYPE="ZRXZ") D @RFTYPE
        I '$G(PLACER) S REFXXX=1,REFCOM="Unable to process refill request." G REFSND
        I $G(REFILLER),$G(REFILLER)'=$G(PSORXFL) S REFCOMXX="Filler number mismatch" D REFERR S REFXXX=1,REFCOM="Unable to process refill request." G REFSND
        K DD,DO S DIC="^PS(52.41,",DIC(0)="L",X=PLACER,DIC("DR")="1////"_$G(DFN)_";2////"_"RF"_";4////"_$G(ENTERED)_";5////"_$G(PROV) D FILE^DICN K DIC,DR I Y<0 S REFXXX=1,REFCOM="Unable to process refill request." G REFSND
        S PENDING=+Y S $P(^PS(52.41,PENDING,0),"^",13)=$G(LOCATION),$P(^(0),"^",17)=$S($G(ROUTING)'="":$G(ROUTING),1:"W"),$P(^(0),"^",19)=$G(PSORXFL),$P(^(0),"^",20)="F",$P(^(0),"^",14)="R"
        S $P(^PS(52.41,PENDING,0),"^",8)=$P($G(^PSRX(PSORXFL,"OR1")),"^"),$P(^PS(52.41,PENDING,0),"^",9)=$P($G(^PSRX(PSORXFL,0)),"^",6)
        S $P(^PS(52.41,PENDING,"INI"),"^")=$G(PSINPTR) D NOW^%DTC S $P(^PS(52.41,PENDING,0),"^",12)=% K %
        K DIK S DA=PENDING,DIK="^PS(52.41," D IX1^DIK K DIK
        G REFSND
PIDZ    ;
        S DFN=+$P(REFSEG,"|",3)
        Q
PV1Z    ;
        S LOCATION=+$P(+$P(REFSEG,"|",3),"^")
        S:'$D(^SC(LOCATION,0)) LOCATION=""
        S INPTRX=0 I $G(LOCATION) S PSINPTR=$P($G(^SC(LOCATION,0)),"^",4) I PSINPTR Q
        I $G(LOCATION) S INPTRX=$P($G(^SC(LOCATION,0)),"^",15)
        I '$G(INPTRX) S INPTRX=$O(^DG(40.8,0))
        I '$G(DT) S DT=$$DT^XLFDT
        S PSINPTR=+$$SITE^VASITE(DT,INPTRX)
        Q
ORCZ    ;
        S PLACER=+$P(REFSEG,"|",2),REFILLER=+$P(REFSEG,"|",3),ENTERED=+$P(REFSEG,"|",10),PROV=+$P(REFSEG,"|",12)
        Q
ZRXZ    ;
        S ROUTING=$P(REFSEG,"|",4)
        Q
STUFF   ;
        S PSOVRBD=$P($G(^PS(50.7,+$G(PSORDITE),0)),"^",2)
        I '$G(PSOVRBD) K PSOVRBD Q
        ;K PSONUNN F PSONUN=0:0 S PSONUN=$O(^PS(50.606,PSOVRBD,"NOUN",PSONUN)) Q:'PSONUN!($D(PSONUNN))  S:$P($G(^(PSONUN,0)),"^")'="" PSONUNN=$P($G(^(0)),"^")
        S PSOVRB=$P($G(^PS(50.606,PSOVRBD,"MISC")),"^")
        F EE=0:0 S EE=$O(^PS(52.41,PENDING,1,EE)) Q:'EE  S $P(^PS(52.41,PENDING,1,EE,1),"^",10)=$$UNESC^ORHLESC($G(PSOVRB))
        K PSOVRBD,PSONUNN,PSONUN,PSOVRB
        Q
