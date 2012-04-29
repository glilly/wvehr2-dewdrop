SROAMEAS        ;BIR/MAM - INPUT TRANSFORMS, HEIGHT & WEIGHT ;03/20/06
        ;;3.0; Surgery ;**38,125,153,166**;24 Jun 93;Build 7
H       Q:'$D(X)  I X'?.N1"C"&(X'?.N1"c"),(+X'=X) K X Q
        I +X=X S X=X+.5\1 I X'>47.9!(X'<86.1) K X Q
        S:X["c" X=+X_"C"
        I X?.N1"C",(X'>121.9!(X'<218.1)) K X
        Q
W       Q:'$D(X)  I +X'=X,(X'?.N1"K")&(X'?.N1"k") K X Q
        I +X=X S X=X+.5\1 I X'>49.9!(X'<700.1) K X Q
        S:X["k" X=+X_"K"
        I X?.N1"K",(X'>22.9!(X'<318.1)) K X
        Q
HWC     ; reject NS entry if the case is cardiac one
        S X=$S(X="ns":"NS",1:X)
        I $P($G(^SRF($S($G(SRTN):SRTN,1:DA),"RA")),"^",2)="C",X="NS" S X=""
        Q
