YTQPXRM1        ;ALB/ASF- MHA3 API FOR CLINICAL REMINDERS ; 3/13/07 1:43pm
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        ;Reference to ^PXRMINDX(601.2, supported by DBIA #4114
        ;Reference to ^PXRMINDX(601.84, supported by DBIA #??????
        Q
OCCUR(YSSUB,YS) ;occurances OF TESTS,GAF,ASI
        ;Input:
        ;YS("CODE"): Test code NUMBER from file 601.71 including "ASI","GAF"
        ;YS("BEGIN"): inclusive date in %DT acceptable format (11/11/2011) to begin search [optional]
        ;YS("END"): inclusive date in %DT acceptable format (11/11/2011) to end search  [optional]
        ;YS("LIMIT"): Last N administrations [optional]
        ;Output
        N G,YSLIMIT,YSJJ,YSSONE,S,R,N,YSN2,N4,I,II,DFN,YSCODE,YSCODEN,YSADATE,YSSCALE,YSBED,YSEND,YSAA,DAS,YSOCC,YSZN,YST,YSLM
        N IFN,R1,R2,R3,SFN1,SFN2,YSBEG,YSCK,YSDFN,YSED,YSIFN,YSINUM,YSITEM,YSN2,YSNODE,YSPRIV,YSQT,YSR,YSSTAFF,YSTYPE,YSCODE,NI,YSID,%DT,X,Y,YS601
        D PARSE(.YS)
        S N=0
        K ^TMP($J,YSSUB)
        I YSCODE="ASI" D ASIOC Q  ;-->out
        I YSCODE="GAF" D GAFOC Q  ;-->out
        I '$D(^YTT(601.71,"B",YSCODE)) S ^TMP($J,YSSUB,1)="[ERROR]^BAD TEST CODE #" Q  ;-->out
        S NI=0
PA      S DFN=0
        F  S DFN=$O(^PXRMINDX(601.84,"IP",YSCODEN,DFN)) Q:DFN'>0  S YSOCC=0 D
        . S YSN2=YSEND+.0000001 F  S YSN2=$O(^PXRMINDX(601.84,"IP",YSCODEN,DFN,YSN2),-1) Q:YSN2'>0!(YSN2<YSBEG)  D
        .. S DAS=0 F  S DAS=$O(^PXRMINDX(601.84,"IP",YSCODEN,DFN,YSN2,DAS)) Q:DAS'>0  D
        ... S YSOCC=YSOCC+1
        ... Q:(YSOCC>YSLM)
        ... S NI=NI+1
        ... S ^TMP($J,YSSUB,DFN,YSOCC)=DAS_U_YSN2_U_YSCODEN_"^601.84"
P0      S DFN=0,YS601=$O(^YTT(601,"B",YSCODE,0))
        F  S DFN=$O(^PXRMINDX(601.2,"IP",YS601,DFN)) Q:DFN'>0  S YS("DFN")=DFN D P1
        S ^TMP($J,YSSUB)="[DATA]"_U_NI
        Q
P1      S YSOCC=$O(^TMP($J,YSSUB,DFN,99999),-1)
        S YSN2=YSEND+.1 F  S YSN2=$O(^PXRMINDX(601.2,"IP",YS601,DFN,YSN2),-1) Q:YSN2'>0!(YSN2<YSBEG)  D
        . S YSOCC=YSOCC+1
        . Q:(YSOCC>YSLM)
        . S NI=NI+1
        . S ^TMP($J,YSSUB,DFN,YSOCC)=DFN_";1;"_YS601_";1;"_YSN2_U_YSN2_U_YS601_"^601.2"
        Q
PARSE(YS)       ; -- array parsing
        S DFN=$G(YS("DFN"))
        S (YSCODEN,YSCODE)=$G(YS("CODE"))
        S YSCODE=$P($G(^YTT(601.71,YSCODE,0),"ERROR"),U)
        S YSADATE=$G(YS("ADATE")) S X=YSADATE,%DT="T" D ^%DT S YSADATE=Y
        S YSSCALE=$G(YS("SCALE"))
        S YSBEG=$G(YS("BEGIN")) S:YSBEG="" YSBEG="01/01/1970" S X=YSBEG,%DT="T" D ^%DT S YSBEG=Y
        S YSEND=$G(YS("END")) S:YSEND="" YSEND="01/01/2099" S X=YSEND,%DT="T" D ^%DT S YSEND=Y
        S YSLM=$G(YS("LIMIT"),1)
        Q
GAFOC   ;all axis5 DXs in time frame
        S YS601=$O(^YTT(601,"B","GAF",0))
        S YST=YSEND+.0000001,NI=0
        F  S YST=$O(^YSD(627.8,"B",YST),-1) Q:YST'>0!(YST<YSBEG)  S IFN=0 F  S IFN=$O(^YSD(627.8,"B",YST,IFN)) Q:IFN'>0  D
        . S X=$P($G(^YSD(627.8,IFN,60)),U,3)
        . Q:X=""
        . S DFN=$P($G(^YSD(627.8,IFN,0)),U,2) Q:DFN'>0  ;bad dfn
        . S YSOCC=$O(^TMP($J,YSSUB,DFN,999999),-1)+1
        . Q:(YSOCC>YSLM)
        . S NI=NI+1
        . S ^TMP($J,YSSUB,DFN,YSOCC)=DFN_";1;"_YS601_";1;"_IFN_U_YST_U_YS601_"^627.8"
        S ^TMP($J,YSSUB)="[DATA]"_U_NI
        Q
ASIOC   ;
        S YS601=$O(^YTT(601,"B","ASI",0))
        S NI=0,DFN=0,YSID=YSEND+.01
        F  S YSID=$O(^YSTX(604,"AD",YSID),-1) Q:(YSID'>0)!(YSID<YSBEG)  S IFN=0 F  S IFN=$O(^YSTX(604,"AD",YSID,IFN)) Q:IFN'>0  D
        . Q:'$D(^YSTX(604,IFN,.5))  ; no sig
        . S G=$G(^YSTX(604,IFN,0))
        . S DFN=$P(G,U,2) Q:DFN'>0  ;bad dfn
        . S YSOCC=$O(^TMP($J,YSSUB,DFN,999999),-1)+1
        . Q:(YSOCC>YSLM)
        . S NI=NI+1
        . S ^TMP($J,YSSUB,DFN,YSOCC)=DFN_";1;"_YS601_";1;"_IFN_U_$P(G,U,5)_U_YS601_"^604"
        S ^TMP($J,YSSUB)="[DATA]"_U_NI
        Q
