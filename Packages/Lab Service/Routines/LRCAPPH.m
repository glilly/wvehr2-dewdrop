LRCAPPH ;DALOI/FHS - PROCESS PHLEBOTOMY WORKLOAD DATA ; 5/1/99
        ;;5.2;LAB SERVICE;**1,19,127,136,138,158,153,263,264,388**;Sep 27, 1994;Build 2
        ;**DBIA 1995-A  Retrieve CPT codes
        ;**DBIA 1995-B  Retrieve CPT Modifiers
        ;**DBIA 1889-A  Pass PCE Encounter Data
        ;**DBIA 1889-B  Delete PCE Entries
        ;**DBIA 1889-F  Extract PCE Data
        ; Reference to ^DIC(9.4, Supported by Reference 10048
        ; Reference to ^SC( Supported by Reference 10040
        ; Reference to  ^%ZOSF("TEST") Supported by Reference #10096
        ; Reference to  ^DIC(40.7 Supported by Reference #923
        ; Reference to  ^XMB(1 Supported by Reference #10091
        ; Reference to  T0^%ZOSV Supported by Reference #10097
        ; Reference to  T1^%ZOSV Supported by Reference #10097
        ; Reference to  ^DIC( Supported by Reference #10006
        ; Reference to  EN3^SDACS Supported by DBIA #10041
        ;  No longer called
        ; Reference to  $$PKGON^VSIT Supported by DBIA #1900-E
        ; Reference to  $$NOW^XLFDT Supported by Reference #10103
        ; Reference to  $$GET^XUA4A72 Supported by Reference #1625
EN      ;
        I $G(^LRO(69,"AE"))'=DT D
        . D EN0^LRCAPPH3
        . S ^LRO(69,"AE")=DT
NP      ;Not performed entry tag Called from LRCAPPNP
        N LRSPEC,LR657,LR658
        D
        . K DIC S DIC="^LAM(",DIC(0)="ONMX"
        . S X="89343.0000",LR657=657 D ^DIC I Y>1 S LR657=+Y
        . S X="89341.0000",LR658=658 D ^DIC I Y>1 S LR658=+Y
        K ^LRO(69,"AE",0)
        I $G(LRNP) S LRNOPX=1
        I $D(ZTQUEUED) S ZTREQ="@" K LRDBUG
        I '$G(LRDBUG) K ^TMP("LRMOD",$J)
        S LRDPRAC=+$P($G(^LAB(69.9,1,12)),U)
        I LRDPRAC D
        . N DIC,X
        . S DIC(0)="NZ",DIC=200,X="`"_LRDPRAC
        . D ^DIC S LRDPRAC=$S(Y<1:0,$P($G(Y(0)),U,11):0,1:+Y)
        . I $$GET^XUA4A72(LRDPRAC)<1 S LRDPRAC=0
        S LROK=+$G(^LAB(69.9,1,.8)) G:'LROK END0
        I $P($G(^SC(LROK,0)),U)'["LAB DIV " G END0
        K LROK
        I '$G(LRNP) L +^LRO("LRCAPPH","NITE"):1 G:'$T END0
        S:'$D(^LAB(69.9,1,"NITE")) ^("NITE")=""
        S LRWRKL=$S($P(^LAB(69.9,1,0),U,14):1,1:0)
        I $D(XRTL) S XRTN="LRCAPPH" D T0^%ZOSV
        S LRPKG=$O(^DIC(9.4,"C","LR",0))
        S:'LRPKG LRPKG=$O(^DIC(9.4,"B","LAB SERVICE",0))
        G:'LRPKG END0
        S LRVSIT=$P($G(^LAB(69.9,1,"VSIT")),U)
        S X="PXAI" X ^%ZOSF("TEST") I '$T G END0
        S:'$G(LRNP) $P(^LAB(69.9,1,"NITE"),U,2)=$$NOW^XLFDT
        S LRPCEON=$$PKGON^VSIT("PX")
        S ^TMP("LRMOD",$J)=""
SDC     S SDC=$S($P(^LAB(69.9,1,"NITE"),U,3):$G(^DIC(40.7,+$P(^LAB(69.9,1,"NITE"),U,3),0)),1:"") S LRSDC=$S($P(SDC,U,2):+$P(SDC,U,2),1:108)
DSSLOC  S LRDLOC=+$G(^LAB(69.9,1,.8))
        S LCWT=$P($G(^LAM(LR658,0)),U,3)_U_$P($G(^LAM(LR658,0)),U,10)
        S LSPWT=$P($G(^LAM(LR657,0)),U,3)_U_$P($G(^LAM(LR657,0)),U,10)
        S LRCSC=+$G(^LAB(69.9,1,"VSIT"))
        S LRINS=+$P($G(^XMB(1,1,"XUS")),U,17) G END0:'LRINS
HEAC    ;
        D
        . N DIC,Y,X
        . S DIC="^LRO(68,",DIC(0)="MO",X="HEM" D ^DIC
        . I Y>0 S LRDAA=+Y Q
        . S LRDAA=10
        S LRSPEC=$P($G(^LAB(69.9,1,1)),U)
        I $G(LRNP) S LRNOPX=0 Q
        S (LRCEX,LRCEXV,LREND,LROA)=0 F  S LRCEX=$O(^LRO(69,"AA",LRCEX)) Q:LRCEX=""!(LREND)  D
        . K LRXCPT
        . S (LROA,LRCC)="" F  S LROA=$O(^LRO(69,"AA",LRCEX,LROA)) Q:LROA=""  S LRCDT=+LROA,LRSN=+$P(LROA,"|",2) D:LRCDT&(LRSN) LOOK D
        . . I '$G(LRDBUG) K:'$G(^LRO(69,"AA",LRCEX,LROA)) ^(LROA)
AE      ;Process NP specimens and delete CPT procedures
        K LRXCPT D ^LRCAPPNP
END0    Q:$G(LRDBUG)
        K I,LRAA,LRCC,LRCDT,LRLD,LRIN,LRINS,LRNT,LROA,LRSN,LRPWT,NODE,X,LREND,LRWRKL,SDC,SDIV,SDATE,SDCTYPE,SDMSG,LRSPWT,LOC,LCWT,LSPWT,LRO,LRSDTC,LSPWT,LRSDC
        K LRVSIT,EDATE,^TMP("LRPXAPI",$J),LRPCEON,DFN,LRCE,LRCSQ,SDUZ,EDATE
        K LRCEX,LRCEXV,CPT,LRNINS,LRCDT,LREDT,LRCNT,LRI,LRICPT,LRINA,LRNLT,LRPKG
        K LRREL,LRSN,LRSTP,LRTST,LRTSTP,LRVSIT,NODE,LRPRO
        K LRDLOC,LRDSSLOC,LRNOP,SDERR,PXKDONE,VSIT,DIC,LRCSC,LRDFN
        K LRDPRAC,LROK,LRXCPT
        K ^TMP("LRMOD",$J)
        I $D(XRT0) S XRTN="END^LRCAPPH" D T1^%ZOSV
        S $P(^LAB(69.9,1,"NITE"),U,2)="" L -^LRO("LRCAPPH","NITE")
        Q
LOOK    ;From LRCAPPNP
        N LRDUZ
        Q:'$D(^LRO(69,LRCDT,1,LRSN,0))#2  S NODE=^(0)
        S LRDFN=+NODE Q:'$D(^LR(LRDFN,0))#2  S LRDPF=+$P(^(0),U,2),DFN=+$P(^(0),U,3)
        Q:'DFN!(LRDPF'=2)
        S LRDUZ=$S($P(NODE,U,2):$P(NODE,U,2),1:DUZ)
        S LRCC=$S(($P(NODE,U,4)="LC"!($P(NODE,U,4)="I")):LR658,$P(NODE,U,4)="SP":LR657,1:0)
        Q:'$D(^LRO(69,LRCDT,1,LRSN,1))#2  S NODE(1)=^(1) Q:$P(NODE(1),U,4)'="C"  S LRNT=+NODE(1),LRIN=$S($P(NODE(1),U,8):$P(NODE(1),U,8),1:LRINS),LRCE=+$G(^(.1))
        I $G(LRNP) S LRNOPX=1 Q
        D:LRCSC EN3 I 'LRWRKL S:'$G(LRDBUG) $P(^LRO(69,LRCDT,1,LRSN,0),U,10)=1,LRCEXV=$G(LRCEX) Q
        Q:$G(^LRO(69,"AA",LRCEX,LROA))
PHLE    I $G(LRCC),LRCEX'=$G(LRCEXV) D
        . S LREDT=$P($G(^LRO(69,LRCDT,1,LRSN,3)),U) Q:'LREDT
        . S LRCDTSAV=LRCDT
        . N LRCDT,LRIN,DIC,X,Y
        . S X="`"_$P(NODE,U,9),DIC="^SC(",DIC(0)="NZ" D ^DIC
        . Q:Y<1
        . S:Y>0 LROL=+Y,LRIN=$P(Y(0),U,4),LRRRL2=$P(Y(0),U,20),LRRRL4=$P(Y(0),U,3)
        . S:'LRIN LRIN=LRINS
        . S LRCDT=$P(LREDT,".")
        . D:'$D(^LRO(64.1,LRIN,1,LRCDT,1,LRCC,1,0))#2 BLDIN^LRCAPV3
        . D
        . . S LRTST=0 F  S LRTST=$O(^LRO(69,LRCDTSAV,1,LRSN,2,LRTST)) Q:LRTST<1  Q:'$P(^(LRTST,0),U,11)
        . . Q:'LRTST  S LREN5=^LRO(69,LRCDTSAV,1,LRSN,2,LRTST,0)
        . . S LRAA=$S($G(^LAB(69.9,1,14,LRIN,20)):+^(20),1:LRDAA)
        . . S LRCTM=$P(LREDT,".",2)
        . . S LRTS=+LREN5,LRCNT=1,LRLD="CP"
        . . S (LRMA,LRLSS,LRWA)=LRAA
        . . S LRACC=$P($G(^LRO(68,+$P(LREN5,U,4),1,+$P(LREN5,U,3),1,+$P(LREN5,U,5),.2)),U)
        . . S LRFILE=+DFN_";DPT(",LROAD=$P(LREN5,U,3)
        . . S LROAD1=$P(NODE,U,5),LROAD2=LRSN
        . . S:'$G(LRSPEC) LRSPEC=$P($G(^LAB(69.9,1,1)),U)
        . . S LRRRL=$P(NODE,U,7)
        . . S LRRRL1=$P(NODE,U,6)
        . . S LRRRL3=$P(NODE,U,2)
        . . S LRIDT="",LRUG=$P(LREN5,U,2)
        . . S LRTEC=$P(NODE,U,2)
        . . D STORE^LRCAPV3
        . . K LRCDTSAV
        . S LRCEXV=LRCEX
        S:'$G(LRDBUG) $P(^LRO(69,LRCDT,1,LRSN,0),U,10)=1 Q
        Q
EN3     ;Called from LRCAPPH
        Q:'$G(LRVSIT)  I $G(LRPCEON) D:$G(LRPKG) EN3^LRCAPPH1
        Q  ; EN3^SDACS is no longer supported
        Q:$G(LRVSIT)=1
        K SDERR D
        . S LOC=$G(^SC(+$P(NODE,U,9),0))
        . I $L(LOC),"CMZ"[$P(LOC,U,3) D
        .. S SDC=LRSDC,SDMSG=$S('$D(ZTQUEUED):"S",1:0),SDCTYPE="S"
        .. S SDIV=LRIN,SDATE=LRNT,SDUZ=$P(NODE,U,2) D:SDUZ EN3^SDACS
        Q
XTMP    ;Clean up XTMP("LRCAP" global
        ; Called from LRNIGHT
        S LRCSQ="" F  S LRCSQ=$O(^XTMP("LRCAP",LRCSQ)) Q:LRCSQ=""  D
        . S LRDUZ=0 F  S LRDUZ=$O(^XTMP("LRCAP",LRCSQ,LRDUZ)) Q:LRDUZ<1  D QC K ^XTMP("LRCAP",LRCSQ)
        K LRDUZ
        Q
QC      ;
        I $D(ZTQUEUED) S ZTREQ="@"
        L +^XTMP("LRCAP",LRCSQ,LRDUZ):1 Q:'$T
        S NODE=$G(^XTMP("LRCAP",LRCSQ,LRDUZ)) G:'$L(NODE) QUIT
        S LRSTDC=+NODE,LRCQC=+$P(NODE,U,2),LRREPC=+$P(NODE,U,3),LRCDT=DT,LRIN=$S($G(DUZ(2)):DUZ(2),1:$$INSN^LRU)
        S LRCC=0 F  S LRCC=$O(^XTMP("LRCAP",LRCSQ,LRDUZ,LRCC)) Q:'LRCC  I $D(^LAM(LRCC,0)) S LRWT=$P(^(0),U,3) D BLDIN^LRCAPV3 S:'$D(^LRO(64.1,LRIN,1,LRCDT,1,LRCC,0)) ^(0)=LRCC_U_LRWT D SET1 L
QUIT    K ^XTMP("LRCAP",LRCSQ,LRDUZ),NODE,LRSTDC,LRCQC,LRREPC,LRCC,LRWT,LRCSC,LRPKG
        K ^TMP("LRPXAPI",$J),^TMP("LRMOD",$J)
        L -^XTMP("LRCAP",LRCSQ,LRDUZ) Q
SET1    F  L +^LRO(64.1,LRIN,1,LRCDT,1,LRCC,"S"):10 Q:$T
        G:'$D(LRSTDC)!('$D(LRCQC))!('$D(LRREPC)) SET2
        I '$D(^LRO(64.1,LRIN,1,LRCDT,1,LRCC,"S")) S ^("S")=LRSTDC_U_LRCQC_U_LRREPC_U G SET2
        S NODE=$G(^LRO(64.1,LRIN,1,LRCDT,1,LRCC,"S")) I LRSTDC S $P(NODE,U)=$P(NODE,U)+LRSTDC
        I LRREPC S $P(NODE,U,3)=$P(NODE,U,3)+LRREPC
        I LRCQC S $P(NODE,U,2)=$P(NODE,U,2)+LRCQC
        S ^LRO(64.1,LRIN,1,LRCDT,1,LRCC,"S")=NODE
SET2    L -^LRO(64.1,LRIN,1,LRCDT,1,LRCC,"S")
        Q
