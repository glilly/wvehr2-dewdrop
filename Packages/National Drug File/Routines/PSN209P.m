PSN209P ;BIR/WRT-Unwind Transport Global and set pieces in VA PRODUCT file ;04/03/09
        ;;4.0; NATIONAL DRUG FILE;**209**; 30 Oct 98;Build 32
        ;
BUILD   ;GET PMIS INFO FROM TRANSPORT GLOBAL AND LOAD
        I '$D(XPDGREF) Q
        N DA,I,J,K,LINE,PSN,ROOT,X
        F PSN=50.621:.001:50.627 K ^PS(PSN)
        S ROOT=$NA(@XPDGREF@("DATA")),J=0
        K ^TMP($J)
        F  S J=$O(@ROOT@(J)) Q:'J  S LINE=^(J),K=$L(LINE,"|")-1 F I=1:1:K S X=$P(LINE,"|",I),^TMP($J,$P(X,"^"))=$P(X,"^",2,4)
        S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  S X=$P($G(^(DA,1)),"^",1,4) S:$D(^TMP($J,DA)) X=X_"^"_^(DA) S ^PSNDF(50.68,DA,1)=X
        K ^TMP($J)
        F PSN=50.621:.001:50.627 M ^PS(PSN)=@XPDGREF@(PSN)
        K DA,I,J,K,LINE,PSN,ROOT,X
        Q
