YTQAPI  ;ASF/ALB MHQ REMOTE PROCEEDURES ; 4/3/07 10:36am
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        Q
TSLIST(YSDATA)  ;list tests and surveys
        ;Input: none
        ;Output: TEST NAME = LAST EDIT DATE^OPERATIONAL^REQUIRES LISCENCE^LISCENCE CURRENT^IS LEGACY^IEN^R PRIVILEGE^IS NATIONAL^HAS BEEN OPERATIONAL
        N YSTESTN,YSTEST,N,G,G1,G2,G3,G4,G5,G6,G7
        K ^TMP($J,"YSTL")
        S YSDATA=$NA(^TMP($J,"YSTL"))
        S N=1,^TMP($J,"YSTL",N)="[DATA]"
        S YSTEST="" F  S YSTEST=$O(^YTT(601.71,"B",YSTEST)) Q:YSTEST=""  D
        . S YSTESTN=$O(^YTT(601.71,"B",YSTEST,0))
        . S N=N+1
        . S G=$$GET1^DIQ(601.71,YSTESTN_",",18,"I")
        . S G1=$$GET1^DIQ(601.71,YSTESTN_",",10,"E")
        . S G2=$$GET1^DIQ(601.71,YSTESTN_",",11,"E")
        . S G3=$$GET1^DIQ(601.71,YSTESTN_",",20,"E")
        . S G4=$$GET1^DIQ(601.71,YSTESTN_",",23,"E")
        . S G5=$$GET1^DIQ(601.71,YSTESTN_",",9,"E")
        . S G6=$$GET1^DIQ(601.71,YSTESTN_",",19,"E")
        . S G7=$$GET1^DIQ(601.71,YSTESTN_",",10.5,"E")
        . S ^TMP($J,"YSTL",N)=YSTEST_"="_G_U_G1_U_G2_U_G3_U_G4_U_YSTESTN_U_G5_U_G6_U_G7
        Q
TSLIST1(YSDATA,YS)      ;list questions for a single test
        ;input: CODE as test name
        ;output: Field^Value
        N YSTESTN,YSTEST,YSF,YSV,N,I,YSEI
        S YSTEST=$G(YS("CODE"))
        I YSTEST="" S YSDATA(1)="[ERROR]",YSDATA(2)="NO code" Q  ;-->out
        S YSTESTN=$O(^YTT(601.71,"B",YSTEST,0))
        I YSTESTN'>0 S YSDATA(1)="[ERROR]",YSDATA(2)="bad code" Q  ;-->out
        S N=2,YSDATA(1)="[DATA]",YSDATA(2)="IEN="_YSTESTN
        S I=0 F  S I=$O(^DD(601.71,I)) Q:I'>0  D
        . S N=N+1
        . S YSEI=$S(I=18:"I",1:"E")
        . D FIELD^DID(601.71,I,"","LABEL","YSF")
        . S YSV=$$GET1^DIQ(601.71,YSTESTN_",",I,YSEI)
        . S YSDATA(N)=YSF("LABEL")_"="_YSV
        Q
CHOICES(YSDATA,YS)      ;list choices for a question
        ;input: CODE as test name
        ;output: 601.75(1) CHOICETYPE ID^SEQUENCE^CHOICE IFN^CHOICE TEXT^LEGACY VALUE
        N YSCDA,YSIC,YSQN,YSN,YSN1,YSTESTN,YSTEST,YSF,YSV,N,G,YSCTYP,YSCTYPID,G,G1,X
        S YSTEST=$G(YS("CODE"))
        S YSTESTN=$O(^YTT(601.71,"B",YSTEST,0))
        I YSTESTN'>0 S YSDATA(1)="[ERROR]",YSDATA(2)="bad code" Q  ;-->out
        S N=1,YSDATA(1)="[DATA]"
        ;
        S YSIC=0
        F  S YSIC=$O(^YTT(601.76,"AC",YSTESTN,YSIC)) Q:YSIC'>0  S YSQN=$P(^YTT(601.76,YSIC,0),U,4) D
        . S YSCTYP=$P($G(^YTT(601.72,YSQN,2)),U,3)
        . S:YSCTYP'="" YSCTYPID(YSCTYP)=""
C2      ;
        S YSN=0
        F  S YSN=$O(YSCTYPID(YSN)) Q:YSN'>0  D
        . S YSN1=0 F  S YSN1=$O(^YTT(601.751,"AC",YSN,YSN1)) Q:YSN1'>0  D
        .. S YSCDA=0 F  S YSCDA=$O(^YTT(601.751,"AC",YSN,YSN1,YSCDA)) Q:YSCDA'>0  D
        ... S N=N+1
        ... S YSDATA(N)=YSN_U_YSN1_U_YSCDA_U_$G(^YTT(601.75,YSCDA,1))_U_$P($G(^YTT(601.75,YSCDA,0)),U,2)
        Q
SKIPPED(YSDATA,YS)      ; skipped questions for an instrument
        ;input: CODE as test name
        ;output: QUESTIONID^SKIPQUESTIONID
        ; for single test in question,skipped order
        N YSTESTN,YSTEST,N,N1,N2,YSQ,YSK,G
        S YSTEST=$G(YS("CODE"))
        S YSTESTN=$O(^YTT(601.71,"B",YSTEST,0))
        I YSTESTN'>0 S YSDATA(1)="[ERROR]",YSDATA(2)="bad code" Q  ;-->out
        I '$D(^YTT(601.79,"AC",YSTESTN)) S YSDATA(1)="[ERROR]",YSDATA(2)="no entries for this code" Q  ;--> out
        S N=1,YSDATA(1)="[DATA]"
        ;
        S N1=0 F  S N1=$O(^YTT(601.79,"AC",YSTESTN,N1)) Q:N1'>0  D
        . S G=^YTT(601.79,N1,0),YSQ=$P(G,U,3),YSK=$P(G,U,4)
        . S:(YSQ?1N.N)&(YSK?1N.N) G(YSQ,YSK)=""
        S N1=0 F  S N1=$O(G(N1)) Q:N1'>0  S N2=0 F  S N2=$O(G(N1,N2)) Q:N2'>0  S N=N+1,YSDATA(N)=N1_U_N2
        Q
SECTION(YSDATA,YS)      ;section captions
        ;input: CODE as test name
        ;output: FIRSTQUESTIONID^TABCAPTION^SECTIONCAPTION^DISPLAYID
        ; for single test in questionID order
        N YSTESTN,YSTEST,N,N1,G,YSQ
        S YSTEST=$G(YS("CODE"))
        S YSTESTN=$O(^YTT(601.71,"B",YSTEST,0))
        I YSTESTN'>0 S YSDATA(1)="[ERROR]",YSDATA(2)="bad code" Q  ;-->out
        I '$D(^YTT(601.81,"AC",YSTESTN)) S YSDATA(1)="[DATA]" Q  ;-->out no entries for this code
        S N=1,YSDATA(1)="[DATA]"
        ;
        S N1=0 F  S N1=$O(^YTT(601.81,"AC",YSTESTN,N1)) Q:N1'>0  D
        . S G=^YTT(601.81,N1,0),YSQ=$P(G,U,3)
        . S:(YSQ?1N.N) G(YSQ)=$P(G,U,3,6)
        S N1=0 F  S N1=$O(G(N1)) Q:N1'>0  D
         . S N=N+1,YSDATA(N)=G(N1)
        . S N=N+1,YSDATA(N)="DISPLAY=" S:$P(G(N1),U,4)?1N.N YSDATA(N)=YSDATA(N)_$$DISPEXT^YTQAPI5($P(G(N1),U,4))
        Q
        ;
