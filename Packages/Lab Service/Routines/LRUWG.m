LRUWG ;AVAMC/REG - SINGLE TEST WORKLIST ;2/22/94  09:45 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 D END W !!?20,"Single test worklist"
T S DIC=60,DIC(0)="AEMOQZ" D ^DIC K DIC G:Y<1 END S W(1)=$P(Y,U,2),F=+Y
 S X=$O(^LAB(60,F,8,0)) I 'X W $C(7),!,"No INSTITUTION designated in LAB TEST FILE (#60, field 6)",! G T
 S X(1)=+^LAB(60,F,8,X,0),X(1)=$P(^DIC(4,X(1),0),U)
 I $O(^LAB(60,F,8,X)) D ASK G:'$D(X) T
 S X=^LAB(60,F,8,X,0),(W,LRAA)=$P(X,"^",2) I 'LRAA W $C(7),!,"No Accession AREA for this test",! G T
D S %DT="AE",%DT("A")="ENTER TEST DATE: " D ^%DT G:Y<1 END D LRAD
 S X=$S(X="Y"&(LRAD["0000"):1,X="D"&(+$E(LRAD,6,7)):1,"MQ"[X&(+$E(LRAD,4,5)):1,1:0) I 'X W $C(7),"  Date not specific enough" G D
 I '$D(^LRO(68,W,1,LRAD,0)) W $C(7),!!,"NO ",W(1)," ACCESSIONS IN FILE FOR ",LRH(0),! G D
ST R !!,"Start from accn #: ",N(1):DTIME G:N(1)=""!(N(1)[U) END G:N(1)'?1N.N ST
 R !!,"Go    to   accn #:   LAST// ",N(2):DTIME G:N(2)[U!('$T) END S:N(2)="" N(2)=99999 I N(2)'?1N.N W $C(7),!!,"NUMBERS ONLY" G ST
 S ZTRTN="QUE^LRUW" D BEG^LRUTL G:POP!($D(ZTSK)) END
QUE S:$D(ZTQUEUED) ZTREQ="@"
 D L^LRU K ^TMP($J) S N=N(1)-1,(LR("Q"),LRQ)=0,LRQ(1)=DUZ(2)
ACN F A=0:0 S N=$O(^LRO(68,W,1,LRAD,1,N)) Q:'N!(N>N(2))  I $D(^(N,0)) S X=^(0),LRLLOC=$P(X,"^",7),LRDFN=+X D:LRDFN TT
 D WRT W:IOST'?1"C".E @IOF K ^TMP($J) D END^LRUTL,END Q
L W !,$J(Z,3),") ",$J($S(T(5)>.999:T(5),1:T(5)*1000),5),?14,$P(N,"^",6) W:$L($P(N,"^",6))>21 !
 S X=$P(N,"^",5) W ?37,N(7),?49,$S(X:$P($G(^VA(200,X,0)),"^",2),1:X),?54,$P(N,"^",2),?60,$E($P(N,"^"),1,19),!?15 F X=1:1:IOM-15 W "-"
 Q
H I $D(LR("F")),IOST?1"C".E D M^LRU Q:LR("Q")
 D F^LRU W !,^TMP($J,W,0)," Worklist",?40,"(* = STAT)"
 W !,"COUNT",?6,"ACC#",?17,"RESULT",?37,"Completed",?49,"Tech",?54,"ID",?60,"PATIENT",!,LR("%"),! Q
NEW D H Q:LR("Q")  W !?15,T(2),T(3),":",!,LRH(0) Q
TT F T=0:0 S T=$O(^LRO(68,W,1,LRAD,1,N,4,T)) Q:'T!(T=F)
 S X=^LR(LRDFN,0),Y=$P(X,"^",3),LRDPF=$P(X,U,2),(X,LRPF)=^DIC($P(X,"^",2),0,"GL"),X=@(X_Y_",0)"),LRP=$P(X,"^"),SSN=$P(X,"^",9) D SSN^LRU
 Q:T<1  S T(4)=^LRO(68,W,1,LRAD,1,N,4,T,0),V=$P(T(4),"^",4),T(6)=$P(T(4),"^",5),T(1)=$P(T(4),"^",2),T(4)=$P(T(4),"^",6) S:T(1)=1 T(1)="*" D STF
 Q
STF ;
 I '$D(^TMP($J,W,1,T,0)) S X=^LAB(60,T,0),P=$S($D(^LAB(60,T,.1)):" ("_$P(^(.1),"^")_")",1:""),^TMP($J,W,1,T,0)=$P(X,"^")_"^"_P,^TMP($J,W,1,"B",$P(X,"^"),T)=""
 I '$D(^TMP($J,W,0)) S X=$S($D(^LRO(68,W,0)):$P(^(0),"^"),1:"??"),^TMP($J,W,0)=X
 I LRPF="^LAB(62.3," S C(6)=N,N=N/1000,^TMP($J,W,1,T,N)=LRP_"^"_SSN(1)_"^"_LRLLOC_"^"_T(1)_"^"_V_"^"_T(4)_"^"_T(6),N=C(6) Q
 S ^TMP($J,W,1,T,N)=LRP_"^"_SSN(1)_"^"_LRLLOC_"^"_T(1)_"^"_V_"^"_T(4)_"^"_T(6) Q
WRT F W=0:0 S W=$O(^TMP($J,W)),LRQ=0 Q:'W  D H Q:LR("Q")  S LR("F")=1 D ZZ
 Q
ZZ S A(8)=0 F X=0:0 S A(8)=$O(^TMP($J,W,1,"B",A(8))) Q:A(8)=""!(LR("Q"))  S T=$O(^(A(8),0)) D:$Y>(IOSL-6) H Q:LR("Q")  S T(3)=^TMP($J,W,1,T,0),T(2)=$P(T(3),"^"),T(3)=$P(T(3),"^",2) W !?15,T(2),T(3),":",!,LRH(0) S T(5)=0 D SCN
 Q
SCN F Z=1:1 S T(5)=$O(^TMP($J,W,1,T,T(5))) Q:T(5)=""!(LR("Q"))  S N=^TMP($J,W,1,T,T(5)),Y=$P(N,"^",7) D T^LRU S N(7)=Y D:$Y>(IOSL-6) NEW Q:LR("Q")  D L
 Q
ASK S DIC="^LAB(60,F,8,",DIC(0)="AEMOQZ",DIC("B")=X(1) D ^DIC K DIC I Y<1 K X Q
 S X=+Y Q
LRAD S X=$P(^LRO(68,LRAA,0),"^",3),(Y,LRAD)=$S(X="Y":$E(Y,1,3)_"0000","M"[X:$E(Y,1,5)_"00","Q"[X:$E(Y,1,3)_"0000"+(($E(Y,4,5)-1)\3*300+100),1:Y) D D^LRU S LRH(0)=Y Q
 ;
END D V^LRU Q
