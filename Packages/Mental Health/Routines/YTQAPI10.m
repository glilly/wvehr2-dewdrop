YTQAPI10        ;ASF/ALB MHQ COPY PROCEEDURES ;12/2/04 11:41am
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        Q
ZZ      K YS,YSDATA R !,"OLD TEST: ",Z1:30 R !,"new test: ",Z2:30
        S YS("ORIGINAL")=Z1,YS("NEW")=Z2 D COPY(.YSDATA,.YS)
        Q
COPY(YSDATA,YS) ;copy instrument
        N %X,%Y,DA,DIK,G,G1,G2,N,N1,N3,X,Y,YSDISNEW,YSDISOLD,YSECNEW,YSERR
        N YSFILE,YSI,YSISRNEW,YSKEYNEW,YSKEYOLD,YSKIPNEW,YSN,YSN1,YSNAT,YSNEWI,YSNEWNAM,YSNEWNUM,YSOLDI,YSOLDNAM
        N YSOLDNUM,YSPROG,YSQUNEW,YSQX,YSRULNEW,YSRULOLD,YSSGNEW,YSSGOLD,YSSLNEW,YSSLOLD,Z1,Z2
        S YSERR=0
        K ^TMP($J,"YSM")
        D PARSE Q:YSERR  ; set/check inputs
        D INS ;add new test entry
        D QUES ;duplicate questions
        D INTRO ;introductions
        D DISPLAY ; q<i>c displays
        D SKIP ;skipped questions
        D RULES^YTQAPI11 ;instrument rules and rules
        D SECTION
        D SCALES^YTQAPI11 ;scale grps,scales,keys
        S YSDATA(1)="[DATA]"
        Q
SECTION ;headings
        S YSFILE=601.81,N=0
        S N=$O(^YTT(601.81,"AC",YSOLDNUM,N)) Q:N'>0  D
        . S G1=^YTT(601.81,N,0)
        . S YSECNEW=$$NEW^YTQLIB(YSFILE)
        . S ^YTT(601.81,YSECNEW,0)=G1
        . S $P(^YTT(601.81,YSECNEW,0),U)=YSECNEW
        . S $P(^YTT(601.81,YSECNEW,0),U,2)=YSNEWNUM
        . S YSQX=$P(G1,U,3)
        . I (YSQX?1N.N)&($D(^TMP($J,"YSM","O",YSQX))) S $P(^YTT(601.81,YSECNEW,0),U,3)=^TMP($J,"YSM","O",YSQX)
        . S DA=YSECNEW,DIK="^YTT("_YSFILE_"," D IX^DIK
        . S YSDISOLD=$P(G1,U,6)
        . Q:YSDISOLD'?1N.N
        . S YSDISNEW=$$NEW^YTQLIB(YSFILE)
        . S %X="^YTT(601.88,"_YSDISOLD_","
        . S %Y="^YTT(601.88,"_YSDISNEW_","
        . D %XY^%RCR
        . S $P(^YTT(601.88,YSDISNEW,0),U)=YSDISNEW
        . S DA=YSDISNEW,DIK="^YTT(601.88," D IX^DIK
        . S $P(^YTT(601.81,YSECNEW,0),U,6)=YSDISNEW
        Q
SKIP    ;skipped qs
        S YSFILE=601.79,N=0
        F  S N=$O(^YTT(601.79,"AC",YSOLDNUM,N)) Q:N'>0  D
        . S G1=^YTT(601.79,N,0)
        . S YSKIPNEW=$$NEW^YTQLIB(YSFILE)
        . S ^YTT(601.79,YSKIPNEW,0)=G1
        . S $P(^YTT(601.79,YSKIPNEW,0),U)=YSKIPNEW
        . S $P(^YTT(601.79,YSKIPNEW,0),U,2)=YSNEWNUM
        . S YSQX=$P(G1,U,3)
        . I (YSQX?1N.N)&($D(^TMP($J,"YSM","O",YSQX))) S $P(^YTT(601.79,YSKIPNEW,0),U,3)=^TMP($J,"YSM","O",YSQX)
        S DA=YSKIPNEW,DIK="^YTT("_YSFILE_"," D IX^DIK
        Q
DISPLAY ;display ques<intro<choice
        S YSFILE=601.88
        S YSN=0 F  S YSN=$O(^YTT(601.76,"AC",YSNEWNUM,YSN)) Q:YSN'>0  D
        . S G=^YTT(601.76,YSN,0)
        . F YSI=7,8,9 S YSDISOLD=$P(G,U,YSI) D:YSDISOLD?1N.N
        .. S YSDISNEW=$$NEW^YTQLIB(YSFILE)
        .. S %X="^YTT("_YSFILE_","_YSDISOLD_","
        .. S %Y="^YTT("_YSFILE_","_YSDISNEW_","
        .. D %XY^%RCR
        .. S $P(^YTT(601.88,YSDISNEW,0),U)=YSDISNEW
        .. S DA=YSDISNEW,DIK="^YTT("_YSFILE_"," D IX^DIK
        .. S $P(^YTT(601.76,YSN,0),U,YSI)=YSDISNEW
        Q
INS     ; new one
        S YSFILE=601.71
        S YSOLDNUM=$O(^YTT(601.71,"B",YSOLDNAM,-1))
        S YSNEWNUM=$$NEW^YTQLIB(YSFILE)
        S %X="^YTT("_YSFILE_","_YSOLDNUM_","
        S %Y="^YTT("_YSFILE_","_YSNEWNUM_","
        D %XY^%RCR
        S $P(^YTT(YSFILE,YSNEWNUM,0),U)=YSNEWNAM
        S $P(^YTT(YSFILE,YSNEWNUM,2),U,2)="U"
        S $P(^YTT(YSFILE,YSNEWNUM,2),U,5)=""
        S DA=YSNEWNUM,DIK="^YTT("_YSFILE_"," D IX^DIK
        Q
QUES    ;questions, content and intros
        S N=0 F  S N=$O(^YTT(601.76,"AD",YSOLDNUM,N)) Q:N'>0  D
        . S YSQUNEW=$$NEW^YTQLIB(601.72)
        . S %X="^YTT(601.72,"_N_","
        . S %Y="^YTT(601.72,"_YSQUNEW_","
        . D %XY^%RCR
        . S $P(^YTT(601.72,YSQUNEW,0),U)=YSQUNEW
        . S ^TMP($J,"YSM","N",YSQUNEW)=N
        . S ^TMP($J,"YSM","O",N)=YSQUNEW
        . S DA=YSQUNEW,DIK="^YTT(601.72," D IX^DIK ;xref questions
        . S N1=0 F  S N1=$O(^YTT(601.76,"AD",YSOLDNUM,N,N1)) Q:N1'>0  D
        ..S N3=$$NEW^YTQLIB(601.76)
        .. S ^YTT(601.76,N3,0)=^YTT(601.76,N1,0)
        .. S $P(^YTT(601.76,N3,0),U)=N3
        .. S $P(^YTT(601.76,N3,0),U,2)=YSNEWNUM
        .. S DA=N3,DIK="^YTT(601.76," D IX^DIK
        Q
INTRO   ;set intros
        S N=0 F  S N=$O(^TMP($J,"YSM","N",N)) Q:N'>0  D
        . S YSOLDI=$P($G(^YTT(601.72,N,2)),U)
        . Q:YSOLDI'?1N.N
        . S YSNEWI=$$NEW^YTQLIB(601.73)
        . S %X="^YTT(601.73,"_YSOLDI_","
        . S %Y="^YTT(601.72,"_YSNEWI_","
        . D %XY^%RCR
        . S $P(^YTT(601.73,YSNEWI,0),U)=YSNEWI
        . S DA=YSNEWI,DIK="^YTT(601.73," D IX^DIK
        . S $P(^YTT(601.72,N,2),U)=YSNEWI
        Q
PARSE   ;get old name, new name and national
        S YSOLDNAM=$G(YS("ORIGINAL"))
        I YSOLDNAM="" S YSDATA(1)="[ERROR]",YSDATA(2)="bad orig",YSERR=1 Q  ;-->out
        I '$D(^YTT(601.71,"B",YSOLDNAM)) S YSDATA(1)="[ERROR]",YSDATA(2)="orig not found",YSERR=1 Q  ;-->out
        S YSNEWNAM=$G(YS("NEW"))
        I YSNEWNAM="" S YSDATA(1)="[ERROR]",YSDATA(2)="bad new",YSERR=1 Q  ;-->out
        I $D(^YTT(601.71,"B",YSNEWNAM)) S YSDATA(1)="[ERROR]",YSDATA(2)="new already exits",YSERR=1 Q  ;-->out
        I $L(YSNEWNAM)>50!($L(YSNEWNAM)<3)!'(YSNEWNAM'?1P.E) S YSDATA(1)="[ERROR]",YSDATA(2)="new out out bounds",YSERR=1 Q  ;-->out
        S YSNAT=$G(YS("NATIONAL"),0)
        K YSPROG S:YSNAT=1&($D(^XUSEC("YSPROG",DUZ))) YSPROG=1
        Q
