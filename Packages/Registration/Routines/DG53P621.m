DG53P621 ;BAY/JAT - Patient File reporting; 6/7/04 7:13pm ; 10/8/04 11:25am
 ;;5.3;Registration;**621**;Aug 13,1993
 ;
REPORT ;
 N X1,X2
 K ^XTMP("DG53P621",$J)
 S X1=DT,X2=90 D C^%DTC
 S ^XTMP("DG53P621",$J,0)=X_"^"_DT_"^Abnormal SSNs"
 I $$DEVICE() D ENTER
 Q
 ;
ENTER ;
 ;
 D READFILE
 D ^%ZISC
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
DEVICE() ;
 ;Description: allows the user to select a device.
 ;
 ;Output:
 ;  Function Value - Returns 0 if the user decides not to print or to
 ;       queue the report, 1 otherwise.
 ;
 N OK,IOP,POP,%ZIS
 S OK=1
 S %ZIS="MQ"
 D ^%ZIS
 S:POP OK=0
 D:OK&$D(IO("Q"))
 .N ZTRTN,ZTDESC,ZTSKM,ZTREQ,ZTSTOP
 .S ZTRTN="ENTER^DG53P621",ZTDESC="Report of abnormal SSNs"
 .D ^%ZTLOAD
 .W !,$S($D(ZTSK):"REQUEST QUEUED TASK="_ZTSK,1:"REQUEST CANCELLED")
 .D HOME^%ZIS
 .S OK=0
 Q OK
 ;
READFILE ;
 N DFN,COUNT,DGZERO,DGSSN
 S (DFN,COUNT)=0
 F  S DFN=$O(^DPT(DFN)) Q:'DFN  D
 .; merged record
 .I $D(^DPT(DFN,-9)) Q
 .; in process of being merged
 .I $P($G(^DPT(DFN,0)),U)["MERGING INTO" Q
 .I $D(^DPT(DFN,0)) D
 ..S DGZERO=$G(^DPT(DFN,0))
 ..I $E($P(DGZERO,U,1),1,2)="ZZ" Q
 ..S DGSSN=$P(DGZERO,U,9)
 ..I $L(DGSSN)>8 Q  ; well-formed ssn, either standard or pseudo
 ..D STORE
 ;
 W !,"Nbr records with abnormal SSN: "_COUNT
 D PRINT
 Q
 ;
STORE ;
 S COUNT=COUNT+1
 S ^XTMP("DG53P621",$J,DFN)=$E(DGZERO,1,55)
 Q
PRINT ;
 U IO
 N DGDDT,DGQUIT,DGPG
 S DGDDT=$$FMTE^XLFDT($$NOW^XLFDT,"D")
 S (DGQUIT,DGPG)=0
 D HEAD
 I '$G(COUNT) D  Q
 .W !!!,?20,"*** No records to report ***"
 W !!,"*** COUNT OF BAD PATIENT RECORDS: ",COUNT," ***",!!
 S DFN=0
 F  S DFN=$O(^XTMP("DG53P621",$J,DFN)) Q:'DFN  D  Q:DGQUIT
 .I $Y>(IOSL-4) D HEAD
 .S DGZERO=$G(^XTMP("DG53P621",$J,DFN))
 .W ?2,DFN,?13,DGZERO,!
 ;
 I DGQUIT W:$D(ZTQUEUED) !!,"Report stopped at user's request" Q
 I $G(DGPG)>0,$E(IOST)="C" K DIR S DIR(0)="E" D ^DIR K DIR S:+Y=0 DGQUIT=1
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
HEAD ;
 I $D(ZTQUEUED),$$S^%ZTLOAD S (ZTSTOP,DGQUIT)=1 Q
 I $G(DGPG)>0,$E(IOST)="C" K DIR S DIR(0)="E" D ^DIR K DIR S:+Y=0 DGQUIT=1
 Q:DGQUIT
 S DGPG=$G(DGPG)+1
 W @IOF,!,DGDDT,?15,"DG*5.3*621 List of abnormal SSNs",?70,"Page:",$J(DGPG,5),! K X S $P(X,"-",81)="" W X,!
 W !
 W !,?2,"DFN",?13,"ZERO NODE",!
 S $P(X,"-",81)="" W X,!
 Q
