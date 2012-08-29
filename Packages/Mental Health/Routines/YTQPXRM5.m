YTQPXRM5        ;ASF/ALB CLINICAL REMINDERS CONT ; 7/13/07 2:27pm
        ;;5.01;MENTAL HEALTH;**85**;DEC 30,1994;Build 49
        ;
        Q
CRTEST(YSDATA,YS)       ;clinical reminders approrpiate instruments
        ;input: LIMIT highest # of questions allowed (25 is default)
        ;output: [DATA] vs [ERROR] 0K vs error msg
        ;         test_name^601.71 ien^# of questions
        N YSLIMIT,YSCODE,YSCODEN,YSNUMB,YSG,YSIEN,YSOPER,YSQG2,YSERR,YSCTYPE,YSCHT,YSCHOICE,YSLEG,YSQN,YSNN
        K YSDATA
        S YSLIMIT=$G(YS("LIMIT"),25)
        S YSDATA(1)="[DATA]",YSNN=1
        S YSCODE=""
        F  S YSCODE=$O(^YTT(601.71,"B",YSCODE)) Q:YSCODE=""  S YSERR=0,YSNUMB=0,YSCODEN=$O(^YTT(601.71,"B",YSCODE,0)) D TCK,SETCR
        Q
TCK     ;check a test for CR
        S YSOPER=$$GET1^DIQ(601.71,YSCODEN_",",10,"I")
        IF YSOPER="C" S YSNUMB="C" Q  ;-->out ASF 11/1/06
        Q:(YSOPER'="Y")
        S YSIEN=0 F  S YSIEN=$O(^YTT(601.76,"AC",YSCODEN,YSIEN)) Q:YSIEN'>0  S YSNUMB=YSNUMB+1
        Q
SETCR   ;set out queue
        I (YSNUMB=0)!(YSNUMB>YSLIMIT)!(YSERR=1) Q  ;->out
        S YSNN=YSNN+1,YSDATA(YSNN)=YSCODE_U_YSCODEN_U_YSNUMB
        Q
ONECR(YSCODEN,YSLIMIT)  ;FUNCTION check one test for CR 
        ;input YSCODEN ien OF 601.71
        ;      YSLIMIT # OF QUESTIONS (25 DEFAULT)
        ;output 1: OK for CR
        ;
        N YSOPER,YSERR,YSIEN,YSNUMB
        S YSOK=0
        I '$D(^YTT(601.71,YSCODEN,0)) Q YSOK  ;->out
        I $P(^YTT(601.71,YSCODEN,0),U)="ASI" Q YSOK  ;-->out
        S YSLIMIT=$G(YSLIMIT,25)
        S YSNUMB=0,YSERR=0 D TCK
        I (YSNUMB=0)!(YSNUMB>YSLIMIT)!(YSERR=1) Q YSOK  ;->out
        S YSOK=1
        Q YSOK
SHOWALL(YSDATA,YS)      ;
        ;returns all item information for a specified test
        ; same format as SHOWALL^YTAPI3
        N G,YSCODE,YSCODEN,YSNUMB,YSEQ,YSIEN,YSR,YSCTYPE,YSG,YSQN,YSQG2,YSCHTSEQ,YSLEG,YSCTEXT,YSCHOICE,YSINTRO,YSLINES,N1
        K YSDATA
        S YSCODE=$G(YS("CODE"),0)
        I '$D(^YTT(601.71,"B",YSCODE)) S YSDATA(1)="[ERROR]",YSDATA(2)="INCORRECT TEST CODE" Q
        S YSCODEN=$O(^YTT(601.71,"B",YSCODE,0))
        S YSNUMB=0
        S YSDATA(1)="[DATA]"
        S YSDATA(2)=YSCODE_U_$P(^YTT(601.71,YSCODEN,0),U,3)
        ;Loop thru test for all items
        S YSEQ=0 F  S YSEQ=$O(^YTT(601.76,"AD",YSCODEN,YSEQ)) Q:YSEQ'>0  S YSIEN=$O(^YTT(601.76,"AD",YSCODEN,YSEQ,0)) Q:YSIEN'>0  S YSNUMB=YSNUMB+1,YSR=0 D
        . S YSG=^YTT(601.76,YSIEN,0),YSQN=$P(YSG,U,4),YSQG2=$G(^YTT(601.72,YSQN,2))
        . D GETTEXT
        . S YSCTYPE=$P(YSQG2,U,3) Q:YSCTYPE=""  ;->out
        . S YSCHTSEQ=0 F  S YSCHTSEQ=$O(^YTT(601.751,"AC",YSCTYPE,YSCHTSEQ)) Q:YSCHTSEQ'>0  D
        .. S YSCHOICE=$O(^YTT(601.751,"AC",YSCTYPE,YSCHTSEQ,0)) Q:YSCHOICE'>0  D
        ... S YSCTEXT=$G(^YTT(601.75,YSCHOICE,1))
        ... S YSLEG=$P($G(^YTT(601.75,YSCHOICE,0)),U,2)
        ... D RESP
        Q
GETTEXT ;pull text and intros
        S N1=0,YSLINES=0 F  S N1=$O(^YTT(601.72,YSQN,1,N1)) Q:N1'>0  S YSLINES=N1 D
        . S YSDATA(YSNUMB,"T",N1)=^YTT(601.72,YSQN,1,N1,0)
        S YSLINES=YSLINES+1,YSDATA(YSNUMB,"T",YSLINES)=" "
        S YSINTRO=$P($G(^YTT(601.72,YSQN,2)),U)
        Q:YSINTRO'?1N.N
        S N1=0 F  S N1=$O(^YTT(601.73,YSINTRO,1,N1)) Q:N1'>0  D
        . S YSDATA(YSNUMB,"I",N1)=^YTT(601.73,YSINTRO,1,N1,0)
        Q
RESP    ;get approp responses
        S YSDATA(YSNUMB,"R",1)="Answer= "
        S YSDATA(YSNUMB,"R",0)=$G(YSDATA(YSNUMB,"R",0))_YSLEG
        S YSLINES=YSLINES+1,YSDATA(YSNUMB,"T",YSLINES)=YSLEG_". "_YSCTEXT
        Q
SCALES(YSDATA,YSCODEN)  ;scales for a test
        ;input :YSCODEN AS 601.71 IEN
        ;output scalename^601.82 ENTRY
        N G,YSCODE,N,N1,YS1,YSZ,YS87,YSONLY,YSNAME
        ;S YSCODEN=$G(YS("CODE"),0)
        I '$D(^YTT(601.71,YSCODEN,0)) S YSDATA(1)="[ERROR]",YSDATA(2)="bad code" Q  ;->out
        S YSCODE=$P(^YTT(601.71,YSCODEN,0),U)
        I YSCODE="ASI" D  Q  ;-->out
        . S YSDATA(1)="[DATA]"
        . S YSDATA("S",1)="Medical"
        . S YSDATA("S",2)="Employment"
        . S YSDATA("S",3)="Alcohol"
        . S YSDATA("S",4)="Drug"
        . S YSDATA("S",5)="Legal"
        . S YSDATA("S",6)="Family"
        . S YSDATA("S",7)="Psychiatric"
        S YS1("CODE")=YSCODE D SCALEG^YTQAPI3(.YSZ,.YS1)
        S YSDATA(1)="[DATA]"
        S N=0 F  S N=$O(^TMP($J,"YSG",N)) Q:N'>0  D
        . S G=^TMP($J,"YSG",N)
        . S YSNAME=$P(G,U,4),YS87=$P($P(G,U,1),"=",2)
        . Q:G'?1"Scale".E
        . S:'$D(YSONLY(YSNAME)) YSONLY(YSNAME)="",YSDATA("S",YS87)=YSNAME
        K ^TMP($J,"YSG")
        Q
SCNAME(YSIEN)   ;get scale name from 601.87 ien
        ;input 601.87 ien
        N YS87
        S YS87=0
        Q:YSIEN'?1N.N YS87  ;out-->
        Q:'$D(^YTT(601.87,YSIEN)) YS87  ;out-->
        S YS87=$$GET1^DIQ(601.87,YSIEN_",",3)
        Q YS87
ALLKEYS(YSDATA,YS)      ;Return ALL or most KEYS that a user has.
        ;input IEN as internal of file 200 [optional/DUZ]
        N YSIEN,I,J,K,L K ^TMP("YSXU",$J)
        S YSIEN=$G(YS("IEN"))
        S:YSIEN="" YSIEN=DUZ
        I YSIEN'>0 S YSDATA(1)="[ERROR]" Q
        S I=0,L=1,YSDATA(1)="[DATA]"
        F  S I=$O(^VA(200,YSIEN,51,I)) Q:I'>0  S K=$G(^DIC(19.1,I,0)) D
        . S L=L+1,YSDATA(L)=$P(K,U,1)
        . Q
