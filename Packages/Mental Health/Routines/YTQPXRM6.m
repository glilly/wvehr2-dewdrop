YTQPXRM6        ;ASF/ALB CLINICAL REMINDERS CONT ; 11/15/07 10:57am
        ;;5.01;MENTAL HEALTH;**85**;DEC 30,1994;Build 49
        ;
        Q
CONVERT(YSDATA,YS)      ;convet 601 ien into 601.71 iens
        ;input YS601 AS 601 IEN
        ;output 601.71 ien
        N YS601,YS60171,YSCODE,YSOP
        S YS601=$G(YS("YS601"),0)
        I YS601=0 S YSDATA(1)="[ERROR]",YSDATA(2)="NO code" Q  ;-->out
        S YSCODE=$P($G(^YTT(601,YS601,0)),U)
        I YSCODE'?2AN.E S YSDATA(1)="[ERROR]",YSDATA(2)="bad 601" Q  ;-->out
        S YS60171=$O(^YTT(601.71,"B",YSCODE,0))
        I YS60171'>0  S YSDATA(1)="[ERROR]",YSDATA(2)="no 71 entry" Q  ;-->out
        S YSOP=$P($G(^YTT(601.71,YS60171,2)),U,2)
        I YSOP="D" S YSDATA(1)="[DATA]",YSDATA(2)=YS60171_U_"dropped" Q  ;-->out
        S YSDATA(1)="[DATA]",YSDATA(2)=YS60171_U_YSCODE
        Q
PRIVL(YSDATA,YS)        ;check privileges
        N YSCODE,YSET,YSKEY
        S YSCODE=$G(YS("CODE"),-1)
        I (YSCODE="GAF")!(YSCODE="ASI") S YSDATA(1)="[DATA]",YSDATA(2)="1^exempt test" Q  ;-->out test exempt
        I '$D(^YTT(601.71,"B",YSCODE)) S YSDATA(1)="[ERROR]",YSDATA(2)="BAD TEST CODE" Q  ;--> out
        S YSET=$O(^YTT(601.71,"B",YSCODE,0))
        S YSDATA(1)="[DATA]"
        S YSKEY=$$GET1^DIQ(601.71,YSET_",",9)
        I YSKEY="" S YSDATA(2)="1^exempt test" Q  ;-->out
        I $D(^XUSEC(YSKEY,DUZ)) S YSDATA(2)="1^user privileged" Q  ;-->out has key
        S YSDATA(2)="0^no access"
        Q
MHA3CODE(X)     ;function to return mha3 test NAME from ien of 601.71
        ;ie S YS("CODE")=$$MHA3CODE^YTQPXRM6(1) sets YS("CODE")="MMPI2"
        S X=$$GET1^DIQ(601.71,X_",",.01)
        Q X
ENDAS71(YSDATA,DAS)     ;single administration output
        ;Input
        ;DAS from ^PXRMINDX(
        ;Output:
        ;Array(1)=[DATA]
        ;Array(2)= Patient Name^Test Code^Test Title^Internal Admin date^External Admin Date ^Ordered by
        ;Array("R",running number)=MH Administration IEN^MH Answer IEN^MH Question IEN^MH Choice IEN [if avail]^MH Legacy answer [single character answer is available^text of answer [first 200 chars]
        ;Array("SI",601.87 IEN)=S_running number1^Scale Name^Raw Score^Transformed Score
        N J,G,N1,N2,YSNAME,YSDATEE,YSDATEI,YSCODE,YSCODEN,YSORD,YSPRT,YSAID,YSADATE,YSA,YSLEG,YSCIS,YSZZ,YSTEXT,YSQID,YSDFN,YSIZE,YSC1,YSCALE1,YSG1,YSRT,YSRTI,YSXXZ
        I DAS?.E1";".E D LEGDAS^YTQPXRM7(.YSDATA,DAS) D SS,SILEG Q  ;--> use old rts
        I '$D(^YTT(601.84,DAS,0)) S YSDATA(1)="[ERROR]",YSDATA(2)="bad das" Q  ;-->out
        S YSDATA(1)="[DATA]"
        S YSNAME=$$GET1^DIQ(601.84,DAS_",",1)
        S YSCODE=$$GET1^DIQ(601.84,DAS_",",2)
        S YSCODEN=$$GET1^DIQ(601.84,DAS_",",2,"I")
        S YSORD=$$GET1^DIQ(601.84,DAS_",",5)
        S YSDATEE=$$GET1^DIQ(601.84,DAS_",",3)
        S YSDATEI=$$GET1^DIQ(601.84,DAS_",",3,"I")
        S YSPRT=$P(^YTT(601.71,YSCODEN,0),U,3)
        S YSDATA(2)=YSNAME_U_YSCODE_U_YSPRT_U_YSDATEI_U_YSDATEE_U_YSORD
        ;ASF 11/15/07
        S YSAID=0,N1=0 F  S YSAID=$O(^YTT(601.85,"AD",DAS,YSAID)) Q:YSAID'>0  Q:'$D(^YTT(601.85,YSAID,0))  S N1=N1+1 D
        . S (YSTEXT,YSLEG)=""
        . S YSA=^YTT(601.85,YSAID,0),YSCIS=$P(YSA,U,4),YSQID=$P(YSA,U,3)
        . I $D(^YTT(601.85,YSAID,1,1,0)) S YSIZE=0,YSTEXT="",J=0 D  S YSTEXT=$E(YSTEXT,2,201)
        .. F  S J=$O(^YTT(601.85,1,J)) Q:J'>0!(YSIZE>200)  S YSTEXT=" "_^YTT(601.85,YSAID,1,J,0),YSIZE=$L(YSTEXT)
        . S:YSCIS?1N.N YSLEG=$P($G(^YTT(601.75,YSCIS,0)),U,2),YSTEXT=$G(^YTT(601.75,YSCIS,1))
        . S:$D(^YTT(601.85,YSAID,1,1,0)) YSTEXT=^YTT(601.85,YSAID,1,1,0)
        . S YSDATA("R",N1)=DAS_U_YSAID_U_YSQID_U_YSCIS_U_YSLEG_U_YSTEXT
        D SS
        S YS("AD")=DAS D GETSCORE^YTQAPI8(.YSZZ,.YS)
        D SI
        Q
UCASE(X)        ;upper case
        N %
        F %=1:1:$L(X) S:$E(X,%)?1L X=$E(X,0,%-1)_$C($A(X,%)-32)_$E(X,%+1,999)
        Q X
SS      ;scale listing
        S:DAS?.E1";".E YSCODEN=$O(^YTT(601.71,"B",YSCODEN,0))
        D SCALES^YTQPXRM5(.YSQQ,YSCODEN)
        S N2=0 F  S N2=$O(YSQQ("S",N2)) Q:N2'>0  D
        . S YSCALE1=YSQQ("S",N2)
        . S YSC1($$UCASE(YSCALE1),N2)=""
        K YSQQ
        Q
SI      ;set internal scale walk
        S N2=1 F  S N2=$O(^TMP($J,"YSCOR",N2)) Q:N2'>0  D
        . S YSG1=^TMP($J,"YSCOR",N2)
        . S YSCALE1=$P(YSG1,"="),YSRT=$P(YSG1,"=",2)
        . ;S YSDATA("S",N2-1)="S"_(N2-1)_U_YSCALE1_U_YSRT
        . S YSRTI=$O(YSC1($$UCASE(YSCALE1),0))
        . S:YSRTI'="" YSDATA("SI",YSRTI)="S"_(N2-1)_U_YSCALE1_U_YSRT
        K ^TMP($J,"YSCOR"),^TMP($J,"YSG"),YS
        Q
SILEG   ;legacy internal walk
        S N2=0 F  S N2=$O(YSDATA("S",N2)) Q:N2'>0  D
        . S YSG1=YSDATA("S",N2),YSCALE1=$P(YSG1,U,2),YSRT=$P(YSG1,U,3,4)
        . S YSRTI=$O(YSC1($$UCASE(YSCALE1),0))
        . S:YSRTI'="" YSDATA("SI",YSRTI)="S"_(N2)_U_YSCALE1_U_YSRT
        K YSDATA("S")
        Q
