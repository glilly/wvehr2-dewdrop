YTQPXRM2        ;ALB/ASF- MHA3 API FOR CLINICAL REMINDERS ; 7/27/07 1:25pm
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        ;Reference to ^PXRMINDX(601.2, supported by DBIA #4114
        ;Reference to ^PXRMINDX(601.84, supported by DBIA #??????
        Q
PTTEST(YSDATA,YS)       ;all data scores for a specific patient
        ;Input:
        ;YS("DFN"): Patient IFN from file2
        ;YS("CODE"): Test code NUMBER from file 601.71 including "ASI","GAF"
        ;YS("BEGIN"): inclusive date in %DT acceptable format (11/11/2011) to begin search [optional]
        ;YS("END"): inclusive date in %DT acceptable format (11/11/2011) to end search  [optional]
        ;YS("LIMIT"): Last N administrations [optional]
        ;Output
        ;YSDATA(1)=[DATA]^NUMBER FOUND
        ;YSDATA(OCCURANCE,1:999) most recent to least recent occurance for this test for this patient
        N YSBEG,YSCODE,R1,R2,R3,YSADATE,YSEND,YSLIMIT,YSLM,YSOCC,YSSCALE,YSSTAFF,YSZ,YSZN,G,YSORT,YSCODEN,YS601,%DT,DAS,DFN,IFN,NI,N,N1,N2,YSID,X,Y,YSNEG,YSDFN
        K ^TMP($J,"YSG"),YSDATA
        D PARSE(.YS)
        I YSLM'?1NP.N!(YSLM=0) S YSDATA(1)="[ERROR]",YSDATA(2)="bad limit" Q  ;-->out
        I YSLM>0 S YSNEG=0,YSORT=-1
        E  S YSLM=YSLM*-1,YSNEG=1,YSORT=1
        I YSCODE="ASI" D ASIPT Q  ;-->out
        I YSCODE="GAF" D GAFPT Q  ;-->out
        D P1,PA
        S NI=0
        I YSNEG=0 S N=9999999 F  S N=$O(^TMP($J,"YSG",N),-1) Q:N=""!(NI=YSLM)  D
        . S N2=9999999 F  S N2=$O(^TMP($J,"YSG",N,N2),-1) Q:N2=""!(NI=YSLM)  S NI=NI+1,YSDATA(NI+1)=^TMP($J,"YSG",N,N2)
        I YSNEG=1 S N=0 F  S N=$O(^TMP($J,"YSG",N)) Q:N=""!(NI=YSLM)  D
        . S N2=0 F  S N2=$O(^TMP($J,"YSG",N,N2)) Q:N2=""  S NI=NI+1,YSDATA(NI+1)=^TMP($J,"YSG",N,N2)
        S YSDATA(1)="[DATA]"_U_NI
        K ^TMP($J,"YSG"),YS
        Q
PA      ;MHA3 DATA
        I YSNEG=0 S YSID=YSEND+.00001
        E  S YSID=YSBEG-.00001
        S NI=0
        F  S YSID=$O(^PXRMINDX(601.84,"PI",DFN,YSCODEN,YSID),YSORT) Q:(YSID'>0)!(YSID<YSBEG)!(YSID>YSEND)  D
        . S DAS=0 F  S DAS=$O(^PXRMINDX(601.84,"PI",DFN,YSCODEN,YSID,DAS)) Q:DAS'>0!(NI=YSLM)  D
        .. S NI=NI+1
        .. S ^TMP($J,"YSG",YSID,NI)=DAS_U_YSID_"^601.84"
        Q
P1      ;old 601.2 data
        I YSNEG=0 S YSID=YSEND+.00001
        E  S YSID=YSBEG-.00001
        S NI=0
        S YS601=$O(^YTT(601,"B",YSCODE,0))
        Q:YS601=""  ;-->out ASF 2/23/07
        F  S YSID=$O(^PXRMINDX(601.2,"PI",DFN,YS601,YSID),YSORT) Q:(YSID'>0)!(YSID<YSBEG)!(YSID>YSEND)!(NI=YSLM)  D
        . S DAS=DFN_";1;"_YS601_";1;"_YSID
        . S NI=NI+1
        . S ^TMP($J,"YSG",YSID,NI)=DAS_U_YSID_"^601.2"
        Q
PARSE(YS)       ; -- array parsing
        S DFN=$G(YS("DFN"))
        S (YSCODEN,YSCODE)=$G(YS("CODE"))
        S YSCODE=$P($G(^YTT(601.71,YSCODEN,0),"ERROR"),U)
        S YSADATE=$G(YS("ADATE")) S X=YSADATE,%DT="T" D ^%DT S YSADATE=Y
        S YSSCALE=$G(YS("SCALE"))
        S YSBEG=$G(YS("BEGIN")) S:YSBEG="" YSBEG="01/01/1970" S X=YSBEG,%DT="T" D ^%DT S YSBEG=Y\1
        S YSEND=$G(YS("END")) S:YSEND="" YSEND="01/01/2099" S X=YSEND,%DT="T" D ^%DT S YSEND=Y
        S YSLM=$G(YS("LIMIT"),1)
        Q
GAFPT   ;gaf for pt IN time
        S YS601=$O(^YTT(601,"B","GAF",0))
        S IFN=$S(YSORT=1:0,1:9999999),NI=0
        K ^TMP($J,"YSGAF")
        F  S IFN=$O(^YSD(627.8,"C",DFN,IFN),YSORT) Q:(IFN'>0)!(NI=YSLM)  D
        . S X=$P($G(^YSD(627.8,IFN,60)),U,3)
        . Q:X=""
        . S X=$P($G(^YSD(627.8,IFN,0)),U,3)
        . Q:(X<YSBEG)!(X>YSEND)
        . S NI=NI+1
        . S ^TMP($J,"YSGAF",X,IFN)=""
        S X=$S(YSORT=1:0,1:9999999)
        F  S X=$O(^TMP($J,"YSGAF",X),YSORT) Q:X'>0  S IFN=0 F  S IFN=$O(^TMP($J,"YSGAF",X,IFN)) Q:IFN'>0  D
        . S YSOCC=$O(YSDATA(9999999),-1)+1 S:YSOCC<2 YSOCC=2
        . S DAS=DFN_";1;"_YS601_";1;"_IFN
        . S YSDATA(YSOCC)=DAS_U_X_"^627.8"
        S YSDATA(1)="[DATA]"_U_NI
        Q
ASIPT   ;asis for pt IN time
        S YS601=$O(^YTT(601,"B","ASI",0))
        S IFN=$S(YSORT=1:0,1:9999999),NI=0
        F  S IFN=$O(^YSTX(604,"C",DFN,IFN),YSORT) Q:IFN'>0!(NI=YSLM)  D
        . Q:'$D(^YSTX(604,IFN,.5))  ; no sig
        . S X=$P($G(^YSTX(604,IFN,0)),U,5)
        . Q:X=""
        . Q:(X<YSBEG)!(X>YSEND)
        . S YSOCC=$O(YSDATA(9999999),-1)+1 S:YSOCC<2 YSOCC=2
        . S NI=NI+1
        . S DAS=DFN_";1;"_YS601_";1;"_IFN
        . S YSDATA(YSOCC)=DAS_U_X_"^604"
        S YSDATA(1)="[DATA]"_U_NI
        Q
