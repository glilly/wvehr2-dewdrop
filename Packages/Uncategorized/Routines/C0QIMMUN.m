C0QIMMUN        ;Prep Immunization Order data for HL7 Message creation ;
        ;;0.1;C0Q;nopatch;noreleasedate;Build 12
        ;  ^XTMP("C0QIMMUN",0)=purge date^create date
        ;  ^XTMP("C0QIMMUN",order_date,order#,item_name)=item_value
        ;  ^XTMP("C0QIMMUN","LASTORDR")=last order processed
FIND    ; Find the next set of immunization orders
        N X1,X2,X,%,%DT,%H,%T,NOW,ORDER,LASTORDR,SUBSC,DIR
        S LASTORDR=+$G(^XTMP("C0QIMMUN","LASTORDR"))
        W !,"The ""Last Order"" from which to begin checking for Immunization orders is: ",LASTORDR
        S DIR("A")="Do you want to reset that value"
        S DIR(0)="Y",DIR("B")="NO" D ^DIR D:Y=1
        . S DIR("A")="What value shall be used?"
        . S DIR(0)="NO",DIR("B")=LASTORDR D ^DIR
        . W:Y'>0 !,"We'll skip reseting it then."
        . D:Y>0
        . . S LASTORDR=+Y
        . . L +^XTMP("C0QIMMUN")
        . . S X1=DT,X2=365 D C^%DTC
        . . S ^XTMP("C0QIMMUN",0)=X_U_DT
        . . S ^XTMP("C0QIMMUN","LASTORDR")=LASTORDR
        . . L -^XTMP("C0QIMMUN")
        . . Q
        . Q
        S DIR("A")="Ready to prep more immunization orders for HL7 messages"
        S DIR(0)="Y",DIR("B")="YES" D ^DIR Q:Y'=1
        L +^XTMP("C0QIMMUN")
        I '$D(^XTMP("C0QIMMUN",0)) D
        . S X1=DT,X2=365 D C^%DTC
        . S ^XTMP("C0QIMMUN",0)=X_U_DT
        . S ^XTMP("C0QIMMUN","LASTORDR")=0
        S ORDER=^XTMP("C0QIMMUN","LASTORDR")
        F  S ORDER=$O(^OR(100,ORDER)) Q:ORDER'>0  D
        . S LASTORDR=ORDER
        . D:$D(^OR(100,ORDER,4.5,"ID","ORZ HL7")) GOTONE
        . Q
        S ^XTMP("C0QIMMUN","LASTORDR")=LASTORDR
        W !,"Done",!,"Last Order processed: ",LASTORDR,!
        L -^XTMP("C0QIMMUN")
        Q
GOTONE  ; Take the order number and move the relevant HL7 information into ^XTMP
        S NOW=$P(^OR(100,ORDER,0),U,7)
        S ^XTMP("C0QIMMUN",NOW,ORDER,"PATIENT")=$P(^OR(100,ORDER,0),U,2)
        S ^XTMP("C0QIMMUN",NOW,ORDER,"LOCATION")=$P(^OR(100,ORDER,0),U,10)
        S ^XTMP("C0QIMMUN",NOW,ORDER,"ORDEREDBY")=$P(^OR(100,ORDER,0),U,6)
        S ENTRY=0 F  S ENTRY=$O(^OR(100,ORDER,4.5,ENTRY)) Q:ENTRY'>0  D
        . S SUBSC=$P($G(^OR(100,ORDER,4.5,ENTRY,0)),U,4)
        . Q:'$L(SUBSC)
        . I SUBSC'="TIME" S ^XTMP("C0QIMMUN",NOW,ORDER,SUBSC)=^OR(100,ORDER,4.5,ENTRY,1)
        . E  S X=^OR(100,ORDER,4.5,ENTRY,1),%DT="TS" D ^%DT S ^XTMP("C0QIMMUN",NOW,ORDER,SUBSC)=Y
        . Q
        S ^XTMP("C0QIMMUN",NOW,ORDER,"ORDERTEXT")=$G(^OR(100,ORDER,8,1,.1,1,0))
        Q
