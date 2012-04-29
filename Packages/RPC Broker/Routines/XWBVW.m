XWBVW   ;GFT - PURGE RPC AUDIT;18FEB2011
        ;;8.0;KERNEL;;Jul 10, 1995
        ;
        ;
        ;
TRAP(XWB)       ;BRING IN THE XWB ARRAY AT TIME OF CALL
        N DFN,RPCNAME
        S RPCNAME=$G(XWB(2,"RPC"))
        S DFN=$$FINDFN(RPCNAME) ;'RPCNAME' IS NAME OF RPC TO BE FOUND IN FILE 8994.8
        I DFN D LOGRPC(RPCNAME,DFN)
        Q
        ;
        ;
FINDFN(RPCNAME) ;XWB ARRAY IS ALSO DEFINED WHEN ENTERING HERE
        N XWBVW,X
        I $G(RPCNAME)="" Q ""
        S XWBVW=$O(^XWBVW("B",RPCNAME,0)) I 'XWBVW Q ""
        I '$P($G(^XWBVW(XWBVW,0)),"^",2) Q "" ;WON'T WORK IF LOGGABLE RPC IS NOT ACTIVE
        S X=+$G(^XWBVW(XWBVW,100)) I X Q +$G(XWB(5,"P",X-1)) ;NODE 100 SAYS WHICH PARAMETER IS DFN; PARAMETERS ARE NUMBERED STARTING FROM 0
        S X=+$G(^XWBVW(XWBVW,101)) I X S X=+$G(XWB(5,"P",X-1)) I X S X=$P($G(^OR(100,X,0)),U,2) I X["DPT(" Q +X ;NODE 101 SAYS WHICH PARAMETER IS ORDER
        Q ""
        ;
        ;
LOGRPC(RPC,XWBDFN)      ;RPC audit   ---  something like XQ12 routine
        N %,Y,XWBVW
        I '$G(XWBDFN) Q
        I RPC'?1.NP Q:RPC=""  S RPC=$O(^XWB(8994,"B",RPC,0)) Q:'RPC
        S %=$P($H,",",2),%=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100)
        L +^XUSEC(8994,0):0
        F XWBVW=%:.00000001 Q:'$D(^XUSEC(8994,XWBVW))
        S ^(XWBVW,0)=RPC_"^"_$G(DUZ)_"^"_$I_"^"_$J
        L -^XUSEC(8994,0)
        S $P(^(0),U,3,4)=XWBVW_"^"_($P(^XUSEC(8994,0),U,4)+1)
        D GETENV^%ZOSV S $P(^XUSEC(8994,XWBVW,0),U,6)=$P(Y,U,2)
        S ^XUSEC(8994,XWBVW,100)=XWBDFN
        ;djw-indices
        S ^XUSEC(8994,"APAT",XWBDFN,XWBVW)=""
        S ^XUSEC(8994,"AD",+$G(DUZ),XWBVW)=""
        Q
        ;
        ;
        ;
XWBPURGE        ;RPC audit purge  --- 'XWBAPURGE' Option    --- stolen from XUAPURGE routine
        N %DT,BDATE,EDATE,ZTIO,ZTRTN,ZTUCI,ZTSAVE,ZTSK
        D BEG G:'$D(EDATE) END
        ;S ZTIO="",ZTRTN="PURGE^XWBVW",ZTDESC="Purge Menu Option Audit Entries" F G="BDATE","EDATE" S ZTSAVE(G)=""
        ;D ^%ZTLOAD K ZTIO,ZTRTN,ZTDESC,ZTUCI,ZTSAVE
        ;Q
PURGE   F REC=BDATE-.000001:0 S REC=$O(^XUSEC(8994,REC)) Q:REC'>0!(REC>EDATE)  S DIK="^XUSEC(8994,",DA=REC D ^DIK K DA
END     Q
        ;
BEG     W !!,"You will be asked for a date range to purge, Begin to End"
        S %DT("A")="PURGE BEGIN DATE: ",%DT="AETX" D ^%DT S BDATE=Y G:Y<1 END S %DT(0)=BDATE,%DT("A")="PURGE END DATE: " D ^%DT S EDATE=Y G:Y<1 END
        Q
        ;
        ;
        ;
        ;
        ;
POPTEMPL(TEMPLATE)      ;FROM AN 8994 TEMPLATE INTO 8994.8
        N DIC,DFN,RPC,DFNX,ORD,ORDX
        Q:$P($G(^DIBT(TEMPLATE,0)),U,4)-8994
        F RPC=0:0 S RPC=$O(^DIBT(TEMPLATE,1,RPC)) Q:'RPC  D POPRPC(RPC)
        Q
        ;
POPRPC(RPC)     ;
        S X=$P(^XWB(8994,RPC,0),U,2,3) I X[U,$T(@X)]"" D
        .S (DFN,DFNX,ORD,ORDX)=0
        .F SEQ=0:0 S SEQ=$O(^XWB(8994,RPC,2,SEQ)) Q:'SEQ  D  Q:DFN
        ..I $P(^(SEQ,0),U)["DFN" S DFNX=SEQ,DFN=$P(^(0),U,5) Q
        ..;I $P(^(0),U)["ORIFN" S ORDX=SEQ,ORD=$P(^(0),U,5)
        .S:DFN DFNX=DFN Q:'DFNX
        .S DIC=8994.8,DIC(0)="L",DIC("DR")="100///"_DFNX,X=$$GET1^DIQ(8994,RPC,.01) D ^DIC
        Q
