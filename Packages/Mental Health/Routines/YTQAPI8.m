YTQAPI8 ;ASF/ALB- MHAX SCORING ; 11/15/07 11:14am
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        Q
OLDSCORE        ;score answers fro 601.2
        D SCOREIT^YTQAPI14(.YSDATA,.YS)
        I YSDATA(1)="[ERROR]" S ^TMP($J,"YSCOR",1)="[ERROR]",^TMP($J,"YSCOR",2)="bad OLDSCORE" Q  ;-->out
        D MVSCORE
        Q
LGSCORE ;score legacy test in 84
        N YSEE
        S YSEE=0
        S X1=^YTT(601.84,YSAD,0)
        S DFN=$P(X1,U,2),YSDATE=$P(X1,U,4)
        S YSOLDI=$O(^YTT(601,"B",YSCODE,0))
        S YSQN=0,N=1,X=""
        F  S YSQN=$O(^YTT(601.85,"AC",YSAD,YSQN)) Q:YSQN'>0  D
        . S YSANSI=$O(^YTT(601.85,"AC",YSAD,YSQN,0))
        . S YSCI=$P($G(^YTT(601.85,YSANSI,0)),U,4)
        . I YSCI'?1N.N S YSEE=1 Q  ;-->out ASF 3/7/07
        . I '$D(^YTT(601.75,YSCI)) S YSEE=1 Q  ;-->out ASF 3/7/07
        . S YSLG=$P(^YTT(601.75,YSCI,0),U,2) S:YSLG="" YSLG=" "
        . S X=X_YSLG
        . I $L(X)=200 S ^YTD(601.2,DFN,1,YSOLDI,1,YSDATE,N)=X,X="",N=N+1
        I YSEE K ^YTD(601.2,DFN,1,YSOLDI,1,YSDATE) S ^TMP($J,"YSCOR",1)="[ERROR]",^TMP($J,"YSCOR",2)="bad LG CHOICE" Q  ;-->out
        S:$L(X) ^YTD(601.2,DFN,1,YSOLDI,1,YSDATE,N)=X
        S ^YTD(601.2,DFN,1,YSOLDI,1,YSDATE,0)=YSDATE_U_U_$P(X1,U,6)_U_$P(X1,U,7)
        S YS("DFN")=DFN,YS("CODE")=YSCODE,YS("ADATE")=YSDATE
        D SCOREIT^YTQAPI14(.YSDATA,.YS) ;ASF 7/12/07
        K ^YTD(601.2,DFN,1,YSOLDI,1,YSDATE)
        I YSDATA(1)="[ERROR]" S ^TMP($J,"YSCOR",1)="[ERROR]",^TMP($J,"YSCOR",2)="bad LG SCORE" Q  ;-->out
        D MVSCORE
        Q
MVSCORE ;move results
        K ^TMP($J,"YSCOR")
        S ^TMP($J,"YSCOR",1)="[DATA]"
        S N1=1,N2=5
        F  S N2=$O(YSDATA(N2)) Q:N2'>0  S N1=N1+1,^TMP($J,"YSCOR",N1)=$P(YSDATA(N2),U,2)_"="_$P(YSDATA(N2),U,3)_U_$P(YSDATA(N2),U,4)
        K YSDATA S YSDATA=$NA(^TMP($J,"YSCOR"))
        Q
GETSCORE(YSDATA,YS)     ;get scales and scale grps for a test
        ; input: AD as administration ID
        ; output: Scale name=Raw Score
        N YSCODE,YSCODEN,N,N2,X,X1,I,YSAD,YSAI,YSTARG,YSAN,YSCALEI,YSKEYI,YSQN,YSRAW,YSVAL,YSDA,YSLG,N1,YSADATE,YSANSI,YSCI,YSDATE,YSDFN,YSOLDI,YSLIMIT,YSXT,DFN
        K ^TMP($J,"YSCOR") S YSDATA=$NA(^TMP($J,"YSCOR"))
        S YSAD=$G(YS("AD"))
        S YSADATE=$G(YS("ADATE")),YSCODE=$G(YS("CODE")),DFN=$G(YS("DFN"))
        I (YSADATE?7N.E)&(YSAD'?1N.N) D OLDSCORE Q  ;-->out Score answers from 601.2
        I YSAD'?1N.N S ^TMP($J,"YSCOR",1)="[ERROR]",^TMP($J,"YSCOR",2)="bad ad num" Q  ;-->out
        I '$D(^YTT(601.85,"AC",YSAD)) S ^TMP($J,"YSCOR",1)="[ERROR]",^TMP($J,"YSCOR",2)="no such reference" Q  ;-->out
        S YSCODE=$$GET1^DIQ(601.84,YSAD_",",2)
        S YSCODEN=$$GET1^DIQ(601.84,YSAD_",",2,"I")
        I '$D(^YTT(601.71,"B",YSCODE)) S ^TMP($J,"YSCOR",1)="[ERROR]",^TMP($J,"YSCOR",2)="no ins" Q  ;-->out
        S YSDA=$O(^YTT(601.71,"B",YSCODE,0))
        S YSLG=$$GET1^DIQ(601.71,YSDA_",",23)
        I YSLG="Yes" D LGSCORE Q  ;-->out Score legacy answers in 601.85
        I '$D(^YTT(601.86,"AC",YSCODEN)) S ^TMP($J,"YSCOR",1)="[ERROR]",^TMP($J,"YSCOR",2)="no scale grps found" Q  ;-->out
        S YS("CODE")=YSCODE
        D SCALEG^YTQAPI3(.YSDATA,.YS)
        S YSDATA=$NA(^TMP($J,"YSCOR"))
        S ^TMP($J,"YSCOR",1)="[DATA]",N=1
        F I=2:1 Q:'$D(^TMP($J,"YSG",I))  I ^TMP($J,"YSG",I)?1"Scale".E S YSRAW="0",N=N+1,^TMP($J,"YSCOR",N)=$P(^TMP($J,"YSG",I),U,4)_"=" D  S ^TMP($J,"YSCOR",N)=^TMP($J,"YSCOR",N)_YSRAW
        . S YSCALEI=$P(^TMP($J,"YSG",I),U),YSCALEI=$P(YSCALEI,"=",2)
        . S YSKEYI=0 F  S YSKEYI=$O(^YTT(601.91,"AC",YSCALEI,YSKEYI)) Q:YSKEYI'>0  D
        .. S G=^YTT(601.91,YSKEYI,0)
        .. S YSQN=$P(G,U,3),YSTARG=$P(G,U,4),YSVAL=$P(G,U,5)
        .. S YSAI=$O(^YTT(601.85,"AC",YSAD,YSQN,0))
        .. Q:YSAI'>0
        .. Q:'$D(^YTT(601.85,YSAI,0))  ;ASF 11/15/07
        .. S YSAN=""
        .. I $D(^YTT(601.85,YSAI,1,1,0)) S YSAN=^YTT(601.85,YSAI,1,1,0)
        .. I $P(^YTT(601.85,YSAI,0),U,4)?1N.N S YSAN=$P(^YTT(601.85,YSAI,0),U,4),YSAN=$G(^YTT(601.75,YSAN,1))
        .. I YSAN=YSTARG S YSRAW=YSRAW+YSVAL
        Q
DELSG(YSDATA,YS)        ; DELETE SCALES AND SCALEGROUP-careful!!!
        ;input: ID as ien of 601.86 scalegroup
        ;output DATAvsERROR
        N YSIEN,YSID,I,N,DA,DIK
        S YSID=$G(YS("ID"),-1)
        I '$D(^YTT(601.86,YSID,0)) S YSDATA(1)="[ERROR]",YSDATA(2)="bad id" Q  ;-->out
        S N=0,YSDATA(1)="[DATA]"
        S YSEQ=0 F  S YSEQ=$O(^YTT(601.87,"AC",YSID,YSEQ)) Q:YSEQ'>0  D
        . S DA=$O(^YTT(601.87,"AC",YSID,YSEQ,0))
        . S DIK="^YTT(601.87,"
        . S N=N+1
        . D ^DIK
        S DA=YSID,DIK="^YTT(601.86," D ^DIK
        S YSDATA(2)=N_" scales deleted"
        Q
SCALEGRP(YSDATA,YS)     ;return scalegroup info
        ; input: CODE as instrument name
        ; output: SCALEGROUP ID^INSTRUMENT ID^SCALEGROUP NAME^GROUP SEQUENCE^ORDINATE TITLE^ORDINATEMIN^ORDINATEINCREMENT^ORDINATEMAX^GRID1^GRID2^GRID3
        N YSCODE,YSCODEN,YSEQ,G,YSIEN,N
        K ^TMP($J,"YSSG")
        S YSDATA=$NA(^TMP($J,"YSSG"))
        S YSCODE=$G(YS("CODE"),0)
        I '$D(^YTT(601.71,"B",YSCODE)) S ^TMP($J,"YSSG",1)="[ERROR]",^TMP($J,"YSSG",2)="no ins" Q  ;-->out
        S YSCODEN=$O(^YTT(601.71,"B",YSCODE,0))
        I '$D(^YTT(601.86,"AC",YSCODEN)) S ^TMP($J,"YSSG",1)="[ERROR]",^TMP($J,"YSSG",2)="no scale grps here" Q  ;-->out
        S N=1,^TMP($J,"YSSG",1)="[DATA]"
        S YSEQ=0 F  S YSEQ=$O(^YTT(601.86,"AC",YSCODEN,YSEQ)) Q:YSEQ=""  D
        . S YSIEN=$O(^YTT(601.86,"AC",YSCODEN,YSEQ,0))
        . S G=^YTT(601.86,YSIEN,0)
        . S N=N+1,^TMP($J,"YSSG",N)=G
        Q
LEGACY(YSDATA,YS)       ;
        K ^TMP("YSDATA",$J) S YSDATA=$NA(^TMP("YSDATA",$J))
        S YSAD=$G(YS("AD"))
        I YSAD'?1N.N S YSDATA(1)="[ERROR]",YSDATA(2)="bad ad num" Q  ;-->out
        I '$D(^YTT(601.85,"AC",YSAD)) S YSDATA(1)="[ERROR]",YSDATA(2)="no such reference" Q  ;-->out
        S YSDATA(1)="[DATA]"
        S X1=^YTT(601.84,YSAD,0)
        S DFN=$P(X1,U,2),YSDATE=$P(X1,U,4)
        S YSCODE=$$GET1^DIQ(601.84,YSAD_",",2)
        S YSOLDI=$O(^YTT(601,"B",YSCODE,0))
        S YSQN=0,N=1,X=""
        F  S YSQN=$O(^YTT(601.85,"AC",YSAD,YSQN)) Q:YSQN'>0  D
        . S YSANSI=$O(^YTT(601.85,"AC",YSAD,YSQN,0))
        . S YSCI=$P(^YTT(601.85,YSANSI,0),U,4)
        . Q:YSCI'?1N.N
        . S YSLG=$P(^YTT(601.75,YSCI,0),U,2) S:YSLG="" YSLG=" "
        . S X=X_YSLG
        . I $L(X)=200 S ^YTD(601.2,DFN,1,YSOLDI,1,YSDATE,N)=X,X="",N=N+1
        S:$L(X) ^YTD(601.2,DFN,1,YSOLDI,1,YSDATE,N)=X
        S ^YTD(601.2,DFN,1,YSOLDI,1,YSDATE,0)=YSDATE_U_U_$P(X1,U,6)_U_$P(X1,U,7)
        S YSDFN=DFN,YSXT=YSDATE_","_YSOLDI D INTRMNT^YTRPWRP(.YSDATA,YSDFN,YSXT)
        K ^YTD(601.2,DFN,1,YSOLDI,1,YSDATE)
        Q
