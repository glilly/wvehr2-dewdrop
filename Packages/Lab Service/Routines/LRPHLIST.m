LRPHLIST        ;SLC/CJS - PRINT COLLECTION LIST ;2/19/91  11:13
        ;;5.2;LAB SERVICE;**161,398**;Sep 27, 1994;Build 3
        K IO("Q"),LRBAR,LRLABLIO
        S U="^",X="NOW",%DT="T",LRLL=1 D ^%DT D DD^LRX S LRDT0=Y
        I $P(^LAB(69.9,1,5),U,10) D  Q
        . W !,$C(7),"Collection list is STILL BUILDING."
        . D QUIT
        S LRDIV=$S($G(DUZ(2)):DUZ(2),1:+$$GET1^DIQ(4.3,1_",",217,"I")) ;multidivision
        I '$D(ZTQUEUED) W !,"1  LIST",!,"2  LABELS",!!,"Choose: " R LRLL:DTIME G:'$T!(LRLL="^")!(LRLL="") QUIT W:LRLL="?" !!,"Enter ""1"" or ""2""",! G LRPHLIST:(LRLL>2)!(LRLL<1) I LRLL=2 S LRPHLISF=2 D ^LRLABLIO I '$D(LRLABLIO) K LRPHLISF G LRPHLIST
        S LRSTA=0,LRFIN=""
        I '$D(ZTQUEUED) D LOC G:X["^" QUIT
        I LRLL=2 S IOP=LRLABLIO I '$G(LRLABLIO("Q")) S %ZIS="Q" D ^%ZIS K %ZIS,IOP G LRPHLIST:POP
        I LRLL=1,'$D(ZTQUEUED) K IOP S %ZIS="Q" D ^%ZIS G LRPHLIST:POP
        I $D(IO("Q"))!(LRLL=2&$G(LRLABLIO("Q"))) D  G END
        . S ZTRTN="DQ^LRPHLIST",ZTDESC="Collection list",ZTSAVE("LR*")="",ZTSAVE("DT")=""
        . I LRLL=2 S ZTIO=LRLABLIO
        . D ^%ZTLOAD
        . D ^%ZISC
        ;
DQ      U IO
        S $P(^LAB(69.9,1,5),"^",15)=1+$S($L($P(^LAB(69.9,1,5),"^",15)):$P(^(5),"^",15),1:0)
        S:$D(ZTQUEUED) ZTREQ="@" W:LRLL=1 !! S LRPR=0 D ^LRPHLIS1
        U IO W:LRLL=1 !
END     D ^%ZISC Q:$D(LRLABLTF)
        K LRBAR,LRLABLIO,LRWLEC,IOP,LRPHLISF,LRXL,ZTSK,ZTRTN,ZTIO,ZTDESC,ZTSAVE,IO("Q")
        G:'$D(ZTQUEUED) LRPHLIST
QUIT    K %,A,AGE,B,DFN,DIC,DOB,H8,I,I1,J,K,L,LRAA,LRACC,LRAD,LRAN,LRCDT,LRCE,LRCOUNT,LRD,LRDAT,LRDFN,LRDPF,LRDTI,LREAL,LREM,LREND,LRFN,LRIDT,LRIN,LRINFW,LRIX,LRLABEL,LRLABLIO,LRLBLBP,LRLF,LRLL,LRILOC,LRNEW,LRNT,LRODT,LRORD,LRPH
        K LRPORD,LRPR,LRPRAC,LRPREF,LRPSN,LRIRB,LRSAMP,LRSN,LRSPEC,LRSSP,LRST,LRTJDATA,LRTOPP,LRTS,LRTV,LRTVOL,LRTXT,LRUNQ,LRVOL,LRWL0,LRWLC,LRWRD,N,PNM,S1,S2,SEX,SSN,T,X,Y,Z,%H,%ZA,%ZB,%ZC,LABEL,LRFIN,LRLABLTF,LRLBLD,LRNOLABL,LRSTA,LRTJ,LRTOP,ZTIO
        K LRRB,LRLLOC,LRDIV,LRDIVLOC,LRMULTI,LRBAR,LRBAR0,LRBAR1
        Q
LOC     R !!,"Starting Location: ",X:DTIME S:X=" " X="" Q:X="^"  S LRSTA=X I X="?" W !,"Enter the abbreviation for the location you want to start with.",!,"Just enter return if you want to start at the beginning." G LOC
LOC1    R !,"Ending location: ",X:DTIME S:X=" " X="" Q:X="^"  S LRFIN=X I X="?" W !,"Enter the abbreviation for the location you want to end with.",!,"Just enter return if you want to print to the end." G LOC1
        S LRSTA=$S(0[LRSTA:-1,+LRSTA=LRSTA:LRSTA-.000001,1:$E(LRSTA,1,$L(LRSTA)-1)_$C($A(LRSTA,$L(LRSTA))-1)),LRFIN=$S(0[LRFIN:"",+LRFIN=LRFIN:LRFIN+.000001,1:LRFIN_" ")
        Q
