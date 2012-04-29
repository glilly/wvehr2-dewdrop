ECXSCLD ;BIR/DMA,CML-Enter, Print and Edit Entries in 728.44 ; 10/10/08 2:39pm
        ;;3.0;DSS EXTRACTS;**2,8,24,30,71,80,105,112**;Dec 22, 1997;Build 26
EN      ;entry point from option
        ;load entries
        W !!,"This option creates local entries in the DSS CLINIC AND STOP CODES file.",!
        I '$D(^ECX(728.44)) W !,"DSS Clinic stop code file does not exist",!! R X:5 K X Q
        K ZTSAVE S ZTDESC="Gather Clinic stop codes for DSS",ZTRTN="START^ECXSCLD",ZTIO="" D ^%ZTLOAD
        Q
START   ; entry point
        S EC=0,ECNT=0 F  S EC=$O(^SC(EC)) Q:'EC  I $D(^(EC,0)) S ECD=^(0),DAT=$G(^("I")) I $P(ECD,U,3)="C" D FIX
        K DIK S DIK="^ECX(728.44,",DIK(1)=".01^B" D ENALL^DIK
        ;S $P(^ECX(728.44,0),U,3,4)=ECL_U_ECNT
        K ZTDESC,EC,J,ECD,ECD2,ECL,ECS,ECS2,ECP
        S ZTREQ="@" Q
        ;
FIX     ; get stop codes and default style for feeder key
        ; 1 if no credit stop code - 5 if credit stop code exists
        K ECD2,ECS2 I $D(^ECX(728.44,EC,0)) S ECD2=^(0) F ECS=2,3 S ECS2(ECS)=$P(ECD2,U,ECS)
        S ID=+DAT,RD=$P(DAT,U,2)
        I $D(ECD2) D
        .I ID,ID'>DT I 'RD!(RD>DT) S:$P(ECD2,U,10)'=ID $P(ECD2,U,7)="" S $P(ECD2,U,10)=ID
        .I ID,RD,RD'>DT S:$P(ECD2,U,10) $P(ECD2,U,7)="" S $P(ECD2,U,10)=""
        .I ID,ID>DT S:$P(ECD2,U,10) $P(ECD2,U,7)="" S $P(ECD2,U,10)=""
        .I 'ID,$P(ECD2,U,10) S $P(ECD2,U,7)="",$P(ECD2,U,10)=""
        F ECS=7,18 S ECP=+$P(ECD,U,ECS),ECS(ECS)=$P($G(^DIC(40.7,ECP,0)),U,2)
        S ECDF=$S(ECS(18)]"":5,1:1) S:$P(ECD,U,17)="Y" ECDF=6 S:$G(^SC(EC,"OOS")) ECDF=6
        S ECL=EC,ECD=EC_U_ECS(7)_U_ECS(18)
        I '$D(ECD2) D
        .S $P(^ECX(728.44,EC,0),U,1,5)=ECD_U_ECS(7)_U_ECS(18),ECNT=ECNT+1,$P(^(0),U,6)=ECDF
        I $D(ECD2) D
        .S $P(ECD2,U,1,3)=ECD
        .I +ECS(7)'=+ECS2(2)!(+ECS(18)'=+ECS2(3)) S $P(ECD2,U,7)=""
        .S ^ECX(728.44,EC,0)=ECD2
        Q
        ;
PRINT   ; print worksheet for updates
        I '$O(^ECX(728.44,0)) W !,"DSS Clinic stop code file does not exist",!! R X:5 K X Q
        W !!,"This option produces a worksheet of (A) All Clinics, (C) Active, (I) Inactive, "
        W !,"or only the (U) Unreviewed Clinics that are awaiting"
        W !,"approval.  Clinics that were defined as ""inactive"" by MAS the last time"
        W !,"the option ""Create DSS Clinic Stop Code File"" was run will be indicated",!,"with an ""*"".",!
        S DIR(0)="S^A:ALL CLINICS;C:ALL ACTIVE CLINICS;I:ALL INACTIVE CLINICS;U:UNREVIEWED CLINICS",DIR("A")="Enter ""A"", ""C"", ""I"", or ""U"""
        S DIR("?",1)="Enter: ""C"" to print a worksheet of all active DSS Clinic Stops,"
        S DIR("?",2)="Enter: ""I"" to print a worksheet of all inactive DSS Clinic  Stops,"
        S DIR("?",3)="Enter: ""A"" to print a worksheet of all DSS Clinic  Stops,"
        S DIR("?")="       ""U"" to print only the Clinic Stops that have not been approved."
        D ^DIR K DIR G END:$D(DIRUT) S ECALL=$E(Y)
        S %ZIS="Q" D ^%ZIS Q:POP
        I $D(IO("Q")) K ZTSAVE S ZTDESC="DSS clinic stop code work sheet",ZTRTN="SPRINT^ECXSCLD",ZTSAVE("ECALL")="" D ^%ZTLOAD,HOME^%ZIS Q
        U IO
SPRINT  ; queued entry to print work sheet
        S QFLG=0,$P(LN,"-",81)="",PG=0
        S ECDATE=$O(^ECX(728.44,"A1","")) I ECDATE S ECDATE=-ECDATE,ECDATE=$$FMTE^XLFDT(ECDATE,"5DF"),ECDATE=$TR(ECDATE," ","0")
        K ^TMP("EC",$J)
        F J=0:0 S J=$O(^ECX(728.44,J)) Q:'J  I $D(^ECX(728.44,J,0)) S ECSD=^(0) D
        . I ECALL="A" I $D(^SC(J,0)) S ECSC=$P(^(0),U),^TMP("EC",$J,ECSC)=$P(ECSD,U,2,200)
        . I (ECALL="I"),($P(ECSD,U,10)) I $D(^SC(J,0)) S ECSC=$P(^(0),U),^TMP("EC",$J,ECSC)=$P(ECSD,U,2,200)
        . I ((ECALL="C")&($P(ECSD,U,10)=""))!((ECALL="C")&($P(ECSD,U,10)>DT)) I $D(^SC(J,0)) S ECSC=$P(^(0),U),^TMP("EC",$J,ECSC)=$P(ECSD,U,2,200)
        . I (ECALL="U"),($P(ECSD,U,7)="") I $D(^SC(J,0)) S ECSC=$P(^(0),U),^TMP("EC",$J,ECSC)=$P(ECSD,U,2,200)
        D HEAD S ECSC="" I $O(^TMP("EC",$J,ECSC))="" W !!,"NO DATA FOUND FOR WORKSHEET.",! G END
        F J=1:1 S ECSC=$O(^TMP("EC",$J,ECSC)) Q:ECSC=""  S ECD=^(ECSC) D SHOWEM Q:QFLG
        I $E(IOST)="C",'QFLG D SS
        K ^TMP("EC",$J),J,ECSC,ECSD,ECDATE,QFLG,PG,LN,SS
        W:$Y @IOF D ^%ZISC S ZTREQ="@"
        Q
        ;
HEAD    ; header for worksheet
        D SS Q:QFLG
        S PG=PG+1 W:$Y!($E(IOST)="C") @IOF W !,"WORKSHEET FOR DSS CLINIC STOPS",?71,"Page: ",PG
        I ECDATE]"" W !,"(last reviewed on ",ECDATE,")"
        E  W !,"(NEVER REVIEWED)"
        W !
        W !!,?1,"CLINIC",?31,"STOP",?38,"CREDIT",?47,"DSS",?54,"DSS",?63,"ACTION",?71,"NAT'L"
        W !,?31,"CODE",?38,"STOP",?47,"STOP",?54,"CREDIT",?71,"CODE",!,?1,"(* - currently inactive)",?38,"CODE",?47,"CODE",?54,"CODE",!,LN Q
        ;
SHOWEM  ; list clinics for worksheet
        I $Y+4>IOSL D HEAD Q:QFLG
        W !!,$E(ECSC,1,31) W:$P(ECD,U,9)]"" "*" F J=1:1:5 W ?$P("31,38,47,54,66",",",J),$S($P(ECD,U,J):$P(ECD,U,J),J<3:"",1:"_____")
        S ECN=$P($G(^ECX(728.441,+$P(ECD,U,7),0)),U) W ?71,$S(ECN]"":ECN,1:"____")
        Q
SS      ;SCROLL STOPS
        I $E(IOST)="C" S SS=22-$Y F JJ=1:1:SS W !
        I $E(IOST)="C",PG>0 S DIR(0)="E" W ! D ^DIR K DIR I 'Y S QFLG=1 Q
        Q
        ;
EDIT    ; put in DSS stopcodes and which one to send
        I '$O(^ECX(728.44,0)) W !,"DSS Clinic stop code file does not exist",!! R X:5 K X Q
        W ! S DIC=728.44,DIC(0)="QEAMZ" D ^DIC G END:Y<0 W !,"STOP CODE : ",$P(Y(0),U,2),!,"CREDIT STOP CODE : ",$P(Y(0),U,3)
        S DIE=728.44,DA=+Y,DR="3;4;5//1;S:X'=4 Y=6;7;6///"_DT_";8" D ^DIE S:$P(^ECX(728.44,DA,0),U,6)'=4 $P(^(0),U,8)="" S $P(^(0),U,7)="" K DIC,DIE,DA,ERR G EDIT
        ;
APPROVE ; approve current DSS Stop and Credit Stop codes
        W !!,"This option allows you to mark the current clinic entries in the CLINICS AND",!,"STOP CODES file (#728.44) as ""reviewed"".  Those entries will then be omitted"
        W !,"from the list printed from the ""Clinic and DSS Stop Codes Print"" when you",!,"choose to print only ""unreviewed"" clinics.",!
        K DIR S DIR(0)="Y",DIR("A",1)="Are you ready to approve the reviewed information provided by the",DIR("A")="""Clinic and DSS Stop Codes Print""",DIR("B")="NO"
        S DIR("?",1)="   Enter:"
        S DIR("?",2)="     ""YES"" if you concur with the ""Clinic and DSS Stop Codes Print"","
        S DIR("?",3)="     ""NO"" or <RET> if you do not want to approve the current information,"
        S DIR("?")="     ""^"" to exit option."
        D ^DIR K DIR I 'Y!($D(DIRUT)) G END
        W ! S ZTRTN="APPLOOP^ECXSCLD",ZTIO="",ZTDESC="Approve DSS stop codes for clinic extract" D ^%ZTLOAD W !!,"...approval queued" G END
        ;
APPLOOP ; queued entry to approve action codes
        F EC=0:0 S EC=$O(^ECX(728.44,EC)) Q:'EC  I $D(^(EC,0)) S DA=EC,DIE="^ECX(728.44,",DR="6///"_DT D ^DIE
        S ZTREQ="@" G END
END     K X,Y,DA,DR,DIC,DIE,QFLG,PG,LN
        Q
        ;
LOOK    ;queued entry to check for new clinics
        S ECD=$E(DT,1,5)-1-($E(DT,4,5)="01"*8800),ECD0=ECD_"00",ECXMISS=10,ECGRP="SCX" K ^TMP("ECXS",$J)
        F EC=0:0 S EC=$O(^SC(EC)) Q:'EC  I $D(^(EC,0)),$P(^(0),U,3)="C",'$D(^ECX(728.44,EC)) S DAT=$G(^SC(EC,"I")) D
        .S ID=+DAT,RD=$P(DAT,U,2) I ID,ID<DT I 'RD!(RD>DT) Q
        .S ^TMP("ECXS",$J,ECXMISS,0)=$J(EC,6)_"    "_$$LJ^XLFSTR($P(^SC(EC,0),U),40),ECXMISS=ECXMISS+1
        D ^ECXSCX1
        Q
