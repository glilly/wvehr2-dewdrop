PSO52AP1        ;BHM/SAB - Encapsulation II API to return Rx data ;04/07/05 10:30 am
        ;;7.0;OUTPATIENT PHARMACY;**213,245,276**;DEC 1997;Build 15
        ;
        ;Reference to ^PS(55 supported by DBIA 2228
        ;Reference to ^PSDRUG supported by DBIA 221
        ;
        ;Rx profile called from PROF^PSO52API
        ;DFN: Patient's IEN 
        ;LIST: Subscript name used in ^TMP global [REQUIRED]
        ;SDATE: Starting Expiration Date [optional]
        ;EDATE: Ending Expiration Date [optional]
        ;
        Q:$G(LIST)=""
        N DA,DR,PST,DIC,DIQ,DATE,IEN K ^TMP($J,LIST)
        Q:'$G(DFN)
        I '$O(^PS(55,DFN,"P",0)),$O(^PS(55,DFN,"ARC",0)) S ^TMP($J,LIST,DFN,"ARC",0)="PATIENT HAS ARCHIVED PRESCRIPTIONS"
        I $G(SDATE) S DATE=SDATE-1 D  G EX
        .I $G(EDATE) F  S DATE=$O(^PS(55,DFN,"P","A",DATE)) Q:'DATE!(DATE>EDATE)  F IEN=0:0 S IEN=$O(^PS(55,DFN,"P","A",DATE,IEN)) Q:'IEN  D ND
        .I '$G(EDATE) F  S DATE=$O(^PS(55,DFN,"P","A",DATE)) Q:'DATE  F IEN=0:0 S IEN=$O(^PS(55,DFN,"P","A",DATE,IEN)) Q:'IEN  D ND
        I $G(EDATE),'$G(SDATE) S DATE=DT-1 D  G EX
        .F  S DATE=$O(^PS(55,DFN,"P","A",DATE)) Q:'DATE!(DATE>EDATE)  F IEN=0:0 S IEN=$O(^PS(55,DFN,"P","A",DATE,IEN)) Q:'IEN  D ND
        S DATE=DT-1 F  S DATE=$O(^PS(55,DFN,"P","A",DATE)) Q:'DATE  F IEN=0:0 S IEN=$O(^PS(55,DFN,"P","A",DATE,IEN)) Q:'IEN  D ND
EX      I $G(DFN),$G(LIST)]"",'$O(^TMP($J,LIST,DFN,0)) S ^TMP($J,LIST,DFN,0)="-1^NO PRESCRIPTION DATA FOUND"
        Q
ND      ;returns data
        I DFN'=$P($G(^PSRX(IEN,0)),"^",2) Q
        I $G(^PSRX(IEN,0))']"" Q
        Q:$P($G(^PSRX(IEN,"STA")),"^")=13
        S ^TMP($J,LIST,DFN,0)=$G(^TMP($J,LIST,DFN,0))+1
        I DT>$P(^PSRX(IEN,2),"^",6),$P(^PSRX(IEN,"STA"),"^")<11 D
        .N PSOEXRX,PSOEXSTA,ORN,PIFN,PSUSD,PRFDT,PDA,PSDTEST,PSOVADM
        .S PSOEXRX=IEN M PSOVADM=VADM D EN2^PSOMAUEX M VADM=PSOVADM K PSOEXRX,PSONM,PSONMX
        K PST S DIC=52,DA=IEN,DR=".01:9;10.3;10.6;11;16;17;100"
        S DIQ="PST",DIQ(0)="IE" D EN^DIQ1
        S ^TMP($J,LIST,"B",PST(52,DA,.01,"E"),IEN)=""
        F DR=.01,1,2,3,4,5,6,6.5,7,8,9,10.3,10.6,11,16,17,100 D
        .I PST(52,DA,DR,"E")'=PST(52,DA,DR,"I") S ^TMP($J,LIST,DFN,IEN,DR)=PST(52,DA,DR,"I")_"^"_PST(52,DA,DR,"E") Q
        .S ^TMP($J,LIST,DFN,IEN,DR)=PST(52,DA,DR,"I")
        S $P(^TMP($J,LIST,DFN,IEN,.01),U,2)=IEN
        K DA,DR,PST,DIC,DIQ
        Q
