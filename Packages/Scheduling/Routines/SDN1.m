SDN1    ;BSN/GRR - NO-SHOW LETTERS ; 17 AUG 84  4:34 pm
        ;;5.3;Scheduling;**330,340,398,455,523**;Aug 13, 1993;Build 6
        N SDBAD
        I ANS["Y"&($D(C)) F A=0:0 S A=$O(^UTILITY($J,A)) Q:A'>0  F C=0:0 S C=$O(^(A,C)) Q:C'>0  S SC=+^(C),SDLET="" S:$D(^SC(SC,"LTR")) SDLET=+^("LTR") S:SDLET ^UTILITY($J,"SDLT",SDLET,A,C)=^UTILITY($J,A,C) S:'SDLET ^UTILITY($J,"NO",A,C)=SC D KLL
        S SDFORM=$S($D(^DG(40.8,SDV1,"LTR")):^("LTR"),1:"") G:ANS["Y"&($D(C)) LST
BC      K:$D(SDLT) C S:$D(SDLT) SDT=SDBD,DATEND=SDED K ^UTILITY($J) I $D(C) K VAUTC S (VAUTC,VAUTC(C))=""
        I $D(VAUTC),'VAUTC F C=0:0 S C=$O(VAUTC(C)) Q:C'>0  D:$D(SDLT) LT D CHECK1 I $T D OVER
        I $D(VAUTC),'VAUTC G LST
LST1    F C=0:0 S C=$O(^SC(C)) Q:C'>0  D LT,CHECK1 I $T,$S(SDV1="":1,SDV=SDV1:1,SDV="":1,1:0),'$D(SDVAUTC(+C)),$D(^SC(C,"S")) D OVER
LST     N SDFIRST S SDFIRST=1
        F SDLET=0:0 S SDLET=$O(^UTILITY($J,"SDLT",SDLET)) Q:SDLET'>0  F A=0:0 S A=$O(^UTILITY($J,"SDLT",SDLET,A)) Q:A'>0  I $S('$D(^DPT(A,.35)):1,$P(^(.35),"^",1)']"":1,1:0) N POP S POP=0 D ^SDLT Q:POP  D WR  ;SD*523 added quit
        I $D(^UTILITY($J,"NO")) W @IOF F A=0:0 S A=$O(^UTILITY($J,"NO",A)) Q:A'>0  F A1=0:0 S A1=$O(^(A,A1)) Q:A1'>0  Q:$$BADADR^DGUTL3(A)  W !,$P(^DPT(A,0),"^")," ",$P(^(0),"^",9)," has failed to keep the following appointment(s):" D NDT
        W:$D(^UTILITY($J,"NO")) !,"However, there are no letters assigned to the clinic(s).",!!
        I $D(^TMP($J,"BADADD")) D BADADD^SDLT K ^TMP($J,"BADADD")
        G END
OVER    S GDATE=SDT Q:'$D(^SC(C,"S"))  F J=0:0 S GDATE=$O(^SC(C,"S",GDATE)) Q:GDATE=""!(GDATE>(DATEND+.9999))  F K=0:0 S K=$O(^SC(C,"S",GDATE,1,K)) Q:K=""  I $D(^(K,0)) S DFN=+^(0) D CHECK
        Q
END     K %,%DT,%IS,A,A0,A1,A2,ALL,ALS,ANS,BY,C,CDATE,DA,DFN,DGPGM,DGVAR,DH,DHD,DIC,DIS,DIV,DIW,DIWF,DIWL,DIWR,DIWT,DO,DOW,DN,DUPE,FLDS,F,F1,FR,GDATE,I,I1,L,L0,LET,MAX,MESS,MIN,NOAP,P,POP,SC,SD,SDFOR,SDLET,SDTIME,SI,SL,SS,ST,SDSTRTDT,TO,X,Y,ADDR,B
        K CLIN,HX,LL,PDAT,S,TIME,Z,D,NDATE,ENDATE,J,SDMDT,SDMSTIME,X1,X2,SDTADE,SDADTB,SDRE,SDRE1,SDIN,SDIS,SDYES,CNN,SDT,DATEND,SDV1,K,SDR,SDJ1,^UTILITY($J),SD1,SD2,SDADD,SDC,SDCL,SDCMAX,SDCONS,SDD,SDDAT,SDDIF,SDDT,SDED,SDFORM,SDHX,SDINP,SDIP
        K %ZIS,Y1,SDBD,SDCT,SDVAUTC,VAUTC,SDX,SDX1,SDNOSH,SDLT1,SDMSG,SDNODE,SDQ,SDRT,SDSOH,SDSTAT,SDT0,SDZSC,SM,SM1,STARTDAY,STIME,SDV,Z0,Z5 D CLOSE^DGUTQ Q
CHECK   I $S('$D(^DPT(DFN,.35)):1,$P(^(.35),"^",1)']"":1,1:0),$D(^DPT(DFN,"S",GDATE,0)),$S($P(^(0),U,2)="N":1,$P(^(0),U,2)="NA":1,$D(SDCP)&$P(^(0),"^",2)["C":1,1:0),$P(^(0),"^",14)=SDTIME!(SDTIME="*"),'$D(^DPT(DFN,.1)) D
        .D BAD Q:SDBAD
        .D SET
        Q  ;above logic changed SD*5.3*455
SET     I SDLT1!SDLET S ^UTILITY($J,"SDLT",$S(SDLT1:SDLT1,1:SDLET),DFN,GDATE)=C_"^"_$P(^DPT(DFN,"S",GDATE,0),"^",10) Q
        S ^UTILITY($J,"NO",DFN,GDATE)=C Q
CHECK1  S SDV=$P(^SC(C,0),"^",15) I $P(^(0),"^",3)="C",$S('$D(^SC(C,"I")):1,'(+^("I")):1,+^("I")>DATEND:1,+$P(^("I"),"^",2)'>DATEND&(+$P(^("I"),"^",2)):1,1:0)
        Q
WR      K CNN F J=0:0 S J=$O(^UTILITY($J,"SDLT",SDLET,A,J)) Q:J=""  S SDR=0,SDX=J,CNN(J)=^(J),CLIN=$P(^SC(+$P(CNN(J),"^",1),0),"^",1),SDC=+CNN(J),S=$S($D(^DPT(A,"S",J,0)):^(0),1:"") D WRAPP^SDLT,SET1
        D:SDR SDR D REST^SDLT Q
SDR     W !!,"The appointment(s) have been rescheduled as follows:",!
        F J=0:0 S J=$O(CNN(J)) Q:J=""  S SDX=$P(CNN(J),"^",2),SDC=$P(CNN(J),"^") I SDX S S=$S($D(^DPT(A,"S",SDX,0)):^(0),1:"") D WRAPP^SDLT
        Q
SET1    S:'SDR SDR=$S($P(CNN(J),"^",2)]"":1,1:0) Q
        Q
LT      S:'SDLT1 SDLET=0 I $D(^SC(C,"LTR")),^("LTR") S SDLET=+^("LTR")
        Q
NDT     W !?15,$P(^SC(+^UTILITY($J,"NO",A,A1),0),"^")," on " S Y=A1 D DT^DIQ Q
KLL     K ^UTILITY($J,A,C) Q
BAD     S SDBAD=$$BADADR^DGUTL3(+DFN)
        S:SDBAD ^TMP($J,"BADADD",$P(^DPT(+DFN,0),"^"),+DFN)=""
        Q
