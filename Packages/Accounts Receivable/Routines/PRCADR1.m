PRCADR1 ;SF-ISC/YJK-PRINT ADDRESS,APPROPR.CDS ;8/16/96  1:02 PM
V       ;;4.5;Accounts Receivable;**49,138,233**;Mar 20, 1995;Build 4
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;print debtor's /vendor address,multiple appropriations,list of other bills.
EN1     ;print the appropriation,pat ref #. (multiple) and amount.
        W !,"ORIGINAL AMOUNT: ",$J($P(^PRCA(430,D0,0),U,3),0,2)
        I $P($G(^PRCA(430,D0,13)),"^") W !,"MEDICARE CONTRACTUAL ADJUSTMENT: ",$J($P($G(^PRCA(430,D0,13)),"^"),0,2)
        I $P($G(^PRCA(430,D0,13)),"^",2) W !,"UNREIMBURSED MEDICARE EXPENSE: ",$J($P($G(^PRCA(430,D0,13)),"^",2),0,2)
        W !!,"FISCAL YEAR",?15,"APPROP. CODE",?38,"PAT REFERENCE #",?66,"AMOUNT"
        W !,"-----------",?15,"------------",?38,"---------------",?66,"------"
        S PRCAFN=0 F PRCAE1=0:0 S PRCAFN=$O(^PRCA(430,D0,2,PRCAFN)) Q:PRCAFN'>0  D WRPAT
END1    K PRCAE1,PRCAFN Q  ;end of EN1
WRPAT   Q:'$D(^PRCA(430,D0,2,PRCAFN,0))  S PRCAFY=$P(^(0),U,1),PRCAMT=$P(^(0),U,2)
        S PRCAPAT="" I $P(^PRCA(430,D0,2,PRCAFN,0),U,3)'="" S PRCAPAT=$S($D(^PRC(442,$P(^(0),U,3),0)):$P(^(0),U,1),1:"")
        S PRCAPPR=$P($G(^PRCA(430,D0,11)),U,17)
        W !,?5,PRCAFY,?18,$E(PRCAPPR,1,10),?40,PRCAPAT,?60,$J(PRCAMT,12,2)
        K PRCAPAT,PRCAPPR,PRCAFY,PRCAMT Q
EN2     ;PRINT DEBTOR'S ADDRESS - VENDOR
        Q:'$D(D0)  S PRCADBPT=$S($P(^PRCA(430,D0,0),U,9)'="":$P(^(0),U,9),1:"") G:PRCADBPT="" END2 S PRCADB=$P(^RCD(340,PRCADBPT,0),"^") N X S X=$$DADD^RCAMADD(PRCADB) S $P(PRCAGL,"^",1,6)=$P(X,"^",1,6),$P(PRCAGL,"^",9)=$P(X,"^",7) K PRCADB
        S PRCASTE=$P(PRCAGL,U,5),PRCALN=$S($D(PRCALN):PRCALN,1:0)
WR      W:PRCALN<1 ! W !,?PRCALN,$P(PRCAGL,U,1)
        F I=2,3,4 W:$P(PRCAGL,U,I)'="" !,?PRCALN,$P(PRCAGL,U,I)
        I PRCASTE'="",PRCASTE'[" " W ", ",PRCASTE," ",$P(PRCAGL,U,6)
        W "        PHONE NO.:",$P(PRCAGL,U,9)
END2    K %,PRCASTE,PRCAGL,PRCADBPT,PRCALN Q
        ;
EN4     ;Print the debtor's other bills.
        D PRCOMM^PRCAUT3 Q:'$D(D0)  S PRCAT1=$P(^PRCA(430,D0,0),U,2) G:PRCAT1="" END4 S PRCAT1=$P(^PRCA(430.2,PRCAT1,0),U,6) G:PRCAT1["T" END4
        S PRCADBPT=$S($P(^PRCA(430,D0,0),U,9)'="":$P(^(0),U,9),1:"")
        G:PRCADBPT="" END4 S X=$P(^RCD(340,PRCADBPT,0),"^",3)
        W !,"Statement date: " N %DT,Y S %DT="F",X=$S($E(DT,6,7)>X:$S($E(DT,4,5)+1>12:1,1:$E(DT,4,5)+1),1:$E(DT,4,5))_"-"_$P(^RCD(340,PRCADBPT,0),"^",3) D ^%DT X ^DD("DD") W $S($L(Y)>4:Y,1:"N/A")
        S PRCABNT="",PRCACT=0 W !,"OTHER BILLS:",!?2
        F I=0:0 S PRCABNT=$O(^PRCA(430,"C",PRCADBPT,PRCABNT)) Q:PRCABNT=""  I PRCABNT'=D0,$D(^PRCA(430,PRCABNT,0)) S PRCACT=PRCACT+1,X="" D:$Y+5>IOSL&($E(IOST)="C")  Q:X["^"  D EN41
        .W *7 R X:DTIME I '$T S X="^" Q
        .W @IOF,!?2
        .Q
END4    K PRCAT1,PRCADBPT,PRCABNT,I,PRCACT Q  ;end of EN4
EN41    S PRCAT11=$P(^PRCA(430,PRCABNT,0),U,2) G:PRCAT11="" END41 S PRCAT11=^PRCA(430.2,PRCAT11,0)
        S PRCABTY=" ("_$E(PRCAT11,1,4)_"/"_$S($D(^PRCA(430.3,+$P(^PRCA(430,PRCABNT,0),"^",8),0)):$E($P(^(0),"^"),1,4),1:"")_")  " W $P(^PRCA(430,PRCABNT,0),U,1),PRCABTY W:'(PRCACT#3) !?2
END41   K PRCABTY,PRCAT11 Q  ;end of EN41
EN5     ;Print interest/admin rate date and rate.
        Q:'$D(PRCABN)  S (PRCA("INTD"),PRCA("INTR"),PRCA("ADMD"),PRCA("ADMR"))=""
        S PRCAIDT=X,X=$$INT^RCMSFN01($P(^PRCA(430,PRCABN,0),"^",10)),PRCA("INTR")=+X
        S Y=$P(X,"^",2) X ^DD("DD") S PRCA("INTD")=Y
EN51    ;
        S X=$$ADM^RCMSFN01($P(^PRCA(430,PRCABN,0),"^",10)),PRCA("ADMR")=+X,Y=$P(X,"^",2) X ^DD("DD") S PRCA("ADMD")=Y
W5      W !!,"INTEREST EFFECTIVE RATE DATE:  ",PRCA("INTD"),?45,"ANNUAL INTEREST RATE:  ",PRCA("INTR")
        W !,"ADMIN EFFECTIVE RATE DATE:     ",PRCA("ADMD"),?45,"MONTHLY ADMIN RATE: ",PRCA("ADMR")
        S X=$S($D(PRCAIDT):PRCAIDT,1:"") K PRCA("INTD"),PRCA("ADMR"),PRCA("ADMD"),PRCA("INTR"),PRCAIDT Q
PATNM   ;write a patient name for the 3rd party
        Q:('$D(PRCAT))!('$D(PRCABN))  Q:PRCAT'["T"
        S DFN=$P(^PRCA(430,PRCABN,0),U,7) I DFN D DEM^VADPT
        W !,"PATIENT: ",$S($D(VADM):VADM(1),1:""),?45,"SSN: ",$S($D(VADM):$P(VADM(2),U,2),1:""),! K DFN,VADM,VAERR Q  ;end of PATNM
EN6     ;Insurance insured's information
        Q:('$D(PRCAT))!('$D(PRCABN))  Q:PRCAT'["T"  S Z=$S($D(^PRCA(430,PRCABN,202)):^(202),1:"")
        W !!,"INSURED'S NAME",?28,"ID NO.",?45,"GROUP NAME",?62,"GROUP NO."
        W !,?2,$P(Z,U,1),?29,$P(Z,U,4),?46,$P(Z,U,5),?63,$P(Z,U,6)
        S %=^PRCA(430,PRCABN,0) W:$P(%,U,19)>0 !!,"SECONDARY INSURANCE CARRIER:  ",$S($D(^DIC(36,+$P(%,U,19),0)):$P(^(0),U,1),1:"")
        W:$P(%,U,20)>0 !,"TERTIARY INSURANCE CARRIER:  ",$S($D(^DIC(36,+$P(%,U,20),0)):$P(^(0),U,1),1:"") K %,Z Q
