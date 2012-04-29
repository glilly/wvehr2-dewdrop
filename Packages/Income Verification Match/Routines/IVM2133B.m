IVM2133B        ;ALB/PHH - IVM*2.0*133 Patient File Cleanup ; 10/6/2008
        ;;2.0;INCOME VERIFICATION MATCH;**133**; 21-OCT-94;Build 2
        Q
RESET   ; Reset the data for the cleanup process
        K ^XTMP($$NAMESPC)
        Q
TEST    ; Simulate Live Run
        N MODE
        S MODE=0
START   ; Start Processor
        N NAMESPC,QTIME
        S NAMESPC=$$NAMESPC
        Q:$$RUNCHK(NAMESPC)   ; Quit if already running or has run to completion
        Q:$$QTIME(.QTIME)
        S:$D(^XTMP(NAMESPC,"CONFIG","RUN MODE")) MODE=^XTMP(NAMESPC,"CONFIG","RUN MODE")
        S:'$D(^XTMP(NAMESPC,"CONFIG","RUN MODE")) ^XTMP(NAMESPC,"CONFIG","RUN MODE")=$S($G(MODE)=0:0,1:1)
        S ^XTMP(NAMESPC,"CONFIG","USER")=$S($G(DUZ)'="":DUZ,1:"UNKNOWN")
        S:'$$QUEUE(QTIME) ^XTMP(NAMESPC,"CONFIG","RUNNING")=""
        Q
NAMESPC()       ; API returns the name space for this patch
        Q "IVM133B"
RUNCHK(NAMESPC) ; Check to see if clean up is already running
        Q:NAMESPC="" 1                   ; Name Space must be defined
        Q:$D(^XTMP(NAMESPC,"CONFIG","RUNNING")) 1
        Q:$D(^XTMP(NAMESPC,"CONFIG","COMPLETE")) 1
        Q 0
QTIME(WHEN)     ; Get the run time for queuing
        N %,%H,%I,X
        D NOW^%DTC
        S WHEN=$P(%,".")_"."_$E($P(%,".",2),1,4)
        Q 0
QUEUE(ZTDTH)    ; Queue the process
        N NAMESPC,QUEERR,ZTDESC,ZTRTN,ZTSK,ZTIO
        S NAMESPC=$$NAMESPC
        S QUEERR=0
        S ZTRTN="CLEAN^IVM2"_$P(NAMESPC,"IVM",2)
        S ZTDESC=NAMESPC_" - Patient File Cleanup Process"
        S ZTIO=""
        D ^%ZTLOAD
        K ^XTMP(NAMESPC,"CONFIG","ZTSK")
        I '$D(ZTSK) S ^XTMP(NAMESPC,"CONFIG","ZTSK")="Unable to queue post-install process.",QUEERR=1
        I $D(ZTSK) S ^XTMP(NAMESPC,"CONFIG","ZTSK")="Post-install queued. Task ID: "_$G(ZTSK)
        D HOME^%ZIS
        Q QUEERR
CLEAN   ; Actual cleanup process
        N NAMESPC,MODE,USER,TASKID,%,%H,%I,X,X1,X2,CHKCNT,ZTSTOP,TMSWT,TOTREC,IEN
        S NAMESPC=$$NAMESPC
        K ^XTMP(NAMESPC,"CONFIG","ABORT TIME")
        S MODE=$G(^XTMP(NAMESPC,"CONFIG","RUN MODE"),0)
        S USER=$G(^XTMP(NAMESPC,"CONFIG","USER"),"UNKNOWN")
        S TASKID=$G(^XTMP(NAMESPC,"CONFIG","ZTSK"),"UNKNOWN")
        ;
        I '$D(^XTMP(NAMESPC,0)) D
        .K ^XTMP(NAMESPC)
        .S ^XTMP(NAMESPC,"CONFIG","IEN")=0
        .S ^XTMP(NAMESPC,"CONFIG","TOTPR")=0
        .S ^XTMP(NAMESPC,"CONFIG","PERCENT COMPLETE")=0
        .S ^XTMP(NAMESPC,"CONFIG","RUN MODE")=MODE
        .S ^XTMP(NAMESPC,"CONFIG","USER")=USER
        .S ^XTMP(NAMESPC,"CONFIG","ZTSK")=TASKID
        .D NOW^%DTC
        .S ^XTMP(NAMESPC,"CONFIG","START TIME")=%
        .S X1=$$DT^XLFDT,X2=90
        .D C^%DTC
        .S ^XTMP(NAMESPC,0)=X_U_$$DT^XLFDT_U_NAMESPC_" - PATIENT FILE CLEANUP"
        ;
        S CHKCNT=250,(ZTSTOP,TMSWT)=0,TOTREC=+$P($G(^DPT(0)),"^",4)
        S IEN=$G(^XTMP(NAMESPC,"CONFIG","IEN"))
        F  S IEN=$O(^DPT(IEN)) Q:'IEN!(TMSWT)  D
        .D PROC(IEN,MODE)
        .S ^XTMP(NAMESPC,"CONFIG","TOTPR")=$G(^XTMP(NAMESPC,"CONFIG","TOTPR"))+1
        .S ^XTMP(NAMESPC,"CONFIG","IEN")=IEN
        .I TOTREC D
        ..S ^XTMP(NAMESPC,"CONFIG","PERCENT COMPLETE")=+$G(^XTMP(NAMESPC,"CONFIG","TOTPR"))/TOTREC
        ..S ^XTMP(NAMESPC,"CONFIG","PERCENT COMPLETE")=+$P((^XTMP(NAMESPC,"CONFIG","PERCENT COMPLETE")*100),".")
        .I +$G(^XTMP(NAMESPC,"CONFIG","TOTPR"))#CHKCNT=0 D
        ..S TMSWT=$$STOPIT()
        ..I TMSWT D
        ...S ZTSTOP=1
        ...N %,%H,%I,X
        ...D NOW^%DTC
        ...S ^XTMP(NAMESPC,"CONFIG","ABORT TIME")=%
        ...D ABORTMSG
        ;
        I 'IEN,'TMSWT D
        .N %,%H,%I,X
        .D NOW^%DTC
        .S ^XTMP(NAMESPC,"CONFIG","COMPLETE")=%
        .S ^XTMP(NAMESPC,"CONFIG","PERCENT COMPLETE")=100
        .D DONEMSG
        ;
        K ^XTMP(NAMESPC,"CONFIG","RUNNING")
        Q
PROC(IEN,MODE)  ; Process the IEN
        ; Update "IVM AUTO ADDR JOB" to "POSTMASTER"
        N NAMESPC
        Q:'$D(^DPT(IEN,0))
        Q:$P($G(^DPT(IEN,.11)),"^",17)'="IVM AUTO ADDR JOB"
        S NAMESPC=$$NAMESPC
        S ^XTMP(NAMESPC,"DATA",IEN)=""
        S ^XTMP(NAMESPC,"CONFIG","ANOMALY")=$G(^XTMP(NAMESPC,"CONFIG","ANOMALY"))+1
        ;
        ; Update only if this is running in live mode
        I MODE D
        .N DA,DIE,DR,X
        .S DA=IEN,DIE="^DPT(",DR=".122////.5"
        .D ^DIE
        S ^XTMP(NAMESPC,"CONFIG","SUCCESS")=$G(^XTMP(NAMESPC,"CONFIG","SUCCESS"))+1
        Q
STOPIT()        ; Checks if user requested task to stop
        N X,STOPIT
        S STOPIT=0
        S X=$$S^%ZTLOAD
        I X D  ;
        .S STOPIT=1
        .I $G(ZTSK) S ZTSTOP=1
        Q STOPIT
ABORTMSG        ; Send the user aborted message:
        N NAMESPC,NAMESPCN,TMP,XMY,XMDUZ,XMTEXT,XMSUB
        S NAMESPC=$$NAMESPC
        S NAMESPCN=+$P(NAMESPC,"IVM",2)
        S XMY(DUZ)="",XMDUZ="IVM PACKAGE",XMTEXT="TMP("_NAMESPCN_","
        S XMSUB="IVM*2.0*"_NAMESPCN_": PATIENT FILE CLEANUP - PROCESS STOPPED BY USER"
        S TMP(NAMESPCN,1)="CLEANUP PROCESSING"
        S TMP(NAMESPCN,2)="------------------"
        S TMP(NAMESPCN,3)=""
        S TMP(NAMESPCN,4)="The cleanup process was aborted prematurely.  Here is the current status:"
        S TMP(NAMESPCN,5)=""
        S TMP(NAMESPCN,6)="  Start Date/Time: "_$$FMTE^XLFDT(+$G(^XTMP(NAMESPC,"CONFIG","START TIME")),"P")
        S TMP(NAMESPCN,7)="    End Date/Time: "_$$FMTE^XLFDT(+$G(^XTMP(NAMESPC,"CONFIG","ABORT TIME")),"P")
        S TMP(NAMESPCN,8)=""
        S TMP(NAMESPCN,9)="Current Counts: "
        S TMP(NAMESPCN,10)="               Total Records Processed: "_+$G(^XTMP(NAMESPC,"CONFIG","TOTPR"))
        S TMP(NAMESPCN,11)="             Total Anomalies Corrected: "_+$G(^XTMP(NAMESPC,"CONFIG","SUCCESS"))
        S TMP(NAMESPCN,12)="                  Percentage Completed: "_+$G(^XTMP(NAMESPC,"CONFIG","PERCENT COMPLETE"))_"%"
        S TMP(NAMESPCN,13)=""
        S TMP(NAMESPCN,14)=""
        D ^XMD
        Q
DONEMSG ; Send the user aborted message:
        N NAMESPC,NAMESPCN,TMP,XMY,XMDUZ,XMTEXT,XMSUB
        S NAMESPC=$$NAMESPC
        S NAMESPCN=+$P(NAMESPC,"IVM",2)
        S XMY(DUZ)="",XMDUZ="IVM PACKAGE",XMTEXT="TMP("_NAMESPCN_","
        S XMSUB="IVM*2.0*"_NAMESPCN_": PATIENT FILE CLEANUP - SUMMARY REPORT"
        S TMP(NAMESPCN,1)="CLEANUP PROCESSING"
        S TMP(NAMESPCN,2)="------------------"
        S TMP(NAMESPCN,3)=""
        S TMP(NAMESPCN,4)="The cleanup has run to completion.  Here are the results:"
        S TMP(NAMESPCN,5)=""
        S TMP(NAMESPCN,6)="  Start Date/Time: "_$$FMTE^XLFDT(+$G(^XTMP(NAMESPC,"CONFIG","START TIME")),"P")
        S TMP(NAMESPCN,7)="    End Date/Time: "_$$FMTE^XLFDT(+$G(^XTMP(NAMESPC,"CONFIG","COMPLETE")),"P")
        S TMP(NAMESPCN,8)=""
        S TMP(NAMESPCN,9)="Current Counts: "
        S TMP(NAMESPCN,10)="               Total Records Processed: "_+$G(^XTMP(NAMESPC,"CONFIG","TOTPR"))
        S TMP(NAMESPCN,11)="             Total Anomalies Corrected: "_+$G(^XTMP(NAMESPC,"CONFIG","SUCCESS"))
        S TMP(NAMESPCN,12)="                  Percentage Completed: 100%"
        S TMP(NAMESPCN,13)=""
        S TMP(NAMESPCN,14)=""
        D ^XMD
        Q
