PRCGARP1        ;WIRMFO/CTB/BGJ-IFCAP PURGEMASTER ROUTINE FOR FILE 442 ;12/10/97  9:07 AM
V       ;;5.1;IFCAP;**46,131**;Oct 20, 2000;Build 13
        ;Per VHA Directive 2004-038, this routine should not be modified.
START(X)        ;
        NEW BEGDA,ENDA,SITE,DIK,DA,MOP,ZNODE
        S BEGDA=$P(X,"-",1),ENDA=+$P(X,"-",2),SITE=$P(X,";",2)
        S DA=BEGDA-1
        F  S DA=$O(^PRC(443.9,DA)) Q:'DA!(DA>ENDA)  D
        . S ZNODE=$G(^PRC(443.9,DA,0)) Q:ZNODE=""
        . I +$P(ZNODE,"^",4)'=SITE QUIT
        . I $P(ZNODE,"^",2)=1 D REMOVE^PRCGARCH QUIT
        . S MOP=$P(ZNODE,"^",3)
        . S:MOP="" MOP="NULL"
        . D @MOP
        . D REMOVE^PRCGARCH
        . QUIT
        QUIT
IS      ;;ISSUES
TA      ;;TRAVEL
OTA     ;;OPEN TRAVEL
        ;;enter code here to completely delete one entry in 442 of the types
        ;; listed above.
        QUIT
AR      ;;ACCOUNTS RECEIVABLE
        N PRCHDA
        QUIT:'$D(DA)
        S PRCHDA=DA
        Q:'$D(^PRC(442,PRCHDA,0))
        D KILL442(PRCHDA)
        QUIT
NULL    ;;442 entry with no MOP
CI      ;;CERTIFIED INVOICE
PIA     ;;PAYMENT IN ADVANCE
DD      ;;GUARANTEED DELIVERY
ST      ;;INVOICE/RECEIVING REPORT
IF      ;;IMPREST FUND/CASHIER
PC      ;;PURCHASE CARD
AB      ;;AUTOBANK
RQ      ;;REQUISITION
        N PRCHDA,PRCHFY,FY,X,I
        QUIT:'$D(DA)
        S PRCHDA=DA
        Q:'$D(^PRC(442,PRCHDA,0))
        D K2237(PRCHDA)
        D K4215(PRCHDA)
        ;delete file 441,442.9 entries
        D K4429(PRCHDA)
        D P441^PRCGPPC1(PRCHDA)
        ;finally, delete 442 and 443.6 (amendments file)
        D KILL442(PRCHDA)
        D KILL4436(PRCHDA)
        ;
        QUIT
1358    ;;1358
        ;;enter code here to completely delete one 1358
        ;delete 410 files, 421.5, 441, 442 files, and finally 442
        N PRCHDA,X
        QUIT:'$D(DA)
        S PRCHDA=DA
        Q:'$D(^PRC(442,PRCHDA,0))
        D K2237(PRCHDA)
        ;delete 1358
        D:$D(^PRC(424,"C",PRCHDA)) DL424^PRCGPPC1(PRCHDA)
        D K4215(PRCHDA)
        D K4429(PRCHDA)
        D KLL4406(PRCHDA),KLL4219(PRCHDA)
        ;finally, delete 442
        D KILL442(PRCHDA)
        QUIT
K4215(PRCHDA)   ;
        NEW PRCFDA
        S PRCFDA=0 F  S PRCFDA=$O(^PRCF(421.5,"E",PRCHDA,PRCFDA)) Q:PRCFDA=""  D KILL4215(PRCFDA)
        QUIT
KILL410(DA)     ;
        Q:'$D(^PRCS(410,DA,0))
        S DIK="^PRCS(410," D ^DIK
        K DIK
        QUIT
KILL443(DA)     ;
        Q:'$D(^PRC(443,DA,0))
        S DIK="^PRC(443," D ^DIK
        K DIK
        QUIT
KILL4215(DA)    ;
        S DIK="^PRCF(421.5," D ^DIK
        K DIK
        QUIT
KILL442(DA)     ;
        D KILL4101(DA)
        D KLL4406(DA),KLL4219(DA)
        S DIK="^PRC(442," D ^DIK
        K DIK
        QUIT
KILL4101(X)     ;Delete 410.1 record when entry in 442 is deleted
        ;
        N DA
        S X=$P($G(^PRC(442,X,0)),"^")
        Q:X'>0
        S DIC(0)="X"
        S DIC="^PRCS(410.1,"
        D ^DIC
        Q:Y=-1
        S DA=+Y
        S DIK="^PRCS(410.1," D ^DIK
        K DIC,DIK,X,Y
        QUIT
        ;
KILL4436(DA)    ;
        S DIK="^PRC(443.6," D ^DIK
        K DIK
        QUIT
K2237(PRCHDA)   ;kill primary 2237
        N PRCSDA
        S PRCSDA=$P($G(^PRC(442,PRCHDA,0)),"^",12)
        I +PRCSDA,$D(^PRCS(410,+PRCSDA)) D KILL410(PRCSDA)
        ;kill other 2237's if present
        I $D(^PRC(442,PRCHDA,13)) D
        .F I=1:1:20 S PRCSDA=$O(^PRC(442,PRCHDA,13,0)) Q:PRCSDA=""  D
        . . I $D(^PRCS(410,PRCSDA,0)) D KILL410(PRCSDA)
        . . I $D(^PRC(443,PRCSDA,0)) D KILL443(PRCSDA)
        . . QUIT
        . QUIT
        QUIT
K4429(PRCHDA)   ;
        N EXPONUM
        S EXPONUM=$P($G(^PRC(442.9,PRCHDA,0)),"^",4) D:EXPONUM'="" P4429^PRCGPPC1(EXPONUM)
        QUIT
KLL4406(DA)     ;Delete 440.6 records when entry in 442 is deleted
        N IPIEN,HLDDA
        S IPIEN=0,HLDDA=0
        F  S IPIEN=$O(^PRCH(440.6,"PO",DA,IPIEN)) Q:IPIEN'>0  D
        .S HLDDA=DA,DA=IPIEN
        .S DIK="^PRCH(440.6," D ^DIK
        .K DIK
        .S DA=HLDDA
        K IPIEN,HLDDA
        Q
KLL4219(DA)     ;Delete 421.9 records when entry in 442 is deleted
        N IPIEN,HLDDA,PONUM
        S PONUM=$P($G(^PRC(442,DA,0)),"^") Q:$G(PONUM)=""
        S IPIEN=0,HLDDA=DA
        F  S IPIEN=$O(^PRCF(421.9,"B",PONUM,IPIEN)) Q:IPIEN'>0  D
        .S DA=IPIEN
        .S DIK="^PRCF(421.9," D ^DIK
        .K DIK
        S DA=HLDDA
        K IPIEN,HLDDA,PONUM
        Q
