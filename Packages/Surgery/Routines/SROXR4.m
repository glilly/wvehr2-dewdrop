SROXR4  ;BIR/MAM - CROSS REFERENCES ;11/05/07
        ;;3.0; Surgery ;**62,83,100,153,166**;24 Jun 93;Build 7
        Q
PRO     ; stuff default prosthesis info
        I '$D(SRTN) Q
        S ^SRF(SRTN,1,DA,0)=^SRF(SRTN,1,DA,0)_"^"_$P(^SRO(131.9,X,0),"^",2,99)
        I $D(^SRO(131.9,X,1)) S ^SRF(SRTN,1,DA,1)=^(1)
        Q
CAN     ; 'SET' logic of the 'ACAN' x-ref on the 'CANCEL REASON'
        ; field in the SURGERY file (130)
        S $P(^SRF(DA,30),"^",2)=$P(^SRO(135,X,0),"^",3) I $P(^SRO(135,X,0),"^",3)="" S $P(^SRF(DA,30),"^",2)="Y"
        I $P(^SRF(DA,30),"^",3)="" S $P(^SRF(DA,30),"^",3)=DUZ
        S SHEMP=$P($G(^SRF(DA,.2)),"^",10) I SHEMP,$D(^SRF(DA,"RA")) S ZTDESC="Clean up Risk Assessment Information, Canceled Case",ZTRTN="RISK^SROXR4",ZTDTH=$H,ZTSAVE("DA")="" D ^%ZTLOAD
        Q
KCAN    ; 'KILL' logic of the 'ACAN' x-ref on the 'CANCEL REASON'
        ; field in the SURGERY file (130)
        S $P(^SRF(DA,30),"^",2)="" I '$P($G(^SRF(DA,30)),"^") S $P(^SRF(DA,30),"^",3)=""
        Q
AS      ; 'SET' logic of the 'AS' x-ref on the SCHEDULED START TIME
        ; field in the SURGERY file (130)
        S OR=$P(^SRF(DA,0),"^",2) I 'OR Q
        S ^SRF("AS",OR,X,DA)=""
        Q
KAS     ; 'KILL' logic of the 'AS' x-ref on the SCHEDULED FINISH TIME
        ; field in the SURGERY file (130)
        S OR=$P(^SRF(DA,0),"^",2) I 'OR Q
        K ^SRF("AS",OR,X,DA)
        Q
SCH     ; 'SET' logic of the 'AC' x-ref of the REQUIRED FIELDS FOR SCHEDULING
        ; field in the SURGERY SITE PARAMETERS file (133)
        S MM=$O(^DD(130,"B",X,0)),$P(^SRO(133,DA(1),4,DA,0),"^",2)=MM K MM
        Q
KSCH    ; 'KILL' logic of the 'AC' x-ref of the REQUIRED FIELDS FOR SCHEDULING
        ; field in the SURGERY SITE PARAMETERS file (133)
        S $P(^SRO(133,DA(1),4,DA,0),"^",2)=""
        Q
RISK    ; clean up risk data for canceled cases
        S DIE=130,DR="102///@;235///@;284///@;323///@" D ^DIE K DR,DA S ZTREQ="@"
        Q
AQ      ; set logic for AQ x-ref
        N SRTD,SRLO D AQDT I SRTD'<SRLO S $P(^SRF(DA,.4),"^",2)="R",^SRF("AQ",SRTD,DA)=""
        Q
KAQ     ; kill logic for AQ x-ref
        N SRTD,SRLO D AQDT S $P(^SRF(DA,.4),"^",2)="" K ^SRF("AQ",SRTD,DA)
        Q
AQDT    ; get quarterly transmission date
        N SRDAY,SRSDATE,SRQTR,SRX,SRYR S SRSDATE=$E($P(^SRF(DA,0),"^",9),1,7)
        S SRYR=$E(SRSDATE,1,3),SRDAY=$E(SRSDATE,4,7),SRQTR=$S(SRDAY<401:2,SRDAY<701:3,SRDAY<1001:4,1:1) I SRQTR=1 S SRYR=SRYR+1
        S SRTD=SRYR_$S(SRQTR=1:"0214",SRQTR=2:"0515",SRQTR=3:"0814",1:"1114")
        S SRX=$E(DT,1,3),SRLO=SRX-1_"0214"
        Q
AQ1     ; set logic for AQ1 x-ref
        I X="R" N SRTD,SRLO D AQDT I SRTD'<SRLO S ^SRF("AQ",SRTD,DA)=""
        Q
KAQ1    ; kill logic for AQ1 x-ref
        N SRTD,SRLO D AQDT K ^SRF("AQ",SRTD,DA)
        Q
AT      ; set logic for AT x-ref on DATE OF LAST TRANSMISSION
        N SRX S ^SRF("AT",X,DA)=""
        S SRX=$P($G(^SRF(DA,"RA")),"^",4) I SRX,SRX'=X K ^SRF("AT",SRX,DA)
        Q
KAT     ; kill logic for AT x-ref on DATE OF LAST TRANSMISSION
        N SRX K ^SRF("AT",X,DA)
        S SRX=$P($G(^SRF(DA,"RA")),"^",4) I SRX,SRX'=X K ^SRF("AT",SRX,DA)
        Q
AT1     ; set logic for AT x-ref on DATE TRANSMITTED
        N SRX S SRX=$P($G(^SRF(DA,"RA")),"^",8) I SRX Q
        S ^SRF("AT",X,DA)=""
        Q
KAT1    ; kill logic for AT x-ref on DATE TRANSMITTED
        N SRX S SRX=$P($G(^SRF(DA,"RA")),"^",8)
        I SRX'=X K ^SRF("AT",X,DA)
        Q
