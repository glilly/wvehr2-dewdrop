YTQPXRM3        ;ASF/ALB MHQ REMOTE PROCEDURES CONT ; 5/7/07 10:44am
        ;;5.01;MENTAL HEALTH;**85**;DEC 30,1994;Build 49
        ;
        Q
QUESTALL(YSDATA,YS)     ;all questions for a test
        ;input: CODE as test name
        ;output: Field^Value
        N YSTESTN,YSTEST,YSF,YSV,N,N2,N3,YSEQX,YSERR,YSLEGA,YSRR,YSCHOT,YSCHOICE,G,YSLN,YSIC,YSQN,YSF,YSCODE,YSQNUMB
        S YSDATA=$NA(^TMP($J,"YSQU")) K ^TMP($J,"YSQU")
        S YSCODE=$G(YS("CODE"),0)
        S YSTESTN=$O(^YTT(601.71,"B",YSCODE,0))
        I YSTESTN'>0 S ^TMP($J,"YSQU",1)="[ERROR]",^TMP($J,"YSQU",2)="bad code" Q  ;-->out
        S YSQNUMB=0
        S ^TMP($J,"YSQU",1)="[DATA]"
        ;
        S YSEQX=0
        F  S YSEQX=$O(^YTT(601.76,"AD",YSTESTN,YSEQX)) Q:YSEQX'>0  D
        . S YSIC=0 F  S YSIC=$O(^YTT(601.76,"AD",YSTESTN,YSEQX,YSIC)) Q:YSIC'>0  S YSQN=$P(^YTT(601.76,YSIC,0),U,4) D QUEST2
        S ^TMP($J,"YSQU",2)=YSCODE_U_"NUMBER OF QUESTIONS="_YSQNUMB
        ;now check Ok for clinical reminders
        D CHECKME
        Q
QUEST2  ;
        S YSQNUMB=YSQNUMB+1
        S ^TMP($J,"YSQU","YSCROSS",YSQNUMB)=YSQN
        ;text
        S N2=0 F  S N2=$O(^YTT(601.72,YSQN,1,N2)) Q:N2'>0  S ^TMP($J,"YSQU",YSQNUMB,"T",N2)=$P($G(^YTT(601.72,YSQN,1,N2,0)),U)
        ;intro
        S G=+$G(^YTT(601.72,YSQN,2))
        S N2=0 F  S N2=$O(^YTT(601.73,G,1,N2)) Q:N2'>0  S ^TMP($J,"YSQU",YSQNUMB,"I",N2)=$P($G(^YTT(601.73,+G,1,N2,0)),U)
        ;responses
        S YSLN=0
        ;S ^TMP($J,"YSQU",YSQNUMB,"R",0)="X"
        S YSCHOT=$P($G(^YTT(601.72,YSQN,2)),U,3)
        Q:YSCHOT'>0
        S N2=0 F  S N2=$O(^YTT(601.751,"AC",YSCHOT,N2)) Q:N2'>0  D
        . S YSCHOICE=$O(^YTT(601.751,"AC",YSCHOT,N2,0))
        . Q:YSCHOICE'>0
        . Q:$P(^YTT(601.75,YSCHOICE,0),U,2)=""
        . ;Q:($P(^YTT(601.75,YSCHOICE,0),U,2)="")
        . S YSLN=YSLN+1
        . S ^TMP($J,"YSQU",YSQNUMB,"R",YSLN)=$P($G(^YTT(601.75,YSCHOICE,1)),U)
        . S ^TMP($J,"YSQU",YSQNUMB,"R",0)=$G(^TMP($J,"YSQU",YSQNUMB,"R",0))_$P($G(^YTT(601.75,YSCHOICE,0)),U,2)
        . S ^TMP($J,"YSQU","YSCA",YSQN,$P(^YTT(601.75,YSCHOICE,0),U,2))=YSCHOICE
        Q
CHECKME ;cr checker
        S YSERR=0
        I YSQNUMB>200 D CLEAN(YSQNUMB_" is too many questions") Q  ;-->out
        S N2=0 F  S N2=$O(^TMP($J,"YSQU",N2)) Q:N2'>0!YSERR  D
        . S YSLEGA=$G(^TMP($J,"YSQU",N2,"R",0))
        . D:YSLEGA="X" CLEAN(N2_" no legacy") Q  ;--out
        . S YSRR=$O(^TMP($J,"YSQU",YSQNUMB,"R",9999),-1)
        . D:YSRR'=($L(YSLEGA)-1) CLEAN(N2_" not all legacy")
        Q
CLEAN(X)        ;
        K ^TMP($J,"YSQU")
        S ^TMP($J,"YSQU",1)="[ERROR]"
        S ^TMP($J,"YSQU",2)=X
        Q
OLDNEW(YSCODEN,YSOLDNUM)        ;
        ;input YSCODEN ien OF 601.71
        ;      YSOLDNUM as ien of "S" MULT of 601 (1= DEFAULT)
        ;output ien OF 601.87, 0=ERROR
        ;
        N N2,YSQQ,YSNAME,YS601,YSOLDNAM,YSNEWN,YSCALE1,YSC1
        IF $G(YSOLDNUM)="" S YSOLDNUM=1
        S YSOUT=0
        I '$D(^YTT(601.71,YSCODEN,0)) Q YSOUT  ;->out
        S YSNAME=$P(^YTT(601.71,YSCODEN,0),U)
        S YS601=$O(^YTT(601,"B",YSNAME,0)) Q:YS601'>0 YSOUT  ;-->out
        I '$D(^YTT(601,YS601,"S",YSOLDNUM,0)) Q YSOUT  ;-->out
        S YSOLDNAM=$P(^YTT(601,YS601,"S",YSOLDNUM,0),U,2)
        D SCALES^YTQPXRM5(.YSQQ,YSCODEN)
        S N2=0 F  S N2=$O(YSQQ("S",N2)) Q:N2'>0  D
        . S YSCALE1=YSQQ("S",N2)
        . S YSC1($$UCASE^YTQPXRM6(YSCALE1),N2)=""
        S YSNEWN=$O(YSC1($$UCASE^YTQPXRM6(YSOLDNAM),0))
        S:YSNEWN>0 YSOUT=YSNEWN
        Q YSOUT
NEWOLD(YSCODEN,YSNEW)   ;
        ;input YSCODEN ien OF 601.71
        ;      YSNEW   ien OF 601.87, 0=ERROR
        ;output  YSOLD as ien of "S" MULT of 601 (1= DEFAULT)
        ;
        N N2,YSX,YSQQ,YSNAME,YS601,YSOLDNAM,YSNEWN,YSON,YSOLDN,YSCNEW
        IF YSNEW="" S YSNEW=1
        S YSOUT=0
        I '$D(^YTT(601.71,YSCODEN,0)) Q YSOUT  ;->out
        S YSNAME=$P(^YTT(601.71,YSCODEN,0),U)
        S YS601=$O(^YTT(601,"B",YSNAME,0)) Q:YS601'>0 YSOUT  ;-->out
        I '$D(^YTT(601.87,YSNEW)) Q YSOUT  ;-->out
        S YSCNEW=$P(^YTT(601.87,YSNEW,0),U,4)
        S N=0 F  S N=$O(^YTT(601,YS601,"S",N)) Q:N'>0  D
        . S YSON=$P(^YTT(601,YS601,"S",N,0),U,2)
        . S YSX($$UCASE^YTQPXRM6(YSON),N)=""
        S YSOLDN=$O(YSX($$UCASE^YTQPXRM6(YSCNEW),0))
        S:YSOLDN>0 YSOUT=YSOLDN
        Q YSOUT
RL(YSCODEN)     ;requires license
        ;input YSCODEN ien OF 601.71
        ;output  Y/N/0
        ;
        N X
        S YSOUT=0
        I '$D(^YTT(601.71,YSCODEN,0)) Q YSOUT  ;->out
        S X=$$GET1^DIQ(601.71,YSCODEN_",",11,"I")
        S YSOUT=$S(X="Y":"Y",X="N":"N",1:0)
        Q YSOUT
