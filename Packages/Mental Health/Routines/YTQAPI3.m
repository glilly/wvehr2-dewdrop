YTQAPI3 ;ASF/ALB MHQ REMOTE PROCEEDURES CONT ; 4/3/07 11:53am
        ;;5.01;MENTAL HEALTH;**85**;DEC 30,1994;Build 49
        Q
SCALEG(YSDATA,YS)       ;returns all scale groups for an instrument
        ;input CODE
        ; output:SCALE NAME^ABBREVIATION^SCALE IEN^SCALE SEQUENCE^SCALE GROUP NAME^SCALE GRUOP IEN^GROUP SEQUENCE^ORD TITLE^MIN^INCREASE^MAX^GRID1^GRID2^GRID3
        ;
        N N,N1,G1,S1,G6,G7,YSCALEN,YSCN,YSCODE,YSGIEN,YSGN
        K ^TMP($J,"YSG") S YSDATA=$NA(^TMP($J,"YSG"))
        S YSCODE=$G(YS("CODE"))
        I '$D(^YTT(601.71,"B",YSCODE)) S ^TMP($J,"YSG",1)="[ERROR]",^TMP($J,"YSG",2)="BAD CODE" Q  ;-->out
        S ^TMP($J,"YSG",1)="[DATA]",N=1,S1=0,G1=0
        S YSCN=$O(^YTT(601.71,"B",YSCODE,0))
        S YSGN=0 F  S YSGN=$O(^YTT(601.86,"AC",YSCN,YSGN)) Q:YSGN'>0  D
        . S YSGIEN=0 F  S YSGIEN=$O(^YTT(601.86,"AC",YSCN,YSGN,YSGIEN)) Q:YSGIEN'>0  D
        .. S N=N+1,G1=G1+1,^TMP($J,"YSG",N)="Group"_G1_"="_YSGIEN_U_$$GET1^DIQ(601.86,YSGIEN_",",1)_U_$P($G(^YTT(601.86,YSGIEN,0)),U,3,99)
        .. S N1=0 F  S N1=$O(^YTT(601.87,"AC",YSGIEN,N1)) Q:N1'>0  D
        ... S YSCALEN=0 F  S YSCALEN=$O(^YTT(601.87,"AC",YSGIEN,N1,YSCALEN)) Q:YSCALEN'>0  D
        .... S N=N+1,S1=S1+1,^TMP($J,"YSG",N)="Scale"_S1_"="_$G(^YTT(601.87,YSCALEN,0))
        Q
BATTC(YSDATA,YS)        ;battery content
        ; OUTPUT: BATTERY NAME ^ INSTRUMENT list sorted by BATTERY & SEQUENCE
        N N,N1,G7,YSBATS,YSBID,YSCONID,YSNAME,YSUB,YS1,YSBNAME
        S N=1,YSDATA(1)="[DATA]"
        S YSUB=0 F  S YSUB=$O(^YTT(601.781,"AC",DUZ,YSUB)) Q:YSUB'>0  D
        . S YSBID=$P(^YTT(601.781,YSUB,0),U,3)
        . S YSBNAME=$P($G(^YTT(601.77,YSBID,0)),U,2)
        . S:$L(YSBNAME) YS1(YSBNAME)=YSBID
        S YSNAME="" F  S YSNAME=$O(YS1(YSNAME)) Q:YSNAME=""  S YSBID=YS1(YSNAME) D
        . S YSBATS=0 F  S YSBATS=$O(^YTT(601.78,"AC",YSBID,YSBATS)) Q:YSBATS'>0  D
        .. S YSCONID=$O(^YTT(601.78,"AC",YSBID,YSBATS,0))
        ..S G7=$G(^YTT(601.78,YSCONID,0))
        .. S N=N+1,YSDATA(N)=$P(G7,U,2)_U_$P(^YTT(601.77,YSBID,0),U,2)_U_$P(G7,U,3,4)_U_$$GET1^DIQ(601.78,YSCONID_",",3)
        Q
FIRSTWP(YSDATA,YS)      ;first line of all intros
        ;returns the first line only of a WP field
        ;Input: FILEN(file number), FIELD (WP filed #)
        ;Ouput IEN^WP Text line 1
        N N,YSN,YSFILEN,YSFIELD
        S YSDATA=$NA(^TMP($J,"YSFWP")) K ^TMP($J,"YSFWP")
        S YSFILEN=$G(YS("FILEN"),0) I $$VFILE^DILFD(YSFILEN)<1 S ^TMP($J,"YSFWP",1)="[ERROR]",^TMP($J,"YSFWP",2)="BAD FILE N" Q  ;--->out
        S YSFIELD=$G(YS("FIELD"),0) S N=$$VFIELD^DILFD(YSFILEN,YSFIELD) I N<1 S ^TMP($J,"YSFWP",1)="[ERROR]",^TMP($J,"YSFWP",2)="BAD field" Q  ;--> out
        S YSN=0,N=1,^TMP($J,"YSFWP",1)="[DATA]"
        F  S YSN=$O(^YTT(YSFILEN,YSN)) Q:YSN'>0  D
        . S N=N+1
        . S ^TMP($J,"YSFWP",N)=YSN_U_$G(^YTT(YSFILEN,YSN,YSFIELD,1,0))
        Q
QUESTALL(YSDATA,YS)     ;all questions for a test
        ;input: CODE as test name
        ;output: Field^Value
        N YSTESTN,YSTEST,YSF,YSV,N,N2,N3,YSEQX,YSIC,YSQN,G
        S YSDATA=$NA(^TMP($J,"YSQU")) K ^TMP($J,"YSQU")
        S YSTEST=$G(YS("CODE"))
        S YSTESTN=$O(^YTT(601.71,"B",YSTEST,0))
        I YSTESTN'>0 S ^TMP($J,"YSQU",1)="[ERROR]",^TMP($J,"YSQU",2)="bad code" Q  ;-->out
        S N=2,N3=0,^TMP($J,"YSQU",1)="[DATA]"
        ;
        S YSEQX=0
        F  S YSEQX=$O(^YTT(601.76,"AD",YSTESTN,YSEQX)) Q:YSEQX'>0  D
        . S YSIC=0 F  S YSIC=$O(^YTT(601.76,"AD",YSTESTN,YSEQX,YSIC)) Q:YSIC'>0  S YSQN=$P(^YTT(601.76,YSIC,0),U,4) D QUEST2
        S ^TMP($J,"YSQU",2)="NUMBER OF QUESTIONS="_N3
        Q
QUEST2  ;
        S N=N+1,N3=N3+1
        S ^TMP($J,"YSQU",N)="QUESTION NUMBER"_N3_"="_YSQN_U_$P(^YTT(601.76,YSIC,0),U,3)_U_$P(^YTT(601.76,YSIC,0),U,5)_U_YSIC
        S N2=0 F  S N2=$O(^YTT(601.72,YSQN,1,N2)) Q:N2'>0  S N=N+1,^TMP($J,"YSQU",N)=$S(N2=1:"QUESTION TEXT"_N3_"=",1:"")_$G(^YTT(601.72,YSQN,1,N2,0))
        S N=N+1,G=$G(^YTT(601.72,YSQN,2))
        S ^TMP($J,"YSQU",N)="INTRO TEXT"_N3_"="_$S(+G>0:+G,1:"")_U D:+G
        . S N2=0 F  S N2=$O(^YTT(601.73,+G,1,N2)) Q:N2'>0  S:N2>1 N=N+1 S ^TMP($J,"YSQU",N)=$G(^TMP($J,"YSQU",N))_$G(^YTT(601.73,+G,1,N2,0))
        S N=N+1
        S ^TMP($J,"YSQU",N)="DESC"_N3_"="_$P($G(^YTT(601.74,+$P(G,U,2),0)),U,2)_U_$P(G,U,3)_U_$P(G,U,4)_U_$P(G,U,5)_U_$P(G,U,6)_U_$P(G,U,7)_U
        S G=+$P(G,U,3),G=$O(^YTT(601.89,"B",G,0)) S:G>0 ^TMP($J,"YSQU",N)=^TMP($J,"YSQU",N)_$P(^YTT(601.89,G,0),U,2)
        S G=^YTT(601.76,YSIC,0)
        S N=N+1
        S ^TMP($J,"YSQU",N)="QDISPLAY"_N3_"=" S:$P(G,U,6)?1N.N ^TMP($J,"YSQU",N)=^TMP($J,"YSQU",N)_$$DISPEXT^YTQAPI5($P(G,U,6))
        S N=N+1
        S ^TMP($J,"YSQU",N)="IDISPLAY"_N3_"=" S:$P(G,U,7)?1N.N ^TMP($J,"YSQU",N)=^TMP($J,"YSQU",N)_$$DISPEXT^YTQAPI5($P(G,U,7))
        S N=N+1
        S ^TMP($J,"YSQU",N)="CDISPLAY"_N3_"=" S:$P(G,U,8)?1N.N ^TMP($J,"YSQU",N)=^TMP($J,"YSQU",N)_$$DISPEXT^YTQAPI5($P(G,U,8))
        Q
PURGE(YSDATA,YS)        ; delete a record
        ;input: FILEN (FILE #)
        ;       IEN (internal record #)
        ;Output :only conformation
        N YSFILEN,YSROOT,YSNODE,DIK,DA
        S DA=$G(YS("IEN"),0)
        S YSFILEN=$G(YS("FILEN"),0) I $$VFILE^DILFD(YSFILEN)<1 S YSDATA(1)="[ERROR]",YSDATA(2)="BAD FILE N" Q  ;--->out
        S YSROOT=$$ROOT^DILFD(YSFILEN)
        S YSNODE=YSROOT_DA_",0)"
        I $D(@YSNODE)'>0 S YSDATA(1)="[ERROR]",YSDATA(2)="no such record" Q  ;-->out
        S DIK=YSROOT D ^DIK
        S YSDATA(1)="[DATA]",YSDATA(2)="record "_DA_" of "_YSFILEN_" deleted"
        Q
