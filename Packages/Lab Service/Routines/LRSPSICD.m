LRSPSICD        ;AVAMC/REG - CY/EM/SP ICD SEARCH ;8/15/95  08:39
        ;;5.2;LAB SERVICE;**72,253,315**;Sep 27, 1994;Build 25
        W @IOF,!?20,LRO(68)," SEARCH BY ICD9CM CODE"
ASK     S DIC=80,DIC(0)="AEMOQZ" D ^DIC K DIC Q:Y<1
        N LRX
        S N=+Y,(LRX,I(1))=$P(Y(0),U),I=$P($$ICDDX^ICDCODE(LRX,,,1),U,4)
        W ! D B^LRU Q:Y<0  S LRSDT=LRSDT-.01,LRLDT=LRLDT+.99
        S ZTRTN="QUE^LRSPSICD" D BEG^LRUTL Q:POP!($D(ZTSK))
QUE     U IO K ^TMP($J) D L^LRU,S^LRU,XR^LRU
        S ^TMP($J,0)=I(1)_"^"_I_"^"_LRO(68)_"^"_"ICD9CM CODE"
        F X=0:0 S LRSDT=$O(^LR(LRXR,LRSDT)) Q:'LRSDT!(LRSDT>LRLDT)  D L
        D ^LRSPSICP K ^TMP($J) D K^LRU,END^LRUTL Q
L       F LRDFN=0:0 S LRDFN=$O(^LR(LRXR,LRSDT,LRDFN)) Q:'LRDFN  D I
        Q
I       F LRI=0:0 S LRI=$O(^LR(LRXR,LRSDT,LRDFN,LRI)) Q:'LRI  D TO
        Q
TO      Q:$P($P($G(^LR(LRDFN,LRSS,LRI,0)),U,6)," ")'=LRABV  Q:'$D(^(3,N,0))
        S LREP=^LR(LRDFN,LRSS,LRI,0),H(2)=$E($P(LREP,"^",10),1,3)
        S LRAC=$P(LREP,"^",6),LRAN=+$P(LRAC," ",3)
PRT     S LRPF=^DIC($P(^LR(LRDFN,0),"^",2),0,"GL"),LRFLN=+$P(@(LRPF_"0)"),"^",2),DFN=$P(^LR(LRDFN,0),"^",3),LRDPF=$P(^(0),U,2) Q:'$D(@(LRPF_DFN_",0)"))
        S LRPPT=@(LRPF_DFN_",0)"),LRP=$P(LRPPT,"^"),SSN=$P(LRPPT,"^",9),SEX=$P(LRPPT,"^",2),DOB=$P(LRPPT,"^",3),X1=$P(LREP,"^"),X2=DOB D ^%DTC,SSN^LRU S AGE=X\365.25
        S:AGE>110!(AGE<10) AGE="?"
        S ^TMP($J,H(2),LRAN)=LRAC_U_AGE_U_SEX_U_LRP_U_SSN(1)_U_+$E($P(LREP,U,10),4,5)_"/"_$E($P(LREP,U,10),6,7),^TMP($J,"B",LRP,H(2),LRAN)=""
HERE    Q
