YTQAPI6  ;ALB/ASF- GAF API,DELETES ; 10/26/06 3:33pm
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
GAFRET(YSDATA,YS)       ;
        N YSBEG,YSEND,YSLIMIT,N,DFN,%DT
        K YSDATA
        D PARSE(.YS)
        I DFN'>0 S YSDATA(1)="[ERROR]",YSDATA(2)="No dfn" Q
        S YSDATA(1)="[DATA]"
        S N=1
        D RETHX
        Q
PARSE(YS)       ; -- array parsing
        S DFN=$G(YS("DFN"),0)
        S YSBEG=$G(YS("BEGIN"),"01/01/1970") S X=YSBEG,%DT="X" D ^%DT S YSBEG=Y
        S YSEND=$G(YS("END"),"01/01/2500") S X=YSEND,%DT="X" D ^%DT S YSEND=Y
        S YSLIMIT=$G(YS("LIMIT"),9999)
        Q
RETHX   ;
        N YSJJ,YSDD,X,Y,YSX,YSN
        S YSDD=9999999-YSEND-.00001
        F YSJJ=1:1:YSLIMIT S YSDD=$O(^YSD(627.8,"AX5",DFN,YSDD)) Q:YSDD'>0!(YSDD>(9999999-YSBEG))  D
         . S YSN=0 F  S YSN=$O(^YSD(627.8,"AX5",DFN,YSDD,YSN)) Q:YSN'>0  D
        .. S YSX=$P($G(^YSD(627.8,YSN,60)),U,3)
        .. S Y=$P($G(^YSD(627.8,YSN,0)),U,3)
        .. S YSX=YSN_"="_$$FMTE^XLFDT(Y,"5TZ")_U_YSX_U_$P(^YSD(627.8,YSN,0),U,4)_U_$$EXTERNAL^DILFD(627.8,.04,"",$P($G(^YSD(627.8,YSN,0)),U,4))_U_$G(^YSD(627.8,YSN,80,1,0))
        .. D SET(YSX)
        Q
SET(X)  ;
        S N=N+1
        S YSDATA(N)=X
        Q
DELETEME(YSDATA,YS)     ;delete a test
        ;removes 601.71 and 601.76 entries only
        ;input: CODE as test name
        ;output: DATA vs ERROR
        N YSTESTN,YSTEST,YSHASOP,DA,DIK
        S YSTEST=$G(YS("CODE"))
        I YSTEST="" S YSDATA(1)="[ERROR]",YSDATA(2)="NO code" Q  ;-->out
        S YSTESTN=$O(^YTT(601.71,"B",YSTEST,0))
        I YSTESTN'>0 S YSDATA(1)="[ERROR]",YSDATA(2)="bad code" Q  ;-->out
        S YSHASOP=$P($G(^YTT(601.71,YSTESTN,2)),U,5)
        I YSHASOP="Y" S YSDATA(1)="[ERROR]",YSDATA(2)="has been operational" Q  ;--> out
        S DA=YSTESTN,DIK="^YTT(601.71," D ^DIK
        S DIK="^YTT(601.76,"
        S DA=0 F  S DA=$O(^YTT(601.76,"AC",YSTESTN,DA)) Q:DA'>0  D ^DIK
        S YSDATA(1)="[DATA]"
        Q
