LRAPCUM1 ;AVAMC/REG - AP PATIENT CUM ;7/15/93  10:36 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P
 W !,LR("%"),!,"SNOMED/ICD codes:" F C=0:0 S C=$O(^LR(LRDFN,LRSS,LRI,2,C)) Q:'C  S T=+^(C,0),T=^LAB(61,T,0) D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P  W !,"T-",$P(T,"^",2),": " S X=$P(T,"^") D:LR(69.2,.05) C^LRUA W X D M
 Q:LRA(2)?1P  W ! F C=0:0 S C=$O(^LR(LRDFN,LRSS,LRI,3,C)) Q:'C  D:$Y>LRA(1)!'$T MORE Q:LRA(2)?1P  S X=+^LR(LRDFN,LRSS,LRI,3,C,0),X=^ICD9(X,0),X(9)=$P(X,"^"),X=$P(X,"^",3) W !,"ICD code: ",X(9),?20 D:LR(69.2,.05) C^LRUA W X
 Q
M F B=0:0 S B=$O(^LR(LRDFN,LRSS,LRI,2,C,2,B)) Q:'B  S M=+^(B,0),M=^LAB(61.1,M,0) D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P  W !?5,"M-",$P(M,"^",2),": " S X=$P(M,"^") D:LR(69.2,.05) C^LRUA W X D EX
 Q:LRA(2)?1P  F B=1.4,3.3,4.5 F F=0:0 S F=$O(^LR(LRDFN,LRSS,LRI,2,C,$P(B,"."),F)) Q:'F  D A
 Q
A S M=+^LR(LRDFN,LRSS,LRI,2,C,$P(B,"."),F,0),E="61."_$P(B,".",2),M=^LAB(E,M,0) D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P  W !?5,$S(B=1.4:"D-",B=3.3:"F-",B=4.5:"P-",1:""),$P(M,"^",2),?12,": " S X=$P(M,"^") D:LR(69.2,.05) C^LRUA W X
 Q
EX F G=0:0 S G=$O(^LR(LRDFN,LRSS,LRI,2,C,2,B,1,G)) Q:'G  S E=+^(G,0),E=^LAB(61.2,E,0) D:$Y>LRA(1)!'$Y MORE Q:LRA(2)?1P  W !?10,"E-",$P(E,"^",2),": " S X=$P(E,"^") D:LR(69.2,.05) C^LRUA W X
 Q
MORE D MORE^LRAPCUM Q
