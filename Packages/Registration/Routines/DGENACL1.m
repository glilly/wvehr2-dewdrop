DGENACL1        ;ALB/MRY - NEW ENROLLEE APPOINTMENT CALL LIST - UPDATE ;02/15/2008
        ;;5.3;Registration;**779,788**;08/13/93;Build 18
        ;
PRINT   N DGLN,PAGE,QUIT,DGTOTAL
        S QUIT=""
        U IO
        I $E(IOST,1,2)="C-" D EN^DDIOL("","","@IOF")
        S DGLN=0
        S PAGE=1
        D HEADER:'DGPFTFLG
        D DATA
        I DGLN=0 D
        . D EN^DDIOL("No data to report.","","!!!?30")
        . I $E(IOST,1,2)="C-" D PAUSE
        I ('DGPFTFLG),(DGLN>0),('QUIT) D SUMARY
        Q
        ;
HEADER  ;
        N DG1,DG2,Y
        I DGRPT=1 D
        . D EN^DDIOL("NEW ENROLLEE APPOINTMENT REQUEST CALL LIST","","!?15")
        . S Y=DT D DD^%DT D EN^DDIOL("Date: "_Y,"","?60")
        . D EN^DDIOL("Page: "_PAGE,"","!?60")
        . D:DGPFTFLG EN^DDIOL("PREFERRED FACILITY: "_DGPFTF,"","!!") D EN^DDIOL("","","!!")
        . I ($G(DGFMT1)="S") D
        . . D EN^DDIOL("1010EZ APPT.","","?30"),EN^DDIOL("REQ","","?45"),EN^DDIOL("RESIDENCE","","?52"),EN^DDIOL("CELLULAR","","?67")
        . . D EN^DDIOL("NAME(SSN)"),EN^DDIOL("REQUEST DATE","","?30"),EN^DDIOL("STA","","?45"),EN^DDIOL("PHONE","","?54"),EN^DDIOL("PHONE","","?68")
        . . D EN^DDIOL("","","!")
        I DGRPT=2 D
        . S Y=DGBEG D DD^%DT S DG1=Y
        . S Y=DGEND D DD^%DT S DG2=Y
        . D EN^DDIOL("NEW ENROLLEE APPOINTMENT REQUEST TRACKING REPORT","","!?10")
        . S Y=DT D DD^%DT D EN^DDIOL("Date: "_Y,"","?60")
        . D EN^DDIOL(DG1_" TO "_DG2,"","!?20"),EN^DDIOL("Page: "_PAGE,"","?60")
        . D:DGPFTFLG EN^DDIOL("PREFERRED FACILITY: "_DGPFTF,"","!!")
        . I ($G(DGFMT2)="D") D
        . . D EN^DDIOL("1010EZ APPT.","","!!?37"),EN^DDIOL("SCHEDULED","","?54"),EN^DDIOL("#","","?71"),EN^DDIOL("REQ","","?76")
        . . D EN^DDIOL("NAME"),EN^DDIOL("EP/CV","","?31"),EN^DDIOL("REQUEST DATE","","?37"),EN^DDIOL("APPOINTMENT DATE","","?51"),EN^DDIOL("DAYS","","?70"),EN^DDIOL("STA","","?76")
        . . D EN^DDIOL("============================"),EN^DDIOL("=====","","?31"),EN^DDIOL("============","","?37"),EN^DDIOL("==================","","?51"),EN^DDIOL("====","","?70"),EN^DDIOL("===","","?76")
        I +DGERROR D  Q
        . D EN^DDIOL($P(DGERROR,"^",2),"","!!!")
        . I $E(IOST,1,2)="C-" D PAUSE
        S PAGE=PAGE+1
        Q
DATA    ;
        N DFN,DGNAM,DGSSN,DGI,DATAEP,DGFLG,DGRDTI,DGDAYS,DFNIEN,SDADTI,SDADT,DGDAYS,DGENPRI,DGENCVEL,DATA3,DGSTA
        F DGI="C","E","F","I","NULL" S DGTOTAL(DGI)=0
        S DGPFTF=""
        F  S DGPFTF=$O(^TMP($J,"DGEN NEACL",DGPFTF)) Q:(DGPFTF="")  D  Q:QUIT
        . I DGPFTFLG F DGI="C","E","F","I","NULL" S DGTOTAL(DGI)=0
        . D TOP:((DGPFTFLG)&(PAGE>1)) D HEADER:((DGPFTFLG)&(PAGE=1))
        . S DGI=0
        . F  S DGI=$O(^TMP($J,"DGEN NEACL",DGPFTF,DGI)) Q:(DGI="")  D  Q:QUIT
        .. S DGRDTI=0 F  S DGRDTI=$O(^TMP($J,"DGEN NEACL",DGPFTF,DGI,DGRDTI)) Q:'DGRDTI  D  Q:QUIT
        ... S DGNAM="" F  S DGNAM=$O(^TMP($J,"DGEN NEACL",DGPFTF,DGI,DGRDTI,DGNAM)) Q:DGNAM=""  D  Q:QUIT
        .... S DFNIEN="" F  S DFNIEN=$O(^TMP($J,"DGEN NEACL",DGPFTF,DGI,DGRDTI,DGNAM,DFNIEN)) Q:DFNIEN=""  D  Q:QUIT
        ..... S SDADTI=$G(^TMP($J,"DGEN NEACL",DGPFTF,DGI,DGRDTI,DGNAM,DFNIEN))
        ..... S DGSTA=$$GET1^DIQ(2,DFNIEN,1010.161,"I") I DGSTA="" S DGSTA="NULL"
        ..... I DGSTA="C" S SDADTI=$$GET1^DIQ(2,DFNIEN,1010.162,"I")
        ..... S DGDAYS=$$DAYS(SDADTI,DGRDTI) S Y=SDADTI X ^DD("DD") S SDADT=Y
        ..... S DGFLG=0 I 'SDADTI S DGFLG=1
        ..... S DATAEP=$G(^TMP($J,"DGEN NEACL",DGPFTF,DGI,DGRDTI,DGNAM,DFNIEN,"PRIORITY"))
        ..... S DGENPRI=$P(DATAEP,"^",3),DGENCVEL=$P(DATAEP,"^",4)
        ..... S DATA3="/" S:+DGENPRI $P(DATA3,"/")=$E("  ",$L(+DGENPRI)+1,2)_+DGENPRI S:DGENCVEL $P(DATA3,"/",2)="EL" I DATA3="/" S DATA3=""
        ..... S DGTOTAL(DGSTA)=DGTOTAL(DGSTA)+1
        ..... D ADD I '(QUIT) D LINE
        . I DGPFTFLG D SUMARY I $E(IOST,1,2)="C-" D PAUSE
        Q
PAUSE   ;
        N DIR,DIRUT,X,Y
        F  Q:$Y>(IOSL-3)  W !
        S DIR(0)="E"
        D ^DIR
        I ('(+Y))!($D(DIRUT)) S QUIT=1
        Q
TOP     ;
        D EN^DDIOL("","","@IOF")
        D HEADER
        Q
ADD     ;
        I $E(IOST,1,2)="C-",($Y>(IOSL-3)) D
        . D PAUSE
        . Q:QUIT
        . D TOP
        I $E(IOST,1,2)'="C-",($Y>(IOSL-3)) D TOP
        Q
LINE    ;add a line to the report
        N DGNAMX,DPTDFN,DGCMT
        I DGRPT=2 S DGNAMX=$P(DGNAM,",")
        E  S DGNAMX=DGNAM
        S DGNAMX=DGNAMX_"("_$E($$GET1^DIQ(2,DFNIEN,.09),6,9)_")"
        I DGRPT=1,($G(DGFMT1)="D") D
        . D EN^DDIOL(DGNAMX,"","!") D ADD Q:QUIT
        . S (Y,DPTDFN)=DFNIEN
        . I $$TESTPAT^VADPT(+Y) D EN^DDIOL("WARNING : You have selected a test patient."),ADD Q:QUIT
        . I $$BADADR^DGUTL3(+Y) D EN^DDIOL("WARNING : ** This patient has been flagged with a Bad Address Indicator."),ADD Q:QUIT
        . I $D(^DPT("AXFFP",1,+Y)) S DGCLIST=1 D FFP^DPTLK5 K DGCLIST D ADD Q:QUIT
        . D ENR^DPTLK,ADD Q:QUIT
        . D CV^DPTLK,ADD Q:QUIT
        . D EN^DDIOL("1010EZ APPT. REQUEST DATE: ") D EN^DDIOL($$GET1^DIQ(2,DFNIEN,1010.1511),"","?28") D ADD Q:QUIT
        . D EN^DDIOL("REQUEST STATUS: ") D EN^DDIOL($$GET1^DIQ(2,DFNIEN,1010.161),"","?18") D ADD Q:QUIT
        . D EN^DDIOL("COMMENT: "_$$GET1^DIQ(2,DFNIEN,1010.163)) D ADD Q:QUIT
        . D EN^DDIOL("PHONE [RESIDENCE]: "_$$GET1^DIQ(2,DFNIEN,.131))
        . D EN^DDIOL("PHONE [CELLULAR]: "_$$GET1^DIQ(2,DFNIEN,.134),"","?44") D ADD Q:QUIT
        . D EN^DDIOL("PREFERRED FACILITY: "_DGPFTF) D ADD Q:QUIT
        . ;D EN^DDIOL("PREFERRED FACILITY: "_$$GET1^DIQ(2,DFNIEN,27.02)) D ADD Q:QUIT
        . D EN^DDIOL("---------------------------------------------------------------","","!?4") D ADD Q:QUIT
        I DGRPT=1,($G(DGFMT1)="S") D  Q:QUIT
        . D EN^DDIOL(DGNAMX) I $L(DGNAMX)>29 D EN^DDIOL("","","!") D ADD Q:QUIT
        . D EN^DDIOL($$GET1^DIQ(2,DFNIEN,1010.1511),"","?30")
        . D EN^DDIOL($$GET1^DIQ(2,DFNIEN,1010.161,"I"),"","?46")
        . D EN^DDIOL($$GET1^DIQ(2,DFNIEN,.131),"","?51")
        . D EN^DDIOL($$GET1^DIQ(2,DFNIEN,.134),"","?66")
        . D ADD Q:QUIT
        I DGRPT=2,($G(DGFMT2)="D") D
        . D EN^DDIOL(DGNAMX) I $L(DGNAMX)>29 D EN^DDIOL("","","!") D ADD Q:QUIT
        . D EN^DDIOL(DATA3,"","?31"),EN^DDIOL($$GET1^DIQ(2,DFNIEN,1010.1511),"","?37"),EN^DDIOL(SDADT,"","?51"),EN^DDIOL($J(DGDAYS,3)_$S(DGFLG:"*",1:""),"","?71"),EN^DDIOL($$GET1^DIQ(2,DFNIEN,1010.161,"I"),"","?77") D ADD Q:QUIT
        . S DGCMT=$$GET1^DIQ(2,DFNIEN,1010.163) I $G(DGCMT)'="" D EN^DDIOL("COMMENT: "_DGCMT,"","!?3") D ADD Q:QUIT
        S DGLN=1
        Q
        ;
SUMARY  ;display totals
        ;K DGFMT1 S DGFMT2="S"
        D ADD2 Q:QUIT
        D EN^DDIOL("SUMMARY","","!!!")
        D EN^DDIOL("==============================================================================")
        S DGI="" F  S DGI=$O(DGTOTAL(DGI)) Q:DGI=""  D
        . I (DGRPT=1)&((DGI="C")!(DGI="F")) Q
        . D EN^DDIOL("Total number of veteran's "_$S(DGI="NULL":"",1:"with ")_$S(DGI="C":"CANCELLED",DGI="E":"EWL",DGI="F":"FILLED",DGI="I":"CONTACTED - IN PROCESS",1:"PENDING ACTION")_$S(DGI="NULL":"",1:" request status"))
        . D EN^DDIOL($J(DGTOTAL(DGI),4),"","?73")
        Q
        ;
ADD2    ;
        I $E(IOST,1,2)="C-",($Y>(IOSL-8)) D
        . D PAUSE
        . Q:QUIT
        . D TOP
        I $E(IOST,1,2)'="C-",($Y>(IOSL-8)) D TOP
        Q
DAYS(X1,X2)     ;Compute # of days
        S X1=$G(X1),X2=$G(X2)
        I X1="" S X1=DT
        D ^%DTC
        Q X
Q       Q
