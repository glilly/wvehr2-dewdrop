YTDOMR1 ;ALB/ASF SLC/DKG-EXTENDED INTERVIEW REPORTER ;6/19/97  17:09
        ;;5.01;MENTAL HEALTH;**31**;Dec 30, 1994
        ;
MAIN    ;
        K ^UTILITY($J,"W")
        S YSLFN=1 ; S YSJ=1,U1=0,L=-200,YSLCK=200
        D R1
        D PRT
        Q
R1      ;
        F YSJ=1:1 Q:'$D(^YTT(601,YSTEST,"G",1,1,YSJ,0))  D R2
        Q
R2      ;
        S A=^YTT(601,YSTEST,"G",1,1,YSJ,0),YSITEM=+$P(A,U),YSEXE=$P($P(A,U),";",2)
        I YSITEM=0 S R="" X YSEXE D STEM Q
        I YSEXE="L"!(YSEXE="'L") D LISTER Q
        S L=(YSITEM-1)\200*200,U1=L+200,YSYX=^YTD(601.2,YSDFN,1,YSET,1,YSED,U1\200)
        S R=$E(YSYX,YSITEM-L) Q:R=" "!(R="X")
        S:"YN"[R R=R="N"+1 S R=$P(A,U,R+2) Q:R=""
        D STEM
        Q
STEM    ;
        S YSSTEM=$P(A,U,2)
        I YSSTEM'["#" S YSYTX=YSSTEM_R D L Q
        S A=$F(YSSTEM,"#") I A<3 S YSYTX=R_$E(YSSTEM,2,999) D L Q
        S YSYTX=$E(YSSTEM,1,A-2)_R_$E(YSSTEM,A,999) D L
        Q
END     ;
        K I,YSLCK,R,YSSTEM,YSYX,YSYCK,YSSCK Q
LISTER  ;list formated output
        K B1 S YSTL=0,YSTLN=1,YSCOMP=$S(YSEXE="'L":"N",1:"Y")
        ; check at list begining
        S YSQTYP=^YTT(601,YSTEST,"Q",YSITEM,1) I YSQTYP'=1 S R="eRROR LINE "_YSJ D STEM Q
        S L=(YSITEM-1)\200*200,U1=L+200,YSYX=^YTD(601.2,YSDFN,1,YSET,1,YSED,U1\200)
        S R=$E(YSYX,YSITEM-L)
        S:R=YSCOMP YSTL=YSTL+1,B1(YSTL)=$P(A,U,3)
        D LIST1
        I 'YSTL S R=$P(A,U,YSTLN+2) D STEM Q
        I YSTL=1 S R=B1(1) D STEM Q
        I YSTL=2  S R=B1(1)_" and "_B1(2) D STEM Q
        S R="" F I=1:1:YSTL-1 S R=R_B1(I)_", "
        S R=R_"and "_B1(YSTL) D STEM
        Q
LIST1   S YSTLN=YSTLN+1,YSITEM=YSITEM+1
        Q:'$D(^YTT(601,YSTEST,"Q",YSITEM))
        S YSQTYP=^YTT(601,YSTEST,"Q",YSITEM,1) Q:YSQTYP'=2
        S L=(YSITEM-1)\200*200,U1=L+200,YSYX=^YTD(601.2,YSDFN,1,YSET,1,YSED,U1\200)
        S R=$E(YSYX,YSITEM-L)
        S:R=YSCOMP YSTL=YSTL+1,B1(YSTL)=$P(A,U,YSTLN+2)
        G LIST1
L       ;
        D:YSYTX["{" PRO ;evaluate pronouns etc
        I $L(YSYTX)<80 S DIWL=0,DIWR=79,X=YSYTX D ^DIWP
        I $L(YSYTX)>80 D
        . S YSX1=YSYTX
        . F I=$L(YSX1):-1:1 S Y1=$E(YSX1,I) I Y1=" "&(I<80) S X=$E(YSX1,1,I-1),YSX1=$E(YSX1,I+1,999),DIWL=0,DIWR=79 D ^DIWP Q 
        . I $L(YSX1),YSX1'=" " S DIWL=0,DIWR=79,X=YSX1 D ^DIWP
        Q
PRT     ; Print output
        S YSZZ=0
        S YSHDR=$E(YSHDR,1,43)_" "_YSSEX_" AGE "_$J(YSAGE,2,0)
        W @IOF,YSHDR,?53,$$FMTE^XLFDT(DT,"5ZD"),?64,$$FMTE^XLFDT(YSHD,"5ZD")
        W !,?53,"PRINTED",?64,"ENTERED",!
        S N=0 F  S N=$O(^UTILITY($J,"W",0,N)) Q:N'>0!YSZZ  D
        . W !,^UTILITY($J,"W",0,N,0)
        . D:$Y+4>IOSL WAIT
        ;
        Q
WAIT    ;
        F I0=1:1:IOSL-$Y-2 W !
        N DTOUT,DUOUT,DIRUT
        I IOST?1"C".E W $C(7) S DIR(0)="E" D ^DIR K DIR S YSZZ=$D(DIRUT)
        Q:YSZZ
        W @IOF,YSHDR,?53,$$FMTE^XLFDT(DT,"5ZD"),?64,$$FMTE^XLFDT(YSHD,"5ZD")
        W !?53,"PRINTED",?64,"ENTERED",!
        Q
PRO     ;evaluate pronoun, possesive etc
        F I=1:1:$L(YSYTX,"{") D
        . S P1=$F(YSYTX,"{")-1,P2=$F(YSYTX,"}")
        . Q:'P1!'P2
        . S G=$E(YSYTX,P1+1,P2-2),G1=0
        . S:G="Pro" G1=$S(YSSEX="F":"She",1:"He")
        . S:G="pro" G1=$S(YSSEX="F":"she",1:"he")
        . S:G="Pos" G1=$S(YSSEX="F":"Her",1:"His")
        . S:G="pos" G1=$S(YSSEX="F":"her",1:"his")
        . S:G="Title" G1=$S(YSSEX="F":"Ms.",1:"Mr.")
        . S:G="DATE" G1=$E(YSED,4,5)_"/"_$E(YSED,6,7)_"/"_$E(YSED,2,3)
        . S:G="CLIN" G1=$P($G(^VA(200,$P(^YTD(601.2,YSDFN,1,YSET,1,YSED,0),U,3),20)),U,2)
        . I G="Last" S X=$P($P(^DPT(YSDFN,0),U),",") D
        .. F %=2:1:$L(X) I $E(X,%)?1U,$E(X,%-1)?1A S X=$E(X,0,%-1)_$C($A(X,%)+32)_$E(X,%+1,999)
        .. S G1=X
        . S YSYTX=$E(YSYTX,1,P1-1)_G1_$E(YSYTX,P2,999)
        ;
        Q
