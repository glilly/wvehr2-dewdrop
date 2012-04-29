MDSTUDL ; HOIFO/NCA - Clinical Procedures Studies List ;10/26/05  11:46
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ; Integration Agreements:
        ; IA# 3468 [Subscription] Use GMRCCP APIs.
        ; IA# 2263 [Supported] XPAR calls
        ; IA# 10103 [Supported] XLFDT calls
        ; IA# 10061 [Supported] VADPT calls
        ; IA# 10062 [Supported] VADPT6 calls
        ; IA# 4869 [Private] ^DIC(45.7,
        ;
EN2     ; Print the Clinical Procedures Studies List
        N DIC,X,Y,DTOUT,DUOUT
S1      R !!,"Select Facility Treating Specialty (or ALL): ",X:DTIME Q:'$T!("^"[X)  S:X="all" X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ") I X="ALL" S MDSPEC=0
        E  K DIC S DIC="^DIC(45.7,",DIC(0)="EMQ" D ^DIC G:Y<1!($D(DTOUT))!($D(DUOUT)) S1 S MDSPEC=+Y K DIC W !
        W !!,"The report requires a 132 column printer."
        W ! K IOP S %ZIS="MQ",%ZIS("A")="Select LIST Printer: " W ! D ^%ZIS K %ZIS,IOP Q:POP
        I $D(IO("Q")) D QUE Q
        U IO D GETTRAN D ^%ZISC K %ZIS,IOP Q
QUE     ; Queue List
        K IO("Q"),ZTUCI,ZTDTH,ZTIO,ZTSAVE,ZTDESC,ZTSK S ZTRTN="GETTRAN^MDSTUDL",ZTREQ="@",ZTSAVE("ZTREQ")="",ZTSAVE("MDSPEC")=""
        S:$D(XQY0) ZTDESC=$P(XQY0,"^",1)
        D ^%ZTLOAD D ^%ZISC U IO W !,"Request Queued",! K ZTSK Q
GETTRAN ; [Procedure] Get a patients transactions
        K ^TMP("MDSTUDL",$J),^TMP("MDINST",$J)
        N BID,DFN,DTP,LN,MDCHKD,MDCHKDT,MDCOM,MDCOMP,MDDEFN,MDMULT,MDNUM,MDPNAM,MDREQ,MDREQDT,MDANOD,MDBNOD,MDCNOD,MDSP,MDTXT,MDURG,MDYR,PG,RESLT,X1,X2,X,Y0
        S RESLT=$NA(^TMP("MDCONL",$J)),LN="",$P(LN,"-",131)="",MDCOM=0
        S PG=0 N % D NOW^%DTC S DTP=%,DTP=$$FMTE^XLFDT(DTP,"1P")
        S MDNUM=$$GET^XPAR("SYS","MD DAYS TO RETAIN COM STUDY",1)
        I +MDNUM>0 S X1=DT,X2=-MDNUM D C^%DTC S MDCOM=X
        S X1=DT,X2=-365 D C^%DTC S MDYR=X
        F DFN=0:0 S DFN=$O(^MDD(702,"B",DFN)) Q:'DFN  D
        .D DEM^VADPT S MDPNAM=$G(VADM(1)) K VADM D PID^VADPT6 S BID=$G(VA("BID")) K VA
        .S MDBNOD=$S($L(MDPNAM)>24:$E(MDPNAM,1,24),1:MDPNAM)_"~"_BID
        .K @RESLT D GETCON(.RESLT,DFN)
        .F MDX=0:0 S MDX=$O(^MDD(702,"B",DFN,+MDX))_"," Q:'MDX  D
        ..S (MDANOD,MDCNOD)=""
        ..Q:'$$GET1^DIQ(702,MDX,.05,"I")
        ..Q:$G(^TMP("MDCONL",$J,+$$GET1^DIQ(702,MDX,.05,"I")))=""
        ..S MDMULT=$$GET1^DIQ(702,MDX,".04:.12","I")
        ..S MDCOMP=$S(+MDMULT<1:MDCOM,1:MDYR)
        ..I MDNUM Q:$$GET1^DIQ(702,MDX,.09,"I")=3&($$GET1^DIQ(702,MDX,.02,"I")<MDCOMP)
        ..S MDREQDT="" I +$$GET1^DIQ(702,MDX,.05,"I") S MDREQDT=$P($G(^TMP("MDCONL",$J,+$$GET1^DIQ(702,MDX,.05,"I"))),U)
        ..I MDREQDT'="" S MDREQDT=$$FMTE^XLFDT(MDREQDT,"2P")
        ..S MDURG="" I +$$GET1^DIQ(702,MDX,.05,"I") S MDURG=$P($G(^TMP("MDCONL",$J,+$$GET1^DIQ(702,MDX,.05,"I"))),U,2)
        ..S MDREQ=$$GET1^DIQ(702,MDX,.04) S:$L(MDREQ)>25 MDREQ=$E(MDREQ,1,25)
        ..S (MDCHKD,MDCHKDT)=$$GET1^DIQ(702,MDX,.02,"I"),MDCHKDT=$$FMTE^XLFDT(MDCHKDT,"2P")
        ..S Z=MDREQ_U_MDCHKDT_U_$$GET1^DIQ(702,MDX,.05,"I")_U_MDREQDT_U_$$GET1^DIQ(702,MDX,.09)_U_MDURG
        ..S MDANOD="UNASSIGNED",MDSP=+$$GET1^DIQ(702,MDX,".04:.02","I")
        ..I +MDSP Q:+MDSPEC>0&(+MDSPEC'=+MDSP)  S MDANOD=$$GET1^DIQ(702,MDX,".04:.02")
        ..S MDANOD=MDANOD_"~"_$$GET1^DIQ(702,MDX,.11)
        ..S:'$D(^TMP("MDINST",$J,MDANOD)) ^TMP("MDINST",$J,MDANOD)=+MDSP_"^"_$$GET1^DIQ(702,MDX,.11,"I")
        ..I +$$GET1^DIQ(702,MDX,.04,"I") S MDDEFN=$$GET1^DIQ(702,MDX,.04),MDCNOD=MDDEFN_"~"_MDBNOD
        ..S ^TMP("MDSTUDL",$J,+MDSP,+$$GET1^DIQ(702,MDX,.11,"I"),MDCNOD,MDCHKD)=Z
        N MDCT S MDCT=0
        N MDLOP S MDLOP="" F  S MDLOP=$O(^TMP("MDINST",$J,MDLOP)) Q:MDLOP=""   S MDSUBS=$G(^(MDLOP)) D
        .D HDR
        .S MDANOD="" F  S MDANOD=$O(^TMP("MDSTUDL",$J,+MDSUBS,+$P(MDSUBS,U,2),MDANOD)) Q:MDANOD=""  S MDBNOD="" F  S MDBNOD=$O(^TMP("MDSTUDL",$J,+MDSUBS,+$P(MDSUBS,U,2),MDANOD,MDBNOD)) Q:MDBNOD=""  D
        ..S Y0=$G(^TMP("MDSTUDL",$J,+MDSUBS,+$P(MDSUBS,U,2),MDANOD,MDBNOD))
        ..D:$Y>(IOSL-8) HDR
        ..W !,$P(MDANOD,"~",2),?25,$P(MDANOD,"~",3),?31,$P(Y0,U,3),?45,$P(Y0,U,4),?67,$S($L($P(Y0,U,6))>10:$E($P(Y0,U,6),1,10),1:$P(Y0,U,6)),?78,$P(Y0,U),?104,$E($P(Y0,U,5),1,5),?111,$P(Y0,U,2),!
        K ^TMP("MDSTUDL",$J),^TMP("MDCONL",$J),^TMP("MDINST",$J)
        Q
GETCON(RESLT,DFN)       ; Get Consult
        K ^TMP("MDTMPL",$J) N MDCDT,X1,X2,X
        S X1=DT,X2=-365 D C^%DTC S MDCDT=X
        D CPLIST^GMRCCP(DFN,,$NA(^TMP("MDTMPL",$J)))
        S MDX=0 F  S MDX=$O(^TMP("MDTMPL",$J,MDX)) Q:'MDX  D:"saprc"[$P(^(MDX),U,4)
        .I $P($G(^TMP("MDTMP",$J,MDX)),U,4)="c" Q:$P($G(^TMP("MDTMP",$J,MDX)),U,1)<MDCDT
        .S @RESLT@($P($G(^TMP("MDTMPL",$J,MDX)),U,5))=$P($G(^TMP("MDTMPL",$J,MDX)),U,1)_"^"_$P($G(^TMP("MDTMPL",$J,MDX)),U,3) Q
        K ^TMP("MDTMPL",$J)
        Q
HDR     ; List Header
        W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1
        W !,DTP,?43,"C L I N I C A L   P R O C E D U R E S   S T U D I E S   L I S T",?125,"Page ",PG,!
        S Y=$S($P(MDLOP,"~")="UNASSIGNED":"",1:$P(MDLOP,"~")) W:Y'="" !!?(131-$L(Y)\2),Y
        W !!,$P(MDLOP,"~",2) S Y="",$P(Y,"=",$L($P(MDLOP,"~",2))+1)="" W !,Y,!
        W !?47,"Reqd.",?106,"CP",?113,"Check-In",!,"Patient",?25,"ID#",?31,"Consult #",?45,"Date/Time",?67,"Urgency",?78,"Procedure",?104,"Status",?113,"Date/Time",!,LN,!
        Q
