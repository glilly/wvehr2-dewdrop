SDRRCRR1        ;10N20/MAH;Recall Reminder list report; 11/8/2006
        ;;5.3;Scheduling;**536**;Aug 13, 1993;Build 53
EN2     ;BY Teams SELECTED Team
        G:'$D(SDT) QUIT
        N VAUTSTR,VAUTVB
        S DIC="^SD(403.55,",VAUTVB="VAUTT",VAUTSTR="Team",VAUTNI="1"
        S DIC(0)="EQMNZ",DIC("A")="Select "_VAUTSTR_": " K @VAUTVB S (@VAUTVB,Y)=0
REDO1   N VAERR,VAI,VAUTNALL,VAUTX
        W !,DIC("A") W:'$D(VAUTNALL) "ALL// " R X:DTIME G QUIT:(X="^")!'$T D:X["?" QQQ I X="" G:$D(VAUTNALL) QUIT S @VAUTVB=1 G TEAM
        S DIC("A")="Select another "_VAUTSTR_": " D ^DIC G:Y'>0 REDO1 D SET
        F VAI=1:0:19 W !,DIC("A") R X:DTIME G QUIT:(X="^")!'$T K Y Q:X=""  D QQQ:X["?" S:$E(X)="-" VAUTX=X,X=$E(VAUTX,2,999) D ^DIC I Y>0 D SET G:VAX REDO1 S:'VAERR VAI=VAI+1
TEAM    ;
        I VAUTT=1 G ENTEAM
        I VAUTT=0 G ONTEAM
        Q
QQQ     W !!,"Please select up to 20 Team that you would like to print" Q
ENTEAM   W !!,"***This report requires 132 columns",!! S %ZIS="QM" D ^%ZIS G:POP QUIT
        I $D(IO("Q")) S ZTIO=ION,ZTDESC="Print Recall List for Clinics",ZTRTN="ENTEAM1^SDRRCRR1" S ZTSAVE("*")="" D ^%ZTLOAD G QUIT
ENTEAM1 ;ALL TEAMS
        K ^TMP($J,"ENTEAM")
        S (PRO,RDT,CDT,CDT1,PAT,PHONE,CLINIC,COMMENT,DIV,DIV1,TEST)=""
        S ZPR=0 F  S ZPR=$O(^SD(403.5,"C",ZPR)) Q:ZPR=""  S D0=0 F  S D0=$O(^SD(403.5,"C",ZPR,D0)) Q:D0=""  S DTA=$G(^SD(403.5,D0,0)) D:DTA]""
        .S TEST=$P($G(^SD(403.5,D0,0)),U,5) S DIV=$P($G(^SD(403.54,TEST,0)),U,2)
        .I DIV'="" S DIV1=$P($G(^SD(403.55,DIV,0)),"^",1)
        .I DIV1="" S DIV1="Unknown"
        .S RDT=$P($G(DTA),"^",6) Q:RDT=""
        .Q:RDT<SDT!(RDT>EDT)
        .S MONTH=$E(RDT,4,5),YR=$E(RDT,2,3)
        .S CLINIC=$P($G(DTA),"^",2),DIV=CLINIC I CLINIC'="" S CLINIC=$$GET1^DIQ(44,CLINIC_",",.01)
        .I CLINIC="" S CLINIC="Unknown Clinic"  ;CLINIC
        .S Y=RDT D DD^%DT S DATE=Y K Y  ;RECALL DATE
        .S PAT=$P($G(DTA),"^",1)
        .Q:$$TESTPAT^VADPT(PAT)
        .S DFN=PAT
        .D ADD^VADPT,DEM^VADPT
        .S LN=$E(VADM(1),1)_$P(VA("BID"),U)
        .S PAT1=$P(VADM(1),U)
        .S (CDT,CDT1)="",Y=$P($G(DTA),"^",10) I Y'="" D DD^%DT S CDT=Y K Y
        .S Z=$P($G(DTA),"^",13) I Z'="" S CDT1="*"_CDT K Z D
        ..I CDT1'="" S CDT=CDT1
        .I CDT="" S CDT="NotSent"
        .S PHONE=$P(VAPA(8),U)
        .I PHONE="" S PHONE="Unk. Phone"  ;phone
        .S COMMENT=$P($G(DTA),"^",7)
        .S PRO=$P($G(DTA),"^",5) I PRO'="" S PRO1=$P($G(^SD(403.54,PRO,0)),"^",1),PRO2=$$NAME^XUSER(PRO1,"F")
        .I PRO="" S PRO2="Unk. Provider"
        .S USER=$P($G(DTA),"^",11) I USER'="" S USER1=$$NAME^XUSER(USER)
        .I USER="" S USER1="Unk. User"
        .S ^TMP($J,"ENTEAM",DIV1,CLINIC,PRO2,MONTH,RDT,PAT1)=CLINIC_"^"_PRO2_"^"_DATE_"^"_CDT_"^"_PAT1_"^"_PHONE_"^"_COMMENT_"^"_USER1_"^"_LN
        .K CLINIC,USER,PRO,PAT,RDT,CDT,CDT1
        D PRT4^SDRRCRRP
        D ^%ZISC
        G QUIT
        ;THIS PART OF THE TEAMS IS OK
ONTEAM   W !!,"***This report requires 132 columns",!! S %ZIS="QM" D ^%ZIS G:POP QUIT
        I $D(IO("Q")) S ZTIO=ION,ZTDESC="Print Recall List for Clinics",ZTRTN="ONTEAM1^SDRRCRR1" S ZTSAVE("*")="" D ^%ZTLOAD G QUIT
ONTEAM1 ;SELECTED TEAMS
        K ^TMP($J,"ONTEAM")
        S (PRO,RDT,CDT,CDT1,PAT,PHONE,CLINIC,COMMENT,DIV,DIV1,TEST)=""
        S TM=0
        F  S TM=$O(VAUTT(TM)) Q:TM=""  S TEAM=$P(VAUTT(TM),"^",1) D
        .S ZPR=0 F  S ZPR=$O(^SD(403.5,"C",ZPR)) Q:ZPR=""  S D0=0 F  S D0=$O(^SD(403.5,"C",ZPR,D0)) Q:D0=""  S DTA=$G(^SD(403.5,D0,0)) D:DTA]""
        ..S TEST=$P($G(^SD(403.5,D0,0)),U,5) S DIV=$P($G(^SD(403.54,TEST,0)),U,2)
        ..Q:DIV'=TEAM
        ..I DIV'="" S DIV1=$P($G(^SD(403.55,DIV,0)),"^",1)
        ..I DIV1="" S DIV1="Unknown"
        ..S RDT=$P($G(DTA),"^",6) Q:RDT=""
        ..Q:RDT<SDT!(RDT>EDT)
        ..S MONTH=$E(RDT,4,5),YR=$E(RDT,2,3)
        ..S CLINIC=$P($G(DTA),"^",2),DIV=CLINIC I CLINIC'="" S CLINIC=$$GET1^DIQ(44,CLINIC_",",.01)
        ..I CLINIC="" S CLINIC="Unknown Clinic"  ;CLINIC
        ..S Y=RDT D DD^%DT S DATE=Y K Y  ;RECALL DATE
        ..S PAT=$P($G(DTA),"^",1)
        ..Q:$$TESTPAT^VADPT(PAT)
        ..S DFN=PAT
        ..D ADD^VADPT,DEM^VADPT
        ..S LN=$E(VADM(1),1)_$P(VA("BID"),U)
        ..S PAT1=$P(VADM(1),U)
        ..S (CDT,CDT1)="",Y=$P($G(DTA),"^",10) I Y'="" D DD^%DT S CDT=Y K Y
        ..S Z=$P($G(DTA),"^",13) I Z'="" S CDT1="*"_CDT K Z D
        ...I CDT1'="" S CDT=CDT1
        ..I CDT="" S CDT="NotSent"
        ..S PHONE=$P(VAPA(8),U)
        ..I PHONE="" S PHONE="Unk. Phone"  ;phone
        ..S COMMENT=$P($G(DTA),"^",7)
        ..S PRO=$P($G(DTA),"^",5) I PRO'="" S PRO1=$P($G(^SD(403.54,PRO,0)),"^",1),PRO2=$$NAME^XUSER(PRO1,"F")
        ..I PRO="" S PRO2="Unk. Provider"
        ..S USER=$P($G(DTA),"^",11) I USER'="" S USER1=$$NAME^XUSER(USER)
        ..I USER="" S USER1="Unk. User"
        ..S ^TMP($J,"ONTEAM",DIV1,CLINIC,PRO2,MONTH,RDT,PAT1)=CLINIC_"^"_PRO2_"^"_DATE_"^"_CDT_"^"_PAT1_"^"_PHONE_"^"_COMMENT_"^"_USER1_"^"_LN
        ..K CLINIC,USER,PRO,PAT,RDT,CDT,CDT1
        D PRT5^SDRRCRRP
        D ^%ZISC
        G QUIT
        ;BY CLINICS WORK FINE
SET     S VAX=0 I $D(VAUTX) S J=$S(VAUTNI=2:+Y,1:$P(Y(0),"^")) K VAUTX S VAERR=$S($D(@VAUTVB@(J)):0,1:1) W $S('VAERR:"...removed from list...",1:"...not on list...can't remove") Q:VAERR  S VAI=VAI-1 K @VAUTVB@(J) S:$O(@VAUTVB@(0))']"" VAX=1 Q
        S VAERR=0 I $S($D(@VAUTVB@($P(Y(0),U))):1,$D(@VAUTVB@(+Y)):1,1:0) W !?3,*7,"You have already selected that ",VAUTSTR,".  Try again." S VAERR=1
        I VAUTNI=1 S @VAUTVB@($P(Y(0),U))=+Y Q
        I VAUTNI=3 S @VAUTVB@($P(Y(0,0),U))=+Y Q
        S @VAUTVB@(+Y)=$P(Y(0),U) Q
QUIT    K DIR,Y,SDT,EDT,COMMENT,D0,DATE,DIC,DIV,DIV1,DTA,I,J,LN,MONTH,PAT1,PHONE,POP,PRO1,PRO2,SSN,TEAM,TEST,TM,USER1,X,YR,ZPR
        K ZTDESC,ZTIO,ZTRTN,ZTSAVE,%DT,%ZIS,%,VAUTC,VAUTD,VA,VAUTNI,VAUTT,DFN,VAX,VAERR,VADM,VAPA
        D KVAR^VADPT
        Q
