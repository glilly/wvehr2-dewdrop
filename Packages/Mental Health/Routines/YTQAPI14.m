YTQAPI14        ;ASF/ALB MHA PROCEEDURES ; 7/12/07 5:00pm
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        Q
SIGNOK(YSDATA,YS)       ; all reqiured fields
        ;Input: IENS as iens for 604
        ;Output: 1^OK TO SIGN
        ;        0^MISSING REQUIRED FIELDS
        ;        2^A G12 RECORD
        N N1,YSASCLS,X,YSASFLD,YSF,YSASSPL,YSN,YSFLAG,YSIEN,YSTYPE
        S YSFLAG=1
        S YSIEN=$G(YS("IENS"),-1)
        I '$D(^YSTX(604,YSIEN,0)) S YSDATA(1)="[ERROR]",YSDATA(2)="BAD IEN" Q
        S YSDATA(1)="[DATA]",YSDATA(2)="1^OK TO SIGN"
        S YSN=2
        S YSASCLS=$$GET1^DIQ(604,YSIEN_",",.04,"I")
        S YSASCLS=YSASCLS+3
        S N1=0 F  S N1=$O(^YSTX(604.66,N1)) Q:N1'>0  D:($P(^YSTX(604.66,N1,0),U,8)&($P(^YSTX(604.66,N1,0),U,YSASCLS)))
        . S YSASFLD=$P(^YSTX(604.66,N1,0),U,3)
        . D TYPE
        .; S YSF=$S(YSASFLD>10.02&(YSASFLD<10.44):"I",$P(^DD(604,YSASFLD,0),U,2)?1"P".E:"",1:"I")
        . S YSF=$S(YSASFLD>10.02&(YSASFLD<10.44):"I",YSTYPE=1:"",1:"I")
        . S X=$$GET1^DIQ(604,YSIEN,YSASFLD,YSF)
        . S:X="" YSFLAG=0,YSN=YSN+1,YSDATA(YSN)=^YSTX(604.66,N1,0)
        S X=$$GET1^DIQ(604,YSIEN,YSASFLD,.11)
        S:X="X"!(X="N") YSFLAG=2
        S:YSFLAG=0 YSDATA(2)="0^MISSING REQUIRED FIELDS"
        S:YSFLAG=2 YSDATA(2)="2^A G12 RECORD"
        Q
TYPE    ;check field type
        ;O = NOT A POINTER 1 = POINTER
        N YSFLD
        S YSTYPE=0
        D FIELD^DID(604,YSASFLD,"","TYPE","YSFLD")
        S:YSFLD("TYPE")="POINTER" YSTYPE=1
        Q
SCOREIT(YSDATA,YS)      ; from YTQAPI8
        N N,N2,N4,R,S,YSAA,I,II,DFN,YSCODE,YSADATE,YSSCALE,YSBED,YSEND
        K YSDATA,YSSONE
        D PARSE^YTAPI(.YS)
SCOR1   S (YSTEST,YSET)=$O(^YTT(601,"B",YSCODE,0))
        S YSED=YSADATE
        S YSDFN=DFN
        S YSSX=$P(^DPT(DFN,0),U,2)
        S YSTN=YSCODE
        IF '$D(^YTD(601.2,YSDFN,1,YSET,1,YSED)) S YSDATA(1)="[ERROR SCORE1+5]",YSDATA(2)="no administration found" Q
        D PRIV ;check it
        S YSR(0)=$G(^YTT(601.6,YSET,0))
        I $P(YSR(0),U,2)="Y" S X=^YTT(601.6,YSET,1) X X
        Q:$G(YSDATA(1))?1"[ERROR".E
        D SCORSET^YTAPI2
        D:YSPRIV SF^YTAPI2
        S N1=0
        F  S N1=$O(YSSONE(N1)) Q:N1'>0  S N=N+1,YSDATA(N)=YSSONE(N1)
        D CLEAN^YSMTI5 Q
PRIV    ;check privileges
        N YS71,YSKEY
        S YSPRIV=0
        S YS71=$O(^YTT(601.71,"B",YSTN,0))
        Q:YS71'>0  ;-->out error
        S YSKEY=$$GET1^DIQ(601.71,YS71_",",9)
        I YSKEY="" S YSPRIV=1 Q  ;-->out exempt
        I $D(^XUSEC(YSKEY,DUZ)) S YSPRIV=1 Q  ;-->out has key
        Q
