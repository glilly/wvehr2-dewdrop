YTQPXRM7        ;ALB/ASF- PSYCH TEST API FOR CLINICAL REMINDERS ; 7/12/07 5:07pm
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        ;Reference to ^PXRMINDX(601.2, supported by DBIA #4114
SET(X)  ;
        S N=N+1
        S YSDATA(N)=X
        Q
DASASI  ;
        K YSSONE
        S N=0,N2=0,IFN=$P(DAS,";",5)
        I '$D(^YSTX(604,IFN,0)) S YSDATA(1)="[ERROR]",YSDATA(2)="no asi match" Q
        D SET("[DATA]")
        S YSADATE=$P(^YSTX(604,IFN,0),U,5)
        S X=$P(^DPT(DFN,0),U)_"^ASI^--- Addiction Severity Index ---^"_YSADATE_U_$$FMTE^XLFDT(YSADATE,"5ZD")_U_$$GET1^DIQ(604,IFN_",",.09,"E")
        D SET(X)
        S YSDATA("S",1)="S1^Medical^"_$$GET1^DIQ(604,IFN_",",8.12)_U_$$GET1^DIQ(604,IFN_",",.61)
        S YSDATA("S",2)="S2^Employment^"_$$GET1^DIQ(604,IFN_",",9.34)_U_$$GET1^DIQ(604,IFN_",",.62)
        S YSDATA("S",3)="S3^Alcohol^"_$$GET1^DIQ(604,IFN_",",11.18)_U_$$GET1^DIQ(604,IFN_",",.63)
        S YSDATA("S",4)="S4^Drug^"_$$GET1^DIQ(604,IFN_",",11.185)_U_$$GET1^DIQ(604,IFN_",",.635)
        S YSDATA("S",5)="S5^Legal^"_$$GET1^DIQ(604,IFN_",",14.34)_U_$$GET1^DIQ(604,IFN_",",.64)
        S YSDATA("S",6)="S6^Family^"_$$GET1^DIQ(604,IFN_",",18.29)_U_$$GET1^DIQ(604,IFN_",",.65)
        S YSDATA("S",7)="S7^Psychiatric^"_$$GET1^DIQ(604,IFN_",",19.33)_U_$$GET1^DIQ(604,IFN_",",.66)
        Q
LEGDAS(YSDATA,DAS)      ;scoring for clinical reminder DAS entry
        N R,S,A,B,C,G,H,I,I1,J,K,L,L1,L2,M,N,N1,N2,P,P3,P4,P5,T,T1,V,W,X,X1,X2,X3,X4,Y,Y1,Y2,YS10,YS25,YS50,YS75,YS90,YSAD,YSAGE,YSANLL,YSAS,YSAST,YSAU,YSB1,YSB2,YSBOX,YSBR
        N YSBV,YSCALEN,YSCALET,YSCF,YSCF1,YSCNT,YSDAT,YSDATES,YSDOB,YSDS,YSED,YSED1,YSEP,YSET,YSF,YSFC,YSFR,YSHP1,YSHP2,YSHS,YSII,YSIN2,YSINC,YSIO,YSIT,YSIT1,YSIT2,YSIX,YSJJ,YSKC,YSKK,YSKY,YSLB,YSLE,YSLL
        N YSLM,YSLN,YSLNE,YSLV,YSMA,YSMF,YSMMPI,YSMMPR,YSMX,YSN,YSNAM,YSND,YSNM,YSNS,YSNS26,YSNS39,YSNS9,YSNSCALE,YSNSS,YSOCAT,YSOCNM,YSOCP,YSOCSX,YSOFF,YSPD,YSPS,YSPT,YSQ,YSQR,YSRAW,YSRH,YSRM,YSRP,YSRR,YSRS,YSRT,YSS,YSS1,YSS2
        N YSSC,YSSCALE,YSSCALEB,YSSEX,YSSH,YSSI,YSSK,YSSNM,YSSNM1,YSSNUMB,YSSP,YSSP4,YSSR,YSSS,YSSSN,YSSX,YSTAR,YSTEST,YSTESTA,YSTL,YSTN,YSTR,YSTTL,YSTV,YSTVL,YSTY,YSULOF,YSULON,YSVS,YSWF,YSX,YSXN,YSXR,YSXX,YSZ,Z,Z1,Z2
        N IFN,N4,R3,SFN1,SFN2,YSAA,YSADATE,YSBED,YSBEG,YSCK,YSCODE,YSED,YSEND,YSIFN,YSINUM,YSITEM,YSN2,YSNODE,YSPRIV,YSQT,YSR,YSSONE,YSSTAFF,YSTYPE
        S DAS=$P(DAS,U)
        S YSCODE=$P(DAS,";",3)
        I YSCODE'?1N.N D ERR("bad test code") Q  ;-->OUT
        S YSCODEN=$P(^YTT(601,YSCODE,0),U)
        S DFN=$P(DAS,";")
        I DFN'?1N.N D ERR("bad dfn") Q  ;--> OUT
        S (IFN,YSADATE)=$P(DAS,";",5)
        I IFN'>0 D ERR("bad IFN") Q  ;-->out
        I YSCODEN="GAF" D GAF Q  ;--> out
        I YSCODEN="ASI" D DASASI Q  ;-->out
        I YSADATE'?7N.E D ERR("bad date") Q  ;-->OUT
        ;;score me
SCOR1   S (YSTEST,YSET)=YSCODE
        S YSED=YSADATE
        S YSDFN=DFN
        S YSSX=$P(^DPT(DFN,0),U,2)
        S YSTN=YSCODEN
        IF '$D(^YTD(601.2,YSDFN,1,YSET,1,YSED)) S YSDATA(1)="[ERROR SCORE1 NEW]",YSDATA(2)="no administration found" Q
        D PRIV ;check it
        Q:YSPRIV=0
        S YSR(0)=$G(^YTT(601.6,YSET,0))
        I $P(YSR(0),U,2)="Y" S X=^YTT(601.6,YSET,1) X X
        Q:$G(YSDATA(1))?1"[ERROR".E
        ;;
SCORSET ;;heading data name^code^title^comp date^ordered by
        S N=0 D SET("[DATA]")
        S X=$P($G(^YTD(601.2,YSDFN,1,YSET,1,YSED,0)),U,3)
        S X=$S(X?1N.N:$P($G(^VA(200,X,0)),U,1),1:"")
        S X=$P(^DPT(DFN,0),U)_U_YSCODE_U_$P($G(^YTT(601,YSET,"P")),U)_U_YSED_U_$$FMTE^XLFDT(YSADATE,"5ZD")_U_X
        D SET(X)
        I YSPRIV=0 D SET("no privilege") Q
        ;no return of responses for legacy tests ASF 2/22/07
        ;S G=$G(^YTD(601.2,DFN,1,YSET,1,YSED,1)) F I=1:1 S A=$E(G,I) Q:A=""  S N1=N1+1,YSDATA("R",N1)="^^^^"_A_U_A
        D:YSPRIV SF^YTAPI2
        S N1=0
        F  S N1=$O(YSSONE(N1)) Q:N1'>0  S YSDATA("S",N1)=YSSONE(N1)
        Q
GAF     ;score gafs
        I '$D(^YSD(627.8,IFN,60)) D ERR("no ax5 ifn") Q  ;-->out
        S N=0,G=^YSD(627.8,IFN,0) D SET("[DATA]")
        S X=$P($G(^DPT(DFN,0)),U)_"^GAF^GAF^"_$P(G,U,3)_U_$$EXTERNAL^DILFD(627.8,.03,"",$P(G,U,3))_U_$$EXTERNAL^DILFD(627.8,.04,"",$P(G,U,4)) ;asf 2/13/04
        D SET(X)
        ;S YSDATA("R",1)="^^^^^"_$P($G(^YSD(627.8,IFN,60)),U,3)
        S YSDATA("S",1)="S1^GAF^"_$P($G(^YSD(627.8,IFN,60)),U,3)_U_$G(^YSD(627.8,IFN,80,1,0))
        Q
ERR(YSX)        ;errors
        S YSDATA(0)="[ERROR]",YSDATA(1)=YSX
        Q
PRIV    ;check privileges
        N YS71,YSKEY
        S YSPRIV=0
        S YS71=$O(^YTT(601.71,"B",YSCODEN,0))
        Q:YS71=""  ;-->out error
        S YSKEY=$$GET1^DIQ(601.71,YS71_",",9)
        I YSKEY="" S YSPRIV=1 Q  ;-->out exempt
        I $D(^XUSEC(YSKEY,DUZ)) S YSPRIV=1 Q  ;-->out has key
        Q
