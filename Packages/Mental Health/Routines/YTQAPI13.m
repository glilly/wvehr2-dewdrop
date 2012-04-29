YTQAPI13        ;ASF/ALB MHQ EXPORT PROCEEDURES ; 4/3/07 11:21am
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        Q
EXPORT(YSDATA,YS)       ;export instrument
        N %X,%Y,G,I,N,N1,N2,YSCALE,YSCI,YSCNT,YSDI,YSEQ,YSERR,YSFILE,YSKEY,YSN,YSNAM,YSNUM,YSQ,YSQN,YSR,YSCT
        K ^TMP($J,"YSE"),^TMP($J,"YSQ")
        S YSCNT=0
        S YSERR=0
        D PARSE Q:YSERR  ; set/check inputs
        S YSFILE=601.71 D SET(YSNUM) ; test entry
        D CONTENT ;inst content
        D QUES ;questions
        D INTRO
        D DISPLAY ; q<i>c displays
        D CHOICE ;types & choices
        D SKIP ;skipped questions
        D RULES ;instrument rules and rules
        D SECTION
        D SCALES ;scale grps,scales,keys
        D MAIL ;export mailman
        Q
CHOICE  ;
        ;choice type
        S YSQ=0 F  S YSQ=$O(^TMP($J,"YSQ",YSQ)) Q:YSQ=""  D
        . S YSCT=$P($G(^YTT(601.72,YSQ,2)),U,3)
        . Q:YSCT'?1N.N
        . S ^TMP($J,"YSCT",YSCT)=""
        . S YSFILE=601.751 D SET(YSCT)
        S YSCT=0 F  S YSCT=$O(^TMP($J,"YSCT",YSCT)) Q:YSCT'>0  D
        . S YSCI=$P($G(^YTT(601.751,0)),U,3)
        . S YSFILE=601.75 D:YSCI?1N.N SET(YSCI)
        Q
SCALES  ;
        ;scale grp
        S YSFILE=601.86
        S YSN=0 F  S N=$O(^YTT(601.86,"AD",YSNUM,YSN)) Q:YSN'>0  D
        . S YSFILE=601.86 D SET(YSN)
        . ;scales
        . S YSCALE=0 F  S YSCALE=$O(^YTT(601.87,"AD",YSN,YSCALE)) Q:YSCALE'>0  D
        .. S YSFILE=601.87 D SET(YSCALE)
        .. S YSKEY=0 F  S YSKEY=$O(^YTT(601.91,"AC",YSCALE,YSKEY)) Q:YSKEY'>0  S YSFILE=601.91 D SET(YSKEY)
        Q
RULES   ;ins rules-rules
        S YSFILE=601.83
        S YSN=0 F  S YSN=$O(^YTT(601.83,"C",YSNUM,YSN)) Q:YSN'>0  D
        . D SET(YSN)
        S YSFILE=601.82
        S YSN=0 F  S YSN=$O(^YTT(601.83,"C",YSNUM,YSN)) Q:YSN'>0  D
        . S YSR=$P($G(^YTT(601.83,YSN,0)),U,4)
        . D:YSR?1N.N SET(YSN)
        Q
SECTION ;headings
        S YSFILE=601.81
        S YSN=0 F  S YSN=$O(^YTT(601.81,"AC",YSNUM,YSN)) Q:YSN'>0  D
        . D SET(YSN)
        Q
SKIP    ;skipped qs
        S YSFILE=601.79
        S YSN=0 F  S YSN=$O(^YTT(601.79,"AC",YSNUM,YSN)) Q:YSN'>0  D
        . D SET(YSN)
        Q
DISPLAY ;display ques<intro<choice
        S YSFILE=601.88
        S YSN=0 F  S YSN=$O(^YTT(601.76,"AC",YSNUM,YSN)) Q:YSN'>0  D
        . S G=$G(^YTT(601.76,YSN,0))
        . F I=7,8,9 S YSDI=$P(G,U,I) D:YSDI?1N.N SET(YSDI)
        Q
CONTENT ;
        S YSFILE=601.76
        S YSEQ=0 F  S YSEQ=$O(^YTT(601.76,"AD",YSNUM,YSEQ)) Q:YSEQ'>0  S YSN=0 F  S YSN=$O(^YTT(601.76,"AD",YSNUM,YSEQ,YSN)) Q:YSN'>0  D
        . D SET(YSN)
        Q
QUES    ;questions
        S YSFILE=601.72
        S YSEQ=0 F  S YSEQ=$O(^YTT(601.76,"AD",YSNUM,YSEQ)) Q:YSEQ'>0  S YSN=0 F  S YSN=$O(^YTT(601.76,"AD",YSNUM,YSEQ,YSN)) Q:YSN'>0  D
        . S YSQN=$P(^YTT(601.76,YSN,0),U,4)
        . S ^TMP($J,"YSQ",YSQN)=""
        . D SET(YSQN)
        Q
INTRO   ;intros
        S YSFILE=601.73
        S YSQN=0 F  S YSQN=$O(^TMP($J,"YSQ",YSQN)) Q:YSQN'>0  D
        . S YSN=$P($G(^YTT(601.72,YSQN,2)),U)
        . D:YSN>0 SET(YSN)
        Q
PARSE   ;get old name, new name and national
        S YSERR=1,YSDATA(1)="[ERROR]"
        S YSNAM=$G(YS("CODE"))
        I YSNAM="" S YSDATA(2)="no code" Q  ;-->out
        I '$D(^YTT(601.71,"B",YSNAM)) S YSDATA(2)="bad code" Q  ;--->out
        S YSNUM=$O(^YTT(601.71,"B",YSNAM,0)),YSDATA(1)="[DATA]",YSERR=0
        Q
MAIL    ;Mailman
        N XMSUB,XMTEXT,XMDUZ,XMY
        S XMSUB="Export of "_YS("CODE")
        S XMTEXT="^TMP($J,""YSE"","
        S XMY(DUZ)=""
        S XMDUZ="AUTOMATED MESSAGE"
        D ^XMD
        Q
SET(YSIEN)      ;content set
        S N=-1 F  S N=$O(^YTT(YSFILE,YSIEN,N)) Q:N=""  D G1
        Q
G1      D:$D(^YTT(YSFILE,YSIEN,N))#2  S N1=-1 F  S N1=$O(^YTT(YSFILE,YSIEN,N,N1)) Q:N1=""  D G2
        . S YSCNT=YSCNT+1
        . S ^TMP($J,"YSE",YSCNT)="^TMP($J,""YSI"","_YSFILE_","_YSIEN_","_N_")"
        . S YSCNT=YSCNT+1
        . S ^TMP($J,"YSE",YSCNT)=^YTT(YSFILE,YSIEN,N)
        Q
G2      D:$D(^YTT(YSFILE,YSIEN,N,N1))#2  S N2=-1 F  S N2=$O(^YTT(YSFILE,YSIEN,N,N1,N2)) Q:N2=""  D G3
        . S YSCNT=YSCNT+1
        . S ^TMP($J,"YSE",YSCNT)="^TMP($J,""YSI"","_YSFILE_","_YSIEN_","_N_","_N1_")"
        . S YSCNT=YSCNT+1
        . S ^TMP($J,"YSE",YSCNT)=^YTT(YSFILE,YSIEN,N,N1)
        Q
G3      D:$D(^YTT(YSFILE,YSIEN,N,N1,N2))#2
        . S YSCNT=YSCNT+1
        . S ^TMP($J,"YSE",YSCNT)="^TMP($J,""YSI"","_YSFILE_","_YSIEN_","_N_","_N1_","_N2_")"
        . S YSCNT=YSCNT+1
        . S ^TMP($J,"YSE",YSCNT)=^YTT(YSFILE,YSIEN,N,N1,N2)
        Q
