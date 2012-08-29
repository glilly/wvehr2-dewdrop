RMPR144P        ;VMP/RB - FIX LAB REQUEST POINTER PROBLEM FOR FILE #660 ;12/20/07
        ;;3.0;Prosthetics;**144**;12/20/07;Build 17
        ;;
        Q
FIX660  ;1. Post install to correct lab request pointer problems for Purchase
        ;   Card order 660 entries with incorrect Lab Request "LB" pointers. 
        ;
BUILD   K ^XTMP("RMPR144P") D NOW^%DTC S RMSTART=%
        S ^XTMP("RMPR144P","START COMPILE")=RMSTART
        S ^XTMP("RMPR144P","END COMPILE")="RUNNING"
        S ^XTMP("RMPR144P",0)=$$FMADD^XLFDT(RMSTART,90)_"^"_RMSTART
0       ;FIND REPETITIVE LAB REQUEST BOGUS LINKS
        S IEN=0,U="^"
1       S IEN=$O(^RMPR(660,IEN)) G EXIT:IEN=""!(IEN]"@")
        S R=$G(^RMPR(660,IEN,0)),R10=$G(^RMPR(660,IEN,10))
        I R=""!($P(R,U)<3050101) G 1
        S LB=$G(^RMPR(660,IEN,"LB")) G 1:LB=""
        S LRQ=$P(LB,U,10) G 1:LRQ=""
2       ;check invalid links
        K XX,IENA,IENB
        S XX=$O(^RMPR(668,"F",IEN,0))
        S IENA=$P(R,U,2),RQ=$G(^RMPR(664.1,LRQ,0)),IENB=$P(RQ,U,2)
        I IENA=IENB G 1
        S ^XTMP("RMPR144P",660,IEN,0)=$G(LRQ)_U_$G(XX)_U_IENA_U_IENB
        S ^XTMP("RMPR144P",660,IEN,1)=LB,^XTMP("RMPR144P",660,IEN,3)=$P(R,U,1,9),^XTMP("RMPR144P",660,IEN,4)=$P(RQ,U,1,9)
        ;W !!,IEN,?12,IENA,?22,IENB,?40,LRQ,?60,XX,!,$P(R,U,1,9),!,LB,!,$P(RQ,U,1,9)
        K ^RMPR(660,IEN,"LB")
        G 1
EXIT    ;
        D NOW^%DTC S RMEND=%
        S ^XTMP("RMPR144P","END COMPILE")=RMEND
        K RMEND,RMSTART,%,IEN,R,R10,LRQ,LB,XX,IENA,IENB
        Q
