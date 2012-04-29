YTQPXRM4        ;ASF/ALB CLINICAL REMINDERS CONT ; 10/29/07 3:06pm
        ;;5.01;MENTAL HEALTH;**85**;DEC 30,1994;Build 49
        ;
        Q
CHECKCR(YSDATA,YS)      ;ckeck out cr dialog is ok
        ; input: CODE,DFN,^TMP($J,AARAY,sequential)=ITEM#^RESPONSE
        ;output [DATA] VS [ERROR]
        ;scoring in ^TMP($J,"YSCOR"
        N DA,DFN,N,YSV,YSCODE,YSQNUMB,YSADDER,YSNEWA,YSADDER,YSDATAZ,YSANS,YSX,YSBOP1
        N YSERR,YSLEGA,YSRR,YSCHOT,YSCHOICE,G,YSLN,YSIC,YSQN,YSF,YSCODE,J,N83,YSANSIV,YSIV,YSQ1,YSRG,YSRULE,YSRULID,DIK,YS84IEN,J1,YSTESTN
        S DFN=$G(YS("DFN"),-1) I '$D(^DPT(DFN)) S YSDATA(1)="ERROR",YSDATA(2)="bad DFN" Q  ;-->out
        S YSDATA(1)="[DATA]"
        D ALLIN
        Q:(YSDATA(1)'="[DATA]")  ;-->out
        D SAVEOK
        L +^YTT(601.84,YS84IEN):30
        K YS D ANSSET
        D GETSCORE^YTQAPI8(.YSV,.YS)
        ; delete admin as it is not fully ok'd
        S J=0 F  S J=$O(^YTT(601.85,"AC",YS84IEN,J)) Q:J'>0  S J1=0 F  S J1=$O(^YTT(601.85,"AC",YS84IEN,J,J1)) Q:J1'>0  D
        . K DIK S DA=J1,DIK="^YTT(601.85," D ^DIK
        K DIK S DA=YS84IEN,DIK="^YTT(601.84," D ^DIK ;moved 10/29/07 asf
        L -^YTT(601.84,YS84IEN):30
        K ^TMP($J,"YSQU")
        Q
SAVECR(YSDATA,YS)       ;save cr entered instruments
        ; input: CODE,DFN,^TMP($J,AARAY,sequential)=ITEM#^RESPONSE
        ;output [DATA] VS [ERROR]
        N DA,DFN,N,YSCODE,YSQNUMB,YSADDER,YSNEWA,YSADDER,YS84IEN,YSDATAZ,YSANS,YSX,YSBOP1,YSSTAFF,YSADATE
        N YSERR,YSLEGA,YSRR,YSCHOT,YSCHOICE,G,YSLN,YSIC,YSQN,YSF,YSCODE,J,N83,YSANSIV,YSIV,YSQ1,YSRG,YSRULE,YSRULID,J1,YSTESTN
        S DFN=$G(YS("DFN"),-1) I '$D(^DPT(DFN)) S YSDATA(1)="ERROR",YSDATA(2)="bad DFN" Q  ;-->out
        S YSADATE=$G(YS("ADATE"),"NOW")
        S YSSTAFF=$G(YS("STAFF"),DUZ)
        S YSDATA(1)="[DATA]"
        D ALLIN
        Q:(YSDATA(1)'="[DATA]")  ;-->out
        D SAVEOK
        K YS D ANSSET
        ;save results
        K YS S YS("AD")=YS84IEN D SCORSAVE^YTQAPI11(.YSDATA,.YS)
        ;send to nat db
        K YS S YS("AD")=YS84IEN D HL7^YTQHL7(.YSDATA,.YS)
        K ^TMP($J,"YSQU")
        Q
ALLIN   ;check cr Entries ok
        S YSCODE=$G(YS("CODE"),0)
        S YSTESTN=$O(^YTT(601.71,"B",YSCODE,0))
        I YSTESTN'>0 S YSDATA(1)="[ERROR]",YSDATA(2)="bad code" Q  ;-->out
        D QUESTALL^YTQPXRM3(.YSDATAZ,.YS)
        I ^TMP($J,"YSQU",1)="[ERROR]" S YSDATA(1)="[ERROR]",YSDATA(2)="QUESTALL ERROR "_^TMP($J,"YSQU",2) Q  ;-->out
        ;set answers
        S N=0 F  S N=$O(YS(N)) Q:N'>0  S YSANS(+YS(N))=$P(YS(N),U,2)
        ;Skip logic fire -only first condition-no consistency only checks
        S N=0 F  S N=$O(^TMP($J,"YSQU","YSCROSS",N)) Q:N'>0  D:$D(YSANS(N))
        . S YSQN=^TMP($J,"YSQU","YSCROSS",N)
        . Q:'$D(^YTT(601.83,"AD",YSTESTN,YSQN))
        . S N83=0
        . F  S N83=$O(^YTT(601.83,"AD",YSTESTN,YSQN,N83)) Q:N83'>0  D
        .. S YSRULID=$P(^YTT(601.83,N83,0),U,4)
        .. S YSRG=^YTT(601.82,YSRULID,0)
        .. S YSQ1=$P(YSRG,U,2),YSIV=$P(YSRG,U,3),YSBOP1=$$BOOL($P(YSRG,U,5))
        .. S:YSBOP1="=<" YSBOP1="<",YSIV=YSIV+.1
        .. S:YSBOP1="=>" YSBOP1=">",YSIV=YSIV-.1
        .. S YSANSIV=$F(^TMP($J,"YSQU",N,"R",0),YSANS(N))-2
        .. S YSX="S YSRULE=0 I ("_YSANSIV_YSBOP1_YSIV_") S YSRULE=1"
        .. X YSX
        .. I $G(YSRULE)=1 S J=0 F  S J=$O(^YTT(601.79,"AE",YSRULID,J)) Q:J'>0  S ^TMP($J,"YSQU","YSKIP",$P($G(^YTT(601.79,J,0),0),U,4))=""
        ; check all required answers present and legal
        S YSERR=""
        S N=0 F  S N=$O(^TMP($J,"YSQU","YSCROSS",N)) Q:N'>0  D
        . S YSQN=^TMP($J,"YSQU","YSCROSS",N)
        . I $D(YSANS(N)) S:(^TMP($J,"YSQU",N,"R",0)'[YSANS(N)) YSERR="0^"_$P(YSERR,U,2)_N_"," ;answer not legal
        . ;I $P(^YTT(601.72,YSQN,2),U,6)="N" Q  ;-->out not a required ques
        . I $D(^TMP($J,"YSQU","YSKIP",YSQN)) Q  ;-->out skip rule
        . I '$D(YSANS(N)) S YSERR="0^"_$P(YSERR,U,2)_N_"," ; error set req answer not present
        I $L(YSERR)>1 S YSDATA(1)="[ERROR]" S YSDATA(2)=YSERR K ^TMP($J,"YSQU") Q  ;-->out houston we have a problem
        Q
SAVEOK  ; checks out so save admin
        S:'$D(YSADATE) YSADATE="NOW"
        S:'$D(YSSTAFF) YSSTAFF=DUZ
        S YSNEWA("FILEN")=601.84,YSNEWA(1)=".01^NEW^1",YSNEWA(2)="1^`"_DFN
        S YSNEWA(3)="2^"_YSCODE,YSNEWA(4)="3^"_YSADATE,YSNEWA(5)="4^NOW"
        S YSNEWA(6)="5^`"_YSSTAFF,YSNEWA(7)="6^`"_DUZ,YSNEWA(8)="7^N",YSNEWA(9)="8^Y"
        ;ASF 8/13 staff and orderer passing
        D EDAD^YTQAPI1(.YSADDER,.YSNEWA)
        S YS84IEN=$P(YSADDER(2),U,2)
        Q
ANSSET  ;save answers
        S N=0 F  S N=$O(^TMP($J,"YSQU","YSCROSS",N)) Q:N'>0  D
        . Q:'$D(YSANS(N))
        . S YS("AD")=YS84IEN
        . S YS("QN")=^TMP($J,"YSQU","YSCROSS",N)
        . S YS("CHOICE")=^TMP($J,"YSQU","YSCA",YS("QN"),YSANS(N)) ;ASF 10/19
        . ;S YS(1)=YSANS(N)
        . D SETANS^YTQAPI2(.YSDATA,.YS)
        Q
BOOL(YSOP)      ;
        S YSOP=$S(YSOP="Equals":"=",YSOP="Is greater than":">",YSOP="Is less than":"<",YSOP="Equals or is less than":"=<",YSOP="Equals or is greater than":"=>",1:"")
        Q YSOP
